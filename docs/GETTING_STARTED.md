# Getting Started with Media Context Crawler

This guide will help you set up and start using Media Context Crawler.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Go 1.21 or higher**: [Download Go](https://go.dev/dl/)
- **PostgreSQL 14+**: [Download PostgreSQL](https://www.postgresql.org/download/)
- **Git**: [Download Git](https://git-scm.com/downloads)

Optional but recommended:
- **Make**: For using the Makefile commands
- **Docker**: For containerized deployment

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/justin4957/media-context-crawler.git
cd media-context-crawler
```

### 2. Install Dependencies

```bash
# Using Make
make deps

# Or using Go directly
go mod download
```

### 3. Set Up the Database

Create a PostgreSQL database:

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE media_context_crawler;

# Exit psql
\q
```

Run the schema migrations:

```bash
psql -U postgres -d media_context_crawler -f docs/schema.sql
```

### 4. Configure the Application

Copy the example configuration file:

```bash
cp config.example.yaml config.yaml
```

Edit `config.yaml` with your settings:

```yaml
database:
  host: localhost
  port: 5432
  name: media_context_crawler
  user: postgres
  password: your_password

api_keys:
  youtube: YOUR_YOUTUBE_API_KEY
  # Add other API keys as needed
```

### 5. Build the Application

```bash
# Using Make
make build

# Or using Go directly
go build -o bin/media-context-crawler ./cmd/media-context-crawler
```

## Getting API Keys

### YouTube Data API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the YouTube Data API v3
4. Create credentials (API key)
5. Copy the API key to your `config.yaml`

### Twitter/X API

1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Create a new app
3. Generate API keys and tokens
4. Copy credentials to your `config.yaml`

### Reddit API

1. Go to [Reddit Apps](https://www.reddit.com/prefs/apps)
2. Create a new app (select "script" type)
3. Note your client ID and secret
4. Copy credentials to your `config.yaml`

## Running the Application

### Basic Usage

```bash
# Run the application
./bin/media-context-crawler

# Or using Make
make run
```

### Analyze a Video

```bash
./bin/media-context-crawler analyze --url "https://youtube.com/watch?v=dQw4w9WgXcQ"
```

### Start a Tree Search

```bash
./bin/media-context-crawler search \
  --video-id "abc123" \
  --platforms "twitter,reddit" \
  --max-depth 3
```

### Start the API Server

```bash
./bin/media-context-crawler serve --port 8080
```

## Development

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make test-coverage
```

### Code Formatting

```bash
# Format code
make fmt

# Run linter (requires golangci-lint)
make lint
```

### Hot Reload Development

Install air for hot reloading:

```bash
go install github.com/cosmtrek/air@latest
```

Run in development mode:

```bash
make dev
```

## Project Structure

```
media-context-crawler/
├── cmd/
│   └── media-context-crawler/    # Main application
├── pkg/                           # Public packages
│   ├── crawler/                   # Platform crawlers
│   ├── nlp/                       # NLP processing
│   ├── database/                  # Database operations
│   ├── tree/                      # Tree search logic
│   └── api/                       # API integrations
├── internal/                      # Private packages
│   ├── config/                    # Configuration
│   └── models/                    # Data models
├── docs/                          # Documentation
├── examples/                      # Usage examples
└── config.yaml                    # Configuration file
```

## Next Steps

1. **Read the Documentation**: Check out the [docs/](../docs) directory for detailed information
2. **Explore Examples**: Look at [examples/](../examples) for usage patterns
3. **Review the Roadmap**: See [ROADMAP.md](../ROADMAP.md) for upcoming features
4. **Contribute**: Read [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines

## Troubleshooting

### Database Connection Issues

If you can't connect to the database:

1. Check that PostgreSQL is running: `pg_isready`
2. Verify your credentials in `config.yaml`
3. Check firewall settings
4. Ensure the database exists: `psql -l`

### API Key Issues

If API calls fail:

1. Verify your API keys are correct
2. Check API quota limits
3. Ensure APIs are enabled in respective developer consoles
4. Check rate limiting configuration

### Build Issues

If the build fails:

1. Ensure Go 1.21+ is installed: `go version`
2. Clear module cache: `go clean -modcache`
3. Re-download dependencies: `go mod download`

## Getting Help

- **Documentation**: [docs/](../docs)
- **Issues**: [GitHub Issues](https://github.com/justin4957/media-context-crawler/issues)
- **Discussions**: [GitHub Discussions](https://github.com/justin4957/media-context-crawler/discussions)

## License

This project is licensed under the MIT License. See [LICENSE](../LICENSE) for details.
