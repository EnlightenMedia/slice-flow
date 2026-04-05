# Git Discipline

Ensures safe commit hygiene by validating what is being committed before it is committed.

## When to trigger

Trigger on every commit attempt — non-negotiable.

## What it produces

Validation and verification only — no new files created.

## Commit flow

The flow is always: **status → inspect → stage by name → commit**

1. **Status** — run `git status` to produce an explicit manifest of all changed and untracked files
2. **Inspect** — review each file on the manifest individually before staging
3. **Stage by name** — stage specific files by name from the verified manifest
4. **Commit** — create the commit with a descriptive message

Never use `git add -A` or `git add .` — always stage by explicit filename.

## Before the first commit in a project

Check for a `.gitignore` file. If one does not exist, create one appropriate for the tech stack before anything is committed.

## Per-file checks

For each file on the manifest, check for:
- `.env` files, credentials, API keys, secrets
- Build output (`node_modules/`, `bin/`, `obj/`, `dist/`, `.next/`, `__pycache__/`)
- IDE-specific files (`.vs/`, `.idea/`, `.vscode/` unless already tracked)
- Large binary files
- Database files
- OS files (`.DS_Store`, `Thumbs.db`)

If the project's `.gitignore` is missing entries for detected tech stack artifacts, update it before staging.

## Sensitive file patterns — always require explicit human confirmation

The following patterns bypass all judgment and always require the user to explicitly confirm before staging, without exception:

- `.env*`
- `*.pem`
- `*.key`
- `*secret*`
- `*credential*`
- `*.p12`
- `*.pfx`

If sensitive-looking files are present in the working tree (even if gitignored), mention them to the user as a heads-up.

## Guardrails

- If there is any doubt about whether a file contains sensitive data, ask the user before staging — the cost of asking is low; the cost of committing a secret is high
- The sensitive file patterns listed above bypass doubt entirely — they always require explicit human confirmation regardless of context
- Never skip this flow, never batch it, never abbreviate it
