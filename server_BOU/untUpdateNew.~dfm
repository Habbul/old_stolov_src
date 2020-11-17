object frmUpdateNew: TfrmUpdateNew
  Left = 450
  Top = 395
  Width = 455
  Height = 340
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1073#1072#1079#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 447
    Height = 121
    Align = alTop
    Caption = ' '#1060#1072#1081#1083' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103' '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 27
      Height = 13
      Caption = #1055#1091#1090#1100':'
    end
    object Label3: TLabel
      Left = 16
      Top = 56
      Width = 110
      Height = 13
      AutoSize = False
      Caption = #1044#1072#1090#1072' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103':'
    end
    object lDataCreate: TLabel
      Left = 136
      Top = 56
      Width = 129
      Height = 13
      AutoSize = False
      Caption = #1085#1077#1090' '#1076#1072#1085#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 16
      Top = 74
      Width = 110
      Height = 13
      AutoSize = False
      Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1087#1080#1089#1077#1081':'
    end
    object Label6: TLabel
      Left = 16
      Top = 92
      Width = 110
      Height = 13
      AutoSize = False
      Caption = #1044#1072#1085#1085#1099#1077' '#1085#1072' '#1087#1077#1088#1080#1086#1076':'
    end
    object lCount: TLabel
      Left = 136
      Top = 74
      Width = 129
      Height = 13
      AutoSize = False
      Caption = #1085#1077#1090' '#1076#1072#1085#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lPeriod: TLabel
      Left = 136
      Top = 92
      Width = 201
      Height = 13
      AutoSize = False
      Caption = #1085#1077#1090' '#1076#1072#1085#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 64
      Top = 16
      Width = 345
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 408
      Top = 14
      Width = 25
      Height = 25
      Caption = '...'
      TabOrder = 1
      OnClick = Button1Click
    end
    object btnStep1: TButton
      Left = 344
      Top = 72
      Width = 91
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 2
      WordWrap = True
      OnClick = btnStep1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 121
    Width = 447
    Height = 185
    Align = alClient
    Caption = ' '#1057#1090#1072#1090#1091#1089' '
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 52
      Width = 170
      Height = 13
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1086' '#1091#1089#1087#1077#1096#1085#1086'!'
      Visible = False
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 24
      Width = 425
      Height = 17
      Max = 60
      TabOrder = 0
    end
    object mAction: TMemo
      Left = 8
      Top = 72
      Width = 313
      Height = 101
      TabOrder = 1
    end
    object btnClose: TButton
      Left = 344
      Top = 132
      Width = 91
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object Button2: TButton
      Left = 344
      Top = 88
      Width = 89
      Height = 25
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1092#1072#1081#1083' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' (*.dbf)|*.dbf'
    Left = 48
    Top = 192
  end
  object DataSource1: TDataSource
    DataSet = tDBFfrom1C
    Left = 120
    Top = 208
  end
  object qUpdate: TMySQLQuery
    DatabaseName = 'beznal'
    Server = frmSpr.MySQLServer
    Left = 320
    Top = 184
  end
  object tDBFfrom1C: TTable
    TableName = 'SOTR_BSK'
    TableType = ttFoxPro
    Left = 240
    Top = 192
  end
  object qTemp: TMySQLQuery
    Server = frmSpr.MySQLServer
    TableName = 'temp'
    Left = 384
    Top = 184
  end
end
