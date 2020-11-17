unit unt_OverCredit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, MySQLDataset, Grids, DBGrids, StdCtrls, ExtCtrls, Buttons,
  ComCtrls;

type
  TFrm_OverCredit = class(TForm)
    Query_temp: TMySQLQuery;
    BitBtn_show: TBitBtn;
    RadioGroup1: TRadioGroup;
    DateTimePicker_begin: TDateTimePicker;
    DateTimePicker_end: TDateTimePicker;
    StringGrid1: TStringGrid;
    BitBtn_stopList: TBitBtn;
    Query_temp1: TMySQLQuery;
    procedure FormShow(Sender: TObject);
    procedure BitBtn_showClick(Sender: TObject);
    procedure BitBtn_stopListClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_OverCredit: TFrm_OverCredit;

implementation

uses untSpravochnik, DateUtils;

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TFrm_OverCredit.FormShow(Sender: TObject);
begin
RadioGroup1.ItemIndex:=0;
end;

//------------------------------------------------------------------------------
procedure TFrm_OverCredit.BitBtn_showClick(Sender: TObject);
var j, i: integer;
    d: TDateTime;
begin
//чистим Stringgrid
for j:=0 to (StringGrid1.RowCount-1) do begin
  for i:=0 to (StringGrid1.ColCount-1) do begin
     StringGrid1.Cells[i,j]:='';
  end;
end;

StringGrid1.ColWidths[0]:=40;
StringGrid1.ColWidths[1]:=60;
StringGrid1.ColWidths[2]:=250;
StringGrid1.ColWidths[3]:=100;
StringGrid1.ColWidths[4]:=100;

StringGrid1.Cells[0,0]:='є п/п';
StringGrid1.Cells[1,0]:='Card_id';
StringGrid1.Cells[2,0]:='‘.».ќ.';
StringGrid1.Cells[3,0]:='—умма кредита';
StringGrid1.Cells[4,0]:='ѕотраченна€ сумма';

j:=1;
i:=1;
StringGrid1.RowCount:=2;
//за текущий мес€ц
if RadioGroup1.ItemIndex=0 then begin
//1 период - берем суммы с 1 по 14 число и сравниваем с кредитами за первый период
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select sum(summa) as sm, s.card_id,family, name, parentname, c1.sumcredit');
Query_temp.SQL.Add('from sale s');
Query_temp.SQL.Add('inner join pers p on p.card_id=s.card_id');
Query_temp.SQL.Add('inner join credits c1 on c1.card_id=s.card_id');
Query_temp.SQL.Add('where saletime>'''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and saletime<'''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('and flagkredita=1');
Query_temp.SQL.Add('and c1.datebegin='''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('group by s.card_id');
Query_temp.SQL.Add('having sum(summa)>(select sumcredit from credits c');
Query_temp.SQL.Add('where datebegin='''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and s.card_id=c.card_id)');
Query_temp.Open;

if not Query_temp.Eof then begin
StringGrid1.Cells[2,j]:='1 период ('+FormatDateTime('mm.yyyy', now)+')';
StringGrid1.RowCount:=StringGrid1.RowCount+1;
j:=j+1;
while not Query_temp.Eof do begin
  StringGrid1.Cells[0,j]:=IntToStr(i);
  StringGrid1.Cells[1,j]:=Query_temp.FieldByName('card_id').AsString;
  StringGrid1.Cells[2,j]:=Query_temp.FieldByName('family').AsString+' '+Query_temp.FieldByName('name').AsString+' '+Query_temp.FieldByName('ParentName').AsString;
  StringGrid1.Cells[3,j]:=Query_temp.FieldByName('sumcredit').AsString;
  StringGrid1.Cells[4,j]:=Query_temp.FieldByName('sm').AsString;
  j:=j+1;
  i:=i+1;
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
Query_temp.Next;
end;
end;

//2 период - берем суммы c 1 числа до текущей даты и сравниваем с кредитами за 2 период (смотрим только тех, кого нет в списке за 1 период)
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select sum(summa) as sm, s.card_id,family, name, parentname, c1.sumcredit');
Query_temp.SQL.Add('from sale s');
Query_temp.SQL.Add('inner join pers p on p.card_id=s.card_id');
Query_temp.SQL.Add('inner join credits c1 on c1.card_id=s.card_id');
Query_temp.SQL.Add('where saletime>'''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and flagkredita=1');
Query_temp.SQL.Add('and c1.datebegin='''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('group by s.card_id');
Query_temp.SQL.Add('having sum(summa)>(select sumcredit from credits c');
Query_temp.SQL.Add('where datebegin='''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('and s.card_id=c.card_id)');
Query_temp.Open;

if not Query_temp.Eof then begin
StringGrid1.Cells[2,j]:='2 период ('+FormatDateTime('mm.yyyy', now)+')';
StringGrid1.RowCount:=StringGrid1.RowCount+1;
j:=j+1;
while not Query_temp.Eof do begin
  StringGrid1.Cells[0,j]:=IntToStr(i);
  StringGrid1.Cells[1,j]:=Query_temp.FieldByName('card_id').AsString;
  StringGrid1.Cells[2,j]:=Query_temp.FieldByName('family').AsString+' '+Query_temp.FieldByName('name').AsString+' '+Query_temp.FieldByName('ParentName').AsString;
  StringGrid1.Cells[3,j]:=Query_temp.FieldByName('sumcredit').AsString;
  StringGrid1.Cells[4,j]:=Query_temp.FieldByName('sm').AsString;
  j:=j+1;
  i:=i+1;
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
Query_temp.Next;
end;
end;
end;

//за выбранный период
if RadioGroup1.ItemIndex=1 then begin
d:=StartOfTheMonth(DateTimePicker_begin.DateTime);

end;

end;

//------------------------------------------------------------------------------
procedure TFrm_OverCredit.BitBtn_stopListClick(Sender: TObject);
var nomer: string;
begin
//вставл€ем записи в стоплист
//записываем в historyevents
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('insert into historyevents(opertime, event_id, memo)');
Query_temp1.SQL.Add('values ('''+FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+''', 16, ''ѕроверка на превышение кредита'')');
Query_temp1.Execute(true);

//1 период - берем суммы с 1 по 14 число и сравниваем с кредитами за первый период
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select sum(summa) as sm, s.card_id,family, name, parentname, c1.sumcredit, pers_id');
Query_temp.SQL.Add('from sale s');
Query_temp.SQL.Add('inner join pers p on p.card_id=s.card_id');
Query_temp.SQL.Add('inner join credits c1 on c1.card_id=s.card_id');
Query_temp.SQL.Add('where saletime>'''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and saletime<'''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('and flagkredita=1');
Query_temp.SQL.Add('and c1.datebegin='''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('group by s.card_id');
Query_temp.SQL.Add('having sum(summa)>(select sumcredit from credits c');
Query_temp.SQL.Add('where datebegin='''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and s.card_id=c.card_id)');
Query_temp.Open;

while not Query_temp.Eof do begin
//ставим флаг 2 в таблице Pers
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('update pers set flagkredita=2');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Execute(true);
//ставим флаг 2 в таблице Card
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('update Card set statecard_id=2');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Execute(true);
//находим номер карты
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('select * from Card');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Open;
nomer:=Query_temp1.FieldByName('nomer').AsString;
//если карты нет в стоплисте - вставл€ем эту карту в стоплист
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('select * from stoplist');
Query_temp1.SQL.Add('where nomer='+nomer);
Query_temp1.Open;
if Query_temp1.Eof then begin
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('insert into stoplist(nomer, dateinsert, flag)');
Query_temp1.SQL.Add('values ('+nomer+', '''+FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+''', 2)');
Query_temp1.Execute(true);
end;
//записываем в historyevents
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('insert into historyevents(opertime, card_id, pers_id, event_id, memo)');
Query_temp1.SQL.Add('values ('''+FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+''', '+Query_temp.fieldbyname('card_id').AsString
                     +', '+Query_temp.fieldbyname('pers_id').AsString+', 16, ''(1 пер) nomer='+nomer+', кредит='
                     +Query_temp.fieldbyname('sumcredit').AsString+', потраченна€ сумма='+Query_temp.fieldbyname('sm').AsString+''')');
Query_temp1.Execute(true);

Query_temp.Next;
end;

//2 период - берем суммы c 1 числа до текущей даты и сравниваем с кредитами за 2 период (смотрим только тех, кого нет в списке за 1 период)
Query_temp.Close;
Query_temp.SQL.Clear;
Query_temp.SQL.Add('select sum(summa) as sm, s.card_id,family, name, parentname, c1.sumcredit, pers_id');
Query_temp.SQL.Add('from sale s');
Query_temp.SQL.Add('inner join pers p on p.card_id=s.card_id');
Query_temp.SQL.Add('inner join credits c1 on c1.card_id=s.card_id');
Query_temp.SQL.Add('where saletime>'''+FormatDateTime('yyyy-mm-dd', StartOfTheMonth(Now))+'''');
Query_temp.SQL.Add('and flagkredita=1');
Query_temp.SQL.Add('and c1.datebegin='''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('group by s.card_id');
Query_temp.SQL.Add('having sum(summa)>(select sumcredit from credits c');
Query_temp.SQL.Add('where datebegin='''+FormatDateTime('yyyy-mm-dd', IncDay(StartOfTheMonth(Now), 14))+'''');
Query_temp.SQL.Add('and s.card_id=c.card_id)');
Query_temp.Open;

while not Query_temp.Eof do begin
//ставим флаг 2 в таблице Pers
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('update pers set flagkredita=2');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Execute(true);
//ставим флаг 2 в таблице Card
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('update Card set statecard_id=2');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Execute(true);
//находим номер карты
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('select * from Card');
Query_temp1.SQL.Add('where card_id='+Query_temp.fieldbyname('card_id').AsString);
Query_temp1.Open;
nomer:=Query_temp1.FieldByName('nomer').AsString;
//если карты нет в стоплисте - вставл€ем эту карту в стоплист
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('select * from stoplist');
Query_temp1.SQL.Add('where nomer='+nomer);
Query_temp1.Open;
if Query_temp1.Eof then begin
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('insert into stoplist(nomer, dateinsert, flag)');
Query_temp1.SQL.Add('values ('+nomer+', '''+FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+''', 2)');
Query_temp1.Execute(true);
end;
//записываем в historyevents
Query_temp1.Close;
Query_temp1.SQL.Clear;
Query_temp1.SQL.Add('insert into historyevents(opertime, card_id, pers_id, event_id, memo)');
Query_temp1.SQL.Add('values ('''+FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)+''', '+Query_temp.fieldbyname('card_id').AsString
                     +', '+Query_temp.fieldbyname('pers_id').AsString+', 16, ''(2 пер) nomer='+nomer+', кредит='
                     +Query_temp.fieldbyname('sumcredit').AsString+', потраченна€ сумма='+Query_temp.fieldbyname('sm').AsString+''')');
Query_temp1.Execute(true);

Query_temp.Next;
end;
//ShowMessage('           √отово!         ');
end;

//------------------------------------------------------------------------------
procedure TFrm_OverCredit.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then
BitBtn_stopList.Enabled:=true
else
BitBtn_stopList.Enabled:=false;
end;

end.
