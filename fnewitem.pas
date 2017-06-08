unit fNewItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, mDbTable, mRecord, fNewCategory, fgl;

type

  { TFormNewItem }

  TFormNewItem = class(TForm)
    btnSave: TButton;
    btnAbort: TButton;
    btn_addCategory: TButton;
    cbbItemCategory: TComboBox;
    dtpItemDate: TDateTimePicker;
    txtItemDesc: TEdit;
    txtItemAmount: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btn_addCategoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FItem: TItem;
    FCategory: TCategory;
    FNewCategory: TFormNewCategory;

    procedure loadDropDown;
  public
    property Item: TItem read FItem write FItem;
    property Category: TCategory read FCategory write FCategory;
  end;

var
  FormNewItem: TFormNewItem;

implementation

{$R *.lfm}

{ TFormNewItem }

procedure TFormNewItem.btnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFormNewItem.btnSaveClick(Sender: TObject);
type
  TKeyValueList = specialize TFPGMap<string, string>;
var
  kVList: TKeyValueList;
begin
  kVList := TKeyValueList.Create;
  try
    kVList.Add('description', txtItemDesc.Text);
    kVList.Add('amount', txtItemAmount.Text);
    kVList.Add('category', TCategoryRecord(
      cbbItemCategory.Items.Objects[cbbItemCategory.ItemIndex]).Id.ToString);
    kVList.Add('date', DateToStr(dtpItemDate.Date));
    Item.addEntry(kVList);
  finally
    if Assigned(kVList) then
      FreeAndNil(kVList);
  end;

  Close;
end;

procedure TFormNewItem.btn_addCategoryClick(Sender: TObject);
begin
  FNewCategory := TFormNewCategory.Create(nil);
  FNewCategory.Category := FCategory;
  FNewCategory.ShowModal;
  loadDropDown;
end;

procedure TFormNewItem.FormCreate(Sender: TObject);
begin

end;

procedure TFormNewItem.FormShow(Sender: TObject);
begin
  dtpItemDate.Date := now;
  loadDropDown;
end;

procedure TFormNewItem.loadDropDown;
var
  size, i: integer;
  categoryRecord: TCategoryRecord;
begin
  cbbItemCategory.Clear;
  FCategory.getEntries;

  size := FCategory.RecordList.Count;
  for i := 0 to (size - 1) do
  begin
    categoryRecord := TCategoryRecord(FCategory.RecordList.Items[i]);
    cbbItemCategory.AddItem(categoryRecord.Description, categoryRecord);
  end;
end;

end.
