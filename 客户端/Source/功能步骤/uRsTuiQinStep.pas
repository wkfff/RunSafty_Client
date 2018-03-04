unit uRsTuiQinStep;

interface
uses
  Classes,SysUtils,uRsStepBase,uRsStepConfig,uGenericData,uTrainPlan,
  uTrainman,uSaftyEnum,uApparatusCommon,uDrink,uTFSystem,uRsConstFieldDefine,
  ZKFPEngXUtils,uTFMessageDefine,uRunSaftyMessageDefine,utfPopBox,StrUtils,
  uLCTrainPlan,uEndWork,uDutyPlace,uLCDutyPlace,
  uLCEndwork,uLCGoodsMgr,uLCDrink,uFrmTuiQinThird;
type
  {TRsTuiQinCheck 检查是否可以退勤}
  TRsTuiQinCheckStep = class(TRsStepBase)
  public
    constructor Create(Owner: TRsFunModule;ConfigNode: TRsStepConfigNode);override;
    destructor Destroy; override;
  private
    {web计划接口}
    m_webTrainPlan:TRsLCTrainPlan;
    m_LCEndwork: TLCEndwork;
    //获取当前人员的退勤计划信息
    function GetTrainmanEndWorkPlan(Param: TRsStepParam;out EndWorkPlan : RRsTuiQinPlan) : BOOLEAN;
  public
    {功能:执行功能步骤}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;override;
  end;

  {TRsTuiQinStep 退勤步骤}
  TRsTuiQinStep = class(TRsStepBase)
  public
    constructor Create(Owner: TRsFunModule;ConfigNode: TRsStepConfigNode);override;
    destructor Destroy; override;
  private
    {web接口_机车计划}
    m_webTrainPlan:TRsLCTrainPlan;
    {WEB接口_出勤点}
    m_webDutyPlace:TRsLCDutyPlace ;

    m_LCEndwork: TLCEndwork;
    //测酒照片上传对象
    m_RsDrinkImage: TRsDrinkImage;
    function PostDrinkImage(Trainman : RRsTrainman;AlcoholResult: RTestAlcoholInfo): string;
   

    //发送测酒信息
    procedure PostAlcoholMessage(Trainman : RRsTrainman;RsDrink : RRsDrink);

    procedure PostWorkEndMessage(Trainman : RRsTrainman;trainmanPlan : RRsTrainmanPlan;
      AlcoholResult: TTestAlcoholResult; dtEndWorkTime: TDateTime);
  public
    {功能:执行功能步骤}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;override;
  end;

  TRsICReturnStep = class(TRsStepBase)
  public
    constructor Create(Owner: TRsFunModule;ConfigNode: TRsStepConfigNode);override;
    destructor Destroy; override;
  private
    m_RsLCGoodsMgr: TRsLCGoodsMgr;
  public
    {功能:执行功能步骤}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;override;
  end;

  TRsShowTuiQinThirdStep = class(TRsStepBase)
  public
    constructor Create(Owner: TRsFunModule;ConfigNode: TRsStepConfigNode);override;
    destructor Destroy; override;
  private
    
  public
    {功能:执行功能步骤}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;override;  
  end;
  
  
implementation

uses uFrmTuiQin, ufrmHint,ufrmTestDrinking,
  Variants, uGlobalDM,uFrmTestDrinkSelect,uFrmSelectPlan,
  uFrmGoodsSend;

{ TRsTuiQinCheck }

constructor TRsTuiQinCheckStep.Create(Owner: TRsFunModule;
  ConfigNode: TRsStepConfigNode);
begin
  inherited Create(Owner,ConfigNode);
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID) ;
  m_LCEndwork := TLCEndwork.Create(GlobalDM.WebAPIUtils);
end;

destructor TRsTuiQinCheckStep.Destroy;
begin
  m_webTrainPlan.Free ;
  m_LCEndwork.Free;
  inherited;
end;

function TRsTuiQinCheckStep.Execute(Param: TRsStepParam;
  var Direction: TRsStepDirection): Boolean;
var
  tuiqinPlan: RRsTuiQinPlan;
  TrainmanPlan : RRsTrainmanPlan;
  post: TRsPost;
  strTemp : string;
begin
  Result := False;
  if not GetTrainmanEndWorkPlan(Param,tuiqinPlan) then
  begin
    Box(Format('没有找到%s的出勤记录！',[GetTrainmanText(Param.Trainman)]));
    exit;
  end;
  
  strTemp :=  tuiqinPlan.TrainPlan.strTrainPlanGUID ;

  
  m_LCEndwork.GetTuiQinPlan(strTemp,tuiqinPlan);
  
  TrainmanPlan.TrainPlan := tuiqinPlan.TrainPlan;
  TrainmanPlan.Group := tuiqinPlan.TuiQinGroup.Group;
  TrainmanPlan.dtBeginWorkTime := tuiqinPlan.dtBeginWorkTime;
  TrainmanPlan.Group.Trainman1.strTrainmanGUID := '';
  TrainmanPlan.Group.Trainman2.strTrainmanGUID := '';
  TrainmanPlan.Group.Trainman3.strTrainmanGUID := '';
  post := ptTrainman;
  if Param.Trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman1.strTrainmanGUID then
  begin
    TrainmanPlan.Group.Trainman1.strTrainmanGUID := Param.Trainman.strTrainmanGUID;
    post := ptTrainman;
    if tuiqinPlan.TuiQinGroup.TestAlcoholInfo1.dtTestTime > 0 then
    begin
      Box('该人员已经退过勤了!');
      exit;
    end;
  end;
  if Param.Trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman2.strTrainmanGUID then
  begin
    TrainmanPlan.Group.Trainman2.strTrainmanGUID := Param.Trainman.strTrainmanGUID;
    post := ptSubTrainman;
    if tuiqinPlan.TuiQinGroup.TestAlcoholInfo2.dtTestTime > 0 then
    begin
      Box('该人员已经退过勤了!');
      exit;
    end;
  end;
  if Param.Trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman3.strTrainmanGUID then
  begin
    TrainmanPlan.Group.Trainman3.strTrainmanGUID := Param.Trainman.strTrainmanGUID;
    post := ptLearning;
    if tuiqinPlan.TuiQinGroup.TestAlcoholInfo3.dtTestTime > 0 then
    begin
      Box('该人员已经退过勤了!');
      exit;
    end;
  end;

  Param.TrainmanPlan := TrainmanPlan;
  Param.IntField['RsPost'] := ord(post);
  Result := True;
  Direction := sdNextStep;
end;

function TRsTuiQinCheckStep.GetTrainmanEndWorkPlan(Param: TRsStepParam;
  out EndWorkPlan: RRsTuiQinPlan): BOOLEAN;
var
  strError:string;
begin
  result := false;
  if not m_webTrainPlan.GetTuiQinPlanByTrainman(Param.Trainman.strTrainmanGUID,EndWorkPlan,strError) then
  begin
    exit;
  end
  else
  begin
    if EndWorkPlan.TrainPlan.nPlanState <> psBeginWork then
    begin
      exit;
    end;
  end;
  result := true;
end;




{ TRsTuiQinStep }

constructor TRsTuiQinStep.Create(Owner: TRsFunModule;
  ConfigNode: TRsStepConfigNode);
begin
  inherited Create(Owner,ConfigNode);
  m_RsDrinkImage := TRsDrinkImage.Create('');
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_LCEndwork := TLCEndwork.Create(GlobalDM.WebAPIUtils);
end;

destructor TRsTuiQinStep.Destroy;
begin
  m_RsDrinkImage.Free;
  m_webTrainPlan.Free;
  m_webDutyPlace.Free;
  m_LCEndwork.Free;
  inherited;
end;

function TRsTuiQinStep.Execute(Param: TRsStepParam;
  var Direction: TRsStepDirection): Boolean;
var
  post: TRsPost;
  dtLastArriveTime : TDateTime;
  RDrink: RRsDrink;
  dtNow: TDateTime;
  strRemark: string;
  Verify: TRsRegisterFlag;
  endWork:RRsEndWork ;
  strError:string;
  dutyPlaceList:TRsDutyPlaceList;
begin
  Result := False;
  strRemark := '';
  post := TRsPost(Param.IntField['RsPost']);
  Verify := TRsRegisterFlag(Param.IntField['Verify']);
  if Param.AlcoholInfo.taTestAlcoholResult <> taNormal then
  begin
    if Param.AlcoholInfo.taTestAlcoholResult = taNoTest then
      GlobalDM.PlaySoundFile('请输入未测酒原因.wav');
    if not TfrmTuiQin.ShowTuiQinForm(Param.Trainman,Verify,
        Post,Param.AlcoholInfo,Param.TrainmanPlan,strRemark) then
        exit;
  end;

  if not m_webDutyPlace.GetDutyPlaceByClient(Param.TrainmanPlan.TrainPlan.strTrainJiaoluGUID,dutyPlaceList,strError) then
  begin
    BoxErr('获取出勤点错误'+strError);
    Exit ;
  end;
  

  
  try
    RDrink.strRemark := strRemark;
    dtNow := GlobalDM.GetNow;

    
    m_LCEndwork.GetLastArrvieTime(Param.TrainmanPlan.TrainPlan.strTrainPlanGUID,
        dtLastArriveTime);
    if dtLastArriveTime < 1 then
      dtLastArriveTime := dtNow;
    
    RDrink.AssignFromTestAlcoholInfo(Param.AlcoholInfo);

    ShowHint('正在上传测酒照片,请稍候……');

    RDrink.strPictureURL := PostDrinkImage(Param.Trainman,Param.AlcoholInfo);

    RDrink.dtCreateTime := dtNow;
    ShowHint('正在保存退勤记录……');


    with  endWork.endWorkInfo do
    begin

      endworkID := '';
      trainmanID := Param.Trainman.strTrainmanGUID;
      planID := Param.TrainmanPlan.TrainPlan.strTrainPlanGUID ;
      verifyID := IntToStr(ord(Verify));
      dutyUserID := GlobalDM.DutyUser.strDutyGUID ;
      stationID := GlobalDM.SiteInfo.strStationGUID ;
      placeID := dutyPlaceList[0].placeID ;
      arriveTime:= dtLastArriveTime;
      lastEndWorkTime := dtNow;
      remark := RDrink.strRemark ;

    end;

    with endWork.drinksInfo do
    begin
      trainmanID := Param.Trainman.strTrainmanGUID ;
      drinkResult := IntToStr(RDrink.nDrinkResult) ;
      workTypeID := IntToStr(DRINK_TEST_TUI_QIN);
      createTime := RDrink.dtCreateTime;
      imagePath  := RDrink.strPictureURL;


      //人员信息
      drink.strTrainmanName := Param.Trainman.strTrainmanName ;
      drink.strTrainmanNumber := Param.Trainman.strTrainmanNumber ;

      //车次信息
      drink.strTrainNo  := Param.TrainmanPlan.TrainPlan.strTrainNo ;
      drink.strTrainNumber := Param.TrainmanPlan.TrainPlan.strTrainNumber  ;
      drink.strTrainTypeName := Param.TrainmanPlan.TrainPlan.strTrainTypeName  ;

      //车间信息
      drink.strWorkShopGUID :=  Param.Trainman.strWorkShopGUID;
      drink.strWorkShopName := Param.Trainman.strWorkShopName ;
      //退勤点信息
      drink.strPlaceID := GlobalDM.DutyPlace.placeID ;
      drink.strPlaceName  := GlobalDM.DutyPlace.placeName;
      //site
      drink.strSiteGUID  := GlobalDM.SiteInfo.strSiteGUID;
      drink.strSiteName  := GlobalDM.SiteInfo.strSiteName ;
      drink.strSiteIp := GlobalDM.SiteInfo.strSiteIP ;
      //值班员
      drink.strAreaGUID := LeftStr(Param.Trainman.strTrainmanNumber,2);
      drink.strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
      drink.strDutyName := GlobalDM.DutyUser.strDutyName ;

      //酒精度
      drink.dwAlcoholicity := RDrink.dwAlcoholicity;
      drink.nWorkTypeID  :=  DRINK_TEST_TUI_QIN ;
      drink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Param.Trainman.strTrainmanNumber);
    end;

    endWork.dutyUserID := GlobalDM.DutyUser.strDutyGUID ;


    if not m_webTrainPlan.ExcuteTuiQin(endWork,strError) then
      raise Exception.Create(strError);


    //发送测酒信息
    //发送测酒信息
    RDrink.nVerifyID := ord(Verify) ;
    RDrink.nWorkTypeID := DRINK_TEST_TUI_QIN ;
    PostAlcoholMessage(Param.Trainman,RDrink);


    PostWorkEndMessage(Param.Trainman,Param.trainmanPlan,Param.AlcoholInfo.taTestAlcoholResult,dtNow);
    ShowHint('退勤数据保存完毕!');
    Result := True;
    Direction := sdNextStep;
    CloseHint();
  except on e : exception do
    begin
      CloseHint();
      BoxErr('退勤失败:' + e.Message);
    end;
  end;
end;

procedure TRsTuiQinStep.PostAlcoholMessage(Trainman: RRsTrainman;
  RsDrink: RRsDrink);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := TFM_TEST_ALCOHOL;
    TFMessage.StrField['tmid'] := Trainman.strTrainmanGUID;
    TFMessage.StrField['tmNumber'] := Trainman.strTrainmanNumber;
    TFMessage.StrField['tmName'] := Trainman.strTrainmanName;

    TFMessage.IntField['workTypeID'] := RsDrink.nWorkTypeID ; //GlobalDM.GetNow;

    TFMessage.dtField['etime'] := RsDrink.dtCreateTime;
    TFMessage.IntField['resultID'] := RsDrink.nDrinkResult;
    TFMessage.IntField['verifyID'] := RsDrink.nVerifyID;

    TFMessage.StrField['siteName'] := GlobalDM.SiteInfo.strSiteName;
    TFMessage.StrField['photoUrl'] := RsDrink.strPictureURL;

    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
  finally
    TFMessage.Free;
  end;
end;

function TRsTuiQinStep.PostDrinkImage(Trainman : RRsTrainman;
  AlcoholResult: RTestAlcoholInfo): string;
var
  strTrainmanNumber:string;
  Picture: TMemoryStream;
  nRetryCount: Integer;
  bSuccess: Boolean;
begin
    //测酒照片添加工号信息
  strTrainmanNumber := Trainman.strTrainmanNumber ;
  m_RsDrinkImage.URLHost := GlobalDM.WebHost + GlobalDM.WebDrinkImgPage;
  
  Picture := TMemoryStream.Create;
  try
    nRetryCount := 0;
    if VarIsEmpty(AlcoholResult.Picture) then
    begin
      Result := '';
      Exit;
    end;
    TemplateOleVariantToStream(AlcoholResult.Picture,Picture);

    bSuccess := False;
    while not bSuccess do
    begin
      try
        ShowHint('第' + IntToStr(nRetryCount + 1) + '次上传测酒照片,请稍候……');
        Result := m_RsDrinkImage.Post(strTrainmanNumber,Picture);
        bSuccess := True;
        if nRetryCount > 0 then
          GlobalDM.LogManage.InsertLog('测酒照片上传成功');
      except
        on E: Exception do
        begin
          GlobalDM.LogManage.InsertLog('测酒照片上传异常:' + E.Message);
          Inc(nRetryCount);
          Sleep(200);
          if nRetryCount >= 3 then
            raise Exception.Create(E.Message);
        end;
      end;

    end;

  finally
    Picture.Free;
  end;

end;

procedure TRsTuiQinStep.PostWorkEndMessage(Trainman: RRsTrainman;
  trainmanPlan: RRsTrainmanPlan; AlcoholResult: TTestAlcoholResult;
  dtEndWorkTime: TDateTime);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := TFM_WORK_END;
    TFMessage.StrField['tmGuid'] := Trainman.strTrainmanGUID;
    TFMessage.StrField['tmid'] := Trainman.strTrainmanNumber;
    TFMessage.StrField['tmname'] := Trainman.strTrainmanName;

    TFMessage.dtField['dttime'] := dtEndWorkTime; //GlobalDM.GetNow;

    TFMessage.StrField['planGuid'] := trainmanPlan.TrainPlan.strTrainPlanGUID;
    TFMessage.StrField['jiaoLuName'] := trainmanPlan.TrainPlan.strTrainJiaoluName;
    TFMessage.StrField['jiaoLuGUID'] := trainmanPlan.TrainPlan.strTrainJiaoluGUID; 

    TFMessage.IntField['cjjg'] := Ord(AlcoholResult);
    TFMessage.dtField['dtStartTime'] :=
        trainmanPlan.TrainPlan.dtStartTime;
    TFMessage.IntField['Tmis'] := GlobalDM.SiteInfo.Tmis;
    TFMessage.StrField['strTrainNo'] := trainmanPlan.TrainPlan.strTrainNo;

    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
  finally
    TFMessage.Free;
  end;

end;

{ TRsICReturnStep }

constructor TRsICReturnStep.Create(Owner: TRsFunModule;
  ConfigNode: TRsStepConfigNode);
begin
  inherited Create(Owner,ConfigNode);
  m_RsLCGoodsMgr := TRsLCGoodsMgr.Create(GlobalDM.WebAPIUtils);
end;

destructor TRsICReturnStep.Destroy;
begin
  m_RsLCGoodsMgr.Free;
  inherited;
end;

function TRsICReturnStep.Execute(Param: TRsStepParam;
  var Direction: TRsStepDirection): Boolean;
var
  Verify: TRsRegisterFlag;
begin
  Result := True;
  Direction := sdNextStep;
  ShowHint('正在检查IC卡发放记录,请稍候……');
  try
    Verify := TRsRegisterFlag(Param.IntField['Verify']);

    if m_RsLCGoodsMgr.IsHaveNotReturnGoods(Param.Trainman.strTrainmanGUID) then
    begin
      SendLendings(Param.Trainman,Verify);
    end;
  finally
    CloseHint;
  end;
end;


  { TRsShowTuiQinThirdStep }

constructor TRsShowTuiQinThirdStep.Create(Owner: TRsFunModule;
  ConfigNode: TRsStepConfigNode);
begin
  inherited;

end;

destructor TRsShowTuiQinThirdStep.Destroy;
begin

  inherited;
end;

function TRsShowTuiQinThirdStep.Execute(Param: TRsStepParam;
  var Direction: TRsStepDirection): Boolean;
begin
  TFrmTuiQinThird.ShowTuiQinThird(Param.TrainmanPlan.TrainPlan.strTrainPlanGUID);  
  result := true;
end;




initialization
  RegisterClass(TRsShowTuiQinThirdStep);
  RegisterClass(TRsTuiQinCheckStep);
  RegisterClass(TRsTuiQinStep);
  RegisterClass(TRsICReturnStep);
end.
