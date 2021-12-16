unit Router4D.History;

{$I Router4D.inc}

interface

uses
  Classes,
  SysUtils,
  {$IFDEF HAS_FMX}
  FMX.Forms,
  FMX.Types,
  {$ELSE}
  Vcl.Forms,
  Vcl.ExtCtrls,
  {$ENDIF}
  System.Generics.Collections,
  Router4D.Interfaces,
  Router4D.Props;

type
  TCachePersistent = record
    FPatch : String;
    FisVisible : Boolean;
    FSBKey : String;
    FPersistentClass : TPersistentClass;
  end;

  TRouter4DHistory = class
    private
      FListCache : TObjectDictionary<String, TObject>;
      {$IFDEF HAS_FMX}
      FListCacheContainer : TObjectDictionary<String, TFMXObject>;
      FMainRouter : TFMXObject;
      FIndexRouter : TFMXObject;
      {$ELSE}
      FListCacheContainer : TObjectDictionary<String, TPanel>;
      FMainRouter : TPanel;
      FIndexRouter : TPanel;
      {$ENDIF}
      FListCache2 : TDictionary<String, TCachePersistent>;
      FInstanteObject : iRouter4DComponent;
      FListCacheOrder : TList<String>;
      FIndexCache : Integer;
      FMaxCacheHistory : Integer;
      procedure CreateInstancePersistent( aPath : String);
      //procedure CacheKeyNotify(Sender: TObject; const Key: string; Action: TCollectionNotification);
    public
      constructor Create;
      destructor Destroy; override;
      {$IFDEF HAS_FMX}
      function MainRouter ( aValue : TFMXObject ) : TRouter4DHistory; overload;
      function MainRouter : TFMXObject; overload;
      function IndexRouter ( aValue : TFMXObject ) : TRouter4DHistory; overload;
      function IndexRouter : TFMXObject; overload;
      function AddHistoryConteiner ( aKey : String; aObject : TFMXObject) : TRouter4DHistory; overload;
      function GetHistoryContainer ( aKey : String ) : TFMXObject;
      {$ELSE}
      function MainRouter ( aValue : TPanel ) : TRouter4DHistory; overload;
      function MainRouter : TPanel; overload;
      function IndexRouter ( aValue : TPanel ) : TRouter4DHistory; overload;
      function IndexRouter : TPanel; overload;
      function AddHistoryConteiner ( aKey : String; aObject : TPanel) : TRouter4DHistory; overload;
      function GetHistoryContainer ( aKey : String ) : TPanel;
      {$ENDIF}
      function AddHistory ( aKey : String; aObject : TObject ) : iRouter4DComponent; overload;
      function AddHistory ( aKey : String; aObject : TPersistentClass ) : iRouter4DComponent; overload;
      function AddHistory ( aKey : String; aObject : TPersistentClass; aSBKey : String; isVisible : Boolean ) : iRouter4DComponent; overload;
      function RemoveHistory ( aKey : String ) : TRouter4DHistory;
      function GetHistory ( aKey : String ) : iRouter4DComponent;
      function RoutersList : TDictionary<String, TObject>;
      function RoutersListPersistent : TDictionary<String, TCachePersistent>;
      function InstanteObject : iRouter4DComponent;
      function GoBack : String;
      function BreadCrumb(aDelimiter: char = '/') : String;
      function addCacheHistory(aKey : String) : TRouter4DHistory;
      function IndexCache : Integer;
  end;

var
  Router4DHistory : TRouter4DHistory;

implementation

{ TRouter4DHistory }

{$IFDEF HAS_FMX}
function TRouter4DHistory.MainRouter(aValue: TFMXObject): TRouter4DHistory;
begin
  Result := Self;
  FMainRouter := aValue;
end;

function TRouter4DHistory.MainRouter: TFMXObject;
begin
  Result := FMainRouter;
end;

function TRouter4DHistory.IndexRouter(aValue: TFMXObject): TRouter4DHistory;
begin
  Result := Self;
  FIndexRouter := aValue;
end;

function TRouter4DHistory.IndexRouter: TFMXObject;
begin
  Result := FIndexRouter;
end;

function TRouter4DHistory.AddHistoryConteiner( aKey : String; aObject : TFMXObject) : TRouter4DHistory;
var
  auxObject : TFMXObject;
begin
  Result := Self;
  if not FListCacheContainer.TryGetValue(aKey, auxObject) then
    FListCacheContainer.Add(aKey, aObject);
end;

function TRouter4DHistory.GetHistoryContainer(aKey: String): TFMXObject;
begin
  FListCacheContainer.TryGetValue(aKey, Result);
end;
{$ELSE}
function TRouter4DHistory.MainRouter(aValue: TPanel): TRouter4DHistory;
begin
  Result := Self;
  FMainRouter := aValue;
end;

function TRouter4DHistory.MainRouter: TPanel;
begin
  Result := FMainRouter;
end;

function TRouter4DHistory.IndexRouter(aValue: TPanel): TRouter4DHistory;
begin
  Result := Self;
  FIndexRouter := aValue;
end;

function TRouter4DHistory.IndexRouter: TPanel;
begin
  Result := FIndexRouter;
end;

function TRouter4DHistory.AddHistoryConteiner( aKey : String; aObject : TPanel) : TRouter4DHistory;
var
  auxObject : TPanel;
begin
  Result := Self;
  if not FListCacheContainer.TryGetValue(aKey, auxObject) then
    FListCacheContainer.Add(aKey, aObject);
end;

function TRouter4DHistory.GetHistoryContainer(aKey: String): TPanel;
begin
  FListCacheContainer.TryGetValue(aKey, Result);
end;

{$ENDIF}

function TRouter4DHistory.IndexCache: Integer;
begin
  Result := Self.FIndexCache;
end;

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

function TRouter4DHistory.GoBack: String;
begin
  if Self.FIndexCache > 0 then
    Dec(Self.FIndexCache);

 Result := Self.FListCacheOrder[Self.FIndexCache];
end;

function TRouter4DHistory.AddHistory( aKey : String; aObject : TObject ) : iRouter4DComponent;
var
  mKey : String;
  vObject : TObject;
begin
  if not Supports(aObject, iRouter4DComponent, Result) then
    raise Exception.Create('Form not Implement iRouter4DelphiComponent Interface');

  try GlobalEventBus.RegisterSubscriber(aObject); except end;

  if FListCache.Count > 25 then
    for mKey in FListCache.Keys do
    begin
      FListCache.Remove(aKey);
      exit;
    end;


  if not FListCache.TryGetValue(aKey, vObject) then
    FListCache.Add(aKey, aObject);

end;

function TRouter4DHistory.AddHistory(aKey: String;
  aObject: TPersistentClass): iRouter4DComponent;
var
  CachePersistent : TCachePersistent;
  vPesersistentClass : TCachePersistent;
begin
  CachePersistent.FPatch := aKey;
  CachePersistent.FisVisible := True;
  CachePersistent.FPersistentClass := aObject;
  CachePersistent.FSBKey := 'SBIndex';

  if not FListCache2.TryGetValue(aKey, vPesersistentClass) then
    FListCache2.Add(aKey, CachePersistent);
end;

function TRouter4DHistory.addCacheHistory(aKey: String): TRouter4DHistory;
var
  I: Integer;
begin
  Result := Self;
  for I := Pred(FListCacheOrder.Count) downto Succ(FIndexCache) do
    FListCacheOrder.Delete(I);

  if FListCacheOrder.Count > FMaxCacheHistory then
    FListCacheOrder.Delete(0);

  FListCacheOrder.Add(aKey);
  FIndexCache := Pred(FListCacheOrder.Count);
end;

function TRouter4DHistory.AddHistory(aKey: String; aObject: TPersistentClass;
  aSBKey : String; isVisible: Boolean): iRouter4DComponent;
var
  CachePersistent : TCachePersistent;
  vPesersistentClass : TCachePersistent;
begin
  CachePersistent.FPatch := aKey;
  CachePersistent.FisVisible := isVisible;
  CachePersistent.FPersistentClass := aObject;
  CachePersistent.FSBKey := aSBKey;

  if not FListCache2.TryGetValue(aKey, vPesersistentClass) then
    FListCache2.Add(aKey, CachePersistent);
end;

constructor TRouter4DHistory.Create;
begin
  FListCache :=  TObjectDictionary<String, TObject>.Create;
  FListCache2 := TDictionary<String, TCachePersistent>.Create;
  FListCacheOrder := TList<String>.Create;
  FMaxCacheHistory := 10;
  {$IFDEF HAS_FMX}
  FListCacheContainer := TObjectDictionary<String, TFMXObject>.Create;
  {$ELSE}
  FListCacheContainer := TObjectDictionary<String, TPanel>.Create;
  {$ENDIF}
end;

procedure TRouter4DHistory.CreateInstancePersistent( aPath : String);
var
  aPersistentClass :  TCachePersistent;
begin
  if not FListCache2.TryGetValue(aPath, aPersistentClass) then
    raise Exception.Create('Not Register Router ' + aPath);

  Self.AddHistory(
    aPath,
    TComponentClass(
      FindClass(
        aPersistentClass
          .FPersistentClass
          .ClassName
      )
    ).Create(Application)
  );
end;

destructor TRouter4DHistory.Destroy;
begin
  FListCache.Free;
  FListCache2.Free;
  FListCacheContainer.Free;
  FListCacheOrder.Free;
  inherited;
end;

function TRouter4DHistory.GetHistory(aKey: String): iRouter4DComponent;
var
  aObject : TObject;
begin

  if not FListCache.TryGetValue(aKey, aObject) then
    Self.CreateInstancePersistent(aKey);

  if not Supports(FListCache.Items[aKey], iRouter4DComponent, Result) then
    raise Exception.Create('Object not Implements Interface Component');

  FInstanteObject := Result;
end;

function TRouter4DHistory.InstanteObject: iRouter4DComponent;
begin
  Result := FInstanteObject;
end;

function TRouter4DHistory.RemoveHistory(aKey: String): TRouter4DHistory;
begin
  Result := Self;
  FListCache.Remove(aKey);
end;

function TRouter4DHistory.RoutersList: TDictionary<String, TObject>;
begin
  Result := FListCache;
end;

function TRouter4DHistory.RoutersListPersistent: TDictionary<String, TCachePersistent>;
begin
  Result := FListCache2;
end;

initialization
  Router4DHistory := TRouter4DHistory.Create;

finalization
  Router4DHistory.Free;
end.
