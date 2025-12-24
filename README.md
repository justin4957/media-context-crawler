# Media Context Crawler

A powerful tool for extracting keywords from video content and performing tree-based crawling of social media platforms to discover related discussions, trends, and contextual information.

## Overview

Media Context Crawler allows you to:
- Extract keywords from YouTube videos, clips, and similar media using natural language processing
- Perform tree-based searches across multiple social media platforms
- Track specific accounts, hashtags, and keywords across platforms
- Build a searchable database of related content and discussions
- Visualize connection trees between original media and discovered content

## Features

### Current Features
- **Video Content Analysis**: Extract keywords and topics from video URLs (YouTube and similar platforms)
- **Multi-Platform Crawling**: Support for Twitter/X, Reddit, TikTok, Instagram, and more
- **Tree Search Architecture**: Navigate related content through branching search paths
- **Keyword Tracking**: Monitor specific terms, hashtags, and account mentions
- **Database Storage**: Persist video content, keywords, and search results
- **Flexible Filtering**: Select specific accounts, hashtags, and platforms to crawl

### Planned Features
See [ROADMAP.md](./ROADMAP.md) for detailed development plans.

## Architecture

```
media-context-crawler/
├── cmd/
│   └── media-context-crawler/  # Main application entry point
├── pkg/
│   ├── crawler/                # Social media platform crawlers
│   ├── nlp/                    # Natural language processing
│   ├── database/               # Database operations
│   ├── tree/                   # Tree search logic
│   └── api/                    # External API integrations
├── internal/
│   ├── config/                 # Configuration management
│   └── models/                 # Data models
├── docs/                       # Documentation
└── examples/                   # Usage examples
```

## Getting Started

### Prerequisites

- Go 1.21 or higher
- PostgreSQL 14+ (or compatible database)
- API keys for social media platforms (see Configuration)

### Installation

```bash
# Clone the repository
git clone https://github.com/justin4957/media-context-crawler.git
cd media-context-crawler

# Install dependencies
go mod download

# Build the application
go build -o bin/media-context-crawler ./cmd/media-context-crawler

# Run the application
./bin/media-context-crawler
```

### Configuration

Create a `config.yaml` file in the project root:

```yaml
database:
  host: localhost
  port: 5432
  name: media_context_crawler
  user: your_username
  password: your_password

api_keys:
  youtube: YOUR_YOUTUBE_API_KEY
  twitter: YOUR_TWITTER_API_KEY
  reddit: YOUR_REDDIT_API_KEY

crawler:
  max_depth: 3              # Maximum tree depth for searches
  rate_limit: 100           # Requests per minute
  concurrent_workers: 5     # Number of concurrent crawlers

nlp:
  min_keyword_relevance: 0.7  # Minimum relevance score for keywords
  max_keywords: 20             # Maximum keywords to extract per video
```

### Quick Start Example

```go
package main

import (
    "github.com/justin4957/media-context-crawler/pkg/nlp"
    "github.com/justin4957/media-context-crawler/pkg/crawler"
    "github.com/justin4957/media-context-crawler/pkg/tree"
)

func main() {
    // Extract keywords from a YouTube video
    keywords, err := nlp.ExtractKeywords("https://youtube.com/watch?v=example")
    if err != nil {
        panic(err)
    }

    // Create a tree search starting from these keywords
    searchTree := tree.NewSearchTree(keywords)

    // Configure crawlers for specific platforms
    searchTree.AddCrawler(crawler.NewTwitterCrawler(
        crawler.WithHashtags("#example", "#trending"),
        crawler.WithAccounts("@example_account"),
    ))

    searchTree.AddCrawler(crawler.NewRedditCrawler(
        crawler.WithSubreddits("r/example"),
    ))

    // Execute the tree search
    results, err := searchTree.Execute()
    if err != nil {
        panic(err)
    }

    // Store results in database
    db.SaveResults(results)
}
```

## Usage

### Basic Workflow

1. **Input Video URL**: Provide a YouTube URL or similar media link
2. **Extract Keywords**: NLP processes the video content to identify key topics
3. **Configure Search**: Select platforms, accounts, hashtags, and filters
4. **Execute Tree Search**: The crawler navigates through related content
5. **View Results**: Explore the connection tree and stored data

### CLI Usage

```bash
# Analyze a single video
media-context-crawler analyze --url "https://youtube.com/watch?v=example"

# Start a tree search with specific parameters
media-context-crawler search \
  --keywords "keyword1,keyword2" \
  --platforms "twitter,reddit" \
  --hashtags "#example" \
  --depth 3

# Export results
media-context-crawler export --format json --output results.json
```

### API Usage

Start the API server:

```bash
media-context-crawler serve --port 8080
```

Example API requests:

```bash
# Submit a video for analysis
curl -X POST http://localhost:8080/api/v1/videos \
  -H "Content-Type: application/json" \
  -d '{"url": "https://youtube.com/watch?v=example"}'

# Start a tree search
curl -X POST http://localhost:8080/api/v1/searches \
  -H "Content-Type: application/json" \
  -d '{
    "video_id": "abc123",
    "platforms": ["twitter", "reddit"],
    "max_depth": 3
  }'

# Get search results
curl http://localhost:8080/api/v1/searches/{search_id}/results
```

## Tree Search Concept

The tree search functionality allows you to:

1. Start with keywords from a video (root node)
2. Search for content on platform A (level 1)
3. Extract new keywords/accounts from results
4. Branch searches to platforms B and C (level 2)
5. Continue expanding based on discoveries (level 3+)

This creates a tree structure showing how topics and discussions spread across platforms.

## Database Schema

The application uses the following main tables:

- `videos`: Stores original video content and metadata
- `keywords`: Extracted keywords with relevance scores
- `search_trees`: Tree search configurations and states
- `search_nodes`: Individual nodes in the search tree
- `social_content`: Discovered social media posts and content
- `platform_accounts`: Tracked accounts across platforms

See [docs/schema.sql](docs/schema.sql) for complete schema.

## Development

### Running Tests

```bash
# Run all tests
go test ./...

# Run with coverage
go test -cover ./...

# Run specific package tests
go test ./pkg/nlp
```

### Building

```bash
# Build for current platform
go build -o bin/media-context-crawler ./cmd/media-context-crawler

# Build for multiple platforms
GOOS=linux GOARCH=amd64 go build -o bin/media-context-crawler-linux ./cmd/media-context-crawler
GOOS=darwin GOARCH=arm64 go build -o bin/media-context-crawler-darwin ./cmd/media-context-crawler
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Go for high-performance concurrent crawling
- NLP powered by natural language processing libraries
- Supports multiple social media platform APIs

## Support

- Documentation: [docs/](./docs)
- Issues: [GitHub Issues](https://github.com/justin4957/media-context-crawler/issues)
- Discussions: [GitHub Discussions](https://github.com/justin4957/media-context-crawler/discussions)

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for planned features and development timeline.
