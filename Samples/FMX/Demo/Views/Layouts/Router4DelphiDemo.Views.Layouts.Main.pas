unit Router4DelphiDemo.Views.Layouts.Main;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  Router4D.Interfaces, FMX.Objects;

type
  TMainLayout = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    LayoutIndex: TLayout;
    Rectangle1: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
     function Render : TFMXObject;
     procedure UnRender;
  end;

var
  MainLayout: TMainLayout;

implementation

uses
  Router4DelphiDemo.View.Pages.Index,
  Router4D,
  Router4DelphiDemo.View.Components.Sidebar;

{$R *.fmx}

{ TMainLayout }

function TMainLayout.Render: TFMXObject;
begin
  Result := LayoutIndex;
  TRouter4D.Render<TPageIndex>.SetElement(Layout3);

  Layout2.RemoveObject(0);
  Layout2.AddObject(
    TComponentSideBar.Create(Self).Layout1
  )
end;

procedure TMainLayout.UnRender;
begin

end;

end.
