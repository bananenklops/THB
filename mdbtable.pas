unit mDbTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbCon, DB, fgl;

type

  TKeyValue = specialize TFPGMap<string, string>;

  { TDbTable }

  TDbTable = class abstract(TObject)

  protected
    query: string;
    FDb: TDbCon;
  public

    procedure createTable; virtual; abstract;
    procedure addEntry(values: TKeyValue); virtual; abstract;
    procedure updateEntry; virtual; abstract;
    procedure deleteEntry; virtual; abstract;
    function getEntries: TParams; virtual; abstract;

    constructor Create;
    destructor Destroy; override;
  published
  end;

  { TItem }

  TItem = class(TDbTable)

  private

  public

    procedure createTable; override;
    procedure addEntry(values: TKeyValue); override;
    procedure updateEntry; override;
    procedure deleteEntry; override;
    function getEntries: TParams; override;
  end;

implementation

// Constructor
constructor TDbTable.Create;
begin
  FDb := TdbCon.Create('./haushalt.db');
  self.createTable;

  inherited Create;
end;

// Destructor
destructor TDbTable.Destroy;
begin
  FDb.Free;

  inherited Destroy;
end;

{ TItem }
procedure TItem.createTable;
begin
  query :=
    'CREATE TABLE IF NOT EXISTS tblReceipt ' +
    '(receipt_id INTEGER AUTO_INCREMENT, ' +
    'description VARCHAR(200) NOT NULL, ' + 'amount DOUBLE(20) NOT NULL, ' +
    'category_id INTEGER DEFAULT 1, ' + 'receipt_date DATETIME, ' +
    'creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
    'PRIMARY KEY (receipt_id), ' +
    'FOREIGN KEY (category_id) REFERENCES tblCategory(category_id) ' + ');';
  FDb.execQuery(query);
end;

procedure TItem.addEntry(values: TKeyValue);
var
  desc, amount, category, date: String;
begin
  desc := values.KeyData['description'];
  amount := values.KeyData['amount'];
  category := values.KeyData['category'];
  date := values.KeyData['date'];
  query :=
    'INSERT INTO tblReceipt (description, amount, category_id, receipt_date) ' +
    'VALUES ("'+desc+'", "'+amount+'", "'+category+'", "'+date+'");';
  FDb.execQuery(query);
end;

procedure TItem.updateEntry;
begin

end;

procedure TItem.deleteEntry;
begin

end;

function TItem.getEntries: TParams;
begin
  Result := nil;
end;

end.
