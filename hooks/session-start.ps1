# Slice Flow — SessionStart hook
# Always injects workflow rules. Also reads docs/roadmaps/ and docs/slices/
# from the project root when they exist.

Write-Output @"
## Slice Flow — Working Rules

You are operating under the Slice Flow workflow. Follow these rules for every session:

- Before writing any code for a new feature or goal, run the Brainstorming skill to produce a roadmap. Do not skip this.
- When the user selects a slice from a roadmap, run the Slice Planning skill to produce a written feature brief saved to docs/slices/. Present it and STOP. Wait for the user to explicitly say they approve before writing any code.
- An inline summary or bullet list is NOT a slice plan. The plan must be a saved file. Self-approval is not allowed — only the user can approve a plan.
- If a slice plan already exists and is approved, follow it exactly — do not re-decompose or re-plan approved work.
- If mid-build reality diverges from the plan, stop and surface it to the human before continuing.
- When a slice is complete: (1) read the done criteria from the slice plan and present them to the user as a verification checklist — what they can open, run, or observe to confirm the slice works. Wait for the user to confirm they are satisfied. (2) Then apply the Git Discipline skill: status -> inspect -> stage by name -> commit. Never use git add -A or git add .
- Update status in both the slice plan and the roadmap when a slice changes state, then commit those updates too.
- Before using any versioned third-party API (Electron, React, Express, any framework or library), run the research skill. Training data familiarity is not verification — check what the current version actually exposes.
- Status markers: [ ] Not started | [P] Planned | [~] In progress | [x] Complete
- docs/roadmaps/ and docs/slices/ live at the repository root.
"@

if (-not (Test-Path "docs/roadmaps") -and -not (Test-Path "docs/slices")) {
    Write-Output "No planning documents found — this appears to be a new project. Start with the Brainstorming skill before writing any code."
    exit 0
}

Write-Output "## Slice Flow — Project State"
Write-Output ""

if (Test-Path "docs/roadmaps") {
    foreach ($f in Get-ChildItem "docs/roadmaps/*.md" -ErrorAction SilentlyContinue) {
        $relPath = "docs/roadmaps/$($f.Name)"
        Write-Output "### $relPath"
        Get-Content $f.FullName -Raw
        Write-Output ""
        Write-Output "---"
        Write-Output ""
    }
}

if (Test-Path "docs/slices") {
    foreach ($f in Get-ChildItem "docs/slices/*.md" -ErrorAction SilentlyContinue) {
        $relPath = "docs/slices/$($f.Name)"
        Write-Output "### $relPath"
        Get-Content $f.FullName -Raw
        Write-Output ""
        Write-Output "---"
        Write-Output ""
    }
}
