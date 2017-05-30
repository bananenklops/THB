unit mDbEntry;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mDbCon, DB;

type
  TDbEntry = class abstract(TObject)

  private

    FDb: TDbCon;
  public

    procedure createTable; virtual; abstract;
    procedure addEntry; virtual; abstract;
    procedure updateEntry; virtual; abstract;
    procedure deleteEntry; virtual; abstract;
    function getEntries: TParams; virtual; abstract;

  published
  end;

implementation

end.

