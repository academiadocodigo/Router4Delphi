unit SimpleDemo.View.Components.Button01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  Router4D.Interfaces,
  Router4D.Props;

type
  TComponentButton01 = class(TForm, iRouter4DComponent)
    Layout1: TLayout;
    Line1: TLine;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
    [Subscribe]
    procedure Props ( aValue : TProps);
    function createButton(aLabel : String) : TFMXObject;
  end;

var
  ComponentButton01: TComponentButton01;

implementation

{$R *.fmx}

{ TComponentButton01 }

function TComponentButton01.createButton(aLabel: String): TFMXObject;
begin
  Result := Layout1;
  Label1.Text := aLabel;
  Layout1.Align := TAlignLayout.Left;
  Line1.Visible := False;
  Self.TagString := aLabel;
end;

procedure TComponentButton01.FormCreate(Sender: TObject);
begin
  GlobalEventBus.RegisterSubscriber(Self);
end;

procedure TComponentButton01.Props(aValue: TProps);
begin
  Line1.Visible := False;

  if (aValue.PropString = Label1.Text) and
      (aValue.Key = 'Button01') then
    Line1.Visible := True;

  aValue.Free;
end;

function TComponentButton01.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TComponentButton01.SpeedButton1Click(Sender: TObject);
begin
  Line1.Visible := True;
  GlobalEventBus.Post(
    TProps.Create
      .PropString(Label1.Text)
      .Key('Button01')
  );
end;

procedure TComponentButton01.UnRender;
begin
  //
end;

end.
