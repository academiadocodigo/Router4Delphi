---
name: test-creator
description: Creates test projects for Router4D components
model: sonnet
tools: [Read, Write, Edit, Glob, Grep, Bash]
---

## Instructions

1. Read `.claude/rules/testing.md` for testing standards.
2. Analyze the Router4D unit to be tested:
   - Read the unit's interface and implementation sections.
   - Identify public methods, properties, and events.
3. Identify test scenarios:
   - **Happy paths**: Normal usage of routing, rendering, and navigation.
   - **Edge cases**: Empty routes, nil components, duplicate registrations.
   - **Error cases**: Invalid paths, missing renders, circular references.
4. Create a DUnit/DUnitX test project in `tests/`:
   - Follow naming: `Test_<Functionality>_<Scenario>_<Expected>`.
   - Example: `Test_Router_NavigateToRegisteredRoute_RendersComponent`.
5. Ensure each test:
   - Is independent and can run in any order.
   - Has no side effects on other tests.
   - Properly creates and frees all objects (no memory leaks).
   - Uses `Setup`/`TearDown` for shared fixtures.
6. Run tests via command line if a test runner is configured.
