unit Router4DelphiDemo.View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts;

type
  TViewPrincipal = class(TForm)
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Animation( aLayout : TFMXObject );
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Router4D,
  Router4DelphiDemo.Views.Layouts.Main,
  Router4DelphiDemo.View.Router;

{$R *.fmx}

procedure TViewPrincipal.Animation(aLayout: TFMXObject);
begin
  TLayout(aLayout).Opacity := 0;
  TLayout(aLayout).AnimateFloat('Opacity', 1, 0.9);
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  TRouter4D.Render<TMainLayout>.SetElement(Layout1, Layout1);
  TRouter4D.Link.Animation(Animation);
end;

end.
