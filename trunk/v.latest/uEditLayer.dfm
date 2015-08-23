object fEditLayer: TfEditLayer
  Left = 382
  Top = 275
  BorderStyle = bsDialog
  Caption = #1064#1072#1088
  ClientHeight = 167
  ClientWidth = 347
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 37
    Height = 13
    Caption = #1055#1110#1076#1087#1080#1089':'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 30
    Height = 13
    Caption = #1050#1086#1083#1110#1088':'
  end
  object shColor: TShape
    Left = 16
    Top = 80
    Width = 73
    Height = 21
    OnMouseDown = shColorMouseDown
  end
  object Label3: TLabel
    Left = 112
    Top = 64
    Width = 49
    Height = 13
    Caption = #1058#1086#1074#1097#1080#1085#1072':'
  end
  object Button1: TButton
    Left = 168
    Top = 120
    Width = 75
    Height = 25
    Caption = #1043#1072#1088#1072#1079#1076
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 256
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1042#1110#1076#1084#1110#1085#1080#1090#1080
    ModalResult = 2
    TabOrder = 1
  end
  object edTitle: TEdit
    Left = 16
    Top = 32
    Width = 313
    Height = 21
    TabOrder = 2
    Text = 'edTitle'
  end
  object edWidth: TEdit
    Left = 112
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'edWidth'
  end
  object Cd1: TColorDialog
    Left = 80
    Top = 104
  end
end
