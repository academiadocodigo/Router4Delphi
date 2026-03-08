---
description: Sample project creation rules for new Router4Delphi features
globs: ["src/**"]
---

# Sample Creation Rules

## Requirement
- Every new feature must include a sample project in `Samples/`.

## Directory Structure
- FMX samples: `Samples/FMX/<feature-name>/`
- VCL samples: `Samples/VCL/<feature-name>/`

## File Requirements
- Only create `.pas` and `.dpr` files (not `.dproj`, `.fmx`, `.dfm`).
- Each sample must include:
  - A main `.dpr` project file.
  - Source `.pas` unit(s) demonstrating the feature.
  - A `README.md` explaining what the sample demonstrates and how to run it.

## Minimum Functionality
- Router setup and initialization.
- At least one route registration.
- Navigation demonstration (triggering a route change).
- Visible output confirming the feature works (console output or UI feedback).

## Style
- Keep samples minimal and focused on the feature being demonstrated.
- Follow the same naming conventions as the main project (`TRouter4D*`, `iRouter4D*`).
- Include comments explaining key steps.
