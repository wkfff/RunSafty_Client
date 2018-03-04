unit uFrmMain_TuiQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, RzTabs, RzStatus, RzPanel, Grids, AdvObj, BaseGrid,
  AdvGrid, Buttons, PngSpeedButton,uTrainmanJiaolu, uTrainPlan, uArea,uTrainman,
  ufrmReadFingerprintTemplates,uFrmTrainmanIdentity,
  uFrmTuiQin,uSaftyEnum,uTrainJiaolu,uTFSystem,
   ActnList, StdCtrls, jpeg, ActiveX, uTFVariantUtils,
  uTFMessageDefine,uRunSaftyMessageDefine,uFrmSelectColumn,uStrGridUtils,
  uConnAccess,uApparatusCommon,uDrink,uRsStepBase,AdvSplitter, uDutyUser,
  ImgList,uFrmProgressEx,uLCTrainPlan,uEndWork,uDutyPlace,uLCDutyPlace,
  uFrmSignMain,uFrmSignJiaolu,uFrmOutWorkChoice,uLCTrainmanMgr,uLCDutyUser,uLCDrink,
  uLCNameBoardEx,uLCEndwork,uTFSkin, RzButton, RzRadChk,uFrmWorkTimeDetail,uFingerCtls;
const
  TESTPICTURE_DEFAULT = 'Images\测酒照片\nophoto.jpg';
  TESTPICTURE_CURRENT = 'Images\测酒照片\DrinkTest.jpg';
const
  WM_Message_DrinkCheck = WM_User + 100;
  WM_Message_DBDiscontect = WM_User + 1001;   
  WM_Message_Refresh = WM_User + 5001;
type
  TfrmMain_TuiQin = class(TForm)
    RzPanel1: TRzPanel;
    btnSystemConfig: TPngSpeedButton;
    btnExit: TPngSpeedButton;
    btnTuiQin: TPngSpeedButton;
    Panel1: TPanel;
    RzPanel3: TRzPanel;
    RzPanel2: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    statusSysTime: TRzGlyphStatus;
    statusDutyUser: TRzGlyphStatus;
    statusFinger: TRzGlyphStatus;
    RzPanel4: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    TimerRefreshData: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    NExit: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    TimerCheckFinger: TTimer;
    tmrReadTime: TTimer;
    pnl2: TPanel;
    btnExchangeModule: TPngSpeedButton;
    Panel4: TPanel;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    miManulTuiQin: TMenuItem;
    PopupMenu: TPopupMenu;
    miPopManuTuiQin: TMenuItem;
    btnRefreshPaln: TPngSpeedButton;
    btnGoodsManage: TPngSpeedButton;
    N6: TMenuItem;
    miReTestDrink: TMenuItem;
    ActionList1: TActionList;
    actF6: TAction;
    N10: TMenuItem;
    miDrinkQuery: TMenuItem;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    mniSystemParam: TMenuItem;
    miPopManulImportServerDrink: TMenuItem;
    statusMatch: TRzGlyphStatus;
    statusMessage: TRzStatusPane;
    statusUpdate: TRzStatusPane;
    TimerImportDrink: TTimer;
    RzPanel5: TRzPanel;
    RzGroupBox1: TRzGroupBox;
    Label3: TLabel;
    lblDrinkNumber: TLabel;
    Label6: TLabel;
    lblDrinkName: TLabel;
    Label8: TLabel;
    lblDrinkResult: TLabel;
    Label1: TLabel;
    lblDrinkTime: TLabel;
    RzGroupBox2: TRzGroupBox;
    imgDrink: TImage;
    RzPanel6: TRzPanel;
    RzPanel8: TRzPanel;
    RzPanel9: TRzPanel;
    grdMain: TAdvStringGrid;
    AdvSplitter1: TAdvSplitter;
    RzPanel10: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    pnlScrollInfo: TRzPanel;
    TimerScroll: TTimer;
    ImageList1: TImageList;
    btnImportDrink: TPngSpeedButton;
    btnCancelDrink: TPngSpeedButton;
    btnDeleteIgnore: TPngSpeedButton;
    btnHideDrink: TPngSpeedButton;
    actF5: TAction;
    N14: TMenuItem;
    N17: TMenuItem;
    mniN20: TMenuItem;
    IC1: TMenuItem;
    btnUploadDrinkInfo: TPngSpeedButton;
    mniSign: TMenuItem;
    mniN21: TMenuItem;
    mniEventDetail: TMenuItem;
    rzpnl2: TRzPanel;
    rzpnlSignForm: TRzPanel;
    splitterSignPlan: TAdvSplitter;
    chkShowAllPlan: TRzCheckBox;
    btnWorkTime: TPngSpeedButton;
    Label2: TLabel;
    lbldwAlcoholicity: TLabel;
    N13: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    statusFingerTime: TRzStatusPane;
    procedure btnTuiQinClick(Sender: TObject);
    procedure tmrReadTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure NExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure strGridTrainPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure statusFingerDblClick(Sender: TObject);
    procedure btnGoodsManageClick(Sender: TObject);
    procedure miReTestDrinkClick(Sender: TObject);
    procedure actF6Execute(Sender: TObject);
    procedure miDrinkQueryClick(Sender: TObject);
    procedure miSelectColumnClick(Sender: TObject);
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
    procedure TimerScrollTimer(Sender: TObject);
    procedure pnlScrollInfoPaint(Sender: TObject);
    procedure statusMatchDblClick(Sender: TObject);
    procedure grdMainCheckBoxChange(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
    procedure btnDeleteIgnoreClick(Sender: TObject);
    procedure actF5Execute(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure miPopManuTuiQinClick(Sender: TObject);
    procedure btnSystemConfigClick(Sender: TObject);
    procedure btnUploadDrinkInfoClick(Sender: TObject);
    procedure chkShowAllPlanClick(Sender: TObject);
    procedure mniEventDetailClick(Sender: TObject);
    procedure btnWorkTimeClick(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
  private
    { Private declarations }
    //签点窗体
    frmSign:TFrmSignMain;
    m_DutyUser: TRsLCBoardInputDuty;
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    //值班员
    m_RsLCDutyUser: TRsLCDutyUser;
    //出勤点
    m_webDutyPlace:TRsLCDutyPlace;
    //网站机车计划接口
    m_webTrainPlan:TRsLCTrainPlan;
    m_LCEndwork: TLCEndwork;
    m_RsLCDrink: TRsLCDrink;
    //测酒照片上传对象
    m_RsDrinkImage: TRsDrinkImage;
    //待退勤的计划数组
    m_TuiQinPlanArray : TRsTuiQinPlanArray;
    //人员接口
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //获取数据互斥
    m_GetDataCriticalSection : TRTLCriticalSection;
    m_FunModule: TRsFunModule;   
    //断网或连网开始时间
    m_nTickCount: Cardinal;
    //气泡提示句柄
    m_hBallHint: Cardinal;   

    //超过指定时间显紫色
    m_PurpleHour: integer;
  private
    //初始化数据
    procedure InitData;
    //刷新计划信息
    procedure InitTuiQinPlans;
    {功能:按下鼠标}
    procedure OnFingerTouching(Sender: TObject);
    //刷新界面
    procedure WMMessageRefresh(var Message : TMessage);message WM_Message_Refresh;

    procedure WMFingerUpdate(var Message : TMessage);message WM_FINGERUPDATE;
    {功能:读取指纹状态}
    procedure ReadFingerprintState;
    //初始化人员交路
    procedure InitTrainJiaolu;
    //获取选中的司机工号
    function GetSelectedTrainman(var Trainman: RRsTrainman): Boolean;
    //判断指定列是否为司机列
    function IsTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为副司机列
    function IsSubTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为学员列
    function IsXueYuanTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为学员列
    function IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
    //判断是否为测酒结果列
    function IsDrinkInfoCol(nCol : integer): Boolean;
    //获取选择的计划信息
    function GetSelectedTuiQinPlan(out TuiQinPlan : RRsTuiQinPlan) : boolean;
    //获取当前人员的退勤计划信息
    function GetTrainmanEndWorkPlan(
      Trainman : RRsTrainman;out EndWorkPlan : RRsTuiQinPlan) : BOOLEAN;
    //强制刷新
    procedure GetDataArray();
    //显示退勤计划的测酒信息
    procedure ShowDringImage(TuiQinPlan : RRsTuiQinPlan;TrainmanSn: Integer);

    //执行退勤
    procedure ExecTuiQin(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
    //无计划出勤
    procedure NoPlanTestDrink(Trainman : RRsTrainman ; Verify : TRsRegisterFlag );
    //创建外段人员工号
    function CreateOuterSideTrainman(strNumber : string):boolean ;
    //退勤
    procedure TuiQin(strNumber:string);
    //提交退勤消息
    procedure PostWorkEndMessage(Trainman : RRsTrainman;trainmanPlan : RRsTrainmanPlan;
      AlcoholResult: TTestAlcoholResult; dtEndWorkTime: TDateTime);
        //发送测酒信息
    procedure PostAlcoholMessage(Trainman : RRsTrainman;RsDrink : RRsDrink);
     //上传测酒记录
    function PostDrinkImage(Trainman : RRsTrainman;AlcoholResult: RTestAlcoholInfo): string;
    //显示提示信息
    procedure ShowHint(strHint: string);
    procedure CloseHint();
      {功能:显示签点窗体}
    procedure ShowSignForm();
  private
    //本地数据操作类
    m_LocalDrinkArray: TRsDrinkInfoArray;
    //查询本地测酒信息
    procedure QueryLocalDrinkInfo();
    //导入测酒信息
    function ImportDrinkInfo(ImportPlan: RRsImportPlan;trainman : RRsTrainman;localDrinkInfo:RRsDrinkInfo): boolean;

    //上传测酒记录
    function  UploadDrinkInfo(Trainman: RRsTrainman;DrinkInfo: RRsDrinkInfo):Boolean;
    //刷新本地测酒记录导入提醒
    procedure RefreshLocalDrinkAlarm(ConnAccess: TConnAccess = nil);
    //在线、离线模式切换事件
    procedure ExchangeModeProc(Sender: TObject);
    //退出在线模式的实现
    procedure ExitSystemProc(Sender: TObject);
  public
    { Public declarations }
    class procedure EnterTuiQin;
    class procedure LeaveTuiQin;
  end;

var
  frmMain_TuiQin: TfrmMain_TuiQin;

implementation
uses
  DateUtils, StrUtils,  uGlobalDM, uFrmTestDrinkSelect,uFrmSelectPlan,
  uFrmTestDrinking, uFrmTextInput, uFrmDisconnectHint,
  uFrmSetStringGridCol, uRunSaftyDefine,uFrmExchangeModule,uFrmImportDrinkInfo,
  uSite,ufrmModifyPassWord,uFrmLogin,  uWorkTime,
  uRunSafetyInterfaceDefine, ZKFPEngXUtils,uFrmOuterTrainman,
  ufrmFingerRegister,uFrmGoodsManage,utfPopBox,uFrmDrinkTestQuery,ufrmTrainmanPicFigEdit,
   uFrmDrinkInfo, ufrmHint,ufrmConfig,ufrmTrainmanNumberInput,
   uFrmGetDateTime,shellapi, ufrmEndWorkQuery, uFrmTrainmanManage, uMenuItemCtl,
   uLCBeginWork;
{$R *.dfm}


procedure TfrmMain_TuiQin.btnTuiQinClick(Sender: TObject);
var
  strNumber : string;
begin
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
      Exit;
  TuiQin(strNumber);
end;

procedure TfrmMain_TuiQin.btnUploadDrinkInfoClick(Sender: TObject);
var
  nRow, nCol,  nImportCount: integer;
  blnCheck: boolean;
  dbConnAccess: TConnAccess;
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
      if blnCheck then Continue;

      if grdMain.Cells[99, nRow] <> '' then
      begin
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
    dbConnAccess.Free;
    TfrmProgressEx.CloseProgress;

    QueryLocalDrinkInfo;
    RefreshLocalDrinkAlarm(dbConnAccess);
  end;
end;

procedure TfrmMain_TuiQin.btnWorkTimeClick(Sender: TObject);
var
  hLib: Cardinal;
  proc: procedure(AppHandle: Cardinal);
begin
  if FileExists(GlobalDM.AppPath + 'WorkTimeQuery.dll') then
  begin
    hLib := LoadLibrary(pchar(GlobalDM.AppPath + 'WorkTimeQuery.dll'));
    if hLib <> 0 then
    begin
      try
        @proc := GetProcAddress(hLib,'WorkTimeQuery_Open');

        proc(Application.Handle);
      finally
        FreeLibrary(hLib);
      end;

    end;

  end;
  
end;

procedure TfrmMain_TuiQin.actF5Execute(Sender: TObject);
begin
  InitTuiQinPlans;
end;

procedure TfrmMain_TuiQin.actF6Execute(Sender: TObject);
var
  strNumber : string;
begin
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
      Exit;
  TuiQin(strNumber);
end;

procedure TfrmMain_TuiQin.btnDeleteIgnoreClick(Sender: TObject);
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

procedure TfrmMain_TuiQin.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TfrmMain_TuiQin.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_TuiQin.btnGoodsManageClick(Sender: TObject);
begin
  LengingManage();
end;

procedure TfrmMain_TuiQin.btnRefreshPalnClick(Sender: TObject);
begin
  InitTuiQinPlans;
end;
                  
procedure TfrmMain_TuiQin.btnSystemConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TfrmMain_TuiQin.ExchangeModeProc(Sender: TObject);
begin
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(sjDuanWang));
end;
         
procedure TfrmMain_TuiQin.ExitSystemProc(Sender: TObject);
begin
  Hide;
  Close;
end;

class procedure TfrmMain_TuiQin.EnterTuiQin;
begin             
  GlobalDm.LocalSiteName := '退勤';
  //初始化需要的硬件驱动
  if frmMain_TuiQin = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TfrmMain_TuiQin, frmMain_TuiQin);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,frmMain_TuiQin);
    frmMain_TuiQin.InitData;
  end;
  frmMain_TuiQin.Show;
end;


procedure TfrmMain_TuiQin.ExecTuiQin(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
var
  Param: TRsStepParam;
  tuiqinPlan : RRsTuiQinPlan;
  OnFingerOp:TOnFingerOP;
begin
  Param := TRsStepParam.Create;
  try
    try
      Param.Trainman := Trainman;
      Param.IntField['Verify'] := Ord(Verify);

      //如果没有获取到计划就执行一般测酒
      if not GetTrainmanEndWorkPlan(Param.Trainman,tuiqinPlan) then
      begin
        if GlobalDM.UsesOutWorkSign then
        begin
          OnFingerOp := OutWorkOnFingerOP;
          case OnFingerOp of
            TOF_NONE: Exit;
            TOF_SIGN : frmSign.Sign(Param.Trainman);
            TOF_AlC :  NoPlanTestDrink(Param.Trainman,Verify);
          end;
          Exit;
        end;
        NoPlanTestDrink(Param.Trainman,Verify);
        exit;
      end;


      m_FunModule.OnShowHint := ShowHint;
      m_FunModule.OnCloseHint := CloseHint;
      if m_FunModule.Execute(Param) then
      begin
        ShowHint('退勤成功!');
        TfrmHint.CloseHintDelay;
      end;
    except
      on E: Exception do
      begin
        Box(E.Message);
      end;
    end;
  finally
    Param.Free;
    TfrmHint.CloseHint;
  end;
end;



procedure TfrmMain_TuiQin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (not Showing) then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes
end;

procedure TfrmMain_TuiQin.FormCreate(Sender: TObject);
begin
  m_nTickCount := 0;
  strGridTrainPlan.SelectionRectangleColor := clRed;


  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;

  m_RsLCDutyUser := TRsLCDutyUser.Create(GlobalDM.WebAPIUtils);
  m_RsDrinkImage := TRsDrinkImage.Create('');
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_RsLCDrink := TRsLCDrink.Create(GlobalDM.WebAPIUtils);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(GlobalDM.WebAPIUtils);
  m_LCEndwork := TLCEndwork.Create(GlobalDM.WebAPIUtils);

  InitializeCriticalSection(m_GetDataCriticalSection);  
  strGridTrainPlan.ColumnSize.Save := false; 
  GlobalDM.SetGridColumnWidth(strGridTrainPlan);
  GlobalDM.SetGridColumnVisible(strGridTrainPlan);

  m_DutyUser := TRsLCBoardInputDuty.Create;
  m_DutyUser.strDutyGUID := GlobalDM.DutyUser.strDutyGUID;
  m_DutyUser.strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
  m_DutyUser.strDutyName := GlobalDM.DutyUser.strDutyName;
  
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
end;

procedure TfrmMain_TuiQin.FormDestroy(Sender: TObject);
begin
  
  if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);

  GlobalDM.SaveGridColumnWidth(strGridTrainPlan);
  GlobalDM.SaveGridColumnVisible(strGridTrainPlan);

  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;

  TimerRefreshData.Enabled := false;
  TimerCheckFinger.Enabled := false;
  tmrReadTime.Enabled := false;

  m_RsLCDutyUser.Free ;

  m_RsLCTrainmanMgr.Free;
  m_RsDrinkImage.Free;
  m_webTrainPlan.Free;                                                    
  m_webDutyPlace.Free ;
  m_RsLCDrink.Free;
  m_RsLCNameBoardEx.Free;
  m_DutyUser.Free;
  m_LCEndwork.Free;
  DeleteCriticalSection(m_GetDataCriticalSection);
  if Assigned(m_FunModule) then
    FreeAndNil(m_FunModule);
end;

procedure TfrmMain_TuiQin.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Open();
    
  //启动系统时间
  TimerRefreshData.Enabled := true;
  TimerImportDrink.Enabled := true;
  statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);

   ShowSignForm();
end;

procedure TfrmMain_TuiQin.GetDataArray();
var
  strError:string;
  dtBeginTime,dtEndTime : TDateTime;
  tuiqinPlanArray : TRsTuiQinPlanArray;
  iCheck:Integer ;
begin
  dtBeginTime := IncHour(dateof(GlobalDM.GetNow) - 1, 18);
  dtEndTime := IncMinute(IncDay(dateOf(GlobalDM.GetNow), 2), 17 * 60 + 59);
  iCheck := Integer ( chkShowAllPlan.checked);
  try
    if not m_webTrainPlan.GetTuiQinPlanByClient(dtBeginTime,dtEndTime,iCheck,tuiqinPlanArray,strError)   then
    begin
      BoxErr(strError);
      Exit ;
    end;
    m_TuiQinPlanArray := tuiqinPlanArray;
  except on e:exception do
    begin
    end;
  end;
end;


function TfrmMain_TuiQin.GetSelectedTrainman(var Trainman: RRsTrainman): Boolean;
var
  selectCol : integer;
begin
  Result := False;

  if strGridTrainPlan.Row > Length(m_TuiQinPlanArray) then
      Exit;
  selectCol :=  strgridTrainPlan.RealColIndex(strGridTrainPlan.Col);   
  if strGridTrainPlan.Cells[selectCol,strGridTrainPlan.ROW] = '' then exit;
      
  if IsTrainmanCol(selectCol) then
  begin
    Trainman := m_TuiQinPlanArray[strGridTrainPlan.Row - 1].TuiQinGroup.Group.Trainman1;
    Result := True;
  end
  else
  if IsSubTrainmanCol(selectCol) then
  begin
    Trainman := m_TuiQinPlanArray[strGridTrainPlan.Row - 1].TuiQinGroup.Group.Trainman2;
    Result := True;
  end;

  if IsXueYuanTrainmanCol(selectCol) then
  begin
    Trainman := m_TuiQinPlanArray[strGridTrainPlan.Row - 1].TuiQinGroup.Group.Trainman3;
    Result := True;
  end;
  if IsXueYuan2TrainmanCol(selectCol) then
  begin
    Trainman := m_TuiQinPlanArray[strGridTrainPlan.Row - 1].TuiQinGroup.Group.Trainman4;
    Result := True;
  end;

end;
function TfrmMain_TuiQin.GetSelectedTuiQinPlan(
  out TuiQinPlan: RRsTuiQinPlan): boolean;
begin
  result := false;
  if strGridTrainPlan.Row < 1 then Exit;;
  if strGridTrainPlan.Row > length(m_TuiQinPlanArray) then exit;
  TuiQinPlan := m_TuiQinPlanArray[strGridTrainPlan.row - 1];
  result := true;
end;

function TfrmMain_TuiQin.GetTrainmanEndWorkPlan(
  Trainman: RRsTrainman;out EndWorkPlan: RRsTuiQinPlan): BOOLEAN;
var
  ErrInfo: string;
begin
  result := false;
  
  if not m_webTrainPlan.GetTuiQinPlanByTrainman(trainman.strTrainmanGUID,EndWorkPlan,ErrInfo) then
  begin
    //接口没有定义没有计划时的返回值，没有计划时返回为异常
    if '没有改乘务员的退勤计划' <> ErrInfo then
      Box('获取退勤计划失败:' + ErrInfo)
    else
      exit;
  end else begin
    if EndWorkPlan.TrainPlan.nPlanState <> psBeginWork then
    begin
      exit;
    end;
  end;
  result := true;
end;

procedure TfrmMain_TuiQin.InitData;
begin
  TtfSkin.InitRzPanel(rzPanel1);
  TtfSkin.InitRzTab(tabTrainJiaolu);
  TtfSkin.InitAdvGrid(strGridTrainPlan);
  
  GlobalDM.LogManage.InsertLog('初始化数据');
  GlobalDM.LogManage.InsertLog('初始化机车交路');
  InitTrainJiaolu;

  //当前登录用户
  statusDutyUser.Caption := '值班员: ' + GlobalDM.DutyUser.strDutyName;
  GlobalDM.LogManage.InsertLog('查看指纹仪状态');
  //查看指纹仪状态
  ReadFingerprintState();

  GlobalDM.LogManage.InsertLog('初始化退勤计划');
  InitTuiQinPlans;
  m_RsDrinkImage.URLHost := GlobalDM.WebHost + GlobalDM.WebDrinkImgPage;
  GlobalDM.LogManage.InsertLog('获取退勤功能模块');
  m_FunModule := GlobalDM.FunModuleManager.CreateModule('退勤功能');
  Caption := '退勤管理 ' + GetFileVersion(Application.ExeName);

  m_PurpleHour := StrToIntDef(ReadIniFile(ExtractFilePath(ParamStr(0)) + 'Config.ini',
    'UserData','TQPrupleHour'),24);

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


procedure TfrmMain_TuiQin.InitTrainJiaolu;
var
  tab:TRzTabCollectionItem;
begin
  tabTrainJiaolu.Tabs.Clear;
  tab := tabTrainJiaolu.Tabs.Add;
  tab.Caption := GlobalDM.SiteInfo.strSiteName;
end;

procedure TfrmMain_TuiQin.InitTuiQinPlans;
begin
  PostMessage(Handle,WM_Message_Refresh,0,0);
end;

function TfrmMain_TuiQin.IsDrinkInfoCol(nCol: integer): Boolean;
var
  sVal: string;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  sVal := strGridTrainPlan.ColumnHeaders.Strings[nCol];
  Result := Pos('酒',sVal) > 0;
end;

function TfrmMain_TuiQin.IsSubTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '副司机');
end;

function TfrmMain_TuiQin.IsTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '司机');
end;

function TfrmMain_TuiQin.IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;
  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员2');
end;

function TfrmMain_TuiQin.IsXueYuanTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;
  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员');
end;

class procedure TfrmMain_TuiQin.LeaveTuiQin;
begin
  //释放已硬件驱动
  if frmMain_TuiQin <> nil then
    FreeAndNil(frmMain_TuiQin);
end;

procedure TfrmMain_TuiQin.N13Click(Sender: TObject);
begin
  TFrmEndWorkQuery.ShowForm;
end;

procedure TfrmMain_TuiQin.N17Click(Sender: TObject);
var
  trainman : RRsTrainman;
  tuiqinPlan : RRsTuiQinPlan;
  TFMessage: TTFMessage;
begin
  if not GetSelectedTrainman(trainman) then
  begin
    Box('清指定人员');
    exit;
  end;
  if not GetSelectedTuiQinPlan(tuiqinPlan) then
  begin
    Box('清选择计划');
    exit;
  end;

  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := TFM_WORK_END;
    TFMessage.StrField['tmGuid'] := Trainman.strTrainmanGUID;
    TFMessage.StrField['tmid'] := Trainman.strTrainmanNumber;
    TFMessage.StrField['tmname'] := Trainman.strTrainmanName;

    if trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman1.strTrainmanGUID then
    begin
      TFMessage.dtField['dttime'] := tuiqinPlan.TuiQinGroup.TestAlcoholInfo1.dtTestTime; 
      TFMessage.IntField['cjjg'] := Ord(tuiqinPlan.TuiQinGroup.TestAlcoholInfo1.taTestAlcoholResult);
    end;
    if trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman2.strTrainmanGUID then
    begin
      TFMessage.dtField['dttime'] := tuiqinPlan.TuiQinGroup.TestAlcoholInfo2.dtTestTime;
      TFMessage.IntField['cjjg'] := Ord(tuiqinPlan.TuiQinGroup.TestAlcoholInfo2.taTestAlcoholResult);
    end;
    if trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman3.strTrainmanGUID then
    begin
      TFMessage.dtField['dttime'] := tuiqinPlan.TuiQinGroup.TestAlcoholInfo3.dtTestTime;
      TFMessage.IntField['cjjg'] := Ord(tuiqinPlan.TuiQinGroup.TestAlcoholInfo3.taTestAlcoholResult);
    end;
    if trainman.strTrainmanGUID = tuiqinPlan.TuiQinGroup.Group.Trainman4.strTrainmanGUID then
    begin
      TFMessage.dtField['dttime'] := tuiqinPlan.TuiQinGroup.TestAlcoholInfo4.dtTestTime;
      TFMessage.IntField['cjjg'] := Ord(tuiqinPlan.TuiQinGroup.TestAlcoholInfo4.taTestAlcoholResult);
    end;
    TFMessage.StrField['planGuid'] := tuiqinPlan.TrainPlan.strTrainPlanGUID;
    TFMessage.StrField['jiaoLuName'] := tuiqinPlan.TrainPlan.strTrainJiaoluName;
    TFMessage.StrField['jiaoLuGUID'] := tuiqinPlan.TrainPlan.strTrainJiaoluGUID;

    TFMessage.dtField['dtStartTime'] :=
        tuiqinPlan.TrainPlan.dtStartTime;
    TFMessage.IntField['Tmis'] := GlobalDM.SiteInfo.Tmis;
    TFMessage.StrField['strTrainNo'] := tuiqinPlan.TrainPlan.strTrainNo;

    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
    Box('发送消息成功');
  finally
    TFMessage.Free;
  end;
end;

procedure TfrmMain_TuiQin.N19Click(Sender: TObject);
begin
      TfrmTrainmanManage.OpenTrainmanQuery;
end;

procedure TfrmMain_TuiQin.mniEventDetailClick(Sender: TObject);
var
  tuiqinPlan: RRstUIQInPlan;
begin
  if not GetSelectedTuiQinPlan(tuiqinPlan) then
  begin
    Box('请先选中计划!');
    Exit;
  end;

  TfrmWorkTimeDetail.ShowWorkTimeDetail(tuiqinPlan.TrainPlan.strTrainPlanGUID);
end;



procedure TfrmMain_TuiQin.N7Click(Sender: TObject);
begin
 TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_TuiQin.N8Click(Sender: TObject);
begin
 frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_TuiQin.N9Click(Sender: TObject);
begin
  btnExchangeModuleClick(btnExchangeModule);
end;

procedure TfrmMain_TuiQin.NExitClick(Sender: TObject);
begin
  btnExit.Click;
end;

procedure TfrmMain_TuiQin.NoPlanTestDrink(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
var
  strTrainNo ,strTrainNumber,strTrainTypeName : string  ;
  Drink: RRsDrink;
  testResult: RTestAlcoholInfo;
begin

  strTrainNo :=  '测试车次' ;
  strTrainNumber :=  '测试车号'  ;
  strTrainTypeName :=  '测试车型'  ;


  with  Drink do
  begin
    //人员信息
    bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber) ;
    strTrainmanGUID := Trainman.strTrainmanGUID ;
    strTrainmanName := Trainman.strTrainmanName ;
    strTrainmanNumber := Trainman.strTrainmanNumber;
    //出勤点信息
    strPlaceID := GlobalDM.DutyPlace.placeID ;
    strPlaceName := GlobalDM.DutyPlace.placeName ;
    strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
    strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
    strSiteName := GlobalDM.SiteInfo.strSiteName ;

    //duty
    strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
    strDutyName := GlobalDM.DutyUser.strDutyName ;
    strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);
     //车间
    strWorkShopGUID := Trainman.strWorkShopGUID ;
    strWorkShopName := Trainman.strWorkShopName ;
    dwAlcoholicity := 0 ;
  end;


  {$REGION '1 获取测试类型'}
  if not TFrmTestDrinkSelect.GetDrinkInfo(DRINK_TEST_TUI_QIN,Drink.nWorkTypeID,strTrainNo ,strTrainNumber,strTrainTypeName )  then
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


  {$REGION '3 测酒'}
  TestDrinking(Trainman,strTrainTypeName,strTrainNumber,strTrainNo,testResult);

  {
  if testResult.taTestAlcoholResult= taNoTest then
  begin
    if not TBox('测酒结果为未测试是否继续测试') then
      Exit ;
  end;
  }
  try
    Drink.AssignFromTestAlcoholInfo(testResult);
    GlobalDM.PlaySoundFile('正在保存测酒记录请稍候.wav');
    try
      Drink.strPictureURL := PostDrinkImage(trainman,testResult);
    finally
      TfrmHint.CloseHint;
    end;

    Drink.nVerifyID := ord(Verify);
    PostAlcoholMessage(Trainman,Drink);
    
    //发送测酒信息
//    m_DBTrainPlanWork.AddDrinkInfo(Drink);
    m_RsLCDrink.AddDrinkInfo(Drink);
    GlobalDM.PlaySoundFile('保存测酒记录成功.wav');
    TtfPopBox.ShowBox('保存测酒记录成功');
  except on e : exception do
    begin
      GlobalDM.PlaySoundFile('保存测酒记录失败.wav');
      BoxErr('保存测酒记录失败:' + e.Message);
    end;
  end;
  {$ENDREGION}
end;

procedure TfrmMain_TuiQin.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not IdentfityTrainman(Sender,TrainMan,Verify,'','','','') then
  begin
    Box('错误的乘务员信息:' + TrainMan.strTrainmanNumber);
    exit;
  end;
  if Trim(Trainman.strTrainmanGUID) = '' then
  begin
    Box('人员识别失败，请双击任务栏更新本地指纹库');
    exit;
  end;

  ExecTuiQin(TrainMan,Verify);
  InitTuiQinPlans;
end;

procedure TfrmMain_TuiQin.pnlScrollInfoPaint(Sender: TObject);
var                       
  w, h, x, y: integer;
  nBorderWidth, nTextWidth, nTextHeight: integer;
begin                 
  SetBkMode(pnlScrollInfo.Canvas.Handle, TRANSPARENT);
  pnlScrollInfo.Canvas.Font.Assign(pnlScrollInfo.Font);

  w := pnlScrollInfo.Width;   
  h := pnlScrollInfo.Height;
  nBorderWidth := pnlScrollInfo.BorderWidth;
  nTextWidth := pnlScrollInfo.Canvas.TextWidth(pnlScrollInfo.Hint);
  nTextHeight := pnlScrollInfo.Canvas.TextHeight(pnlScrollInfo.Hint);

  if pnlScrollInfo.Tag <= (-nTextWidth) then pnlScrollInfo.Tag := w - nBorderWidth * 2;
  x := nBorderWidth + pnlScrollInfo.Tag;
  y := (h - nTextHeight) div 2;

  pnlScrollInfo.Canvas.TextOut(x, y, pnlScrollInfo.Hint);
  pnlScrollInfo.Canvas.Brush.Color := pnlScrollInfo.BorderColor;
  pnlScrollInfo.Canvas.Rectangle(0, 0, nBorderWidth, h);
  pnlScrollInfo.Canvas.Rectangle(w - nBorderWidth, 0, w, h);
end;



procedure TfrmMain_TuiQin.PostAlcoholMessage(Trainman: RRsTrainman;
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

function TfrmMain_TuiQin.PostDrinkImage(Trainman : RRsTrainman;
  AlcoholResult: RTestAlcoholInfo): string;
var
  strTrainmanNumber: string ;
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
      if not TBox('测酒照片为空,是否继续?') then
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
      if not TBox('测酒照片捕获失败,是否继续?') then
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
procedure TfrmMain_TuiQin.PostWorkEndMessage(Trainman : RRsTrainman;
    trainmanPlan : RRsTrainmanPlan;AlcoholResult: TTestAlcoholResult; dtEndWorkTime: TDateTime);
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

procedure TfrmMain_TuiQin.ReadFingerprintState;
begin
  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪：正常';
    statusFinger.ShowHint := False ;
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪：连接失败';
    statusFinger.ShowHint := True ;
  end;
end;

procedure TfrmMain_TuiQin.ShowDringImage(TuiQinPlan: RRsTuiQinPlan;
  TrainmanSn: Integer);
var
  Trainman: RRsTrainman;
  RsDrink: RRsDrink;   
  strPath, strFile, strUrl: string;
begin
  try
    Trainman.strTrainmanGUID := '';
    case TrainmanSn  of
      0:Trainman := TuiQinPlan.TuiQinGroup.Group.Trainman1;
      1:Trainman := TuiQinPlan.TuiQinGroup.Group.Trainman2;
      2:Trainman := TuiQinPlan.TuiQinGroup.Group.Trainman3;
      3:Trainman := TuiQinPlan.TuiQinGroup.Group.Trainman4;
    end;

    

    if m_RsLCDrink.GetTrainmanDrinkInfo(Trainman.strTrainmanGUID,
            TuiQinPlan.TrainPlan.strTrainPlanGUID,Ord(wtEndWork),RsDrink) then
    begin 
      lblDrinkNumber.Caption := Trainman.strTrainmanNumber;
      lblDrinkName.Caption := Trainman.strTrainmanName;
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
          if m_RsDrinkImage.DownLoad(GlobalDM.WebHost + RsDrink.strPictureURL,GlobalDM.AppPath + TESTPICTURE_CURRENT) then
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
        imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
    end
    else
    begin
      lblDrinkNumber.Caption := '-';
      lblDrinkTime.Caption := '-';
      lblDrinkName.Caption := '-';
      lblDrinkResult.Caption := '-';
      lbldwAlcoholicity.Caption := '-';
      imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
    end;
  except on e : Exception do
    GlobalDM.LogManage.InsertLog('显示测酒照片异常:'+e.Message);
  end;
end;



procedure TfrmMain_TuiQin.ShowHint(strHint: string);
begin
  TfrmHint.ShowHint(strHint);
end;

procedure TfrmMain_TuiQin.ShowSignForm;
begin
  if GlobalDM.UsesOutWorkSign then
  begin
    rzpnlSignForm.Visible := True;
    frmSign := ShowSignPlanForm(rzpnlSignForm,TSF_TuiQin);

    Exit;
  end;
  rzpnl2.Align := alClient;
  rzpnlSignForm.Visible := False;
  splitterSignPlan.Visible := False;
end;

procedure TfrmMain_TuiQin.statusFingerDblClick(Sender: TObject);
begin
  GlobalDM.ReinitFinger();
end;

procedure TfrmMain_TuiQin.statusMatchDblClick(Sender: TObject);
begin
  if not RzPanel8.Visible then
  begin
    RzPanel8.Visible := true;
    QueryLocalDrinkInfo;
  end;
end;

procedure TfrmMain_TuiQin.strGridTrainPlanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_TuiQin.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  manstate:TRsTrainmanState;
  planstate:TRsPlanState;
begin
  if ACol = 1 then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;        
  end
  else if (ACol = 10) or (ACol = 13) or (ACol = 16) then
  begin
    for manstate := Low(TRsTrainmanState) to High(TRsTrainmanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsTrainmanStateNameAry[manstate] then
      begin
        ABrush.Color := TRsTrainmanStateBackColorAry[manstate];
        AFont.Color := TRsTrainmanStateFontColorAry[manstate];
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

procedure TfrmMain_TuiQin.strGridTrainPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
  col,row,selectCol : integer;
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

  selectCol := strgridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if IsTrainmanCol(selectCol)
    or IsSubTrainmanCol(selectCol)
    or IsXueYuanTrainmanCol(selectCol)
    or IsXueYuan2TrainmanCol(selectCol)
    then
  begin
    if strGridTrainPlan.Row <= Length(m_TuiQinPlanArray) then
      PopupMenu.Popup(PT.X,PT.Y);
  end;
end;
   
procedure TfrmMain_TuiQin.strGridTrainPlanSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var                
  TuiQinPlan: RRsTuiQinPlan;
  nTrainmanSn,selectCol: integer;
begin
  lblDrinkNumber.Caption := '-';
  lblDrinkName.Caption := '-';
  lblDrinkTime.Caption := '-';
  lblDrinkResult.Caption := '-';
  imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
  if ARow < 1 then Exit;
  if ARow > length(m_TuiQinPlanArray) then exit;
  selectCol := strgridTrainPlan.RealColIndex(ACol);
  if strGridTrainPlan.Cells[selectCol, ARow] = '' then exit;
             
  TuiQinPlan := m_TuiQinPlanArray[ARow - 1];
  nTrainmanSn := -1;

  if IsTrainmanCol(selectCol) then nTrainmanSn := 0;
  if IsSubTrainmanCol(selectCol) then nTrainmanSn := 1;
  if IsXueYuanTrainmanCol(selectCol) then nTrainmanSn := 2;
  if IsXueYuan2TrainmanCol(selectCol) then nTrainmanSn := 3;
  if nTrainmanSn >= 0 then ShowDringImage(TuiQinPlan,nTrainmanSn);
end;



procedure TfrmMain_TuiQin.TimerImportDrinkTimer(Sender: TObject);
begin
  TimerImportDrink.Enabled := false;
  RefreshLocalDrinkAlarm;
end;

procedure TfrmMain_TuiQin.TimerScrollTimer(Sender: TObject);
begin
  pnlScrollInfo.Tag := pnlScrollInfo.Tag - 10;
  pnlScrollInfo.Repaint;
end;

procedure TfrmMain_TuiQin.chkShowAllPlanClick(Sender: TObject);
begin
  InitTuiQinPlans;
end;

procedure TfrmMain_TuiQin.CloseHint;
begin
  TfrmHint.CloseHint;
end;

function TfrmMain_TuiQin.CreateOuterSideTrainman(strNumber: string): boolean;
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
  //第二步设置指纹信息
  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    if ModifyTrainmanPicFig(trainman.strTrainmanGUID) then
    begin
      GlobalDM.FingerPrintCtl.ServerFingerCtl.FinerID := NewGUID;
    end;
  end
end;

procedure TfrmMain_TuiQin.tmrReadTimeTimer(Sender: TObject);    

begin             
  TTimer(Sender).Enabled := false;
  try
    if True then
    begin
      if GetTickCount - m_nTickCount >= 10000 then
      begin
        m_nTickCount := GetTickCount;
        if FrmDisconnectHint <> nil then FrmDisconnectHint.CloseForm;
      end;
    end else begin
      if GetTickCount - m_nTickCount >= 10000 then
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

procedure TfrmMain_TuiQin.TuiQin(strNumber: string);
var
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
  strError : string ;
begin
  GlobalDM.FingerPrintCtl.OnTouch := nil;
  try
    if not m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman,2) then
    begin
      strError := format('工号:[%s] 不存在 , 是否创建该工号?',[Trim(strNumber)])  ;
      if not TBox(strError) then
        exit;
      //创建工号，设置指纹
      if not CreateOuterSideTrainman(strNumber) then
        Exit ;
      //重新获取一下工号
      m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman,2)
    end;

    Verify := rfInput;
    ExecTuiQin(Trainman,Verify);
    InitTuiQinPlans;
  finally
    GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  end;
end;

function TfrmMain_TuiQin.UploadDrinkInfo(Trainman: RRsTrainman;
  DrinkInfo: RRsDrinkInfo ): Boolean;
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
  dutyUser := TRsDutyUser.Create ;
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
      RDrink.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
      RDrink.strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
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
    dutyUser.Free ;
  end;
end;

procedure TfrmMain_TuiQin.miDrinkQueryClick(Sender: TObject);
begin
  TFrmDrinkTestQuery.OpenDrinkTestQuery;
end;

procedure TfrmMain_TuiQin.miPopManulImportServerDrinkClick(Sender: TObject);
var  
  DrinkQuery: RRsDrinkQuery;
  DrinkInfo: RRsDrinkInfo;
  Trainman: RRsTrainman;
  tuiqinPlan: RRstUIQInPlan;
  Param: TRelDrinkParam;
  trainmanPlan: RRsTrainmanPlan;
begin
  if not GetSelectedTuiQinPlan(tuiqinPlan) then
  begin
    Box('请先选中计划!');
    Exit;
  end;
  GetSelectedTrainman(TrainMan);

  DrinkQuery.nWorkTypeID := DRINK_TEST_TUI_QIN ;
  DrinkQuery.strTrainmanNumber := TrainMan.strTrainmanNumber;
  DrinkQuery.dtBeginTime := tuiqinPlan.TrainPlan.dtStartTime; //出勤计划时间
  DrinkQuery.dtEndTime := IncDay(tuiqinPlan.TrainPlan.dtStartTime, 10); //出勤计划后10天
  if TFrmDrinkInfo.ShowForm(dfServer, DrinkQuery, DrinkInfo) <> mrOK then exit;


  Param := TRelDrinkParam.Create;
  try
    Param.TmGUID := Trainman.strTrainmanGUID;
    Param.TmNumber := Trainman.strTrainmanNumber;
    Param.PlanGUID := tuiqinPlan.TrainPlan.strTrainPlanGUID;
    Param.DrinkGUID := DrinkInfo.strGUID;
    Param.DutyGUID := GlobalDM.DutyUser.strDutyGUID;
    Param.SiteGUID := GlobalDM.SiteInfo.strSiteGUID;
    m_LCEndwork.RelDrink(Param);
  finally
    Param.Free;
  end;


  trainmanPlan.TrainPlan := tuiqinPlan.TrainPlan;
  PostWorkEndMessage(Trainman,trainmanPlan,TTestAlcoholResult(DrinkInfo.nDrinkResult),
    DrinkInfo.dtCreateTime);

  TtfPopBox.ShowBox('退勤成功！');
  InitTuiQinPlans;
end;

procedure TfrmMain_TuiQin.miPopManuTuiQinClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
begin
  if not GetSelectedTrainman(TrainMan) then
  begin
    exit;
  end;
  strNumber := trainman.strTrainmanNumber;
  TuiQin(strNumber);
end;

procedure TfrmMain_TuiQin.miReTestDrinkClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  strTrainPlanGUID:string;
  testResult: RTestAlcoholInfo;
  RDrink: RRsDrink;
  TrainPlan: RRsTrainPlan;
  ErrInfo: string;
  endWork: RRsEndWork;
  tuiqinPlan: RRstUIQInPlan;
begin
  GlobalDM.FingerPrintCtl.OnTouch := nil;
  try
    if not GetSelectedTrainman(TrainMan) then
    begin
        exit;
    end;

    if not GetSelectedTuiQinPlan(tuiqinPlan) then
    begin
      Box('请先选中计划!');
      Exit;
    end;

    strTrainPlanGUID := tuiqinPlan.TrainPlan.strTrainPlanGUID;
    
    //获取计划里面的车次信息
    if not m_webTrainPlan.GetTrainPlanByID(strTrainPlanGUID,TrainPlan) then
    begin
      Box('获取计划失败:' + ErrInfo);
      Exit;
    end;

    strNumber := trainman.strTrainmanGUID;
    m_RsLCTrainmanMgr.GetTrainman(strNumber,trainman,2);


    if not TBox('您是否要为“' + trainman.strTrainmanName + '”重新测酒?') then
      Exit;

    TestDrinking(trainman,TrainPlan.strTrainTypeName,
      TrainPlan.strTrainNumber,TrainPlan.strTrainNo,
      testResult);


    if testResult.taTestAlcoholResult <> taNormal then
    begin
      if not TBox('测酒结果为:' + TestAlcoholResultToString(testResult.taTestAlcoholResult)
        + ',是否保存?') then
        Exit;
    end;

    RDrink.AssignFromTestAlcoholInfo(testResult);
    try
      RDrink.strPictureURL := PostDrinkImage(trainman,testResult);
    finally
      TfrmHint.CloseHint;
    end;


    with  endWork.endWorkInfo do
      begin
        endworkID := '';
        trainmanID := Trainman.strTrainmanGUID;
        planID := TrainPlan.strTrainPlanGUID ;
        dutyUserID := GlobalDM.DutyUser.strDutyGUID ;
        stationID := GlobalDM.SiteInfo.strStationGUID ;
        placeID := GlobalDM.DutyPlace.placeID ;
        arriveTime:= TestResult.dtTestTime;
        lastEndWorkTime := GlobalDM.GetNow;
        verifyID := IntToStr(ord(rfInput));
        remark := '';

      end;

      with endWork.drinksInfo do
      begin
        trainmanID := Trainman.strTrainmanGUID ;
        drinkResult := inttostr(RDrink.nDrinkResult) ;
        workTypeID := IntToStr(RDrink.nWorkTypeID);
        createTime := RDrink.dtCreateTime;
        imagePath  := RDrink.strPictureURL;


        //人员信息
        drink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(Trainman.strTrainmanNumber) ;
        drink.strTrainmanName := Trainman.strTrainmanName ;
        drink.strTrainmanNumber := Trainman.strTrainmanNumber ;

        //车次信息
        drink.strTrainNo  := TrainPlan.strTrainNo ;
        drink.strTrainNumber := TrainPlan.strTrainNumber  ;
        drink.strTrainTypeName := TrainPlan.strTrainTypeName  ;

        drink.nVerifyID := ord(rfInput) ;


        drink.strSiteGUID  := GlobalDM.SiteInfo.strSiteGUID;
        drink.strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
        drink.strSiteName  := GlobalDM.SiteInfo.strSiteName ;
        drink.strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);
        drink.strWorkShopGUID := Trainman.strWorkShopGUID ;
        drink.strWorkShopName := Trainman.strWorkShopName ;;

        drink.strPlaceID := GlobalDM.DutyPlace.placeID ;
        drink.strPlaceName := GlobalDM.DutyPlace.placeName ;


        RDrink.strAreaGUID := LeftStr(Trainman.strTrainmanNumber,2);
        RDrink.strWorkShopGUID := Trainman.strWorkShopGUID ;
        RDrink.strWorkShopName := Trainman.strWorkShopName ;;

        RDrink.strPlaceID := GlobalDM.DutyPlace.placeID ;
        RDrink.strPlaceName := GlobalDM.DutyPlace.placeName ;

        //酒精度
        drink.dwAlcoholicity := RDrink.dwAlcoholicity;
        drink.nWorkTypeID  :=  DRINK_TEST_TUI_QIN ;
      end;



    RDrink.nVerifyID := ord(rfInput) ;
    RDrink.nWorkTypeID := DRINK_TEST_TUI_QIN ;
    PostAlcoholMessage(trainman,RDrink);

    if not m_webTrainPlan.ExcuteTuiQin(endWork,ErrInfo) then
    begin
      Box(ErrInfo);
      Exit;
    end;
    
    InitTuiQinPlans;
  finally
    GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  end;
end;

procedure TfrmMain_TuiQin.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(strGridTrainPlan,'TuiQinPlan');
end;

procedure TfrmMain_TuiQin.WMFingerUpdate(var Message: TMessage);
var
  v: Double;
begin
  v := ComposeDWord(Message.WParam,Message.LParam);
  statusFingerTime.Caption := FormatDateTime('mm-dd hh:nn',TDateTime(v));
end;

procedure TfrmMain_TuiQin.WMMessageRefresh(var Message: TMessage);
var
  i : integer;
begin
  try
    GetDataArray();
    with strGridTrainPlan do
    begin
      ClearRows(1, 10000);

      if length(m_TuiqinPlanArray) > 0 then
        RowCount := length(m_TuiqinPlanArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_TuiqinPlanArray) - 1 do
      begin
        RowColor[i + 1] := clWhite;
        if (m_TuiQinPlanArray[i].TrainPlan.nPlanState = psBeginWork) then
        begin
          RowColor[i + 1] := clRed;
          if (m_tuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo1.dtTestTime=0)
            and (m_tuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo2.dtTestTime=0)
            and (m_tuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo3.dtTestTime=0)
            and (m_tuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo4.dtTestTime=0) then
          begin
            if CompareDateTime(IncHour(m_tuiqinPlanArray[i].TrainPlan.dtStartTime,m_PurpleHour),Now) < 0 then
              RowColor[i + 1] := $00EE6DF1
            else
              RowColor[i + 1] := clYellow;
          end;
        end;


        Cells[0, i + 1] := IntToStr(i + 1);
        Cells[1, i + 1] := TRsPlanStateNameAry[m_TuiqinPlanArray[i].TrainPlan.nPlanState];
        Cells[2, i + 1] := m_TuiqinPlanArray[i].TrainPlan.strTrainJiaoluName;
        Cells[3, i + 1] :=  m_TuiqinPlanArray[i].TrainPlan.strTrainTypeName + '-' +  m_TuiqinPlanArray[i].TrainPlan.strTrainNumber;
        Cells[4, i + 1] :=  m_TuiqinPlanArray[i].TrainPlan.strTrainNo;

        Cells[5, i + 1] := FormatDateTime('mm-dd hh:nn',m_TuiqinPlanArray[i].TrainPlan.dtStartTime);
        Cells[6, i + 1] := FormatDateTime('mm-dd hh:nn',m_TuiqinPlanArray[i].TrainPlan.dtChuQinTime);


        Cells[7, i + 1] := '';
        if m_TuiqinPlanArray[i].TrainPlan.dtLastArriveTime > 0  then
        begin
          Cells[7, i + 1] := FormatDateTime('MM-dd HH:nn',m_TuiqinPlanArray[i].TrainPlan.dtLastArriveTime);
        end;

        if m_TuiqinPlanArray[i].TuiQinGroup.Group.strGroupGUID  <> '' then
        begin
          Cells[8, i + 1] := GetTrainmanText(m_TuiqinPlanArray[i].TuiQinGroup.Group.Trainman1);
          FontStyles[7,i+1] := [fsBold];
          Cells[9, i + 1] := '';
          Cells[10, i + 1] := '';
          Cells[11, i + 1] := '';
          if  m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo1.dtTestTime > 0 then
          begin
            Cells[9, i + 1] := FormatDateTime('MM-dd HH:nn',m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo1.dtTestTime);
            Cells[10, i + 1] := TestAlcoholResultToString(m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo1.taTestAlcoholResult);
            Cells[11, i + 1] := TRsRegisterFlagNameAry[m_TuiqinPlanArray[i].TuiQinGroup.nVerifyID1];
          end;

          Cells[12, i + 1] := GetTrainmanText(m_TuiqinPlanArray[i].TuiQinGroup.Group.Trainman2);
          FontStyles[11,i+1] := [fsBold];
          Cells[13, i + 1] := '';
          Cells[14, i + 1] := '';
          Cells[15, i + 1] := '';
          if  m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo2.dtTestTime > 0 then
          begin
            Cells[13, i + 1] := FormatDateTime('MM-dd HH:nn',m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo2.dtTestTime);
            Cells[14, i + 1] := TestAlcoholResultToString(m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo2.taTestAlcoholResult);
            Cells[15, i + 1] := TRsRegisterFlagNameAry[m_TuiqinPlanArray[i].TuiQinGroup.nVerifyID2];
          end;


          Cells[16, i + 1] := GetTrainmanText(m_TuiqinPlanArray[i].TuiQinGroup.Group.Trainman3);
          FontStyles[16,i+1] := [fsBold];
          Cells[17, i + 1] := '';
          Cells[18, i + 1] := '';
          Cells[19, i + 1] := '';
          if  m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo3.dtTestTime > 0 then
          begin
            Cells[17, i + 1] := FormatDateTime('MM-dd HH:nn',m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo3.dtTestTime);
            Cells[18, i + 1] := TestAlcoholResultToString(m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo3.taTestAlcoholResult);
            Cells[19, i + 1] := TRsRegisterFlagNameAry[m_TuiqinPlanArray[i].TuiQinGroup.nVerifyID3];
          end;

          Cells[20, i + 1] := GetTrainmanText(m_TuiqinPlanArray[i].TuiQinGroup.Group.Trainman4);
          FontStyles[20,i+1] := [fsBold];
          Cells[21, i + 1] := '';
          Cells[22, i + 1] := '';
          Cells[23, i + 1] := '';
          if  m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo4.dtTestTime > 0 then
          begin
            Cells[21, i + 1] := FormatDateTime('MM-dd HH:nn',m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo4.dtTestTime);
            Cells[22, i + 1] := TestAlcoholResultToString(m_TuiqinPlanArray[i].TuiQinGroup.TestAlcoholInfo4.taTestAlcoholResult);
            Cells[23, i + 1] := TRsRegisterFlagNameAry[m_TuiqinPlanArray[i].TuiQinGroup.nVerifyID4];
          end;
        end;

        Cells[24 , i +1 ] :=  m_TuiqinPlanArray[i].TrainPlan.strPlaceName ;

        if m_TuiqinPlanArray[i].TrainPlan.nNeedRest > 0 then
        begin
          Cells[25, i + 1] := '侯班';
          Cells[26, i + 1] := FormatDateTime('yy-MM-dd hh:nn', m_TuiqinPlanArray[i].TrainPlan.dtArriveTime);
          Cells[27, i + 1] := FormatDateTime('yy-MM-dd hh:nn', m_TuiqinPlanArray[i].TrainPlan.dtCallTime);
        end;

        Cells[99, i + 1] := m_TuiqinPlanArray[i].TrainPlan.strTrainPlanGUID;
      end;
    end;
  finally
    //LeaveCriticalSection(m_GetDataCriticalSection);
  end;
end;
       
//==============================================================================

procedure TfrmMain_TuiQin.grdMainCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if ACol = 5 then CanEdit := True;
end;

procedure TfrmMain_TuiQin.grdMainCheckBoxChange(Sender: TObject; ACol,
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

procedure TfrmMain_TuiQin.grdMainGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_TuiQin.btnImportDrinkClick(Sender: TObject);
var
  nRow, nCol,  nImportCount: integer;
  blnCheck: boolean;
  dbConnAccess: TConnAccess;
  importPlan : RRsImportPlan;
  tuiqinplan : RRsTuiQinPlan;
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
      TfrmProgressEx.ShowProgress('上传退勤记录',nRow,grdMain.RowCount-1);
           
      Application.ProcessMessages;
      grdMain.GetCheckBoxState(5, nRow, blnCheck);
      GlobalDM.LogManage.InsertLog('上传断网测酒记录--1开始上传断网测酒记录');
      if blnCheck then Continue;

      if grdMain.Cells[99, nRow] <> '' then
      begin
        if not m_RsLCTrainmanMgr.GetTrainmanByNumber(m_LocalDrinkArray[nRow-1].strTrainmanNumber,trainman) then
        begin
          GlobalDM.LogManage.InsertLog('上传断网测酒记录---2获取员工号失败,员工号:'+m_LocalDrinkArray[nRow-1].strTrainmanNumber);
          continue;
        end;

        
        if not m_LCEndwork.GetEndworkPlanByTime(trainman.strTrainmanNumber,m_LocalDrinkArray[nRow-1].dtCreateTime,
        GlobalDM.SiteInfo.strSiteGUID,tuiqinplan) then
        begin
          GlobalDM.LogManage.InsertLog('上传断网测酒记录--3没有找到该员工的计划,员工号:'+trainman.strTrainmanNumber);
          continue;
        end;
        importPlan.TrainPlan := tuiqinplan.TrainPlan;
        importPlan.Group := tuiqinplan.TuiQinGroup.Group;
        importplan.Trainman := trainman;

        importPlan.blnMatched := true;
        importPlan.nVerifyID := TRsRegisterFlag(m_LocalDrinkArray[nRow-1].nVerifyID);
        importPlan.TestAlcoholInfo.dtTestTime := m_LocalDrinkArray[nRow-1].dtCreateTime;
        importPlan.TestAlcoholInfo.taTestAlcoholResult := TTestAlcoholResult(m_LocalDrinkArray[nRow-1].nDrinkResult);
        importPlan.TestAlcoholInfo.Picture := m_LocalDrinkArray[nRow-1].DrinkImage;
        importPlan.TestAlcoholInfo.nAlcoholicity := m_LocalDrinkArray[nRow-1].dwAlcoholicity;
        importPlan.nDrinkInfoID := m_LocalDrinkArray[nRow-1].nDrinkInfoID;

        if ImportDrinkInfo(importPlan,trainman,m_LocalDrinkArray[nRow-1]) then
          dbConnAccess.UpdateDrinkState(importPlan.nDrinkInfoID)
        else
          GlobalDM.LogManage.InsertLog('上传断网测酒记录--4导入测酒记录失败');

      end;
    end;
  finally
    TfrmProgressEx.CloseProgress;
    dbConnAccess.Free;

    QueryLocalDrinkInfo;
    RefreshLocalDrinkAlarm(dbConnAccess);
    InitTuiQinPlans;
  end;
end;

procedure TfrmMain_TuiQin.btnCancelDrinkClick(Sender: TObject);
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

procedure TfrmMain_TuiQin.btnHideDrinkClick(Sender: TObject);
begin
  AdvSplitter1.Visible := false;
  RzPanel8.Visible := false;
end;

procedure TfrmMain_TuiQin.QueryLocalDrinkInfo();
var               
  dbConnAccess: TConnAccess;
  i: integer;
  DrinkQuery: RRsDrinkQuery; 

begin

  
  dbConnAccess := TConnAccess.Create(Application);
  try
    if not dbConnAccess.ConnectAccess then exit;
    try
      DrinkQuery.nWorkTypeID := 0;
      DrinkQuery.strTrainmanNumber := '';
      DrinkQuery.dtBeginTime := 0;
      DrinkQuery.dtEndTime := 0;
      dbConnAccess.QueryDrinkInfo(DrinkQuery, m_LocalDrinkArray);
      with grdMain do
      begin
        ClearRows(1, 10000);
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
        grdMain.Repaint;
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
         
function TfrmMain_TuiQin.ImportDrinkInfo(ImportPlan: RRsImportPlan;trainman : RRsTrainman;localDrinkInfo:RRsDrinkInfo): boolean;
var
  TestResult: RTestAlcoholInfo;
  trainmanPlan : RRsTrainmanPlan;
  RDrink: RRsDrink;
  endWork:RRsEndWork ;
  strError:string;
  dtNow: TDateTime;
  dutyUser :TRsDutyUser;
  dutyPlaceList:TRsDutyPlaceList;
begin
  result := false;
  dutyUser := TRsDutyUser.Create ;
  try

    if not m_webDutyPlace.GetDutyPlaceByClient(ImportPlan.TrainPlan.strTrainJiaoluGUID,
      dutyPlaceList,strError) then
    begin
      BoxErr('获取出勤点错误'+strError);
      Exit ;
    end;

    try
      trainmanPlan.Group := ImportPlan.Group;
      trainmanPlan.Group.Trainman1.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman2.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman3.strTrainmanGUID := '';
      trainmanPlan.Group.Trainman4.strTrainmanGUID := '';
      trainmanPlan.TrainPlan := ImportPlan.TrainPlan;
      trainmanPlan.dtBeginWorkTime := ImportPlan.dtBeginWorkTime;

      TestResult := ImportPlan.TestAlcoholInfo;
      RDrink.AssignFromTestAlcoholInfo(TestResult);
      RDrink.strPictureURL := PostDrinkImage(ImportPlan.Trainman,TestResult);
      Application.ProcessMessages;

      dtNow := GlobalDM.GetNow;
      with  endWork.endWorkInfo do
      begin

        endworkID := '';
        trainmanID := ImportPlan.Trainman.strTrainmanGUID;
        planID := ImportPlan.TrainPlan.strTrainPlanGUID ;
        verifyID := IntToStr(ord(ImportPlan.nVerifyID));
        dutyUserID := GlobalDM.DutyUser.strDutyGUID ;
        stationID := GlobalDM.SiteInfo.strStationGUID ;
        placeID := dutyPlaceList[0].placeID ;
        arriveTime:= TestResult.dtTestTime;
        lastEndWorkTime := dtNow;
        remark := '';

      end;

      with endWork.drinksInfo do
      begin
        trainmanID := ImportPlan.Trainman.strTrainmanGUID ;
        drinkResult := inttostr(RDrink.nDrinkResult) ;
        workTypeID := IntToStr(RDrink.nWorkTypeID);
        createTime := RDrink.dtCreateTime;
        imagePath  := RDrink.strPictureURL;


        //人员信息
        drink.bLocalAreaTrainman := GlobalDM.bLocalAreaTrainman(ImportPlan.Trainman.strTrainmanNumber) ;
        drink.strTrainmanName := ImportPlan.Trainman.strTrainmanName ;
        drink.strTrainmanNumber := ImportPlan.Trainman.strTrainmanNumber ;

        //车次信息
        drink.strTrainNo  := ImportPlan.TrainPlan.strTrainNo ;
        drink.strTrainNumber := ImportPlan.TrainPlan.strTrainNumber  ;
        drink.strTrainTypeName := ImportPlan.TrainPlan.strTrainTypeName  ;

        //车间信息
        drink.strWorkShopGUID :=  ImportPlan.Trainman.strWorkShopGUID;
        drink.strWorkShopName := ImportPlan.Trainman.strWorkShopName ;
        
        //退勤点信息
        drink.strPlaceID := GlobalDM.DutyPlace.placeID ;
        drink.strPlaceName  := GlobalDM.DutyPlace.placeName;
        //
        drink.strSiteGUID  := GlobalDM.SiteInfo.strSiteGUID;
        drink.strSiteIP := GlobalDM.SiteInfo.strSiteIP ;
        drink.strSiteName  := GlobalDM.SiteInfo.strSiteName ;

        drink.strAreaGUID := LeftStr(ImportPlan.Trainman.strTrainmanNumber,2);
        drink.strDutyNumber := localDrinkInfo.strDutyNumber;
        if m_RsLCDutyUser.GetDutyUserByNumber(localDrinkInfo.strDutyNumber,dutyUser) = True then
          drink.strDutyName:= dutyUser.strDutyName;

        //酒精度
        drink.dwAlcoholicity := RDrink.dwAlcoholicity;
        drink.nWorkTypeID  :=  DRINK_TEST_TUI_QIN ;
      end;

      endWork.dutyUserID := GlobalDM.DutyUser.strDutyGUID ;


      if not m_webTrainPlan.ExcuteTuiQin(endWork,strError) then
        raise Exception.Create(strError);



      Application.ProcessMessages;


      RDrink.nVerifyID := ord(ImportPlan.nVerifyID) ;
      RDrink.nWorkTypeID := DRINK_TEST_TUI_QIN ;
      PostAlcoholMessage(ImportPlan.trainman,RDrink);

      PostWorkEndMessage(ImportPlan.Trainman,trainmanPlan,TestResult.taTestAlcoholResult,TestResult.dtTestTime);
      result := true;
    except on e : exception do
      begin
        Box('导入失败:' + e.Message);
      end;
    end;
  finally
    dutyUser.Free ;
  end;
end;
  
procedure TfrmMain_TuiQin.RefreshLocalDrinkAlarm(ConnAccess: TConnAccess);
var
  dbConnAccess: TConnAccess;
  nCount: integer;
  pt: TPoint;
begin
  nCount := 0;
  if ConnAccess <> nil then
  begin
    try
      nCount := ConnAccess.GetDrinkInfoCount;
    except
    end;
  end
  else
  begin
    dbConnAccess := TConnAccess.Create(Application);
    try
      if not dbConnAccess.ConnectAccess then exit;
      nCount := dbConnAccess.GetDrinkInfoCount;
    finally
      dbConnAccess.Free;
    end;
  end;

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
end;

end.
