unit Router4D.Switch;

{$I Router4D.inc}

interface

uses
  Classes,
  System.Generics.Collections,
  Router4D.Interfaces,
  Router4D.History;

type
  TRouter4DSwitch = class(TInterfacedObject, iRouter4DSwitch)
    private
      FSideBarList : TDictionary<String, iRouter4DSidebar>;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iRouter4DSwitch;
      function Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True) : iRouter4DSwitch;
      function UnRouter(aPath : String) : iRouter4DSwitch;
      function SidebarAdd ( aPatch : String; aSideBar : iRouter4DSidebar) : iRouter4DSwitch;
      function SideBarList : TDictionary<String, iRouter4DSidebar>;
  end;

implementation

{ TRouter4DSwitch }

uses
  Router4D.Utils;

constructor TRouter4DSwitch.Create;
begin
  FSideBarList := TDictionary<String, iRouter4DSidebar>.Create;
end;

destructor TRouter4DSwitch.Destroy;
begin
  FSideBarList.Free;
  inherited;
end;

class function TRouter4DSwitch.New: iRouter4DSwitch;
begin
    Result := Self.Create;
end;

function TRouter4DSwitch.Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True) : iRouter4DSwitch;
begin
  Result := Self;
  RegisterClass(aRouter);
  Router4DHistory.AddHistory(aPath, aRouter, aSidebarKey, isVisible);
end;

function TRouter4DSwitch.SidebarAdd(aPatch: String;
  aSideBar: iRouter4DSidebar): iRouter4DSwitch;
begin
  Result := Self;
  FSideBarList.Add(aPatch, aSideBar);
end;

function TRouter4DSwitch.SideBarList: TDictionary<String, iRouter4DSidebar>;
begin
  Result := FSideBarList;
end;

function TRouter4DSwitch.UnRouter(aPath: String) : iRouter4DSwitch;
begin
  Result := Self;
  Router4DHistory.RemoveHistory(aPath);
end;

end.
