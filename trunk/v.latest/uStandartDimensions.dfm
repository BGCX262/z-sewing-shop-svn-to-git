object fStandartDimensions: TfStandartDimensions
  Left = 149
  Top = 298
  BorderStyle = bsDialog
  Caption = #1056#1086#1079#1084#1110#1088#1085#1072' '#1083#1110#1085#1110#1081#1082#1072
  ClientHeight = 499
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 424
    Width = 189
    Height = 13
    Caption = '* '#1087#1086#1076#1074#1110#1081#1085#1080#1081' '#1082#1083#1110#1082' - '#1088#1077#1076#1072#1075#1091#1074#1072#1085#1085#1103' '#1079#1072#1084#1110#1088#1091
  end
  object tcDimPozn: TTabControl
    Left = 16
    Top = 80
    Width = 529
    Height = 337
    TabOrder = 0
    Tabs.Strings = (
      'XS'
      'S'
      'M'
      'L'
      'XL'
      'XXL')
    TabIndex = 0
    OnChange = tcDimPoznChange
    object lvDimensions: TListView
      Left = 4
      Top = 24
      Width = 521
      Height = 309
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = #1053#1072#1079#1074#1072' '#1084#1110#1088#1082#1080
        end
        item
          Caption = #1055#1086#1079#1085#1072#1095#1077#1085#1085#1103
          Width = 100
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
  end
  object Button1: TButton
    Left = 624
    Top = 456
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1080#1090#1080
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object rgSexList: TRadioGroup
    Left = 16
    Top = 16
    Width = 681
    Height = 49
    Caption = #1057#1090#1072#1090#1100
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      #1095#1086#1083#1086#1074#1110#1095#1110
      #1078#1110#1085#1086#1095#1110)
    TabOrder = 2
    OnClick = rgSexListClick
  end
  object Button6: TButton
    Left = 16
    Top = 456
    Width = 113
    Height = 25
    Caption = #1047#1072#1089#1090#1086#1089#1091#1074#1072#1090#1080' >>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 560
    Top = 192
    Width = 137
    Height = 25
    Caption = #1058#1080#1087#1086#1088#1086#1079#1084#1110#1088#1080
    TabOrder = 4
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 560
    Top = 224
    Width = 137
    Height = 25
    Caption = #1052#1110#1088#1082#1080
    TabOrder = 5
    OnClick = Button8Click
  end
  object Button3: TButton
    Left = 560
    Top = 104
    Width = 137
    Height = 25
    Action = fMain.aSaveSize
    TabOrder = 6
  end
  object Button4: TButton
    Left = 560
    Top = 72
    Width = 137
    Height = 25
    Hint = 'Open|Opens an existing file'
    Caption = #1047#1072#1074#1072#1085#1090#1072#1078#1080#1090#1080' '#1083#1110#1085#1110#1081#1082#1091
    TabOrder = 7
    OnClick = Button4Click
  end
end
