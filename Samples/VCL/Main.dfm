object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'fMain'
  ClientHeight = 678
  ClientWidth = 1178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 1178
    Height = 678
    Align = alClient
    TabOrder = 0
    object pnlMain: TPanel
      Left = 1
      Top = 1
      Width = 192
      Height = 676
      Align = alLeft
      TabOrder = 0
    end
    object pnlEmbed: TPanel
      Left = 193
      Top = 1
      Width = 984
      Height = 676
      Align = alClient
      TabOrder = 1
    end
  end
end
