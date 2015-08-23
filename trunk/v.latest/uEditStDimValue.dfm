object fEditStDimValue: TfEditStDimValue
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #1047#1085#1072#1095#1077#1085#1085#1103' '#1079#1072#1084#1110#1088#1091
  ClientHeight = 162
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 62
    Height = 13
    Caption = #1058#1080#1087#1086#1088#1086#1079#1084#1110#1088':'
  end
  object lbTypeRozm: TLabel
    Left = 88
    Top = 40
    Width = 70
    Height = 13
    Caption = 'lbTypeRozm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDimPozn: TLabel
    Left = 16
    Top = 64
    Width = 50
    Height = 13
    Caption = 'lbDimPozn'
  end
  object lbSexType: TLabel
    Left = 88
    Top = 16
    Width = 60
    Height = 13
    Caption = 'lbSexType'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 22
    Height = 13
    Caption = #1058#1080#1087':'
  end
  object edValue: TEdit
    Left = 16
    Top = 80
    Width = 289
    Height = 21
    TabOrder = 0
    Text = 'edValue'
  end
  object Button1: TButton
    Left = 152
    Top = 120
    Width = 75
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 234
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 2
  end
end
