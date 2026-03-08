---
name: changelog-format
description: CHANGELOG format reference
---

# CHANGELOG Format

Use the following template when updating `CHANGELOG.md`:

```
# Changelog

## [Unreleased]

### Added
- **FeatureName** - description (file.pas)

### Changed
- **ModifiedName** - what changed (file.pas)

### Fixed
- **BugName** - what was fixed (file.pas)

## [1.0.0] - 2024-01-15

### Added
- **InitialRelease** - description (file.pas)
```

## Rules

- Group entries under `Added`, `Changed`, or `Fixed`.
- Bold the feature/item name.
- Include the affected file in parentheses.
- New entries go under `[Unreleased]` until a release is tagged.
- When releasing, rename `[Unreleased]` to `[X.Y.Z] - YYYY-MM-DD` and add a new empty `[Unreleased]` section above it.
