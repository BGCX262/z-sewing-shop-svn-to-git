object fEditSegment: TfEditSegment
  Left = 402
  Top = 259
  BorderStyle = bsDialog
  Caption = #1042#1110#1076#1088#1110#1079#1086#1082' '#1073#1072#1079#1080#1089#1085#1086#1111' '#1089#1110#1090#1082#1080
  ClientHeight = 322
  ClientWidth = 360
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
    Top = 16
    Width = 49
    Height = 13
    Caption = #1042#1110#1076' '#1090#1086#1095#1082#1080':'
  end
  object Label1: TLabel
    Left = 192
    Top = 16
    Width = 49
    Height = 13
    Caption = #1044#1086' '#1090#1086#1095#1082#1080':'
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 30
    Height = 13
    Caption = #1064#1072#1088#1080':'
  end
  object cbP1: TComboBox
    Left = 16
    Top = 32
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
  end
  object cbP2: TComboBox
    Left = 192
    Top = 32
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 1
  end
  object Button1: TButton
    Left = 176
    Top = 280
    Width = 75
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 264
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 3
  end
  object clbLayers: TCheckListBox
    Left = 16
    Top = 88
    Width = 321
    Height = 177
    ItemHeight = 13
    TabOrder = 4
  end
end
