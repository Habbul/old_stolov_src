unit untMifareDll;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

const
  Certificate = '001DC059';

  KEY_A = $00;
  KEY_B = $04;
  KEY_SET0 = $00;
  KEY_SET1 = $01;
  KEY_SET2 = $02;

  MODE_IDLE = $00;
  MODE_ALL = $01;

  MIFARE_OK = 0;

// ==============
// === Errors ===
// ==============

  MIFARE_NOTAGERR   =      1;
  MIFARE_CRCERR     =      2;
  MIFARE_EMPTY      =      3;
  MIFARE_AUTHERR    =      4;
  MIFARE_PARITYERR  =      5;
  MIFARE_CODEERR    =      6;
  MIFARE_SERNRERR   =      8;
  MIFARE_NOTAUTHERR =      10;
  MIFARE_BITCOUNTERR=      11;
  MIFARE_BYTECOUNTERR=     12;
  MIFARE_IDLE       =      13;
  MIFARE_TRANSERR   =      14;
  MIFARE_WRITEERR   =      15;
  MIFARE_INCRERR    =      16;
  MIFARE_DECRERR    =      17;
  MIFARE_READERR    =      18;
  MIFARE_QUIT       =      30;
  MIFARE_PARMERR    =      94;
  MIFARE_STRERR     =      97;
  MIFARE_BREAK      =      99;
  MIFARE_NY_IMPLEMENTED=   100;
  TCL_CARD_PROTOCOL_ERROR= 120;
  TCL_LENTH_TOO_LARGE=     121;
  MIFARE_SERERR     =      255;
  MIFARE_ERROR      =      (-1);

  DllName = 'c:\Kassa\Mifare.dll';
  PuthFolder = 'c:\Kassa';
  function MifareCardSerialNoGet(CardSerialNo : PDWord) : integer; stdcall;
  function MifareSessionOpen(MCADCertificate : PChar; PortNo : byte) : integer; stdcall;
  function MifareSessionOpen1(MCADCertificate : PChar) : integer; stdcall;
//           MifareSessionOpen1(BYTEP MCADCertificate);
  function MifareSessionOpen2(MCADCertificate : PChar; PortNo : byte) : integer; stdcall;
//  function MifareSessionOpen2(MCADCertificate : PChar) : integer; stdcall;
  function MifareSessionClose : integer; stdcall;
  function MifareValueRead(SectorNo, BlockNo : Byte; Value : PDWord; Address : PChar) : integer; stdcall;
  function MifareLoadKeyIntoReader(AuthenticationMode, SectorNo : Byte; Key : PChar) : integer; stdcall;
  function MifareCardRequest(RequestMode : byte) : integer; stdcall;
  function MifareAnticollision(CardSerialNo:PDWord) : integer; stdcall;
  function MifareCardSelect(CardSerialNo : DWORD) : integer; stdcall;
  function MifareSectorAuthentication(AuthenticationMode, SectorNo : BYTE) : integer; stdcall;
  function MifareBlockRead(SectorNo, BlockNo : BYTE; OutputData : PChar) : integer; stdcall;
  function MifareBlockWrite(SectorNo, BlockNo : BYTE; InputData : PChar) : integer; stdcall;
  function MifareCardHalt : integer; stdcall;
  function MifareSectorOpen(RequestMode, AuthenticationMode, SectorNo : Byte; CardSerialNo : PDWord) : integer; stdcall;
  function ConvertValueToBlockData(Value : DWORD; Address : Byte; ValueBlockData : PChar) : integer; stdcall;
  function ConvertBlockDataToValue(ValueBlockData : PChar; Value : PDWORD; Address : PChar) : integer; stdcall;
  function MifareTransfer(SectorNo, BlockNo : BYTE) : integer; stdcall;
  function MifareCounterInitiate(AuthenticationMode : Byte;
                                 SectorNo : Byte;
                                 CounterType : Byte;
                                 CounterUnit : Byte;
                                 CounterValue : DWord;
                                 KeysVersion : Byte;
                                 KeyA : Byte;
                                 KeyB : Byte;
                                 CardSerialNo : PDWord) : integer; stdcall;

implementation

uses untGlobalVar;

function MifareCardSerialNoGet; external DllName name 'MifareCardSerialNoGet';
function MifareSessionOpen; external DllName name 'MifareSessionOpen';
function MifareSessionOpen1; external DllName name 'MifareSessionOpen1';
function MifareSessionOpen2; external DllName name 'MifareSessionOpen2';
function MifareSessionClose; external DllName name 'MifareSessionClose';
function MifareValueRead; external DllName name 'MifareValueRead';
function MifareLoadKeyIntoReader; external DllName name 'MifareLoadKeyIntoReader';
function MifareCounterInitiate; external DllName name 'MifareCounterInitiate';
function MifareCardRequest; external DllName name 'MifareCardRequest';
function MifareAnticollision; external DllName name 'MifareAnticollision';
function MifareCardSelect; external DllName name 'MifareCardSelect';
function MifareSectorAuthentication; external DllName name 'MifareSectorAuthentication';
function MifareBlockRead; external DllName name 'MifareBlockRead';
function MifareBlockWrite; external DllName name 'MifareBlockWrite';
function MifareCardHalt; external DllName name 'MifareCardHalt';
function MifareSectorOpen; external DllName name 'MifareSectorOpen';
function ConvertValueToBlockData; external DllName name 'ConvertValueToBlockData';
function MifareTransfer; external DllName name 'MifareTransfer';
function ConvertBlockDataToValue; external DllName name 'ConvertBlockDataToValue';

end.
