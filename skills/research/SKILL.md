---
name: research
description: >-
  Verifies technical choices against current documentation before committing.
  TRIGGER when: about to install a package, use a library API, follow setup
  instructions, or make a technical recommendation that depends on external
  tools or services being current. Also use when the user asks "how should I
  do X" and the answer depends on current best practices, library versions,
  or API availability.
  DO NOT TRIGGER when: working with internal project code, well-known
  language features, or decisions that don't depend on external packages.
user-invocable: true
argument-hint: "[package name, technical question, or topic to research]"
---

# Research — Verify Before You Commit

Your training data may be outdated. Package versions change, APIs get
deprecated, installation steps evolve, and best practices shift. This skill
ensures you check current sources before recommending or using external
packages, libraries, APIs, or technical approaches.

The core rule: **do not trust your training data for anything versioned.**
Look it up.

## When This Activates

**Always research when you are about to:**
- Recommend or install a specific package version
- Write code that uses a third-party library's API
- Follow setup or configuration instructions for an external tool
- Suggest a technical approach that depends on how a library or service works
- Answer "how should I do X" when the answer involves external dependencies

**Skip research when:**
- Using standard language features (e.g. Python builtins, JS array methods)
- Working with internal project code you've already read
- The user has already provided the specific version and instructions to use

## How To Research

### Step 1 — Identify what needs verification

Before installing, recommending, or coding against an external dependency,
list what you need to verify:
- Does this package still exist and is it actively maintained?
- What is the current stable version?
- Has the API changed from what you remember?
- Are the installation instructions you'd give actually correct?
- Are there known issues or deprecations?

### Step 2 — Check primary sources

Use web search and web fetch to check these sources, in priority order:

**For packages:**
- **npm registry** (registry.npmjs.org) — current version, install command
- **PyPI** (pypi.org) — current version, install command
- **NuGet** (nuget.org) — current version, install command
- **Package GitHub repo** — README for current usage, releases for versions,
  issues for known problems

**For technical approaches:**
- **Official documentation** — the library or framework's own docs
- **GitHub repo** — README, examples, recent issues/discussions
- **Release notes / changelogs** — what changed in recent versions

Do NOT rely on blog posts, tutorials, or Stack Overflow answers as primary
sources — they go stale. Use them only to discover approaches, then verify
against official docs.

### Step 2b — Fail fast if research is going nowhere

**Do not repeat similar searches hoping for a different result.** Each
search should explore a genuinely different angle — a different package
name, a different ecosystem, a different approach to the problem. If
your searches are returning the same results or you're rephrasing the
same query, you're looping.

Signs you should stop and escalate:

- You've already tried the obvious package names and they don't exist
  or are archived
- Search results keep returning the same unhelpful pages
- You're rephrasing queries rather than exploring new directions
- Multiple candidates exist but none clearly do what's needed
- You've done 5+ searches without a clear answer

When this happens:

1. **Stop searching.** More of the same won't help.
2. **Report what you found and what you didn't.** Be honest: "I searched
   for X, Y, and Z. No viable package exists for this specific need."
3. **Record the finding.** This is important context — any future
   recommendations in this session must account for the gap. Do not
   later recommend the same approach that just failed research.
4. **Offer to revisit the fundamental tech choice.** The problem may not
   be "which package" but "which approach." Say: "This suggests the
   [approach/library/platform] choice may need revisiting. Want me to
   research alternative approaches to [the underlying goal]?"

The goal is to surface dead ends quickly so the user can redirect,
not to exhaust every search permutation before admitting it's not working.

### Step 3 — Report findings

Present what you found concisely:

**For a package verification:**
```
Package: [name]
Current version: [version]
Install: [exact command]
Status: [actively maintained / deprecated / archived]
Notes: [any API changes, breaking changes, or gotchas relevant to our use]
```

**For a technical approach:**
```
Question: [what we needed to know]
Finding: [the answer, with source]
Source: [URL]
Relevance: [how this affects our plan or implementation]
```

If what you found contradicts your training data, say so explicitly —
"My training data suggested X, but the current docs say Y."

### Step 4 — Adjust the plan

If research reveals a problem (deprecated package, breaking API change,
better alternative), present the issue and options before proceeding.
Do not silently swap in an alternative — the user drives technical decisions.

## Integration with Other Skills

- **During slice-planning:** When a technical choice needs verification,
  flag it and research before finalising the plan.
- **During implementation:** If you're about to `npm install` or `pip install`
  something, verify the package and version first.
- **Standalone:** The user can invoke this directly to research a topic
  before making a decision.

## Guidelines

- Speed matters. Check the one or two most authoritative sources, not
  every page on the internet. Registry + GitHub README is usually enough.
- If you cannot verify something (site unreachable, no clear docs), say so.
  "I couldn't verify this" is better than guessing.
- Do not pad your findings with information the user didn't ask about.
  If they asked "what version of Express is current," don't return a full
  Express tutorial.
- When recommending alternatives, limit to 2-3 options with clear tradeoffs.
  Do not present a catalogue.
