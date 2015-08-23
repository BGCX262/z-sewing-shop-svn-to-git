object fSplines: TfSplines
  Left = 372
  Top = 167
  BorderStyle = bsDialog
  Caption = #1057#1087#1083#1072#1081#1085#1080
  ClientHeight = 385
  ClientWidth = 565
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
  object lvSplines: TListView
    Left = 16
    Top = 16
    Width = 441
    Height = 345
    Columns = <
      item
        AutoSize = True
        Caption = #1050#1088#1080#1074#1072
      end
      item
        Caption = #1042#1080#1076
        Width = 100
      end
      item
        Caption = #1050#1088#1080#1074#1080#1079#1085#1072
        Width = 70
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnEdit: TButton
    Left = 475
    Top = 16
    Width = 75
    Height = 25
    Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080
    TabOrder = 1
    OnClick = btnEditClick
  end
  object Button2: TButton
    Left = 475
    Top = 48
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 475
    Top = 96
    Width = 75
    Height = 25
    Caption = #1042#1080#1076#1072#1083#1080#1090#1080
    TabOrder = 3
    OnClick = Button3Click
  end
end
