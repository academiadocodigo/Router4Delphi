# CLAUDE.md -- docs/

This file provides guidance to Claude Code when working with documentation in this directory.

## Plan Files

All design and implementation plans live in `plans/`.

| Type | Naming | Purpose |
|------|--------|---------|
| Design doc | `plans/YYYY-MM-DD-<topic>-design.md` | Brainstorming, alternatives analysis, architecture exploration |
| Implementation plan | `plans/YYYY-MM-DD-<topic>-plan.md` | Step-by-step execution with tasks and acceptance criteria |

Always create a design doc first. Only promote to a plan after the approach is validated.

## CHANGELOG

The project CHANGELOG (`CHANGELOG.md` at the repository root) follows the [Keep a Changelog](https://keepachangelog.com) format.

### Sections

Use only these section headers under each version:

- **Added** -- new features or capabilities
- **Changed** -- modifications to existing functionality
- **Deprecated** -- features marked for future removal
- **Removed** -- features that have been deleted
- **Fixed** -- bug fixes

### Rules

1. Update the CHANGELOG **before** committing the related code change.
2. Place new entries under the `[Unreleased]` heading.
3. Each entry format: `- **ComponentName** - brief description (SourceFile.pas)`
4. Do not document changes to CHANGELOG.md, CLAUDE.md, docs/plans/, or .claude/ in the CHANGELOG.

## Documentation Format

All documentation in this directory uses **Markdown**.

### Requirements

- Every new feature or significant change **must** include a documentation update.
- Document public API surfaces: classes, interfaces, methods, and their parameters.
- Include at least one usage example per feature.
- Keep language clear and concise; write in English.
