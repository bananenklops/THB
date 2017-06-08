unit mRecord;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TRecord }

  TRecord = class abstract(TObject)
  protected
    FId: integer;
    FCreationDateTime: TDateTime;
    FSaveEvent: TNotifyEvent;
    FDeleteEvent: TNotifyEvent;
  public
    procedure saveRecord;
    procedure deleteRecord;
    procedure setId(id: integer);
    procedure setCreationDateTime(cdt: TDateTime);

    property Id: integer read FId write FId;
    property CreationDateTime: TDateTime read FCreationDateTime write FCreationDateTime;

    property OnSave: TNotifyEvent read FSaveEvent write FSaveEvent;
    property OnDelete: TNotifyEvent read FDeleteEvent write FDeleteEvent;
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

  public
    function isReceivt: boolean;
    function isCosts: boolean;

    property Description: string read FDescription write FDescription;
    property Category: integer read FCategory write FCategory;
    property Amount: double read Famount write Famount;
    property Date: TDate read Fdate write Fdate;
    property ItemType: TItemType read FType write FType;

  end;

  { TCategoryRecord }

  TItemList = specialize TFPGObjectList<TItemRecord>;

  TCategoryRecord = class(TRecord)
  private
    FDescription: string;
    FPriority: integer;
    FItemList: TItemList;
  public
    property Description: string read FDescription write FDescription;
    property Priority: integer read FPriority write FPriority;
    property ItemList: TItemList read FItemList write FItemList;

  end;

implementation

{ TCategoryRecord }

{ TRecord }

procedure TRecord.saveRecord;
begin
  if not Assigned(FSaveEvent) then
    exit;
  FSaveEvent(Self);
end;

procedure TRecord.deleteRecord;
begin
  if not Assigned(FDeleteEvent) then
    exit;
  FDeleteEvent(self);
end;

procedure TRecord.setId(id: integer);
begin
  self.FId := id;
end;

procedure TRecord.setCreationDateTime(cdt: TDateTime);
begin
  FCreationDateTime := cdt;
end;

{ TCategoryRecord }

{ TItemRecord }

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
