# Changelog

All notable changes to Slice Flow will be documented here.

## [1.0.1] - 2026-04-06

### Fixed
- SessionStart hook: `agent` type is not supported for session startup hooks; replaced with a `command` type that runs `hooks/session-start.sh`
- Extracted inline hook command into `hooks/session-start.sh` for readability

## [1.0.0] - 2026-04-05

### Added
- Initial release
- Skills: brainstorming, slice-planning, checkpoint, research, git-discipline, roadmap-consolidation
- Hooks: SessionStart (adaptive context injection), PostToolUse (commit nudge)
