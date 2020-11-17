unit untGlobalVar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Math, untMifareDll, IniFiles;

const
  Sector = 14;
  Block = 0;

var
  a             : integer;
  AuthentMode   : Byte;
  CardNo        : DWORD;
  Dost          : array [1..10] of DWORD;
  Val           : array [0..15] of byte; // ������ ��������� � ����� �������� (������������ �� �����)
  Ostatok       : real;
  SummaSpisania : real;
  SelectSpr     : boolean; // ����� ������ �������� �� �����������
  TypeEmpl_id   : integer; // id ��������� ��������������� ����������
  CurrentCardNo : DWORD; // ����� ����� ������� � ������ �������� �� �����
  CurrentCardId : string; // id ����� ������� � ������ �������� �� �����
  CurrentEmplId : string; // id ����� ���������� (������, �����, ����������� � ��.)
  CurrentPersId : string; // id ������� � ������ ��������
  CurDirPuth    : string; // ������� ����� �������
//  DllName : string; // ���� � ���
  bDelimYes     : boolean; // ���� ����� ������� � �����, true - ������� ��� ���� 
  bMinusYes     : boolean; // ���� ����� "-" � �����, true - ����� ��� ���� 
  tIniSett      : TIniFile;
  PutchFolderPrj : String;
  TradePoint_id : integer; // id ������ �������
  TradePoint    : string; // �������� ������ �������
  arrSumOtdel      : array [1..9] of real; // ������ ���� �� �������
  ListDriv1, ListDriv2 : String;
  FlashButton : string; //����� ������

procedure ErrorMsg(ErrorCode : integer);
// * ������� ����� �� 16�� � 10�� *
function HexToInt (Hex : String) : Integer;
function fncExecSQLFillCB(Table, Field: string; ComboBox : TComboBox) : boolean;
function fncExecSQLFillLB(Table, Field: string; ListBox : TListBox) : boolean;
// ������ ������� Value � ������(����) SektorN(BlockN) ����� � � CurrentCardNo; 
function fncWriteInCard(CardN : DWORD; SectorN, BlockN : byte; Value : array of byte; var ErrStr : string) : integer;
procedure prcExecSQL(Text : string);
function fncExecSQLOpen(Text : string) : boolean;
procedure prcBSKBadData(sCardNo : string);
procedure prcGetDriv(var List : String);
procedure prcAddBSKInStopList(InList, InBSK : boolean);// ��� � ����-����

implementation

uses
  untMain, untSpravochnik, untDB, untDostup, untFirst;


  function fncWriteInCard(CardN : DWORD; SectorN, BlockN : byte; Value : array of byte; var ErrStr : string) : integer;
var
  aa : integer;
begin
try
  ErrStr := '';
  aa := 0;
  Result := aa;

  // ��������� � ����� ����������� � CurrentCardNo
  MifareCardSerialNoGet(@CardNo);

  if CardNo = CardN then
  begin
    // request
    aa := MifareCardRequest(MODE_ALL);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // anticollision
    aa := MifareAnticollision(@CardNo);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // select card
    aa := MifareCardSelect(CardNo);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // autentication
    AuthentMode := Key_B or Key_Set0;
    aa := MifareSectorAuthentication(AuthentMode, SectorN);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // ������ �� �����
    aa := MifareBlockWrite(SectorN, BlockN, @Val);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // ������������ �����
    aa := MifareCardHalt;
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;
  end
  else
  begin
    Result := 666;
  end;

{  aa := MifareSessionClose;     // ��������� ������ ������ � ������
  if aa <> MIFARE_OK then       // ������ �� �������
  begin
    result := aa;
    exit;
  end;    }
finally
end;
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

// * ������� ����� �� 16�� � 10�� *
function HexToInt (Hex : String) : Integer;
var
  Int,i  : Integer;
  Stroka : String;
  Temp   : integer;
begin
  Stroka := '0123456789ABCDEF';
  Temp := 0;
  Int := 0;
  for i := Length(Hex) downto 1 do
  begin
    case pos (Hex[Length(Hex)-i+1], Stroka) of
      1  : Int := 0;
      2  : Int := 1;
      3  : Int := 2;
      4  : Int := 3;
      5  : Int := 4;
      6  : Int := 5;
      7  : Int := 6;
      8  : Int := 7;
      9  : Int := 8;
      10 : Int := 9;
      11 : Int := 10;
      12 : Int := 11;
      13 : Int := 12;
      14 : Int := 13;
      15 : Int := 14;
      16 : Int := 15;
    end;
    Temp := Temp + Round(Int * power(16, i-1));
  end;
  Result := Temp;
end;

procedure ErrorMsg(ErrorCode : integer);
var
  TextMsg : string;
begin
  case ErrorCode of
    1:
    begin
      TextMsg := '������ ������ ������. ��������� ������������ ����������� ����!';
    end;
    2:
    begin
      TextMsg := '������ �������� �����!';
    end;
    else
      TextMsg := '�� ���������� ������, ��� ' + IntToStr(ErrorCode) + '!';
  end;
//  frmMain.lMessage.Caption := TextMsg;
end;

procedure prcExecSQL(Text : string);
begin
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add(Text);
  mDB.qTemp.ExecSQL;
end;

procedure prcBSKBadData(sCardNo : string);// ������ ������� �� ���
var
  t : string;
begin
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add('update card set statecard_id = 2 where nomer =' + sCardNo + '');
  mDB.qTemp.ExecSQL;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo) ');
  mDB.qTemp.SQL.Add('values(Now(), 11, ' + CurrentCardId + ',' + CurrentPersId + ', ');
  mDB.qTemp.SQL.Add(CurrentEmplId + ', ' + sCardNo + ' )');
  mDB.qTemp.ExecSQL;
  //��������� ���� �� ��� - ��� �������������
  Val[11] := 66; //
  fncWriteInCard(CurrentCardNo, Sector, Block, Val, t);
end;

procedure prcAddBSKInStopList(InList, InBSK : boolean);// ��� � ����-����
var
  t, sCardNo : string;
begin
  sCardNo := IntToStr(CurrentCardNo);
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;                  // ������� ������ �� �������
  mDB.qTemp.SQL.Add('delete from credits where card_id = "' + CurrentCardId + '" ');
  mDB.qTemp.SQL.Add('and datebegin="' + FormatDateTime('yyyy-mm-01 00:00:00', Now()) + '"');
  mDB.qTemp.ExecSQL;
  if InList then                        // ��� � ����-����
  begin
    mDB.qTemp.Close;
    mDB.qTemp.SQL.Clear;
    mDB.qTemp.SQL.Add('insert into stoplist(nomer, dateinsert) values("' + sCardNo + '",Now())');
    mDB.qTemp.ExecSQL;
    mDB.qTemp.SQL.Clear;
    mDB.qTemp.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, empl_id, memo) ');
    mDB.qTemp.SQL.Add('values(Now(), 11, ' + CurrentCardId + ',' + CurrentPersId + ', ');
    mDB.qTemp.SQL.Add(CurrentEmplId + ', ' + sCardNo + ' )');
    mDB.qTemp.ExecSQL;
  end;
  if InBSK then                         //��������� ���� �� ��� - ��� �� ����������
  begin 
    Val[12] := 44;
    fncWriteInCard(CurrentCardNo, Sector, Block, Val, t);
  end;
end;

function fncExecSQLOpen(Text : string) : boolean;
begin
  Result := true;
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add(Text);
  mDB.qTemp.ExecSQL;
  mDB.qTemp.Open;
  mDB.qTemp.First;
  if mDB.qTemp.Eof then
    Result := false;
end;

function fncExecSQLFillCB(Table, Field: string; ComboBox : TComboBox) : boolean;
begin
  Result := true;
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add('select distinct ' + Field + ' from ' + Table +' ');
  mDB.qTemp.ExecSQL;
  mDB.qTemp.Open;
  mDB.qTemp.First;
  ComboBox.Clear;
  if mDB.qTemp.Eof then
  begin
    Result := false;
    exit;
  end
  else
    while not mDB.qTemp.Eof do
    begin
      ComboBox.Items.Add(mDB.qTemp.FieldByName(Field).AsString);
      mDB.qTemp.Next;
    end;
end;

function fncExecSQLFillLB(Table, Field: string; ListBox : TListBox) : boolean;
begin
  Result := true;
  mDB.qTemp.Close;
  mDB.qTemp.SQL.Clear;
  mDB.qTemp.SQL.Add('select distinct ' + Field + ' from ' + Table +' ');
  mDB.qTemp.ExecSQL;
  mDB.qTemp.Open;
  mDB.qTemp.First;
  ListBox.Clear;
  if mDB.qTemp.Eof then
  begin
    Result := false;
    exit;
  end
  else
    while not mDB.qTemp.Eof do
    begin
      ListBox.Items.Add(mDB.qTemp.FieldByName(Field).AsString);
      mDB.qTemp.Next;
    end;
end;

end.
