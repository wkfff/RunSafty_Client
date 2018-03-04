unit uExchangeSignInfo;

interface

uses
  DB,ADODB,uRoomSign,Windows,
  uTrainman,Variants,ZKFPEngXUtils,uSaftyEnum,SysUtils,Classes,uLeaderExam;


type


  //进度函数指针
  TShowProgressFunc = procedure (Index,Count : integer) of object;

  
  //功能:公寓信息下载/上传基类
  //类名: TBaseExchangeSignInfo
  // 为了消除下载和上传里面的重复函数
  TBaseExchangeSignInfo = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //停止程序
    procedure Stop();
  public
        //设置 服务器和本地连接
    procedure SetConnect(ServerCon,LocalCon:TADOConnection;
      ShowProgressFunc:TShowProgressFunc;ShowProgressFuncCur:TShowProgressFunc);
  protected
    //是否处于停止状态
    function CanStop():Boolean ;
      //人员信息
    procedure TrainmanToADOQuery(Trainman : RRsTrainman;ADOQuery : TADOQuery);
    procedure ADOQueryToTrainman(var Trainman:RRsTrainman;ADOQuery : TADOQuery);
    //入寓
    procedure SignInToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);
    procedure AdoToSignIn(RoomSign: TRsRoomSign;ADOQuery:TADOQuery);

    //离寓
    procedure SignOutToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);
    procedure AdoToSignOut(RoomSign: TRsRoomSign;ADOQuery:TADOQuery);

    //查岗登记
    procedure  AdoToLeaderInspect(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
    procedure  LeaderInspectToAdo(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
  protected
    //服务器CON,
    m_conServer : TADOConnection ;
    //本地数据CON
    m_conLocal : TADOConnection ;
    //总进度事件
    m_pProgressFunc : TShowProgressFunc;
    //当前进度事件
    m_pProgressFuncCur : TShowProgressFunc;
    //停止标志
    m_hStopFlag : THandle ;
  end;

implementation

{ TBaseExchangeSignInfo }

procedure TBaseExchangeSignInfo.ADOQueryToTrainman(var Trainman: RRsTrainman;
  ADOQuery: TADOQuery);
var
  StreamObject : TMemoryStream;
begin
  Trainman.strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
  Trainman.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  Trainman.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  //Trainman.nPostID := TRsPost(adoQuery.FieldByName('nPostID').asInteger);
  //trainman.nID := adoQuery.FieldByName('nID').asInteger;

  //Trainman.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
  //Trainman.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
{
  Trainman.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
 // Trainman.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
  Trainman.strTelNumber := adoQuery.FieldByName('strTelNumber').AsString;
  Trainman.strMobileNumber := adoQuery.FieldByName('strMobileNumber').AsString;
  Trainman.strAdddress := adoQuery.FieldByName('strAddress').AsString;
  Trainman.nDriverType := TRsDriverType(adoQuery.FieldByName('nDriverType').asInteger);
  Trainman.bIsKey := adoQuery.FieldByName('bIsKey').AsInteger;
  Trainman.dtRuZhiTime := adoQuery.FieldByName('dtRuZhiTime').AsDateTime;
  Trainman.dtJiuZhiTime := adoQuery.FieldByName('dtJiuZhiTime').AsDateTime;
  Trainman.nDriverLevel := adoQuery.FieldByName('nDriverLevel').AsInteger;
  Trainman.strABCD := adoQuery.FieldByName('strABCD').AsString;
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  if adoQuery.FieldByName('nKeHuoID').AsString = '' then
    Trainman.nKeHuoID := khNone
  else
    Trainman.nKeHuoID :=  TRsKehuo(adoQuery.FieldByName('nKeHuoID').AsInteger);
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  Trainman.strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
  Trainman.strTrainmanJiaoluGUID := adoQuery.FieldByName('strTrainmanJiaoluGUID').AsString;
//  Trainman.strTrainJiaoluName := adoQuery.FieldByName('strTrainJiaoluName').AsString;
  Trainman.dtLastEndworkTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;

  Trainman.dtCreateTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;
  Trainman.nTrainmanState := TRsTrainmanState(adoQuery.FieldByName('nTrainmanState').asInteger);
  trainman.nID := adoQuery.FieldByName('nID').asInteger;
  if ADOQuery.Fields.FindField('strJP') <> nil then
    trainman.strJP := adoQuery.FieldByName('strJP').AsString;
    }
  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;

    end;

    {读取指纹2}
    if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;

    {
    if True then
    begin
      if ADOQuery.FieldByName('Picture').IsNull = False then
      begin
        (ADOQuery.FieldByName('Picture') As TBlobField).SaveToStream(StreamObject);
        Trainman.Picture := StreamToTemplateOleVariant(StreamObject);
        StreamObject.Clear;
      end;
    end;
    }
  finally
    StreamObject.Free;
  end;
end;

procedure TBaseExchangeSignInfo.AdoToLeaderInspect(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    LeaderInspect.GUID := FieldByName('strGUID').AsString;
    LeaderInspect.LeaderGUID := FieldByName('strLeaderGUID').AsString;
    LeaderInspect.AreaGUID := FieldByName('strAreaGUID').AsString;
    LeaderInspect.VerifyID := FieldByName('nVerifyID').AsInteger;
    LeaderInspect.CreateTime := FieldByName('dtCreateTime').AsDateTime;
    LeaderInspect.DutyGUID := FieldByName('strDutyGUID').AsString;
    LeaderInspect.strContext  := FieldByName('strContext').AsString;
  end;
end;

procedure TBaseExchangeSignInfo.AdoToSignIn(RoomSign: TRsRoomSign;
  ADOQuery: TADOQuery);
begin
  with RoomSign do
  begin
    strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
    strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
    strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
    strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
    strSiteGUID := ADOQuery.FieldByName('strSiteGUID').AsString;
    strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
    dtInRoomTime := ADOQuery.FieldByName('dtInRoomTime').AsDateTime;
    nInRoomVerifyID := ADOQuery.FieldByName('nInRoomVerifyID').AsInteger;
    strRoomNumber :=  ADOQuery.FieldByName('strRoomNumber').AsString;
    nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger;
  end;
end;

procedure TBaseExchangeSignInfo.AdoToSignOut(RoomSign: TRsRoomSign;
  ADOQuery: TADOQuery);
begin
  with RoomSign do
  begin
    strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
    strOutRoomGUID := ADOQuery.FieldByName('strOutRoomGUID').AsString;
    strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
    strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
    strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
    strSiteGUID := ADOQuery.FieldByName('strSiteGUID').AsString ;
    strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
    dtOutRoomTime := ADOQuery.FieldByName('dtOutRoomTime').AsDateTime;
    nOutRoomVerifyID := ADOQuery.FieldByName('nOutRoomVerifyID').AsInteger;
  end; 
end;

function TBaseExchangeSignInfo.CanStop: Boolean;
begin
  Result := False ;
  if WAIT_OBJECT_0 = WaitForSingleObject(m_hStopFlag,100) then
    Result := True ;
end;

constructor TBaseExchangeSignInfo.Create;
begin
  m_hStopFlag := CreateEvent(nil,False,False,nil);
end;

destructor TBaseExchangeSignInfo.Destroy;
begin
  SetEvent(m_hStopFlag);
  WaitForSingleObject(m_hStopFlag,1000);
  CloseHandle(m_hStopFlag);
  m_hStopFlag := 0 ;
  inherited;
end;

procedure TBaseExchangeSignInfo.LeaderInspectToAdo(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    FieldByName('strGUID').AsString := LeaderInspect.GUID;
    FieldByName('strLeaderGUID').AsString := LeaderInspect.LeaderGUID;
    FieldByName('strAreaGUID').AsString := LeaderInspect.AreaGUID;
    FieldByName('nVerifyID').AsInteger := LeaderInspect.VerifyID;
    FieldByName('dtCreateTime').AsDateTime := LeaderInspect.CreateTime;
    FieldByName('strDutyGUID').AsString := LeaderInspect.DutyGUID;
    FieldByName('strContext').AsString := LeaderInspect.strContext;
  end; 
end;

procedure TBaseExchangeSignInfo.SetConnect(ServerCon, LocalCon: TADOConnection;
  ShowProgressFunc: TShowProgressFunc;ShowProgressFuncCur:TShowProgressFunc);
begin
  m_conServer := ServerCon ;
  m_conLocal := LocalCon ;
  m_pProgressFunc := ShowProgressFunc ;
  m_pProgressFuncCur := ShowProgressFuncCur ;
end;

procedure TBaseExchangeSignInfo.SignInToAdo(ADOQuery: TADOQuery;
  RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strInRoomGUID').AsString := RoomSign.strInRoomGUID;
    FieldByName('strTrainPlanGUID').AsString := RoomSign.strTrainPlanGUID;
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtInRoomTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('nInRoomVerifyID').AsInteger := RoomSign.nInRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    //FieldByName('dtCreateTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('strRoomNumber').AsString := RoomSign.strRoomNumber;
    FieldByName('nBedNumber').AsInteger := RoomSign.nBedNumber;
  end;
end;

procedure TBaseExchangeSignInfo.SignOutToAdo(ADOQuery: TADOQuery;
  RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strOutRoomGUID').AsString := RoomSign.strOutRoomGUID ;
    FieldByName('strTrainPlanGUID').AsString := RoomSign.strTrainPlanGUID;
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtOutRoomTime').AsDateTime := RoomSign.dtOutRoomTime;
    FieldByName('nOutRoomVerifyID').AsInteger := RoomSign.nOutRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    FieldByName('dtCreateTime').AsDateTime := RoomSign.dtOutRoomTime;
    FieldByName('strInRoomGUID').AsString := RoomSign.strInRoomGUID;
  end;
end;

procedure TBaseExchangeSignInfo.Stop;
begin
  SetEvent(m_hStopFlag);
end;

procedure TBaseExchangeSignInfo.TrainmanToADOQuery(Trainman: RRsTrainman;
  ADOQuery: TADOQuery);
var
  StreamObject : TMemoryStream;
begin
  //adoQuery.FieldByName('ntrainmanid').asInteger := trainman.nID ;
  adoQuery.FieldByName('strGUID').AsString := Trainman.strTrainmanGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := Trainman.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := Trainman.strTrainmanName;
  {
  adoQuery.FieldByName('strWorkShopName').AsString := Trainman.strWorkShopName;

  adoQuery.FieldByName('nPostID').asInteger := Ord(Trainman.nPostID);
  adoQuery.FieldByName('strWorkShopGUID').AsString := Trainman.strWorkShopGUID;
  adoQuery.FieldByName('strGuideGroupGUID').AsString := Trainman.strGuideGroupGUID;
  adoQuery.FieldByName('strTelNumber').AsString := Trainman.strTelNumber;
  adoQuery.FieldByName('strMobileNumber').AsString := Trainman.strMobileNumber;
  adoQuery.FieldByName('strAddress').AsString := Trainman.strAdddress;
  adoQuery.FieldByName('nDriverType').asInteger := Ord(Trainman.nDriverType);
  adoQuery.FieldByName('bIsKey').AsInteger := Trainman.bIsKey;
  adoQuery.FieldByName('dtRuZhiTime').AsDateTime := Trainman.dtRuZhiTime;
  adoQuery.FieldByName('dtJiuZhiTime').AsDateTime := Trainman.dtJiuZhiTime;
  adoQuery.FieldByName('nDriverLevel').AsInteger := Trainman.nDriverLevel;
  adoQuery.FieldByName('strABCD').AsString := Trainman.strABCD;
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('nKeHuoID').AsInteger := Ord(Trainman.nKeHuoID);
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('strTrainJiaoluGUID').AsString := Trainman.strTrainJiaoluGUID;
  ADOQuery.FieldByName('strTrainmanJiaoluGUID').AsString :=  Trainman.strTrainmanJiaoluGUID;
  adoQuery.FieldByName('dtLastEndworkTime').AsDateTime := Trainman.dtLastEndworkTime;

  adoQuery.FieldByName('dtLastEndworkTime').AsDateTime := Trainman.dtCreateTime;
  adoQuery.FieldByName('nTrainmanState').asInteger := Ord(Trainman.nTrainmanState);
  adoQuery.FieldByName('strJP').AsString := Trainman.strJP;
  }
  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if not (VarIsNull(Trainman.FingerPrint1)  or VarIsEmpty(Trainman.FingerPrint1)) then
    begin
      TemplateOleVariantToStream(Trainman.FingerPrint1,StreamObject);
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).LoadFromStream(StreamObject);
      StreamObject.Clear;
    end;

    {读取指纹2}
    if not (VarIsNull(Trainman.FingerPrint2)  or VarIsEmpty(Trainman.FingerPrint2)) then
      begin
      TemplateOleVariantToStream(Trainman.FingerPrint2,StreamObject);
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).LoadFromStream(StreamObject);

      StreamObject.Clear;
    end;

    {
    if True then
    begin

      if not (VarIsNull(Trainman.Picture)  or VarIsEmpty(Trainman.Picture)) then
      begin
         TemplateOleVariantToStream(Trainman.Picture,StreamObject);
        (ADOQuery.FieldByName('Picture') As TBlobField).LoadFromStream(StreamObject);
        StreamObject.Clear;
      end;
    end;
    }
  finally
    StreamObject.Free;
  end;
end;

end.
