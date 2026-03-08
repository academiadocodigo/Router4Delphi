---
name: memory-safety
description: Delphi memory and resource management patterns
---

# Memory and Resource Management

## Interface Reference Counting

`TInterfacedObject` provides automatic reference counting. When the last interface reference goes out of scope, the object is freed automatically. Always assign to interface-typed variables to activate reference counting.

## Object Ownership

If you call `Create`, you must call `Free` (unless the object is managed via interfaces). No exceptions.

## try/finally Pattern

All resource allocations must be wrapped in `try/finally`:

```pascal
LStream := TFileStream.Create(APath, fmOpenRead);
try
  // use LStream
finally
  LStream.Free;
end;
```

## Cache Management

Router4D uses `MAX_FRAME_COUNT = 25` to limit the number of cached frames. When the cache exceeds this limit, the oldest entries are removed to prevent unbounded memory growth.

## Common Pitfalls

- **Mixing interface and object references**: Holding both an interface reference and an object reference to the same `TInterfacedObject` instance causes premature or double frees. Pick one.
- **Forgetting to nil references**: After freeing an object, set the variable to `nil` to avoid dangling pointer access.
- **Circular interface references**: Two objects holding interface references to each other will never be freed. Break cycles by using weak references or explicit cleanup.

## FreeAndNil in Destructors

Use `FreeAndNil` for owned objects in destructors to safely release and nil fields:

```pascal
destructor TRouter4DHistory.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;
```
