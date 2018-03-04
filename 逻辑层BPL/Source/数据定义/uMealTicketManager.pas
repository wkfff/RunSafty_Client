unit uMealTicketManager;

interface

uses
  SysUtils,DateUtils,SqlExpr,DB,ADODB,utfsystem,uMealTicket,uTrainman,uTrainmanJiaolu,uTrainPlan,uDBMealTicket,uMealTicketRule,uDBMealTicketRule;

type
    {饭票管理中心操作类
    根据交路类型和用餐类型获取饭票}
  TMealTicketManager = class
  public
    constructor Create(ConnectionTicket:TSQLConnection;ConnectionLocal:TADOConnection;WorkShopGUID:string);
    destructor Destroy();override;
  public
    {司机，发放人，人员交路，行车计划}
    function  GiveMealTicket(TrainmanNumber:string;TrainmanName:string;ShenHeNumber:string;
      TrainmanJiaoLu:RRsTrainmanJiaolu;TrainPlan:RRsTrainPlan;out MealTicket:RRsMealTicket):Boolean;overload;
    //按给定人员饭票数目发放饭票
    function  GiveMealTicket(TrainmanNumber:string;TrainmanName:string;ShenHeNumber:string;iA,iB:Integer;CheCi:string;
      PaiBanTime:TDateTime;out Error:string):Boolean;overload;
    //删饭票
    procedure DeleteMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan);
    //修改饭票
    function ModifyMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan;CanQuanA,CanQuanB,CanQuanC:Integer):Boolean;
    //是否应领过饭票
    function  IsGivedTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan;var CanQuanA,CanQuanB,CanQuanC:Integer):Boolean;
  private
    //根据下面的步骤信息填充一个完成的信息
    procedure GetMealTicket();
    //发饭票
    function WriteMealTicket(MealTicket:RRsMealTicket):Boolean;
  private
    // 1 根据时间和车次组成本次的GUID
    function  GetPaiBanStr(StartWork:TDateTime;CheCi:string):string;
    // 2 获取司机信息
    procedure  GetDriverInfo();
    //3  填充出勤时间(年月日)
    procedure GetChuQinInfo();
    //4 根据交路类型和时间获取饭票数目
    procedure  GetTicketInfo();
    //5 获取发放人员信息
    procedure GetShenHeInfo();
    //6 获取餐券GUID
    procedure GetGUID();
  private
    //是否是东线
    function  IsEastLine(TrainmanJiaoLu:RRsTrainmanJiaolu):Boolean;
    //获取用餐的类型 {早餐，午餐，晚餐}
    function  GetMealType(DateTime:TDateTime):TRsMealType;
  private
    m_strWorkShopGUID:string;                   //车间GUID
    m_dbMealTicketRule:TRsDBMealTicketRule;     //饭票规则
    m_dbLogMealTicket:TRsDBLogMealTicket;       //饭票发放记录
    m_MealTicket:RRsMealTicket ;              //餐券信息
    m_dbMealTicket:TRsDBMealTicket;           //饭票数据库操作
    m_dtPaiBanTime:TDateTime;                  //派班时间
    m_strTrainmanNumber:string;                  //司机工号
    m_strTrainmanName:string;                   //司机名字
    m_strShenHeNumber:string;                    //发放人
    m_strCheCi:string;                           //车次
    m_TrainmanJiaoLu:RRsTrainmanJiaolu  ;     //交路信息
    m_nJiaoluType:TRsJiaoluType;            //人员交路类型
    m_strQuDuan:string;                     //行车区段
  end;

implementation




{ TMealTicketManager }

procedure TMealTicketManager.DeleteMealTicket(TrainmanNumber:string;TrainmanPlan:RRsTrainmanPlan);
var
  strPaiBan:string;
begin
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  m_dbMealTicket.Delete(strPaiBan,TrainmanNumber);
end;

destructor TMealTicketManager.Destroy;
begin
    //饭票释放
  m_dbMealTicket.Free;
  m_dbLogMealTicket.Free;
  m_dbMealTicketRule.Free;
  inherited;
end;

procedure TMealTicketManager.GetMealTicket;
begin
  GetGUID;
  GetDriverInfo;
  GetChuQinInfo();
  GetTicketInfo;
  GetShenHeInfo;
end;

procedure TMealTicketManager.GetGUID;
begin
  m_MealTicket.PAIBAN_STR := GetPaiBanStr(m_dtPaiBanTime,m_strCheCi );
end;

procedure TMealTicketManager.GetChuQinInfo();
var
  strDriverName:string;
  strCheJian:string;
begin
  m_dbMealTicket.GetDriverInfo(m_strTrainmanNumber,strDriverName,strCheJian);

  m_MealTicket.PAIBAN_CHECI := m_strCheCi ;
  m_MealTicket.CHUQIN_TIME :=  FormatDateTime('yyyy-mm:dd HH:MM:SS',m_dtPaiBanTime);
  m_MealTicket.CHUQIN_YEAR := YearOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_MONTH := MonthOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_DAY := DayOf(m_dtPaiBanTime);
  m_MealTicket.CHUQIN_YMD := StrToInt(FormatDateTime('yyyymmdd',m_dtPaiBanTime));
  m_MealTicket.CHUQIN_DEPART := strCheJian;
end;

procedure TMealTicketManager.GetDriverInfo;
var
  strDriverName:string;
  strCheJian:string;
begin
  if m_dbMealTicket.GetDriverInfo(m_strTrainmanNumber,strDriverName,strCheJian)then
  begin
    m_MealTicket.DRIVER_CODE := m_strTrainmanNumber ;
    m_MealTicket.DRIVER_NAME := strDriverName ;
    m_MealTicket.CHEJIAN_NAME := strCheJian ;
  end
  else
  begin
    m_MealTicket.DRIVER_CODE := m_strTrainmanNumber ;
    m_MealTicket.DRIVER_NAME := m_strTrainmanName ;
    m_MealTicket.CHEJIAN_NAME := '唐山运用' ;
  end;
end;

procedure TMealTicketManager.GetShenHeInfo;
var
  strName:string;
begin
  //获取发放人名字
  m_dbMealTicket.GetAdminInfo(m_strShenHeNumber,strName);

  m_MealTicket.SHENHEREN_CODE := m_strShenHeNumber ;
  m_MealTicket.SHENHEREN_NAME := strName ;
  m_MealTicket.CHECK_FLAG := 1 ;

  m_MealTicket.REC_TIME :=  FormatDateTime('yyyy-mm:dd HH:MM:SS',Now) ;
end;

function TMealTicketManager.GetMealType(DateTime: TDateTime): TRsMealType;
var
  wHour:Word;
begin
  Result := mtLunch ;
  wHour := HourOf(DateTime);
  if ( wHour >= BREAKFAST_MIN_HOUR ) and ( wHour < BREAKFAST_MAX_HOUR ) then
    Result := mtBreakFast ;
  {
  else if ( wHour >= LUNCH_MIN_HOUR ) and ( wHour <= LUNCH_MAX_HOUR ) then
    Result := mtLunch ;
  else if ( wHour >= DINNER_MIN_HOUR ) and ( wHour <= DINNER_MAX_HOUR ) then
    Result := mtDinner
  else
    Result := mtOther ;
  }
end;

function TMealTicketManager.WriteMealTicket(MealTicket: RRsMealTicket):Boolean;
begin
  Result := m_dbMealTicket.Insert(m_MealTicket);
end;

constructor TMealTicketManager.Create(ConnectionTicket:TSQLConnection;ConnectionLocal:TADOConnection;WorkShopGUID:string);
begin
  inherited Create();
  m_dbMealTicket := TRsDBMealTicket.Create(ConnectionTicket);
  m_dbLogMealTicket := TRsDBLogMealTicket.Create(ConnectionLocal);
  m_dbMealTicketRule := TRsDBMealTicketRule.Create(ConnectionLocal);
  m_strWorkShopGUID := WorkShopGUID ;
end;

function TMealTicketManager.GiveMealTicket(TrainmanNumber,TrainmanName,
  ShenHeNumber: string; TrainmanJiaoLu: RRsTrainmanJiaolu;
  TrainPlan:RRsTrainPlan;out MealTicket:RRsMealTicket): Boolean;
var
  nHour : Integer ;
  dtGive:TDateTime;
begin
  Result := False ;
  dtGive := 0 ;
  m_strTrainmanNumber := TrainmanNumber ;
  m_strTrainmanName := TrainmanName ;
  m_strShenHeNumber := ShenHeNumber ;
  m_strCheCi := TrainPlan.strTrainNo ;
  m_TrainmanJiaoLu := TrainmanJiaoLu ;
  m_dtPaiBanTime := TrainPlan.dtStartTime ;
  m_strQuDuan := TrainPlan.strTrainJiaoluName ;

  GetMealTicket();

  //发放饭票的时间间隔
  if m_dbMealTicket.GetCanQuanLastTime(TrainmanNumber,dtGive) then
  begin
    nHour := HoursBetween(m_dtPaiBanTime , dtGive);
    if nHour < 24 then
      Exit;
  end;

  if not WriteMealTicket(m_MealTicket)  then
    Exit;
  MealTicket := m_MealTicket ;
  Result := True ;
end;

function TMealTicketManager.GetPaiBanStr(StartWork:TDateTime;CheCi:string): string;
var
  strTime:string;
begin
  Result := '' ;
  strTime := FormatDateTime('yyyymmddHHMMSS',StartWork);
  Result := Format('%s%s',[strTime,CheCi]);
end;

procedure TMealTicketManager.GetTicketInfo();
var
  iA,iB:Integer;
  operMealTicket : TMealTicketOperate ;
  MealType:TRsMealType;
  bIsEast : Boolean ;
  personInfo:RRsMealTicketPersonInfo;
begin
  iA := 0 ;
  iB := 0 ;

  personInfo.strWorkShopGUID := m_strWorkShopGUID;
  personInfo.strTrainmanNumber := m_strTrainmanNumber ;
  personInfo.dtPaiBan := TimeOf(m_dtPaiBanTime) ;
  personInfo.strQuDuan := m_strQuDuan;
  personInfo.strCheCi := m_strCheCi;
  //如果有策略 则执行策略里面的内容
  if m_dbMealTicketRule.GetTicket(personInfo,iA,iB) then
  begin
    m_MealTicket.CANQUAN_A := iA ;
    m_MealTicket.CANQUAN_B := iB ;
    m_MealTicket.CANQUAN_C := 0 ;
    Exit ;
  end  ;

  bIsEast := False ;
  //获取交路类型
  case m_TrainmanJiaoLu.nJiaoluType of
  jltNamed :
    begin
      operMealTicket := TKeCheMealTicketOperate.Create;
    end;
  jltOrder :
    begin
      if bIsEast then
        operMealTicket := TEastHuoCheMealTicketOperate.Create
      else
        operMealTicket := TWeastHuoCheMealTicketOperate.Create;
    end;
  jltTogether :
    begin
      operMealTicket := TDiaoCheMealTicketOperate.Create;
    end;
  else
    Exit;
  end;




  try
    //获取用餐类型
    MealType := GetMealType(m_dtPaiBanTime) ;
      //获取票数
    operMealTicket.GetTicket(MealType,m_MealTicket);
  finally
    operMealTicket.Free;
  end;
end;

function TMealTicketManager.GiveMealTicket(TrainmanNumber, TrainmanName,
  ShenHeNumber: string; iA, iB: Integer; CheCi: string;
  PaiBanTime: TDateTime;out Error:string): Boolean;
var
  nHour : Integer ;
  dtGive:TDateTime;
begin
  Result := False ;
  dtGive := 0 ;
  m_strTrainmanNumber := TrainmanNumber ;
  m_strTrainmanName := TrainmanName ;
  m_strShenHeNumber := ShenHeNumber ;
  m_dtPaiBanTime := PaiBanTime ;
  m_strCheCi := CheCi ;

  GetGUID;
  GetDriverInfo;
  GetChuQinInfo;
  m_MealTicket.CANQUAN_A := iA ;
  m_MealTicket.CANQUAN_B := iB ;
  GetShenHeInfo;


  //发放饭票的时间间隔
  if m_dbMealTicket.GetCanQuanLastTime(TrainmanNumber,dtGive) then
  begin
    nHour := HoursBetween(m_dtPaiBanTime , dtGive);
    if nHour < 24 then
    begin
      Error := '已经在24小时之内领取过饭票';
      Exit;
    end;
  end;

  if not WriteMealTicket(m_MealTicket)  then
  begin
    Error := '发放饭票失败';
    Exit;
  end;

  m_dbLogMealTicket.Log(m_MealTicket);

  Result := True ;
end;

function TMealTicketManager.IsEastLine(
  TrainmanJiaoLu: RRsTrainmanJiaolu): Boolean;
begin
  Result := False ;
  if TrainmanJiaoLu.strTrainmanJiaoluName = '唐山东－山海关（货）' then
    Result := True
  else
    Result := False ;
end;

function TMealTicketManager.IsGivedTicket(TrainmanNumber: string;
  TrainmanPlan: RRsTrainmanPlan;var CanQuanA,CanQuanB,CanQuanC:Integer): Boolean;
var
  strPaiBan:string;
begin
  Result := False ;
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  Result := m_dbMealTicket.IsGivedTicket(strPaiBan,TrainmanNumber,CanQuanA,CanQuanB,CanQuanC)
end;

function TMealTicketManager.ModifyMealTicket(TrainmanNumber: string;
  TrainmanPlan: RRsTrainmanPlan; CanQuanA, CanQuanB, CanQuanC: Integer):Boolean;
var
  strPaiBan:string;
begin
  Result := False ;
  strPaiBan := GetPaiBanStr(TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.strTrainNo) ;
  Result := m_dbMealTicket.Update(strPaiBan,TrainmanNumber,CanQuanA, CanQuanB, CanQuanC);
end;

end.
