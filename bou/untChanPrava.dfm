object frmChangePrava: TfrmChangePrava
  Left = 415
  Top = 391
  Width = 360
  Height = 271
  Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1072#1074#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 55
    Height = 13
    Caption = #1042#1089#1077' '#1087#1088#1072#1074#1072':'
  end
  object Label2: TLabel
    Left = 192
    Top = 16
    Width = 95
    Height = 13
    Caption = #1042#1099#1073#1088#1072#1085#1085#1099#1077' '#1087#1088#1072#1074#1072':'
  end
  object lbAllPrava: TListBox
    Left = 16
    Top = 32
    Width = 137
    Height = 145
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbAllPravaClick
  end
  object lbSelectPrava: TListBox
    Left = 192
    Top = 32
    Width = 137
    Height = 145
    ItemHeight = 13
    TabOrder = 1
    OnClick = lbSelectPravaClick
  end
  object Button1: TButton
    Left = 160
    Top = 200
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 256
    Top = 200
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = Button4Click
  end
  object btnInSelect: TBitBtn
    Left = 160
    Top = 40
    Width = 25
    Height = 25
    Caption = '>'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnInSelectClick
  end
  object btnInAll: TBitBtn
    Left = 160
    Top = 72
    Width = 25
    Height = 25
    Caption = '<'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnInAllClick
  end
  object btnAllInSelect: TBitBtn
    Left = 160
    Top = 112
    Width = 25
    Height = 25
    Caption = '>>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = btnAllInSelectClick
  end
  object btnSelectInAll: TBitBtn
    Left = 160
    Top = 144
    Width = 25
    Height = 25
    Caption = '<<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = btnSelectInAllClick
  end
end
