unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fNewItem, fNewCategory, mDbTable;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnNewItem: TButton;
    btnNewCategory: TButton;
    procedure btnNewItemClick(Sender: TObject);
    procedure btnNewCategoryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FformNewItem: TFormNewItem;
    FformNewCategory: TFormNewCategory;
    FItemTable : TItem;
    FCategoryTable : TCategory;
  public
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}


{ TFormMain }

procedure TFormMain.btnNewItemClick(Sender: TObject);
begin
  FformNewItem := TFormNewItem.Create(nil);
  FformNewItem.Item := FItemTable;
  FformNewItem.Category := FCategoryTable;
  FformNewItem.ShowModal;
  FreeAndNil(FformNewItem);
end;

procedure TFormMain.btnNewCategoryClick(Sender: TObject);
begin
  FformNewCategory := TFormNewCategory.Create(nil);
  FformNewCategory.Category := FCategoryTable;
  FformNewCategory.ShowModal;
  FreeAndNil(FformNewCategory);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FItemTable := TItem.Create;
  FCategoryTable := TCategory.Create;
end;

destructor TFormMain.Destroy;
begin
  FreeAndNil(FItemTable);
  FreeAndNil(FCategoryTable);

  inherited Destroy;
end;

end.

