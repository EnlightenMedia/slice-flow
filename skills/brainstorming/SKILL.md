---
name: brainstorming
description: >-
  Collaborative design that produces a sliced roadmap for iterative delivery.
  TRIGGER when: the user wants to plan a new feature, project, or significant
  piece of work before implementation begins.
  DO NOT TRIGGER when: the user is asking a question, wants a recommendation,
  is exploring ideas, or already has a clear single task and wants to start building.
  Not every conversation needs a roadmap - just answer questions directly.
user-invocable: true
argument-hint: "[what you want to build]"
---

# Brainstorming — From Idea to Sliced Roadmap

This skill turns an idea into a prioritised list of vertical slices ready for
iterative delivery. The output is a roadmap, not a spec — each slice is
something you can build, run, and demonstrate.

Do NOT write any code or create any implementation files during brainstorming.
The only artifact is the roadmap document.

## Step 0 — Check for an Existing Roadmap

Before starting from scratch, check `docs/roadmaps/` for an existing roadmap
that covers this project or feature area.

**If a roadmap exists**, read it and understand:
- What has already been completed (check slice statuses)
- What is planned but not yet started
- What the current approach and tech stack are

Also check `docs/slices/` for any slice plans that aren't referenced in
a roadmap. These are standalone slices that still occupy a slice number.
New slices must not conflict with existing slice numbers — whether those
slices are in a roadmap or not.

Then ask the user: are they extending this roadmap with new features, or
starting a separate roadmap for something unrelated?

- **Extending:** Skip Steps 1-2 (the goal and approach are established).
  Go straight to Step 3 and propose new slices that build on what exists.
  New slices should continue the numbering from the highest existing slice
  number (in roadmaps or standalone slice plans) and declare dependencies
  on existing slices where appropriate.
- **New roadmap:** Proceed from Step 1 as normal.

**If no roadmap exists**, proceed from Step 1.

## Step 1 — Understand the Goal

Ask clarifying questions to understand what the user wants to build and why.
Before moving to approaches, ensure you have covered the full surface area
of the problem. Use this checklist mentally — you do not need to ask about
every item, but you must not leave an entire dimension unexplored:

- **Users** — who uses this and how?
- **Frontend** — is there a UI? What kind? (web, mobile, CLI, none)
- **Backend** — APIs, services, data storage?
- **Tech stack** — languages, frameworks, platforms for each layer
- **Integrations** — third-party services, APIs, auth providers?
- **Deployment** — where does this run? Local, cloud, CI/CD?
- **Constraints** — budget, timeline, existing codebase, team size?

Rules:
- One question at a time. Do not dump a list of five questions.
- Prefer multiple-choice where possible — it's faster for the user to pick
  than to write from scratch.
- If the user's answer to one question reveals a dimension you haven't
  covered, ask about it before moving on.
- Stop asking when you have enough to propose approaches. You do not need
  a complete specification — just enough to slice meaningfully.
- If the user has already explained the goal clearly, skip to Step 2.

## Step 2 — Present Approaches

If there is a meaningful architectural or strategic choice, present 2-3
approaches. For each, state:
- The core idea in one sentence
- Key tradeoff (what you gain, what you give up)

If there is no meaningful choice (the path is obvious), say so and skip to
Step 3. Do not invent artificial alternatives.

**Verify key dependencies before committing.** If the chosen approach depends
on a specific external package, library, or service existing (e.g. "use a
ConPTY wrapper for C#", "use a React PDF renderer"), research it now using
the research skill. Confirm that:
- A viable package exists for the target language/platform
- It is actively maintained (not archived or abandoned)
- It does what the approach assumes it does

If research reveals that a key dependency doesn't exist or isn't viable,
surface this to the user before proceeding — the approach itself may need
to change. Do not commit to an approach that depends on a package you
haven't verified.

Wait for the user to choose or direct before continuing.

## Step 3 — Decompose into Vertical Slices

Break the chosen approach into vertical slices. A vertical slice is:
- A unit of work that delivers observable, runnable value on its own
- Spans all layers needed to deliver that value (UI + API + storage)
- Small enough to build and review in one session

**The "layer cake" anti-pattern:** Never split "build the API" and "build
the UI" into separate slices. The first slice of any web app must span all
layers — UI, API, and storage — delivering the core happy path end-to-end.
"Testable with curl" is not observable value for a web app. Similarly,
"set up the database" is not a slice — it's plumbing that belongs inside
the first slice that uses it.

**Self-check before presenting:** For each slice, ask: could a non-technical
stakeholder see or use this independently? If not, merge it with the next
slice until the answer is yes.

For each slice, provide:
- **Name** — short label
- **Observable result** — what the user can see, run, or verify when it's done
- **Depends on** — which prior slices must be complete first (if any)

Present the slices in recommended build order.

**Write the roadmap to file:**
- **New roadmap:** Write to `docs/roadmaps/YYYY-MM-DD-<topic>.md`
- **Extending:** Update the existing roadmap file — append new slices,
  do not modify completed or in-progress slices.

The roadmap should contain:
- **Goal** — one paragraph on what we're building and why
- **Approach** — the chosen approach (one paragraph)
- **Slices** — the full slice list with Name, Observable result, and
  Depends on for each
- **Status** — each slice marked with a standard status marker:
  `[ ]` Not started, `[P]` Planned, `[~]` In progress, `[x]` Complete

After writing the file, tell the user where it is and ask them to review.

**Stop completely.** Do not list implementation steps, do not begin slice
planning, do not start any work. Wait for the user to reply.
Their reply is the gate — nothing else is.

## Step 4 — Refine

The user may:
- Reorder slices
- Split a slice that's too big
- Merge slices that are too small
- Remove slices they don't want yet
- Add slices you missed

Update the file with each revision. Iterate until the user approves
the slice list. Do not rush this step — getting the slices right is
more valuable than starting fast.

## Step 5 — Commit

Once the user approves the roadmap, commit it using git-discipline:
run `git status`, stage the roadmap file by name, and commit with a
message describing what was planned.

## Guidelines

- Stay conversational. This is a dialogue, not a presentation.
- Bias toward fewer, larger slices rather than a long list of tiny ones.
  3-7 slices is typical. If you have more than 10, you're probably slicing
  too thin or the scope is too large for one roadmap.
- Do not include testing as a separate slice. Testing is part of every slice.
- Do not plan beyond what the user has asked for. No "future enhancements"
  or "nice to have" sections.
- **No self-sequencing.** Phrases like "now let me plan the first slice",
  "let's get started on slice 1", or moving directly into slice planning
  are forbidden before the user explicitly approves the roadmap.
- **No self-approval.** Only the user can approve the roadmap. Agreement
  with your own proposal is not approval.
