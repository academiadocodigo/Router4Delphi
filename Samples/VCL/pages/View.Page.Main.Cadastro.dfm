object fViewPageMainCadastro: TfViewPageMainCadastro
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'fViewPageMainCadastro'
  ClientHeight = 484
  ClientWidth = 799
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlAll: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 484
    Align = alClient
    TabOrder = 0
    object btnProduct: TButton
      Left = 24
      Top = 32
      Width = 153
      Height = 25
      Caption = 'Product'
      TabOrder = 0
      OnClick = btnProductClick
    end
    object btnProductProp: TButton
      Left = 24
      Top = 63
      Width = 153
      Height = 25
      Caption = 'Product With Prop'
      TabOrder = 1
      OnClick = btnProductPropClick
    end
    object btnCustomer: TButton
      Left = 24
      Top = 104
      Width = 153
      Height = 25
      Caption = 'Customer'
      TabOrder = 2
      OnClick = btnCustomerClick
    end
    object btnCustomerWithProps: TButton
      Left = 24
      Top = 135
      Width = 153
      Height = 25
      Caption = 'Customer With Prop'
      TabOrder = 3
      OnClick = btnCustomerWithPropsClick
    end
  end
end
