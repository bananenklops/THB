unit fNewItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, mDbTable, mRecord, fgl;

type

  { TFormNewItem }

  TFormNewItem = class(TForm)
    btnSave: TButton;
    btnAbort: TButton;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FItem: TItem;
    FCategory: TCategory;
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
    kVList.Add('category', '1');
    kVList.Add('date', DateTimeToStr(Now));
  finally
    FreeAndNil(kVList);
  end;
  Item.addEntry(kVList);

  Close;
end;

procedure TFormNewItem.FormCreate(Sender: TObject);
begin

end;

procedure TFormNewItem.FormShow(Sender: TObject);
var
  categoryRecord: TCategoryRecord;
  size, i: integer;
begin
  size := FCategory.RecordList.Count;

  for i := 0 to (size - 1) do begin
    categoryRecord := FCategory.RecordList[i] as TCategoryRecord;

    cbbItemCategory.AddItem(categoryRecord.Description, categoryRecord);
  end;
end;

end.

