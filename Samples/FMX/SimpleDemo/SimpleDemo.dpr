program SimpleDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  SimpleDemo.View.Principal in 'SimpleDemo.View.Principal.pas' {Form2},
  SimpleDemo.View.Page.Principal in 'SimpleDemo.View.Page.Principal.pas' {PagePrincipal},
  SimpleDemo.View.Page.Cadastros in 'SimpleDemo.View.Page.Cadastros.pas' {PageCadastros},
  SimpleDemo.View.Page.Cadastros.Sub in 'SimpleDemo.View.Page.Cadastros.Sub.pas' {SubCadastros},
  SimpleDemo.View.Components.Button01 in 'SimpleDemo.View.Components.Button01.pas' {ComponentButton01};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
