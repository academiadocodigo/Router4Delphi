# CLAUDE.md — Router4Delphi Samples

## File Ownership

**Claude Code may create or edit:**
- `.pas` files (unit source code)
- `.dpr` files (program source)

**Claude Code must NOT create or edit:**
- `.dproj` (project settings — IDE-generated XML)
- `.fmx` (FMX form layout — IDE binary/text)
- `.dfm` (VCL form layout — IDE binary/text)
- `.res` (compiled resources)

These IDE-managed files contain visual designer data and build configuration that must be produced by the Delphi IDE.

## Sample Structure

Every sample must follow this layout:

```
Samples/<Framework>/<SampleName>/
  <SampleName>.dpr          -- program file (required)
  <SampleName>.dproj        -- IDE only, do not generate
  README.md                 -- brief description and usage instructions
  <unit files>.pas          -- source units
```

Existing samples for reference:
- `FMX/SimpleDemo/` — flat structure, all units in one folder
- `FMX/Demo/` — organized into `Views/Pages/`, `Views/Layouts/`, `Views/Components/`, `Views/Routers/`
- `VCL/` — main form at root, page units in `pages/` subfolder

When a sample needs forms or visual components, create only the `.pas` file with the class skeleton. Add a comment noting the developer must design the form in the IDE and save the corresponding `.fmx` or `.dfm`.

Reuse existing shared units (e.g., `Router4D.pas`, `Router4D.History.pas`) from the library root via search path — do not duplicate them into sample folders.

## Minimum Demonstration Requirements

Every sample must demonstrate at least:

1. **Router setup** — Initialize `TRouter4D` with a render container (typically a `TLayout` for FMX or `TPanel` for VCL).
2. **Route registration** — Register at least two routes using `TRouter4D.Switch.Router('<name>', TPageClass)`.
3. **Navigation** — Trigger at least one route change (e.g., button click calling `TRouter4D.Link.&Goto('<name>')`).
4. **Visible output** — Each routed page must contain at least a label or other visual element so the user can confirm navigation works.

## .dpr Conventions

FMX programs must include `System.StartUpCopy` in uses. The main form is created via `Application.CreateForm`. Route registration happens either in a dedicated router unit's `initialization` section or in the main form's `OnCreate`.

```delphi
program MyDemo;
uses
  System.StartUpCopy,
  FMX.Forms,
  MyDemo.View.Main in 'MyDemo.View.Main.pas' {FormMain};
{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
```

VCL programs follow the same pattern but use `Vcl.Forms` and omit `System.StartUpCopy`.
