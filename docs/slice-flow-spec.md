# Slice Flow

**A Claude Code plugin that enforces iterative, human-gated, slice-based development.**

Slice Flow prevents the common failure mode of AI-assisted development: rushing into code without a plan, building too much at once, and losing human oversight. It introduces vertical slices as the unit of work, requires planning before implementation, and gates transitions between work units with human approval.

---

## Problem

When working with AI coding assistants, it's easy to:

- Start coding before understanding the full scope
- Build monolithic features instead of delivering incremental value
- Commit to external dependencies without verifying they exist or are maintained
- Lose track of what's been planned, what's in progress, and what's done
- Accidentally commit secrets, build artifacts, or sensitive files
- Let the AI silently continue past natural review points

Slice Flow addresses all of these by embedding planning discipline, research verification, human checkpoints, and git hygiene directly into the development workflow.

---

## Core Concepts

### Vertical Slices

The fundamental unit of work is a vertical slice — a piece of functionality that cuts through all layers of the stack and delivers observable, end-to-end value. A non-technical stakeholder should be able to see or use the result of each slice independently.

What is NOT a vertical slice:

- A layer ("build the API", "build the UI") — this is "layer cake" decomposition
- Plumbing ("set up the database", "configure auth middleware") — this is infrastructure, not value
- Testing ("write tests") — testing is part of every slice, not a separate one
- Something only verifiable by a developer ("testable with curl" is not observable value for a web app)

### Human Gates

Humans approve every transition: which slice to work on, when a slice is done, and whether to proceed to the next. The AI never silently continues past a gate. This keeps the human in control of sequencing, scope, and quality.

### Planning Before Code

No code is written until planning is complete and approved. Planning produces documents (roadmaps and feature briefs), not code. The implementer decides file structures, class interfaces, and directory layouts during the build phase — not during planning.

### Research Before Committing

External dependencies (packages, libraries, APIs, services) are verified against current primary sources before being incorporated into plans. Training data is not trusted for anything versioned.

---

## Capabilities

### Skill: Brainstorming

Converts a high-level idea into a prioritized roadmap of vertical slices.

**What it produces:** A roadmap document in `docs/roadmaps/YYYY-MM-DD-<topic>.md` containing the goal, chosen approach, and an ordered list of slices with observable results, dependencies, and status.

**Behaviors:**

- Checks for existing roadmaps and slice plans before starting. If a roadmap already exists, asks whether to extend it or start a new one.
- When extending, continues slice numbering from the highest existing number. Never modifies completed or in-progress slices.
- New slice numbers must not conflict with numbers in either `docs/roadmaps/` or `docs/slices/` — standalone slice plans occupy numbers even if they aren't referenced in a roadmap.
- Enforces vertical slice decomposition. Rejects layer cake breakdowns.
- Biases toward fewer, larger slices (3-7 is typical). More than 10 suggests over-slicing or scope that's too large.
- If the chosen approach depends on an external package or library, invokes research to verify it exists and is actively maintained before finalizing.
- Asks one clarifying question at a time, prefers multiple-choice over open-ended, and stops asking once there's enough information to slice meaningfully.
- Runs a self-check before presenting slices: could a non-technical stakeholder see or use each slice independently? If not, merges until the answer is yes.
- After presenting, expects the user to reorder, split, merge, remove, or add slices. Iterates until the user approves.

**Guardrails:**

- Does NOT write any code or create implementation files.
- Does NOT plan "future enhancements" or "nice to haves" beyond what was asked.
- Does NOT trigger on simple questions, exploratory conversations, or when the user already has a clear single task.

---

### Skill: Slice Planning

Produces a feature brief for a single approved slice from a roadmap.

**What it produces:** A feature brief in `docs/slices/YYYY-MM-DD-slice-N-<slice-name>.md` containing the slice name, objective, key decisions, numbered tasks, done criteria, and status.

**Behaviors:**

- Loads the relevant roadmap and checks the status of prior slices to understand the starting point and dependencies.
- Explores the codebase to understand what's already built, what conventions the project follows, and what dependencies are installed — to inform tasks, not to prescribe implementation.
- Tasks describe what to build, not how. Done criteria describe what the user can verify, not what the code looks like internally.
- Keeps the brief to one screen. If a slice needs more than 3-7 tasks, flags that it should probably be split into smaller slices.
- Flags any architecture or library decisions that need research verification.
- After the user approves, updates the roadmap to mark the slice as `[P] Planned` with a link to the slice plan.
- Plans one slice at a time — does not plan the next until the current one is done.

**Guardrails:**

- Does NOT prescribe file structures, class interfaces, code snippets, file paths, or directory structures. The implementer decides.
- Does NOT include startup sequences or data flow diagrams — these are too prescriptive.
- Does NOT trigger when the user is still brainstorming, asking questions, or already has a plan and wants to build.

---

### Skill: Checkpoint

Gates multi-unit work by decomposing it into slices, presenting them for approval, building one at a time, and pausing between slices for human verification.

**What it produces:** Conversational output (not file-based). The gating is behavioral — pausing and waiting for explicit approval.

**Behaviors:**

- Presents slices with observable/verifiable results and waits for explicit user approval before starting any work.
- After completing a slice: reports what was built, explains how to verify it, presents what the next slice will be, and waits. Does not silently continue.
- Within a slice, uses normal Claude flow — does not add extra gates on top of Claude's native behavior.
- If mid-slice the scope grows beyond one logical unit, stops and re-decomposes.

**Guardrails:**

- Never combines slices to "save time." Never skips the pause between slices.
- Exception: if the user explicitly says "just do them all" or "skip pauses" for a specific task, honors it for that task only. Does not carry the exception forward.
- Only triggers when work contains multiple logical units that could each be built, run, and verified independently. Single-unit work (even if it spans many files) uses normal Claude flow — a single bug fix, a single refactor, or a single skill file are all one unit regardless of file count.
- Does not trigger when the user is asking questions, researching, or running commands.
- **Does not trigger when an approved slice plan exists for the current task.** The slice plan defines the boundary and is the unit of work — overlap prevention is already handled by the plan. Build fidelity is enforced by the Session Start hook.

---

### Skill: Research

Verifies technical choices against current documentation before committing to them.

**Core rule:** Do not trust training data for anything versioned. Look it up.

**What it produces:** Structured findings (package name, current version, install command, maintenance status, notes — or question, finding, source, relevance).

**Behaviors:**

- Checks primary sources in priority order: package registries (npm, PyPI, NuGet), GitHub repos (README, releases, issues), official documentation.
- Does NOT rely on blog posts, tutorials, or Stack Overflow as primary sources — they go stale. Uses them only to discover, then verifies against official docs.
- If findings contradict training data, states it explicitly: "My training data suggested X, but current docs say Y."
- Presents issues and options to the user. Does NOT silently swap in alternatives — the user drives technical decisions.

**Fail-fast behavior (critical):**

- Does not repeat similar searches hoping for different results. Each search explores a genuinely different angle.
- Signs to stop: obvious package names don't exist or are archived, search results keep returning the same unhelpful pages, rephrasing queries rather than exploring new directions, multiple candidates but none clearly fit, 5+ searches without a clear answer.
- When this happens: stops searching, reports honestly what was found and what wasn't, records the finding, and offers to revisit the fundamental tech choice.

**Guardrails:**

- Speed matters: 1-2 authoritative sources (registry + GitHub README) are usually enough.
- If something can't be verified, says so — "I couldn't verify this" beats guessing.
- Does not pad findings with unasked-for information. Limits alternative recommendations to 2-3 with clear tradeoffs.
- Triggers when about to install a package, use a third-party API, follow external setup instructions, or recommend an approach involving external dependencies.
- Skips research for standard language features (Python builtins, JS array methods) or internal project code already read.

---

### Skill: Git Discipline

Ensures safe commit hygiene by validating what's being committed before it's committed.

**What it produces:** Validation and verification — no new files.

**Behaviors:**

- Before the first commit in a project, checks for a `.gitignore` file. If one doesn't exist, creates one appropriate for the tech stack before anything is committed.
- Before staging anything, runs `git status` to produce an explicit manifest of changed and untracked files. Inspects each file on the manifest individually before staging.
- Applies sensitive-file checks per file: `.env` files, credentials, API keys, secrets, build output (`node_modules/`, `bin/`, `obj/`), IDE-specific files (`.vs/`, `.idea/` unless already tracked), large binary files, database files, OS files (`.DS_Store`, `Thumbs.db`).
- The following file patterns always require explicit human confirmation before staging, without exception: `.env*`, `*.pem`, `*.key`, `*secret*`, `*credential*`, `*.p12`, `*.pfx`.
- Stages specific files by name from the verified manifest. Never uses `git add -A` or `git add .`.
- If the project's `.gitignore` is missing entries for the current tech stack, updates it.
- If sensitive-looking files are noticed in the working tree (even if gitignored), mentions them to the user as a heads-up.

The commit flow is always: **status → inspect → stage by name → commit.**

**Guardrails:**

- If there is any doubt about whether something contains sensitive data, asks the user before staging. The cost of asking is low; the cost of committing a secret is high.
- The file patterns listed above bypass doubt entirely — they always require explicit human confirmation regardless of context.
- Triggers on every commit attempt — non-negotiable.

---

### Hook: Session Start

Runs automatically when a session begins. Injects context about the slice-based workflow.

Both `docs/roadmaps/` and `docs/slices/` live at the repository root, not nested under any individual project or package. This ensures planning documents are shared across all projects in the workspace.

- Reminds to check `docs/roadmaps/` for all existing roadmap files and read every roadmap to understand the full plan, which slices are done, and the current state. Multiple roadmaps may exist covering different phases.
- Reminds to check `docs/slices/` for all existing slice plans. If one exists for the current task, follow it — do not re-decompose or re-plan approved work.
- Establishes that a single approved slice is a single unit of work. Build it using normal flow. Do not break it into sub-slices.
- **When building from an approved slice plan, the numbered tasks are the build checklist. Work through them in order. Do not add, remove, or reinterpret tasks unilaterally. If reality requires a deviation, surface it to the human before proceeding — this is a plan failure, not an invitation to improvise.**
- Reminds to update status in both the slice plan and the roadmap when a slice is complete.
- Establishes the standard status markers used across all documents.

---

### Hook: Post-Tool Use (after Write/Edit)

Runs automatically after any file creation or modification. Encourages "commit early, commit often" discipline.

Trigger heuristic splits by file type:

- **Planning artifacts** (files under `docs/roadmaps/` or `docs/slices/`): always suggest a commit. Writing a roadmap or slice plan is always a meaningful unit of work.
- **Code files**: only suggest a commit when the surrounding context indicates task completion (e.g., a test just passed, the AI indicated it finished a task). Do not suggest after every individual file edit.

The suggestion is a non-blocking nudge — the user can ignore it without friction. Discourages batching commits.

---

## Future Capabilities

### Skill: Roadmap Consolidation

Consolidates fragmented planning documents into a coherent, up-to-date state. **Only runs when explicitly directed by the user — never triggers automatically.**

**What it produces:** Updated roadmap files with all known slices referenced, and a consolidation summary confirming what was merged, what was left unchanged, and any conflicts or ambiguities that require human resolution.

**Behaviors:**

- Reads every file in `docs/roadmaps/` and `docs/slices/` before making any changes.
- Identifies slice plan files that exist in `docs/slices/` but are not referenced in any roadmap, and adds them to the appropriate roadmap. If the correct roadmap is ambiguous, flags it for human decision rather than guessing.
- Checks for numbering conflicts (two slices with the same number across roadmaps or standalone plans) and surfaces them for human resolution.
- Does not modify the content of any slice plan, and does not modify the status of any slice. Consolidation is structural only.
- After consolidation, presents a summary of all changes made and all open questions requiring human input.

**Guardrails:**

- Never runs automatically. Must be explicitly invoked.
- Never discards or overwrites slice content — only adds references and resolves structural gaps.
- If the scope of fragmentation is large enough that consolidation itself carries risk, flags this to the user before making changes and offers to proceed incrementally.

---

## Packaging

Slice Flow is distributed as a Claude Code plugin — a set of files installed into the user's Claude Code environment:

| Deliverable | Type | Purpose |
|---|---|---|
| One file per skill | Skill file | Brainstorming, Slice Planning, Checkpoint, Research, Git Discipline, Roadmap Consolidation |
| Session Start | Hook file | Injects roadmap/slice context at the start of every session |
| Post-Tool Use | Hook file | Fires after Write/Edit to encourage timely commits |

No CLAUDE.md modifications, no wrapper scripts, no external services. The plugin works by the skills and hooks being present in the Claude Code environment.

---

## Design Principles

### One Artifact Per Skill

Each skill produces exactly one type of artifact:

| Skill | Artifact |
|-------|----------|
| Brainstorming | Roadmap document |
| Slice Planning | Feature brief document |
| Checkpoint | Conversational gates (no file) |
| Research | Finding report (conversational) |
| Git Discipline | Validation (no new files) |
| Roadmap Consolidation | Updated roadmap files + consolidation summary |

Implementation (actual code) happens only when all planning is approved and the build phase begins.

### Skills Know When NOT to Trigger

Not every conversation needs the full workflow. Skills explicitly define when they should not activate:

- Simple questions get direct answers — no roadmap needed.
- Single-unit tasks use normal Claude flow — no checkpoint gating.
- An approved slice plan suppresses Checkpoint — the plan defines the boundary.
- Internal code and language builtins don't need research verification.
- An approved plan should be followed, not re-planned.
- Roadmap Consolidation never runs unless explicitly directed.

### Status Consistency

All documents use the same status markers:

- `[ ]` Not started
- `[P]` Planned (slice plan exists)
- `[~]` In progress
- `[x]` Complete

Status must be updated in both the slice plan and the roadmap when a slice's status changes. This creates a single coherent view of project progress.

### The No Re-Planning Rule

Once a slice plan is approved, it is binding for the build phase. The session start hook explicitly enforces this: "If a slice plan exists for the current task, follow it — do not re-decompose or re-plan approved work." If mid-build the scope genuinely changes, the checkpoint skill allows re-decomposition — but approved plans are not casually discarded.

### The Plan Failure Escape Hatch

Mid-build discoveries sometimes reveal that an earlier planning assumption was wrong — not scope creep, but a fundamental error: a dependency doesn't work as expected, an API doesn't expose what the plan assumed, or new information contradicts a key decision.

In these cases:

- Stop immediately. Do not attempt to work around the problem silently.
- Surface the finding to the human explicitly: what was assumed, what was discovered, and why the plan cannot proceed as written.
- Wait for human direction before continuing. The human may choose to revise the slice plan, abandon the slice, or accept a revised approach.

This is distinct from scope growth (handled by Checkpoint re-decomposition) and from casual re-planning (which is forbidden). A plan failure is an honest signal that reality has diverged from the plan — it requires human judgment, not AI improvisation.

### Workflow Sequence

The intended flow through a full feature lifecycle:

1. **Brainstorming** produces a roadmap → commit
2. **Slice Planning** produces a feature brief for slice 1 → commit
3. **Checkpoint** decomposes the slice work if no slice plan exists and work is multi-unit; defers to the slice plan if one exists
4. **Build** using normal Claude flow, treating slice plan tasks as the build checklist
5. **Git Discipline** validates before each commit
6. **Post-Tool hook** reminds to commit after meaningful changes
7. Update status in slice plan and roadmap → commit
8. Return to step 2 for the next slice
9. **Roadmap Consolidation** run on demand when planning documents have drifted out of sync

### Commit Frequency and Gating Are Complementary

The post-tool hook encourages committing after each meaningful piece of work within a slice (writing a component, passing a test). The checkpoint skill gates between slices to ensure human approval before moving to the next. These are not contradictory — commit often within a slice, but pause between slices.
