unit mDbTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbCon, DB, fgl, mRecord, sqldb, Dialogs;

type

  TKeyValue = specialize TFPGMap<string, string>;
  TRecordList = specialize TFPGObjectList<TRecord>;

  { TDbTable }

  TDbTable = class abstract(TObject)

  protected

    FDbQuery: TSQLQuery;
    FDb: TDbCon;
    tblName: string;
    FRecordList: TRecordList;

    procedure ListItemSave(Sender: TObject);
  public

    procedure createTable; virtual; abstract;
    procedure addEntry(values: TKeyValue); virtual; abstract;
    procedure updateEntry; virtual; abstract;
    procedure deleteEntry; virtual; abstract;
    procedure getEntries; virtual; abstract;
    function getTableName: string;

    property RecordList: TRecordList read FRecordList write FRecordList;

    constructor Create;
    destructor Destroy; override;
  published
  end;

  { TItem }

  TItem = class(TDbTable)

  public

    procedure createTable; override;
    procedure addEntry(values: TKeyValue); override;
    procedure updateEntry; override;
    procedure deleteEntry; override;
    procedure getEntries; override;
  end;

  { TCategory }

  TCategory = class(TDbTable)
  private
    FCategory: TCategoryRecord;
  public
    procedure createTable; override;
    procedure addEntry(values: TKeyValue); override;
    procedure updateEntry; override;
    procedure deleteEntry; override;
    procedure getEntries; override;
  end;

implementation

{ TDbTable }

procedure TDbTable.ListItemSave(Sender: TObject);
var
  lcItem: TItemRecord;
begin
  lcItem := TitemRecord(Sender);
end;


function TDbTable.getTableName: string;
begin
  Result := tblName;
end;

// Constructor
constructor TDbTable.Create;
begin
  FRecordList := TRecordList.Create;
  createTable;

  inherited Create;
end;

// Destructor
destructor TDbTable.Destroy;
begin
  if Assigned(FRecordList) then
    FreeAndNil(FRecordList);

  inherited Destroy;
end;

{ TCategory }

procedure TCategory.createTable;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS tblCategory ' +
        '(category_id INTEGER NOT NULL, ' +
        'description VARCHAR(200) UNIQUE NOT NULL, ' +
        'priority INTEGER(3) NOT NULL DEFAULT 100, ' +
        'creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
        'PRIMARY KEY (category_id));';
      FDb.execQuery(FDbQuery);
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

procedure TCategory.addEntry(values: TKeyValue);
var
  desc, priority: string;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    FDbQuery := TSQLQuery.Create(nil);
    try
      desc := values.KeyData['description'];
      priority := values.KeyData['priority'];

      FDbQuery.SQL.Text :=
        'INSERT INTO tblCategory (description, priority) ' + 'VALUES (:desc, :prio);';
      FDbQuery.ParamByName('desc').AsString := desc;
      FDbQuery.ParamByName('prio').AsInteger := priority.ToInteger;

      FDb.execQuery(FDbQuery);
      getEntries;
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

procedure TCategory.updateEntry;
begin

end;

procedure TCategory.deleteEntry;
begin

end;

procedure TCategory.getEntries;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    FRecordList.Clear;

    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'SELECT * FROM tblCategory';
      FDbQuery := FDb.selectQuery(FDbQuery);
      FDbQuery.Open;

      while not FDbQuery.EOF do
      begin
        FCategory := TCategoryRecord.Create;
        FCategory.Id := FDbQuery.Fields[0].AsInteger;
        FCategory.Description := FDbQuery.Fields[1].AsString;
        FCategory.Priority := FDbQuery.Fields[2].AsInteger;
        FCategory.CreationDateTime := FDbQuery.Fields[3].AsDateTime;

        FRecordList.Add(FCategory);

        FDbQuery.Next;
      end;
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

{ TItem }

procedure TItem.createTable;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS tblItem ' + '(item_id INTEGER NOT NULL, ' +
        'description VARCHAR(200) NOT NULL, ' + 'amount DOUBLE(20) NOT NULL, ' +
        'category_id INTEGER DEFAULT 1, ' + 'item_date DATETIME, ' +
        'creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, ' +
        'PRIMARY KEY (item_id), ' +
        'FOREIGN KEY (category_id) REFERENCES tblCategory(category_id) ' + ');';

      FDb.execQuery(FDbQuery);
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

procedure TItem.addEntry(values: TKeyValue);
var
  desc, amount, category, date: string;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    desc := values.KeyData['description'];
    amount := values.KeyData['amount'];
    category := values.KeyData['category'];
    date := values.KeyData['date'];

    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'INSERT INTO tblItem (description, amount, category_id, item_date) ' +
        'VALUES (:desc, :amount, :category, :date);';
      FDbQuery.ParamByName('desc').AsString := desc;
      FDbQuery.ParamByName('amount').AsCurrency := amount.ToDouble;
      FDbQuery.ParamByName('category').AsInteger := category.ToInteger;
      FDbQuery.ParamByName('date').AsDate := StrToDateTime(date);
      FDb.execQuery(FDbQuery);
      getEntries;
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

procedure TItem.updateEntry;
begin

end;

procedure TItem.deleteEntry;
begin

end;

procedure TItem.getEntries;
var
  itemType: mRecord.TItemType;
  dbRecord: TItemRecord;
begin
  FDb := TdbCon.Create('./haushalt.db');
  try
    FRecordList.Clear;
    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'SELECT * FROM tblItem';
      FDbQuery := FDb.selectQuery(FDbQuery);
      FDbQuery.Open;
      while not FDbQuery.EOF do
      begin
        dbRecord := TItemRecord.Create;
        if (FDbQuery.Fields[2].AsCurrency) < 0 then
          itemType := TItemType.itCosts
        else
          itemType := TItemType.itReceivt;

        dbRecord.Id := FDbQuery.Fields[0].AsInteger;
        dbRecord.Description := FDbQuery.Fields[1].AsString;
        dbRecord.Amount := FDbQuery.Fields[2].AsCurrency;
        dbRecord.Category := FDbQuery.Fields[3].AsInteger;
        dbRecord.Date := FDbQuery.Fields[4].AsDateTime;
        dbRecord.CreationDateTime := FDbQuery.Fields[5].AsDateTime;
        dbRecord.OnSave := @ListItemSave;
        dbRecord.ItemType := itemType;

        FRecordList.Add(dbRecord);

        FDbQuery.Next;
      end;
    finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
  finally
    if Assigned(FDb) then
      FreeAndNil(FDb);
  end;
end;

end.
