program Router4DelphiDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Router4DelphiDemo.View.Principal in 'Views\Router4DelphiDemo.View.Principal.pas' {ViewPrincipal},
  Router4DelphiDemo.Views.Layouts.Main in 'Views\Layouts\Router4DelphiDemo.Views.Layouts.Main.pas' {MainLayout},
  Router4DelphiDemo.View.Components.Sidebar in 'Views\Components\Router4DelphiDemo.View.Components.Sidebar.pas' {ComponentSideBar},
  Router4DelphiDemo.View.Router in 'Views\Routers\Router4DelphiDemo.View.Router.pas',
  Router4DelphiDemo.View.Pages.Index in 'Views\Pages\Router4DelphiDemo.View.Pages.Index.pas' {PageIndex},
  Router4DelphiDemo.View.Pages.Cadastros in 'Views\Pages\Router4DelphiDemo.View.Pages.Cadastros.pas' {PageCadastros};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
