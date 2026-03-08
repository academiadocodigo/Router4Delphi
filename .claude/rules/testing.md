---
description: Testing standards for Router4Delphi source and test code
globs: ["src/**", "tests/**"]
---

# Testing Rules

## Structure
- All tests live in `tests/`.
- Test project naming: `Test.<Module>.dpr` or `TestRouter4D<Feature>.dpr`.
- Test method naming: `Test_<Functionality>_<Scenario>_<ExpectedResult>`.

## Coverage Requirements
- Every public method must have tests covering:
  - Happy path with valid inputs.
  - Edge cases: `nil`, empty string, zero, boundary values.
  - Error cases: invalid input, missing dependencies.

## Principles
- Tests must be independent; no reliance on execution order.
- Each test sets up its own state and tears it down.
- Use interface-based mocks for external dependencies.
- No memory leaks: pair every `Create` with `Free` in `try/finally`, or use interface reference counting.
- Avoid testing private methods directly; test through the public interface.

## Running
- Compile and run test projects from the `tests/` directory.
- All tests must pass before any commit to `master`.
