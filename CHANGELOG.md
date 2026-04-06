# Changelog

All notable changes to Slice Flow will be documented here.

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
