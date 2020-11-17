unit untUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBTables, Grids, DBGrids, MySQLDataset, ExtCtrls,
  Gauges, ComCtrls, DBGridEh, Math, Buttons, Spin, IniFiles, MySQLServer;

type
  TfrmUpdate = class(TForm)
    qTemp: TMySQLQuery;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    btnStep1: TBitBtn;
    btnStep3: TButton;
    pnlStep1: TPanel;
    lStep1: TLabel;
    Image3: TImage;
    Panel3: TPanel;
    Label4: TLabel;
    pnlStep5: TPanel;
    Image4: TImage;
    Label3: TLabel;
    pnlStep3: TPanel;
    Image5: TImage;
    lStep3: TLabel;
    pnlStep4: TPanel;
    Image2: TImage;
    Label5: TLabel;
    ServerRoot: TMySQLServer;
    pbExport: TProgressBar;
    Panel2: TPanel;
    btnClose: TBitBtn;
    mAction: TMemo;
    pnlWait: TPanel;
    Image1: TImage;
    Label1: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnStep1Click(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdate: TfrmUpdate;

implementation

uses untSpravochnik, DateUtils, untGlobalVar, untThread, untExport2;

{$R *.dfm}

function fncUpdateDB(Progress : integer; FlashButt : string):boolean;
begin
  result := true;
try
  Application.ProcessMessages;
  frmUpdate.pbExport.Position := Progress;

  progress := Round((frmUpdate.pbExport.Max - frmUpdate.pbExport.Position)/13);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into historyevents ');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into historyevents(OperTime,Empl_id, Event_id, memo)');
  frmUpdate.qTemp.SQL.Add('values(Now(), 1, 13, 158)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update pers set flagKredita = 2');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update pers set flagKredita = 2');
  frmUpdate.qTemp.Execute;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update card set StateCard_id = 2');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update card set StateCard_id = 2');
  frmUpdate.qTemp.Execute;
 //...................................................................................
   //обновляем таблицу  empl_id
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update employee set Flag = 2');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update employee set Flag = 2');
  frmUpdate.qTemp.Execute;
 //...................................................................................

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from credits');
  frmUpdate.qTemp.SQL.Clear;                      // удаляем все кредиты,
  frmUpdate.qTemp.SQL.Add('delete from credits'); // т.к. при выгрузке базы
  frmUpdate.qTemp.Execute(true);                  // берется текущий и следующий периоды

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempcard');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempcard');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from temppers');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from temppers');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempcredits');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempcredits');
  frmUpdate.qTemp.Execute(true);
 //...................................................................................
 // frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempempl ');
 // frmUpdate.qTemp.SQL.Clear;
 // frmUpdate.qTemp.SQL.Add('delete from tempempl t');
 // frmUpdate.qTemp.Execute(true);
//...................................................................................
  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_card.bou"');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_card.bou" into table beznal.tempcard');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_pers.bou"');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_pers.bou" into table beznal.temppers');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_credits.bou"');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_credits.bou" into table beznal.tempcredits');
  frmUpdate.qTemp.Execute(true);
  //.........................................................................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_employee.bou"');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('load data local infile "' + FlashButt + ':\' + IntToStr(TradePoint_id) + '_employee.bou" into table beznal.tempempl');
  frmUpdate.qTemp.Execute(true);
  //.........................................................................................................................................
  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;
  //.........................................................................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update employee e set e.Flag = 1');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update employee e,tempempl t  set e.Flag=1, e.TypeEmpl_id= t.TypeEmpl_id, e.TradePoint_id= t.TradePoint_id, e.NomerBSK=t.NomerBSK, e.Family=t.Family, e.Name=t.Name, e.ParentName=t.ParentName ');
  frmUpdate.qTemp.SQL.Add('where e.empl_id =t.empl_id ');
  frmUpdate.qTemp.Execute(true);
    //.........................................................................................................................................
  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update card c set c.statecard_id = 1');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update card c set c.statecard_id = 1');
  frmUpdate.qTemp.SQL.Add('where c.card_id in (select t.card_id from tempcard t)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' update pers p set p.flagkredita = 1');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('update pers p set p.flagkredita = 1');
  frmUpdate.qTemp.SQL.Add('where p.pers_id in (select t.pers_id from temppers t)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempcard where card_id in');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempcard where card_id in');
  frmUpdate.qTemp.SQL.Add('(select c.card_id from card c)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from temppers where pers_id in');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from temppers where pers_id in');
  frmUpdate.qTemp.SQL.Add('(select p.pers_id from pers p)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;
  //........................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempempl where empl_id in');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempempl where empl_id in');
  frmUpdate.qTemp.SQL.Add('(select e.empl_id from employee e)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;
  //........................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into card(card_id, StateCard_id, nomer)');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into card(card_id, StateCard_id, nomer)');
  frmUpdate.qTemp.SQL.Add('select card_id, StateCard_id, nomer from tempcard');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into pers(pers_id, card_id...');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into pers(pers_id, card_id, family, name, parentname, tabnum, flagkredita)');
  frmUpdate.qTemp.SQL.Add('select pers_id, card_id, family, name, parentname, tabnum, Flagkredita from temppers');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;
  //...............................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into employee (Empl_id, TypeEmpl_id...');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into employee(empl_id, TypeEmpl_id, TradePoint_id, NomerBSK, Family, Name, ParentName, Flag)');
  frmUpdate.qTemp.SQL.Add('select empl_id, TypeEmpl_id, TradePoint_id, NomerBSK, Family, Name, ParentName, Flag from tempempl');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;
  //...............................................................................................
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into credits');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into credits(credit_id, card_id, datebegin, dateEnd, sumcredit, Empl_id)');
  frmUpdate.qTemp.SQL.Add('select credit_id, card_id, DateBegin, DateEnd, SumCredit, 1 from tempcredits');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempcredits');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempcredits');
  frmUpdate.qTemp.Execute(true);

  //.......................................................................
  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempempl');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempempl');
  frmUpdate.qTemp.Execute(true);
 //.......................................................................
  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from tempcard');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from tempcard');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Position + Progress;

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' delete from temppers');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('delete from temppers');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' insert into historyevents');
  frmUpdate.qTemp.SQL.Clear;
  frmUpdate.qTemp.SQL.Add('insert into historyevents(OperTime,Empl_id, Event_id, memo)');
  frmUpdate.qTemp.SQL.Add('values(Now(), 1, 14, 444)');
  frmUpdate.qTemp.Execute(true);

  frmUpdate.pbExport.Position := frmUpdate.pbExport.Max;
  frmUpdate.btnClose.Enabled := true;
  frmUpdate.mAction.Lines.Add(DateTimeToStr(Now) + ' выгрузка окончена');
except
  result := false;
end;
end;

procedure TfrmUpdate.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmUpdate.btnStep1Click(Sender: TObject);
begin
  prcGetDriv(ListDriv1);
  btnStep1.Visible := false;
  pnlStep1.Visible := false;
  btnStep3.Visible := true;
  pnlStep3.Visible := true;
  frmUpdate.pbExport.Position := 10;
end;

procedure TfrmUpdate.btnStep3Click(Sender: TObject);
var
  i    : integer;
  sSql : string;
  sDBegin, sDEnd : string;
  Year, Month, DayB, DayE : Word;
  NameF : string;
begin
  frmUpdate.pnlWait.Visible := true;
  btnStep3.Visible := false;
  pnlStep3.Visible := false;
  frmUpdate.pbExport.Position := 20;
  Application.ProcessMessages;
  for i := 1 to 6 do
  begin // ждем когда флешка обнаружиться в системе
        // поставить прогресс бар
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
    frmUpdate.pbExport.Position := 20 + 10 * i;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // обнаружили букву флешки
        FlashButton := ListDriv2[i];

        // ищем файлы БД, если их нет, сообщаем об ошибке
        if (not FileExists(FlashButton + ':\' + IntToStr(TradePoint_id) + '_card.bou')) or
           (not FileExists(FlashButton + ':\' + IntToStr(TradePoint_id) + '_employee.bou')) or
           (not FileExists(FlashButton + ':\' + IntToStr(TradePoint_id) + '_pers.bou')) or
           (not FileExists(FlashButton + ':\' + IntToStr(TradePoint_id) + '_credits.bou')) then
        begin
          MessageDlg('Обновление не возможно!' + #13#10 + 'Не найден один из файлов обновления!', mtError, [mbOk], 0);
          pnlStep5.Visible := true;
          Break;
        end;

        try //инициализация БД в админовской учетной записи
          tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
          frmUpdate.ServerRoot.Disconnect;
          frmUpdate.ServerRoot.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
          frmUpdate.ServerRoot.Host := tIniSett.ReadString('MySQL', 'Host', '');
          frmUpdate.ServerRoot.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
          tIniSett.Destroy;
          frmUpdate.ServerRoot.Connect;
        except
          ShowMessage('Ошибка при инициализации базы!');
          frmUpdate.ServerRoot.Disconnect;
          exit;
        end;

        NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_stop.bou';
        if FileExists(NameF) then
          fncAddStopList();      // функция загрузки стоп-листа
        case fncUpdateDB(frmUpdate.pbExport.Position, FlashButton) of
          true:  // выгрузка произведена без ошибок
            begin
              pnlStep4.Visible := true;
              frmUpdate.pbExport.Position := frmUpdate.pbExport.Max;
              // удалить с флешки файлы
              NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_employee.bou';
              if FileExists(NameF) then
                DeleteFile(NameF);
              NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_card.bou';
              if FileExists(NameF) then
                DeleteFile(NameF);
              NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_pers.bou';
              if FileExists(NameF) then
                DeleteFile(NameF);
              NameF := FlashButton + ':/' + IntToStr(TradePoint_id) + '_credits.bou';
              if FileExists(NameF) then
                DeleteFile(NameF);
              break;
            end;
          false: // при выгрузке произошла ошибка
            begin
              pnlStep5.Visible := true;
              frmUpdate.pbExport.Position := frmUpdate.pbExport.Max;
              break;
            end;
        end;
      end;
    end;
  end
  else
  begin
    frmUpdate.pbExport.Position := frmUpdate.pbExport.Max;
    ShowMessage('Не обнаружена флешка, попробуйте начать заново!');
    pnlStep1.Visible := true;
    btnStep1.Visible := true;
    frmUpdate.pbExport.Position := frmUpdate.pbExport.Min;
  end;
  frmUpdate.pnlWait.Visible := false;
  frmUpdate.ServerRoot.Disconnect;
end;

procedure TfrmUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmUpdate.mAction.Visible:= false;
  frmUpdate.pnlStep1.Visible := true;
  frmUpdate.btnStep1.Visible := true;
  frmUpdate.pnlStep5.Visible := false;
  frmUpdate.btnStep3.Visible := false;
  frmUpdate.pnlStep3.Visible := false;
  frmUpdate.pnlStep4.Visible := false;
  frmUpdate.pbExport.Position := 0;
end;

end.

