unit SimpleDemo.View.Page.Cadastros.Sub;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  Router4D.Interfaces;

type
  TSubCadastros = class(TForm, iRouter4DComponent)
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
  SubCadastros: TSubCadastros;

implementation

uses
  Router4D.History;

{$R *.fmx}

{ TSubCadastros }

function TSubCadastros.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TSubCadastros.UnRender;
begin
  //
end;

end.
