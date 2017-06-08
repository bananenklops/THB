unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, fNewItem, fNewCategory, mDbTable, mRecord, LCLIntf, LCLType,
  ComCtrls;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnNewItem: TButton;
    btnNewCategory: TButton;
    liv_items: TListView;
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
const
  MAX_TABS = 4;
  Tab = #32;
var
  item: TItemRecord;
  size, i: integer;
  categoryString: string;
  Tabulators: array[0..MAX_TABS] of Integer;
  li: TListItem;
begin
  Tabulators[0] := 70;
  Tabulators[1] := 120;
  Tabulators[2] := 100;
  Tabulators[3] := 80;
  //lis_items.TabWidth := 1;
  //SendMessage(lis_items.Handle, LBS_, MAX_TABS, Longint(@Tabulators));
  FItemTable.getEntries;

  size := FItemTable.RecordList.Count;

  liv_items.Clear;
  for i := 0 to (size - 1) do
  begin
    item := TItemRecord(FItemTable.RecordList.Items[i]);
    categoryString := FCategoryTable.getCategoryStringById(item.Category);

    li:=liv_items.Items.Add;
    li.Caption:=item.Description;
    li.SubItems.Add(categoryString);
    li.SubItems.Add(DateToStr(item.Date));
    li.SubItems.Add(item.Amount.ToString);

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
