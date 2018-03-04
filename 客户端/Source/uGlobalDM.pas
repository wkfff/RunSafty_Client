unit uGlobalDM;

interface

uses
  Windows, SysUtils, Classes, DB, ADODB,Forms,Messages,uDutyUser, uTFDBAutoConnect,
  StdCtrls,RzTray,uTFSystem,uSite,ZKFPEngXControl_TLB,MMSystem,uRsStepBase,
  uApparatus,ZKFPEngXUtils,uTrainman, AdvGrid,
  Graphics,jpeg,Variants,ExtCtrls,uTFVariantUtils,  XMLDoc, XMLIntf,
  CommCtrl,uTFSqlConn,uTFMessageComponent, RzCommon, uConnAccess,IdHTTP,uLogManage,
  DBXpress, WideStrings, SqlExpr
  ,uApparatusCommon,uDutyPlace,uBaseWebInterface,StrUtils,uHttpWebAPI,uLCCommon,
  uLCTrainmanMgr, RzLaunch,uEmbeddedPageInMenu,uFingerCtls,
  RsLibHelper;

const
  StrGridVisibleFile = 'FormColVisibles.ini';
  HISTROYFILE = 'histroy.ini';

  DRINK_TEST_CHU_QIN = 2 ;	  //出勤测酒
  DRINK_TEST_TUI_QIN = 3 ;	  //退勤测酒
  DRINK_TEST_IN_ROOM = 4 ;	  //外公寓入寓测酒
  DRINK_TEST_OUT_ROOM = 5 ;	  //外公寓出寓测酒
  DRINK_TEST_OUTER_SIDE = 6 ;	  //外段测酒
  DRINK_TEST_TEST      = 7 ;    //测试测酒
  DRINK_TEST_HAND_WORK = 10	; //手工测酒

const
  WM_MSGFingerCapture = WM_User + 11;
  WM_MSGFingerEnorll = WM_USER + 12;
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;

  
  //切换消息函数
  WM_MSG_ExchangeModule = WM_User + 111;
  //重新登录系统消息函数
  WM_MSG_ReloginSystem = WM_User + 112;
  
type

  RLogUserInfo = record
    strDutyNumber:string;
    strDutyUserGUID:string;
    strDutyUserName:string;
    strSiteGUID:string;
    strSiteName:string;
    strWorkShopGUID:string;
  end;

  TGlobalDM = class(TDataModule)
    FrameController: TRzFrameController;
    tmrAppVersion: TTimer;
    GSCLConnection: TADOConnection;
    TicketConnection: TSQLConnection;
    LocalADOConnection: TADOConnection;
    RzLauncher: TRzLauncher;

    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure tmrAppVersionTimer(Sender: TObject);
  private
    { Private declarations }
    m_RsLCCommon: TRsLCCommon;
    m_RsLCTrainmamMgr: TRsLCTrainmanMgr;
    //WEB地址
    m_strWebHost: string;
    //测酒照片上传地址
    m_strWebDrinkImgPage: string;
    //消息页面地址
    m_strWebMessagePage: string;
    m_OnAppVersionChange: TNotifyEvent;
    m_strCurrentVersion: string;
    m_strGetNewVersionUrl: string;
    m_strProjectID: string;
    //本地站点配置信息
    FPlanEditEable: string;    
    FBeginWorkRightBottomShow: string;
    FBeginWorkValidateShow: string;
    FOutWorkHours: string;
    m_WebAPIUtils: TWebAPIUtils;
    m_EmbeddedCtl: TEmbeddedCtl;   

    m_FingerPrintCtl: TFingerPrintCtl;
  private
    procedure OnMessageError(strErr: string);
    {功能:获取本地工作站名}
    function GetLocalSiteName: string;
    {功能:设置本地工作站名}
    procedure SetLocalSiteName(const Value: string);
    
    function GetAppPath: string;
    function GetShowPlanStartTime: string;
    procedure SetShowPlanStartTime(const Value: string);
    function GetConfigFileName: string;
    function GetSiteNumber: string;
    procedure SetSiteNumber(const Value: string);
    function GetBeginWorkRightBottomShow: Boolean;
    function GetBeginWorkValidateShow: Boolean;   
    function GetPlanEditEable: Boolean;
    procedure SetSelectedTrainmanJiaolus(const Value: TStringArray);
    procedure SetNameplateTrainmanJiaolu(const Value: string);
    function GetNameplateTrainmanJiaolu: string;
    function GetOutWorkHours: word;
    function GetNoPlanTestDrink: boolean;
    function GetGSCL2005Url: string;

    //是否使用饭票
    function  GetUsesMealTicket:boolean;
    procedure SetUsesMealTicket(AUses:boolean);

    function GetRoomRemind: boolean;
    procedure SetRoomRemind(Value: Boolean);

    //是否启用删除功能
    function  GetUsesDelGroup():boolean;
    procedure SetUsesDelGroup(AUses:boolean);
    function GetUsesOutWorkSign: Boolean;
    procedure SetOutWorkSign(const Value: Boolean);
    function GetShowSignPlanStartTime: TDateTime;
    procedure SetShowSignPlanStartTime(const Value: TDateTime);
    function GetUsesGoodsRange: boolean;
    procedure SetUsesGoodsRange(const Value: boolean);
    function GetGuideGroupGUID: string;
    procedure SetGuideGroupGUID(const Value: string);
    function GetSendPlanNotceMin: Integer;
    procedure SetSendPlanNotceMin(const Value: Integer);
    function GetDLRARUpdateTime: TDatetime;
    function GetUsesPrintDL: Boolean;
    procedure SetDLRARUpdateTime(const Value: TDatetime);
    procedure SetUsesPrintDL(const Value: Boolean);
    function GetDLFTPConfig: RFTPConfig;
    procedure SetDLFTPConfig(const Value: RFTPConfig);

  private
    m_SiteConfigs: TStrings;
     //配置的数据库连接参数
    m_SQLConfig : TSQLConfig;
    //运行记录数据库连接
    m_GSCLSQLConfig : TSQLConfig;
    //本地数据库连接参数
    m_SQLConfig_Local :TSQLConfig;
    m_strSiteNumberMem : string ;
    m_TicketNumberLen: integer;


    function GetPrintModuleFile: string;
    function GetSelectPrintModule: boolean;
    procedure SetPrintModuleFile(const Value: string);
    procedure SetSelectPrintModule(const Value: boolean);
    function GetUseFinger: Boolean;
    procedure SetUserFinger(const Value: Boolean);
  public
    { Public declarations }
    // 当前岗位
    CurrentModule : TRsSiteJob;
    //当前客户端的岗位
    SiteInfo : TRsSiteInfo;
    //当前客户端的出勤点
    DutyPlace :  RRsDutyPlace ;
    //当前登录值班员信息
    DutyUser : TRsDutyUser;
    MsgHandle : THandle;
    TFMessageCompnent: TTFMessageCompnent;
    LogManage: TLogManage;
    FunModuleManager: TRsFunModuleManager;
    //日志信息
    LogUserInfo:RLogUserInfo;
    
  public

    //是否处于连接状态
    function IsConnected():boolean ;
    //加载本地配置信息
    procedure LoadConfig;
    procedure LoadDB_Config(); 
    procedure LoadSiteConfig;
    //连接本地数据库
    function ConnectLocalDB(strDatabase: WideString=''):Boolean;
    //连接饭票数据库
    function ConnectMealDB(out ErrTxt:string):Boolean;

    procedure ConnectLocal_SQLDB;
     //获取远程服务器当前时间
    function  GetNow : TDateTime;
    //获取指定时间的时间范围
    procedure GetTimeSpan(SourceTime : TDateTime;out BeginTime : TDateTime;out EndTime : TDateTime);

    //获取派班室最后一次选择的人员交路信息
    function GetSelectedTrainmanJiaolus : TStringArray;
    // 取汉字的拼音
    function GetHzPy(const AHzStr: AnsiString): AnsiString;
    //从TAB_System_Config表取配置信息
    function DB_SysConfig(const SectionName,Ident: string): string;
    function SetDBSysConfig(const SectionName, Ident, Value: string): boolean;
    //播放语音文件
    procedure PlaySoundFile(SoundFile: string);
    //一直播放声音
    procedure PlaySoundFileLoop(SoundFile: string);
    //停止播放声音
    procedure StopPlaySound();


    function ReadHistroy(Section,Ident: string): string;
    procedure WriteHistroy(Section,Ident,Value: string);
    //获取网站新接口
    function  GetWebApiHost():string;
    //设置网站新接口
    procedure SetWebApiHost(Host:string);
    //获取网站和客户端的对接接口
    function GetWebUrl():string;
    {调度端的计划属于哪个出勤点
    导入计划所用
    }
    //设置出勤点
    procedure SetPlanDutyPlaceID(PlaceID:string);
    //获取出勤点
    function GetPlanDutyPlaceID():string;

    //是否使用本地声音播放测酒仪音乐
    function  IsUseLocalDrinkSound():boolean;
    //是否是本段人员 [比较工号的前两位和SITEIP的前两位]
    function bLocalAreaTrainman(strTrainmanNumber: string): Boolean;
  public
    function HttpConnConfig: RInterConnConfig;
    procedure UpdateConfigFile();
    //保存表格列宽
    procedure SaveGridColumnWidth(Grid: TAdvStringGrid);
    //设置表格列宽
    procedure SetGridColumnWidth(Grid: TAdvStringGrid);
    //保存表格列可视
    procedure SaveGridColumnVisible(Grid: TAdvStringGrid);
    //设置表格列可视
    procedure SetGridColumnVisible(Grid: TAdvStringGrid);
    //查询服务器是否有升级包
    function GetUpdateInfo(): boolean;
    //气泡提示的创建与释放
    function CreateHint(hWnd: Cardinal; Text: string; Pos: TPoint): Cardinal;
    procedure DestroyHint(var hHint: Cardinal);
    procedure ReinitFinger();
    function IniConfig(Section,Ident: string): string;
  public
    property TicketNumberLen: integer read m_TicketNumberLen write m_TicketNumberLen;
    {本地工作站名}
    property LocalSiteName : string read GetLocalSiteName write SetLocalSiteName;
    //应用程序根路径
    property AppPath : string read GetAppPath;
    //数据库连接
    property SQLConfig : TSQLConfig read m_SQLConfig write m_SQLConfig;
    property GSCLSQLConfig : TSQLConfig read m_GSCLSQLConfig;
    property ConfigFileName : string read GetConfigFileName;

         //本地数据库连接
    property SQLConfig_Local :TSQLConfig read m_SQLConfig_Local write m_SQLConfig_Local;
    //上一次的计划显示开始时间
    property ShowPlanStartTime : string read GetShowPlanStartTime write SetShowPlanStartTime;
    //当前工作站的工号
    property SiteNumber  : string read GetSiteNumber write SetSiteNumber;
    //当前内存中的工作站工号
    property SiteNumberMem  : string read m_strSiteNumberMem write m_strSiteNumberMem;
    //是否退勤无计划测酒
    property NoPlanTestDrink : boolean read GetNoPlanTestDrink;
    //当前派班显示勾选的人员交路
    property SelectedTrainmanJiaolus : TStringArray read GetSelectedTrainmanJiaolus
      write SetSelectedTrainmanJiaolus;
    //名牌中选中的人员交路
    property NameplateTrainmanJiaolu : string read GetNameplateTrainmanJiaolu write
      SetNameplateTrainmanJiaolu;                
    //出勤测酒窗口右下角显示
    property BeginWorkRightBottomShow: Boolean read GetBeginWorkRightBottomShow;
    property BeginWorkValidateShow: Boolean read GetBeginWorkValidateShow;
    //超劳提醒时长
    property OutWorkHours : word read GetOutWorkHours;
    //允许派班端编辑计划
    property PlanEditEable : Boolean read GetPlanEditEable;

    property WebHost: string read GetWebApiHost write SetWebApiHost;
    property WebDrinkImgPage: string read m_strWebDrinkImgPage;
    property WebMessagePage: string read m_strWebMessagePage;
    property WebAPIUtils: TWebAPIUtils read m_WebAPIUtils;

    property OnAppVersionChange: TNotifyEvent read m_OnAppVersionChange write m_OnAppVersionChange;
    property GSCL2005Url: string read GetGSCL2005Url;
    property UsesMealTicket:boolean  read GetUsesMealTicket write SetUsesMealTicket;
    property UsesDelGroup:boolean read GetUsesDelGroup write SetUsesDelGroup;
    property DutyPlaceID:string read GetPlanDutyPlaceID write SetPlanDutyPlaceID;
    property RoomRemind: Boolean read GetRoomRemind write SetRoomRemind;

    property UsesOutWorkSign :Boolean read GetUsesOutWorkSign write SetOutWorkSign;
    property ShowSignPlanStartTime:TDateTime read GetShowSignPlanStartTime write SetShowSignPlanStartTime;
    property UsesGoodsRange:boolean  read GetUsesGoodsRange write SetUsesGoodsRange;
    property GuideGroupGUID : string read GetGuideGroupGUID write SetGuideGroupGUID ;
    property SendPlanNoticeMin:Integer read GetSendPlanNotceMin write SetSendPlanNotceMin;

    property UsesPrintDL :Boolean read GetUsesPrintDL write SetUsesPrintDL;
    property dtDLRARUpdate:TDatetime read GetDLRARUpdateTime write SetDLRARUpdateTime ;
    property DLFTPConfig:RFTPConfig read GetDLFTPConfig write SetDLFTPConfig;
    property EmbeddedCtl: TEmbeddedCtl read m_EmbeddedCtl;
    property FingerPrintCtl: TFingerPrintCtl read m_FingerPrintCtl;
    property SiteConfigs: TStrings read m_SiteConfigs;
    property RemeberPrintModule : boolean read GetSelectPrintModule write SetSelectPrintModule;
    property PrintModuleFile : string read GetPrintModuleFile write SetPrintModuleFile;
    property UseFinger: Boolean read GetUseFinger write SetUserFinger;
  end;
  {功能:检查摄像头是否安装}
  function WebcamExists():Boolean;

 
var
  GlobalDM: TGlobalDM;
implementation
uses
  iniFiles,DSUtil,DirectShow9,DateUtils,uModuleExchange, superobject,
  uMealTicketConfig, ufrmReadFingerprintTemplates;
var
  g_ModleExchange : TModuleExchange;
{$R *.dfm}

  {功能:检查摄像头是否安装}
  function WebcamExists():Boolean;
    //功能:检查摄像头是否安装
  var
    CapEnum : TSysDevEnum;
  begin
    Result := False;
    CapEnum := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    try
      if CapEnum.CountFilters > 0 then
        Result := True;
    finally
    end;
    CapEnum.Free;
  end;




function TGlobalDM.bLocalAreaTrainman(strTrainmanNumber: string): Boolean;
begin
  result := False;
  if LeftStr(strTrainmanNumber,2) = LeftStr(Self.SiteNumber,2) then
  begin
    result := True;
  end;
end;



function TGlobalDM.ConnectLocalDB(strDatabase: WideString=''):Boolean;
var
  strConnection: string;
begin
  result := false;
  if LocalADOConnection.Connected then LocalADOConnection.Connected := false;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'RunSafty.mdb';
  strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  try
    LocalADOConnection.Close;
    LocalADOConnection.ConnectionString := strConnection;
    LocalADOConnection.Open;
  except
  end;
  if LocalADOConnection.Connected then
    result := true;
end;

procedure TGlobalDM.ConnectLocal_SQLDB;
begin
  if LocalADOConnection.Connected then
    LocalADOConnection.Connected := false;
  LocalADOConnection.ConnectionString := m_SQLConfig_Local.ConnString;
  LocalADOConnection.LoginPrompt := false;
  LocalADOConnection.KeepConnection := true;
  LocalADOConnection.Connected := true;
end;

function TGlobalDM.ConnectMealDB(out ErrTxt:string):Boolean;
var
  mealTicketConfigOper:TRsMealConfigOper;
  ServerConfig:RRsMealServerConfig;
  strFile:string;
  strDataBase:string;
begin
  Result := True ;
  strFile := Format('%sconfig.ini',[ExtractFilePath(Application.ExeName)]) ;
  mealTicketConfigOper := TRsMealConfigOper.Create(strFile);
  try
    try
      mealTicketConfigOper.ReadMealServerConfig(ServerConfig);
      with TicketConnection do
      begin
        if Connected then
          Connected := False ;
        //连接方法
        //192.168.1.105/3050:D:\CJGL\CJGL.DAT
        //'172.17.2.10:c:\db\myDb.fdb'
        strDataBase := format('%s:%s',[ServerConfig.strServerIp,ServerConfig.strDataLocation]);
        Params.Values['Database']:= strDataBase ;
        Params.Values['User_Name']:= ServerConfig.strServerUser;
        Params.Values['Password']:= ServerConfig.strServerPass;
        Connected := True ;
      end;
    except
      on e:Exception do
      begin
        Result := False;
        ErrTxt := e.Message;

      end;
    end;
  finally
    mealTicketConfigOper.Free;
  end;
end;


function GetURLHost(url: string): string;
var
  nIndex: integer;
begin
  url := LowerCase(Trim(url));
  nIndex := Pos('http://',url);
  if nIndex > 0 then
  begin
    Result := Copy(url,nIndex + 7,Length(url) - nIndex - 6);

    nIndex := Pos(':',Result);
    if nIndex > 0 then
    begin
      Result := Copy(Result,1,nIndex - 1 );
    end;
  end
  else
    Result := '';
end;

function GetUrlPort(url: string): integer;
var
  nIndex: integer;
begin
  url := LowerCase(Trim(url));
  nIndex := Pos('http://',url);
  if nIndex > 0 then
  begin
    url := Copy(url,nIndex + 7,Length(url) - nIndex - 6);
    nIndex := Pos(':',url);
    if nIndex > 0 then
    begin
      url := Copy(url,nIndex + 1,length(url) - nIndex);
      Result := StrToIntDef(url,80);
    end
    else
      Result := 80;

  end
  else
    Result := 80;
end;


procedure TGlobalDM.DataModuleCreate(Sender: TObject);
begin
  m_SiteConfigs := TStringList.Create;
  g_ModleExchange := TModuleExchange.Create(1);
  LogManage := TLogManage.Create;
  MsgHandle := g_ModleExchange.MsgHandle;
  m_SQLConfig := TSQLConfig.Create(AppPath + 'config.ini','SQLCONFIG');
  m_GSCLSQLConfig := TSQLConfig.Create(AppPath + 'config.ini','GSCLSQLCONFIG');
	 
  m_SQLConfig_Local := TSQLConfig.Create(AppPath + 'config.ini','SQLCONFIG_LOCAL');

  TFMessageCompnent := TTFMessageCompnent.Create(ASynMode);
  FunModuleManager := TRsFunModuleManager.Create(nil);
  TFMessageCompnent.ConnectTimeOut := 3000;
  TFMessageCompnent.Period := 2000;
  TFMessageCompnent.OnError := OnMessageError;
  TFMessageCompnent.LocalTempPath := AppPath;
  LogManage.FileNamePath := AppPath + 'Log\';
  m_WebAPIUtils := TWebAPIUtils.Create();

  m_WebAPIUtils.Host := GetURLHost(GetWebApiHost);
  m_WebAPIUtils.Port := GetUrlPort(GetWebApiHost);
  m_RsLCTrainmamMgr := TRsLCTrainmanMgr.Create(WebAPIUtils);
  m_RsLCCommon := TRsLCCommon.Create('','','');
  m_EmbeddedCtl := TEmbeddedCtl.Create;
  m_FingerPrintCtl := TFingerPrintCtl.Create(AppPath,WebAPIUtils);
  m_FingerPrintCtl.SetSyncLogCallBack(LogManage.InsertLog);
end;

procedure TGlobalDM.DataModuleDestroy(Sender: TObject);
begin
  g_ModleExchange.Free;
  m_SQLConfig.Free;
  m_SQLConfig_Local.Free;
   if DutyUser <> nil then
     FreeAndNil(DutyUser);
   if SiteInfo <> nil then
     FreeAndNil(SiteInfo);
  TFMessageCompnent.Free;
  LogManage.Free;
  FunModuleManager.Free;

  m_GSCLSQLConfig.free;

  m_WebAPIUtils.Free;
  m_RsLCCommon.Free;
  m_RsLCTrainmamMgr.Free;
  m_EmbeddedCtl.Free;
  m_FingerPrintCtl.Free;
  m_SiteConfigs.Free;

end;

function TGlobalDM.DB_SysConfig(const SectionName, Ident: string): string;
var
  ErrInfo: string;
begin
  Result := m_RsLCCommon.GetDBSysConfig(SectionName, Ident, ErrInfo);
end;

function TGlobalDM.SetDBSysConfig(const SectionName, Ident, Value: string): boolean;
var
  ErrInfo: string;
begin
  m_RsLCCommon.SetConnConfig(HttpConnConfig);
  Result := m_RsLCCommon.SetDBSysConfig(SectionName, Ident, Value,ErrInfo);
  if not Result then
    Raise Exception.Create(ErrInfo);
end;

procedure TGlobalDM.SetDLFTPConfig(const Value: RFTPConfig);
begin
  WriteIniFile(ConfigFileName,'DLFTP','strHost',Value.strHost);
  WriteIniFile(ConfigFileName,'DLFTP','nPort',IntToStr(Value.nPort));
  WriteIniFile(ConfigFileName,'DLFTP','strDir',Value.strDir);
  WriteIniFile(ConfigFileName,'DLFTP','strUserName',Value.strUserName);
  WriteIniFile(ConfigFileName,'DLFTP','strPassWord',Value.strPassWord);
end;

procedure TGlobalDM.SetDLRARUpdateTime(const Value: TDatetime);
var
  strTime:string;
begin
  strTime := FormatDateTime('yyyy-mm-dd HH:nn:ss', Value);
  WriteIniFile(ConfigFileName,'SysConfig','DDMLRARUpdateTime',strTime);
end;

procedure TGlobalDM.SetPlanDutyPlaceID(PlaceID: string);
begin
  WriteIniFile(ConfigFileName,'UserData','PlanDutyPlaceID',PlaceID);
end;

procedure TGlobalDM.SetPrintModuleFile(const Value: string);
begin
  WriteIniFile(ConfigFileName,'UserData','PrintModuleFile',Value);
end;

procedure TGlobalDM.SetRoomRemind(Value: Boolean);
begin
  if Value then
    WriteIniFile(ConfigFileName,'SysConfig','RoomRemind','1')
  else
    WriteIniFile(ConfigFileName,'SysConfig','RoomRemind','0');
end;

procedure TGlobalDM.LoadSiteConfig();
var
   ErrInfo: string;
  NameValueList: TRsNameValueList;
  I: Integer;
begin
  m_RsLCCommon.SetConnConfig(HttpConnConfig);
  if not m_RsLCCommon.GetSiteConfig(SiteNumber,NameValueList,ErrInfo) then
  begin
    Box(ErrInfo);
    Exit;
  end;

  for I := 0 to Length(NameValueList) - 1 do
  begin
    //后增加保存全部配置
    m_SiteConfigs.Values[NameValueList[i].strName] := NameValueList[i].strValue;

    if NameValueList[i].strName = 'PlanEditEable' then FPlanEditEable := NameValueList[i].strValue
    else if NameValueList[i].strName = 'BeginWorkRightBottomShow' then FBeginWorkRightBottomShow := NameValueList[i].strValue
    else if NameValueList[i].strName = 'BeginWorkValidateShow' then FBeginWorkValidateShow := NameValueList[i].strValue
    else if NameValueList[i].strName = 'OutWorkHours' then FOutWorkHours := NameValueList[i].strValue;
  end;



  if FPlanEditEable = '' then FPlanEditEable := '0';    
  if FBeginWorkRightBottomShow = '' then FBeginWorkRightBottomShow := '1';
  if FBeginWorkValidateShow = '' then FBeginWorkValidateShow := '1';
  if FOutWorkHours = '' then FOutWorkHours := '17';

end;

function TGlobalDM.GetAppPath: string;
begin
   Result := ExtractFilePath(Application.ExeName)
end;

function TGlobalDM.GetBeginWorkRightBottomShow: Boolean;
begin
  Result := (FBeginWorkRightBottomShow = '1');
end;

function TGlobalDM.GetBeginWorkValidateShow: Boolean;
begin
  Result := (FBeginWorkValidateShow = '1');
end;

function TGlobalDM.GetPlanEditEable: Boolean;
begin
  Result := (FPlanEditEable = '1');
end;

function TGlobalDM.GetPrintModuleFile: string;
begin
    result :=  ReadIniFile(ConfigFileName,'UserData','PrintModuleFile');
end;

function TGlobalDM.GetRoomRemind: boolean;
var
  strUses:string;
begin
  strUses := ReadIniFile(ConfigFileName,'SysConfig','RoomRemind');
  Result := strUses = '1';
end;

function TGlobalDM.GetConfigFileName: string;
begin
  result := ExtractFilePath(Application.ExeName) + 'Config.ini';
end;

function TGlobalDM.GetDLFTPConfig: RFTPConfig;
var
  strTemp:string;
begin
  result.strHost := ReadIniFile(ConfigFileName,'DLFTP','strHost');
  strTemp:= ReadIniFile(ConfigFileName,'DLFTP','nPort');
  if TryStrToInt(strTemp,Result.nPort) = False then
    result.nPort := 21;
  result.strDir := ReadIniFile(ConfigFileName,'DLFTP','strDir');
  result.strUserName := ReadIniFile(ConfigFileName,'DLFTP','strUserName');
  Result.strPassWord := ReadIniFile(ConfigFileName,'DLFTP','strPassWord');
end;

function TGlobalDM.GetDLRARUpdateTime: TDatetime;
var
  strTime:string;
begin
  Result := 0 ;
  strTime := ReadIniFile(ConfigFileName,'SysConfig','DDMLRARUpdateTime');
  if strTime = '' then
    Exit
  else
    Result := strToDateTime(strTime);
end;

function TGlobalDM.GetPlanDutyPlaceID: string;
begin
  Result := ReadIniFile(ConfigFileName,'UserData','PlanDutyPlaceID') ;
end;

function TGlobalDM.GetGSCL2005Url: string;
begin
 result := ReadIniFile(GlobalDM.AppPath + 'Config.ini','GSCL2005','URLHost');
end;

function TGlobalDM.GetGuideGroupGUID: string;
begin
  result := ReadIniFile(ConfigFileName,'SysConfig','GuideGroupGUID');
end;

function TGlobalDM.GetHzPy(const AHzStr: AnsiString): AnsiString;
const
  ChinaCode: array[0..25, 0..1] of Integer = ((1601, 1636), (1637, 1832), (1833, 2077),
    (2078, 2273), (2274, 2301), (2302, 2432), (2433, 2593), (2594, 2786), (9999, 0000),
    (2787, 3105), (3106, 3211), (3212, 3471), (3472, 3634), (3635, 3722), (3723, 3729),
    (3730, 3857), (3858, 4026), (4027, 4085), (4086, 4389), (4390, 4557), (9999, 0000),
    (9999, 0000), (4558, 4683), (4684, 4924), (4925, 5248), (5249, 5589));
var
  i, j, HzOrd: Integer;
begin
  Result := '';
  i := 1;
  while i <= Length(AHzStr) do
  begin
    if (AHzStr[i] >= #160) and (AHzStr[i + 1] >= #160) then
    begin
      HzOrd := (Ord(AHzStr[i]) - 160) * 100 + Ord(AHzStr[i + 1]) - 160;
      for j := 0 to 25 do
      begin
        if (HzOrd >= ChinaCode[j][0]) and (HzOrd <= ChinaCode[j][1]) then
        begin
          Result := Result + AnsiChar(Byte('A') + j);
          Break;
        end;
      end;
      Inc(i);
    end else Result := Result + AHzStr[i];
    Inc(i);
  end;
end;

function TGlobalDM.GetNameplateTrainmanJiaolu: string;
begin
  Result := ReadIniFile(ExtractFilePath(Application.ExeName) + 'Config.ini',
    'UserData','NameplateTrainmanJiaolu');
end;

function TGlobalDM.GetLocalSiteName: string;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    Result := trim(ini.ReadString('SysConfig','LocalSiteName',''));
  finally
    ini.Free;
  end;
end;
   
procedure TGlobalDM.SetLocalSiteName(const Value: string);
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    ini.WriteString('SysConfig','LocalSiteName',Value);
  finally
    ini.Free;
  end;
end;

function TGlobalDM.GetNoPlanTestDrink: boolean;
var
  strResult: string;
begin
  strResult := ReadIniFile(ExtractFilePath(Application.ExeName) + 'Config.ini',
    'UserData','NoPlanTestDrink');
  Result := (strResult = '1');  
end;

function TGlobalDM.GetNow: TDateTime;
var
  ErrInfo: string;
begin
  Result := m_RsLCCommon.GetNow(ErrInfo);
end;


function TGlobalDM.GetSelectedTrainmanJiaolus: TStringArray;
var
  jiaolus : string;
  strsTemp : TStringList;
  i: Integer;
begin
  jiaolus :=  ReadIniFile(ConfigFileName,'UserData','SelectedTrainmanJiaolus');
  strsTemp := TStringList.Create;
  try
    strsTemp.Delimiter := ',';
    strsTemp.DelimitedText := jiaolus;
    SetLength(result,strsTemp.Count);
    for i := 0 to strsTemp.count - 1 do
    begin
      result[i] := strsTemp[i];
    end;
  finally
    strsTemp.Free;
  end;
end;

function TGlobalDM.GetSelectPrintModule: boolean;
var
  strTemp : string;
  bTemp : boolean;
begin
  Result := false;
  strTemp := ReadIniFile(ConfigFileName,'UserData','SelectPrintModule');
  if TryStrToBool(strTemp,bTemp) then
  begin
    result := bTemp;
  end;
end;


function TGlobalDM.GetSendPlanNotceMin: Integer;
var
  strMin:string;
begin
  Result := 0 ;
  strMin := ReadIniFile(ConfigFileName,'SysConfig','SendPlanNotceMin');
  if strMin = '' then
    Exit
  else
    Result := StrToInt(strMin);
end;

function TGlobalDM.GetShowPlanStartTime: string;
var
  dtTemp : TDateTime;
begin
  dtTemp := IncHour(GlobalDM.GetNow,-1) ;
  result := Formatdatetime('yyyy-MM-dd HH:00:00',dtTemp) ;
end;

function TGlobalDM.GetShowSignPlanStartTime: TDateTime;
var
  strTemp : string;
  dtTemp : TDateTime;
begin
  result := DateOf(self.GetNow());
  strTemp := ReadIniFile(ConfigFileName,'UserData','ShowSignPlanStartTime');
  if TryStrToDateTime(strTemp,dtTemp) then
  begin
    result := dtTemp;
  end;
end;

function TGlobalDM.GetSiteNumber: string;
begin
  result := ReadIniFile(ConfigFileName,'UserData','SiteNumber');
end;

procedure TGlobalDM.GetTimeSpan(SourceTime: TDateTime; out BeginTime,
  EndTime: TDateTime);
begin
  BeginTime := IncHour(dateof(SourceTime)-1, 18);
  EndTime := IncMinute(IncDay(dateOf(SourceTime), 1), 17 * 60 + 59)
end;

function TGlobalDM.IniConfig(Section, Ident: string): string;
begin
  Result := ReadIniFile(AppPath + 'Config.ini',Section,Ident)
end;



function TGlobalDM.IsConnected: boolean;
var
  strResult : string;
  http:TIdHTTP;
begin
  Result := False ;
  http := TIdHTTP.Create(nil);
  try
    try
      with http do
      begin
        ConnectTimeout := 5000 ;
        Request.Pragma := 'no-cache';
        Request.CacheControl := 'no-cache';
        Request.Connection := 'close';
        strResult := http.Get(GetWebApiHost) ;
        strResult := Utf8ToAnsi(strResult);
        Result := True ;
      end;
    except
      on e:Exception do
      begin
        strResult := e.Message ;
      end;
    end;
  finally
    http.Free;
  end;
end;

function TGlobalDM.IsUseLocalDrinkSound: boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'UserData','IsUseLocalDrinkSound');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

procedure TGlobalDM.LoadConfig;
var
  ini : TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
      m_SQLConfig.Load;
      m_SQLConfig_Local.Load;
      m_GSCLSQLConfig.Load;

      TFMessageCompnent.ClientID := ini.ReadString('TFMessage','ClientID','');
      //TFMessageCompnent.ClientID := ini.ReadString('UserData','SiteNumber','');

      if FileExists(AppPath + 'Update.ini') then
      begin
        m_strGetNewVersionUrl := ReadIniFile(AppPath + 'Update.ini','SysConfig','GetNewVersionUrl');
        m_strCurrentVersion := ReadIniFile(AppPath + 'Update.ini','SysConfig','ProjectVersion');
        m_strProjectID := ReadIniFile(AppPath + 'Update.ini','SysConfig','ProjectID');

      end;


  finally
    ini.Free;
  end;

  if FileExists(AppPath + 'StepConfig.xml') then
    FunModuleManager.LoadConfig(AppPath + 'StepConfig.xml');
end;

procedure TGlobalDM.LoadDB_Config;
begin
  m_strWebHost := GetWebApiHost;
  m_strWebDrinkImgPage:= DB_SysConfig('SysConfig','DrinkImgPage');
  m_strWebMessagePage:= DB_SysConfig('SysConfig','MessagePage');
  TicketNumberLen := StrToIntDef(DB_SysConfig('SysConfig','TicketNumberLen'),7);
  TFMessageCompnent.URL := m_strWebHost + m_strWebMessagePage;
end;






procedure TGlobalDM.OnMessageError(strErr: string);
begin
  LogManage.InsertLog(strErr);
end;

procedure TGlobalDM.PlaySoundFile(SoundFile: string);
begin
  if FileExists(AppPath + 'Sounds\' + SoundFile) then
    MMSystem.PlaySound(Pchar(AppPath + 'Sounds\' + SoundFile), 0,SND_FILENAME or SND_ASYNC  );
end;

procedure TGlobalDM.PlaySoundFileLoop(SoundFile: string);
begin
  if FileExists(AppPath + 'Sounds\' + SoundFile) then
    MMSystem.PlaySound(Pchar(AppPath + 'Sounds\' + SoundFile), 0,SND_FILENAME or SND_ASYNC or SND_LOOP );
end;

//==============================================================================

procedure TGlobalDM.SaveGridColumnWidth(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount, nColWidth: integer;
  strIniFile, strSection, strKey: string;
begin
  if Grid.ColumnSize.Save then exit;
  
  strIniFile := 'FormColWidths.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;

    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 0 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      nColWidth := Grid.ColWidths[grid.DisplColIndex(i)];
      Ini.WriteInteger(strSection, strKey, nColWidth);
    end;
  finally
    Ini.Free();
  end;
end;

procedure TGlobalDM.SetGridColumnWidth(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount, nColWidth: integer;
  strIniFile, strSection, strKey: string;
begin
  if Grid.ColumnSize.Save then exit;
  
  strIniFile := 'FormColWidths.ini';
  strSection := Grid.ColumnSize.Section;
  if strIniFile = '' then exit;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;
//    if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 0 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      nColWidth := Ini.ReadInteger(strSection, strKey, -1);
      if nColWidth >= 0 then Grid.ColWidths[grid.DisplColIndex(i)] := nColWidth;
    end;
  finally
    Ini.Free();
  end;
end;
        
procedure TGlobalDM.SetGuideGroupGUID(const Value: string);
begin
  WriteIniFile(ConfigFileName,'SysConfig','GuideGroupGUID',Value);
end;

procedure TGlobalDM.SaveGridColumnVisible(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount: integer;
  strIniFile, strSection, strKey: string;
begin
  strIniFile := 'FormColVisibles.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  try
    nColCount := Grid.ColumnHeaders.Count;  
    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 1 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      Ini.WriteBool(strSection, strKey, not Grid.IsHiddenColumn(i));
    end;
  finally
    Ini.Free();
  end;
end;

procedure TGlobalDM.SetGridColumnVisible(Grid: TAdvStringGrid);
var
  Ini: TIniFile;
  i, nColCount: integer;
  strIniFile, strSection, strKey: string;
begin
  strIniFile := 'FormColVisibles.ini';
  strSection := Grid.ColumnSize.Section;
  if strSection = '' then exit;

  strIniFile := ExtractFilePath(Application.ExeName) + strIniFile;
  Ini:=TIniFile.Create(strIniFile);
  Grid.BeginUpdate;
  try
    nColCount := Grid.ColumnHeaders.Count;  
    //if nColCount > Grid.ColCount then nColCount := Grid.ColCount;
    for i := 1 to nColCount - 1 do
    begin
      strKey := Grid.ColumnHeaders[i];
      if strKey = '' then Continue;
      if Ini.ReadBool(strSection, strKey, True) then
        Grid.UnHideColumn(i)
      else
        Grid.HideColumn(i);
    end;
  finally
    Grid.EndUpdate;
    Ini.Free();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//功能: STRING 的内容流化到 OLEVARIANT 中
//参数：
////////////////////////////////////////////////////////////////////////////////

function TextToOleData(const AText: string): OleVariant;
var
  nSize: Integer;
  pData: Pointer;
begin
  nSize := Length(AText);
  if nSize = 0 then
    Result := Null
  else begin
    Result := VarArrayCreate([0, nSize - 1], varByte);
    pData := VarArrayLock(Result);
    try
      Move(Pchar(AText)^, pData^, nSize);
    finally
      VarArrayUnlock(Result);
    end;
  end;
end;

function TGlobalDM.ReadHistroy(Section, Ident: string): string;
begin
  Result := ReadIniFile(ExtractFilePath(Application.ExeName) + HISTROYFILE,Section,Ident);
end;

procedure TGlobalDM.ReinitFinger;
begin
  try
    if TBox('确认要重新初化指纹仪吗？') then
    begin
      if not GlobalDM.FingerPrintCtl.Init() then
      begin
        Box('初始化指纹仪失败:' + GlobalDM.FingerPrintCtl.InitError);
      end;
      FingerPrintCtl.LoadLocalTM(TFrmFinerLoadProgress.ShowProgress());
    end;

  finally
    TFrmFinerLoadProgress.CloseProgress();
  end;
end;

procedure TGlobalDM.SetNameplateTrainmanJiaolu(const Value: string);
begin
  WriteIniFile(ExtractFilePath(Application.ExeName) + 'Config.ini',
    'UserData','NameplateTrainmanJiaolu',VALUE);
end;

procedure TGlobalDM.SetOutWorkSign(const Value: Boolean);
var
  strUses:string;
begin
  if Value then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'SysConfig','UsesOutWorkSign',strUses);
end;

procedure TGlobalDM.SetSelectedTrainmanJiaolus(const Value: TStringArray);
var
  i: Integer;
  strTemp : string;
begin
  strTemp := '';
  for i := 0 to length(Value) - 1 do
  begin
    if strTemp = '' then
      strTemp := value[i]
    else
      strTemp := strTemp + ',' + value[i];
  end;
  WriteIniFile(ConfigFileName,'UserData','SelectedTrainmanJiaolus',strTemp);
end;

procedure TGlobalDM.SetSelectPrintModule(const Value: boolean);
begin
  WriteIniFile(ConfigFileName,'UserData','SelectPrintModule',BoolToStr(Value));
end;

procedure TGlobalDM.SetSendPlanNotceMin(const Value: Integer);
var
  strMin:string;
begin
  strMin := IntToStr(Value);
  WriteIniFile(ConfigFileName,'SysConfig','SendPlanNotceMin',strMin);
end;

procedure TGlobalDM.SetShowPlanStartTime(const Value: string);
begin
  WriteIniFile(ConfigFileName,'UserData','ShowPlanStartTime',Value);
end;

procedure TGlobalDM.SetShowSignPlanStartTime(const Value: TDateTime);
var
  strTemp:string;
begin
  strTemp := FormatDateTime('yyyy-mm-dd HH:nn:ss',Value);
  WriteIniFile(ConfigFileName,'UserData','ShowSignPlanStartTime',strTemp);
end;

procedure TGlobalDM.SetSiteNumber(const Value: string);
begin
  WriteIniFile(ConfigFileName,'UserData','SiteNumber',Value);
end;

procedure TGlobalDM.SetUserFinger(const Value: Boolean);
begin
  if Value  then
    WriteIniFile(ConfigFileName,'UserData','UserFinger','1')
  else
    WriteIniFile(ConfigFileName,'UserData','UserFinger','0');
end;

procedure TGlobalDM.SetUsesDelGroup(AUses: boolean);
var
  strUses:string;
begin
  if AUses then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'SysConfig','UsesDelGroup',strUses);
end;

procedure TGlobalDM.SetUsesGoodsRange(const Value: boolean);
var
  strUses:string;
begin
  if Value then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'GoodsRangeConfig','UsesGoodsRange',strUses)
end;

procedure TGlobalDM.SetUsesMealTicket(AUses: boolean);
var
  strUses:string;
begin
  if AUses then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'MealTicketConfig','UsesMealTicket',strUses)
end;

procedure TGlobalDM.SetUsesPrintDL(const Value: Boolean);
var
  strUses:string;
begin
  if Value then
    strUses := '1'
  else
    strUses := '0';
  WriteIniFile(ConfigFileName,'SysConfig','UsesPrintDL',strUses);

end;

procedure TGlobalDM.SetWebApiHost(Host: string);
var
  strUpdateIniName:string;
  strUrl:string;
begin
  WriteIniFile(ConfigFileName,'WebApi','URL',Host);

  strUpdateIniName := ExtractFilePath(Application.ExeName) + 'Update.ini';
  strUrl := Format('%s/Web接口/更新程序/GetNewVersion.ashx',[Host]);
  WriteIniFile(strUpdateIniName,'SysConfig','GetNewVersionUrl',strUrl);

end;

procedure TGlobalDM.StopPlaySound;
begin
    MMSystem.PlaySound(nil, 0,0 );
end;

function TGlobalDM.GetOutWorkHours: word;
begin
  result := StrToIntDef(FOutWorkHours, 17);
  if result <= 0 then result := 17;
end;



procedure TGlobalDM.tmrAppVersionTimer(Sender: TObject);
var
  IdHttp: TIdHttp;
  iJSON: ISuperObject;
  strHttpResult: string;
begin
  if m_strGetNewVersionUrl = '' then
    exit;
  IdHttp := TIdHTTP.Create(nil);
  try
    try
      strHttpResult := IdHttp.Get(m_strGetNewVersionUrl + Format('?pid=%s&version=%s',
        [m_strProjectID, m_strCurrentVersion]));

      IdHttp.Disconnect();

      iJSON := SO(strHttpResult);
      if iJSON.B['NeedUpdate'] then
      begin
        m_strCurrentVersion := Trim(iJSON.S['strProjectVersion']);
        if Assigned(m_OnAppVersionChange) then
          m_OnAppVersionChange(nil);
      end;
    finally
      IdHttp.Free;
    end;
  except

  end;
end;

procedure TGlobalDM.UpdateConfigFile;
begin
  RzLauncher.FileName := AppPath + 'RsConfigUpdate.exe';
  if FileExists(RzLauncher.FileName) then
  begin
    RzLauncher.Execute;
    Sleep(1000);
  end;
end;


procedure TGlobalDM.WriteHistroy(Section, Ident, Value: string);
begin
  WriteIniFile(ExtractFilePath(Application.ExeName) + HISTROYFILE,Section,Ident,Value);
end;


function TGlobalDM.GetUpdateInfo(): boolean;
var
  IdHTTP: TIdHTTP;
  iJSON: ISuperObject;
  strUrl, strUpdateInfo: string; 
  Ini: TIniFile;
  strGetNewVersionUrl, strProjectID, strProjectVersion: string;
begin
  result := false;

  if FileExists(AppPath + 'Update.ini') then
  begin
    Ini := TIniFile.Create(AppPath + 'Update.ini');
    try                  
      strGetNewVersionUrl := Trim(Ini.ReadString('SysConfig', 'GetNewVersionUrl', ''));
      strProjectID := Trim(Ini.ReadString('SysConfig', 'ProjectID', ''));
      strProjectVersion := Trim(Ini.ReadString('SysConfig', 'ProjectVersion', ''));
    finally
      Ini.Free();
    end;
  end;
  if (strGetNewVersionUrl='') or (strProjectID = '') then exit;
  
  try                       
    strUrl := strGetNewVersionUrl + Format('?pid=%s&version=%s', [strProjectID, strProjectVersion]);
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.Disconnect;
      IdHTTP.Request.Pragma := 'no-cache';
      IdHTTP.Request.CacheControl := 'no-cache';
      IdHTTP.Request.Connection := 'close';
      IdHTTP.ReadTimeout := 1000;
      IdHTTP.ConnectTimeout := 1000;
      strUpdateInfo := IdHTTP.Get(strUrl);
      strUpdateInfo := Utf8ToAnsi(strUpdateInfo);
      IdHTTP.Disconnect;
    finally
      IdHTTP.Free;
    end;
    if strUpdateInfo = '' then exit;

    iJSON := SO(strUpdateInfo);
    result := iJSON.B['NeedUpdate'];
    iJSON := nil;
  except on e : exception do
    //Box('查找服务器上的可升级包时，出现异常！'#13#10#13#10'异常信息：'+e.Message);
  end;
end;



function TGlobalDM.GetUseFinger: Boolean;
begin
  result :=  not (ReadIniFile(ConfigFileName,'UserData','UserFinger') = '0');
end;

function TGlobalDM.GetUsesDelGroup: boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'SysConfig','UsesDelGroup');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

function TGlobalDM.GetUsesGoodsRange: boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'GoodsRangeConfig','UsesGoodsRange');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

function TGlobalDM.GetUsesMealTicket: boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'MealTicketConfig','UsesMealTicket');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

function TGlobalDM.GetUsesOutWorkSign: Boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'SysConfig','UsesOutWorkSign');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

function TGlobalDM.GetUsesPrintDL: Boolean;
var
  strUses:string;
begin
  Result := False ;
  strUses := ReadIniFile(ConfigFileName,'SysConfig','UsesPrintDL');
  if strUses = '' then
    Exit
  else
    Result := StrToBool(strUses);
end;

function TGlobalDM.GetWebApiHost: string;
begin
  Result := ReadIniFile(ConfigFileName,'WebApi','URL')
end;

function TGlobalDM.GetWebUrl: string;
var
  strUrl : string;
begin
  strUrl := Format('%s/AshxService/QueryProcess.ashx?',[GetWebApiHost]);
  Result := strUrl ;
end;

function TGlobalDM.HttpConnConfig: RInterConnConfig;
begin
  Result.URL := GetWebUrl;
  if SiteInfo <> nil then
  begin
    Result.SiteID := SiteInfo.strSiteGUID;
    Result.ClientID := SiteInfo.strSiteIP;
  end;

end;

function TGlobalDM.CreateHint(hWnd: Cardinal; Text: string; Pos: TPoint): Cardinal;
var
  hHint: Cardinal;
  ti: TToolInfo;
begin
  Result := 0;
  if hWnd = 0 then exit;

  hHint := CreateWindow('Tooltips_Class32', nil, $40, 0, 0, 0, 0, 0, 0, hInstance, nil);
  if hHint > 0 then
  begin
    Result :=hHint;
    ZeroMemory(@ti, SizeOf(ti));
    ti.cbSize := SizeOf(TToolInfo);
    ti.uFlags := TTF_IDISHWND or TTF_TRACK;
    ti.hwnd := hWnd;
    ti.hInst := hInstance;
    ti.lpszText := pchar(Text);
    SendMessage(hHint, TTM_ADDTOOL, 0, Integer(@ti));
    SendMessage(hHint, TTM_SETMAXTIPWIDTH, 0, 100);
    SendMessage(hHint, TTM_TRACKPOSITION, 0, MAKELONG(Pos.X, Pos.Y)); //设置位置
    SendMessage(hHint, TTM_TRACKACTIVATE, Integer(True), Integer(@ti));
  end;
end;

procedure TGlobalDM.DestroyHint(var hHint: Cardinal);
begin
  if hHint > 0 then
  begin
    DestroyWindow(hHint);
    hHint := 0;
  end;
end;

end.
