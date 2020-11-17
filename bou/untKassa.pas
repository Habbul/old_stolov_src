unit untKassa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, untGlobalVar, untMifareDll, Mask,
  DB, MySQLDataset, Spin;

type
  TfrmKassa = class(TForm)
    btnNewClient: TBitBtn;
    btnExit: TBitBtn;
    gbPerson: TGroupBox;
    Label6: TLabel;
    Label5: TLabel;
    gbOplata: TGroupBox;
    edSumma: TEdit;
    btnClientCancel: TBitBtn;
    gbOstatok: TGroupBox;
    Label3: TLabel;
    Label7: TLabel;
    btnOk: TBitBtn;
    stSpisano: TStaticText;
    stOstatokNaChete: TStaticText;
    Panel1: TPanel;
    tClock: TTimer;
    Panel2: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lTime: TLabel;
    lDate: TLabel;
    lFio: TLabel;
    lCardNo: TLabel;
    lTabNo: TLabel;
    qSelPers: TMySQLQuery;
    qSelPerSum: TMySQLQuery;
    qInsSale: TMySQLQuery;
    Label4: TLabel;
    Bevel3: TBevel;
    Label1: TLabel;
    stOstatok: TStaticText;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Bevel4: TBevel;
    stOst: TStaticText;
    btnClientOk: TBitBtn;
    StaticText2: TStaticText;
    Label2: TLabel;
    seOtdel: TSpinEdit;
    lOtdel: TLabel;
    Panel4: TPanel;
    lMessage: TLabel;
    qSalesOfDay: TMySQLQuery;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel3: TPanel;
    imgCardNo: TSpeedButton;
    lTradePoint: TLabel;
    imgGreen: TBitBtn;
    imgRed: TBitBtn;
    imgGray: TBitBtn;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    lSalesOfDay: TLabel;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    qStopList: TMySQLQuery;
    procedure btnNewClientClick(Sender: TObject);
    procedure btnClientCancelClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnClientOkClick(Sender: TObject);
    procedure edSummaKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
    procedure tClockTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure seOtdelChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TValueBSK_DB = record
    Year, Month, Day : word;
    Date : TDate;
    iLimit, iOstLim, iInvLim : integer;
    fLimit, fOstLim, fInvLim : real;
    sLimit, sOstLim, sInvLim : string;
  end;

var
  frmKassa: TfrmKassa;
  PosPunct : integer;
function fncChek():boolean;
implementation

uses untFirst, ConvUtils, untSpravochnik, DateUtils, Math;

{$R *.dfm}

procedure prcSalesOfDay();
var
  Summa : string;
begin
  frmKassa.qSalesOfDay.Open;
  Summa := frmKassa.qSalesOfDay.FieldByName('sumsale').AsString;
  if Summa = '' then Summa := '0,00';
  frmKassa.lSalesOfDay.Caption := Summa;
  frmKassa.qSalesOfDay.Close;
end;

procedure TfrmKassa.btnNewClientClick(Sender: TObject);
var
  BSK, DB : TValueBSK_DB;
  i : integer;
  temp, text : string;
  t          : string;
begin
Ostatok:=0; //(Ильсия 30-10-2009)
  frmKassa.Memo1.Clear;
  frmKassa.StaticText1.Caption := '0';
  frmKassa.seOtdel.Value := 1;
  CardNo := 0;
  MessageDlg('Приложите БСК к считывателю, и не убирайте до завершения операций!', mtInformation, [mbOk], 0);
  a := MifareCardRequest(MODE_ALL);  // request
  a := MifareAnticollision(@CardNo); // anticollision
  a := MifareCardSelect(CardNo);     // select card
  case a of
    Mifare_Ok :
    begin
      AuthentMode := Key_A or Key_Set0; // autentication
      a := MifareSectorAuthentication(AuthentMode, Sector);

//чистим массив Val  (Ильсия 30-10-2009)
Val[0]:=0; Val[1]:=0; Val[2]:=0; Val[3]:=0; Val[4]:=0; Val[5]:=0;
val[6]:=0; val[7]:=0; Val[8]:=0; Val[9]:=0; Val[10]:=0;

      // считываем с карточки данные: период действия лимита, доступная сумма
      a := MifareBlockRead(Sector, Block, @Val);

//проверяем, если считались 0, нужно повторить операцию (Ильсия 09-11-2009)
if (Val[0]=0) and (Val[1]=0) and (Val[2]=0) and (Val[3]=0) and (Val[4]=0) and (Val[5]=0) and (Val[6]=0)
and (Val[7]=0) and (Val[8]=0) and (Val[9]=0) and (Val[10]=0) then begin
MessageDlg('ОШИБКА!' + #13#10 + #13#10 + 'Данные по карте не считались,' + #13#10 + 'приложите БСК повторно!', mtError, [mbOk], 0);
a := MifareCardHalt;
exit;
end;


      try
      case val[11] of
        66 : // БСК заблокирована
        begin // меняем флаг кредита в базе на "некредитуемый"
          frmKassa.btnClientCancel.Click;
          prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
          MessageDlg('ОШИБКА! БСК заблокирована, обратитесь в службу ИВЦ!', mtError, [mbOk], 0);
          exit;
        end;
      end;
      except
      end;

      frmKassa.qSelPerSum.Close;     // выборка данных по кредитованию БСК на текущий период
      frmKassa.qSelPerSum.SQL.Clear; // где флаг кредитования = 1 (кредитуемая БСК)
      frmKassa.qSelPerSum.SQL.Add('SELECT * FROM credits cr, card ca ');
      frmKassa.qSelPerSum.SQL.Add('where datebegin <= curdate() ');
      frmKassa.qSelPerSum.SQL.Add('and dateend >= curdate() ');
      frmKassa.qSelPerSum.SQL.Add('and ca.nomer = ' + IntToStr(CardNo));
      frmKassa.qSelPerSum.SQL.Add('and cr.card_id = ca.card_id ');
      frmKassa.qSelPerSum.SQL.Add('and ca.statecard_id = 1');
      frmKassa.qSelPerSum.Execute;
      frmKassa.qSelPerSum.Open;

      case frmKassa.qSelPerSum.RecordCount of
        0 :  // ошибка: данных по кредитованию этой карты не найдено
        begin
          MessageDlg('ОШИБКА!' + #13#10 + #13#10 + 'Данных по начислению кредита не найдено,' + #13#10 + 'или БСК в стоп листе!', mtError, [mbOk], 0);
          a := MifareCardHalt;
          exit;
        end;
        1 :  // все в норме
        begin
//          if frmKassa.qSelPerSum.FieldByName('statecard_id').AsInteger = 2 then
//          begin
//            MessageDlg('ВНИМАНИЕ: данная БСК в стоп листе!', mtWarning, [mbOk], 0);
//            a := MifareCardHalt;
//            exit;
//          end;
        end;
        else // ошибка: выбрано более одной записи по данной карте на заданный период
        begin
          MessageDlg('ОШИБКА: задвоение записей в базе кредитов!', mtError, [mbOK], 0);
          a := MifareCardHalt;
          exit;
        end;
      end;
      // поиск персональных данных (ФИО, таб.номер) владельца БСК
      frmKassa.qSelPers.Close;
      frmKassa.qSelPers.SQL.Clear;
      frmKassa.qSelPers.SQL.Add('select concat(p.family, ' + ''' ''' + ' , p.name, ' + ''' ''' + ' , p.parentname) ');
      frmKassa.qSelPers.SQL.Add('as persname, p.tabnum as tabnum, c.card_id as cardid, p.pers_id as persid, p.flagkredita as fk');
      frmKassa.qSelPers.SQL.Add('from beznal.card c ');
      frmKassa.qSelPers.SQL.Add('left join pers p on (c.card_id = p.card_id) ');
      frmKassa.qSelPers.SQL.Add('where c.nomer = ' + IntToStr(CardNo) + ' ');
      frmKassa.qSelPers.SQL.Add('and p.flagkredita = 1');
      frmKassa.qSelPers.Execute;
      frmKassa.qSelPers.Open;

      case frmKassa.qSelPers.RecordCount of              // по считанному номеру выбираем персональные данные из базы
        0 :  // ошибка: не найдены данные на владельца БСК
        begin
          MessageDlg('ОШИБКА!' + #13#10 + #13#10 + 'Не найдены данные на владельца БСК,' +#13#10+'или сотрудник в стоп листе!', mtError, [mbOK], 0);
          a := MifareCardHalt;
          exit;
        end;
        1 :  // все в норме, проверить флаг кредита
        begin
//          if frmKassa.qSelPers.FieldByName('fk').AsInteger = 2 then
//          begin
//            MessageDlg('ВНИМАНИЕ: даннный сотрудник в стоп листе!', mtWarning, [mbOk], 0);
//            a := MifareCardHalt;
//            exit;
//          end;
          gbPerson.Visible := true;
          gbOplata.Visible := true;
          bDelimYes := false;
        end;
        else // ошибка: найдено более 1 владельца БСК
        begin
          MessageDlg('ОШИБКА: найдено более 1 владельца БСК!', mtError, [mbOK], 0);
          a := MifareCardHalt;
          exit;
        end;
      end;

      lCardNo.Caption := IntToStr(CardNo); // выводим персональные данные на экран
      lFio.Caption := frmKassa.qSelPers.fieldbyname('persname').AsString;
      lTabNo.Caption := frmKassa.qSelPers.fieldbyname('tabnum').AsString;
      CurrentCardId := frmKassa.qSelPers.fieldbyname('cardid').AsString;
      CurrentPersId := frmKassa.qSelPers.fieldbyname('persid').AsString;
      CurrentCardNo := CardNo;            // сохраняем полученный № карты для проверки перед записью данных

      frmKassa.qStopList.Close;           // проверяем, БСК в стоп-листе или нет
      frmKassa.qStopList.SQL.Clear;
      frmKassa.qStopList.SQL.Add('select * from stoplist where nomer="' + IntToStr(CardNo) + '"');
      frmKassa.qStopList.Open;
      if frmKassa.qStopList.RecordCount <> 0 then
      begin                               //БСК в стоп-листе
        prcAddBSKInStopList(false, true);            // выставляем флаг на бск
        MessageDlg('ОШИБКА! БСК в стоп-листе!', mtError, [mbOk], 0);
        exit;
      end;

      frmKassa.edSumma.SetFocus;
      frmKassa.btnClientCancel.Enabled := true;
      frmKassa.btnNewClient.Enabled := false;

      imgCardNo.Glyph := frmKassa.imgGreen.Glyph;

      BSK.sOstLim := IntToHex(Val[0], 2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2);
      BSK.sLimit := IntToHex(Val[3], 2) + IntToHex(Val[4], 2) + IntToHex(Val[5], 2);
      BSK.sInvLim := IntToHex(Val[10], 2) + IntToHex(Val[9], 2) + IntToHex(Val[8], 2);
      BSK.iOstLim := HexToInt(BSK.sOstLim);
      BSK.iLimit := HexToInt(BSK.sLimit);
      BSK.iInvLim := HexToInt(BSK.sInvLim);

      if BSK.sOstLim <> BSK.sInvLim  then  // сравниваем остаток и перевернутый остаток, если не равны выдаем ошибку
      begin
        frmKassa.btnClientCancel.Click;

        frmSpr.qHistory.SQL.Clear; // пишем историю
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
        frmSpr.qHistory.SQL.Add('values(Now(), 9, ' + CurrentCardId + ',' + CurrentPersId + ', ');
        frmSpr.qHistory.SQL.Add(CurrentEmplId + ', ' + IntToStr(CardNo) + ' )');
        frmSpr.qHistory.Execute;
        prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
        MessageDlg('ОШИБКА! Данные на БСК утеряны, обратитесь в службу ИВЦ!', mtError, [mbOk], 0);
        exit;
      end;

      //Elena 20090708 begin
      t := '"' + IntToStr(CardNo) + ' ' + inttostr(val[1]) + ' ' + inttostr(val[2]) + ' ' + inttostr(val[3]) + ' ' + inttostr(val[4])+
           ' ' + inttostr(val[5])+ ' ' + inttostr(val[6]) + ' ' + inttostr(val[7])+ ' ' +
           inttostr(val[8])+ ' ' + inttostr(val[9])+ ' ' + inttostr(val[10])+ ' ' + inttostr(val[11]) + '"';
      //Elena 20090708 end
      try
      if (val[7] > 122) or (val[7] = 0)  then // ОШИБКА: значение месяц/период > 122 либо =0
      begin                                   // присваем текущий период и остаток = 0
        //Elena 20090708 begin
        DecodeDate(now, DB.Year, DB.Month, DB.Day);
        if DB.Day < 15 then
          DB.Day := 1
        else
          DB.Day := 2;

        DB.iLimit := Round(frmKassa.qSelPerSum.FieldByName('SumCredit').AsFloat*100);
        BSK.iLimit := DB.iLimit;       // лимитБСК = лимитБД
        BSK.sLimit := IntToHex(BSK.iLimit, 6);
        Val[0] := 0; // остаток лимита
        Val[1] := 0; //
        Val[2] := 0; //
        Val[3] := (HexToInt(BSK.sLimit[1] + BSK.sLimit[2]));   // лимит
        Val[4] := (HexToInt(BSK.sLimit[3] + BSK.sLimit[4]));   //
        Val[5] := (HexToInt(BSK.sLimit[5] + BSK.sLimit[6]));   //
        {Val[3] := 0;   // лимит
        Val[4] := 0;   //
        Val[5] := 0;   //    }
        val[7] := DB.Month * 10 + DB.Day;
        val[6] := DB.Year - 2000;
        Val[8] := 0; // инверсия остатока лимита
        Val[9] := 0; //
        Val[10] := 0; //

        frmSpr.qHistory.SQL.Clear; // пишем историю
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
        frmspr.qHistory.SQL.Add('values(Now(), 10, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ','+t+ ' )');
        frmSpr.qHistory.Execute;

        fncWriteInCard(CurrentCardNo, Sector, Block, Val, temp); //Смена периода на БСК, сумма = 0!

        frmSpr.qHistory.SQL.Clear; // пишем историю
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
        frmSpr.qHistory.SQL.Add('values(Now(), 4, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ', "' + text + '" )');
        frmSpr.qHistory.Execute;

        MessageDlg('ОШИБКА КАРТЫ! БСК размагничена, данные утеряны!', mtError, [mbOk], 0);

        exit;
  //        val[7] := 11;
  //        val[6] := 6;
        //Elena 20090708 end
      end;
      BSK.Year := 2000 + Val[6];    // преобразовываем значение год/месяц с БСК в дату
      BSK.Month := Val[7] div 10;
      BSK.Day := 1;
      if (Val[7] mod 10) = 2 then
        BSK.Day := 15;
      BSK.Date := EncodeDate(BSK.Year, BSK.Month, BSK.Day);
      DecodeDate(now, DB.Year, DB.Month, DB.Day);
      if DB.Day < 15 then
        DB.Day := 1
      else
        DB.Day := 15;
      DB.Date := EncodeDate(DB.Year, DB.Month, DB.Day);
      except
        frmKassa.btnClientCancel.Click;
        frmSpr.qHistory.SQL.Clear; // пишем историю
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
      //Elena 20090708 begin
      //  frmSpr.qHistory.SQL.Add('values(Now(), 10, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ', ' + IntToStr(CardNo) + ' )');
        frmspr.qHistory.SQL.Add('values(Now(), 10, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ','+t+ ' )');
      //Elena 20090708 end
        frmSpr.qHistory.Execute;
        prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
        MessageDlg('ОШИБКА КАРТЫ! БСК заблокировано!', mtError, [mbOk], 0);
        exit;
      end;
Ostatok:=0; //(Ильсия 30-10-2009)
      Ostatok := (HexToInt(BSK.sOstLim))/100;

      // записанный на карте интервал не равен текущему периоду - смена периода
      if (BSK.Date <> DB.Date) then        // сравниваем временной интервал БСК с текущей датой
      begin                                // взять из базы новые значения периода и лимита и записать на карту
        BSK.sOstLim := IntToHex(Val[0], 2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2);
        BSK.iOstLim := HexToInt(BSK.sOstLim);
        text := 'остаток ' + FloatToStr((BSK.iOstLim)/100) + ' на ' +IntToStr(BSK.Year)+ ' ' + IntToStr(BSK.Month) + ' ' + IntToStr(BSK.Day);

        frmSpr.qHistory.SQL.Clear; // снимаем остаток с карты
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmSpr.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
        frmSpr.qHistory.Execute;

        DB.iLimit := Round(frmKassa.qSelPerSum.FieldByName('SumCredit').AsFloat*100);
        DB.sLimit := IntToStr(DB.iLimit);
        text := FloatToStr((DB.iLimit)/100);
        case DB.Day of
          1:                            // если период  = 1
          begin
            BSK.iLimit := DB.iLimit;       // лимитБСК = лимитБД
            BSK.iOstLim := DB.iLimit;      // остаток лимитаБСК = лимитБД
            BSK.Month := DB.Month*10 + 1;  // период - 1 половина месяца
            BSK.Year := DB.Year - 2000;    // период - год
          end;
          15:                           // если период  = 2
          begin
            if (BSK.Year = DB.Year) and (BSK.Month = DB.Month) then // если ГодМесяцБСК = ГодМесяцТекущие
            begin
              text := FloatToStr((DB.iLimit)/100) + ' - ' + FloatToStr((BSK.iLimit)/100) + ' + ' + FloatToStr((BSK.iOstLim)/100) + ' ';
              BSK.iOstLim := (DB.iLimit - BSK.iLimit + BSK.iOstLim);//  ОстЛимитаБСК = ЛимитБД - ЛимитБСК + ОстЛимБСК

              if BSK.iOstLim < 0 then // остаток лимита < 0
              begin  // значит беда, !!!!!!!занести БСК в черный список!!!!!!!!!
                frmKassa.btnClientCancel.Click;
                frmSpr.qHistory.SQL.Clear; // пишем историю
                frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
                frmSpr.qHistory.SQL.Add('values(Now(), 12, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ', '' ЛимитБД - ЛимитБСК + ОстЛимБСК ''' + IntToStr(BSK.iOstLim) + ' )');
                frmSpr.qHistory.Execute;

                prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!

                MessageDlg('ОШИБКА! БСК заблокирована, обратитесь в службу ИВЦ!', mtError, [mbOk], 0);
                exit;
              end;

              BSK.iLimit := DB.iLimit;       // лимитБСК = лимитБД
              BSK.Month := DB.Month*10 + 2;  // период - 2 половина месяца
              BSK.Year := DB.Year - 2000;    // период - год
            end
            else          // если ГодМесяцБСК <> ГодМесяцТекущие
            begin
              BSK.iLimit := DB.iLimit;       // лимитБСК = лимитБД
              BSK.iOstLim := DB.iLimit;      // остаток лимитаБСК = лимитБД
              BSK.Month := DB.Month*10 + 2;  // период - 2 половина месяца
              BSK.Year := DB.Year - 2000;    // период - год
            end;
          end;
        end;
        BSK.sOstLim := IntToHex(BSK.iOstLim, 6);
        BSK.sLimit := IntToHex(BSK.iLimit, 6);
        BSK.sInvLim := BSK.sOstLim;
        Val[0] := (HexToInt(BSK.sOstLim[1] + BSK.sOstLim[2])); // остаток лимита
        Val[1] := (HexToInt(BSK.sOstLim[3] + BSK.sOstLim[4])); //
        Val[2] := (HexToInt(BSK.sOstLim[5] + BSK.sOstLim[6])); //
        Val[3] := (HexToInt(BSK.sLimit[1] + BSK.sLimit[2]));   // лимит
        Val[4] := (HexToInt(BSK.sLimit[3] + BSK.sLimit[4]));   //
        Val[5] := (HexToInt(BSK.sLimit[5] + BSK.sLimit[6]));   //
        Val[7] := BSK.Month;                                   // период - № половины месяца
        Val[6] := BSK.Year;                                    // период - год
        Val[8] := (HexToInt(BSK.sOstLim[5] + BSK.sOstLim[6])); // инверсия остатока лимита
        Val[9] := (HexToInt(BSK.sOstLim[3] + BSK.sOstLim[4])); //
        Val[10] := (HexToInt(BSK.sOstLim[1] + BSK.sOstLim[2])); //
        Val[11] := 1; //БСК не заблокировано
        Val[12] := 55; //кредит открыт

        fncWriteInCard(CurrentCardNo, Sector, Block, Val, temp); //Смена периода на БСК, внесена новая сумма!

        frmSpr.qHistory.SQL.Clear; // пишем историю
        frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
        frmSpr.qHistory.SQL.Add('values(Now(), 4, ' + CurrentCardId + ',' + CurrentPersId + ',' + CurrentEmplId + ', "' + text + '" )');
        frmSpr.qHistory.Execute;
        Ostatok := (BSK.iOstLim)/100;
      end
      else// записанный на карте интервал равен текущему периоду - проверяем флаг кредитования
      begin
        if Val[12] = 44 then //кредит закрыт
        begin
          prcAddBSKInStopList(true, false); // добавляем в стоплист
          frmKassa.btnClientCancel.Click;
          MessageDlg('ОШИБКА!' + #13#10 + #13#10 + 'БСК в стоп листе!', mtError, [mbOk], 0);
          a := MifareCardHalt;
          exit;
        end;
      end;

      text := 'остаток перед списанием ' + FloatToStr(Ostatok);
      frmSpr.qHistory.SQL.Clear; // снимаем остаток с карты
      frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
      frmSpr.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
      frmSpr.qHistory.Execute;

      frmKassa.lMessage.Caption := 'Наберите сумму и нажмите "ENTER", для снятия суммы или "ESC" для отмены';
      stOstatok.Caption := FloatToStr(Ostatok) + ' руб.';
      stOst.Caption := FloatToStr(Ostatok);
      frmKassa.seOtdel.Visible := true;
    end
    else
    begin //ошибка нет карты в поле антены
      imgCardNo.Glyph := frmKassa.imgRed.Glyph;
    end;
  end;
  frmKassa.qSelPerSum.Close;
  frmKassa.qSelPers.Close;
  a := MifareCardHalt;
end;

procedure TfrmKassa.btnClientCancelClick(Sender: TObject);
begin
  imgCardNo.Glyph := frmKassa.imgGray.Glyph;
  lFio.Caption := '';
  lTabNo.Caption := '';
  stOstatok.Caption := '0,00';
  lCardNo.Caption := '';
  edSumma.Clear;
//  frmKassa.btnClientOk.Enabled := false;
  frmKassa.btnClientCancel.Enabled := false;
  frmKassa.btnNewClient.Enabled := true;
  gbOplata.Visible := false;
  gbOstatok.Visible := false;
  gbPerson.Visible := false;
  frmKassa.lMessage.Caption := 'Приложите БСК к считывателю, и не убирайте до завершения операций!';

  frmKassa.qSelPerSum.Close;
  frmKassa.qSelPers.Close;

  frmKassa.btnNewClient.SetFocus;
end;

procedure TfrmKassa.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmKassa.btnClientOkClick(Sender: TObject);
var
  iSumma  : integer;
  SummaInTab : string;
  sSumma  : string;

  ErrCode : integer;
  Error   : string;
  ControlErr : string; // отслеживание ошибки
begin
try
  ControlErr := '';
  ErrCode := 0;

  SummaSpisania := StrToFloat(StaticText1.Caption);

  Ostatok := RoundTo(StrToFloat(frmKassa.stOst.Caption), -2) - SummaSpisania;

  iSumma := Round(Ostatok*100);
  sSumma := IntToHex(iSumma, 6);
  Val[0] := (HexToInt(sSumma[1] + sSumma[2]));
  Val[1] := (HexToInt(sSumma[3] + sSumma[4]));
  Val[2] := (HexToInt(sSumma[5] + sSumma[6]));

  Val[8] := (HexToInt(sSumma[5] + sSumma[6])); // инверсия остатока лимита
  Val[9] := (HexToInt(sSumma[3] + sSumma[4])); //
  Val[10] := (HexToInt(sSumma[1] + sSumma[2])); //

  ErrCode := fncWriteInCard(CurrentCardNo, Sector, Block, Val, Error);
  case ErrCode of
    0 :
    begin
      stSpisano.Caption := FloatToStr(SummaSpisania) + ' руб.';
      stOstatokNaChete.Caption := FloatToStr(Ostatok) + ' руб.';

//      frmKassa.qInsSale.Close;
      SummaInTab := StringReplace((FloatToStr(SummaSpisania)), ',', '.', [rfReplaceAll]);
      frmKassa.qInsSale.SQL.Clear;
      frmKassa.qInsSale.SQL.Add('insert into sale(card_id, Empl_id, summa, saletime, tradepoint_id, otdel) ');
      frmKassa.qInsSale.SQL.Add('values(' + CurrentCardId + ', ' + CurrentEmplId + ', ' + SummaInTab + ', Now(),' + IntToStr(TradePoint_id) + ',' + frmKassa.lOtdel.Caption + ')');
      frmKassa.qInsSale.Execute;

      // пишем историю
      frmSpr.qHistory.Close;
      frmSpr.qHistory.SQL.Clear;
      frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
      frmSpr.qHistory.SQL.Add('values(Now(), 1, ' + CurrentCardId + ',' + CurrentPersId + ', ');
      frmSpr.qHistory.SQL.Add(CurrentEmplId + ', ' + SummaInTab + ' )');
      frmSpr.qHistory.Execute;
//      frmKassa.qInsSale.Open;

      text := 'остаток после списания ' + FloatToStr(Ostatok);
      frmSpr.qHistory.SQL.Clear; // снимаем остаток с карты
      frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
      frmSpr.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
      frmSpr.qHistory.Execute;

      gbOplata.Visible := false;
      gbOstatok.Visible := true;
      frmKassa.Resizing(wsNormal);
      frmKassa.Height := 400;
      btnOk.SetFocus;
      frmKassa.lMessage.Caption := 'Для завершения операций нажмите "ВВОД" на клавиатуре или кнопку "Ok" мышкой';
    end;
    1:
    begin
      MessageDlg('Операция завершилась неудачно! ' + #13#10 + 'Код ошибки 1: нет карты в поле антенны!', mtError, [mbOK], 0);
    end;
    666 : //
    begin
      MessageDlg('Внимание! Номер БСК не сходиться!' + #13#10 + 'Приложите БСК № ' + IntToStr(CurrentCardNo) + ' или отмените операцию!', mtWarning, [mbOK], 0);
      frmKassa.lMessage.Caption := 'Номер БСК не сходиться! Приложите БСК № ' + IntToStr(CurrentCardNo) + ' или отмените операцию!';
      edSumma.SetFocus;
    end;
    else
    begin
      // расшифровать коды ошибок
      MessageDlg('Операция завершилась неудачно! Код ошибки: ' + IntToStr(ErrCode), mtError, [mbOK], 0);
    end;
  end;

except
  on E:EConvertError do
  begin
    ControlErr := ControlErr + inttostr(ErrCode) + ' ошибка ввод суммы';// 2 этап
    MessageDlg('Ошибка ввода суммы!', mtError, [mbOK], 0);
  end;

  on E: Exception do
  begin
    ControlErr := ControlErr + inttostr(ErrCode) + ' другая ошибка';// 2 этап
  end;
end;
  if ControlErr <>'' then
  begin
    frmSpr.qHistory.Close;
    frmSpr.qHistory.SQL.Clear;// контрольное отслеживание ошибки
    frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo)');
    frmSpr.qHistory.SQL.Add('values(Now(), 12, ' + CurrentCardId + ',' + CurrentPersId + ', ');
    frmSpr.qHistory.SQL.Add(CurrentEmplId + ', ' + ControlErr + ' )');
    frmSpr.qHistory.Execute;
  end;
  prcSalesOfDay;
end;

procedure TfrmKassa.edSummaKeyPress(Sender: TObject; var Key: Char);
begin
  PosPunct := pos(',', edSumma.Text);
  case PosPunct of
    0:
    begin
      bDelimYes := false;
    end;
  else
    begin
        if ((length(edSumma.Text) - PosPunct) >= 2) and
          (key in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', ',']) then key := #0
    end;
  end;

  PosPunct := pos('-', edSumma.Text);
  case PosPunct of
    0:
    begin
      bMinusYes := false;
    end;
  end;

  case key of
  #13 : // нажата клавиша Enter - принимаем операцию
    begin
      if fncChek then
        case MessageDlg('С БСК будет снята сумма ' + frmKassa.StaticText1.Caption + ' руб.' + #13#10
                      + 'Подтверждаете операцию?', mtConfirmation, [mbYes, mbNo], 0) of
         mrYes: // снимаем сумму с БСК
         begin
           frmKassa.btnClientOk.Click();
         end;
         mrNo:  // возвращаемся в набор суммы
         begin
           frmKassa.btnClientCancel.Click();
         end;
        end
      else
        frmKassa.edSumma.SetFocus;
    end;
  #27 : // нажата клавиша Esc - отменяем операцию
    frmKassa.btnClientCancel.Click();
  #43 : // нажата клавиша "+" - переносим сумму в чек
    begin
      key := #0;
      fncChek;
    end;
  #45 : // нажата клавиша "-" - переносим ее в начало суммы
  begin
    if not bMinusYes then
    begin
      bMinusYes := true;
      frmKassa.edSumma.Text := '-' + frmKassa.edSumma.Text;
      fncChek;

//      frmKassa.edSumma.SelStart := length(frmKassa.edSumma.text);
    end;
    key := #0;
  end;
  #8, #48, #49, #50, #51, #52, #53, #54, #55, #56, #57 : // нажата цифра - оставняем как есть
    key := key;
  #44, #46 : // нажата клавиша "." - превращаем ее в ','
    begin
      Key := ',';
    end
  else
    key := #0;
  end;
  if key = ',' then
  begin
    if bDelimYes then
      key := #0
    else
      bDelimYes := true;
  end;

{//  chr((#key);
//  if key in [#1, #2] then   ShowMessage(key);
//  if key = '-' then key := #0;
  if key = '.' then key := ',';
  if key in ( ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', ',', #8, #13, #27] ) then
    key := key
  else key := #0;
  case key of
  #13 : // нажата клавиша Enter - принимаем операцию
  #27 : // нажата клавиша Esc - отменяем операцию
    frmKassa.btnClientCancel.Click();
  end;}
end;

procedure TfrmKassa.btnOkClick(Sender: TObject);
begin
  frmKassa.btnClientCancel.Click;
//  gbOplata.Visible := false;
  gbOstatok.Visible := false;
  frmKassa.lMessage.Caption := 'Приложите новое БСК к считывателю, и не убирайте до завершения операций!';
  btnNewClient.SetFocus;
end;

procedure TfrmKassa.tClockTimer(Sender: TObject);
begin
  frmKassa.lTime.Caption := TimeToStr(Now);
end;

procedure TfrmKassa.FormShow(Sender: TObject);
begin
  prcSalesOfDay;
  frmKassa.Height := 425;
  frmKassa.lDate.Caption := DateToStr(Now);
  PosPunct := 0;
end;

procedure TfrmKassa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmKassa.btnClientCancel.Click();
end;

function fncChek():boolean;
var
  k : real;
  text, otdel : string;
  l, i, p : integer;
  function AddZero(a : string) : string;
  var j, f : integer;
  begin
    a := FloatToStr(RoundTO(StrToFloat(a), -2));
    result := a;
    if pos(',', a) = 0 then
      result := a + ',00'
    else
    begin
      j := length(a) - Pos(',', a);
      case j of
        2 : result := a;// + ',00';
        1 : result := a + '0';
      end;
    end;
  end;
begin
  result := true;
  k := StrToFloat(frmKassa.StaticText1.Caption);
  try
    k := k + StrToFloat(frmKassa.edSumma.Text);
  except
    result := false;
    if (frmKassa.edSumma.Text = '') and (frmKassa.StaticText1.Caption <> '0') then
      result := true;
    frmKassa.edSumma.Clear;
    exit;
  end;
  if  K > Ostatok then
  begin
    MessageDlg('ОШИБКА!' + #13#10 + 'Невозможно снять сумму,' + #13#10 + 'недостаточно средств!', mtError, [mbOK], 0);
    result := false;
    exit;
  end;
  if k <= 0 then
  begin
    MessageDlg('ОШИБКА!' + #13#10 + 'Невозможно снять сумму,' + #13#10 + 'набранная сумма меньше или = 0!', mtError, [mbOK], 0);
    result := false;
  end
  else
  begin
    otdel := IntToStr(frmKassa.seOtdel.Value);
    frmKassa.StaticText1.Caption := FloatToStr(RoundTo(k, -2));
    text := IntToStr(frmKassa.Memo1.Lines.Count + 1) + '.' +  AddZero(frmKassa.edSumma.Text);
    p := pos('.', text) + 1;  //17 символов
    l := 17 - length(text);
    i := l;
    while i > 0 do
    begin
      insert('.', text, p);
      Inc(i, -1);
    end;
    frmKassa.Memo1.Lines.Append(text);
    frmKassa.lOtdel.Caption := IntToStr(frmKassa.seOtdel.Value);
    frmKassa.seOtdel.Visible := False;
    frmKassa.edSumma.Clear;
  end;
end;

procedure TfrmKassa.seOtdelChange(Sender: TObject);
begin
  frmKassa.edSumma.SetFocus;
end;

end.
