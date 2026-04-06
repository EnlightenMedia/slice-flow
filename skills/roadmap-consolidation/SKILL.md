---
name: roadmap-consolidation
description: >-
  Consolidates fragmented planning documents into a coherent, up-to-date state.
  TRIGGER when: the user explicitly asks to consolidate roadmaps or sync
  planning documents.
  DO NOT TRIGGER automatically — only run when explicitly directed by the user.
user-invocable: true
argument-hint: "[optional: specific roadmap or area to consolidate]"
---

# Roadmap Consolidation — Sync Planning Documents

This skill reconciles `docs/roadmaps/` and `docs/slices/` when they have
drifted out of sync — slice plans that aren't referenced in any roadmap,
numbering conflicts, or structural gaps. It is structural only: it never
modifies slice content or status markers.

**Only runs when explicitly invoked.** Never triggers automatically.

## Step 1 — Read Everything First

Before making any changes, read every file in both directories:
- Every file in `docs/roadmaps/`
- Every file in `docs/slices/`

Do not make any changes until you have a complete picture of the current state.

## Step 2 — Identify Gaps and Conflicts

With the full picture, identify:

- **Unlinked slice plans** — files in `docs/slices/` not referenced in any
  roadmap. For each, determine which roadmap it belongs to. If the correct
  roadmap is ambiguous, flag it — do not guess.
- **Numbering conflicts** — two or more slices sharing the same number across
  roadmaps or standalone plans. List each conflict explicitly.
- **Broken links** — roadmap entries that reference a slice plan file that
  does not exist.

## Step 3 — Present the Consolidation Plan

Before touching any files, present what you intend to do:

```
Consolidation plan:

Unlinked slice plans to add:
- [slice file] → [roadmap file] (reason)

Numbering conflicts requiring human resolution:
- Slice N appears in [file A] and [file B] — which takes priority?

Broken links to flag:
- [roadmap file] references [missing slice file]

No changes will be made until you confirm.
```

**Stop completely.** Wait for the user to confirm or redirect before
making any changes. Their reply is the gate — nothing else is.

## Step 4 — Make the Approved Changes

Once the user approves, make only the changes they confirmed:
- Add references to roadmaps for unlinked slice plans
- Do not resolve numbering conflicts unilaterally — only the user can decide
- Do not modify the content of any slice plan
- Do not modify the status of any slice

If the scope of changes is large enough to carry risk, offer to proceed
incrementally rather than all at once.

## Step 5 — Present the Summary

After making changes, report:
- What was changed and in which files
- What was left unchanged
- Any open questions still requiring human input (unresolved conflicts,
  ambiguous assignments, broken links with no clear fix)

Suggest a commit for the updated roadmap files.

## Guidelines

- Consolidation is structural only. Content and status are read-only.
- If anything is ambiguous, flag it — never guess or resolve unilaterally.
- **No self-approval.** Present the plan and wait. Do not proceed to
  make changes before the user confirms.
