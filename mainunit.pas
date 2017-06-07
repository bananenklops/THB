unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fNewItem, fNewCategory, mDbTable, mRecord;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnNewItem: TButton;
    btnNewCategory: TButton;
    lis_items: TListBox;
    procedure btnNewItemClick(Sender: TObject);
    procedure btnNewCategoryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FformNewItem: TFormNewItem;
    FformNewCategory: TFormNewCategory;
    FItemTable: TItem;
    FCategoryTable: TCategory;

    procedure loadItemList;
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
  if Assigned(FformNewItem) then
    FreeAndNil(FformNewItem);
  loadItemList;
end;

procedure TFormMain.btnNewCategoryClick(Sender: TObject);
begin
  FformNewCategory := TFormNewCategory.Create(nil);
  FformNewCategory.Category := FCategoryTable;
  FformNewCategory.ShowModal;
  if Assigned(FformNewCategory) then
    FreeAndNil(FformNewCategory);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FItemTable := TItem.Create;
  FCategoryTable := TCategory.Create;

  loadItemList;

end;

procedure TFormMain.loadItemList;
var
  item: TItemRecord;
  size, i: integer;
begin
  FItemTable.getEntries;

  size := FItemTable.RecordList.Count;

  for i := 0 to (size - 1) do
  begin
    item := TItemRecord(FItemTable.RecordList.Items[i]);
    lis_items.AddItem(item.Description, item);
  end;
end;

destructor TFormMain.Destroy;
begin
  if Assigned(FItemTable) then
    FreeAndNil(FItemTable);
  if Assigned(FCategoryTable) then
    FreeAndNil(FCategoryTable);

  inherited Destroy;
end;

end.
