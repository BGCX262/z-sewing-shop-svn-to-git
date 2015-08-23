object fDimensions: TfDimensions
  Left = 372
  Top = 236
  BorderStyle = bsDialog
  Caption = #1052#1110#1088#1082#1080
  ClientHeight = 387
  ClientWidth = 614
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
  object lvDimensions: TListView
    Left = 16
    Top = 16
    Width = 473
    Height = 345
    Columns = <
      item
        AutoSize = True
        Caption = #1053#1072#1079#1074#1072' '#1084#1110#1088#1082#1080
      end
      item
      end
      item
        Alignment = taRightJustify
        Caption = #1042#1077#1083#1080#1095#1080#1085#1072', '#1089#1084
        Width = 90
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvDimensionsDblClick
  end
  object btnEdit: TButton
    Left = 512
    Top = 16
    Width = 75
    Height = 25
    Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080
    TabOrder = 1
    OnClick = btnEditClick
  end
  object Button2: TButton
    Left = 512
    Top = 48
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 512
    Top = 96
    Width = 75
    Height = 25
    Caption = #1042#1080#1076#1072#1083#1080#1090#1080
    TabOrder = 3
    OnClick = Button3Click
  end
end
