unit untReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, MySQLDataset, MySQLServer, OleServer,
  OleCtnrs, comobj, ExcelXp, DBTables, IniFiles, Spin, ExtCtrls, math;

type
  TfrmExport = class(TForm)
    btnExit: TBitBtn;
    qReport: TMySQLQuery;
    btnReport: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    rbDay: TRadioButton;
    rbPeriod: TRadioButton;
    gbPeriod: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtDateBegin: TDateTimePicker;
    dtDateEnd: TDateTimePicker;
    gbDay: TGroupBox;
    dtDay: TDateTimePicker;
    rbOtdel: TRadioButton;
    rbAll: TRadioButton;
    rbPunctAll: TRadioButton;
    rbPunctSel: TRadioButton;
    cbPunct: TComboBox;
    TabSheet4: TTabSheet;
    rbPersAll: TRadioButton;
    rbPersSel: TRadioButton;
    Edit1: TEdit;
    procedure btnExitClick(Sender: TObject);
    procedure rbDayClick(Sender: TObject);
    procedure rbPeriodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtDateBeginChange(Sender: TObject);
    procedure dtDayChange(Sender: TObject);
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


procedure TfrmExport.dtDateBeginChange(Sender: TObject);
begin
  frmExport.dtDay.Date := frmExport.dtDateBegin.Date;
end;

procedure TfrmExport.dtDayChange(Sender: TObject);
begin
  frmExport.dtDateBegin.Date := frmExport.dtDay.Date;
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
  result := true;
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
