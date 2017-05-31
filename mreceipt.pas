unit mReceipt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbEntry, DB, fgl;

type

  { TReceipt }

  TReceipt = class(TDbEntry)

  private

    description: string;
    amount: double;
    date, category: integer;
  public

    procedure createTable; override;
    procedure addEntry(values: specialize TFPGMap <String,String>); override;
    procedure updateEntry; override;
    procedure deleteEntry; override;
    function getEntries: TParams; override;
  end;

implementation

{ TReceipt }

procedure TReceipt.createTable;
begin
  query :=
    'CREATE TABLE IF NOT EXISTS tblReceipt ' +
    '(receipt_id INTEGER AUTO_INCREMENT NOT NULL, ' +
    'description VARCHAR(200) NOT NULL, ' + 'amount DOUBLE(20) NOT NULL, ' +
    'category_id INTEGER DEFAULT 1, ' + 'date DATETIME DEFAULT NOW(), ' +
    'PRIMARY KEY (receipt_id), ' +
    'FOREIGN KEY (category_id) REFERENCES tblCategory(category_id) ' + ');';
  FDb.execQuery(query);
end;

procedure TReceipt.addEntry(values: specialize TFPGMap <String,String>);
begin
  query :=
    'INSERT INTO ' + 'tblReceipt ' +
    '(description, amount, date, category_id) VALUES' + '("' +
    description + '","' + amount.ToString() + '","' + date.ToString() + '","' + category.ToString() + '");';
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






