unit untChanPrava;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmChangePrava = class(TForm)
    lbAllPrava: TListBox;
    lbSelectPrava: TListBox;
    Button1: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnInSelect: TBitBtn;
    btnInAll: TBitBtn;
    btnAllInSelect: TBitBtn;
    btnSelectInAll: TBitBtn;
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAllInSelectClick(Sender: TObject);
    procedure btnSelectInAllClick(Sender: TObject);
    procedure btnInSelectClick(Sender: TObject);
    procedure btnInAllClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbAllPravaClick(Sender: TObject);
    procedure lbSelectPravaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChangePrava: TfrmChangePrava;

implementation

uses untDostup;

{$R *.dfm}

procedure TfrmChangePrava.Button4Click(Sender: TObject);
begin
  close;
end;

procedure TfrmChangePrava.Button1Click(Sender: TObject);
var
  i : integer;
begin
  frmDostup.qTemp.Close;
  frmDostup.qTemp.SQL.Clear;

  frmDostup.qTemp.SQL.Add('delete from pravafortypeemployee ');
  frmDostup.qTemp.SQL.Add('where typeempl_id = ');
  frmDostup.qTemp.SQL.Add('    (select typeempl_id from typeemployers where post = ''' + frmDostup.dbgTEmpl.Columns[1].Field.AsString + ''') ');

  frmDostup.qTemp.Execute;
  frmDostup.qTemp.Open;

  for i := 0 to frmChangePrava.lbSelectPrava.Count - 1 do
  begin
    frmDostup.qTemp.Close;
    frmDostup.qTemp.SQL.Clear;

    frmDostup.qTemp.SQL.Add('insert into pravafortypeemployee(typeempl_id, prava_id) ');
    frmDostup.qTemp.SQL.Add('values((select typeempl_id from typeemployers where post = ''' + frmDostup.dbgTEmpl.Columns[1].Field.AsString + '''), ');
    frmDostup.qTemp.SQL.Add('       (select prava_id from prava where name = ''' + frmChangePrava.lbSelectPrava.Items.Strings[i] + ''')) ');

    frmDostup.qTemp.Execute;
    frmDostup.qTemp.Open;
  end;

  close;
  frmDostup.dbgTEmpl.OnCellClick(nil);
end;

procedure TfrmChangePrava.FormShow(Sender: TObject);
begin
  frmDostup.qTemp.Close;
  frmDostup.qTemp.SQL.Clear;

{  frmDostup.qTemp.SQL.Add('select pe.prava_id, pe.typeempl_id, pr.name as nam ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pr.prava_id = pe.prava_id) and (pe.typeempl_id = 3) ');
  frmDostup.qTemp.SQL.Add('where pe.typeempl_id is null ');    }

{  frmDostup.qTemp.SQL.Add('select pe.prava_id, pe.typeempl_id, pr.name as nam  ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) ');
  frmDostup.qTemp.SQL.Add('left join typeemployers te on (te.typeempl_id = pe.typeempl_id) ');
  frmDostup.qTemp.SQL.Add('where (te.post <> ''' + frmDostup.ListBox1.Items.Strings[frmDostup.ListBox1.itemindex] + ''') or (pe.typeempl_id is null) ');}

{select pe.prava_id, pe.typeempl_id, pr.name as nam
from prava pr
left join pravafortypeemployee pe on (pr.prava_id = pe.prava_id) and (pe.typeempl_id = 3)
where pe.typeempl_id is null   }

  frmDostup.qTemp.SQL.Add('select pe.prava_id, pe.typeempl_id, pr.name as nam ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) and (pe.typeempl_id = ' + frmDostup.dbgTEmpl.Columns[0].Field.AsString + ') ');
  frmDostup.qTemp.SQL.Add('where (pe.typeempl_id is null) ');
  frmDostup.qTemp.Execute;
  frmDostup.qTemp.Open;

  frmDostup.qTemp.First;
  frmChangePrava.lbAllPrava.Clear;
  while not frmDostup.qTemp.Eof do
  begin
    frmChangePrava.lbAllPrava.Items.Add(frmDostup.qTemp.fieldbyname('nam').AsString);
    frmDostup.qTemp.Next;
  end;

  frmDostup.qTemp.Close;
  frmDostup.qTemp.SQL.Clear;

{  frmDostup.qTemp.SQL.Add('select pe.prava_id, pe.typeempl_id, pr.name as nam  ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) ');
  frmDostup.qTemp.SQL.Add('left join typeemployers te on (te.typeempl_id = pe.typeempl_id) ');
  frmDostup.qTemp.SQL.Add('where (te.post = ''' + frmDostup.ListBox1.Items.Strings[frmDostup.ListBox1.itemindex] + ''')');}

  frmDostup.qTemp.SQL.Add('select pe.prava_id, pe.typeempl_id, pr.name as nam ');
  frmDostup.qTemp.SQL.Add('from prava pr ');
  frmDostup.qTemp.SQL.Add('left join pravafortypeemployee pe on (pe.prava_id = pr.prava_id) ');
  frmDostup.qTemp.SQL.Add('where (pe.typeempl_id = ' + frmDostup.dbgTEmpl.Columns[0].Field.AsString + ')');
  frmDostup.qTemp.Execute;
  frmDostup.qTemp.Open;

  frmDostup.qTemp.First;
  frmChangePrava.lbSelectPrava.Clear;
  while not frmDostup.qTemp.Eof do
  begin
    frmChangePrava.lbSelectPrava.Items.Add(frmDostup.qTemp.fieldbyname('nam').AsString);
    frmDostup.qTemp.Next;
  end;
end;

procedure TfrmChangePrava.btnAllInSelectClick(Sender: TObject);
begin
  frmChangePrava.lbSelectPrava.Items.AddStrings(frmChangePrava.lbAllPrava.Items);
  frmChangePrava.lbAllPrava.Clear;
  frmChangePrava.btnInSelect.Enabled := false;
//  frmChangePrava.btnInAll.Enabled := true;
end;

procedure TfrmChangePrava.btnSelectInAllClick(Sender: TObject);
begin
  frmChangePrava.lbAllPrava.Items.AddStrings(frmChangePrava.lbSelectPrava.Items);
  frmChangePrava.lbSelectPrava.Clear;
  frmChangePrava.btnInAll.Enabled := false;
//  frmChangePrava.btnInSelect.Enabled := true;
end;

procedure TfrmChangePrava.btnInSelectClick(Sender: TObject);
begin
  frmChangePrava.lbSelectPrava.Items.Add(frmChangePrava.lbAllPrava.Items.Strings[frmChangePrava.lbAllPrava.Itemindex]);
  frmChangePrava.lbAllPrava.DeleteSelected;
  frmChangePrava.btnInSelect.Enabled := false;
end;

procedure TfrmChangePrava.btnInAllClick(Sender: TObject);
begin
  frmChangePrava.lbAllPrava.Items.Add(frmChangePrava.lbSelectPrava.Items.Strings[frmChangePrava.lbSelectPrava.Itemindex]);
  frmChangePrava.lbSelectPrava.DeleteSelected;
  frmChangePrava.btnInAll.Enabled := false;
end;

procedure TfrmChangePrava.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmChangePrava.lbAllPrava.Clear;
  frmChangePrava.lbSelectPrava.Clear;
end;

procedure TfrmChangePrava.lbAllPravaClick(Sender: TObject);
begin
  frmChangePrava.btnInSelect.Enabled := true;
  frmChangePrava.btnInAll.Enabled := false;
end;

procedure TfrmChangePrava.lbSelectPravaClick(Sender: TObject);
begin
  frmChangePrava.btnInSelect.Enabled := false;
  frmChangePrava.btnInAll.Enabled := true;
end;

end.
