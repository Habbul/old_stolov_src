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
  Val           : array [0..15] of byte; // массив считанных с карты значений (записываемых на карту)
  Ostatok       : real;
  SummaSpisania : real;
  SelectSpr     : boolean; // режим выбора элемента из справочника
  TypeEmpl_id   : integer; // id должности авторизованного сотрудника
  CurrentCardId : string; // id карты клиента в начале операций на кассе
  CurrentEmplId : string; // id карты сотрудника (кассир, админ, завстоловой и пр.)
  CurrentPersId : string; // id клиента в начале операций
  CurDirPuth    : string; // текущая папка проекта
  bDelimYes     : boolean; // флаг ввода запятой в числе, true - запятая уже есть 
  bMinusYes     : boolean; // флаг ввода "-" в числе, true - минус уже есть 
  tIniSett      : TIniFile;
  TextF         : TextFile;
  PuthFileRarus : string;
  PuthFileReader, DllName : string;
  TradePoint_id : integer; // id пункта продажи
  Empl_id       : integer; // id продавца
function fncIniReader() : boolean;
// * перевод числа из 16СИ в 10СИ *
function HexToInt (Hex : String) : Integer;
// запись массива Value в сектор(блок) SektorN(BlockN) карты с № CurrentCardNo;
function fncWriteInCard(CardN : DWORD; SectorN, BlockN : byte; Value : array of byte; var ErrStr : string) : integer;
procedure prcBSKBadData(sCardNo : string);
procedure prcAddBSKInStopList(InBSK : boolean);// БСК в стоп-лист

implementation

uses
  untKassa;

procedure prcAddBSKInStopList(InBSK : boolean);// БСК в стоп-лист
var
  t : string;
begin
  if InBSK then                         //выставить флаг на БСК - БСК не кредитуема
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
//  a := MifareSessionOpen1(Certificate);     // открываем сессию работы с картой
  a := MifareSessionOpen2(Certificate, 1);     // открываем сессию работы с картой
  if a <> MIFARE_OK then                    // сессия не открыта, код ошибки: 11
  begin
    MessageDlg('Система не может быть загружена!' + #13#10 + 'Код ошибки: 11', mtError, [mbOk], 0);
    Result := false;
    exit;
  end;

  // загрузка ключей
  AuthentMode := Key_A or Key_Set0;  // KeyA := 'D4AA94C4B5E8';
  Key[0] := $D4;
  Key[1] := $AA;
  Key[2] := $94;
  Key[3] := $C4;
  Key[4] := $B5;
  Key[5] := $E8;

  a := MifareLoadKeyIntoReader(AuthentMode, 14, @Key);
  if a <> MIFARE_OK then                    // загрузка ключа А
  begin                                     // ключ не загружен, код ошибки: 22
    MessageDlg('Система не может быть загружена!' + #13#10 + 'Код ошибки: 22', mtError, [mbOk], 0);
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
  if a <> MIFARE_OK then                    // загрузка ключа B
  begin                                     // ключ не загружен, код ошибки: 33
    MessageDlg('Система не может быть загружена!' + #13#10 + 'Код ошибки: 33', mtError, [mbOk], 0);
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

  // считываем № карты исравниваем с CurrentCardNo
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

    // запись на карту
    aa := MifareBlockWrite(SectorN, BlockN, @Val);
    if aa <> MIFARE_OK then
    begin
      result := aa;
      exit;
    end;

    // освобождение карты
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

{  aa := MifareSessionClose;     // закрываем сессию работы с картой
  if aa <> MIFARE_OK then       // сессия не открыта
  begin
    result := aa;
    exit;
  end;    }
finally
end;
end;


// * перевод числа из 16СИ в 10СИ *
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
  //выставить флаг на БСК - БСК заблокирована
  Val[11] := 66; //
  fncWriteInCard(CardNo, Sector, Block, Val, t);
end;

end.
