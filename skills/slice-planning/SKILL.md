# Slice Planning

Produces a feature brief for a single approved slice from a roadmap.

## When to trigger

Trigger when the user selects a specific slice from an approved roadmap and wants to plan it before building.

Do NOT trigger when:
- The user is still brainstorming or deciding which slice to work on
- The user already has an approved slice plan and wants to build — follow the plan, do not re-plan
- The user is asking questions or running exploratory commands

## What it produces

A feature brief saved to `docs/slices/YYYY-MM-DD-slice-N-<slice-name>.md` containing:
- Slice name and number
- Objective
- Key decisions
- Numbered tasks (what to build, not how)
- Done criteria (what the user can verify, not internal code details)
- Status

## Behaviors

1. Load the relevant roadmap. Check the status of prior slices to understand the starting point and any dependencies.

2. Explore the codebase to understand what is already built, what conventions the project follows, and what dependencies are installed. Use this to inform tasks — not to prescribe implementation.

3. Write tasks that describe what to build, not how. Write done criteria that describe what the user can observe or verify, not what the code looks like internally.

4. Keep the brief to one screen. If a slice needs more than 3–7 tasks, flag that it should probably be split into two smaller slices.

5. Flag any architecture or library decisions that need research verification before the build begins.

6. Present the brief and iterate until the user approves.

7. Once approved:
   - Save the feature brief to `docs/slices/YYYY-MM-DD-slice-N-<slice-name>.md`
   - Update the roadmap to mark the slice as `[P] Planned` with a link to the slice plan file
   - Suggest a commit

8. Plan one slice at a time. Do not plan the next slice until the current one is complete.

## Feature brief format

```markdown
# Slice N — <Name>

**Objective:** <one sentence>
**Status:** [P] Planned
**Roadmap:** [link to roadmap file]
**Created:** YYYY-MM-DD

## Key Decisions

- <decision 1>
- <decision 2>

## Tasks

1. <what to build>
2. <what to build>
...

## Done Criteria

- <what the user can see or verify>
- <what the user can see or verify>
```

## Guardrails

- Do NOT prescribe file structures, class interfaces, code snippets, file paths, or directory layouts — the implementer decides
- Do NOT include startup sequences or data flow diagrams — these are too prescriptive
- Do NOT plan the next slice until the current one is complete
