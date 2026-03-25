#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/home/clawbot/.openclaw/workspace/prayer-timings"
STATE_FILE="/home/clawbot/.openclaw/workspace/.state/prayer-timings-last-sha"
LOG_FILE="/home/clawbot/.openclaw/workspace/logs/prayer-timings-autodeploy.log"
REPO="https://github.com/tariqbaater/Prayer_Timings.git"
BRANCH="main"

mkdir -p "$(dirname "$STATE_FILE")" "$(dirname "$LOG_FILE")"
cd "$APP_DIR"

REMOTE_SHA=$(git ls-remote "$REPO" "refs/heads/$BRANCH" | awk '{print $1}')
CURRENT_SHA=$(cat "$STATE_FILE" 2>/dev/null || git rev-parse HEAD)

if [[ -z "$REMOTE_SHA" ]]; then
  echo "$(date -u +%FT%TZ) ERROR: could not fetch remote SHA" >> "$LOG_FILE"
  exit 1
fi

if [[ "$REMOTE_SHA" != "$CURRENT_SHA" ]]; then
  git fetch origin "$BRANCH" >> "$LOG_FILE" 2>&1
  git checkout "$BRANCH" >> "$LOG_FILE" 2>&1
  git reset --hard "origin/$BRANCH" >> "$LOG_FILE" 2>&1
  echo "$REMOTE_SHA" > "$STATE_FILE"
  echo "$(date -u +%FT%TZ) Updated to $REMOTE_SHA" >> "$LOG_FILE"
else
  echo "$(date -u +%FT%TZ) No changes ($REMOTE_SHA)" >> "$LOG_FILE"
fi
