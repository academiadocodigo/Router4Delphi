---
name: coding-patterns
description: Router4D coding patterns and conventions
---

# Router4D Coding Patterns

## Unit Template

```pascal
unit Router4D.<Module>;

{$I Router4D.inc}

interface

uses
  System.SysUtils, System.Classes,
  {$IFDEF HAS_FMX}
  FMX.Forms,
  {$ELSE}
  Vcl.Forms,
  {$ENDIF}
  Router4D.Interfaces;

type
  iRouter4D<Name> = interface
    ['{GUID}']
  end;

  TRouter4D<Name> = class(TInterfacedObject, iRouter4D<Name>)
  private
    FField: TObject;
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

## Class Template

- Inherit from `TInterfacedObject` and implement the corresponding interface.
- Private fields use the `F` prefix.
- Provide a `class function New: iRouter4D<Name>;` factory method.

## Naming Conventions

| Element         | Convention              | Example                    |
|-----------------|-------------------------|----------------------------|
| File            | `Router4D.<Module>.pas` | `Router4D.History.pas`     |
| Class           | `TRouter4D<Name>`       | `TRouter4DHistory`         |
| Interface       | `iRouter4D<Name>`       | `iRouter4DHistory`         |
| Function/Method | PascalCase              | `GetMainRouter`            |
| Parameters      | `a` prefix              | `aForm`, `aKey`            |
| Fields          | `F` prefix              | `FMainRouter`, `FHistory`  |
| Constants       | ALL_CAPS                | `MAX_FRAME_COUNT`          |

## Error Handling

Use `try/finally` for resource cleanup. Re-raise after cleanup when needed.

```pascal
LObj := TObject.Create;
try
  // work
finally
  LObj.Free;
end;
```

## Uses Clause Order

1. System units (`System.SysUtils`, `System.Classes`, etc.)
2. FMX/VCL units (`FMX.Forms`, `FMX.Types`, etc.)
3. Project units (`Router4D.Interfaces`, `Router4D.History`, etc.)
