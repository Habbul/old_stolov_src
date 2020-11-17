unit untStop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGridEh, MySQLDataset, StdCtrls, Buttons;

type
  TfrmStopList = class(TForm)
    MySQLQuery1: TMySQLQuery;
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    edFIO: TEdit;
    dbgNewStop: TDBGridEh;
    dsSearch: TDataSource;
    qSearch: TMySQLQuery;
    GroupBox2: TGroupBox;
    DBGridEh1: TDBGridEh;
    btnAddStop: TButton;
    btnExit: TBitBtn;
    edBSKNo: TEdit;
    qUpdateStop: TMySQLQuery;
    btnShowStop: TButton;
    procedure edFIOChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dbgNewStopDblClick(Sender: TObject);
    procedure btnAddStopClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnShowStopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStopList: TfrmStopList;

implementation

uses untSpravochnik, untGlobalVar;

{$R *.dfm}

procedure TfrmStopList.edFIOChange(Sender: TObject);
begin
  frmStopList.btnAddStop.Visible := false;
  frmStopList.edBSKNo.Clear;
//  btnSearch.Visible := true;
//  if Length(frmStopList.edFIO.Text)=0 then
//    btnSearch.Visible := false;
  frmStopList.qSearch.Close;
  frmStopList.qSearch.SQL.Clear;
  frmStopList.qSearch.SQL.Add('select concat(p.family,' + ''' ''' + ', p.name, ' + ''' ''' +  ', p.parentname) as FIO, p.tabnum, c.nomer, c.card_id, p.pers_id ');
  frmStopList.qSearch.SQL.Add('from card c, pers p ');
  frmStopList.qSearch.SQL.Add('where c.statecard_id = 1 and c.card_id = p.card_id and ');
  frmStopList.qSearch.SQL.Add('LOCATE(''' + frmStopList.edFIO.Text + ''', ');
  frmStopList.qSearch.SQL.Add('concat(p.family,' + ''' ''' + ', p.name, ' + ''' ''' +  ', p.parentname))=1 ');
  frmStopList.qSearch.SQL.Add('order by p.family, p.name, p.parentname');
//  frmStopList.qSearch.SQL.Add('where c.statecard_id = 1 and c.card_id = p.card_id order by p.family, p.name, p.parentname');
  frmStopList.qSearch.Open;
end;

procedure TfrmStopList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmStopList.qSearch.Close;
  frmStopList.MySQLQuery1.Close;
  frmStopList.edFIO.Clear;
  frmStopList.edBSKNo.Clear;
  frmStopList.btnAddStop.Visible := false;
end;

procedure TfrmStopList.FormShow(Sender: TObject);
begin
  frmStopList.btnShowStop.Click;
  frmStopList.edFIO.SetFocus;
end;

procedure TfrmStopList.dbgNewStopDblClick(Sender: TObject);
begin
  frmStopList.edFIO.Text := frmStopList.dbgNewStop.Columns[0].Field.AsString;
  frmStopList.edBSKNo.Text := frmStopList.dbgNewStop.Columns[2].Field.AsString;
  CurrentCardId := frmStopList.dbgNewStop.Columns[3].Field.AsString;
  CurrentPersId := frmStopList.dbgNewStop.Columns[4].Field.AsString;
  frmStopList.btnAddStop.Visible := true;
end;

procedure TfrmStopList.btnAddStopClick(Sender: TObject);
begin
  if frmStopList.edBSKNo.Text = '' then
  begin
   ShowMessage('Не выбран сотрудник! Щелкните 2 раз мышкой на его фамилии!');
   exit;
  end;
  //выставляем флаг не кредитуемости у БСК
  frmStopList.qUpdateStop.SQL.Clear;
  frmStopList.qUpdateStop.SQL.Add('update card set Statecard_id=2 where nomer =''' + frmStopList.edBSKNo.Text + ''' ');
  frmStopList.qUpdateStop.Execute;

  //выставляем флаг не кредитуемости у сотрудника, владельца сего БСК
  frmStopList.qUpdateStop.SQL.Clear;
  frmStopList.qUpdateStop.SQL.Add('update pers set flagkredita=2 where card_id=' + CurrentCardId);
  frmStopList.qUpdateStop.Execute;

  //добавляем событие: БСК занесено в стоплист
  frmStopList.qUpdateStop.SQL.Clear;
  frmStopList.qUpdateStop.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo) ');
  frmStopList.qUpdateStop.SQL.Add('values(Now(), 11, ' + CurrentCardId + ',' + CurrentPersId + ', ');
  frmStopList.qUpdateStop.SQL.Add(CurrentEmplId + ', ' + frmStopList.edBSKNo.Text + ' )');
  frmStopList.qUpdateStop.ExecSQL;

  ShowMessage('Сотрудник добавлен в стоп лист');
  frmStopList.btnShowStop.Click;
  frmStopList.edFIO.SetFocus;
end;

procedure TfrmStopList.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmStopList.btnShowStopClick(Sender: TObject);
var
  text : string;
begin
  frmStopList.MySQLQuery1.Close;
  frmStopList.MySQLQuery1.SQL.Clear;
  frmStopList.MySQLQuery1.SQL.Add('select concat(p.family,' + ''' ''' + ', p.name, ' + ''' ''' +  ', p.parentname) as FIO, p.tabnum, c.nomer ');
  frmStopList.MySQLQuery1.SQL.Add('from card c, pers p ');
  frmStopList.MySQLQuery1.SQL.Add('where c.statecard_id = 2 and c.card_id = p.card_id order by p.family, p.name, p.parentname');
  frmStopList.MySQLQuery1.Open;
end;

end.
