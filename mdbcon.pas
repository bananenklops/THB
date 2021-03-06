unit mDbCon;

{$mode objfpc}{$H+}

interface

uses
  sqlite3conn, sqldb, SysUtils, RegExpr, Dialogs, DB, Classes;

type
  TDbCon = class(TObject)
  private

    FdbCon: TSQLite3Connection;
    FdbTrans: TSQLTransaction;
  public

    constructor Create(db: string);
    destructor Destroy; override;
    procedure execQuery(dbQuery: TSQLQuery);
    function selectQuery(dbQuery: TSQLQuery): TSQLQuery;
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
      FdbCon := TSQLite3Connection.Create(nil);
      FdbTrans := TSQLTransaction.Create(nil);

      FdbCon.DatabaseName := db;
      FdbTrans.DataBase := FdbCon;

      FdbCon.Open;
      if not FdbCon.Connected then
        ShowMessage('database connection could not be established');
      FdbCon.Close;
    end
    else
    begin
      ShowMessage('database file not valid');
    end;
  finally
    if Assigned((RegexObj)) then
      FreeAndNil(RegexObj);
  end;

  // Constructor von Elternobjekt ausführen:
  inherited Create;
end;

// Destructor
destructor TDbCon.Destroy;
begin
  if Assigned(FdbCon) then
    FreeAndNil(FdbCon);
  if Assigned(FdbTrans) then
    FreeAndNil(FdbTrans);

  inherited Destroy;
end;

procedure TDbCon.execQuery(dbQuery: TSQLQuery);
begin
  try

    // Verbindung herstellen
    FdbCon.Open;

    // Query ausfuehren
    dbQuery.Transaction := FdbTrans;
    FdbTrans.Active := True;

    dbQuery.ExecSQL;
    FdbTrans.Commit;
    FdbTrans.Active := False;

    // Verbindung schliessen
    FdbCon.Close;
  except
    on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

function TDbCon.selectQuery(dbQuery: TSQLQuery): TSQLQuery;
begin
  try
    // Verbindung herstellen
    FdbCon.Open;

    // Query ausfuehren
    dbQuery.DataBase := FdbCon;

    // Verbindung schliessen
    FdbCon.Close;

    // Daten in Variable speichern
    Result := dbQuery;

  except
    on E: EDatabaseError do
    begin
      MessageDlg('Error', 'A database error has occurred. Technical error message: ' +
        E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.
