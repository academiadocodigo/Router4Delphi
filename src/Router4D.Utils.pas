unit Router4D.Utils;

{$I Router4D.inc}

interface

uses
  System.Rtti,
  Router4D.Props,
  SysUtils,
  Classes;

type
  TRouter4DUtils = class
    private
    public
      class function CreateInstance<T> : T;
  end;

   TNotifyEventWrapper = class(TComponent)
  private
    FProc: TProc<TObject, String>;
    FAux : String;
  public
    constructor Create(Owner: TComponent; Proc: TProc<TObject, String>; Aux : String = ''); reintroduce;
    class function AnonProc2NotifyEvent(Owner: TComponent; Proc: TProc<TObject, String>; Aux : String = ''): TNotifyEvent;
  published
    procedure Event(Sender: TObject);
  end;

implementation

{ TRouter4DUtils }

class function TRouter4DUtils.CreateInstance<T>: T;
var
  AValue: TValue;
  ctx: TRttiContext;
  rType: TRttiType;
  AMethCreate: TRttiMethod;
  instanceType: TRttiInstanceType;
begin
  ctx := TRttiContext.Create;
  rType := ctx.GetType(TypeInfo(T));
  for AMethCreate in rType.GetMethods do
  begin
    if (AMethCreate.IsConstructor) and (Length(AMethCreate.GetParameters) = 1) then
    begin
      instanceType := rType.AsInstance;
      AValue := AMethCreate.Invoke(instanceType.MetaclassType, [nil]);
      Result := AValue.AsType<T>;

      try
        GlobalEventBus.RegisterSubscriber(AValue.AsType<TObject>);
      except

      end;

      Exit;
    end;
  end;

end;

{ TNotifyEventWrapper }

class function TNotifyEventWrapper.AnonProc2NotifyEvent(Owner: TComponent; Proc: TProc<TObject, String>; Aux : String = ''): TNotifyEvent;
begin
  Result := Self.Create(Owner, Proc, Aux).Event;
end;

constructor TNotifyEventWrapper.Create(Owner: TComponent; Proc: TProc<TObject, String>; Aux : String = '');
begin
   inherited Create(Owner);
   FProc := Proc;
   FAux := Aux;
end;

procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FProc(Sender, FAux);
end;

end.
