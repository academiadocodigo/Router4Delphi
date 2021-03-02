unit SimpleDemo.View.Page.Cadastros;

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
  FMX.Layouts,
  Router4D.Interfaces,
  Router4D.Props, FMX.Edit, FMX.Objects;

type
  TPageCadastros = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Layout2: TLayout;
    Layout3: TLayout;
    Rectangle1: TRectangle;
    Layout4: TLayout;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CreateMenuSuperior;
    procedure CreateRouters;
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
    [Subscribe]
    procedure Props ( aValue : TProps);
  end;

var
  PageCadastros: TPageCadastros;

implementation

uses
  Router4D, SimpleDemo.View.Page.Cadastros.Sub, SimpleDemo.View.Page.Principal,
  SimpleDemo.View.Components.Button01;

{$R *.fmx}

{ TPageCadastros }

procedure TPageCadastros.Button1Click(Sender: TObject);
begin
  TRouter4D.Link.&To('Inicio');
end;

procedure TPageCadastros.FormCreate(Sender: TObject);
begin
  CreateRouters;
  CreateMenuSuperior;
end;

procedure TPageCadastros.Props(aValue: TProps);
begin
  if (aValue.PropString <> '') and (aValue.Key = 'TelaCadastro') then
    Label1.Text := aValue.PropString;

  aValue.Free;
end;

procedure TPageCadastros.CreateRouters;
begin
  TRouter4D.Switch.Router('Clientes', TPagePrincipal, 'cadastros');
  TRouter4D.Switch.Router('Fornecedores', TSubCadastros, 'cadastros');
  TRouter4D.Switch.Router('Produtos', TSubCadastros, 'cadastros');
end;

procedure TPageCadastros.CreateMenuSuperior;
begin
  Layout4.AddObject(
    TComponentButton01.Create(Self)
    .createButton('Clientes')
  );

  Layout4.AddObject(
    TComponentButton01.Create(Self)
    .createButton('Produtos')
  );

  Layout4.AddObject(
    TComponentButton01.Create(Self)
    .createButton('Fornecedores')
  );
end;

function TPageCadastros.Render: TFMXObject;
begin
  Label1.Text := 'Cadastros';
  Result := Layout1;
end;

procedure TPageCadastros.UnRender;
begin
  //
end;

end.
