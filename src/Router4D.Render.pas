unit Router4D.Render;

{$I Router4D.inc}

interface

uses
  {$IFDEF HAS_FMX}
  FMX.Types,
  {$ELSE}
  Vcl.ExtCtrls,
  Router4D.Helper,
  {$ENDIF}
  Router4D.Interfaces;

type
  TRouter4DRender = class(TInterfacedObject, iRouter4DRender)
    private
      [weak]
      FParent : iRouter4DComponent;
    public
      constructor Create(Parent : iRouter4DComponent);
      destructor Destroy; override;
      class function New(Parent : iRouter4DComponent) : iRouter4DRender;
      {$IFDEF HAS_FMX}
      function SetElement ( aComponent : TFMXObject; aIndexComponent : TFMXObject = nil ) : iRouter4DRender;
      {$ELSE}
      function SetElement ( aComponent : TPanel; aIndexComponent : TPanel = nil ) : iRouter4DRender;
      {$ENDIF}
  end;

implementation

uses
  Router4D.History;

{ TRouter4DelphiRender }

constructor TRouter4DRender.Create(Parent: iRouter4DComponent);
begin
  FParent := Parent;
end;

destructor TRouter4DRender.Destroy;
begin

  inherited;
end;

{$IFDEF HAS_FMX}
function TRouter4DRender.SetElement( aComponent : TFMXObject; aIndexComponent : TFMXObject = nil ) : iRouter4DRender;
begin
  Result := Self;
  Router4DHistory.MainRouter(aComponent);

  if aIndexComponent <> nil then
    Router4DHistory.IndexRouter(aIndexComponent);

  if Assigned(FParent) then
  begin
    aComponent.RemoveObject(0);
    aComponent.AddObject(FParent.Render);
  end;
end;
{$ELSE}
function TRouter4DRender.SetElement( aComponent : TPanel; aIndexComponent : TPanel = nil ) : iRouter4DRender;
begin
  Result := Self;
  Router4DHistory.MainRouter(aComponent);

  if aIndexComponent <> nil then
    Router4DHistory.IndexRouter(aIndexComponent);

  if Assigned(FParent) then
  begin
    aComponent.RemoveObject;
    aComponent.AddObject(FParent.Render);
  end;
end;
{$ENDIF}

class function TRouter4DRender.New(
  Parent: iRouter4DComponent): iRouter4DRender;
begin
  Result := Self.Create(Parent);
end;

end.
