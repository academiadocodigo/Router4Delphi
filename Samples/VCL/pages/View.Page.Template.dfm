object fViewPageTemplate: TfViewPageTemplate
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'fViewPageTemplate'
  ClientHeight = 463
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 715
    Height = 463
    Align = alClient
    TabOrder = 0
    DesignSize = (
      715
      463)
    object lblTitle: TLabel
      Left = 16
      Top = 24
      Width = 142
      Height = 33
      Caption = 'Cadastro de'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 16
      Top = 67
      Width = 70
      Height = 19
      Caption = 'lblSubtitle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnBack: TButton
      Left = 16
      Top = 415
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Voltar'
      TabOrder = 0
      OnClick = btnBackClick
    end
  end
end
