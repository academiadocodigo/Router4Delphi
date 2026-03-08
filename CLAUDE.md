# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Router4Delphi is a screen routing framework for Delphi FMX and VCL applications. It enables loose coupling between screens through dynamic routing, an event bus for data passing, and navigation history.

## Repository Structure

```
Router4Delphi/
  src/                    # All library source units (Router4D.*.pas, EventBus.*, helpers)
  Samples/
    FMX/
      SimpleDemo/         # Minimal single-form FMX example
      Demo/               # Full app with pages, sidebar, layouts, route registration
    VCL/                  # VCL implementation example
  tests/                  # Test projects and plans
  docs/                   # Documentation and project plans
  assets/                 # Images and media for README
  Router4Delphi.dpk       # Delphi package file
  Router4Delphi.dproj     # Delphi project file
  ProjectGroup1.groupproj # Project group (library + sample apps)
  boss.json               # Boss dependency manager (no external deps)
```

## Build

This is a Delphi package (`Router4Delphi.dpk`). Build via the Delphi IDE or MSBuild:

```
msbuild Router4Delphi.dproj /p:Config=Release /p:Platform=Win32
```

The project group `ProjectGroup1.groupproj` builds the library plus two sample apps (SimpleDemo and Demo).

No external dependencies (boss.json has none). All utilities are bundled.

## FMX vs VCL Compilation

Controlled by `src/Router4D.inc`:
- **FMX mode**: `{$DEFINE HAS_FMX}` uncommented (default)
- **VCL mode**: `{$DEFINE HAS_FMX}` commented out

This directive is checked throughout the codebase with `{$IFDEF HAS_FMX}` to switch between `TFMXObject` and `TPanel` containers.

## Architecture

**Entry point**: `TRouter4D` (facade in `Router4D.pas`) — all routing goes through its static class methods: `Link`, `Switch`, `Render<T>`, `SideBar`.

**Core flow**:
1. **Register routes**: `TRouter4D.Switch.Router('path', TFormClass)` — maps string paths to form classes
2. **Set containers**: `TRouter4D.Render<TInitialForm>.SetElement(MainLayout, IndexLayout)` — configures where routed forms are embedded
3. **Navigate**: `TRouter4D.Link.&To('path')` — switches the displayed form
4. **Pass data**: `TRouter4D.Link.&To('path', TProps.Create.PropString('data').Key('key'))` — sends data via EventBus

**Key units** (all in `src/`):

| Unit | Role |
|------|------|
| `Router4D.Interfaces.pas` | All interfaces: `iRouter4DComponent` (forms must implement `Render`/`UnRender`), `iRouter4DLink`, `iRouter4DSwitch`, `iRouter4DRender`, `iRouter4DSidebar` |
| `Router4D.History.pas` | Singleton managing route cache (max 25 frames), navigation stack, breadcrumbs, and container references |
| `Router4D.Link.pas` | Navigation implementation with multiple `&To()` overloads, `GoBack()`, `IndexLink()`, animation support |
| `Router4D.Switch.pas` | Route registration with sidebar category support |
| `Router4D.Render.pas` | Container setup and initial form rendering |
| `Router4D.Props.pas` | `TProps` data transfer object (string/int/currency/double/datetime/object), `[Subscribe]` attribute, `TDEBEvent<T>` wrapper |
| `Router4D.Sidebar.pas` | FMX-only dynamic menu generation from registered routes |
| `Router4D.Helper.pas` | VCL-only `TPanel` helper adding `AddObject`/`RemoveObject` |
| `Router4D.Utils.pas` | RTTI-based instantiation, `TNotifyEventWrapper` for anonymous procs |
| `EventBus.Core.pas` | Pub/sub event bus with thread mode support (Posting/Main/Async/Background) |

**Patterns**: Singleton (History, GlobalEventBus), Facade (TRouter4D), Interface-based design throughout, RTTI reflection for dynamic instantiation, Pub/Sub via EventBus.

## Routable Forms

Forms must implement `iRouter4DComponent`:
```delphi
function Render: TFMXObject;  // Return the layout to embed
procedure UnRender;            // Cleanup when leaving
```

Data reception uses the `[Subscribe]` attribute on a method accepting `TProps`.

## Samples

- `Samples/FMX/SimpleDemo/` — minimal single-form example
- `Samples/FMX/Demo/` — full app with pages, sidebar, layouts, and route registration
- `Samples/VCL/` — VCL implementation example

## Conventions

**File naming**: `Router4D.<Module>.pas` (e.g., `Router4D.Link.pas`, `Router4D.History.pas`).

**Classes**: `TRouter4D<Name>` (e.g., `TRouter4DHistory`, `TRouter4DLink`).

**Interfaces**: lowercase `i` prefix — `iRouter4D<Name>` (e.g., `iRouter4DComponent`, `iRouter4DLink`).

**Variables**:
- Parameters: `a` prefix, camelCase (e.g., `aPath`, `aRouter`, `aForm`)
- Fields: `F` prefix, camelCase (e.g., `FHistory`, `FMainRouter`)

**Constants**: `ALL_CAPS` with underscores (e.g., `MAX_FRAME_COUNT`).

**General style**: Follow the existing patterns in `src/`. Use interface-based design. Keep units focused on a single responsibility.

## Fundamental Requirement

Every new feature or significant change **must** include:

1. **Tests** — add or update test cases in `tests/` covering the new behavior
2. **Samples** — update or add sample usage in `Samples/FMX/` and/or `Samples/VCL/` as appropriate
3. **Documentation** — update relevant docs (this file, README, or `docs/`) to reflect the change
4. **CHANGELOG** — add an entry describing what changed, following keep-a-changelog format

Pull requests missing any of these will be considered incomplete.
