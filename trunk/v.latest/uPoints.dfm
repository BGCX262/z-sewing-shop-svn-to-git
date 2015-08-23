object fPoints: TfPoints
  Left = 286
  Top = 182
  BorderStyle = bsDialog
  Caption = #1058#1086#1095#1082#1080' '#1073#1072#1079#1080#1089#1085#1086#1111' '#1089#1110#1090#1082#1080
  ClientHeight = 393
  ClientWidth = 495
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
  object lvPoints: TListView
    Left = 16
    Top = 16
    Width = 369
    Height = 361
    Columns = <
      item
        AutoSize = True
        Caption = #1058#1086#1095#1082#1072
      end
      item
        Alignment = taRightJustify
        Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1080' X, '#1089#1084
        Width = 120
      end
      item
        Alignment = taRightJustify
        Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1080' Y, '#1089#1084
        Width = 120
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvPointsDblClick
  end
  object btnEdit: TButton
    Left = 403
    Top = 16
    Width = 75
    Height = 25
    Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080
    TabOrder = 1
    OnClick = btnEditClick
  end
  object Button2: TButton
    Left = 403
    Top = 48
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080' (f)'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 403
    Top = 128
    Width = 75
    Height = 25
    Caption = #1042#1080#1076#1072#1083#1080#1090#1080
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 403
    Top = 80
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080' (XY)'
    TabOrder = 4
    OnClick = Button4Click
  end
end
