unit untSaleOfDay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, MySQLDataset, Grids, DBGridEh, ExtCtrls,
  Buttons, ExcelXP, comobj, OleServer, DBGridEhGrouping, GridsEh;

type
  TfrmSaleOfDay = class(TForm)
    Panel2: TPanel;
    btnExit: TBitBtn;
    qSalesOfOtdel: TMySQLQuery;
    dsSaleOfOtdel: TDataSource;
    qSaleSumma: TMySQLQuery;
    qSalesOfOtdelSumma: TFloatField;
    qSalesOfOtdelOtdel: TLargeintField;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    rbDay: TRadioButton;
    rbPeriod: TRadioButton;
    gbPeriod: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtDateBegin: TDateTimePicker;
    dtDateEnd: TDateTimePicker;
    gbDay: TGroupBox;
    dtDay: TDateTimePicker;
    GroupBox1: TGroupBox;
    cbPunct: TComboBox;
    gbResult: TGroupBox;
    Label4: TLabel;
    lSalesOfDay: TLabel;
    Bevel1: TBevel;
    DBGridEh1: TDBGridEh;
    btnSaleOfDay: TBitBtn;
    Splitter1: TSplitter;
    Button1: TButton;
    ExcelApplication1: TExcelApplication;
    ExcelWorkbook1: TExcelWorkbook;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnSaleOfDayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbDayClick(Sender: TObject);
    procedure rbPeriodClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSaleOfDay: TfrmSaleOfDay;

implementation

uses untSpravochnik, untGlobalVar, DateUtils;

{$R *.dfm}

procedure TfrmSaleOfDay.FormShow(Sender: TObject);
begin
  fncExecSQLFillCB('TradePoint', 'NameTP', frmSaleOfDay.cbPunct);
  frmSaleOfDay.cbPunct.ItemIndex := 0;
  frmSaleOfDay.dtDay.Date := now();
  frmSaleOfDay.dtDateBegin.Date := now();
  frmSaleOfDay.dtDateEnd.Date := now();
end;

procedure TfrmSaleOfDay.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSaleOfDay.btnSaleOfDayClick(Sender: TObject);
var
  summa, StrSQL, SqlOtdel     : string;
  DateStr, DateBStr, DateEStr : string;
  DateD, DateB, DateE         : Tdate;
  Year, Month, Day            : Word;
  sPunct                      : string;
begin
//  frmSaleOfDay.gbResult.Visible := false;
  case frmSaleOfDay.cbPunct.ItemIndex of
  0 : // продажи на всех точках
    sPunct := '';
  else // выбрана точка продаж
    sPunct := ' and tradepoint_id = ' + inttostr(frmSaleOfDay.cbPunct.ItemIndex);
  end;

  case frmSaleOfDay.rbDay.Checked of
    true : // за 1 день
    begin
      DateD := frmSaleOfDay.dtDay.Date;
      DecodeDate(DateD, Year, Month, Day);
      DateStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
      StrSQL := 'SELECT sum(summa) FROM sale where date(saletime) = date("' + DateStr + '") ' + sPunct;
      SqlOtdel := 'SELECT sum(summa) as summa, otdel FROM sale where date(saletime)=date("' + DateStr + '") ' + sPunct + ' group by otdel ';
    end;
    false: // за период
    begin
      DateB := frmSaleOfDay.dtDateBegin.Date;
      DateE := frmSaleOfDay.dtDateEnd.Date;
      DecodeDate(DateB, Year, Month, Day);

      DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
      DecodeDate(DateE, Year, Month, Day);
      DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

      StrSQL := ' select sum(summa) from sale where' +
                ' date(saletime) >= date(''' + DateBStr + ''') and ' +
                ' date(saletime) <= date(''' + DateEStr + ''') ' + sPunct;

      SqlOtdel := ' select sum(summa) as summa, otdel from sale where' +
                  ' date(saletime) >= date(''' + DateBStr + ''') and ' +
                  ' date(saletime) <= date(''' + DateEStr + ''') ' + sPunct + ' group by otdel';
    end;
  end;

  frmSaleOfDay.qSaleSumma.Close;
  frmSaleOfDay.qSaleSumma.SQL.Clear;
  frmSaleOfDay.qSaleSumma.SQL.Add(StrSQL);
  frmSaleOfDay.qSaleSumma.Open;
  Summa := frmSaleOfDay.qSaleSumma.fieldByName('sum(summa)').AsString;
  if Summa = '' then // нет данных
    begin
      MessageDlg('За данный период данных нет!', mtInformation, [mbOk], 0);
      exit;
    end
  else
    begin
      frmSaleOfDay.lSalesOfDay.Caption := Summa + ' руб.';
    end;
  frmSaleOfDay.qSaleSumma.Close;

  frmSaleOfDay.qSalesOfOtdel.Close;
  frmSaleOfDay.qSalesOfOtdel.SQL.Clear;
  frmSaleOfDay.qSalesOfOtdel.SQL.Add(SqlOtdel);
  frmSaleOfDay.qSalesOfOtdel.Open;
//  frmSaleOfDay.gbResult.Visible := true;
end;

procedure TfrmSaleOfDay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSaleOfDay.qSalesOfOtdel.Close;
  frmSaleOfDay.qSaleSumma.Close;
end;

procedure TfrmSaleOfDay.rbDayClick(Sender: TObject);
begin
  case rbDay.Checked of
  true:
    begin
      gbDay.Visible := true;
      gbPeriod.Visible := false;
    end;
  end;
end;

procedure TfrmSaleOfDay.rbPeriodClick(Sender: TObject);
begin
  case rbPeriod.Checked of
  true:
    begin
      gbDay.Visible := false;
      gbPeriod.Visible := true;
    end;
  end;
end;

procedure TfrmSaleOfDay.Button1Click(Sender: TObject);
var
  StrSQL, SqlOtdel, tpname    : string;
  DateStr, DateBStr, DateEStr : string;
  DateD, DateB, DateE         : Tdate;
  Year, Month, Day            : Word;
  i, j                        : integer;
  XLApp                       : Variant;
  Sheet                       : Variant;
  Range                       : Variant;
  Colum                       : Variant;
  sum  : real;
begin
  DateB := frmSaleOfDay.dtDateBegin.Date;
  DateE := frmSaleOfDay.dtDateEnd.Date;
  DecodeDate(DateB, Year, Month, Day);

  DateBStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
  DecodeDate(DateE, Year, Month, Day);
  DateEStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);

  StrSQL := ' select t.nametp as tpname, sum(s.summa) as summa, date(s.saletime) as dateb from sale s' +
            ' left join tradepoint t on t.tradepoint_id=s.tradepoint_id where' +
            ' date(saletime) >= date(''' + DateBStr + ''')  and ' +
            ' date(saletime) <= date(''' + DateEStr + ''') ' +
            ' group by s.tradepoint_id, date(s.saletime)';

  frmSaleOfDay.qSaleSumma.Close;
  frmSaleOfDay.qSaleSumma.SQL.Clear;
  frmSaleOfDay.qSaleSumma.SQL.Add(StrSQL);
  frmSaleOfDay.qSaleSumma.Open;
  frmSaleOfDay.qSaleSumma.First;

  case frmSaleOfDay.qSaleSumma.RecordCount of
    0:
    begin
       ShowMessage('На заданные условия данных нет!');
    end
    else
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Workbooks.Add(-4167);
      XLApp.Workbooks[1].WorkSheets[1].Name := 'Список';
      XLApp.Visible := true;

      // шапка
      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A1', 'D1'];
      Range.Font.Bold := true;
      Range.Font.Size := 12;
      Range.MergeCells := true;
      Range.HorizontalAlignment := xlCenter;
      Range.VerticalAlignment := xlCenter;
      Range.Value := 'Суммы продаж по точкам';

      Range := XLApp.Workbooks[1].WorkSheets['Список'].Range['A2', 'D2'];
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

      Sheet := XLApp.Workbooks[1].WorkSheets['Список'];
      Sheet.Cells[4, 1] := '№ п.п.';
      Sheet.Cells[4, 2] := 'Пункт продажи';

      i := 3;
      while dateb <= datee do
      begin
        Colum.Columns[i].HorizontalAlignment := xlCenter;
        Sheet.Cells[4, i].Orientation := 90;
        Sheet.Cells[4, i].ColumnWidth := 7;
        Sheet.Cells[4, i].Font.Bold := true;
        Sheet.Cells[4, i] := datetostr(dateb);
        dateb := IncDay(dateb, 1);
        inc(i);
      end;
      j := 5;
      sum := 0;
      tpname := frmSaleOfDay.qSaleSumma.FieldByName('tpname').AsString;
      Sheet.Cells[j, 1] := IntToStr(i);
      Sheet.Cells[j, 2] := tpname;
      while not frmSaleOfDay.qSaleSumma.Eof do
      begin
        if tpname <> frmSaleOfDay.qSaleSumma.FieldByName('tpname').AsString then
        begin
          tpname := frmSaleOfDay.qSaleSumma.FieldByName('tpname').AsString;
          Sheet.Cells[j, 3 + DayOf(DateE)] := sum;
          inc(j);
          Sheet.Cells[j, 1] := IntToStr(i);
          Sheet.Cells[j, 2] := tpname;
          sum := 0;
        end;
        i := 2 + DayOf(frmSaleOfDay.qSaleSumma.FieldByName('dateb').AsDateTime);
        Sheet.Cells[j, i] := frmSaleOfDay.qSaleSumma.FieldByName('summa').AsString;
        sum := sum + frmSaleOfDay.qSaleSumma.FieldByName('summa').AsFloat;
        frmSaleOfDay.qSaleSumma.Next;
        inc(i);
      end;
      Sheet.Cells[j, 3 + DayOf(DateE)] := sum;

      XLApp.Workbooks[1].WorkSheets[1].PageSetup.Orientation := xlPortrait;
      frmSaleOfDay.qSaleSumma.Close;
      end;
   end;
end;

end.
