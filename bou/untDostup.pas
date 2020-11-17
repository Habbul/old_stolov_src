unit untDostup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, Grids, DBGrids, DB, MySQLDataset,
  DBGridEh, ExtCtrls, Mask, DBCtrlsEh, DBLookupEh, CheckLst, GridsEh;

type
  TfrmDostup = class(TForm)
    qSelectPravo: TMySQLQuery;
    dsSelPravo: TDataSource;
    qSelectPravonomer: TMySQLStringField;
    qSelectPravofamily: TMySQLStringField;
    qSelectPravoname: TMySQLStringField;
    qSelectPravoparentname: TMySQLStringField;
    qSelectPravopost: TMySQLStringField;
    dsTEmpl: TDataSource;
    qTEmpl: TMySQLQuery;
    qInsert: TMySQLQuery;
    qTemp: TMySQLQuery;
    qSelectPravopers_id: TAutoIncField;
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
    qDelete: TMySQLQuery;
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
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDostup: TfrmDostup;
function PD():boolean;

implementation

uses untSpravochnik, untGlobalVar, untChanPrava, untFirst;

{$R *.dfm}

function SelectRec(TabSh : TTabSheet):integer;
begin

end;

procedure TfrmDostup.btnSelectEmplClick(Sender: TObject);
begin
  frmSpr.tsPers.TabVisible := true;
  frmSpr.qPers.Close;
  frmSpr.qPers.SQL.Clear;
  frmSpr.qPers.SQL.Add('Select * from pers where flagkredita=1 order by Family, name, parentname');
  frmSpr.qPers.Open;
  frmSpr.Show;
  SelectSpr := true;
end;

procedure TfrmDostup.FormShow(Sender: TObject);
begin
  frmDostup.qSelectPravo.Open;
  fncExecSQLFillCB('TypeEmployers', 'post', frmDostup.cbTEmpl);
  frmDostup.qTEmpl.Open;
  fncExecSQLFillLB('TypeEmployers', 'post', frmDostup.listbox1);
  frmDostup.dbgTEmpl.OnCellClick(nil);
end;

procedure TfrmDostup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmDostup.qSelectPravo.Close;
  frmDostup.qTEmpl.Close;
end;

procedure TfrmDostup.btnAddEmplClick(Sender: TObject);
begin
  if PD() then
  begin
    frmDostup.qTemp.SQL.Clear;
    frmDostup.qTemp.SQL.Add('select * from employee where empl_id = ' + edPers_id.Text);
    frmDostup.qTemp.Open;
    if not frmDostup.qTemp.Eof then
    begin
      MessageDlg('Внимание! Данный сотрудник уже имеет доступ к системе!' + #13#10 +'Если Вы хотите изменить право доступа, нажмите кнопку "Изменить"', mtWarning, [mbOK], 0);
      frmDostup.qTemp.Close;
    end
    else
    begin
      frmDostup.qSelectPravo.Close;
      frmDostup.qInsert.SQL.Clear;
      frmDostup.qInsert.SQL.Add('insert into employee(Empl_id, TypeEmpl_id) values(' + edPers_id.Text + ',');
      frmDostup.qInsert.SQL.Add('(select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + ''') )');
      frmDostup.qInsert.Execute;
      frmDostup.qSelectPravo.Open;
    end;
    frmDostup.pnlNewEmpl.Visible := false;
    frmDostup.gbAction.Visible := true;
    frmDostup.btnAddEmpl.Visible := false;
    frmDostup.edFIO.Text := '';
    frmDostup.edName.Text := '';
    frmDostup.edParentName.Text := '';
    frmDostup.edPers_id.Text := '';
    frmDostup.cbTEmpl.Text := '';
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
end;

procedure TfrmDostup.btnChangeClick(Sender: TObject);
begin
  frmDostup.gbAction.Visible := false;
  frmDostup.pnlNewEmpl.Visible := true;
  frmDostup.btnSaveEmpl.Visible := true;

  frmDostup.edFIO.Text := DBGridEh1.Columns[1].Field.AsString;
  frmDostup.edName.Text := DBGridEh1.Columns[2].Field.AsString;
  frmDostup.edParentName.Text := DBGridEh1.Columns[3].Field.AsString;
  frmDostup.edPers_id.Text := DBGridEh1.Columns[5].Field.AsString;
  frmDostup.cbTEmpl.Text := DBGridEh1.Columns[4].Field.AsString;

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
    MessageDlg('Вашего доступа не хватает чтобы поставить такую должность!', mtError, [mbOK], 0);
    result := false;
  end;
//  ShowMessage('Ваш доступ ' + IntTostr(Dostup2) + ', присваиваемый доступ ' + IntTostr(Dostup1));
//  TypeEmpl_id
end;

procedure TfrmDostup.btnSaveEmplClick(Sender: TObject);
begin
  if PD() then
  begin
    frmDostup.btnSaveEmpl.Visible := false;

    frmDostup.qSelectPravo.Close;
    frmDostup.qInsert.SQL.Clear;
  //  frmDostup.qInsert.SQL.Add('(select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + '''))');
    frmDostup.qInsert.SQL.Add('update employee ');
    frmDostup.qInsert.SQL.Add('set TypeEmpl_id = (select typeempl_id from typeemployers where post = ''' + cbTEmpl.Text + ''') ');
    frmDostup.qInsert.SQL.Add('where Empl_id = ''' + edPers_id.Text + ''' ');

    frmDostup.qInsert.Execute;
    frmDostup.qSelectPravo.Open;

    frmDostup.pnlNewEmpl.Visible := false;
    frmDostup.gbAction.Visible := true;
    frmDostup.btnSaveEmpl.Visible := false;

    frmDostup.edFIO.Text := '';
    frmDostup.edName.Text := '';
    frmDostup.edParentName.Text := '';
    frmDostup.edPers_id.Text := '';
    frmDostup.cbTEmpl.Text := '';
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

procedure TfrmDostup.btnDeleteClick(Sender: TObject);
var
  Pers_id : string;
begin
  ShowMessage('Pers_id=' + DBGridEh1.Columns[5].Field.AsString);
  Pers_id := DBGridEh1.Columns[5].Field.AsString;
  frmDostup.qDelete.SQL.Clear;
  frmDostup.qDelete.SQL.Add('delete from employee where empl_id = ' + Pers_id);
  frmDostup.qDelete.Execute(true);
  frmDostup.qSelectPravo.Close;
  frmDostup.qSelectPravo.Open;
  //нужно завести новый столбец в таблице employee - флаг об удалении
  //и в запросе у qSelectPravo добавить условие: выводить тех, кто не удален
end;

end.
