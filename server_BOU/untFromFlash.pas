unit untFromFlash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, Buttons, DB, MySQLDataset,
  MySQLServer, IniFiles, DateUtils, untInFlash, Grids, DBGridEh, Math,
  DBGridEhGrouping, GridsEh;

type
  TfrmFromFlash = class(TForm)
    Panel2: TPanel;
    btnExit: TBitBtn;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    btnStep1: TBitBtn;
    btnStep3: TButton;
    btnStep2: TButton;
    pbExport: TProgressBar;
    btnStep4: TButton;
    pnlStep1: TPanel;
    lStep1: TLabel;
    Image3: TImage;
    Panel3: TPanel;
    Label4: TLabel;
    pnlStep2: TPanel;
    Image1: TImage;
    lStep2: TLabel;
    pnlStep5: TPanel;
    Image4: TImage;
    Label3: TLabel;
    pnlStep3: TPanel;
    Image5: TImage;
    lStep3: TLabel;
    pnlStep4: TPanel;
    Image2: TImage;
    Label5: TLabel;
    cbPunct: TComboBox;
    qDateFlash: TMySQLQuery;
    GroupBox1: TGroupBox;
    DBGridEh1: TDBGridEh;
    qImport: TMySQLQuery;
    dsDateFlash: TDataSource;
    qTempSale1: TMySQLTable;
    qInsert: TMySQLQuery;
    qTempSale1TradePoint_id: TLargeintField;
    qTempSale1Card_id: TLargeintField;
    qTempSale1Empl_id: TLargeintField;
    qTempSale1Summa: TFloatField;
    qTempSale1Saletime: TDateTimeField;
    qTempSale1Otdel: TLargeintField;
    qTempSale: TMySQLQuery;
    qTempSaleTradePoint_id: TLargeintField;
    qTempSaleCard_id: TLargeintField;
    qTempSaleEmpl_id: TLargeintField;
    qTempSaleSumma: TFloatField;
    qTempSaleSaletime: TDateTimeField;
    qTempSaleOtdel: TLargeintField;
    Query_temp: TMySQLQuery;
    MySQLServer1: TMySQLServer;
    procedure btnStep1Click(Sender: TObject);
    procedure btnStep2Click(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure btnStep4Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFromFlash: TfrmFromFlash;
function fncDateDelphiToSQL(DateDelphi: TDateTime) : string;
function fncImportSale() : boolean;
procedure prcLastImport();

implementation

uses untGlobalVar, untSpravochnik, untUpdateNew, Unt_OverCredit;

{$R *.dfm}

procedure TfrmFromFlash.btnStep1Click(Sender: TObject);
begin
  prcGetDriv(ListDriv1);
  btnStep1.Visible := false;
  pnlStep1.Visible := false;
  btnStep2.Visible := true;
  pnlStep2.Visible := true;
  frmFromFlash.pbExport.Position := 10;
  btnExit.Enabled := false;
end;

procedure TfrmFromFlash.btnStep2Click(Sender: TObject);
begin
  if frmFromFlash.cbPunct.ItemIndex = -1 then
  begin
    ShowMessage('�������� ����� �������!');
    exit;
  end;
  btnStep2.Visible := false;
  pnlStep2.Visible := false;
  btnStep3.Visible := true;
  pnlStep3.Visible := true;
  frmFromFlash.pbExport.Position := 20;
end;

function fncImportSale() : boolean;
var
  DateB,
  DateE  : TDateTime;
  sql    : string;
  sLabel,
  sDate  : string;
  NameF, s, saletime  : string;
  wYear, wMonth, wDay, wHour, wMin, wSec, wMSec : Word;
  pos, pos2    : integer;
begin
  pos := Round((frmFromFlash.pbExport.Max - frmFromFlash.pbExport.Position)/50);
  result := true;

  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ��� ����� ������ ����� ��������� ������������� ������ tradepoint ������
  // � ������� sale � ���������� � ���� tradepoint_ok
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_Wait.bou';
  if not FileExists(NameF) then         // ���� �� ������ ����-���� �������� ������������� ��������
  begin                                 // ��� ����� ������� �� TradePoint_Wait.bou
    result := false;                    // ���� �� ������, ������ ������!!! 
    MessageDlg('������ ��� �������� ������!' + #13#10 + '�� ������ ���� ������!', mtError, [mbOk], 0);
    exit;
  end;
  AssignFile(TextF, NameF);
  Reset(TextF);
  read(TextF, sDate);                   // ��������� ������ - ���� ��������� ���������� ������ �� ������� sale
  CloseFile(TextF);

  if sDate = '' then                    // ������ ��� - ������ ������
  begin
    MessageDlg('������ ��� �������� ���������!' + #13#10 + '���� ������ ����!', mtError, [mbOk], 0);
    result := false;
    exit;
  end;

  if not FileExists(FlashButton + ':/' + IntToStr(TradePoint_id) + '_sale.bou') then // ���� ���� ������
  begin                                 // ���� �� ������, ������ ������!!!
    result := false;
    MessageDlg('������ ��� �������� ������!' + #13#10 + '�� ������ ���� ������!', mtError, [mbOk], 0);
    exit;
  end;

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  try                                   // ������������� �� � ����������� ������� ������
    tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
    frmInFlash.ServerRoot.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
    frmInFlash.ServerRoot.Host := tIniSett.ReadString('MySQL', 'Host', '');
    frmInFlash.ServerRoot.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
    tIniSett.Destroy;
    frmInFlash.ServerRoot.Connect;
  except
    ShowMessage('������ ��� ������������� ����!');
    frmInFlash.ServerRoot.Disconnect;
    result := false;
    exit;
  end;

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;           // ������� ��������� ������� tempsale
  frmFromFlash.qImport.SQL.Clear;
  frmFromFlash.qImport.SQL.Add('delete from tempsale');
  frmFromFlash.qImport.Execute(true);

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmInFlash.qRoot.Close;
  frmInFlash.qRoot.SQL.Clear;           // ��������� sale.bou �� ��������� ������� tempsale
  frmInFlash.qRoot.SQL.Add('load data infile "' + FlashButton + ':/' + IntToStr(TradePoint_id) + '_sale.bou" ');
  frmInFlash.qRoot.SQL.Add('into table beznal.tempsale(tradepoint_id, card_id, empl_id, summa, saletime, otdel)');
  frmInFlash.qRoot.Execute(true);

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ����� ��������� ������ � sale ������������� ������ tradepoint...
  frmFromFlash.qImport.SQL.Add('select max(saletime) as MaxST from sale where tradepoint_id = ' + IntToStr(TradePoint_id));
  frmFromFlash.qImport.Open;
  sDate := fncDateDelphiToSQL(frmFromFlash.qImport.FieldByName('MaxST').AsDateTime);

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ����� ��������� ������ � sale ������������� ������ tradepoint...
  frmFromFlash.qImport.SQL.Add('delete from tempsale where saletime <= "' + sDate + '"');
  frmFromFlash.qImport.Execute(true);

  frmFromFlash.qTempSale.Open;
  frmFromFlash.qTempSale.RecordCount;
  frmFromFlash.qTempSale.First;
  if frmFromFlash.qTempSale.RecordCount<>0 then
  pos2 := StrToInt(FloatToStr(roundto(((frmFromFlash.pbExport.Max - frmFromFlash.pbExport.Position)/frmFromFlash.qTempSale.RecordCount),0)))
  else pos2 := 0;
  while not frmFromFlash.qTempSale.Eof do
  begin  // ���� ������ � sale

    saletime := FormatDateTime('yyyy-mm-dd hh:mm:ss', frmFromFlash.qTempSale.fieldbyname('saletime').AsDateTime);
    frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos2;
    frmFromFlash.qImport.Close;
    frmFromFlash.qImport.SQL.Clear;
    frmFromFlash.qImport.SQL.Add('select count(*) as cou from sale ');
    frmFromFlash.qImport.SQL.Add('where saletime = "' +  saletime + '" and ');
    frmFromFlash.qImport.SQL.Add('tradepoint_id = ' + IntToStr(Tradepoint_id) + ' ');
    frmFromFlash.qImport.Open;
//    frmFromFlash.Memo1.Lines.Add(DateTimeToStr(now) + ': ' +  frmFromFlash.qTempSale.FieldByName('saletime').AsString);
    case frmFromFlash.qImport.FieldByName('cou').AsInteger of
      0: // ����� ������ ��� � sale - ���������
      begin
//        s := ;
        s := StringReplace((frmFromFlash.qTempSale.fieldbyname('summa').AsString), ',', '.', [rfReplaceAll]);

        frmFromFlash.qInsert.Close;
        frmFromFlash.qInsert.SQL.Clear;
        frmFromFlash.qInsert.SQL.Add('insert into sale(tradepoint_id, card_id, empl_id, summa, saletime, otdel) ');
        frmFromFlash.qInsert.SQL.Add('values(' + frmFromFlash.qTempSale.fieldbyname('tradepoint_id').AsString + ', ');
        frmFromFlash.qInsert.SQL.Add(frmFromFlash.qTempSale.fieldbyname('card_id').AsString+ ', ');
        frmFromFlash.qInsert.SQL.Add(frmFromFlash.qTempSale.fieldbyname('empl_id').AsString+ ', ');
        frmFromFlash.qInsert.SQL.Add('"' + s + '", ');
        frmFromFlash.qInsert.SQL.Add('"' + saletime + '", ');
        frmFromFlash.qInsert.SQL.Add(frmFromFlash.qTempSale.fieldbyname('otdel').AsString+ ')');
        frmFromFlash.qInsert.Execute(true);
      end;
      1:// ����� ������ ���� � sale - ����������� ��, �.�. ������ �� ������
      begin

      end;
    end;
    frmFromFlash.qImport.Close;
    frmFromFlash.qTempSale.Next;
  end;
  frmFromFlash.qTempSale.Close;

{  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ������� �� ������� tempsale ������ ������� ���� � sale...
  frmFromFlash.qImport.SQL.Add('delete from tempsale ');
  frmFromFlash.qImport.SQL.Add('where saletime in (select saletime from sale where tradepoint_id = ' + IntToStr(Tradepoint_id)+') ');
  frmFromFlash.qImport.Execute(true);

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ...��� ��������� ������ ��������� � ������� sale
  frmFromFlash.qImport.SQL.Add('insert into sale(tradepoint_id, card_id, empl_id, summa, saletime, otdel) ');
  frmFromFlash.qImport.SQL.Add('select * from tempsale ');
  frmFromFlash.qImport.Execute(true);  }

{  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ������� tempsale
  frmFromFlash.qImport.SQL.Add('delete from tempsale');
  frmFromFlash.qImport.Execute(true);   }

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;       // ����� ��������� ������ � sale ������������� ������ tradepoint...
  frmFromFlash.qImport.SQL.Add('select max(saletime) as MaxST from sale where tradepoint_id = ' + IntToStr(TradePoint_id));
  frmFromFlash.qImport.Open;
  sDate := fncDateDelphiToSQL(frmFromFlash.qImport.FieldByName('MaxST').AsDateTime);

  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Position + pos;
  NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_Ok.bou';
  if FileExists(NameF) then             // ������� ����-���� ������������� �������� ���� ����������
  begin
    DeleteFile(NameF);
  end;
  AssignFile(TextF, NameF);
  Rewrite(TextF);                       // ...� ���������� � ����-���� ������������� ��������
  writeln(TextF, sDate);
  FileSetAttr(NameF, faHidden);         // ������������� �������� � ����� - �������
  CloseFile(TextF);

  if FileExists(FlashButton + ':/' + IntToStr(TradePoint_id) + '_Wait.bou') then  // ������� ����-���� ��������
    DeleteFile(FlashButton + ':/' + IntToStr(TradePoint_id) + '_Wait.bou');

  if FileExists(FlashButton + ':/' + IntToStr(TradePoint_id) + '_sale.bou') then  // ������� sale.bou
    DeleteFile(FlashButton + ':/' + IntToStr(TradePoint_id) + '_sale.bou');
end;

function fncDateDelphiToSQL(DateDelphi: TDateTime) : string;
var
  wYear, wMonth, wDay, wHour, wMin, wSec, wMSec : Word;
begin
  if DateDelphi = 0 then result := ''
  else
  begin
    DecodeDateTime(DateDelphi, wYear, wMonth, wDay, wHour, wMin, wSec, wMSec);
    Result := IntToStr(wYear) + '-' + IntToStr(wMonth) + '-' + IntToStr(wDay) +
             ' ' + IntToStr(wHour) + ':' + IntToStr(wMin) + ':' + IntToStr(wSec);
  end;
end;

function fncLastSale() : boolean;
var
 NamFile : string;

begin
  // ����� ��������� ������ � sale ...
  frmFromFlash.qImport.Close;
  frmFromFlash.qImport.SQL.Clear;
  frmFromFlash.qImport.SQL.Add('select max(saletime) as MaxSaleTime from sale where tradepoint = ' + IntToStr(tradepoint_id));
  frmFromFlash.qImport.Open;

//  DecodeDateTime(frmFromFlash.qImport.FieldByName('MaxSaleTime').AsDateTime, wYear, wMonth, wDay, wHour, wMin, wSec, wMSec);
//  sDate := IntToStr(wYear) + '-' + IntToStr(wMonth) + '-' + IntToStr(wDay) +
//           ' ' + IntToStr(wHour) + ':' + IntToStr(wMin) + ':' + IntToStr(wSec);

  // ...� ���������� � ����-���� �������������
  // ��� ����� ������� �� TradePoint_Ok.bou
  NamFile := FlashButton + ':/' + IntToStr(TradePoint_id) + '_Ok.bou';
  if FileExists(NamFile) then
  begin  // ������� ���� ���� ����������!
    DeleteFile(NamFile);
  end;
  AssignFile(TextF, NamFile);
  Rewrite(TextF);
  writeln(TextF, frmFromFlash.qImport.FieldByName('MaxSaleTime').AsDateTime);
  FileSetAttr(NamFile, faHidden);// ������������� �������� - �������
  CloseFile(TextF);
  frmFromFlash.qImport.Close;
end;

procedure TfrmFromFlash.btnStep3Click(Sender: TObject);
var
  SDate : string;
  i,k   : integer;
  NameF : string;
  History_name, Copy_History_name: string;
  Copy_History: textfile;
  max_id: integer;
begin
  frmUpdateNew.qTemp.SQL.Clear;
  frmUpdateNew.qTemp.SQL.Add('insert into historyevents(OperTime, Empl_id, Event_id, memo)');
  frmUpdateNew.qTemp.SQL.Add('values(Now(), 1, 13, "������ �������� ������ � ������ �� ' + cbPunct.Text + '")');
  frmUpdateNew.qTemp.Execute(true);

  frmFromFlash.pbExport.Position := 30;
  for i := 1 to 6 do
  begin // ���� ����� ������ ������������ � �������
        // ��������� �������� ���
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
    frmFromFlash.pbExport.Position := 30 + 5 * i;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // ���������� ����� ������
        FlashButton := ListDriv2[i];
        TradePoint_id := frmFromFlash.cbPunct.ItemIndex; // ���������� ����� ������

        if fncImportSale() then
          pnlStep4.Visible := true
        else // ������ ��� ��������, ������� ���� ������ TradePoint_Ok.bou � ����� ��������� ����������� �������
        begin
          frmFromFlash.qImport.Close;
          frmFromFlash.qImport.SQL.Clear;       // ����� ��������� ������ � sale ������������� ������ tradepoint...
          frmFromFlash.qImport.SQL.Add('select max(saletime) as MaxST from sale where tradepoint_id = ' + IntToStr(TradePoint_id));
          frmFromFlash.qImport.Open;
          sDate := fncDateDelphiToSQL(frmFromFlash.qImport.FieldByName('MaxST').AsDateTime);

          NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_Ok.bou';
          if FileExists(NameF) then             // ������� ����-���� ������������� �������� ���� ����������
          begin
            DeleteFile(NameF);
          end;
          AssignFile(TextF, NameF);
          Rewrite(TextF);                       // ...� ���������� � ����-���� ������������� ��������
          writeln(TextF, sDate);
          FileSetAttr(NameF, faHidden);         // ������������� �������� � ����� - �������
          CloseFile(TextF);

//          NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_Ok.bou';
//          if FileExists(NameF) then
//            DeleteFile(NameF);
//          FileCreate(NameF);
//          FileSetAttr(NameF, faHidden);
          pnlStep5.Visible := true;
        end;
        frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Max;
        prcLastImport();


//��������� ���, ��� �������� ������
Frm_OverCredit.BitBtn_stopList.Click;

fncCreateStopListForTP(); // ���������� �� ������ ����-����

//��������� HistoryEvents
History_name:=FlashButton+':\'+IntToStr(TradePoint_id)+'_History.bou';
if (FileExists(History_name)) then begin

try
//������ ��������� �������
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('delete from tempHistory');
Query_temp.Execute(true);

//��������� ��� �� ��������� �������
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('load data infile '''+History_name+'''');
Query_temp.SQL.Add('into table beznal.temphistory (TradePoint_id, HistoryEvent_id, OperTime, Card_id, Pers_id, Empl_id, Event_id, Memo)');
Query_temp.Execute(true);

//������� ������������ ������ � Historyevents_frompoints �� ������ �����
max_id:=0;
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select max(historyevent_id) as m');
Query_temp.SQL.Add('from historyevents_frompoints');
Query_temp.SQL.Add('where tradepoint_id='+IntToStr(TradePoint_id));
Query_temp.Open;
if not Query_temp.Eof then
max_id:=Query_temp.FieldByName('m').AsInteger;

//������� �� temphistory ���, ��� ������ ���� ������
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('delete from tempHistory');
Query_temp.SQL.Add('where historyevent_id<='+IntToStr(max_id));
Query_temp.Execute(true);

//���������� ��� ��������� � Historyevents_frompoints
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('insert historyevents_frompoints');
Query_temp.SQL.Add('select * from temphistory');
Query_temp.Execute(true);

//������� ������������ ������ � Historyevents_frompoints �� ������ �����
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select max(historyevent_id) as m');
Query_temp.SQL.Add('from historyevents_frompoints');
Query_temp.SQL.Add('where tradepoint_id='+IntToStr(TradePoint_id));
Query_temp.Open;
max_id:=Query_temp.FieldByName('m').AsInteger;

//��������� ����� ��������� ����������� ������
Copy_History_name:=FlashButton+':\'+IntToStr(TradePoint_id)+'_Copy_history.txt';
if FileExists(Copy_History_name) then
DeleteFile(Copy_History_name);
AssignFile(Copy_History, Copy_History_name);
Rewrite(Copy_History);
Writeln(Copy_History, inttostr(max_id));
FileSetAttr(Copy_history_name, faHidden);         // ������������� �������� � ����� - �������
CloseFile(Copy_History);

except
end;
end;

        btnStep3.Visible := false;
        pnlStep3.Visible := false;


        frmFromFlash.btnStep4.Visible := true;
        break;
      end;
    end;
  end
  else
  begin
    frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Max;
    ShowMessage('�� ���������� ������, ���������� ������ ������!');
    pnlStep1.Visible := true;
    btnStep1.Visible := true;
    btnStep3.Visible := false;
    pnlStep3.Visible := false;
    frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Min;
  end;
  frmInFlash.ServerRoot.Disconnect;
  btnExit.Enabled := true;
  frmUpdateNew.qTemp.SQL.Clear;
  frmUpdateNew.qTemp.SQL.Add('insert into historyevents(OperTime, Empl_id, Event_id, memo)');
  frmUpdateNew.qTemp.SQL.Add('values(Now(), 1, 14, "��������� �������� ������ � ������ �� ' + cbPunct.Text + '")');
  frmUpdateNew.qTemp.Execute(true);
end;

procedure TfrmFromFlash.btnStep4Click(Sender: TObject);
begin
  pnlStep1.Visible := true;
  btnStep1.Visible := true;
  btnStep3.Visible := false;
  pnlStep3.Visible := false;
  btnStep4.Visible := false;
  pnlStep4.Visible := false;
  pnlStep5.Visible := false;
  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Min;
end;

procedure TfrmFromFlash.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFromFlash.FormShow(Sender: TObject);
begin
  fncExecSQLFillCB('TradePoint', 'NameTP', frmFromFlash.cbPunct);
  prcLastImport;
end;

procedure TfrmFromFlash.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  pnlStep1.Visible := true;
  btnStep1.Visible := true;
  btnStep3.Visible := false;
  pnlStep3.Visible := false;
  btnStep4.Visible := false;
  pnlStep4.Visible := false;
  frmFromFlash.pbExport.Position := frmFromFlash.pbExport.Min;
  frmFromFlash.qDateFlash.Close;
end;

procedure prcLastImport();
begin
  frmFromFlash.qDateFlash.Close;
  frmFromFlash.qDateFlash.SQL.Clear;
  frmFromFlash.qDateFlash.SQL.Add('SELECT max(s.saletime) as st, t.nametp as ntp FROM sale s, tradepoint t');
  frmFromFlash.qDateFlash.SQL.Add('where t.tradepoint_id=s.tradepoint_id group by s.tradepoint_id');
  frmFromFlash.qDateFlash.SQL.Add('order by st');
  frmFromFlash.qDateFlash.Open;
end;

end.
