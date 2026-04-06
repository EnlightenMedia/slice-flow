---
name: git-discipline
description: >-
  Git safety checks before committing. TRIGGER when: about to run git add,
  git commit, or any git staging operation. Also trigger when starting work
  in a project for the first time to check for .gitignore. Make sure to use
  this skill whenever staging files, committing changes, or initialising a
  git repository, even if it seems routine.
user-invocable: false
---

# Git Discipline — Commit Safe

The commit flow is always: **status → inspect → stage by name → commit.**
Never skip or reorder these steps.

## Before the First Commit in a Project

Before making any commit in a project, check:

1. **Does a `.gitignore` file exist?** If not, create one appropriate for
   the project's tech stack before committing anything.
2. **Review what's being staged.** Look for files that should not be
   committed:
   - `.env` files, credentials, API keys, secrets
   - Build output, `node_modules/`, `bin/`, `obj/`
   - IDE-specific files (`.vs/`, `.idea/`) unless the project already
     tracks them
   - Large binary files, database files
   - OS files (`.DS_Store`, `Thumbs.db`)
3. **If there is any doubt about whether a file contains sensitive data,
   ask the user before staging it.** Do not guess. The cost of asking is
   low; the cost of committing a secret is high.

## Sensitive File Patterns — Always Require Explicit Human Confirmation

The following patterns bypass all judgment. Always ask the user to explicitly
confirm before staging, without exception:

- `.env*`
- `*.pem`
- `*.key`
- `*secret*`
- `*credential*`
- `*.p12`
- `*.pfx`

If any of these are present in the working tree (even if gitignored), mention
them to the user as a heads-up.

## During Ongoing Work

- Run `git status` first to produce a manifest of all changed and untracked files.
- Inspect each file on the manifest individually before staging.
- Stage specific files by name. Never use `git add -A` or `git add .` — these
  can sweep in unintended files.
- If the project's `.gitignore` is missing entries for the current tech
  stack, update it before staging.
- If you notice sensitive-looking files in the working tree (even if
  they're gitignored), mention them to the user as a heads-up.
