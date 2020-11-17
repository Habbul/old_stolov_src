unit untFirst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DBTables, DB, XPMan, MySQLDataset,
  ImgList;

type
  TfrmFirst = class(TForm)
    btnExit: TBitBtn;
    btnAutent: TBitBtn;
    Panel2: TPanel;
    lMessage: TLabel;
    btnKassa: TBitBtn;
    btnBase: TBitBtn;
    btnStopList: TBitBtn;
    XPManifest1: TXPManifest;
    btnDostup: TBitBtn;
    qSelPrava: TMySQLQuery;
    qHistory: TMySQLQuery;
    Bevel1: TBevel;
    btnSetting: TBitBtn;
    qTemp: TMySQLQuery;
    lTradePoint: TLabel;
    btnSaleOfDay: TBitBtn;
    GroupBox1: TGroupBox;
    btnUpdateDB: TBitBtn;
    btnExportDB: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExitClick(Sender: TObject);
    procedure btnAutentClick(Sender: TObject);
    procedure btnKassaClick(Sender: TObject);
    procedure btnStopListClick(Sender: TObject);
    procedure btnBaseClick(Sender: TObject);
    procedure btnDostupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExportDBClick(Sender: TObject);
    procedure btnUpdateDBClick(Sender: TObject);
    procedure btnKassaKeyPress(Sender: TObject; var Key: Char);
    procedure btnSettingClick(Sender: TObject);
    procedure btnSaleOfDayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure prcVisibleBTN();
  end;

var
  frmFirst: TfrmFirst;

implementation

uses untGlobalVar, untMifareDll, untKassa, untMain, untSpravochnik,
  untDostup, untUpdate, untStop, untExport2, untSaleOfDay;

{$R *.dfm}

procedure TfrmFirst.prcVisibleBTN();
begin
  frmFirst.btnKassa.Enabled := false;
  frmFirst.btnBase.Enabled := false;
  frmFirst.btnStopList.Enabled := false;
  frmFirst.btnDostup.Enabled := false;
  frmFirst.btnUpdateDB.Enabled := false;
  frmFirst.btnExportDB.Enabled := false;
  frmFirst.btnSetting.Enabled := false;
  frmFirst.btnSaleOfDay.Enabled := false;
  frmFirst.btnUpdateDB.Enabled := false;
  frmFirst.btnAutent.Visible := true;
  frmSpr.Panel2.Visible := false;
  frmFirst.lMessage.Caption := 'Авторизуйтесь, пожалуйста!';
end;

procedure TfrmFirst.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  a := MifareSessionClose;              // закрываем сессию работы с картой
  frmSpr.qPers.Close;
  frmSpr.qPrava.Close;
  frmSpr.qCard.Close;
  frmSpr.qStateCard.Close;
  frmSpr.qTemp.Close;

  frmSpr.qHistory.Close;               // пишем историю: "Приложение закрыто"
  frmSpr.qHistory.SQL.Clear;
  frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id) values(Now(), 8)');
  frmSpr.qHistory.Execute;

//  frmFirst.qHistory.SQL.Clear;          // пишем историю
//  frmFirst.qHistory.SQL.Add('insert into historyevents(opertime, Event_id) values(Now(), 8)');
//  frmFirst.qHistory.Execute;
end;

procedure TfrmFirst.btnExitClick(Sender: TObject);
begin
  close;
end;

function fncShowAutorise():integer;
var
 t      : string;
 tradep : integer;
begin
  frmFirst.prcVisibleBTN;

  t := IntToStr(CardNo);
  // ищем в базе права доступа в систему
  frmFirst.qSelPrava.Close;
  frmFirst.qSelPrava.SQL.Clear;

// лена 29.03.09 начало
  frmFirst.qSelPrava.SQL.Add('select e.nomerbsk, t.typeempl_id as typem, prava.prava_id, concat(e.family, ' + ''' ''' +  ' , e.name, ' + ''' ''' +  ' , e.parentname) as persname, ');
  frmFirst.qSelPrava.SQL.Add('t.post as pos, e.empl_id as emplid ');
  frmFirst.qSelPrava.SQL.Add('from beznal.employee e ');
  frmFirst.qSelPrava.SQL.Add('left join beznal.typeemployers t on (t.typeempl_id = e.typeempl_id) ');
  frmFirst.qSelPrava.SQL.Add('left join beznal.pravafortypeemployee pr on (pr.typeempl_id = t.typeempl_id) ');
  frmFirst.qSelPrava.SQL.Add('left join beznal.prava on (prava.prava_id = pr.prava_id) ');
  frmFirst.qSelPrava.SQL.Add('where t.typeempl_id is not null and e.nomerbsk = ' + t + ' and flag = 1 ');

//  frmFirst.qSelPrava.SQL.Add('select c.nomer, t.typeempl_id as typem, prava.prava_id, concat(p.family, ' + ''' ''' + ' , ');
//  frmFirst.qSelPrava.SQL.Add('p.name, ' + ''' ''' + ' , p.parentname) as persname, t.post as pos, e.empl_id as emplid, ');
//  frmFirst.qSelPrava.SQL.Add('c.card_id as cardid, p.pers_id as persid ');
//  frmFirst.qSelPrava.SQL.Add('from beznal.card c ');
//  frmFirst.qSelPrava.SQL.Add('left join pers p on (c.card_id = p.card_id) ');
//  frmFirst.qSelPrava.SQL.Add('left join employee e on (p.pers_id = e.empl_id) ');
//  frmFirst.qSelPrava.SQL.Add('left join typeemployers t on (t.typeempl_id = e.typeempl_id) ');
//  frmFirst.qSelPrava.SQL.Add('left join pravafortypeemployee pr on (pr.typeempl_id = t.typeempl_id) ');
//  frmFirst.qSelPrava.SQL.Add('left join prava on (prava.prava_id = pr.prava_id) ');
//  frmFirst.qSelPrava.SQL.Add('where t.typeempl_id is not null and c.nomer = ' + t + ' ');

// лена 29.03.09 окончание
  frmFirst.qSelPrava.Execute;
  frmFirst.qSelPrava.Open;

  TypeEmpl_id := frmFirst.qSelPrava.FieldByName('typem').AsInteger;
  CurrentEmplId := frmFirst.qSelPrava.FieldByName('emplid').AsString;

// лена 29.03.09 начало
//  CurrentPersId := frmFirst.qSelPrava.FieldByName('persid').AsString;
//  CurrentCardId := frmFirst.qSelPrava.FieldByName('cardid').AsString;
  CurrentPersId := '999999';
  CurrentCardId := '888888';
// лена 29.03.09 окончание

  case frmFirst.qSelPrava.RecordCount of
    0:
    begin
      ShowMessage('Извините, у Вас отсутствуют права доступа к системе!');
      frmFirst.qHistory.SQL.Clear; // пишем историю
      frmFirst.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, memo) ');
      frmFirst.qHistory.SQL.Add('values(Now(), 6, (select card_id from card where nomer = ' + t + '), ''' + t + ''')');
      frmFirst.qHistory.Execute;
    end
    else
    begin
{      tradep := frmFirst.qSelPrava.FieldByName('tradep').AsInteger;
      case tradep of // проверяем доступ к точке
        0: // 0 точка, свободный доступ ко всем точкам
      else // доступ только к определенной точке
        begin
          if tradep <> TradePoint_id then
          begin
            ShowMessage('Извините, у Вас отсутствуют права доступа на работу в этой точке!');
            exit;
          end;
        end;
      end;    }
      frmFirst.qHistory.SQL.Clear; // пишем историю
      frmFirst.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id) ');
      frmFirst.qHistory.SQL.Add('values(Now(), 5, ' + CurrentCardId + ', ' + CurrentPersId + ', ' + CurrentEmplId + ' )');
      frmFirst.qHistory.Execute;
    end;
  end;

  frmFirst.lMessage.Caption := '' + frmFirst.qSelPrava.FieldByName('persname').AsString + ' - ' + frmFirst.qSelPrava.FieldByName('pos').AsString;
  frmDostup.tsEmpl.TabVisible := false;
  frmDostup.tsPrava.TabVisible := false;

  frmFirst.qSelPrava.First;
  while not frmFirst.qSelPrava.Eof do
  begin
    case frmFirst.qSelPrava.FieldByName('Prava_id').AsInteger of
      1: // полный доступ
      begin
        frmFirst.btnKassa.Enabled := true;
        frmFirst.btnBase.Enabled := true;
        frmFirst.btnStopList.Enabled := true;
        frmFirst.btnDostup.Enabled := true;
        frmFirst.btnUpdateDB.Enabled := true;
        frmFirst.btnExportDB.Enabled := true;
        frmFirst.btnSetting.Enabled := true;
        frmDostup.tsEmpl.TabVisible := true;
        frmDostup.tsPrava.TabVisible := true;
        frmFirst.btnSaleOfDay.Enabled := true;
        frmFirst.btnKassa.SetFocus;
        frmSpr.Panel2.Visible := true;
        frmUpdate.mAction.Visible:= true;
       end;
      2: // доступ к настройкам
      begin
        frmFirst.btnDostup.Enabled := false;
        frmDostup.tsEmpl.TabVisible := true;
      end;
      3: // загрузка базы
      begin
        frmFirst.btnUpdateDB.Enabled := true;
        frmFirst.btnSetting.Enabled := true;
      end;
      4: // выгрузка базы
      begin
        frmFirst.btnExportDB.Enabled := true;
      end;
      5: // заполнение стоп-листа
      begin
        frmFirst.btnStopList.Enabled := true;
      end;
      6: // работа на кассе и просмотр сумм продаж
      begin
        frmFirst.btnKassa.Enabled := true;
        frmFirst.btnSaleOfDay.Enabled := true;
        frmFirst.btnKassa.SetFocus;
      end;
    end;
    frmFirst.qSelPrava.Next;
  end;
  frmFirst.qSelPrava.Close;
end;

procedure TfrmFirst.btnAutentClick(Sender: TObject);
var
 t : string;
begin
  prcVisibleBTN;
  MessageDlg('Приложите БСК к считывателю!', mtInformation, [mbOK], 0);
  CardNo := 0;                      //  ' --- Чтение номера карты --- ');
  a := MifareCardSerialNoGet(@CardNo);
  case a of
    Mifare_Ok :
    begin
      fncShowAutorise();
    end;
    MIFARE_NOTAGERR :
    begin
      MessageDlg('Ошибка чтения карты - Нет карты в поле антены', mtError, [mbOk], 0);
    end;
    else
    begin
      MessageDlg('Ошибка чтения карты. Код ошибки ' + IntToStr(a), mtError, [mbOk], 0);
    end;
  end;   
end;

procedure TfrmFirst.btnKassaClick(Sender: TObject);
begin
  prcVisibleBTN;

// лена 29.03.09 начало
//  frmKassa.Show; // закоментировано для магазина на тукая
  frmKassa.Show; // для всех остальных точек открыто
// лена 29.03.09 окончание
end;

procedure TfrmFirst.btnStopListClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmStopList.Show;
end;

procedure TfrmFirst.btnBaseClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmSpr.qPers.Close;
  frmSpr.qPers.SQL.Clear;
  frmSpr.qPers.SQL.Add('Select * from pers order by family, name, parentname');
  frmSpr.qPers.Open;
  
  frmSpr.qPrava.Open;
  frmSpr.qStateCard.Open;
  frmSpr.qCard.Open;
  frmSpr.qEmployee.Open;
  frmSpr.qTEmpl.Open;
  frmSpr.tsPers.TabVisible := true;
  frmSpr.tsCard.TabVisible := true;
  frmSpr.tsStateCard.TabVisible := true;
  frmSpr.tsPrava.TabVisible := true;
  frmSpr.tsEmpl.TabVisible := true;
  frmSpr.tsTEmp.TabVisible := true;
  frmSpr.Show;
//  btnBase.Visible := false;
end;

procedure TfrmFirst.btnDostupClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmSpr.tsPers.TabVisible := false;
  frmSpr.tsCard.TabVisible := false;
  frmSpr.tsStateCard.TabVisible := false;
  frmSpr.tsPrava.TabVisible := false;
  frmSpr.tsEmpl.TabVisible := false;
  frmSpr.tsTEmp.TabVisible := false;
  frmDostup.Show;
end;

procedure TfrmFirst.FormShow(Sender: TObject);
 begin
  frmFirst.qTemp.Close;
  frmFirst.qTemp.SQL.Clear;
  frmFirst.qTemp.SQL.Add('SELECT nameTP FROM tradepoint where tradepoint_id=' + IntToStr(TradePoint_id));
  frmFirst.qTemp.Open;
  TradePoint := frmFirst.qTemp.FieldByName('nametp').AsString;
  frmFirst.qTemp.Close;
  frmFirst.lTradePoint.Caption := TradePoint;
  frmKassa.lTradePoint.Caption := TradePoint;
  fncShowAutorise();
end;
 {
begin
  tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
  frmFirst.btnBase.Visible := tIniSett.ReadBool('Button', 'Spr', false);
  frmFirst.btnStopList.Visible := tIniSett.ReadBool('Button', 'Stop', false);
  frmFirst.btnDostup.Visible := tIniSett.ReadBool('Button', 'Prava', false);
  frmFirst.btnUpdateDB.Visible := tIniSett.ReadBool('Button', 'DB', false);
  frmFirst.btnExportDB.Visible := tIniSett.ReadBool('Button', 'Ved', false);
  frmFirst.btnSetting.Visible := tIniSett.ReadBool('Button', 'Sett', false);
  frmFirst.btnInFlash.Visible := tIniSett.ReadBool('Button', 'InFlash', false);
  frmFirst.btnFromFlash.Visible := tIniSett.ReadBool('Button', 'FromFlash', false);
  TradePoint_id := tIniSett.ReadInteger('Setting', 'TradePoint', 0);
  TradePoint := '';
  tIniSett.Destroy;
end;
      }
procedure TfrmFirst.btnExportDBClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmExport2.Show;
end;

procedure TfrmFirst.btnUpdateDBClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmUpdate.Show;
end;

procedure TfrmFirst.btnKassaKeyPress(Sender: TObject; var Key: Char);
begin
  ShowMessage(inttostr(ord(key)) + ' ' + key);
end;

procedure TfrmFirst.btnSettingClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmMain.Show;
end;

procedure TfrmFirst.btnSaleOfDayClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmSaleOfDay.Show;
end;

initialization
  PutchFolderPrj := GetCurrentDir;

end.
