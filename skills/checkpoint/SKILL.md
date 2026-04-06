---
name: checkpoint
description: >-
  Decomposes multi-unit work into vertical slices and gates transitions between them.
  TRIGGER when: the task involves more than one logical unit of work that could
  each be built and verified independently.
  DO NOT TRIGGER when: the task is a single cohesive change, a question,
  research, or running commands.
user-invocable: true
argument-hint: "[optional: description of work to decompose]"
---

# Checkpoint — Slice Control for Multi-Unit Work

This skill governs how multi-unit work is decomposed and sequenced.
It does NOT gate individual edits or single-unit tasks — Claude's native
plan mode and edit confirmations handle those.

## When This Activates

**Activate when** the requested work involves multiple logical units — distinct
changes that could each be built, run, and verified independently.

Examples: "build a plugin with three skills", "refactor auth and add logging",
"set up CI, linting, and test infrastructure".

**Do not activate when:**
- The work is a single cohesive unit, regardless of how many files it touches.
  A single skill file, a single bug fix, a single refactor — these are one unit
  even if they span several files.
- An approved slice plan exists for the current task. The slice plan defines
  the boundary and is the unit of work — do not decompose on top of it.
- The user is asking a question, researching, or running commands.

## What To Do

**Step 1 — Present the slice list.**

Before beginning, decompose the work into vertical slices. Each slice must be:
- Independently buildable and runnable
- Small enough to review in one pass
- Described by its observable result, not its implementation details

Present the list:

```
I see N slices in this work:

1. [Slice name] — [what will be observable/verifiable when done]
2. [Slice name] — [what will be observable/verifiable when done]
...

I'll build these one at a time, pausing after each.
Which slice should I start with, or would you like to adjust this breakdown?
```

**Stop completely.** Wait for the user to approve the breakdown before
starting any slice. Their reply is the gate — nothing else is.

**Step 2 — Build the approved slice.**

Implement using Claude's normal flow — plan, edit, confirm as usual.
Do not add extra gates on top of Claude's native behavior within a slice.

**Step 3 — Pause between slices.**

After completing a slice, stop and report:
- What was built
- How to verify it

Then present what the next slice will be and wait for explicit approval
before starting it. Do NOT silently continue into the next slice.

## Rules

- Never combine multiple slices into one to "save time."
- Never skip the pause between slices.
- If the user says "just do them all" or "skip pauses" for a specific task,
  proceed without inter-slice pauses FOR THAT TASK ONLY.
- If mid-slice you realize the scope has grown beyond one logical unit,
  stop and re-decompose.
- **No self-sequencing.** Moving directly into the first slice after
  presenting the breakdown is forbidden. Wait for explicit user approval.
- **No self-approval.** Only the user can approve the breakdown or
  authorize the next slice. Agreement with your own proposal is not approval.
