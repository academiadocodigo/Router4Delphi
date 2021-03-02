program Router;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fMain},
  View.Page.Main.Cadastro in 'pages\View.Page.Main.Cadastro.pas' {fViewPageMainCadastro},
  View.Page.Template in 'pages\View.Page.Template.pas' {fViewPageTemplate},
  View.Page.Product in 'pages\View.Page.Product.pas' {fViewPageProduct},
  View.Page.Customer in 'pages\View.Page.Customer.pas' {fViewPageCustomer};

{$R *.res}

begin
	ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
