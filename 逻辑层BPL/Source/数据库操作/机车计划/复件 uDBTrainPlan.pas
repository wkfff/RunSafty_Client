unit uDBTrainPlan;

interface

uses
  ADODB,Classes,uTrainPlan,uTFSystem,uTrainmanJiaolu,uTrainman,uApparatusCommon,
  Dialogs,uTFVariantUtils,Variants,uSaftyEnum,uDBTrainmanJiaolu,uDrink,
  uSite,uDutyUser;

type
  //////////////////////////////////////////////////////////////////////////////
  ///机车计划操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainPlan = class(TDBOperate)
  private
    //功能：从adoquery中读取数据放入RTrainplan结构中
    class procedure TrainPlanFromADOQuery(var TrainPlan:RRsTrainPlan;ADOQuery : TADOQuery);
    //功能：从adoquery中读取数据放入RChuQinPlan结构中
    class procedure InOutPlanFromADOQuery(var InOutPlan : RRsInOutPlan ;ADOQuery : TADOQuery);
  public
    //功能：获取需要出入寓叫班的计划
    class procedure GetInOutPlans(ADOConn : TADOConnection;BeginTime,EndTime : TDateTime;SiteGUID:string;
      out InOutPlanArray : TRsInOutPlanArray);
     //功能：获取需要出入寓叫班的计划
    class function GetInOutPlanDetail(ADOConn : TADOConnection; TrainPlanGUID:string;out InOutPlan : RRsInOutPlan) : boolean;
     //功能：获取人员所在的能够退勤的计划
    class function GetTrainmanInOutPlan(ADOConn : TADOConnection;trainmanGUID:string;var InOutPlan : RRsInOutPlan):boolean;
    //功能：入寓登记
    class function InRoom(ADOConn : TADOConnection;InRoomInfo :RRsInRoomInfo):boolean;
    //功能：离寓登记
    class function OutRoom(ADOConn : TADOConnection;OutRoomInfo :RRsOutRoomInfo):boolean;
    //功能：修改强休计划的叫班时间
    class function UpdatePlanRecordTime(ADOConn : TADOConnection;TrainPlanGUID : string):boolean;
    //功能：修改计划的房间号
    class function EditPlanRoom(ADOConn : TADOConnection;TrainPlanGUID : string;RoomNumber : string):boolean;
  private
    //从ADOQuery填充机车计划
    procedure ADOQueryToTrainPlan(ADOQuery : TADOQuery;out TrainPlan :  RRsTrainPlan);
    //将机车计划信息填充到ADOQuery中
    procedure TrainPlanToADOQuery(ADOQuery : TADOQuery;TrainPlan : RRsTrainPlan; UpdateState : boolean = true);
    //ADOQuery填充到出勤地点设置结构中
    procedure ADOQueryToChuQinDiDian(ADOQuery : TADOQuery; out CQDD : RRsChuQinDiDian);
     //从ADOQuery填充人员计划
    procedure ADOQueryToTrainmanPlan(ADOQuery : TADOQuery;out TrainmanPlan :  RRsTrainmanPlan);
    //从ADOQuery填充计划下发日志
    procedure ADOQueryToSendLog(ADOQuery : TADOQuery; out  SendLog : RRsTrainPlanSendLog);
    //从ADOQuery填充到机组信息
    procedure ADOQueryToGroup(ADOQuery : TADOQuery;out Group: RRsGroup);
    //从ADOquery中填充到出勤计划中
    procedure ADOQueryToChuQinPlan(ADOQuery : TADOQuery;out ChuQinPlan : RRsChuQinPlan;
      NeedPicture : boolean);
    //从ADOquery中填充到退勤计划中
    procedure ADOQueryToTuiQinPlan(ADOQuery : TADOQuery;out TuiQinPlan : RRsTuiQinPlan);
    procedure GetSubPlans(PlanGUIDs : TStrings;SubPlanGUIDs: TStrings);
    function CancleRelativePlan(PlanGUIDs : TStrings;SiteGUID:String;DutyUserGUID:string): Boolean;
  public
    //功能：添加机车计划
    procedure Add(TrainPlan : RRsTrainPlan);
    //功能：修改机车计划
    procedure Update(TrainPlan : RRsTrainPlan;DTNow : Tdatetime;SiteGUID:String;DutyUserGUID:string);
    //功能：删除机车计划
    procedure Delete(TrainPlanGUID : string);
    //功能：获取机车计划
    function GetPlan(TrainPlanGUID : string;var TrainPlan : RRsTrainPlan):boolean;
    //获取出勤地点设置信息
    function GetChuQinDiDian(StationGUID : string; out CQDD : RRsChuQinDiDian) : boolean;
    //功能：获取机车计划
    procedure GetTrainPlans(BeginDateTime:TDateTime;EndDateTime : TDateTime;
      TrainJiaoluGUID :string;PlanStateSet : TRsPlanStateSet;out TrainPlanArray : TRsTrainPlanArray);
    //功能：从图定车次计划表中加载并生成指定时间范围内的加载机车计划
    procedure LoadTrainPlan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string);
    //功能:在派班功能中从图定车次加载计划
    procedure LoadTrainPlanByPaiBan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string);
     //功能：撤销计划
    function CancelPlan(PlanGUIDs : TStrings;SiteGUID:String;DutyUserGUID:string) : boolean;
    //功能：判断是否满足删除条件
    function CanCanlePlan(PlanGUIDs : TStrings;var strError: string): Boolean;
    //功能：下发计划
    function SendPlan(PlanGUIDS : TStrings;SiteGUID:String;DutyUserGUID:string) : boolean;
    //功能：根据车次和时间获取计划
    function GetPlanByTrainNo(strTrainNo: string;dtStartTime: TDateTime; var TrainPlan : RRsTrainPlan): Boolean;

  public
    //获取所有人员计划信息
    procedure GetTrainmanPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUID : string;
      out TrainmanPlanArray : TRsTrainmanPlanArray); overload;
      
    procedure RefreshTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan);
    //获取已下发的人员计划信息
    procedure GetSentTrainmanPlans(BeginTime, EndTime: TDateTime;SiteGUID : string;
      TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);

    procedure GetNeedCombineTrainmanPlans(SiteGUID : string;out TrainmanPlanArray: TRsTrainmanPlanArray);
 
    //获取指定GUID的人员计划信息
    function GetTrainmanPlan(TrainmanPlanGUID : string;var TrainmanPlan : RRsTrainmanPlan):boolean;overload;
    //获取指定派班室可接收的计划的下发信息
    procedure GetSendLog(SiteGUID : string;LastTime : TDateTime;out SendLogArray : TRsTrainPlanSendLogArray);overload;

    procedure GetSendLog(SiteGUID : string;PlanGUIDS: TStringList;out SendLogArray : TRsTrainPlanSendLogArray);overload;
    //功能：接收计划
    procedure ReceivePlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID:string);
    //功能：发布计划
    procedure PublishPlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID:string);    
    //判断两个人员计划的数组是否相等
    function EqualTrainmanPlan(Source,Dest : TRsTrainmanPlanArray):boolean;
    //获取某个乘务员对于莫条计划来说的提前出勤时间和休息信息设置
    function GetChuQinSetInfo(TrainPlan : RRsTrainPlan;Trainman:RRsTrainman;out
      ChuQinTime : TDateTime;out Rest : RRsRest) : boolean;
    //将人员从计划中移除，并不影响名牌操作
    procedure DeleteTrainmanFromPlan(TrainmanPlanGUID : string;TrainmanIndex : integer);
    //设置计划的值乘机组信息
    procedure SetGroupToPlan(Group : RRsGroup;TrainPlan: RRsTrainPlan;
      DutyUserGUID,DutySiteGUID  : string);
    //设置出勤时间
    procedure SetBeginWorkTime(TrainPlanGUID : string;
      OldBeginWorkTime,NewBeginWorkTime : TDateTime;
      DutyUser : TRsDutyUser; DutySite : TRsSiteInfo);
    //功能：设置计划强休信息
    procedure SetPlanRest(TrainPlanGUID:string;OldRest,NewRest : RRsRest;DutyUser : TRsDutyUser; DutySite : TRsSiteInfo);
  
    //轮乘拍班
    procedure OrderDispath(TrainJiaoluGUID : string;TrainmanJiaolus : TStrings;
      DutyUser : TRsDutyUser; DutySite : TRsSiteInfo);
    //获取指定计划应该安排的包成机车的机组信息
    function GetBaoChengGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
    //获取指定计划应该安排的轮乘的机组信息
    function GetLunChengGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
    //获取指定计划应该安排的记名式的机组信息
    function GetJiMingGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
    //获取指定人员交路且混淆个别匹配项目后计划应该安排的轮乘的机组信息
    function GetLunChengFixedGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;
      TrainmanJiaolus : TStrings;
      FixKehuoArray : TRsKeHuoIDArray;FixTrainmanTypeArray : TRsTrainmanTypeArray;
      FixDragTypeArray : TRsDragTypeArray;
      out Group : RRsGroup) : boolean;
  public
    //获取需要出勤的计划信息
    procedure GetNeedChuQinPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUID : string;
      out ChuQinPlanArray : TRsChuQinPlanArray);
    //获取客户端管辖区段内需要出勤的计划信息
    procedure GetNeedChuQinPlansOfSite(BeginTime,EndTime : TDateTime;SiteGUID : string;
      out ChuQinPlanArray : TRsChuQinPlanArray);
    //获取出勤计划信息
    function GetChuQinPlan(ChuQinPlanGUID : string;var ChuQinPlan : RRsChuQinPlan):boolean;overload;
    //获取出勤计划信息
    function GetChuQinPlanByTraiNo(TrainNo : string;out TrainmanPlan : RRsTrainmanPlan):boolean;overload;
    //获取指定工号的乘务员所在的出勤计划
    function GetTrainmanChuQinPlan(TrainmanGUID : string;
      out ChuQinPlan : RRsChuQinPlan;SiteGUID : string) : boolean;
    //判断两个人员计划的数组是否相等
    function EqualChuQinPlan(Source,Dest : TRsChuQinPlanArray):boolean;
    //指定的乘务员执行出勤操作
    procedure BeginWork(TrainmanGUID : string;
      TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
      DutyUserGUID:string;BeginWorkStationGUID:string;DTNow : TDateTime);
    //获取测酒记录
    function GetTrainmanDrinkInfo(strTrainmanGUID,strTrainPlanGUID: string;
        WorkType: TRsWorkTypeID;var RsDrink : RRsDrink): Boolean;

  public
    //获取需要出勤的计划信息
    procedure GetNeedTuiQinPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUID : string;
      out TuiQinPlanArray : TRsTuiQinPlanArray);
    //获取客户端管辖区段内需要出勤的计划信息
    procedure GetNeedTuiQinPlansOfSite(BeginTime,EndTime : TDateTime;SiteGUID : string;
      out TuiQinPlanArray : TRsTuiQinPlanArray;nOutWorkHours : integer = 17);
     //获取指定工号的乘务员所在的出勤计划
    function GetTrainmanTuiQinPlan(TrainmanGUID : string;
      out TuiQinPlan : RRsTuiQinPlan;SiteGUID : string) : boolean;
    //获取最后一次退勤记录GUID
    function GetLastTuiQinRecord(TrainmanGUID : string;var strEndWorkGUID: string;
        var EndWorkTime: TDateTime):Boolean;        
    //获取指定工号的乘务员所在的出勤计划
    function GetTuiQinPlan(TuiQinPlanGUID  : string;out TuiQinPlan : RRsTuiQinPlan) : boolean;
    //指定的乘务员执行退勤操作
    procedure EndWork(TrainmanGUID : string;
      TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
      DutyUserGUID:string;EndWorkStationGUID:string;ArriveTime,LastEndWorkTime : TDateTime);
    //获取计划的最后到达时间
    function GetPlanLastArriveTime(TrainPlanGUID : string; out ArriveTime: TDateTime) : boolean;
    //更新退勤测酒结果
    procedure UpdateEndWorkTestResult(strEndWorkGUID: string;RsDrink : RRsDrink);
    //删除退勤记录
    procedure RemoveEndWorkRecord(strEndWorkGUID: string);
    //包乘翻牌,需要提供翻牌人，值乘计划，所在车站，是否出勤翻牌
    procedure TurnPlateOrder(TrainmanGUID : string;TrainmanPlan:RRsTrainmanPlan;
      TrainmanJiaoluGUID : STRING;nRunType : TRsRunType;StationGUID : string;
      ArriveTime : TDateTime;IsBeginWork : boolean);
    //记名式交路翻牌
    procedure TurnPlateNamed(TrainmanJiaoluGUID : string);
    //判断两个人员计划的数组是否相等
    function EqualTuiQinPlan(Source,Dest : TRsTuiQinPlanArray):boolean;
    //根据工号获取乘务员的计划
    function GetPlanByTrainmanNumber(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer) : boolean;
  public
    //功能：记名式交路推牌
    function PushNameplateNamed(TrainmanJiaoluGUID:string;DutyUserGUID:string) : boolean;
    //更新计划状态，用于计划的人员添加或者删除后引起的计划状态的变化
    procedure UpdatePlanState(TrainPlanGUID : string);
    //添加外段测酒记录
    procedure AddForeignDrink(TrainmanNumber : string ;RsDrink : RRsDrink; DutyUserGUID : string);
    //清楚计划的异常状态、该人员所在组但是计划中的组信息不是该组
    procedure ClearTrainmanPlanError(GroupGUID : string);
    //获取人员当前正在值乘的计划
    function GetPlanOfTrainman(TrainmanGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取当前机组正在值乘的计划
    function GetPlanOfGroup(GroupGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取当前包乘机车内正在值乘的计划信息
    function GetPlanOfTrain(TrainGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取当前机组正在值乘的计划
    function ReloadGroupOfPlan(TrainPlanGUID  :string) : boolean;
  end;

implementation
uses
  SysUtils, DB,DateUtils;
{ TDBTrainPlan }

procedure TRsDBTrainPlan.Add(TrainPlan: RRsTrainPlan);
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  strGUID := NewGUID;
  strSql := 'Select * from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      TrainPlanToADOQuery(ADOQuery,TrainPlan);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.AddForeignDrink(TrainmanNumber: string;RsDrink : RRsDrink; DutyUserGUID : string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      //插入新的测酒记录
      strSql := 'insert into TAB_Drink_Information (strGUID,strTrainmanGUID, ' +
        ' nDrinkResult,dtCreateTime,strAreaGUID,strDutyGUID,nVerifyID,strWorkID,nWorkTypeID,strImagePath) ' +
        ' values (:strGUID,:strTrainmanGUID,:nDrinkResult,getdate(),' +
        ' :strAreaGUID,:strDutyGUID,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath)';
      SQL.Text := strSql;
      Parameters.ParamByName( 'strGUID').Value := NewGUID;
      Parameters.ParamByName( 'strTrainmanGUID').Value := TrainmanNumber;
      Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
      Parameters.ParamByName('strImagePath').Value := RsDrink.strPictureURL;

      Parameters.ParamByName( 'strAreaGUID').Value := '';
      Parameters.ParamByName( 'strDutyGUID').Value := DutyUserGUID;
      Parameters.ParamByName( 'nVerifyID').Value := Ord(rfInput);
      Parameters.ParamByName( 'strWorkID').Value := '';
      Parameters.ParamByName( 'nWorkTypeID').Value :=10;

      if ExecSQL = 0 then
      begin
        Exception.Create('添加出勤测酒记录失败');
        exit;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToChuQinDiDian(ADOQuery: TADOQuery;
out  CQDD: RRsChuQinDiDian);
begin
  with ADOQuery do
  begin
    CQDD.strGUID := FieldByName('strGUID').AsString;
    CQDD.strStationGUID := FieldByName('strStationGUID').AsString;
    CQDD.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    CQDD.nLocalRest := FieldByName('nLocalRest').AsInteger;
    CQDD.nLocalPre := FieldByName('nLocalPre').AsInteger;
    CQDD.nOutRest := FieldByName('nOutRest').AsInteger;
    CQDD.nOutPre := FieldByName('nOutPre').AsInteger;
    CQDD.nZJPre := FieldByName('nZJPre').AsInteger;
    CQDD.nNightReset := FieldByName('nNightReset').AsInteger;
    CQDD.bIsRest := FieldByName('bIsRest').AsInteger;
    CQDD.dtRestTime := FieldByName('dtRestTime').AsDateTime;
    CQDD.dtCallTime := FieldByName('dtCallTime').AsDateTime;
    CQDD.nContinueHours := FieldByName('nContinueHours').AsInteger;
    CQDD.bRuKuFanPai := FieldByName('bRuKuFanPai').AsInteger;
    CQDD.bLocalChaolao := FieldByName('bLocalChaolao').AsInteger;
    CQDD.bOutChaoLao := FieldByName('bOutChaoLao').AsInteger;
  end;
end;



procedure TRsDBTrainPlan.ADOQueryToChuQinPlan(ADOQuery: TADOQuery;
  out ChuQinPlan: RRsChuQinPlan;NeedPicture : boolean);
begin
  ADOQueryToTrainPlan(ADOQuery,ChuQinPlan.TrainPlan);

  ChuQinPlan.dtBeginWorkTime := ADOQuery.FieldByName('dtChuQinTime').AsDateTime;
  
  ChuQinPlan.ChuQinGroup.Group.strGroupGUID := ADOQuery.FieldByName('strGroupGUID').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman1.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman1.strTrainmanName := ADOQuery.FieldByName('strTrainmanName1').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman1.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber1').AsString;

  ChuQinPlan.ChuQinGroup.Group.Trainman2.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman2.strTrainmanName := ADOQuery.FieldByName('strTrainmanName2').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman2.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber2').AsString;

  ChuQinPlan.ChuQinGroup.Group.Trainman3.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID3').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman3.strTrainmanName := ADOQuery.FieldByName('strTrainmanName3').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman3.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber3').AsString;


  
  if ADOQuery.FindField('strBeginWorkMemo') <> nil then
    ChuQinPlan.ChuQinGroup.strChuQinMemo := ADOQuery.FieldByName('strBeginWorkMemo').AsString;
  if not ADOQuery.FieldByName('nVerifyID1').IsNull then
    ChuQinPlan.ChuQinGroup.nVerifyID1 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID1').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult1').IsNull then
    ChuQinPlan.ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult1').AsInteger);
  ChuQinPlan.ChuQinGroup.TestAlcoholInfo1.dtTestTime :=  ADOQuery.FieldByName('dtTestTime1').AsDateTime;
  if not ADOQuery.FieldByName('nVerifyID2').IsNull then
    ChuQinPlan.ChuQinGroup.nVerifyID2 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID2').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult2').IsNull then
    ChuQinPlan.ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult2').AsInteger);

  ChuQinPlan.ChuQinGroup.TestAlcoholInfo2.dtTestTime :=  ADOQuery.FieldByName('dtTestTime2').AsDateTime;

  if not ADOQuery.FieldByName('nVerifyID3').IsNull then
    ChuQinPlan.ChuQinGroup.nVerifyID3 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID3').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult3').IsNull then
    ChuQinPlan.ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult3').AsInteger);
  ChuQinPlan.ChuQinGroup.TestAlcoholInfo3.dtTestTime :=  ADOQuery.FieldByName('dtTestTime3').AsDateTime;

end;

procedure TRsDBTrainPlan.ADOQueryToGroup(ADOQuery: TADOQuery; out Group: RRsGroup);
begin
  with ADOQuery do
  begin
    Group.strGroupGUID := FieldByName('strGroupGUID').AsString;
    if FindField('strZFQJGUID') <> nil then
    begin
      Group.ZFQJ.strZFQJGUID := FieldByName('strZFQJGUID').AsString;
      Group.ZFQJ.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
      Group.ZFQJ.nQuJianIndex := FieldByName('nQuJianIndex').AsInteger;
      Group.ZFQJ.strBeginStationGUID := FieldByName('strBeginStationGUID').AsString;
      Group.ZFQJ.strBeginStationName := FieldByName('strBeginStationName').AsString;
      Group.ZFQJ.strEndStationGUID := FieldByName('strEndStationGUID').AsString;
      Group.ZFQJ.strEndStationName := FieldByName('strEndStationName').AsString;
    end;

    Group.Trainman1.strTrainmanGUID := FieldByName('strTrainmanGUID1').AsString;
    Group.Trainman1.strTrainmanName := FieldByName('strTrainmanName1').AsString;
    Group.Trainman1.strTrainmanNumber := FieldByName('strTrainmanNumber1').AsString;
    Group.Trainman1.strTelNumber := FieldByName('strTelNumber1').AsString;
    if FieldByName('nTrainmanState1').IsNull then
      Group.Trainman1.nTrainmanState := tsNil
    else
      Group.Trainman1.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState1').AsInteger);

    Group.Trainman1.nPostID := TRsPost(adoQuery.FieldByName('nPost1').asInteger);
    Group.Trainman1.strWorkShopGUID := FieldByName('strWorkShopGUID1').AsString;
    Group.Trainman1.dtLastEndworkTime := FieldByName('dtLastEndworkTime1').AsDateTime;


    Group.Trainman2.strTrainmanGUID := FieldByName('strTrainmanGUID2').AsString;
    Group.Trainman2.strTrainmanName := FieldByName('strTrainmanName2').AsString;
    Group.Trainman2.strTrainmanNumber := FieldByName('strTrainmanNumber2').AsString;
    Group.Trainman2.strTelNumber := FieldByName('strTelNumber2').AsString;
    if FieldByName('nTrainmanState2').IsNull then
      Group.Trainman2.nTrainmanState := tsNil
    else
      Group.Trainman2.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState2').AsInteger);
    Group.Trainman2.nPostID := TRsPost(adoQuery.FieldByName('nPost2').asInteger);
    Group.Trainman2.strWorkShopGUID := FieldByName('strWorkShopGUID2').AsString;
    Group.Trainman2.dtLastEndworkTime := FieldByName('dtLastEndworkTime2').AsDateTime;


    Group.Trainman3.strTrainmanGUID := FieldByName('strTrainmanGUID3').AsString;
    Group.Trainman3.strTrainmanName := FieldByName('strTrainmanName3').AsString;
    Group.Trainman3.strTrainmanNumber := FieldByName('strTrainmanNumber3').AsString;
    Group.Trainman3.strTelNumber := FieldByName('strTelNumber3').AsString;
    if FieldByName('nTrainmanState3').IsNull then
      Group.Trainman3.nTrainmanState := tsNil
    else
      Group.Trainman3.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState3').AsInteger);
    Group.Trainman3.nPostID := TRsPost(adoQuery.FieldByName('nPost3').asInteger);
    Group.Trainman3.strWorkShopGUID := FieldByName('strWorkShopGUID3').AsString;
    Group.Trainman3.dtLastEndworkTime := FieldByName('dtLastEndworkTime3').AsDateTime;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToSendLog(ADOQuery: TADOQuery;
  out SendLog: RRsTrainPlanSendLog);
begin
  with ADOQuery do
  begin
    SendLog.strTrainNo := FieldByname('strTrainNo').AsString; 
    SendLog.strSendGUID := FieldByname('strSendGUID').AsString;
    SendLog.strTrainPlanGUID := FieldByname('strTrainPlanGUID').AsString;
    SendLog.strTrainJiaoluName := FieldByname('strTrainJiaoluName').AsString;
    SendLog.dtStartTime := FieldByname('dtStartTime').AsDateTime;
    SendLog.dtRealStartTime := FieldByname('dtRealStartTime').AsDateTime;
    SendLog.strSendSiteName := FieldByname('strSendSiteName').AsString;
    SendLog.dtSendTime := FieldByname('dtSendTime').AsDateTime;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToTrainmanPlan(ADOQuery: TADOQuery;
  out TrainmanPlan: RRsTrainmanPlan);
begin
  ADOQueryToTrainPlan(ADOQuery,TrainmanPlan.TrainPlan);

  TrainmanPlan.RestInfo.nNeedRest := ADOQuery.FieldByName('nNeedRest').AsInteger;
  TrainmanPlan.RestInfo.dtArriveTime := ADOQuery.FieldByName('dtArriveTime').AsDateTime;
  TrainmanPlan.RestInfo.dtCallTime := ADOQuery.FieldByName('dtCallTime').AsDateTime;

  TrainmanPlan.dtBeginWorkTime := ADOQuery.FieldByName('dtChuQinTime').AsDateTime;

  TrainmanPlan.Group.strGroupGUID := ADOQuery.FieldByName('strGroupGUID').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanName := ADOQuery.FieldByName('strTrainmanName1').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber1').AsString;

  TrainmanPlan.Group.Trainman2.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  TrainmanPlan.Group.Trainman2.strTrainmanName := ADOQuery.FieldByName('strTrainmanName2').AsString;
  TrainmanPlan.Group.Trainman2.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber2').AsString;

  TrainmanPlan.Group.Trainman3.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID3').AsString;
  TrainmanPlan.Group.Trainman3.strTrainmanName := ADOQuery.FieldByName('strTrainmanName3').AsString;
  TrainmanPlan.Group.Trainman3.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber3').AsString;
end;


procedure TRsDBTrainPlan.ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan :  RRsTrainPlan);
begin
  with ADOQuery do
  begin
    TrainPlan.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    TrainPlan.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainPlan.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainPlan.strTrainNo := FieldByName('strTrainNo').AsString;
    TrainPlan.dtStartTime :=  FieldByName('dtStartTime').Value;
    TrainPlan.dtRealStartTime :=  0;
    if not FieldByName('dtRealStartTime').IsNull then
      TrainPlan.dtRealStartTime := FieldByName('dtRealStartTime').Value;
    TrainPlan.dtFirstStartTime := FieldByName('dtRealStartTime').Value;
    TrainPlan.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainPlan.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainPlan.strStartStation := FieldByName('strStartStation').AsString;
    TrainPlan.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainPlan.strEndStation := FieldByName('strEndStation').AsString;
    TrainPlan.strEndStationName := FieldByName('strEndStationName').AsString;
    TrainPlan.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').AsInteger);
    TrainPlan.nPlanType := TRsPlanType(FieldByName('nPlanType').AsInteger);
    TrainPlan.nDragType := TRsDragType(FieldByName('nDragType').AsInteger);
    TrainPlan.nKeHuoID := TRsKehuo(FieldByName('nKeHuoID').asInteger);
    TrainPlan.nRemarkType := TRsPlanRemarkType(FieldByName('nRemarkType').AsInteger);
    TrainPlan.strRemark := FieldByName('strRemark').AsString;
    TrainPlan.nPlanState := TRsPlanState(FieldByName('nPlanState').AsInteger);
    TrainPlan.dtLastArriveTime := FieldByName('dtLastArriveTime').asdatetime;
    TrainPlan.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    TrainPlan.strCreateSiteGUID := FieldByName('strCreateSiteGUID').AsString;
    TrainPlan.strCreateUserGUID := FieldByName('strCreateUserGUID').AsString;
    TrainPlan.strMainPlanGUID := FieldByName('strMainPlanGUID').AsString 
  end;
end;


procedure TRsDBTrainPlan.ADOQueryToTuiQinPlan(ADOQuery: TADOQuery;
  out TuiQinPlan: RRsTuiQinPlan);
begin
  ADOQueryToTrainPlan(ADOQuery,TuiQinPlan.TrainPlan);

  TuiQinPlan.dtBeginWorkTime := ADOQuery.FieldByName('dtChuQinTime').AsDateTime;
  TuiQinPlan.TuiQinGroup.Group.strGroupGUID := ADOQuery.FieldByName('strGroupGUID').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman1.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman1.strTrainmanName := ADOQuery.FieldByName('strTrainmanName1').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman1.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber1').AsString;

  TuiQinPlan.TuiQinGroup.Group.Trainman2.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman2.strTrainmanName := ADOQuery.FieldByName('strTrainmanName2').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman2.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber2').AsString;

  TuiQinPlan.TuiQinGroup.Group.Trainman3.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID3').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman3.strTrainmanName := ADOQuery.FieldByName('strTrainmanName3').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman3.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber3').AsString;


  if not ADOQuery.FieldByName('nVerifyID1').IsNull then
    TuiQinPlan.TuiQinGroup.nVerifyID1 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID1').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult1').IsNull then
    TuiQinPlan.TuiQinGroup.TestAlcoholInfo1.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult1').AsInteger);
  TuiQinPlan.TuiQinGroup.TestAlcoholInfo1.dtTestTime :=  ADOQuery.FieldByName('dtTestTime1').AsDateTime;

  if not ADOQuery.FieldByName('nVerifyID2').IsNull then
    TuiQinPlan.TuiQinGroup.nVerifyID2 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID2').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult2').IsNull then
    TuiQinPlan.TuiQinGroup.TestAlcoholInfo2.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult2').AsInteger);

  TuiQinPlan.TuiQinGroup.TestAlcoholInfo2.dtTestTime :=  ADOQuery.FieldByName('dtTestTime2').AsDateTime;
  if not ADOQuery.FieldByName('nVerifyID3').IsNull then
    TuiQinPlan.TuiQinGroup.nVerifyID3 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID3').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult3').IsNull then
    TuiQinPlan.TuiQinGroup.TestAlcoholInfo3.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult3').AsInteger);
  TuiQinPlan.TuiQinGroup.TestAlcoholInfo3.dtTestTime :=  ADOQuery.FieldByName('dtTestTime3').AsDateTime;
end;

procedure TRsDBTrainPlan.BeginWork(TrainmanGUID : string;
  TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
  DutyUserGUID: string;BeginWorkStationGUID:string;DTNow : TDateTime);
var
  strSql : string;
  adoQuery : TADOQuery;
  beginWorkID : string;
  strTrainmanJiaoluGUID : string;
  nRunType : TRsRunType;
  nTurnOrder : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        beginWorkID := NewGUID;
        nTurnOrder :=0 ;
        strSql := 'select bIsBeginWorkFP from TAB_Base_TrainJiaolu where strTrainJiaoluGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainJiaoluGUID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount > 0 then
        begin
          nTurnOrder := FieldByName('bIsBeginWorkFP').AsInteger;
        end;

        //保存出勤记录
        strSql := 'select * from TAB_Plan_BeginWork where strTrainPlanGUID = %s and strTrainmanGUID = %s';


        strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
            QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strBeginWorkGUID').AsString := beginWorkID;
          FieldByName('strTrainPlanGUID').AsString := TrainmanPlan.TrainPlan.strTrainPlanGUID;
          FieldByName('strTrainmanGUID').AsString := TrainmanGUID;
          FieldByName('dtCreateTime').AsString := FormatDateTime('yyyy-MM-dd HH:nn:ss',dtnow);
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strStationGUID').AsString := BeginWorkStationGUID;
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end else begin
          Edit;
          beginWorkID := FieldByName('strBeginWorkGUID').AsString;
          FieldByName('dtCreateTime').AsString := FormatDateTime('yyyy-MM-dd HH:nn:ss',dtnow);
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end;
        Post;
        
        //保存测酒记录
        //删除老的测酒记录
        strSQL := 'delete from TAB_Drink_Information where strWorkID = %s and nWorkTypeID=%d and strTrainmanGUID = %s';
        strSql := Format(strSql,[QuotedStr(beginWorkID),2,QuotedStr(TrainmanGUID)]);
        Sql.Text := strSql;
        ExecSQL;
        //插入新的测酒记录
        strSql := 'insert into TAB_Drink_Information (strGUID,strTrainmanGUID, ' +
          ' nDrinkResult,dtCreateTime,strAreaGUID,strDutyGUID,nVerifyID,strWorkID,nWorkTypeID,strImagePath,strRemark) ' +
          ' values (:strGUID,:strTrainmanGUID,:nDrinkResult,getdate(),' +
          ' :strAreaGUID,:strDutyGUID,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath,:strRemark)';
        SQL.Text := strSql;
        Parameters.ParamByName( 'strGUID').Value := NewGUID;
        Parameters.ParamByName( 'strTrainmanGUID').Value := TrainmanGUID;
        Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
        Parameters.ParamByName( 'strAreaGUID').Value := '';
        Parameters.ParamByName( 'strDutyGUID').Value := DutyUserGUID;
        Parameters.ParamByName( 'nVerifyID').Value := Ord(Verify);
        Parameters.ParamByName( 'strWorkID').Value := beginWorkID;
        Parameters.ParamByName( 'nWorkTypeID').Value :=2;
        Parameters.ParamByName('strImagePath').Value := RsDrink.strPictureURL;

        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          Exception.Create('添加出勤测酒记录失败');
          exit;
        end;

        
        {$region '修改计划状态,设置为已出勤'}
        strSql := 'update TAB_Plan_Train set nPlanState=%d where strTrainPlanGUID=%s and  ' +
        ' (select count(*) from VIEW_Plan_BeginWork where strTrainPlanGUID=TAB_Plan_Train.strTrainPlanGUID  and  ' +
        ' ((strTrainmanGUID1 is null) or (strTrainmanGUID1 = %s) or not(dtTestTime1 is null)) and ' +
          ' ((strTrainmanGUID2 is null) or (strTrainmanGUID2 = %s) or not(dtTestTime2 is null))  and ' +
          ' ((strTrainmanGUID3 is null) or (strTrainmanGUID3 = %s) or not(dtTestTime3 is null)) ) > 0';
        strSql := Format(strSql,[Ord(psBeginWork),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
          QuotedStr(''),
          QuotedStr(''),
          QuotedStr('')
          ]);
        SQL.Text := strSql;
        if ExecSql > 0 then
        begin

           strSql := 'select * from TAB_Base_TrainmanJiaolu ' + 
          ' where strTrainmanJiaoluGUID = ' + 
          '(select top 1 strTrainmanJiaoluGUID from ' + 
              ' VIEW_Nameplate_TrainmanInJiaolu_All where strTrainmanGUID = %s)';


          strSql := Format(strSql,[QuotedStr(TrainmanGUID)]);
          SQL.Text := strSql;
          Open;
          if RecordCount > 0 then
          begin
            if TRsJiaoluType(FieldByName('nJiaoluType').AsInteger) = jltOrder then
            begin
              if nTurnOrder > 0 then
              begin
                strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
                nRunType := TRsRunType(FieldByName('nTrainmanRunType').AsInteger);
                TurnPlateOrder(TrainmanGUID,TrainmanPlan,strTrainmanJiaoluGUID,
                  nRunType,BeginWorkStationGUID,RsDrink.dtCreateTime,true);
              end;
            end;
          end;
        
        end;
        {$endregion '修改计划状态,设置为已出勤'}
        


        m_ADOConnection.CommitTrans;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.CanCanlePlan(PlanGUIDs: TStrings;
  var strError: string): Boolean;
var
  trainmanPlan: RRsTrainmanPlan;
  I: Integer;
  subGUIDS: TStrings;
begin
  Result := False;

  for I := 0 to PlanGUIDs.Count - 1 do
  begin
    if not GetTrainmanPlan(PlanGUIDs[i], trainmanPlan) then
    begin
      strError := '已有计划已被删除，请刷新后重试';
      Exit;
    end;

    if trainmanPlan.Group.strGroupGUID <> '' then
    begin
      strError := '不能撤销已经安排人员的计划！';
      Exit;
    end;
  end;
  subGUIDS := TStringList.Create;
  try
    GetSubPlans(PlanGUIDs,subGUIDS);

    for I := 0 to subGUIDS.Count - 1 do
    begin
      if not GetTrainmanPlan(subGUIDS[i], trainmanPlan) then
      begin
        Continue;
      end;
      if trainmanPlan.Group.strGroupGUID <> '' then
      begin
        strError := '附加计划已安排人员,不能撤销计划!';
        Exit;
      end;
    end;
  finally
    subGUIDS.Free;
  end;

  Result := True;
end;

function TRsDBTrainPlan.CancelPlan(PlanGUIDs: TStrings;SiteGUID:String;DutyUserGUID:string): boolean;
begin
  Result := CancleRelativePlan(PlanGUIDs,SiteGUID,DutyUserGUID);
end;


function TRsDBTrainPlan.CancleRelativePlan(PlanGUIDs: TStrings; SiteGUID,
  DutyUserGUID: string): Boolean;
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
  subGUIDS: TStrings;
begin
  Result := false;
  subGUIDS := TStringList.Create;
  try
    GetSubPlans(PlanGUIDs,subGUIDS);

    for I := 0 to subGUIDS.Count - 1 do
    begin
      PlanGUIDs.Add(subGUIDS.Strings[i]);
    end;

  finally
    subGUIDS.Free;
  end;

  
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psCancel),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'insert into TAB_Plan_Cancel (strTrainPlanGUID,dtCancelTime,strCancelDutyGUID,strFlowSiteGUID) values (%s,getdate(),%s,%s)';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;
          if execsql = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;

          strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strTrainPlanGUID = %s';
          strSql := Format(strSql,[QuotedStr(''),QuotedStr(PlanGUIDS[i])]);
          SQL.Text := strSql;
          ExecSql;
        end;
        m_ADOConnection.CommitTrans;
        result := true;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.ClearTrainmanPlanError(GroupGUID: string);
var
  strSql,strGroupGUID,strTrainPlanGUID,strTemp : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_Nameplate_Group where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('未找到该人员所在的机组信息');
        exit;
      end;
      if FieldByName('strTrainPlanGUID').AsString = '' then
      begin
        raise Exception.Create('该人员所在机组当前未值乘计划，不用清理');
        exit;
      end;
      strGroupGUID  :=  FieldByName('strGroupGUID').AsString;
      strTrainPlanGUID  :=  FieldByName('strTrainPlanGUID').AsString;
      strSql := 'select top 1 * from VIEW_Plan_Trainman where strGroupGUID = %s and strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(strGroupGUID),QuotedStr(strTrainPlanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        strTemp := '该人员正在值乘计划,请先撤出该计划:%s[%s]';
        strTemp := Format(strTemp,[FormatDateTime('yyyy-MM-dd HH:nn:ss',FieldByName('dtStartTime').asDateTime)
          ,QuotedStr(FieldByName('strTrainNo').AsString)]);
        raise Exception.Create(strTemp);
        exit;
      end;
      strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(''),QuotedStr(strGroupGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;  
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.Delete(TrainPlanGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'delete from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.DeleteTrainmanFromPlan(TrainmanPlanGUID: string;
  TrainmanIndex: integer);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      if trainmanIndex = 1 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID1=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      if trainmanIndex = 2 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID2=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      if trainmanIndex = 3 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID3=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;

      strSql := 'delete from tab_plan_trainman where strTrainPlanGUID = %s and (strTrainmanGUID1 is null or strTrainmanGUID1=%s) ' +
        ' and (strTrainmanGUID1 is null or strTrainmanGUID1=%s) and (strTrainmanGUID1 is null or strTrainmanGUID1=%s)';
      strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID),QuotedStr(''),QuotedStr(''),QuotedStr('')]);
      SQL.Text := strSql;
      if ExecSQL > 0 then
      begin
        strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = null where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

class function TRsDBTrainPlan.EditPlanRoom(ADOConn: TADOConnection; TrainPlanGUID,
  RoomNumber: string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      strSql := 'update TAB_Plan_CallRecord set strRoomNumber=%s where strTrainPlanGUID=%s';
      strSql := Format(strSql,[QuotedStr(RoomNumber),QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      Result := ExecSQL > 0;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.EndWork(TrainmanGUID : string;
      TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
      DutyUserGUID:string;EndWorkStationGUID:string;ArriveTime,LastEndWorkTime : TDateTime);
var
  strSql : string;
  adoQuery : TADOQuery;
  endWorkID : string;

  trainmanJiaoluGUID : string;

  nTrainmanJiaoluType : TRsJiaoluType;
  nRunType : TRsRunType;
begin

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        {$region '司机的退勤测酒记录'}

          endWorkID := NewGUID;
          //保存出勤记录
          strSql := 'insert into TAB_Plan_EndWork (strEndWorkGUID,strTrainPlanGUID, ' +
            ' strTrainmanGUID,dtCreateTime,nVerifyID,strStationGUID,strRemark) values (%s,%s,%s,%s,%d,%s,%s)';
          strSql := Format(strSql,[QuotedStr(endWorkID),
            QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),QuotedStr(TrainmanGUID),
            QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',RsDrink.dtCreateTime)),
            Ord(Verify),QuotedStr(EndWorkStationGUID),QuotedStr(RsDrink.strRemark)]);
          SQL.Text := strSql;
          if ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            Exception.Create('添加退勤记录失败');
            exit;
          end;
          //保存测酒记录
          strSql := 'insert into TAB_Drink_Information (strGUID,strTrainmanGUID, ' +
            ' nDrinkResult,dtCreateTime,strAreaGUID,strDutyGUID,nVerifyID,strWorkID,nWorkTypeID,strImagePath) ' +
            ' values (:strGUID,:strTrainmanGUID,:nDrinkResult,getdate(),' +
            ' :strAreaGUID,:strDutyGUID,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath)';
          SQL.Text := strSql;
          Parameters.ParamByName( 'strGUID').Value := NewGUID;
          Parameters.ParamByName( 'strTrainmanGUID').Value := TrainmanGUID;
          Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
          Parameters.ParamByName( 'strAreaGUID').Value := '';
          Parameters.ParamByName( 'strDutyGUID').Value := DutyUserGUID;
          Parameters.ParamByName( 'nVerifyID').Value := Ord(Verify);
          Parameters.ParamByName( 'strWorkID').Value := endWorkID;
          Parameters.ParamByName( 'nWorkTypeID').Value :=3;
          Parameters.ParamByName('strImagePath').Value := RsDrink.strPictureURL;   

          if ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            Exception.Create('添加测酒记录失败');
            exit;
          end;
 
        {$endregion '司机的退勤测酒记录'}

        {$region '修改计划状态,设置为已出勤'}
        strSql := 'update TAB_Plan_Train set nPlanState=%d where strTrainPlanGUID=%s and  ' +
        ' (select count(*) from VIEW_Plan_EndWork where strTrainPlanGUID=TAB_Plan_Train.strTrainPlanGUID  and  ' +
          ' ((strTrainmanGUID1 is null) or (strTrainmanGUID1 = %s) or not(dtTestTime1 is null)) and ' +
          ' ((strTrainmanGUID2 is null) or (strTrainmanGUID2 = %s) or not(dtTestTime2 is null))  and ' +
          ' ((strTrainmanGUID3 is null) or (strTrainmanGUID3 = %s) or not(dtTestTime3 is null)) ) > 0';
        strSql := Format(strSql,[Ord(psEndWork),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
          QuotedStr(''),
          QuotedStr(''),
          QuotedStr('')  ]);
        SQL.Text := strSql;
        if ExecSql > 0 then
        begin
          {$region '修改机组所在的计划,设置为空'}
          strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strGroupGUID = %s';
          strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
          SQL.Text := strSql;
          ExecSql;
          {$endregion '修改计划状态,设置为已出勤'}

          //翻牌
          strSql := 'select nJiaoluType,strTrainmanJiaoluGUID,nTrainmanRunType from VIEW_Nameplate_TrainmanInJiaolu_All ' +
            ' where strTrainmanGUID = %s';
          strSql := Format(strSql,[QuotedStr(TrainmanGUID)]);
          SQL.Text := strSql;
          Open;
          if RecordCount = 0  then
          begin
            m_ADOConnection.RollbackTrans;
            raise exception.Create('该机组没有处于任何人员交路中');
            exit;
          end;
          
          trainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
          nTrainmanJiaoluType := TRsJiaoluType(FieldByName('nJiaoluType').AsInteger);
          nRunType :=  TRsRunType(FieldByName('nTrainmanRunType').AsInteger);
          {$region '包乘翻牌'}
          if nTrainmanJiaoluType = jltTogether then
          begin
            //将序号大于本机组的机组序号全部减少1
            strSql := 'update TAB_Nameplate_TrainmanJiaolu_OrderInTrain ' +
              ' set nOrder = nOrder - 1 where nOrder > ' +
              ' (select top 1 nOrder from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s)' +
              ' and strTrainGUID = ' +
              ' (select top 1 strTrainGUID from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s)';
            strSql := Format(strSql,[QuotedStr(TrainmanPlan.Group.strGroupGUID),
              QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
            SQL.Text := strSql;
            ExecSQL;
            //将本机组的序号设置为包车内的机组的最大序号加1
            strSql := 'update TAB_Nameplate_TrainmanJiaolu_OrderInTrain ' +
              ' set nOrder = (select max(nOrder) + 1 from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strTrainGUID = ' +
              ' (select top 1 strTrainGUID from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s)) where strGroupGUID=%s';
            strSql := Format(strSql,[QuotedStr(TrainmanPlan.Group.strGroupGUID),
              QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
            SQL.Text := strSql;
            ExecSQL;

            strSql := 'update TAB_Nameplate_TrainmanJiaolu_OrderInTrain set dtLastArriveTime = %s where strGroupGUID = %s';
            strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',ArriveTime)),
              QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
            SQL.Text := strSql;
            ExecSQL;
          end;
          {$endregion '包乘翻牌'}
          
          {$region '轮乘翻牌'}
          if nTrainmanJiaoluType = jltOrder then
          begin
            TurnPlateOrder(TrainmanGUID,TrainmanPlan,trainmanJiaoluGUID,nRunType,EndWorkStationGUID,ArriveTime,false);
          end;
          {$endregion '轮乘翻牌'}
        end;
         strSql := 'update TAB_Plan_Train set dtLastArriveTime = %s where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',ArriveTime)),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
        {$region '修改人员的最后退勤时间'}
        strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s,nTrainmanState=%d where strTrainmanGUID = %s';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',
          LastEndWorkTime)),Ord(tsNormal),QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        ExecSql;
        {$endregion '修改人员的最后退勤时间'}
        m_ADOConnection.CommitTrans;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise Exception.Create(e.Message);     
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.EqualChuQinPlan(Source, Dest: TRsChuQinPlanArray): boolean;
var
  i: Integer;
begin
  result := false;
  if length(Source) <> length(dest) then exit;
  for i := 0 to length(Source) - 1 do
  begin
    if Source[i].TrainPlan.strTrainPlanGUID <> Dest[i].TrainPlan.strTrainPlanGUID then exit;
    if Source[i].TrainPlan.strTrainTypeName <> Dest[i].TrainPlan.strTrainTypeName then exit;
    if Source[i].TrainPlan.strTrainNumber <> Dest[i].TrainPlan.strTrainNumber then exit;
    if Source[i].TrainPlan.strTrainNo <> Dest[i].TrainPlan.strTrainNo then exit;
    if Source[i].TrainPlan.dtStartTime <> Dest[i].TrainPlan.dtStartTime then exit;
    if Source[i].TrainPlan.dtRealStartTime <> Dest[i].TrainPlan.dtRealStartTime then exit;
    if Source[i].TrainPlan.strTrainJiaoluGUID <> Dest[i].TrainPlan.strTrainJiaoluGUID then exit;
    if Source[i].TrainPlan.strTrainJiaoluName <> Dest[i].TrainPlan.strTrainJiaoluName then exit;
    if Source[i].TrainPlan.strStartStation <> Dest[i].TrainPlan.strStartStation then exit;
    if Source[i].TrainPlan.strStartStationName <> Dest[i].TrainPlan.strStartStationName then exit;
    if Source[i].TrainPlan.strEndStation <> Dest[i].TrainPlan.strEndStation then exit;
    if Source[i].TrainPlan.strEndStationName <> Dest[i].TrainPlan.strEndStationName then exit;
    if Source[i].TrainPlan.nTrainmanTypeID <> Dest[i].TrainPlan.nTrainmanTypeID then exit;
    if Source[i].TrainPlan.nPlanType <> Dest[i].TrainPlan.nPlanType then exit;
    if Source[i].TrainPlan.nDragType <> Dest[i].TrainPlan.nDragType then exit;
    if Source[i].TrainPlan.nKeHuoID <> Dest[i].TrainPlan.nKeHuoID then exit;
    if Source[i].TrainPlan.nRemarkType <> Dest[i].TrainPlan.nRemarkType then exit;
    if Source[i].TrainPlan.strRemark <> Dest[i].TrainPlan.strRemark then exit;
    if Source[i].TrainPlan.nPlanState <> Dest[i].TrainPlan.nPlanState then exit;
    if Source[i].TrainPlan.strPlanStateName <> Dest[i].TrainPlan.strPlanStateName then exit;

    if Source[i].dtBeginWorkTime <> Dest[i].dtBeginWorkTime then exit;

    if Source[i].ChuQinGroup.Group.Trainman1.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman1.strTrainmanGUID then exit;
    if Source[i].ChuQinGroup.Group.Trainman2.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman2.strTrainmanGUID then exit;
    if Source[i].ChuQinGroup.Group.Trainman3.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman3.strTrainmanGUID then exit;

    if Source[i].ChuQinGroup.nVerifyID1 <> Dest[i].ChuQinGroup.nVerifyID1 then exit;
    if Source[i].ChuQinGroup.nVerifyID2 <> Dest[i].ChuQinGroup.nVerifyID2 then exit;
    if Source[i].ChuQinGroup.nVerifyID3 <> Dest[i].ChuQinGroup.nVerifyID3 then exit;

    if Source[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime then exit;

    if Source[i].ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult then exit;
  end;
  result := true;
end;

function TRsDBTrainPlan.EqualTrainmanPlan(Source,
  Dest: TRsTrainmanPlanArray): boolean;
var
  i: Integer;
begin
  result := false;
  if length(Source) <> length(dest) then exit;
  for i := 0 to length(Source) - 1 do
  begin
    if Source[i].TrainPlan.strTrainPlanGUID <> Dest[i].TrainPlan.strTrainPlanGUID then exit;
    if Source[i].TrainPlan.strTrainTypeName <> Dest[i].TrainPlan.strTrainTypeName then exit;
    if Source[i].TrainPlan.strTrainNumber <> Dest[i].TrainPlan.strTrainNumber then exit;
    if Source[i].TrainPlan.strTrainNo <> Dest[i].TrainPlan.strTrainNo then exit;
    if Source[i].TrainPlan.dtStartTime <> Dest[i].TrainPlan.dtStartTime then exit;
    if Source[i].TrainPlan.dtRealStartTime <> Dest[i].TrainPlan.dtRealStartTime then exit;
    if Source[i].TrainPlan.strTrainJiaoluGUID <> Dest[i].TrainPlan.strTrainJiaoluGUID then exit;
    if Source[i].TrainPlan.strTrainJiaoluName <> Dest[i].TrainPlan.strTrainJiaoluName then exit;
    if Source[i].TrainPlan.strStartStation <> Dest[i].TrainPlan.strStartStation then exit;
    if Source[i].TrainPlan.strStartStationName <> Dest[i].TrainPlan.strStartStationName then exit;
    if Source[i].TrainPlan.strEndStation <> Dest[i].TrainPlan.strEndStation then exit;
    if Source[i].TrainPlan.strEndStationName <> Dest[i].TrainPlan.strEndStationName then exit;
    if Source[i].TrainPlan.nTrainmanTypeID <> Dest[i].TrainPlan.nTrainmanTypeID then exit;
    if Source[i].TrainPlan.nPlanType <> Dest[i].TrainPlan.nPlanType then exit;
    if Source[i].TrainPlan.nDragType <> Dest[i].TrainPlan.nDragType then exit;
    if Source[i].TrainPlan.nKeHuoID <> Dest[i].TrainPlan.nKeHuoID then exit;
    if Source[i].TrainPlan.nRemarkType <> Dest[i].TrainPlan.nRemarkType then exit;
    if Source[i].TrainPlan.strRemark <> Dest[i].TrainPlan.strRemark then exit;
    if Source[i].TrainPlan.nPlanState <> Dest[i].TrainPlan.nPlanState then exit;
    if Source[i].TrainPlan.strPlanStateName <> Dest[i].TrainPlan.strPlanStateName then exit;

    if Source[i].dtBeginWorkTime <> Dest[i].dtBeginWorkTime then exit;

    if Source[i].Group.Trainman1.strTrainmanGUID <> Dest[i].Group.Trainman1.strTrainmanGUID then exit;
    if Source[i].Group.Trainman2.strTrainmanGUID <> Dest[i].Group.Trainman2.strTrainmanGUID then exit;
    if Source[i].Group.Trainman3.strTrainmanGUID <> Dest[i].Group.Trainman3.strTrainmanGUID then exit;

    if Source[i].RestInfo.nNeedRest <> Dest[i].RestInfo.nNeedRest then exit;
    if Source[i].RestInfo.dtArriveTime <> Dest[i].RestInfo.dtArriveTime then exit;
    if Source[i].RestInfo.dtCallTime <> Dest[i].RestInfo.dtCallTime then exit;
  end;
  result := true;
end;

function TRsDBTrainPlan.EqualTuiQinPlan(Source, Dest: TRsTuiQinPlanArray): boolean;
var
  i: Integer;
begin
  result := false;
  if length(Source) <> length(dest) then exit;
  for i := 0 to length(Source) - 1 do
  begin
    if Source[i].TrainPlan.strTrainPlanGUID <> Dest[i].TrainPlan.strTrainPlanGUID then exit;
    if Source[i].TrainPlan.strTrainTypeName <> Dest[i].TrainPlan.strTrainTypeName then exit;
    if Source[i].TrainPlan.strTrainNumber <> Dest[i].TrainPlan.strTrainNumber then exit;
    if Source[i].TrainPlan.strTrainNo <> Dest[i].TrainPlan.strTrainNo then exit;
    if Source[i].TrainPlan.dtStartTime <> Dest[i].TrainPlan.dtStartTime then exit;
    if Source[i].TrainPlan.dtRealStartTime <> Dest[i].TrainPlan.dtRealStartTime then exit;
    if Source[i].TrainPlan.strTrainJiaoluGUID <> Dest[i].TrainPlan.strTrainJiaoluGUID then exit;
    if Source[i].TrainPlan.strTrainJiaoluName <> Dest[i].TrainPlan.strTrainJiaoluName then exit;
    if Source[i].TrainPlan.strStartStation <> Dest[i].TrainPlan.strStartStation then exit;
    if Source[i].TrainPlan.strStartStationName <> Dest[i].TrainPlan.strStartStationName then exit;
    if Source[i].TrainPlan.strEndStation <> Dest[i].TrainPlan.strEndStation then exit;
    if Source[i].TrainPlan.strEndStationName <> Dest[i].TrainPlan.strEndStationName then exit;
    if Source[i].TrainPlan.nTrainmanTypeID <> Dest[i].TrainPlan.nTrainmanTypeID then exit;
    if Source[i].TrainPlan.nPlanType <> Dest[i].TrainPlan.nPlanType then exit;
    if Source[i].TrainPlan.nDragType <> Dest[i].TrainPlan.nDragType then exit;
    if Source[i].TrainPlan.nKeHuoID <> Dest[i].TrainPlan.nKeHuoID then exit;
    if Source[i].TrainPlan.nRemarkType <> Dest[i].TrainPlan.nRemarkType then exit;
    if Source[i].TrainPlan.strRemark <> Dest[i].TrainPlan.strRemark then exit;
    if Source[i].TrainPlan.nPlanState <> Dest[i].TrainPlan.nPlanState then exit;
    if Source[i].TrainPlan.strPlanStateName <> Dest[i].TrainPlan.strPlanStateName then exit;

    if Source[i].dtBeginWorkTime <> Dest[i].dtBeginWorkTime then exit;

    if Source[i].TuiQinGroup.Group.Trainman1.strTrainmanGUID <> Dest[i].TuiQinGroup.Group.Trainman1.strTrainmanGUID then exit;
    if Source[i].TuiQinGroup.Group.Trainman2.strTrainmanGUID <> Dest[i].TuiQinGroup.Group.Trainman2.strTrainmanGUID then exit;
    if Source[i].TuiQinGroup.Group.Trainman3.strTrainmanGUID <> Dest[i].TuiQinGroup.Group.Trainman3.strTrainmanGUID then exit;

    if Source[i].TuiQinGroup.nVerifyID1 <> Dest[i].TuiQinGroup.nVerifyID1 then exit;
    if Source[i].TuiQinGroup.nVerifyID2 <> Dest[i].TuiQinGroup.nVerifyID2 then exit;
    if Source[i].TuiQinGroup.nVerifyID3 <> Dest[i].TuiQinGroup.nVerifyID3 then exit;

    if Source[i].TuiQinGroup.TestAlcoholInfo1.dtTestTime <> Dest[i].TuiQinGroup.TestAlcoholInfo1.dtTestTime then exit;
    if Source[i].TuiQinGroup.TestAlcoholInfo2.dtTestTime <> Dest[i].TuiQinGroup.TestAlcoholInfo2.dtTestTime then exit;
    if Source[i].TuiQinGroup.TestAlcoholInfo3.dtTestTime <> Dest[i].TuiQinGroup.TestAlcoholInfo3.dtTestTime then exit;

    if Source[i].TuiQinGroup.TestAlcoholInfo1.taTestAlcoholResult <> Dest[i].TuiQinGroup.TestAlcoholInfo1.taTestAlcoholResult then exit;
    if Source[i].TuiQinGroup.TestAlcoholInfo2.taTestAlcoholResult <> Dest[i].TuiQinGroup.TestAlcoholInfo2.taTestAlcoholResult then exit;
    if Source[i].TuiQinGroup.TestAlcoholInfo3.taTestAlcoholResult <> Dest[i].TuiQinGroup.TestAlcoholInfo3.taTestAlcoholResult then exit;
  end;
  result := true;
end;



class function TRsDBTrainPlan.GetTrainmanInOutPlan(ADOConn: TADOConnection;
  trainmanGUID: string; var InOutPlan: RRsInOutPlan): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    strSql := 'select top 1 * from VIEW_Plan_InOut ' +
    ' where nNeedRest= 1 and (strTrainmanGUID1=%s and nTrainmanState1 in (3,4)) or  ' +
      ' (strTrainmanGUID2=%s and nTrainmanState2 in(3,4)) or  ' +
      ' (strTrainmanGUID3=%s and nTrainmanState2 in(3,4)) order by dtCallTime ';
    strSql := Format(strSql,[QuotedStr(trainmanGUID),QuotedStr(trainmanGUID)
      ,QuotedStr(trainmanGUID)]);
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        InOutPlanFromADOQuery(InOutPlan,adoQuery);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;




function TRsDBTrainPlan.GetLastTuiQinRecord(TrainmanGUID: string;
  var strEndWorkGUID: string; var EndWorkTime: TDateTime): Boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from TAB_Plan_EndWork ' +
    ' where strTrainmanGUID = %s order by dtCreateTime DESC';

  strSql := Format(strSql,[QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        strEndWorkGUID :=  FieldByName('strEndworkGUID').AsString;
        EndWorkTime := FieldByName('dtCreateTime').AsDateTime;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


class procedure TRsDBTrainPlan.InOutPlanFromADOQuery(var InOutPlan: RRsInOutPlan;
  ADOQuery: TADOQuery);
begin
  TrainPlanFromADOQuery(InOutPlan.TrainPlan,ADOQuery);
  TRsDBTrainmanJiaolu.GroupFromADOQuery(InOutPlan.InOutGroup.Group,ADOQuery);

  InOutPlan.nCallSucceed := ADOQuery.FieldByName('nCallSucceed').AsInteger;
  InOutPlan.InOutGroup.strRoomNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
  InOutPlan.InOutGroup.CallCount := ADOQuery.FieldByName('CallCount').AsInteger;


  if not ADOQuery.FieldByName('nInRoomVerifyID1').IsNull then
    InOutPlan.InOutGroup.nInRoomVerifyID1 := TRsRegisterFlag(ADOQuery.FieldByName('nInRoomVerifyID1').AsInteger);
  if not ADOQuery.FieldByName('dtInRoomTime1').IsNull then
    InOutPlan.InOutGroup.dtInRoomTime1 := ADOQuery.FieldByName('dtInRoomTime1').AsDateTime;
  if not ADOQuery.FieldByName('nInRoomVerifyID2').IsNull then
    InOutPlan.InOutGroup.nInRoomVerifyID2 := TRsRegisterFlag(ADOQuery.FieldByName('nInRoomVerifyID2').AsInteger);
  if not ADOQuery.FieldByName('dtInRoomTime2').IsNull then
    InOutPlan.InOutGroup.dtInRoomTime2 := ADOQuery.FieldByName('dtInRoomTime2').AsDateTime;
  if not ADOQuery.FieldByName('nInRoomVerifyID3').IsNull then
    InOutPlan.InOutGroup.nInRoomVerifyID3 := TRsRegisterFlag(ADOQuery.FieldByName('nInRoomVerifyID3').AsInteger);
  if not ADOQuery.FieldByName('dtInRoomTime3').IsNull then
    InOutPlan.InOutGroup.dtInRoomTime3 := ADOQuery.FieldByName('dtInRoomTime3').AsDateTime;

  if not ADOQuery.FieldByName('nOutRoomVerifyID1').IsNull then
    InOutPlan.InOutGroup.nOutRoomVerifyID1 := TRsRegisterFlag(ADOQuery.FieldByName('nOutRoomVerifyID1').AsInteger);
  if not ADOQuery.FieldByName('dtOutRoomTime1').IsNull then
    InOutPlan.InOutGroup.dtOutRoomTime1 := ADOQuery.FieldByName('dtOutRoomTime1').AsDateTime;
  if not ADOQuery.FieldByName('nOutRoomVerifyID2').IsNull then
    InOutPlan.InOutGroup.nOutRoomVerifyID2 := TRsRegisterFlag(ADOQuery.FieldByName('nOutRoomVerifyID2').AsInteger);
  if not ADOQuery.FieldByName('dtOutRoomTime2').IsNull then
    InOutPlan.InOutGroup.dtOutRoomTime2 := ADOQuery.FieldByName('dtOutRoomTime2').AsDateTime;
  if not ADOQuery.FieldByName('nOutRoomVerifyID3').IsNull then
    InOutPlan.InOutGroup.nOutRoomVerifyID3 := TRsRegisterFlag(ADOQuery.FieldByName('nOutRoomVerifyID3').AsInteger);
  if not ADOQuery.FieldByName('dtOutRoomTime3').IsNull then
    InOutPlan.InOutGroup.dtOutRoomTime3 := ADOQuery.FieldByName('dtOutRoomTime3').AsDateTime;

end;

class function TRsDBTrainPlan.InRoom(ADOConn: TADOConnection;InRoomInfo :RRsInRoomInfo): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      ADOConn.BeginTrans;
      try
        //插入入寓信息表
        strSql := 'insert into TAB_Plan_InRoom (strInRoomGUID,strTrainPlanGUID, ' +
          ' strTrainmanGUID,dtInRoomTime,nInRoomVerifyID,strDutyUserGUID) ' +
          ' values (%s,%s,%s,getdate(),%d,%s)';
        strSql := Format(strSql,[QuotedStr(NewGUID),QuotedStr(InRoomInfo.strTrainPlanGUID),
              QuotedStr(InRoomInfo.strTrainmanGUID),
              Ord(InRoomInfo.nVerifyID),QuotedStr(InRoomInfo.strDutyUserGUID)]);
        SQL.Text := strSql;
        if ExecSQL = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;             
        //修改乘务员状态
        strSql := 'update tab_org_trainman set nTrainmanState = %d where strGUID = %s ';
        strSql := Format(strSql,[Ord(tsInRoom),QuotedStr(InRoomInfo.strTrainmanGUID)]);
        SQL.Text := strSql;
        if ExecSQL = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;
        //修改计划状态
        strSql := 'select * from VIEW_plan_InOut where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(InRoomInfo.strTrainPlanGUID)]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;
        if FieldByName('strTrainmanGUID1').AsString = InRoomInfo.strTrainmanGUID then
        begin
          if  (FieldByName('strTrainmanGUID2').IsNull or (not FieldByName('dtInRoomTime2').IsNull))
              and  (FieldByName('strTrainmanGUID3').IsNull or (not FieldByName('dtInRoomTime3').IsNull)) then
          begin
            strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
            strSql := Format(strSql,[Ord(psInRoom),QuotedStr(InRoomInfo.strTrainPlanGUID)]);
            Sql.Text := strSql;
            if ExecSQL = 0 then
            begin
              ADOConn.RollbackTrans;
              exit;
            end;
          end;
        end else begin
          if FieldByName('strTrainmanGUID2').AsString = InRoomInfo.strTrainmanGUID then
          begin
            if  (FieldByName('strTrainmanGUID1').IsNull or (not FieldByName('dtInRoomTime1').IsNull))
                and  (FieldByName('strTrainmanGUID3').IsNull or (not FieldByName('dtInRoomTime3').IsNull)) then
            begin
              strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
              strSql := Format(strSql,[Ord(psInRoom),QuotedStr(InRoomInfo.strTrainPlanGUID)]);
              Sql.Text := strSql;
              if ExecSQL = 0 then
              begin
                ADOConn.RollbackTrans;
                exit;
              end;
            end;
          end else begin
            if FieldByName('strTrainmanGUID3').AsString = InRoomInfo.strTrainmanGUID then
            begin
              if  (FieldByName('strTrainmanGUID2').IsNull or (not FieldByName('dtInRoomTime2').IsNull))
                  and  (FieldByName('strTrainmanGUID1').IsNull or (not FieldByName('dtInRoomTime1').IsNull)) then
              begin
                strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
                strSql := Format(strSql,[Ord(psInRoom),QuotedStr(InRoomInfo.strTrainPlanGUID)]);
                Sql.Text := strSql;
                if ExecSQL = 0 then
                begin
                  ADOConn.RollbackTrans;
                  exit;
                end;
              end;
            end;
          end;
        end;
        //插入叫班记录
        strSql := 'select * from TAB_Plan_CallRecord where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(InRoomInfo.strTrainPlanGUID)]);
        sql.Text := strSql;
        Open;
        if recordCount = 0 then
        begin
          Append;
          FieldByName('strTrainPlanGUID').AsString := InRoomInfo.strTrainPlanGUID;
          FieldByName('strRoomNumber').AsString := InRoomInfo.strRoomNumber;
          Post;
        end;
        ADOConn.CommitTrans;      
        Result := true;
      except
        ADOConn.RollbackTrans;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TRsDBTrainPlan.GetInOutPlanDetail(ADOConn: TADOConnection;
  TrainPlanGUID: string; out InOutPlan: RRsInOutPlan) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  strSql := 'select * from VIEW_Plan_InOut where strTrainPlanGUID = %s'; 
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        InOutPlanFromADOQuery(InOutPlan,ADOQuery);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

class procedure TRsDBTrainPlan.GetInOutPlans(ADOConn: TADOConnection; BeginTime,
  EndTime: TDateTime; SiteGUID: string; out InOutPlanArray : TRsInOutPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_InOut where ' +
          ' nPlanState >=6 and dtCallTime >=%s and dtCallTime <= %s and ' +
          ' nNeedRest = 1 and strSiteGUID=%s';
 
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime)),QuotedStr(SiteGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      SetLength(InOutPlanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        InOutPlanFromADOQuery(InOutPlanArray[i],ADOQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


function TRsDBTrainPlan.GetJiMingGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_Named ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s)) and ' +
                //--机车车号与计划的车型车号相同
                ' ((strCheCi1) = %s) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_Named.strGroupGUID and nPlanState < %d) = 0 ' +
                ' ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        QuotedStr(TrainPlan.strTrainNo),
        Ord(psEndWork)
        ]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetLunChengFixedGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;
      TrainmanJiaolus : TStrings;
      FixKehuoArray : TRsKeHuoIDArray;FixTrainmanTypeArray : TRsTrainmanTypeArray;
      FixDragTypeArray : TRsDragTypeArray;
      out Group : RRsGroup) : boolean;
var
  strSql,strKehuo,strTrainmanType,strDragType,strTrainmanGUID : string;
  adoQuery : TADOQuery;
  i: integer;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strTrainmanGUID := QuotedStr('');
      for i := 0 to TrainmanJiaolus.Count - 1 do
      begin
        strTrainmanGUID := strTrainmanGUID + ',' + QuotedStr(TrainmanJiaolus[i]);
      end;
      strTrainmanGUID := '(' +strTrainmanGUID+ ')';
      
      strKehuo := '-1';
      for i := 0 to length(FixKehuoArray) - 1 do
      begin
        strKehuo := strKehuo + ',' + IntToStr(Ord(FixkehuoArray[i]));
      end;
      strKehuo := '(' + strKehuo + ')';

      strTrainmanType := '-1';
      for i := 0 to length(FixTrainmanTypeArray) - 1 do
      begin
        strTrainmanType := strTrainmanType + ',' + IntToStr(Ord(FixTrainmanTypeArray[i]));
      end;
      strTrainmanType := '(' + strTrainmanType + ')';
      
      strDragType := '-1';
      for i := 0 to length(FixDragTypeArray) - 1 do
      begin
        strDragType := strDragType + IntToStr(Ord(FixDragTypeArray[i]));
      end;
      strDragType := '(' + strDragType + ')';
      
      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_Order ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in %s) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where  ((nKehuoID = %d and nTrainmanID = %d and nDragType = %d) ' +
                //--过滤条件
                ' or (nKehuoID in %s) or (nTrainmanTypeID in %s) or (nDragType in %s)) and ' +
                ' strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_Order.strGroupGUID and nPlanState < %d) = 0 ' +
                ' order by case when dtLastEndWorkTime1 is null then dtLastEndWorkTime1 else nOrder ';
      strSql := Format(strSql,[strTrainmanGUID,
        Ord(TrainPlan.nKeHuoID),Ord(TrainPlan.nTrainmanTypeID),Ord(TrainPlan.nDragType),
        strKehuo,strTrainmanType,strDragType,
        Ord(psEndWork)
        ]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetLunChengGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 nTrainmanRunType from TAB_Base_TrainmanJiaolu where strTrainmanJiaouGUID = %s';     

      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_Order ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s and ' +
                ' nKehuoID = %d and nTrainmanTypeID = %d and nDragTypeID = %d)) and ' +
                ' ((strBeginStationGUID = %s and strEndStationGUID = %s) or (strStationGUID=%s)) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where   ' +
                ' strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_Order.strGroupGUID and nPlanState < %d) = 0 ' +
                ' order by nOrder ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        Ord(TrainPlan.nKeHuoID),Ord(TrainPlan.nTrainmanTypeID),Ord(TrainPlan.nDragType),
        QuotedStr(TrainPlan.strStartStation),QuotedStr(TrainPlan.strEndStation), QuotedStr(TrainPlan.strStartStation),
        Ord(psEndWork)
        ]);
        
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetNeedChuQinPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUID: string; out ChuQinPlanArray : TRsChuQinPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_BeginWork where (dtStartTime >=%s or nPlanState in (%d,%d,%d))  and nPlanState in (%d,%d,%d,%d,%d)';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    Ord(psPublish),Ord(psInRoom),Ord(psOutRoom),
    Ord(psPublish),Ord(psInRoom),Ord(psOutRoom),Ord(psBeginWork),Ord(psEndWork)]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by nPlanState,dtStartTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(ChuQinPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToChuQinPlan(adoQuery,ChuQinPlanArray[i],false);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetNeedChuQinPlansOfSite(BeginTime, EndTime: TDateTime;
  SiteGUID: string; out ChuQinPlanArray: TRsChuQinPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_BeginWork where (dtStartTime >=%s or nPlanState in (%d,%d,%d))  and nPlanState in (%d,%d,%d,%d,%d)';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    Ord(psPublish),Ord(psInRoom),Ord(psOutRoom),
    Ord(psPublish),Ord(psInRoom),Ord(psOutRoom),Ord(psBeginWork),Ord(psEndWork)]);
  if SiteGUID <> '' then
  begin
    strSql := strSql + ' and strTrainJiaoluGUID in ' +
     ' (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = ' + QuotedStr(SiteGUID) + ')' ;
  end;

  strSql := strSql + ' order by nPlanState,dtStartTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(ChuQinPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToChuQinPlan(adoQuery,ChuQinPlanArray[i],false);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetNeedCombineTrainmanPlans(SiteGUID: string;
  out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where ' +
  ' (nPlanState in (%d,%d,%d))';
  strSql := Format(strSql,[Ord(psPublish),Ord(psReceive),Ord(psSent)]);

  strSql := strSql + ' and (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ) ';
  strSql := Format(strSql,[QuotedStr(SiteGUID)]);

  strSql := strSql + ' order by dtStartTime,nID Desc ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetNeedTuiQinPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUID: string; out TuiQinPlanArray: TRsTuiQinPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_EndWork where ((dtTestTime1 >=%s or dtTestTime2 >= %s or dtTestTime3 >= %s) or ' +
    ' nPlanState = %d )' + 
    ' and nPlanState in (%d,%d) and  ' +
    ' not ((dtTestTime1 is null) and (dtTestTime2 is null) and (dtTestTime3 is null))';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    Ord(psBeginWork),
    Ord(psBeginWork),Ord(psEndWork)]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by nPlanState,dtLastArriveTime desc';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TuiQinPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTuiQinPlan(adoQuery,TuiQinPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetNeedTuiQinPlansOfSite(BeginTime, EndTime: TDateTime;
  SiteGUID: string; out TuiQinPlanArray: TRsTuiQinPlanArray;nOutWorkHours : integer);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
  strJiaoLuCondition: string;
begin

  ADOQuery := TADOQuery.Create(nil);
  try
    strSql := 'select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite  where strSiteGUID = ' + QuotedStr(SiteGUID);
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open();
    strJiaoLuCondition := '(';
    while not adoQuery.Eof do
    begin
      if Length(strJiaoLuCondition) > 10 then
        strJiaoLuCondition := strJiaoLuCondition + ',' +
          QuotedStr(adoQuery.FieldByName('strTrainJiaoluGUID').AsString)

      else
        strJiaoLuCondition := strJiaoLuCondition +
          QuotedStr(adoQuery.FieldByName('strTrainJiaoluGUID').AsString);

      adoQuery.Next;
    end;

    strJiaoLuCondition := strJiaoLuCondition + ')';


    strSql := 'select * from VIEW_Plan_EndWork where ((dtTestTime1 >=%s or dtTestTime2 >= %s or dtTestTime3 >= %s) or ' +
      ' (nPlanState = %d and  dateAdd(hh,%d,dtStartTime) <= getdate()  ))';


    strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
      Ord(psBeginWork), nOutWorkHours]);
    if SiteGUID <> '' then
    begin
      strSql := strSql + ' and strTrainJiaoluGUID in ' + strJiaoLuCondition;
    end;

    strSql := strSql + ' order by nPlanState,dtLastArriveTime desc';


    with adoQuery do
    begin

      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TuiQinPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTuiQinPlan(adoQuery,TuiQinPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetBaoChengGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s)) and ' +
                //--机车车号与计划的车型车号相同
                ' ((strTrainTypeName + ''-'' + strTrainNumber) = %s) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_TogetherTrain.strGroupGUID and nPlanState < %d) = 0 ' +
                ' order by nOrder ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        QuotedStr(TrainPlan.strTrainTypeName + '-' + TrainPlan.strTrainNumber),
        Ord(psEndWork)
        ]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinDiDian(StationGUID: string;
  out CQDD: RRsChuQinDiDian) : boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Base_ChuQinDiDian where strStationGUID = %s';
      strSql := Format(strSql,[QuotedStr(StationGUID)]);
      sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToChuQinDiDian(ADOQuery,CQDD);
      result := true;    
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinPlan(ChuQinPlanGUID: string;
  var ChuQinPlan: RRsChuQinPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_BeginWork where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(ChuQinPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToChuQinPlan(adoQuery,ChuQinPlan,true);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinPlanByTraiNo(TrainNo: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_BeginWork where strTrainNo = %s and nPlanState in (%d,%d) and dtCreateTime > dateAdd(dd,-1,getdate())';
  strSql := Format(strSql,[QuotedStr(TrainNo),Ord(psBeginWork),Ord(psEndWork)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetTrainmanChuQinPlan(TrainmanGUID: string;
  out ChuQinPlan: RRsChuQinPlan;SiteGUID : string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_BeginWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' (nPlanState in (%d,%d)) and (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s)';

  strSql := Format(strSql,[QuotedStr(SiteGUID) ,Ord(psPublish),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToChuQinPlan(ADOQuery,ChuQinPlan,true);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;




function TRsDBTrainPlan.GetTrainmanDrinkInfo(strTrainmanGUID,
  strTrainPlanGUID: string; WorkType: TRsWorkTypeID;
  var RsDrink: RRsDrink): Boolean;

var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False;
  if Trim(strTrainmanGUID) = '' then
    Exit;
  ADOQuery := NewADOQuery;
  try
    case WorkType of
      wtBeginWork:
        begin
          strSQL := 'select * from TAB_Drink_Information where strWorkID = ( '
            + 'select top 1 strBeginWorkGUID from TAB_Plan_BeginWork where '
            + 'strTrainPlanGUID = %s and strTrainmanGUID = %s)';
        end;
      wtEndWork:
        begin
          strSQL := 'select * from TAB_Drink_Information where strWorkID = ( '
            + 'select top 1 strEndWorkGUID from TAB_Plan_EndWork where '
            + 'strTrainPlanGUID = %s and strTrainmanGUID = %s)';
        end
    else
      Exit;
    end;
    
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(strTrainPlanGUID),QuotedStr(strTrainmanGUID)]);

    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
    begin
      Result := True;
      RsDrink.nDrinkResult := ADOQuery.FieldByName('nDrinkResult').asinteger;
      RsDrink.dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      RsDrink.strPictureURL := Trim(ADOQuery.FieldByName('strImagePath').AsString);
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinSetInfo(TrainPlan: RRsTrainPlan;
  Trainman: RRsTrainman; out ChuQinTime: TDateTime; out Rest: RRsRest) : boolean;
var
  cqdd : RRsChuQinDiDian;
  restDate : TDateTime;
begin
  result := false;
  if not GetChuQinDiDian(TrainPlan.strStartStation,cqdd) then exit;
  if TrainPlan.nRemarkType = prtZhanJie then
    ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nZJPre*-1)
  else begin
    if cqdd.strWorkShopGUID = Trainman.strWorkShopGUID then
      ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nLocalPre*-1)
    else
      ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nOutPre*-1)
  end;
  restDate := DateOf(TrainPlan.dtRealStartTime);
  if CQDD.dtCallTime >= TimeOf(TrainPlan.dtRealStartTime) then
    restDate := IncDay(restDate,-1);

  Rest.nNeedRest := cqdd.bIsRest;
  Rest.dtArriveTime := restDate + cqdd.dtRestTime;
  Rest.dtCallTime := restDate + cqdd.dtCallTime;
  result := true;
end;

function TRsDBTrainPlan.GetPlan(TrainPlanGUID : string;var TrainPlan : RRsTrainPlan) : boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainPlan(adoQuery,TrainPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanByTrainmanNumber(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  //获取计划信息
  strSql := 'select top 1 * from VIEW_Plan_Trainman ' +
    ' where %s >= dateAdd(n,-120,dtStartTime) and %s<=dateAdd(hh,50,dtStartTime) and nPlanState >= 4 ' +
    '  and  ((strTrainmanNumber1 = %s) or (strTrainmanNumber2 = %s)) order by dtStartTime desc ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToTrainPlan(adoQuery,TrainPlan);
        if FieldByName('strTrainmanNumber1').AsString = TrainmanNumber then
          TrainmanIndex := 1;
        if FieldByName('strTrainmanNumber2').AsString = TrainmanNumber then
          TrainmanIndex := 2;
        if FieldByName('strTrainmanNumber3').AsString = TrainmanNumber then
          TrainmanIndex := 3;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetPlanByTrainNo(strTrainNo: string;
  dtStartTime: TDateTime;var TrainPlan : RRsTrainPlan): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Train where strTrainNo = %s and dtStartTime = %s';
  strSql := Format(strSql,[QuotedStr(strTrainNo),QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStartTime))]);
  
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainPlan(adoQuery,TrainPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;
function TRsDBTrainPlan.GetPlanLastArriveTime(TrainPlanGUID: string;
  out ArriveTime : TDateTime): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select dtLastArriveTime from TAB_Plan_Train where  ' +
    ' strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      if FieldByName('dtLastArriveTime').IsNull then exit;

      ArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanOfGroup(GroupGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from TAB_Nameplate_Group where strGroupGUID = %s)';
  strSql := Format(strSql,[QuotedStr(GroupGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetPlanOfTrain(TrainGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain where strTrainGUID = %s)';
  strSql := Format(strSql,[QuotedStr(TrainGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanOfTrainman(TrainmanGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  if TrainmanGUID = '' then exit;
  
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from TAB_Nameplate_Group where strTrainmanGUID1 = %s or strTrainmanGUID2=%s or strTrainmanGUID3 = %s)';
  strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetSendLog(SiteGUID: string; LastTime: TDateTime;
  out SendLogArray: TRsTrainPlanSendLogArray);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from tab_plan_send  tsend where (dtSendTime > %s) and ' +
    ' (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ' +
    ' or strTrainJiaoluGUID in (select strSubTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s))) ' +
    ' and ' +
	  ' (dtSendTime = (select max(dtSendTime) from tab_plan_send where strTrainPlanGUID=tsend.strTrainPlanGUID)) ' +
    ' order by dtSendTime';
  strSql := Format(strSql,[
    QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',LastTime)),
    QuotedStr(SiteGUID),QuotedStr(SiteGUID)
    ]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;

      SetLength(SendLogArray,0);
      while not eof do
      begin
        if FieldByName('bIsRec').AsInteger = 0 then
        begin
          SetLength(SendLogArray,length(SendLogArray) + 1);
          ADOQueryToSendLog(adoQuery,SendLogArray[length(SendLogArray) - 1]);
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetSendLog(SiteGUID: string; PlanGUIDS: TStringList;
  out SendLogArray: TRsTrainPlanSendLogArray);
var
  strSql : string;
  adoQuery : TADOQuery;
  strPlanGUIDS: string;
  i: Integer;
begin
  strPlanGUIDS := '';
  for I := 0 to PlanGUIDS.Count - 1 do
  begin
    if strPlanGUIDS = '' then
      strPlanGUIDS := QuotedStr(PlanGUIDS[i])
    else
      strPlanGUIDS := strPlanGUIDS + ',' + QuotedStr(PlanGUIDS[i]);
  end;
    
  strSql := 'select * from tab_plan_send  tsend where ' +
    ' (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s)) and ' +
	  ' (strTrainPlanGUID in (%s) ) order by dtSendTime';
  strSql := Format(strSql,[QuotedStr(SiteGUID),strPlanGUIDS]);

  SetLength(SendLogArray,0);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;

      SetLength(SendLogArray,0);
      while not eof do
      begin
        if FieldByName('bIsRec').AsInteger = 0 then
        begin
          SetLength(SendLogArray,length(SendLogArray) + 1);
          ADOQueryToSendLog(adoQuery,SendLogArray[length(SendLogArray) - 1]);
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;


procedure TRsDBTrainPlan.GetSentTrainmanPlans(BeginTime, EndTime: TDateTime;SiteGUID : string;
  TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where ' +
  ' ((dtStartTime >=%s ) or (dtStartTime <= 36524)) and not nPlanState in (%d,%d)';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    Ord(psCancel),Ord(psEdit)]);
  if TrainJiaoluGUID <> '' then
  begin
    strSql := strSql + ' and (strTrainJiaoluGUID = %s or strTrainJiaoluGUID in (select strSubTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID = %s))';
    strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),QuotedStr(TrainJiaoluGUID)]);  
  end
  else begin
    strSql + ' and (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ) ';
    strSql := Format(strSql,[QuotedStr(SiteGUID)]);
  end;

  strSql := strSql + ' order by dtStartTime,nID Desc ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetSubPlans(PlanGUIDs, SubPlanGUIDs: TStrings);
var
  adoQuery : TADOQuery;
  I: Integer;
  strGUIDs: string;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);
  SubPlanGUIDs.Clear;
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := 'select strTrainPlanGUID from TAB_Plan_Train where '
      + 'nPlanState > '+ IntToStr(Ord(psCancel)) + ' and strMainPlanGUID in ' + strGUIDS;
    adoQuery.Open();

    while not  adoQuery.Eof do
    begin
      SubPlanGUIDs.Add(adoQuery.FieldByName('strTrainPlanGUID').AsString);
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.LoadTrainPlan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'exec PROC_LoadTrainNo %s,%s,%s,%s,%s';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginDateTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndDateTime)),
      QuotedStr(TrainJiaoluGUID),
      QuotedStr(DutyUserGUID),
      QuotedStr(SiteGUID)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.LoadTrainPlanByPaiBan(BeginDateTime,
  EndDateTime: TDateTime; TrainJiaoluGUID, DutyUserGUID, SiteGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'exec PROC_LoadTrainNo %s,%s,%s,%s,%s';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginDateTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndDateTime)),
      QuotedStr(TrainJiaoluGUID),
      QuotedStr(DutyUserGUID),
      QuotedStr(SiteGUID)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;
procedure TRsDBTrainPlan.OrderDispath(TrainJiaoluGUID: string;
  TrainmanJiaolus: TStrings; DutyUser: TRsDutyUser; DutySite: TRsSiteInfo);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
  strGUIDs : string;
begin
  for i := 0 to TrainmanJiaolus.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(TrainmanJiaolus[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(TrainmanJiaolus[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  strSql := 'exec PROC_Plan_AutoDispatch %s,%s';
  strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),QuotedStr(strGUIDs)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TRsDBTrainPlan.OutRoom(ADOConn: TADOConnection;OutRoomInfo :RRsOutRoomInfo): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      ADOConn.BeginTrans;
      try
        //插入入寓信息表
        strSql := 'insert into TAB_Plan_OutRoom (strOutRoomGUID,strTrainPlanGUID, ' +
          ' strTrainmanGUID,dtOutRoomTime,nOutRoomVerifyID,strDutyUserGUID) ' +
          ' values (%s,%s,%s,getdate(),%d,%s)';
        strSql := Format(strSql,[QuotedStr(NewGUID),QuotedStr(OutRoomInfo.strTrainPlanGUID),
              QuotedStr(OutRoomInfo.strTrainmanGUID),
              Ord(OutRoomInfo.nVerifyID),QuotedStr(OutRoomInfo.strDutyUserGUID)]);
        SQL.Text := strSql;
        if ExecSQL = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;             
        //修改乘务员状态
        strSql := 'update tab_org_trainman set nTrainmanState = %d where strGUID = %s ';
        strSql := Format(strSql,[Ord(tsOutRoom),QuotedStr(OutRoomInfo.strTrainmanGUID)]);
        SQL.Text := strSql;
        if ExecSQL = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;
        //修改计划状态
        strSql := 'select * from VIEW_plan_InOut where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(OutRoomInfo.strTrainPlanGUID)]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          ADOConn.RollbackTrans;
          exit;
        end;
        if FieldByName('strTrainmanGUID1').AsString = OutRoomInfo.strTrainmanGUID then
        begin
          if  (FieldByName('strTrainmanGUID2').IsNull or (not FieldByName('dtOutRoomTime2').IsNull))
              and  (FieldByName('strTrainmanGUID3').IsNull or (not FieldByName('dtOutRoomTime3').IsNull)) then
          begin
            strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
            strSql := Format(strSql,[Ord(psOutRoom),QuotedStr(OutRoomInfo.strTrainPlanGUID)]);
            Sql.Text := strSql;
            if ExecSQL = 0 then
            begin
              ADOConn.RollbackTrans;
              exit;
            end;
          end;
        end else begin
          if FieldByName('strTrainmanGUID2').AsString = OutRoomInfo.strTrainmanGUID then
          begin
            if  (FieldByName('strTrainmanGUID1').IsNull or (not FieldByName('dtOutRoomTime1').IsNull))
                and  (FieldByName('strTrainmanGUID3').IsNull or (not FieldByName('dtOutRoomTime3').IsNull)) then
            begin
              strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
              strSql := Format(strSql,[Ord(psOutRoom),QuotedStr(OutRoomInfo.strTrainPlanGUID)]);
              Sql.Text := strSql;
              if ExecSQL = 0 then
              begin
                ADOConn.RollbackTrans;
                exit;
              end;
            end;
          end else begin
            if FieldByName('strTrainmanGUID3').AsString = OutRoomInfo.strTrainmanGUID then
            begin
              if  (FieldByName('strTrainmanGUID2').IsNull or (not FieldByName('dtOutRoomTime2').IsNull))
                  and  (FieldByName('strTrainmanGUID1').IsNull or (not FieldByName('dtOutRoomTime1').IsNull)) then
              begin
                strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s ';
                strSql := Format(strSql,[Ord(psOutRoom),QuotedStr(OutRoomInfo.strTrainPlanGUID)]);
                Sql.Text := strSql;
                if ExecSQL = 0 then
                begin
                  ADOConn.RollbackTrans;
                  exit;
                end;      
              end;
            end;
          end;
        end;
        ADOConn.CommitTrans;
        Result := true;
      except
        ADOConn.RollbackTrans;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainPlan.PublishPlan(PlanGUIDs: TStrings;SiteGUID,DutyUserGUID: string);
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psPublish),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'PROC_Plan_AddPublishRecord %s,%s,%s';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;
          if execsql = 0 then
          begin
            exit;
          end;
        end;
        m_ADOConnection.CommitTrans;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.PushNameplateNamed(TrainmanJiaoluGUID, DutyUserGUID: string) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  //  @TrainmanJiaoluGUID varchar(50),
  //  @DutyGUID varchar(50)
  strSql := 'exec PROC_Plan_PushNameplateNamed %s,%s';
  strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID),QuotedStr(DutyUserGUID)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Result :=  ExecSQL > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainPlan.ReceivePlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID  : string);
var
  i : integer;
  strSql,strGUIDs,siteName,dutyUserName,dutyUserID : string;
  adoQuery : TADOQuery;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select strSiteName from TAB_Base_Site where strSiteGUID=%s';
      strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('本客户端信息没有登记！');
        exit;
      end;
      siteName := FieldByName('strSiteName').AsString;

      strSql := ' select strDutyName,strDutyNumber from TAB_Org_DutyUser where strDutyGUID=%s';
      strSql := Format(strSql,[QuotedStr(DutyUserGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('当前登录用户没有登记！');
        exit;
      end;
      dutyUserName := FieldByName('strDutyName').AsString;
      dutyUserID   := FieldByName('strDutyNumber').AsString;

      strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s and nPlanState = %d';
      strSql := Format(strSql,[Ord(psReceive),strGUIDs,Ord(psSent)]);
      SQL.Text := strSql;
      ExecSQL;

      strSql := ' update tab_plan_send set bIsRec = 1,dtRecTime = getdate(),strRecSiteGUID=%s, ' +
       ' strRecSiteName=%s,strRecUserGUID=%s,strRecUserName=%s,strRecUserID=%s ' +
       ' where strTrainPlanGUID in %s and  ' +
 	     ' (dtSendTime = (select max(dtSendTime) from tab_plan_send tSend where tSend.strTrainPlanGUID=tab_plan_send.strTrainPlanGUID) and bIsRec = 0) ';

      strSql := Format(strSql,[
        QuotedStr(SiteGUID),
        QuotedStr(siteName),
        QuotedStr(DutyUserGUID),
        QuotedStr(dutyUserName),
        QuotedStr(dutyUserID),
        strGUIDs
        ]);
      SQL.Text := strSql;
      ExecSQL;

    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.RefreshTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where strTrainplanGUID = %s';
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID)]);

      Open;
      if adoQuery.RecordCount > 0 then
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
function TRsDBTrainPlan.ReloadGroupOfPlan(TrainPlanGUID: string): boolean;
var
  strSql : string;
  strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3 : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3 from TAB_Nameplate_Group where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
      strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
      strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString;

      strSql := 'update tab_Plan_Trainman set strTrainmanGUID1 = %s,strTrainmanGUID2=%s,strTrainmanGUID3=%s where strTrainPlanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(strTrainmanGUID1),QuotedStr(strTrainmanGUID2),QuotedStr(strTrainmanGUID3),QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.RemoveEndWorkRecord(strEndWorkGUID: string);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;

    //删除测酒记录
    ADOQuery.SQL.Text := 'delete from TAB_Drink_Information where strWorkID = '
      + QuotedStr(strEndWorkGUID);

    ADOQuery.ExecSQL;

    ADOQuery.SQL.Text :=
    'update TAB_Plan_Train Set nPlanState = %d where ' +
      'nPlanState = %d and strTrainPlanGUID = (select top 1 strTrainplanGUID from ' +
      'TAB_Plan_EndWork where strEndWorkGUID = %s) ';

    ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[Ord(psBeginWork),Ord(psEndWork),
    QuotedStr(strEndWorkGUID)]);

    ADOQuery.ExecSQL;

    ADOQuery.SQL.Text := 'delete from TAB_Plan_EndWork where strEndWorkGUID = '
      + QuotedStr(strEndWorkGUID);

    ADOQuery.ExecSQL;    
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBTrainPlan.SendPlan(PlanGUIDS: TStrings;SiteGUID:String;DutyUserGUID:string): boolean;
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psSent),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'PROC_Plan_AddSendRecord %s,%s,%s';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;
          if execsql = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;
        end;
        m_ADOConnection.CommitTrans;
        result := true;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.SetBeginWorkTime(TrainPlanGUID: string; OldBeginWorkTime,
  NewBeginWorkTime: TDateTime; DutyUser : TRsDutyUser; DutySite : TRsSiteInfo);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set dtChuQinTime  = %s where strTrainPlanGUID = %s ';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewBeginWorkTime)),
          QuotedStr(TrainPlanGUID)]);
        SQL.Text  := strSql;
        ExecSql;

        m_ADOConnection.CommitTrans;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.SetGroupToPlan(Group: RRsGroup; TrainPlan: RRsTrainPlan;
  DutyUserGUID,DutySiteGUID  : string);
var
  strSql : string;
  dtChuQinTime : TDateTime;
  rest : RRsRest ;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
//
//      strSql := 'select strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3 from tab_plan_trainman where strTrainPlanGUID = %s';
//      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);
//      strSql :=
//       //修改当前机组值乘计划信息
//      strSql := 'update tab_org_trainman set nTrainmanState = %d where ';
//      strSql := Format(strSql,[QuotedStr(Group.strTrainPlanGUID)]);
//      SQL.Text := strSql;
//      ExecSQL;

       //修改当前机组值乘计划信息
      strSql := 'delete from TAB_Plan_Trainman where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(Group.strTrainPlanGUID)]);
      SQL.Text := strSql;
      ExecSQL;
      //根据出勤地点设置获取计划中的出勤时间、侯班信息的缺省信息
      if GetChuQinSetInfo(TrainPlan,Group.Trainman1,dtChuQinTime,rest) then 
      begin
        strSql := 'update TAB_Plan_Train set dtChuQinTime = %s,nNeedRest=%d,dtArriveTime=%s,dtCallTime=%s where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtChuQinTime)),
          Rest.nNeedRest,
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',Rest.dtArriveTime)),
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',Rest.dtCallTime)),
          QuotedStr(TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;  
      end;

      //修改人员信息
      strSql := 'select * from TAB_Plan_Trainman where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        Append;
      end
      else begin
        Edit;
      end;
      FieldByName('strTrainPlanGUID').AsString := TrainPlan.strTrainPlanGUID;
      FieldByName('strTrainmanGUID1').AsString := Group.Trainman1.strTrainmanGUID;
      FieldByName('strTrainmanGUID2').AsString := Group.Trainman2.strTrainmanGUID;
      FieldByName('strTrainmanGUID3').AsString := Group.Trainman3.strTrainmanGUID;
      FieldByName('strGroupGUID').AsString := Group.strGroupGUID;
      FieldByName('strDutyGUID').AsString := DutyUserGUID;
      FieldByName('strDutySiteGUID').AsString := DutySiteGUID;
      Post;
      //修改当前机组值乘计划信息
      strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID),
        QuotedStr(Group.strGroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;  
end;

procedure TRsDBTrainPlan.SetPlanRest(TrainPlanGUID:string;OldRest,NewRest : RRsRest;
  DutyUser : TRsDutyUser; DutySite : TRsSiteInfo);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Plan_Train set nNeedRest = %d,dtArriveTime = %s,dtCallTime = %s where strTrainPlanGUID = %s ';
      strSql := Format(strSql,[NewRest.nNeedRest,
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewRest.dtArriveTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewRest.dtCallTime)),
        QuotedStr(TrainPlanGUID)]);
      SQL.Text  := strSql;
      ExecSql;
    end;
  finally
    adoQuery.Free;
  end;
end;


class procedure TRsDBTrainPlan.TrainPlanFromADOQuery(var TrainPlan: RRsTrainPlan;
  ADOQuery: TADOQuery);
begin
  with ADOQuery do
  begin
    TrainPlan.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    TrainPlan.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainPlan.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainPlan.strTrainNo := FieldByName('strTrainNo').AsString;
    TrainPlan.dtStartTime := FieldByName('dtStartTime').AsDateTime;
    TrainPlan.dtRealStartTime := FieldByName('dtRealStartTime').AsDateTime;
    TrainPlan.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainPlan.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainPlan.strStartStation := FieldByName('strStartStation').AsString;
    TrainPlan.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainPlan.strEndStation := FieldByName('strEndStation').AsString;
    TrainPlan.strEndStationName := FieldByName('strEndStationName').AsString;

    TrainPlan.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').AsInteger);
    TrainPlan.nPlanType := TRsPlanType(FieldByName('nPlanType').AsInteger);
    TrainPlan.nDragType := TRsDragType(FieldByName('nDragType').AsInteger);
    TrainPlan.nKeHuoID := TRsKehuo(FieldByName('nKeHuoID').AsInteger);
    TrainPlan.nRemarkType := TRsPlanRemarkType(FieldByName('nRemarkType').AsInteger);
    TrainPlan.strRemark := FieldByName('strRemark').AsString;
    TrainPlan.nPlanState := TRsPlanState(FieldByName('nPlanState').AsInteger);
    TrainPlan.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    TrainPlan.strCreateSiteGUID := FieldByName('strCreateSiteGUID').AsString;
    TrainPlan.strCreateUserGUID := FieldByName('strCreateUserGUID').AsString;
  end;
end;

procedure TRsDBTrainPlan.TrainPlanToADOQuery(ADOQuery: TADOQuery; TrainPlan : RRsTrainPlan; UpdateState : boolean = true);
begin
  with ADOQuery do
  begin
    FieldByName('strTrainPlanGUID').AsString := TrainPlan.strTrainPlanGUID;
    FieldByName('strTrainTypeName').AsString := TrainPlan.strTrainTypeName;
    FieldByName('strTrainNumber').AsString := TrainPlan.strTrainNumber;
    FieldByName('strTrainNo').AsString := TrainPlan.strTrainNo;
    FieldByName('dtStartTime').AsDateTime := TrainPlan.dtStartTime;
    FieldByName('dtRealStartTime').AsDateTime := TrainPlan.dtRealStartTime;
    FieldByName('strTrainJiaoluGUID').AsString := TrainPlan.strTrainJiaoluGUID;
    FieldByName('strStartStation').AsString := TrainPlan.strStartStation;
    FieldByName('strEndStation').AsString := TrainPlan.strEndStation;
    FieldByName('nTrainmanTypeID').AsInteger := Ord(TrainPlan.nTrainmanTypeID);
    FieldByName('nPlanType').AsInteger := Ord(TrainPlan.nPlanType);
    FieldByName('nDragType').AsInteger := Ord(TrainPlan.nDragType);
    FieldByName('nKeHuoID').AsInteger := Ord(TrainPlan.nKeHuoID);
    FieldByName('nRemarkType').AsInteger := Ord(TrainPlan.nRemarkType);
    FieldByName('strRemark').AsString := TrainPlan.strRemark;
    if updateState then
      FieldByName('nPlanState').AsInteger := Ord(TrainPlan.nPlanState);
    FieldByName('dtCreateTime').AsDateTime := TrainPlan.dtCreateTime;
    FieldByName('strCreateSiteGUID').AsString := TrainPlan.strCreateSiteGUID;
    FieldByName('strCreateUserGUID').AsString := TrainPlan.strCreateUserGUID;
    FieldByName('strMainPlanGUID').AsString := TrainPlan.strMainPlanGUID;
  end;
end;

procedure TRsDBTrainPlan.TurnPlateNamed(TrainmanJiaoluGUID: string);
var
  i : integer;
  strSql,strFirstGroupGUID,strPreCheciGUID,strFinalCheciGUID : string;
  adoQuery,adoQueryOrder : TADOQuery;
begin
  strSql :=  'select * from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s order by nCheciOrder';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID)]);
      Sql.Text := strSql;
      Connection := m_ADOConnection;
      Open;
      i := 0;
      while not eof do
      begin
        if i = 0 then
        begin
          strFirstGroupGUID := FieldByName('strGroupGUID').asstring;
        end;
        if (i = RecordCount -1) then
        begin
          strFinalCheciGUID := FieldByName('strCheCiGUID').asstring;
        end;
        if i > 0 then
        begin
          strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
          strSql := Format(strSql,[QuotedStr(FieldByName('strGroupGUID').AsString),QuotedStr(strPreCheciGUID)]);
          adoQueryOrder := TADOQuery.Create(m_ADOConnection);
          adoQueryOrder.Connection := m_ADOConnection;
          adoQueryOrder.SQL.Text := strSql;
          adoQueryOrder.ExecSQL;
        end;
        strPreCheciGUID := FieldByName('strCheCiGUID').asstring;
        Inc(i);
        next;
      end;
    end;

    strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
    strSql := Format(strSql,[QuotedStr(strFirstGroupGUID),QuotedStr(strFinalCheciGUID)]);
    adoQueryOrder := TADOQuery.Create(m_ADOConnection);
    adoQueryOrder.Connection := m_ADOConnection;
    adoQueryOrder.SQL.Text := strSql;
    adoQueryOrder.ExecSQL;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.TurnPlateOrder(TrainmanGUID : string;TrainmanPlan:RRsTrainmanPlan;
      TrainmanJiaoluGUID:String;nRunType : TRsRunType;StationGUID : string;
      ArriveTime : TDateTime;IsBeginWork : boolean);
var
  strSql : string;
  adoQuery : TADOQuery;
  strZFQJGUID,strDestZFQJGUID,strDestStationGUID,strSourceStation : string;
  nQuJianIndex : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      if nRunType = trtZFQJ then
      begin
        {$region '获取当前机组所在的折返区间和区间序号'}
        strSql := 'select strZFQJGUID,nQuJianIndex from  VIEW_Nameplate_Group  where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        Open;
        strZFQJGUID := FieldByName('strZFQJGUID').AsString;
        nQuJianIndex := FieldByName('nQuJianIndex').asInteger;
        {$endregion '获取当前机组所在的折返区间和区间序号'}
            
        {$region '获取本机组应该到达的下一个折返区间'}
        strSql := 'select top 1 strZFQJGUID from TAB_Base_ZFQJ  ' +
          ' where strTrainJiaoluGUID = %s and ' +
          ' nQuJianIndex > %d ' +
          ' order by nQuJianIndex';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainJiaoluGUID)
          ,nQuJianIndex]);  
        SQL.Text := strSql;
        Open;
        if RecordCount > 0 then
        begin
          strDestZFQJGUID := FieldByName('strZFQJGUID').AsString;
        end else begin
          //获取本机组应该到达的下一个折返区间
          strSql := 'select top 1 strZFQJGUID from TAB_Base_ZFQJ  ' +
            ' where strTrainJiaoluGUID = %s ' + 
            ' order by nQuJianIndex';
          strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainJiaoluGUID)
            ]);  
          SQL.Text := strSql;
          Open;
          strDestZFQJGUID := FieldByName('strZFQJGUID').AsString;
        end;            
        {$endregion '获取本机组应该到达的下一个折返区间'}

        {$region '获取当前机组所在的折返区间和区间序号'}
        strSql := 'select nOrder  from  TAB_Nameplate_TrainmanJiaolu_Order  where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        Open;
        {$endregion '获取当前机组所在的折返区间和区间序号'}

            
        {$region '将本机组的序号设置为人员交路内的机组的最大序号加1'}
        strSql := 'update TAB_Nameplate_Group set strZFQJGUID = %s where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(strDestZFQJGUID),
          QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        ExecSQL;
            
        strSql := 'update TAB_Nameplate_TrainmanJiaolu_Order set dtLastArriveTime = %s where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',ArriveTime)),
          QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        ExecSQL;
        {$endregion}
      end else begin

        {$region '获取当前机组所在的折返区间和区间序号'}
        strSql := 'select nOrder,strStationGUID  from  VIEW_Nameplate_TrainmanJiaolu_Order  where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        Open;
        strSourceStation := FieldByName('strStationGUID').AsString;
        {$endregion '获取当前机组所在的折返区间和区间序号'}

        
        strDestStationGUID := StationGUID;
        if IsBeginWork then
        begin
          strDestStationGUID := TrainmanPlan.TrainPlan.strEndStation;        
        end;

        strSql := 'update TAB_Nameplate_Group set strStationGUID = %s where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(strDestStationGUID),
          QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        ExecSQL;

        strSql := 'update TAB_Nameplate_TrainmanJiaolu_Order set dtLastArriveTime = %s where strGroupGUID = %s';
        strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',ArriveTime)),
          QuotedStr(TrainmanPlan.Group.strGroupGUID)]);
        SQL.Text := strSql;
        ExecSQL;
        {$region ''}
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.Update(TrainPlan: RRsTrainPlan;DTNow : Tdatetime;SiteGUID:String;DutyUserGUID:string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'Select * from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      try
        Sql.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Raise Exception.Create('无次计划信息!');
          exit;
        end;      
        Edit;
        //开车前三个小时不能修改初发开车时间
        if IncHour(TrainPlan.dtRealStartTime,3) < dtnow  then
        begin
          TrainPlan.dtFirstStartTime := TrainPlan.dtRealStartTime;
        end;      
        TrainPlanToADOQuery(ADOQuery,TrainPlan,false);
        Post;


        if Ord(TrainPlan.nPlanState) >= Ord(psSent) then
        begin
          Close;

          strSql := 'PROC_Plan_WriteChangeLog %s,%s,%s';;
          SQL.Text := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID),
            QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);

          ExecSQL;
        end;
        

      except
        on E: Exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise Exception.Create(E.Message);
        end;
      end;
    end;
    m_ADOConnection.CommitTrans;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.UpdateEndWorkTestResult(strEndWorkGUID: string;
  RsDrink : RRsDrink);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'select * from TAB_Drink_Information where strWorkID = '
      + QuotedStr(strEndWorkGUID);

    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
      ADOQuery.Edit
    else
      Exit;

    ADOQuery.FieldByName('nDrinkResult').AsInteger :=
        RsDrink.nDrinkResult;
        
    ADOQuery.FieldByName('dtCreateTime').AsDateTime := RsDrink.dtCreateTime;

    ADOQuery.FieldByName('strImagePath').AsString := RsDrink.strPictureURL;
    ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;
end;

class function TRsDBTrainPlan.UpdatePlanRecordTime(ADOConn: TADOConnection;
  TrainPlanGUID: string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      strSql := 'update TAB_Plan_Trainman set dtCallTime=getdate() where strTrainPlanGUID=%s';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      Result := ExecSQL > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.UpdatePlanState(TrainPlanGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    With adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s and nPlanState = %d' +
        ' and (select count(*) from VIEW_Plan_BeginWork where strTrainPlanGUID = TAB_Plan_Train.strTrainPlanGUID and ' +
          ' ((strTrainmanGUID1 is null or strTrainmanGUID1 = %s or not(dtTestTime1 is null)) ' +
          ' and  (strTrainmanGUID2 is null or  strTrainmanGUID2 = %s or not(dtTestTime2 is null)) ' +
          ' and (strTrainmanGUID3 is null or strTrainmanGUID3 = %s or not(dtTestTime3 is null)))' +
        ') > 0';
      strSql := Format(strSql,[Ord(psBeginWork),QuotedStr(TrainPlanGUID),Ord(psPublish),QuotedStr(''),QuotedStr(''),QuotedStr('')]);
      Sql.Text := strSql;
      ExecSql;

//      strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s and nPlanState = %d' +
//        ' and (select count(*) from VIEW_Plan_Trainman where strTrainPlanGUID = TAB_Plan_Train.strTrainPlanGUID and ' +
//          ' ((nTrainmanState1 = %d)  or  (nTrainmanState2 = %d) or (nTrainmanState3 = %d))' +
//        ') > 0';
//      strSql := Format(strSql,[Ord(psPublish),QuotedStr(TrainPlanGUID),Ord(psBeginWork),Ord(tsPlaning),Ord(tsPlaning),Ord(tsPlaning)]);
//      Sql.Text := strSql;
//      ExecSql;
    end; 
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetTrainPlans(BeginDateTime, EndDateTime: TDateTime;
  TrainJiaoluGUID: string; PlanStateSet: TRsPlanStateSet;
  out TrainPlanArray: TRsTrainPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Train where dtStartTime >=%s and dtStartTime <= %s ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginDateTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndDateTime))]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by dtStartTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainPlan(adoQuery,TrainPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetTuiQinPlan(TuiQinPlanGUID: string;
  out TuiQinPlan: RRsTuiQinPlan): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_EndWork ' +
    ' where  strTrainPlanGUID = %s';

  strSql := Format(strSql,[QuotedStr(TuiQinPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToTuiQinPlan(ADOQuery,TuiQinPlan);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetTrainmanPlan(TrainmanPlanGUID: string;
  var TrainmanPlan: RRsTrainmanPlan): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_Trainman where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID)]);

  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;      
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainPlan.GetTrainmanPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where (dtStartTime >=%s or '
    + '(dtStartTime <= 36524))and dtStartTime <= %s and nPlanState <> 0';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime))]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by dtStartTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetTrainmanTuiQinPlan(TrainmanGUID: string;
  out TuiQinPlan : RRsTuiQinPlan;SiteGUID : string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_EndWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' nPlanState = %d AND (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s) order by dtStartTime desc';

  strSql := Format(strSql,[QuotedStr(SiteGUID),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToTuiQinPlan(ADOQuery,TuiQinPlan);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
