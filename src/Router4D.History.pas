unit Router4D.History;

interface

uses
  Classes,
  SysUtils,
  FMX.Forms,
  System.Generics.Collections,
  Router4D.Interfaces,
  FMX.Types,
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
      FListCacheContainer : TObjectDictionary<String, TFMXObject>;
      FListCache2 : TDictionary<String, TCachePersistent>;
      FMainRouter : TFMXObject;
      FIndexRouter : TFMXObject;
      FInstanteObject : iRouter4DComponent;
      procedure CreateInstancePersistent( aPath : String);
    public
      constructor Create;
      destructor Destroy; override;
      function MainRouter ( aValue : TFMXObject ) : TRouter4DHistory; overload;
      function MainRouter : TFMXObject; overload;
      function IndexRouter ( aValue : TFMXObject ) : TRouter4DHistory; overload;
      function IndexRouter : TFMXObject; overload;
      function AddHistory ( aKey : String; aObject : TObject ) : iRouter4DComponent; overload;
      function AddHistory ( aKey : String; aObject : TPersistentClass ) : iRouter4DComponent; overload;
      function AddHistory ( aKey : String; aObject : TPersistentClass; aSBKey : String; isVisible : Boolean ) : iRouter4DComponent; overload;
      function AddHistoryConteiner ( aKey : String; aObject : TFMXObject) : TRouter4DHistory; overload;
      function GetHistoryContainer ( aKey : String ) : TFMXObject;
      function RemoveHistory ( aKey : String ) : TRouter4DHistory;
      function GetHistory ( aKey : String ) : iRouter4DComponent;
      function RoutersList : TDictionary<String, TObject>;
      function RoutersListPersistent : TDictionary<String, TCachePersistent>;
      function InstanteObject : iRouter4DComponent;
  end;

var
  Router4DHistory : TRouter4DHistory;

implementation

{ TRouter4DHistory }

function TRouter4DHistory.AddHistory( aKey : String; aObject : TObject ) : iRouter4DComponent;
var
  mKey : String;
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

  FListCache.TryAdd(aKey, aObject);

end;

function TRouter4DHistory.AddHistory(aKey: String;
  aObject: TPersistentClass): iRouter4DComponent;
var
  CachePersistent : TCachePersistent;
begin
   //if not Supports(aObject, iRouter4DComponent, Result) then
    //raise Exception.Create('Form not Implement iRouter4DelphiComponent Interface');

  CachePersistent.FPatch := aKey;
  CachePersistent.FisVisible := True;
  CachePersistent.FPersistentClass := aObject;
  CachePersistent.FSBKey := 'SBIndex';

  try FListCache2.Add(aKey, CachePersistent); except end;
end;

function TRouter4DHistory.AddHistory(aKey: String; aObject: TPersistentClass;
  aSBKey : String; isVisible: Boolean): iRouter4DComponent;
var
  CachePersistent : TCachePersistent;
begin
  CachePersistent.FPatch := aKey;
  CachePersistent.FisVisible := isVisible;
  CachePersistent.FPersistentClass := aObject;
  CachePersistent.FSBKey := aSBKey;

  try FListCache2.TryAdd(aKey, CachePersistent); except end;
end;

function TRouter4DHistory.AddHistoryConteiner( aKey : String; aObject : TFMXObject) : TRouter4DHistory;
var
  auxObject : TFMXObject;
begin
  Result := Self;
  if not FListCacheContainer.TryGetValue(aKey, auxObject) then
    FListCacheContainer.TryAdd(aKey, aObject);
end;

constructor TRouter4DHistory.Create;
begin
  FListCache :=  TObjectDictionary<String, TObject>.Create;
  FListCache2 := TDictionary<String, TCachePersistent>.Create;
  FListCacheContainer := TObjectDictionary<String, TFMXObject>.Create;
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

function TRouter4DHistory.GetHistoryContainer(aKey: String): TFMXObject;
begin
  FListCacheContainer.TryGetValue(aKey, Result);
end;

function TRouter4DHistory.IndexRouter: TFMXObject;
begin
  Result := FIndexRouter;
end;

function TRouter4DHistory.InstanteObject: iRouter4DComponent;
begin
  Result := FInstanteObject;
end;

function TRouter4DHistory.IndexRouter(aValue: TFMXObject): TRouter4DHistory;
begin
  Result := Self;
  FIndexRouter := aValue;
end;

function TRouter4DHistory.MainRouter: TFMXObject;
begin
  Result := FMainRouter;
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

function TRouter4DHistory.MainRouter(aValue: TFMXObject): TRouter4DHistory;
begin
  Result := Self;
  FMainRouter := aValue;
end;

initialization
  Router4DHistory := TRouter4DHistory.Create;

finalization
  Router4DHistory.Free;
end.
