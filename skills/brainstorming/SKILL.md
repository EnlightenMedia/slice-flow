# Brainstorming

Converts a high-level idea into a prioritized roadmap of vertical slices.

## When to trigger

Trigger when the user presents a high-level idea, feature request, or goal that needs to be broken down into a plan before any code is written.

Do NOT trigger when:
- The user is asking a simple question or having an exploratory conversation
- The user already has a clear single task and wants to build it
- A slice plan already exists for the current work — follow it, do not re-plan

## What it produces

A roadmap document saved to `docs/roadmaps/YYYY-MM-DD-<topic>.md` containing:
- The goal
- The chosen approach
- An ordered list of vertical slices with observable results, dependencies, and status markers

## Vertical slice definition

A vertical slice cuts through all layers of the stack and delivers observable, end-to-end value. A non-technical stakeholder should be able to see or use the result independently.

What is NOT a vertical slice:
- A layer ("build the API", "build the UI") — this is layer-cake decomposition
- Plumbing ("set up the database", "configure auth middleware") — infrastructure, not value
- Testing ("write tests") — testing is part of every slice, not a separate one
- Something only verifiable by a developer ("testable with curl" is not observable value for a web app)

## Behaviors

1. Before starting, check `docs/roadmaps/` and `docs/slices/` for existing documents. If a roadmap already exists, ask whether to extend it or start a new one.

2. When extending an existing roadmap:
   - Continue slice numbering from the highest existing number across both `docs/roadmaps/` and `docs/slices/`
   - Never modify completed (`[x]`) or in-progress (`[~]`) slices

3. Ask clarifying questions one at a time. Prefer multiple-choice over open-ended. Stop asking once there is enough information to slice meaningfully.

4. If the chosen approach depends on an external package or library, invoke the Research skill to verify it exists and is actively maintained before finalising the roadmap.

5. Enforce vertical slice decomposition. Reject layer-cake breakdowns — do not accept them as slices, explain why, and re-ask.

6. Bias toward fewer, larger slices. 3–7 slices is typical. More than 10 suggests over-slicing or a scope that is too large.

7. Before presenting slices, run a self-check: could a non-technical stakeholder see or use the result of each slice independently? If not, merge slices until the answer is yes.

8. Present the proposed slices and expect the user to reorder, split, merge, remove, or add. Iterate until the user explicitly approves.

9. Once approved, save the roadmap to `docs/roadmaps/YYYY-MM-DD-<topic>.md` and suggest a commit.

## Roadmap document format

```markdown
# <Topic> Roadmap

**Goal:** <one sentence>
**Approach:** <chosen approach and rationale>
**Created:** YYYY-MM-DD

## Slices

- [ ] Slice 1 — <name>: <observable result>
- [ ] Slice 2 — <name>: <observable result>
...
```

## Guardrails

- Do NOT write any code or create implementation files
- Do NOT plan "future enhancements" or "nice to haves" beyond what was asked
- Do NOT number new slices in a way that conflicts with existing slice numbers in either `docs/roadmaps/` or `docs/slices/`
