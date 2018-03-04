unit uWaitWork;

interface
uses
  Classes,SysUtils,Contnrs,uSaftyEnum,uTFSystem,superobject,uPubFun,uTrainman,
  StrUtils;
type

  TWaitWorkPlanType =(TWWPT_ASSIGN{派班},TWWPT_SIGN{签点},TWWPT_LOCAL{本地});

  TInOutRoomType = (TInRoom{入公寓},TOutRoom{出公寓}) ;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSyncPlanIDInfo
  /// 描述:待同步待乘计划ID以及计划类型信息
  //////////////////////////////////////////////////////////////////////////////
  TSyncPlanIDInfo = class
    //计划GUID
    strPlanGUID:string;
    //计划类别
    ePlanType: TWaitWorkPlanType;
  end;

  {待同步待乘计划 id,类型信息列表}
  TSyncPlanIDInfoList  = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSyncPlanIDInfo;
    procedure SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
  public
    function Add(AObject: TSyncPlanIDInfo): Integer;
    property Items[Index: Integer]: TSyncPlanIDInfo read GetItem write SetItem; default;
  end;

  /////////////////////////////////////////////////////////////////////////////
  ///结构体名:RRSInOutRoomInfo
  ///描述:乘务员出入公寓信息
  /////////////////////////////////////////////////////////////////////////////
  RRSInOutRoomInfo= record
  public
    //记录GUID
    strGUID:string;
    //入寓记录GUID
    strInRoomGUID:string;
    //行车计划GUID
    strTrainPlanGUID  :string;
    //候班计划GUID
    strWaitPlanGUID:string;
    //出入公寓时间
    dtInOutRoomTime:TDateTime;
    //身份验证类型
    eVerifyType :TRsRegisterFlag;
    //值班员GUID
    strDutyUserGUID:string;
    //司机GUID
    strTrainmanGUID:string;
    //司机工号
    strTrainmanNumber:string;
    //司机姓名
    strTrainmanName:string;
    //记录创建时间
    dtCreatetTime  :TDateTime;
    //客户端guid
    strSiteGUID  :string;
    //房间号
    strRoomNumber :string;
    //床位号
    nBedNumber :Integer;
    //是否同步
    bUploaded:Boolean;
    //候班计划类型
    eWaitPlanType:TWaitWorkPlanType;
    //候班时间
    dtArriveTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //出入公寓类别
    eInOutType:TInOutRoomType;
  public
    {功能:转换为json数据}
    function ToJsonStr(inOutType:TInOutRoomType):string;
  end;
  //出入公寓信息数组
  RRsInOutRoomInfoArray= array of RRSInOutRoomInfo;


  (*
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TInOutRoomInfo
  ///描述:人员出入公寓信息
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfo = class
  public
    {功能:设置值}
    procedure SetValues(strGUID,strPlanGUID,strTrainmanGUID:string;
        eType:TInOutRoomType;dtTime:TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
    {功能:重置}
    procedure Reset();
       {功能:转换为JSON对象}
    function ToJsonStr():string;

  public
    //记录GUID
    strGUID:string;
    //候班计划GUID
    strPlanGUID:string;
    //人员GUID
    strTrainmanGUID:string;
    //出入公寓类型
    eType:TInOutRoomType;
    //出入公寓时间
    dtTime:TDateTime;
    //候班时间
    dtArriveTime:TDateTime;
    // 是否上传
    bUpload :Boolean;
    //计划类型
    ePlanType:TWaitWorkPlanType;
  end;
  *)

  (*
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TInOutRoomInfoList
  ///描述:人员出入公寓信息列表
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TInOutRoomInfo;
    procedure SetItem(Index: Integer; AObject: TInOutRoomInfo);
  public
    function Add(AObject: TInOutRoomInfo): Integer;
    property Items[Index: Integer]: TInOutRoomInfo read GetItem write SetItem; default;
    {功能:转换为json串}
    function ToJsonStr():string;

  end;
  *)

  //////////////////////////////////////////////////////////////////////////////
  ///类名:TWaitWorkTrainmanInfo
  ///描述:人员候班计划信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfo = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //序号
    nIndex:Integer;
    //记录guid
    strGUID:string;
    //计划guid
    strPlanGUID:string;
    //人员GUID
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员姓名
    strTrainmanName:string;
    //计划状态
    eTMState:TRsPlanState;
    //实际房间
    strRealRoom:string;
    //入寓记录
    InRoomInfo:RRSInOutRoomInfo;
    //出公寓记录
    OutRoomInfo:RRSInOutRoomInfo;
  public
    {功能:获取状态}
    function GetStateStr():string;
  end;
  //////////////////////////////////////////////////////////////////////////////
  ///类名:TWaitWorkTrainmanList
  ///描述:人员候班计划信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitWorkTrainmanInfo;
    procedure SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
  public
    {功能:查找人员}
    function findTrainman(strTrainmanGUID:string): TWaitWorkTrainmanInfo;
    {功能:查找人员按照工号}
    function FindTrainman_GH(strGH:string):TWaitWorkTrainmanInfo;
    {功能:找到第一个空缺人员}
    function FindEmptyTrainman():TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitWorkTrainmanInfo): Integer;
    property Items[Index: Integer]: TWaitWorkTrainmanInfo read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  类名：TWaitWorkPlan
  ///  描述：候班计划
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //序号
    nIndex:Integer;
    //候班计划GUID
    strPlanGUID:string;
    //签点计划GUID
    strSignPlanGUID:string;
    //车间GUID
    strCheJianGUID:string;
    //车间名称
    strCheJianName:string;
    //交路GUID
    strTrainJiaoLuGUID:string;
    //交路名称
    strTrainJiaoLuName:string;
    //交路简称
    strTrainJiaoLuNickName:string;
    //是否启动

    nNeedRest:Integer;
    //计划状态
    ePlanState: TRsPlanState;
    //计划GUID
    strTrainPlanGUID:string ;
    //车次
    strCheCi:string;
    //候班时间
    dtWaitWorkTime:TDateTime;
    //叫班时间
    dtCallWorkTime:TDateTime;
    //出勤时间
    dtBeginWorkTime:TDateTime ;
    //开车时间
    dtKaiCheTime : TDateTime ;
    //房间号
    strRoomNum:string;
    //类型
    ePlanType:TWaitWorkPlanType;
    //需要同步叫班
    nNeedSyncCall:Boolean;
    //人员计划列表
    tmPlanList : TWaitWorkTrainmanInfoList;
  public
    {功能:获取实际人员数量}
    function GetTrainmanCount():Integer;
    {功能:获取未出寓人员总数}
    function GetUnOutRoomTrainmanCount():Integer;
    {功能:判断是否都已出公寓}
    function bAllOutRoom():Boolean;
    {功能:判断是否都已入寓}
    function bAllInRoom():Boolean;
    {功能:增加人员入寓计划}
    function AddTrainman(Trainman:RRsTrainman;var strResult:string):TWaitWorkTrainmanInfo;
    {功能:增加人员}
    procedure AddNewTrianman(strGUID,strNumber,strName:string);
    {功能:获取状态文字}
    function GetStateStr():string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名：TWaitWorkPlanList
  ///  描述：候班计划列表
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlanList = class(TObjectList)

  protected
    function GetItem(Index: Integer): TWaitWorkPlan;
    procedure SetItem(Index: Integer; AObject: TWaitWorkPlan);
  public
    {功能:根据计划id查找计划}
    function Find(strPlanGUID:string):TWaitWorkPlan;
    {功能:根据房间号查找对象}
    function FindByRoomNum(strRoomNum:string):TWaitWorkPlan;
    {功能:查找根据车次}
    function findByCheCi(strCheCi:string):TWaitWorkPlan;
    
    property Items[Index: Integer]: TWaitWorkPlan read GetItem write SetItem; default;
    function Add(AObject: TWaitWorkPlan): Integer;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWaitRoom
  ///  描述:待乘房间信息
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //房间号
    strRoomNum:string;

    //待乘人员列表
    waitManList:TWaitWorkTrainmanInfoList;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRoomWaitManList
  ///  描述:待乘房间入住信息列表
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoomList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitRoom;
    procedure SetItem(Index: Integer; AObject: TWaitRoom);
  public
    {功能:根据房间号查找}
    function Find(strRoomNum:string):TWaitRoom;
    {功能:根据人员GUID查找人员入住信息}
    function FindTrainman(strTrainmanGUID:string):TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitRoom): Integer;
    property Items[Index: Integer]: TWaitRoom read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:RWaitTime
  /// 描述:候班时刻表记录
  ///  /////////////////////////////////////////////////////////////////////////
  RWaitTime = record
    //记录GUID
    strGUID:string;
    //车间GUID
    strWorkshopGUID:string;
    //车间名称
    strWorkShopName:string;
    //交路GUID
    strTrainJiaoLuGUID:string;
    //交路名称
    strTrainJiaoLuName:string;
    //交路别名
    strTrainJiaoLuNickName:string;
    //车次
    strTrainNo:string;
    //房间号
    strRoomNum:string;
    //候班时间
    dtWaitTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //开车时间
    dtKaiCheTime: TDateTime;
  public
    {功能:初始化}
    procedure New();
  end;

  {候班房间时刻表}
  TWaitTimeAry = array of RWaitTime;

const
  TWaitWorkPlanTypeName : array[TWaitWorkPlanType] of string = ('派班','签点','本地');

implementation

{ TWaitWorkPlanList }

function TWaitWorkPlanList.Add(AObject: TWaitWorkPlan): Integer;
begin
  AObject.nIndex := self.Count;
  Result := inherited Add (AObject);
end;

function TWaitWorkPlanList.Find(strPlanGUID: string): TWaitWorkPlan;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strPlanGUID = strPlanGUID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TWaitWorkPlanList.findByCheCi(strCheCi:string):TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if UpperCase(Self.Items[i].strCheCi) = UpperCase(strCheCi) then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;
function TWaitWorkPlanList.FindByRoomNum(strRoomNum: string): TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Self.Items[i].strRoomNum = strRoomNum then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;

function TWaitWorkPlanList.GetItem(Index: Integer): TWaitWorkPlan;
begin
  Result := TWaitWorkPlan( inherited GetItem(Index));
end;

procedure TWaitWorkPlanList.SetItem(Index: Integer; AObject: TWaitWorkPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TWaitWorkPlan }



procedure TWaitWorkPlan.AddNewTrianman(strGUID,strNumber,strName:string);
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  tmPlan:=TWaitWorkTrainmanInfo.Create;
  tmPlan.strGUID := NewGUID;
  tmPlan.strTrainmanGUID := strGUID;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanNumber := strNumber;
  tmPlan.strTrainmanName := strName;
  if tmPlan.strTrainmanGUID <> '' then
    tmPlan.eTMState := psPublish
  else
    tmPlan.eTMState := psEdit;
  self.tmPlanList.Add(tmPlan);
end;

function TWaitWorkPlan.AddTrainman(Trainman:RRsTrainman;var strResult:string): TWaitWorkTrainmanInfo;
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  tmPlan := Self.tmPlanList.findTrainman(Trainman.strTrainmanGUID);
  if Assigned(tmPlan) then //已找到
  begin
    strResult := '计划内不允许有重复的乘务员!';
    Exit;
  end;

  tmPlan := Self.tmPlanList.FindEmptyTrainman();
  if not Assigned(tmPlan) then
  begin
    strResult := '计划内最多允许包含四位乘务员!';
    Exit;
  end;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanGUID := Trainman.strTrainmanGUID;
  tmPlan.strTrainmanNumber := Trainman.strTrainmanNumber;
  tmPlan.strTrainmanName := Trainman.strTrainmanName;
  tmPlan.eTMState := psPublish;

  Result := tmPlan;
end;

function TWaitWorkPlan.bAllInRoom():Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState = psPublish) then
    begin
      result := False;
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.bAllOutRoom: Boolean;
var
  i,nEmptCount:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if Self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState < psOutRoom) then
    begin
      result := False;
      Exit;
    end;
  end;
  
end;

constructor TWaitWorkPlan.Create;
begin
  tmPlanList := TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitWorkPlan.Destroy;
begin
  tmPlanList.Free;
  inherited;
end;


function TWaitWorkPlan.GetStateStr: string;
var
  i:Integer;
begin
  result := '已发布';
  if Self.bAllOutRoom then
  begin
    result := '已离寓';
  end;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    if tmPlanList.Items[i].InRoomInfo.strGUID <>'' then
    begin
      result := '已入寓';
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.GetTrainmanCount: Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if tmInfo.strTrainmanGUID <> '' then
      Inc(result);
  end;
end;
function TWaitWorkPlan.GetUnOutRoomTrainmanCount():Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.eTMState > psPublish) and (tmInfo.eTMState < psOutRoom) then
      Inc(Result);
  end;

end;

{ TWaitWorkTrainmanList }

function TWaitWorkTrainmanInfoList.Add(AObject: TWaitWorkTrainmanInfo): Integer;
begin
  AObject.nIndex := self.Count ;
  result := inherited Add(AObject);
end;

function TWaitWorkTrainmanInfoList.FindEmptyTrainman(
  ): TWaitWorkTrainmanInfo;
var
  i:Integer;
  info:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  if Self.Count <4 then
  begin
    info := TWaitWorkTrainmanInfo.Create;
    Self.Add(info);
  end;

  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = '' then
    begin
      Result := Items[i];
      Break;
    end;
  end;


end;

function TWaitWorkTrainmanInfoList.findTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      Result := items[i];
      Break;
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_GH(
  strGH: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanNumber = strGH then
    begin
      result := Items[i];
    end;    
  end;
end;

function TWaitWorkTrainmanInfoList.GetItem(Index: Integer): TWaitWorkTrainmanInfo;
begin
  result := TWaitWorkTrainmanInfo(inherited GetItem(Index));
end;

procedure TWaitWorkTrainmanInfoList.SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
begin
  SetItem(Index,AObject);
end;
(*
{ TInOutRoomInfoList }

function TInOutRoomInfoList.Add(AObject: TInOutRoomInfo): Integer;
begin
  Result := inherited Add(AObject);
end;

function TInOutRoomInfoList.GetItem(Index: Integer): TInOutRoomInfo;
begin
  result := TInOutRoomInfo(inherited GetItem(Index));
end;

procedure TInOutRoomInfoList.SetItem(Index: Integer; AObject: TInOutRoomInfo);
begin
  inherited SetItem(Index,AObject);
end;

function TInOutRoomInfoList.ToJsonStr: string;
var
  i:Integer;
  iJson: ISuperObject;
  infoJson:ISuperObject;
begin
  for i := 0 to self.Count - 1 do
  begin
    infoJson := so(Self.Items[i].ToJsonStr);
    iJson.AsArray.Add(infoJson);
  end;
  result := iJson.asstring;
  iJson := nil;
end;
 *)
{ TWaitWorkTrainmanInfo }

constructor TWaitWorkTrainmanInfo.Create;
begin
end;

destructor TWaitWorkTrainmanInfo.Destroy;
begin
  inherited;
end;

{ TInOutRoomInfo }

function TWaitWorkTrainmanInfo.GetStateStr: string;
begin
  result := '';
  if Self.strTrainmanGUID <> '' then
    Result := '未入寓';
  if Self.eTMState > psPublish then
    result := TRsPlanStateNameAry[Self.eTMState];
  Exit;

  if strTrainmanGUID = '' then Exit;
  
  result := '未入寓';
  if Self.InRoomInfo.strGUID <> '' then
  begin
    result := '已入寓';
  end;
  if Self.OutRoomInfo.strGUID <> '' then
  begin
    result := '已离寓';
  end;
  
end;
 (*
procedure TInOutRoomInfo.Reset;
begin
  Self.strGUID := '';
  Self.strPlanGUID := '';
  Self.strTrainmanGUID := '';
  self.eType := TInRoom;
  Self.dtTime := 0;
  Self.dtArriveTime := 0;
  bUpload := False;
end;

procedure TInOutRoomInfo.SetValues(strGUID, strPlanGUID, strTrainmanGUID: string;
    eType: TInOutRoomType; dtTime: TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
begin
  Self.strGUID := strGUID;
  Self.strPlanGUID := strPlanGUID;
  Self.strTrainmanGUID := strTrainmanGUID;
  self.eType := eType;
  Self.dtTime := dtTime;
  self.dtArriveTime := dtArriveTime;
  Self.ePlanType := ePlanType;
  bUpload := False;
end;


function TInOutRoomInfo.ToJsonStr: string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  jso.S['strGUID'] := strGUID;
  jso.s['strWaitPlanGUID'] := strPlanGUID;
  jso.s['strTrainmanGUID'] := strTrainmanGUID;
  jso.I['InOutRoomType'] := Ord(eType);
  jso.s['dtArriveTime']:= FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  jso.s['dtTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  if ePlanType = TWWPT_ASSIGN then
    jso.S['strTrainPlanGUID'] := strPlanGUID;
  Result := jso.AsString;
  jso := nil;
end;
  *)

{ TSyncPlanIDInfoList }

function TSyncPlanIDInfoList.Add(AObject: TSyncPlanIDInfo): Integer;
begin
  result := inherited Add(AObject);
end;

function TSyncPlanIDInfoList.GetItem(Index: Integer): TSyncPlanIDInfo;
begin
  result := TSyncPlanIDInfo(inherited GetItem(Index));
end;

procedure TSyncPlanIDInfoList.SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
begin
  inherited SetItem(Index,AObject);
end;



{ TWaitRoomList }

function TWaitRoomList.Add(AObject: TWaitRoom): Integer;
begin
  Result:= inherited Add(AObject);
end;

function TWaitRoomList.Find(strRoomNum: string): TWaitRoom;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strRoomNum = strRoomNum then
    begin
      result := Items[i];
      Exit;
    end;
  end;
end;

function TWaitRoomList.FindTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    result := self.Items[i].waitManList.findTrainman(strTrainmanGUID);
    if Assigned(Result) then Exit;
  end;
end;

function TWaitRoomList.GetItem(Index: Integer): TWaitRoom;
begin
  result := TWaitRoom(inherited GetItem(index) );
end;

procedure TWaitRoomList.SetItem(Index: Integer;
  AObject: TWaitRoom);
begin
  inherited SetItem(index,AObject);
end;

{ TWaitWorkRoomInfo }

constructor TWaitRoom.Create;
begin
  waitManList:=TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitRoom.Destroy;
begin
  waitManList.Free;
  inherited;
end;



{ RRSInOutRoomInfo }

function RRSInOutRoomInfo.ToJsonStr(inOutType:TInOutRoomType): string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  if inOutType = TInRoom then
  begin
    jso.S['strInRoomGUID'] := strGUID;
    jso.S['dtInRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nInRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  if inOutType = TOutRoom then
  begin
    jso.S['strOutRoomGUID'] := strGUID;
    jso.S['dtOutRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nOutRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  jso.S['strTrainPlanGUID'] := strTrainPlanGUID;
  jso.S['strTrainmanNumber'] := strTrainmanNumber;
  jso.S['strTrainmanGUID'] := strTrainmanGUID ;
  jso.S['strDutyUserGUID'] := strDutyUserGUID   ;
  jso.S['strSiteGUID'] := strSiteGUID  ;
  jso.S['strRoomNumber'] := strRoomNumber  ;
  jso.I['nBedNumber'] := nBedNumber  ;
  jso.S['dtCreateTime'] := TPubFun.dateTime2Str(dtCreatetTime)  ;
  jso.S['strWaitPlanGUID'] := strWaitPlanGUID  ;
  jso.I['ePlanType']  := Ord(eWaitPlanType) ;
  jso.S['dtArriveTime'] := TPubFun.DateTime2Str(dtArriveTime);
  //jso.I['bUpLoaded'] := TPubFun.Bool2Int(bUploaded)  ;
  Result := jso.AsString;
  jso := nil;
end;

{ RWaitTime }

procedure RWaitTime.New;
begin
  strGUID := NewGUID();
  strWorkshopGUID:='';
  strWorkShopName:='';
  strTrainJiaoLuGUID:='';
  strTrainJiaoLuName:='';
  strTrainJiaoLuNickName:='';
  strTrainNo:='';
  strRoomNum:='';
  dtWaitTime:=0;
  dtCallTime:=0;
  dtChuQinTime:=0;
  dtKaiCheTime:=0;
end;

end.
