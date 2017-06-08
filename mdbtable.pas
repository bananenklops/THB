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

    FTableExists: Boolean;

    procedure ListSave(Sender: TObject); virtual; abstract;
    procedure ListDelete(Sender: TObject); virtual; abstract;
  public

    procedure createTable; virtual; abstract;
    procedure addEntry(values: TKeyValue); virtual; abstract;
    procedure updateEntry; virtual; abstract;
    procedure deleteEntry; virtual; abstract;
    procedure getEntries; virtual; abstract;
    function getTableName: string;

    property RecordList: TRecordList read FRecordList write FRecordList;
    property TableExists: Boolean read FTableExists write FTableExists;

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
    procedure ListSave(Sender: TObject); override;
    procedure ListDelete(Sender: TObject); override;
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
    procedure ListSave(Sender: TObject); override;
    procedure ListDelete(Sender: TObject); override;

    function getCategoryStringById(id:integer): string;
  end;

implementation

{ TDbTable }

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
        'SELECT * FROM tblCategory;';
      FDbQuery := FDb.selectQuery(FDbQuery);
      FDbQuery.Open;
      if not FDbQuery.EOF then
        TableExists:=true
      else
        TableExists:=false;
      finally
      if Assigned(FDbQuery) then
        FreeAndNil(FDbQuery);
    end;
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
    if TableExists = false then begin
      FDbQuery := TSQLQuery.Create(nil);
      try
        FDbQuery.SQL.Text :=
          'INSERT INTO tblCategory (description, priority) VALUES ' +
          '(:d1, :p1), ' +
          '(:d2, :p2), ' +
          '(:d3, :p3), ' +
          '(:d4, :p4);';
        FDbQuery.ParamByName('d1').AsString:='Lebensmittel';
        FDbQuery.ParamByName('p1').AsInteger:=200;
        FDbQuery.ParamByName('d2').AsString:='Getränke';
        FDbQuery.ParamByName('p2').AsInteger:=201;
        FDbQuery.ParamByName('d3').AsString:='Kleidung';
        FDbQuery.ParamByName('p3').AsInteger:=300;
        FDbQuery.ParamByName('d4').AsString:='Sonstiges';
        FDbQuery.ParamByName('p4').AsInteger:=400;
        FDb.execQuery(FDbQuery);
      finally
        if Assigned(FDbQuery) then
          FreeAndNil(FDbQuery);
      end;
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
        FCategory.OnSave := @ListSave;
        FCategory.OnDelete := @ListDelete;

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

procedure TCategory.ListSave(Sender: TObject);
begin

end;

procedure TCategory.ListDelete(Sender: TObject);
var
  lcRecord: TRecord;
begin
  lcRecord := TRecord(Sender);
  FDb := TdbCon.Create('./haushalt.db');
  try
    FDbQuery := TSQLQuery.Create(nil);
    try
      FDbQuery.SQL.Text :=
        'DELETE FROM tblCategory ' +
        'WHERE category_id = :id;';
      FDbQuery.ParamByName('id').AsInteger := lcRecord.Id;
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

function TCategory.getCategoryStringById(id: integer): string;
var
  size, i: integer;
  categoryRecord: TCategoryRecord;
begin
  size := FRecordList.Count;
  for i := 0 to (size - 1) do begin
    categoryRecord := TCategoryRecord(FRecordList.Items[i]);
    if not categoryRecord.Id = id then begin
      Continue;
    end else begin
      Result := categoryRecord.Description;
      exit;
    end
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
        dbRecord.OnSave := @ListSave;
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

procedure TItem.ListSave(Sender: TObject);
begin

end;

procedure TItem.ListDelete(Sender: TObject);
begin

end;

end.
