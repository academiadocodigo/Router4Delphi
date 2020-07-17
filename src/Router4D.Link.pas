unit Router4D.Link;

interface

uses
  FMX.Types,
  FMX.Layouts,
  SysUtils,
  Router4D.Interfaces,
  Router4D.Props;

type
  TRouter4DLink = class(TInterfacedObject, iRouter4DLink)
    private
      FAnimation : TProc<TFMXObject>;
    public
    constructor Create;
    destructor Destroy; override;
    class function New : iRouter4DLink;
    function Animation ( aAnimation : TProc<TFMXObject> ) : iRouter4DLink;
    function &To ( aPatch : String; aComponent : TFMXObject ) : iRouter4DLink; overload;
    function &To ( aPatch : String) : iRouter4DLink; overload;
    function &To ( aPatch : String; aProps : TProps; aKey : String = '') : iRouter4DLink; overload;
    function &To ( aPatch : String; aNameContainer : String) : iRouter4DLink; overload;
    function IndexLink ( aPatch : String ) : iRouter4DLink;
  end;

implementation

{ TRouter4DLink }

uses Router4D.History;

function TRouter4DLink.&To( aPatch : String; aComponent : TFMXObject ) : iRouter4DLink;
begin
  Result := Self;
  aComponent.RemoveObject(0);
  Router4DHistory.InstanteObject.UnRender;
  aComponent
    .AddObject(
      Router4DHistory
        .GetHistory(aPatch)
        .Render
    );
end;

function TRouter4DLink.&To(aPatch, aNameContainer: String): iRouter4DLink;
var
  aContainer : TFMXObject;
begin
  Result := Self;
  Router4DHistory.InstanteObject.UnRender;
  aContainer := Router4DHistory.GetHistoryContainer(aNameContainer);
  aContainer.RemoveObject(0);

  aContainer
    .AddObject(
      Router4DHistory
        .GetHistory(aPatch)
        .Render
    );

    if Assigned(FAnimation) then
      FAnimation(aContainer);

end;

function TRouter4DLink.Animation(aAnimation: TProc<TFMXObject>): iRouter4DLink;
begin
  Result := Self;
  FAnimation := aAnimation;
end;

constructor TRouter4DLink.Create;
begin

end;

destructor TRouter4DLink.Destroy;
begin

  inherited;
end;

function TRouter4DLink.IndexLink(aPatch: String): iRouter4DLink;
begin
  Result := Self;
  Router4DHistory.IndexRouter.RemoveObject(0);
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .IndexRouter
    .AddObject(
      Router4DHistory
        .GetHistory(aPatch)
        .Render
    );

  if Assigned(FAnimation) then
  FAnimation(Router4DHistory.IndexRouter);

end;

function TRouter4DLink.&To(aPatch: String) : iRouter4DLink;
begin
  Result := Self;
  Router4DHistory.MainRouter.RemoveObject(0);
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .MainRouter
    .AddObject(
      Router4DHistory
        .GetHistory(aPatch)
        .Render
    );

  if Assigned(FAnimation) then
    FAnimation(Router4DHistory.MainRouter);

end;

function TRouter4DLink.&To(aPatch: String; aProps: TProps; aKey : String = '') : iRouter4DLink;
begin
  Result := Self;
  Router4DHistory.MainRouter.RemoveObject(0);
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .MainRouter
    .AddObject(
      Router4DHistory
        .GetHistory(aPatch)
        .Render
    );

  if Assigned(FAnimation) then
    FAnimation(Router4DHistory.MainRouter);

  if aKey <> '' then aProps.Key(aKey);

  GlobalEventBus.Post(aProps);
end;

class function TRouter4DLink.New: iRouter4DLink;
begin
  Result := Self.Create;
end;

end.
