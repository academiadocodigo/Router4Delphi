# Security & Performance Fixes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix all critical, high, and medium severity security and performance issues identified in the Router4Delphi codebase analysis.

**Architecture:** Fixes are applied directly to existing units in `src/`. No new units are created. Changes preserve the existing API surface — all fixes are internal. Each task targets one file to minimize merge conflicts.

**Tech Stack:** Delphi/Object Pascal, FMX/VCL conditional compilation via `{$DEFINE HAS_FMX}`

---

### Task 1: Router4D.History — Bounds checking and Result initialization (CRITICAL)

**Files:**
- Modify: `src/Router4D.History.pas:122-135` (GetHistoryContainer, GetRouter, PreviousRouter)
- Modify: `src/Router4D.History.pas:168-171` (VCL GetHistoryContainer)

**Context:** `GetHistoryContainer` returns uninitialized `Result` when key not found. `GetRouter` and `PreviousRouter` access `FListCacheOrder` without bounds checking, causing Access Violation if `FIndexCache` is out of range.

**Step 1: Fix FMX `GetHistoryContainer` — initialize Result before TryGetValue**

Change `src/Router4D.History.pas` line 122-125 from:
```pascal
function TRouter4DHistory.GetHistoryContainer(aKey: String): TFMXObject;
begin
  FListCacheContainer.TryGetValue(aKey, Result);
end;
```
To:
```pascal
function TRouter4DHistory.GetHistoryContainer(aKey: String): TFMXObject;
begin
  Result := nil;
  if not FListCacheContainer.TryGetValue(aKey, Result) then
    raise Exception.CreateFmt('Container not found: %s', [aKey]);
end;
```

**Step 2: Fix VCL `GetHistoryContainer` — same pattern**

Change `src/Router4D.History.pas` line 168-171 from:
```pascal
function TRouter4DHistory.GetHistoryContainer(aKey: String): TPanel;
begin
  FListCacheContainer.TryGetValue(aKey, Result);
end;
```
To:
```pascal
function TRouter4DHistory.GetHistoryContainer(aKey: String): TPanel;
begin
  Result := nil;
  if not FListCacheContainer.TryGetValue(aKey, Result) then
    raise Exception.CreateFmt('Container not found: %s', [aKey]);
end;
```

**Step 3: Fix `GetRouter` — add bounds check**

Change `src/Router4D.History.pas` line 132-135 from:
```pascal
function TRouter4DHistory.GetRouter: String;
begin
  Result := Self.FListCacheOrder[Self.FIndexCache];
end;
```
To:
```pascal
function TRouter4DHistory.GetRouter: String;
begin
  if (FIndexCache < 0) or (FIndexCache >= FListCacheOrder.Count) then
    raise Exception.Create('No active route in history');
  Result := Self.FListCacheOrder[Self.FIndexCache];
end;
```

**Step 4: Fix `PreviousRouter` — add bounds check**

Change `src/Router4D.History.pas` line 127-130 from:
```pascal
function TRouter4DHistory.PreviousRouter: String;
begin
  Result := Self.FListCacheOrder[Self.FIndexCache - 1];
end;
```
To:
```pascal
function TRouter4DHistory.PreviousRouter: String;
begin
  if (FIndexCache <= 0) or (FIndexCache > FListCacheOrder.Count) then
    raise Exception.Create('No previous route in history');
  Result := Self.FListCacheOrder[Self.FIndexCache - 1];
end;
```

**Step 5: Fix `BreadCrumb` — add bounds check before array access**

Change `src/Router4D.History.pas` line 189 from:
```pascal
 Result := Self.FListCacheOrder[Self.FIndexCache];
```
To:
```pascal
 if (FIndexCache < 0) or (FIndexCache >= FListCacheOrder.Count) then
   Exit;
 Result := Self.FListCacheOrder[Self.FIndexCache];
```

**Step 6: Fix `GoBack` — add bounds check**

Change `src/Router4D.History.pas` line 197-203 from:
```pascal
function TRouter4DHistory.GoBack: String;
begin
  if Self.FIndexCache > 0 then
    Dec(Self.FIndexCache);

 Result := Self.FListCacheOrder[Self.FIndexCache];
end;
```
To:
```pascal
function TRouter4DHistory.GoBack: String;
begin
  if Self.FIndexCache > 0 then
    Dec(Self.FIndexCache);

  if (FIndexCache < 0) or (FIndexCache >= FListCacheOrder.Count) then
    raise Exception.Create('No route in history to go back to');
  Result := Self.FListCacheOrder[Self.FIndexCache];
end;
```

**Step 7: Commit**

```bash
git add src/Router4D.History.pas
git commit -m "fix: add bounds checking and Result initialization in History

Prevents Access Violations from uninitialized Result in
GetHistoryContainer and out-of-bounds access in GetRouter,
PreviousRouter, GoBack, and BreadCrumb."
```

---

### Task 2: Router4D.History — Fix silent exception swallowing and cache eviction

**Files:**
- Modify: `src/Router4D.History.pas:205-226` (AddHistory with TObject overload)

**Context:** `try GlobalEventBus.RegisterSubscriber(aObject); except end;` silently hides registration failures. Cache eviction creates an iterator over all keys just to remove one item, and only removes one even when count exceeds limit by more.

**Step 1: Replace silent except with meaningful error handling**

Change `src/Router4D.History.pas` line 213 from:
```pascal
  try GlobalEventBus.RegisterSubscriber(aObject); except end;
```
To:
```pascal
  try
    GlobalEventBus.RegisterSubscriber(aObject);
  except
    on E: Exception do
    begin
      // Subscriber registration is optional — log but don't block navigation
      {$IFDEF DEBUG}
      System.SysUtils.OutputDebugString(PChar(
        'Router4D: Failed to register subscriber ' + aObject.ClassName + ': ' + E.Message));
      {$ENDIF}
    end;
  end;
```

**Step 2: Fix cache eviction — replace key iterator with direct removal**

Change `src/Router4D.History.pas` lines 215-220 from:
```pascal
  if FListCache.Count > MAX_FRAME_COUNT then
    for mKey in FListCache.Keys do
    begin
      FListCache.Remove(mKey);
      Break;
    end;
```
To:
```pascal
  while FListCache.Count > MAX_FRAME_COUNT do
  begin
    if FListCacheOrder.Count > 0 then
    begin
      FListCache.Remove(FListCacheOrder[0]);
      FListCacheOrder.Delete(0);
    end
    else
      Break;
  end;
```

**Step 3: Remove unused `mKey` variable declaration**

Remove `mKey : String;` from line 207 (no longer needed after the eviction fix).

**Step 4: Commit**

```bash
git add src/Router4D.History.pas
git commit -m "fix: replace silent exception and fix cache eviction in History

- RegisterSubscriber failures now log to debug output instead of
  being silently swallowed
- Cache eviction uses FListCacheOrder for FIFO removal instead of
  iterating all keys, and loops until under the limit"
```

---

### Task 3: Router4D.History — Synchronize cache state between FListCache and FListCacheOrder

**Files:**
- Modify: `src/Router4D.History.pas:243-256` (addCacheHistory)

**Context:** `FListCacheOrder` can grow indefinitely because its trimming logic (`FMaxCacheHistory`) is separate from `FListCache`'s `MAX_FRAME_COUNT`. The eviction fix in Task 2 now ties them together, so `addCacheHistory` should use the same constant.

**Step 1: Align FMaxCacheHistory with MAX_FRAME_COUNT**

Change `src/Router4D.History.pas` line 278 in the constructor from:
```pascal
  FMaxCacheHistory := 10;
```
To:
```pascal
  FMaxCacheHistory := MAX_FRAME_COUNT;
```

**Step 2: Commit**

```bash
git add src/Router4D.History.pas
git commit -m "fix: align FMaxCacheHistory with MAX_FRAME_COUNT

Prevents inconsistent state where FListCacheOrder has a different
size limit than FListCache."
```

---

### Task 4: Router4D.Utils — Fix silent exception swallowing

**Files:**
- Modify: `src/Router4D.Utils.pas:53-57`

**Context:** Same silent `except end` pattern as History. Registration failure is silently ignored.

**Step 1: Add debug logging to the except block**

Change `src/Router4D.Utils.pas` lines 53-57 from:
```pascal
      try
        GlobalEventBus.RegisterSubscriber(AValue.AsType<TObject>);
      except

      end;
```
To:
```pascal
      try
        GlobalEventBus.RegisterSubscriber(AValue.AsType<TObject>);
      except
        on E: Exception do
        begin
          {$IFDEF DEBUG}
          System.SysUtils.OutputDebugString(PChar(
            'Router4D: Failed to register subscriber: ' + E.Message));
          {$ENDIF}
        end;
      end;
```

**Step 2: Commit**

```bash
git add src/Router4D.Utils.pas
git commit -m "fix: replace silent exception in Utils.CreateInstance

RegisterSubscriber failures now log to debug output instead of
being silently swallowed."
```

---

### Task 5: Router4D.Link — Add nil checks before container access

**Files:**
- Modify: `src/Router4D.Link.pas:131-159` (&To with aNameContainer overload)

**Context:** `GetHistoryContainer` can return nil (before Task 1 fix) or raise (after Task 1 fix). But `InstanteObject` can also be nil if no previous navigation occurred. Multiple overloads call `Router4DHistory.InstanteObject.UnRender` without checking if `InstanteObject` is assigned.

**Step 1: Add nil check for InstanteObject in the named container overload**

Change `src/Router4D.Link.pas` lines 139-141 from:
```pascal
  Result := Self;
  Router4DHistory.InstanteObject.UnRender;
  aContainer := Router4DHistory.GetHistoryContainer(aNameContainer);
```
To:
```pascal
  Result := Self;
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
  aContainer := Router4DHistory.GetHistoryContainer(aNameContainer);
```

**Step 2: Add nil check for InstanteObject in &To(aPatch) overload**

Change `src/Router4D.Link.pas` line 222 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 3: Add nil check for InstanteObject in &To(aPatch, aProps, aKey) overload**

Change `src/Router4D.Link.pas` line 245 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 4: Add nil check for InstanteObject in GoBack**

Change `src/Router4D.Link.pas` line 180 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 5: Add nil check for InstanteObject in IndexLink**

Change `src/Router4D.Link.pas` line 200 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 6: Add nil checks in FMX overloads (&To with TFMXObject)**

Change `src/Router4D.Link.pas` line 68 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

Change `src/Router4D.Link.pas` line 82 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 7: Add nil checks in VCL overloads (&To with TPanel)**

Change `src/Router4D.Link.pas` line 104 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

Change `src/Router4D.Link.pas` line 118 from:
```pascal
  Router4DHistory.InstanteObject.UnRender;
```
To:
```pascal
  if Assigned(Router4DHistory.InstanteObject) then
    Router4DHistory.InstanteObject.UnRender;
```

**Step 8: Commit**

```bash
git add src/Router4D.Link.pas
git commit -m "fix: add nil checks for InstanteObject before UnRender calls

Prevents Access Violation when navigating before any route has been
rendered (InstanteObject is nil on first navigation)."
```

---

### Task 6: Router4D.Sidebar — Fix ItemIndex -1 crash

**Files:**
- Modify: `src/Router4D.Sidebar.pas:115-136` (OnClick handler)

**Context:** When no item is selected in the ListBox, `ItemIndex` is -1. Accessing `Items[-1]` causes an out-of-bounds exception.

**Step 1: Add ItemIndex validation in the OnClick handler**

Change `src/Router4D.Sidebar.pas` lines 120-133 from:
```pascal
      procedure(Sender: TObject; Aux : String)
      begin
        TRouter4D
        .Link
          .Animation(
            procedure ( aObject : TFMXObject )
            begin
              TLayout(aObject).Opacity := 0;
              TLayout(aObject).AnimateFloat('Opacity', 1, 0.2);
            end)
          .&To(
            (Sender as TListBox).Items[(Sender as TListBox).ItemIndex],
            Aux
          )
      end,
```
To:
```pascal
      procedure(Sender: TObject; Aux : String)
      var
        LListBox: TListBox;
      begin
        LListBox := Sender as TListBox;
        if LListBox.ItemIndex < 0 then
          Exit;
        TRouter4D
        .Link
          .Animation(
            procedure ( aObject : TFMXObject )
            begin
              TLayout(aObject).Opacity := 0;
              TLayout(aObject).AnimateFloat('Opacity', 1, 0.2);
            end)
          .&To(
            LListBox.Items[LListBox.ItemIndex],
            Aux
          )
      end,
```

**Step 2: Commit**

```bash
git add src/Router4D.Sidebar.pas
git commit -m "fix: guard Sidebar OnClick against ItemIndex -1

Prevents out-of-bounds exception when ListBox receives click
without a selected item."
```

---

### Task 7: EventBus.Core — Fix cloned event leak on exception

**Files:**
- Modify: `src/EventBus.Core.pas:177-207` (Post method)

**Context:** In `Post()`, when iterating subscribers, each event is cloned (line 197) then passed to `PostToSubscription`. If `PostToSubscription` raises for the `Posting` thread mode, the cloned event `LEvent` is never freed. The original `AEvent` is freed in `finally`, but clones are not tracked.

**Step 1: Wrap clone+post in try/except to free clone on failure**

Change `src/EventBus.Core.pas` lines 188-199 from:
```pascal
      for LSubscription in LSubscriptions do
      begin

        if not LSubscription.Active then
          continue;

        if ((not AContext.IsEmpty) and (LSubscription.Context <> AContext)) then
          continue;

        LEvent := CloneEvent(AEvent);
        PostToSubscription(LSubscription, LEvent, LIsMainThread);
      end;
```
To:
```pascal
      for LSubscription in LSubscriptions do
      begin

        if not LSubscription.Active then
          continue;

        if ((not AContext.IsEmpty) and (LSubscription.Context <> AContext)) then
          continue;

        LEvent := CloneEvent(AEvent);
        try
          PostToSubscription(LSubscription, LEvent, LIsMainThread);
        except
          LEvent.Free;
          raise;
        end;
      end;
```

**Step 2: Commit**

```bash
git add src/EventBus.Core.pas
git commit -m "fix: free cloned event on PostToSubscription failure

Prevents memory leak when PostToSubscription raises an exception
for Posting thread mode — the cloned event is now freed before
re-raising."
```

---

### Task 8: Router4D.History — Performance: use TStringBuilder in BreadCrumb

**Files:**
- Modify: `src/Router4D.History.pas:180-195` (BreadCrumb method)

**Context:** String concatenation in a loop is O(n²). For histories with many entries, this degrades. `TStringBuilder` reduces to O(n).

**Step 1: Add `System.SysUtils` to uses if not present (already present — verify)**

Already in uses clause at line 9: `SysUtils`. No change needed.

**Step 2: Rewrite BreadCrumb using TStringBuilder**

Change `src/Router4D.History.pas` lines 180-195 from:
```pascal
function TRouter4DHistory.BreadCrumb(aDelimiter: char): String;
var
  i : integer;
begin
  Result := '';

 if Self.FIndexCache = -1 then
    Exit;

 Result := Self.FListCacheOrder[Self.FIndexCache];

 for i := Self.FIndexCache-1 downto 0 do
 begin
    Result := Self.FListCacheOrder[i] + ADelimiter + Result;
 end;
end;
```
To:
```pascal
function TRouter4DHistory.BreadCrumb(aDelimiter: char): String;
var
  I: Integer;
  LSB: TStringBuilder;
begin
  Result := '';

  if (FIndexCache < 0) or (FIndexCache >= FListCacheOrder.Count) then
    Exit;

  LSB := TStringBuilder.Create;
  try
    for I := 0 to FIndexCache do
    begin
      if LSB.Length > 0 then
        LSB.Append(aDelimiter);
      LSB.Append(FListCacheOrder[I]);
    end;
    Result := LSB.ToString;
  finally
    LSB.Free;
  end;
end;
```

**Step 3: Commit**

```bash
git add src/Router4D.History.pas
git commit -m "perf: use TStringBuilder in BreadCrumb

Replaces O(n²) string concatenation with O(n) StringBuilder.
Also adds bounds checking for FIndexCache."
```

---

### Task 9: Router4D.History — Initialize FIndexCache safely in constructor

**Files:**
- Modify: `src/Router4D.History.pas:273-284` (constructor)

**Context:** `FIndexCache` is not explicitly initialized in the constructor. Delphi zeroes class fields, so it starts at 0 — but several methods treat -1 as "no history". This mismatch means `GetRouter` would access `FListCacheOrder[0]` when the list is empty.

**Step 1: Explicitly initialize FIndexCache to -1**

Change `src/Router4D.History.pas` line 278 (after the fix from Task 3, `FMaxCacheHistory := MAX_FRAME_COUNT;`). Add after it:
```pascal
  FIndexCache := -1;
```

The constructor should look like:
```pascal
constructor TRouter4DHistory.Create;
begin
  FListCache :=  TObjectDictionary<String, TObject>.Create;
  FListCache2 := TDictionary<String, TCachePersistent>.Create;
  FListCacheOrder := TList<String>.Create;
  FMaxCacheHistory := MAX_FRAME_COUNT;
  FIndexCache := -1;
  {$IFDEF HAS_FMX}
  FListCacheContainer := TObjectDictionary<String, TFMXObject>.Create;
  {$ELSE}
  FListCacheContainer := TObjectDictionary<String, TPanel>.Create;
  {$ENDIF}
end;
```

**Step 2: Commit**

```bash
git add src/Router4D.History.pas
git commit -m "fix: explicitly initialize FIndexCache to -1

Ensures GetRouter and PreviousRouter correctly detect 'no history'
state instead of accessing FListCacheOrder[0] on an empty list."
```

---

### Task 10: Router4D.Render — Add nil check for FParent.Render return value

**Files:**
- Modify: `src/Router4D.Render.pas:50-64` (FMX SetElement)
- Modify: `src/Router4D.Render.pas:66-80` (VCL SetElement)

**Context:** `FParent.Render` could return nil. Calling `aComponent.AddObject(nil)` may cause unexpected behavior.

**Step 1: Add nil check in FMX SetElement**

Change `src/Router4D.Render.pas` lines 59-63 from:
```pascal
  if Assigned(FParent) then
  begin
    aComponent.RemoveObject(0);
    aComponent.AddObject(FParent.Render);
  end;
```
To:
```pascal
  if Assigned(FParent) and Assigned(FParent.Render) then
  begin
    aComponent.RemoveObject(0);
    aComponent.AddObject(FParent.Render);
  end;
```

**Step 2: Add nil check in VCL SetElement**

Change `src/Router4D.Render.pas` lines 74-78 from:
```pascal
  if Assigned(FParent) then
  begin
    aComponent.RemoveObject;
    aComponent.AddObject(FParent.Render);
  end;
```
To:
```pascal
  if Assigned(FParent) and Assigned(FParent.Render) then
  begin
    aComponent.RemoveObject;
    aComponent.AddObject(FParent.Render);
  end;
```

**Step 3: Commit**

```bash
git add src/Router4D.Render.pas
git commit -m "fix: guard against nil return from FParent.Render

Prevents adding nil object to container when the parent
component's Render method returns nil."
```

---

## Task Summary

| Task | File | Severity | Type | Description |
|------|------|----------|------|-------------|
| 1 | Router4D.History | CRITICAL | Security | Bounds checking + Result init |
| 2 | Router4D.History | HIGH | Security | Silent exception + cache eviction |
| 3 | Router4D.History | HIGH | Security | Sync cache limits |
| 4 | Router4D.Utils | MEDIUM | Security | Silent exception |
| 5 | Router4D.Link | HIGH | Security | Nil checks before UnRender |
| 6 | Router4D.Sidebar | HIGH | Security | ItemIndex -1 guard |
| 7 | EventBus.Core | HIGH | Security | Clone leak on exception |
| 8 | Router4D.History | MEDIUM | Performance | TStringBuilder in BreadCrumb |
| 9 | Router4D.History | HIGH | Security | FIndexCache init to -1 |
| 10 | Router4D.Render | MEDIUM | Security | Nil check on FParent.Render |

**Execution order:** Tasks 1→2→3→8→9 (all in History.pas, sequential to avoid conflicts), then 4→5→6→7→10 (independent files, can be parallel).
