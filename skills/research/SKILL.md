# Research

Verifies technical choices against current documentation before committing to them.

**Core rule:** Do not trust training data for anything versioned. Look it up.

## When to trigger

Trigger when about to:
- Install or recommend a third-party package or library
- Use a third-party API or external service
- Follow external setup instructions
- Commit to an approach that depends on an external dependency

Do NOT trigger for:
- Standard language features (Python builtins, JS array methods, standard library)
- Internal project code already read in this session
- Well-established tooling with no versioned surface (e.g. git, bash)

## What it produces

Structured findings reported conversationally:

**For packages/libraries:**
- Package name
- Current version
- Install command
- Maintenance status (active / archived / unmaintained)
- Any relevant notes

**For general technical questions:**
- Question
- Finding
- Source
- Relevance to the current decision

## Behaviors

1. Check primary sources in priority order:
   - Package registries (npm, PyPI, NuGet, crates.io, etc.)
   - GitHub repository (README, releases, recent issues)
   - Official documentation

2. Do NOT rely on blog posts, tutorials, or Stack Overflow as primary sources — they go stale. Use them only to discover, then verify against official docs.

3. If findings contradict training data, state it explicitly: "My training data suggested X, but current docs say Y."

4. Present findings and any issues to the user. Do NOT silently swap in alternatives — the user drives technical decisions.

5. Limit alternative recommendations to 2–3 with clear trade-offs.

## Fail-fast behavior

Stop searching when any of these signs appear:
- Obvious package names do not exist or are archived
- Search results keep returning the same unhelpful pages
- Queries are being rephrased rather than exploring genuinely new angles
- Multiple candidates exist but none clearly fit
- 5 or more searches without a clear answer

When stopping: report honestly what was found and what was not. State "I couldn't verify this" rather than guessing. Offer to revisit the fundamental technical choice.

Do NOT repeat similar searches hoping for different results. Each search must explore a genuinely different angle.

## Guardrails

- 1–2 authoritative sources (registry + GitHub README) are usually enough — do not over-research
- "I couldn't verify this" beats guessing
- Do not pad findings with unrequested information
