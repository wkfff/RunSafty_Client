unit uLCTrainmanMgr;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject,uTrainman,uLLCommonFun,
  uHttpWebAPI,uSaftyEnum,uTrainmanJiaolu;
const
  OPTION_GETTM_NOPICNOFINGER = 0;
  OPTION_GETTM_INCLUDEFINGER = 1;
  OPTION_GETTM_INCLUDEPIC = 2;
type
  //枚举统计信息
  REnumSum = record
    //枚举名称
    EnumName: string;
    //枚举ID
    EnumID: string;
    //统计数量
    EnumCount: integer;
  end;

  TEnumSumArray = array of REnumSum;


  TListProgress = procedure(postion,max: integer);
  //人员信息接口
  TRsLCTrainmanMgr = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能：添加乘务员
    procedure AddTrainman(const Trainman : RRsTrainman);
    //功能：修改乘务员
    procedure UpdateTrainman(const Trainman : RRsTrainman) ;
    //功能：删除乘务员
    procedure DeleteTrainman(TrainmanGUID: string);

    //获取指定ID的乘务员的信息
    function GetTrainmanByNumber(TrainmanNumber : string;out Trainman : RRsTrainman;option: integer = 0) : boolean;
    //分页查找
    procedure QueryTrainmans_blobFlag(QueryTrainman: RRsQueryTrainman;PageIndex: integer;
      out TrainmanArray: TRsTrainmanArray;out nTotalCount:Integer);
    //获取空闲人员
    function GetPopupTrainmans(WorkShopGUID, strKeyName: string; PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
    //获取人员摘要信息
    procedure GetTrainmansBrief(startNid,nCount,option: integer;out TrainmanArray:TRsTrainmanArray;out nTotalCount: integer);

    procedure ListTrainman(QueryTrainman: RRsQueryTrainman;out TrainmanArray:TRsTrainmanArray;Progress: TListProgress);

    //更新司机联系方式
    procedure UpdateTrainmanTel(TrainmanGUID : string;TrainmanTel,
      TrainmanMobile,TrainmanAddress,TrainmanRemark : string);

    //是否存在非GUID的司机工号  where GUID = TrainmanGUID and strTrainmanNumber <>  TrainmanNumber
    function ExistNumber(TrainmanGUID,TrainmanNumber : string) : boolean;

    //根据GUID获取乘务员信息
    function GetTrainman(TrainmanGUID : string;out Trainman : RRsTrainman;option: Integer = 0) : boolean;

    //清除指纹
    procedure ClearFinger(TrainmanGUID : string);

    //更新指纹照片    
    procedure UpdateFingerAndPic(const Trainman : RRsTrainman);

    //设置指定人员状态
    procedure SetTrainmanState(TrainmanGUID : string; TrainmanState : integer);

    //根据nid获取乘务员
    function GetTrainmanByID(ID: integer;out Trainman: RRsTrainman): Boolean;

    //获取各状态人员数量统计信息
    procedure GetTrainmanStateCount(WorkShopGUID: string;var TrainmanStateCount: RTrainmanStateCount);

    //获取指定车间的 人员交路状况
    procedure GetTrainmanJiaoLuCount(WorkShopGUID : string;var CountArray: TRsTrainJiaoLuCountArray);

    //获取指定车间内各种请销假人员的数量
    procedure GetTrainmanLeaveCount(WorkShopGUID : string;out EnumSumArray: TEnumSumArray);

    //获取车间的人员的 运行状况
    procedure GetTrainmanRunStateCount(WorkShopGUID : string;var CountArray:TRTrainmanRunStateCountArray);

    procedure UpdateTrainmanJiaolu(TrainmanGUID: string;TrainmanJiaoluGUID: string);
    //修改人员所属组织结构
    procedure UpdateTrainmanOrg(TrainmanNumber : string;
      AreaGUID : string;WorkShopGUID : string;TrainJiaoluGUID : string;
      DutyUserGUID : string;DutyUserNumber : string;DutyUserName:string);
  private
    m_WebAPIUtils:TWebAPIUtils;

  public
    class function JsonToTrainman(ijson: ISuperObject): RRsTrainman;
    class function TrainmanToJson(const Trainman : RRsTrainman): ISuperObject;
    class function RsQueryTrainmanToJson(const QueryTrainman: RRsQueryTrainman): ISuperObject;
  end;
implementation

{ TRsLCTrainmanMgr }

procedure TRsLCTrainmanMgr.AddTrainman(const Trainman: RRsTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['trainman'] := TrainmanToJson(Trainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.AddTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCTrainmanMgr.ClearFinger(TrainmanGUID : string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.ClearFinger',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCTrainmanMgr.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCTrainmanMgr.DeleteTrainman(TrainmanGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.DelTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;



function TRsLCTrainmanMgr.ExistNumber(TrainmanGUID,
  TrainmanNumber: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.S['TrainmanNumber'] := TrainmanNumber; 

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.ExistNumber',JSON.AsString);

  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Result := m_WebAPIUtils.GetHttpDataJson(strOutputData).B['result'];

end;

function TRsLCTrainmanMgr.GetPopupTrainmans(WorkShopGUID, strKeyName: string;
  PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  JSONTrainmanArray : ISuperObject;
  i: integer;
begin
  json := SO();
  json.S['WorkShopGUID'] := WorkShopGUID;
  json.S['strKeyName'] := strKeyName;
  json.I['PageIndex'] := PageIndex;
 

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetPopupTrainmans',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  json := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['nTotalCount'];

  JSONTrainmanArray := JSON.O['trainmanArray'];
  SetLength(TrainmanArray,JSONTrainmanArray.AsArray.Length);
  for I := 0 to JSONTrainmanArray.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(JSONTrainmanArray.AsArray[i]);
  end;
end;

function TRsLCTrainmanMgr.GetTrainman(TrainmanGUID: string;
  out Trainman: RRsTrainman;option: integer): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainman',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['trainmanArray'];
  
  result := json.AsArray.Length > 0;

  if Result then
  begin
    Trainman := JsonToTrainman(json.AsArray[0]);
  end;
end;

function TRsLCTrainmanMgr.GetTrainmanByID(ID: integer;
  out Trainman: RRsTrainman): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.I['ID'] := ID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Trainman.GetByID',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;


  if Result then
  begin
    Trainman := JsonToTrainman(json.O['TM']);
  end;
end;

function TRsLCTrainmanMgr.GetTrainmanByNumber(TrainmanNumber: string;
  out Trainman: RRsTrainman;option: integer): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanNumber'] := TrainmanNumber;
  json.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainmanByNumber',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['trainmanArray'];
  
  result := json.AsArray.Length > 0;

  if Result then
  begin
    Trainman := JsonToTrainman(json.AsArray[0]);
  end;
end;


procedure TRsLCTrainmanMgr.GetTrainmanJiaoLuCount(WorkShopGUID: string;
  var CountArray: TRsTrainJiaoLuCountArray);
  function JsonToJiaoLuCount(iJson: ISuperObject): RRsTrainJiaoLuCount;
  begin
    //交路名字
    Result.strJiaoLuName := iJson.S['strJiaoLuName'];
    //人员个数
    Result.nCount := iJson.I['nCount'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.TrainmanJiaoLu',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(CountArray,JSON.O['SumCount'].AsArray.Length);
  for I := 0 to Length(CountArray) - 1 do
  begin
    CountArray[i] := JsonToJiaoLuCount(JSON.O['SumCount'].AsArray[i]);
  end;

end;

procedure TRsLCTrainmanMgr.GetTrainmanLeaveCount(WorkShopGUID: string;
  out EnumSumArray: TEnumSumArray);
  function JsonToLeaveCount(iJson: ISuperObject): REnumSum;
  begin
    //枚举名称
    Result.EnumName := iJson.S['EnumName'];
    //枚举ID
    Result.EnumID := iJson.S['EnumID'];
    //统计数量
    Result.EnumCount := iJson.I['EnumCount'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.Leave',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(EnumSumArray,JSON.O['Sum'].AsArray.Length);
  for I := 0 to Length(EnumSumArray) - 1 do
  begin
    EnumSumArray[i] := JsonToLeaveCount(JSON.O['Sum'].AsArray[i]);
  end;

end;

procedure TRsLCTrainmanMgr.GetTrainmanRunStateCount(WorkShopGUID: string;
  var CountArray: TRTrainmanRunStateCountArray);
  function JsonToSimpleGrp(iJson: ISuperObject): RRsGroup;
  begin
    Result := EmptyRsGroup;
    Result.GroupState := TRsTrainmanState(iJson.I['GroupState']);
    Result.Trainman1.strTrainmanNumber := iJson.S['TrainmanNumber1'];
    Result.Trainman1.strTrainmanName := iJson.S['TrainmanName1'];

    Result.Trainman2.strTrainmanNumber := iJson.S['TrainmanNumber2'];
    Result.Trainman2.strTrainmanName := iJson.S['TrainmanName2'];

    Result.Trainman3.strTrainmanNumber := iJson.S['TrainmanNumber3'];
    Result.Trainman3.strTrainmanName := iJson.S['TrainmanName3'];

    Result.Trainman4.strTrainmanNumber := iJson.S['TrainmanNumber4'];
    Result.Trainman4.strTrainmanName := iJson.S['TrainmanName4'];
  end;
  function JsonToCountInfo(iJson: ISuperObject): RTrainmanRunStateCount;
  var
    k: Integer;
  begin
    Result.strJiaoLuName := iJson.S['strJiaoLuName'];
    //运行中
    Result.nRuningCount := iJson.I['nRuningCount'];
    //本段休息
    Result.nLocalCount := iJson.I['nLocalCount'];
    //外段休息
    Result.nSiteCount := iJson.I['nSiteCount'];
    SetLength(Result.group,iJson.O['group'].AsArray.Length);
    for k := 0 to Length(Result.group) - 1 do
    begin
      Result.group[k] := JsonToSimpleGrp(iJson.O['group'].AsArray[k]);
    end;
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.RunState',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(CountArray,JSON.O['Sum'].AsArray.Length);
  for I := 0 to Length(CountArray) - 1 do
  begin
    CountArray[i] := JsonToCountInfo(JSON.O['Sum'].AsArray[i]);
  end;

end;
procedure TRsLCTrainmanMgr.GetTrainmansBrief(
  startNid,nCount,option: integer;out TrainmanArray:TRsTrainmanArray;out nTotalCount: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  i: integer;
begin
  JSON := SO();
  JSON.I['startNid'] := startNid;
  JSON.I['nCount'] := nCount;
  JSON.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainmansBrief',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  nTotalCount := JSON.I['nTotalCount'];
  JSON := JSON.O['trainmanArray'];
  SetLength(TrainmanArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(json.AsArray[i]);
  end;
end;




procedure TRsLCTrainmanMgr.GetTrainmanStateCount(WorkShopGUID: string;
  var TrainmanStateCount: RTrainmanStateCount);
  function JsonToStateCount(iJson: ISuperObject): RTrainmanStateCount;
  begin
    {非运转}
    Result.nUnRuning := iJson.I['nUnRuning'];
    {预备}
    Result.nReady := iJson.I['nReady'];
    {正常或已退勤}
    Result.nNormal := iJson.I['nNormal'];
    {已安排计划}
    Result.nPlaning := iJson.I['nPlaning'];
    {已入寓}
    Result.nInRoom := iJson.I['nInRoom'];
    {已离寓}
    Result.nOutRoom := iJson.I['nOutRoom'];
    {已出勤}
    Result.nRuning := iJson.I['nRuning'];
    {空人员}
    Result.nNil := iJson.I['nNil'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.GetTrainmanStateCount',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  TrainmanStateCount := JsonToStateCount(JSON.O['SumCount']);
end;


class function TRsLCTrainmanMgr.JsonToTrainman(ijson: ISuperObject): RRsTrainman;
begin
  //司机GUID
  Result.strTrainmanGUID := iJson.S['strTrainmanGUID'];
  //司机姓名
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  //司机工号
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];

  Result.nPostID := TRsPost(iJson.I['nPostID']);
  //职位名称
  Result.strPostName := iJson.S['strPostName'];
  //所属车间GUID
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //所属车间名称
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  {指纹1}
  Result.FingerPrint1 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint1']);

  if iJson.O['nFingerPrint1_Null'] <> nil then
    Result.nFingerPrint1_Null := iJson.I['nFingerPrint1_Null']
  else
  begin
    if Length(iJson.S['FingerPrint1']) = 0 then
      {指纹1空标志,空位0,不空为1}
      Result.nFingerPrint1_Null := 0
    else
      Result.nFingerPrint1_Null := 1;
  end;


  
  {指纹2}
  Result.FingerPrint2 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint2']);

  if iJson.O['nFingerPrint2_Null'] <> nil then
    Result.nFingerPrint2_Null := iJson.I['nFingerPrint2_Null']
  else
  begin
    if Length(iJson.S['FingerPrint2']) = 0 then
      {指纹2空标志,空位0,不空为1}
      Result.nFingerPrint2_Null := 0
    else
      Result.nFingerPrint2_Null := 1;
  end;
  


  //测酒照片
  Result.Picture := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['Picture']);

  if iJson.O['nPicture_Null'] <> nil then
    Result.nPicture_Null := iJson.I['nPicture_Null']
  else
  begin
    if Length(iJson.S['Picture']) = 0 then
      //照片空标志,空位0,不空为1
      Result.nPicture_Null := 0
    else
      Result.nPicture_Null := 1;
  end;

  
  //指导组GUID
  Result.strGuideGroupGUID := iJson.S['strGuideGroupGUID'];
  //指导组名称
  Result.strGuideGroupName := iJson.S['strGuideGroupName'];
  //联系电话
  Result.strTelNumber := iJson.S['strTelNumber'];
  //手机号
  Result.strMobileNumber := iJson.S['strMobileNumber'];
  //家庭住址
  Result.strAdddress := iJson.S['strAddress'];
  //驾驶工种
  Result.nDriverType := TRsDriverType(iJson.I['nDriverType']);                                 


  Result.strDriverTypeName := iJson.S['strDriverTypeName'];

  //叫班状态
  Result.nCallWorkState := TRsCallWorkState(iJson.I['nCallWorkState']);

  //叫班时间
  Result.strCallWorkGUID := iJson.S['strCallWorkGUID'];
  //关键人(0,1)
  Result.bIsKey := iJson.I['bIsKey'];
  //入职日期
  Result.dtRuZhiTime := StrToDateTimeDef(iJson.S['dtRuZhiTime'],0);
  //就职日期
  Result.dtJiuZhiTime := StrToDateTimeDef(iJson.S['dtJiuZhiTime'],0);
  //1、2、3
  Result.nDriverLevel := iJson.I['nDriverLevel'];
  //ABCD
  Result.strABCD := iJson.S['strABCD'];
  //备注
  Result.strRemark := iJson.S['strRemark'];

  //客货ID
  Result.nKeHuoID := TRsKehuo(iJson.I['nKeHuoID']);
  
  //客货名称
  Result.strKeHuoName := iJson.S['strKeHuoName'];
  //所属区段
  Result.strTrainJiaoluGUID := iJson.S['strTrainJiaoluGUID'];
  //所属人员交路
  Result.strTrainmanJiaoluGUID := iJson.S['strTrainmanJiaoluGUID'];
  //区段名称
  Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
  //最后退勤时间
  Result.dtLastEndworkTime := StrToDateTimeDef(iJson.S['dtLastEndworkTime'],0);
  //机务段编号
  Result.strAreaGUID := iJson.S['strareaguid'];
  //自增编号
  Result.nID := iJson.I['nID'];
  //创建时间
  Result.dtCreateTime := StrToDateTimeDef(iJson.S['dtCreateTime'],0);
  //状态
  TCF_Enum.SetEnumValue(@Result.nTrainmanState,SizeOf(Result.nTrainmanState),iJson.I['nTrainmanState']);
  //姓名简拼
  Result.strJP := iJson.S['strJP'];
  //最后入寓时间
  Result.dtLastInRoomTime := StrToDateTimeDef(iJson.S['dtLastInRoomTime'],0);
  //最后离寓时间
  Result.dtLastOutRoomTime := StrToDateTimeDef(iJson.S['dtLastOutRoomTime'],0); 
end;


procedure TRsLCTrainmanMgr.ListTrainman(QueryTrainman: RRsQueryTrainman;
  out TrainmanArray: TRsTrainmanArray; Progress: TListProgress);
var
  index,totalCount: integer;
  tmpArray: TRsTrainmanArray;
  I: integer;
begin
  totalCount := 0;
  index := 1;
  repeat
    QueryTrainmans_blobFlag(QueryTrainman,index,tmpArray,totalCount);
//    GetTrainmansBrief(index,20,option,tmpArray,totalCount);

    if Length(tmpArray) = 0 then break;
    
    Inc(index);   

    SetLength(TrainmanArray,Length(TrainmanArray) + Length(tmpArray));
    for I := 0 to Length(tmpArray) - 1 do
    begin
      TrainmanArray[Length(TrainmanArray) - Length(tmpArray) + i] := tmpArray[i];
    end;

    if Assigned(Progress) then
      Progress(Length(TrainmanArray),totalCount);
      
  until (Length(TrainmanArray) >=  totalCount);
  
  
end;

procedure TRsLCTrainmanMgr.QueryTrainmans_blobFlag(
  QueryTrainman: RRsQueryTrainman; PageIndex: integer;
  out TrainmanArray: TRsTrainmanArray; out nTotalCount: Integer);
var
  json: ISuperObject;
  strOutputData,strResultText : string ;
  I: Integer;
begin
  json := SO;
  json.I['PageIndex'] := PageIndex;
  json.O['QueryTrainman'] := RsQueryTrainmanToJson(QueryTrainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.QueryTrainmans_blobFlag',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  
  json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  

  nTotalCount := json.I['nTotalCount'];

  json := json.O['trainmanArray'];
  SetLength(TrainmanArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(json.AsArray[i]);
  end;
end;

class function TRsLCTrainmanMgr.RsQueryTrainmanToJson(
  const QueryTrainman: RRsQueryTrainman): ISuperObject;
begin
  Result := SO();
  //工号，空为所有
  Result.S['strTrainmanNumber'] := QueryTrainman.strTrainmanNumber;
  //姓名，空为所有
  Result.S['strTrainmanName'] := QueryTrainman.strTrainmanName;
  //机务段编号
  Result.S['strAreaGUID'] := QueryTrainman.strAreaGUID;
  //所属车间，空为所有
  Result.S['strWorkShopGUID'] := QueryTrainman.strWorkShopGUID;
  //区段信息
  Result.S['strTrainJiaoluGUID'] := QueryTrainman.strTrainJiaoluGUID;
  //指导组
  Result.S['strGuideGroupGUID'] := QueryTrainman.strGuideGroupGUID;
  //已登记指纹数量，-1为所有
  Result.I['nFingerCount'] := QueryTrainman.nFingerCount;
  //是否有照片，-1为所有
  Result.I['nPhotoCount'] := QueryTrainman.nPhotoCount;      
end;

procedure TRsLCTrainmanMgr.SetTrainmanState(TrainmanGUID: string;
  TrainmanState: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.I['TrainmanState'] := TrainmanState;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.SetTrainmanState',JSON.AsString);

  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

class function TRsLCTrainmanMgr.TrainmanToJson(
  const Trainman: RRsTrainman): ISuperObject;
begin
  Result := SO();
  //司机GUID
  Result.S['strTrainmanGUID'] := Trainman.strTrainmanGUID;
  //司机姓名
  Result.S['strTrainmanName'] := Trainman.strTrainmanName;
  //司机工号
  Result.S['strTrainmanNumber'] := Trainman.strTrainmanNumber;
  //职位
  Result.I['nPostID'] := Ord(Trainman.nPostID);
  //职位名称
  Result.S['strPostName'] := Trainman.strPostName;
  //所属车间GUID
  Result.S['strWorkShopGUID'] := Trainman.strWorkShopGUID;
  //所属车间名称
  Result.S['strWorkShopName'] := Trainman.strWorkShopName;

  {指纹1}
  Result.S['FingerPrint1'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.FingerPrint1,True);
  {指纹1空标志,空位0,不空为1}
  Result.I['nFingerPrint1_Null'] := Trainman.nFingerPrint1_Null;


  {指纹2}
  Result.S['FingerPrint2'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.FingerPrint2,True);
  {指纹2空标志,空位0,不空为1}
  Result.I['nFingerPrint2_Null'] := Trainman.nFingerPrint2_Null;


  //测酒照片
  Result.S['Picture'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.Picture,True);
  //照片空标志,空位0,不空为1
  Result.I['nPicture_Null'] := Trainman.nPicture_Null;
  
  //指导组GUID
  Result.S['strGuideGroupGUID'] := Trainman.strGuideGroupGUID;
  //指导组名称
  Result.S['strGuideGroupName'] := Trainman.strGuideGroupName;
  //联系电话
  Result.S['strTelNumber'] := Trainman.strTelNumber;
  //手机号
  Result.S['strMobileNumber'] := Trainman.strMobileNumber;
  //家庭住址
  Result.S['strAddress'] := Trainman.strAdddress;
  //驾驶工种
  Result.I['nDriverType'] := Ord(Trainman.nDriverType);
  Result.S['strDriverTypeName'] := Trainman.strDriverTypeName;
  //叫班状态
  Result.I['nCallWorkState'] := Ord(Trainman.nCallWorkState);
  //叫班时间
  Result.S['strCallWorkGUID'] := Trainman.strCallWorkGUID;
  //关键人(0,1)
  Result.I['bIsKey'] := Trainman.bIsKey;
  //入职日期
  Result.S['dtRuZhiTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtRuZhiTime);
  //就职日期
  Result.S['dtJiuZhiTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtJiuZhiTime);
  //1、2、3
  Result.I['nDriverLevel'] := Trainman.nDriverLevel;
  //ABCD
  Result.S['strABCD'] := Trainman.strABCD;
  //备注
  Result.S['strRemark'] := Trainman.strRemark;
  //客货ID
  Result.I['nKeHuoID'] := Ord(Trainman.nKeHuoID);
  //客货名称
  Result.S['strKeHuoName'] := Trainman.strKeHuoName;
  //所属区段
  Result.S['strTrainJiaoluGUID'] := Trainman.strTrainJiaoluGUID;
  //所属人员交路
  Result.S['strTrainmanJiaoluGUID'] := Trainman.strTrainmanJiaoluGUID;
  //区段名称
  Result.S['strTrainJiaoluName'] := Trainman.strTrainJiaoluName;
  //最后退勤时间
  Result.S['dtLastEndworkTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastEndworkTime);
  //机务段编号
  Result.S['strAreaGUID'] := Trainman.strAreaGUID;
  //和接口定义不统一，导致两种写法都有可能用，暂时都写入JSON中
  Result.S['strareaguid'] := Trainman.strAreaGUID;

  //自增编号
  Result.I['nID'] := Trainman.nID;
  //创建时间
  Result.S['dtCreateTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtCreateTime);
  //状态
  Result.I['nTrainmanState'] := Ord(Trainman.nTrainmanState);
  //姓名简拼
  Result.S['strJP'] := Trainman.strJP;
  //最后入寓时间
  Result.S['dtLastInRoomTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastInRoomTime);
  //最后离寓时间
  Result.S['dtLastOutRoomTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastOutRoomTime);  
end;

procedure TRsLCTrainmanMgr.UpdateFingerAndPic(const Trainman : RRsTrainman);
var
  json: ISuperObject;
  strOutputData,strResultText: string;
begin
  json := so;
  json.o['trainman'] := TrainmanToJson(Trainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateFingerAndPic',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTrainmanMgr.UpdateTrainman(const Trainman: RRsTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.O['trainman'] := TrainmanToJson(Trainman);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCTrainmanMgr.UpdateTrainmanJiaolu(TrainmanGUID,
  TrainmanJiaoluGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['TrainmanGUID'] := TrainmanGUID;
  json.s['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.UpdateTrainmanJiaolu',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
procedure TRsLCTrainmanMgr.UpdateTrainmanOrg(TrainmanNumber, AreaGUID,
  WorkShopGUID, TrainJiaoluGUID, DutyUserGUID, DutyUserNumber: string;
  DutyUserName:string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['TrainmanNumber'] := TrainmanNumber;
  json.s['AreaGUID'] := AreaGUID;
  json.s['WorkShopGUID'] := WorkShopGUID;
  json.s['TrainJiaoluGUID'] := TrainJiaoluGUID;
  json.s['DutyUserGUID'] := DutyUserGUID;
  json.s['DutyUserNumber'] := DutyUserNumber;
  json.s['DutyUserName'] := DutyUserName;
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.UpdateTMOrg',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTrainmanMgr.UpdateTrainmanTel(TrainmanGUID, TrainmanTel,
  TrainmanMobile, TrainmanAddress, TrainmanRemark: string);
var
  json: ISuperObject;
  strOutputData,strResultText : string ;
begin
  json := SO;
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.S['TrainmanTel'] := TrainmanTel;
  json.S['TrainmanMobile'] := TrainmanMobile;
  json.S['TrainmanAddress'] := TrainmanAddress;
  json.S['TrainmanRemark'] := TrainmanRemark;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateTrainmanTel',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

end.
