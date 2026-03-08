---
description: Documentation requirements for new Router4Delphi features
globs: ["src/**"]
---

# Documentation Rules

## Requirements
- Every new feature or public API change must update the relevant documentation.
- Documentation lives in `docs/` and `README.md`.

## Content Standards
- Include a **usage example** section showing practical Delphi code.
- Provide an **API reference** listing method signatures, parameters (`aParamName: Type`), and return types.
- Describe expected behavior, edge cases, and error conditions.

## README Updates
- Update `README.md` when a feature changes the public API surface.
- Keep the feature list and usage examples in sync with the current codebase.

## Style
- Write in clear, concise English.
- Use Delphi code blocks for examples (` ```delphi `).
- Document interface methods, not just class methods.
