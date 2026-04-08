#!/usr/bin/env bash
# Slice Flow — PostToolUse hook (GitHub Copilot)
# Suggests a commit after writing planning documents.
# Input: JSON on stdin with toolName and toolArgs fields.

input=$(cat 2>/dev/null)

# Extract file path from toolArgs JSON (handles both string-encoded and object forms)
file_path=$(printf '%s' "$input" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    args = d.get('toolArgs', {})
    if isinstance(args, str):
        args = json.loads(args)
    print(args.get('file_path', args.get('path', '')))
except Exception:
    print('')
" 2>/dev/null)

if [[ "$file_path" == docs/roadmaps/* ]] || [[ "$file_path" == docs/slices/* ]]; then
    printf "Planning document saved — consider committing now with a short descriptive message.\n"
fi
