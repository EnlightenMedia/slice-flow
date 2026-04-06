#!/usr/bin/env bash
# Slice Flow — SessionStart hook
# Always injects workflow rules. Also reads docs/roadmaps/ and docs/slices/
# from the project root when they exist.

printf "## Slice Flow — Working Rules\n\n"
printf "You are operating under the Slice Flow workflow. Follow these rules for every session:\n\n"
printf "- Before writing any code for a new feature or goal, run the Brainstorming skill to produce a roadmap, then the Slice Planning skill to produce a feature brief. Do not skip planning.\n"
printf "- If a slice plan already exists for the current task, follow it exactly — do not re-decompose or re-plan approved work.\n"
printf "- If mid-build reality diverges from the plan, stop and surface it to the human before continuing.\n"
printf "- Update status in both the slice plan and the roadmap when a slice changes state.\n"
printf "- Status markers: [ ] Not started | [P] Planned | [~] In progress | [x] Complete\n"
printf "- docs/roadmaps/ and docs/slices/ live at the repository root.\n\n"

if [ ! -d "docs/roadmaps" ] && [ ! -d "docs/slices" ]; then
  printf "No planning documents found — this appears to be a new project. Start with the Brainstorming skill before writing any code.\n"
  exit 0
fi

printf "## Slice Flow — Project State\n\n"

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
