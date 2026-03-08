---
name: changelog-enforcer
description: Ensures CHANGELOG.md is updated before commits
model: sonnet
maxTurns: 5
tools: [Read, Edit, Bash, Grep, Glob]
---

## Instructions

1. Read `.claude/rules/changelog.md` for changelog formatting rules.
2. Run `git diff --cached --name-only` to list staged files.
3. Run `git diff --cached` to understand the nature of each change.
4. Read the current `CHANGELOG.md` in the project root.
5. For each changed Router4D unit (`.pas`, `.dpk`, `.dproj`), verify:
   - The change is documented under `[Unreleased]` in CHANGELOG.md.
   - Entries are categorized: Added, Changed, Fixed, Removed.
6. If entries are missing, add them under the correct category:
   - Use clear descriptions referencing the affected unit (e.g., `Router4D.History.pas`).
   - Follow Keep a Changelog format.
7. Report which entries were added or already present.
