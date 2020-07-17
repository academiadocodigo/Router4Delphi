unit Router4D.Render;

interface

uses
  Router4D.Interfaces,
  FMX.Types;

type
  TRouter4DRender = class(TInterfacedObject, iRouter4DRender)
    private
      [weak]
      FParent : iRouter4DComponent;
    public
      constructor Create(Parent : iRouter4DComponent);
      destructor Destroy; override;
      class function New(Parent : iRouter4DComponent) : iRouter4DRender;
      function SetElement ( aComponent : TFMXObject; aIndexComponent : TFMXObject = nil ) : iRouter4DRender;
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

class function TRouter4DRender.New(
  Parent: iRouter4DComponent): iRouter4DRender;
begin
  Result := Self.Create(Parent);
end;

end.
