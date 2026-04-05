# Slice Flow — Plugin Design

**Date:** 2026-04-05
**Status:** Approved

---

## Overview

Slice Flow is a Claude Code plugin that enforces iterative, human-gated, slice-based development. It is distributed as open source on GitHub and published to the Claude Code plugin marketplace.

---

## Directory Structure

```
slice-flow/
├── .claude-plugin/
│   └── plugin.json          # manifest: name, version, description, author, license, keywords
├── skills/
│   ├── brainstorming/
│   │   └── SKILL.md
│   ├── slice-planning/
│   │   └── SKILL.md
│   ├── checkpoint/
│   │   └── SKILL.md
│   ├── research/
│   │   └── SKILL.md
│   ├── git-discipline/
│   │   └── SKILL.md
│   └── roadmap-consolidation/
│       └── SKILL.md         # future capability — manual invocation only
├── hooks/
│   └── hooks.json           # SessionStart + PostToolUse (Write|Edit) agent hooks
├── README.md
├── CHANGELOG.md
└── LICENSE
```

Each skill is self-contained: all logic lives in its own `SKILL.md` with no cross-references to other skill files. Roadmap Consolidation is included from the start but its `SKILL.md` makes clear it only runs when explicitly invoked.

---

## Plugin Manifest

`.claude-plugin/plugin.json`:

```json
{
  "name": "slice-flow",
  "version": "1.0.0",
  "description": "Enforces iterative, human-gated, slice-based development with AI coding assistants.",
  "author": {
    "url": "https://github.com/<to-be-confirmed>"
  },
  "homepage": "https://github.com/<to-be-confirmed>/slice-flow",
  "repository": "https://github.com/<to-be-confirmed>/slice-flow",
  "license": "MIT",
  "keywords": ["workflow", "planning", "vertical-slices", "development-process", "human-in-the-loop"]
}
```

GitHub organisation/username to be confirmed before publishing.

---

## Skills

Each skill's `SKILL.md` encodes the corresponding section of the spec directly.

| Skill | Triggers when | Key behaviors | Hard stops |
|---|---|---|---|
| **brainstorming** | High-level idea needs slicing | Checks existing roadmaps, enforces vertical slice decomposition, iterates until user approves | No code; no future enhancements beyond scope |
| **slice-planning** | User picks a slice to plan | Explores codebase, produces feature brief, updates roadmap status | No file structures or code snippets; one slice at a time |
| **checkpoint** | Multi-unit work with no approved plan | Decomposes, presents slices, pauses between each for approval | Never skips pauses; suppressed when approved slice plan exists |
| **research** | About to use an external dependency | Checks registries + GitHub, states contradictions with training data | Fail-fast: stops after exhausting genuine angles, not rephrasing |
| **git-discipline** | Every commit attempt | status → inspect → stage by name → commit; creates .gitignore if missing | Never `git add -A`; sensitive file patterns always require explicit confirmation |
| **roadmap-consolidation** | Explicitly invoked only | Reads all roadmaps + slices, adds unlinked slices, surfaces conflicts | Never auto-triggers; never modifies slice content |

---

## Hooks

Both hooks use the `agent` type, giving them filesystem access via tools.

### SessionStart

Runs when a session begins.

1. Checks if `docs/roadmaps/` and `docs/slices/` exist at repo root — if neither exists, silently exits (new project, nothing to inject)
2. Reads all roadmap files → extracts slice list and statuses
3. Reads all slice plan files → extracts statuses
4. Injects a structured summary: roadmap goals, all slices with statuses, full content of any in-progress (`[~]`) slice
5. Establishes standard status markers and the no-re-planning rule for the session

### PostToolUse

Matcher: `Write|Edit` — fires after any file is written or modified.

1. Checks the path of the file just written
2. If under `docs/roadmaps/` or `docs/slices/` → always suggests a commit
3. If a code file → checks if surrounding context indicates task completion; if yes, suggests a commit; if ambiguous or no, exits silently (bias toward not interrupting flow)
4. Suggestion is a short non-blocking nudge — one line, no gate

---

## Status Markers

All planning documents use consistent markers:

| Marker | Meaning |
|---|---|
| `[ ]` | Not started |
| `[P]` | Planned (slice plan exists) |
| `[~]` | In progress |
| `[x]` | Complete |

Status must be updated in both the slice plan and the roadmap when a slice changes state.

---

## Path Conventions

- `docs/roadmaps/` and `docs/slices/` live at the **repository root**, not nested under any project or package. This ensures planning documents are shared across all projects in a workspace.
- Roadmap filenames: `docs/roadmaps/YYYY-MM-DD-<topic>.md`
- Slice plan filenames: `docs/slices/YYYY-MM-DD-slice-N-<slice-name>.md`
