unit SimpleDemo.View.Page.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Router4D.Interfaces;

type
  TPagePrincipal = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  PagePrincipal: TPagePrincipal;

implementation

uses
  Router4D,
  Router4D.Props;

{$R *.fmx}

{ TPagePrincipal }

procedure TPagePrincipal.Button1Click(Sender: TObject);
begin
  TRouter4D.Link.&To('Cadastros');
end;

procedure TPagePrincipal.Button2Click(Sender: TObject);
begin
  TRouter4D.Link
    .&To(
      'Cadastros',
      TProps
        .Create
        .PropString(
          'Olá Router4D, Seu Cadastro Recebeu as Props'
        )
        .PropInteger(0)
        .Key('TelaCadastro')
    );
end;

function TPagePrincipal.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TPagePrincipal.UnRender;
begin
  //
end;

end.
