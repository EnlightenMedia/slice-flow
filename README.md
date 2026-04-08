# Slice Flow

**A plugin for Claude Code and GitHub Copilot CLI that enforces iterative, human-gated, slice-based development.**

Slice Flow prevents the common failure mode of AI-assisted development: rushing into code without a plan, building too much at once, and losing human oversight. It introduces vertical slices as the unit of work, requires planning before implementation, and gates transitions between work units with human approval.

---

## Installation

**Claude Code:**
```bash
claude plugin install slice-flow
```

Or install to a specific scope:

```bash
# Available to your whole team via version control
claude plugin install slice-flow --scope project

# Personal use only, gitignored
claude plugin install slice-flow --scope local
```

**GitHub Copilot CLI:**
```bash
gh copilot plugin install slice-flow
```

---

## What's included

### Skills

| Skill | Invoke | Purpose |
|---|---|---|
| `brainstorming` | Auto-triggered or `/slice-flow:brainstorming` | Converts a high-level idea into a roadmap of vertical slices |
| `slice-planning` | Auto-triggered or `/slice-flow:slice-planning` | Produces a feature brief for one approved slice |
| `checkpoint` | Auto-triggered or `/slice-flow:checkpoint` | Gates multi-unit work with human approval between slices |
| `research` | Auto-triggered or `/slice-flow:research` | Verifies external dependencies against current documentation |
| `git-discipline` | Auto-triggered or `/slice-flow:git-discipline` | Enforces safe commit hygiene: status → inspect → stage by name → commit |
| `roadmap-consolidation` | `/slice-flow:roadmap-consolidation` only | Consolidates fragmented planning documents (explicit invocation only) |

### Hooks

| Hook | Event | Purpose |
|---|---|---|
| Session context | `SessionStart` | Reads existing roadmaps and slice plans, injects a structured summary of project state into each session |
| Commit nudge | `PostToolUse` (Write/Edit) | Suggests a commit after planning artifacts are written, or after code task completion signals |

---

## How it works

The intended flow through a full feature lifecycle:

1. **Brainstorming** produces a roadmap → commit
2. **Slice Planning** produces a feature brief for slice 1 → commit
3. **Checkpoint** gates the work if no slice plan exists and work is multi-unit; defers to the slice plan if one exists
4. **Build** using normal Claude flow, treating slice plan tasks as the checklist
5. **Git Discipline** validates before each commit
6. Update status in slice plan and roadmap → commit
7. Return to step 2 for the next slice
8. **Roadmap Consolidation** run on demand when planning documents drift out of sync

---

## Planning document conventions

Planning documents live at the **repository root**, shared across all projects in the workspace:

```
docs/
├── roadmaps/
│   └── YYYY-MM-DD-<topic>.md
└── slices/
    └── YYYY-MM-DD-slice-N-<slice-name>.md
```

### Status markers

All documents use consistent status markers:

| Marker | Meaning |
|---|---|
| `[ ]` | Not started |
| `[P]` | Planned (slice plan exists) |
| `[~]` | In progress |
| `[x]` | Complete |

Status must be updated in both the slice plan and the roadmap when a slice changes state.

---

## Core concepts

### Vertical slices

The fundamental unit of work is a vertical slice — a piece of functionality that cuts through all layers of the stack and delivers observable, end-to-end value. A non-technical stakeholder should be able to see or use the result of each slice independently.

**Not a vertical slice:**
- A layer ("build the API", "build the UI")
- Plumbing ("set up the database")
- Testing ("write tests") — testing is part of every slice
- Something only verifiable by a developer

### The no-re-planning rule

Once a slice plan is approved, it is the build checklist. If mid-build reality diverges from the plan (a dependency doesn't work, an API doesn't expose what was assumed), stop immediately and surface it to the human before continuing. Do not improvise.

### Human gates

Humans approve every transition: which slice to work on, when a slice is done, and whether to proceed to the next. The AI never silently continues past a gate.

---

## License

[MIT](LICENSE)
