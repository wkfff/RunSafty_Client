unit uPlan;

interface
uses
  SysUtils,uTFSystem,Contnrs, uTrainNo;

const
  {未录入}
  PLANSTATE_NOINPUT = 0;
  {未签到}
  PLANSTATE_NOSIGNIN = 1;
  {已签到}
  PLANSTATE_SIGNIN = 2;
  {已入寓}
  PLANSTATE_INROOM = 3;
  {已离寓}
  PLANSTATE_OUTROOM = 4;
  {已出勤}
  PLANSTATE_BEGINWORK = 5;
type

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TPlan
  /// 说明:计划信息
  //////////////////////////////////////////////////////////////////////////////
  TPlan = class(TTrainNo)
  public
    constructor Create();
    {功能:拷贝数据}
    procedure CopyFrom(Plan:TPlan);reintroduce;
  public
    {功能:将整型计划状态转换为字符串}
    class function PlanStateToString(nTypeID : Integer) : String;
    {功能:将字符串计划状态转换为整型}
    class function PlanStateToInt(strType : string) : Integer;
  public
    {车型}
    strTrainType : String;
    {车号}
    strTrainNumber : String;
    {乘务员1GUID}
    strTrainmanGUID1 : String;
    {乘务员1计划状态}
    nTrainmanState1 : Integer;
    {乘务员2GUID}
    strTrainmanGUID2 : String;
    {乘务员2计划状态}
    nTrainmanState2 : Integer;
    {计划状态}
    nState : Integer;
    {计划时间}
    dtPlanDate : TDateTime;
    {录入人}
    strInputGUID : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TPlanList
  /// 说明:计划信息列表
  //////////////////////////////////////////////////////////////////////////////
  TPlanList = Class(TObjectList)
  protected
    function GetItem(Index: Integer): TPlan;
    procedure SetItem(Index: Integer; Item: TPlan);
  public
  public
    function Add(Item: TTrainNo): Integer;
    property Items[Index: Integer]: TPlan read GetItem write SetItem; default;
  end;
  

implementation

{ TPlan }

procedure TPlan.CopyFrom(Plan: TPlan);
{功能:拷贝数据}
begin
  inherited CopyFrom(TTrainNo(Plan));
  strTrainType := Plan.strTrainType;
  strTrainNumber := Plan.strTrainNumber;
  strTrainmanGUID1 := Plan.strTrainmanGUID1;
  nTrainmanState1 := Plan.nTrainmanState1;
  strTrainmanGUID2 := Plan.strTrainmanGUID2;
  nTrainmanState2 := Plan.nTrainmanState2;
  nState := Plan.nState;
  dtPlanDate := Plan.dtPlanDate;
  strInputGUID := plan.strInputGUID; 
end;

constructor TPlan.Create;
begin
  strGUID := '';
  nState := PLANSTATE_NOSIGNIN;
  strTrainType := '';
  strTrainNumber := '';
  strTrainmanGUID1 := '';
  nTrainmanState1 := 1;
  strTrainmanGUID2 := '';
  nTrainmanState2 := 1;
end;

class function TPlan.PlanStateToInt(strType: string): Integer;
{功能:将字符串计划状态转换为整型}
begin
  Result := 0;

  if strType = '未录入' then
    Result := 0;

  if strType = '未签到' then
    Result := 1;

  if strType = '已签到' then
    Result := 2;

  if strType = '已入寓' then
    Result := 3;

  if strType = '已离寓' then
    Result := 4;

  if strType = '已出勤' then
    Result := 5;
end;

class function TPlan.PlanStateToString(nTypeID: Integer): String;
{功能:将整型计划状态转换为字符串}
begin
  Result := '';
  case nTypeID of
    0 : Result := '未录入';
    1 : Result := '未签到';
    2 : Result := '已签到';
    3 : Result := '已入寓';
    4 : Result := '已离寓';
    5 : Result := '已出勤';
  end;
end;

{ TPlanList }

function TPlanList.Add(Item : TTrainNo): Integer;
begin
  Result := inherited Add(Item);
end;

function TPlanList.GetItem(Index: Integer): TPlan;
begin
  Result := TPlan(inherited GetItem(Index));
end;

procedure TPlanList.SetItem(Index: Integer; Item: TPlan);
begin
  inherited SetItem(Index,Item);
end;

end.
