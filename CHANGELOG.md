# Changelog

All notable changes to Slice Flow will be documented here.

## [1.0.22] - 2026-04-13

### Changed
- Remove postToolUse hook from copilot-hooks.json — commit nudge now handled by skills

## [1.0.21] - 2026-04-13

### Changed
- Remove PostToolUse hook — replaced by explicit commit steps in brainstorming and slice-planning skills

## [1.0.20] - 2026-04-13

### Changed
- slice-planning: always include a commit task and done criterion in every slice brief; Step 5 now commits the slice plan and roadmap update
- brainstorming: add Step 5 to commit the roadmap after user approval
- Replaces the broken PostToolUse agent hook with explicit commit steps baked into the skills themselves

## [1.0.19] - 2026-04-13

### Fixed
- Restore PostToolUse hook (prompt-only) — reverted accidental removal

## [1.0.18] - 2026-04-13

### Fixed
- PostToolUse agent hook: remove `"prompt"` field, keep only `"messages"` array — hypothesis is that Claude Code picks `prompt` when both are present and then fails to convert it to messages internally

## [1.0.17] - 2026-04-13

### Fixed
- PostToolUse agent hook: include both `"prompt"` (string) and `"messages"` (array) fields with identical content — validator expects `prompt`, runtime expects `messages`; having both should satisfy both sides

## [1.0.16] - 2026-04-13

### Fixed
- PostToolUse agent hook: reverted `"messages"` array back to `"prompt"` string — Claude Code validator expects `prompt` (string), not `messages` (array)

## [1.0.15] - 2026-04-10

### Fixed
- PostToolUse agent hook: replaced `"prompt"` field with `"messages"` array (`[{"role": "user", "content": "..."}]`) to match the Claude Code agent hook runner's required schema

## [1.0.14] - 2026-04-08

### Added
- GitHub Copilot CLI plugin support: `.github/plugin.json` manifest
- `hooks/copilot-hooks.json` — Copilot-format hook config (`version: 1`, camelCase event names, bash-only)
- `hooks/post-tool-use.sh` — PostToolUse commit nudge for Copilot (bash equivalent of the Claude Code agent hook)

## [1.0.13] - 2026-04-07

### Changed
- Research skill: add "training data familiarity is not verification" guardrail
- SessionStart hook: add rule to run research before using any versioned third-party API

## [1.0.12] - 2026-04-06

### Changed
- SessionStart hook: at slice completion, present done criteria as a user verification checklist before running git-discipline
- Checkpoint skill Step 3: explicitly read done criteria from slice plan and present as concrete user-verification steps

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
