package main

import (
	"fmt"
	"log"
)

// This is a placeholder example showing how the Media Context Crawler will be used
// Implementation coming in Phase 1

func main() {
	fmt.Println("Media Context Crawler - Basic Usage Example")
	fmt.Println("============================================")
	fmt.Println()

	// Example 1: Analyze a YouTube video
	analyzeVideoExample()

	// Example 2: Create a tree search
	treeSearchExample()

	// Example 3: Query results
	queryResultsExample()
}

func analyzeVideoExample() {
	fmt.Println("Example 1: Analyze a YouTube Video")
	fmt.Println("-----------------------------------")

	// This will be implemented in Phase 1
	videoURL := "https://youtube.com/watch?v=example"

	fmt.Printf("Step 1: Submit video URL: %s\n", videoURL)
	fmt.Println("Step 2: Extract transcript and metadata")
	fmt.Println("Step 3: Perform NLP analysis")
	fmt.Println("Step 4: Extract keywords with relevance scores")
	fmt.Println()
	fmt.Println("Expected output:")
	fmt.Println("  - Keywords: [climate, change, global, warming, carbon, emissions]")
	fmt.Println("  - Entities: [UN, Paris Agreement, IPCC]")
	fmt.Println("  - Topics: [climate science, environmental policy]")
	fmt.Println()
}

func treeSearchExample() {
	fmt.Println("Example 2: Create a Tree Search")
	fmt.Println("--------------------------------")

	// This will be implemented in Phase 1-2
	fmt.Println("Step 1: Configure search parameters")
	fmt.Println("  - Platforms: Twitter, Reddit")
	fmt.Println("  - Max depth: 3")
	fmt.Println("  - Keywords from video analysis")
	fmt.Println()
	fmt.Println("Step 2: Execute tree search")
	fmt.Println("  Level 0 (Root): Video keywords")
	fmt.Println("  Level 1: Search Twitter for 'climate change'")
	fmt.Println("    → Found 150 tweets")
	fmt.Println("    → Extract accounts: @ClimateScience, @GreenPolicy")
	fmt.Println("  Level 2: Search Reddit for 'carbon emissions'")
	fmt.Println("    → Found 75 posts in r/climate")
	fmt.Println("    → Extract hashtags: #NetZero, #ClimateAction")
	fmt.Println("  Level 3: Search Twitter for #NetZero")
	fmt.Println("    → Found 200 tweets")
	fmt.Println()
}

func queryResultsExample() {
	fmt.Println("Example 3: Query Search Results")
	fmt.Println("--------------------------------")

	fmt.Println("Query: Find all content mentioning 'carbon emissions'")
	fmt.Println("Results:")
	fmt.Println("  1. Twitter post by @ClimateScience")
	fmt.Println("     'New study shows carbon emissions dropped 5% in 2024'")
	fmt.Println("     Engagement: 1.2K likes, 340 retweets")
	fmt.Println()
	fmt.Println("  2. Reddit post in r/climate")
	fmt.Println("     'Discussion: How to reduce personal carbon footprint'")
	fmt.Println("     Engagement: 450 upvotes, 89 comments")
	fmt.Println()
	fmt.Println("Tree visualization:")
	fmt.Println("  Video: 'Climate Change Explained'")
	fmt.Println("    ├─ Twitter: 'climate change' (150 results)")
	fmt.Println("    │   ├─ @ClimateScience (45 tweets)")
	fmt.Println("    │   └─ @GreenPolicy (32 tweets)")
	fmt.Println("    └─ Reddit: 'carbon emissions' (75 results)")
	fmt.Println("        ├─ r/climate (45 posts)")
	fmt.Println("        └─ r/environment (30 posts)")
	fmt.Println()
}

// Note: This is a conceptual example
// Actual implementation will use the pkg/ modules:
// - pkg/nlp for keyword extraction
// - pkg/crawler for platform crawling
// - pkg/tree for search tree management
// - pkg/database for data persistence

func init() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}
