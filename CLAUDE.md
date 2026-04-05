# Slice Flow — Developer Guide

## What this repo is

Slice Flow is a Claude Code plugin. It enforces iterative, human-gated, slice-based development by providing six skills and two hooks.

The authoritative reference for all behavior, triggers, guardrails, and design decisions is:
**`docs/slice-flow-spec.md`** — read it before making any changes.

The design document (`docs/2026-04-05-slice-flow-design.md`) records the architectural decisions made during the initial build.

---

## Plugin structure

```
slice-flow/
├── .claude-plugin/plugin.json     # manifest
├── skills/<name>/SKILL.md         # one directory per skill
├── hooks/hooks.json               # SessionStart + PostToolUse agent hooks
├── README.md
├── CHANGELOG.md
└── LICENSE
```

Components must be at the plugin root. Only `plugin.json` belongs in `.claude-plugin/`.

---

## Skill conventions

### Self-contained

Every skill is fully self-contained. A skill may not reference or depend on content from another skill file. If a definition (e.g. vertical slice, status markers) is needed in two skills, it is written in both. This is intentional — each skill must be understandable in isolation.

### SKILL.md structure

Each skill file follows this structure:

```markdown
# <Skill Name>

One-sentence description of what this skill does.

## When to trigger
[conditions that activate this skill]
[explicit DO NOT trigger conditions]

## What it produces
[the single artifact or output this skill creates]

## Behaviors
[numbered list of behaviors in execution order]

## Guardrails
[hard constraints — things this skill must never do]
```

### Faithfulness to the spec

Skill content must faithfully reflect `docs/slice-flow-spec.md`. Do not interpret, extend, or add behaviors beyond what the spec defines. If the spec needs to change, update the spec first, then update the skill.

---

## Hook conventions

Both hooks use `agent` type for filesystem access. Hook prompts live inline in `hooks/hooks.json`.

- **SessionStart** — reads `docs/roadmaps/` and `docs/slices/`, injects adaptive context (summary of all, full content of in-progress slices)
- **PostToolUse (Write|Edit)** — suggests a commit after planning artifacts; suggests a commit after code task completion signals; exits silently otherwise

---

## Validating changes

Before committing any change to the plugin:

```bash
/plugin validate .
```

This checks `plugin.json`, skill/agent frontmatter, and `hooks/hooks.json` for schema errors.

## Testing locally

To test the plugin in the current session without installing it:

```bash
claude --plugin-dir .
```

Then use `/plugin` to confirm all skills and hooks registered correctly.

---

## Commits

Follow the git-discipline skill's own flow: `status → inspect → stage by name → commit`. Do not use `git add -A`.

Bump the version in `.claude-plugin/plugin.json` and add a `CHANGELOG.md` entry for any change that affects plugin behavior.
