module github.com/justin4957/media-context-crawler

go 1.21

require (
	// Database
	github.com/lib/pq v1.10.9

	// Configuration
	gopkg.in/yaml.v3 v3.0.1

	// HTTP and API clients
	github.com/go-resty/resty/v2 v2.11.0

	// NLP and text processing
	github.com/jdkato/prose/v2 v2.0.0

	// CLI
	github.com/spf13/cobra v1.8.0
	github.com/spf13/viper v1.18.2

	// Logging
	go.uber.org/zap v1.26.0

	// Testing
	github.com/stretchr/testify v1.8.4
)
