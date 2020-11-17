object frmExport: TfrmExport
  Left = 388
  Top = 281
  Width = 510
  Height = 528
  Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1074#1077#1076#1086#1084#1086#1089#1090#1077#1081
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
  object btnExit: TBitBtn
    Left = 328
    Top = 416
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
  object btnReport: TButton
    Left = 208
    Top = 248
    Width = 105
    Height = 25
    Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 1
    OnClick = btnReportClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 502
    Height = 161
    ActivePage = TabSheet2
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1055#1077#1088#1080#1086#1076
      object rbDay: TRadioButton
        Left = 16
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
        Left = 16
        Top = 64
        Width = 89
        Height = 17
        Caption = #1047#1072' '#1087#1077#1088#1080#1086#1076
        TabOrder = 1
        OnClick = rbPeriodClick
      end
      object gbPeriod: TGroupBox
        Left = 110
        Top = 16
        Width = 171
        Height = 105
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
          Left = 16
          Top = 72
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
          OnChange = dtDateBeginChange
        end
        object dtDateEnd: TDateTimePicker
          Left = 40
          Top = 64
          Width = 105
          Height = 21
          Date = 39142.763461539350000000
          Time = 39142.763461539350000000
          TabOrder = 1
        end
      end
      object gbDay: TGroupBox
        Left = 110
        Top = 16
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
          OnChange = dtDayChange
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1055#1091#1085#1082#1090' '#1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 2
      object rbPunctAll: TRadioButton
        Left = 16
        Top = 32
        Width = 97
        Height = 17
        Caption = #1042#1089#1077
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbDayClick
      end
      object rbPunctSel: TRadioButton
        Left = 16
        Top = 64
        Width = 113
        Height = 17
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1090#1086#1095#1082#1091
        TabOrder = 1
        OnClick = rbPeriodClick
      end
      object cbPunct: TComboBox
        Left = 128
        Top = 64
        Width = 201
        Height = 21
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object TabSheet4: TTabSheet
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      ImageIndex = 3
      object rbPersAll: TRadioButton
        Left = 16
        Top = 32
        Width = 81
        Height = 17
        Caption = #1042#1089#1077
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbDayClick
      end
      object rbPersSel: TRadioButton
        Left = 16
        Top = 64
        Width = 97
        Height = 17
        Caption = #1042#1099#1073#1088#1072#1090#1100' '#1060#1048#1054
        TabOrder = 1
        OnClick = rbPeriodClick
      end
      object Edit1: TEdit
        Left = 16
        Top = 88
        Width = 257
        Height = 21
        TabOrder = 2
        Text = 'Edit1'
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1086#1088#1103#1076#1086#1082' '#1074#1099#1074#1086#1076#1072
      ImageIndex = 1
      object rbOtdel: TRadioButton
        Left = 16
        Top = 32
        Width = 81
        Height = 17
        Caption = #1055#1086' '#1086#1090#1076#1077#1083#1072#1084
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = rbDayClick
      end
      object rbAll: TRadioButton
        Left = 16
        Top = 64
        Width = 97
        Height = 17
        Caption = #1054#1073#1097#1080#1081' '#1089#1087#1080#1089#1086#1082
        TabOrder = 1
        OnClick = rbPeriodClick
      end
    end
  end
  object qReport: TMySQLQuery
    DatabaseName = 'beznal'
    Server = frmSpr.MySQLServer
    Left = 24
    Top = 232
  end
end
