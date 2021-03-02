unit SimpleDemo.View.Principal;

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
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ListBox,
  FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.SearchBox, FMX.MultiView;

type
  TForm2 = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Layout5: TLayout;
    procedure FormShow(Sender: TObject);
  private
    procedure RegisterRouters;
    procedure createSideBar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  Router4D,
  SimpleDemo.View.Page.Cadastros,
  SimpleDemo.View.Page.Principal;

{$R *.fmx}

procedure TForm2.FormShow(Sender: TObject);
begin
  RegisterRouters;
  TRouter4D.Render<TPagePrincipal>.SetElement(Layout4, Layout1);
end;

procedure TForm2.RegisterRouters;
begin
  TRouter4D.Switch.Router('Inicio', TPagePrincipal);
  TRouter4D.Switch.Router('Cadastros', TPageCadastros);
  TRouter4D.Switch.Router('Configuracoes', TPageCadastros);
  createSideBar;
end;

procedure TForm2.createSideBar;
begin
  TRouter4D
    .SideBar
      .MainContainer(Layout5)
      .LinkContainer(Layout4)
      .FontSize(15)
      .FontColor(4294967295)
      .ItemHeigth(60)
    .RenderToListBox;
end;

end.
