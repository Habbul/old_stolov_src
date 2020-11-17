unit untKassa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, untGlobalVar, untMifareDll, Mask, MySQLDataset,
  DB, MySQLServer, IniFiles;

type
  TfrmKassa = class(TForm)
    qSelPers: TMySQLQuery;
    qSelPerSum: TMySQLQuery;
    qInsSale: TMySQLQuery;
    qTemp: TMySQLQuery;
    MySQLServer: TMySQLServer;
    qHistory: TMySQLQuery;
    Timer1: TTimer;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
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
//function fncChek():boolean;
function fncNewClient(var Kod, Str, FIO, Summa : string) : boolean;
procedure prcWriteInFile(Kod, Str : string);
implementation

uses ConvUtils, DateUtils, Math;

{$R *.dfm}

function fncNewClient(var Kod, Str, FIO, Summa : string) : boolean;
var
  BSK, DB    : TValueBSK_DB;
  temp, text : string;
  iSumma     : integer;
  SummaInTab : string;
  sSumma     : string;
  ErrCode    : integer;
  Error      : string;
  t          : string;
begin
  Result := false;
  CardNo := 0;
  a := MifareCardRequest(MODE_ALL);  // request
  a := MifareAnticollision(@CardNo); // anticollision
  a := MifareCardSelect(CardNo);     // select card
  case a of
    Mifare_Ok :
    begin
      AuthentMode := Key_A or Key_Set0; // autentication
      a := MifareSectorAuthentication(AuthentMode, Sector);

      // считываем с карточки данные: период действия лимита, доступная сумма
      a := MifareBlockRead(Sector, Block, @Val);

      try
      case val[11] of
        66 : // БСК заблокирована
        begin // меняем флаг кредита в базе на "некредитуемый"
          prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
          kod := '550';
          Str := 'ОШИБКА! БСК заблокирована';
          a := MifareCardHalt;
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
          kod := '560';
          Str := 'ОШИБКА! Данных по начислению кредита не найдено, или БСК в черном списке!';
          a := MifareCardHalt;
          exit;
        end;
        1 :  // все в норме
        begin
//          if frmKassa.qSelPerSum.FieldByName('statecard_id').AsInteger = 2 then
//          begin
//            MessageDlg('ВНИМАНИЕ: данная БСК в черном списке!', mtWarning, [mbOk], 0);
//            a := MifareCardHalt;
//            exit;
//          end;
        end;
        else // ошибка: выбрано более одной записи по данной карте на заданный период
        begin
          kod := '561';
          Str := 'ОШИБКА! Задвоение записей в базе!';
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
      
      case frmKassa.qSelPers.RecordCount of       // по считанному номеру выбираем персональные данные из базы
        0 :  // ошибка: не найдены данные на владельца БСК
        begin
          kod := '570';
          Str := 'ОШИБКА! Не найдены данные на владельца БСК, или сотрудник в черном списке!';
          a := MifareCardHalt;
          exit;
        end;
        1 :  // все в норме, проверить флаг кредита
        begin
//          if frmKassa.qSelPers.FieldByName('fk').AsInteger = 2 then
//          begin
//            MessageDlg('ВНИМАНИЕ: даннный сотрудник в черном списке!', mtWarning, [mbOk], 0);
//            a := MifareCardHalt;
//            exit;
//          end;
          bDelimYes := false;
        end;
        else // ошибка: найдено более 1 владельца БСК
        begin
          kod := '571';
          Str := 'ОШИБКА! Найдено более 1 владельца БСК!';
          a := MifareCardHalt;
          exit;
        end;
      end;

      FIO := frmKassa.qSelPers.fieldbyname('persname').AsString; // запоминаем персональные данные
      CurrentCardId := frmKassa.qSelPers.fieldbyname('cardid').AsString;
      CurrentPersId := frmKassa.qSelPers.fieldbyname('persid').AsString;

      frmKassa.qTemp.Close;           // проверяем, БСК в стоп-листе или нет
      frmKassa.qTemp.SQL.Clear;
      frmKassa.qTemp.SQL.Add('select * from stoplist where nomer="' + IntToStr(CardNo) + '"');
      frmKassa.qTemp.Open;
      if frmKassa.qTemp.RecordCount <> 0 then
      begin                             //БСК в стоп-листе
        prcAddBSKInStopList(true);      // выставляем флаг на бск
        kod := '550';
        Str := 'ОШИБКА! БСК в стоп-листе';
        exit;
      end;

      BSK.sOstLim := IntToHex(Val[0], 2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2);
      BSK.sLimit := IntToHex(Val[3], 2) + IntToHex(Val[4], 2) + IntToHex(Val[5], 2);
      BSK.sInvLim := IntToHex(Val[10], 2) + IntToHex(Val[9], 2) + IntToHex(Val[8], 2);
      BSK.iOstLim := HexToInt(BSK.sOstLim);
      BSK.iLimit := HexToInt(BSK.sLimit);
      BSK.iInvLim := HexToInt(BSK.sInvLim);
      Ostatok := BSK.iOstLim/100;

      if BSK.sOstLim <> BSK.sInvLim  then  // сравниваем остаток и перевернутый остаток, если не равны выдаем ошибку
      begin
        frmKassa.qHistory.SQL.Clear; // пишем историю
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 9, ' + CurrentCardId + ',' + CurrentPersId + ', ');
        frmKassa.qHistory.SQL.Add(IntToStr(CardNo) + ' )');
        frmKassa.qHistory.Execute;
        prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
        kod := '580';
        Str := 'ОШИБКА КАРТЫ! Данные на БСК утеряны';
        exit;
      end;
      //Elena 20090708 begin
      t := '"БСК размагниченно, данные утеряны! ' + inttostr(val[1]) + ' ' + inttostr(val[2]) + ' ' + inttostr(val[3]) + ' ' + inttostr(val[4])+
           ' ' + inttostr(val[5])+ ' ' + inttostr(val[6]) + ' ' + inttostr(val[7])+ ' ' +
           inttostr(val[8])+ ' ' + inttostr(val[9])+ ' ' + inttostr(val[10])+ ' ' + inttostr(val[11]) + '"';
      //Elena 20090708 end
      try
      if (val[7] > 122) or (val[7] = 0)  then // если значение месяц/период > 122
      begin                                   // присваиваем текущий период
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
        Val[5] := 0;   //}
        val[7] := DB.Month * 10 + DB.Day;
        val[6] := DB.Year - 2000;
        Val[8] := 0; // инверсия остатока лимита
        Val[9] := 0; //
        Val[10] := 0; //

        frmKassa.qHistory.SQL.Clear; // пишем историю
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 10, ' + CurrentCardId + ',' + CurrentPersId + ','+t+ ' )');
        frmKassa.qHistory.Execute;

        fncWriteInCard(CardNo, Sector, Block, Val, temp); //Смена периода на БСК, внесена новая сумма!

        frmKassa.qHistory.SQL.Clear; // пишем историю
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 4, ' + CurrentCardId + ',' + CurrentPersId + ', "выставлен текущий период, сумма=0 " )');
        frmKassa.qHistory.Execute;

        kod := '580';
        Str := 'ОШИБКА КАРТЫ! БСК размагничена, данные утеряны!';
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
        frmKassa.qHistory.SQL.Clear; // пишем историю
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 10, ' + CurrentCardId + ',' + CurrentPersId + ',' + t + ' )');
        frmKassa.qHistory.Execute;
        prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
        kod := '580';
        Str := 'ОШИБКА КАРТЫ! Данные на БСК утеряны';
        exit;
      end;

      // записанный на карте интервал не равен текущему периоду
      if (BSK.Date <> DB.Date) and (DB.iLimit > BSK.iLimit) then        // сравниваем временной интервал БСК с текущей датой
      begin                                // взять из базы новые значения периода и лимита и записать на карту
        BSK.sOstLim := IntToHex(Val[0], 2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2);
        BSK.iOstLim := HexToInt(BSK.sOstLim);
        text := 'остаток ' + FloatToStr((BSK.iOstLim)/100) + ' на ' +IntToStr(BSK.Year)+ ' ' + IntToStr(BSK.Month) + ' ' + IntToStr(BSK.Day);

        frmKassa.qHistory.SQL.Clear; // снимаем остаток с карты
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
        frmKassa.qHistory.Execute;

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
            if (BSK.Year = DB.Year) and (BSK.Month = DB.Month) and (DB.iLimit > BSK.iLimit) then // если ГодМесяцБСК = ГодМесяцТекущие
            begin
              text := FloatToStr((DB.iLimit)/100) + ' - ' + FloatToStr((BSK.iLimit)/100) + ' + ' + FloatToStr((BSK.iOstLim)/100) + ' ';
              BSK.iOstLim := (DB.iLimit - BSK.iLimit + BSK.iOstLim);//  ОстЛимитаБСК = ЛимитБД - ЛимитБСК + ОстЛимБСК

              if BSK.iOstLim < 0 then // остаток лимита < 0
              begin  // значит беда, !!!!!!!занести БСК в черный список!!!!!!!!!
                frmKassa.qHistory.SQL.Clear; // пишем историю
                frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
                frmKassa.qHistory.SQL.Add('values(Now(), 12, ' + CurrentCardId + ',' + CurrentPersId + ', '' ЛимитБД - ЛимитБСК + ОстЛимБСК ''' + IntToStr(BSK.iOstLim) + ' )');
                frmKassa.qHistory.Execute;

                prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
                kod := '550';
                Str := 'ОШИБКА! БСК заблокирована';
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

        fncWriteInCard(CardNo, Sector, Block, Val, temp); //Смена периода на БСК, внесена новая сумма!

        frmKassa.qHistory.SQL.Clear; // пишем историю
        frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
        frmKassa.qHistory.SQL.Add('values(Now(), 4, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
        frmKassa.qHistory.Execute;
        Ostatok := (BSK.iOstLim)/100;
      end
      else// записанный на карте интервал равен текущему периоду - проверяем флаг кредитования
      begin
        if Val[12] = 44 then //кредит закрыт
        begin
          kod := '550';
          Str := 'ОШИБКА! БСК в стоп-листе';
          exit;
        end;
        //на БСК текущий период, сравниваем остаток и сумму списания
        BSK.sOstLim := IntToHex(Val[0], 2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2);
        BSK.sLimit := IntToHex(Val[3], 2) + IntToHex(Val[4], 2) + IntToHex(Val[5], 2);
        BSK.sInvLim := IntToHex(Val[10], 2) + IntToHex(Val[9], 2) + IntToHex(Val[8], 2);
        BSK.iOstLim := HexToInt(BSK.sOstLim);
        BSK.iLimit := HexToInt(BSK.sLimit);
        BSK.iInvLim := HexToInt(BSK.sInvLim);
        Ostatok := BSK.iOstLim/100;

        if BSK.sOstLim <> BSK.sInvLim  then  // сравниваем остаток и перевернутый остаток, если не равны выдаем ошибку
        begin
          frmKassa.qHistory.SQL.Clear; // пишем историю
          frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
          frmKassa.qHistory.SQL.Add('values(Now(), 9, ' + CurrentCardId + ',' + CurrentPersId + ', ');
          frmKassa.qHistory.SQL.Add(IntToStr(CardNo) + ' )');
          frmKassa.qHistory.Execute;
          prcBSKBadData(IntToStr(CardNo)); // БСК в черный список!
          kod := '580';
          Str := 'ОШИБКА! Данные на БСК утеряны';
          exit;
        end;
      end;
//      if Ostatok < SummaSpisania then  //остаток на БСК меньше запрашиваемой суммы
//      begin
//        kod := '590';
//        Str := 'Не достаточно средств! Доступно ' + FloatToStr(Ostatok);
//        exit;
//      end;
    end
    else
    begin //ошибка нет карты в поле антены
      kod := '531';
      Str := 'ОШИБКА! Не найдена карта';
      exit;
    end;
  end;
  frmKassa.qSelPerSum.Close;
  frmKassa.qSelPers.Close;

  //-------------------------Списываем сумму-------------------------
//  SummaSpisania := StrToFloat(frmKassa.edSumma.Text);

      //Elena 20090709 begin
      text := 'остаток перед списанием ' + FloatToStr(Ostatok);
      frmKassa.qHistory.SQL.Clear; // снимаем остаток с карты перед снятия суммы
      frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
      frmKassa.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
      frmKassa.qHistory.Execute;
      //Elena 20090709 end

  if  Ostatok < SummaSpisania then
  begin
    kod := '590';
    Str := 'Не достаточно средств! Доступно ' + FloatToStr(Ostatok) + ' руб.';
    result := false;
    exit;
  end;

  Ostatok := Ostatok - SummaSpisania;

  iSumma := Round(Ostatok*100);
  sSumma := IntToHex(iSumma, 6);
  Val[0] := (HexToInt(sSumma[1] + sSumma[2]));
  Val[1] := (HexToInt(sSumma[3] + sSumma[4]));
  Val[2] := (HexToInt(sSumma[5] + sSumma[6]));

  Val[8] := (HexToInt(sSumma[5] + sSumma[6])); // инверсия остатока лимита
  Val[9] := (HexToInt(sSumma[3] + sSumma[4])); //
  Val[10] := (HexToInt(sSumma[1] + sSumma[2])); //

  ErrCode := fncWriteInCard(CardNo, Sector, Block, Val, Error);
  case ErrCode of
    0 :
    begin
      Summa := FloatToStr(Ostatok);

      SummaInTab := StringReplace((FloatToStr(SummaSpisania)), ',', '.', [rfReplaceAll]);
      frmKassa.qInsSale.SQL.Clear;
      frmKassa.qInsSale.SQL.Add('insert into sale(empl_id, card_id, summa, saletime, tradepoint_id, otdel) ');
      frmKassa.qInsSale.SQL.Add('values(' + inttostr(empl_id) + ',' + CurrentCardId + ', ' + SummaInTab + ', Now(), ' + IntToStr(TradePoint_id) + ', 1)');
      frmKassa.qInsSale.Execute;

      // пишем историю
      frmKassa.qHistory.Close;
      frmKassa.qHistory.SQL.Clear;
      frmKassa.qHistory.SQL.Add('insert into historyevents(empl_id, opertime, Event_id, Card_id, pers_id, memo)');
      frmKassa.qHistory.SQL.Add('values(' + inttostr(empl_id) + ', Now(), 1, ' + CurrentCardId + ',' + CurrentPersId + ', ');
      frmKassa.qHistory.SQL.Add(SummaInTab + ' )');
      frmKassa.qHistory.Execute;

      //Elena 20090709 begin
      text := 'остаток после списания ' + FloatToStr(Ostatok);
      frmKassa.qHistory.SQL.Clear; // снимаем остаток с карты
      frmKassa.qHistory.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo)');
      frmKassa.qHistory.SQL.Add('values(Now(), 15, ' + CurrentCardId + ',' + CurrentPersId + ', "' + text + '" )');
      frmKassa.qHistory.Execute;
      //Elena 20090709 end

      frmKassa.qSelPerSum.Close;
      frmKassa.qSelPers.Close;
      result := true;
    end;
    1:
    begin
      kod := '531';
      Str := 'ОШИБКА! Не найдена карта';
      exit;
    end;
    else
    begin
      kod := '666';
      Str := 'Другая ошибка: ' + IntToStr(ErrCode);
      exit;
    end;
  end;
  a := MifareCardHalt;
end;


procedure prcWriteInFile(Kod, Str : string);
begin
  AssignFile(TextF, PuthFileReader);
  Rewrite(TextF);
  writeln(TextF, Kod);
  writeln(TextF, Str);
  CloseFile(TextF);
end;

function fncSettMySQL():boolean;
var
  puth : string;
begin
  result := true;
try
  puth := PuthFolder + '\Setting.ini';
  tIniSett := TIniFile.Create(puth);
  frmKassa.MySQLServer.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
  frmKassa.MySQLServer.Host := tIniSett.ReadString('MySQL', 'Host', 'localhost');
  frmKassa.MySQLServer.DatabaseName := tIniSett.ReadString('MySQL', 'DB', 'beznal');
  frmKassa.MySQLServer.Connect;
  TradePoint_id := tIniSett.ReadInteger('Setting', 'TradePoint', 1);
  Empl_id := tIniSett.ReadInteger('Setting', 'EmplId', 1);
  tIniSett.Destroy;
except
  result := false;
  frmKassa.MySQLServer.Disconnect;
end;
end;

procedure TfrmKassa.FormShow(Sender: TObject);
var
  Kod, str, FIO, Sum : string;
begin
  frmKassa.Timer1.Enabled := true;
  //проверка связи с базой
  if not fncSettMySQL then
  begin
    prcWriteInFile('600', 'Проблемы при настройке доступа к базе');
    close;
  end;

  if FileExists(PuthFileRarus) then //проверяем наличие файла с информацией о сумме
  begin
    AssignFile(TextF, PuthFileRarus);
    Reset(TextF);
    read(TextF, Str);
    CloseFile(TextF);

    //проверить STR на отрицательность
    case Length(Str) of
    0 :
      begin
        prcWriteInFile('540','Файл с исходными данными пуст!');
        close;
      end;
    else
    begin
      SummaSpisania := StrToFloat(Str);
      case fncIniReader of                 //инициализируем ридер
      false:
        begin                           //при инициализации возникли проблемы
          a := MifareSessionClose;      // закрываем сессию работы с картой, передаем в файл данные об ошибке
          prcWriteInFile('530','Ошибка при инициализации считывателя!');
          close;                        //закрывем приложение
        end;
      end;

      case fncNewClient(kod, str, FIO, Sum) of              //принимаем нового клиента //снимаем сумму
      false:
        begin // ошибка при выборе нового клиента
          prcWriteInFile(Kod, Str);
          close;
        end;
      true:
        begin // клиент принят успешно
          prcWriteInFile('500', FIO + ', остаток ' + Sum + ' руб.');
          close;
        end;
      end;
    end
    end;
    DeleteFile(PuthFileRarus);
  end
  else //файла не существует
  begin
    prcWriteInFile('520','Не найден исходный файл!');
    close;
  end;
end;

procedure TfrmKassa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  a := MifareSessionClose;              // закрываем сессию работы с картой
end;

{function fncChek():boolean;
var
  k : real;
begin
  result := true;
  k := StrToFloat(frmKassa.edSumma.Text);
  try
    k := k + StrToFloat(frmKassa.edSumma.Text);
  except
    result := false;
    if (frmKassa.edSumma.Text = '') and (frmKassa.edSumma.Text <> '0') then
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
    MessageDlg('ОШИБКА!' + #13#10 + 'Невозможно снять сумму,' + #13#10 + 'набранная сумма меньше 0!', mtError, [mbOK], 0);
    result := false;
  end
  else
  begin
    frmKassa.edSumma.Text := FloatToStr(RoundTo(k, -2));
    frmKassa.edSumma.Clear;
  end;
end;  }

procedure TfrmKassa.Timer1Timer(Sender: TObject);
begin
  frmKassa.Enabled := false;
  frmKassa.Close;
end;

initialization
PuthFileRarus := PuthFolder + '\FileRarus.txt';
PuthFileReader := PuthFolder + '\FileReader.txt';

end.
