{ *******************************************************************************
  Copyright 2016-2019 Daniele Spinetti

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ******************************************************************************** }

unit Router4D.Props;

{$I Router4D.inc}

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti;

type

  TThreadMode = (Posting, Main, Async, Background);

  TCloneEventCallback = function(const AObject: TObject): TObject of object;
  TCloneEventMethod = TFunc<TObject, TObject>;

  IEventBus = Interface
    ['{7BDF4536-F2BA-4FBA-B186-09E1EE6C7E35}']
    procedure RegisterSubscriber(ASubscriber: TObject);
    function IsRegistered(ASubscriber: TObject): Boolean;
    procedure Unregister(ASubscriber: TObject);
    procedure Post(AEvent: TObject; const AContext: String = '';
      AEventOwner: Boolean = true);

    procedure SetOnCloneEvent(const aCloneEvent: TCloneEventCallback);
    procedure AddCustomClassCloning(const AQualifiedClassName: String;
      const aCloneEvent: TCloneEventMethod);
    procedure RemoveCustomClassCloning(const AQualifiedClassName: String);

    property OnCloneEvent: TCloneEventCallback write SetOnCloneEvent;
  end;

  SubscribeAttribute = class(TCustomAttribute)
  private
    FContext: String;
    FThreadMode: TThreadMode;
  public
    constructor Create(AThreadMode: TThreadMode = TThreadMode.Posting;
      const AContext: String = '');
    property ThreadMode: TThreadMode read FThreadMode;
    property Context: String read FContext;
  end;

  TDEBEvent<T> = class(TObject)
  private
    FDataOwner: Boolean;
    FData: T;
    procedure SetData(const Value: T);
    procedure SetDataOwner(const Value: Boolean);
  public
    constructor Create; overload;
    constructor Create(AData: T); overload;
    destructor Destroy; override;
    property DataOwner: Boolean read FDataOwner write SetDataOwner;
    property Data: T read FData write SetData;
  end;


  TProps = class
    private
      FPropString: String;
      FPropInteger: Integer;
      FPropCurrency : Currency;
      FPropDouble : Double;
      FPropValue : TValue;
      FPropObject : TObject;
      FPropDateTime : TDateTime;
      FKey : String;
    public
      constructor Create;
      destructor Destroy; override;
      function PropString ( aProp : String ) : TProps; overload;
      function PropString : String; overload;
      function PropInteger ( aProp : Integer ) : TProps; overload;
      function PropInteger : Integer; overload;
      function PropCurrency ( aProp : Currency ) : TProps; overload;
      function PropCurrency : Currency; overload;
      function PropDouble ( aProp : Double ) : TProps; overload;
      function PropDouble : Double; overload;
      function PropValue ( aProp : TValue ) : TProps; overload;
      function PropValue : TValue; overload;
      function PropObject ( aProp : TObject ) : TProps; overload;
      function PropObject : TObject; overload;
      function PropDateTime ( aProp : TDateTime ) : TProps; overload;
      function PropDateTime : TDateTime; overload;
      function Key ( aKey : String ) : TProps; overload;
      function Key : String; overload;
    end;

function GlobalEventBus: IEventBus;

implementation

uses
  EventBus.Core, RTTIUtilsU;

var
  FGlobalEventBus: IEventBus;

  { SubscribeAttribute }

constructor SubscribeAttribute.Create(AThreadMode
  : TThreadMode = TThreadMode.Posting; const AContext: String = '');
begin
  inherited Create;
  FContext := AContext;
  FThreadMode := AThreadMode;
end;

{ TDEBSimpleEvent<T> }

constructor TDEBEvent<T>.Create(AData: T);
begin
  inherited Create;
  DataOwner := true;
  Data := AData;
end;

constructor TDEBEvent<T>.Create;
begin
  inherited Create;
end;

destructor TDEBEvent<T>.Destroy;
var
  LValue: TValue;
begin
  LValue := TValue.From<T>(Data);
  if (LValue.IsObject) and DataOwner then
    LValue.AsObject.Free;
  inherited;
end;

procedure TDEBEvent<T>.SetData(const Value: T);
begin
  FData := Value;
end;

procedure TDEBEvent<T>.SetDataOwner(const Value: Boolean);
begin
  FDataOwner := Value;
end;

function GlobalEventBus: IEventBus;
begin
  if not Assigned(FGlobalEventBus) then
    FGlobalEventBus := TEventBus.Create;
  Result := FGlobalEventBus;
end;

{ TProps }

constructor TProps.Create;
begin

end;

destructor TProps.Destroy;
begin

  inherited;
end;

function TProps.Key(aKey: String): TProps;
begin
  Result := Self;
  FKey := aKey;
end;

function TProps.Key: String;
begin
  Result := FKey;
end;

function TProps.PropCurrency: Currency;
begin
  Result := FPropCurrency;
end;

function TProps.PropDateTime: TDateTime;
begin
  Result := FPropDateTime;
end;

function TProps.PropDateTime(aProp: TDateTime): TProps;
begin
  Result := Self;
  FPropDateTime := aProp;
end;

function TProps.PropDouble: Double;
begin
  Result := FPropDouble;
end;

function TProps.PropDouble(aProp: Double): TProps;
begin
  Result := Self;
  FPropDouble := aProp;
end;

function TProps.PropCurrency(aProp: Currency): TProps;
begin
  Result := Self;
  FPropCurrency := aProp;
end;

function TProps.PropInteger: Integer;
begin
  Result := FPropInteger;
end;

function TProps.PropObject: TObject;
begin
  Result := FPropObject;
end;

function TProps.PropObject(aProp: TObject): TProps;
begin
  Result := Self;
  FPropObject := aProp;
end;

function TProps.PropInteger(aProp: Integer): TProps;
begin
  Result := Self;
  FPropInteger := aProp;
end;

function TProps.PropString(aProp: String): TProps;
begin
  Result := Self;
  FPropString := aProp;
end;

function TProps.PropString: String;
begin
  Result := FPropString;
end;

function TProps.PropValue: TValue;
begin
  Result := FPropValue;
end;

function TProps.PropValue(aProp: TValue): TProps;
begin
  Result := Self;
  FPropValue := aProp;
end;

initialization
  GlobalEventBus;

finalization

end.
