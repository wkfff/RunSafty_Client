unit uLCNameBoardEx;

interface
uses
  Classes,SysUtils, uTrainmanJiaolu,uSaftyEnum,
  uTrainman, uTrainPlan,uHttpWebAPI,uJsonSerialize,superobject,
  uLCTrainmanMgr,uLCTrainPlan,uTuiQinTime;
type
  {$region '输入实体定义'}

  RNameBoardCondition = record
    strTrainmanNumber: string;
    strTrainmanName: string;
    strJP: string;
    strTrainmanJiaoluGUID: string;
  public
    procedure Init();
    function ToSQL: string;
  end;
  
  TRSLBoardChangeType = (btNone=0,btcAddTrainman{添加人员},btcDeleteTrainman{删除人员},
    btcExchangeTrainman{交换人员},btcAddGroup{添加机组},btcDeleteGroup{删除机组},
    bctExchangeGroup{交换机组},btcChangeGroupOrder{修改机组的顺序},
    btcChangeJiaoLu{更改交路},btcClearArriveTime{清除最后到达时间},btcChangeArriveTime{修改最后到达时间});
  //变动日志
  RRsChangeLog = record
    //日志GUID
    strLogGUID : string;
    //人员交路GUID
    strTrainmanJiaoluGUID : string;
    //人员交路名称
    strTrainmanJiaoluName : string;
    //变动类型
    nBoardChangeType : TRSLBoardChangeType;
    //变动内容
    strContent : string;
    //值班员GUID
    strDutyUserGUID : string;
    //值班员工号
    strDutyUserNumber : string;
    //值班员名称
    strDutyUserName : string;
    //变动时间
    dtEventTime : TDatetime;
    //自增id
    nid : integer;
  end;
  TRsChangeLogArray = array of RRsChangeLog;
  
  //输入的人员交路参数
  TRsLCBoardInputJL = class(TPersistent)
  private
    m_jiaoluID: string;
    m_jiaoluName: string;
    m_jiaoluType: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure SetTrainmanJL(JiaoLu: RRsTrainmanJiaolu);
  published
    property jiaoluID: string read m_jiaoluID write m_jiaoluID;
    property jiaoluName: string read m_jiaoluName write m_jiaoluName;
    property jiaoluType: integer read m_jiaoluType write m_jiaoluType;
  end;



  //输入的值班员信息
  TRsLCBoardInputDuty = class(TPersistent)
  private
    m_strDutyGUID: string;
    m_strDutyNumber: string;
    m_strDutyName: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  published
    property strDutyGUID: string read m_strDutyGUID write m_strDutyGUID;
    property strDutyNumber: string read m_strDutyNumber write m_strDutyNumber;
    property strDutyName: string read m_strDutyName write m_strDutyName;
  end;            

  //记名式机组输入参数
  TRsLCNamedGrpInputParam = class(TPersistent)
  public
    constructor Create;
    destructor Destroy;override;
  private
    //所属人员交路信息
    m_TrainmanJiaolu: TRsLCBoardInputJL;
    //值班员信息
    m_DutyUser: TRsLCBoardInputDuty;
    //记名式机组的GUID
    m_CheciGUID: string;
    //序号
    m_CheciOrder: integer;
    //车次类型(0,1)
    m_CheciType: integer;
    //往路车次
    m_Checi1: string;
    //回路车次
    m_Checi2: string;
    //乘务员1工号                          
    m_TrainmanNumber1: string;
    //乘务员2工号
    m_TrainmanNumber2: string;
    //乘务员3工号
    m_TrainmanNumber3: string;
    //乘务员4工号
    m_TrainmanNumber4: string;
  published
    property TrainmanJiaolu: TRsLCBoardInputJL read m_TrainmanJiaolu write m_TrainmanJiaolu;
    property DutyUser: TRsLCBoardInputDuty read m_DutyUser write m_DutyUser;
    property CheciGUID: string read m_CheciGUID write m_CheciGUID;
    property CheciOrder: integer read m_CheciOrder write m_CheciOrder;
    property CheciType: integer read m_CheciType write m_CheciType;
    property Checi1: string read m_Checi1 write m_Checi1;
    property Checi2: string read m_Checi2 write m_Checi2;
    property TrainmanNumber1: string read m_TrainmanNumber1 write m_TrainmanNumber1;
    property TrainmanNumber2: string read m_TrainmanNumber2 write m_TrainmanNumber2;
    property TrainmanNumber3: string read m_TrainmanNumber3 write m_TrainmanNumber3;
    property TrainmanNumber4: string read m_TrainmanNumber4 write m_TrainmanNumber4;
  end;


  //轮乘机组输入参数
  TRsLCOrderGrpInputParam = class(TPersistent)
  public
    constructor Create;
    destructor Destroy;override;
  private
    //所属人员交路信息
    m_TrainmanJiaolu: TRsLCBoardInputJL;
    //值班员信息
    m_DutyUser: TRsLCBoardInputDuty;
    //轮乘机组的GUID
    m_OrderGUID: string;
    //机组最近到达时间
    m_LastArriveTime: TDateTime;
    //所在出勤点编号
    m_PlaceID: string;    
    //乘务员1工号
    m_TrainmanNumber1: string;
    //乘务员2工号
    m_TrainmanNumber2: string;
    //乘务员3工号
    m_TrainmanNumber3: string;
    //乘务员4工号
    m_TrainmanNumber4: string;
  published
    property TrainmanJiaolu: TRsLCBoardInputJL read m_TrainmanJiaolu write m_TrainmanJiaolu;
    property DutyUser: TRsLCBoardInputDuty read m_DutyUser write m_DutyUser;
    property OrderGUID: string read m_OrderGUID write m_OrderGUID;
    property LastArriveTime: TDateTime read m_LastArriveTime write m_LastArriveTime;
    property PlaceID: string read m_PlaceID write m_PlaceID;
    property TrainmanNumber1: string read m_TrainmanNumber1 write m_TrainmanNumber1;
    property TrainmanNumber2: string read m_TrainmanNumber2 write m_TrainmanNumber2;
    property TrainmanNumber3: string read m_TrainmanNumber3 write m_TrainmanNumber3;
    property TrainmanNumber4: string read m_TrainmanNumber4 write m_TrainmanNumber4;
  end;


  //包乘机组输入参数
  TRsLCTogetherGrpInputParam = class(TPersistent)
  public
    constructor Create;
    destructor Destroy;override;
  private
    //所属人员交路信息
    m_TrainmanJiaolu: TRsLCBoardInputJL;
    //值班员信息
    m_DutyUser: TRsLCBoardInputDuty;
    //轮乘机组的GUID
    m_OrderGUID: string;
    //机组序号
    m_Order: integer;
    //所属机车GUID
    m_TrainGUID: string;
    //乘务员1工号
    m_TrainmanNumber1: string;
    //乘务员2工号
    m_TrainmanNumber2: string;
    //乘务员3工号
    m_TrainmanNumber3: string;
    //乘务员4工号
    m_TrainmanNumber4: string;
  published
    property TrainmanJiaolu: TRsLCBoardInputJL read m_TrainmanJiaolu write m_TrainmanJiaolu;
    property DutyUser: TRsLCBoardInputDuty read m_DutyUser write m_DutyUser;
    property OrderGUID: string read m_OrderGUID write m_OrderGUID;
    property Order: integer read m_Order write m_Order;
    property TrainGUID: string read m_TrainGUID write m_TrainGUID;
    property TrainmanNumber1: string read m_TrainmanNumber1 write m_TrainmanNumber1;
    property TrainmanNumber2: string read m_TrainmanNumber2 write m_TrainmanNumber2;
    property TrainmanNumber3: string read m_TrainmanNumber3 write m_TrainmanNumber3;
    property TrainmanNumber4: string read m_TrainmanNumber4 write m_TrainmanNumber4;
  end; 


  //添加人员全入参数
  TRsLCTrainmanAddInput = class(TPersistent)
  public
    constructor Create;
    destructor Destroy;override;
  private
    //所属人员交路信息
    m_TrainmanJiaolu: TRsLCBoardInputJL;
    //值班员信息
    m_DutyUser: TRsLCBoardInputDuty;
    //待添加的人员工号
    m_TrainmanNumber: string;
    //添加的位置(1,2,3,4)
    m_TrainmanIndex: integer;
    //所在机组
    m_GroupGUID: string;    
  published
    property TrainmanJiaolu: TRsLCBoardInputJL read m_TrainmanJiaolu write m_TrainmanJiaolu;
    property DutyUser: TRsLCBoardInputDuty read m_DutyUser write m_DutyUser;
    property TrainmanNumber: string read m_TrainmanNumber write m_TrainmanNumber;
    property TrainmanIndex: integer read m_TrainmanIndex write m_TrainmanIndex;
    property GroupGUID: string read m_GroupGUID write m_GroupGUID;
  end;



  
  //人员名牌查找结果  
  TRsLCBoardTmFindRet = class(TPersistent)
  private
    //是否找到(0未找到,1找到)
    m_IsFind: integer;
    //所在人员交路
    m_strTrainmanJiaoluGUID: string;
    //人员状态
    m_nTrainmanState: integer;
    //所在出勤点
    m_strPlaceID: string;
    //所在人员交路名称
    m_strTrainmanJiaoluName: string;
    //所在出勤点名称
    m_strPlaceName: string;
    //人员状态名称
    m_strTrainmanStateName: string;
    //所属机组名称
    m_strGroupGUID: string;
    //所在机组位置(1,2,3,4)
    m_nTrainmanIndex: integer;
  published
    property IsFind: integer read m_IsFind write m_IsFind;
    property strTrainmanJiaoluGUID: string read m_strTrainmanJiaoluGUID write m_strTrainmanJiaoluGUID;
    property nTrainmanState: integer read m_nTrainmanState write m_nTrainmanState;
    property strPlaceID: string read m_strPlaceID write m_strPlaceID;
    property strTrainmanJiaoluName: string read m_strTrainmanJiaoluName write m_strTrainmanJiaoluName;
    property strPlaceName: string read m_strPlaceName write m_strPlaceName;
    property strTrainmanStateName: string read m_strTrainmanStateName write m_strTrainmanStateName;
    property strGroupGUID: string read m_strGroupGUID write m_strGroupGUID;
    property nTrainmanIndex: integer read m_nTrainmanIndex write m_nTrainmanIndex;
  end;


  TChangeGrpJLInput = class(TPersistent)
  public
    constructor create();
    destructor Destroy;override;
  private
    m_SrcJiaolu: TRsLCBoardInputJL;
    m_DestJiaolu: TRsLCBoardInputJL;
    m_DutyUser: TRsLCBoardInputDuty;
    m_strGroupGUID: string;
    m_strCheCi1: string;
    m_strCheCi2: string;
    m_strTrainGUID: string;
    m_TrainNumber: string;
  published
    property GroupGUID: string read m_strGroupGUID write m_strGroupGUID;
    property CheCi1: string read m_strCheCi1 write m_strCheCi1;
    property CheCi2: string read m_strCheCi2 write m_strCheCi2;
    property TrainGUID: string read m_strTrainGUID write m_strTrainGUID;
    property TrainNumber: string read m_TrainNumber write m_TrainNumber;
    property SrcJiaolu: TRsLCBoardInputJL read m_SrcJiaolu;
    property DestJiaolu: TRsLCBoardInputJL read m_DestJiaolu;
    property DutyUser: TRsLCBoardInputDuty read m_DutyUser;
  end;


   //预备人员顺序定义
  RRsPrepareTMOrder  = record
    /// 人员交路GUID
    public  TrainmanJiaoluGUID : string;
    /// 人员交路交路名称
    public TrainmanJiaoluName : string;
    //职务
    public PostID  : integer;
    /// 工号
    public TrainmanNumber : string;
    //姓名
    public TrainmanName : string;
    /// 序号
    public  TrainmanOrder : integer;
  end;
  RRsPrepareTMOrderLog  = record
    public  LogTime : TDateTime;
    public UserNumber  :string;
    public UserName :string ;
    public TMJiaoluGUID :string ;
    public TMJiaoluName :string ;
    //1添加。2替换，3删除
    public ChangeType  : integer;
    public LogText  : string;
  end;
  TRsPrepareTMOrderLogArray = array of RRsPrepareTMOrderLog;

  TRsPrepareTMOrderArray = array of  RRsPrepareTMOrder;

  {$endregion '输入实体定义'}



  TRsLCGroupTX = class(TWepApiBase)
  public
    //调休
    procedure Add(TrainmanJiaolu: TRsLCBoardInputJL;DutyUser: TRsLCBoardInputDuty;GroupGUID: string);

    //结束调休
    procedure Del(TrainmanJiaolu: TRsLCBoardInputJL;DutyUser: TRsLCBoardInputDuty;GroupGUID: string);
    
    //获取调休机组列表
    procedure Get(TrainmanJLGUID: string;out Groups: TRsGroupArray);
  end;


  
  TRsLCGroup = class(TWepApiBase)
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_GroupTX: TRsLCGroupTX;
  public
    //1.4.4	检测指定的机组是否处于可被编辑状态(添加人员\删除人员)
    function IsBusy(GroupGUID: string;var Msg: string): Boolean;
    //1.4.5	检测机组内人员是否已经在别的机组内
    function PersonInOtherGrp(trainmanNumber1,trainmanNumber2,trainmanNumber3,
      trainmanNumber4: string;var Msg: string): Boolean;

    //1.4.8	删除机组
    procedure Delete(TrainmanJiaolu: TRsLCBoardInputJL;GroupGUID: string;DutyUser: TRsLCBoardInputDuty);
    //1.4.11	设置乘务员
    procedure AddTrainman(AddInput: TRsLCTrainmanAddInput);
    //1.4.12	删除乘务员
    procedure DeleteTrainman(Input: TRsLCTrainmanAddInput);
    //1.4.13	获取机组当前正在值乘的计划信息
    function GetPlan(GroupGUID : string;out TrainmanPlan : RRsTrainmanPlan): Boolean;
    //1.4.28	清除机组最后到达时间
    procedure ClearArriveTime(GroupGUID: string;OldTime: TDateTime;
      DutyUser: TRsLCBoardInputDuty;TrainmanJiaolu: TRsLCBoardInputJL);
    //1.4.29	修改机组最后到达时间
    procedure UpdateArriveTime(GroupGUID: string;OldTime,NewTime: TDateTime;
      DutyUser: TRsLCBoardInputDuty;TrainmanJiaolu: TRsLCBoardInputJL);

    //1.4.27	获取人员所在机组
    function GetGroup(TrainmanNumber: string;HasRestInfo: integer;out Group : RRsGroup): Boolean;overload;

    //1.4.27	移动机组上一组、下一组
    procedure Swap(TrainmanJiaolu: TRsLCBoardInputJL;DutyUser: TRsLCBoardInputDuty;
    SourceGroupGUID,DestGroupGUID: string);

    //获取机组信息
    function GetGroup(GroupGUID: string;out Group : RRsGroup): Boolean;overload;

    //获取机组所在人员交路信息
    function GetTrainmanJiaoluOfGroup(GroupGUID: string;out trainmanJiaoLu : RRsTrainmanJiaolu): Boolean;
    //获取多个人员交路的机组数组、按照时间排序
    procedure GetGroupArrayInTrainmanJiaolus(TrainmanJiaolus: string;JiaoluType: integer;out Groups: TRsGroupArray);
    //获取人员所在的机组信息(机组内包含寓休信息)
    function GetGroupWithInRoomTime(TrainmanNumber: string;out Group : RRsGroup): Boolean;
    //获取退勤时间修改记录
    procedure GetTuiqinTimeLog(StartDate,EndDate:TDateTime;out LogList:TRsTuiQinTimeLogList);
  public
    class function JsonToGroup(iJson: ISuperObject): RRsGroup;
    class function JsonToGrpTrainman(iJson: ISuperObject): RRsTrainman;
    class function GrpTrainmanToJson(trainman: RRsTrainman): ISuperObject;
    class function GroupToJson(group: RRsGroup): ISuperObject;
  public
    property GroupTX: TRsLCGroupTX read m_GroupTX;
  end;

  TRsLCOrderGroup = class(TRsLCGroup)
  public
    //1.4.2	获取指定车间的指定人员交路下的无出勤点的人员列表
    procedure GetNullStationGrps(TrainmanJiaoluGUID: string;
      out OrderGroupArray: TRsOrderGroupArray);
    //1.4.14	插入轮乘机组
    procedure Add(AddParam: TRsLCOrderGrpInputParam);
    //获取轮乘机组信息
    function GetOrderGroup(GroupGUID: string; var OrderGroup: RRsOrderGroup): Boolean;

    procedure ChangeJl(Input: TChangeGrpJLInput);
  public
    class function JsonToOrderGroup(iJson: ISuperObject): RRsOrderGroup;
  end;


  
  TRsLCNamedGroup = class(TRsLCGroup)
  public
    //添加机组
    procedure Add(AddParam: TRsLCNamedGrpInputParam);
    //1.4.9	修改记名式机组的车次信息
    procedure UpdateCC(checi1,checi2,checiID: string;checiType: integer);
    //1.4.10	修改记名式机组的序号信息
    procedure UpdateIndex(CheciGUID: string;CheciOrder: integer);
    //1.4.23	记名式名牌翻牌    向左/右翻拍(1左,2右)
    procedure Turn(TrainmanJiaoluGUID: string;LeftOrRight: integer);
    //查找记名式机组
    function GetNamedGroup(GroupGUID: string; var NamedGroup: RRsNamedGroup): Boolean;

    procedure ChangeJl(Input: TChangeGrpJLInput);
  public
    class function JsonToNamedGroup(iJson: ISuperObject): RRsNamedGroup;
    class function NamedGroupToJson(NamedGroup: RRsNamedGroup): ISuperObject;
  end;

  //包乘机组
  TRsLCTogetherGroup = class(TRsLCGroup)
  public
    //1.4.8	添加包乘机车
    procedure Add(AddParam: TRsLCTogetherGrpInputParam);

    procedure ChangeJl(Input: TChangeGrpJLInput);

  end;


  //轮乘名牌
  TRsLCOrderPlate = class(TWepApiBase)
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_Group: TRsLCOrderGroup;
  public
    property Group: TRsLCOrderGroup read m_Group;
  end;

  //记名式名牌
  TRsLCNamedPlate = class(TWepApiBase)
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_Group: TRsLCNamedGroup;
  public
    property Group: TRsLCNamedGroup read m_Group;
  end;

  //包乘名牌
  TRsLCTogetherPlate = class(TWepApiBase)
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_Group: TRsLCTogetherGroup;
  public
    //1.4.17	判断指定的包乘机车组是否已经存在
    function ExistTrain(TrainTypeName,TrainNumber: string): Boolean;
    //1.4.18	添加包乘机车信息
    procedure AddTrain(TrainmanJiaoluGUID,TrainGUID,TrainTypeName,TrainNumber: string);
    //1.4.19	获取指定的包乘机车信息
    procedure GetTrain(strTrainGUID: string; out TogetherTrain: RRsTogetherTrain);
    //1.4.20	删除指定的包乘机车信息
    procedure DeleteTrain(TrainGUID: string);
    //修改包乘机车
    procedure UpdateTrain(TrainGUID,TrainTypeName,TrainNumber: string);
    //获取包乘机车的计划
    function GetTrainPlan(TrainGUID : string;out TrainmanPlan : RRsTrainmanPlan): Boolean;
    //获取人员交路下的机车列表，不包含机组信息
    procedure GetTrainList(TrainmanJiaoluGUID: string;out TrainArray: TRsTogetherTrainArray);
  public
    class function JsonToTogetherTrain(Json: ISuperObject): RRsTogetherTrain;
    class function JsonToSimplePlan(Json: ISuperObject): RRsTrainPlan;
    property Group: TRsLCTogetherGroup read m_Group;
  end;

  
  TRsLCBoardTrainman = class(TWepApiBase)
  public
    //1.4.1	获取指定车间的指定人员交路下的非运转人员列表
    procedure GetUnRun(WorkShopGUID,TrainmanJiaoluGUID: string;
      out TrainmanArray: TRsTrainmanLeaveArray);
    //1.4.3	获取指定车间的指定人员交路下的预备人员列表
    procedure GetPrepare(WorkshopGUID,TrainmanJiaoluGUID: string;out Trainmans: TRsTrainmanArray);

    //获取指定交路下的预备人员的排序信息
    procedure GetPrepareOrder(WorkshopGUID,TrainmanJiaoluGUID: string;out TrainmanOrders : TRsPrepareTMOrderArray);
    procedure AddPrepareChangeLog(LogTime : TDateTime;UserNumber,UserName : string;
      TMJiaoluGUID,TMJiaoluName : string; 
      ChangeType : integer;LogText : string);
   function  QueryPrepareChangeLog(BeginTime: TDateTime;EndTime: TDateTime;
    TMJiaoluGUID,LogText: string) : TRsPrepareTMOrderLogArray;
    ///修改预备人员序号
    procedure AddPerpareTrainmanOrder(TrainmanOrder : RRsPrepareTMOrder);
    ///修改预备人员序号
    procedure UpdatePerpareTrainmanOrder(Source : RRsPrepareTMOrder;Dest :RRsPrepareTMOrder);
    //删除预报人员序号
    procedure DeletePerpareTrainmanOrder(TrainmanOrder : RRsPrepareTMOrder);

    //1.4.21	将指定的预备人员的状态转换为空状态
    procedure SetStateToNull(TrainmanNumber: string);
    //1.4.22	将指定交路下的预备人员的状态全部转换为空状态
    procedure SetAllStateToNull(WorkShopGUID: string);
    //1.4.25	获取人员所在名牌位置
    function Find(TrainmanNumber: string;FindRet: TRsLCBoardTmFindRet): Boolean;
    //1.4.30	获取车间内指定类型的非运转人员
    procedure GetUnRunByType(WorkShopGUID: string;Types : TStrings;
      out Trainmans : TRsTrainmanLeaveArray);
    //获取指定人员的的计划
    function GetPlan(TrainmanNumber : string;out TrainmanPlan : RRsTrainmanPlan): Boolean;

  private
    //JSON转非运转人员
    function JsonToRLeaveTrainman(iJson: ISuperObject): RRsTrainmanLeaveInfo;
  end;

  TRsLCNameBoardEx = class(TWepApiBase)
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_Order: TRsLCOrderPlate;
    m_Named: TRsLCNamedPlate;
    m_Together: TRsLCTogetherPlate;
    m_Group: TRsLCGroup;
    m_Trainman: TRsLCBoardTrainman;
  public
    //查询名牌变动日志
    procedure QueryChangeLog(BeginTime, EndTime: TDateTime;
      Trainmanjiaolus: TStrings; ChangeType: integer;Key: string;out ChangeLogArray: TRsChangeLogArray);

    procedure ChangeGroupJl(Input: TChangeGrpJLInput);
    property Order: TRsLCOrderPlate read m_Order;
    property Named: TRsLCNamedPlate read m_Named;
    property Together: TRsLCTogetherPlate read m_Together;
    property Group: TRsLCGroup read m_Group;
    property Trainman: TRsLCBoardTrainman read m_Trainman;
  end;


const
  TRSLBoardChangeTypeNameArray : array[TRSLBoardChangeType] of string =
    ('未知','添加人员','删除人员','交换人员','添加机组','删除机组','交换机组',
    '修改机组顺序','更改交路','清除退勤时间','修改退勤时间');
implementation

{ TRsLCGroup }

procedure TRsLCGroup.AddTrainman(AddInput: TRsLCTrainmanAddInput);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AddInput);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.AddTrainman',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCGroup.ClearArriveTime(GroupGUID: string;OldTime: TDateTime;
  DutyUser: TRsLCBoardInputDuty;TrainmanJiaolu: TRsLCBoardInputJL );
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  JSON.S['OldTime'] := TimeToJSONString(OldTime);
  JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.ClearArriveTime',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


constructor TRsLCGroup.Create(WebAPIUtils: TWebAPIUtils);
begin
  inherited Create(WebAPIUtils);
  m_GroupTX := TRsLCGroupTX.Create(WebAPIUtils);
end;

procedure TRsLCGroup.Delete(TrainmanJiaolu: TRsLCBoardInputJL;GroupGUID: string;
  DutyUser: TRsLCBoardInputDuty);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);
  JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCGroup.DeleteTrainman(Input: TRsLCTrainmanAddInput);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Input);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.DeleteTrainman',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

destructor TRsLCGroup.Destroy;
begin
  m_GroupTX.Free;
  inherited;
end;

function TRsLCGroup.GetGroup(TrainmanNumber: string; HasRestInfo: integer;
  out Group: RRsGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  JSON.I['HasRestInfo'] := HasRestInfo;



  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.Trainman.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := (JSON.O['Group'] <> nil) and (JSON.O['Group'].IsType(stObject));
  
  if Result then
    Group := JsonToGroup(JSON.O['Group'])

end;
function TRsLCGroup.GetGroup(GroupGUID: string; out Group: RRsGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] = 1;

  if Result then
    Group := JsonToGroup(JSON.O['Group'])

end;


procedure TRsLCGroup.GetGroupArrayInTrainmanJiaolus(TrainmanJiaolus: string;
  JiaoluType: integer; out Groups: TRsGroupArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['TrainmanJiaolus'] := TrainmanJiaolus;
  JSON.I['JiaoluType'] := JiaoluType;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.TrainmanJiaolu.Group.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(Groups,JSON.O['Groups'].AsArray.Length);
  for I := 0 to JSON.O['Groups'].AsArray.Length - 1 do
  begin
    Groups[i] := JsonToGroup(JSON.O['Groups'].AsArray[i]);
  end;

end;

function TRsLCGroup.GetGroupWithInRoomTime(TrainmanNumber: string;
  out Group: RRsGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanNumber'] := TrainmanNumber;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.Trainman.Group.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] = 1;
  
  if Result then
    Group := JsonToGroup(JSON.O['Group'])

end;

function TRsLCGroup.GetPlan(GroupGUID : string;out TrainmanPlan : RRsTrainmanPlan): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  TrainPlan: RRsTrainPlan;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.GetPlan',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := (JSON.O['Exist'] <> nil) and (JSON.I['Exist'] = 1);
  if Result then
  begin
    TRsLCTrainPlan.JsonToTrainPlan(TrainPlan,JSON.O['Plan']);
    TrainmanPlan.TrainPlan := TrainPlan;
  end;

end;


function TRsLCGroup.GetTrainmanJiaoluOfGroup(GroupGUID: string;
  out trainmanJiaoLu: RRsTrainmanJiaolu): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  JLMin: TRsLCBoardInputJL;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.Group.TrainmanJiaolu.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] = 1;


  if Result then
  begin
    JLMin := TRsLCBoardInputJL.Create;
    try
      TJsonSerialize.DeSerialize(JSON.O['TrainmanJiaolu'],JLMin);

      trainmanJiaoLu.strTrainmanJiaoluGUID := JLMin.jiaoluID;
      trainmanJiaoLu.strTrainmanJiaoluName := JLMin.jiaoluName;
      trainmanJiaoLu.nJiaoluType := TRsJiaoluType(JLMin.jiaoluType);
      
    finally
      JLMin.Free;
    end;
  end;

end;


procedure TRsLCGroup.GetTuiqinTimeLog(StartDate, EndDate: TDateTime;
  out LogList: TRsTuiQinTimeLogList);
  function JsonTo(iJson: ISuperObject):RRsTuiQinTimeLog;
  begin
    //机组GUID
    Result.strGroupGUID := iJson.S['strGroupGUID'];
    //所属车间GUID
    Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
    //GUID
    Result.strTrainmanGUID1 := iJson.S['strTrainmanGUID1'];
    //工号
    Result.strTrainmanNumber1 := iJson.S['strTrainmanNumber1'];
    //姓名
    Result.strTrainmanName1 := iJson.S['strTrainmanName1'];
  
    //GUID
    Result.strTrainmanGUID2 := iJson.S['strTrainmanGUID2'];
    //工号
    Result.strTrainmanNumber2 := iJson.S['strTrainmanNumber2'];
    //工号
    Result.strTrainmanName2 := iJson.S['strTrainmanName2'];
  
    //GUID
    Result.strTrainmanGUID3 := iJson.S['strTrainmanGUID3'];
    //工号
    Result.strTrainmanNumber3 := iJson.S['strTrainmanNumber3'];
    //工号
    Result.strTrainmanName3 := iJson.S['strTrainmanName3'];
  
    //计划
    Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
    //计划开车时间
    Result.dtStartTime := StrToDateTimeDef(iJson.S['dtStartTime'],0);
    //车次
    Result.strTrainNo := iJson.S['strTrainNo'];
  
    //旧时间
    Result.dtOldArriveTime := StrToDateTimeDef(iJson.S['dtOldArriveTime'],0);
    //新时间
    Result.dtNewArriveTime := StrToDateTimeDef(iJson.S['dtNewArriveTime'],0);
    //修改人名字
    Result.strDutyUserNumber := iJson.S['strDutyUserNumber'];
    //修改人名字
    Result.strDutyUserName := iJson.S['strDutyUserName'];
    //修改时间
    Result.dtCreateTime := StrToDateTimeDef(iJson.S['dtCreateTime'],0);
    //类型                                                         
    Result.nType := iJson.I['nType'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['BeginTime'] := TimeToJSONString(StartDate);
  JSON.S['EndTime'] := TimeToJSONString(EndDate);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.TuiqinTimeLog.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(LogList,JSON.O['Logs'].AsArray.Length);
  for I := 0 to Length(LogList) - 1 do
  begin
    LogList[i] := JsonTo(JSON.O['Logs'].AsArray[i]);
  end;


end;

class function TRsLCGroup.GroupToJson(group: RRsGroup): ISuperObject;
begin
  Result.S['groupID'] := group.strGroupGUID;
  Result.I['groupState'] := Ord(group.groupState );
  Result.S['trainPlanID'] := group.strTrainPlanGUID;

  TimeToJSONObj(Result,'arriveTime',group.dtArriveTime);

  TimeToJSONObj(Result,'lastInRoomTime1',group.dtLastInRoomTime1);

  TimeToJSONObj(Result,'lastInRoomTime2',group.dtLastInRoomTime2);

  TimeToJSONObj(Result,'lastInRoomTime3',group.dtLastInRoomTime3);

  TimeToJSONObj(Result,'lastInRoomTime4',group.dtLastInRoomTime4);





  with group.place do
  begin
    Result.S['place.placeID'] := placeID;
    Result.S['place.placeName'] := placeName;
  end;

  with group.Station do
  begin
    Result.S['station.stationID'] := strStationGUID ;
    Result.S['station.stationNumber'] := strStationNumber;
    Result.S['station.stationName'] := strStationName;
  end;

  with group do
  begin
    Result.O['trainman1'] := GrpTrainmanToJson(trainman1);

    Result.O['trainman2'] := GrpTrainmanToJson(trainman2);

    Result.O['trainman3'] := GrpTrainmanToJson(trainman3);

    Result.O['trainman4'] := GrpTrainmanToJson(trainman4);
  end;

end;

class function TRsLCGroup.GrpTrainmanToJson(
  trainman: RRsTrainman): ISuperObject;
begin

    Result.S['trainmanID'] := trainman.strTrainmanGUID ;
    Result.S['trainmanNumber'] := trainman.strTrainmanNumber ;
    Result.S['trainmanName'] := trainman.strTrainmanName ;
    Result.I['postID'] := Ord(trainman.nPostID);
    Result.S['telNumber'] := trainman.strTelNumber ;
    Result.I['trainmanState'] := Ord(trainman.nTrainmanState);
    Result.S['postName'] := trainman.strPostName ;
    Result.I['driverTypeID'] := Ord(trainman.nDriverType) ;
    Result.S['driverTypeName'] := trainman.strDriverTypeName ;
    Result.S['ABCD'] := trainman.strABCD ;
    Result.I['isKey'] := trainman.bIsKey;


    Result.i['callWorkState'] := Ord(trainman.nCallWorkState);

    Result.S['callWorkID'] := trainman.strCallWorkGUID;

end;



function TRsLCGroup.IsBusy(GroupGUID: string;var Msg: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['GroupGUID'] := GroupGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.IsBusy',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Checked'] = 0;
  if not Result then
  begin
    Msg := JSON.S['CheckBrief'];
  end;
end;
class function TRsLCGroup.JsonToGroup(iJson: ISuperObject): RRsGroup;
begin

  with Result do
  begin
    strGroupGUID := iJson.S['groupID'];
    if iJson.S['groupState'] <> '' then
      groupState :=  TRsTrainmanState ( strtoint ( iJson.S['groupState'] ) ) ;
    strTrainPlanGUID := iJson.S['trainPlanID'];

    if iJson.S['arriveTime'] <> '' then
      dtArriveTime := StrToDateTime(iJson.S['arriveTime']) ;

    if iJson.S['lastInRoomTime1'] <> '' then
      dtLastInRoomTime1:= StrToDateTime(iJson.S['lastInRoomTime1']) ;

    if iJson.S['lastInRoomTime2'] <> '' then
      dtLastInRoomTime2:= StrToDateTime(iJson.S['lastInRoomTime2']) ;

    if iJson.S['lastInRoomTime3'] <> '' then
      dtLastInRoomTime3:= StrToDateTime(iJson.S['lastInRoomTime3']) ;

    if iJson.S['lastInRoomTime4'] <> '' then
      dtLastInRoomTime4:=  StrToDateTime(iJson.S['lastInRoomTime4']) ;

  end;

  with Result.place do
  begin
    placeID := iJson.S['place.placeID'];
    placeName := iJson.S['place.placeName'];
  end;

  with Result.Station do
  begin
    strStationGUID := iJson.S['station.stationID'] ;
    strStationNumber := iJson.S['station.stationNumber'];
    strStationName := iJson.S['station.stationName'];
  end;

  with Result do
  begin
    trainman1 := JsonToGrpTrainman(iJson.O['trainman1']);

    trainman2 := JsonToGrpTrainman(iJson.O['trainman2']);

    trainman3 := JsonToGrpTrainman(iJson.O['trainman3']);

    trainman4 := JsonToGrpTrainman(iJson.O['trainman4']);

  end;

  Result.dtTXBeginTime := strToDateTimeDef(iJson.S['dtTXBeginTime'],0);
end;
class function TRsLCGroup.JsonToGrpTrainman(iJson: ISuperObject): RRsTrainman;
begin
  with Result do
  begin
    strTrainmanGUID := iJson.S['trainmanID'] ;
    strTrainmanNumber := iJson.S['trainmanNumber'] ;
    strTrainmanName := iJson.S['trainmanName'] ;
    nPostID :=  TRsPost ( strtoint(iJson.S['postID']) ) ;
    strTelNumber := iJson.S['telNumber'] ;
    strMobileNumber := strTelNumber ;
    //strMobileNumber := iJson.S['mobileNumber'];
    nTrainmanState := TRsTrainmanState   (StrToInt(iJson.S['trainmanState']));
    strPostName := iJson.S['postName'] ;
    nDriverType := TRsDriverType ( strtoint ( iJson.S['driverTypeID'] ) ) ;
    strDriverTypeName := iJson.S['driverTypeName'] ;
    strABCD := iJson.S['ABCD'] ;
    bIsKey :=  ( StrToInt(iJson.S['isKey']) ) ;

    if iJson.S['callWorkState'] <> '' then
      nCallWorkState :=  TRsCallWorkState ( StrToInt(iJson.S['callWorkState']) );
    if iJson.S['callWorkID'] <> '' then
      strCallWorkGUID := iJson.S['callWorkID'];
  end;
end;



function TRsLCGroup.PersonInOtherGrp(trainmanNumber1,trainmanNumber2,trainmanNumber3,
      trainmanNumber4: string;var Msg: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['trainmanNumber1'] := trainmanNumber1;
  JSON.S['trainmanNumber2'] := trainmanNumber2;
  JSON.S['trainmanNumber3'] := trainmanNumber3;
  JSON.S['trainmanNumber4'] := trainmanNumber4;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.HasGroup',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Checked'] = 0;
  if not Result then
  begin
    Msg := JSON.S['CheckBrief'];
  end;
end;


procedure TRsLCGroup.Swap(TrainmanJiaolu: TRsLCBoardInputJL;
  DutyUser: TRsLCBoardInputDuty; SourceGroupGUID, DestGroupGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['SourceGroupGUID'] := SourceGroupGUID;
  JSON.S['DestGroupGUID'] := DestGroupGUID;
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);
  JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.OrderGroup.Swap',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCGroup.UpdateArriveTime(GroupGUID: string;OldTime,NewTime: TDateTime;
  DutyUser: TRsLCBoardInputDuty;TrainmanJiaolu: TRsLCBoardInputJL);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  JSON.S['OldTime'] := TimeToJSONString(OldTime);
  JSON.S['NewTime'] := TimeToJSONString(NewTime);
  JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);




  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.UpdateArriveTime',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


{ TOrderGroup }

procedure TRsLCOrderGroup.ChangeJl(Input: TChangeGrpJLInput);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Input);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.OrderChangeJL',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCOrderGroup.GetNullStationGrps(TrainmanJiaoluGUID: string;
      out OrderGroupArray: TRsOrderGroupArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.OrderGrup.NullPlace.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Groups'];

  SetLength(OrderGroupArray,JSON.AsArray.Length);
  for I := 0 to Length(OrderGroupArray) - 1 do
  begin
    OrderGroupArray[i] := JsonToOrderGroup(JSON.AsArray[i]);
  end;

end;
function TRsLCOrderGroup.GetOrderGroup(GroupGUID: string;
  var OrderGroup: RRsOrderGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCOrderGroup.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] = 1;

  if Result then
    OrderGroup := JsonToOrderGroup(JSON.O['Group'])

end;

procedure TRsLCOrderGroup.Add(AddParam: TRsLCOrderGrpInputParam);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AddParam);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.AddOrderGroup',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
class function TRsLCOrderGroup.JsonToOrderGroup(
  iJson: ISuperObject): RRsOrderGroup;
begin
  Result.strOrderGUID := iJson.S['orderID'];
  Result.strTrainmanJiaoluGUID := iJson.S['trainmanjiaoluID'];
  Result.nOrder := iJson.I['order'];
  Result.Group := JsonToGroup(iJson.O['group']);
  Result.dtLastArriveTime := StrToDateTimeDef(iJson.S['lastArriveTime'],0);
end;


{ TRsLCNamedGroup }
procedure TRsLCNamedGroup.Add(AddParam: TRsLCNamedGrpInputParam);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AddParam);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.AddNamedGroup',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCNamedGroup.ChangeJl(Input: TChangeGrpJLInput);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Input);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.NamedChangeJL',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCNamedGroup.GetNamedGroup(GroupGUID: string;
  var NamedGroup: RRsNamedGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCNamedGroup.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] = 1;
  
  if Result then
    NamedGroup := JsonToNamedGroup(JSON.O['Group'])

end;

class function TRsLCNamedGroup.JsonToNamedGroup(
  iJson: ISuperObject): RRsNamedGroup;
begin
  with Result do
  begin
      strCheciGUID := iJson.S['strCheciGUID'];
      strTrainmanJiaoluGUID := iJson.S['strTrainmanJiaoluGUID'];
      nCheciOrder := iJson.I['nCheciOrder'];
      nCheciType := TRsCheciType(iJson.I['nCheciType']);
      strCheci1 := iJson.S['strCheci1'];
      strCheci2 := iJson.S['strCheci2'];
      if iJson.S['dtLastArriveTime'] <> '' then
        dtLastArriveTime := StrToDateTime( iJson.S['dtLastArriveTime'] );

      Group := TRsLCGroup.JsonToGroup(iJson.O['Group']);
  end;
end;

class function TRsLCNamedGroup.NamedGroupToJson(
  NamedGroup: RRsNamedGroup): ISuperObject;
begin
  Result :=  SO();

  with NamedGroup do
  begin
      Result.S['strCheciGUID'] := strCheciGUID;
      Result.S['strTrainmanJiaoluGUID'] := strTrainmanJiaoluGUID;
      Result.I['nCheciOrder'] := nCheciOrder;
      Result.I['nCheciType'] := Ord(nCheciType);
      Result.S['strCheci1'] := strCheci1;
      Result.S['strCheci2'] := strCheci2;
      TimeToJSONObj(Result,'dtLastArriveTime',dtLastArriveTime);

      Result.O['Group'] := GroupToJson(Group);
  end;
end;

procedure TRsLCNamedGroup.Turn(TrainmanJiaoluGUID: string;LeftOrRight: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := so();
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  JSON.I['LeftOrRight'] := LeftOrRight;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.NamedGroup.Turn',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCNamedGroup.UpdateCC(checi1,checi2,checiID: string;checiType: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := so();
  JSON.S['checi1'] := checi1;
  JSON.S['checi2'] := checi2;
  JSON.S['checiID'] := checiID;
  JSON.I['checiType'] := checiType;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.NamedGroup.UpdateCC',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCNamedGroup.UpdateIndex(CheciGUID: string;CheciOrder: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := so();
  JSON.S['CheciGUID'] := CheciGUID;
  JSON.I['CheciOrder'] := CheciOrder;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.NamedGroup.UpdateIndex',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

{ TRsLCOrderPlate }

constructor TRsLCOrderPlate.Create(WebAPIUtils: TWebAPIUtils);
begin
  inherited Create(WebAPIUtils);
  m_Group := TRsLCOrderGroup.Create(WebAPIUtils);
end;

destructor TRsLCOrderPlate.Destroy;
begin
  m_Group.Free;
  inherited;
end;

{ TRsLCNamedPlate }

constructor TRsLCNamedPlate.Create(WebAPIUtils: TWebAPIUtils);
begin
  inherited Create(WebAPIUtils);
  m_Group := TRsLCNamedGroup.Create(WebAPIUtils);
end;

destructor TRsLCNamedPlate.Destroy;
begin
  m_Group.Free;
  inherited;
end;

{ TRsLCTogetherPlate }

procedure TRsLCTogetherPlate.AddTrain(TrainmanJiaoluGUID,TrainGUID,
  TrainTypeName,TrainNumber: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  JSON.S['TrainGUID'] := TrainGUID;
  JSON.S['TrainTypeName'] := TrainTypeName;
  JSON.S['TrainNumber'] := TrainNumber;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Together.Train.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCTogetherPlate.Create(WebAPIUtils: TWebAPIUtils);
begin
  Inherited Create(WebAPIUtils);
  m_Group := TRsLCTogetherGroup.Create(WebAPIUtils); 
end;

procedure TRsLCTogetherPlate.DeleteTrain(TrainGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainGUID'] := TrainGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Together.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

destructor TRsLCTogetherPlate.Destroy;
begin
  m_Group.Free;
  inherited;
end;

function TRsLCTogetherPlate.ExistTrain(TrainTypeName,TrainNumber: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainTypeName'] := TrainTypeName;
  JSON.S['TrainNumber'] := TrainNumber;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.TogetherGroup.Train.Exist',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;
end;

procedure TRsLCTogetherPlate.GetTrain(strTrainGUID: string;
 out TogetherTrain: RRsTogetherTrain);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['strTrainGUID'] := strTrainGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Together.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TogetherTrain := JsonToTogetherTrain(JSON.O['Train']);
end;

procedure TRsLCTogetherPlate.GetTrainList(TrainmanJiaoluGUID: string;
  out TrainArray: TRsTogetherTrainArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTogetherGroup.Train.GetTrainList',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);


  SetLength(TrainArray,JSON.AsArray.Length);
  for I := 0 to Length(TrainArray) - 1 do
  begin
    TrainArray[i].strTrainGUID := JSON.AsArray[i].S['strTrainGUID'];
    TrainArray[i].strTrainmanJiaoluGUID := JSON.AsArray[i].S['strTrainmanJiaoluGUID'];
    TrainArray[i].strTrainTypeName := JSON.AsArray[i].S['strTrainTypeName'];
    TrainArray[i].strTrainNumber := JSON.AsArray[i].S['strTrainNumber'];
  end;


end;

function TRsLCTogetherPlate.GetTrainPlan(TrainGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainGUID'] := TrainGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTogetherGroup.Train.Plan.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);


  Result := JSON.I['Exist'] = 1;
  
  if Result then
  begin
    TrainmanPlan.TrainPlan := JsonToSimplePlan(JSON.O['Plan']);
  end;

end;
class function TRsLCTogetherPlate.JsonToSimplePlan(
  Json: ISuperObject): RRsTrainPlan;
begin
  Result.strTrainPlanGUID := json.S['strTrainPlanGUID'];
  Result.dtChuQinTime := StrToDateTimeDef(Json.S['dtChuQinTime'],0);
  Result.strTrainNo := Json.S['strTrainNo'];
  Result.strTrainJiaoluName := Json.S['strTrainJiaoluName'];
  Result.strTrainJiaoluGUID := Json.S['strTrainJiaoluGUID'];
  Result.nPlanState := TRsPlanState(Json.I['nPlanState']); 
end;

class function TRsLCTogetherPlate.JsonToTogetherTrain(
  Json: ISuperObject): RRsTogetherTrain;
var
  jsonOrderGroupInTrainArray:TSuperArray ;
  jsonGroup:ISuperObject ;
  i : Integer ;
begin
  with Result do
  begin
    //包乘机车GUID
    strTrainGUID := Json.S['strTrainGUID'];
    //所属交路GUID
    strTrainmanJiaoluGUID := Json.S['strTrainmanJiaoluGUID'];
    //机车类型
    strTrainTypeName := Json.S['strTrainTypeName'];
    //机车号
    strTrainNumber := Json.S['strTrainNumber'];

    jsonOrderGroupInTrainArray := json.O['Groups'].AsArray;

    SetLength(Groups,jsonOrderGroupInTrainArray.Length);
    for I := 0 to jsonOrderGroupInTrainArray.Length - 1 do
    begin
      with Groups[i] do
      begin
        //排序GUID
        strOrderGUID := jsonOrderGroupInTrainArray[i].S['strOrderGUID'];
        //所属机车GUID
        strTrainGUID := jsonOrderGroupInTrainArray[i].S['strTrainGUID'];
        //序号
        nOrder := jsonOrderGroupInTrainArray[i].I['nOrder'];
        //最后一次到达时间
        if jsonOrderGroupInTrainArray[i].S['dtLastArriveTime'] <> '' then
          dtLastArriveTime := StrToDateTime( jsonOrderGroupInTrainArray[i].S['dtLastArriveTime'] );

        jsonGroup := jsonOrderGroupInTrainArray[i].O['Group'] ;

        Group := TRsLCGroup.JsonToGroup(jsonGroup);
      end;
    end;
  end;
end;

procedure TRsLCTogetherPlate.UpdateTrain(TrainGUID, TrainTypeName,
  TrainNumber: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainGUID'] := TrainGUID;
  JSON.S['TrainTypeName'] := TrainTypeName;
  JSON.S['TrainNumber'] := TrainNumber;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTogetherGroup.Train.Update',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
{ TRsLCBoardTrainman }

procedure TRsLCBoardTrainman.AddPerpareTrainmanOrder(
  TrainmanOrder: RRsPrepareTMOrder);
var
  strOutputData,strResultText : String;
  JSON,JSON2 : ISuperObject;
begin
  JSON2 := SO();
  JSON2.S['TrainmanJiaoluGUID'] := TrainmanOrder.TrainmanJiaoluGUID;
  JSON2.S['TrainmanJiaoluName'] := TrainmanOrder.TrainmanJiaoluName;
  JSON2.S['TrainmanNumber'] := TrainmanOrder.TrainmanNumber;
  JSON2.S['TrainmanName'] := TrainmanOrder.TrainmanName;
  JSON2.I['PostID'] := TrainmanOrder.PostID;
  JSON2.I['TrainmanOrder'] := TrainmanOrder.TrainmanOrder;
  JSON := SO();
  JSON.O['TMOrder'] := Json2;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.AddOrder',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCBoardTrainman.AddPrepareChangeLog(LogTime: TDateTime; UserNumber,
  UserName, TMJiaoluGUID, TMJiaoluName: string; ChangeType: integer;
  LogText: string);
var
  strOutputData,strResultText : String;
  JSON,Json2: ISuperObject;
begin
  JSON := SO;
  Json2 :=SO;
  Json2.S['LogTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',LogTime);
  Json2.S['UserNumber'] := UserNumber;
  Json2.S['UserName'] := UserName;
  Json2.S['TMJiaoluGUID'] := TMJiaoluGUID;
  Json2.S['TMJiaoluName'] := TMJiaoluName;
  Json2.I['ChangeType'] := ChangeType;
  Json2.S['LogText'] := LogText;
  Json.O['ChangeLog'] := Json2;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.AddLog',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCBoardTrainman.DeletePerpareTrainmanOrder(
  TrainmanOrder: RRsPrepareTMOrder);
var
  strOutputData,strResultText : String;
  JSON,JSON2 : ISuperObject;
begin
  JSON2 := SO();
  JSON2.S['TrainmanJiaoluGUID'] := TrainmanOrder.TrainmanJiaoluGUID;
  JSON2.S['TrainmanJiaoluName'] := TrainmanOrder.TrainmanJiaoluName;
  JSON2.S['TrainmanNumber'] := TrainmanOrder.TrainmanNumber;
  JSON2.S['TrainmanName'] := TrainmanOrder.TrainmanName;
  JSON2.I['PostID'] := TrainmanOrder.PostID;
  JSON2.I['TrainmanOrder'] := TrainmanOrder.TrainmanOrder;
  JSON := SO();
  JSON.O['TMOrder'] := Json2;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.DeleteOrder',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCBoardTrainman.Find(TrainmanNumber: string;
  FindRet: TRsLCBoardTmFindRet): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Find',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

 TJsonSerialize.DeSerialize(JSON,FindRet);
  Result:= FindRet.IsFind = 1;

end;

function TRsLCBoardTrainman.GetPlan(TrainmanNumber: string;
  out TrainmanPlan: RRsTrainmanPlan): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.BoardTrainman.Plan.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := (JSON.O['Exist'] <> nil) and (JSON.I['Exist'] = 1);
  if Result then
  begin
    TrainmanPlan.TrainPlan := TRsLCTogetherPlate.JsonToSimplePlan(JSON.O['Plan']);
  end;

end;

procedure TRsLCBoardTrainman.GetPrepare(WorkshopGUID,TrainmanJiaoluGUID: string;
  out Trainmans: TRsTrainmanArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Trainmans'];

  SetLength(Trainmans,JSON.AsArray.Length);
  for I := 0 to Length(Trainmans) - 1 do
  begin

    Trainmans[i] := TRsLCGroup.JsonToGrpTrainman(JSON.AsArray[i]);
  end;

end;

procedure TRsLCBoardTrainman.GetPrepareOrder(WorkshopGUID,
  TrainmanJiaoluGUID: string; out TrainmanOrders: TRsPrepareTMOrderArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.QueryOrder',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['TMOrders'];

  SetLength(TrainmanOrders,JSON.AsArray.Length);
  for I := 0 to Length(TrainmanOrders) - 1 do
  begin

    with TrainmanOrders[i] do
    begin
      TrainmanJiaoluGUID := JSON.AsArray[i].S['TrainmanJiaoluGUID'] ;
      TrainmanJiaoluName := JSON.AsArray[i].S['TrainmanJiaoluName'] ;
      TrainmanNumber := JSON.AsArray[i].S['TrainmanNumber'] ;
      TrainmanName := JSON.AsArray[i].S['TrainmanName'] ;
      PostID :=  StrToInt(JSON.AsArray[i].S['PostID']) ;
      TrainmanOrder :=  StrToInt(JSON.AsArray[i].S['TrainmanOrder']);
    end;
  end;
end;

procedure TRsLCBoardTrainman.GetUnRun(WorkShopGUID,TrainmanJiaoluGUID: string;
      out TrainmanArray: TRsTrainmanLeaveArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.S['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Unrun.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Trainmans'];

  SetLength(TrainmanArray,JSON.AsArray.Length);
  for I := 0 to Length(TrainmanArray) - 1 do
  begin
    TrainmanArray[i] := JsonToRLeaveTrainman(JSON.AsArray[i]); 
  end;

end;

procedure TRsLCBoardTrainman.GetUnRunByType(WorkShopGUID: string;Types : TStrings;
      out Trainmans : TRsTrainmanLeaveArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;

  JSON.S['Types'] := Types.CommaText;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Unrun.GetByType',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Trainmans'];

  SetLength(Trainmans,JSON.AsArray.Length);
  for I := 0 to Length(Trainmans) - 1 do
  begin
    Trainmans[i] := JsonToRLeaveTrainman(JSON.AsArray[i]); 
  end;

end;
function TRsLCBoardTrainman.JsonToRLeaveTrainman(
  iJson: ISuperObject): RRsTrainmanLeaveInfo;
begin
  Result.strLeaveTypeGUID := iJson.S['strLeaveTypeGUID'];
  Result.strLeaveTypeName := iJson.S['strLeaveTypeName'];
  Result.dBeginTime := StrToDateTimeDef(iJson.S['dBeginTime'],strtodatetime('2000-01-01'));
  Result.dEndTime := StrToDateTimeDef(iJson.S['dEndTime'],strtodatetime('2000-01-01'));
  Result.Trainman := TRsLCGroup.JsonToGrpTrainman(iJson.O['Trainman']);
end;

function TRsLCBoardTrainman.QueryPrepareChangeLog(BeginTime, EndTime: TDateTime;
  TMJiaoluGUID, LogText: string): TRsPrepareTMOrderLogArray;
var
  strOutputData,strResultText : String;
  JSON,Json2 : ISuperObject;
  I: Integer;
begin
  setLength(result,0);
  JSON := SO();
  JSON.S['BeginTime'] := Formatdatetime('yyyyy-MM-dd HH:nn:ss',BeginTime);
  JSON.S['EndTime'] := Formatdatetime('yyyyy-MM-dd HH:nn:ss',EndTime);
  JSON.S['TMJiaoluGUID'] := TMJiaoluGUID;
  JSON.S['LogText'] := LogText;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.QueryLog',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Json2 := JSON.O['Logs'];
  if Json2 <> nil then
  begin
    SetLength(Result,Json2.AsArray.Length);
    for I := 0 to Length(Result) - 1 do
    begin

      with Result[i] do
      begin
        LogTime := StrToDateTime(Json2.AsArray[i].S['LogTime']);
        UserNumber := Json2.AsArray[i].S['UserNumber'] ;
        UserName := Json2.AsArray[i].S['UserName'] ;
        TMJiaoluGUID := Json2.AsArray[i].S['TMJiaoluGUID'] ;
        TMJiaoluName :=  Json2.AsArray[i].S['TMJiaoluName'] ;
        ChangeType :=  StrToInt(Json2.AsArray[i].S['ChangeType']);
        LogText :=  Json2.AsArray[i].S['LogText'];
      end;
    end;
  end;
end;

procedure TRsLCBoardTrainman.SetAllStateToNull(WorkShopGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.AllToNull',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;

procedure TRsLCBoardTrainman.SetStateToNull(TrainmanNumber: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.ToNull',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;

procedure TRsLCBoardTrainman.UpdatePerpareTrainmanOrder(Source,
  Dest: RRsPrepareTMOrder);
var
  strOutputData,strResultText : String;
  JSON,JSON2,JSON3 : ISuperObject;
begin
  JSON2 := SO();
  JSON2.S['TrainmanJiaoluGUID'] := Source.TrainmanJiaoluGUID;
  JSON2.S['TrainmanJiaoluName'] := Source.TrainmanJiaoluName;
  JSON2.S['TrainmanNumber'] := Source.TrainmanNumber;
  JSON2.S['TrainmanName'] := Source.TrainmanName;
  JSON2.I['PostID'] := Source.PostID;
  JSON2.I['TrainmanOrder'] := Source.TrainmanOrder;

  JSON3 := SO();
  JSON3.S['TrainmanJiaoluGUID'] := Dest.TrainmanJiaoluGUID;
  JSON3.S['TrainmanJiaoluName'] := Dest.TrainmanJiaoluName;
  JSON3.S['TrainmanNumber'] := Dest.TrainmanNumber;
  JSON3.S['TrainmanName'] := Dest.TrainmanName;
  JSON3.I['PostID'] := Dest.PostID;
  JSON3.I['TrainmanOrder'] := Dest.TrainmanOrder;
  JSON := SO();
  JSON.O['Source'] := Json2;
  JSON.O['Dest'] := JSON3;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Trainman.Prepare.UpdateOrder',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

{ TRsLCNameBoard }

procedure TRsLCNameBoardEx.ChangeGroupJl(Input: TChangeGrpJLInput);
begin
  case Input.DestJiaolu.jiaoluType of
    Ord(jltNamed): m_Named.Group.ChangeJl(Input);
    Ord(jltOrder): m_Order.Group.ChangeJl(Input);
    Ord(jltTogether): m_Together.Group.ChangeJl(Input);  
  end;
end;

constructor TRsLCNameBoardEx.Create(WebAPIUtils: TWebAPIUtils);
begin
  Inherited Create(WebAPIUtils);
  m_Group := TRsLCGroup.Create(WebAPIUtils);
  m_Order := TRsLCOrderPlate.Create(WebAPIUtils);
  m_Named := TRsLCNamedPlate.Create(WebAPIUtils);
  m_Together := TRsLCTogetherPlate.Create(WebAPIUtils);
  m_Trainman := TRsLCBoardTrainman.Create(WebAPIUtils);
end;

destructor TRsLCNameBoardEx.Destroy;
begin
  m_Group.Free;
  m_Order.Free;
  m_Named.Free;
  m_Together.Free;
  m_Trainman.Free;
  inherited;
end;

procedure TRsLCNameBoardEx.QueryChangeLog(BeginTime, EndTime: TDateTime;
      Trainmanjiaolus: TStrings; ChangeType: integer;Key: string;out ChangeLogArray: TRsChangeLogArray);
      function JsonToChangelog(iJson: ISuperObject): RRsChangeLog;
      begin
        //日志GUID
        Result.strLogGUID := iJson.S['strLogGUID'];
        //人员交路GUID
        Result.strTrainmanJiaoluGUID := iJson.S['strTrainmanJiaoluGUID'];
        //人员交路名称
        Result.strTrainmanJiaoluName := iJson.S['strTrainmanJiaoluName'];
        //变动类型
        Result.nBoardChangeType := TRSLBoardChangeType(iJson.I['nBoardChangeType']);
        //变动内容
        Result.strContent := iJson.S['strContent'];
        //值班员GUID
        Result.strDutyUserGUID := iJson.S['strDutyUserGUID'];
        //值班员工号
        Result.strDutyUserNumber := iJson.S['strDutyUserNumber'];
        //值班员名称                     
        Result.strDutyUserName := iJson.S['strDutyUserName'];
        //变动时间
        Result.dtEventTime := StrToDateTime(iJson.S['dtEventTime']);
        //自增id
        Result.nid := iJson.I['nid'];
      end; 
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['dtBeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginTime);
  JSON.S['dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndTime);
  JSON.S['trainmanjiaolus'] := Trainmanjiaolus.CommaText;
  JSON.I['changeType'] := ChangeType;
  JSON.S['key'] := Key;

  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.BoardChangeLog.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(ChangeLogArray,JSON.O['Logs'].AsArray.Length);

  for I := 0 to Length(ChangeLogArray) - 1 do
  begin
    ChangeLogArray[i] := JsonToChangelog(JSON.O['Logs'].AsArray[i]);  
  end;


end;

{ TRsLCNamedGroupInputParam }

constructor TRsLCNamedGrpInputParam.Create;
begin
  m_TrainmanJiaolu := TRsLCBoardInputJL.Create;
  m_DutyUser := TRsLCBoardInputDuty.Create;
end;

destructor TRsLCNamedGrpInputParam.Destroy;
begin
  m_TrainmanJiaolu.Free;
  m_DutyUser.Free;
  inherited;
end;

{ TRsLCOrderGroupInputParam }

constructor TRsLCOrderGrpInputParam.Create;
begin
  m_TrainmanJiaolu := TRsLCBoardInputJL.Create;
  m_DutyUser := TRsLCBoardInputDuty.Create;
end;

destructor TRsLCOrderGrpInputParam.Destroy;
begin
  m_TrainmanJiaolu.Free;
  m_DutyUser.Free;
  inherited;
end;

{ TRsLCTogetherGroupInputParam }

constructor TRsLCTogetherGrpInputParam.Create;
begin
  m_TrainmanJiaolu := TRsLCBoardInputJL.Create;
  m_DutyUser := TRsLCBoardInputDuty.Create;
end;

destructor TRsLCTogetherGrpInputParam.Destroy;
begin
  m_TrainmanJiaolu.Free;
  m_DutyUser.Free;
  inherited;
end;

{ TRsLCTogetherGroup }

procedure TRsLCTogetherGroup.Add(AddParam: TRsLCTogetherGrpInputParam);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AddParam);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.AddTogetherGroup',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTogetherGroup.ChangeJl(Input: TChangeGrpJLInput);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(Input);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCNameBoard.Group.TogetherChangeJL',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
{ TRsLCTrainmanAddInput }

constructor TRsLCTrainmanAddInput.Create;
begin
  m_TrainmanJiaolu := TRsLCBoardInputJL.Create;
  m_DutyUser := TRsLCBoardInputDuty.Create;
end;

destructor TRsLCTrainmanAddInput.Destroy;
begin
  m_TrainmanJiaolu.Free;
  m_DutyUser.Free;
  inherited;
end;

{ TRsLCBoardInputJL }

procedure TRsLCBoardInputJL.AssignTo(Dest: TPersistent);
begin
  TRsLCBoardInputJL(Dest).m_jiaoluID := m_jiaoluID;
  TRsLCBoardInputJL(Dest).m_jiaoluName := m_jiaoluName;
  TRsLCBoardInputJL(Dest).jiaoluType := m_jiaoluType;
end;

procedure TRsLCBoardInputJL.SetTrainmanJL(JiaoLu: RRsTrainmanJiaolu);
begin
  m_jiaoluID := JiaoLu.strTrainmanJiaoluGUID;
  m_jiaoluName := JiaoLu.strTrainmanJiaoluName;
  m_jiaoluType := Ord(JiaoLu.nJiaoluType);
end;

{ TRsLCBoardInputDuty }

procedure TRsLCBoardInputDuty.AssignTo(Dest: TPersistent);
begin
  TRsLCBoardInputDuty(Dest).m_strDutyGUID := m_strDutyGUID;
  TRsLCBoardInputDuty(Dest).m_strDutyNumber := m_strDutyNumber;
  TRsLCBoardInputDuty(Dest).m_strDutyName := m_strDutyName;
end;

{ RNameBoardCondition }

procedure RNameBoardCondition.Init;
begin
  strTrainmanJiaoluGUID := '';
  strTrainmanNumber := '';
  strTrainmanName := '';
  strJP := '';
end;

function RNameBoardCondition.ToSQL: string;
begin
  Result := 'where (1=1) ';

  if strTrainmanJiaoluGUID <> '' then
    Result := Result + ' and strTrainmanJiaoluGUID = ' + QuotedStr(strTrainmanJiaoluGUID);

  if strTrainmanNumber <> '' then
    Result := Result +
      Format(' and (strTrainmanNumber1 = %0:s or strTrainmanNumber2 = %0:s or strTrainmanNumber3 = %0:s or strTrainmanNumber4 = %0:s)',[QuotedStr(strTrainmanNumber)]);

  if strTrainmanName <> '' then
    Result := Result +
    Format(' and (strTrainmanName1 = %0:s or strTrainmanName2 = %0:s or strTrainmanName3 = %0:s or strTrainmanName4 = %0:s)',[QuotedStr(strTrainmanNumber)]);
end;
{ TChangeGrpJLInput }

constructor TChangeGrpJLInput.create;
begin
  m_SrcJiaolu := TRsLCBoardInputJL.Create;
  m_DestJiaolu := TRsLCBoardInputJL.Create;
  m_DutyUser := TRsLCBoardInputDuty.Create;
end;

destructor TChangeGrpJLInput.Destroy;
begin
  m_SrcJiaolu.Free;
  m_DestJiaolu.Free;
  m_DutyUser.Free;
  inherited;
end;

{ TRsLCGroupTX }

procedure TRsLCGroupTX.Add(TrainmanJiaolu: TRsLCBoardInputJL;
  DutyUser: TRsLCBoardInputDuty; GroupGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  if DutyUser <> nil then  
    JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);
    
  if TrainmanJiaolu <> nil then  
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.TX.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCGroupTX.Del(TrainmanJiaolu: TRsLCBoardInputJL;
  DutyUser: TRsLCBoardInputDuty; GroupGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['GroupGUID'] := GroupGUID;
  if DutyUser <> nil then  
    JSON.O['DutyUser'] := TJsonSerialize.Serialize(DutyUser);
    
  if TrainmanJiaolu <> nil then  
  JSON.O['TrainmanJiaolu'] := TJsonSerialize.Serialize(TrainmanJiaolu);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.TX.Del',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCGroupTX.Get(TrainmanJLGUID: string; out Groups: TRsGroupArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  i: integer;
begin
  JSON := SO;
  JSON.S['JLGuid'] := TrainmanJLGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCGroup.TX.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);


  SetLength(Groups,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    Groups[i] := TRsLCGroup.JsonToGroup(JSON.AsArray[i]);
  end;

  
end;

end.
