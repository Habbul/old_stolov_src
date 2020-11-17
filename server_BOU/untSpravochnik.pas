unit untSpravochnik;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGridEh, ComCtrls, ExtCtrls, DB, DBTables, StdCtrls,
  MySQLDataset, MySQLServer, Mask, DBCtrlsEh, IniFiles, GridsEh,
  DBGridEhGrouping;

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
    Beznal: TDatabase;
    tStopList: TTable;
    qStopList: TMySQLQuery;
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
//  mysqlrec: mysql; //Global mysql struct
  connected: Integer; //Global var to keep track of whether we are connected

implementation

uses
  untDB, untGlobalVar, untDostup, untMifareDll, untExport2, untMain,
  untFirst, untLogo;
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
end;

procedure TfrmSpr.DBGridEh1DblClick(Sender: TObject);
begin
  case SelectSpr of
  true: //����� ������� ������ �� �����������
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

  case SelectReport of
  true: //����� ������� ������ ��� ������
    begin
      frmExport2.edFIO.Text := DBGridEh1.Columns[2].Field.AsString;
      frmExport2.edName.Text := DBGridEh1.Columns[3].Field.AsString;
      frmExport2.edParentName.Text := DBGridEh1.Columns[4].Field.AsString;
      frmExport2.edPers_id.Text := DBGridEh1.Columns[0].Field.AsString;
      frmExport2.edCard_Id.Text := DBGridEh1.Columns[1].Field.AsString;
      frmExport2.edTabNum.Text := DBGridEh1.Columns[5].Field.AsString;
      frmSpr.Close;
      frmExport2.btnVedOfPers.Visible := true;
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
      MessageDlg('������ ����� ����� - ��� ����� � ���� ������', mtError, [mbOk], 0);
    end;
    else
    begin
      MessageDlg('������ ����� �����. ��� ������ ' + IntToStr(a), mtError, [mbOk], 0);
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

function fncUpdStopList() : boolean; // ���������� ���������
var
  sStopList : string;
  sTabNamStopList : string;
begin
try
  tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
  frmSpr.MySQLServer.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
  frmSpr.MySQLServer.Host := tIniSett.ReadString('MySQL', 'Host', '');
  frmSpr.MySQLServer.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
  sStopList := tIniSett.ReadString('Setting', 'StopList', '');
  sTabNamStopList := tIniSett.ReadString('Setting', 'TabNamStoplist', '');
  tIniSett.Destroy;
  frmSpr.MySQLServer.Connect;
except
  ShowMessage('���������� ��������� �������, ������ ��� ������������� ����!');
  frmSpr.MySQLServer.Disconnect;
  frmFirst.Close;
end;
  if FileExists(sStopList + sTabNamStopList) then  //����� ����� ������ ����-�����
  begin
    frmFirst.lDateStopList.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss', FileDateToDateTime(FileAge(sStopList + sTabNamStopList)));

    frmSpr.tStopList.DatabaseName := sStopList;
    frmSpr.tStopList.TableName := sTabNamStopList;

    frmSpr.qStopList.SQL.Clear;                    //�������� ������� ����-����� //������� ������ � ������ 1, �� ���� ��, ������� ��������� �� 1�
    frmSpr.qStopList.SQL.Add('delete from stoplist where flag=1');               //���� 2 - ������, ������� ��������� �����
    frmSpr.qStopList.Execute;

    frmSpr.tStopList.Open;
    frmSpr.tStopList.First;                        //���������� ����-�����
    while not frmSpr.tStopList.Eof do
    begin
      frmSpr.qStopList.SQL.Clear;
      frmSpr.qStopList.SQL.Add('insert into stoplist(Nomer, DateInsert, flag)');
      frmSpr.qStopList.SQL.Add('values("' + frmSpr.tStopList.FieldByName('Nomer').AsString  + '", Now(), 1)');
      frmSpr.qStopList.Execute;
      frmSpr.tStopList.Next;
    end;
    frmSpr.tStopList.Close;
    frmFirst.lDateLastUpd.Caption := DateTimeToStr(Now());
    DeleteFile(sStopList + sTabNamStopList);       //�������� ����� ������ ����-�����
    // ������� ������ ������� ���������� ���������� ����-����� � ���� ��������
    tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
    tIniSett.WriteString('OutputData', 'DateStopList', frmFirst.lDateStopList.Caption);
    tIniSett.Destroy;
  end
  else
  begin
    // ����� ���� �� ����� ��������
    tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
    frmFirst.lDateStopList.Caption := tIniSett.ReadString('OutputData', 'DateStopList', '�� ��������');
    tIniSett.Destroy;
    //
  end;
  frmSpr.qTemp.Close;
  frmSpr.qTemp.SQL.Clear;
  frmSpr.qTemp.SQL.Add('select max(dateinsert) as md from stoplist ');
  frmSpr.qTemp.Open;
  if frmSpr.qTemp.fieldByName('md').AsDateTime <> 0 then
    frmFirst.lDateLastUpd.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss', frmSpr.qTemp.fieldByName('md').AsDateTime);
  frmSpr.qTemp.Close;
end;

procedure TfrmSpr.FormCreate(Sender: TObject);
begin
  frmLogo.lAction.Caption := '�������� ����-�����';
  frmLogo.Update;
  fncUpdStopList();
end;

end.
