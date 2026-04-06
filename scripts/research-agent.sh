#!/usr/bin/env bash
# research-agent.sh — Launch daily retail research agent
#
# Runs at 5:00 AM daily via cronjob
# Researches KSA retail news and publishes to blog

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_FILE="$PROJECT_ROOT/logs/research.log"

mkdir -p "$PROJECT_ROOT/logs"

echo "[$(date)] Starting daily research..." >> "$LOG_FILE"

# Check if agent tool is available (for opencode environment)
if command -v task &> /dev/null; then
    # Run research agent
    task --subagent-type gsd-project-researcher \
        --prompt "Research the latest developments in Saudi Arabian retail sector. Focus on:
        1. Modern Retail in KSA (Vision 2030, market trends, regulations)
        2. Technology Advances (AI/ML, POS, e-commerce, digital payments)
        3. Darkstores & Omnichannel (last-mile, fulfillment, delivery)
        
        Output: Write a research post to /Users/openclaw/.openclaw/workspace/tariq/Blog/my-hugo-site/content/posts/2026/research-$(date +%Y-%m-%d).md
        
        Follow the format in AGENTS.md:
        - Executive summary (2-3 sentences)
        - Key findings (bulleted list)
        - Industry implications (2-3 paragraphs)  
        - Sources (minimum 3, with dates)
        
        Use websearch and webfetch tools to gather current news from Saudi sources." \
        --description "Daily KSA retail research" 2>&1 | tee -a "$LOG_FILE"
else
    echo "[$(date)] ERROR: task command not found" >> "$LOG_FILE"
    exit 1
fi

# If research file created, commit and publish
RESEARCH_FILE="$PROJECT_ROOT/my-hugo-site/content/posts/2026/research-$(date +%Y-%m-%d).md"

if [ -f "$RESEARCH_FILE" ]; then
    echo "[$(date)] Research found, publishing..." >> "$LOG_FILE"
    cd "$PROJECT_ROOT"
    git add "$RESEARCH_FILE"
    git commit -m "research: daily KSA retail update ($(date +%Y-%m-%d))" 2>/dev/null || true
    
    # Run publish script
    bash "$SCRIPT_DIR/publish.sh" 2>&1 | tee -a "$LOG_FILE"
    
    echo "[$(date)] Research published successfully" >> "$LOG_FILE"
else
    echo "[$(date)] No research file created, skipping publish" >> "$LOG_FILE"
fi

echo "[$(date)] Daily research complete" >> "$LOG_FILE"