unit untFirst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DBTables, DB, XPMan, MySQLDataset,
  ImgList, Grids, DBGrids;

type
  TfrmFirst = class(TForm)
    GroupBox1: TGroupBox;
    btnInFlash: TBitBtn;
    btnFromFlash: TBitBtn;
    Panel1: TPanel;
    btnExit: TBitBtn;
    XPManifest1: TXPManifest;
    qHistory: TMySQLQuery;
    qSelPrava: TMySQLQuery;
    Panel2: TPanel;
    btnUpdateDb: TBitBtn;
    btnExportDB: TBitBtn;
    btnStopList: TBitBtn;
    btnDostup: TBitBtn;
    btnSetting: TBitBtn;
    btnBase: TBitBtn;
    btnUpdateDBOld: TBitBtn;
    GroupBox2: TGroupBox;
    btnSaleOfDay: TBitBtn;
    Label1: TLabel;
    lDateStopList: TLabel;
    Label2: TLabel;
    lDateLastUpd: TLabel;
    Btn_OverCredit: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExitClick(Sender: TObject);
    procedure btnStopListClick(Sender: TObject);
    procedure btnBaseClick(Sender: TObject);
    procedure btnDostupClick(Sender: TObject);
    procedure btnExportDBClick(Sender: TObject);
    procedure btnUpdateDBOldClick(Sender: TObject);
    procedure btnKassaKeyPress(Sender: TObject; var Key: Char);
    procedure btnSettingClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUpdateDbClick(Sender: TObject);
    procedure btnInFlashClick(Sender: TObject);
    procedure btnFromFlashClick(Sender: TObject);
    procedure btnSaleOfDayClick(Sender: TObject);
    procedure Btn_OverCreditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure prcVisibleBTN();
  end;

var
  frmFirst: TfrmFirst;

implementation

uses untGlobalVar, untMifareDll, untMain, untSpravochnik,
  untDostup, untUpdate, untStop, untExport2, IniFiles, untUpdateNew,
  untInFlash, untFromFlash, untSaleOfDay, untLogo, unt_OverCredit;

{$R *.dfm}

procedure TfrmFirst.prcVisibleBTN();
begin
{  frmFirst.btnBase.Enabled := false;
  frmFirst.btnSettings.Enabled := false;
  frmFirst.btnDostup.Enabled := false;
  frmFirst.btnUpdateDB.Enabled := false;
  frmFirst.btnExportDB.Enabled := false;}
  frmSpr.Panel2.Visible := false;
end;

procedure TfrmFirst.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmSpr.qPers.Close;
  frmSpr.qPrava.Close;
  frmSpr.qCard.Close;
  frmSpr.qStateCard.Close;
  frmSpr.qTemp.Close;

//  frmSpr.qHistory.Close;               // пишем историю: "Приложение закрыто"
//  frmSpr.qHistory.SQL.Clear;
//  frmSpr.qHistory.SQL.Add('insert into historyevents(opertime, Event_id) values(Now(), 8)');
//  frmSpr.qHistory.Execute;
end;

procedure TfrmFirst.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFirst.btnStopListClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmStopList.Show;
end;

procedure TfrmFirst.btnBaseClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmSpr.qPers.Open;
  frmSpr.qPrava.Open;
  frmSpr.qStateCard.Open;
  frmSpr.qCard.Open;
  frmSpr.qEmployee.Open;
  frmSpr.qTEmpl.Open;
  frmSpr.tsPers.TabVisible := true;
  frmSpr.tsCard.TabVisible := true;
  frmSpr.tsStateCard.TabVisible := true;
  frmSpr.tsPrava.TabVisible := true;
  frmSpr.tsEmpl.TabVisible := true;
  frmSpr.tsTEmp.TabVisible := true;
  frmSpr.Show;
//  btnBase.Visible := false;
end;

procedure TfrmFirst.btnDostupClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmSpr.tsPers.TabVisible := false;
  frmSpr.tsCard.TabVisible := false;
  frmSpr.tsStateCard.TabVisible := false;
  frmSpr.tsPrava.TabVisible := false;
  frmSpr.tsEmpl.TabVisible := false;
  frmSpr.tsTEmp.TabVisible := false;
  frmDostup.Show;
end;

procedure TfrmFirst.btnExportDBClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmExport2.Show;
end;

procedure TfrmFirst.btnUpdateDBOldClick(Sender: TObject);
begin
  prcVisibleBTN;
  frmUpdate.Show;
end;

procedure TfrmFirst.btnKassaKeyPress(Sender: TObject; var Key: Char);
begin
  ShowMessage(inttostr(ord(key)) + ' ' + key);
end;

procedure TfrmFirst.btnSettingClick(Sender: TObject);
begin
  frmMain.Show;
end;

{function Get7Code(Code:String): String;
var tCode:String;
begin
  tCode:=Code;
  if length(tCode)>7 then tCode:=Copy(tCode,length(tCode)-6,7);
  while length(tCode)<7 do
  begin
  tCode:='0'+tCode;
  end;
   Result:=tCode;
end;

procedure frNoteGetValue(const ParName: string;
  var ParValue: Variant);
var
  BarCode,NCode:string;
  PC:Integer;
  NoteData.Remainder :
begin
  if ParName='Наименование абонента' then ParValue:= NoteData.ClientName;
  if ParName='Адрес абонента' then ParValue:=NoteData.BillAddress;
  if ParName='Номер лицевого счета' then ParValue:=NoteData.AccountNumber;
  if ParName='Сумма к оплате' then begin 
    if NoteData.Remainder<0 then ParValue:=-NoteData.Remainder
                            else ParValue:=0;
  end;
  if ParName='Штрихкод1' then ParValue:='';
  if ParName='Штрихкод2' then ParValue:=''; 
  if ParName='Дата начала периода' then ParValue:=FormatDateTime('DD.MM.YYYY',NoteData.PeriodStart);
  if ParName='Дата конца периода' then ParValue:=FormatDateTime('DD.MM.YYYY',NoteData.PeriodEnd );
  if ParName='Номер квитанции' then ParValue:=NoteData.NoteNumber;
  if ParName='Телефон' then ParValue:=NoteData.Phones;
  if ParName='Срок оплаты' then ParValue:=FormatDateTime(' DD.MM.YYYY ',NoteData.NotePeriod);
  if ParName='Остаток на начало периода' then ParValue:=Abs(NoteData.LastRemainder);
  if ParName='Остаток на конец периода' then ParValue:=Abs(NoteData.Remainder);
  if ParName='Лейбл "Остаток на начало периода"' then begin 
    if NoteData.LastRemainder<0 then ParValue:='Долг абонента на '+FormatDateTime('DD.MM.YYYY',NoteData.PeriodStart)
    else ParValue:='Остаток на '+FormatDateTime('DD.MM.YYYY', NoteData.PeriodStart );
  end;
  if ParName='Лейбл "Остаток на конец периода"' then begin
    if NoteData.Remainder<0 then ParValue:='Долг абонента на '+FormatDateTime('DD.MM.YYYY',NoteData.PeriodEnd+1 )
    else ParValue:='Остаток на '+FormatDateTime('DD.MM.YYYY',NoteData.PeriodEnd);
  end;
  if ParName='Штрихкод1' then begin
    BarCode:='1016001';
    if NoteData.Remainder <0 then BarCode:=BarCode+Format('%8.8d',[Round(-NoteData.Remainder*100)])
                            else BarCode:=BarCode+'00000000';
    ParValue:=BarCode+GetBarCodeCheckSum(BarCode);
  end; 
  if ParName='Штрихкод2' then begin
    //BarCode:=NoteData.AccountNumber;
    //Delete(BarCode,Pos('/',BarCode),1);
    BarCode:=Get7Code(NoteData.AccountNumber);
    NCode:=Get7Code(NoteData.NoteNumber );
    //BarCode:='2'+BarCode+Format('%7.7d',[Round(StrToInt(NoteData.NoteNumber)*100)]);
    BarCode:='2'+BarCode+NCode;
    ParValue:=BarCode+GetBarCodeCheckSum(BarCode);
  end;
  PC:=0; 
  if NoteData.PayDemandNumber<>'' then begin
    if NoteData.WhatToDo=doPrint then PC:=NoteData.PayDemandCount else PC:=1;
  end;
  if ParName='Количество платежных требований' then ParValue:=PC; 
  if ParName='Компания' then ParValue:=NoteData.CompanyName;
  if ParName='Адрес компании' then ParValue:=NoteData.CompanyAddress;
  if ParName='БИК банка получателя' then ParValue:=NoteData.CompanyBankBIK ;
  if ParName='Банк получателя' then ParValue:=NoteData.CompanyBank;
  if ParName='Счет получателя' then ParValue:=NoteData.CompanySettlementAccount;
  if ParName='Счет банка получателя' then ParValue:= NoteData.CompanyCorrAccount;
  if ParName='ИНН получателя' then ParValue:=NoteData.CompanyINN;
  if ParName='Наименование получателя' then ParValue:=NoteData.CompanyName;
end;
 
function TDocumentsFormAbon.GetBarCodeCheckSum(BarCode: string):string;
var
  A,i:Integer;
begin
  if Length(BarCode)<>15 then begin
    Result:='';
    Exit;
  end;
  A:=0;
  for i:=0 to 7 do
    A:=A+StrToInt(BarCode[2*i+1]);
  A:=A*3;
  for i:=1 to 7 do
    A:=A+StrToInt(BarCode[2*i]);
  A:=A mod 10;
  if A>0 then A:=10-A;
  Result:=IntToStr(A);
end;  }

procedure TfrmFirst.FormShow(Sender: TObject);
begin
  tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
  frmFirst.btnBase.Visible := tIniSett.ReadBool('Button', 'Spr', false);
  frmFirst.btnStopList.Visible := tIniSett.ReadBool('Button', 'Stop', false);
  frmFirst.btnDostup.Visible := tIniSett.ReadBool('Button', 'Prava', false);
  frmFirst.btnUpdateDB.Visible := tIniSett.ReadBool('Button', 'DB', false);
  frmFirst.btnExportDB.Visible := tIniSett.ReadBool('Button', 'Ved', false);
  frmFirst.btnSetting.Visible := tIniSett.ReadBool('Button', 'Sett', false);
  frmFirst.btnInFlash.Visible := tIniSett.ReadBool('Button', 'InFlash', false);
  frmFirst.btnFromFlash.Visible := tIniSett.ReadBool('Button', 'FromFlash', false);
  frmFirst.Btn_OverCredit.Visible := tIniSett.ReadBool('Button', 'OverCredit', false);
  TradePoint_id := tIniSett.ReadInteger('Setting', 'TradePoint', 0);
  TradePoint := '';
  tIniSett.Destroy;

  Btn_OverCredit.Caption:='Превышение'+#13+'кредита';
end;

procedure TfrmFirst.btnUpdateDbClick(Sender: TObject);
begin
  frmUpdateNew.Show;
end;

procedure TfrmFirst.btnInFlashClick(Sender: TObject);
begin
  frmInFlash.Show;
end;

procedure TfrmFirst.btnFromFlashClick(Sender: TObject);
begin
  frmFromFlash.show;
end;

procedure TfrmFirst.btnSaleOfDayClick(Sender: TObject);
begin
  frmSaleOfDay.Show;
end;

procedure TfrmFirst.Btn_OverCreditClick(Sender: TObject);
begin
frm_OverCredit.Show;
end;

initialization
  PutchFolderPrj := GetCurrentDir;

end.
