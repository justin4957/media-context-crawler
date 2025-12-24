package models

import (
	"time"

	"github.com/google/uuid"
)

// Video represents a video from any supported platform
type Video struct {
	ID              uuid.UUID              `json:"id" db:"id"`
	URL             string                 `json:"url" db:"url"`
	Platform        string                 `json:"platform" db:"platform"`
	PlatformID      string                 `json:"platform_id" db:"platform_id"`
	Title           string                 `json:"title" db:"title"`
	Description     string                 `json:"description" db:"description"`
	ChannelName     string                 `json:"channel_name" db:"channel_name"`
	ChannelID       string                 `json:"channel_id" db:"channel_id"`
	DurationSeconds int                    `json:"duration_seconds" db:"duration_seconds"`
	ViewCount       int64                  `json:"view_count" db:"view_count"`
	PublishedAt     *time.Time             `json:"published_at" db:"published_at"`
	Transcript      string                 `json:"transcript" db:"transcript"`
	ThumbnailURL    string                 `json:"thumbnail_url" db:"thumbnail_url"`
	CreatedAt       time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt       time.Time              `json:"updated_at" db:"updated_at"`
	LastAnalyzedAt  *time.Time             `json:"last_analyzed_at" db:"last_analyzed_at"`
	Metadata        map[string]interface{} `json:"metadata" db:"metadata"`
}

// Keyword represents an extracted keyword from a video
type Keyword struct {
	ID             uuid.UUID `json:"id" db:"id"`
	VideoID        uuid.UUID `json:"video_id" db:"video_id"`
	Keyword        string    `json:"keyword" db:"keyword"`
	RelevanceScore float64   `json:"relevance_score" db:"relevance_score"`
	Frequency      int       `json:"frequency" db:"frequency"`
	KeywordType    string    `json:"keyword_type" db:"keyword_type"`
	EntityType     string    `json:"entity_type" db:"entity_type"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}

// SearchTree represents a tree search configuration and state
type SearchTree struct {
	ID           uuid.UUID              `json:"id" db:"id"`
	VideoID      uuid.UUID              `json:"video_id" db:"video_id"`
	Name         string                 `json:"name" db:"name"`
	Description  string                 `json:"description" db:"description"`
	Status       string                 `json:"status" db:"status"`
	MaxDepth     int                    `json:"max_depth" db:"max_depth"`
	Strategy     string                 `json:"strategy" db:"strategy"`
	Platforms    []string               `json:"platforms" db:"platforms"`
	Config       map[string]interface{} `json:"config" db:"config"`
	StartedAt    *time.Time             `json:"started_at" db:"started_at"`
	CompletedAt  *time.Time             `json:"completed_at" db:"completed_at"`
	CreatedAt    time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time              `json:"updated_at" db:"updated_at"`
	ErrorMessage string                 `json:"error_message,omitempty" db:"error_message"`
}

// SearchNode represents an individual node in the search tree
type SearchNode struct {
	ID             uuid.UUID              `json:"id" db:"id"`
	SearchTreeID   uuid.UUID              `json:"search_tree_id" db:"search_tree_id"`
	ParentNodeID   *uuid.UUID             `json:"parent_node_id,omitempty" db:"parent_node_id"`
	Depth          int                    `json:"depth" db:"depth"`
	NodeType       string                 `json:"node_type" db:"node_type"`
	SearchQuery    string                 `json:"search_query" db:"search_query"`
	Platform       string                 `json:"platform" db:"platform"`
	RelevanceScore float64                `json:"relevance_score" db:"relevance_score"`
	Status         string                 `json:"status" db:"status"`
	ResultsCount   int                    `json:"results_count" db:"results_count"`
	CreatedAt      time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt      time.Time              `json:"updated_at" db:"updated_at"`
	Metadata       map[string]interface{} `json:"metadata" db:"metadata"`
}

// SocialContent represents discovered social media content
type SocialContent struct {
	ID                  uuid.UUID              `json:"id" db:"id"`
	SearchNodeID        uuid.UUID              `json:"search_node_id" db:"search_node_id"`
	Platform            string                 `json:"platform" db:"platform"`
	PlatformContentID   string                 `json:"platform_content_id" db:"platform_content_id"`
	ContentType         string                 `json:"content_type" db:"content_type"`
	AuthorID            string                 `json:"author_id" db:"author_id"`
	AuthorUsername      string                 `json:"author_username" db:"author_username"`
	AuthorDisplayName   string                 `json:"author_display_name" db:"author_display_name"`
	ContentText         string                 `json:"content_text" db:"content_text"`
	ContentURL          string                 `json:"content_url" db:"content_url"`
	MediaURLs           []string               `json:"media_urls" db:"media_urls"`
	Hashtags            []string               `json:"hashtags" db:"hashtags"`
	Mentions            []string               `json:"mentions" db:"mentions"`
	EngagementLikes     int                    `json:"engagement_likes" db:"engagement_likes"`
	EngagementShares    int                    `json:"engagement_shares" db:"engagement_shares"`
	EngagementComments  int                    `json:"engagement_comments" db:"engagement_comments"`
	EngagementViews     int                    `json:"engagement_views" db:"engagement_views"`
	SentimentScore      float64                `json:"sentiment_score" db:"sentiment_score"`
	RelevanceScore      float64                `json:"relevance_score" db:"relevance_score"`
	PublishedAt         *time.Time             `json:"published_at" db:"published_at"`
	CreatedAt           time.Time              `json:"created_at" db:"created_at"`
	Metadata            map[string]interface{} `json:"metadata" db:"metadata"`
}

// PlatformAccount represents a social media account
type PlatformAccount struct {
	ID                uuid.UUID              `json:"id" db:"id"`
	Platform          string                 `json:"platform" db:"platform"`
	PlatformAccountID string                 `json:"platform_account_id" db:"platform_account_id"`
	Username          string                 `json:"username" db:"username"`
	DisplayName       string                 `json:"display_name" db:"display_name"`
	Bio               string                 `json:"bio" db:"bio"`
	FollowersCount    int                    `json:"followers_count" db:"followers_count"`
	FollowingCount    int                    `json:"following_count" db:"following_count"`
	Verified          bool                   `json:"verified" db:"verified"`
	AccountURL        string                 `json:"account_url" db:"account_url"`
	ProfileImageURL   string                 `json:"profile_image_url" db:"profile_image_url"`
	CreatedAt         time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time              `json:"updated_at" db:"updated_at"`
	Metadata          map[string]interface{} `json:"metadata" db:"metadata"`
}
