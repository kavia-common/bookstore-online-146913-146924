#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-146913-146924/backend"
cd "$WORKSPACE"
if [ -f package-lock.json ]; then
  npm ci --no-audit --no-fund || { echo "npm ci failed" >&2; exit 4; }
else
  npm i --include=dev --no-audit --no-fund || { echo "npm i failed" >&2; exit 5; }
fi
# verify key modules by requiring the app (will throw and exit nonzero if broken)
node -e "require('./index'); console.log('require-check OK')" || { echo "require-check failed" >&2; exit 6; }
