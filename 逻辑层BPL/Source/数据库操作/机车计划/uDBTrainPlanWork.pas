unit uDBTrainPlanWork;

interface

uses
  ADODB,Classes,uTrainPlan,uTFSystem,uTrainmanJiaolu,uTrainman,uApparatusCommon,
  Dialogs,uTFVariantUtils,Variants,uSaftyEnum,uDBTrainmanJiaolu,uDrink,
  uSite,uDutyUser;

type
  //////////////////////////////////////////////////////////////////////////////
  ///机车计划操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainPlanWork = class(TDBOperate)
  private
    //从ADOQuery填充机车计划
    procedure ADOQueryToTrainPlan(ADOQuery : TADOQuery;out TrainPlan :  RRsTrainPlan);
    //从ADOquery中填充到出勤计划中
    procedure ADOQueryToChuQinPlan(ADOQuery : TADOQuery;out ChuQinPlan : RRsChuQinPlan;
      NeedPicture : boolean);
    //从ADOquery中填充到退勤计划中
    procedure ADOQueryToTuiQinPlan(ADOQuery : TADOQuery;out TuiQinPlan : RRsTuiQinPlan);
    //包乘翻牌,需要提供翻牌人，值乘计划，所在车站，是否出勤翻牌
    procedure TurnPlateOrder(TrainmanGUID : string;TrainmanPlan:RRsTrainmanPlan;
      TrainmanJiaoluGUID : STRING;nRunType : TRsRunType;StationGUID : string;
      ArriveTime : TDateTime;IsBeginWork : boolean);
  public
    //获取客户端管辖区段内需要出勤的计划信息
    procedure GetNeedChuQinPlansOfSite(BeginTime,EndTime : TDateTime;SiteGUID : string;
      out ChuQinPlanArray : TRsChuQinPlanArray);
    //获取指定工号的乘务员所在的出勤计划
    function GetTrainmanChuQinPlan(TrainmanGUID : string;
      out ChuQinPlan : RRsChuQinPlan;SiteGUID : string) : boolean;
     //获取指定工号的乘务员所在的出勤计划
    function GetTrainmanChuQinPlanFromDrink(TrainmanGUID : string;
      out ChuQinPlan : RRsChuQinPlan;SiteGUID : string;DrinkTime:TDateTime) : boolean;
    //判断两个人员计划的数组是否相等
    function EqualChuQinPlan(Source,Dest : TRsChuQinPlanArray):boolean;
    //指定的乘务员执行出勤操作
    procedure BeginWork(TrainmanGUID : string;
  TrainmanPlan:RRsTrainmanPlan;RsDrink : RRsDrink;
  BeginWorkStationGUID:string);

      //指定的乘务员执行出勤操作--导入手工记录
    procedure ImportBeginWork(Trainman: RRsTrainman;
      TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
      DutyUserGUID:string;BeginWorkStationGUID:string;DTNow : TDateTime);

  public
    //获取客户端管辖区段内需要出勤的计划信息
    procedure GetNeedTuiQinPlansOfSite(BeginTime,EndTime : TDateTime;SiteGUID : string;
      out TuiQinPlanArray : TRsTuiQinPlanArray;nOutWorkHours : integer = 17);
     //获取指定工号的乘务员所在的出勤计划
    function GetTrainmanTuiQinPlan(TrainmanGUID : string;
      out TuiQinPlan : RRsTuiQinPlan;SiteGUID : string) : boolean;
    //根据测酒时间和 定工号的乘务员所在的出勤计划
    function GetTrainmanTuiQinPlanFromDrink(TrainmanGUID : string;
      out TuiQinPlan : RRsTuiQinPlan;SiteGUID : string;DrinkTime:TDateTime) : boolean;

    //获取最后一次退勤记录GUID
    function GetLastTuiQinRecord(TrainmanGUID : string;var strEndWorkGUID: string;
      var strTrainPlanGUID:string;  var EndWorkTime: TDateTime):Boolean;
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
  public //测试用例
    //获取出勤计划信息
    function GetChuQinPlan(ChuQinPlanGUID : string;var ChuQinPlan : RRsChuQinPlan):boolean;overload;     
    //获取指定工号的乘务员所在的出勤计划
    function GetTuiQinPlan(TuiQinPlanGUID  : string;out TuiQinPlan : RRsTuiQinPlan) : boolean;
  public                               
    //获取测酒记录
    function GetTrainmanDrinkInfo(strTrainmanGUID,strTrainPlanGUID: string;
        WorkType: TRsWorkTypeID;var RsDrink : RRsDrink): Boolean;
    //添加酒记录
    procedure AddDrinkInfo(RsDrink : RRsDrink);
  end;

implementation
uses
  SysUtils, DB,DateUtils;
{ TDBTrainPlan }


procedure TRsDBTrainPlanWork.AddDrinkInfo(RsDrink : RRsDrink);
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
      strSql := 'insert into TAB_Drink_Information  ' +
        ' ( strGUID,bLocalAreaTrainman,strTrainmanGUID,strTrainmanNumber,strTrainmanName ,dwAlcoholicity ,nDrinkResult,dtCreateTime , ' +
        ' strTrainNo , strTrainNumber , strTrainTypeName , strPlaceID , strPlaceName, strSiteGUID , strSiteNumber,strSiteName , '  +
        ' strWorkShopGUID , strWorkShopName ,strAreaGUID,strDutyNumber,strDutyName,nVerifyID,strWorkID,nWorkTypeID,strImagePath ) ' +
        'values (:strGUID,:bLocalAreaTrainman,:strTrainmanGUID,:strTrainmanNumber,:strTrainmanName,:dwAlcoholicity,:nDrinkResult,:dtCreateTime,' +
        ' :strTrainNo , :strTrainNumber , :strTrainTypeName , :strPlaceID , :strPlaceName, :strSiteGUID ,:strSiteNumber, :strSiteName , '  +
        ' :strWorkShopGUID , :strWorkShopName ,:strAreaGUID,:strDutyNumber,:strDutyName,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath)';
      SQL.Text := strSql;
      Parameters.ParamByName( 'strGUID').Value := NewGUID;
      Parameters.ParamByName( 'bLocalAreaTrainman').Value := RsDrink.bLocalAreaTrainman;
      Parameters.ParamByName( 'strTrainmanGUID').Value := RsDrink.strTrainmanGUID;
      Parameters.ParamByName( 'strTrainmanNumber').Value := RsDrink.strTrainmanNumber;
      Parameters.ParamByName( 'strTrainmanName').Value := RsDrink.strTrainmanName;

      Parameters.ParamByName( 'dwAlcoholicity').Value := RsDrink.dwAlcoholicity;

      Parameters.ParamByName( 'strTrainNo').Value := RsDrink.strTrainNo;
      Parameters.ParamByName( 'strTrainNumber').Value := RsDrink.strTrainNumber;
      Parameters.ParamByName( 'strTrainTypeName').Value := RsDrink.strTrainTypeName;

      Parameters.ParamByName( 'strPlaceID').Value := RsDrink.strPlaceID;
      Parameters.ParamByName( 'strPlaceName').Value := RsDrink.strPlaceName;
      Parameters.ParamByName( 'strSiteGUID').Value := RsDrink.strSiteGUID;
      Parameters.ParamByName( 'strSiteNumber').Value := RsDrink.strSiteIp;
      Parameters.ParamByName( 'strSiteName').Value := RsDrink.strSiteName;

      Parameters.ParamByName( 'strWorkShopGUID').Value := RsDrink.strWorkShopGUID;
      Parameters.ParamByName( 'strWorkShopName').Value := RsDrink.strWorkShopName;

      Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
      Parameters.ParamByName('strImagePath').Value := RsDrink.strPictureURL;
      Parameters.ParamByName('dtCreateTime').Value := RsDrink.dtCreateTime;

      Parameters.ParamByName( 'strAreaGUID').Value := RsDrink.strAreaGUID;
      Parameters.ParamByName( 'strDutyNumber').Value := RsDrink.strDutyNumber;
      Parameters.ParamByName( 'strDutyName').Value := RsDrink.strDutyName;
      Parameters.ParamByName( 'nVerifyID').Value := RsDrink.nVerifyID;
      Parameters.ParamByName( 'strWorkID').Value := '';
      Parameters.ParamByName( 'nWorkTypeID').Value := RsDrink.nWorkTypeID;

      if ExecSQL = 0 then
      begin
        Exception.Create('添加测酒记录失败');
        exit;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlanWork.ADOQueryToChuQinPlan(ADOQuery: TADOQuery;
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

  ChuQinPlan.ChuQinGroup.Group.Trainman4.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID4').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman4.strTrainmanName := ADOQuery.FieldByName('strTrainmanName4').AsString;
  ChuQinPlan.ChuQinGroup.Group.Trainman4.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber4').AsString;
  if ADOQuery.FindField('strICCheckResult') <> nil then
    ChuQinPlan.strICCheckResult := ADOQuery.FieldByName('strICCheckResult').AsString;
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

  if not ADOQuery.FieldByName('nVerifyID4').IsNull then
    ChuQinPlan.ChuQinGroup.nVerifyID4 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID4').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult4').IsNull then
    ChuQinPlan.ChuQinGroup.TestAlcoholInfo4.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult4').AsInteger);
  ChuQinPlan.ChuQinGroup.TestAlcoholInfo4.dtTestTime :=  ADOQuery.FieldByName('dtTestTime4').AsDateTime;

end;

procedure TRsDBTrainPlanWork.ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan :  RRsTrainPlan);
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
    begin
      TrainPlan.dtRealStartTime := FieldByName('dtRealStartTime').Value;
      TrainPlan.dtFirstStartTime := FieldByName('dtRealStartTime').Value;
    end;
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

procedure TRsDBTrainPlanWork.ADOQueryToTuiQinPlan(ADOQuery: TADOQuery;
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

  TuiQinPlan.TuiQinGroup.Group.Trainman4.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID4').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman4.strTrainmanName := ADOQuery.FieldByName('strTrainmanName4').AsString;
  TuiQinPlan.TuiQinGroup.Group.Trainman4.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber4').AsString;
  
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

  if not ADOQuery.FieldByName('nVerifyID4').IsNull then
    TuiQinPlan.TuiQinGroup.nVerifyID4 := TRsRegisterFlag(ADOQuery.FieldByName('nVerifyID4').AsInteger);
  if not ADOQuery.FieldByName('nDrinkResult4').IsNull then
    TuiQinPlan.TuiQinGroup.TestAlcoholInfo4.taTestAlcoholResult :=  TTestAlcoholResult(ADOQuery.FieldByName('nDrinkResult4').AsInteger);
  TuiQinPlan.TuiQinGroup.TestAlcoholInfo4.dtTestTime :=  ADOQuery.FieldByName('dtTestTime4').AsDateTime;

  if ADOQuery.Fields.FindField('dtTurnStartTime') <> nil then
  begin
    if ( ADOQuery.FieldByName('dtTurnStartTime').AsDateTime > 0) then    
      TuiQinPlan.dtTurnStartTime := ADOQuery.FieldByName('dtTurnStartTime').AsDateTime;
    TuiQinPlan.bSigned := ADOQuery.FieldByName('bSigned').AsInteger;
    TuiQinPlan.bIsOver := ADOQuery.FieldByName('bIsOver').AsInteger;
  end;

  if ADOQuery.Fields.FindField('nTurnMinutes') <> nil then
  begin
    TuiQinPlan.nTurnMinutes := ADOQuery.FieldByName('nTurnMinutes').AsInteger;
    TuiQinPlan.nTurnAlarmMinutes := ADOQuery.FieldByName('nTurnAlarmMinutes').AsInteger;
  end;
end;

procedure TRsDBTrainPlanWork.BeginWork(TrainmanGUID : string;
  TrainmanPlan:RRsTrainmanPlan;RsDrink : RRsDrink;
  BeginWorkStationGUID:string);
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
        SQL.Text := 'Update TAB_System_Lock set nLock = -nLock';
        ExecSQL;
        
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

        //增加记录时候不修改原先的时间
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
          FieldByName('dtCreateTime').AsString := FormatDateTime('yyyy-MM-dd HH:nn:ss',RsDrink.dtCreateTime);
          FieldByName('nVerifyID').AsInteger := RsDrink.nVerifyID;
          FieldByName('strStationGUID').AsString := BeginWorkStationGUID;
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end else begin
          Edit;
          beginWorkID := FieldByName('strBeginWorkGUID').AsString;
          FieldByName('nVerifyID').AsInteger := RsDrink.nVerifyID ;
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end;
        Post;
       

        {$REGION '插入新的测酒记录'}
strSql := 'insert into TAB_Drink_Information  ' +
          ' ( strGUID,strTrainmanGUID,strTrainmanNumber,strTrainmanName ,dwAlcoholicity ,nDrinkResult,dtCreateTime , ' +
          ' strTrainNo , strTrainNumber , strTrainTypeName , strPlaceID , strPlaceName, strSiteGUID , strSiteName , '  +
          ' strWorkShopGUID , strWorkShopName ,strAreaGUID,strDutyNumber,strDutyName,nVerifyID,strWorkID,nWorkTypeID,strImagePath,strSiteNumber,bLocalAreaTrainman ) ' +
          'values (:strGUID,:strTrainmanGUID,:strTrainmanNumber,:strTrainmanName,:dwAlcoholicity,:nDrinkResult,:dtCreateTime,' +
          ' :strTrainNo , :strTrainNumber , :strTrainTypeName , :strPlaceID , :strPlaceName, :strSiteGUID , :strSiteName , '  +
          ' :strWorkShopGUID , :strWorkShopName ,:strAreaGUID,:strDutyNumber,:strDutyName,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath,:strSiteNumber,:bLocalAreaTrainman)';
        SQL.Text := strSql;
        Parameters.ParamByName( 'strGUID').Value := NewGUID;
        Parameters.ParamByName( 'strTrainmanGUID').Value := RsDrink.strTrainmanGUID;
        Parameters.ParamByName( 'strTrainmanNumber').Value := RsDrink.strTrainmanNumber;
        Parameters.ParamByName( 'strTrainmanName').Value := RsDrink.strTrainmanName;

        Parameters.ParamByName( 'dwAlcoholicity').Value := RsDrink.dwAlcoholicity;

        Parameters.ParamByName( 'strTrainNo').Value := RsDrink.strTrainNo;
        Parameters.ParamByName( 'strTrainNumber').Value := RsDrink.strTrainNumber;
        Parameters.ParamByName( 'strTrainTypeName').Value := RsDrink.strTrainTypeName;

        Parameters.ParamByName( 'strPlaceID').Value := RsDrink.strPlaceID;
        Parameters.ParamByName( 'strPlaceName').Value := RsDrink.strPlaceName;
        Parameters.ParamByName( 'strSiteGUID').Value := RsDrink.strSiteGUID;
        Parameters.ParamByName( 'strSiteName').Value := RsDrink.strSiteName;

        Parameters.ParamByName( 'strWorkShopGUID').Value := RsDrink.strWorkShopGUID;
        Parameters.ParamByName( 'strWorkShopName').Value := RsDrink.strWorkShopName;

        Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
        Parameters.ParamByName('strImagePath').Value := RsDrink.strPictureURL;
        Parameters.ParamByName('dtCreateTime').Value := RsDrink.dtCreateTime;

        Parameters.ParamByName( 'strAreaGUID').Value := RsDrink.strAreaGUID ;
        Parameters.ParamByName( 'strDutyNumber').Value := RsDrink.strDutyNumber;
        Parameters.ParamByName( 'strDutyName').Value := RsDrink.strDutyName;
        Parameters.ParamByName( 'nVerifyID').Value := RsDrink.nVerifyID;
        Parameters.ParamByName( 'strWorkID').Value := beginWorkID ;
        Parameters.ParamByName( 'nWorkTypeID').Value := 2  ;
        Parameters.ParamByName('strSiteNumber').Value := RsDrink.strSiteIP ;
        Parameters.ParamByName('bLocalAreaTrainman').Value := RsDrink.bLocalAreaTrainman;

        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          Exception.Create('添加出勤测酒记录失败');
          exit;
        end;
        {$ENDREGION}

        
        {$region '修改计划状态,设置为已出勤'}
        strSql := 'update TAB_Plan_Train set nPlanState=%d where strTrainPlanGUID=%s and  ' +
        ' (select count(*) from VIEW_Plan_BeginWork where strTrainPlanGUID=TAB_Plan_Train.strTrainPlanGUID  and  ' +
        ' ((strTrainmanGUID1 is null) or (strTrainmanGUID1 = %s) or not(dtTestTime1 is null)) and ' +
          ' ((strTrainmanGUID2 is null) or (strTrainmanGUID2 = %s) or not(dtTestTime2 is null))  and ' +
          ' ((strTrainmanGUID3 is null) or (strTrainmanGUID3 = %s) or not(dtTestTime3 is null))   and ' +
          ' ((strTrainmanGUID4 is null) or (strTrainmanGUID4 = %s) or not(dtTestTime4 is null))) > 0';
        strSql := Format(strSql,[Ord(psBeginWork),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
          QuotedStr(''),
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


        {$REGION '修改实际出勤时间'}

        strSql := Format('update TAB_Plan_Train set dtBeginWorkTime=getdate() '   +
        'where strTrainPlanGUID = %s and dtBeginWorkTime is null ',[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL ;

        
        {$ENDREGION}

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

procedure TRsDBTrainPlanWork.EndWork(TrainmanGUID : string;
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
        SQL.Text := 'Update TAB_System_Lock set nLock = -nLock';
        ExecSQL;
        
        {$region '司机的退勤测酒记录'}

        endWorkID := NewGUID;

        //新的测酒记录的时间不变更
        strSql := 'select * from TAB_Plan_EndWork where strTrainPlanGUID = %s and strTrainmanGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
            QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strEndWorkGUID').AsString := endWorkID;
          FieldByName('strTrainPlanGUID').AsString := TrainmanPlan.TrainPlan.strTrainPlanGUID;
          FieldByName('strTrainmanGUID').AsString := TrainmanGUID;
          FieldByName('dtCreateTime').AsString := FormatDateTime('yyyy-MM-dd HH:nn:ss',RsDrink.dtCreateTime);
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strStationGUID').AsString := EndWorkStationGUID;
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end else begin
          Edit;
          endWorkID := FieldByName('strEndWorkGUID').AsString;
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end;
        Post;

           //删除老的测酒记录

          strSQL := 'delete from TAB_Drink_Information where strWorkID = %s and nWorkTypeID=%d and strTrainmanGUID = %s';
          strSql := Format(strSql,[QuotedStr(endWorkID),3,QuotedStr(TrainmanGUID)]);
          Sql.Text := strSql;
          ExecSQL;
          //保存测酒记录
          strSql := 'insert into TAB_Drink_Information (strGUID,strTrainmanGUID, ' +
            ' nDrinkResult,dtCreateTime,strAreaGUID,strDutyGUID,nVerifyID,strWorkID,nWorkTypeID,strImagePath) ' +
            ' values (:strGUID,:strTrainmanGUID,:nDrinkResult,:dtCreateTime,' +
            ' :strAreaGUID,:strDutyGUID,:nVerifyID,:strWorkID,:nWorkTypeID,:strImagePath)';
          SQL.Text := strSql;
          Parameters.ParamByName( 'strGUID').Value := NewGUID;
          Parameters.ParamByName( 'strTrainmanGUID').Value := TrainmanGUID;
          Parameters.ParamByName( 'nDrinkResult').Value := RsDrink.nDrinkResult;
          Parameters.ParamByName( 'dtCreateTime').Value := RsDrink.dtCreateTime;
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
          ' ((strTrainmanGUID3 is null) or (strTrainmanGUID3 = %s) or not(dtTestTime3 is null))  and ' +
          ' ((strTrainmanGUID4 is null) or (strTrainmanGUID4 = %s) or not(dtTestTime4 is null))) > 0';
        strSql := Format(strSql,[Ord(psEndWork),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
          QuotedStr(''),
          QuotedStr(''),
          QuotedStr(''),QuotedStr('')  ]);
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

function TRsDBTrainPlanWork.GetPlanLastArriveTime(TrainPlanGUID: string;
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

function TRsDBTrainPlanWork.EqualChuQinPlan(Source, Dest: TRsChuQinPlanArray): boolean;
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
    if Source[i].strICCheckResult <> Dest[i].strICCheckResult then exit;
    
    if Source[i].dtBeginWorkTime <> Dest[i].dtBeginWorkTime then exit;

    if Source[i].ChuQinGroup.Group.Trainman1.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman1.strTrainmanGUID then exit;
    if Source[i].ChuQinGroup.Group.Trainman2.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman2.strTrainmanGUID then exit;
    if Source[i].ChuQinGroup.Group.Trainman3.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman3.strTrainmanGUID then exit;
    if Source[i].ChuQinGroup.Group.Trainman4.strTrainmanGUID <> Dest[i].ChuQinGroup.Group.Trainman4.strTrainmanGUID then exit;

    if Source[i].ChuQinGroup.nVerifyID1 <> Dest[i].ChuQinGroup.nVerifyID1 then exit;
    if Source[i].ChuQinGroup.nVerifyID2 <> Dest[i].ChuQinGroup.nVerifyID2 then exit;
    if Source[i].ChuQinGroup.nVerifyID3 <> Dest[i].ChuQinGroup.nVerifyID3 then exit;
    if Source[i].ChuQinGroup.nVerifyID4 <> Dest[i].ChuQinGroup.nVerifyID4 then exit;

    if Source[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo4.dtTestTime <> Dest[i].ChuQinGroup.TestAlcoholInfo4.dtTestTime then exit;

    if Source[i].ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult then exit;
    if Source[i].ChuQinGroup.TestAlcoholInfo4.taTestAlcoholResult <> Dest[i].ChuQinGroup.TestAlcoholInfo4.taTestAlcoholResult then exit;
  end;
  result := true;
end;

function TRsDBTrainPlanWork.GetLastTuiQinRecord(TrainmanGUID: string;
  var strEndWorkGUID: string; var strTrainPlanGUID:string;var EndWorkTime: TDateTime): Boolean;
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
        strTrainPlanGUID :=  FieldByName('strTrainPlanGUID').AsString;
        EndWorkTime := FieldByName('dtCreateTime').AsDateTime;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlanWork.GetNeedChuQinPlansOfSite(BeginTime, EndTime: TDateTime;
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

procedure TRsDBTrainPlanWork.GetNeedTuiQinPlansOfSite(BeginTime, EndTime: TDateTime;
  SiteGUID: string; out TuiQinPlanArray: TRsTuiQinPlanArray;nOutWorkHours : integer);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
  strJiaoLuCondition: string;
  dtNow : TDateTime;
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
    dtNow := Now;
    strSql := 'select getdate() as dtNow';
    with adoQuery do
    begin
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
        dtNow := FieldByName('dtNow').AsDateTime;
    end;

    strSql := 'select *,b.dtTurnStartTime ,bSigned,bIsOver,c.nTurnMinutes,c.nTurnAlarmMinutes from VIEW_Plan_EndWork ' +
      ' left join VIEW_WorkTime_Turn_Branch_MaxStartTime as b on  ' +
      ' VIEW_Plan_EndWork.strTrainPlanGUID = b.strFlowID  ' +
      ' left join TAB_Base_TrainmanTypeTurn as c on VIEW_Plan_EndWork.nTrainmanTypeID=c.nTrainmanTypeID and VIEW_Plan_EndWork.nKeHuoID=c.nKeHuoID  ' +
      ' where ((dtLastArriveTime >=%s and %s) or ' +
      ' (nPlanState = %d and  bIsOver = 0 and (%s  > DATEADD (mi,nTurnAlarmMinutes,dtTurnStartTime) and %s)))';


    strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
      ' strTrainJiaoluGUID in ' + strJiaoLuCondition,
      Ord(psBeginWork),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtNow)),
      '  strTrainJiaoluGUID in ' + strJiaoLuCondition]);
//    if SiteGUID <> '' then
//    begin
//      strSql := strSql + ' and strTrainJiaoluGUID in ' + strJiaoLuCondition;
//    end;

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

function TRsDBTrainPlanWork.GetChuQinPlan(ChuQinPlanGUID: string;
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

function TRsDBTrainPlanWork.GetTrainmanChuQinPlan(TrainmanGUID: string;
  out ChuQinPlan: RRsChuQinPlan;SiteGUID : string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_BeginWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' (nPlanState in (%d,%d)) and (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s or strTrainmanGUID4 = %s)';

  strSql := Format(strSql,[QuotedStr(SiteGUID) ,Ord(psPublish),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
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




function TRsDBTrainPlanWork.GetTrainmanChuQinPlanFromDrink(TrainmanGUID: string;
  out ChuQinPlan: RRsChuQinPlan; SiteGUID: string;
  DrinkTime: TDateTime): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
  ChuQinTime:TDateTime ;
  Hour,   Minute,   Second,   mSecond :Word;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_BeginWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' (nPlanState in (%d,%d)) and (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s or strTrainmanGUID4 = %s)';

  strSql := Format(strSql,[QuotedStr(SiteGUID) ,Ord(psPublish),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin

        ChuQinTime := FieldByName('dtStartTime').AsDateTime;
        //是否超过一天
        if  ChuQinTime - DrinkTime  >= 1  then
        begin
          Result := False ;
          Exit ;
        end;
        DecodeTime(ChuQinTime - DrinkTime,Hour,   Minute,   Second,   mSecond);
        //是否超过一个小时

        if Hour >= 1 then
        begin
          Result := False ;
          Exit ;
        end;
        //是否超过30分钟
        if Minute >120  then
        begin
          Result := False ;
          Exit ;
        end;


        ADOQueryToChuQinPlan(ADOQuery,ChuQinPlan,true);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlanWork.GetTrainmanDrinkInfo(strTrainmanGUID,
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
            + 'strTrainPlanGUID = %s and strTrainmanGUID = %s) ORDER BY dtCreateTime DESC';
        end;
      wtEndWork:
        begin
          strSQL := 'select * from TAB_Drink_Information where strWorkID = ( '
            + 'select top 1 strEndWorkGUID from TAB_Plan_EndWork where '
            + 'strTrainPlanGUID = %s and strTrainmanGUID = %s) ORDER BY dtCreateTime DESC';
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

procedure TRsDBTrainPlanWork.RemoveEndWorkRecord(strEndWorkGUID: string);
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

procedure TRsDBTrainPlanWork.TurnPlateOrder(TrainmanGUID : string;TrainmanPlan:RRsTrainmanPlan;
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


procedure TRsDBTrainPlanWork.UpdateEndWorkTestResult(strEndWorkGUID: string;
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

function TRsDBTrainPlanWork.GetTuiQinPlan(TuiQinPlanGUID: string;
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

procedure TRsDBTrainPlanWork.ImportBeginWork(Trainman: RRsTrainman;
  TrainmanPlan: RRsTrainmanPlan; Verify: TRsRegisterFlag; RsDrink: RRsDrink;
  DutyUserGUID, BeginWorkStationGUID: string; DTNow: TDateTime);
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
        SQL.Text := 'Update TAB_System_Lock set nLock = -nLock';
        ExecSQL;
        
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

        //增加记录时候不修改原先的时间
        strSql := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
            QuotedStr(Trainman.strTrainmanGUID)]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strBeginWorkGUID').AsString := beginWorkID;
          FieldByName('strTrainPlanGUID').AsString := TrainmanPlan.TrainPlan.strTrainPlanGUID;
          FieldByName('strTrainmanGUID').AsString := Trainman.strTrainmanGUID ;
          FieldByName('dtCreateTime').AsString := FormatDateTime('yyyy-MM-dd HH:nn:ss',dtnow);
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strStationGUID').AsString := BeginWorkStationGUID;
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end else begin
          Edit;
          beginWorkID := FieldByName('strBeginWorkGUID').AsString;
          FieldByName('nVerifyID').AsInteger := Ord(Verify);
          FieldByName('strRemark').AsString := RsDrink.strRemark;
        end;
        Post;
        


        {$REGION '修改测酒记录'}
        strSql :=  'update TAB_Drink_Information set ' +
        ' strWorkID=:strWorkID , strTrainmanGUID=:strTrainmanGUID , ' +
        ' strTrainNo=:strTrainNo , strTrainNumber=:strTrainNumber , strTrainTypeName=:strTrainTypeName, ' +
        ' nWorkTypeID=2 ' +
        ' where strGUID = ' + QuotedStr(RsDrink.strGUID) ;

        SQL.Text := strSql;
        Parameters.ParamByName( 'strTrainmanGUID').Value := Trainman.strTrainmanGUID;
        Parameters.ParamByName( 'strWorkID').Value := beginWorkID;
        Parameters.ParamByName( 'strTrainNo').Value := RsDrink.strTrainNo;
        Parameters.ParamByName( 'strTrainNumber').Value := RsDrink.strTrainNumber;
        Parameters.ParamByName( 'strTrainTypeName').Value := RsDrink.strTrainTypeName;
        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          Exception.Create('修改出勤测酒记录失败');
          exit;
        end;
        {$ENDREGION}


        {$region '修改计划状态,设置为已出勤'}
        strSql := 'update TAB_Plan_Train set nPlanState=%d where strTrainPlanGUID=%s and  ' +
        ' (select count(*) from VIEW_Plan_BeginWork where strTrainPlanGUID=TAB_Plan_Train.strTrainPlanGUID  and  ' +
        ' ((strTrainmanGUID1 is null) or (strTrainmanGUID1 = %s) or not(dtTestTime1 is null)) and ' +
          ' ((strTrainmanGUID2 is null) or (strTrainmanGUID2 = %s) or not(dtTestTime2 is null))  and ' +
          ' ((strTrainmanGUID3 is null) or (strTrainmanGUID3 = %s) or not(dtTestTime3 is null))   and ' +
          ' ((strTrainmanGUID4 is null) or (strTrainmanGUID4 = %s) or not(dtTestTime4 is null))) > 0';
        strSql := Format(strSql,[Ord(psBeginWork),
          QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID),
          QuotedStr(''),
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


          strSql := Format(strSql,[QuotedStr(Trainman.strTrainmanGUID)]);
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
                TurnPlateOrder(Trainman.strTrainmanGUID,TrainmanPlan,strTrainmanJiaoluGUID,
                  nRunType,BeginWorkStationGUID,RsDrink.dtCreateTime,true);
              end;
            end;
          end;
        
        end;
        {$endregion '修改计划状态,设置为已出勤'}


        {$REGION '修改实际出勤时间'}

        strSql := Format('update TAB_Plan_Train set dtBeginWorkTime=getdate() '   +
        'where strTrainPlanGUID = %s and dtBeginWorkTime is null ',[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL ;

        
        {$ENDREGION}

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

function TRsDBTrainPlanWork.GetTrainmanTuiQinPlan(TrainmanGUID: string;
  out TuiQinPlan : RRsTuiQinPlan;SiteGUID : string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_EndWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' nPlanState = %d AND (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s or strTrainmanGUID4 = %s) order by dtStartTime desc';

  strSql := Format(strSql,[QuotedStr(SiteGUID),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
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

function TRsDBTrainPlanWork.GetTrainmanTuiQinPlanFromDrink(TrainmanGUID: string;
  out TuiQinPlan: RRsTuiQinPlan; SiteGUID: string;
  DrinkTime: TDateTime): boolean;

var
  strSql : string;
  adoQuery : TADOQuery;
  dtStartTime:TDateTime ;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_EndWork ' +
    ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) and ' +
    ' nPlanState = %d AND (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s or strTrainmanGUID4 = %s) order by dtStartTime desc';

  strSql := Format(strSql,[QuotedStr(SiteGUID),Ord(psBeginWork),
    QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        dtStartTime := FieldByName('dtStartTime').AsDateTime;
        //测酒时间查过计划出勤时间3天
        if  DrinkTime - dtStartTime    >= 3  then
        begin
          Result := False ;
          Exit ;
        end;
        //测酒时间小于计划出勤时间
        if DrinkTime < dtStartTime    then
        begin
          result := False;
          Exit;
        end;

        ADOQueryToTuiQinPlan(ADOQuery,TuiQinPlan);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
