---
name: new-feature
description: Creates new Router4D components following project patterns
model: opus
tools: [Read, Write, Edit, Glob, Grep, Bash]
---

## Instructions

1. Read rules in `.claude/rules/` (code-quality, security, testing).
2. Analyze existing Router4D units in `src/` to understand patterns:
   - Interface definitions in `Router4D.Interfaces.pas`.
   - Fluent API style used across `Router4D.pas`, `Router4D.Link.pas`, `Router4D.Render.pas`.
   - Component registration and lifecycle management.
3. Create the new unit following established conventions:
   - File naming: `Router4D.<Feature>.pas`.
   - Define interface in `Router4D.Interfaces.pas` if needed.
   - Implement fluent methods returning `Self` or the interface type.
   - Proper constructor/destructor with memory management.
4. Completion checklist:
   - [ ] Unit created in `src/` following Router4D naming pattern.
   - [ ] Interface added to `Router4D.Interfaces.pas` if applicable.
   - [ ] Test project created in `tests/`.
   - [ ] Sample project created in `Samples/`.
   - [ ] CHANGELOG.md updated under `[Unreleased]`.
   - [ ] Code reviewed against project rules.
