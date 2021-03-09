unit Router4DelphiDemo.View.Pages.Cadastros;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Router4D.Interfaces;

type
  TPageCadastros = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  PageCadastros: TPageCadastros;

implementation

{$R *.fmx}

{ TForm2 }

function TPageCadastros.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TPageCadastros.UnRender;
begin

end;

end.
