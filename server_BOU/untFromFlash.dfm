object frmFromFlash: TfrmFromFlash
  Left = 363
  Top = 231
  Width = 508
  Height = 574
  BorderIcons = []
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1088#1086#1076#1072#1078' '#1089' '#1092#1083#1077#1096#1082#1080', '#1079#1072#1075#1088#1091#1079#1082#1072' '#1089#1090#1086#1087'-'#1083#1080#1089#1090#1072
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
    Top = 466
    Width = 500
    Height = 74
    Align = alBottom
    TabOrder = 0
    object btnExit: TBitBtn
      Left = 336
      Top = 17
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
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 500
    Height = 466
    Align = alClient
    TabOrder = 1
    object Panel1: TPanel
      Left = 2
      Top = 149
      Width = 496
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object btnStep1: TBitBtn
        Left = 384
        Top = 8
        Width = 89
        Height = 25
        Caption = #1044#1072#1083#1077#1077' >>'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = btnStep1Click
      end
      object btnStep3: TButton
        Left = 384
        Top = 8
        Width = 89
        Height = 25
        Caption = #1044#1072#1083#1077#1077' >>'
        TabOrder = 1
        Visible = False
        OnClick = btnStep3Click
      end
      object btnStep2: TButton
        Left = 384
        Top = 8
        Width = 89
        Height = 25
        Caption = #1044#1072#1083#1077#1077' >>'
        TabOrder = 2
        Visible = False
        OnClick = btnStep2Click
      end
      object pbExport: TProgressBar
        Left = 16
        Top = 11
        Width = 345
        Height = 17
        Max = 10000
        TabOrder = 3
      end
      object btnStep4: TButton
        Left = 384
        Top = 8
        Width = 89
        Height = 25
        Caption = #1057#1083#1077#1076#1091#1102#1097#1072#1103
        TabOrder = 4
        Visible = False
        OnClick = btnStep4Click
      end
    end
    object pnlStep1: TPanel
      Left = 2
      Top = 49
      Width = 496
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lStep1: TLabel
        Left = 32
        Top = 1
        Width = 465
        Height = 43
        AutoSize = False
        Caption = 
          #1064#1072#1075' 1. '#1045#1089#1083#1080' '#1082' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1091' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1072' '#1092#1083#1077#1096#1082#1072', '#1080#1079#1074#1083#1077#1082#1080#1090#1077' '#1077#1077'! '#1055#1086#1089#1083#1077' ' +
          #1080#1079#1074#1083#1077#1095#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' "'#1044#1072#1083#1077#1077'".'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Image3: TImage
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Picture.Data = {
          07544269746D617036050000424D360500000000000036040000280000001000
          0000100000000100080000000000000100000000000000000000000100000000
          000000000000262626004B4B4B00717171000E0E0E003434340059595900C0C0
          C000D0D0D000C3C3C300F1F1F100E5E5E500D9D9D900CDCDCD00C0C0C000B4B4
          B400B0B0B000989898007F7F7F00666666004E4E4E0035353500E9E9E900D5D5
          D500C1C1C100ACACAC0098989800838383007E7E7E006D6D6D005B5B5B004949
          49003838380026262600E0E0E000C8C8C800AFAFAF00979797007E7E7E006666
          66004C4C4C0042424200373737002D2D2D002222220018181800E2E2E200CACA
          CA00B3B3B3009B9B9B00838383006B6B6B00555555004A4A4A003E3E3E003232
          3200262626001A1A1A00E3E3E300CDCDCD00B7B7B700A1A1A1008B8B8B007575
          75005F5F5F005252520044444400373737002A2A2A001D1D1D00E5E5E500D0D0
          D000BCBCBC00A7A7A700939393007E7E7E00686868005A5A5A004B4B4B003D3D
          3D002F2F2F0020202000E1E1E100C8C8C800AFAFAF00969696007D7D7D006464
          64004F4F4F0044444400383838002D2D2D002222220017171700DDDDDD00C0C0
          C000A3A3A30086868600696969004B4B4B00353535002E2E2E00262626001F1F
          1F001717170010101000D8D8D800B9B9B9009A9A9A007B7B7B005C5C5C003C3C
          3C001B1B1B001818180014141400101010000C0C0C0008080800E1E1E100C6C6
          C600ABABAB0090909000757575005A5A5A004E4E4E0043434300383838002D2D
          2D002222220017171700E9E9E900D6D6D600C3C3C300B0B0B0009E9E9E008B8B
          8B00808080006E6E6E005C5C5C004A4A4A003838380026262600F2F2F200E7E7
          E700DDDDDD00D2D2D200C8C8C800BDBDBD00B1B1B10099999900818181006969
          69005050500038383800F0F0F000E4E4E400D8D8D800CCCCCC00C0C0C000B4B4
          B400A9A9A900919191007A7A7A00636363004B4B4B0034343400EFEFEF00E1E1
          E100D3D3D300C6C6C600B8B8B800ABABAB009F9F9F0089898900737373005D5D
          5D004747470031313100EDEDED00DFDFDF00D0D0D000C2C2C200B3B3B300A5A5
          A50095959500818181006D6D6D0058585800434343002F2F2F00F1F1F100E5E5
          E500D9D9D900CDCDCD00C0C0C000B4B4B400AFAFAF00979797007F7F7F006767
          67004E4E4E0036363600F5F5F500EDEDED00E5E5E500DDDDDD00D5D5D500CDCD
          CD00C9C9C900ADADAD0091919100757575005A5A5A003E3E3E00FAFAFA00F6F6
          F600F2F2F200EEEEEE00EAEAEA00E7E7E700E2E2E200C3C3C300A4A4A4008585
          85006666660047474700F2F2F200E6E6E600DADADA00CECECE00C1C1C100B6B6
          B600AAAAAA009E9E9E0092929200868686007A7A7A006D6D6D00626262005656
          56004A4A4A003E3E3E0032323200262626001A1A1A000E0E0E00FAFAFA00A0A0
          A000808080004C4C4C0096969600E2E2E2001C1C1C0068686800B2B2B200FFFF
          FF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00BDFABC00FFFFFFFFFF
          FFFFFFFFFFFF00BAFAC7BDFFFFFFFFFFFFFFFFFFFF00BCB8FAB9BC00FFFFFFFF
          FFFFFFFFFF0002FAFAB90200FFFFFFFFFFFFFFFFFFBDFAA8A9FAB90200FFFFFF
          FFFFFFFF00BAB6A8A9BBB9C7BD00FFFFFFFFFFFF00AAA9A7F400BBBB0200FFFF
          FFFFFFFFFFF3AAAA00FFBCB8C7BD00FFFFFFFFFFFF000000FFFF00BABABC00FF
          FFFFFFFFFFFFFFFFFFFFFFBDFA02BDFFFFFFFFFFFFFFFFFFFFFFFF00FAB90200
          FFFFFFFFFFFFFFFFFFFFFFFF00B9BBB1FFFFFFFFFFFFFFFFFFFFFFFF00AFB4A9
          00FFFFFFFFFFFFFFFFFFFFFFFFF3A9A4FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFF}
        Stretch = True
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 15
      Width = 496
      Height = 34
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label4: TLabel
        Left = 10
        Top = 0
        Width = 175
        Height = 25
        AutoSize = False
        Caption = #1055#1086#1088#1103#1076#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
    end
    object pnlStep2: TPanel
      Left = 2
      Top = 94
      Width = 496
      Height = 90
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      Visible = False
      object Image1: TImage
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Picture.Data = {
          07544269746D617036050000424D360500000000000036040000280000001000
          0000100000000100080000000000000100000000000000000000000100000000
          000000000000262626004B4B4B00717171000E0E0E003434340059595900C0C0
          C000D0D0D000C3C3C300F1F1F100E5E5E500D9D9D900CDCDCD00C0C0C000B4B4
          B400B0B0B000989898007F7F7F00666666004E4E4E0035353500E9E9E900D5D5
          D500C1C1C100ACACAC0098989800838383007E7E7E006D6D6D005B5B5B004949
          49003838380026262600E0E0E000C8C8C800AFAFAF00979797007E7E7E006666
          66004C4C4C0042424200373737002D2D2D002222220018181800E2E2E200CACA
          CA00B3B3B3009B9B9B00838383006B6B6B00555555004A4A4A003E3E3E003232
          3200262626001A1A1A00E3E3E300CDCDCD00B7B7B700A1A1A1008B8B8B007575
          75005F5F5F005252520044444400373737002A2A2A001D1D1D00E5E5E500D0D0
          D000BCBCBC00A7A7A700939393007E7E7E00686868005A5A5A004B4B4B003D3D
          3D002F2F2F0020202000E1E1E100C8C8C800AFAFAF00969696007D7D7D006464
          64004F4F4F0044444400383838002D2D2D002222220017171700DDDDDD00C0C0
          C000A3A3A30086868600696969004B4B4B00353535002E2E2E00262626001F1F
          1F001717170010101000D8D8D800B9B9B9009A9A9A007B7B7B005C5C5C003C3C
          3C001B1B1B001818180014141400101010000C0C0C0008080800E1E1E100C6C6
          C600ABABAB0090909000757575005A5A5A004E4E4E0043434300383838002D2D
          2D002222220017171700E9E9E900D6D6D600C3C3C300B0B0B0009E9E9E008B8B
          8B00808080006E6E6E005C5C5C004A4A4A003838380026262600F2F2F200E7E7
          E700DDDDDD00D2D2D200C8C8C800BDBDBD00B1B1B10099999900818181006969
          69005050500038383800F0F0F000E4E4E400D8D8D800CCCCCC00C0C0C000B4B4
          B400A9A9A900919191007A7A7A00636363004B4B4B0034343400EFEFEF00E1E1
          E100D3D3D300C6C6C600B8B8B800ABABAB009F9F9F0089898900737373005D5D
          5D004747470031313100EDEDED00DFDFDF00D0D0D000C2C2C200B3B3B300A5A5
          A50095959500818181006D6D6D0058585800434343002F2F2F00F1F1F100E5E5
          E500D9D9D900CDCDCD00C0C0C000B4B4B400AFAFAF00979797007F7F7F006767
          67004E4E4E0036363600F5F5F500EDEDED00E5E5E500DDDDDD00D5D5D500CDCD
          CD00C9C9C900ADADAD0091919100757575005A5A5A003E3E3E00FAFAFA00F6F6
          F600F2F2F200EEEEEE00EAEAEA00E7E7E700E2E2E200C3C3C300A4A4A4008585
          85006666660047474700F2F2F200E6E6E600DADADA00CECECE00C1C1C100B6B6
          B600AAAAAA009E9E9E0092929200868686007A7A7A006D6D6D00626262005656
          56004A4A4A003E3E3E0032323200262626001A1A1A000E0E0E00FAFAFA00A0A0
          A000808080004C4C4C0096969600E2E2E2001C1C1C0068686800B2B2B200FFFF
          FF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00BDFABC00FFFFFFFFFF
          FFFFFFFFFFFF00BAFAC7BDFFFFFFFFFFFFFFFFFFFF00BCB8FAB9BC00FFFFFFFF
          FFFFFFFFFF0002FAFAB90200FFFFFFFFFFFFFFFFFFBDFAA8A9FAB90200FFFFFF
          FFFFFFFF00BAB6A8A9BBB9C7BD00FFFFFFFFFFFF00AAA9A7F400BBBB0200FFFF
          FFFFFFFFFFF3AAAA00FFBCB8C7BD00FFFFFFFFFFFF000000FFFF00BABABC00FF
          FFFFFFFFFFFFFFFFFFFFFFBDFA02BDFFFFFFFFFFFFFFFFFFFFFFFF00FAB90200
          FFFFFFFFFFFFFFFFFFFFFFFF00B9BBB1FFFFFFFFFFFFFFFFFFFFFFFF00AFB4A9
          00FFFFFFFFFFFFFFFFFFFFFFFFF3A9A4FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFF}
        Stretch = True
      end
      object lStep2: TLabel
        Left = 34
        Top = 1
        Width = 451
        Height = 37
        AutoSize = False
        Caption = 
          #1064#1072#1075' 2. '#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1095#1082#1091' c '#1082#1086#1090#1086#1088#1086#1081' '#1087#1086#1083#1091#1095#1077#1085#1072' '#1074#1099#1075#1088#1091#1079#1082#1072' '#1080' '#1085#1072#1078#1084#1080#1090#1077' '#1082#1085#1086#1087 +
          #1082#1091' "'#1044#1072#1083#1077#1077'"'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object cbPunct: TComboBox
        Left = 32
        Top = 48
        Width = 441
        Height = 21
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object pnlStep5: TPanel
      Left = 2
      Top = 274
      Width = 496
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      Visible = False
      object Image4: TImage
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Picture.Data = {
          07544269746D617036050000424D360500000000000036040000280000001000
          0000100000000100080000000000000100000000000000000000000100000000
          000000000000262626004B4B4B00717171000E0E0E003434340059595900C0C0
          C000D0D0D000C3C3C300F1F1F100E5E5E500D9D9D900CDCDCD00C0C0C000B4B4
          B400B0B0B000989898007F7F7F00666666004E4E4E0035353500E9E9E900D5D5
          D500C1C1C100ACACAC0098989800838383007E7E7E006D6D6D005B5B5B004949
          49003838380026262600E0E0E000C8C8C800AFAFAF00979797007E7E7E006666
          66004C4C4C0042424200373737002D2D2D002222220018181800E2E2E200CACA
          CA00B3B3B3009B9B9B00838383006B6B6B00555555004A4A4A003E3E3E003232
          3200262626001A1A1A00E3E3E300CDCDCD00B7B7B700A1A1A1008B8B8B007575
          75005F5F5F005252520044444400373737002A2A2A001D1D1D00E5E5E500D0D0
          D000BCBCBC00A7A7A700939393007E7E7E00686868005A5A5A004B4B4B003D3D
          3D002F2F2F0020202000E1E1E100C8C8C800AFAFAF00969696007D7D7D006464
          64004F4F4F0044444400383838002D2D2D002222220017171700DDDDDD00C0C0
          C000A3A3A30086868600696969004B4B4B00353535002E2E2E00262626001F1F
          1F001717170010101000D8D8D800B9B9B9009A9A9A007B7B7B005C5C5C003C3C
          3C001B1B1B001818180014141400101010000C0C0C0008080800E1E1E100C6C6
          C600ABABAB0090909000757575005A5A5A004E4E4E0043434300383838002D2D
          2D002222220017171700E9E9E900D6D6D600C3C3C300B0B0B0009E9E9E008B8B
          8B00808080006E6E6E005C5C5C004A4A4A003838380026262600F2F2F200E7E7
          E700DDDDDD00D2D2D200C8C8C800BDBDBD00B1B1B10099999900818181006969
          69005050500038383800F0F0F000E4E4E400D8D8D800CCCCCC00C0C0C000B4B4
          B400A9A9A900919191007A7A7A00636363004B4B4B0034343400EFEFEF00E1E1
          E100D3D3D300C6C6C600B8B8B800ABABAB009F9F9F0089898900737373005D5D
          5D004747470031313100EDEDED00DFDFDF00D0D0D000C2C2C200B3B3B300A5A5
          A50095959500818181006D6D6D0058585800434343002F2F2F00F1F1F100E5E5
          E500D9D9D900CDCDCD00C0C0C000B4B4B400AFAFAF00979797007F7F7F006767
          67004E4E4E0036363600F5F5F500EDEDED00E5E5E500DDDDDD00D5D5D500CDCD
          CD00C9C9C900ADADAD0091919100757575005A5A5A003E3E3E00FAFAFA00F6F6
          F600F2F2F200EEEEEE00EAEAEA00E7E7E700E2E2E200C3C3C300A4A4A4008585
          85006666660047474700F2F2F200E6E6E600DADADA00CECECE00C1C1C100B6B6
          B600AAAAAA009E9E9E0092929200868686007A7A7A006D6D6D00626262005656
          56004A4A4A003E3E3E0032323200262626001A1A1A000E0E0E00FAFAFA00A0A0
          A000808080004C4C4C0096969600E2E2E2001C1C1C0068686800B2B2B200FFFF
          FF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00BDFABC00FFFFFFFFFF
          FFFFFFFFFFFF00BAFAC7BDFFFFFFFFFFFFFFFFFFFF00BCB8FAB9BC00FFFFFFFF
          FFFFFFFFFF0002FAFAB90200FFFFFFFFFFFFFFFFFFBDFAA8A9FAB90200FFFFFF
          FFFFFFFF00BAB6A8A9BBB9C7BD00FFFFFFFFFFFF00AAA9A7F400BBBB0200FFFF
          FFFFFFFFFFF3AAAA00FFBCB8C7BD00FFFFFFFFFFFF000000FFFF00BABABC00FF
          FFFFFFFFFFFFFFFFFFFFFFBDFA02BDFFFFFFFFFFFFFFFFFFFFFFFF00FAB90200
          FFFFFFFFFFFFFFFFFFFFFFFF00B9BBB1FFFFFFFFFFFFFFFFFFFFFFFF00AFB4A9
          00FFFFFFFFFFFFFFFFFFFFFFFFF3A9A4FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFF}
        Stretch = True
      end
      object Label3: TLabel
        Left = 34
        Top = 11
        Width = 451
        Height = 22
        AutoSize = False
        Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1085#1077' '#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1072'!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
    end
    object pnlStep3: TPanel
      Left = 2
      Top = 184
      Width = 496
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      Visible = False
      object Image5: TImage
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Picture.Data = {
          07544269746D617036050000424D360500000000000036040000280000001000
          0000100000000100080000000000000100000000000000000000000100000000
          000000000000262626004B4B4B00717171000E0E0E003434340059595900C0C0
          C000D0D0D000C3C3C300F1F1F100E5E5E500D9D9D900CDCDCD00C0C0C000B4B4
          B400B0B0B000989898007F7F7F00666666004E4E4E0035353500E9E9E900D5D5
          D500C1C1C100ACACAC0098989800838383007E7E7E006D6D6D005B5B5B004949
          49003838380026262600E0E0E000C8C8C800AFAFAF00979797007E7E7E006666
          66004C4C4C0042424200373737002D2D2D002222220018181800E2E2E200CACA
          CA00B3B3B3009B9B9B00838383006B6B6B00555555004A4A4A003E3E3E003232
          3200262626001A1A1A00E3E3E300CDCDCD00B7B7B700A1A1A1008B8B8B007575
          75005F5F5F005252520044444400373737002A2A2A001D1D1D00E5E5E500D0D0
          D000BCBCBC00A7A7A700939393007E7E7E00686868005A5A5A004B4B4B003D3D
          3D002F2F2F0020202000E1E1E100C8C8C800AFAFAF00969696007D7D7D006464
          64004F4F4F0044444400383838002D2D2D002222220017171700DDDDDD00C0C0
          C000A3A3A30086868600696969004B4B4B00353535002E2E2E00262626001F1F
          1F001717170010101000D8D8D800B9B9B9009A9A9A007B7B7B005C5C5C003C3C
          3C001B1B1B001818180014141400101010000C0C0C0008080800E1E1E100C6C6
          C600ABABAB0090909000757575005A5A5A004E4E4E0043434300383838002D2D
          2D002222220017171700E9E9E900D6D6D600C3C3C300B0B0B0009E9E9E008B8B
          8B00808080006E6E6E005C5C5C004A4A4A003838380026262600F2F2F200E7E7
          E700DDDDDD00D2D2D200C8C8C800BDBDBD00B1B1B10099999900818181006969
          69005050500038383800F0F0F000E4E4E400D8D8D800CCCCCC00C0C0C000B4B4
          B400A9A9A900919191007A7A7A00636363004B4B4B0034343400EFEFEF00E1E1
          E100D3D3D300C6C6C600B8B8B800ABABAB009F9F9F0089898900737373005D5D
          5D004747470031313100EDEDED00DFDFDF00D0D0D000C2C2C200B3B3B300A5A5
          A50095959500818181006D6D6D0058585800434343002F2F2F00F1F1F100E5E5
          E500D9D9D900CDCDCD00C0C0C000B4B4B400AFAFAF00979797007F7F7F006767
          67004E4E4E0036363600F5F5F500EDEDED00E5E5E500DDDDDD00D5D5D500CDCD
          CD00C9C9C900ADADAD0091919100757575005A5A5A003E3E3E00FAFAFA00F6F6
          F600F2F2F200EEEEEE00EAEAEA00E7E7E700E2E2E200C3C3C300A4A4A4008585
          85006666660047474700F2F2F200E6E6E600DADADA00CECECE00C1C1C100B6B6
          B600AAAAAA009E9E9E0092929200868686007A7A7A006D6D6D00626262005656
          56004A4A4A003E3E3E0032323200262626001A1A1A000E0E0E00FAFAFA00A0A0
          A000808080004C4C4C0096969600E2E2E2001C1C1C0068686800B2B2B200FFFF
          FF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00BDFABC00FFFFFFFFFF
          FFFFFFFFFFFF00BAFAC7BDFFFFFFFFFFFFFFFFFFFF00BCB8FAB9BC00FFFFFFFF
          FFFFFFFFFF0002FAFAB90200FFFFFFFFFFFFFFFFFFBDFAA8A9FAB90200FFFFFF
          FFFFFFFF00BAB6A8A9BBB9C7BD00FFFFFFFFFFFF00AAA9A7F400BBBB0200FFFF
          FFFFFFFFFFF3AAAA00FFBCB8C7BD00FFFFFFFFFFFF000000FFFF00BABABC00FF
          FFFFFFFFFFFFFFFFFFFFFFBDFA02BDFFFFFFFFFFFFFFFFFFFFFFFF00FAB90200
          FFFFFFFFFFFFFFFFFFFFFFFF00B9BBB1FFFFFFFFFFFFFFFFFFFFFFFF00AFB4A9
          00FFFFFFFFFFFFFFFFFFFFFFFFF3A9A4FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFF}
        Stretch = True
      end
      object lStep3: TLabel
        Left = 34
        Top = 1
        Width = 451
        Height = 40
        AutoSize = False
        Caption = 
          #1064#1072#1075' 3. '#1055#1086#1076#1082#1083#1102#1095#1080#1090#1077' '#1092#1083#1077#1096#1082#1091' '#1082' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1091' '#1080' '#1085#1077' '#1080#1079#1074#1083#1077#1082#1072#1081#1090#1077' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085 +
          #1080#1103'. '#1053#1072#1078#1084#1080#1090#1077' "'#1044#1072#1083#1077#1077'".'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
    end
    object pnlStep4: TPanel
      Left = 2
      Top = 229
      Width = 496
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 6
      Visible = False
      object Image2: TImage
        Left = 8
        Top = 12
        Width = 17
        Height = 17
        Picture.Data = {
          07544269746D617036050000424D360500000000000036040000280000001000
          0000100000000100080000000000000100000000000000000000000100000000
          000000000000262626004B4B4B00717171000E0E0E003434340059595900C0C0
          C000D0D0D000C3C3C300F1F1F100E5E5E500D9D9D900CDCDCD00C0C0C000B4B4
          B400B0B0B000989898007F7F7F00666666004E4E4E0035353500E9E9E900D5D5
          D500C1C1C100ACACAC0098989800838383007E7E7E006D6D6D005B5B5B004949
          49003838380026262600E0E0E000C8C8C800AFAFAF00979797007E7E7E006666
          66004C4C4C0042424200373737002D2D2D002222220018181800E2E2E200CACA
          CA00B3B3B3009B9B9B00838383006B6B6B00555555004A4A4A003E3E3E003232
          3200262626001A1A1A00E3E3E300CDCDCD00B7B7B700A1A1A1008B8B8B007575
          75005F5F5F005252520044444400373737002A2A2A001D1D1D00E5E5E500D0D0
          D000BCBCBC00A7A7A700939393007E7E7E00686868005A5A5A004B4B4B003D3D
          3D002F2F2F0020202000E1E1E100C8C8C800AFAFAF00969696007D7D7D006464
          64004F4F4F0044444400383838002D2D2D002222220017171700DDDDDD00C0C0
          C000A3A3A30086868600696969004B4B4B00353535002E2E2E00262626001F1F
          1F001717170010101000D8D8D800B9B9B9009A9A9A007B7B7B005C5C5C003C3C
          3C001B1B1B001818180014141400101010000C0C0C0008080800E1E1E100C6C6
          C600ABABAB0090909000757575005A5A5A004E4E4E0043434300383838002D2D
          2D002222220017171700E9E9E900D6D6D600C3C3C300B0B0B0009E9E9E008B8B
          8B00808080006E6E6E005C5C5C004A4A4A003838380026262600F2F2F200E7E7
          E700DDDDDD00D2D2D200C8C8C800BDBDBD00B1B1B10099999900818181006969
          69005050500038383800F0F0F000E4E4E400D8D8D800CCCCCC00C0C0C000B4B4
          B400A9A9A900919191007A7A7A00636363004B4B4B0034343400EFEFEF00E1E1
          E100D3D3D300C6C6C600B8B8B800ABABAB009F9F9F0089898900737373005D5D
          5D004747470031313100EDEDED00DFDFDF00D0D0D000C2C2C200B3B3B300A5A5
          A50095959500818181006D6D6D0058585800434343002F2F2F00F1F1F100E5E5
          E500D9D9D900CDCDCD00C0C0C000B4B4B400AFAFAF00979797007F7F7F006767
          67004E4E4E0036363600F5F5F500EDEDED00E5E5E500DDDDDD00D5D5D500CDCD
          CD00C9C9C900ADADAD0091919100757575005A5A5A003E3E3E00FAFAFA00F6F6
          F600F2F2F200EEEEEE00EAEAEA00E7E7E700E2E2E200C3C3C300A4A4A4008585
          85006666660047474700F2F2F200E6E6E600DADADA00CECECE00C1C1C100B6B6
          B600AAAAAA009E9E9E0092929200868686007A7A7A006D6D6D00626262005656
          56004A4A4A003E3E3E0032323200262626001A1A1A000E0E0E00FAFAFA00A0A0
          A000808080004C4C4C0096969600E2E2E2001C1C1C0068686800B2B2B200FFFF
          FF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00BDFABC00FFFFFFFFFF
          FFFFFFFFFFFF00BAFAC7BDFFFFFFFFFFFFFFFFFFFF00BCB8FAB9BC00FFFFFFFF
          FFFFFFFFFF0002FAFAB90200FFFFFFFFFFFFFFFFFFBDFAA8A9FAB90200FFFFFF
          FFFFFFFF00BAB6A8A9BBB9C7BD00FFFFFFFFFFFF00AAA9A7F400BBBB0200FFFF
          FFFFFFFFFFF3AAAA00FFBCB8C7BD00FFFFFFFFFFFF000000FFFF00BABABC00FF
          FFFFFFFFFFFFFFFFFFFFFFBDFA02BDFFFFFFFFFFFFFFFFFFFFFFFF00FAB90200
          FFFFFFFFFFFFFFFFFFFFFFFF00B9BBB1FFFFFFFFFFFFFFFFFFFFFFFF00AFB4A9
          00FFFFFFFFFFFFFFFFFFFFFFFFF3A9A4FFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          FFFF}
        Stretch = True
      end
      object Label5: TLabel
        Left = 34
        Top = 11
        Width = 451
        Height = 22
        AutoSize = False
        Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1086#1082#1086#1085#1095#1077#1085#1072' '#1091#1089#1087#1077#1096#1085#1086'! '#1052#1086#1078#1085#1086' '#1080#1079#1074#1083#1077#1095#1100' '#1092#1083#1077#1096#1082#1091'!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
    end
    object GroupBox1: TGroupBox
      Left = 2
      Top = 193
      Width = 496
      Height = 271
      Align = alBottom
      Caption = ' '#1055#1086#1089#1083#1077#1076#1085#1080#1077' '#1074#1099#1075#1088#1091#1078#1077#1085#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '
      TabOrder = 7
      object DBGridEh1: TDBGridEh
        Left = 2
        Top = 15
        Width = 492
        Height = 254
        Align = alClient
        DataGrouping.GroupLevels = <>
        DataSource = dsDateFlash
        Flat = False
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        RowDetailPanel.Color = clBtnFace
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ntp'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1095#1082#1080
            Width = 266
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'st'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1044#1072#1090#1072
            Width = 136
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object qDateFlash: TMySQLQuery
    Server = frmSpr.MySQLServer
    Left = 310
    Top = 408
  end
  object qImport: TMySQLQuery
    Server = frmSpr.MySQLServer
    Left = 310
    Top = 296
  end
  object dsDateFlash: TDataSource
    DataSet = qDateFlash
    Left = 234
    Top = 408
  end
  object qTempSale1: TMySQLTable
    Server = frmSpr.MySQLServer
    TableName = 'tempsale'
    Left = 34
    Top = 257
    object qTempSale1TradePoint_id: TLargeintField
      FieldName = 'TradePoint_id'
      Required = True
    end
    object qTempSale1Card_id: TLargeintField
      FieldName = 'Card_id'
      Required = True
    end
    object qTempSale1Empl_id: TLargeintField
      FieldName = 'Empl_id'
      Required = True
    end
    object qTempSale1Summa: TFloatField
      FieldName = 'Summa'
      Required = True
    end
    object qTempSale1Saletime: TDateTimeField
      FieldName = 'Saletime'
      Required = True
    end
    object qTempSale1Otdel: TLargeintField
      FieldName = 'Otdel'
      Required = True
    end
  end
  object qInsert: TMySQLQuery
    Server = frmSpr.MySQLServer
    TableName = 'tempsale'
    Left = 158
    Top = 312
  end
  object qTempSale: TMySQLQuery
    Server = frmSpr.MySQLServer
    TableName = 'tempsale'
    Left = 34
    Top = 313
    object qTempSaleTradePoint_id: TLargeintField
      FieldName = 'TradePoint_id'
      Required = True
    end
    object qTempSaleCard_id: TLargeintField
      FieldName = 'Card_id'
      Required = True
    end
    object qTempSaleEmpl_id: TLargeintField
      FieldName = 'Empl_id'
      Required = True
    end
    object qTempSaleSumma: TFloatField
      FieldName = 'Summa'
      Required = True
    end
    object qTempSaleSaletime: TDateTimeField
      FieldName = 'Saletime'
      Required = True
    end
    object qTempSaleOtdel: TLargeintField
      FieldName = 'Otdel'
      Required = True
    end
  end
  object Query_temp: TMySQLQuery
    Server = MySQLServer1
    Left = 50
    Top = 376
  end
  object MySQLServer1: TMySQLServer
    Connected = True
    DatabaseName = 'beznal'
    Host = 'localhost'
    UserName = 'root'
    Password = 'accident'
    Left = 170
    Top = 392
  end
end
