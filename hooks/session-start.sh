#!/usr/bin/env bash
# Slice Flow — SessionStart hook
# Reads docs/roadmaps/ and docs/slices/ from the project root and outputs
# their contents as context for the session. Exits silently if neither exists.

if [ ! -d "docs/roadmaps" ] && [ ! -d "docs/slices" ]; then
  exit 0
fi

printf "## Slice Flow — Session Context\n\n"
printf "Status markers: [ ] Not started | [P] Planned | [~] In progress | [x] Complete\n"
printf "docs/roadmaps/ and docs/slices/ live at the repository root.\n"
printf "If a slice plan exists for the current task, follow it exactly — do not re-decompose or re-plan approved work.\n"
printf "If mid-build reality diverges from the plan, stop and surface it to the human before continuing.\n"
printf "Update status in both the slice plan and the roadmap when a slice changes state.\n\n"

if [ -d "docs/roadmaps" ]; then
  for f in docs/roadmaps/*.md; do
    [ -f "$f" ] || continue
    printf "### %s\n" "$f"
    cat "$f"
    printf "\n---\n\n"
  done
fi

if [ -d "docs/slices" ]; then
  for f in docs/slices/*.md; do
    [ -f "$f" ] || continue
    printf "### %s\n" "$f"
    cat "$f"
    printf "\n---\n\n"
  done
fi
