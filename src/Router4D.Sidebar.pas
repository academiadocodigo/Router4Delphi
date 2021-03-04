unit Router4D.Sidebar;

{$I Router4D.inc}

interface

{$IFDEF HAS_FMX}
uses
  Classes,
  SysUtils,
  FMX.Types,
  FMX.ListBox,
  FMX.SearchBox,
  FMX.Layouts,
  Router4D.Interfaces,
  System.UITypes;

type
  TRouter4DSidebar = class(TInterfacedObject, iRouter4DSidebar)
    private
      FName : String;
      FMainContainer : TFMXObject;
      FLinkContainer : TFMXObject;
      FAnimation : TProc<TFMXObject>;
      FFontSize : Integer;
      FFontColor : TAlphaColor;
      FItemHeigth : Integer;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iRouter4DSidebar;
      function Animation ( aAnimation : TProc<TFMXObject> ) : iRouter4DSidebar;
      function MainContainer ( aValue : TFMXObject ) : iRouter4DSidebar; overload;
      function MainContainer  : TFMXObject; overload;
      function LinkContainer ( aValue : TFMXObject ) : iRouter4DSidebar;
      function RenderToListBox : iRouter4DSidebar;
      function Name ( aValue : String ) : iRouter4DSidebar; overload;
      function Name  : String; overload;
      function FontSize ( aValue : Integer ) : iRouter4DSidebar;
      function FontColor ( aValue : TAlphaColor ) : iRouter4DSidebar;
      function ItemHeigth ( aValue : Integer ) : iRouter4DSidebar;
  end;

implementation

uses
  Router4D,
  Router4D.History,
  Router4D.Utils;

{ TRouter4DSidebar }

function TRouter4DSidebar.Animation(
  aAnimation: TProc<TFMXObject>): iRouter4DSidebar;
begin
  Result := Self;
  FAnimation := aAnimation;
end;

function TRouter4DSidebar.LinkContainer(aValue: TFMXObject): iRouter4DSidebar;
begin
  Result := Self;
  FLinkContainer := aValue;
end;

function TRouter4DSidebar.MainContainer(aValue: TFMXObject): iRouter4DSidebar;
begin
  Result := Self;
  FMainContainer := aValue;
end;

function TRouter4DSidebar.MainContainer: TFMXObject;
begin
  Result := FMainContainer;
end;

function TRouter4DSidebar.RenderToListBox: iRouter4DSidebar;
var
  aListBox : TListBox;
  aListBoxItem : TListBoxItem;
  AListBoxSearch : TSearchBox;
  aItem : TCachePersistent;
begin
  aListBox := TListBox.Create(FMainContainer);
  aListBox.Align := TAlignLayout.Client;

  aListBox.StyleLookup := 'transparentlistboxstyle';

  aListBox.BeginUpdate;

  AListBoxSearch := TSearchBox.Create(aListBox);
  AListBoxSearch.Height := FItemHeigth - 25;
  aListBox.ItemHeight := FItemHeigth;

  aListBox.AddObject(AListBoxSearch);

  for aItem in Router4DHistory.RoutersListPersistent.Values do
  begin
    if AItem.FisVisible and (AItem.FSBKey = FName) then
    begin
      aListBoxItem := TListBoxItem.Create(aListBox);
      aListBoxItem.Parent := aListBox;
      aListBoxItem.StyledSettings:=[TStyledSetting.Other];
      aListBoxItem.TextSettings.Font.Size := FFontSize;
      aListBoxItem.FontColor := FFontColor;
      aListBoxItem.Text := aItem.FPatch;
      aListBox.AddObject(aListBoxItem);
    end;
  end;
  aListBox.EndUpdate;


  Router4DHistory.AddHistoryConteiner(FName, FLinkContainer);

  aListBox.OnClick :=

  TNotifyEventWrapper
    .AnonProc2NotifyEvent(
      aListBox,
      procedure(Sender: TObject; Aux : String)
      begin
        TRouter4D
        .Link
          .Animation(
            procedure ( aObject : TFMXObject )
            begin
              TLayout(aObject).Opacity := 0;
              TLayout(aObject).AnimateFloat('Opacity', 1, 0.2);
            end)
          .&To(
            (Sender as TListBox).Items[(Sender as TListBox).ItemIndex],
            Aux
          )
      end,
      FName
    );

  FMainContainer.AddObject(aListBox);
end;

constructor TRouter4DSidebar.Create;
begin
  FName := 'SBIndex';
  FLinkContainer := Router4DHistory.MainRouter;
end;

destructor TRouter4DSidebar.Destroy;
begin

  inherited;
end;

function TRouter4DSidebar.FontColor(aValue: TAlphaColor): iRouter4DSidebar;
begin
  Result := Self;
  FFontColor := aValue;
end;

function TRouter4DSidebar.FontSize(aValue: Integer): iRouter4DSidebar;
begin
  Result := Self;
  FFontSize := aValue;
end;

function TRouter4DSidebar.ItemHeigth(aValue: Integer): iRouter4DSidebar;
begin
  Result := Self;
  FItemHeigth := aValue;
end;

function TRouter4DSidebar.Name(aValue: String): iRouter4DSidebar;
begin
  Result := Self;
  FName := aValue;
end;

function TRouter4DSidebar.Name: String;
begin
  Result := FName;
end;

class function TRouter4DSidebar.New: iRouter4DSidebar;
begin
    Result := Self.Create;
end;
{$ELSE}
implementation
{$ENDIF}

end.
