unit untSpravochnik;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, ComCtrls, ExtCtrls, DB, DBTables, StdCtrls, _libmysq,
  MySQLDataset, MySQLServer, Mask, DBCtrlsEh, IniFiles, GridsEh;

type
  TfrmSpr = class(TForm)
    PageControl1: TPageControl;
    Panel1: TPanel;
    tsPers: TTabSheet;
    tsCard: TTabSheet;
    DBGridEh1: TDBGridEh;
    Panel2: TPanel;
    DBGridEh2: TDBGridEh;
    dsPers: TDataSource;
    dsCard: TDataSource;
    tsStateCard: TTabSheet;
    DBGridEh3: TDBGridEh;
    dsSCard: TDataSource;
    Beznal: TDatabase;
    tsPrava: TTabSheet;
    dsPrava: TDataSource;
    DBGridEh5: TDBGridEh;
    Panel4: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    MySQLServer: TMySQLServer;
    qPrava: TMySQLQuery;
    qPravaPrava_id: TAutoIncField;
    qPravaName: TMySQLStringField;
    qStateCard: TMySQLQuery;
    qStateCardStateCard_id: TAutoIncField;
    qStateCardName: TMySQLStringField;
    qStateCardDescription: TMySQLStringField;
    qCard: TMySQLQuery;
    qCardCard_id: TAutoIncField;
    qCardStateCard_id: TIntegerField;
    qCardNomer: TMySQLStringField;
    qTemp: TMySQLQuery;
    pnlStateCard: TPanel;
    Label2: TLabel;
    edState: TEdit;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label3: TLabel;
    edDescription: TEdit;
    Panel3: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Edit3: TEdit;
    Button11: TButton;
    Button12: TButton;
    dsEmpl: TDataSource;
    qEmployee: TMySQLQuery;
    qEmployeeEmpl_id: TIntegerField;
    qEmployeeTypeEmpl_id: TIntegerField;
    dsTEmpl: TDataSource;
    qTEmpl: TMySQLQuery;
    tsEmpl: TTabSheet;
    tsTEmp: TTabSheet;
    DBGridEh4: TDBGridEh;
    Panel5: TPanel;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    DBGridEh6: TDBGridEh;
    Panel6: TPanel;
    qTEmplTypeEmpl_id: TAutoIncField;
    qTEmplpost: TMySQLStringField;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button13: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Button14: TButton;
    Edit12: TEdit;
    Edit13: TEdit;
    DBEditEh1: TDBEditEh;
    DBEditEh2: TDBEditEh;
    DBEditEh3: TDBEditEh;
    DBEditEh4: TDBEditEh;
    qHistory: TMySQLQuery;
    qPers: TMySQLQuery;
    qPersPers_id: TAutoIncField;
    qPersCard_id: TIntegerField;
    qPersFamily: TMySQLStringField;
    qPersName: TMySQLStringField;
    qPersParentName: TMySQLStringField;
    qPersTabNum: TMySQLStringField;
    qPersFlagKredita: TIntegerField;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure MySQLServerAfterDisconnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSpr: TfrmSpr;
  mysqlrec: mysql; //Global mysql struct
  connected: Integer; //Global var to keep track of whether we are connected

implementation

uses

  untDB, untGlobalVar , untDostup, untMifareDll, untFirst;
{$R *.dfm}

procedure TfrmSpr.Button1Click(Sender: TObject);
begin
  qPrava.Close;
  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into prava(name) values(''' + Edit1.Text + ''')');
  qTemp.ExecSQL;//('insert into prava(name) values(' + Edit1.Text + ')');
  qPrava.Open;
end;

procedure TfrmSpr.Button5Click(Sender: TObject);
begin
  qStateCard.Close;
  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into StateCard(name, description) values(''' + edState.Text + ''', ''' + edDescription.Text + ''')');
  qTemp.ExecSQL;//('insert into prava(name) values(' + Edit1.Text + ')');
  qStateCard.Open;
end;

procedure TfrmSpr.Button6Click(Sender: TObject);
begin
  qStateCard.Open;
end;

procedure TfrmSpr.Button7Click(Sender: TObject);
begin
  qStateCard.Close;
end;

procedure TfrmSpr.Button9Click(Sender: TObject);
begin
  qCard.Open;
end;

procedure TfrmSpr.Button10Click(Sender: TObject);
begin
  qCard.Close;
end;

procedure TfrmSpr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmSpr.tsPers.TabVisible := false;
  frmSpr.tsCard.TabVisible := false;
  frmSpr.tsStateCard.TabVisible := false;
  frmSpr.tsPrava.TabVisible := false;
  frmSpr.tsEmpl.TabVisible := false;
  frmSpr.tsTEmp.TabVisible := false;
  SelectSpr := false;
  frmSpr.qPers.Close;
  frmSpr.qPrava.Close;
  frmSpr.qStateCard.Close;
  frmSpr.qCard.Close;
  frmSpr.qEmployee.Close;
  frmSpr.qTEmpl.Close;
end;

procedure TfrmSpr.DBGridEh1DblClick(Sender: TObject);
begin
  case SelectSpr of
  true: //режим выборки данных из справочника
    begin
      frmDostup.edFIO.Text := DBGridEh1.Columns[2].Field.AsString;
      frmDostup.edName.Text := DBGridEh1.Columns[3].Field.AsString;
      frmDostup.edParentName.Text := DBGridEh1.Columns[4].Field.AsString;
      frmDostup.edPers_id.Text := DBGridEh1.Columns[0].Field.AsString;
      frmSpr.Close;
    end;
  false:
    begin
    end;
  end;
end;

procedure TfrmSpr.Button12Click(Sender: TObject);
var
  d : DWORD;
begin
  d := 0;
  a := MifareCardSerialNoGet(@d);
  case a of
    Mifare_Ok :
    begin
    end;
    MIFARE_NOTAGERR :
    begin
      MessageDlg('Ошибка чтени карты - Нет карты в поле антены', mtError, [mbOk], 0);
    end;
    else
    begin
      MessageDlg('Ошибка чтени карты. Код ошибки ' + IntToStr(a), mtError, [mbOk], 0);
    end;
  end;
end;

procedure TfrmSpr.Button14Click(Sender: TObject);
begin
  frmSpr.qPers.Post;
end;

procedure TfrmSpr.Button13Click(Sender: TObject);
begin
  frmSpr.qPers.Insert;
end;

procedure TfrmSpr.MySQLServerAfterDisconnect(Sender: TObject);
begin
  if not MySQLServer.Connected then
    MySQLServer.Connect;
end;

procedure TfrmSpr.FormCreate(Sender: TObject);
begin
try
  tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
  frmSpr.MySQLServer.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
  frmSpr.MySQLServer.Host := tIniSett.ReadString('MySQL', 'Host', '');
  frmSpr.MySQLServer.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
  tIniSett.Destroy;
  frmSpr.MySQLServer.Connect;
except
  ShowMessage('Невозможно загрузить систему, ошибка при инициализации базы!');
  frmSpr.MySQLServer.Disconnect;
  frmFirst.Close;
end;
end;

end.
