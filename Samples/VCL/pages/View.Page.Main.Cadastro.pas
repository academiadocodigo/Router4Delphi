unit View.Page.Main.Cadastro;

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
  Vcl.ExtCtrls,
  Router4D.Interfaces,
	Vcl.StdCtrls, Router4D, Router4D.Props;

type
  TfViewPageMainCadastro = class(TForm, iRouter4DComponent)
    pnlAll: TPanel;
    btnProduct: TButton;
    btnProductProp: TButton;
    btnCustomer: TButton;
    btnCustomerWithProps: TButton;
    procedure btnProductClick(Sender: TObject);
    procedure btnProductPropClick(Sender: TObject);
    procedure btnCustomerClick(Sender: TObject);
    procedure btnCustomerWithPropsClick(Sender: TObject);
  private
    function Render: TForm;
    procedure UnRender;
  public
    { Public declarations }
  end;

var
  fViewPageMainCadastro: TfViewPageMainCadastro;

implementation

{$R *.dfm}

procedure TfViewPageMainCadastro.btnCustomerClick(Sender: TObject);
begin
	TRouter4D.Link.&To('Customer');
end;

procedure TfViewPageMainCadastro.btnCustomerWithPropsClick(Sender: TObject);
begin
  TRouter4D.Link
		.&To(
			'Customer',
			TProps
				.Create
				.PropString(
					'Olá Customer, Seu Cadastro Recebeu as Props'
				)
				.Key('TelaCadastro')
		);
end;

procedure TfViewPageMainCadastro.btnProductClick(Sender: TObject);
begin
	TRouter4D.Link.&To('Product');
end;

procedure TfViewPageMainCadastro.btnProductPropClick(Sender: TObject);
begin
	TRouter4D.Link
		.&To(
			'Product',
			TProps
				.Create
				.PropString(
					'Olá Product, Seu Cadastro Recebeu as Props'
				)
				.Key('TelaCadastro')
		);
end;

function TfViewPageMainCadastro.Render: TForm;
begin
	Result := Self;
end;

procedure TfViewPageMainCadastro.UnRender;
begin

end;

end.

