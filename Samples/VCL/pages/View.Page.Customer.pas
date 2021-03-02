unit View.Page.Customer;

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
  TfViewPageCustomer = class(TfViewPageTemplate)
    edt1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fViewPageCustomer: TfViewPageCustomer;

implementation

{$R *.dfm}

end.

