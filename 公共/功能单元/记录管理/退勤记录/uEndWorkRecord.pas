unit uEndWorkRecord;

interface

uses Contnrs;

type
  //////////////////////////////
  /// 类名:TBeginWorkRecord
  /// 说明:出勤记录对象
  //////////////////////////////
  TEndWorkRecord = class
  public
    strGUID : String;
    {担当车次}
    strCheCi : String;
    {驾驶机车车型}
    strTrainType : String;
    {驾驶机车车号}
    strTrainNumber : String;
    {客货类型}
    strKeHuo : String;
    {开车时间}
    dtKaiCheTime : TDateTime;
    {到达时间}
    dtDaoDaTime : TDateTime;
    {乘务员1GUID}
    strTrainmanGUID1 : String;
    {乘务员1身份验证方式}
    nTrainmanVerifyID1 : Integer;
    {乘务员2GUID}
    strTrainmanGUID2 : String;
    {乘务员2身份验证方式}
    nTrainmanVerifyID2 : Integer;
    {区域ID}
    strAreaGUID : String;
    {退勤时间}
    dtCreateTime : TDateTime;
    {办理退勤人员}
    strDutyGUID : String;
    {退勤点}
    strEndStation : string;
  public
    procedure CopyFrom(Item : TEndWorkRecord);
  end;

  //////////////////////////////
  /// 类名:TBeginWorkRecordEx
  /// 说明:出勤记录扩展对象
  //////////////////////////////
  TEndWorkRecordEx = class(TEndWorkRecord)
    {乘务员1姓名}
    strTrainmanName1 : String;
    {乘务员1工号}
    strTrainmanNumber1 : String;
    {乘务员1测酒结果}
    TestDrinkResult1 : Integer;
    {乘务员2姓名}
    strTrainmanName2 : String;
    {乘务员2工号}
    strTrainmanNumber2 : String;
    {乘务员1测酒结果}
    TestDrinkResult2 : Integer;
  public
    procedure CopyFrom(Item : TEndWorkRecordEx);reintroduce;
  end;

  //////////////////////////////
  /// 类名:TBeginWorkRecordExList
  /// 说明:出勤记录扩展对象
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

