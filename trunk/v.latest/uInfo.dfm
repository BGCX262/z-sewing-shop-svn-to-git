object fInfo: TfInfo
  Left = 355
  Top = 321
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1072#1083#1100#1085#1072' '#1110#1085#1092#1086#1088#1084#1072#1094#1110#1103
  ClientHeight = 500
  ClientWidth = 615
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 67
    Width = 32
    Height = 13
    Caption = #1057#1090#1072#1090#1100':'
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 35
    Height = 13
    Caption = #1053#1072#1079#1074#1072':'
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 50
    Height = 13
    Caption = #1055#1088#1080#1084#1110#1090#1082#1080':'
  end
  object Image1: TImage
    Left = 296
    Top = 32
    Width = 300
    Height = 400
    Center = True
    Proportional = True
    Stretch = True
  end
  object Button1: TButton
    Left = 440
    Top = 456
    Width = 75
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 526
    Top = 456
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 1
  end
  object edTitle: TEdit
    Left = 16
    Top = 32
    Width = 257
    Height = 21
    TabOrder = 2
    Text = 'edTitle'
  end
  object cbSex: TComboBox
    Left = 16
    Top = 80
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'cbSex'
  end
  object edDescr: TEdit
    Left = 16
    Top = 128
    Width = 257
    Height = 21
    TabOrder = 4
    Text = 'edDescr'
  end
end
