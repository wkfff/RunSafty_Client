unit uBeginWorkRecord;

interface

uses Contnrs;

type
  //////////////////////////////
  /// 类名:TBeginWorkRecord
  /// 说明:出勤记录对象
  //////////////////////////////
  TBeginWorkRecord = class
  public
    strGUID : String;
    {担当区段}
    strSectionName : String;
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
    {出勤时间}
    dtCreateTime : TDateTime;
    {办理出勤人员}
    strDutyGUID : String;
    {计划ID}
    strPlanGUID : String;
  public
    {功能:从别的出勤记录复制一个}
    procedure CopyFrom(Item:TBeginWorkRecord);
  end;

  //////////////////////////////
  /// 类名:TBeginWorkRecordEx
  /// 说明:出勤记录扩展对象
  //////////////////////////////
  TBeginWorkRecordEx = class(TBeginWorkRecord)
    {乘务员1姓名}
    strTrainmanName1 : String;
    {乘务员1工号}
    strTrainmanNumber1 : String;
    {乘务员1测酒结果}
    TestDrinkResult1 : Integer;
    {乘务员1验卡结果}
    CheckCardResult1 : String;
    {乘务员2姓名}
    strTrainmanName2 : String;
    {乘务员2工号}
    strTrainmanNumber2 : String;
    {乘务员2测酒结果}
    TestDrinkResult2 : Integer;
    {乘务员2验卡结果}
    CheckCardResult2 : String;
  public
    {功能:复制出勤记录扩展对象}
    procedure CopyFrom(Item:TBeginWorkRecordEx);reintroduce;
    
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TBeginWorkRecordExList
  /// 说明:出勤记录扩展对象
  //////////////////////////////////////////////////////////////////////////////
  TBeginWorkRecordExList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TBeginWorkRecordEx;
    procedure SetItem(Index: Integer; Item: TBeginWorkRecordEx);
  public
    {功能:从别的出勤记录扩展对象复制一个}
    procedure CopyFrom(RecordList:TBeginWorkRecordExList);
    function Add(Item: TBeginWorkRecordEx): Integer;
    property Items[Index: Integer]: TBeginWorkRecordEx read GetItem write SetItem; default;
  end;

implementation
uses
  SysUtils;
{ TBeginWorkRecordExList }

function TBeginWorkRecordExList.Add(Item: TBeginWorkRecordEx): Integer;
begin
  Result := inherited Add(Item);
end;

procedure TBeginWorkRecordExList.CopyFrom(RecordList: TBeginWorkRecordExList);
{功能:从别的出勤记录扩展对象复制一个}
var
  Item : TBeginWorkRecordEx;
  i : Integer;
begin
  Clear;
  for I := 0 to RecordList.Count - 1 do
  begin
    Item := TBeginWorkRecordEx.Create;
    Item.CopyFrom(RecordList.Items[i]);
    Add(Item);
  end;
end;

function TBeginWorkRecordExList.GetItem(Index: Integer): TBeginWorkRecordEx;
begin
  Result := TBeginWorkRecordEx(inherited GetItem(Index));
end;

procedure TBeginWorkRecordExList.SetItem(Index: Integer;
  Item: TBeginWorkRecordEx);
begin
  inherited SetItem(Index,Item);
end;

{ TBeginWorkRecord }

procedure TBeginWorkRecord.CopyFrom(Item: TBeginWorkRecord);
{功能:从别的出勤记录复制一个}
begin
  strGUID := Item.strGUID;
  strSectionName := Item.strSectionName;
  strCheCi := Item.strCheCi;
  strTrainType := Item.strTrainType;
  strTrainNumber := Item.strTrainNumber;
  strKeHuo := Item.strKeHuo;
  dtKaiCheTime := Item.dtKaiCheTime;
  strTrainmanGUID1 := Item.strTrainmanGUID1;
  nTrainmanVerifyID1 := Item.nTrainmanVerifyID1;
  strTrainmanGUID2 := Item.strTrainmanGUID2;
  nTrainmanVerifyID2 := Item.nTrainmanVerifyID2;
  strAreaGUID := Item.strAreaGUID;
  dtCreateTime := Item.dtCreateTime;
  strDutyGUID := Item.strDutyGUID;
  strPlanGUID := Item.strPlanGUID;
end;

{ TBeginWorkRecordEx }

procedure TBeginWorkRecordEx.CopyFrom(Item: TBeginWorkRecordEx);
begin
  inherited CopyFrom(TBeginWorkRecord(Item));
  strTrainmanName1 := Item.strTrainmanName1;
  strTrainmanNumber1 := Item.strTrainmanNumber1;
  TestDrinkResult1 := Item.TestDrinkResult1;
  CheckCardResult1 := Item.CheckCardResult1;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanNumber2 := Item.strTrainmanNumber2;
  TestDrinkResult2 := Item.TestDrinkResult2;
  CheckCardResult2 := Item.CheckCardResult2;
end;


end.

