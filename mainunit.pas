unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fNewItem;

type

  { TFormMain }

  TFormMain = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    formNewItem: TFormNewItem;
  public
    { public declarations }
  end;

var
  Form1: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.Button1Click(Sender: TObject);
begin
  formNewItem:=TFormNewItem.Create(nil);
  formNewItem.ShowModal;
  FreeAndNil(formNewItem);
end;

end.

