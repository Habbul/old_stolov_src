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
  CurrentCardId : string; // id ����� ������� � ������ �������� �� �����
  CurrentEmplId : string; // id ����� ���������� (������, �����, ����������� � ��.)
  CurrentPersId : string; // id ������� � ������ ��������
  CurDirPuth    : string; // ������� ����� �������
  bDelimYes     : boolean; // ���� ����� ������� � �����, true - ������� ��� ���� 
  bMinusYes     : boolean; // ���� ����� "-" � �����, true - ����� ��� ���� 
  tIniSett      : TIniFile;
  TextF         : TextFile;
  PuthFileRarus : string;
  PuthFileReader, DllName : string;
  TradePoint_id : integer; // id ������ �������
  Empl_id       : integer; // id ��������
function fncIniReader() : boolean;
// * ������� ����� �� 16�� � 10�� *
function HexToInt (Hex : String) : Integer;
// ������ ������� Value � ������(����) SektorN(BlockN) ����� � � CurrentCardNo;
function fncWriteInCard(CardN : DWORD; SectorN, BlockN : byte; Value : array of byte; var ErrStr : string) : integer;
procedure prcBSKBadData(sCardNo : string);
procedure prcAddBSKInStopList(InBSK : boolean);// ��� � ����-����

implementation

uses
  untKassa;

procedure prcAddBSKInStopList(InBSK : boolean);// ��� � ����-����
var
  t : string;
begin
  if InBSK then                         //��������� ���� �� ��� - ��� �� ����������
  begin 
    Val[12] := 44;
    fncWriteInCard(CardNo, Sector, Block, Val, t);
  end;
end;

function fncIniReader() : boolean;
var
  Key : array [0..5] of Byte;
begin
  Result := true;
//  a := MifareSessionOpen1(Certificate);     // ��������� ������ ������ � ������
  a := MifareSessionOpen2(Certificate, 1);     // ��������� ������ ������ � ������
  if a <> MIFARE_OK then                    // ������ �� �������, ��� ������: 11
  begin
    MessageDlg('������� �� ����� ���� ���������!' + #13#10 + '��� ������: 11', mtError, [mbOk], 0);
    Result := false;
    exit;
  end;

  // �������� ������
  AuthentMode := Key_A or Key_Set0;  // KeyA := 'D4AA94C4B5E8';
  Key[0] := $D4;
  Key[1] := $AA;
  Key[2] := $94;
  Key[3] := $C4;
  Key[4] := $B5;
  Key[5] := $E8;

  a := MifareLoadKeyIntoReader(AuthentMode, 14, @Key);
  if a <> MIFARE_OK then                    // �������� ����� �
  begin                                     // ���� �� ��������, ��� ������: 22
    MessageDlg('������� �� ����� ���� ���������!' + #13#10 + '��� ������: 22', mtError, [mbOk], 0);
    Result := false;
    exit;
  end;

  AuthentMode := Key_B or Key_Set0; // KeyB := '7F5C4D210F0B';  7F 5C 4D 21 0F 0B+14B
  Key[0] := $7F;
  Key[1] := $5C;
  Key[2] := $4D;
  Key[3] := $21;
  Key[4] := $0F;
  Key[5] := $0B;

  a := MifareLoadKeyIntoReader(AuthentMode, 14, @Key);
  if a <> MIFARE_OK then                    // �������� ����� B
  begin                                     // ���� �� ��������, ��� ������: 33
    MessageDlg('������� �� ����� ���� ���������!' + #13#10 + '��� ������: 33', mtError, [mbOk], 0);
    Result := false;
    exit;
  end;
end;

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

procedure prcBSKBadData(sCardNo : string);
var
  t : string;
begin
  frmKassa.qTemp.Close;
  frmKassa.qTemp.SQL.Clear;
  frmKassa.qTemp.SQL.Add('update card set statecard_id = 2 where nomer =' + sCardNo + '');
  frmKassa.qTemp.ExecSQL;
  frmKassa.qTemp.SQL.Clear;
  frmKassa.qTemp.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, pers_id, memo) ');
  frmKassa.qTemp.SQL.Add('values(Now(), 11, ' + CurrentCardId + ',' + CurrentPersId + ', ' + sCardNo + ' )');
  frmKassa.qTemp.ExecSQL;
  //��������� ���� �� ��� - ��� �������������
  Val[11] := 66; //
  fncWriteInCard(CardNo, Sector, Block, Val, t);
end;

end.
