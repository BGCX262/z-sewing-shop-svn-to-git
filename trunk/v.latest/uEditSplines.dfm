object fEditSpline: TfEditSpline
  Left = 146
  Top = 177
  BorderStyle = bsDialog
  Caption = #1042#1110#1076#1088#1110#1079#1082#1080', '#1083#1072#1084#1072#1085#1110', '#1089#1087#1083#1072#1081#1085#1080
  ClientHeight = 404
  ClientWidth = 455
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
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 171
    Height = 13
    Caption = #1042#1074#1077#1076#1110#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1095#1086#1082' '#1095#1077#1088#1077#1079' '#1082#1086#1084#1091':'
  end
  object Label3: TLabel
    Left = 16
    Top = 176
    Width = 30
    Height = 13
    Caption = #1064#1072#1088#1080':'
  end
  object Button1: TButton
    Left = 272
    Top = 360
    Width = 75
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 360
    Top = 360
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 1
  end
  object clbLayers: TCheckListBox
    Left = 16
    Top = 192
    Width = 417
    Height = 145
    ItemHeight = 13
    TabOrder = 2
  end
  object edPoints: TEdit
    Left = 16
    Top = 32
    Width = 417
    Height = 21
    TabOrder = 3
    Text = 'edPoints'
  end
  object rgLineType: TRadioGroup
    Left = 16
    Top = 64
    Width = 81
    Height = 89
    Items.Strings = (
      #1083#1072#1084#1072#1085#1072
      #1089#1087#1083#1072#1081#1085)
    TabOrder = 4
    OnClick = rgLineTypeClick
  end
  object gbTension: TGroupBox
    Left = 112
    Top = 64
    Width = 321
    Height = 89
    Caption = #1050#1088#1080#1074#1080#1079#1085#1072
    TabOrder = 5
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 47
      Height = 13
      Caption = '0 ('#1087#1088#1103#1084#1072')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 88
      Top = 24
      Width = 113
      Height = 13
      Caption = '0.5 ('#1087#1086'-'#1079#1072#1084#1086#1074#1095#1091#1074#1072#1085#1085#1102')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 298
      Top = 24
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object tbTension: TTrackBar
      Left = 8
      Top = 40
      Width = 305
      Height = 45
      Max = 20
      Position = 5
      TabOrder = 0
    end
  end
end
