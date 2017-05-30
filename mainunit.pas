unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs, mReceipt;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    FReceipt: TReceipt;
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
  FReceipt := TReceipt.Create;
end;

end.

