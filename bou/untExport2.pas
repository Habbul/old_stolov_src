unit untExport2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, MySQLDataset, MySQLServer, OleServer,
  OleCtnrs, comobj, ExcelXp, DBTables, IniFiles, Spin, ExtCtrls, math;

type
  TfrmExport2 = class(TForm)
    GroupBox3: TGroupBox;
    rbDay: TRadioButton;
    gbDay: TGroupBox;
    dtDay: TDateTimePicker;
    rbPeriod: TRadioButton;
    gbPeriod: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtDateBegin: TDateTimePicker;
    dtDateEnd: TDateTimePicker;
    qReport: TMySQLQuery;
    tExport: TTable;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Button4: TButton;
    Panel1: TPanel;
    btnStep1: TBitBtn;
    pnlStep1: TPanel;
    lStep1: TLabel;
    Panel3: TPanel;
    Image3: TImage;
    pnlStep5: TPanel;
    Image4: TImage;
    Label3: TLabel;
    pnlStep3: TPanel;
    Image5: TImage;
    lStep3: TLabel;
    pnlStep4: TPanel;
    Image2: TImage;
    Label5: TLabel;
    btnReport: TButton;
    GroupBox2: TGroupBox;
    rbOtdel: TRadioButton;
    rbAll: TRadioButton;
    Panel2: TPanel;
    btnExit: TBitBtn;
    Button3: TButton;
    pbExport: TProgressBar;
    Label4: TLabel;
    btnStep3: TButton;
    ServerRoot: TMySQLServer;
    qExport: TMySQLQuery;
    Button6: TButton;
    cbMonth: TComboBox;
    seYear: TSpinEdit;
    Query_temp: TMySQLQuery;
    procedure btnExitClick(Sender: TObject);
    procedure rbDayClick(Sender: TObject);
    procedure rbPeriodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtDateBeginChange(Sender: TObject);
    procedure dtDayChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnStep1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExport2: TfrmExport2;
  ListDriv1, ListDriv2 : String;
procedure prcCreateFileExcel(NameF, NameL, Password : string);
function GetHardDiskSerial(const DriveLetter: Char): string;
function fncExportDB() : boolean;
procedure prcGetDriv(var List : String);
function fncExportSale(): boolean;
function fncDateDelphiToSQL(DateDelphi: TDateTime) : string;
function fncAddStopList() : boolean; // функция загрузки стоп-листа

implementation

uses untGlobalVar, untSpravochnik, DateUtils;

{$R *.dfm}

procedure TfrmExport2.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmExport2.rbDayClick(Sender: TObject);
begin
  case rbDay.Checked of
  true:
    begin
      gbDay.Visible := true;
      gbPeriod.Visible := false;
    end;
  end;
end;

procedure TfrmExport2.rbPeriodClick(Sender: TObject);
begin
  case rbPeriod.Checked of
  true:
    begin
      gbDay.Visible := false;
      gbPeriod.Visible := true;
    end;
  end;
end;

procedure TfrmExport2.FormShow(Sender: TObject);
var
  wYear, wMonth, wDay : word;
begin
  dtDay.Date := Now;
  dtDateBegin.Date := Now;
  dtDateEnd.Date := Now;
  DecodeDate(now, wYear, wMonth, wDay);
//  frmExport2.cbMonth.ItemIndex := wMonth - 2;
//  frmExport2.seYear.Value := wYear;

end;

procedure prcGetDriv(var List : String);
var
  i: integer;
  LogDrives: set of 0..25;
begin
  List := '';
  integer(LogDrives) := GetLogicalDrives;
  for i := 0 to 25 do
    if (i in LogDrives) then
    begin
      List := list + (chr(i + 65));
    end;
end;

function fncDateDelphiToSQL(DateDelphi: TDateTime) : string;
var
  wYear, wMonth, wDay, wHour, wMin, wSec, wMSec : Word;
begin
  DecodeDateTime(DateDelphi, wYear, wMonth, wDay, wHour, wMin, wSec, wMSec);
  Result := IntToStr(wYear) + '-' + IntToStr(wMonth) + '-' + IntToStr(wDay) +
           ' ' + IntToStr(wHour) + ':' + IntToStr(wMin) + ':' + IntToStr(wSec);
end;

function fncExportSale(): boolean;
var
  DateB,
  DateE  : TDateTime;
  sql    : string;
  sLabel,
  sDate  : string;
  NameF  : string;
  TextF  : TextFile;
  History_name, HistoryEvent_id: string;
  Copy_History: textfile;
begin
  result := true;
  // имя файла состоит из TradePoint_Ok.bou
  NameF := FlashButton + ':\' + IntToStr(TradePoint_id) + '_Ok.bou';
  if not FileExists(NameF) then         // ищем на флешке файл-флаг подтверждения выгрузки
  begin                                 // файл не найден, {выдаем ошибку!!! или} формируем файл выгрузки sale
//    result := false;                  // с самой первой даты, т.е. выставить sDate := ''
//    MessageDlg('Ошибка при выгрузке ведомости!' + #13#10+ 'Не найден файл обмена!', mtError, [mbOk], 0);
//    exit;
    sDate := '';
  end
  else                                  // файл существует
  begin
    AssignFile(TextF, NameF);
    Reset(TextF);                         
    read(TextF, sDate);                 // считываем данные - дату последней выгруженой записи из таблицы sale
    CloseFile(TextF);
  end;

  if sDate = '' then                    // если файл обмена пуст берем самую первую запись в таблице sale
  begin
    frmExport2.qReport.Close;
    frmExport2.qReport.SQL.Clear;
    frmExport2.qReport.SQL.Add('select min(saletime) as MinST from sale');
    frmExport2.qReport.Open;            // уменьшаем ее на 1 день, чтобы 1 запись попала в запрос
    DateB := IncDay(frmExport2.qReport.FieldByName('MinST').AsDateTime, -1);
    sDate := fncDateDelphiToSQL(DateB); // переводим дату в формат mysql
  end
  else                                  // в файле обмена имеются данные
  begin                                 // дата последней выгруженой записи из таблицы sale
    frmExport2.qReport.Close;           // ищем такую запись в sale
    frmExport2.qReport.SQL.Clear;
    frmExport2.qReport.SQL.Add('select * from sale where saletime = "' + sDate + '"');
    frmExport2.qReport.Open;
    case frmExport2.qReport.RecordCount of
      0 :                               // нет такой записи, значит ошибка ...
      begin                             // например флешка с другой точки
        MessageDlg('Ошибка при выгрузке ведомости!' + #13#10 + 'Ошибка при синхронизации!', mtError, [mbOk], 0);
        result := false;
        exit;
      end;
      1 :                               // есть такая запись, все нормально
      begin                             // ничего не делаем, двигаемся дальше
      end;
    else                                // задвоение записей, ошибка
      begin                             // такого в принципе произойти не должно
        MessageDlg('Ошибка при выгрузке ведомости!' + #13#10 + 'Другая ошибка!', mtError, [mbOk], 0);
        result := false;
        exit;
      end;
    end;
  end;

  try                                   // инициализация БД в админовской учетной записи. для выгрузки
    tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
    frmExport2.ServerRoot.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
    frmExport2.ServerRoot.Host := tIniSett.ReadString('MySQL', 'Host', '');
    frmExport2.ServerRoot.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
    tIniSett.Destroy;
    frmExport2.ServerRoot.Connect;
  except
    ShowMessage('Ошибка при инициализации базы!');
    frmExport2.ServerRoot.Disconnect;
    result := false;
    exit;
  end;

  DeleteFile(NameF);                    // если мы дошли до сюда, файл tradepoint_ok.bou удаляется

  if FileExists(FlashButton + ':\' + IntToStr(TradePoint_id) + '_sale.bou') then  // удаляем с флешки файл sale.bou, если есть
    DeleteFile(FlashButton + ':\' + IntToStr(TradePoint_id) + '_sale.bou');
                                        // делаем выборку продаж
  sql := 'select tradepoint_id, card_id, empl_id, summa, saletime, otdel from beznal.sale ' +
         'where saletime > "' + sDate + '" into outfile "' + FlashButton + ':\\' + IntToStr(TradePoint_id) + '_sale.bou" ';

  frmExport2.qExport.Close;
  frmExport2.qExport.SQL.Clear;
  frmExport2.qExport.SQL.Add(sql);
  frmExport2.qExport.Execute(true);
  FileSetAttr(FlashButton + ':\' + IntToStr(TradePoint_id) + '_sale.bou', faHidden);         // устанавливаем аттрибут у файла sale - скрытый

  frmExport2.qReport.Close;             // берем время последней продажи ...
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('select max(saletime) as MaxSaleTime, max(sales_id) as MaxSaleId from sale');
  frmExport2.qReport.Open;
                                        // ... переводим в формат mysql ...
  sDate := fncDateDelphiToSQL(frmExport2.qReport.FieldByName('MaxSaleTime').AsDateTime);

  NameF := FlashButton + ':\' + IntToStr(TradePoint_id) + '_Wait.bou'; // имя файла состоит из TradePoint_Wait.bou
  if FileExists(NameF) then
  begin                                 // удалить файл если существует!
    DeleteFile(NameF);
  end;
  AssignFile(TextF, NameF);
  Rewrite(TextF);                       // ...и записываем в файл-флаг ожидания подтверждения
  writeln(TextF, sDate);
  writeln(TextF, frmExport2.qReport.FieldByName('MaxSaleId').AsString);
  FileSetAttr(NameF, faHidden);         // устанавливаем аттрибут у файла - скрытый
  CloseFile(TextF);
  frmExport2.qReport.Close;


//формируем файл Historyevents
try
//определяем имя файла
History_name:=FlashButton+':\'+IntToStr(TradePoint_id)+'_History.bou';

if FileExists(History_name) then
DeleteFile(History_name);

//определяем с какой записи начать копирование
HistoryEvent_id:='0';
if FileExists(FlashButton+':\'+IntToStr(TradePoint_id)+'_Copy_History.txt') then begin
AssignFile(Copy_History, FlashButton+':\'+IntToStr(TradePoint_id)+'_Copy_History.txt');
Reset(Copy_History);
Readln(Copy_History, HistoryEvent_id);
if HistoryEvent_id='' then
HistoryEvent_id:='0';
CloseFile(Copy_History);
end;


//запрос из базы
frmExport2.Query_temp.Close;
frmExport2.Query_temp.SQL.Clear;
frmExport2.Query_temp.SQL.Add('select '+IntToStr(TradePoint_id)+',HistoryEvent_id, OperTime, Card_id, Pers_id, Empl_id, Event_id, Memo  from historyevents ');
frmExport2.Query_temp.SQL.Add('where historyevent_id>'+HistoryEvent_id);
frmExport2.Query_temp.SQL.Add('into outfile '''+History_name+'''');
frmExport2.Query_temp.Execute(true);

FileSetAttr(History_name, faHidden);         // устанавливаем аттрибут у файла - скрытый

except
MessageDlg('Ошибка копирования HistoryEvents!', mtError, [mbOk], 0);
result := false;
exit;
end;
end;

function fncExportDB() : boolean;
var
  XLApp  : Variant;
  Sheet  : Variant;
  Range  : Variant;
  Colum  : Variant;
  i      : Integer;
  DateBStr, DateEStr : string;
  DateB, DateE : TDate;
  Year, Month, DayB, DayE : Word;
  vedomost : string;
  sum : real;
  NameF, NameL, Password : string;
  posit : real;
  posit2 : integer;
begin
  posit := (frmExport2.pbExport.Max - frmExport2.pbExport.Position)/5 ;
  frmExport2.pbExport.Position := frmExport2.pbExport.Position + Round(posit);
  Result := false;
  Year := frmExport2.seYear.Value;
  Month := frmExport2.cbMonth.ItemIndex + 1;
  DayB := 1;
  DayE := DaysInAMonth(Year, Month); // кол-во дней в месяце, для определения последнего дня

  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayB);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayE);

  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO,');
  frmExport2.qReport.SQL.Add('sum(s.summa) as summa FROM sale s, card c, pers p');
  frmExport2.qReport.SQL.Add('where s.card_id = c.card_id and c.card_id = p.card_id and ');
  frmExport2.qReport.SQL.Add('date(s.saletime) >= date(''' + DateBStr + ''') and date(s.saletime) <= date(''' + DateEStr + ''')');
  frmExport2.qReport.SQL.Add('group by p.tabnum');
  frmExport2.qReport.SQL.Add('order by p.family');
  frmExport2.qReport.Open;

  frmExport2.pbExport.Position := frmExport2.pbExport.Position + Round(posit);
  case frmExport2.qReport.RecordCount of
    0: // На заданные условия данных нет!
    begin
    end
    else
    begin
      // !!!имя файла определить как: период_TradePoint_id.xls
      NameF := FlashButton + ':\Мой файл.xls';
      NameL := 'Ведомость';
      Password := 'accident';
      // определить букву флешки: взять буквы без флешки, и буквы с флешкой
      // если файл на флешке существует, удаляем его
      if FileExists(NameF) then
        DeleteFile(NameF);

//      FileCreate('e:\Мой файл.xls');
//      FileSetAttr('e:\Мой файл.xls', faHidden);

      //создаем файл
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := NameL;

      //заполнить названия столбцов
      Sheet := XLApp.Workbooks[1].WorkSheets[NameL];
      Sheet.Cells[1, 1] := 'TABNUM';
      Sheet.Cells[1, 2] := 'FIO';
      Sheet.Cells[1, 3] := 'SUMMA';
      Sheet.Cells[1, 4] := 'PERIOD';

      // !!!для дубля создать файл DBF
      frmExport2.tExport.Close;
      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      frmExport2.tExport.DatabaseName := tIniSett.ReadString('Setting', 'Basa', '');
      frmExport2.tExport.TableName := tIniSett.ReadString('Setting', 'TableName', '');
      tIniSett.Destroy;

      frmExport2.tExport.EmptyTable;
      frmExport2.tExport.Open;
      sum := 0;
      posit2 := frmExport2.pbExport.Position;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        frmExport2.pbExport.Position := posit2 + Round(2*posit/frmExport2.qReport.RecordCount*(i+1));
        frmExport2.tExport.Insert;
        frmExport2.tExport.Edit;
        frmExport2.tExport.FieldByName('TabNum').AsString := frmExport2.qReport.FieldByName('Tn').AsString;
        frmExport2.tExport.FieldByName('Summa').AsString := frmExport2.qReport.FieldByName('Summa').AsString;
//        frmExport2.tExport.FieldByName('FIO').AsString := frmExport2.qReport.FieldByName('FIO').AsString;
//        frmExport2.tExport.FieldByName('Period').AsDateTime := EncodeDate(Year, Month, DayB);

        Sheet.Cells[i + 2, 1] := frmExport2.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + 2, 3] := frmExport2.qReport.FieldByName('summa').AsFloat;
        Sheet.Cells[i + 2, 2] := frmExport2.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + 2, 4] := EncodeDate(Year, Month, DayB);

        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
        frmExport2.tExport.Post;
        frmExport2.tExport.FlushBuffers;
      end;
      Sheet.Cells[i + 2, 4] := sum;

      frmExport2.tExport.Close;
      frmExport2.qReport.Close;
      end;
      //сохраняем под именем и с паролем
      XLApp.ActiveWorkbook.SaveAs(NameF, xlNormal, Password, EmptyParam, EmptyParam, EmptyParam,
                                  EmptyParam, EmptyParam, EmptyParam, EmptyParam);
      XLApp.ActiveWorkbook.close(EmptyParam, EmptyParam, EmptyParam);
      XLApp := UnAssigned;
      FileSetAttr(NameF, faHidden);
      Result := true;
   end;
end;

procedure TfrmExport2.dtDateBeginChange(Sender: TObject);
begin
  frmExport2.dtDay.Date := frmExport2.dtDateBegin.Date;
end;

procedure TfrmExport2.dtDayChange(Sender: TObject);
begin
  frmExport2.dtDateBegin.Date := frmExport2.dtDay.Date;
end;

procedure TfrmExport2.Button1Click(Sender: TObject);
begin
//ExcelApplication1.Workbooks.Add()
{ExcelWorkbook1.ConnectTo(
ExcelApplication1.Workbooks.Open('1111.xls',2,False,EmptyParam,'123456',
                                 EmptyParam,EmptyParam, EmptyParam,EmptyParam, EmptyParam,
                                 EmptyParam, EmptyParam, False, EmptyParam, EmptyParam, 0));

      Sheet := ExcelApplication1.Workbooks[1].WorkSheets['Лист1'];
      Sheet.Cells[7, 1] := '№ п.п';
      Sheet.Cells[8, 2] := 'Таб.номер';
      Sheet.Cells[9, 3] := '123';
      Sheet.Cells[10, 4] := '4578';
      ExcelWorkbook1.Password := '111';//устанавливаем пароль на файл
      ExcelApplication1.ActiveWorkbook.save(0);
//      ExcelApplication1.ActiveWorkbook.SaveAs(0);
//      ExcelApplication1.ActiveWorkbook.Close(0);

      ExcelApplication1.Disconnect;
      //Range := ExcelApplication1.Workbooks[1].Range['A2', 'D2'];
//ExcelApplication1.Visible[0] := true;   }
end;

procedure prcCreateFileExcel(NameF, NameL, Password : string);
var
  XLApp  : Variant;
begin
  try
  XLApp := CreateOleObject('Excel.Application');
  XLApp.Workbooks.Add(-4167);
  XLApp.Workbooks[1].WorkSheets[1].Name := NameL;
  XLApp.ActiveWorkbook.SaveAs(NameF, xlNormal, Password, EmptyParam, EmptyParam, EmptyParam,
                              EmptyParam, EmptyParam, EmptyParam, EmptyParam);
  XLApp.ActiveWorkbook.close(EmptyParam, EmptyParam, EmptyParam);
  XLApp := UnAssigned;
  except
    XLApp.ActiveWorkbook.close(false, NameF, EmptyParam);
    XLApp := UnAssigned;
  end;
end;

procedure TfrmExport2.Button2Click(Sender: TObject);
begin
  prcCreateFileExcel('f:\Мой файл.xls', 'Перечень', 'accident');
end;

function GetHardDiskSerial(const DriveLetter: Char): string;
var
  NotUsed:  DWORD;
  VolumeFlags: DWORD;
  VolumeInfo: array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
begin
  GetVolumeInformation(PChar(DriveLetter + ':\'), nil, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed, VolumeFlags, nil, 0);
//  Result := Format('Label = %s VolSer = %8.8X', [VolumeInfo, VolumeSerialNumber]);
  Result := IntToStr(VolumeSerialNumber);
end;


procedure TfrmExport2.Button4Click(Sender: TObject);
begin
  showmessage(GetHardDiskSerial('f'));
end;

procedure TfrmExport2.btnStep1Click(Sender: TObject);
begin
  prcGetDriv(ListDriv1);
  btnStep1.Visible := false;
  pnlStep1.Visible := false;
  btnStep3.Visible := true;
  pnlStep3.Visible := true;
  frmExport2.pbExport.Position := 10;
end;

procedure TfrmExport2.Button3Click(Sender: TObject);
begin
{
// ---------выгрузка таблицы sale во внешний файл-----------------
// -------------локальная точка для сервера-----------------------
// создать mysqlserver с правами root, выполнять выгрузку через него
// при помощи sql запроса

// перед выгрузкой удалить файл sale.bou, если он существует

select * from beznal.sale
where date(saletime) >= '2007-03-01' and date(saletime) <= '2007-03-31'
into outfile 'e:\sale.bou'

// с выборкой столбцов
select tradepoint_id, card_id, empl_id, summa, saletime, otdel from beznal.sale
where date(saletime) >= '2007-03-01' and date(saletime) <= '2007-03-31'
into outfile 'e:\sale.bou'

// после выгрузки поставит пароль на файл sale.bou

// -------------загрузка таблицы sale из файла в базу-------------
// ---------------на сервере от локальной точки-------------------

load data local infile 'e:\sale.bou' into table beznal.sale

// с выборкой столбцов
load data local infile 'e:\sale.bou' into table beznal.sale(tradepoint_id, card_id, summa, saletime, otdel)
}
end;

function fncReport() : boolean;
var
  XLApp     : Variant;
  Sheet     : Variant;
  Range     : Variant;
  Colum     : Variant;
  i, k      : Integer;
  DateStr, DateBStr, DateEStr : string;
  DateD, DateB, DateE : TDate;
  Year, Month, Day : Word;
  vedomost  : string;
  sum       : real;
  sPeriod   : String;
  StrSQL, GroupSQL  : string;
  Widht     : string;
  Otdel1, Otdel2 : integer;
begin
  case frmExport2.rbOtdel.Checked of
    true : // разбить ведомость на отделы
    begin
      Widht := 'E';
      GroupSQL := ' group by p.tabnum, s.otdel order by s.otdel, p.family ';
    end;
    false : // вывести общую ведомость
    begin
      Widht := 'D';
      GroupSQL := ' group by p.tabnum order by p.family ';
    end;
  end;
  case frmExport2.rbDay.Checked of
    true: // ведомость за 1 день
    begin
      DateD := frmExport2.dtDay.Date;
      DecodeDate(DateD, Year, Month, Day);
      DateStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
      StrSQL := ' SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO, ' +
                ' sum(s.summa) as summa, s.otdel FROM sale s, card c, pers p ' +
                ' where s.card_id = c.card_id and c.card_id = p.card_id and ' +
                ' date(s.saletime) = date(''' + DateStr + ''') ' + GroupSQL;
      sPeriod := Tradepoint + ' за ' + DateTostr(DateD);

      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      vedomost := tIniSett.ReadString('Setting', 'VedOfDay', '');
      tIniSett.Destroy;
    end;
    false: // ведомость за период
    begin
      DateB := frmExport2.dtDateBegin.Date;
      DateE := frmExport2.dtDateEnd.Date;
      DecodeDate(DateB, Year, Month, Day);
      DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
      DecodeDate(DateE, Year, Month, Day);
      DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

      StrSQL := ' SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO, ' +
                ' sum(s.summa) as summa, s.otdel FROM sale s, card c, pers p ' +
                ' where s.card_id = c.card_id and c.card_id = p.card_id and ' +
                ' date(s.saletime) >= date(''' + DateBStr + ''') and ' +
                ' date(s.saletime) <= date(''' + DateEStr + ''') ' + GroupSQL;
      sPeriod := Tradepoint + ' за период с ' + DateTostr(DateB) +' по ' + DateTostr(DateE);

      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      vedomost := tIniSett.ReadString('Setting', 'VedOfPeriod', '');
      tIniSett.Destroy;
    end;
  end;
  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add(StrSQL);
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
       result := false;
       exit;
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', Widht + '1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'ВЕДОМОСТЬ';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', Widht + '2'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'безналичной оплаты продуктов питания';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A3', Widht + '3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sPeriod;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', Widht + '4'];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.WrapText := true;
     // настройка параметров столбцов
      Colum := XLApp.Workbooks[1].WorkSheets['Список'].Columns;
      Colum.Columns[1].ColumnWidth := 5;
      Colum.Columns[1].HorizontalAlignment := xlCenter;
      Colum.Columns[2].ColumnWidth := 12;
      Colum.Columns[2].HorizontalAlignment := xlCenter;
      Colum.Columns[3].ColumnWidth := 40;
      Colum.Columns[4].ColumnWidth := 10;
      Colum.Columns[4].HorizontalAlignment := xlCenter;

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Таб.номер';
      Sheet.Cells[4, 3] := 'ФИО';
      Sheet.Cells[4, 4] := 'Сумма';

      case frmExport2.rbOtdel.Checked of
        true : // разбить ведомость на отделы
        begin
          Colum.Columns[5].ColumnWidth := 10;
          Colum.Columns[5].HorizontalAlignment := xlCenter;
          Sheet.Cells[4, 5] := 'Отдел';
        end;
      end;

      Otdel1 := frmExport2.qReport.FieldByName('Otdel').AsInteger;
      Otdel2 := frmExport2.qReport.FieldByName('Otdel').AsInteger;
      sum := 0;
      k := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        case frmExport2.rbOtdel.Checked of
          true : // разбить ведомость на отделы
            Otdel2 := frmExport2.qReport.FieldByName('Otdel').AsInteger;
        end;
        if Otdel1 <> Otdel2 then
        begin
          //  подвести итог, обнулить сумму
          Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + k + 5), 'C' + inttostr(i + k + 5)];
          Range.Font.Bold := true;
          Range.MergeCells := true;
          Range.VerticalAlignment := xlCenter;
          Range.HorizontalAlignment := xlCenter;
          Range.Value := 'ИТОГО отдел ' + IntToStr(Otdel1);

          Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['D' + inttostr(i + k + 5), 'D' + inttostr(i + k + 5)];
          Range.Font.Bold := true;
          Range.VerticalAlignment := xlCenter;
          Range.HorizontalAlignment := xlCenter;
          Range.Value := sum;
          Otdel1 := Otdel2;
          sum := 0;
          k := k + 1;
        end;

        Sheet.Cells[i + k + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + k + 5, 2] := frmExport2.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + k + 5, 3] := frmExport2.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + k + 5, 4] := frmExport2.qReport.FieldByName('summa').AsFloat;
        case frmExport2.rbOtdel.Checked of
          true : // разбить ведомость на отделы
            Sheet.Cells[i + k + 5, 5] := frmExport2.qReport.FieldByName('Otdel').AsFloat;
        end;
        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + k + 5), 'C' + inttostr(i + k + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';
      case frmExport2.rbOtdel.Checked of
        true : // разбить ведомость на отделы
          Range.Value := 'ИТОГО отдел ' + IntToStr(Otdel1);
      end;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['D' + inttostr(i + k + 5), 'D' + inttostr(i + k + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', Widht + IntToStr(5 + frmExport2.qReport.RecordCount + k)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.qReport.Close;

      if FileExists(vedomost + 'ведомость ' + sPeriod + '.xls') then
        DeleteFile(vedomost + 'ведомость ' + sPeriod + '.xls');

//      XLApp.ActiveWorkbook.SaveAs('.xls',xlNormal, '', '', False, False);
//      NameF :=  + 'Ведомость' + IntToStr(TradePoint_id) + '_' + NameFile;
//      XLApp.ActiveWorkbook.SaveAs(FlashButton + ':\ведомость ' + sPeriod + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
      end;
   end;
end;

procedure TfrmExport2.btnReportClick(Sender: TObject);
begin
  frmExport2.btnReport.Enabled := false;
  fncReport();
  frmExport2.btnReport.Enabled := true;
end;

function fncAddStopList() : boolean; // функция загрузки стоп-листа
var 
  SDate : string;
  wYear, wMonth, wDay : word;
  NameF : string;
begin
  NameF := FlashButton + ':/' + IntToStr(Tradepoint_id)+ '_stop.bou';
  if FileExists(NameF) then             // если существует файл стоп-листа
  begin                                 // загружаем стоп-лист в базу
    frmExport2.qExport.Close;           
    frmExport2.qExport.SQL.Clear;       // очищаем временную таблицу
    frmExport2.qExport.SQL.Add('delete from beznal.Stoplist');
    frmExport2.qExport.Execute(true);

    frmExport2.qExport.SQL.Clear;
    frmExport2.qExport.SQL.Add('load data local infile "' + NameF + '" into table beznal.stoplist');
    frmExport2.qExport.Execute(true);

    frmExport2.qExport.Close;           // обновляем таблицу card
    frmExport2.qExport.SQL.Clear;
    frmExport2.qExport.SQL.Add('update card set statecard_id=2 where nomer in (select nomer from stoplist) ');
    frmExport2.qExport.Execute(true);
  end;
end;

procedure TfrmExport2.btnStep3Click(Sender: TObject);
var
  i : integer;
begin

  frmExport2.pbExport.Position := 30;
  for i := 1 to 6 do
  begin // ждем когда флешка обнаружиться в системе
        // поставить прогресс бар
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
    frmExport2.pbExport.Position := 30 + 10 * i;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // обнаружили букву флешки
        FlashButton := ListDriv2[i];

        fncAddStopList(); // загрузить стоп-лист, если есть
        
        if fncExportSale() then
          pnlStep4.Visible := true
        else
          pnlStep5.Visible := true;

        btnStep3.Visible := false;
        pnlStep3.Visible := false;
        frmExport2.pbExport.Position := frmExport2.pbExport.Max;
        break;
      end;
    end;
  end
  else
  begin
    frmExport2.pbExport.Position := frmExport2.pbExport.Max;
    ShowMessage('Не обнаружена флешка, попробуйте начать заново!');
    pnlStep1.Visible := true;
    btnStep1.Visible := true;
    btnStep3.Visible := false;
    pnlStep3.Visible := false;
    frmExport2.pbExport.Position := frmExport2.pbExport.Min;
  end;
end;

procedure TfrmExport2.Button6Click(Sender: TObject);
var
  sLabel : string;
  des    : integer;
begin
  sLabel := DateTimeToStr(now);
  sLabel := StringReplace(sLabel, '.', '', [rfReplaceAll]);
  sLabel := StringReplace(sLabel, ':', '', [rfReplaceAll]);
  des := FileCreate('d:\'+ sLabel + '.bou');
  FileSetAttr('d:\'+ sLabel + '.bou', faHidden);
  FileClose(des);
end;

end.
