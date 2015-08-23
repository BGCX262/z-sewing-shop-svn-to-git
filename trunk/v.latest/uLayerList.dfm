object fLayerList: TfLayerList
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = #1064#1072#1088#1080
  ClientHeight = 371
  ClientWidth = 515
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
  object lvLayers: TListView
    Left = 16
    Top = 16
    Width = 385
    Height = 329
    Columns = <
      item
        AutoSize = True
        Caption = #1064#1072#1088
      end
      item
        Caption = #1050#1086#1083#1110#1088
        Width = 80
      end
      item
        Caption = #1058#1086#1074#1097#1080#1085#1072
        Width = 80
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawSubItem = lvLayersCustomDrawSubItem
    OnDblClick = lvLayersDblClick
  end
  object Button3: TButton
    Left = 416
    Top = 48
    Width = 75
    Height = 25
    Caption = #1044#1086#1076#1072#1090#1080
    TabOrder = 1
    OnClick = Button3Click
  end
  object btnEdit: TButton
    Left = 416
    Top = 16
    Width = 75
    Height = 25
    Caption = #1056#1077#1076#1072#1075#1091#1074#1072#1090#1080
    TabOrder = 2
    OnClick = btnEditClick
  end
  object Button5: TButton
    Left = 416
    Top = 88
    Width = 75
    Height = 25
    Caption = #1042#1080#1076#1072#1083#1080#1090#1080
    TabOrder = 3
    OnClick = Button5Click
  end
end
