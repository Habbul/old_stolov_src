unit untUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBTables, Grids, DBGrids, MySQLDataset, ExtCtrls,
  Gauges, ComCtrls, DBGridEh, Math;

type
  TfrmUpdate = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    DataSource1: TDataSource;
    btnClose: TButton;
    qUpdate: TMySQLQuery;
    qSelect: TMySQLQuery;
    btnStep1: TButton;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    Label2: TLabel;
    btnLoading: TButton;
    imgStep2: TImage;
    imgStep1: TImage;
    imgGreen: TImage;
    imgGrey: TImage;
    Table1: TTable;
    btnStep2: TButton;
    qTemp: TMySQLQuery;
    procedure Button1Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnStep1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadingClick(Sender: TObject);
    procedure btnStep2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdate: TfrmUpdate;

implementation

uses untSpravochnik, DateUtils, untGlobalVar, untThread;

{$R *.dfm}

procedure TfrmUpdate.Button1Click(Sender: TObject);
begin
  frmUpdate.imgStep1.Picture := frmUpdate.imgGrey.Picture;
  frmUpdate.imgStep2.Picture := frmUpdate.imgGrey.Picture;
  frmUpdate.ProgressBar1.Position := 0;
  Table1.Close;
  if OpenDialog1.Execute then
  begin
    Table1.DatabaseName := ExtractFilePath(OpenDialog1.FileName);
    Edit1.Text := OpenDialog1.FileName;
    Table1.TableName := ExtractFileName(OpenDialog1.FileName);
    Table1.Open;
  end;
end;

procedure TfrmUpdate.btnCloseClick(Sender: TObject);
begin
  Table1.Close;
  close;
end;

procedure TfrmUpdate.btnStep1Click(Sender: TObject);
var
  datab, datae : string;
  period, day : integer;
//  CardUpd, CardIns, PersUpd, PersIns : integer;
begin
  frmUpdate.btnClose.Enabled := false;
  frmUpdate.ProgressBar1.Position := 0;
//  CardUpd := 0;
//  CardIns := 0;
//  PersUpd := 0;
//  PersIns := 0;

  qUpdate.Close;
  qUpdate.SQL.Clear;
  qUpdate.SQL.Add('update pers set flagKredita = 2');
  qUpdate.Execute;

  qUpdate.SQL.Clear;
  qUpdate.SQL.Add('update card set StateCard_id = 2');
  qUpdate.Execute;

  frmUpdate.ProgressBar1.Max := Table1.RecordCount;
  Table1.First;

  qUpdate.SQL.Clear;
  qUpdate.SQL.Add('delete from temp');
  qUpdate.Execute;

  while not Table1.Eof do
  begin
    frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position + 1;
    qUpdate.SQL.Clear;
    qUpdate.SQL.Add('insert into temp(tabnum, family, name, parentname, sumcredit, DateBegin, DateEnd, nomer) ');
    qUpdate.SQL.Add('values("' + Table1.FieldByName('tabnum').AsString  + '", ');
    qUpdate.SQL.Add(' "' + Table1.FieldByName('family').AsString  + '", ');
    qUpdate.SQL.Add(' "' + Table1.FieldByName('name').AsString  + '", ');
    qUpdate.SQL.Add(' "' + Table1.FieldByName('parentname').AsString  + '", ');
    qUpdate.SQL.Add(Table1.FieldByName('sumcredit').AsString  + ', ');

    period := Table1.FieldByName('period').AsInteger;
    case period of
      1:
      begin
        datab := Table1.FieldByName('year').AsString + '-' + Table1.FieldByName('month').AsString + '-01';
        datae := Table1.FieldByName('year').AsString + '-' + Table1.FieldByName('month').AsString + '-14';
      end;
      2:
      begin
        day := DaysInAMonth(Table1.FieldByName('year').AsInteger, Table1.FieldByName('month').AsInteger);
        datab := Table1.FieldByName('year').AsString + '-' + Table1.FieldByName('month').AsString + '-15';
        datae := Table1.FieldByName('year').AsString + '-' + Table1.FieldByName('month').AsString + '-' + inttostr(day);
      end;
    end;
    qUpdate.SQL.Add(''''+ datab + ''', ''' + datae + ''', ');
    qUpdate.SQL.Add(' "' + Table1.FieldByName('nomer').AsString  + '") ');
    qUpdate.Execute;
    Table1.Next;
  end;
  Application.ProcessMessages;
//  Memo1.Lines.Add('Заполнили Update ' + timetostr(now));
  frmUpdate.imgStep1.Picture := frmUpdate.imgGreen.Picture;
  frmUpdate.ProgressBar1.Position := 0;
end;

procedure TfrmUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmUpdate.imgStep1.Picture := frmUpdate.imgGrey.Picture;
  frmUpdate.imgStep2.Picture := frmUpdate.imgGrey.Picture;
end;

procedure TfrmUpdate.btnLoadingClick(Sender: TObject);
begin
  frmUpdate.btnStep1.Click;
  frmUpdate.btnStep2.Click;
end;

procedure TfrmUpdate.btnStep2Click(Sender: TObject);
begin
  frmUpdate.ProgressBar1.Max := 60;
  Application.ProcessMessages;
  frmUpdate.ProgressBar1.Position := 0;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into historyevents(OperTime, Empl_id, Event_id, memo)');
  qTemp.SQL.Add('values(Now(), 1, 13, 158)');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 5;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into creditshistory(card_id, Empl_idB, datebegin, dateEnd, sumcredit, DateUpd, Empl_idE)');
  qTemp.SQL.Add('select c.card_id, c.Empl_id, c.DateBegin, c.DateEnd, c.SumCredit, Now(), 1 from credits c');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 10;

//  qTemp.SQL.Clear;
//  qTemp.SQL.Add('delete from credits');
//  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 15;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*3;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('update card c set c.statecard_id = 1');
  qTemp.SQL.Add('where c.nomer in (select t.nomer from temp t)');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 20;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*4;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('update pers set pers.flagkredita = 1 where card_id in (SELECT c.card_id FROM card c, temp t');
  qTemp.SQL.Add('where c.nomer = t.nomer and c.card_id = pers.card_id)');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 25;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*5;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into credits(card_id, datebegin, dateEnd, sumcredit, Empl_id)');
  qTemp.SQL.Add('select c.card_id, t.DateBegin, t.DateEnd, t.SumCredit, 1 from temp t, card c where t.nomer = c.nomer');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 30;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*6;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('delete from temp where nomer in');
  qTemp.SQL.Add('(select c.nomer from card c)');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 35;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*7;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into card(StateCard_id, nomer)');
  qTemp.SQL.Add('select Flagkredita, nomer from temp');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 40;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*8;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into pers(card_id, family, name, parentname, tabnum, flagkredita)');
  qTemp.SQL.Add('select c.card_id, t.family, t.name, t.parentname, t.tabnum, t.Flagkredita from temp t, card c');
  qTemp.SQL.Add('where c.nomer = t.nomer');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 45;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*9;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into credits(card_id, datebegin, dateEnd, sumcredit, Empl_id)');
  qTemp.SQL.Add('select c.card_id, t.DateBegin, t.DateEnd, t.SumCredit, 1 from temp t, card c where t.nomer = c.nomer');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 50;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*10;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('delete from temp');
  qTemp.Execute(true);

  frmUpdate.ProgressBar1.Position := 55;
//  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Position/12*11;

  qTemp.SQL.Clear;
  qTemp.SQL.Add('insert into historyevents(OperTime, Empl_id, Event_id, memo)');
  qTemp.SQL.Add('values(Now(), 1, 14, 444)');
  qTemp.Execute(true);

  frmUpdate.imgStep2.Picture := frmUpdate.imgGreen.Picture;
  frmUpdate.ProgressBar1.Position := frmUpdate.ProgressBar1.Max;
  frmUpdate.btnClose.Enabled := true;
//  ShowMessage('Все!');
end;

end.

