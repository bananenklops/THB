unit fNewCategory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, mDbTable, mRecord, fgl;

type

  { TFormNewCategory }

  TFormNewCategory = class(TForm)
    btnAbort: TButton;
    btnSave: TButton;
    btn_delete: TButton;
    GroupBox1: TGroupBox;
    lblDescription: TLabel;
    lblPriority: TLabel;
    lis_categories: TListBox;
    txtDescription: TEdit;
    txtPriority: TEdit;
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCategory: TCategory;

    procedure loadList;
  public
    property Category: TCategory read FCategory write FCategory;
    { public declarations }
  end;

var
  FormNewCategory: TFormNewCategory;

implementation

{$R *.lfm}

{ TFormNewCategory }

procedure TFormNewCategory.btnSaveClick(Sender: TObject);
type
  TKeyValueList = specialize TFPGMap<string, string>;
var
  kVList: TKeyValueList;
begin
  kVList := TKeyValueList.Create;
  try
    kVList.Add('description', txtDescription.Text);
    kVList.Add('priority', txtPriority.Text);
    Category.addEntry(kVList);
  finally
    if Assigned(kVList) then
      FreeAndNil(kVList);
  end;

  loadList;
  txtDescription.Text := '';
  txtPriority.Text := '';
end;

procedure TFormNewCategory.btn_deleteClick(Sender: TObject);
var
  categoryRecord: TCategoryRecord;
begin
  categoryRecord := TCategoryRecord(lis_categories.Items.Objects[lis_categories.ItemIndex]);
  categoryRecord.deleteRecord;
  loadList;
end;

procedure TFormNewCategory.FormShow(Sender: TObject);
begin
  loadList;
end;

procedure TFormNewCategory.loadList;
var
  size, i: integer;
  categoryRecord: TCategoryRecord;
begin
  Category.getEntries;
  lis_categories.Clear;
  size := Category.RecordList.Count;
  for i := 0 to (size - 1) do begin
    categoryRecord := TCategoryRecord(Category.RecordList[i]);
    lis_categories.AddItem(categoryRecord.Description, categoryRecord);
  end;
end;

procedure TFormNewCategory.btnAbortClick(Sender: TObject);
begin
  Close;
end;

end.
