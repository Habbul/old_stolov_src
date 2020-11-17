unit untFlash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, Buttons, DB, MySQLDataset,
  MySQLServer, IniFiles;

type
  TfrmFlash = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    btnStep1: TBitBtn;
    btnStep3: TButton;
    btnStep2: TButton;
    pbExport: TProgressBar;
    pnlStep1: TPanel;
    lStep1: TLabel;
    Image3: TImage;
    Panel3: TPanel;
    Label4: TLabel;
    pnlStep2: TPanel;
    Image1: TImage;
    lStep2: TLabel;
    seYear: TSpinEdit;
    pnlStep5: TPanel;
    Image4: TImage;
    Label3: TLabel;
    pnlStep3: TPanel;
    Image5: TImage;
    lStep3: TLabel;
    pnlStep4: TPanel;
    Image2: TImage;
    Label5: TLabel;
    btnStep4: TButton;
    qExport: TMySQLQuery;
    qRoot: TMySQLQuery;
    ServerRoot: TMySQLServer;
    cbPunct: TComboBox;
    Panel2: TPanel;
    btnExit: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnStep1Click(Sender: TObject);
    procedure btnStep2Click(Sender: TObject);
    procedure btnStep3Click(Sender: TObject);
    procedure btnStep4Click(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFlash: TfrmFlash;

implementation

uses untGlobalVar;

{$R *.dfm}

procedure TfrmFlash.FormShow(Sender: TObject);
begin
  fncExecSQLFillCB('TradePoint', 'NameTP', frmFlash.cbPunct);
end;

procedure TfrmFlash.btnStep1Click(Sender: TObject);
begin
  prcGetDriv(ListDriv1);
  btnStep1.Visible := false;
  pnlStep1.Visible := false;
  btnStep2.Visible := true;
  pnlStep2.Visible := true;
  frmFlash.pbExport.Position := 10;
  btnExit.Enabled := false;
end;

procedure TfrmFlash.btnStep2Click(Sender: TObject);
begin
  if frmFlash.cbPunct.ItemIndex = -1 then
  begin
    ShowMessage('Выберите точку продажи!');
    exit;
  end;
  btnStep2.Visible := false;
  pnlStep2.Visible := false;
  btnStep3.Visible := true;
  pnlStep3.Visible := true;
  frmFlash.pbExport.Position := 20;
end;

procedure TfrmFlash.btnStep3Click(Sender: TObject);
var
  i,k    : integer;
  sSql : string;
  sDBegin, sDEnd : string;
  Year, Month, DayB, DayE : Word;
  NameF : string;
begin
  frmFlash.pbExport.Position := 30;
  for i := 1 to 6 do
  begin // ждем когда флешка обнаружиться в системе
        // поставить прогресс бар
    sleep(500);
    prcGetDriv(ListDriv2);
    if Length(ListDriv1) < Length(ListDriv2) then break;
    frmFlash.pbExport.Position := 30 + 5 * i;
  end;

  if Length(ListDriv1) < Length(ListDriv2) then
  begin
    for i := 1 to length(ListDriv2) do
    begin
      if Pos(ListDriv2[i], ListDriv1) = 0 then
      begin // обнаружили букву флешки
        FlashButton := ListDriv2[i];

        try //инициализация БД в админовской учетной записи
          tIniSett := TIniFile.Create(PutchFolderPrj + '\Setting.ini');
          frmFlash.ServerRoot.Disconnect;
          frmFlash.ServerRoot.Port := tIniSett.ReadInteger('MySQL', 'Port', 3306);
          frmFlash.ServerRoot.Host := tIniSett.ReadString('MySQL', 'Host', '');
          frmFlash.ServerRoot.DatabaseName := tIniSett.ReadString('MySQL', 'DB', '');
          tIniSett.Destroy;
          frmFlash.ServerRoot.Connect;
        except
          ShowMessage('Ошибка при инициализации базы!');
          frmFlash.ServerRoot.Disconnect;
          exit;
        end;
        k := Round((frmFlash.pbExport.Max - frmFlash.pbExport.Position)/7);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;

        // перед выгрузкой удалить с флешки файлы card.xls, pers.xls, credits.xls
        NameF := FlashButton + ':\card.xls';
        if FileExists(NameF) then
          DeleteFile(NameF);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;
        // берем таблицу card
        frmFlash.qExport.Close;
        frmFlash.qExport.SQL.Clear;
        frmFlash.qExport.SQL.Add('SELECT * FROM beznal.card');
        frmFlash.qExport.SQL.Add('where statecard_id=1');
        frmFlash.qExport.SQL.Add('into outfile "' + NameF + '"');
        frmFlash.qExport.Execute(true);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;
        // берем таблицу pers
        NameF := FlashButton + ':\pers.xls';
        if FileExists(NameF) then
          DeleteFile(NameF);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;

        frmFlash.qExport.Close;
        frmFlash.qExport.SQL.Clear;
        frmFlash.qExport.SQL.Add('SELECT * FROM beznal.pers');
        frmFlash.qExport.SQL.Add('where flagkredita=1');
        frmFlash.qExport.SQL.Add('into outfile "' + NameF + '"');
        frmFlash.qExport.Execute(true);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;
        // берем таблицу credits
        NameF := FlashButton + ':\credits.xls';
        if FileExists(NameF) then
          DeleteFile(NameF);

        frmFlash.pbExport.Position := frmFlash.pbExport.Position + k;

        frmFlash.qExport.Close;
        frmFlash.qExport.SQL.Clear;
        frmFlash.qExport.SQL.Add('SELECT * FROM beznal.credits');
        frmFlash.qExport.SQL.Add('into outfile "' + NameF + '"');
        frmFlash.qExport.Execute(true);

        pnlStep4.Visible := true;
        btnStep4.Visible := true;
        btnStep3.Visible := false;
        pnlStep3.Visible := false;
        frmFlash.pbExport.Position := frmFlash.pbExport.Max;
        break;
      end;
    end;
  end
  else
  begin
    frmFlash.pbExport.Position := frmFlash.pbExport.Max;
    ShowMessage('Не обнаружена флешка, попробуйте начать заново!');
    pnlStep1.Visible := true;
    btnStep1.Visible := true;
    btnStep3.Visible := false;
    pnlStep3.Visible := false;
    frmFlash.pbExport.Position := frmFlash.pbExport.Min;
  end;
  frmFlash.ServerRoot.Disconnect;
  btnExit.Enabled := true;
end;

procedure TfrmFlash.btnStep4Click(Sender: TObject);
begin
  pnlStep1.Visible := true;
  btnStep1.Visible := true;
  btnStep3.Visible := false;
  pnlStep3.Visible := false;
  btnStep4.Visible := false;
  pnlStep4.Visible := false;
  frmFlash.pbExport.Position := frmFlash.pbExport.Min;
  frmFlash.cbPunct.Text := '';
  frmFlash.cbPunct.ItemIndex := -1;
end;

procedure TfrmFlash.btnExitClick(Sender: TObject);
begin
  close;
end;

end.
