object fEditPoint: TfEditPoint
  Left = 176
  Top = 114
  BorderStyle = bsDialog
  Caption = #1058#1086#1095#1082#1072' '#1073#1072#1079#1080#1089#1085#1086#1111' '#1089#1110#1090#1082#1080
  ClientHeight = 343
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 13
    Caption = #1058#1086#1095#1082#1072':'
  end
  object Label2: TLabel
    Left = 280
    Top = 16
    Width = 199
    Height = 13
    Caption = #1056#1072#1093#1091#1074#1072#1090#1080' '#1095#1080' '#1073#1091#1076#1091#1074#1072#1090#1080' '#1074#1110#1076#1088#1110#1079#1086#1082#1074#1110#1076' '#1090#1086#1095#1082#1080':'
  end
  object Label7: TLabel
    Left = 16
    Top = 304
    Width = 113
    Height = 13
    Caption = #1055#1077#1088#1096#1072' '#1073#1072#1079#1080#1089#1085#1072' '#1090#1086#1095#1082#1072':'
  end
  object Button1: TButton
    Left = 352
    Top = 296
    Width = 73
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 440
    Top = 296
    Width = 73
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 1
  end
  object edTitle: TEdit
    Left = 16
    Top = 32
    Width = 233
    Height = 28
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Text = 'edTitle'
  end
  object chbSegment: TCheckBox
    Left = 280
    Top = 56
    Width = 161
    Height = 17
    Caption = #1042#1110#1076#1086#1073#1088#1072#1078#1072#1090#1080' '#1074#1110#1076#1088#1110#1079#1086#1082
    TabOrder = 3
  end
  object cbPrePoint: TComboBox
    Left = 280
    Top = 32
    Width = 233
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 4
  end
  object pcPos1: TPageControl
    Left = 16
    Top = 80
    Width = 497
    Height = 201
    ActivePage = TabSheet4
    TabOrder = 5
    object TabSheet4: TTabSheet
      Caption = #1047#1072#1076#1072#1090#1080' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1080
      object Label5: TLabel
        Left = 8
        Top = 8
        Width = 30
        Height = 13
        Caption = 'X, '#1089#1084':'
      end
      object Label6: TLabel
        Left = 8
        Top = 56
        Width = 30
        Height = 13
        Caption = 'Y, '#1089#1084':'
      end
      object Label8: TLabel
        Left = 8
        Top = 104
        Width = 465
        Height = 65
        AutoSize = False
        Caption = 
          '* '#1058#1086#1095#1082#1080' '#1079#1072#1076#1072#1085#1110' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1072#1084#1080' '#1074#1080#1079#1085#1072#1095#1072#1102#1090#1100' '#1086#1082#1088#1077#1084#1080#1081' '#1086#1073#39#1108#1082#1090', '#1076#1083#1103' '#1103#1082#1086#1075#1086 +
          ' '#1084#1086#1078#1085#1072' '#1079#1072#1076#1072#1074#1072#1090#1080' '#1086#1082#1088#1077#1084#1110' '#1076#1086#1076#1072#1090#1082#1086#1074#1110' '#1087#1072#1088#1072#1084#1077#1090#1088#1080', '#1090#1072#1082#1110' '#1103#1082': '#1082#1091#1090' '#1087#1086#1074#1086#1088#1086#1090 +
          #1091', '#1076#1079#1077#1088#1082#1072#1083#1100#1085#1077' '#1074#1110#1076#1086#1073#1088#1072#1078#1077#1085#1085#1103' '#1087#1086'-'#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1110', '#1076#1079#1077#1088#1082#1072#1083#1100#1085#1077' '#1074#1110#1076#1086#1073#1088#1072#1078#1077#1085 +
          #1085#1103' '#1087#1086'-'#1074#1077#1088#1090#1080#1082#1072#1083#1110'. '#1050#1091#1090' '#1087#1086#1074#1086#1088#1086#1090#1091' '#1090#1072' '#1074#1110#1076#1086#1073#1088#1072#1078#1077#1085#1085#1103' '#1085#1077' '#1074#1087#1083#1080#1074#1072#1102#1090#1100' '#1085#1072' '#1088#1086 +
          #1079#1088#1072#1093#1091#1085#1086#1082', '#1072' '#1089#1090#1086#1089#1091#1102#1090#1100#1089#1103' '#1074#1080#1082#1083#1102#1095#1085#1086' '#1074#1110#1079#1091#1072#1083#1110#1079#1072#1094#1110#1111'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label9: TLabel
        Left = 176
        Top = 8
        Width = 69
        Height = 13
        Caption = #1050#1091#1090' '#1087#1086#1074#1086#1088#1086#1090#1091':'
      end
      object Bevel1: TBevel
        Left = 152
        Top = 8
        Width = 9
        Height = 89
        Shape = bsLeftLine
      end
      object Image1: TImage
        Left = 176
        Top = 56
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          07544269746D6170F6000000424DF60000000000000076000000280000001000
          0000100000000100040000000000800000000000000000000000100000000000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC0000000000CCCCCC0FFFFFFFF
          0CCCCCC0FFFFFFFF0CCCCCC0FFFFFFFF0CCCCCC0FFFFFFFF0CCCCCC0FFFFFFFF
          0CCC000000F00F000000CCC0FFFFFFFF0CCCCCC0FFFFFFFF0CCCCCC0FFFFFFFF
          0CCCCCC0FFFFFFFF0CCCCCC0FFFFFFFF0CCCCCC0000000000CCCCCCCCCCCCCCC
          CCCC}
        Transparent = True
      end
      object Image2: TImage
        Left = 176
        Top = 80
        Width = 16
        Height = 16
        AutoSize = True
        Picture.Data = {
          07544269746D6170F6000000424DF60000000000000076000000280000001000
          0000100000000100040000000000800000000000000000000000100000000000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00CCCCCCC0CCCCCCCCCCCCCCC0CCCCCCCCCCCCCCC0CCCCCCCCC00000000000
          00CCC0FFFFF0FFFFF0CCC0FFFFF0FFFFF0CCC0FFFFFFFFFFF0CCC0FFFFF0FFFF
          F0CCC0FFFFF0FFFFF0CCC0FFFFFFFFFFF0CCC0FFFFF0FFFFF0CCC0FFFFF0FFFF
          F0CCC0000000000000CCCCCCCCC0CCCCCCCCCCCCCCC0CCCCCCCCCCCCCCC0CCCC
          CCCC}
        Transparent = True
      end
      object edX: TEdit
        Left = 8
        Top = 24
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'edX'
      end
      object edY: TEdit
        Left = 8
        Top = 72
        Width = 121
        Height = 21
        TabOrder = 1
        Text = 'edY'
      end
      object chbVMirror: TCheckBox
        Left = 200
        Top = 56
        Width = 209
        Height = 17
        Caption = #1042#1110#1076#1086#1073#1088#1072#1079#1080#1090#1080' '#1087#1086'-'#1074#1077#1088#1090#1080#1082#1072#1083#1110
        TabOrder = 2
      end
      object chbHMirror: TCheckBox
        Left = 200
        Top = 80
        Width = 209
        Height = 17
        Caption = #1042#1110#1076#1086#1073#1088#1072#1079#1080#1090#1080' '#1087#1086'-'#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1110
        TabOrder = 3
      end
      object cbObjectAngle: TComboBox
        Left = 176
        Top = 24
        Width = 161
        Height = 21
        ItemHeight = 13
        TabOrder = 4
        Text = 'cbObjectAngle'
        Items.Strings = (
          '0'
          '90'
          '180'
          '270')
      end
    end
    object TabSheet5: TTabSheet
      Caption = #1047#1072#1076#1072#1090#1080' '#1092#1086#1088#1084#1091#1083#1091
      ImageIndex = 1
      object Label4: TLabel
        Left = 8
        Top = 96
        Width = 122
        Height = 13
        Caption = #1056#1086#1079#1088#1072#1093#1091#1085#1082#1086#1074#1072' '#1092#1086#1088#1084#1091#1083#1072':'
      end
      object pcPos2: TPageControl
        Left = 8
        Top = 8
        Width = 465
        Height = 81
        ActivePage = TabSheet6
        TabOrder = 0
        object TabSheet6: TTabSheet
          Caption = #1051#1110#1085#1110#1081#1085#1086
          object Label3: TLabel
            Left = 8
            Top = 8
            Width = 138
            Height = 13
            Caption = #1050#1091#1090' ('#1079#1085#1072#1095#1077#1085#1085#1103' '#1095#1080' '#1092#1086#1088#1084#1091#1083#1072'):'
          end
          object cbAngle: TComboBox
            Left = 8
            Top = 24
            Width = 433
            Height = 24
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ItemHeight = 16
            ItemIndex = 0
            ParentFont = False
            TabOrder = 0
            Text = '0'
            Items.Strings = (
              '0'
              '90'
              '180'
              '270')
          end
        end
        object TabSheet7: TTabSheet
          Caption = #1055#1086'-'#1076#1091#1079#1110
          ImageIndex = 1
        end
      end
      object edFormula: TMemo
        Left = 8
        Top = 112
        Width = 465
        Height = 57
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'edFormula')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object edBasis: TEdit
    Left = 136
    Top = 296
    Width = 121
    Height = 21
    TabStop = False
    Color = clSilver
    ReadOnly = True
    TabOrder = 6
    Text = 'edBasis'
  end
end
