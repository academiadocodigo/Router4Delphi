unit Router4D.Helper;

interface

uses
  System.Classes,
	Vcl.ExtCtrls,
	Vcl.Forms,
  Vcl.Controls;

type
	TRouter4DHelper = class helper for TPanel
  public
    procedure RemoveObject; overload;
		procedure AddObject(AValue: TForm);
	end;

implementation

procedure TRouter4DHelper.AddObject(AValue: TForm);
begin
	AValue.Parent := Self;
  AValue.Show;
end;

procedure TRouter4DHelper.RemoveObject;
var
	lIndex: Integer;
begin
	for lIndex := Self.ControlCount - 1 downto 0 do
  begin
    if (Self.Controls[lIndex] is TForm) then
    begin
      (Self.Controls[lIndex] as TForm).Close;
      (Self.Controls[lIndex] as TForm).parent := nil;
    end;
  end;
end;

end.
