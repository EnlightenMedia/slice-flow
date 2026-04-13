---
name: slice-planning
description: >-
  Produces a feature brief with tasks and done criteria for a single slice.
  TRIGGER when: the user is ready to start working on a specific slice and
  needs to break it into tasks before implementation begins.
  DO NOT TRIGGER when: the user is asking a question, wants a recommendation,
  is still brainstorming, or already has a plan and wants to start building.
user-invocable: true
argument-hint: "[slice name or number from roadmap]"
---

# Slice Planning — Feature Brief for One Slice

This skill takes a single slice from an approved roadmap and produces a
feature brief: what it delivers, what tasks are needed to build it, and
how to know when it's done. Implementation detail belongs in the build
phase, not here.

Do NOT write implementation code during slice planning. Do NOT prescribe
file structures, class interfaces, code snippets, or startup sequences.
The only artifact is the feature brief.

## Step 1 — Load Context

Find and read the relevant roadmap document from `docs/roadmaps/`.
If no roadmap exists, ask the user to describe the slice they want to plan.

Identify the specific slice to plan. If the user didn't specify, ask which
slice they want to work on next.

Check whether any prior slices have been completed that affect this one
(read prior slice plans and their status if they exist).

## Step 2 — Explore the Codebase

Before planning, understand what already exists:
- What's already built from prior slices?
- What conventions does the project follow?
- What dependencies are already installed?

This informs the tasks — not to prescribe how to build, but to understand
the starting point.

## Step 3 — Write the Feature Brief

**Write the draft to file** at `docs/slices/YYYY-MM-DD-slice-N-<slice-name>.md`
so the user can review it in their editor. The terminal is not a good
place to read structured plans.

The brief should contain:

- **Slice** — name and which roadmap it belongs to
- **Objective** — what the user can see, run, or demonstrate when this
  slice is complete (restate from roadmap)
- **Key decisions** — architectural or library choices that affect this
  slice or future slices. Only include decisions where there's a genuine
  alternative worth noting. If a choice needs research into current
  package versions or APIs, flag it for the research skill.
- **Tasks** — a numbered list of implementation tasks. Each task should
  be a logical step toward the objective, not a file-level prescription.
  Think "what do we need to build" not "what code do we write."
  Always include as the final task: "Commit — run git-discipline and
  commit all slice changes with a descriptive message."
- **Done criteria** — a checklist of observable, verifiable conditions
  that must all be true for the slice to be considered complete. These
  should be testable by the user, not internal implementation checks.
  Always include as the final criterion: "[ ] All slice changes committed
  to git with a descriptive message."
- **Status** — use standard markers: `[ ]` Not started, `[P]` Planned,
  `[~]` In progress, `[x]` Complete. Initial status is `[ ] Not started`

**What NOT to include:**
- File paths or directory structures — the implementer decides those
- Class interfaces or function signatures — those emerge during coding
- Code snippets or pseudocode — that's implementation
- Startup sequences or data flow diagrams — too prescriptive

After writing the file, tell the user where it is and ask them to review.

**Stop completely.** Do not list implementation steps, do not create a
task tracker, do not begin any work. Wait for the user to reply.
Their reply is the gate — nothing else is.

## Step 4 — Refine

The user may:
- Adjust the task breakdown
- Add or remove done criteria
- Challenge a key decision
- Ask you to research a library or API before committing
- Flag that a task is too big or too small

Update the file with each revision. Iterate until the user approves.

## Step 5 — Finalise

Once approved, update the roadmap document to mark this slice as
`[P] Planned` with a link to the slice plan.

Then commit the slice plan and roadmap update using git-discipline:
run `git status`, stage the slice plan file and the roadmap file by
name, and commit with a message describing the slice that was planned.

## Guidelines

- Keep it brief. A good feature brief fits on one screen.
- Tasks describe what to build, not how to build it.
- Done criteria describe what the user can verify, not what the code
  looks like internally.
- One slice at a time. Do not plan the next slice until this one is done.
- If a slice is too large to break into 3-7 tasks, it should probably
  be split into smaller slices — flag this to the user.
- **No self-sequencing.** Phrases like "now let me implement", "let's get
  started", or creating a task/step list before approval are implementation
  acts. They are forbidden before the user approves the written brief.
- **No self-approval.** Only the user can approve the brief. Agreement
  with your own plan is not approval.
