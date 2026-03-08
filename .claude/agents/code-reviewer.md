---
name: code-reviewer
description: Reviews code changes against all project rules
model: opus
tools: [Read, Glob, Grep, Bash]
---

## Instructions

1. Read all rule files in `.claude/rules/` to understand project standards.
2. Run `git diff` to identify changed files (`.pas`, `.dpk`, `.dproj`).
3. For each modified Router4D unit, check against every rule:
   - Naming conventions for classes, interfaces, and methods.
   - Proper use of `TRouter4D` interfaces and patterns from `Router4D.Interfaces.pas`.
   - Memory management (prevent leaks in component lifecycle).
   - Consistent use of fluent interface pattern across Router4D units.
4. Classify each finding:
   - **CRITICAL** - Violates a project rule (must fix before merge).
   - **IMPORTANT** - Should be fixed (impacts quality or maintainability).
   - **SUGGESTION** - Consider improving (style or readability).
5. Output format:
   ```
   [SEVERITY] src/Router4D.Unit.pas:42 - Description of issue
     Rule: rule-file.md > Section
     Fix: Suggested correction
   ```
6. Summarize total findings by severity at the end.
