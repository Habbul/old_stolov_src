object frmSaleOfDay: TfrmSaleOfDay
  Left = 394
  Top = 269
  Width = 482
  Height = 427
  Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
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
  object Panel2: TPanel
    Left = 0
    Top = 330
    Width = 474
    Height = 63
    Align = alBottom
    TabOrder = 0
    object btnExit: TBitBtn
      Left = 304
      Top = 5
      Width = 153
      Height = 49
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnExitClick
      Glyph.Data = {
        76020000424D7602000000000000760000002800000020000000200000000100
        0400000000000002000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF88FFF88F
        FF88FFF000FF88FFFFFFFF8FFF88FFF88FFF88F0EE0FFF88FFFFFFF88FFF88FF
        F88FFF80EE608FFF88FF88FFF88FFF88FFF88FF0EE66088FFF88FF88FFF88FFF
        88FFF880EE6660F88FFF8FFF88FFF88FFF88FFF0EE66660FF88F000000000000
        0FFF88F0EE6666600000FFFFFFFFFFFF088FFF80EE66666078FFFFFFFFFFFFFF
        0FF88FF0EE66666078FFFFFFFFFFFF8F00000000EE66666078FFFFFFFFFFF088
        07777770EE66666078FFFFFFFFFFF00807777770EE66666078FFFFFFFFFFF060
        07777770EE66666078FFFFFFFFFFF06607777770EE60066078FFFFFF888880E6
        60777770EE07066078FFFFF8888880EE66077770EE0F066078FFFF00000000EE
        E6607770EE60066078FFF066666666EEEE660770EE66666078FFF0EEEEEEEEEE
        EEE66070EE66666078FFF0EEFFFFFFFFFFEE6070EE66666078FFF0EEEEEEEEEE
        FEE60770EE66666078FFFF00000000EFEE607770EE66666078FFFFFFFFFFF0EE
        E6077770EE66666078FFFFFFFFFFF0EE60777770EE66666078FFFFFFFFFFF0E6
        07777770EE66666078FFFFFFFFFFF060077777770EE6666078FFFFFFFFFFF00F
        0777777770EE666078FFFFFFFFFFFFFF07777777770EE66078FFFFFFFFFFFFFF
        077777777770EE6078FFFFFFFFFFFFFF0777777777770EE07FFFFFFFFFFFFFFF
        0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Spacing = 10
    end
    object btnSaleOfDay: TBitBtn
      Left = 16
      Top = 6
      Width = 153
      Height = 49
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      WordWrap = True
      OnClick = btnSaleOfDayClick
      Glyph.Data = {
        76020000424D7602000000000000760000002800000020000000200000000100
        0400000000000002000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888777777777
        7777777777777777888888000000000000000000000000078888880FFFFFFF7F
        FFFFFF7FFFFFFF078888880FFFFFFF7FFFFFFF7FFFFFFF078888880FFFFFFF7F
        FFFFFF7FFFFFFF07888888077777777777707777777777078888880FFFFFFF7F
        FFFF007FFFFFFF078888880FFFFFFF7FFFFF0B008FFFFF078888880FFFFFFF7F
        FFFFF07708FFFF078888880777777777777770BB707777078888880FFFFFFF7F
        FFFFFF0FB708FF0788888808888888788888FF70FB708F078888880000000000
        00088F7F0FB7080088888066666666666660777770FB7007088880E006006006
        00608F7FFF0F0807808880EE06E06E06E0608F7FFFF0FB70880880E666666666
        66608F7FFFFF0FB7080880E00600600600607777777770FB700880EE06E06E06
        E0608F7FFFFFFF0FB70880E66666666666608F7FFFFFFF00F00880E006006006
        00608F7FFFFFFF0700F080EE06E06E06E060777777777707880080E666666666
        66608F7FFFFFFF07888880E00600600600608F7FFFFFFF07888880EE06E06E06
        E0608F7FFFFFFF07888880E6666666666660000000000008888880E666666666
        6660788888888888888880E08FFFFFFFF060788888888888888880E088888888
        8060788888888888888880E0000000000060788888888888888880EEEEEEEEEE
        EE60888888888888888888000000000000088888888888888888}
    end
    object Button1: TButton
      Left = 192
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 2
      Visible = False
      OnClick = Button1Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 474
    Height = 330
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 0
      Top = 182
      Width = 474
      Height = 16
      Cursor = crVSplit
      Align = alBottom
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 474
      Height = 112
      Align = alClient
      Caption = ' '#1055#1077#1088#1080#1086#1076' '
      TabOrder = 0
      object rbDay: TRadioButton
        Left = 24
        Top = 32
        Width = 97
        Height = 17
        Caption = #1047#1072' '#1076#1077#1085#1100
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbDayClick
      end
      object rbPeriod: TRadioButton
        Left = 24
        Top = 64
        Width = 89
        Height = 17
        Caption = #1047#1072' '#1087#1077#1088#1080#1086#1076
        TabOrder = 1
        OnClick = rbPeriodClick
      end
      object gbPeriod: TGroupBox
        Left = 126
        Top = 24
        Width = 331
        Height = 65
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1077#1088#1080#1086#1076' '
        TabOrder = 2
        Visible = False
        object Label1: TLabel
          Left = 16
          Top = 32
          Width = 6
          Height = 13
          Caption = #1089
        end
        object Label2: TLabel
          Left = 168
          Top = 32
          Width = 12
          Height = 13
          Caption = #1087#1086
        end
        object dtDateBegin: TDateTimePicker
          Left = 40
          Top = 24
          Width = 105
          Height = 21
          Date = 39142.763461539350000000
          Time = 39142.763461539350000000
          TabOrder = 0
        end
        object dtDateEnd: TDateTimePicker
          Left = 192
          Top = 24
          Width = 105
          Height = 21
          Date = 39142.763461539350000000
          Time = 39142.763461539350000000
          TabOrder = 1
        end
      end
      object gbDay: TGroupBox
        Left = 126
        Top = 24
        Width = 171
        Height = 65
        Caption = ' '#1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1090#1091' '
        TabOrder = 3
        object dtDay: TDateTimePicker
          Left = 40
          Top = 24
          Width = 105
          Height = 21
          Date = 39142.763461539350000000
          Time = 39142.763461539350000000
          TabOrder = 0
        end
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 112
      Width = 474
      Height = 70
      Align = alBottom
      Caption = ' '#1058#1086#1095#1082#1072' '#1087#1088#1086#1076#1072#1078#1080' '
      TabOrder = 1
      object cbPunct: TComboBox
        Left = 16
        Top = 28
        Width = 433
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object gbResult: TGroupBox
      Left = 0
      Top = 198
      Width = 474
      Height = 132
      Align = alBottom
      Caption = ' '#1056#1077#1079#1091#1083#1100#1090#1072#1090' '
      TabOrder = 2
      object Label4: TLabel
        Left = 240
        Top = 16
        Width = 125
        Height = 13
        Caption = #1042' '#1090#1086#1084' '#1095#1080#1089#1083#1077' '#1087#1086' '#1086#1090#1076#1077#1083#1072#1084':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lSalesOfDay: TLabel
        Left = 16
        Top = 60
        Width = 201
        Height = 33
        Alignment = taCenter
        AutoSize = False
        Caption = '0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -27
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 16
        Top = 48
        Width = 201
        Height = 57
      end
      object DBGridEh1: TDBGridEh
        Left = 240
        Top = 32
        Width = 177
        Height = 73
        DataGrouping.GroupLevels = <>
        DataSource = dsSaleOfOtdel
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        ReadOnly = True
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'Otdel'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1054#1090#1076#1077#1083
            Width = 57
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'Summa'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1057#1091#1084#1084#1072' '#1074' '#1088#1091#1073'.'
            Width = 80
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object qSalesOfOtdel: TMySQLQuery
    DatabaseName = 'beznal'
    Server = frmSpr.MySQLServer
    TableName = 'sale'
    Left = 370
    Top = 93
    object qSalesOfOtdelSumma: TFloatField
      FieldName = 'Summa'
    end
    object qSalesOfOtdelOtdel: TLargeintField
      FieldName = 'Otdel'
      Required = True
    end
  end
  object dsSaleOfOtdel: TDataSource
    DataSet = qSalesOfOtdel
    Left = 314
    Top = 93
  end
  object qSaleSumma: TMySQLQuery
    DatabaseName = 'beznal'
    Server = frmSpr.MySQLServer
    TableName = 'sale'
    Left = 426
    Top = 93
  end
  object ExcelApplication1: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 424
    Top = 168
  end
  object ExcelWorkbook1: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 432
    Top = 224
  end
end
