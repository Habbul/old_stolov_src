unit untKassa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, untGlobalVar, untMifareDll, Mask, MySQLDataset,
  DB, MySQLServer, IniFiles;

type
  TfrmKassa = class(TForm)
    qSelPers: TMySQLQuery;
    qSelPerSum: TMySQLQuery;
    qInsSale: TMySQLQuery;
    qTemp: TMySQLQuery;
    MySQLServer: TMySQLServer;
    qHistory: TMySQLQuery;
    Timer1: TTimer;
    DataSource1: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TValueBSK_DB = record
    Year, Month, Day : word;
    Date : TDate;
    iLimit, iOstLim, iInvLim : integer;
    fLimit, fOstLim, fInvLim : real;
    sLimit, sOstLim, sInvLim : string;
  end;

var
  frmKassa: TfrmKassa;
  PosPunct : integer;
//function fncChek():boolean;
function fncNewClient(var Kod, Str, FIO, Summa : string) : boolean;
procedure prcWriteInFile(Kod, Str : string);
implementation

uses ConvUtils, DateUtils, Math;

{$R *.dfm}

function fncNewClient(var Kod, Str, FIO, Summa : string) : boolean;
var
  BSK, DB    : TValueBSK_DB;
  temp, text : string;
  iSumma     : integer;
  SummaInTab : string;
  sSumma     : string;
  ErrCode    : integer;
  Error      : string;
  t          : string;
begin
  Result := false;
  CardNo := 0;
  a := MifareCardRequest(MODE_ALL);  // request
  a := MifareAnticollision(@CardNo); // anticollision
  a := MifareCardSelect(CardNo);     // select card
  case a of
    Mifare_Ok :
    begin
      AuthentMode := Key_A or Key_Set0; // autentication
      a := MifareSectorAuthentication(AuthentMode, Sector);

      // 