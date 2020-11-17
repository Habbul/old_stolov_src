unit untExport2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB, MySQLDataset, MySQLServer, OleServer,
  OleCtnrs, comobj, ExcelXp, DBTables, IniFiles, Spin, ExtCtrls, math,
  Grids, DBGridEh, DBGridEhGrouping, GridsEh;

type
  TfrmExport2 = class(TForm)
    qReport: TMySQLQuery;
    tExport: TTable;
    MySQLServerRoot: TMySQLServer;
    qRoot: TMySQLQuery;
    ExcelApplication1: TExcelApplication;
    ExcelWorkbook1: TExcelWorkbook;
    Panel2: TPanel;
    btnExit: TBitBtn;
    Button3: TButton;
    Button1: TButton;
    btnExportDB: TBitBtn;
    Button4: TButton;
    Button2: TButton;
    Button5: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cbMonth: TComboBox;
    seYear: TSpinEdit;
    btnVed1C: TBitBtn;
    btnStep3: TButton;
    rbDay: TRadioButton;
    rbPeriod: TRadioButton;
    gbPeriod: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    dtDateBegin: TDateTimePicker;
    dtDateEnd: TDateTimePicker;
    GroupBox2: TGroupBox;
    rbOtdel: TRadioButton;
    rbAll: TRadioButton;
    gbDay: TGroupBox;
    dtDay: TDateTimePicker;
    Label1: TLabel;
    btnVedFromPoint: TBitBtn;
    cbPunct: TComboBox;
    Label2: TLabel;
    TabSheet3: TTabSheet;
    dbDatas: TGroupBox;
    btnVedOfPers: TBitBtn;
    GroupBox3: TGroupBox;
    btnSelectEmpl: TButton;
    edTabNum: TEdit;
    edFIO: TEdit;
    edName: TEdit;
    edParentName: TEdit;
    btnSearch: TButton;
    edPers_id: TEdit;
    Label8: TLabel;
    rbTabNo: TRadioButton;
    rbFIO: TRadioButton;
    qSelectPers: TMySQLQuery;
    DataSource1: TDataSource;
    Label5: TLabel;
    edCard_Id: TEdit;
    qTradePoint: TMySQLQuery;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    Panel3: TPanel;
    Label3: TLabel;
    dtDateBPers: TDateTimePicker;
    Label4: TLabel;
    dtDateEPers: TDateTimePicker;
    TabSheet4: TTabSheet;
    DBGridEh1: TDBGridEh;
    dsCreditForPers: TDataSource;
    qCreditForPers: TMySQLQuery;
    Edit1: TEdit;
    Label9: TLabel;
    Query1: TQuery;
    Button6: TButton;
    GroupBox1: TGroupBox;
    rbGroupTradePoint: TRadioButton;
    rbGroupDay: TRadioButton;
    procedure btnExitClick(Sender: TObject);
    procedure rbDayClick(Sender: TObject);
    procedure rbPeriodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExportDBClick(Sender: TObject);
    procedure dtDateBeginChange(Sender: TObject);
    procedure dtDayChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnVed1CClick(Sender: TObject);
    procedure btnVedFromPointClick(Sender: TObject);
    procedure btnSelectEmplClick(Sender: TObject);
    procedure rbTabNoClick(Sender: TObject);
    procedure rbFIOClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edTabNumChange(Sender: TObject);
    procedure btnVedOfPersClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExport2: TfrmExport2;
  SelectReport : boolean;
function fncReportOfDay() : boolean;
function fncReportPeriod() : boolean;
procedure prcCreateFileExcel(NameF, NameL, Password : string);
function GetHardDiskSerial(const DriveLetter: Char): string;
function fncExportDB() : boolean;
function fncExportDBSQL(Pass, SQL, DateBStr, DateEStr, NameFile : string) : boolean;
function fncReport() : boolean;
function fncReportPersOfDay(FIO : string) : boolean;


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
  fncExecSQLFillCB('TradePoint', 'NameTP', frmExport2.cbPunct);
  frmExport2.cbPunct.ItemIndex := 0;
  dtDay.Date := Now;
  dtDateBegin.Date := Now;
  dtDateEnd.Date := Now;
  dtDateBPers.Date := Now;
  dtDateEPers.Date := Now;
  DecodeDate(now, wYear, wMonth, wDay);
  frmExport2.cbMonth.ItemIndex := wMonth - 2;
  frmExport2.seYear.Value := wYear;
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
  sPunct                      : string;
begin
  case frmExport2.cbPunct.ItemIndex of
  0 : // продажи на всех точках
  begin
    sPunct := '';
    Tradepoint:= '';
  end;
  else // выбрана точка продаж
    begin
      sPunct := ' and tradepoint_id = ' + inttostr(frmExport2.cbPunct.ItemIndex);
      Tradepoint := frmExport2.cbPunct.Items.Strings[frmExport2.cbPunct.ItemIndex];
    end;
  end;

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
                ' where s.card_id = c.card_id and c.card_id = p.card_id ' + sPunct +
                ' and date(s.saletime) = date(''' + DateStr + ''') ' + GroupSQL;
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
                ' where s.card_id = c.card_id and c.card_id = p.card_id ' + sPunct +
                ' and date(s.saletime) >= date(''' + DateBStr + ''') and ' +
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

      XLApp.ActiveWorkbook.SaveAs(vedomost + 'ведомость ' + sPeriod + '.xls',xlNormal, '', '', False, False);
//      NameF :=  + 'Ведомость' + IntToStr(TradePoint_id) + '_' + NameFile;
//      XLApp.ActiveWorkbook.SaveAs(FlashButton + ':\ведомость ' + sPeriod + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
      end;
   end;
end;

function fncReportPeriod() : boolean;
var
  XLApp  : Variant;
  Sheet  : Variant;
  Range  : Variant;
  Colum  : Variant;
  i      : Integer;
  DateBStr, DateEStr : string;
  DateB, DateE : TDate;
  Year, Month, Day : Word;
  vedomost : string;
  sum : real;
begin
  DateB := frmExport2.dtDateBegin.Date;
  DateE := frmExport2.dtDateEnd.Date;

  DecodeDate(DateB, Year, Month, Day);
  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  DecodeDate(DateE, Year, Month, Day);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO,');
  frmExport2.qReport.SQL.Add('sum(s.summa) as summa FROM sale s, card c, pers p');
  frmExport2.qReport.SQL.Add('where s.card_id = c.card_id and c.card_id = p.card_id and ');
  frmExport2.qReport.SQL.Add('date(s.saletime) >= date(''' + DateBStr + ''') and date(s.saletime) <= date(''' + DateEStr + ''')');
  frmExport2.qReport.SQL.Add('group by p.tabnum');
  frmExport2.qReport.SQL.Add('order by p.family');
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', 'D1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'ВЕДОМОСТЬ';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', 'D2'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'безналичной оплаты продуктов питания ' + Tradepoint;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A3', 'D3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := Tradepoint + ' за период с ' + DateTostr(DateB) +' по ' + DateTostr(DateE);

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D4'];
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
      Colum.Columns[4].ColumnWidth := 20;
      Colum.Columns[4].HorizontalAlignment := xlCenter;

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Таб.номер';
      Sheet.Cells[4, 3] := 'ФИО';
      Sheet.Cells[4, 4] := 'Сумма';

      frmExport2.tExport.Close;
      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      frmExport2.tExport.DatabaseName := tIniSett.ReadString('Setting', 'Basa', '');
      frmExport2.tExport.TableName := tIniSett.ReadString('Setting', 'TableName', '');
      vedomost := tIniSett.ReadString('Setting', 'VedOfPeriod', '');
      tIniSett.Destroy;

      frmExport2.tExport.EmptyTable;
      frmExport2.tExport.Open;
      sum := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        frmExport2.tExport.Insert;
        frmExport2.tExport.Edit;
        frmExport2.tExport.FieldByName('TabNum').AsString := frmExport2.qReport.FieldByName('Tn').AsString;
        frmExport2.tExport.FieldByName('Summa').AsString := frmExport2.qReport.FieldByName('Summa').AsString;
        Sheet.Cells[i + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + 5, 2] := frmExport2.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + 5, 3] := frmExport2.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + 5, 4] := frmExport2.qReport.FieldByName('summa').AsFloat;
        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
        frmExport2.tExport.Post;
        frmExport2.tExport.FlushBuffers;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + 5), 'C' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['D' + inttostr(i + 5), 'D' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D' + IntToStr(5 + frmExport2.qReport.RecordCount)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.tExport.Close;
      frmExport2.qReport.Close;

      XLApp.ActiveWorkbook.SaveAs(vedomost + tradepoint + 'ведомость с ' + DateBStr + ' по ' + DateEStr + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
      end;
   end;
end;

function fncExportDB() : boolean;
var
  XLApp, Sheet : Variant;
  Range        : Variant;
  Colum        : Variant;
  i            : Integer;
  DateBStr, DateEStr : string;
  Year, Month, DayB, DayE : Word;
  sum          : real;
  NameL        : string;
  posit        : real;
  posit2       : integer;
begin
  Result := false;
  Year := frmExport2.seYear.Value;
  Month := frmExport2.cbMonth.ItemIndex + 1;
  DayB := 1;
  DayE := DaysInAMonth(Year, Month); // кол-во дней в месяце, для определения последнего дня

  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayB);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayE);

  // выгружаем ведомость
  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT s.tradepoint_id as trp, p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO,');
  frmExport2.qReport.SQL.Add('sum(s.summa) as summa, c.nomer as BSK FROM sale s, card c, pers p');
  frmExport2.qReport.SQL.Add('where s.card_id = c.card_id and c.card_id = p.card_id and ');
  frmExport2.qReport.SQL.Add('date(s.saletime) >= date(''' + DateBStr + ''') and date(s.saletime) <= date(''' + DateEStr + ''')');
  frmExport2.qReport.SQL.Add('group by s.tradepoint_id, p.tabnum');
  frmExport2.qReport.SQL.Add('order by p.family');
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      NameL := 'Ведомость';

      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := NameL;

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A1', 'E1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'ВЕДОМОСТЬ';

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A2', 'E2'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'безналичной оплаты продуктов питания ' + Tradepoint;

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A3', 'E3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := Tradepoint + ' за ' + frmExport2.cbMonth.Items.Strings[frmExport2.cbMonth.ItemIndex] + ' ' + IntToStr(frmExport2.seYear.Value)+ ' года';

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A4', 'E4'];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.WrapText := true;
     // настройка параметров столбцов
      Colum := XLApp.Workbooks[1].WorkSheets[NameL].Columns;
      Colum.Columns[1].ColumnWidth := 5;
      Colum.Columns[1].HorizontalAlignment := xlCenter;
      Colum.Columns[2].ColumnWidth := 12;
      Colum.Columns[2].HorizontalAlignment := xlCenter;
      Colum.Columns[3].ColumnWidth := 40;
      Colum.Columns[4].ColumnWidth := 10;
      Colum.Columns[4].HorizontalAlignment := xlCenter;
      Colum.Columns[5].ColumnWidth := 10;
      Colum.Columns[5].HorizontalAlignment := xlCenter;

      //заполнить названия столбцов
      Sheet := XLApp.Workbooks[1].WorkSheets[NameL];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Таб.номер';
      Sheet.Cells[4, 3] := 'ФИО';
      Sheet.Cells[4, 4] := 'Сумма';
      Sheet.Cells[4, 5] := 'Точка продажи';

      // создаем файл дбф для 1С
      frmExport2.tExport.Close;
      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      frmExport2.tExport.DatabaseName := tIniSett.ReadString('Setting', 'Basa', '');
      frmExport2.tExport.TableName := tIniSett.ReadString('Setting', 'TableName', '');
      tIniSett.Destroy;

      frmExport2.tExport.EmptyTable;
      frmExport2.tExport.Open;
      sum := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        frmExport2.tExport.Insert;
        frmExport2.tExport.Edit;
        frmExport2.tExport.FieldByName('TabNum').AsString := frmExport2.qReport.FieldByName('Tn').AsString;
        frmExport2.tExport.FieldByName('Summa').AsString := frmExport2.qReport.FieldByName('Summa').AsString;
        frmExport2.tExport.FieldByName('Point').AsString := frmExport2.qReport.FieldByName('trp').AsString;
        frmExport2.tExport.FieldByName('FIO').AsString := frmExport2.qReport.FieldByName('FIO').AsString;
        frmExport2.tExport.FieldByName('BSK').AsString := frmExport2.qReport.FieldByName('BSK').AsString;

        Sheet.Cells[i + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + 5, 2] := frmExport2.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + 5, 3] := frmExport2.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + 5, 4] := frmExport2.qReport.FieldByName('Summa').AsFloat;
        Sheet.Cells[i + 5, 5] := frmExport2.qReport.FieldByName('trp').AsString;

        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
        frmExport2.tExport.Post;
        frmExport2.tExport.FlushBuffers;
      end;
//      Sheet.Cells[i + 5, 3] := sum;

      frmExport2.tExport.Close;
      end;
      XLApp.visible := true;// := UnAssigned;
      Result := true;

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A' + inttostr(i + 5), 'C' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['D' + inttostr(i + 5), 'D' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets[NameL].Range['A4', 'E' + IntToStr(5 + frmExport2.qReport.RecordCount)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.tExport.Close;
      frmExport2.qReport.Close;

      XLApp.ActiveWorkbook.SaveAs('d:\ведомость за ' + frmExport2.cbMonth.Items.Strings[frmExport2.cbMonth.ItemIndex] + ' ' + IntToStr(frmExport2.seYear.Value)+ ' года' + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
   end;
end;

function fncExportDBSQL(Pass, SQL, DateBStr, DateEStr, NameFile : string) : boolean;
var
  XLApp     : Variant;
  NameFSQL,
  NameF, NameF2 : string;
  posit : real;
begin
try

  try //инициализация БД в админовской учетной записи
    tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
    frmExport2.MySQLServerRoot.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
    frmExport2.MySQLServerRoot.Host := tIniSett.ReadString('MySQL', 'Host', '');
    frmExport2.MySQLServerRoot.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
    tIniSett.Destroy;
    frmExport2.MySQLServerRoot.Connect;
  except
    ShowMessage('Ошибка при инициализации базы!');
    frmExport2.MySQLServerRoot.Disconnect;
    result := false;
    exit;
  end;

  // полное имя файла для SQL запроса с двойным \\
  NameFSQL := FlashButton + ':\\' + IntToStr(TradePoint_id) + '_' + NameFile;
  // имя видимого файла после SQL запроса: буква флешки:\период_TradePoint_id.xls
  NameF := FlashButton + ':\' + IntToStr(TradePoint_id) + '_' + NameFile;
  // имя скрытого, запароленного файла: буква флешки:\период_TradePoint_id.xls
  NameF2 := FlashButton + ':\' + DateBStr + '_' + DateEStr + '_' + IntToStr(TradePoint_id) + '_' +  NameFile;

  if FileExists(NameF) then  // если видимый файл на флешке существует, удаляем его
    DeleteFile(NameF);
  if FileExists(NameF2) then  // если скрытый файл на флешке существует, удаляем его
    DeleteFile(NameF2);


  SQL := SQL + 'into outfile ''' + NameFSQL + '''';  // дополняем SQL запрос

  frmExport2.qRoot.Close;                            // выгружаем
  frmExport2.qRoot.SQL.Clear;
  frmExport2.qRoot.SQL.Add(SQL);
  frmExport2.qRoot.Execute;

{  XLApp := CreateOleObject('Excel.Application');
  // открываем полученный файл
  XLApp.Workbooks.Open(NameF, 2, False, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,EmptyParam, EmptyParam);//,

  // сохраняем файл под паролем
  XLApp.ActiveWorkbook.SaveAs(NameF2, xlNormal, Pass, EmptyParam, EmptyParam, EmptyParam,
                                  EmptyParam, EmptyParam, EmptyParam, EmptyParam);
  XLApp.ActiveWorkbook.close(EmptyParam, EmptyParam, EmptyParam);
  XLApp := UnAssigned;  }
  FileSetAttr(NameF2, faHidden); //устанавливаем атрибут у запаролленого файла как системный(скрытый)
  Result := true;
except
  result := false;
end;
end;

function fncReportOfDay() : boolean;
var
  XLApp  : Variant;
  Sheet  : Variant;
  Range  : Variant;
  Colum  : Variant;
  i      : Integer;
  DateStr : string;
  DateD : TDate;
  Year, Month, Day : Word;
  vedomost : string;
  sum : real;
begin
  result := true;
  DateD := frmExport2.dtDay.Date;
  DecodeDate(DateD, Year, Month, Day);
  DateStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT p.TabNum as Tn, concat(p.Family,' + ''' ''' + ' , p.Name, ' + ''' ''' + ', p.ParentName) as FIO,');
  frmExport2.qReport.SQL.Add('sum(s.summa) as summa, s.otdel FROM sale s, card c, pers p');
  frmExport2.qReport.SQL.Add('where s.card_id = c.card_id and c.card_id = p.card_id and date(s.saletime) = date(''' + DateStr + ''')');
  frmExport2.qReport.SQL.Add('group by tn, s.otdel');
  frmExport2.qReport.SQL.Add('order by p.family');
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', 'D1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'ВЕДОМОСТЬ';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', 'D2'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'безналичной оплаты продуктов питания';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A3', 'D3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := Tradepoint + ' за ' + DateTostr(DateD);

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D4'];
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
      Colum.Columns[4].ColumnWidth := 20;
      Colum.Columns[4].HorizontalAlignment := xlCenter;

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Таб.номер';
      Sheet.Cells[4, 3] := 'ФИО';
      Sheet.Cells[4, 4] := 'Сумма';

      frmExport2.tExport.Close;

      tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
      frmExport2.tExport.DatabaseName := tIniSett.ReadString('Setting', 'Basa', '');
      frmExport2.tExport.TableName := tIniSett.ReadString('Setting', 'TableName', '');
      vedomost := tIniSett.ReadString('Setting', 'VedOfDay', '');
      tIniSett.Destroy;

      frmExport2.tExport.EmptyTable;
      frmExport2.tExport.Open;
      sum := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        frmExport2.tExport.Insert;
        frmExport2.tExport.Edit;
        frmExport2.tExport.FieldByName('TabNum').AsString := frmExport2.qReport.FieldByName('Tn').AsString;
        frmExport2.tExport.FieldByName('Summa').AsString := frmExport2.qReport.FieldByName('Summa').AsString;
        Sheet.Cells[i + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + 5, 2] := frmExport2.qReport.FieldByName('Tn').AsString;
        Sheet.Cells[i + 5, 3] := frmExport2.qReport.FieldByName('FIO').AsString;
        Sheet.Cells[i + 5, 4] := frmExport2.qReport.FieldByName('summa').AsFloat;
        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
        frmExport2.tExport.Post;
        frmExport2.tExport.FlushBuffers;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + 5), 'C' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['D' + inttostr(i + 5), 'D' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D' + IntToStr(5 + frmExport2.qReport.RecordCount)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.tExport.Close;
      frmExport2.qReport.Close;

      XLApp.ActiveWorkbook.SaveAs(vedomost + TradePoint + 'ведомость за ' + DateStr + '.xls',xlNormal, '', '', False, False);
      XLApp.Visible := true;
      end;
   end;
end;

function fncReportOfPers(FIO : string) : boolean;
var
  XLApp  : Variant;
  Sheet  : Variant;
  Range  : Variant;
  Colum  : Variant;
  i      : Integer;
  DateStr : string;
  DateB, DateE : TDate;
  DateBStr, DateEStr : string;
  Year, Month, Day : Word;
  vedomost : string;
  sum : real;
begin
  result := true;
  DateB := frmExport2.dtDateBPers.Date;
  DateE := frmExport2.dtDateEPers.Date;

  DecodeDate(DateB, Year, Month, Day);
  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  DecodeDate(DateE, Year, Month, Day);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  frmExport2.qTradePoint.Close;
  frmExport2.qTradePoint.SQL.Clear;
  frmExport2.qTradePoint.SQL.Add('SELECT t.tradepoint_id as trid, t.nametp as ntp, max(Saletime) as maxst FROM sale s, tradepoint t');
  frmExport2.qTradePoint.SQL.Add('where s.tradepoint_id=t.tradepoint_id');
  frmExport2.qTradePoint.SQL.Add('group by t.tradepoint_id');
  frmExport2.qTradePoint.SQL.Add('order by t.tradepoint_id');
  frmExport2.qTradePoint.Open;

//SELECT concat(p.family, ' ', p.name, ' ', p.parentname), p.tabnum, s.summa, s.saletime, t.NameTP FROM sale s
//left join tradepoint t on t.tradepoint_id=s.tradepoint_id
//l/eft join pers p on p.card_id=s.card_id
//where s.card_id=88 and s.saletime> '2007-04-30' and s.saletime<'2007-06-01'

  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT t.nametp as ntp, t.tradepoint_id as trid');
  frmExport2.qReport.SQL.Add(', sum(s.summa) as summa');
//  frmExport2.qReport.SQL.Add(', s.summa as summa');
  frmExport2.qReport.SQL.Add('FROM sale s, tradepoint t');
  frmExport2.qReport.SQL.Add('where s.card_id=' + frmExport2.edCard_Id.Text + ' and s.tradepoint_id=t.tradepoint_id');
  frmExport2.qReport.SQL.Add('and date(s.saletime) >= date("' + DateBStr + '")');
  frmExport2.qReport.SQL.Add('and date(s.saletime) <= date("' + DateEStr + '")');
  frmExport2.qReport.SQL.Add('group by t.tradepoint_id');
  frmExport2.qReport.SQL.Add('order by t.tradepoint_id');
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', 'D1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'Безналичная оплата продуктов питания';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', 'D2'];
//      Range.Font.Bold := true;
      Range.Font.Size := 10;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := FIO;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A3', 'D3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'за период с ' + DateTostr(DateB) + ' по ' + DateTostr(DateE);

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D4'];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.WrapText := true;
     // настройка параметров столбцов
      Colum := XLApp.Workbooks[1].WorkSheets['Список'].Columns;
      Colum.Columns[1].ColumnWidth := 5;
      Colum.Columns[1].HorizontalAlignment := xlCenter;
      Colum.Columns[2].ColumnWidth := 35;
      Colum.Columns[3].ColumnWidth := 15;
      Colum.Columns[3].HorizontalAlignment := xlCenter;
      Colum.Columns[4].ColumnWidth := 25;
      Colum.Columns[4].HorizontalAlignment := xlCenter;

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Пункт продажи';
      Sheet.Cells[4, 3] := 'Сумма';
      Sheet.Cells[4, 4] := 'Данные на';

      sum := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        Sheet.Cells[i + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + 5, 2] := frmExport2.qReport.FieldByName('ntp').AsString;
        Sheet.Cells[i + 5, 3] := frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qTradePoint.RecNo := (frmExport2.qReport.FieldByName('trid').AsInteger - 1);
        
        Sheet.Cells[i + 5, 4] := frmExport2.qTradePoint.FieldByName('maxst').AsString;
//        Sheet.Cells[i + 5, 5] := frmExport2.qTradePoint.FieldByName('ntp').AsString;
        sum := sum + frmExport2.qReport.FieldByName('summa').AsFloat;
        frmExport2.qReport.Next;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + 5), 'B' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['C' + inttostr(i + 5), 'C' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D' + IntToStr(5 + frmExport2.qReport.RecordCount)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.qReport.Close;

      XLApp.Visible := true;
      end;
   end;
end;

function fncReportPersOfDay(FIO : string) : boolean;
var
  XLApp  : Variant;
  Sheet  : Variant;
  Range  : Variant;
  Colum  : Variant;
  i      : Integer;
  DateStr : string;
  DateB, DateE : TDate;
  DateBStr, DateEStr : string;
  Year, Month, Day : Word;
  vedomost : string;
  sum : real;
begin
  result := true;
//  DateB := frmExport2.dtDateBPers.Date;
//  DateE := frmExport2.dtDateEPers.Date;
//  DecodeDate(DateB, Year, Month, Day);
//  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
//  DecodeDate(DateE, Year, Month, Day);
//  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

{SELECT concat(p.family, ' ', p.name, ' ', p.parentname), p.tabnum, s.summa, s.saletime, t.NameTP FROM sale s
left join tradepoint t on t.tradepoint_id=s.tradepoint_id
left join pers p on p.card_id=s.card_id
where s.card_id=88 and s.saletime> '2007-04-30' and s.saletime<'2007-06-01'}
  DateBStr := FormatDateTime('yyyy-mm-dd', frmExport2.dtDateBPers.Date);
  DateEStr := FormatDateTime('yyyy-mm-dd', frmExport2.dtDateEPers.Date);

  frmExport2.qReport.Close;
  frmExport2.qReport.SQL.Clear;
  frmExport2.qReport.SQL.Add('SELECT concat(p.family, " ", p.name, " ", p.parentname), p.tabnum as tabnum, s.summa as ss, s.saletime as st, t.NameTP as nametp FROM sale s');
  frmExport2.qReport.SQL.Add('left join tradepoint t on t.tradepoint_id=s.tradepoint_id');
  frmExport2.qReport.SQL.Add('left join pers p on p.card_id=s.card_id');
  frmExport2.qReport.SQL.Add('where s.card_id=' + frmExport2.edCard_Id.Text );
  frmExport2.qReport.SQL.Add(' and date(s.saletime) >= "' + DateBStr + '" ');
  frmExport2.qReport.SQL.Add(' and date(s.saletime) <= "' + DateEStr + '"');
  frmExport2.qReport.SQL.Add(' order by s.saletime ');
  frmExport2.qReport.Open;

  case frmExport2.qReport.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', 'D1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'Безналичная оплата продуктов питания';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', 'D2'];
//      Range.Font.Bold := true;
      Range.Font.Size := 10;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := FIO;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A3', 'D3'];
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'за период с ' + DateTostr(frmExport2.dtDateBPers.Date) + ' по ' + DateTostr(frmExport2.dtDateEPers.Date);

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D4'];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.WrapText := true;
     // настройка параметров столбцов
      Colum := XLApp.Workbooks[1].WorkSheets['Список'].Columns;
      Colum.Columns[1].ColumnWidth := 5;
      Colum.Columns[1].HorizontalAlignment := xlCenter;
      Colum.Columns[2].ColumnWidth := 35;
      Colum.Columns[3].ColumnWidth := 15;
      Colum.Columns[3].HorizontalAlignment := xlCenter;
      Colum.Columns[4].ColumnWidth := 25;
      Colum.Columns[4].HorizontalAlignment := xlCenter;

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п';
      Sheet.Cells[4, 2] := 'Пункт продажи';
      Sheet.Cells[4, 3] := 'Сумма';

      sum := 0;
      for i := 0 to frmExport2.qReport.RecordCount - 1 do
      begin
        Sheet.Cells[i + 5, 1] := IntToStr(i + 1);
        Sheet.Cells[i + 5, 2] := frmExport2.qReport.FieldByName('nametp').AsString;
        Sheet.Cells[i + 5, 3] := frmExport2.qReport.FieldByName('ss').AsFloat;
        Sheet.Cells[i + 5, 4] := frmExport2.qReport.FieldByName('st').AsString;
        sum := sum + frmExport2.qReport.FieldByName('ss').AsFloat;
        frmExport2.qReport.Next;
      end;
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A' + inttostr(i + 5), 'B' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.MergeCells := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := 'ИТОГО';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['C' + inttostr(i + 5), 'C' + inttostr(i + 5)];
      Range.Font.Bold := true;
      Range.VerticalAlignment := xlCenter;
      Range.HorizontalAlignment := xlCenter;
      Range.Value := sum;

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A4', 'D' + IntToStr(5 + frmExport2.qReport.RecordCount)];
      Range.Borders.LineStyle := xlContinuous;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmExport2.qReport.Close;

      XLApp.Visible := true;
      end;
   end;
end;

procedure TfrmExport2.btnExportDBClick(Sender: TObject);
begin
  case rbDay.Checked of
    true:
    begin
      fncReportOfDay();
    end;
    false:
    begin
      fncReportPeriod();
    end;
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

procedure TfrmExport2.btnStep3Click(Sender: TObject);
var
  i    : integer;
  sSql : string;
  sDBegin, sDEnd : string;
  Year, Month, DayB, DayE : Word;
begin
  for i := 1 to 6 do
  begin // ждем когда флешка обнаружиться в системе
        // поставить прогресс бар
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // обнаружили букву флешки
        FlashButton := ListDriv2[i];

        Year := frmExport2.seYear.Value; // определяем дату
        Month := frmExport2.cbMonth.ItemIndex + 1;
        DayB := 1;
        DayE := DaysInAMonth(Year, Month); // кол-во дней в месяце, для определения последнего дня

        sDBegin := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayB);
        sDEnd := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(DayE); 

        sSql := 'select tradepoint_id, card_id, empl_id, summa, saletime, otdel from beznal.sale ' +
                'where date(saletime) >= date(''' + sDBegin + ''') and date(saletime) <= date(''' + sDEnd + ''') ';

//function fncExportDBSQL(Pass, SQL, DateBStr, DateEStr, NameFile : string) : boolean;
        fncExportDBSQL('accident', sSQL, sDBegin, sDEnd, 'Sale.bou');
        fncReport();

{        if fncExportDBSQL('accident', sSQL, sDBegin, sDEnd, 'Sale.bou') and fncReport() then
          pnlStep4.Visible := true
        else
          pnlStep5.Visible := true;}

        btnStep3.Visible := false;
        break;
      end;
    end;
  end
  else
  begin
    ShowMessage('Не обнаружена флешка, попробуйте начать заново!');
  end;
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
into outfile 'e:/sale.bou'

// с выборкой столбцов

select tradepoint_id, card_id, empl_id, summa, saletime, otdel from beznal.sale
where date(saletime) >= '2007-03-01' and date(saletime) <= '2007-03-31'
into outfile 'e:/sale.bou'

// после выгрузки поставит пароль на файл sale.bou

// -------------загрузка таблицы sale из файла в базу-------------
// ---------------на сервере от локальной точки-------------------

load data local infile 'e:/sale.bou' into table beznal.sale

// с выборкой столбцов
load data local infile 'e:/sale.bou' into table beznal.sale(tradepoint_id, card_id, empl_id, summa, saletime, otdel)
}
end;

procedure TfrmExport2.Button5Click(Sender: TObject);
begin
  fncReport();
end;

procedure TfrmExport2.btnVed1CClick(Sender: TObject);
begin
  fncExportDB();
end;

procedure TfrmExport2.btnVedFromPointClick(Sender: TObject);
begin
  fncReport();
end;

procedure TfrmExport2.btnSelectEmplClick(Sender: TObject);
begin
  frmExport2.btnVedOfPers.Visible := false;
  frmSpr.tsCard.TabVisible := false;
  frmSpr.tsStateCard.TabVisible := false;
  frmSpr.tsPrava.TabVisible := false;
  frmSpr.tsEmpl.TabVisible := false;
  frmSpr.tsTEmp.TabVisible := false;
  frmSpr.tsPers.TabVisible := true;
  frmSpr.qPers.Close;
  frmSpr.qPers.SQL.Clear;
  frmSpr.qPers.SQL.Add('Select * from pers order by Family, name, parentname');
  frmSpr.qPers.Open;
  frmSpr.Show;
  SelectReport := true;
end;

procedure TfrmExport2.rbTabNoClick(Sender: TObject);
begin
  case rbTabNo.Checked of
  true:
    begin
      btnSearch.Visible := true;
      btnSelectEmpl.Visible := false;
      frmExport2.edFIO.Clear;// Text := frmExport2.qSelectPers.FieldByName('Family').AsString;;
      frmExport2.edName.Clear;//Text := frmExport2.qSelectPers.FieldByName('Name').AsString;;
      frmExport2.edParentName.Clear;//Text := frmExport2.qSelectPers.FieldByName('ParentName').AsString;;
      frmExport2.edPers_id.Clear;//Text := frmExport2.qSelectPers.FieldByName('Pers_id').AsString;;
      frmExport2.edCard_Id.Clear;//Text := frmExport2.qSelectPers.FieldByName('Card_Id').AsString;;
      edTabNum.SetFocus;
    end;
  end;
end;

procedure TfrmExport2.rbFIOClick(Sender: TObject);
begin
  case rbFIO.Checked of
  true:
    begin
      btnSearch.Visible := false;
      btnSelectEmpl.Visible := true;
    end;
  end;
end;

procedure TfrmExport2.btnSearchClick(Sender: TObject);
begin
  frmExport2.btnVedOfPers.Visible := false;
  frmExport2.edFIO.Clear;
  frmExport2.edName.Clear;
  frmExport2.edParentName.Clear;
  frmExport2.edCard_Id.Clear;
  frmExport2.edPers_id.Clear;
  frmExport2.qSelectPers.Close;
  frmExport2.qSelectPers.SQL.Clear;
  frmExport2.qSelectPers.SQL.Add('select * from pers where tabnum = "' + frmExport2.edTabNum.Text + '"');
  frmExport2.qSelectPers.Open;
  case frmExport2.qSelectPers.RecordCount of
    0:
    begin
      ShowMessage('Сотрудник с таб.№ ' + edTabNum.Text + ' не найден!');
    end;
    1:
    begin
      frmExport2.edFIO.Text := frmExport2.qSelectPers.FieldByName('Family').AsString;;
      frmExport2.edName.Text := frmExport2.qSelectPers.FieldByName('Name').AsString;;
      frmExport2.edParentName.Text := frmExport2.qSelectPers.FieldByName('ParentName').AsString;;
      frmExport2.edPers_id.Text := frmExport2.qSelectPers.FieldByName('Pers_id').AsString;;
      frmExport2.edCard_Id.Text := frmExport2.qSelectPers.FieldByName('Card_Id').AsString;;
      frmExport2.edTabNum.Text := frmExport2.qSelectPers.FieldByName('TabNum').AsString;;
      frmExport2.btnVedOfPers.Visible := true;
    end;
  else
    begin
      ShowMessage('Ошибка при поиске по таб.№' + edTabNum.Text + '!'+ #13#10 + 'Попробуйте выбрать сотрудника по ФИО.');
      rbFIO.Checked := true;
    end;
  end;
end;

procedure TfrmExport2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmExport2.qSelectPers.Close;
  frmExport2.qCreditForPers.Close;
end;

procedure TfrmExport2.edTabNumChange(Sender: TObject);
begin
  if Length(edTabNum.Text)<>0 then
    btnSearch.Enabled := true
  else
    btnSearch.Enabled := false;
end;

procedure TfrmExport2.btnVedOfPersClick(Sender: TObject);
begin
  if rbGroupTradePoint.Checked then
    fncReportOfPers('Сотрудник: ' + edFIO.Text + ' ' + edName.Text + ' ' + edParentName.Text);
  if rbGroupDay.Checked then
    fncReportPersOfDay('Сотрудник: ' + edFIO.Text + ' ' + edName.Text + ' ' + edParentName.Text);
end;

procedure TfrmExport2.Edit1Change(Sender: TObject);
begin
  if length(frmExport2.Edit1.Text) <> 0 then
  begin
    frmExport2.qCreditForPers.Close;
    frmExport2.qCreditForPers.SQL.Clear;
    frmExport2.qCreditForPers.SQL.Add('SELECT concat(p.family, " ", p.name, " ", p.parentname), p.tabnum, p.flagkredita,');
    frmExport2.qCreditForPers.SQL.Add('c.nomer, c.statecard_id, cr.datebegin, cr.dateend, cr.sumcredit');
    frmExport2.qCreditForPers.SQL.Add('FROM pers p');
    frmExport2.qCreditForPers.SQL.Add('left join card c on c.card_id=p.card_id');
    frmExport2.qCreditForPers.SQL.Add('left join credits cr on cr.card_id=p.card_id');
    frmExport2.qCreditForPers.SQL.Add('where instr(concat(p.family, " ", p.name, " ", p.parentname), "' + frmExport2.Edit1.Text + '")');
    frmExport2.qCreditForPers.Open;
  end
  else
    frmExport2.qCreditForPers.Close;
end;

procedure TfrmExport2.Button6Click(Sender: TObject);
begin
  fncReportPersOfDay('Сотрудник: ' + edFIO.Text + ' ' + edName.Text + ' ' + edParentName.Text);
{SELECT concat(p.family, ' ', p.name, ' ', p.parentname), p.tabnum, s.summa, s.saletime, t.NameTP FROM sale s
left join tradepoint t on t.tradepoint_id=s.tradepoint_id
left join pers p on p.card_id=s.card_id
where s.card_id=88 and s.saletime> '2007-04-30' and s.saletime<'2007-06-01'}
end;

end.
