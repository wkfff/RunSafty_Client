unit uFrmMain_ChuQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Menus, ExtCtrls, RzTabs, pngimage, StdCtrls, RzStatus,
  RzPanel, Grids, AdvObj, BaseGrid, AdvGrid, PngSpeedButton, Buttons,
  uTrainmanJiaolu,  uArea, ufrmReadFingerprintTemplates, uTFSystem, ActiveX,
  uFrmTrainmanIdentity, uFrmChuQin, RzSplit, RzButton, RzRadChk, ComCtrls,
  RzEdit,uTFVariantUtils, SyncObjs,uTrainman,
  uSaftyEnum,uTrainJiaolu,uTrainPlan,
  AdvDateTimePicker, ActnList, PngImageList, jpeg,
  uTFMessageDefine,uRunSaftyMessageDefine, AdvMenus,uFrmSelectColumn,uStrGridUtils
  , uGlobalDM, RzDTP, uConnAccess,uApparatusCommon, OleCtrls, SHDocVw,
  uDrink, AdvSplitter, ImgList,uFrmProgressEx,uLCTrainPlan,uDutyUser,
  uDDMLConfirm,uLCDDMLConfirm,uFrmBeginworkVIEW,uFrmPlanWriteSection,
   uPrintTMReport,uFrmPrintTMRpt,UFrmPrintJieShi,
  uFrmGeXingChuQin,uLCTrainmanMgr,uLCDutyUser,uLCBaseDict,uLCDrink,uLCBeginwork,uTFSkin,
  superobject,uLLCommonFun,uRoomCallRemind,uFingerCtls;
const
  TESTPICTURE_DEFAULT = 'Images\测酒照片\nophoto.jpg';
  TESTPICTURE_CURRENT = 'Images\测酒照片\DrinkTest.jpg';
const
  WM_Message_DrinkCheck = WM_User + 100;
  WM_Message_DBDiscontect = WM_User + 1001;
  WM_Message_Refresh = WM_User + 5001;
type
  TfrmMain_ChuQin = class(TForm)
    RzPanel1: TRzPanel;
    btnPhotoFingerUpdate: TPngSpeedButton;
    Panel3: TPanel;
    RzPanel3: TRzPanel;
    RzPanel2: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    RzPanel4: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miNameplate: TMenuItem;
    N2: TMenuItem;
    NExit: TMenuItem;
    btnExit: TPngSpeedButton;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    btnManulBeginWork: TPngSpeedButton;
    statusSysTime: TRzGlyphStatus;
    statusDutyUser: TRzGlyphStatus;
    statusFinger: TRzGlyphStatus;
    tmrReadTime: TTimer;
    mSysSet: TMenuItem;
    miDrinkQuery: TMenuItem;
    N6: TMenuItem;
    btnExchangeModule: TPngSpeedButton;
    Panel4: TPanel;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    miManulBeginWork: TMenuItem;
    PopupMenu: TPopupMenu;
    miPopManulBeginWork: TMenuItem;
    Label4: TLabel;
    btnRefreshPaln: TPngSpeedButton;
    N7: TMenuItem;
    ActionList1: TActionList;
    actF6: TAction;
    RzPanel6: TRzPanel;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    dtpPlanStartDate: TRzDateTimePicker;
    miPopManulImportServerDrink: TMenuItem;
    statusMatch: TRzGlyphStatus;
    statusMessage: TRzStatusPane;
    statusUpdate: TRzStatusPane;
    RzPanel5: TRzPanel;
    TimerImportDrink: TTimer;
    RzPanel7: TRzPanel;
    RzPanel10: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    RzPanel8: TRzPanel;
    RzPanel9: TRzPanel;
    btnImportDrink: TPngSpeedButton;
    grdMain: TAdvStringGrid;
    AdvSplitter1: TAdvSplitter;
    TimerScroll: TTimer;
    ImageList1: TImageList;
    btnCancelDrink: TPngSpeedButton;
    btnDeleteIgnore: TPngSpeedButton;
    btnHideDrink: TPngSpeedButton;
    actF5: TAction;
    mniN9: TMenuItem;
    mniN10: TMenuItem;
    PngImageList1: TPngImageList;
    timerPlaySound: TTimer;
    dtpPlanStartTime: TRzDateTimePicker;
    btnUploadDrinkInfo: TPngSpeedButton;
    N8: TMenuItem;
    btnImportPlan: TPngSpeedButton;
    Panel1: TPanel;
    N14: TMenuItem;
    miBeginworkFlow: TMenuItem;
    miSetWritecardSection: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    gbTrainman: TRzGroupBox;
    rzpBeginworkFlow: TRzPanel;
    RzRadioButton1: TRzRadioButton;
    RzRadioButton2: TRzRadioButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    RzGroupBox1: TRzGroupBox;
    imgDrink: TImage;
    Label1: TLabel;
    lblDrinkTime: TLabel;
    Label8: TLabel;
    lblDrinkResult: TLabel;
    Label3: TLabel;
    lbldwAlcoholicity: TLabel;
    imgTrainman: TImage;
    imgBeginworkFlow: TImage;
    rzpTrainmanInfo: TRzPanel;
    Label2: TLabel;
    lblTrainmanInfo: TLabel;
    imglstBeginworkFlow: TImageList;
    imglstBeginworkflow2: TImageList;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N9: TMenuItem;
    N21: TMenuItem;
    miTestFun: TMenuItem;
    N23: TMenuItem;
    statusFingerTime: TRzStatusPane;
    procedure btnExitClick(Sender: TObject);
    procedure NExitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrReadTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPhotoFingerUpdateClick(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miNameplateClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure strGridTrainPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure statusFingerDblClick(Sender: TObject);
    procedure actF6Execute(Sender: TObject);
    procedure miDrinkQueryClick(Sender: TObject);
    procedure miSelectColumnClick(Sender: TObject);
    procedure dtpPlanStartDateKeyPress(Sender: TObject; var Key: Char);
    procedure miPopManulImportServerDrinkClick(Sender: TObject);
    procedure strGridTrainPlanSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TimerImportDrinkTimer(Sender: TObject);
    procedure btnImportDrinkClick(Sender: TObject);
    procedure btnCancelDrinkClick(Sender: TObject);
    procedure btnHideDrinkClick(Sender: TObject);
    procedure grdMainGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdMainCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure statusMatchDblClick(Sender: TObject);
    procedure grdMainCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure btnDeleteIgnoreClick(Sender: TObject);
    procedure actF5Execute(Sender: TObject);
    procedure btnManulBeginWorkClick(Sender: TObject);
    procedure miPopManulBeginWorkClick(Sender: TObject);
    procedure strGridTrainPlanDblClick(Sender: TObject);
    procedure btnSystemConfigClick(Sender: TObject);
    procedure timerPlaySoundTimer(Sender: TObject);
    procedure btnUploadDrinkInfoClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure btnImportPlanClick(Sender: TObject);
    procedure miBeginworkFlowClick(Sender: TObject);
    procedure miSetWritecardSectionClick(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure RzRadioButton1Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
  private
    { Private declarations }
    m_LCBeginwork: TLCBeginwork;
    //测酒接口
    m_RsLCDrink: TRsLCDrink;
    //值班员
    m_RsLCDutyUser: TRsLCDutyUser;
    //
    m_nDayPlanID:Integer ;    //所管计划
    //web接口机车计划操作
    m_webTrainPlan:TRsLCTrainPlan;
    //乘务员信息操作接口
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //测酒照片上传对象
    m_RsDrinkImage: TRsDrinkImage;
    //带出勤的计划数组
    m_ChuQinPlanArray : TRsChuQinPlanArray;
    
    m_RightBottomPopWindow: Boolean;
    //断网或连网开始时间
    m_nTickCount: Cardinal;
    //气泡提示句柄
    m_hBallHint: Cardinal;
    //接收计划气泡
    m_hRecvHint : Cardinal ;
    //
    m_nSoundTickCount : Cardinal ;

    m_bPrintJSOldMode: Boolean;
    
  private
    procedure InitChuQinPlans;
    //显示接收计划界面
    procedure ShowReceivePlan();
    //初始化数据
    procedure InitData;
    //初始化人员交路
    procedure InitTrainJiaolus;
    //读取指纹状态
    procedure ReadFingerprintState;
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    //刷新界面
    procedure WMMessageRefresh(var Message : TMessage);message WM_Message_Refresh;
    procedure WMFingerUpdate(var Message : TMessage);message WM_FINGERUPDATE;
    //获取选中的司机工号
    function GetSelectedTrainman(var Trainman: RRsTrainman;var TrainmanIndex : integer): Boolean;
    //判断指定列是否为司机列
    function IsTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为副司机列
    function IsSubTrainmanCol(nCol: Integer): Boolean;
    //判断是否为学员列
    function IsXueYuanTrainmanCol(nCol: Integer): Boolean;
    //判断是否为学员2列
    function IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
    //判断是否为验卡结果列
    function IsICCheckCol(nCol : integer) : boolean;
    //判断是否为测酒结果列
    function IsDrinkInfoCol(nCol : integer): Boolean;
    //强制刷新
    procedure GetDataArray(ForceRefresh : boolean);
    //获取选择的计划信息
    function GetSelectedChuQinPlan(out ChuQinPlan : RRsChuQinPlan) : boolean;
    //显示计划的出勤测酒信息
    procedure ShowDringImage(ChuQinPlan : RRsChuQinPlan;TrainmanSn: Integer);
    procedure ShowTrainmanPic(ChuQinPlan: RRsChuQinPlan;TrainmanSn: Integer);
    //执行出勤
    procedure ExecChuQin(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
    //无计划出勤
    procedure NoPlanTestDrink(Trainman : RRsTrainman ; Verify : TRsRegisterFlag );
    //创建外段人员工号
    function CreateOuterSideTrainman(strNumber : string):boolean ;
    //出勤
    procedure ChuQin(strNumber : string);
    //接收系统消息事件
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //发送出勤消息
    procedure PostWorkBeginMessage(Trainman : RRsTrainman;trainmanPlan : RRsTrainmanPlan;
        AlcoholResult: TTestAlcoholResult; dtBeginWorkTime: TDateTime);
        //发送测酒信息
    procedure PostAlcoholMessage(Trainman : RRsTrainman;RsDrink : RRsDrink);
    //上传测酒结果
    function UploadAlcoholResult(Trainman : RRsTrainman;TrainmanPlan : RRsTrainmanPlan;Verify :  TRsRegisterFlag):Boolean;
    //上传测酒照片
    function PostDrinkImage(Trainman : RRsTrainman;AlcoholResult: RTestAlcoholInfo): string;
    //保存出勤记录
    procedure SaveBeginWorkData(TrainmanGUID: string;TrainmanPlan: RRsTrainmanPlan; RsDrink: RRsDrink;
        BeginWorkStationGUID: string);
  private
    //获取IC卡检车内容中结果的字符串
    function GetICCheckResult(CheckResultString : string) : string;
    function GetICCheckFontColor(ChuQinPlan : RRsChuQinPlan) : TColor;

    procedure PrintJFJSOldMode(chuqinPlan: RRsChuQinPlan);
  private
    //本地数据操作类
    m_LocalDrinkArray: TRsDrinkInfoArray;
    //显示标准照片
    m_bShowTMPic: Boolean;
    //显示出勤流程
    m_bShowWorkFlow: Boolean;

    m_FrmPrintJieShi: TFrmPrintJieShi;

    //查询本地测酒信息
    procedure QueryLocalDrinkInfo();
    //导入测酒信息
    function  ImportDrinkInfo(chuqinPlan : RRsChuQinPlan;trainman : RRsTrainman;localDrinkInfo:RRsDrinkInfo): boolean;
    //上传测酒记录
    function  UploadDrinkInfo(Trainman: RRsTrainman;DrinkInfo: RRsDrinkInfo):Boolean;
    //刷新本地测酒记录导入提醒
    procedure RefreshLocalDrinkAlarm(ConnAccess: TConnAccess = nil);
    //在线、离线模式切换事件
    procedure ExchangeModeProc(Sender: TObject);
    //退出在线模式的实现
    procedure ExitSystemProc(Sender: TObject);
    //绘制出勤流程
    procedure DrawBeginworkFlow(Canvas : TCanvas;R : TRect;
      Trainman : RRsTrainman;Plan : RRsChuQinPlan);
  public
    { Public declarations }
    class procedure EnterChuQin;
    class procedure LeaveChuQin;

  end;



implementation
uses
  DateUtils,  uFrmTestDrinkSelect,uFrmSelectPlan,
  uFrmTestDrinking, uFrmTextInput, ufrmTrainmanPicFigEdit, uFrmDisconnectHint,
  uRunSaftyDefine, uFrmSetStringGridCol,uFrmOuterTrainman,
  StrUtils, {uFrmErrorTipLog,}uFrmExchangeModule,ufrmModifyPassWord,uFrmLogin,
  uSite, {ufrmStationGround,}  uRunSafetyInterfaceDefine, uFrmImportDrinkInfo,
  ufrmFingerRegister,utfPopBox,uFrmDrinkTestQuery, uFrmDrinkInfo,ZKFPEngXUtils,
  ufrmHint,ufrmConfig,ufrmTrainmanNumberInput,uFrmMainTemeplateTrainNo,
  uFrmTMRptSelect, uKeyManConfirm, uPubJsPrintCtl, uFlowCtlIntf,
  uFrmTrainmanManage, uMenuItemCtl;
var
  frmMain_ChuQin: TfrmMain_ChuQin;  
{$R *.dfm}

function LoginCallback(var TM: RTM; var Verify: integer): Boolean;
var
  Trainman: RRsTrainman;
  vFlag: TRsRegisterFlag;
begin

  Result := TmLogin(Trainman,vFlag);
  
  if Result then
  begin
    Verify := Ord(vFlag);
    TM.ID := Trainman.strTrainmanGUID;
    TM.Number := Trainman.strTrainmanNumber;
    TM.Name := Trainman.strTrainmanName;
    TM.WorkShopID := Trainman.strWorkShopGUID;
    TM.WorkShopName := Trainman.strWorkShopName;
  end;


end;
{ TfrmMain_ChuQin }


procedure TfrmMain_ChuQin.miPopManulBeginWorkClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  trainmanIndex : integer;
begin
  if not GetSelectedTrainman(TrainMan,trainmanIndex) then
  begin
    exit;
  end;
  strNumber := trainman.strTrainmanNumber;
  ChuQin(strNumber);
end;

procedure TfrmMain_ChuQin.miPopManulImportServerDrinkClick(Sender: TObject);
var
  DrinkQuery: RRsDrinkQuery;
  DrinkInfo: RRsDrinkInfo;
  Trainman: RRsTrainman;
  Verify: TRsRegisterFlag;
  chuqinPlan: RRsChuQinPlan;
  TestResult: RTestAlcoholInfo;
  trainmanPlan : RRsTrainmanPlan;  
  trainmanIndex : integer;
  RDrink: RRsDrink;
begin
  if not GetSelectedChuQinPlan(chuqinPlan) then
  begin
    Box('请先选中计划!');
    Exit;
  end;   
  GetSelectedTrainman(TrainMan, trainmanIndex);

  DrinkQuery.nWorkTypeID := DRINK_TEST_CHU_QIN ;      
  DrinkQuery.strTrainmanNumber := TrainMan.strTrainmanNumber;
  DrinkQuery.dtBeginTime := IncHour(chuqinPlan.TrainPlan.dtStartTime, -6); //出勤计划前6小时
  DrinkQuery.dtEndTime := IncHour(chuqinPlan.TrainPlan.dtStartTime, 6); //出勤计划后3小时
  if TFrmDrinkInfo.ShowForm(dfServer, DrinkQuery, DrinkInfo) <> mrOK then exit;

  TestResult.dtTestTime := DrinkInfo.dtCreateTime;
  TestResult.taTestAlcoholResult := TTestAlcoholResult(DrinkInfo.nDrinkResult);
  TestResult.Picture := DrinkInfo.DrinkImage;
  TestResult.nAlcoholicity := DrinkInfo.dwAlcoholicity;

  trainmanPlan.Group := chuqinPlan.ChuQinGroup.Group;
  trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
  trainmanPlan.TrainPlan := chuqinPlan.TrainPlan;
  trainmanPlan.dtBeginWorkTime := chuqinPlan.dtBeginWorkTime;
  
  m_RsLCTrainmanMgr.GetTrainmanByNumber(DrinkInfo.strTrainmanNumber, Trainman);
  Verify := TRsRegisterFlag(DrinkInfo.nVerifyID);
  if not TBox(Format('您确认要导入“%s[%s]”的测酒记录吗？', [Trainman.strTrainmanName, Trainman.strTrainmanNumber])) then exit;

  //人员信息
  RDrink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber)  ;
  RDrink.strTrainmanGUID := Trainman.strTrainmanGUID ;
  RDrink.strTrainmanName := Trainman.strTrainmanName ;
  RDrink.strTrainmanNumber := Trainman.strTrainmanNumber;
  //车次信息
  RDrink.strTrainNo :=  trainmanPlan.TrainPlan.strTrainNo ;
  RDrink.strTrainNumber :=  trainmanPlan.TrainPlan.strTrainNumber ;
  RDrink.strTrainTypeName :=  trainmanPlan.TrainPlan.strTrainTypeName ;
  //出勤点信息
  RDrink.strPlaceID := GlobalDM.DutyPlace.placeID ;
  RDrink.strPlaceName := GlobalDM.DutyPlace.placeName ;
  RDrink.strSiteIp := GlobalDM.SiteInfo.strSiteIP ;
  RDrink.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
  RDrink.strSiteName := GlobalDM.SiteInfo.strSiteName ;

  RDrink.strDutyGUID := GlobalDM.DutyUser.strDutyGUID ;
  RDrink.strDutyNumber := GlobalDM.DutyUser.strDutyNumber ;
  RDrink.strDutyName := GlobalDM.DutyUser.strDutyName ;

  RDrink.strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);
  

  //车间
  RDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
  RDrink.strWorkShopName := Trainman.strWorkShopName ;

  RDrink.strGUID := DrinkInfo.strGUID ;
  RDrink.AssignFromTestAlcoholInfo(TestResult);
  RDrink.nVerifyID :=  DrinkInfo.nVerifyID ;
  RDrink.strPictureURL := DrinkInfo.strPictureURL;

  
  m_LCBeginwork.ImportBeginWork(Trainman.strTrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,
  RDrink,Ord(Verify),'手工导入');


  PostWorkBeginMessage(Trainman,trainmanPlan,TestResult.taTestAlcoholResult,TestResult.dtTestTime);

  TtfPopBox.ShowBox('出勤成功！');
  InitChuQinPlans;
end;

procedure TfrmMain_ChuQin.actF6Execute(Sender: TObject);
var
  strNumber : string;
begin
  //输入工号
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
    Exit;
  //执行出勤
  ChuQin(strNumber);
end;

procedure TfrmMain_ChuQin.btnDeleteIgnoreClick(Sender: TObject);
var
  dbConnAccess: TConnAccess;
begin
  if not TBOX('删除后记录将不可恢复，您确定要这么样吗？') then exit;
  dbConnAccess := TConnAccess.Create(Application);
  try
    try
      if not dbConnAccess.ConnectAccess then
      begin
        Box('连接本地数据库异常，导入失败!');
        Exit;
      end;
      dbConnAccess.DeleteIgnoreRecord;
      QueryLocalDrinkInfo;
      Box('删除成功');
    except on e : exception do
      begin
        Box('删除失败:' + e.Message);
      end;
    end;
  finally
    dbConnAccess.Free;
  end;
end;

procedure TfrmMain_ChuQin.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TfrmMain_ChuQin.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_ChuQin.btnPhotoFingerUpdateClick(Sender: TObject);
var
  strNumber: string;
  trainman: RRsTrainman;
begin
  if TextInput('乘务员工号输入窗口', '请输入乘务员工号:', strNumber) = False then
    Exit;
  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    if ModifyTrainmanPicFig(trainman.strTrainmanGUID) then
    begin
      GlobalDM.FingerPrintCtl.ServerFingerCtl.FinerID := NewGUID;
    end;
  end
  else
  begin
    Box('该乘务员不存在');
  end;
end;

procedure TfrmMain_ChuQin.btnSystemConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TfrmMain_ChuQin.btnUploadDrinkInfoClick(Sender: TObject);
var
  nRow, nCol,  nImportCount: integer;
  dbConnAccess: TConnAccess;
  blnCheck: boolean;
  trainman : RRsTrainman;
begin
  dbConnAccess := TConnAccess.Create(Application);
  try
    nImportCount := 0;
    nCol := grdMain.Col;
    grdMain.Col := 1;   
    grdMain.Col := nCol;
    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      if blnCheck then Continue;      
      if grdMain.Cells[99, nRow] <> '' then
      begin
        if (not blnCheck) then
          nImportCount := nImportCount + 1;
      end;
    end;
    if nImportCount = 0 then
    begin
      Box('没有待匹配的记录，操作不能继续！');
      exit;
    end;
    if not TBox(Format('待匹配的有%d条，您确认要继续操作吗？', [nImportCount])) then exit;
    
    if not dbConnAccess.ConnectAccess then
    begin
      Box('连接本地数据库异常，导入失败!');
      Exit;
    end;

    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      TfrmProgressEx.ShowProgress('上传测酒记录',nRow,grdMain.RowCount-1);
      Application.ProcessMessages;
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      GlobalDM.LogManage.InsertLog('上传断网测酒记录--1开始上传断网测酒记录');
      if grdMain.Cells[99, nRow] <> '' then
      begin
        if blnCheck then continue;
        if not m_RsLCTrainmanMgr.GetTrainmanByNumber(m_LocalDrinkArray[nRow-1].strTrainmanNumber,trainman) then
        begin
          GlobalDM.LogManage.InsertLog('上传断网测酒记录---2获取员工号失败,员工号:'+m_LocalDrinkArray[nRow-1].strTrainmanNumber);
          continue;
        end;

        //上传测酒信息 (上传测酒照片/数据增加记录)
        if UploadDrinkInfo(trainman,m_LocalDrinkArray[nRow-1] ) then
          dbConnAccess.UpdateDrinkState(m_LocalDrinkArray[nRow-1].nDrinkInfoID)
        else
          GlobalDM.LogManage.InsertLog('上传断网测酒记录--4导入测酒记录失败');
      end;
    end;
  finally
    TfrmProgressEx.CloseProgress;
    dbConnAccess.Free;

    QueryLocalDrinkInfo;
    RefreshLocalDrinkAlarm(dbConnAccess);
  end;
end;

procedure TfrmMain_ChuQin.ExchangeModeProc(Sender: TObject);
begin
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(sjDuanWang));
end;
         
procedure TfrmMain_ChuQin.ExitSystemProc(Sender: TObject);
begin
  Hide;
  Close;
end;
 


procedure TfrmMain_ChuQin.dtpPlanStartDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnRefreshPaln.Click;
end;

procedure TfrmMain_ChuQin.dtpPlanStartTimeChange(Sender: TObject);
begin
  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
end;

class procedure TfrmMain_ChuQin.EnterChuQin;
begin
  GlobalDm.LocalSiteName := '出勤';
  if frmMain_ChuQin = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TfrmMain_ChuQin, frmMain_ChuQin);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,frmMain_ChuQin);
    frmMain_ChuQin.InitData;
  end;
  frmMain_ChuQin.Show;
end;



procedure TfrmMain_ChuQin.ExecChuQin(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
var
  strError:string;
  chuqinPlan: RRsChuQinPlan;
  trainmanPlan : RRsTrainmanPlan;
  function CheckFlow(): Boolean;
  var
    param: RParam;
  begin
    param.Size := SizeOf(param);
    param.AppHandle := Application.Handle;
    param.ApiHost := GlobalDM.WebAPIUtils.Host;
    param.ApiPort := GlobalDM.WebAPIUtils.Port;
    param.Site.WorkShopID := GlobalDM.SiteInfo.WorkShopGUID;
    param.Site.SiteID := GlobalDM.SiteInfo.strSiteGUID;
    param.Site.SiteName := GlobalDM.SiteInfo.strSiteName;

    param.TM.ID := Trainman.strTrainmanGUID;
    param.TM.Number := Trainman.strTrainmanNumber;
    param.TM.Name := Trainman.strTrainmanName;
    param.TM.WorkShopID := Trainman.strWorkShopGUID;
    param.TM.WorkShopName := Trainman.strWorkShopName;
    param.Plan.TrainType := chuqinPlan.TrainPlan.strTrainTypeName;
    param.Plan.TrainNumber := chuqinPlan.TrainPlan.strTrainNumber;
    param.Plan.TrainNo := chuqinPlan.TrainPlan.strTrainNo;
    param.Plan.PlanID := chuqinPlan.TrainPlan.strTrainPlanGUID;
    param.Plan.JlName := chuqinPlan.TrainPlan.strTrainJiaoluName;
    param.Plan.JlID := chuqinPlan.TrainPlan.strTrainJiaoluGUID;
    param.Plan.StartTime := chuqinPlan.TrainPlan.dtStartTime;

    param.LoginFun := LoginCallback;

    Result := CheckBWFlow(param);
  end;
begin
  FillChar(chuqinPlan,SizeOf(chuqinPlan),0);
  //获取当前人员的出勤计划
  if not m_webTrainPlan.GetChuQinPlanByTrainman(trainman.strTrainmanGUID,
    chuqinPlan,strError) then
  begin
    //没有获取到计划就提示输入车次测酒
    FillChar(chuqinPlan,SizeOf(chuqinPlan),0);
    if not CheckFlow then Exit;
    NoPlanTestDrink(trainman,Verify);
    Exit ;
  end;


  if not CheckFlow then Exit;


  
  if Trainman.bIsKey <> 0 then
  begin
    TFrmKeyManConfirm.ShowKeyMan(Trainman.strTrainmanNumber);
  end;
  
  trainmanPlan.Group := chuqinPlan.ChuQinGroup.Group;
  trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
  trainmanPlan.TrainPlan := chuqinPlan.TrainPlan;
  trainmanPlan.dtBeginWorkTime := chuqinPlan.dtBeginWorkTime;


  UploadAlcoholResult(Trainman,trainmanPlan,Verify) ;
end;

procedure TfrmMain_ChuQin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (not Showing)  then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_ChuQin.FormCreate(Sender: TObject);
begin
  m_RsLCDrink := TRsLCDrink.Create(GlobalDM.WebAPIUtils);
  m_nTickCount := 0;
  m_hRecvHint := 0 ;
  m_nSoundTickCount := 0 ;
  strGridTrainPlan.SelectionRectangleColor := clRed;
  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;


  dtpPlanStartTime.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);



  m_RsLCDutyUser := TRsLCDutyUser.Create(GlobalDM.WebAPIUtils);

  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);

  m_RsDrinkImage := TRsDrinkImage.Create('');

  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_LCBeginwork := TLCBeginwork.Create(GlobalDM.WebAPIUtils);

  m_RightBottomPopWindow := GlobalDM.BeginWorkRightBottomShow;
  strGridTrainPlan.ColumnSize.Save := false;
  GlobalDM.SetGridColumnWidth(strGridTrainPlan);
  GlobalDM.SetGridColumnVisible(strGridTrainPlan);
  statusMatch.OnDblClick := statusMatchDblClick;

end;

procedure TfrmMain_ChuQin.FormDestroy(Sender: TObject);
begin
  if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
  if m_hRecvHint > 0 then GlobalDM.DestroyHint(m_hRecvHint);

  GlobalDM.SaveGridColumnWidth(strGridTrainPlan);  
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;

  
  tmrReadTime.Enabled := false;
  GlobalDM.FingerPrintCtl.EventHolder.Restore();
  m_RsLCTrainmanMgr.Free;
  m_RsLCDutyUser.Free ;

  m_LCBeginwork.Free;


  m_RsDrinkImage.Free;
  m_webTrainPlan.Free ;
  m_RsLCDrink.Free;
  
end;

procedure TfrmMain_ChuQin.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
  GetDataArray(true);
  TimerImportDrink.Enabled := true;
end;

function TfrmMain_ChuQin.GetSelectedTrainman(var Trainman: RRsTrainman;var TrainmanIndex : integer): Boolean;
var
  selectCol : integer;
begin
  Result := False;
  TrainmanIndex := 0;
  if strGridTrainPlan.Row > Length(m_ChuQinPlanArray) then
      Exit;
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if strGridTrainPlan.Cells[selectCol,strGridTrainPlan.ROW] = '' then exit;

  if IsTrainmanCol(selectCol) then
  begin
    Trainman := m_ChuQinPlanArray[strGridTrainPlan.Row - 1].ChuQinGroup.Group.Trainman1;
    TrainmanIndex := 1;
    Result := True;
  end
  else
  if IsSubTrainmanCol(selectCol) then
  begin
    Trainman := m_ChuQinPlanArray[strGridTrainPlan.Row - 1].ChuQinGroup.Group.Trainman2;
    TrainmanIndex := 2;
    Result := True;
  end;
  if IsXueYuanTrainmanCol(selectCol) then
  begin
    Trainman := m_ChuQinPlanArray[strGridTrainPlan.Row - 1].ChuQinGroup.Group.Trainman3;
    TrainmanIndex := 3;
    Result := True;
  end;
  if IsXueYuan2TrainmanCol(selectCol) then
  begin
    Trainman := m_ChuQinPlanArray[strGridTrainPlan.Row - 1].ChuQinGroup.Group.Trainman4;
    TrainmanIndex := 4;
    Result := True;
  end;
end;

procedure TfrmMain_ChuQin.GetDataArray(ForceRefresh: boolean);
var
  strError:string;
  dtBeginTime,dtEndTime : TDateTime;
  chuqinPlanArray : TRsChuQinPlanArray;
begin

  dtBeginTime := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  dtEndTime := dtBeginTime + 2;
  try
    try
      if not m_webTrainPlan.GetChuQinPlanByClient(dtBeginTime,dtEndTime,chuqinPlanArray,strError)   then
      begin
        BoxErr(strError);
        Exit ;
      end;

      m_ChuQinPlanArray := chuqinPlanArray;

      if not ForceRefresh then
      PostMessage(Self.Handle,WM_Message_Refresh,0,0);
    except on e:exception do
      begin
        ;
      end;
    end;
  finally
    ;
  end;
end;

function TfrmMain_ChuQin.GetICCheckFontColor(ChuQinPlan: RRsChuQinPlan): TColor;
begin
  result := clBlack;
  if (ChuQinPlan.TrainPlan.dtStartTime <= GlobalDM.GetNow) or (ChuQinPlan.TrainPlan.nPlanState >= psBeginWork) then
  begin
    if GetICCheckResult(ChuQinPlan.strICCheckResult) <> '合格' then
    begin
      result := clRed;
    end;
  end;
end;

function TfrmMain_ChuQin.GetICCheckResult(CheckResultString : string): string;
begin
  result := Copy(checkResultString,0,Pos(':',CheckResultString)-1);
  if (result = '') then result := '未验卡';
  
end;

function TfrmMain_ChuQin.GetSelectedChuQinPlan(
  out ChuQinPlan: RRsChuQinPlan): boolean;
begin
  result := false;
  if strGridTrainPlan.Row < 1 then Exit;;
  if strGridTrainPlan.Row > length(m_ChuQinPlanArray) then exit;
  
  ChuQinPlan := m_ChuQinPlanArray[strGridTrainPlan.row - 1];
  result := true;
end;

class procedure TfrmMain_ChuQin.LeaveChuQin;
begin
  //释放已硬件驱动
  if frmMain_ChuQin <> nil then
    FreeAndNil(frmMain_ChuQin);
end;

procedure TfrmMain_ChuQin.miBeginworkFlowClick(Sender: TObject);
var
  chuqinplan : RRsChuQinPlan;
begin
  if not GetSelectedChuQinPlan(chuqinplan) then exit;
  if TfrmBeginworkView.ShowView(chuqinplan.TrainPlan.strTrainPlanGUID) then
  begin
    InitChuQinPlans;
  end;
end;

procedure TfrmMain_ChuQin.miDrinkQueryClick(Sender: TObject);
begin
  TFrmDrinkTestQuery.OpenDrinkTestQuery;
end;

procedure TfrmMain_ChuQin.miNameplateClick(Sender: TObject);
begin
 TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_ChuQin.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(strGridTrainPlan,'ChuQinPlan');
end;

procedure TfrmMain_ChuQin.miSetWritecardSectionClick(Sender: TObject);
var
  chuqinplan : RRsChuQinPlan;
begin
  if not GetSelectedChuQinPlan(chuqinplan) then exit;  
  TfrmPlanWriteSection.Open(chuqinPlan.TrainPlan.strTrainPlanGUID);
end;

procedure TfrmMain_ChuQin.N10Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_ChuQin.N12Click(Sender: TObject);
begin
  btnExchangeModuleClick(btnExchangeModule);
end;

procedure TfrmMain_ChuQin.N16Click(Sender: TObject);
var
  chuqinPlan: RRsChuQinPlan;
begin
  if not GetSelectedChuQinPlan(chuqinPlan) then Exit;

  if m_bPrintJSOldMode then
    PrintJFJSOldMode(chuqinPlan)
  else
    TPubJsPrintCtl.Print(chuqinPlan);
end;

procedure TfrmMain_ChuQin.N17Click(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  trainmanIndex : integer;
  strError:string;
  chuqinPlan: RRsChuQinPlan;
  trainmanPlan : RRsTrainmanPlan;
begin
  if not GetSelectedTrainman(TrainMan,trainmanIndex) then
  begin
    exit;
  end;
  strNumber := trainman.strTrainmanNumber;
  //获取当前人员的出勤计划

  if not m_webTrainPlan.GetChuQinPlanByTrainman(trainman.strTrainmanGUID,
    chuqinPlan,strError) then
  begin
    Box(Format('没有找到%s的出勤记录！',[GetTrainmanText(Trainman)]));
    exit;
  end;

  
  trainmanPlan.Group := chuqinPlan.ChuQinGroup.Group;
  trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
  trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
  trainmanPlan.TrainPlan := chuqinPlan.TrainPlan;
  trainmanPlan.dtBeginWorkTime := chuqinPlan.dtBeginWorkTime;
  if Trainman.strTrainmanGUID = chuqinPlan.ChuQinGroup.Group.Trainman1.strTrainmanGUID then
  begin
    TFrmGeXingChuQin.ShowGeXingChuQin(chuqinPlan);
  end;
end;

procedure TfrmMain_ChuQin.N19Click(Sender: TObject);
begin
  TfrmTMRptSelect.Config;
end;

procedure TfrmMain_ChuQin.N20Click(Sender: TObject);
var
  chuqinPlan1,chuqinPlan2:RRSChuQinPlan;
  strErr:string;
begin
  ZeroMemory(@chuqinPlan2,SizeOf(chuqinPlan2));
  ZeroMemory(@chuqinPlan1,SizeOf(chuqinPlan1));
  
   if not GetSelectedChuQinPlan(chuqinPlan1) then
  begin
    Box('请先选中计划!');
    Exit;
  end; 

  if TPrintTMReport.PrintRpt(LeftStr(GlobalDM.SiteInfo.strSiteIP,2),chuqinPlan1,chuqinPlan2,strErr)= False then
  begin
    Box(strErr);
  end;

end;
procedure TfrmMain_ChuQin.N21Click(Sender: TObject);
begin
    TfrmTrainmanManage.OpenTrainmanQuery;
end;

procedure TfrmMain_ChuQin.N8Click(Sender: TObject);
begin
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo(True);
end;

procedure TfrmMain_ChuQin.NExitClick(Sender: TObject);
begin
  Close;
end;
procedure TfrmMain_ChuQin.NoPlanTestDrink(Trainman: RRsTrainman ; Verify : TRsRegisterFlag );
var
  strTrainNo ,strTrainNumber,strTrainTypeName : string  ;
  Drink: RRsDrink;
  testResult: RTestAlcoholInfo;
begin

  try
    try
      strTrainNo :=  '测试车次' ;
      strTrainNumber :=  '测试车号'  ;
      strTrainTypeName :=  '测试车型'  ;

      with  Drink do
      begin
        //人员信息
        bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber);

        strTrainmanGUID := Trainman.strTrainmanGUID ;
        strTrainmanName := Trainman.strTrainmanName ;
        strTrainmanNumber := Trainman.strTrainmanNumber;
        //出勤点信息
        strPlaceID := GlobalDM.DutyPlace.placeID ;
        strPlaceName := GlobalDM.DutyPlace.placeName ;
        //site
        strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
        strSiteIP := GlobalDM.SiteInfo.strSiteIP;
        strSiteName := GlobalDM.SiteInfo.strSiteName ;
        //duty
        strDutyGUID := GlobalDM.DutyUser.strDutyGUID ;
        strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
        strDutyName := GlobalDM.DutyUser.strDutyName ;
        
        strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);

        //车间
        strWorkShopGUID := Trainman.strWorkShopGUID ;
        strWorkShopName := Trainman.strWorkShopName ;

        dwAlcoholicity := 0 ;
      end;

      {$REGION '1 获取测试类型'}
      if not TFrmTestDrinkSelect.GetDrinkInfo(DRINK_TEST_CHU_QIN,Drink.nWorkTypeID,strTrainNo ,strTrainNumber,strTrainTypeName )  then
      begin
        Exit ;
      end;
      {$ENDREGION}
      {$REGION '2 输入车次'}
      //车次信息
      Drink.strTrainNo :=  strTrainNo;
      Drink.strTrainNumber :=  strTrainNumber  ;
      Drink.strTrainTypeName :=  strTrainTypeName  ;
      {$ENDREGION}

      TestDrinking(Trainman,strTrainTypeName,strTrainNumber,strTrainNo,testResult);

      if testResult.taTestAlcoholResult= taNoTest then
      begin
        if not TBox('测酒结果为未测试是否继续测试') then
          Exit ;
      end;

      Drink.AssignFromTestAlcoholInfo(testResult);
      GlobalDM.PlaySoundFile('正在保存测酒记录请稍候.wav');
      Drink.strPictureURL := PostDrinkImage(trainman,testResult);
      Drink.nVerifyID := ord(Verify);
      PostAlcoholMessage(Trainman,Drink);

      
      //发送测酒信息
      m_RsLCDrink.AddDrinkInfo(Drink);
      GlobalDM.PlaySoundFile('保存测酒记录成功.wav');
      TtfPopBox.ShowBox('保存测酒记录成功');
    except on e : exception do
      begin
        GlobalDM.PlaySoundFile('保存测酒记录失败.wav');
        BoxErr('保存测酒记录失败:' + e.Message);
      end;
    end;
  finally
    TfrmHint.CloseHint;
  end;

end;

procedure TfrmMain_ChuQin.OnTFMessage(TFMessages: TTFMessageList);
var
  i: Integer;
  bFlag: Boolean;
  bPlaySound: Boolean;
  bIsUpdate : Boolean ;
begin
  bIsUpdate := False ;
  bPlaySound := False;
  bFlag := False;
  for I := 0 to TFMessages.Count - 1 do
  begin
    case TFMessages.Items[i].msg of
      TFM_PLAN_RENYUAN_PUBLISH,
      TFM_PLAN_RENYUAN_UPDATE,
      TFM_PLAN_RENYUAN_DELETE,
      TFM_PLAN_RENYUAN_RMTRAINMAN,
      TFM_PLAN_RENYUAN_RMGROUP,
      TFM_PLAN_TRAIN_UPDATE,
      TFM_PLAN_TRAIN_CANCEL:
      begin
        if RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
          GlobalDM.SiteInfo.strSiteGUID) then
        begin
          bFlag := True;
          Break;
        end;
      end;
      //接收-发布机车计划
      TFM_PLAN_TRAIN_PUBLISH:
      begin
        if RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
          GlobalDM.SiteInfo.strSiteGUID) then
        begin
          //开始播放声音
          timerPlaySound.Enabled := True ;
          //显示接收计划提示
          ShowReceivePlan();
          Exit ;
        end;
      end;
      //如果收到验卡消息则刷信界面
      TFM_OTHER_YANKA :
      begin
        if RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
          GlobalDM.SiteInfo.strSiteGUID) then
        begin
          bFlag := True;
          InitChuQinPlans;
          Break;
        end;
      end;

      //外勤的更新接话和接受计划
      //接收到更新人员的叫班信息
      TFM_PLAN_WAIQIN_PUBLISH :
      begin
        if  TFMessages.Items[i].IntField['nDayPlanID'] = m_nDayPlanID  then
        begin
          bPlaySound := True ;
        end;
      end ;
      TFM_PLAN_WAIQIN_UPDATE :
      //接收到更新人员的叫班信息
        begin
          if  TFMessages.Items[i].IntField['nDayPlanID'] = m_nDayPlanID  then
          begin
            bIsUpdate := True ;
          end;
        end ;
    ELSE
      Continue;
    end;

  end;

  //提示外勤端更新和接受计划
    if bPlaySound then
    begin
      GlobalDM.PlaySoundFileLoop('接收计划.wav');
    end;

    if bIsUpdate then
    begin
      GlobalDM.PlaySoundFileLoop('更新计划.wav');
    end;
  
  for I := 0 to TFMessages.Count - 1 do
  begin
    TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
  end;

  if bFlag then
    GetDataArray(False);
end;

procedure TfrmMain_ChuQin.PostAlcoholMessage(Trainman: RRsTrainman;
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

function TfrmMain_ChuQin.PostDrinkImage(Trainman : RRsTrainman;
  AlcoholResult: RTestAlcoholInfo): string;
var
  strTrainmanNumber:string ;
  msPicture: TMemoryStream;
  nRetryCount: Integer;
  strPath, strFile: string;
begin
  strTrainmanNumber := Trainman.strTrainmanNumber ;

  msPicture := TMemoryStream.Create;
  try
    nRetryCount := 0;
    //检测照片是否为空。为空则退出
    if VarIsEmpty(AlcoholResult.Picture) then
    begin
      if not tbox('测酒照片为空,是否继续') then
      begin
        GlobalDM.LogManage.InsertLog('测酒照片为空:' + strTrainmanNumber);
        raise Exception.Create('测酒照片为空！');
        Exit;
      end;
      GlobalDM.LogManage.InsertLog('上传测酒照片为空:' + strTrainmanNumber);
      Exit ;
    end;
    TemplateOleVariantToStream(AlcoholResult.Picture,msPicture);
    if (msPicture.Size = 0) then
    begin
      if not tbox('测酒照片捕获失败,是否继续') then
      begin
        GlobalDM.LogManage.InsertLog('测酒照片捕获失败:' + strTrainmanNumber);
        raise Exception.Create('测酒照片捕获失败，清重新测酒！');
        exit;
      end;
    end;
    
    while true do
    begin
      nRetryCount := nRetryCount + 1;
      if nRetryCount > 3 then
      begin
        raise Exception.Create('测酒照片上传失败,请检查连接.');
        GlobalDM.LogManage.InsertLog('测酒照片上传失败:' + strTrainmanNumber);
        break;
      end;
      try
        //显示进度
        TfrmHint.ShowHint('第' + IntToStr(nRetryCount ) + '次上传['+strTrainmanNumber+']测酒照片,请稍候……');
        //上传照片
        Result := m_RsDrinkImage.Post(strTrainmanNumber,msPicture);
         GlobalDM.LogManage.InsertLog(Result);
        //保存本地测酒照片
        strFile := GlobalDM.AppPath + StringReplace(Result,'/','\',[rfReplaceAll]);
        strFile := StringReplace(strFile,'\\','\',[rfReplaceAll]);
        strPath := ExtractFilePath(strFile);

        if not DirectoryExists(strPath) then ForceDirectories(strPath);
        msPicture.SaveToFile(strFile);
        break;
      except
        on E: Exception do
        begin
          GlobalDM.LogManage.InsertLog('测酒照片上传异常:' + E.Message + Format('第%d次',[nRetryCount]));
          Sleep(300);
        end;
      end;
    end;
  finally
    TfrmHint.CloseHint;
    msPicture.Free;
  end;
end;

procedure TfrmMain_ChuQin.PostWorkBeginMessage(Trainman : RRsTrainman;
    trainmanPlan : RRsTrainmanPlan;AlcoholResult: TTestAlcoholResult; dtBeginWorkTime: TDateTime);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := TFM_WORK_BEGIN;
    TFMessage.StrField['tmGuid'] := Trainman.strTrainmanGUID;
    TFMessage.StrField['tmid'] := Trainman.strTrainmanNumber;
    TFMessage.StrField['tmname'] := Trainman.strTrainmanName;

    TFMessage.dtField['dttime'] := dtBeginWorkTime; //GlobalDM.GetNow;

    TFMessage.StrField['planGuid'] := trainmanPlan.TrainPlan.strTrainPlanGUID;
    TFMessage.StrField['jiaoLuName'] := trainmanPlan.TrainPlan.strTrainJiaoluName;
    TFMessage.StrField['jiaoLuGUID'] := trainmanPlan.TrainPlan.strTrainJiaoluGUID;
    
    TFMessage.dtField['dtStartTime'] :=
        trainmanPlan.TrainPlan.dtStartTime;
    TFMessage.IntField['cjjg'] := Ord(AlcoholResult);

    TFMessage.StrField['strTrainTypeName'] := trainmanPlan.TrainPlan.strTrainTypeName;
    TFMessage.StrField['strTrainNumber'] := trainmanPlan.TrainPlan.strTrainNumber;
    TFMessage.StrField['strTrainNo'] := trainmanPlan.TrainPlan.strTrainNo;
    TFMessage.IntField['Tmis'] := GlobalDM.SiteInfo.Tmis;
    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
  finally
    TFMessage.Free;
  end;

end;

procedure TfrmMain_ChuQin.PrintJFJSOldMode(chuqinPlan: RRsChuQinPlan);
var
  trainman : RRsTrainman;
begin
  if not Assigned(m_FrmPrintJieShi) then
    m_FrmPrintJieShi := TFrmPrintJieShi.Create(self);

  trainman := chuqinPlan.ChuQinGroup.Group.Trainman1;

  if trainman.strTrainmanName = '' then
    trainman := chuqinPlan.ChuQinGroup.Group.Trainman2;


  m_FrmPrintJieShi.ShowPrintJiaoFuJieShi(chuqinPlan,Trainman);
end;

procedure TfrmMain_ChuQin.OnFingerTouching(Sender: TObject);
var
  trainmanPlan: RRsTrainmanPlan;
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not IdentfityTrainman(Sender,TrainMan,Verify,
    trainmanPlan.Group.Trainman1.strTrainmanGUID,
    trainmanPlan.Group.Trainman2.strTrainmanGUID,
    trainmanPlan.Group.Trainman3.strTrainmanGUID,
    trainmanPlan.Group.Trainman4.strTrainmanGUID) then
  begin
    exit;
  end;
  if Trim(Trainman.strTrainmanGUID) = '' then
  begin
    Box('人员识别失败，请双击任务栏更新本地指纹库');
    exit;
  end;

  ExecChuQin(TrainMan,verify);
end;

procedure TfrmMain_ChuQin.ReadFingerprintState;
begin
  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪连接正常';
    statusFinger.ShowHint := False ;
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪连接失败！';
    statusFinger.ShowHint := True ;
  end;
end;

procedure TfrmMain_ChuQin.SaveBeginWorkData(TrainmanGUID: string;TrainmanPlan: RRsTrainmanPlan; RsDrink: RRsDrink;
        BeginWorkStationGUID: string);
var
  nRetryCount: Integer;
  bSuccess: Boolean;
begin
  nRetryCount := 0;
  bSuccess := False;
  while not bSuccess do
  begin
    try
      m_LCBeginwork.Submit(TrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,RsDrink);
      bSuccess := True;
       if nRetryCount > 0 then
        GlobalDM.LogManage.InsertLog('出勤数据保存成功,工号:' + RsDrink.strTrainmanNumber);
    except
      on E: Exception do
      begin
        inc(nRetryCount);
        GlobalDM.LogManage.InsertLog('出勤数据保存异常:' + E.Message);
        Sleep(1000);
        if nRetryCount >= 3 then
        begin
          raise Exception.Create(E.Message);
        end;
      end;

    end;
  end;


end;

procedure TfrmMain_ChuQin.ShowDringImage(ChuQinPlan: RRsChuQinPlan;
  TrainmanSn: Integer);
var
  Trainman: RRsTrainman;
  RsDrink: RRsDrink;
  strPath, strFile, strUrl: string;
begin
  try
    Trainman.strTrainmanGUID := '';
    case TrainmanSn  of
      0:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman1;
      1:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman2;
      2:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman3;
      3:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman4;
    end;
    

    if m_RsLCDrink.GetTrainmanDrinkInfo(Trainman.strTrainmanGUID,
            ChuQinPlan.TrainPlan.strTrainPlanGUID,Ord(wtBeginWork),RsDrink) then
    begin

      lblTrainmanInfo.Caption :=  GetTrainmanText(Trainman);

      lblDrinkTime.Caption := FormatDateTime('yyyy-mm-dd hh:nn:ss',RsDrink.dtCreateTime);
      lblDrinkResult.Caption := TestAlcoholResultToString(TTestAlcoholResult(RsDrink.nDrinkResult));

      lbldwAlcoholicity.Caption := IntToStr(RsDrink.dwAlcoholicity);
      if RsDrink.strPictureURL <> '' then
      begin
        strUrl := RsDrink.strPictureURL;
        if strUrl[1] = '/' then strUrl := Copy(strUrl, 2, Length(strUrl) - 1);
        strFile := ExtractFilePath(Application.ExeName) + ReplaceStr(strUrl, '/', '\');
        if FileExists(strFile) then
        begin
          if GetFileSize(strFile) > 0 then
            imgDrink.Picture.LoadFromFile(strFile)
          else
            imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
        end
        else
        begin
          if m_RsDrinkImage.DownLoad(GlobalDM.WebHost + RsDrink.strPictureURL, GlobalDM.AppPath + TESTPICTURE_CURRENT) then
          begin
            imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_CURRENT);
            strPath := ExtractFilePath(strFile);
            if not DirectoryExists(strPath) then ForceDirectories(strPath);
            CopyFile(PChar(GlobalDM.AppPath + TESTPICTURE_CURRENT), PChar(strFile), false);
          end
          else
            imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
        end;
      end
      else
      begin
        imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
      end;

    end
    else
    begin
      lblTrainmanInfo.Caption := '[-]';
      lblDrinkTime.Caption := '-';
      lblDrinkResult.Caption := '-';
      lbldwAlcoholicity.Caption := '-';
      imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
    end;
  except on e : Exception do
    GlobalDM.LogManage.InsertLog('显示测酒照片异常:'+e.Message);
  end;
end;

procedure TfrmMain_ChuQin.ShowReceivePlan;
const
  X_POS = 80 ;
  Y_POS =100 ;
var
  pt: TPoint;
begin
  if m_hRecvHint > 0  then
    GlobalDM.DestroyHint(m_hRecvHint);
  pt.X := X_POS;
  pt.Y := Y_POS ;
  pt := RzPanel1.ScreenToClient(pt);
  m_hRecvHint := GlobalDM.CreateHint(btnExchangeModule.Parent.Handle, '请在派班室端接收计划!', pt);
end;

procedure TfrmMain_ChuQin.ShowTrainmanPic(ChuQinPlan: RRsChuQinPlan;
  TrainmanSn: Integer);
var
  Trainman: RRsTrainman;
  Stream: TMemoryStream;
  TrainmanID: string;
begin
  Trainman.strTrainmanGUID := '';
  case TrainmanSn  of
    0:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman1;
    1:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman2;
    2:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman3;
    3:Trainman := ChuQinPlan.ChuQinGroup.Group.Trainman4;
  end;

  TrainmanID := Trainman.strTrainmanGUID;
  //获取标准照片
  m_RsLCTrainmanMgr.GetTrainman(TrainmanID,Trainman,2);

  lblTrainmanInfo.Caption :=  Trainman.strTrainmanNumber + '-' + Trainman.strTrainmanName;
  Stream := TMemoryStream.Create;
  try
    TCF_VariantParse.OleVariantToStream(Trainman.Picture,Stream);

    if Stream.Size > 0 then
    begin
      Stream.SaveToFile(GlobalDM.AppPath + '标准照片.jpg');
      imgTrainman.Picture.LoadFromFile(GlobalDM.AppPath + '标准照片.jpg');
    end
    else
      imgTrainman.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);

  finally
    Stream.Free;
  end;


end;

procedure TfrmMain_ChuQin.statusFingerDblClick(Sender: TObject);
begin
  GlobalDM.ReinitFinger();
end;

procedure TfrmMain_ChuQin.statusMatchDblClick(Sender: TObject);
begin
  if not RzPanel8.Visible then
  begin
    RzPanel8.Visible := true;
    QueryLocalDrinkInfo();
  end;
end;

procedure TfrmMain_ChuQin.strGridTrainPlanDblClick(Sender: TObject);
var
  nSelectedCol : integer;
  chuqinPlan : RRsChuQinPlan;
begin
  nSelectedCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if IsICCheckCol(nSelectedCol) then
  begin
    GetSelectedChuQinPlan(chuqinPlan);
    Box(chuqinPlan.strICCheckResult);
  end;
end;

procedure TfrmMain_ChuQin.strGridTrainPlanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter; 
end;

procedure TfrmMain_ChuQin.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = 1 then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        //ABrush.Style := bsSolid ;
        Break;
      end;
    end;
  end;

  if IsDrinkInfoCol(ACol) then
  begin
    if (strGridTrainPlan.Cells[ACol,ARow] = '饮酒')
    or (strGridTrainPlan.Cells[ACol,ARow] = '酗酒')
    or (strGridTrainPlan.Cells[ACol,ARow] = '未测试') then
      AFont.Color := clRed;
  end;
end;

procedure TfrmMain_ChuQin.strGridTrainPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
  col,row : integer;
begin
  if mbRight <> Button then
    Exit;

  strGridTrainPlan.MouseToCell(X,Y,col,row);
  if (row = 0) then
  begin
    pt := Point(X,Y);
    pt := strGridTrainPlan.ClientToScreen(pt);
    pMenuColumn.Popup(pt.X,pt.y);
    exit;
  end;
  GetCursorPos(PT);

  if IsTrainmanCol(strGridTrainPlan.RealColIndex(strGridTrainPlan.Col))
    or IsSubTrainmanCol(strGridTrainPlan.RealColIndex(strGridTrainPlan.Col))
    or IsXueYuanTrainmanCol(strGridTrainPlan.RealColIndex(strGridTrainPlan.Col))
    or IsXueYuan2TrainmanCol(strGridTrainPlan.RealColIndex(strGridTrainPlan.Col)) then
  begin
    if strGridTrainPlan.Row <= Length(m_ChuQinPlanArray) then
      PopupMenu.Popup(PT.X,PT.Y);
  end;


end;
    
procedure TfrmMain_ChuQin.strGridTrainPlanSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var                
  ChuQinPlan: RRsChuQinPlan;
  nTrainmanSn: integer;
  selectCol : Integer;
  tm : RRsTrainman;
begin
  lblTrainmanInfo.Caption := '[-]';
  lblDrinkTime.Caption := '-';
  lblDrinkResult.Caption := '-';
  imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
  if ARow < 1 then Exit;
  if ARow > length(m_ChuQinPlanArray) then exit;
  selectCol := strgridTrainPlan.RealColIndex(ACol);
  if strGridTrainPlan.Cells[selectCol, ARow] = '' then exit;

  ChuQinPlan := m_ChuQinPlanArray[ARow - 1];
  nTrainmanSn := -1;

  if IsTrainmanCol(selectCol) then
  begin
    nTrainmanSn := 0;
    tm := ChuQinPlan.ChuQinGroup.Group.Trainman1;
  end;
  if IsSubTrainmanCol(selectCol) then
  begin
    nTrainmanSn := 1;
    tm := ChuQinPlan.ChuQinGroup.Group.Trainman2;
  end;
  if IsXueYuanTrainmanCol(selectCol) then
  begin
    nTrainmanSn := 2;
    tm := ChuQinPlan.ChuQinGroup.Group.Trainman3;
  end;
  if IsXueYuan2TrainmanCol(selectCol) then
  begin
    nTrainmanSn := 3;
    tm := ChuQinPlan.ChuQinGroup.Group.Trainman4;
  end;
  if nTrainmanSn >= 0 then
  begin
    ShowDringImage(ChuQinPlan,nTrainmanSn);
    if m_bShowTMPic then    
      ShowTrainmanPic(ChuQinPlan,nTrainmanSn);
    if m_bShowWorkFlow then    
    DrawBeginworkFlow(imgBeginworkFlow.Canvas,
      Rect(0,0,imgBeginworkFlow.Width,imgBeginworkFlow.Height),tm,ChuQinPlan);
  end;
end;

procedure TfrmMain_ChuQin.InitChuQinPlans;
begin
  PostMessage(Handle,WM_Message_Refresh,0,0)
end;

procedure TfrmMain_ChuQin.InitData;
var
  strDutyPlaceID : string;
begin
  TtfSkin.InitRzPanel(RzPanel1);
  TtfSkin.InitRzPanel(rzpBeginworkFlow);
  TtfSkin.InitRzPanel(rzpTrainmanInfo);
  TtfSkin.InitRzTab(tabTrainJiaolu);
  TtfSkin.InitAdvGrid(strGridTrainPlan);

  m_bShowTMPic :=
  ReadIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowTMPic',True);

  m_bShowWorkFlow :=
  ReadIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowWorkFlow',True);

  m_bPrintJSOldMode := GlobalDM.DB_SysConfig('JFJSCfg','PrintOldMode') = '1';

  gbTrainman.Visible := m_bShowTMPic;
  rzpTrainmanInfo.Visible := m_bShowTMPic;

   
  //获取所管理的计划
  strDutyPlaceID := GlobalDM.DutyPlaceID ;
  if strDutyPlaceID = '' then
  begin
    Box('没有关注的外勤端,无法收到机车计划更新消息！');
  end else begin
    m_nDayPlanID := StrToInt(strDutyPlaceID)  ;
  end;

  //当前登录用户
  statusDutyUser.Caption := '值班员: ' + GlobalDM.DutyUser.strDutyName;
  statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);

  InitTrainJiaolus;
  InitChuQinPlans;

  m_RsDrinkImage.URLHost := GlobalDM.WebHost + GlobalDM.WebDrinkImgPage;

  Caption := '出勤管理 ' + GetFileVersion(Application.ExeName);

  miTestFun.Visible := GlobalDM.IniConfig('UserData','TestFun') = '1';


  with TMenuItemCtl.Create do
  begin
    try
      Load;
      InitMenu('出勤窗口',MainMenu1);
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain_ChuQin.InitTrainJiaolus;
var
  tab:TRzTabCollectionItem;
begin
  tabTrainJiaolu.Tabs.Clear;
  tab := tabTrainJiaolu.Tabs.Add;
  tab.Caption := GlobalDM.SiteInfo.strSiteName;
end;


function TfrmMain_ChuQin.IsDrinkInfoCol(nCol: integer): Boolean;
var
  sVal: string;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  sVal := strGridTrainPlan.ColumnHeaders.Strings[nCol];
  Result := Pos('酒',sVal) > 0;
end;

function TfrmMain_ChuQin.IsICCheckCol(nCol: integer): boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '验卡结果');
end;

function TfrmMain_ChuQin.IsSubTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '副司机');
end;
function TfrmMain_ChuQin.IsTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '司机');
end;

function TfrmMain_ChuQin.IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员2');
end;

function TfrmMain_ChuQin.IsXueYuanTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员');
end;

procedure TfrmMain_ChuQin.TimerImportDrinkTimer(Sender: TObject);
begin
  TimerImportDrink.Enabled := false;
  RefreshLocalDrinkAlarm;
end;

procedure TfrmMain_ChuQin.timerPlaySoundTimer(Sender: TObject);
{
 第一次 直接播放声音
 第二次来的时候则必须大于指定的间隔
}
const
  PLAY_SOUND_INTERVAL = 10000;
begin
  if ( ( m_nSoundTickCount > 0 ) and  ( GetTickCount - m_nSoundTickCount >= PLAY_SOUND_INTERVAL ) )
   or
   ( m_nSoundTickCount = 0 )
  then
  begin
    GlobalDM.PlaySoundFile('接收计划.wav');
    m_nSoundTickCount := GetTickCount ;
  end;
end;

procedure TfrmMain_ChuQin.ChuQin(strNumber: string);
var
  strError : string ;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
begin
  GlobalDM.FingerPrintCtl.OnTouch := nil;
  try
    //检查工号是否存在
    if not m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman,2) then
    begin
      strError := format('工号:[%s] 不存在 , 是否创建该工号?',[Trim(strNumber)])  ;
      if not TBox(strError) then
        exit;

      //创建工号,并设置人员的指纹信息[可选]
      if not CreateOuterSideTrainman(strNumber) then
        Exit ;
        
      //重新获取一下人员的信息
      m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman,2)
    end;

    Verify :=  rfInput;

    
    ExecChuQin(Trainman,Verify);
  finally
    GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  end;
end;

function TfrmMain_ChuQin.CreateOuterSideTrainman(strNumber: string):boolean;
var
  trainman: RRsTrainman;
  strTrainmanName:string;
  strJwdCode: string;
begin
  Result := True ;
  //第一步创建人员
  if not TFrmOuterSideTrainman.CreateOuterSideTrainman(strNumber,strTrainmanName,strJwdCode) then
  begin
    Result := False ;
    Exit;
  end;
  trainman.strTrainmanName := strTrainmanName;
  //第二步设置指纹信息
  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    if ModifyTrainmanPicFig(trainman.strTrainmanGUID) then
    begin
      GlobalDM.FingerPrintCtl.ServerFingerCtl.FinerID := NewGUID;
    end;
  end
end;

procedure TfrmMain_ChuQin.DrawBeginworkFlow(Canvas: TCanvas;R : TRect;
  Trainman : RRsTrainman;Plan : RRsChuQinPlan);
var
  t,i,k,h : integer;
  rTemp : TRect;
  flowArray : TRsBeginworkFlowArray;
  stepArray : TRsTrainmanBeginworkStepArray;
  trainFlow : RRsTrainplanBeginworkFlow;
  strTemp,strVerifyName,strDrinkResultName : string;
  bmp : TBitmap;
  io : ISuperObject;
begin
  if (Trainman.strTrainmanGUID = '') then exit;
  Canvas.FillRect(r);
  if (plan.TrainPlan.strTrainPlanGUID = '') then exit;
  
  m_LCBeginwork.GetPlanBeginworkFlow(Plan.TrainPlan.strTrainPlanGUID,
    GlobalDM.SiteInfo.WorkShopGUID,flowArray,stepArray,trainFlow);

  //花流程区域背景
  Canvas.Brush.Color := Rgb(238,243,249);
  rTemp := Rect(R.Left,R.Top,R.Left + 60,r.Bottom);
  Canvas.FillRect(rTemp);
  Canvas.Brush.Color := clWhite;


  bmp := TBitmap.Create;
  try
    imglstBeginworkFlow.GetBitmap(0,bmp);
    //花垂直分割线
    Canvas.Brush.Bitmap := bmp;
    rTemp := Rect(R.Left + 53,R.Top,R.Left + 57,r.Bottom);
    Canvas.FillRect(rTemp);
    Canvas.Brush.Color := clWhite;
  finally
    bmp.Free;
  end;

  t := 10;
  SetBkMode(canvas.Handle,TRANSPARENT);
  for i := 0 to length(FlowArray) - 1 do
  begin
    Canvas.TextOut(R.Left,r.Top + t,FlowArray[i].strStepName);
    bmp := TBitmap.Create;
    try
      Canvas.Brush.Color := clWhite;
      imglstBeginworkflow2.GetBitmap(0,bmp);
      for k := 0 to length(stepArray) - 1 do
      begin
        if Trainman.strTrainmanGUID = stepArray[k].strTrainmanGUID then
        begin
          if FlowArray[i].nStepID = stepArray[k].nStepID then
          begin
            imglstBeginworkFlow2.GetBitmap(1,bmp);
            strTemp := stepArray[k].strStepResultText;
            case FlowArray[i].nStepID of
              1009 : begin
                strTemp := Formatdatetime('yyyy-MM-dd HH:nn:ss',stepArray[k].dtEventTime);
                strTemp := Format(' 勾画时间:%s',[strTemp]);
              end;
              1012 : begin
                strTemp := Formatdatetime('yyyy-MM-dd HH:nn:ss',stepArray[k].dtEventTime);
                strTemp := Format(' 打印时间:%s',[strTemp]);
              end;
              1013 : begin
                strTemp := Formatdatetime('yyyy-MM-dd HH:nn:ss',stepArray[k].dtEventTime);
                strTemp := Format(' 查看时间:%s',[strTemp]);
              end;
              1003 : begin
                io := so(stepArray[k].strStepResultText);
                if (io <> nil) then
                begin
                  strVerifyName := '工号';
                  if (io.I['VerfiyID'] = 1) then
                    strVerifyName := '指纹';
                  case TTestAlcoholResult(io.I['TestAlcoholResult']) of
                    taNormal : strDrinkResultName := '正常';
                    taAlcoholContentMiddling : strDrinkResultName := '饮酒';
                    taAlcoholContentHeight : strDrinkResultName := '酗酒';
                    taNoTest : strDrinkResultName := '未测试';
                  end;
                strTemp := Format(' 时间:%s,结果:%s,验证:%s,酒精:%s.',
                  [io.S['TestTime'],strDrinkResultName, strVerifyName,io.S['Alcoholicity']]);
                  //{"TestAlcoholResult":0,"VerfiyID":1,"TestTime":"2015-09-25T17:31:23","TestPicturePath":"/DrinkImage/2015/9/25/201509251731232302470.jpg","Alcoholicity":0}
                end;
              end;
              1004 : begin
                strTemp := Formatdatetime('yyyy-MM-dd HH:nn:ss',stepArray[k].dtEventTime);
                strTemp := Format(' 阅读时间:%s.',[strTemp]);
              end;
              1008 : begin
                strTemp := Formatdatetime('yyyy-MM-dd HH:nn:ss',stepArray[k].dtEventTime);
                strTemp := Format(' 验卡时间:【%s】,验卡结果:【%s】',[strTemp,stepArray[k].strStepResultText]);
                strTemp := ReplaceStr(strTemp,char(10),'');
                strTemp := ReplaceStr(strTemp,char(13),'');
              end;
            end;
            break;
          end;
        end;
      end;
      //Canvas.Ellipse(R.Left + 55 - 5,r.Top + t + 3,R.Left + 55 + 5,r.Top + t + 13);
      Canvas.Draw(R.Left + 55 - 5,r.Top + t + 3,bmp);
    finally
      bmp.Free;
    end;

    

    rTemp := Rect(r.Left + 60 + 5,r.Top + t ,r.Right - 5,r.Top + t + 40);
    //strTemp :='撒打飞机啊送到附近啊三菱电机法律上款到即发拉升阶段分厘卡时间大幅';
    Canvas.TextRect(rTemp,strTemp,[tfLeft,tfTop,tfWordBreak,tfEndEllipsis]);


    case FlowArray[i].nStepID of
      1009 : begin
        h := t + 30;
        t := t +40;
      end;
      1012 : begin
        h := t + 30;
        t := t +40;
      end;
      1013 : begin
        h := t + 30;
        t := t +40;
      end;
      1003 : begin
        h := t + 30;
        t := t +80;
      end;
      1004 : begin
        h := t + 30;
        t := t +40;
      end;
      1008 : begin
        h := t + 50;
        t := t +60;
      end;
    else
      h := t + 50;
    end;
    canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clGray;
    canvas.MoveTo(r.Left + 60 + 10,r.Top + h);
    canvas.LineTo(r.Right - 10,r.Top + h);
    canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clBlack;
  end;

end;

procedure TfrmMain_ChuQin.tmrReadTimeTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    ReadFingerprintState();

    if GlobalDM.IsConnected then
    begin
      if GetTickCount - m_nTickCount >= 10000 then
      begin

        if FrmDisconnectHint <> nil then FrmDisconnectHint.CloseForm;
      end;
    end else begin
      if GetTickCount - m_nTickCount >= 30000 then
      begin
        m_nTickCount := GetTickCount;
        TFrmDisconnectHint.ShowForm;
        FrmDisconnectHint.OnChangeMode := ExchangeModeProc;
        FrmDisconnectHint.OnExitSystem := ExitSystemProc;
        if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
      end;
    end;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    statusMessage.Caption := Format('消息缓存：%d条', [GlobalDM.TFMessageCompnent.MessageBufferCount]);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;


function TfrmMain_ChuQin.UploadAlcoholResult(Trainman : RRsTrainman;TrainmanPlan : RRsTrainmanPlan;Verify :  TRsRegisterFlag): Boolean;
var
  post: TRsPost;
  testResult: RTestAlcoholInfo;
  RsDrink: RRsDrink;
  dtNow: TDateTime;
  strRemark: string;
begin
  result := false;
  post := ptTrainman;
  
  //测酒
  TestDrinking(Trainman,trainmanPlan.TrainPlan.strTrainTypeName,
    trainmanPlan.TrainPlan.strTrainNumber,trainmanPlan.TrainPlan.strTrainNo,
     testResult,m_RightBottomPopWindow);


  strRemark := '';


  //测酒结果异常需要收工确认
  if testResult.taTestAlcoholResult <> taNormal then
  begin
    if GlobalDM.BeginWorkValidateShow then    
    begin
      if testResult.taTestAlcoholResult = taNoTest then GlobalDM.PlaySoundFile('请输入未测酒原因.wav');
      if not TFrmChuQin.ShowChuQinForm(Trainman,Verify,Post,testResult,trainmanPlan,strRemark) then exit;
    end;
  end ;

  try
    try
      RsDrink.AssignFromTestAlcoholInfo(testResult);
      RsDrink.strRemark := strRemark;

      dtNow := GlobalDM.GetNow;
      GlobalDM.PlaySoundFile('正在保存出勤记录请稍候.wav');
      TfrmHint.ShowHint('正在上传测酒照片,请稍候……');
      RsDrink.strPictureURL := PostDrinkImage(Trainman,testResult);
      //检查测酒照片是否为空
      if RsDrink.strPictureURL = '' then
      begin
        if not tbox('测酒照片为空,是否继续') then
        begin
          raise Exception.Create('测酒照片为空！');
          Exit;
        end;
      end;
      //人员信息
      RsDrink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber)  ;

      RsDrink.strTrainmanGUID := Trainman.strTrainmanGUID ;
      RsDrink.strTrainmanName := Trainman.strTrainmanName ;
      RsDrink.strTrainmanNumber := Trainman.strTrainmanNumber;
      //车次信息
      RsDrink.strTrainNo :=  trainmanPlan.TrainPlan.strTrainNo ;
      RsDrink.strTrainNumber :=  trainmanPlan.TrainPlan.strTrainNumber ;
      RsDrink.strTrainTypeName :=  trainmanPlan.TrainPlan.strTrainTypeName ;
      //出勤点信息
      RsDrink.strPlaceID := GlobalDM.DutyPlace.placeID ;
      RsDrink.strPlaceName := GlobalDM.DutyPlace.placeName ;
      RsDrink.strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
      RsDrink.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
      RsDrink.strSiteName := GlobalDM.SiteInfo.strSiteName ;

      RsDrink.strDutyGUID := GlobalDM.DutyUser.strDutyGUID ;
      RsDrink.strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
      RsDrink.strDutyName := GlobalDM.DutyUser.strDutyName ;

      RsDrink.strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);

      RsDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
      RsDrink.strWorkShopName := Trainman.strWorkShopName ;

      //发送测酒信息
      RsDrink.nVerifyID := ord(Verify);
      RsDrink.nWorkTypeID := DRINK_TEST_CHU_QIN ;
      PostAlcoholMessage(Trainman,RsDrink);

      TfrmHint.ShowHint('正在保存出勤记录……');

      SaveBeginWorkData(Trainman.strTrainmanGUID,trainmanPlan,
        RsDrink,GlobalDM.SiteInfo.strStationGUID);
        
      PostWorkBeginMessage(Trainman,trainmanPlan,testResult.taTestAlcoholResult,dtNow);
      
      GlobalDM.PlaySoundFile('出勤成功.wav');
      TfrmHint.ShowHintDelay('出勤成功!');
    finally
      TfrmHint.CloseHint();
    end;
    InitChuQinPlans;
  except on e : exception do
    begin
      GlobalDM.PlaySoundFile('出勤失败.wav');
      BoxErr('出勤失败:' + e.Message);
    end;
  end;

end;

function TfrmMain_ChuQin.UploadDrinkInfo(Trainman: RRsTrainman;DrinkInfo: RRsDrinkInfo): Boolean;
var
  RDrink: RRsDrink;
  testAlcoholInfo : RTestAlcoholInfo ;
  dutyUser :TRsDutyUser;
begin
  Result := False ;

  testAlcoholInfo.dtTestTime := DrinkInfo.dtCreateTime;
  testAlcoholInfo.taTestAlcoholResult := TTestAlcoholResult(DrinkInfo.nDrinkResult);
  testAlcoholInfo.Picture := DrinkInfo.DrinkImage;
  testAlcoholInfo.nAlcoholicity := DrinkInfo.dwAlcoholicity ;
  dutyUser :=TRsDutyUser.Create;
  try
    try
      RDrink.AssignFromTestAlcoholInfo(testAlcoholInfo);
      RDrink.strPictureURL := PostDrinkImage(trainman,testAlcoholInfo);

      //人员信息
      RDrink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber) ;
      RDrink.strTrainmanGUID := Trainman.strTrainmanGUID ;
      RDrink.strTrainmanName := Trainman.strTrainmanName ;
      RDrink.strTrainmanNumber := Trainman.strTrainmanNumber;
      //车次信息
      RDrink.strTrainNo :=  DrinkInfo.strTrainNo ;
      RDrink.strTrainNumber :=  DrinkInfo.strTrainNumber ;
      RDrink.strTrainTypeName :=  DrinkInfo.strTrainTypeName ;
      //出勤点信息
      RDrink.strPlaceID := GlobalDM.DutyPlace.placeID ;
      RDrink.strPlaceName := GlobalDM.DutyPlace.placeName ;
      RDrink.strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
      RDrink.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
      RDrink.strSiteName := GlobalDM.SiteInfo.strSiteName ;


      RDrink.strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);

      
      RDrink.strDutyNumber := DrinkInfo.strDutyNumber;
      if m_RsLCDutyUser.GetDutyUserByNumber(DrinkInfo.strDutyNumber,dutyUser) = True then
        RDrink.strDutyName:= dutyUser.strDutyName;

      RDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
      RDrink.strWorkShopName := Trainman.strWorkShopName ;

      //发送测酒信息
      RDrink.nVerifyID := DrinkInfo.nVerifyID ;
      RDrink.nWorkTypeID := DrinkInfo.nWorkTypeID  ;

      PostAlcoholMessage(trainman,RDrink);
      
      m_RsLCDrink.AddDrinkInfo(RDrink);
      //TtfPopBox.ShowBox('保存测酒记录成功');
      result := true ;
    except on e : exception do
      begin
        BoxErr('保存测酒记录失败:' + e.Message);
      end;
    end;
  finally
    TfrmHint.CloseHint;
    dutyUser.Free ;
  end;
end;


procedure TfrmMain_ChuQin.WMFingerUpdate(var Message: TMessage);
var
  v: Double;
begin
  v := ComposeDWord(Message.WParam,Message.LParam);
  statusFingerTime.Caption := FormatDateTime('mm-dd hh:nn',TDateTime(v));
end;

procedure TfrmMain_ChuQin.WMMessageRefresh(var Message: TMessage);
var
  i : integer;
  dtNow: TDateTime;
begin
  try
    GetDataArray(True);

    dtNow := GlobalDM.GetNow;
    strGridTrainPlan.BeginUpdate;
    with strGridTrainPlan do
    begin

      ClearRows(1, 10000);
      if length(m_ChuqinPlanArray) > 0 then
        RowCount := length(m_ChuqinPlanArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_ChuqinPlanArray) - 1 do
      begin
        RowColor[i + 1] := clWhite;

        //事件在出勤前30分钟以后
        if (IncMinute(dtNow,20) > m_ChuqinPlanArray[i].TrainPlan.dtStartTime)
          and (m_ChuqinPlanArray[i].TrainPlan.nPlanState < psBeginWork) then
        begin
          RowColor[i + 1] := $00BFFFFF;
        end;
        //事件在出勤前5分钟以后

        if (IncMinute(dtNow,5) > m_ChuqinPlanArray[i].TrainPlan.dtStartTime)
          and (m_ChuqinPlanArray[i].TrainPlan.nPlanState < psBeginWork) then
        begin
          RowColor[i + 1] := clRed;
        end;
        
        //有人测酒但是没有全部出勤
        if ((m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime > 0) or
          (m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime > 0) or
          (m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime > 0) or
          (m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo4.dtTestTime > 0)) and
          (m_ChuqinPlanArray[i].TrainPlan.nPlanState < psBeginWork) then
        begin
          RowColor[i + 1] := clRed;
        end;

        Cells[0, i + 1] := IntToStr(i + 1);
        if m_ChuqinPlanArray[i].nFlowState = 1 then
          Cells[0, i + 1] := IntToStr(i + 1) + '√';       
        Cells[1, i + 1] := TRsPlanStateNameAry[m_ChuqinPlanArray[i].TrainPlan.nPlanState];
        Cells[2, i + 1] := m_ChuqinPlanArray[i].TrainPlan.strTrainJiaoluName;
        Cells[3, i + 1] :=  m_ChuqinPlanArray[i].TrainPlan.strTrainTypeName + '-' +  m_ChuqinPlanArray[i].TrainPlan.strTrainNumber;
        Cells[4, i + 1] :=  m_ChuqinPlanArray[i].TrainPlan.strTrainNo;
        Cells[5,i + 1] :=  FormatDateTime('MM-dd hh:nn', m_ChuqinPlanArray[i].TrainPlan.dtStartTime);
        Cells[6, i + 1] := FormatDateTime('MM-dd hh:nn', m_ChuqinPlanArray[i].TrainPlan.dtChuQinTime);
        Cells[7, i + 1] := FormatDateTime('MM-dd hh:nn', m_ChuqinPlanArray[i].TrainPlan.dtRealStartTime);
        if m_ChuqinPlanArray[i].dtBeginWorkTime > 0 then
          Cells[8, i + 1] := FormatDateTime('MM-dd hh:nn', m_ChuqinPlanArray[i].dtBeginWorkTime);
        Cells[9, i + 1] := m_ChuqinPlanArray[i].TrainPlan.strStartStationName;
        Cells[10, i + 1] := m_ChuqinPlanArray[i].TrainPlan.strEndStationName;
        Cells[11, i + 1] := TRsTrainmanTypeName[m_ChuqinPlanArray[i].TrainPlan.nTrainmanTypeID];
        Cells[12, i + 1] := TRsPlanTypeName[m_ChuqinPlanArray[i].TrainPlan.nPlanType];
        Cells[13, i + 1] := TRsDragTypeName[m_ChuqinPlanArray[i].TrainPlan.nDragType];
        Cells[14, i + 1] := TRsKeHuoNameArray[m_ChuqinPlanArray[i].TrainPlan.nKeHuoID];
        if m_ChuqinPlanArray[i].TrainPlan.nRemarkType = prtOther then
           Cells[15, i + 1] := m_ChuqinPlanArray[i].TrainPlan.strRemark
        else
          Cells[15, i + 1] := TRsPlanRemarkTypeName[m_ChuqinPlanArray[i].TrainPlan.nRemarkType];
        Cells[16, i + 1] := GetICCheckResult(m_ChuqinPlanArray[i].strICCheckResult);
        FontColors[16,i+1] := GetICCheckFontColor(m_ChuqinPlanArray[i]);
        if m_ChuqinPlanArray[i].ChuQinGroup.Group.strGroupGUID  <> '' then
        begin
          //晚出勤加红
          FontColors[17,i+1] := clBlack;
          if (m_ChuqinPlanArray[i].TrainPlan.dtStartTime < m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime) then
            FontColors[17,i+1] := clRed;
          //司机
          Cells[17, i + 1] := GetTrainmanText(m_ChuqinPlanArray[i].ChuQinGroup.Group.Trainman1);
          FontStyles[17,i+1] := [fsBold];
          Cells[18, i + 1] := '';
          Cells[19, i + 1] := '';
          if  m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo1.dtTestTime > 0 then
          begin
            Cells[18, i + 1] := TestAlcoholResultToString(m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult);
            Cells[19, i + 1] := TRsRegisterFlagNameAry[m_ChuqinPlanArray[i].ChuQinGroup.nVerifyID1];
          end;
          //晚出勤加红
          FontColors[20,i+1] := clBlack;
          if (m_ChuqinPlanArray[i].TrainPlan.dtStartTime < m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime) then
            FontColors[20,i+1] := clRed;
          //副司机
          Cells[20, i + 1] := GetTrainmanText(m_ChuqinPlanArray[i].ChuQinGroup.Group.Trainman2);
          FontStyles[20,i+1] := [fsBold];
          Cells[21, i + 1] := '';
          Cells[22, i + 1] := '';
          if  m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo2.dtTestTime > 0 then
          begin
            Cells[21, i + 1] := TestAlcoholResultToString(m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult);
            Cells[22, i + 1] := TRsRegisterFlagNameAry[m_ChuqinPlanArray[i].ChuQinGroup.nVerifyID2];
          end;
          //晚出勤加红
          FontColors[23,i+1] := clBlack;
          if (m_ChuqinPlanArray[i].TrainPlan.dtStartTime < m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime) then
            FontColors[23,i+1] := clRed;
          //学员
          Cells[23, i + 1] := GetTrainmanText(m_ChuqinPlanArray[i].ChuQinGroup.Group.Trainman3);
          FontStyles[23,i+1] := [fsBold];
          Cells[24, i + 1] := '';
          Cells[25, i + 1] := '';
          if  m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo3.dtTestTime > 0 then
          begin
            Cells[24, i + 1] := TestAlcoholResultToString(m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult);
            Cells[25, i + 1] := TRsRegisterFlagNameAry[m_ChuqinPlanArray[i].ChuQinGroup.nVerifyID3];
          end;
          //晚出勤加红
          FontColors[26,i+1] := clBlack;
          if (m_ChuqinPlanArray[i].TrainPlan.dtStartTime < m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo4.dtTestTime) then
            FontColors[26,i+1] := clRed;
           //学员2
          Cells[26, i + 1] := GetTrainmanText(m_ChuqinPlanArray[i].ChuQinGroup.Group.Trainman4);
          FontStyles[22,i+1] := [fsBold];
          Cells[27, i + 1] := '';
          Cells[28, i + 1] := '';
          if  m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo4.dtTestTime > 0 then
          begin
            Cells[27, i + 1] := TestAlcoholResultToString(m_ChuqinPlanArray[i].ChuQinGroup.TestAlcoholInfo4.taTestAlcoholResult);
            Cells[28, i + 1] := TRsRegisterFlagNameAry[m_ChuqinPlanArray[i].ChuQinGroup.nVerifyID4];
          end;  
        end;

        Cells[29 , i + 1 ] := m_ChuqinPlanArray[i].TrainPlan.strPlaceName ;


        if m_ChuqinPlanArray[i].TrainPlan.nNeedRest > 0 then
        begin
          Cells[30, i + 1] := '侯班';
          Cells[31, i + 1] := FormatDateTime('yy-MM-dd hh:nn', m_ChuqinPlanArray[i].TrainPlan.dtArriveTime);
          Cells[32, i + 1] := FormatDateTime('yy-MM-dd hh:nn', m_ChuqinPlanArray[i].TrainPlan.dtCallTime);
        end;

        Cells[99, i + 1] := m_ChuqinPlanArray[i].TrainPlan.strTrainPlanGUID;
      end;
    end;
  finally
   strGridTrainPlan.EndUpdate; ;
  end;
end;

//==============================================================================

procedure TfrmMain_ChuQin.grdMainCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if ACol = 5 then CanEdit := True;
end;

procedure TfrmMain_ChuQin.grdMainCheckBoxChange(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
var
  nDelFlag: integer;
  dbConnAccess: TConnAccess;
begin
  nDelFlag := 0;
  if State then nDelFlag := 2;

  dbConnAccess := TConnAccess.Create(Application);
  try
    if not dbConnAccess.ConnectAccess then
    begin
      Box('连接本地数据库异常，导入失败!');
      Exit;
    end;
    dbConnAccess.UpdateDrinkState(m_LocalDrinkArray[ARow-1].nDrinkInfoID, nDelFlag);
    RefreshLocalDrinkAlarm(dbConnAccess);
  finally
    dbConnAccess.Free;
  end;
end;

procedure TfrmMain_ChuQin.grdMainGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_ChuQin.btnImportDrinkClick(Sender: TObject);
var
  nRow, nCol,  nImportCount: integer;
  dbConnAccess: TConnAccess;
  blnCheck: boolean;
  importPlan : RRsImportPlan;
  chuqinPlan : RRsChuQinPlan;
  trainman : RRsTrainman;
begin
  dbConnAccess := TConnAccess.Create(Application);
  try
    nImportCount := 0;
    nCol := grdMain.Col;
    grdMain.Col := 1;   
    grdMain.Col := nCol;
    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      if blnCheck then Continue;      
      if grdMain.Cells[99, nRow] <> '' then
      begin
        if (not blnCheck) then
          nImportCount := nImportCount + 1;
      end;
    end;
    if nImportCount = 0 then
    begin
      Box('没有待匹配的记录，操作不能继续！');
      exit;
    end;
    if not TBox(Format('待匹配的有%d条，您确认要继续操作吗？', [nImportCount])) then exit;
    
    if not dbConnAccess.ConnectAccess then
    begin
      Box('连接本地数据库异常，导入失败!');
      Exit;
    end;

    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      TfrmProgressEx.ShowProgress('上传出勤记录',nRow,grdMain.RowCount-1);
      Application.ProcessMessages;
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      GlobalDM.LogManage.InsertLog('上传断网测酒记录--1开始上传断网测酒记录');
      if grdMain.Cells[99, nRow] <> '' then
      begin
        if blnCheck then continue;
        if not m_RsLCTrainmanMgr.GetTrainmanByNumber(m_LocalDrinkArray[nRow-1].strTrainmanNumber,trainman) then
        begin
          GlobalDM.LogManage.InsertLog('上传断网测酒记录---2获取员工号失败,员工号:'+m_LocalDrinkArray[nRow-1].strTrainmanNumber);
          continue;
        end;

        
        if not m_LCBeginwork.GetBeginworkPlanByTime(trainman.strTrainmanNumber,m_LocalDrinkArray[nRow-1].dtCreateTime,GlobalDM.SiteInfo.strSiteGUID,chuqinPlan) then
        begin
          GlobalDM.LogManage.InsertLog('上传断网测酒记录--3没有找到该员工的计划,员工号:'+trainman.strTrainmanNumber);
          continue;
        end;

        importPlan.TrainPlan := chuqinPlan.TrainPlan;
        importPlan.Group := chuqinPlan.ChuQinGroup.Group;
        importplan.Trainman := trainman;

        importPlan.blnMatched := true;
        importPlan.nVerifyID := TRsRegisterFlag(m_LocalDrinkArray[nRow-1].nVerifyID);
        importPlan.TestAlcoholInfo.dtTestTime := m_LocalDrinkArray[nRow-1].dtCreateTime;
        importPlan.TestAlcoholInfo.taTestAlcoholResult := TTestAlcoholResult(m_LocalDrinkArray[nRow-1].nDrinkResult);
        importPlan.TestAlcoholInfo.Picture := m_LocalDrinkArray[nRow-1].DrinkImage;
        importPlan.TestAlcoholInfo.nAlcoholicity := m_LocalDrinkArray[nRow-1].dwAlcoholicity;
        importPlan.nDrinkInfoID := m_LocalDrinkArray[nRow-1].nDrinkInfoID;

        if ImportDrinkInfo(chuqinPlan,trainman,m_LocalDrinkArray[nRow-1])  then
          dbConnAccess.UpdateDrinkState(m_LocalDrinkArray[nRow-1].nDrinkInfoID)
        else
          GlobalDM.LogManage.InsertLog('上传断网测酒记录--4导入测酒记录失败');
      end;
    end;
    InitChuQinPlans;
  finally
    GlobalDM.LogManage.InsertLog('上传断网测酒记录结束1');
    TfrmProgressEx.CloseProgress;
    dbConnAccess.Free;

    QueryLocalDrinkInfo;
    RefreshLocalDrinkAlarm(dbConnAccess);
    GlobalDM.LogManage.InsertLog('上传断网测酒记录结束2');
  end;
end;

procedure TfrmMain_ChuQin.btnImportPlanClick(Sender: TObject);
begin
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo(True); 
end;


procedure TfrmMain_ChuQin.btnManulBeginWorkClick(Sender: TObject);
var
  strNumber : string;
begin
  //输入工号
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
    Exit;
  //执行出勤
  ChuQin(strNumber);
end;

procedure TfrmMain_ChuQin.actF5Execute(Sender: TObject);
begin
  InitChuQinPlans;
end;

procedure TfrmMain_ChuQin.btnCancelDrinkClick(Sender: TObject);
var
  nRow, nCol, nDelete: integer;
  dbConnAccess: TConnAccess;
  blnCheck: boolean;
begin
  dbConnAccess := TConnAccess.Create(Application);
  try
    nDelete := 0;
    nCol := grdMain.Col;
    grdMain.Col := 1;   
    grdMain.Col := nCol;
    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      if blnCheck then Continue;
      nDelete := nDelete + 1;
    end;
    if nDelete = 0 then
    begin
      Box('没有待忽略的记录，操作不能继续！');
      exit;
    end;
    if not TBox(Format('待忽略的有%d条，您确认要继续操作吗？', [nDelete])) then exit;
    
    if not dbConnAccess.ConnectAccess then
    begin
      Box('连接本地数据库异常，导入失败!');
      Exit;
    end;



    for nRow := 1 to grdMain.RowCount - 1 do
    begin
      Application.ProcessMessages;
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      if blnCheck then Continue;

      dbConnAccess.UpdateDrinkState(m_LocalDrinkArray[nRow-1].nDrinkInfoID, 2);
      grdMain.SetCheckBoxState(5, nRow, True);
    end;

    RefreshLocalDrinkAlarm(dbConnAccess);
    QueryLocalDrinkInfo;
  finally
    dbConnAccess.Free;
  end;


end;

procedure TfrmMain_ChuQin.btnHideDrinkClick(Sender: TObject);
begin
  AdvSplitter1.Visible := false;
  RzPanel8.Visible := false;
end;

procedure TfrmMain_ChuQin.QueryLocalDrinkInfo();
var
  dbConnAccess: TConnAccess;
  i: integer;
  drinkQuery: RRsDrinkQuery;
begin
  dbConnAccess := TConnAccess.Create(Application);
  try
    if not dbConnAccess.ConnectAccess then exit;
    try
      drinkQuery.nWorkTypeID := 0;
      drinkQuery.strTrainmanNumber := '';
      drinkQuery.dtBeginTime := 0;
      drinkQuery.dtEndTime := 0;
      dbConnAccess.QueryDrinkInfo(drinkQuery, m_LocalDrinkArray);
      with grdMain do
      begin
        ClearRows(1, RowCount - 1);
        ClearCols(99, 99);
        RowCount := Length(m_LocalDrinkArray) + 1;
        if RowCount = 1 then
        begin
          RowCount := 2;
          FixedRows := 1;
        end;
        for i := 0 to Length(m_LocalDrinkArray) - 1 do
        begin
          Cells[0, i + 1] := inttoStr(i + 1);
          Cells[1, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',m_LocalDrinkArray[i].dtCreateTime);
          Cells[2, i + 1] := Format('%6s[%s]', [m_LocalDrinkArray[i].strTrainmanName, m_LocalDrinkArray[i].strTrainmanNumber]);
          Cells[3, i + 1] := TestAlcoholResultToString(TTestAlcoholResult(m_LocalDrinkArray[i].nDrinkResult));
          Cells[4, i + 1] := TRsRegisterFlagNameAry[TRsRegisterFlag(m_LocalDrinkArray[i].nVerifyID)];
          if m_LocalDrinkArray[i].nDelFlag = 2 then
            AddCheckBox(5, i + 1, True, False)
          else
            AddCheckBox(5, i + 1, False, False);
          Cells[99, i + 1] := IntToStr(m_LocalDrinkArray[i].nDrinkInfoID);
        end;
      end;
    except on e : exception do
      begin
        BoxErr('查询信息失败:' + e.Message);
      end;
    end;
  finally
    dbConnAccess.Free;
  end;
  AdvSplitter1.Visible := true;
  RzPanel8.Visible := true;
end;

function TfrmMain_ChuQin.ImportDrinkInfo(chuqinPlan : RRsChuQinPlan;trainman : RRsTrainman;localDrinkInfo:RRsDrinkInfo): boolean;
var
  TestResult: RTestAlcoholInfo;
  trainmanPlan : RRsTrainmanPlan;
  dutyUser :TRsDutyUser;
  RDrink: RRsDrink;
begin
  result := false;
  TestResult.dtTestTime := localDrinkInfo.dtCreateTime;
  TestResult.taTestAlcoholResult := TTestAlcoholResult(localDrinkInfo.nDrinkResult);
  TestResult.Picture := localDrinkInfo.DrinkImage;
  TestResult.nAlcoholicity := localDrinkInfo.dwAlcoholicity ;
  dutyUser :=TRsDutyUser.Create;
  try
    try
      trainmanPlan.Group := chuqinPlan.ChuQinGroup.Group;
      trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
      trainmanPlan.TrainPlan := chuqinPlan.TrainPlan;
      trainmanPlan.dtBeginWorkTime := chuqinPlan.dtBeginWorkTime;

      //测酒信息
      RDrink.nDrinkResult := Ord(localDrinkInfo.nDrinkResult);
      RDrink.DrinkImage := localDrinkInfo.DrinkImage;
      RDrink.dtCreateTime := localDrinkInfo.dtCreateTime;
      RDrink.dwAlcoholicity := localDrinkInfo.dwAlcoholicity;
      RDrink.AssignFromTestAlcoholInfo(TestResult);
      //人员信息
      RDrink.strTrainmanGUID := Trainman.strTrainmanGUID ;
      RDrink.strTrainmanName := Trainman.strTrainmanName ;
      RDrink.strTrainmanNumber := Trainman.strTrainmanNumber;
      //车次信息
      RDrink.strTrainNo :=  trainmanPlan.TrainPlan.strTrainNo ;
      RDrink.strTrainNumber :=  trainmanPlan.TrainPlan.strTrainNumber ;
      RDrink.strTrainTypeName :=  trainmanPlan.TrainPlan.strTrainTypeName ;
      //出勤点信息
      RDrink.strPlaceID := GlobalDM.DutyPlace.placeID ;
      RDrink.strPlaceName := GlobalDM.DutyPlace.placeName ;
      RDrink.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
      RDrink.strSiteIP := GlobalDM.SiteInfo.strSiteIP;
      RDrink.strSiteName := GlobalDM.SiteInfo.strSiteName ;
      //机务段信息
      RDrink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(trainmanPlan.TrainPlan.strTrainNumber);
      RDrink.strAreaGUID := LeftStr(trainman.strTrainmanNumber,2);
      //值班员信息
      RDrink.strDutyNumber :=  localDrinkInfo.strDutyNumber;
      if m_RsLCDutyUser.GetDutyUserByNumber(localDrinkInfo.strDutyNumber,dutyUser)= True then
        RDrink.strDutyName:=  dutyUser.strDutyName;
        
      RDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
      RDrink.strWorkShopName := Trainman.strWorkShopName ;

      //发送测酒信息
      RDrink.nVerifyID := Ord ( localDrinkInfo.nVerifyID ) ;
      RDrink.nWorkTypeID := DRINK_TEST_CHU_QIN ;

      RDrink.strPictureURL := PostDrinkImage(Trainman,TestResult);

                     
      m_LCBeginwork.Submit(Trainman.strTrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,RDrink);

      PostAlcoholMessage(Trainman,RDrink);
      PostWorkBeginMessage(Trainman,trainmanPlan,TestResult.taTestAlcoholResult,TestResult.dtTestTime);
      result := true;
    except on e : exception do
      begin
        Box('导入失败:' + e.Message);
      end;
    end;
  finally
    dutyUser.Free;
  end;
end;

procedure TfrmMain_ChuQin.RefreshLocalDrinkAlarm(ConnAccess: TConnAccess);
var
  dbConnAccess: TConnAccess;
  nCount: integer;
  pt: TPoint;
begin
  dbConnAccess := ConnAccess;
  try
    if dbConnAccess = nil then
    begin
      dbConnAccess := TConnAccess.Create(Application);
      if not dbConnAccess.ConnectAccess then exit;
    end;
    try
      nCount := dbConnAccess.GetDrinkInfoCount;
      if nCount = 0 then
      begin
        statusMatch.Font.Color := clBlack;
        statusMatch.Caption := '双击查看断网测酒记录';
        statusMatch.ImageIndex := 2;
        if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
      end
      else
      begin                       
        statusMatch.Font.Color := clRed;
        statusMatch.Caption := '双击匹配断网测酒记录';
        statusMatch.ImageIndex := 2;

        pt.X := statusMatch.Left + statusMatch.Width div 2;
        pt.Y := statusMatch.Top + 4;
        pt := RzStatusBar1.ClientToScreen(pt);
        if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
        m_hBallHint := GlobalDM.CreateHint(statusMatch.Parent.Handle, statusMatch.Caption, pt);
      end;
    except
      //此处应该在界面上加上本地数据库异常提醒
    end;
  finally
    if (ConnAccess = nil) and (dbConnAccess <> nil) then
    begin
      dbConnAccess.Free;
    end;
  end;
end;

procedure TfrmMain_ChuQin.RzRadioButton1Click(Sender: TObject);
begin
  if(RzRadioButton1.Checked) then
  begin
    PageControl1.ActivePageIndex := 0;
    exit;
  end;
  if(RzRadioButton2.Checked) then
  begin
    PageControl1.ActivePageIndex := 1;
    exit;
  end;  
end;




end.


