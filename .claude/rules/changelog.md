---
description: Changelog documentation requirements for Router4Delphi source changes
globs: ["src/**"]
---

# Changelog Rules

## Requirement
- All code changes in `src/` must be documented in `CHANGELOG.md` BEFORE committing.

## Format
- Each entry: `- **BoldName** - brief description (file.pas)`
- Example: `- **HistoryBack** - added backward navigation support (Router4D.History.pas)`

## Sections
Use [Keep a Changelog](https://keepachangelog.com/) sections:
- **Added** - new features or capabilities.
- **Changed** - modifications to existing functionality.
- **Deprecated** - features marked for future removal.
- **Removed** - features that were deleted.
- **Fixed** - bug fixes.

## Exceptions
Do not document changes to:
- `CHANGELOG.md` itself.
- `CLAUDE.md`.
- `docs/plans/` directory.
- `.claude/` directory.
