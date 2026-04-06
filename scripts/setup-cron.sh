#!/usr/bin/env bash
# setup-cron.sh — Set up cronjob for automatic blog publishing

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUBLISH_SCRIPT="$SCRIPT_DIR/publish.sh"

CRON_JOB="0 8 * * 0 cd \"$SCRIPT_DIR\" && bash \"$(basename "$PUBLISH_SCRIPT")\" >> \$HOME/blog-publish.log 2>&1"

if [[ "${1:-}" == "--remove" ]]; then
  crontab -l 2>/dev/null | grep -v -F "$PUBLISH_SCRIPT" | crontab -
  echo "Cronjob removed"
  exit 0
fi

(crontab -l 2>/dev/null | grep -v -F "$PUBLISH_SCRIPT"; echo "$CRON_JOB") | crontab -

echo "Installed: Every Sunday at 8:00 AM"
echo "Log: ~/blog-publish.log"
crontab -l | grep -F "$PUBLISH_SCRIPT"