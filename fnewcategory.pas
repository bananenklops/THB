unit fNewCategory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, mDbTable, mRecord, fgl;

type

  { TFormNewCategory }

  TFormNewCategory = class(TForm)
    btnAbort: TButton;
    btnSave: TButton;
    btn_delete: TButton;
    GroupBox1: TGroupBox;
    lblDescription: TLabel;
    lblPriority: TLabel;
    liv_categories: TListView;
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
  li: TListItem;
begin
  li := liv_categories.Selected;
  categoryRecord := TCategoryRecord(li.SubItems.Objects[1]);
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
  li: TListItem;
begin
  Category.getEntries;
  liv_categories.Clear;
  size := Category.RecordList.Count;
  for i := 0 to (size - 1) do begin
    categoryRecord := TCategoryRecord(FCategory.RecordList.Items[i]);
    li:=liv_categories.Items.Add;
    li.Caption:=categoryRecord.Description;
    li.SubItems.Add(categoryRecord.Priority.ToString);
    li.SubItems.AddObject('Obj',categoryRecord);
  end;
end;

procedure TFormNewCategory.btnAbortClick(Sender: TObject);
begin
  Close;
end;

end.
