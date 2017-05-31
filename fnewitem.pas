unit fNewItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, mDbTable, fgl;

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
  private
    FReceipt: TItem;
  public
    { public declarations }
  end;

var
  Form2: TFormNewItem;

implementation

{$R *.lfm}

{ TFormNewItem }

procedure TFormNewItem.btnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFormNewItem.btnSaveClick(Sender: TObject);
type
  Ttest = specialize TFPGMap<String,String>;
var
  test: Ttest;
begin
  test := Ttest.Create;
  test.Add('description',txtItemDesc.Text);
  test.Add('amount',txtItemAmount.Text);
  test.Add('category','1');
  test.Add('date',DateTimeToStr(Now));
  FReceipt := TItem.Create;
  FReceipt.addEntry(test);

  Close;
end;

end.

