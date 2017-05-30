unit mDbCon;

{$mode objfpc}{$H+}

interface

uses
  sqlite3conn, sqldb, SysUtils, RegExpr, Dialogs, DB, Classes;

type
  TDbCon = class(TObject)
  private

    dbCon: TSQLite3Connection;
    dbTrans: TSQLTransaction;
    dbQuery: TSQLQuery;
  public

    constructor Create(db: string);
    destructor Destroy; override;
    procedure execQuery(query: string);
    procedure updateQuery(table: string; column: string; Value: string;
      whereKey: string; whereValue: string);
    function selectQuery(query:String): TParams;
  protected
  end;

var
  RegexObj: TRegExpr;

implementation

// Constructor
constructor TDbCon.Create(db: string);
begin
  RegexObj := TRegExpr.Create;
  try
    RegexObj.Expression := '^(.+)\.db$';

    if RegexObj.Exec(db) then
    begin
      if FileExists(db) then
      begin
        dbCon := TSQLite3Connection.Create(nil);
        dbTrans := TSQLTransaction.Create(nil);
        dbQuery := TSQLQuery.Create(nil);

        dbCon.DatabaseName := db;
        dbTrans.DataBase := dbCon;
        dbQuery.Transaction := dbTrans;
        dbCon.Open;
        if not dbCon.Connected then
          ShowMessage('database connection could not be established');
        dbCon.Close;
      end
      else
      begin
        ShowMessage('database file not found');
      end;
    end
    else
    begin
      ShowMessage('database file not valid');
    end;
  finally
    RegexObj.Free;
  end;

  // Constructor von Elternobjekt ausführen:
  inherited Create;
end;

// Destructor
destructor TDbCon.Destroy;
begin
  dbCon.Free;
  dbTrans.Free;
  dbQuery.Free;

  inherited Destroy;
end;

procedure TDbCon.execQuery(query: string);
begin
  try
    // Verbindung herstellen
    dbCon.Open;

    // Query ausfuehren
    dbQuery.Close;
    dbQuery.SQL.Text := query;
    dbQuery.ExecSQL;
    dbTrans.Commit;

    // Verbindung schliessen
    dbCon.Close;
  except
    on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TDbCon.updateQuery(table: string; column: string; Value: string;
  whereKey: string; whereValue: string);
begin
  try
    // Verbindung herstellen
    dbCon.Open;

    // Query ausfuehren
    dbQuery.Close;
    dbQuery.SQL.Text :=
      'UPDATE :table SET :column = :value WHERE :whereKey = :whereValue;';
    dbQuery.ParamByName('table').AsString := table;
    dbQuery.ParamByName('column').AsString := column;
    dbQuery.ParamByName('value').AsString := value;
    dbQuery.ParamByName('whereKey').AsString := whereKey;
    dbQuery.ParamByName('whereValue').AsString := whereValue;
    dbQuery.ExecSQL;
    dbTrans.Commit;

    // Verbindung schliessen
    dbCon.Close;
  except
    on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TDbCon.selectQuery(query:String): TParams;
begin
  try
    // Verbindung herstellen
    dbCon.Open;

    // Query ausfuehren
    dbQuery.Close;
    dbQuery.SQL.Text := query;
    dbQuery.Open;

    // Daten in Variable speichern
    Result := dbQuery.Params;

    // Verbindung schliessen
    dbCon.Close;
  except
    on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
