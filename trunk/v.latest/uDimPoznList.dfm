object fDimPoznList: TfDimPoznList
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #1055#1086#1079#1085#1072#1095#1077#1085#1085#1103' '#1084#1110#1088#1086#1082
  ClientHeight = 451
  ClientWidth = 508
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
    Top = 16
    Width = 44
    Height = 13
    Caption = #1056#1086#1079#1084#1110#1088#1080':'
  end
  object cbSizes: TComboBox
    Left = 16
    Top = 32
    Width = 473
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 0
    OnChange = cbSizesChange
  end
  object lvDimensions: TListView
    Left = 16
    Top = 72
    Width = 385
    Height = 329
    Columns = <
      item
        AutoSize = True
        Caption = #1053#1072#1079#1074#1072' '#1084#1110#1088#1082#1080
      end
      item
        Caption = #1055#1086#1079#1085#1072#1095#1077#1085#1085#1103
        Width = 100
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Button2: TButton
    Left = 416
    Top = 416
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1047#1072#1082#1088#1080#1090#1080
    ModalResult = 2
    TabOrder = 2
  end
  object Button3: TButton
    Left = 416
    Top = 104
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080
    TabOrder = 3
    OnClick = Button3Click
  end
  object btnEdit: TButton
    Left = 416
    Top = 72
    Width = 75
    Height = 25
    Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080
    TabOrder = 4
    OnClick = btnEditClick
  end
  object Button5: TButton
    Left = 416
    Top = 144
    Width = 75
    Height = 25
    Caption = #1042#1080#1076#1072#1083#1080#1090#1080
    TabOrder = 5
    OnClick = Button5Click
  end
end
