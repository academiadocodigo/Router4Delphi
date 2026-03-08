---
description: Code quality and naming conventions for Router4Delphi source
globs: ["src/**"]
---

# Code Quality Rules

## Naming Conventions
- Classes: `TRouter4D<Name>` (e.g., `TRouter4DHistory`).
- Interfaces: `iRouter4D<Name>` (e.g., `iRouter4DHistory`).
- Parameters: `a` prefix (e.g., `aPrefix`, `aFormClass`).
- Fields: `F` prefix (e.g., `FPrefix`, `FHistory`).
- Constants: `ALL_CAPS` with underscores (e.g., `DEFAULT_ROUTE`).

## Uses Clause Order
1. System units (`System.SysUtils`, `System.Classes`).
2. Framework units (`FMX.*`, `VCL.*`).
3. Project units (`Router4D.*`).

## Design Patterns
- Prefer interface-based design with reference counting for lifetime management.
- Return `Self` (as interface) from methods to support fluent/chaining API.
- New functionality must implement an interface before the concrete class.

## Error Handling
- Use `try/finally` for all resource management.
- Re-raise exceptions after cleanup; never silently swallow them.

## Prohibited
- Silent exception swallowing (`except end`).
- Hardcoded magic numbers; use named constants.
- Direct `TForm.Create` outside the routing mechanism.
- Bypassing interface contracts with concrete class casts.
