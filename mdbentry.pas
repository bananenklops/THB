unit mDbEntry;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbCon, DB;

type
  TDbEntry = class(TObject)

  protected

    FDb: TDbCon;
  public

    procedure createTable; virtual; abstract;
    procedure addEntry; virtual; abstract;
    procedure updateEntry; virtual; abstract;
    procedure deleteEntry; virtual; abstract;
    function getEntries: TParams; virtual; abstract;

    constructor Create;
    destructor Destroy; override;
  published
  end;

implementation

  // Constructor
  constructor TDbEntry.Create;
  begin
    FDb := TdbCon.Create('./haushalt.db');
    self.createTable;

    inherited Create;
  end;

  // Destructor
  destructor TDbEntry.Destroy;
  begin
    FDb.Free;

    inherited Destroy;
  end;
end.

