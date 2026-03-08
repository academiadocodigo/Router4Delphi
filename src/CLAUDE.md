# CLAUDE.md - Router4Delphi Source Guide

## Project Overview

Router4Delphi is a Delphi routing framework for FMX and VCL applications. It uses interface-based design with RTTI for dynamic component instantiation.

## Unit Structure Template

```pascal
unit Router4D.<Module>;

{$I Router4D.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  {$IFDEF HAS_FMX}
  FMX.Types,
  {$ELSE}
  Vcl.ExtCtrls,
  {$ENDIF}
  Router4D.Interfaces;

type
  TRouter4D<Name> = class(TInterfacedObject, iRouter4D<Name>)
  private
    FField: <Type>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iRouter4D<Name>;
  end;

implementation

{ TRouter4D<Name> }

constructor TRouter4D<Name>.Create;
begin
end;

destructor TRouter4D<Name>.Destroy;
begin
  inherited;
end;

class function TRouter4D<Name>.New: iRouter4D<Name>;
begin
  Result := Self.Create;
end;

end.
```

## Key Source Files

| File | Purpose |
|------|---------|
| `Router4D.inc` | Compiler toggle: `{$DEFINE HAS_FMX}` for FMX, comment out for VCL |
| `Router4D.Interfaces.pas` | All interface contracts (`iRouter4D*`) |
| `Router4D.pas` | Main entry point, `TRouter4D` facade class |
| `Router4D.History.pas` | Navigation history, cache management, global `Router4DHistory` var |
| `Router4D.Link.pas` | Route navigation (`&To`, `GoBack`, `IndexLink`) |
| `Router4D.Switch.pas` | Route registration (`Router`, `UnRouter`) |
| `Router4D.Render.pas` | Component rendering into containers |
| `Router4D.Sidebar.pas` | Sidebar UI management (FMX only for `RenderToListBox`) |
| `Router4D.Props.pas` | Property passing between routes |
| `Router4D.Helper.pas` | Helper utilities |
| `Router4D.Utils.pas` | Shared utilities |

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | `TRouter4D<Name>` | `TRouter4DHistory`, `TRouter4DLink` |
| Interfaces | `iRouter4D<Name>` (lowercase `i`) | `iRouter4DComponent`, `iRouter4DLink` |
| Parameters | `a` prefix + camelCase | `aPath`, `aRouter`, `aComponent` |
| Fields | `F` prefix + camelCase | `FHistory`, `FMainRouter`, `FListCache` |
| Constants | ALL_CAPS | `MAX_FRAME_COUNT` |
| Unit names | `Router4D.<Module>.pas` | `Router4D.History.pas` |
| Factory methods | `class function New` | `TRouter4DLink.New` |

## FMX / VCL Conditional Compilation

The framework targets both FMX and VCL via the include file `Router4D.inc`:

```pascal
// In Router4D.inc:
//{$DEFINE HAS_FMX}   // Uncomment for FMX, leave commented for VCL
```

Every unit includes `{$I Router4D.inc}` and uses `{$IFDEF HAS_FMX}` to switch between FMX types (`TFMXObject`) and VCL types (`TPanel`, `TForm`). Always maintain both branches when modifying conditional blocks.

## Architecture Patterns

- **Interface-based design**: All public contracts are interfaces in `Router4D.Interfaces.pas`. Implementations are in their own units.
- **Factory pattern**: Classes expose `class function New` returning the interface type, not the class.
- **Fluent API**: Methods return `Self` (typed as the interface) to enable chaining.
- **Global singleton**: `Router4DHistory` is a global variable initialized in the `initialization` section of `Router4D.History.pas` and freed in `finalization`.
- **RTTI instantiation**: Routes are registered as `TPersistentClass` and instantiated dynamically via `FindClass` and `TComponentClass.Create`.

## Security and Resource Management Rules

1. **Use `try/finally` for resource cleanup.** Any locally created object must be freed in a `finally` block unless ownership is transferred.
2. **Do not silently swallow exceptions.** Avoid empty `except` blocks. If an exception must be caught, log or re-raise it. (Note: `try GlobalEventBus.RegisterSubscriber(...); except end;` exists in the codebase but should not be replicated.)
3. **Rely on interface reference counting.** Objects returned as interfaces (`iRouter4D*`) are reference-counted via `TInterfacedObject`. Do not call `Free` on interface-referenced objects.
4. **Free owned objects in `Destroy`.** Classes that create owned objects in the constructor must free them in `Destroy` (see `TRouter4DHistory.Destroy`).
5. **Validate interface support before use.** Always check `Supports(aObject, iRouter4DComponent, Result)` before casting. Raise a descriptive exception on failure.
6. **Respect cache limits.** The history cache enforces `MAX_FRAME_COUNT`. Follow the same pattern when adding new caches.
