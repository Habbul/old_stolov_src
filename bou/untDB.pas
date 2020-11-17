unit untDB;

interface

uses
  SysUtils, Classes, DB, DBTables, MySQLDataset, untSpravochnik;

type
  TmDB = class(TDataModule)
    qTemp: TMySQLQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mDB: TmDB;

implementation

{$R *.dfm}

end.
