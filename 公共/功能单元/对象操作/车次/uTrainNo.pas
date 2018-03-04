unit uTrainNo;

interface
uses
  SysUtils,uTFSystem,Contnrs;


const
  {单司机}
  TRAINMANTYPE_SINGLE  = 1;
  {双司机}
  TRAINMANTYPE_DOUBLE  = 2;


type

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTrainNo
  /// 说明:车次信息
  //////////////////////////////////////////////////////////////////////////////
  TTrainNo = Class
  public
    constructor Create();
  public
    {功能:拷贝数据}
    procedure CopyFrom(Item:TTrainNo);
    {功能:将整型单双司机类型转换为字符串}
    class function TrainmanTypeToString(nTypeID : Integer) : String;
    {功能:将字符串单双司机转换为整型}
    class function TrainmanTypeToInt(strType : string) : Integer;
  public
    strGUID : String;
    {车次}
    strTrainNo : String;
    {客货}
    strKeHuo : String;
    {区段}
    strSectionName : String;
    {交路号}
    strJiaoLuNumber : String;
    {车站号}
    strCheZhanNumber : String;
    {休息时间}
    dtRestTime : TDateTime;
    {叫班时间}
    dtCallTime : TDateTime;
    {出勤时间}
    dtOutDutyTime : TDateTime;
    {开车时间}
    dtStartTime : TDateTime;
    {单双司机 1为单司机 2为双司机}
    nTrainmanTypeID : Integer;
    {是否需要强休}
    nIsEnforceRest : Integer;
    {区域ID}
    strAreaGUID : String;
    {记录产生时间}
    dtCreateTime : TDateTime;
    {起始站}
    strStartStation : string;
    {终到站}
    strEndStation : string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTrainNoList
  /// 说明:车次信息列表
  //////////////////////////////////////////////////////////////////////////////
  TTrainNoList = Class(TObjectList)
  protected
    function GetItem(Index: Integer): TTrainNo;
    procedure SetItem(Index: Integer; Item: TTrainNo);
  public
  public
    function Add(Item: TTrainNo): Integer;
    property Items[Index: Integer]: TTrainNo read GetItem write SetItem; default;
  end;

implementation

{ TTrainNoOpt }
{ TTrainNo }

procedure TTrainNo.CopyFrom(Item: TTrainNo);
{功能:拷贝数据}
begin
  strGUID := Item.strGUID;
  {车次}
  strTrainNo := Item.strTrainNo;
  {区段}
  strSectionName := Item.strSectionName;
  {交路号}
  strJiaoLuNumber := Item.strJiaoLuNumber;
  {车站号}
  strCheZhanNumber := Item.strCheZhanNumber;
  {休息时间}
  dtRestTime := Item.dtRestTime;
  {叫班时间}
  dtCallTime := Item.dtCallTime;
  {出勤时间}
  dtOutDutyTime := Item.dtOutDutyTime;
  {开车时间}
  dtStartTime := Item.dtStartTime;
  {单双司机 1为单司机 2为双司机}
  nTrainmanTypeID := Item.nTrainmanTypeID;
  {是否需要强休}
  nIsEnforceRest := Item.nIsEnforceRest;
  {区域ID}
  strAreaGUID := Item.strAreaGUID;
  {记录产生时间}
  dtCreateTime := Item.dtCreateTime;
  {客货}
  strKeHuo := Item.strKeHuo;
end;

constructor TTrainNo.Create;
begin
  dtCreateTime := Now;
end;

class function TTrainNo.TrainmanTypeToInt(strType: String): Integer;
{功能:将字符串单双司机转换为整型}
begin
  Result := 0;
  if strType = '单司机' then
    Result := 1;
  if strType = '双司机' then
    Result := 2;
end;

class function TTrainNo.TrainmanTypeToString(nTypeID: Integer): String;
{功能:将整型单双司机类型转换为字符串}
begin
  Result := '';
  case nTypeID of
    1 : Result := '单司机';
    2 : Result := '双司机';
  end;
end;

{ TTrainNoList }

function TTrainNoList.Add(Item: TTrainNo): Integer;
begin
  Result := inherited Add(Item);
end;

function TTrainNoList.GetItem(Index: Integer): TTrainNo;
begin
  Result := TTrainNo(inherited GetItem(Index));
end;

procedure TTrainNoList.SetItem(Index: Integer; Item: TTrainNo);
begin
  inherited SetItem(Index,Item);
end;

end.
