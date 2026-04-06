#!/usr/bin/env bash
# research-agent.sh — Daily KSA retail research
#
# Usage: bash scripts/research-agent.sh
# Runs manually or via cron at 5AM daily
#
# This script researches KSA retail news and publishes to the blog.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONTENT_DIR="$PROJECT_ROOT/my-hugo-site/content/posts/2026"
LOG_FILE="$PROJECT_ROOT/logs/research.log"
TODAY=$(date +%Y-%m-%d)
RESEARCH_FILE="$CONTENT_DIR/research-$TODAY.md"

mkdir -p "$PROJECT_ROOT/logs"
mkdir -p "$CONTENT_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting daily KSA retail research..."

# Check for websearch command (from opencode tools)
if command -v websearch &> /dev/null; then
    log "Using websearch tool..."
    
    # Search for KSA retail news
    SEARCH_RESULTS=$(websearch --query "Saudi Arabia retail Vision 2030 news 2026" --numResults 5 2>&1 || true)
    
    if [ -n "$SEARCH_RESULTS" ]; then
        log "Found search results"
    fi
fi

# Check for opencode agent capability
if [ -f "$HOME/.config/opencode/bin/opencode" ]; then
    log "OpenCode available - use agent for research"
fi

# Create research post template
log "Creating research post: $RESEARCH_FILE"

cat > "$RESEARCH_FILE" << EOF
---
title: "KSA Retail Update: $(date +'%B %d, %Y')"
date: $TODAY
draft: true
categories: ["Retail Operations"]
tags: ["KSA Retail", "Technology", "Dark Store", "Omnichannel", "Research"]
weight: 1
---

## Executive Summary
[Research pending - add summary of key findings]

## Key Findings
- [Add finding 1 with source]
- [Add finding 2 with source]
- [Add finding 3 with source]
- [Add finding 4 with source]

## Industry Implications
[Analyze what these developments mean for KSA retail operators]

## Sources
- [Source 1](URL) — Date
- [Source 2](URL) — Date
- [Source 3](URL) — Date
EOF

log "Created research template at $RESEARCH_FILE"
log "Edit the file with research findings, then set draft: false and run publish.sh"

# Check if there's a research prompt file
if [ -f "$PROJECT_ROOT/logs/research-prompt.txt" ]; then
    log "Research prompt available at logs/research-prompt.txt"
fi

log "Run 'bash scripts/publish.sh' after completing research to publish"

exit 0