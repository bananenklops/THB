unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs, mDbCon;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    FDb: TDbCon;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{
begin

end;
}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  FDb := TDbCon.Create('.\haushalt.db');
end;

end.
