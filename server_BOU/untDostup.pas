unit untDostup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, Grids, DBGrids, DB, MySQLDataset,
  DBGridEh, ExtCtrls, Mask, DBCtrlsEh, DBLookupEh, CheckLst, untMifareDll,
  DBGridEhGrouping, GridsEh;

type
  TfrmDostup = class(TForm)
    qSelectPravo2: TMySQLQuery;
    dsSelPravo: TDataSource;
    qSelectPravo2nomer: TMySQLStringField;
    qSelectPravo2family: TMySQLStringField;
    qSelectPravo2name: TMySQLStringField;
    qSelectPravo2parentname: TMySQLStringField;
    qSelectPravo2post: TMySQLStringField;
    dsTEmpl: TDataSource;
    qTEmpl: TMySQLQuery;
    qInsert: TMySQLQuery;
    qTemp: TMySQLQuery;
    qSelectPravo2pers_id: TAutoIncField;
    PageControl1: TPageControl;
    tsEmpl: TTabSheet;
    tsPrava: TTabSheet;
    gbAction: TGroupBox;
    btnNew: TButton;
    btnChange: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    pnlNewEmpl: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    edFIO: TEdit;
    btnSelectEmpl: TButton;
    edPers_id: TEdit;
    cbTEmpl: TComboBox;
    btnAddEmpl: TButton;
    btnCancEmpl: TButton;
    btnSaveEmpl: TButton;
    edName: TEdit;
    edParentName: TEdit;
    DBGridEh1: TDBGridEh;
    dsPForEmpl: TDataSource;
    qPravaForEmpl: TMySQLQuery;
    qTEmplTypeEmpl_id: TAutoIncField;
    qTEmplPost: TMySQLStringField;
    btnClose2: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    edNewTEmpl: TEdit;
    btnNewTEmpl: TButton;
    GroupBox2: TGroupBox;
    btnEditPrava: TButton;
    ListBox2: TListBox;
    dbgPrava: TDBGridEh;
    ListBox1: TListBox;
    dbgTEmpl: TDBGridEh;
    Button1: TButton;
    edNumBSK: TEdit;
    Label5: TLabel;
    DBGridEh2: TDBGridEh;
    dsShowEmpl: TDataSource;
    qShowEmpl: TMySQLQuery;
    qShowEmplEmpl_id: TIntegerField;
    qShowEmpleTypeEmpl_id: TIntegerField;
    qShowEmplTradePoint_id: TLargeintField;
    qShowEmplNomerBSK: TMySQLStringField;
    qShowEmplFamily: TMySQLStringField;
    qShowEmplName: TMySQLStringField;
    qShowEmplParentName: TMySQLStringField;
    qShowEmpltTypeEmpl_id: TIntegerField;
    qShowEmplPost: TMySQLStringField;
    qShowEmplFlag: TLargeintField;
    cbFlag: TCheckBox;
    procedure btnSelectEmplClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddEmplClick(Sender: TObject);
    procedure btnCancEmplClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveEmplClick(Sender: TObject);
    procedure dbgTEmplCellClick(Column: TColumnEh);
    procedure btnClose2Click(Sender: TObject);
    procedure btnNewTEmplClick(Sender: TObject);
    procedure edNewTEmplChange(Sender: TObject);
    procedure btnEditPravaClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBGridEh2DblClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDostup: TfrmDostup;
  SetColor         : TColor;
function PD():boolean;

implementation

uses untSpravochnik, untGlobalVar, untChanPrava, untFirst, DateUtils;

{$R *.dfm}

procedure TfrmDostup.btnSelectEmplClick(Sender: TObject);
begin
  frmSpr.tsPers.TabVisible := true;
  frmSpr.qPers.Close;
  frmSpr.qPers.SQL.Clear;
  frmSpr.qPers.SQL.Add('Select * from pers where flagkredita=1 order by Family, name, parentname');
  frmSpr.qPers.Open;
  frmSpr.Show;
  SelectSpr := true;


//  frmSpr.tsPers.TabVisible := true;
//  frmSpr.qPers.Open;
//  frmSpr.Show;
//  SelectSpr := true;
end;

procedure TfrmDostup.FormShow(Sender: TObject);
begin
  frmDostup.qShowEmpl.Open;
  fncExecSQLFillCB('TypeEmployers', 'post', frmDostup.cbTEmpl);
  frmDostup.qTEmpl.Open;
  fncExecSQLFillLB('TypeEmployers', 'post', frmDostup.listbox1);
  frmDostup.dbgTEmpl.OnCellClick(nil);
end;

procedure TfrmDostup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmDostup.qShowEmpl.Close;
  frmDostup.qTEmpl.Close;
end;

procedure TfrmDostup.btnAddEmplClick(Sender: TObject);
var
  flag : string;
begin
//20090325 Lena{
  if trim(edFIO.Text) = '' then
  begin
    MessageDlg('������� �������!', mtError, [mbOK], 0);
    edFIO.SetFocus;
    exit;
  end;
  if trim(edName.Text) = '' then
  begin
    MessageDlg('������� ���!', mtError, [mbOK], 0);
    edName.SetFocus;
    exit;
  end;
  if trim(edParentName.Text) = '' then
  begin
    MessageDlg('������� ��������!', mtError, [mbOK], 0);
    edParentName.SetFocus;
    exit;
  end;
  if trim(edNumBSK.Text) = '' then
  begin
    MessageDlg('�������� � ���!', mtError, [mbOK], 0);
    edNumBSK.SetFocus;
    exit;
  end;
  if cbTEmpl.text = '' then
  begin
    MessageDlg('�������� ���������!', mtError, [mbOK], 0);
    cbTEmpl.SetFocus;
    exit;
  end;
  frmDostup.edPers_id.Text := IntToStr(SecondsBetween(StrtoDateTime('25.03.2009  00:00:00.000'), now)); //20090325 Lena

//20090325 Lena}

  if PD() then
  begin
    frmDostup.qTemp.SQL.Clear;
    frmDostup.qTemp.SQL.Add('select * from employee where empl_id = ' + edPers_id.Text);
    frmDostup.qTemp.Open;
    if not frmDostup.qTemp.Eof then
    begin
      MessageDlg('��������! ������ ��������� ��� ����� ������ � �������!' + #13#10 +'���� �� ������ �������� ����� �������, ������� ������ "��������"', mtWarning, [mbOK], 0);
      frmDostup.qTemp.Close;
    end
    else
    begin
      flag := '2';
      case cbflag.Checked of
        true:
          flag := '1';
      end;
      frmDostup.btnSaveEmpl.Visible := false;
      frmDostup.qShowEmpl.Close;
      frmDostup.qInsert.SQL.Clear;
  //  frmDostup.qInsert.SQL.Add('(select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''))');
      frmDostup.qInsert.SQL.Add('insert into employee(Empl_id, TypeEmpl_id, family, name, parentname, nomerbsk, flag) ');
      frmDostup.qInsert.SQL.Add('values (' + edPers_id.Text + ', (select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''), ');
      frmDostup.qInsert.SQL.Add(' ''' + edFIO.Text + ''', ');
      frmDostup.qInsert.SQL.Add(' ''' + edName.Text + ''', ');
      frmDostup.qInsert.SQL.Add(' ''' + edParentName.Text + ''', ');
      frmDostup.qInsert.SQL.Add(' ''' + edNumBSK.Text + ''', ');
      frmDostup.qInsert.SQL.Add(' ' + flag + ') ');
//      frmDostup.qInsert.SQL.Add('where Empl_id = ''' + edPers_id.Text + ''' ');

      frmDostup.qInsert.Execute(true);
      frmDostup.qShowEmpl.Open;
//      frmDostup.qSelectPravo.Close;
//      frmDostup.qInsert.SQL.Clear;
//      frmDostup.qInsert.SQL.Add('insert into employee(Empl_id, TypeEmpl_id) values(' + edPers_id.Text + ', (select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''))');
//      frmDostup.qInsert.Execute;
//      frmDostup.qSelectPravo.Open;
    end;
    frmDostup.pnlNewEmpl.Visible := false;
    frmDostup.gbAction.Visible := true;
    frmDostup.btnAddEmpl.Visible := false;
    frmDostup.edFIO.Text := '';
    frmDostup.edName.Text := '';
    frmDostup.edParentName.Text := '';
    frmDostup.edPers_id.Text := '';
    frmDostup.cbTEmpl.Text := '';
    frmDostup.edNumBSK.Text := '';
    frmDostup.cbFlag.Checked := false;
  end;
end;

procedure TfrmDostup.btnCancEmplClick(Sender: TObject);
begin
  frmDostup.pnlNewEmpl.Visible := false;
  frmDostup.gbAction.Visible := true;
  frmDostup.edFIO.Text := '';
  frmDostup.edName.Text := '';
  frmDostup.edParentName.Text := '';
  frmDostup.edPers_id.Text := '';
  frmDostup.cbTEmpl.Text := '';
  frmDostup.btnSaveEmpl.Visible := false;
  frmDostup.btnAddEmpl.Visible := false;
end;

procedure TfrmDostup.btnNewClick(Sender: TObject);
begin
  frmDostup.gbAction.Visible := false;
  frmDostup.pnlNewEmpl.Visible := true;
  frmDostup.btnAddEmpl.Visible := true;
  frmDostup.edFIO.SetFocus;
end;

procedure TfrmDostup.btnChangeClick(Sender: TObject);
begin
  frmDostup.gbAction.Visible := false;
  frmDostup.pnlNewEmpl.Visible := true;
  frmDostup.btnSaveEmpl.Visible := true;

  frmDostup.edFIO.Text := DBGridEh1.FieldColumns['Family'].Field.AsString;
  frmDostup.edName.Text := DBGridEh1.FieldColumns['Name'].Field.AsString;
  frmDostup.edParentName.Text := DBGridEh1.FieldColumns['Parentname'].Field.AsString;
  frmDostup.edPers_id.Text := DBGridEh1.FieldColumns['empl_id'].Field.AsString;
  frmDostup.cbTEmpl.Text := DBGridEh1.FieldColumns['post'].Field.AsString;
  frmDostup.edNumBSK.Text := DBGridEh1.FieldColumns['nomerbsk'].Field.AsString;
  frmDostup.cbFlag.Checked := false;
  case DBGridEh1.FieldColumns['flag'].Field.AsInteger of
    1:
      frmDostup.cbFlag.Checked := true;
  end;

//  frmDostup.edFIO.Text := '';
//  frmDostup.edName.Text := '';
//  frmDostup.edParentName.Text := '';
//  frmDostup.cbTEmpl.Text := '';
end;

procedure TfrmDostup.btnCloseClick(Sender: TObject);
begin
  close;
end;

function PD():boolean;
var
  Dostup1, Dostup2 : integer;
begin
  result := true;
  frmDostup.qTemp.Close;
  frmDostup.qTemp.SQL.Clear;
  frmDostup.qTemp.SQL.Add('select min(pe.prava_id) as minpr ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) ');
  frmDostup.qTemp.SQL.Add('where (pe.typeempl_id = (select typeempl_id from typeemployers where post = ''' + frmDostup.cbTEmpl.Text + ''')) ');
  frmDostup.qTemp.Open;
  Dostup1 := frmDostup.qTemp.fieldbyname('minpr').AsInteger;

  frmDostup.qTemp.Close;
  frmDostup.qTemp.SQL.Clear;
  frmDostup.qTemp.SQL.Add('select min(pe.prava_id) as minpr ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) ');
  frmDostup.qTemp.SQL.Add('where pe.typeempl_id = ' + IntTostr(TypeEmpl_id) + ' ');
  frmDostup.qTemp.Open;
  Dostup2 := frmDostup.qTemp.fieldbyname('minpr').AsInteger;

  if Dostup1 < Dostup2 then
  begin
    MessageDlg('������ ������� �� ������� ����� ��������� ����� ���������!', mtError, [mbOK], 0);
    result := false;
  end;
//  ShowMessage('��� ������ ' + IntTostr(Dostup2) + ', ������������� ������ ' + IntTostr(Dostup1));
//  TypeEmpl_id
end;

procedure TfrmDostup.btnSaveEmplClick(Sender: TObject);
var
  flag : string;
begin
  if PD() then
  begin
    flag := '2';
    case cbflag.Checked of
      true:
        flag := '1';
    end;
    frmDostup.btnSaveEmpl.Visible := false;

    frmDostup.qShowEmpl.Close;
    frmDostup.qInsert.SQL.Clear;
  //  frmDostup.qInsert.SQL.Add('(select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''))');
    frmDostup.qInsert.SQL.Add('update employee ');
    frmDostup.qInsert.SQL.Add('set TypeEmpl_id = (select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''), ');
    frmDostup.qInsert.SQL.Add('family = ''' + edFIO.Text + ''', ');
    frmDostup.qInsert.SQL.Add('name = ''' + edName.Text + ''', ');
    frmDostup.qInsert.SQL.Add('parentname = ''' + edParentName.Text + ''', ');
    frmDostup.qInsert.SQL.Add('nomerbsk = ''' + edNumBSK.Text + ''', ');
    frmDostup.qInsert.SQL.Add('flag = ''' + flag + ''' ');
    frmDostup.qInsert.SQL.Add('where Empl_id = ''' + edPers_id.Text + ''' ');

    frmDostup.qInsert.Execute;
    frmDostup.qShowEmpl.Open;

    frmDostup.pnlNewEmpl.Visible := false;
    frmDostup.gbAction.Visible := true;
    frmDostup.btnSaveEmpl.Visible := false;

    frmDostup.edFIO.Text := '';
    frmDostup.edName.Text := '';
    frmDostup.edParentName.Text := '';
    frmDostup.edPers_id.Text := '';
    frmDostup.cbTEmpl.Text := '';
    frmDostup.edNumBSK.Text := '';
    frmDostup.cbFlag.Checked := false;
  end;
end;

procedure TfrmDostup.dbgTEmplCellClick(Column: TColumnEh);
var
  id : string;
begin
  id := dbgTEmpl.Columns[0].Field.AsString;
  frmDostup.qPravaForEmpl.Close;
  frmDostup.qPravaForEmpl.SQL.Clear;

  frmDostup.qPravaForEmpl.SQL.Add('SELECT te.typeempl_id, pr.name ');
  frmDostup.qPravaForEmpl.SQL.Add('FROM typeemployers te ');
  frmDostup.qPravaForEmpl.SQL.Add('left join pravafortypeemployee pe on (pe.typeempl_id = te.typeempl_id) ');
  frmDostup.qPravaForEmpl.SQL.Add('left join prava pr on (pr.prava_id = pe.prava_id) ');
  frmDostup.qPravaForEmpl.SQL.Add('where pe.typeempl_id = ''' + id + ''' ');

  frmDostup.qPravaForEmpl.Execute;
  frmDostup.qPravaForEmpl.Open;
  frmDostup.dbgPrava.Visible := true;
  frmDostup.btnEditPrava.Enabled := true;
end;

procedure TfrmDostup.btnClose2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmDostup.btnNewTEmplClick(Sender: TObject);
begin
  frmDostup.qTEmpl.Close;

  frmDostup.qInsert.Close;
  frmDostup.qInsert.SQL.Clear;
  frmDostup.qInsert.SQL.Add(' insert typeemployers(post) values( ''' + edNewTEmpl.Text + ''')');
  frmDostup.qInsert.Execute;
  frmDostup.qInsert.Open;

  frmDostup.qTEmpl.Open;
end;

procedure TfrmDostup.edNewTEmplChange(Sender: TObject);
begin
  case length(edNewTEmpl.Text) of
  0 :
    frmDostup.btnNewTEmpl.Enabled := false;
  else
    frmDostup.btnNewTEmpl.Enabled := true;
  end;
end;

procedure TfrmDostup.btnEditPravaClick(Sender: TObject);
begin
//  frmChangePrava.Caption := frmDostup.ListBox1.Items.Strings[frmDostup.ListBox1.itemindex];
  frmChangePrava.Caption := dbgTEmpl.Columns[1].Field.AsString;
  frmChangePrava.ShowModal;
end;

procedure TfrmDostup.ListBox1Click(Sender: TObject);
var
  s, sql : string;
begin
  frmDostup.ListBox2.Clear;
  s := frmDostup.ListBox1.Items.Strings[frmDostup.ListBox1.itemindex];
//  id := dbgTEmpl.Columns[0].Field.AsString;
  frmDostup.qPravaForEmpl.Close;
  frmDostup.qPravaForEmpl.SQL.Clear;
  sql := '';
  sql := 'SELECT te.typeempl_id, pr.name as nam ';
  sql := sql + 'FROM typeemployers te ';
  sql := sql + 'left join pravafortypeemployee pe on (pe.typeempl_id = te.typeempl_id) ';
  sql := sql + 'left join prava pr on (pr.prava_id = pe.prava_id) ';
  sql := sql + 'where te.post = ''' + s + ''' ';
  frmDostup.qPravaForEmpl.SQL.Add(sql);
//  frmDostup.qPravaForEmpl.SQL.Add('SELECT te.typeempl_id, pr.name as nam ');
//  frmDostup.qPravaForEmpl.SQL.Add('FROM typeemployers te ');
//  frmDostup.qPravaForEmpl.SQL.Add('left join pravafortypeemployee pe on (pe.typeempl_id = te.typeempl_id) ');
//  frmDostup.qPravaForEmpl.SQL.Add('left join prava pr on (pr.prava_id = pe.prava_id) ');
//  frmDostup.qPravaForEmpl.SQL.Add('where te.post = ''' + s + ''' ');

//  frmDostup.qPravaForEmpl.Execute;
  frmDostup.qPravaForEmpl.Open;
  frmDostup.qPravaForEmpl.First;
  while not frmDostup.qPravaForEmpl.Eof do
  begin
    frmDostup.ListBox2.Items.Add(frmDostup.qPravaForEmpl.FieldByName('nam').AsString);
    frmDostup.qPravaForEmpl.Next;
  end;
  //frmDostup.dbgPrava.Visible := true;

end;

procedure TfrmDostup.Button1Click(Sender: TObject);
var
  DW : DWORD;
begin
  IniReader();
  MessageDlg('��������� ��� � �����������!', mtInformation, [mbOK], 0);
  DW := 0;
  MifareCardSerialNoGet(@DW);
  frmDostup.edNumBSK.Text :=IntToStr(DW);
{  CardNo := 0;
  a := MifareCardSerialNoGet(@CardNo); // ' --- ������ ������ ����� --- ');
  case a of
    Mifare_Ok :
    begin
      frmDostup.edNumBSK.Text := IntToStr(CardNo);
    end;
    MIFARE_NOTAGERR :
    begin
      MessageDlg('������ ������ ����� - ��� ����� � ���� ������', mtError, [mbOk], 0);
    end;
    else
    begin
      MessageDlg('������ ������ �����. ��� ������ ' + IntToStr(a), mtError, [mbOk], 0);
    end;
  end;}
end;

procedure TfrmDostup.DBGridEh2DblClick(Sender: TObject);
begin
  edFIO.Text := frmDostup.DBGridEh2.Columns[1].Field.AsString;
  edPers_id.Text := frmDostup.DBGridEh2.Columns[5].Field.AsString;
  edName.Text := frmDostup.DBGridEh2.Columns[2].Field.AsString;
  edParentName.Text := frmDostup.DBGridEh2.Columns[3].Field.AsString;
  edNumBSK.Text := frmDostup.DBGridEh2.Columns[0].Field.AsString;
  cbTEmpl.Text := frmDostup.DBGridEh2.Columns[4].Field.AsString;
end;

procedure TfrmDostup.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  DBGridEh1.FieldColumns['Flag'].KeyList.Add('1');
  DBGridEh1.FieldColumns['Flag'].KeyList.Add('2');
  DBGridEh1.FieldColumns['Flag'].Checkboxes := true;

  if Column.Field.DataSet.FieldByName('Flag').AsString = '2' then
  begin
//    Background := clSilver;
    Background := clSkyBlue; //   SetColor
//    Background := SetColor;
  end;
end;

end.
