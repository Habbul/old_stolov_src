unit untExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, MySQLDataset, MySQLServer, OleServer,
  OleCtnrs, comobj, ExcelXp, DBTables, IniFiles, Spin, ExtCtrls, math;

type
  TfrmExport = class(TForm)
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
    btnExit: TBitBtn;
    qReport: TMySQLQuery;
    tExport: TTable;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Button4: TButton;
    Panel1: TPanel;
    btnStep1: TBitBtn;
    btnStep3: TButton;
    pnlStep1: TPanel;
    lStep1: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Image3: TImage;
    pnlStep2: TPanel;
    Image1: TImage;
    lStep2: TLabel;
    cbMonth: TComboBox;
    seYear: TSpinEdit;
    pnlStep5: TPanel;
    Image4: TImage;
    Label3: TLabel;
    pnlStep3: TPanel;
    Image5: TImage;
    lStep3: TLabel;
    btnStep2: TButton;
    pnlStep4: TPanel;
    Image2: TImage;
    Label5: TLabel;
    pbExport: TProgressBar;
    Button3: TButton;
    btnReport: TButton;
    GroupBox2: TGroupBox;
    rbOtdel: TRadioButton;
    rbAll: TRadioButton;
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
    procedure btnStep2Click(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExport: TfrmExport;
  ListDriv1, ListDriv2 : String;
  FlashButton : string; //буква флешки
procedure prcCreateFileExcel(NameF, NameL, Password : string);
function GetHardDiskSerial(const DriveLetter: Char): string;
function fncExportDB() : boolean;
procedure prcGetDriv(var List : String);

implementation

uses untGlobalVar, untSpravochnik, DateUtils;

{$R *.dfm}

procedure TfrmExport.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmExport.rbDayClick(Sender: TObject);
begin
  case rbDay.Checked of
  true:
    begin
      gbDay.Visible := true;
      gbPeriod.Visible := false;
    end;
  end;
end;

procedure TfrmExport.rbPeriodClick(Sender: TObject);
begin
  case rbPeriod.Checked of
  true:
    begin
      gbDay.Visible := false;
      gbPeriod.Visible := true;
    end;
  end;
end;

procedure TfrmExport.FormShow(Sender: TObject);
var
  wYear, wMonth, wDay : word;
begin
  dtDay.Date := Now;
  dtDateBegin.Date := Now;
  dtDateEnd.Date := Now;
  DecodeDate(now, wYear, wMonth, wDay);
  frmExport.cbMonth.ItemIndex := wMonth - 2;
  frmExport.seYear.Value := wYear;

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
//      frmExport2.ListBox1.Items.Add(chr(i + 65));
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
  posit := (frmExport.pbExport.Max - frmExport.pbExport.Position)/5 ;
  frmExport.pbExport.Position := frmExport.pbExport.Position + Round(posit);
  Result := false;
  Year := frmExport.seYear.Value;
  Month := frmExport.cbMonth.ItemIndex + 1;
  DayB := 1;
  DayE := DaysInAMonth(Year, Month); // кол-во дней в месяце, для определения последнего дня

  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayB);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayE);

  frmExport.qReport.Close;
  frmExport.qReport.SQL.Clear;
  frmExport.qReport.SQL.Add('SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO,');
  frmExport.qReport.SQL.Add('sum(s.summa) as summa FROM sale s, card c, pers p');
  frmExport.qReport.SQL.Add('where s.card_id = c.card_id and c.card_id = p.card_id and ');
  frmExport.qReport.SQL.Add('date(s.saletime) >= date(''' + DateBStr + ''') and date(s.saletime) <= date(''' + DateEStr + ''')');
  frmExport.qReport.SQL.Add('group by p.tabnum');
  frmExport.qReport.SQL.Add('order by p.family');
  frmExport.qReport.Open;

  frmExport.pbExport.Position := frmExport.pbExport.Position + Round(posit);
  case frmExport.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
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
      frmExport.tExport.Close;
      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      frmExport.tExport.DatabaseName := tIniSett.ReadString('Setting', 'Basa', '');
      frmExport.tExport.TableName := tIniSett.ReadString('Setting', 'TableName', '');
      tIniSett.Destroy;

      frmExport.tExport.EmptyTable;
      frmExport.tExport.Open;
      sum := 0;
      posit2 := frmExport.pbExport.Position;
      for i := 0 to frmExport.qReport.RecordCount - 1 do
      begin
        frmExport.pbExport.Position := posit2 + Round(2*posit/frmExport.qReport.RecordCount*(i+1));
        frmExport.tExport.Insert;
        frmExport.tExport.Edit;
        frmExport.tExport.FieldByName('TabNum').AsString := frmExport.qReport.FieldByName('Tn').AsString;
        frmExport.tExport.FieldByName('Summa').AsString := frmExport.qReport.FieldByName('Summa').AsString;
//        frmExport2.tExport.FieldByName('FIO').AsString := frmExport2.qReport.FieldByName('FIO').AsString;
//        frmExport2.tExport.FieldByName('Period').AsDateTime := EncodeDate(Year, Month, DayB);

        Sheet.Cells[i + 2, 1] := frmExport.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + 2, 3] := frmExport.qReport.FieldByName('summa').AsFloat;
        Sheet.Cells[i + 2, 2] := frmExport.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + 2, 4] := EncodeDate(Year, Month, DayB);

        sum := sum + frmExport.qReport.FieldByName('summa').AsFloat;
        frmExport.qReport.Next;
        frmExport.tExport.Post;
        frmExport.tExport.FlushBuffers;
      end;
      Sheet.Cells[i + 2, 4] := sum;

      frmExport.tExport.Close;
      frmExport.qReport.Close;
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

procedure TfrmExport.dtDateBeginChange(Sender: TObject);
begin
  frmExport.dtDay.Date := frmExport.dtDateBegin.Date;
end;

procedure TfrmExport.dtDayChange(Sender: TObject);
begin
  frmExport.dtDateBegin.Date := frmExport.dtDay.Date;
end;

procedure TfrmExport.Button1Click(Sender: TObject);
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

procedure TfrmExport.Button2Click(Sender: TObject);
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


procedure TfrmExport.Button4Click(Sender: TObject);
begin
  showmessage(GetHardDiskSerial('f'));
end;

procedure TfrmExport.btnStep1Click(Sender: TObject);
begin
  prcGetDriv(ListDriv1);
  btnStep1.Visible := false;
  pnlStep1.Visible := false;
  btnStep2.Visible := true;
  pnlStep2.Visible := true;
  frmExport.pbExport.Position := 10;
end;

procedure TfrmExport.btnStep2Click(Sender: TObject);
begin
  btnStep2.Visible := false;
  pnlStep2.Visible := false;
  btnStep3.Visible := true;
  pnlStep3.Visible := true;
  frmExport.pbExport.Position := 20;
end;

procedure TfrmExport.btnStep3Click(Sender: TObject);
var
  i : integer;
begin
  frmExport.pbExport.Position := 30;
  for i := 1 to 6 do
  begin // ждем когда флешка обнаружиться в системе
        // поставить прогресс бар
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
    frmExport.pbExport.Position := 30 + 10 * i;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // обнаружили букву флешки
        FlashButton := ListDriv2[i];
        if fncExportDB() then
          pnlStep4.Visible := true
        else
          pnlStep5.Visible := true;

        btnStep3.Visible := false;
        pnlStep3.Visible := false;
        frmExport.pbExport.Position := frmExport.pbExport.Max;
        break;
      end;
    end;
  end
  else
  begin
    frmExport.pbExport.Position := frmExport.pbExport.Max;
    ShowMessage('Не обнаружена флешка, попробуйте начать заново!');
    pnlStep1.Visible := true;
    btnStep1.Visible := true;
    btnStep3.Visible := false;
    pnlStep3.Visible := false;
    frmExport.pbExport.Position := frmExport.pbExport.Min;
  end;
end;

procedure TfrmExport.Button3Click(Sender: TObject);
begin
{
// ---------выгрузка таблицы sale во внешний файл-----------------
// -------------локальная точка для сервера-----------------------
// создать mysqlserver с правами root, выполнять выгрузку через него
// при помощи sql запроса

// перед выгрузкой удалить файл sale.xls, если он существует

select * from beznal.sale
where date(saletime) >= '2007-03-01' and date(saletime) <= '2007-03-31'
into outfile 'e:\sale.xls'

// с выборкой столбцов
select tradepoint_id, card_id, summa, saletime, otdel from beznal.sale
where date(saletime) >= '2007-03-01' and date(saletime) <= '2007-03-31'
into outfile 'e:\sale.xls'

// после выгрузки поставит пароль на файл sale.xls

// -------------загрузка таблицы sale из файла в базу-------------
// ---------------на сервере от локальной точки-------------------

load data local infile 'e:\sale.xls' into table beznal.sale

// с выборкой столбцов
load data local infile 'e:\sale.xls' into table beznal.sale(tradepoint_id, card_id, summa, saletime, otdel)
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
  case frmExport.rbOtdel.Checked of
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
  case frmExport.rbDay.Checked of
    true: // ведомость за 1 день
    begin
      DateD := frmExport.dtDay.Date;
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
      DateB := frmExport.dtDateBegin.Date;
      DateE := frmExport.dtDateEnd.Date;
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
  frmExport.qReport.Close;
  frmExport.qReport.SQL.Clear;
  frmExport.qReport.SQL.Add(StrSQL);
  frmExport.qReport.Open;

  case frmExport.qReport.RecordCount of
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

      case frmExport.rbOtdel.Checked of
        true : // разбить ведомость на отделы
        begin
          Colum.Columns[5].ColumnWidth := 10;
          Colum.Columns[5].HorizontalAlignment := xlCenter;
          Sheet.Cells[4, 5] := 'Отдел';
        end;
      end;

      Otdel1 := frmExport.qReport.FieldByName('Otdel').AsInteger;
      Otdel2 := frmExport.qReport.FieldByName('Otdel').AsInteger;
      sum := 0;
      k := 0;
      for i := 0 to frmExport.qReport.RecordCount - 1 do
      begin
        case frmExport.rbOtdel.Checked of
          true : // разбить ведомость на отделы
            Otdel2 := frmExport.qReport.FieldByName('Otdel').AsInteger;
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
        Sheet.Cells[i + k + 5, 2] := frmExport.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + k + 5, 3] := frmExport.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + k + 5, 4] := frmExport.qReport.FieldByName('summa').AsFloat;
        case frmExport.rbOtdel.Checked of
          true : // разбить ведомость на отделы
            Sheet.Cells[i + k + 5, 5] := frmExport.qReport.FieldByName('Otdel').AsFloat;
        end;
        sum := sum + frmExport.qReport.FieldByName('summa').AsFloat;
        frmExport.qReport.Next;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + k + 5), 'C' + inttostr(i + k + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';
      case frmExport.rbOtdel.Checked of
        true : // разбить ведомость на отделы
          Range.Value := 'ИТОГО отдел ' + IntToStr(Otdel1);
      end;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['D' + inttostr(i + k + 5), 'D' + inttostr(i + k + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', Widht + IntToStr(5 + frmExport.qReport.RecordCount + k)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport.qReport.Close;

      if FileExists(vedomost + 'ведомость ' + sPeriod + '.xls') then
        DeleteFile(vedomost + 'ведомость ' + sPeriod + '.xls');

      XLApp.ActiveWorkbook.SaveAs(vedomost + 'ведомость ' + sPeriod + '.xls',xlNormal, '', '', False, False);
//      NameF :=  + 'Ведомость' + IntToStr(TradePoint_id) + '_' + NameFile;
//      XLApp.ActiveWorkbook.SaveAs(FlashButton + ':\ведомость ' + sPeriod + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
      end;
   end;
end;

procedure TfrmExport.btnReportClick(Sender: TObject);
begin
  frmExport.btnReport.Enabled := false;
  fncReport();
  frmExport.btnReport.Enabled := true;
end;

end.
