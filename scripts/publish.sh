#!/usr/bin/env bash
# publish.sh — Publish blog to GitHub Pages
#
# Usage:
#   ./publish.sh                    # Build and publish
#   ./publish.sh --check            # Just check for new content
#
# Workflow: cron runs this every Sunday 8AM to publish new posts
# from OpenCode agents.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HUGO_DIR="$PROJECT_ROOT/my-hugo-site"
OUTPUT_DIR="$HUGO_DIR/public"

echo "[publish] Starting blog publish..."

# Check Hugo
if ! command -v hugo &> /dev/null; then
  echo "[publish] ERROR: Hugo not installed"
  exit 1
fi

# Build Hugo
echo "[publish] Building Hugo site..."
cd "$HUGO_DIR"
hugo --destination public --minify

# Verify output
if [ ! -f "$OUTPUT_DIR/index.html" ]; then
  echo "[publish] ERROR: Build failed - no index.html"
  exit 1
fi

POST_COUNT=$(find "$OUTPUT_DIR/posts" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
echo "[publish] Build complete: $POST_COUNT posts"

# Copy build output to project root (GitHub Pages serves from root)
echo "[publish] Copying to deploy location..."
cp -r "$OUTPUT_DIR/"* "$PROJECT_ROOT/"

# Commit and push
cd "$PROJECT_ROOT"
git add -A

if git diff --staged --quiet; then
  echo "[publish] No changes to publish"
  exit 0
fi

git commit -m "blog: publish new posts ($(date +'%Y-%m-%d'))"
git push origin main

echo "[publish] ✅ Published to https://tariqbaater.github.io/"