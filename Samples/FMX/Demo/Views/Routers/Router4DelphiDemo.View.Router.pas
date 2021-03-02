unit Router4DelphiDemo.View.Router;

interface

type
  TRouters = class
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

var
  Routers : TRouters;

implementation

uses
  Router4D,
  Router4DelphiDemo.View.Pages.Index,
  Router4DelphiDemo.Views.Layouts.Main,
  Router4DelphiDemo.View.Pages.Cadastros;

{ TRouters }

constructor TRouters.Create;
begin
  TRouter4D.Switch.Router('Home', TPageIndex);
  TRouter4D.Switch.Router('Cadastros', TPageCadastros);
  TRouter4D.Switch.Router('main', TMainLayout);
end;

destructor TRouters.Destroy;
begin

  inherited;
end;

initialization
  Routers := TRouters.Create;

finalization
  Routers.Free;

end.
