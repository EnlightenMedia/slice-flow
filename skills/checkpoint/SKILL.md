# Checkpoint

Gates multi-unit work by decomposing it into slices, presenting them for approval, building one at a time, and pausing between slices for human verification.

## When to trigger

Trigger when the work at hand contains multiple logical units that could each be built, run, and verified independently, AND no approved slice plan exists for the current task.

Do NOT trigger when:
- An approved slice plan exists for the current task — the plan defines the boundary, follow it
- The work is a single unit (even if it spans many files) — a single bug fix, a single refactor, or a single skill file are all one unit regardless of file count
- The user is asking questions, researching, or running commands
- The user has explicitly said to skip pauses for the current task

## What it produces

Conversational output only — no files. The gating is behavioral: pausing and waiting for explicit approval.

## Behaviors

1. Decompose the work into slices with observable, verifiable results. Present the slices and wait for explicit user approval before starting any work.

2. Build one slice at a time. After completing each slice:
   - Report what was built
   - Explain how to verify it
   - Present what the next slice will be
   - Wait for explicit user approval before continuing

3. Within a single slice, use normal Claude flow — do not add extra gates on top of Claude's native behavior.

4. If mid-slice the scope grows beyond one logical unit, stop and re-decompose before continuing.

## Guardrails

- Never combine slices to "save time"
- Never silently continue past a slice boundary — always pause and wait
- Exception: if the user explicitly says "just do them all" or "skip pauses" for a specific task, honor it for that task only. Do not carry the exception forward to future tasks.
- If an approved slice plan exists, this skill does not trigger — the plan is the unit of work
