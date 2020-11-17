unit untSaleOfDay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, MySQLDataset, Grids, DBGridEh, ExtCtrls,
  Buttons;

type
  TfrmSaleOfDay = class(TForm)
    GroupBox3: TGroupBox;
    btnSaleOfDay: TBitBtn;
    Panel2: TPanel;
    btnExit: TBitBtn;
    gbResult: TGroupBox;
    rbDay: TRadioButton;
    rbPeriod: TRadioButton;
    gbDay: TGroupBox;
    dtDay: TDateTimePicker;
    gbPeriod: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtDateBegin: TDateTimePicker;
    dtDateEnd: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    DBGridEh1: TDBGridEh;
    qSalesOfOtdel: TMySQLQuery;
    dsSaleOfOtdel: TDataSource;
    qSaleSumma: TMySQLQuery;
    qSalesOfOtdelSumma: TFloatField;
    qSalesOfOtdelOtdel: TLargeintField;
    lSalesOfDay: TLabel;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnSaleOfDayClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbDayClick(Sender: TObject);
    procedure rbPeriodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSaleOfDay: TfrmSaleOfDay;

implementation

uses untSpravochnik;

{$R *.dfm}

procedure TfrmSaleOfDay.FormShow(Sender: TObject);
begin
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
begin
  frmSaleOfDay.gbResult.Visible := false;
  case frmSaleOfDay.rbDay.Checked of
    true : // за 1 день
    begin
      DateD := frmSaleOfDay.dtDay.Date;
      DecodeDate(DateD, Year, Month, Day);
      DateStr := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day);
      StrSQL := 'SELECT sum(summa) FROM sale where date(saletime) = date("' + DateStr + '")';
      SqlOtdel := 'SELECT sum(summa) as summa, otdel FROM sale where date(saletime)=date("' + DateStr + '") group by otdel ';
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
                ' date(saletime) <= date(''' + DateEStr + ''') ';

      SqlOtdel := ' select sum(summa) as summa, otdel from sale where' +
                  ' date(saletime) >= date(''' + DateBStr + ''') and ' +
                  ' date(saletime) <= date(''' + DateEStr + ''') group by otdel';
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
  frmSaleOfDay.gbResult.Visible := true;
end;

procedure TfrmSaleOfDay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmSaleOfDay.qSalesOfOtdel.Close;
  frmSaleOfDay.qSaleSumma.Close;
  frmSaleOfDay.gbResult.Visible := false;
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

end.
