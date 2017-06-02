unit fNewCategory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, mDbTable, fgl;

type

  { TFormNewCategory }

  TFormNewCategory = class(TForm)
    btnAbort: TButton;
    btnSave: TButton;
    lblDescription: TLabel;
    lblPriority: TLabel;
    txtDescription: TEdit;
    txtPriority: TEdit;
    procedure btnAbortClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    FCategory: TCategory;
  public
    property Category : TCategory read FCategory write FCategory;
    { public declarations }
  end;

var
  FormNewCategory: TFormNewCategory;

implementation

{$R *.lfm}

{ TFormNewCategory }

procedure TFormNewCategory.btnSaveClick(Sender: TObject);
type
  TKeyValueList = specialize TFPGMap<String,String>;
var
  kVList: TKeyValueList;
begin
  kVList := TKeyValueList.Create;
  try
    kVList.Add('description', txtDescription.Text);
    kVList.Add('priority', txtPriority.Text);
    Category.addEntry(kVList)
  finally
    FreeAndNil(kVList);
  end;

  Close;
end;

procedure TFormNewCategory.btnAbortClick(Sender: TObject);
begin
  Close;
end;

end.
