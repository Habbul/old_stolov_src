unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, Spin, Grids, untMifareDll,
  untGlobalVar, Math, ComCtrls, DB, MySQLDataset, DBGridEh, GridsEh,
  DBGridEhGrouping;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    edSect: TEdit;
    Label4: TLabel;
    edBlock: TEdit;
    Button1: TButton;
    btnReadCard: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    Bevel1: TBevel;
    edLimit: TEdit;
    Label7: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    edInvOst: TEdit;
    edOst: TEdit;
    edYear: TEdit;
    edMonth: TEdit;
    Label8: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button4: TButton;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    btnReport: TBitBtn;
    BitBtn1: TBitBtn;
    btnNumCard: TButton;
    Bevel2: TBevel;
    DBGridEh1: TDBGridEh;
    qRequest: TMySQLQuery;
    Button3: TButton;
    mRequest: TMemo;
    dsRequest: TDataSource;
    lCardNo: TLabel;
    TabSheet3: TTabSheet;
    Memo2: TMemo;
    GroupBox1: TGroupBox;
    Button6: TButton;
    GroupBox2: TGroupBox;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    Button5: TButton;
    Edit1: TEdit;
    qHistoryEvent: TMySQLQuery;
    dsHistoryEvent: TDataSource;
    Edit2: TEdit;
    Label3: TLabel;
    Button7: TButton;
    Label5: TLabel;
    Fio1: TLabel;
    qSelPers: TMySQLQuery;
    procedure btnExitClick(Sender: TObject);
    procedure btnNumCardClick(Sender: TObject);
    procedure btnReadCardClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  frmMain: TfrmMain;
  PC : PChar;
//  Certificate : PChar;
  DW : DWORD;
  PDW : PDWORD;
implementation

uses untSpravochnik;

{$R *.dfm}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  close;  //sleep(1);
end;

procedure TfrmMain.btnNumCardClick(Sender: TObject);
begin
  Memo1.Lines.Add(' --- ������ ������ ����� --- ');
  DW := 0;
  MifareCardSerialNoGet(@DW);
  Memo1.Lines.Add(' � ����� = ' + IntToStr(DW));
end;

procedure TfrmMain.btnReadCardClick(Sender: TObject);
var
  text : string;
  i    : integer;
begin
   Memo1.Lines.Add(' --- ������ ������ � ����� --- ');

  MifareCardSerialNoGet(@DW);
  Memo1.Lines.Add(' � ����� = ' + IntToStr(DW));
  // ����� ������������ ������ (���, ���.�����) ��������� ���
   CardNo := 0;
  MessageDlg('��������� ��� � �����������, � �� �������� �� ���������� ��������!', mtInformation, [mbOk], 0);
  a := MifareCardRequest(MODE_ALL);  // request
  a := MifareAnticollision(@CardNo); // anticollision
  a := MifareCardSelect(CardNo);     // select card
  case a of
    Mifare_Ok :
    begin
      AuthentMode := Key_A or Key_Set0; // autentication
      a := MifareSectorAuthentication(AuthentMode, Sector);
      end;
    end;
   frmMain.qSelPers.Close;
   frmMain.qSelPers.SQL.Clear;
   frmMain.qSelPers.SQL.Add('select concat(p.family, ' + ''' ''' + ' , p.name, ' + ''' ''' + ' , p.parentname) ');
   frmMain.qSelPers.SQL.Add('as persname, p.tabnum as tabnum, c.card_id as cardid, p.pers_id as persid, p.flagkredita as fk');
   frmMain.qSelPers.SQL.Add('from beznal.card c ');
   frmMain.qSelPers.SQL.Add('left join pers p on (c.card_id = p.card_id) ');
   frmMain.qSelPers.SQL.Add('where c.nomer = ' + IntToStr(CardNo) + ' ');
   frmMain.qSelPers.Execute;
   frmMain.qSelPers.Open;
    case frmMain.qSelPers.RecordCount of              // �� ���������� ������ �������� ������������ ������ �� ����
        0 :  // ������: �� ������� ������ �� ��������� ���
        begin
          MessageDlg('������!' + #13#10 + #13#10 + '�� ������� ������ �� ��������� ���,' +#13#10+'��� ��������� � ���� �����!', mtError, [mbOK], 0);
         a := MifareCardHalt;
          exit;
        end;
     end;
   Fio1.Caption := frmMain.qSelPers.fieldbyname('persname').AsString;


  // request
  a := MifareCardRequest(MODE_ALL);
  Memo1.Lines.Add('MifareCardRequest ' + IntToStr(a));
  // anticollision
  a := MifareAnticollision(@DW);
  Memo1.Lines.Add('MifareAnticollision ' + IntToStr(a));
  // select card
  a := MifareCardSelect(DW);
  Memo1.Lines.Add('MifareCardSelect ' + IntToStr(a));
  // autentication
  AuthentMode := Key_A or Key_Set0;
  a := MifareSectorAuthentication(AuthentMode, StrToInt(edSect.text));
  Memo1.Lines.Add('MifareSectorAuthentication ' + IntToStr(a));

  a := MifareBlockRead(StrToInt(edSect.text), StrToInt(edBlock.text), @Val);
  Memo1.Lines.Add('MifareBlockRead ' + IntToStr(a));

  text := '';
  for i := 0 to 15 do
  begin
    text := text + ' ' + IntToHex(Val[i], 2);
    StringGrid1.Cells[i, 1] := IntToStr(Val[i]);
  end;
  Memo1.Lines.Add('MifareBlockRead = ' + text);

  a := MifareCardHalt;
  Memo1.Lines.Add('MifareCardHalt ' + IntToStr(a));

  edYear.Text := IntToStr(2000 + Val[6]);    // ��������������� �������� ���/����� � ��� � ����
  edMonth.Text := IntToStr(Val[7] div 10);
  if (Val[7] mod 10) = 2 then
    frmMain.RadioButton2.Checked := true;
  edOst.Text    := FloatToStr(RoundTo((HexToInt(IntToHex(Val[0],  2) + IntToHex(Val[1], 2) + IntToHex(Val[2], 2)))/100, -2));
  edLimit.Text  := FloatToStr(RoundTo((HexToInt(IntToHex(Val[3],  2) + IntToHex(Val[4], 2) + IntToHex(Val[5], 2)))/100, -2));
  edInvOst.Text := FloatToStr(RoundTo((HexToInt(IntToHex(Val[10], 2) + IntToHex(Val[9], 2) + IntToHex(Val[8], 2)))/100, -2));
  Edit2.Text:=FloatToStr(StrToFloatDef(edLimit.Text,0)-StrToFloatDef(edOst.Text,0));
  if Val[6] = 0 then
  Label5.Visible := True else  Label5.Visible := False;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  i : integer;
  text : string;
  SectorEd, BlockEd : byte;
begin
  Memo1.Lines.Add(' --- ������ ������ �� ����� --- ');

  SectorEd := StrToInt(edSect.text);
  BlockEd := StrToInt(edBlock.text);

  MifareCardSerialNoGet(@DW);
  Memo1.Lines.Add(' � ����� = ' + IntToStr(DW));

  // request
  a := MifareCardRequest(MODE_ALL);
  Memo1.Lines.Add('MifareCardRequest ' + IntToStr(a));
  // anticollision
  a := MifareAnticollision(@DW);
  Memo1.Lines.Add('MifareAnticollision ' + IntToStr(a));
  // select card
  a := MifareCardSelect(DW);
  Memo1.Lines.Add('MifareCardSelect ' + IntToStr(a));
  // autentication
  AuthentMode := Key_B or Key_Set0;
  a := MifareSectorAuthentication(AuthentMode, Sector);
  Memo1.Lines.Add('MifareSectorAuthentication ' + IntToStr(a));

  text := '';
  for i := 0 to 15 do
  begin
    Val[i] := StrToInt(StringGrid1.Cells[i, 1]);
    text := text + ' ' + IntToHex(Val[i], 2);
  end;
  Memo1.Lines.Add('MifareBlockWrite = ' + text);

//  Val[0] := StrToInt(Edit1.text);
  a := MifareBlockWrite(Sector, Block, @Val);
  Memo1.Lines.Add('MifareBlockWrite ' + IntToStr(a));

  a := MifareCardHalt;
  Memo1.Lines.Add('MifareCardHalt ' + IntToStr(a));
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  a := MifareSectorOpen(MODE_ALL, 0, StrToInt(edSect.text), @DW);
  Memo1.Lines.Add(' --- ��������� ������ � ' + edSect.Text + ' ����� � ' + IntToStr(DW) + ' --- ');
  Memo1.Lines.Add('MifareSectorOpen ' + IntToStr(a));
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to 15 do
  begin
    StringGrid1.Cells[i, 0] := IntToStr(i);
  end;
  IniReader();
  Label5.Visible := False;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  iSumma, iLim  : integer;
  sSumma  : string;
  sLim : string;
  ErrCode : integer;
  Error   : string;
  Sec, Bloc : integer;
  aa : integer;

begin
  iSumma := Round(StrToFloat(frmMain.edOst.text)*100);
  sSumma := IntToHex(iSumma, 6);
  Val[0] := (HexToInt(sSumma[1] + sSumma[2]));  //�������
  Val[1] := (HexToInt(sSumma[3] + sSumma[4]));
  Val[2] := (HexToInt(sSumma[5] + sSumma[6]));

  iLim := Round(StrToFloat(frmMain.edLimit.Text)*100);
  sLim :=  IntToHex(iLim, 6);
  Val[3] := (HexToInt(sLim[1] + sLim[2]));   // �����
  Val[4] := (HexToInt(sLim[3] + sLim[4]));   //
  Val[5] := (HexToInt(sLim[5] + sLim[6]));   //

  Val[7] := StrToInt(edMonth.text)*10 + 1; // ������ - � �������� ������
  if RadioButton2.Checked then
    Val[7] := StrToInt(edMonth.text)*10 + 2; // ������ - � �������� ������

  Val[6] := StrToInt(frmMain.edYear.text)-2000;        // ������ - ���

  Val[8] := (HexToInt(sSumma[5] + sSumma[6])); // �������� �������� ������
  Val[9] := (HexToInt(sSumma[3] + sSumma[4])); //
  Val[10] := (HexToInt(sSumma[1] + sSumma[2])); //
  Sec := StrToInt(edSect.text);
  Bloc := StrToInt(edBlock.text);
//  fncWriteInCard(CurrentCardNo, Sec, Bloc, Val, Error);

  MifareCardSerialNoGet(@CardNo);

    aa := MifareCardRequest(MODE_ALL);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // anticollision
    aa := MifareAnticollision(@CardNo);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // select card
    aa := MifareCardSelect(CardNo);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // autentication
    AuthentMode := Key_B or Key_Set0;
    aa := MifareSectorAuthentication(AuthentMode, Sec);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    //������ �� �����
      aa := MifareBlockWrite(Sec, Bloc, @Val);
      if aa <> MIFARE_OK then

    begin
      exit;
    end;

   // ������������ �����
    aa := MifareCardHalt;
    if aa <> MIFARE_OK then
    begin
      exit;
    end;
  frmMain.edOst.Clear;
  frmMain.edInvOst.Clear;
  frmMain.edYear.Clear;
  frmMain.edMonth.Clear;
  frmMain.edLimit.Clear;
  frmMain.edit2.Clear;
  frmMain.RadioButton1.Checked := true;
  end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  StrRequest : string;
begin
  StrRequest := 'SELECT h.opertime, e.eventname, h.memo, p.family FROM historyevents h' + #13#10 +
                'left join eventstab e on h.event_id=e.event_id' + #13#10 +
                'left join pers p on (h.card_id=p.card_id)' + #13#10 +
                'order by opertime';
  frmMain.mRequest.Text := StrRequest;
  frmMain.qRequest.Close;
  frmMain.qRequest.SQL.Clear;
  frmMain.qRequest.SQL.Add(StrRequest);
  frmMain.qRequest.Open;          
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  a := MifareSessionClose;              // ��������� ������ ������ � ������
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
 if CheckBox1.Checked then
 begin
  edLimit.Text:='0';
  edOst.Text:='0';
  edinvOst.Text:='0';
  Edit2.Text:='0';
  edYear.Text:='0';
  edMonth.Text:='0';
 end;
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  iSumma, iLim  : integer;
  sSumma  : string;
  sLim : string;
  ErrCode : integer;
  Error   : string;
  Sec, Bloc : integer;
  aa : integer;
begin
  iSumma := Round(0*100);
  sSumma := IntToHex(iSumma, 6);
  Val[0] := (HexToInt(sSumma[1] + sSumma[2]));  //�������
  Val[1] := (HexToInt(sSumma[3] + sSumma[4]));
  Val[2] := (HexToInt(sSumma[5] + sSumma[6]));

  iLim := Round(0*100);
  sLim :=  IntToHex(iLim, 6);
  Val[3] := (HexToInt(sLim[1] + sLim[2]));   // �����
  Val[4] := (HexToInt(sLim[3] + sLim[4]));   //
  Val[5] := (HexToInt(sLim[5] + sLim[6]));   //

  Val[7] := 0*10 + 1; // ������ - � �������� ������
  if RadioButton2.Checked then
    Val[7] := 0*10 + 2; // ������ - � �������� ������

  Val[6] := 0;        // ������ - ���

  Val[8] := (HexToInt(sSumma[5] + sSumma[6])); // �������� ��������� ������
  Val[9] := (HexToInt(sSumma[3] + sSumma[4])); //
  Val[10] := (HexToInt(sSumma[1] + sSumma[2])); //
  Sec := StrToInt(edSect.text);
  Bloc := StrToInt(edBlock.text);
//  fncWriteInCard(CurrentCardNo, Sec, Bloc, Val, Error);

  MifareCardSerialNoGet(@CardNo);

    aa := MifareCardRequest(MODE_ALL);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // anticollision
    aa := MifareAnticollision(@CardNo);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // select card
    aa := MifareCardSelect(CardNo);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    // autentication
    AuthentMode := Key_B or Key_Set0;
    aa := MifareSectorAuthentication(AuthentMode, Sec);
    if aa <> MIFARE_OK then
    begin
      exit;
    end;

    //������ �� �����
      aa := MifareBlockWrite(Sec, Bloc, @Val);
      if aa <> MIFARE_OK then

    begin
      exit;
    end;

   // ������������ �����
    aa := MifareCardHalt;
    if aa <> MIFARE_OK then
    begin
      exit;
    end;
  frmMain.edOst.Clear;
  frmMain.edInvOst.Clear;
  frmMain.edYear.Clear;
  frmMain.edMonth.Clear;
  frmMain.edLimit.Clear;
  frmMain.edit2.Clear;
  frmMain.RadioButton1.Checked := true;
  ShowMessage('��� ������������� �������');
end;

end.



