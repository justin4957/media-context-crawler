-- Media Context Crawler Database Schema
-- PostgreSQL 14+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Videos table: stores original video content and metadata
CREATE TABLE videos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    url TEXT NOT NULL UNIQUE,
    platform VARCHAR(50) NOT NULL, -- 'youtube', 'vimeo', etc.
    platform_id VARCHAR(255), -- Platform-specific video ID
    title TEXT,
    description TEXT,
    channel_name VARCHAR(255),
    channel_id VARCHAR(255),
    duration_seconds INTEGER,
    view_count BIGINT,
    published_at TIMESTAMP,
    transcript TEXT,
    thumbnail_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_analyzed_at TIMESTAMP,
    metadata JSONB -- Additional platform-specific metadata
);

CREATE INDEX idx_videos_platform ON videos(platform);
CREATE INDEX idx_videos_platform_id ON videos(platform_id);
CREATE INDEX idx_videos_created_at ON videos(created_at DESC);

-- Keywords table: extracted keywords with relevance scores
CREATE TABLE keywords (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    keyword TEXT NOT NULL,
    relevance_score DECIMAL(4,3) NOT NULL CHECK (relevance_score >= 0 AND relevance_score <= 1),
    frequency INTEGER DEFAULT 1,
    keyword_type VARCHAR(50), -- 'entity', 'topic', 'hashtag', etc.
    entity_type VARCHAR(50), -- 'person', 'organization', 'location', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_keywords_video_id ON keywords(video_id);
CREATE INDEX idx_keywords_keyword ON keywords(keyword);
CREATE INDEX idx_keywords_relevance ON keywords(relevance_score DESC);
CREATE UNIQUE INDEX idx_keywords_video_keyword ON keywords(video_id, keyword);

-- Search trees table: tree search configurations and states
CREATE TABLE search_trees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    video_id UUID NOT NULL REFERENCES videos(id) ON DELETE CASCADE,
    name VARCHAR(255),
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'running', 'completed', 'failed'
    max_depth INTEGER DEFAULT 3,
    strategy VARCHAR(50) DEFAULT 'breadth_first', -- 'breadth_first', 'depth_first', 'best_first'
    platforms TEXT[], -- Array of platforms to search
    config JSONB, -- Search configuration (filters, accounts, hashtags, etc.)
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT
);

CREATE INDEX idx_search_trees_video_id ON search_trees(video_id);
CREATE INDEX idx_search_trees_status ON search_trees(status);
CREATE INDEX idx_search_trees_created_at ON search_trees(created_at DESC);

-- Search nodes table: individual nodes in the search tree
CREATE TABLE search_nodes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    search_tree_id UUID NOT NULL REFERENCES search_trees(id) ON DELETE CASCADE,
    parent_node_id UUID REFERENCES search_nodes(id) ON DELETE CASCADE,
    depth INTEGER NOT NULL DEFAULT 0,
    node_type VARCHAR(50) NOT NULL, -- 'root', 'keyword', 'account', 'hashtag', 'content'
    search_query TEXT, -- The query used to find this node
    platform VARCHAR(50), -- Platform where search was performed
    relevance_score DECIMAL(4,3),
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed', 'pruned'
    results_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

CREATE INDEX idx_search_nodes_tree_id ON search_nodes(search_tree_id);
CREATE INDEX idx_search_nodes_parent_id ON search_nodes(parent_node_id);
CREATE INDEX idx_search_nodes_depth ON search_nodes(depth);
CREATE INDEX idx_search_nodes_status ON search_nodes(status);

-- Social content table: discovered social media posts and content
CREATE TABLE social_content (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    search_node_id UUID NOT NULL REFERENCES search_nodes(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    platform_content_id VARCHAR(255) NOT NULL, -- Platform-specific post/content ID
    content_type VARCHAR(50), -- 'post', 'comment', 'video', 'article', etc.
    author_id VARCHAR(255),
    author_username VARCHAR(255),
    author_display_name VARCHAR(255),
    content_text TEXT,
    content_url TEXT,
    media_urls TEXT[],
    hashtags TEXT[],
    mentions TEXT[],
    engagement_likes INTEGER DEFAULT 0,
    engagement_shares INTEGER DEFAULT 0,
    engagement_comments INTEGER DEFAULT 0,
    engagement_views INTEGER DEFAULT 0,
    sentiment_score DECIMAL(3,2), -- -1.0 to 1.0
    relevance_score DECIMAL(4,3),
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB,
    UNIQUE(platform, platform_content_id)
);

CREATE INDEX idx_social_content_node_id ON social_content(search_node_id);
CREATE INDEX idx_social_content_platform ON social_content(platform);
CREATE INDEX idx_social_content_author ON social_content(author_username);
CREATE INDEX idx_social_content_published_at ON social_content(published_at DESC);
CREATE INDEX idx_social_content_relevance ON social_content(relevance_score DESC);
CREATE INDEX idx_social_content_hashtags ON social_content USING GIN(hashtags);

-- Platform accounts table: tracked accounts across platforms
CREATE TABLE platform_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    platform VARCHAR(50) NOT NULL,
    platform_account_id VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    display_name VARCHAR(255),
    bio TEXT,
    followers_count INTEGER,
    following_count INTEGER,
    verified BOOLEAN DEFAULT false,
    account_url TEXT,
    profile_image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB,
    UNIQUE(platform, platform_account_id)
);

CREATE INDEX idx_platform_accounts_platform ON platform_accounts(platform);
CREATE INDEX idx_platform_accounts_username ON platform_accounts(username);

-- Account relationships table: relationships between accounts and content
CREATE TABLE account_content_relationships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_id UUID NOT NULL REFERENCES platform_accounts(id) ON DELETE CASCADE,
    content_id UUID NOT NULL REFERENCES social_content(id) ON DELETE CASCADE,
    relationship_type VARCHAR(50), -- 'author', 'mentioned', 'replied_to', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(account_id, content_id, relationship_type)
);

CREATE INDEX idx_account_relationships_account ON account_content_relationships(account_id);
CREATE INDEX idx_account_relationships_content ON account_content_relationships(content_id);

-- Hashtags table: aggregated hashtag statistics
CREATE TABLE hashtags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag VARCHAR(255) NOT NULL UNIQUE,
    usage_count INTEGER DEFAULT 0,
    first_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    platforms TEXT[] -- Platforms where this hashtag was found
);

CREATE INDEX idx_hashtags_tag ON hashtags(tag);
CREATE INDEX idx_hashtags_usage ON hashtags(usage_count DESC);

-- API rate limits tracking table
CREATE TABLE api_rate_limits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    platform VARCHAR(50) NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    requests_remaining INTEGER,
    requests_limit INTEGER,
    reset_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(platform, endpoint)
);

CREATE INDEX idx_rate_limits_platform ON api_rate_limits(platform);
CREATE INDEX idx_rate_limits_reset_at ON api_rate_limits(reset_at);

-- Search history table: user search history and analytics
CREATE TABLE search_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    search_tree_id UUID REFERENCES search_trees(id) ON DELETE SET NULL,
    query_type VARCHAR(50), -- 'video_analysis', 'tree_search', 'keyword_search'
    query_params JSONB,
    results_count INTEGER,
    execution_time_ms INTEGER,
    success BOOLEAN DEFAULT true,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_search_history_created_at ON search_history(created_at DESC);
CREATE INDEX idx_search_history_query_type ON search_history(query_type);

-- Functions and triggers

-- Update timestamp function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_videos_updated_at BEFORE UPDATE ON videos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_search_trees_updated_at BEFORE UPDATE ON search_trees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_search_nodes_updated_at BEFORE UPDATE ON search_nodes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_platform_accounts_updated_at BEFORE UPDATE ON platform_accounts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_api_rate_limits_updated_at BEFORE UPDATE ON api_rate_limits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Views

-- Active searches view
CREATE VIEW active_searches AS
SELECT
    st.id,
    st.name,
    v.title as video_title,
    v.url as video_url,
    st.status,
    st.platforms,
    COUNT(DISTINCT sn.id) as total_nodes,
    COUNT(DISTINCT sc.id) as total_content,
    st.started_at,
    st.created_at
FROM search_trees st
JOIN videos v ON st.video_id = v.id
LEFT JOIN search_nodes sn ON st.id = sn.search_tree_id
LEFT JOIN social_content sc ON sn.id = sc.search_node_id
WHERE st.status IN ('pending', 'running')
GROUP BY st.id, st.name, v.title, v.url, st.status, st.platforms, st.started_at, st.created_at;

-- Popular hashtags view
CREATE VIEW popular_hashtags AS
SELECT
    h.tag,
    h.usage_count,
    h.platforms,
    COUNT(DISTINCT sc.id) as content_count,
    h.first_seen_at,
    h.last_seen_at
FROM hashtags h
LEFT JOIN social_content sc ON h.tag = ANY(sc.hashtags)
GROUP BY h.id, h.tag, h.usage_count, h.platforms, h.first_seen_at, h.last_seen_at
ORDER BY h.usage_count DESC;

-- Comments
COMMENT ON TABLE videos IS 'Stores original video content and metadata from various platforms';
COMMENT ON TABLE keywords IS 'Keywords extracted from videos with relevance scores and frequency';
COMMENT ON TABLE search_trees IS 'Top-level search configurations and execution state';
COMMENT ON TABLE search_nodes IS 'Individual nodes in the tree search representing search points';
COMMENT ON TABLE social_content IS 'Social media posts and content discovered during searches';
COMMENT ON TABLE platform_accounts IS 'Social media accounts encountered during crawling';
COMMENT ON TABLE hashtags IS 'Aggregated hashtag usage statistics across platforms';
