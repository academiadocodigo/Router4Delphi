unit View.Page.Template;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Router4D.Interfaces,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Router4D.Props,
  Router4D;

type
  TfViewPageTemplate = class(TForm, IRouter4DComponent)
    pnlBackground: TPanel;
    btnBack: TButton;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    procedure btnBackClick(Sender: TObject);
  private
    function Render: TForm;
    procedure UnRender;
  public
    [Subscribe]
    procedure Props(AValue: TProps);
  end;

var
  fViewPageTemplate: TfViewPageTemplate;

implementation

{$R *.dfm}

{ TfViewPageTemplate }

procedure TfViewPageTemplate.btnBackClick(Sender: TObject);
begin
  TRouter4D.Link.&To('Start');
end;

procedure TfViewPageTemplate.Props(AValue: TProps);
begin
  lblSubtitle.Caption := AValue.PropString;

  AValue.Free;
end;

function TfViewPageTemplate.Render: TForm;
begin
  Result := Self;
end;

procedure TfViewPageTemplate.UnRender;
begin

end;

end.

