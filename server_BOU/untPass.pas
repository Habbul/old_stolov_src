unit untPass;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, DB, MySQLDataset, MySQLServer;

type
  TfrmPaswrdDlg = class(TForm)
    btnAutent: TBitBtn;
    btnExit: TBitBtn;
    qSelPrava: TMySQLQuery;
    MySQLServer: TMySQLServer;
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAutentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaswrdDlg: TfrmPaswrdDlg;
  sMessage : string;

implementation

uses untFirst, untGlobalVar, untMifareDll, untDostup;

{$R *.dfm}

procedure TfrmPaswrdDlg.btnExitClick(Sender: TObject);
begin
  frmPaswrdDlg.qSelPrava.Close;               // пишем историю: "окончание работы с приложением"
  frmPaswrdDlg.qSelPrava.SQL.Clear;
  frmPaswrdDlg.qSelPrava.SQL.Add('insert into historyevents(opertime, Event_id) values(Now(), 8)');
  frmPaswrdDlg.qSelPrava.Execute;
  frmPaswrdDlg.ModalResult := mrCancel;
end;

procedure TfrmPaswrdDlg.FormShow(Sender: TObject);
begin
  frmPaswrdDlg.qSelPrava.Close;               // пишем историю: "Приложение запущено"
  frmPaswrdDlg.qSelPrava.SQL.Clear;
  frmPaswrdDlg.qSelPrava.SQL.Add('insert into historyevents(opertime, Event_id) values(Now(), 7)');
  frmPaswrdDlg.qSelPrava.Execute;
end;

procedure TfrmPaswrdDlg.btnAutentClick(Sender: TObject);
var
 t : string;
begin
  MessageDlg('Приложите БСК к считывателю!', mtInformation, [mbOK], 0);

  CardNo := 0;
  a := MifareCardSerialNoGet(@CardNo); // ' --- Чтение номера карты --- ');
  case a of
    Mifare_Ok :
    begin
      t := IntToStr(CardNo);

      frmPaswrdDlg.MySQLServer.Connect;

      frmPaswrdDlg.qSelPrava.Close;        // ищем в базе права доступа в систему
      frmPaswrdDlg.qSelPrava.SQL.Clear;
      frmPaswrdDlg.qSelPrava.SQL.Add('select c.nomer, t.typeempl_id as typem, prava.prava_id, concat(p.family, ' + ''' ''' + ' , p.name, ' + ''' ''' + ' , p.parentname) as persname, t.post as pos, e.empl_id as emplid, c.card_id as cardid ');
      frmPaswrdDlg.qSelPrava.SQL.Add('from beznal.card c ');
      frmPaswrdDlg.qSelPrava.SQL.Add('left join beznal.pers p on (c.card_id = p.card_id) ');
      frmPaswrdDlg.qSelPrava.SQL.Add('left join beznal.employee e on (p.pers_id = e.empl_id) ');
      frmPaswrdDlg.qSelPrava.SQL.Add('left join beznal.typeemployers t on (t.typeempl_id = e.typeempl_id) ');
      frmPaswrdDlg.qSelPrava.SQL.Add('left join beznal.pravafortypeemployee pr on (pr.typeempl_id = t.typeempl_id) ');
      frmPaswrdDlg.qSelPrava.SQL.Add('left join beznal.prava on (prava.prava_id = pr.prava_id) ');
      frmPaswrdDlg.qSelPrava.SQL.Add('where t.typeempl_id is not null and c.nomer = ' + t + ' ');
      frmPaswrdDlg.qSelPrava.Execute;
      frmPaswrdDlg.qSelPrava.Open;

      sMessage := frmPaswrdDlg.qSelPrava.FieldByName('persname').AsString + ' - ' + frmPaswrdDlg.qSelPrava.FieldByName('pos').AsString;
      case frmPaswrdDlg.qSelPrava.RecordCount of
        0:
        begin
          frmPaswrdDlg.ModalResult := mrCancel;
          frmPaswrdDlg.qSelPrava.Close;
          frmPaswrdDlg.qSelPrava.SQL.Clear; // пишем историю
          frmPaswrdDlg.qSelPrava.SQL.Add('insert into historyevents(opertime, Event_id, Card_id, memo) ');
          frmPaswrdDlg.qSelPrava.SQL.Add('values(Now(), 6, (select card_id from card where nomer = ' + t + '), ''' + t + ''')');
          frmPaswrdDlg.qSelPrava.Execute;
          MessageDlg('Извините, у Вас отсутствуют права доступа к системе!', mtError, [mbOk], 0);
        end
        else
        begin
          frmPaswrdDlg.ModalResult := mrOk;
        end;
      end;
      frmPaswrdDlg.qSelPrava.Close;
      frmPaswrdDlg.MySQLServer.Disconnect;
    end;
    MIFARE_NOTAGERR :
    begin
      MessageDlg('Ошибка чтения карты - Нет карты в поле антены', mtError, [mbOk], 0);
    end;
    else
    begin
      MessageDlg('Ошибка чтения карты. Код ошибки ' + IntToStr(a), mtError, [mbOk], 0);
    end;
  end;
end;

end.

