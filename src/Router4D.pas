unit Router4D;

{$I Router4D.inc}

interface

uses
  System.Generics.Collections,
  System.Classes,
  System.Rtti,
  System.TypInfo,
  SysUtils,
  {$IFDEF HAS_FMX}
  FMX.Types,
  {$ELSE}
  Vcl.ExtCtrls,
  {$ENDIF}
  Router4D.Interfaces,
  Router4D.History,
  Router4D.Render,
  Router4D.Link;

type
  TRouter4D = class(TInterfacedObject, iRouter4D)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iRouter4D;
      class function Render<T : class, constructor> : iRouter4DRender;
      class function Link : iRouter4DLink;
      class function Switch : iRouter4DSwitch;
      {$IFDEF HAS_FMX}
      class function SideBar : iRouter4DSidebar;
      {$ENDIF}
  end;

implementation

{ TRouter4Delphi }

uses
  Router4D.Utils,
  Router4D.Switch,
  Router4D.Sidebar;

constructor TRouter4D.Create;
begin

end;

destructor TRouter4D.Destroy;
begin

  inherited;
end;

class function TRouter4D.Link: iRouter4DLink;
begin
  Result := TRouter4DLink.New;
end;

class function TRouter4D.New: iRouter4D;
begin
  Result := Self.Create;
end;

class function TRouter4D.Render<T>: iRouter4DRender;
begin
  Router4DHistory
    .AddHistory(
      TPersistentClass(T).ClassName,
      TPersistentClass(T)
    );


  Result :=
    TRouter4DRender
      .New(
        Router4DHistory
          .GetHistory(
            TPersistentClass(T)
              .ClassName
          )
      );
end;
{$IFDEF HAS_FMX}
class function TRouter4D.SideBar: iRouter4DSidebar;
begin
  Result := TRouter4DSidebar.New;
end;
{$ENDIF}
class function TRouter4D.Switch: iRouter4DSwitch;
begin
  Result := TRouter4DSwitch.New;
end;

end.
