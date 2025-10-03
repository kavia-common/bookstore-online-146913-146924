#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/bookstore-online-146913-146924/backend"
cd "$WORKSPACE"
# start production server (node start.js) and capture PID
node start.js &
PID=$!
cleanup(){
  if ps -p "$PID" >/dev/null 2>&1; then
    kill "$PID" 2>/dev/null || true
    # wait up to 5s for graceful shutdown
    for i in 0 1 2 3 4; do
      if ! ps -p "$PID" >/dev/null 2>&1; then break; fi
      sleep 1
    done
    if ps -p "$PID" >/dev/null 2>&1; then
      kill -9 "$PID" 2>/dev/null || true
    fi
  fi
}
trap cleanup EXIT
URL=http://127.0.0.1:3000/catalog
MAX=20; SLEEP=0.5; i=0
while [ $i -lt $MAX ]; do
  # prefer HTTP probe; timeout short to avoid blocking
  if curl -sS -m 2 -f "$URL" -o /tmp/validate_body.$$; then
    HTTP_STATUS=0
    BODY_SNIPPET=$(head -c 200 /tmp/validate_body.$$ | sed -n '1,1p' || true)
    echo "validation: http OK; body_snippet: ${BODY_SNIPPET}"
    rm -f /tmp/validate_body.$$ || true
    cleanup
    trap - EXIT
    exit 0
  fi
  i=$((i+1)); sleep $SLEEP
done
echo "validation failed: /catalog endpoint unreachable after retries" >&2
cleanup
exit 5
