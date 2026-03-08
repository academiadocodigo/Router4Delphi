---
description: Security and resource safety rules for all Router4Delphi code
globs: ["**"]
---

# Security Rules

## Resource Management
- Every resource that is opened or created must have a corresponding `try/finally` block ensuring cleanup.
- Pair `Create` with `Free`, `Open` with `Close`, `Lock` with `Unlock`.
- Prefer interface references for automatic reference-counted lifetime management.

## Exception Handling
- Never swallow exceptions silently (`except end` is forbidden).
- Always re-raise after cleanup, or log with sufficient context (unit name, method, parameters).
- Use specific exception types rather than catching bare `Exception`.

## Credentials and Secrets
- Never hardcode credentials, tokens, API keys, or passwords in source code.
- Store sensitive configuration externally (environment variables, config files excluded from VCS).

## Data Safety
- Use parameterized queries for any SQL interaction; never concatenate user input into SQL strings.
- Validate and sanitize all external input before processing.

## Interface Reference Counting
- Be aware that Delphi interfaces are reference-counted; prevent premature release by holding a reference in a variable.
- Avoid mixing object and interface references to the same instance to prevent double-free.
