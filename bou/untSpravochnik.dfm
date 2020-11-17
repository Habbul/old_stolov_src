object frmSpr: TfrmSpr
  Left = 308
  Top = 234
  Width = 714
  Height = 497
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 706
    Height = 422
    ActivePage = tsPers
    Align = alClient
    TabOrder = 0
    object tsCard: TTabSheet
      Caption = #1057#1084#1072#1088#1090#1082#1072#1088#1090#1099
      ImageIndex = 1
      object DBGridEh2: TDBGridEh
        Left = 0
        Top = 0
        Width = 513
        Height = 394
        Align = alClient
        DataSource = dsCard
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
            EditButtons = <>
            FieldName = 'Card_id'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'StateCard_id'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'Nomer'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel3: TPanel
        Left = 513
        Top = 0
        Width = 185
        Height = 394
        Align = alRight
        TabOrder = 1
        object Label4: TLabel
          Left = 16
          Top = 8
          Width = 88
          Height = 13
          Caption = 'C'#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1072#1088#1090#1099
        end
        object Label5: TLabel
          Left = 16
          Top = 56
          Width = 45
          Height = 13
          Caption = #8470' '#1082#1072#1088#1090#1099
        end
        object Edit2: TEdit
          Left = 16
          Top = 24
          Width = 137
          Height = 21
          TabOrder = 0
        end
        object Button8: TButton
          Left = 56
          Top = 120
          Width = 75
          Height = 25
          Caption = #1047#1072#1087#1080#1089#1072#1090#1100
          TabOrder = 1
        end
        object Button9: TButton
          Left = 48
          Top = 224
          Width = 75
          Height = 25
          Caption = 'Open'
          TabOrder = 2
          OnClick = Button9Click
        end
        object Button10: TButton
          Left = 48
          Top = 256
          Width = 75
          Height = 25
          Caption = 'Close'
          TabOrder = 3
          OnClick = Button10Click
        end
        object Edit3: TEdit
          Left = 16
          Top = 72
          Width = 97
          Height = 21
          TabOrder = 4
        end
        object Button11: TButton
          Left = 144
          Top = 20
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 5
        end
        object Button12: TButton
          Left = 112
          Top = 72
          Width = 57
          Height = 25
          Caption = #1057#1095#1080#1090#1072#1090#1100
          TabOrder = 6
          OnClick = Button12Click
        end
      end
    end
    object tsStateCard: TTabSheet
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1089#1084#1072#1088#1090#1082#1072#1088#1090#1099
      ImageIndex = 2
      object DBGridEh3: TDBGridEh
        Left = 0
        Top = 0
        Width = 513
        Height = 394
        Align = alClient
        DataSource = dsSCard
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
            EditButtons = <>
            FieldName = 'StateCard_id'
            Footers = <>
            Width = 68
          end
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            Width = 120
          end
          item
            EditButtons = <>
            FieldName = 'Description'
            Footers = <>
            Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
            Width = 257
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object pnlStateCard: TPanel
        Left = 513
        Top = 0
        Width = 185
        Height = 394
        Align = alRight
        TabOrder = 1
        object Label2: TLabel
          Left = 16
          Top = 8
          Width = 54
          Height = 13
          Caption = 'C'#1086#1089#1090#1086#1103#1085#1080#1077
        end
        object Label3: TLabel
          Left = 16
          Top = 56
          Width = 50
          Height = 13
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        end
        object edState: TEdit
          Left = 16
          Top = 24
          Width = 161
          Height = 21
          TabOrder = 0
        end
        object Button5: TButton
          Left = 56
          Top = 104
          Width = 75
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 1
          OnClick = Button5Click
        end
        object Button6: TButton
          Left = 48
          Top = 224
          Width = 75
          Height = 25
          Caption = 'Open'
          TabOrder = 2
          OnClick = Button6Click
        end
        object Button7: TButton
          Left = 48
          Top = 256
          Width = 75
          Height = 25
          Caption = 'Close'
          TabOrder = 3
          OnClick = Button7Click
        end
        object edDescription: TEdit
          Left = 16
          Top = 72
          Width = 161
          Height = 21
          TabOrder = 4
        end
      end
    end
    object tsPers: TTabSheet
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      object DBGridEh1: TDBGridEh
        Left = 0
        Top = 0
        Width = 520
        Height = 394
        Align = alClient
        DataSource = dsPers
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
        UseMultiTitle = True
        OnDblClick = DBGridEh1DblClick
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Pers_id'
            Footers = <>
            Visible = False
            Width = 33
          end
          item
            EditButtons = <>
            FieldName = 'Card_id'
            Footers = <>
            Visible = False
            Width = 38
          end
          item
            EditButtons = <>
            FieldName = 'Family'
            Footers = <>
            Title.Caption = #1060#1072#1084#1080#1083#1080#1103
            Width = 134
          end
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Caption = #1048#1084#1103
            Width = 97
          end
          item
            EditButtons = <>
            FieldName = 'ParentName'
            Footers = <>
            Title.Caption = #1054#1090#1095#1077#1089#1090#1074#1086
            Width = 123
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'TabNum'
            Footers = <>
            Title.Caption = #1058#1072#1073'. '#8470
            Width = 59
          end
          item
            Alignment = taCenter
            EditButtons = <>
            FieldName = 'FlagKredita'
            Footers = <>
            Title.Caption = #1060#1083#1072#1075' '#1082#1088#1077#1076#1080#1090#1072
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel2: TPanel
        Left = 520
        Top = 0
        Width = 178
        Height = 394
        Align = alRight
        TabOrder = 1
        object Label6: TLabel
          Left = 24
          Top = 40
          Width = 49
          Height = 13
          Caption = #1060#1072#1084#1080#1083#1080#1103
        end
        object Label7: TLabel
          Left = 24
          Top = 88
          Width = 22
          Height = 13
          Caption = #1048#1084#1103
        end
        object Label8: TLabel
          Left = 24
          Top = 144
          Width = 47
          Height = 13
          Caption = #1054#1090#1095#1077#1089#1090#1074#1086
        end
        object Label9: TLabel
          Left = 24
          Top = 200
          Width = 71
          Height = 13
          Caption = #1058#1072#1073#1077#1083#1100#1085#1099#1081' '#8470
        end
        object Label10: TLabel
          Left = 24
          Top = 256
          Width = 35
          Height = 13
          Caption = #8470' '#1041#1057#1050
        end
        object Label11: TLabel
          Left = 128
          Top = 256
          Width = 36
          Height = 13
          Caption = 'Card_id'
        end
        object Button13: TButton
          Left = 56
          Top = 8
          Width = 75
          Height = 25
          Caption = #1053#1086#1074#1099#1081
          TabOrder = 0
          OnClick = Button13Click
        end
        object Button14: TButton
          Left = 56
          Top = 312
          Width = 75
          Height = 25
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          TabOrder = 1
          OnClick = Button14Click
        end
        object Edit12: TEdit
          Left = 16
          Top = 272
          Width = 97
          Height = 21
          TabOrder = 2
        end
        object Edit13: TEdit
          Left = 128
          Top = 272
          Width = 41
          Height = 21
          TabOrder = 3
        end
        object DBEditEh1: TDBEditEh
          Left = 16
          Top = 56
          Width = 145
          Height = 21
          DataField = 'Family'
          DataSource = dsPers
          EditButtons = <>
          TabOrder = 4
          Visible = True
        end
        object DBEditEh2: TDBEditEh
          Left = 16
          Top = 104
          Width = 145
          Height = 21
          DataField = 'Name'
          DataSource = dsPers
          EditButtons = <>
          TabOrder = 5
          Visible = True
        end
        object DBEditEh3: TDBEditEh
          Left = 16
          Top = 160
          Width = 145
          Height = 21
          DataField = 'ParentName'
          DataSource = dsPers
          EditButtons = <>
          TabOrder = 6
          Visible = True
        end
        object DBEditEh4: TDBEditEh
          Left = 16
          Top = 216
          Width = 145
          Height = 21
          DataField = 'TabNum'
          DataSource = dsPers
          EditButtons = <>
          TabOrder = 7
          Visible = True
        end
      end
    end
    object tsEmpl: TTabSheet
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1089#1080#1089#1090#1077#1084#1099
      ImageIndex = 4
      object DBGridEh4: TDBGridEh
        Left = 0
        Top = 0
        Width = 520
        Height = 394
        Align = alClient
        DataSource = dsEmpl
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
        UseMultiTitle = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'Empl_id'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'TypeEmpl_id'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel5: TPanel
        Left = 520
        Top = 0
        Width = 178
        Height = 394
        Align = alRight
        TabOrder = 1
        object Edit8: TEdit
          Left = 24
          Top = 24
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'Edit4'
        end
        object Edit9: TEdit
          Left = 24
          Top = 120
          Width = 121
          Height = 21
          TabOrder = 1
          Text = 'Edit5'
        end
        object Edit10: TEdit
          Left = 24
          Top = 152
          Width = 121
          Height = 21
          TabOrder = 2
          Text = 'Edit6'
        end
        object Edit11: TEdit
          Left = 24
          Top = 184
          Width = 121
          Height = 21
          TabOrder = 3
          Text = 'Edit7'
        end
      end
    end
    object tsTEmp: TTabSheet
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      ImageIndex = 5
      object DBGridEh6: TDBGridEh
        Left = 0
        Top = 0
        Width = 504
        Height = 394
        Align = alClient
        DataSource = dsTEmpl
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
        UseMultiTitle = True
        Columns = <
          item
            EditButtons = <>
            FieldName = 'TypeEmpl_id'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'post'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel6: TPanel
        Left = 504
        Top = 0
        Width = 194
        Height = 394
        Align = alRight
        TabOrder = 1
      end
    end
    object tsPrava: TTabSheet
      Caption = #1055#1088#1072#1074#1072
      ImageIndex = 3
      object DBGridEh5: TDBGridEh
        Left = 0
        Top = 0
        Width = 513
        Height = 394
        Align = alClient
        DataSource = dsPrava
        Flat = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        ParentFont = False
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
            FieldName = 'Prava_id'
            Footers = <>
          end
          item
            EditButtons = <>
            FieldName = 'Name'
            Footers = <>
            Title.Alignment = taCenter
            Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            Width = 276
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object Panel4: TPanel
        Left = 513
        Top = 0
        Width = 185
        Height = 394
        Align = alRight
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 8
          Width = 65
          Height = 13
          Caption = #1053#1086#1074#1086#1077' '#1087#1088#1072#1074#1086
        end
        object Edit1: TEdit
          Left = 16
          Top = 24
          Width = 161
          Height = 21
          TabOrder = 0
        end
        object Button1: TButton
          Left = 56
          Top = 64
          Width = 75
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100
          TabOrder = 1
          OnClick = Button1Click
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 422
    Width = 706
    Height = 41
    Align = alBottom
    TabOrder = 1
  end
  object dsPers: TDataSource
    DataSet = qPers
    Left = 32
    Top = 72
  end
  object dsCard: TDataSource
    DataSet = qCard
    Left = 32
    Top = 128
  end
  object dsSCard: TDataSource
    DataSet = qStateCard
    Left = 32
    Top = 184
  end
  object Beznal: TDatabase
    AliasName = 'Beznal'
    DatabaseName = 'BN'
    LoginPrompt = False
    Params.Strings = (
      'USER NAME=Elena'
      'PASSWORD=accident')
    SessionName = 'Default'
    Left = 656
    Top = 368
  end
  object dsPrava: TDataSource
    DataSet = qPrava
    Left = 32
    Top = 368
  end
  object MySQLServer: TMySQLServer
    Host = 'localhost'
    UserName = 'Elena'
    Password = 'accident'
    Params.Strings = (
      'connect_timeout=120')
    Options = [coInteractive, coTransactions]
    AfterDisconnect = MySQLServerAfterDisconnect
    Left = 573
    Top = 368
  end
  object qPrava: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'prava'
    Left = 84
    Top = 368
    object qPravaPrava_id: TAutoIncField
      FieldName = 'Prava_id'
      Origin = 'Prava_id'
      ReadOnly = True
    end
    object qPravaName: TMySQLStringField
      FieldName = 'Name'
      Origin = 'Name'
      Size = 60
      StringType = stNormal
    end
  end
  object qStateCard: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'statecard'
    Left = 84
    Top = 184
    object qStateCardStateCard_id: TAutoIncField
      FieldName = 'StateCard_id'
      Origin = 'StateCard_id'
      ReadOnly = True
    end
    object qStateCardName: TMySQLStringField
      FieldName = 'Name'
      Origin = 'Name'
      StringType = stNormal
    end
    object qStateCardDescription: TMySQLStringField
      FieldName = 'Description'
      Origin = 'Description'
      Size = 240
      StringType = stNormal
    end
  end
  object qCard: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'card'
    Left = 84
    Top = 128
    object qCardCard_id: TAutoIncField
      FieldName = 'Card_id'
      Origin = 'Card_id'
      ReadOnly = True
    end
    object qCardStateCard_id: TIntegerField
      FieldName = 'StateCard_id'
      Origin = 'StateCard_id'
    end
    object qCardNomer: TMySQLStringField
      FieldName = 'Nomer'
      Origin = 'Nomer'
      StringType = stNormal
    end
  end
  object qTemp: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    Left = 660
    Top = 312
  end
  object dsEmpl: TDataSource
    DataSet = qEmployee
    Left = 32
    Top = 256
  end
  object qEmployee: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'employee'
    Left = 84
    Top = 256
    object qEmployeeEmpl_id: TIntegerField
      FieldName = 'Empl_id'
      Required = True
    end
    object qEmployeeTypeEmpl_id: TIntegerField
      FieldName = 'TypeEmpl_id'
    end
  end
  object dsTEmpl: TDataSource
    DataSet = qTEmpl
    Left = 32
    Top = 312
  end
  object qTEmpl: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'typeemployers'
    Left = 84
    Top = 312
    object qTEmplTypeEmpl_id: TAutoIncField
      FieldName = 'TypeEmpl_id'
      ReadOnly = True
    end
    object qTEmplpost: TMySQLStringField
      FieldName = 'post'
      Size = 40
      StringType = stNormal
    end
  end
  object qHistory: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'sale'
    Left = 288
    Top = 78
  end
  object qPers: TMySQLQuery
    DatabaseName = 'beznal'
    Server = MySQLServer
    TableName = 'pers'
    Left = 84
    Top = 72
    object qPersPers_id: TAutoIncField
      FieldName = 'Pers_id'
      ReadOnly = True
    end
    object qPersCard_id: TIntegerField
      FieldName = 'Card_id'
    end
    object qPersFamily: TMySQLStringField
      FieldName = 'Family'
      Size = 30
      StringType = stNormal
    end
    object qPersName: TMySQLStringField
      FieldName = 'Name'
      StringType = stNormal
    end
    object qPersParentName: TMySQLStringField
      FieldName = 'ParentName'
      Size = 30
      StringType = stNormal
    end
    object qPersTabNum: TMySQLStringField
      FieldName = 'TabNum'
      Size = 10
      StringType = stNormal
    end
    object qPersFlagKredita: TIntegerField
      FieldName = 'FlagKredita'
    end
  end
end
