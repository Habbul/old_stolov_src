program SystemBOU;

{%File 'Mifare.dll'}

uses
  Forms,
  Dialogs,
  Controls,
  SysUtils,
  IniFiles,
  untMain in 'untMain.pas' {frmMain},
  untKassa in 'untKassa.pas' {frmKassa},
  untMifareDll in 'untMifareDll.pas',
  untGlobalVar in 'untGlobalVar.pas',
  untFirst in 'untFirst.pas' {frmFirst},
  untSpravochnik in 'untSpravochnik.pas' {frmSpr},
  untDB in 'untDB.pas' {mDB: TDataModule},
  untDostup in 'untDostup.pas' {frmDostup},
  untChanPrava in 'untChanPrava.pas' {frmChangePrava},
  untPass in 'untPass.pas' {frmPaswrdDlg},
  untLogo in 'untLogo.pas' {frmLogo},
  untUpdate in 'untUpdate.pas' {frmUpdate},
  untThread in 'untThread.pas',
  untStop in 'untStop.pas' {frmStopList},
  untExport2 in 'untExport2.pas' {frmExport2},
  untSaleOfDay in 'untSaleOfDay.pas' {frmSaleOfDay};

{$R *.res}
var
  Str : string;
//function fncCheckDate() : boolean; // �������� �� ��������� ���������� �������
//  TradePoint_id := tIniSett.ReadInteger('Setting', 'TradePoint', 1);
//function fncBackUp() : boolean;

function IniReader() : boolean;
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

function fncCheckDate() : boolean; // �������� �� ��������� ���������� �������
begin
  result := true;
  frmPaswrdDlg.qCheckDate.Close;
  frmPaswrdDlg.qCheckDate.SQL.Clear;
  frmPaswrdDlg.qCheckDate.SQL.Add('SELECT max(opertime) as opertime FROM historyevents');
  frmPaswrdDlg.qCheckDate.Open;
  if frmPaswrdDlg.qCheckDate.FieldByName('opertime').AsDateTime > Now() then
    result := false;
  frmPaswrdDlg.qCheckDate.Close;
end;

function fncBackUp() : boolean;
var
  tIniBackUp    : TIniFile;
  BackUp, NameF : string;
begin
  Result := true;
try //���������� ���� � ����� backup � ������������� ����������� ������
  tIniBackUp := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
  frmPaswrdDlg.sqlRootBackUp.Disconnect;
  frmPaswrdDlg.sqlRootBackUp.Port := tIniBackUp.ReadInteger('MySQL', 'Port', 3306);
  frmPaswrdDlg.sqlRootBackUp.Host := tIniBackUp.ReadString('MySQL', 'Host', '');
  frmPaswrdDlg.sqlRootBackUp.DatabaseName := tIniBackUp.ReadString('MySQL', 'DB', '');
  TradePoint_id := tIniBackUp.ReadInteger('Setting', 'TradePoint', 1);
  BackUp := tIniBackUp.ReadString('Setting', 'BackUp', 'c:\');
  NameF := BackUp + IntToStr(TradePoint_id) + '_' + 'BackUp_' + FormatDateTime('yyyymmdd', Now()) + '.bou';
  tIniBackUp.Destroy;
  frmPaswrdDlg.sqlRootBackUp.Connect;
except
  Result := false;
  ShowMessage('������ ��� �������� ��������� �����!');
  frmPaswrdDlg.sqlRootBackUp.Disconnect;
  exit;
end; // ������� BackUp
  if FileExists(NameF) then
    DeleteFile(NameF);
  frmPaswrdDlg.qBackUp.Close;
  frmPaswrdDlg.qBackUp.SQL.Clear;
  frmPaswrdDlg.qBackUp.SQL.Add('select * from beznal.sale');
  frmPaswrdDlg.qBackUp.SQL.Add('into outfile "' + NameF + '"');
  frmPaswrdDlg.qBackUp.Execute(true);
end;

begin
  Application.Initialize;
  Application.Title := '������� ���';
  CurDirPuth := GetCurrentDir;
//  DllName = CurDirPuth + '\Mifare.dll';
  frmLogo := TfrmLogo.Create(Application);
  frmLogo.Show;   // ��������
  frmLogo.Update;
  frmPaswrdDlg := TfrmPaswrdDlg.Create(Application);//.CreateForm(TfrmPaswrdDlg, frmPaswrdDlg);

  // �������� �� ��������� ����
  frmLogo.lAction.Caption := '�������� �� ��������� ����';
  frmLogo.Update;
  if not fncCheckDate then
  begin
    ShowMessage('������ ��� ��������!!! �� ������ ����!!!');
    frmPaswrdDlg.Hide;
    frmPaswrdDlg.Free;
    frmLogo.Hide;
    frmLogo.Free;
    exit;
  end;
  // ������� ��������� ����� ������� sale
  frmLogo.lAction.Caption := '�������� ��������� �����';
  frmLogo.Update;
  fncBackUp();
  // �������� �� � ����� "Basa=d:\�������� �� ���\"
  frmLogo.lAction.Caption := '�������� ����� �� ������������';
  frmLogo.Update;
  if IniReader then
  begin
    frmLogo.Hide;
    frmLogo.Free;
    frmPaswrdDlg.ShowModal;
    if frmPaswrdDlg.ModalResult = mrOk then
    begin
      Str := sMessage;
      frmPaswrdDlg.Hide;
      frmPaswrdDlg.Free;
   Application.CreateForm(TfrmFirst, frmFirst);

    Application.CreateForm(TfrmMain, frmMain);

    Application.CreateForm(TfrmKassa, frmKassa);
  Application.CreateForm(TfrmSpr, frmSpr);
  Application.CreateForm(TmDB, mDB);
  Application.CreateForm(TfrmDostup, frmDostup);
  Application.CreateForm(TfrmChangePrava, frmChangePrava);
  Application.CreateForm(TfrmUpdate, frmUpdate);
  Application.CreateForm(TfrmStopList, frmStopList);
  Application.CreateForm(TfrmExport2, frmExport2);
  Application.CreateForm(TfrmSaleOfDay, frmSaleOfDay);
  Application.Run;
    end
    else
    begin
      frmPaswrdDlg.Hide;
      frmPaswrdDlg.Free;
    end;
  end
  else
  begin
    frmLogo.Hide;
    frmLogo.Free;
  end;
end.
