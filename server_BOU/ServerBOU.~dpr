program ServerBOU;

{%File 'Mifare.dll'}

uses
  Forms,
  Dialogs,
  Controls,
  SysUtils,
  untChanPrava in 'untChanPrava.pas' {frmChangePrava},
  untDB in 'untDB.pas' {mDB: TDataModule},
  untDostup in 'untDostup.pas' {frmDostup},
  untExport2 in 'untExport2.pas' {frmExport2},
  untFirst in 'untFirst.pas' {frmFirst},
  untInFlash in 'untInFlash.pas' {frmInFlash},
  untGlobalVar in 'untGlobalVar.pas',
  untLogo in 'untLogo.pas' {frmLogo},
  untMain in 'untMain.pas' {frmMain},
  untMifareDll in 'untMifareDll.pas',
  untReport in 'untReport.pas' {frmExport},
  untSpravochnik in 'untSpravochnik.pas' {frmSpr},
  untStop in 'untStop.pas' {frmStopList},
  untThread in 'untThread.pas',
  untUpdate in 'untUpdate.pas' {frmUpdate},
  untUpdateNew in 'untUpdateNew.pas' {frmUpdateNew},
  untFromFlash in 'untFromFlash.pas' {frmFromFlash},
  untSaleOfDay in 'untSaleOfDay.pas' {frmSaleOfDay},
  unt_OverCredit in 'unt_OverCredit.pas' {Frm_OverCredit};

{$R *.res}

begin
  Application.Initialize;
  CurDirPuth := GetCurrentDir;
//  DllName = CurDirPuth + '\Mifare.dll';
  frmLogo := TfrmLogo.Create(Application);
  frmLogo.Show;   // заставка
  frmLogo.Update;
  Application.Title := 'Сервер БОУ';
  Application.CreateForm(TfrmFirst, frmFirst);
  Application.CreateForm(TfrmSpr, frmSpr);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TmDB, mDB);
  Application.CreateForm(TfrmDostup, frmDostup);
  Application.CreateForm(TfrmChangePrava, frmChangePrava);
  Application.CreateForm(TfrmUpdateNew, frmUpdateNew);
  Application.CreateForm(TfrmStopList, frmStopList);
  Application.CreateForm(TfrmExport2, frmExport2);
  Application.CreateForm(TfrmUpdate, frmUpdate);
  Application.CreateForm(TfrmInFlash, frmInFlash);
  Application.CreateForm(TfrmExport, frmExport);
  Application.CreateForm(TfrmFromFlash, frmFromFlash);
  Application.CreateForm(TfrmSaleOfDay, frmSaleOfDay);
  Application.CreateForm(TFrm_OverCredit, Frm_OverCredit);
  frmLogo.Hide;
  frmLogo.Free;
  Application.Run;
end.
