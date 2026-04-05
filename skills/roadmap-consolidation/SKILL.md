# Roadmap Consolidation

Consolidates fragmented planning documents into a coherent, up-to-date state.

> **Future capability** — this skill is complete and available, but consider it stabilised once the core workflow (brainstorming, slice-planning, checkpoint, research, git-discipline) has been validated in practice.

## When to trigger

**Only when explicitly directed by the user.** Never trigger automatically.

Typical invocation: "consolidate the roadmaps" or "run roadmap consolidation".

## What it produces

- Updated roadmap files with all known slices referenced
- A consolidation summary (conversational) confirming what was merged, what was left unchanged, and any conflicts or ambiguities requiring human resolution

## Behaviors

1. Read every file in `docs/roadmaps/` and `docs/slices/` before making any changes.

2. Identify slice plan files in `docs/slices/` that are not referenced in any roadmap. Add them to the appropriate roadmap. If the correct roadmap is ambiguous, flag it for human decision — do not guess.

3. Check for numbering conflicts (two slices with the same number across roadmaps or standalone plans). Surface them for human resolution — do not resolve them unilaterally.

4. Do not modify the content of any slice plan. Do not modify the status of any slice. Consolidation is structural only.

5. After consolidation, present a summary of all changes made and all open questions requiring human input.

6. If the scope of fragmentation is large enough that consolidation itself carries risk, flag this to the user before making changes and offer to proceed incrementally.

## Guardrails

- Never runs automatically — must be explicitly invoked
- Never discards or overwrites slice content — only adds references and resolves structural gaps
- Never resolves ambiguous roadmap assignments unilaterally — always surfaces to the human
- Never modifies slice status markers
