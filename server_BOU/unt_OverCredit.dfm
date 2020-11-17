object Frm_OverCredit: TFrm_OverCredit
  Left = 274
  Top = 417
  Width = 603
  Height = 503
  Caption = #1055#1088#1077#1074#1099#1096#1077#1085#1080#1077' '#1082#1088#1077#1076#1080#1090#1072' '#1079#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 569
    Height = 73
    Caption = #1042#1099#1073#1086#1088
    Items.Strings = (
      #1047#1072' '#1090#1077#1082#1091#1097#1080#1081' '#1084#1077#1089#1103#1094
      #1047#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076)
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object BitBtn_show: TBitBtn
    Left = 288
    Top = 96
    Width = 75
    Height = 25
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 0
    OnClick = BitBtn_showClick
  end
  object DateTimePicker_begin: TDateTimePicker
    Left = 264
    Top = 48
    Width = 97
    Height = 21
    Date = 40015.539054131940000000
    Time = 40015.539054131940000000
    TabOrder = 2
  end
  object DateTimePicker_end: TDateTimePicker
    Left = 456
    Top = 48
    Width = 89
    Height = 21
    Date = 40015.539126319450000000
    Time = 40015.539126319450000000
    TabOrder = 3
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 128
    Width = 577
    Height = 345
    DefaultColWidth = 150
    DefaultRowHeight = 18
    TabOrder = 4
  end
  object BitBtn_stopList: TBitBtn
    Left = 384
    Top = 96
    Width = 185
    Height = 25
    Caption = #1047#1072#1085#1077#1089#1090#1080' '#1074' '#1095#1077#1088#1085#1099#1081' '#1089#1087#1080#1089#1086#1082
    TabOrder = 5
    OnClick = BitBtn_stopListClick
  end
  object Query_temp: TMySQLQuery
    Server = frmSpr.MySQLServer
    Left = 488
    Top = 16
  end
  object Query_temp1: TMySQLQuery
    Server = frmSpr.MySQLServer
    Left = 520
    Top = 16
  end
end
