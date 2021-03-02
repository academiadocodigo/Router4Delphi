unit Router4DelphiDemo.View.Components.Sidebar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TComponentSideBar = class(TForm)
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    Rectangle1: TRectangle;
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ComponentSideBar: TComponentSideBar;

implementation

uses
  Router4D;

{$R *.fmx}

procedure TComponentSideBar.ListBox1Click(Sender: TObject);
begin
   TRouter4D.Link.&To(ListBox1.Items[ListBox1.ItemIndex])
end;

end.
