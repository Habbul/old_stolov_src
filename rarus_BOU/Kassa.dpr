program Kassa;

{%File 'Mifare.dll'}

uses
  Forms,
  Dialogs,
  Controls,
  SysUtils,
  untKassa in 'untKassa.pas' {frmKassa},
  untMifareDll in 'untMifareDll.pas',
  untGlobalVar in 'untGlobalVar.pas';

{$R *.res}

begin
  Application.Initialize;
  CurDirPuth := GetCurrentDir;
  Application.Title := 'Безналичная оплата';
  Application.CreateForm(TfrmKassa, frmKassa);
  Application.Run;
end.
