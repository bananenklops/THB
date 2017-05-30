unit mReceipt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbEntry, DB;

type

  { TReceipt }

  TReceipt = class(TDbEntry)

  private


  public

    procedure createTable; override;
    procedure addEntry; override;
    procedure updateEntry; override;
    procedure deleteEntry; override;
    function getEntries: TParams; override;
  end;

implementation

{ TReceipt }

procedure TReceipt.createTable;
var
  query: string;
begin
  query :=
    'CREATE TABLE IF NOT EXISTS tblReceipt ' +
    '(receipt_id INTEGER AUTO_INCREMENT NOT NULL, ' +
    'description VARCHAR(200) NOT NULL, ' + 'amount DOUBLE(20) NOT NULL, ' +
    'category_id INTEGER DEFAULT 1, ' +
    'PRIMARY KEY (receipt_id), ' +
    'FOREIGN KEY (category_id) REFERENCES tblCategory(category_id) ' +
    ');';
  FDb.execQuery(query);
end;

procedure TReceipt.addEntry;
begin

end;

procedure TReceipt.updateEntry;
begin

end;

procedure TReceipt.deleteEntry;
begin

end;

function TReceipt.getEntries: TParams;
begin

end;

end.


