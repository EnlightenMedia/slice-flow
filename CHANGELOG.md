# Changelog

All notable changes to Slice Flow will be documented here.

## [1.0.11] - 2026-04-06

### Changed
- Roadmap Consolidation skill rewritten: added frontmatter, step-based structure, present-plan-before-changes gate (hard stop for user confirmation), removed future-capability notice

## [1.0.10] - 2026-04-06

### Changed
- Research skill rewritten: added frontmatter, structured step format, explicit fail-fast escalation steps including "record the finding", report templates, integration guidance

## [1.0.9] - 2026-04-06

### Changed
- Git Discipline skill rewritten: added frontmatter (user-invocable: false), named commit flow (status → inspect → stage by name → commit), explicit sensitive file patterns hard list

## [1.0.8] - 2026-04-06

### Changed
- Checkpoint skill rewritten: added frontmatter, presentation template, hard stop after slice breakdown, "do not activate when approved slice plan exists" guardrail, anti-rationalization guardrails

## [1.0.7] - 2026-04-06

### Changed
- Brainstorming skill rewritten: added frontmatter, Step 0 (existing roadmap check), Step 2 (present approaches with research verification), write-first approach, explicit hard stop after presenting roadmap, anti-rationalization guardrails

## [1.0.6] - 2026-04-06

### Changed
- Slice Planning skill rewritten: write-first approach (brief saved to file before user review), explicit hard stop after presenting the brief, anti-rationalization guardrails (no self-sequencing, no self-approval)

## [1.0.5] - 2026-04-06

### Fixed
- SessionStart hook: explicitly forbid inline planning summaries as substitutes for a saved slice plan file; clarify that only the user (not Claude) can approve a plan

## [1.0.4] - 2026-04-06

### Fixed
- SessionStart hook: clarify that selecting a slice is a trigger to run Slice Planning, not approval to build — prevents Claude from jumping straight into implementation on "Let's start with Slice N"

## [1.0.3] - 2026-04-06

### Fixed
- SessionStart hook: add explicit rule to apply Git Discipline after completing a slice, so Claude proactively runs the commit flow rather than waiting to be asked

## [1.0.2] - 2026-04-06

### Fixed
- SessionStart hook: always inject workflow rules so Claude enforces planning before coding, even on new projects with no docs yet

## [1.0.1] - 2026-04-06

### Fixed
- SessionStart hook: `agent` type is not supported for session startup hooks; replaced with a `command` type that runs `hooks/session-start.sh`
- Extracted inline hook command into `hooks/session-start.sh` for readability

## [1.0.0] - 2026-04-05

### Added
- Initial release
- Skills: brainstorming, slice-planning, checkpoint, research, git-discipline, roadmap-consolidation
- Hooks: SessionStart (adaptive context injection), PostToolUse (commit nudge)
