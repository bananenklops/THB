unit mRecord;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TRecord }

  TRecord = class abstract(TObject)
  protected
    Fid: integer;
    creationDateTime: TDateTime;
  public
    procedure saveRecord; virtual; abstract;
    procedure deleteRecord; virtual; abstract;
    procedure setId(id: integer);
    procedure setCreationDateTime(cdt: TDateTime);
  end;

  { TItemRecord }

  TItemType = (itCosts, itReceivt);

  TItemRecord = class(TRecord)
  private
    FDescription: string;
    FCategory: integer;
    Famount: double;
    Fdate: TDate;
    FType: TItemType;
    FSaveEvent: TNotifyEvent;

  public
    procedure saveRecord; override;
    procedure deleteRecord; override;

    procedure setDescription(desc: string);
    procedure setCategory(cat: integer);
    procedure setAmount(amount: double);
    procedure setDate(date: TDate);
    procedure setFType(itType: TItemType);

    function isReceivt: boolean;
    function isCosts: boolean;

    property Description: string read FDescription write FDescription;
    property Category: integer read FCategory write FCategory;
    property Amount: double read Famount write Famount;
    property Date: TDate read Fdate write Fdate;
    property ItemType: TItemType read FType write FType;

    property OnSave: TNotifyEvent read FSaveEvent write FSaveEvent;
  end;

  { TCategoryRecord }

  TItemList = specialize TFPGObjectList<TItemRecord>;

  TCategoryRecord = class(TRecord)
  private
    FDescription: string;
    FPriority: integer;
    FItemList: TItemList;
  public
    procedure saveRecord; override;
    procedure deleteRecord; override;

    property Description: string read FDescription write FDescription;
    property Priority: integer read FPriority write FPriority;
    property ItemList: TItemList read FItemList write FItemList;

  end;

implementation

{ TCategoryRecord }

procedure TCategoryRecord.saveRecord;
begin

end;

procedure TCategoryRecord.deleteRecord;
begin

end;

{ TRecord }

procedure TRecord.setId(id: integer);
begin
  self.Fid := id;
end;

procedure TRecord.setCreationDateTime(cdt: TDateTime);
begin
  creationDateTime := cdt;
end;

{ TItemRecord }

procedure TItemRecord.saveRecord;
begin
  if not Assigned(FSaveEvent) then
    exit;
  FSaveEvent(Self);
end;

procedure TItemRecord.deleteRecord;
begin

end;

procedure TItemRecord.setDescription(desc: string);
begin
  description := desc;
end;

procedure TItemRecord.setCategory(cat: integer);
begin
  FCategory := cat;
end;

procedure TItemRecord.setAmount(amount: double);
begin
  self.Famount := amount;
end;

procedure TItemRecord.setDate(date: TDate);
begin
  self.Fdate := date;
end;

procedure TItemRecord.setFType(itType: TItemType);
begin
  FType := itType;
end;

function TItemRecord.isReceivt: boolean;
begin
  if (FType = itReceivt) then
    Result := True
  else
    Result := False;
end;

function TItemRecord.isCosts: boolean;
begin
  if (FType = itCosts) then
    Result := True
  else
    Result := False;
end;

end.
