unit View.Page.Product;

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
  View.Page.Template,
  Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfViewPageProduct = class(TfViewPageTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fViewPageProduct: TfViewPageProduct;

implementation

{$R *.dfm}

end.

