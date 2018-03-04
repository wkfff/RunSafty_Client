unit uEndWorkRecord;

interface

uses Contnrs;

type
  //////////////////////////////
  /// ����:TBeginWorkRecord
  /// ˵��:���ڼ�¼����
  //////////////////////////////
  TEndWorkRecord = class
  public
    strGUID : String;
    {��������}
    strCheCi : String;
    {��ʻ��������}
    strTrainType : String;
    {��ʻ��������}
    strTrainNumber : String;
    {�ͻ�����}
    strKeHuo : String;
    {����ʱ��}
    dtKaiCheTime : TDateTime;
    {����ʱ��}
    dtDaoDaTime : TDateTime;
    {����Ա1GUID}
    strTrainmanGUID1 : String;
    {����Ա1�����֤��ʽ}
    nTrainmanVerifyID1 : Integer;
    {����Ա2GUID}
    strTrainmanGUID2 : String;
    {����Ա2�����֤��ʽ}
    nTrainmanVerifyID2 : Integer;
    {����ID}
    strAreaGUID : String;
    {����ʱ��}
    dtCreateTime : TDateTime;
    {����������Ա}
    strDutyGUID : String;
    {���ڵ�}
    strEndStation : string;
  public
    procedure CopyFrom(Item : TEndWorkRecord);
  end;

  //////////////////////////////
  /// ����:TBeginWorkRecordEx
  /// ˵��:���ڼ�¼��չ����
  //////////////////////////////
  TEndWorkRecordEx = class(TEndWorkRecord)
    {����Ա1����}
    strTrainmanName1 : String;
    {����Ա1����}
    strTrainmanNumber1 : String;
    {����Ա1��ƽ��}
    TestDrinkResult1 : Integer;
    {����Ա2����}
    strTrainmanName2 : String;
    {����Ա2����}
    strTrainmanNumber2 : String;
    {����Ա1��ƽ��}
    TestDrinkResult2 : Integer;
  public
    procedure CopyFrom(Item : TEndWorkRecordEx);reintroduce;
  end;

  //////////////////////////////
  /// ����:TBeginWorkRecordExList
  /// ˵��:���ڼ�¼��չ����
  //////////////////////////////
  TEndWorkRecordExList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TEndWorkRecordEx;
    procedure SetItem(Index: Integer; Item: TEndWorkRecordEx);
  public
    procedure CopyFrom(EndWorkRecordExList:TEndWorkRecordExList);
    function Add(Item: TEndWorkRecordEx): Integer;
    property Items[Index: Integer]: TEndWorkRecordEx read GetItem write SetItem; default;
  end;

implementation

{ TBeginWorkRecordExList }

function TEndWorkRecordExList.Add(Item: TEndWorkRecordEx): Integer;
begin
  Result := inherited Add(Item);
end;

procedure TEndWorkRecordExList.CopyFrom(
  EndWorkRecordExList: TEndWorkRecordExList);
var
  i : Integer;
  Item : TEndWorkRecordEx;
begin
  Clear;
  for I := 0 to EndWorkRecordExList.Count - 1 do
  begin
    Item := TEndWorkRecordEx.Create;
    Item.CopyFrom(EndWorkRecordExList.Items[i]);
    Add(Item);
  end;
end;

function TEndWorkRecordExList.GetItem(Index: Integer): TEndWorkRecordEx;
begin
  Result := TEndWorkRecordEx(inherited GetItem(Index));
end;

procedure TEndWorkRecordExList.SetItem(Index: Integer;
  Item: TEndWorkRecordEx);
begin
  inherited SetItem(Index,Item);
end;

{ TEndWorkRecordEx }

procedure TEndWorkRecordEx.CopyFrom(Item: TEndWorkRecordEx);
begin
  inherited CopyFrom(TEndWorkRecord(Item));
  strTrainmanName1 := Item.strTrainmanName1;
  strTrainmanNumber1 := Item.strTrainmanNumber1;
  TestDrinkResult1 := Item.TestDrinkResult1;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanNumber2 := Item.strTrainmanNumber2;
  TestDrinkResult2 := Item.TestDrinkResult2;
end;

{ TEndWorkRecord }

procedure TEndWorkRecord.CopyFrom(Item: TEndWorkRecord);
begin
  strGUID := Item.strGUID;
  strCheCi := Item.strCheCi;
  strTrainType := Item.strTrainType;
  strTrainNumber := Item.strTrainNumber;
  strKeHuo := Item.strKeHuo;
  dtKaiCheTime := Item.dtKaiCheTime;
  dtDaoDaTime := Item.dtDaoDaTime;
  strTrainmanGUID1 := Item.strTrainmanGUID1;
  nTrainmanVerifyID1 := Item.nTrainmanVerifyID1;
  strTrainmanGUID2 := Item.strTrainmanGUID2;
  nTrainmanVerifyID2 := Item.nTrainmanVerifyID2;
  strAreaGUID := Item.strAreaGUID;
  dtCreateTime := Item.dtCreateTime;
  strDutyGUID := Item.strDutyGUID;
end;

end.

