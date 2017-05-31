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
  private
    formNewItem: TFormNewItem;
  public
    { public declarations }
  end;

var
  Form1: TFormMain;

implementation

{$R *.lfm}


end.

