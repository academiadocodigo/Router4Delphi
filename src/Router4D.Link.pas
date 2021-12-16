unit Router4D.Link;

{$I Router4D.inc}

interface

uses
  {$IFDEF HAS_FMX}
  FMX.Types,
  FMX.Layouts,
  {$ELSE}
  Vcl.ExtCtrls,
  Router4D.Helper,
  {$ENDIF}
  SysUtils,
  Router4D.Interfaces,
  Router4D.Props;

type
  TRouter4DLink = class(TInterfacedObject, iRouter4DLink)
    private
      {$IFDEF HAS_FMX}
      FAnimation : TProc<TFMXObject>;
      {$ELSE}
      FAnimation : TProc<TPanel>;
      {$ENDIF}
    public
    constructor Create;
    destructor Destroy; override;
    class function New : iRouter4DLink;
    {$IFDEF HAS_FMX}
    function Animation ( aAnimation : TProc<TFMXObject> ) : iRouter4DLink;
    function &To ( aPatch : String; aComponent : TFMXObject ) : iRouter4DLink; overload;
    {$ELSE}
    function Animation ( aAnimation : TProc<TPanel> ) : iRouter4DLink;
    function &To ( aPatch : String; aComponent : TPanel ) : iRouter4DLink; overload;
    {$ENDIF}
    function &To ( aPatch : String) : iRouter4DLink; overload;
    function &To ( aPatch : String; aProps : TProps; aKey : String = '') : iRouter4DLink; overload;
    function &To ( aPatch : String; aNameContainer : String) : iRouter4DLink; overload;
    function GoBack : iRouter4DLink;
    function IndexLink ( aPatch : String ) : iRouter4DLink;
  end;

var
  Router4DLink : iRouter4DLink;

implementation

{ TRouter4DLink }


uses Router4D.History;

{$IFDEF HAS_FMX}
function TRouter4DLink.Animation(aAnimation: TProc<TFMXObject>): iRouter4DLink;
begin
  Result := Self;
  FAnimation := aAnimation;
end;

function TRouter4DLink.&To( aPatch : String; aComponent : TFMXObject ) : iRouter4DLink;
begin
  Result := Self;
  aComponent.RemoveObject(0);
  Router4DHistory.InstanteObject.UnRender;
  aComponent
    .AddObject(
      Router4DHistory
        .addCacheHistory(aPatch)
        .GetHistory(aPatch)
        .Render
    );
end;
{$ELSE}
function TRouter4DLink.Animation(aAnimation: TProc<TPanel>): iRouter4DLink;
begin
  Result := Self;
  FAnimation := aAnimation;
end;

function TRouter4DLink.&To( aPatch : String; aComponent : TPanel ) : iRouter4DLink;
begin
  Result := Self;
  aComponent.RemoveObject;
  Router4DHistory.InstanteObject.UnRender;
  aComponent
    .AddObject(
      Router4DHistory
        .addCacheHistory(aPatch)
        .GetHistory(aPatch)
        .Render
    );
end;
{$ENDIF}

function TRouter4DLink.&To(aPatch, aNameContainer: String): iRouter4DLink;
var
  {$IFDEF HAS_FMX}
  aContainer : TFMXObject;
  {$ELSE}
  aContainer : TPanel;
  {$ENDIF}
begin
  Result := Self;
  Router4DHistory.InstanteObject.UnRender;
  aContainer := Router4DHistory.GetHistoryContainer(aNameContainer);
  {$IFDEF HAS_FMX}
  aContainer.RemoveObject(0);
  {$ELSE}
  aContainer.RemoveObject;
  {$ENDIF}

  aContainer
    .AddObject(
      Router4DHistory
        .addCacheHistory(aPatch)
        .GetHistory(aPatch)
        .Render
    );

    if Assigned(FAnimation) then
      FAnimation(aContainer);

end;

constructor TRouter4DLink.Create;
begin

end;

destructor TRouter4DLink.Destroy;
begin

  inherited;
end;

function TRouter4DLink.GoBack : iRouter4DLink;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  Router4DHistory.MainRouter.RemoveObject(0);
  {$ELSE}
  Router4DHistory.MainRouter.RemoveObject;
  {$ENDIF}
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .MainRouter
    .AddObject(
      Router4DHistory
        .GetHistory(Router4DHistory.GoBack)
        .Render
    );

  if Assigned(FAnimation) then
    FAnimation(Router4DHistory.MainRouter);
end;
function TRouter4DLink.IndexLink(aPatch: String): iRouter4DLink;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  Router4DHistory.IndexRouter.RemoveObject(0);
  {$ELSE}
  Router4DHistory.IndexRouter.RemoveObject;
  {$ENDIF}
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
  {$IFDEF HAS_FMX}
  Router4DHistory.MainRouter.RemoveObject(0);
  {$ELSE}
  Router4DHistory.MainRouter.RemoveObject;
  {$ENDIF}
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .MainRouter
    .AddObject(
      Router4DHistory
        .addCacheHistory(aPatch)
        .GetHistory(aPatch)
        .Render
    );

  if Assigned(FAnimation) then
    FAnimation(Router4DHistory.MainRouter);

end;

function TRouter4DLink.&To(aPatch: String; aProps: TProps; aKey : String = '') : iRouter4DLink;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  Router4DHistory.MainRouter.RemoveObject(0);
  {$ELSE}
  Router4DHistory.MainRouter.RemoveObject;
  {$ENDIF}
  Router4DHistory.InstanteObject.UnRender;
  Router4DHistory
  .MainRouter
    .AddObject(
      Router4DHistory
        .addCacheHistory(aPatch)
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
  if not Assigned(Router4DLink) then
    Router4DLink := Self.Create;

  Result := Router4DLink;
end;

initialization
  Router4DLink := TRouter4DLink.New;

end.
