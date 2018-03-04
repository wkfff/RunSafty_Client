unit uFrmMain_RoomSign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, ExtCtrls, RzPanel, Menus, ComCtrls, RzDTP, StdCtrls,
  Buttons, PngSpeedButton,uGlobalDM, uStyleGrid, Grids, AdvObj, BaseGrid,
  AdvGrid, ActnList,utfsystem,ufrmTextInput,
  uTrainman,uTestFTPUDPThread,MMSystem,UfrmUDPConfig, RzTray, PngCustomButton,
  PngBitBtn , Math,
  uTrainPlan,uLogs,
  uSaftyEnum,uFrmRoom,
  uDBTrainman, uDBTrainJiaolu,
  IniFiles,pngimage,uConnAccess, RzTabs,
  uDBAccessRoomSign,uRoomSignConfig ,uUploadSignInfo,ShellAPI,
  uThreadUploadSign,uPlan,DateUtils,
  uLCTrainPlan,uWorkShop,uDBWorkShop,uCallRoomDM,Contnrs,uCallUtils,
  uTFMessageDefine,uRunSaftyMessageDefine,
  uCallRecord,uMixerRecord,uFrmErrorAlarm,ADODB,uRoomWaitDBOprate
  ;

type



  TfrmMain_RoomSign = class(TForm)
    pMain: TPanel;
    RzPanel2: TRzPanel;
    PngCustomButton7: TPngCustomButton;
    PngCustomButton8: TPngCustomButton;
    PngCustomButton9: TPngCustomButton;
    PngCustomButton13: TPngCustomButton;
    PngCustomButton14: TPngCustomButton;
    PngCustomButton15: TPngCustomButton;
    lblSysTime: TLabel;
    lblDutyUser: TLabel;
    lblDBState: TLabel;
    lblFingerState: TLabel;
    lblSerialState: TLabel;
    lblTestLine: TLabel;
    lblUDPState: TLabel;
    lblFTPState: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miExit: TMenuItem;
    N2: TMenuItem;
    mniCallOnfig: TMenuItem;
    mniFTPConfig: TMenuItem;
    miUDPConfig: TMenuItem;
    N9: TMenuItem;
    miRoom: TMenuItem;
    N7: TMenuItem;
    miQueryCallRecord: TMenuItem;
    N12: TMenuItem;
    miDCJL: TMenuItem;
    miQueryRoomState: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    TimerSystemTime: TTimer;
    ActionList1: TActionList;
    actF5: TAction;
    actF4: TAction;
    actF3: TAction;
    actF6: TAction;
    actCtrlI: TAction;
    actTrainman: TAction;
    actRestInWaiting: TAction;
    actFingerLevel: TAction;
    timerAutoCall: TTimer;
    timerDBAutoConnect: TTimer;
    timerTestLineBegin: TTimer;
    timerTestLineEnd: TTimer;
    PageControl1: TPageControl;
    tabCall: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel3: TPanel;
    lblCallCount: TLabel;
    btnOutRoom: TSpeedButton;
    btnInRoom: TSpeedButton;
    btnCall: TSpeedButton;
    btnLeaderExam: TSpeedButton;
    btnCallNow2: TSpeedButton;
    btnChanngeRoom: TSpeedButton;
    btnEditCallTime: TSpeedButton;
    strGridCall: TAdvStringGrid;
    grpRoomPlan: TGroupBox;
    Panel5: TPanel;
    RoomPlanGrid: TAdvStringGrid;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    PColor1: TPanel;
    pColor2: TPanel;
    pColor3: TPanel;
    pColor4: TPanel;
    pColor5: TPanel;
    GroupBox2: TGroupBox;
    btnCallNow: TButton;
    btnAddTemp: TButton;
    btnDeleteTemp: TButton;
    btnEditTemp: TButton;
    pngbtbtnManual: TPngBitBtn;
    miQueryLeaderExam: TMenuItem;
    mniModifyPassword: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    mniTrainmanManager: TMenuItem;
    btnTestMessage: TButton;
    timerAutoRefresh: TTimer;
    N3: TMenuItem;
    E1: TMenuItem;
    actImportTrainmanInfo: TAction;
    N10: TMenuItem;
    actExportSignInfo: TAction;
    N11: TMenuItem;
    N13: TMenuItem;
    actF10: TAction;


    procedure btnExchangeModuleClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);


    procedure actImportSignInfoExecute(Sender: TObject);
    procedure actExportSignInfoExecute(Sender: TObject);

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnInRoomClick(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure btnCallNowClick(Sender: TObject);
    procedure btnAddTempClick(Sender: TObject);
    procedure btnEditTempClick(Sender: TObject);
    procedure btnDeleteTempClick(Sender: TObject);
    procedure pngbtbtnManualClick(Sender: TObject);
    procedure btnCallNow2Click(Sender: TObject);
    procedure btnLeaderExamClick(Sender: TObject);
    procedure btnChanngeRoomClick(Sender: TObject);
    procedure btnEditCallTimeClick(Sender: TObject);
    procedure TimerSystemTimeTimer(Sender: TObject);
    procedure timerAutoRefreshTimer(Sender: TObject);
    procedure timerAutoCallTimer(Sender: TObject);
    procedure timerDBAutoConnectTimer(Sender: TObject);
    procedure timerTestLineBeginTimer(Sender: TObject);
    procedure timerTestLineEndTimer(Sender: TObject);
    procedure mniCallOnfigClick(Sender: TObject);
    procedure mniFTPConfigClick(Sender: TObject);
    procedure miUDPConfigClick(Sender: TObject);
    procedure miRoomClick(Sender: TObject);
    procedure miQueryCallRecordClick(Sender: TObject);
    procedure miDCJLClick(Sender: TObject);
    procedure miQueryRoomStateClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miQueryLeaderExamClick(Sender: TObject);
    procedure btnOutRoomClick(Sender: TObject);
    procedure mniModifyPasswordClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure mniTrainmanManagerClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure RzTrayIcon1QueryEndSession(Sender: TObject;
      var AllowSessionToEnd: Boolean);
    procedure btnTestMessageClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure actImportTrainmanInfoExecute(Sender: TObject);
    procedure actF3Execute(Sender: TObject);
    procedure actF4Execute(Sender: TObject);
    procedure actF5Execute(Sender: TObject);
    procedure actF6Execute(Sender: TObject);
    procedure actCtrlIExecute(Sender: TObject);
    procedure actRestInWaitingExecute(Sender: TObject);
    procedure actFingerLevelExecute(Sender: TObject);
    procedure actF10Execute(Sender: TObject);

  private
    m_strRecGUID: string; //当前叫班GUID
    m_CallList: TObjectList;
    m_AppStartTime: TDateTime;
    m_CallThread : TCallThread;
    m_CallData : TCallData;
    m_bCapturing : boolean;
    m_MixerRecord : TMixerRecord;
    m_TestRecord : TMixerRecord;
    m_FrmAlarm : TfrmErrorAlarm;

    procedure CallRoom(dtNow: TDateTime; callData: TCallData;secondCall : boolean);
  private
    { Private declarations }
    //初始化待承
    procedure InitRoomPlan();
    //初始化叫班列表信息{强休}
    procedure InitCalls;
    //判断追叫时间,判断当前时间在规定叫班时间5分钟虎1个小时之内
    function InSecondCallTime(callTime, nowTime: TDateTime): boolean;
    //添加叫班数据
    procedure InsertCall(ado: TADOQuery; nType: Integer);
    //删除已取消的叫班数据
    procedure DeleteCall(ado:TADOQuery;nType:Integer);
    //保存自动叫班数据
    procedure SaveCallResult(strGUID: string);
    //刷新所有的数据
    procedure RefreshAll;
    //刷新所有背景色
    procedure RefreshAllBGColor(nTypeID : Integer);
    //获取待班车次的呼叫此次
    function GetCallCount(strGUID: string): Integer;
    //获取待乘车次的数据
    function GetCallData(strGUID: string) :  TCallData;
    //显示叫班失败窗口
    procedure  ShowCallFailure(msg : string);
    procedure ShowAlarm(msg : string);
    procedure CloseAlarm();
    //读取指纹仪的状态描述
    procedure ReadFingerprintState;
    //开始录音
    procedure WMMSGRecordBegin(var Message : TMessage); message WM_MSGRecordBegin;
    //结束录音
    procedure WMMSGRecordEnd(var Message : TMessage); message WM_MSGRecordEnd;
    //开始叫班
    procedure WMSGCallBegin(var Message : TMessage); message WM_MSGCallBegin;
    //叫班结束
    procedure WMMSGCallEnd(var Message : TMessage); message WM_MSGCallEnd;
    procedure WMMSGWaitingForConfirm(var Message : TMessage); message WM_MSGWaitingForConfirm;
    //全局热键消息
    procedure WMHotkey(var msg:TWMHotkey);message WM_HOTKEY;
    //(闫)
    //测试UDP结束
    procedure WMMSGTestUDPEnd(var message : TMessage); message WM_MSGTestUDPEnd;
    //测试FTP结束
    procedure WMMSGTestFTPEnd(var message : TMessage); message WM_MSGTestFTPEnd;
    {功能：手工叫班}
    procedure ManualCall();
    procedure WriteDutyTime(RoomPlanID: string;dtDutyTime: TDateTime);

  public
    { Public declarations }
    m_dtLastCallTime: TDateTime; //上一次叫班时间
    m_dtLastResetTime : TDateTime;
    //让所有控件可以操作
    procedure EnableAll;
    //让所有控件不能操作
    procedure DisableAll;

    //远程叫班模式（闫）
    procedure KaiShiJiaoBan(JiaoBanCommand: string);

  private
    //数据回传(入寓和离寓信息)
    m_obUpload:TUploadSignInfo;
    //配置管理
    m_obRoomSignConfig : TRoomSignConfigOper;
    //前一个调用的事件  ,指纹仪事件
    m_OldFingerTouch : TNotifyEvent;
    //行车区段数据库操作
    m_DBTrainJiaolu : TRsDBTrainJiaolu;
    //WEB计划接口
    m_webTrainPlan:TRsLCTrainPlan;
  private

      //根据消息里面的PLANGUID制造计划 默认为签到状态
    function InsertWaitPlan(PlanGUIDS:TStrings):Boolean;
    {功能:修改候班计划 默认为签到状态}
    function UpdateWaitPlan(PlanGUIDS:TStrings):Boolean;
    {功能:修改候班计划}
    function DeleteWaitPlan(PlanGUIDS:TStrings):Boolean;
    {功能:回传信息}
    procedure UploadRoomSignInfo(Sender: TObject);

    //添加测试强休计划
    procedure AddQiangXiuPlan();

  private
    procedure TestMessage();
      //接收系统消息事件
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    //数据库已连接
    procedure DBConnected(Sender : TObject);
    //数据库已断开
    procedure DBDisconnected(Sender : TObject);
  public
    procedure InitData();
    {功能:出入公寓}
    procedure InOutRoom(trainman:RRsTrainman;eVerifyFlag: TRsRegisterFlag);
  public
    { Public declarations }
    class procedure EnterRoomSign();
    class procedure LeaveRoomSign();
  end;

var
  frmMain_RoomSign: TfrmMain_RoomSign;

implementation

{$R *.dfm}

uses
  ufrmModifyPassWord,ufrmDCJS, uFrmAbout,
  uFrmLogin,uMixerControl,uFrmRoomState,
  uFrmExchangeModule,ufrmPlanNoCallEdit,ufrmQueryCallRecord,
  uSite,
  uFrmInputDutyTime,
  ufrmAccessReadFingerprintTemplates,
  uFrmLeaderInspect,
  ufrmConfig,
  ufrmTrainmanPicFigEdit,uFrmEditCallTime,
  uFrmGetDateTime,
  uFrmRestTrainNo,
  uFrmLeaderResult,uFrmFTPConfig,
  utfPopBox,uFrmProgressExEx,
  ufrmTrainmanPicFigEditAccess,
  uFrmTrainmanManageAccess,uFrmQueryLeaderExam,
  uFrmProgressEx,ufrmCallConfig,uFrmNoTimeAlarm,
  uDownLoadSignInfo,uFrmCallConfirm,ufrmTrainmanIdentityAccess,
  uFrmRoomSignSysConfig,uFrmCallFailure,ufrmManualCall2,
  uFrmRoomInfo,ufrmHint,uRoom, uFrmFindRoom, uFrmTrainNoSelect, uFrmInRoom,
  uFrmOutRoom,uFrmImportTrainman;



function GetDeveiceID(strRoom: string): Integer;
//功能：根据房间号获得设备ID号
var
  room: RRoom;
begin
  room := TRoomOpt.GetRoom(DMCallRoom.LocalArea, strRoom);
  Result := room.nDeveiveID;
end;


function CalledToStr(bValue: Boolean): string;
begin
  if bValue then
    Result := '已叫班'
  else
    Result := '未叫班';
end;


procedure TfrmMain_RoomSign.actCtrlIExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RoomSign.actExportSignInfoExecute(Sender: TObject);
begin
  UploadRoomSignInfo(Sender);
end;

procedure TfrmMain_RoomSign.actF10Execute(Sender: TObject);
begin
  btnLeaderExam.Click ;
end;

procedure TfrmMain_RoomSign.actF3Execute(Sender: TObject);
begin
  btnInRoom.Click;
end;

procedure TfrmMain_RoomSign.actF4Execute(Sender: TObject);
begin
  btnOutRoom.Click;
end;

procedure TfrmMain_RoomSign.actF5Execute(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RoomSign.actF6Execute(Sender: TObject);
begin
  btnCall.Click;
end;

procedure TfrmMain_RoomSign.actFingerLevelExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RoomSign.actImportSignInfoExecute(Sender: TObject);
//var
//  obDownload:TDownloadSignInfo;
//  nCount:Integer;
begin
//  nCount := 0;

//  try
//    GlobalDM.ConnecDB;
//  except on e : exception do
//    begin
//      Box(Format('连接服务器失败:%s...',[e.Message]));
//      Exit;
//    end;
//  end;
//
//  obDownload := TDownloadSignInfo.Create() ;
//  try
//    try
//      TfrmProgressEx.CreateProgress();
//      obDownload.SetConnect(GlobalDM.ADOConnection,GlobalDM.LocalADOConnection,
//        TfrmProgressEx.DisplayProgess,nil);
//
//      TfrmProgressEx.SetHint('正在导入房间信息，请稍后');
//      obDownload.DownloadRoomInfo(nCount) ;
//
//      TfrmProgressEx.SetHint('正在导入入寓信息，请稍后');
//      obDownload.DownloadSignInInfo(nCount) ;
//
//      TfrmProgressEx.SetHint('正在导入离寓信息，请稍后');
//      obDownload.DownloadSignOutInfo(nCount) ;
//
//      TtfPopBox.ShowBox('导入完毕',1000);
//    except
//      on e:Exception do
//      begin
//        BoxErr('导入错误:' + e.Message );
//      end;
//    end;
//  finally
//    TfrmProgressEx.CloseProgress;
//    obDownload.Free ;
//  end;
end;

procedure TfrmMain_RoomSign.actImportTrainmanInfoExecute(Sender: TObject);
begin
    TFrmImportTrainman.ImportTrainman ;
end;

procedure TfrmMain_RoomSign.actRestInWaitingExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RoomSign.AddQiangXiuPlan;
var
  planRest : RPlan;
begin
  try
    GlobalDM.LogManage.InsertLog('增加需要强休的人员计划');
      //排除过期的计划
    with planRest do
    begin
      strGUID :=  '123456' ;
      strTrainNo := 'k105' ;

      dtSigninTime := StrToDateTime('2015-06-03 10:20:07') ;
      dtCallTime := StrToDateTime('2015-06-03 10:20:07')  ;
      dtOutDutyTime := StrToDateTime('2015-06-03 10:20:07') ;
      dtStartTime := StrToDateTime('2015-06-03 10:20:07')  ;

      strMainDriverGUID := '001367E1-17D5-46A3-A800-54FA962C9817';
      nMainDriverState := 2 ;   //已签到

      strSubDriverGUID := '' ;
      nSubDriverState := 2 ;   //已签到

      strInputGUID := 'E350B305-80B3-4E95-AABF-332C33CB1C91';
      dtInputTime := StrToDateTime('2015-05-29 10:20:07') ;

      nTrainmanTypeID := 2;
      nState := 2 ;
      strAreaGUID := '' ;
    end;
    TDBPlan.AddPlan(planRest);
    Application.ProcessMessages ;
  finally
    ;
  end;
end;

procedure TfrmMain_RoomSign.btnAddTempClick(Sender: TObject);
var
  frmPlanNoCall : TfrmPlanNoCall;
begin
  frmPlanNoCall := TfrmPlanNoCall.Create(nil);
  try
    frmPlanNoCall.ShowModal;
  finally
    frmPlanNoCall.Free;
  end;
end;

procedure TfrmMain_RoomSign.btnCallClick(Sender: TObject);
begin
  ManualCall();
end;

procedure TfrmMain_RoomSign.btnCallNow2Click(Sender: TObject);
var
  strGUID : string;
  plan : RPlan;
begin
  if (strGridCall.Row = 0)  then exit;

  strGUID :=  strGridCall.Cells[99, strGridCall.Row];
  if strGUID = '' then exit;
  plan := TDBPlan.GetPlan(strGUID);
  if plan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 3) and  (plan.nSubDriverState < 3) then
  begin
    Application.MessageBox('还没有人员入寓！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('该计划已经叫过班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，请勿重复叫班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('您确定要现在就对车次【'+plan.strTrainno+'】进行叫班吗？')
    ,'提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TDBPlan.UpdatePlanRecordTime(strGUID) then
  begin
    TLog.SaveLog(now,Format('%s立即叫班',[plan.strTrainNo]));
    InitCalls;
    Application.MessageBox('立即叫班失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('叫班成功！，请稍等！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_RoomSign.btnCallNowClick(Sender: TObject);
var
  //ado: TADOQuery;
  strGUID : string;
  roomPlan : RWaitPlanRecord;
  dtDutyTime: TDateTime;
begin
  if (RoomPlanGrid.Row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;
  strGUID :=  RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;

  roomPlan := TWaitPlanOpt.GetPlanRecord(strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，请勿重复叫班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('您确定要现在就对车次【'+roomPlan.strTrainno+'】进行叫班吗？')
    ,'提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if (ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','MustDutyTime') = '1')
    and (roomPlan.dtDutyTime <= 0) then
  begin
    if ShowFrmInPutDutyTime(dtDutyTime) = False then Exit;
    WriteDutyTime(strGUID,dtDutyTime);
  end;


  if not TWaitPlanOpt.UpdatePlanRecordTime(strGUID) then
  begin
    TLog.SaveLog(now,Format('%s立即叫班',[roomPlan.strTrainNo]));
    InitRoomPlan;
    Application.MessageBox('立即叫班失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  //远程叫班模式派班端（闫）
  if (not DMCallRoom.bCallModel) and (not DMCallRoom.bInstallAddress ) then
  begin
    //InitRoomPlan;
    Application.MessageBox('叫班命令已发出，请稍等！','提示',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  Application.MessageBox('叫班成功！，请稍等！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_RoomSign.btnChanngeRoomClick(Sender: TObject);
var
  strGUID : string;
  plan : RPlan;
  roomNumber : string;
begin
  if (strGridCall.Row = 0)  then exit;
  strGUID :=  strGridCall.Cells[99, strGridCall.Row];
  if strGUID = '' then exit;
  plan := TDBPlan.GetPlan(strGUID);
  if plan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState > 3) or (plan.nSubDriverState > 3) then
  begin
    Application.MessageBox('入住人员已经办理离寓，不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 3) and (plan.nMainDriverState < 3) then
  begin
    Application.MessageBox('还未给此计划分配房间,不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('该计划已经叫过班,不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  frmFindRoom := TfrmFindRoom.Create(nil);
  try
    if frmFindRoom.ShowModal = mrCancel then exit;
    roomNumber := frmFindRoom.lvRoom.Selected.SubItems[0];
    if not TDBPlan.EditPlanRoom(strGUID,roomNumber) then
    begin
      Application.MessageBox('修改失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    Application.MessageBox('修改成功！','提示',MB_OK + MB_ICONINFORMATION);
  finally
    frmFindRoom.Free;
  end;
end;

procedure TfrmMain_RoomSign.btnDeleteTempClick(Sender: TObject);
var
  strGUID : string;
  roomPlan : RWaitPlanRecord;
begin
  if (RoomPlanGrid.row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;
  strGUID :=  RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;
  roomPlan := TWaitPlanOpt.GetPlanRecord(strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班，不能删除！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，不能删除计划！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  

  if Application.MessageBox('您确定要删除该计划吗？','提示',MB_OKCANCEL) = mrCancel then exit;

  if not TWaitPlanOpt.DeletePlanRecord(strGUID) then
  begin
    Application.MessageBox('删除异常，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  Application.MessageBox('删除成功！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_RoomSign.btnEditCallTimeClick(Sender: TObject);
var
  strGUID : string;
  plan : RPlan;
begin
  if (strGridCall.Row = 0)  then exit;

  strGUID :=  strGridCall.Cells[99, strGridCall.Row];
  if strGUID = '' then exit;
  plan := TDBPlan.GetPlan(strGUID);
  if plan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 2) and  (plan.nSubDriverState < 2) then
  begin
    Application.MessageBox('还没有人员签到！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('该计划已经叫过班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，不能进行此操作！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not TfrmEditCallTime.EditForm(plan.dtCallTime) then exit;

  if not TDBPlan.UpdateCalTime(strGUID,plan.dtCallTime) then
  begin
    TLog.SaveLog(now,Format('%s修改叫班时间:%s',[plan.strTrainNo,FormatDateTime('yyyy-MM-dd HH:nn',plan.dtCallTime)]));
    InitCalls;
    Application.MessageBox('修改叫班时间失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('修改叫班时间成功！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_RoomSign.btnEditTempClick(Sender: TObject);
var
  frmPlanNoCallEdit : TfrmPlanNoCallEdit;
  strGUID : string;
  roomPlan : RWaitPlanRecord;
begin
  if (RoomPlanGrid.row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;

  strGUID :=  RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;
  roomPlan := TWaitPlanOpt.GetPlanRecord(strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班，不能修改！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，不能修改计划！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
 
  frmPlanNoCallEdit := TfrmPlanNoCallEdit.Create(nil);
  try
    frmPlanNoCallEdit.PlanGUID := strGUID;
    frmPlanNoCallEdit.ShowModal;
  finally
    frmPlanNoCallEdit.Free;
  end;
end;

procedure TfrmMain_RoomSign.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
end;

procedure TfrmMain_RoomSign.btnExitClick(Sender: TObject);
begin
  Close;
end;



procedure TfrmMain_RoomSign.btnInRoomClick(Sender: TObject);
var
  trainNo: string;
  ado: TADOQuery;
  frmTrainNoSelect:TfrmTrainNoSelect ;
begin
  GlobalDM.OnFingerTouching := nil ;
  frmTrainNoSelect := TfrmTrainNoSelect.Create(nil);
  try
    if frmTrainNoSelect.ShowModal = mrOk then
    begin
      trainNo := frmTrainNoSelect.m_strTrainNo;
      TDBPlan.GetInRoomByTrainNo(trainNo, GlobalDM.GetNow, ado);
      if ado.RecordCount = 0 then
      begin
        Application.MessageBox('没有找到指定车次的计划信息.',
          '提示', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
      try
        frmInRoom := TfrmInRoom.Create(nil);
        try
          frmInRoom.PlanGUID := ado.FieldByName('strGUID').AsString;
          frmInRoom.TrainPlanGUID := ado.FieldByName('strGUID').AsString ;
          if frmInRoom.ShowModal = mrok then
          begin
            InitCalls;
          end;
        finally
          frmInRoom.Free;
        end;
      finally
        ado.Free;
      end;
    end;
  finally
    frmTrainNoSelect.Free;
    GlobalDM.OnFingerTouching := OnFingerTouching ;
  end;
end;

procedure TfrmMain_RoomSign.btnLeaderExamClick(Sender: TObject);
var
  frm : TFrmLeaderInspect;
begin
  frm := TFrmLeaderInspect.Create(nil) ;
  try
    frm.ShowModal ;
  finally
    frm.Free ;
  end;
end;

procedure TfrmMain_RoomSign.btnOutRoomClick(Sender: TObject);
var
  trainNo: string;
  ado: TADOQuery;
  frmTrainNoSelect : TfrmTrainNoSelect;
begin
  GlobalDM.OnFingerTouching := nil ;
  frmTrainNoSelect := TfrmTrainNoSelect.Create(nil);
  try
    if frmTrainNoSelect.ShowModal = mrOk then
    begin
      trainNo := frmTrainNoSelect.m_strTrainNo;
      TDBPlan.GetOutRoomByTrainNo(trainNo, GlobalDM.GetNow, ado);
      if ado.RecordCount = 0 then
      begin
        Application.MessageBox('没有找到指定车次的计划信息.',
          '提示', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
      if GlobalDM.GetNow < IncHour(ado.FieldByName('dtCallTime').AsDateTime,-1) then
      begin
        if not AlarmNoTime then exit;              
      end;
      try
        frmOutRoom := TfrmOutRoom.Create(nil);
        try
          frmOutRoom.PlanGUID := ado.FieldByName('strGUID').AsString;
          frmOutRoom.TrainPlanGUID := ado.FieldByName('strGUID').AsString;
          if frmOutRoom.ShowModal = mrok then
          begin
            InitCalls;
          end;
        finally
          frmOutRoom.Free;
        end;
      finally
        ado.Free;
      end;
    end;
  finally
    frmTrainNoSelect.Free;
    GlobalDM.OnFingerTouching := OnFingerTouching ;
  end;
end;

procedure TfrmMain_RoomSign.btnTestMessageClick(Sender: TObject);
begin
  AddQiangXiuPlan;
  Exit ;
  TestMessage ;
end;

procedure TfrmMain_RoomSign.CallRoom(dtNow: TDateTime; callData: TCallData;
  secondCall: boolean);
begin
  ;//远程叫班模式（闫）
  if not DMCallRoom.bCallModel then
  begin
    TLog.SaveLog(Now,'不是叫班模式');
    if not secondCall then
      DMCallRoom.UDPControl.SendCommand('#1:' + callData.strRoomNumber + ':' + callData.strGUID + '#')
    else
      DMCallRoom.UDPControl.SendCommand('#11:' + callData.strRoomNumber + ':' + callData.strGUID + '#');
  end;

  OutputDebugString(PChar(Format('开始呼叫%s房间',[callData.strRoomNumber])));
  m_CallData := callData;
  try
    //如果存在以前的叫班线程，则释放线程重新创建叫班线程
    if Assigned(m_CallThread) then
      FreeAndNil(m_CallThread);
    m_CallThread := TCallThread.Create(true);
    TLog.SaveLog(now,'创建呼叫线程成功');
      //记录当前叫班的数据
    m_strRecGUID := m_CallData.strGUID;
    m_dtLastCallTime := StrToDateTime('9999-01-01 00:00:00');
    //保存叫班数据的状态
    //Inc(callData.nCallState);
    //刷新叫班数据显示
    RefreshAllBGColor(callData.nType);
    //开始执行叫班线程

    m_CallThread.CallData := callData;
    m_CallThread.IsRecall := secondCall;
    TLog.SaveLog(now,'启动叫班数据线程');
    m_CallThread.Resume;
    TLog.SaveLog(now,'启动叫班数据线程成功');
  except
    //叫班过程异常则复位叫班数据
    dtNow := GlobalDM.GetNow;
    m_dtLastCallTime := dtNow;
    m_strRecGUID := '';
    RefreshAllBGColor(callData.nType);
    TLog.SaveLog(now,'启动叫班数据线程失败');
  end;
end;

procedure TfrmMain_RoomSign.CloseAlarm;
begin
  m_FrmAlarm.Hide;
end;

function TfrmMain_RoomSign.InsertWaitPlan(
  PlanGUIDS: TStrings): Boolean;
var
  //人员计划
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray ;
  strError:string;
  i : Integer ;
  planRest : RPlan;
begin
  Result := False ;
  //获取需要强休的人员计划
  GlobalDM.LogManage.InsertLog('获取需要强休的人员计划');

  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;


  try
    GlobalDM.LogManage.InsertLog('增加需要强休的人员计划');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //排除过期的计划
      if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
        Continue ;
      with planRest do
      begin
        strGUID :=  TrainmanPlan.TrainPlan.strTrainPlanGUID ;
        strTrainNo := TrainmanPlan.TrainPlan.strTrainNo ;

        dtSigninTime := TrainmanPlan.TrainPlan.dtArriveTime;
        dtCallTime := TrainmanPlan.TrainPlan.dtCallTime ;
        dtOutDutyTime := TrainmanPlan.TrainPlan.dtStartTime ;
        dtStartTime := TrainmanPlan.TrainPlan.dtChuQinTime ;

        strMainDriverGUID := TrainmanPlan.Group.Trainman1.strTrainmanGUID;
        nMainDriverState := 2 ;   //已签到

        strSubDriverGUID := TrainmanPlan.Group.Trainman2.strTrainmanGUID ;
        nSubDriverState := 2 ;   //已签到

        strInputGUID := TrainmanPlan.TrainPlan.strCreateUserGUID;
        dtInputTime := TrainmanPlan.TrainPlan.dtCreateTime ;

        nTrainmanTypeID := 2;
        nState := 2 ;
        strAreaGUID := '' ;
      end;
      TDBPlan.AddPlan(planRest);
      Application.ProcessMessages ;
    end;
    Result := True ;
  finally
    ;
  end;
end;

procedure TfrmMain_RoomSign.DBConnected(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RoomSign.DBDisconnected(Sender: TObject);
begin

end;

procedure TfrmMain_RoomSign.DeleteCall(ado: TADOQuery; nType: Integer);
var
  i : Integer;
  bFind : Boolean;
  callGUID : string;
  callData : TCallData;
begin
  for i := m_CallList.Count - 1 downto 0 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    if callData.nType = nType then
    begin
      bFind := false;
      with ado do
      begin
        First;
        while not eof do
        begin
          callGUID := FieldByName('strGUID').AsString;
          if callGUID = callData.strGUID then
          begin
            bFind := true;
            break;
          end;
          next;
        end;
      end;
      if not bFind then
      begin
        //已过期的计划的叫班时间在23：30分以后的数据，在当前时间为00：30分以前不删除
        if  TimeOf(callData.dtCallTime) > TimeOf(StrToDateTime('2000-01-01 23:30:00')) then
        begin
          if TimeOf(GlobalDM.GetNow) < TimeOf(StrToDateTime('2000-01-01 00:30:00')) then
          begin
            OutputDebugString(PChar(FormatDateTime('HH:nn',TimeOf(callData.dtCallTime))));
            continue;
          end;
        end;
        m_callList.Delete(i);
      end;
    end;
  end;
end;

function TfrmMain_RoomSign.DeleteWaitPlan(
  PlanGUIDS: TStrings): Boolean;
var
  //人员计划
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray;
  strError,strPlanGUID :string;
  i : Integer ;
begin
  Result := False ;
  //获取需要强休的人员计划
  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;
  try
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //排除过期的计划
      if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
        Continue ;

      strPlanGUID := TrainmanPlan.TrainPlan.strTrainPlanGUID ;
      if not TDBPlan.FindByID(strPlanGUID) then
        Continue ;
      TDBPlan.DeletePlan(strPlanGUID);
      Application.ProcessMessages ;
    end;
  finally
     ;
  end;
end;

procedure TfrmMain_RoomSign.DisableAll;
begin
  Self.Menu := nil;;
  pMain.Enabled := false;

  timerAutoCall.Enabled := false;
end;



procedure TfrmMain_RoomSign.EnableAll;
begin

end;

class procedure TfrmMain_RoomSign.EnterRoomSign();
begin
  if frmMain_RoomSign = nil then
  begin
    Application.CreateForm(TfrmMain_RoomSign,frmMain_RoomSign);
    frmMain_RoomSign.InitData;
  end;
  frmMain_RoomSign.Show;
end;


procedure TfrmMain_RoomSign.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes
end;

procedure TfrmMain_RoomSign.FormCreate(Sender: TObject);
var
  strDutyGUID:string;
  strSiteGUID:string;
  i : Integer ;
begin

  for i := 0 to PageControl1.PageCount - 1 do
  begin
    PageControl1.Pages[i].TabVisible := False;//隐藏
  end ;
  PageControl1.ActivePage  := tabCall ;


  //注册全局F10快捷键
  //RegisterHotkey(Handle,1,0,VK_F10);
  //连接本地数据库
  GlobalDM.ConnectLocal_SQLDB();
  GlobalDM.m_bIsAccessMode := True ;
  //GlobalDM.blnIsLocalMode := True;
//  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  
  GlobalDM.LogManage.InsertLog('初始化指纹仪');
  //初始化指纹仪
  GlobalDM.InitFingerPrintting;

    //当前登录用户
  //statusDutyUser.Caption := '值班员: ' + '';
  GlobalDM.LogManage.InsertLog('查看指纹仪状态');
  //查看指纹仪状态
  ReadFingerprintState();

  GlobalDM.LogManage.InsertLog('读取指纹库内容');
  //读取指纹库内容
  if GlobalDM.FingerprintInitSuccess then
  begin
    GlobalDM.LogManage.InsertLog('初始化指纹仪成功!');
    ReadFingerprintTemplatesAccess(True);
  end;
  GlobalDM.LogManage.InsertLog('读取指纹模板');


  //挂接指纹仪点击事件
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;
  GlobalDM.OnDBConnected := DBConnected;
  GlobalDM.OnDBDisconnected := DBDisconnected;

  //如果使用网络版则禁止修改人员信息
  //单机版可以添加人员，但是不能回传数据
  //m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  m_obRoomSignConfig.ReadFromFile;


  m_bCapturing := false;
  m_CallList := TObjectList.Create;
  m_dtLastCallTime := 0;

  m_AppStartTime := GlobalDM.GetNow;

  m_MixerRecord := TMixerRecord.Create;
  //程序启动复位发射器
  DMCallRoom.CallControl.Reset;
  m_dtLastResetTime := Now;
  m_FrmAlarm := TfrmErrorAlarm.Create(NIL);

  TLog.SaveLog(now,'程序启动');

  TestFTPUDPThread := TTestFTPUDPThread.Create;


  //数据回传
  {$REGION '数据回传'}
  m_obUpload := TUploadSignInfo.Create() ;
//  m_obUpload.SetConnect(GlobalDM.ADOConnection,GlobalDM.LocalADOConnection,
//    TfrmProgressEx.DisplayProgess,nil);
  if GlobalDM.DutyUser = nil then
    strDutyGUID := ''
  else
    strDutyGUID := GlobalDM.DutyUser.strDutyGUID ;
  if GlobalDM.SiteInfo = nil then
    strSiteGUID := ''
  else
    strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
  m_obUpload.SetDutyUser(strDutyGUID,strSiteGUID);


  //读取数据回传的时间


  {
  with m_obRoomSignConfig.RoomSignConfigInfo do
  begin
    if  True  then
    begin
      m_obUploadThread := TThreadUploadSign.Create(strDutyGUID,strSiteGUID);
      if not m_obUploadThread.InitData then
      begin
        GlobalDM.LogManage.InsertLog('连接数据库失败');
        Exit;
      end;
      //分钟
      m_obUploadThread.SetSleepTime( nUploadTime * 60 );
      m_obUploadThread.Resume;
    end;
  end;
  }

  {$ENDREGION}
end;

procedure TfrmMain_RoomSign.FormDestroy(Sender: TObject);
begin

  //UnRegisterHotkey(Handle,1);

  m_obRoomSignConfig.Free ;
  m_DBTrainJiaolu.Free ;
  m_webTrainPlan.Free ;
  m_obUpload.Free ;


  m_CallList.Free;
  if Assigned(m_TestRecord) then
  begin
    m_TestRecord.stop;
    m_TestRecord.Free;
  end;
  if Assigned(m_CallThread) then
    m_CallThread.Free;

  m_MixerRecord.Stop;
  m_MixerRecord.Free;
  m_FrmAlarm.Free;

  //(闫)
  ShellExecute(   0,   nil,   'cmd.exe',   '/c   rd temp /s   /q',   nil,   SW_HIDE   );
  CreateDirectory(PChar(ExtractFilePath(ParamStr(0)) + 'temp'),nil);
  TestFTPUDPThread.Terminate;
  TestFTPUDPThread.WaitFor;
  TestFTPUDPThread.Free;


  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
end;

procedure TfrmMain_RoomSign.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
end;



function TfrmMain_RoomSign.GetCallCount(strGUID: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to m_CallList.Count - 1 do
  begin
    if TCallData(m_CallList.Items[i]).strGUID = strGUID then
    begin
      Result := TCallData(m_CallList.Items[i]).nCallState;
    end;
  end;
end;

function TfrmMain_RoomSign.GetCallData(strGUID: string): TCallData;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to m_CallList.Count - 1 do
  begin
    if TCallData(m_CallList.Items[i]).strGUID = strGUID then
    begin
      Result := TCallData(m_CallList.Items[i]);
    end;
  end;
end;

procedure TfrmMain_RoomSign.InitCalls;
var
  ado: TADOQuery;
  i, totalCount, waitCount, callCount: Integer;
begin
  ado := nil;
  try
    TDBPlan.GetCalls(GlobalDM.GetNow, ado);
    i := 0;
    with ado do
    begin
      totalCount := RecordCount;
      waitCount := 0;
      callCount := 0;
      strGridCall.RowCount := RecordCount + 2;
      strGridCall.Clear;
      strGridCall.ClearRows(0,9999);
      {$REGION '初始化列'}
      strGridCall.Cells[0, 0] := '序号';
      strGridCall.Cells[1, 0] := '待班车次';
      strGridCall.Cells[2, 0] := '房间号';
      strGridCall.Cells[3, 0] := '强休时间';
      strGridCall.Cells[4, 0] := '叫班时间';
      strGridCall.Cells[5, 0] := '出勤时间';
      strGridCall.Cells[6, 0] := '单双司机';
      strGridCall.Cells[7, 0] := '正司机';
      strGridCall.Cells[8, 0] := '正司机状态';
      strGridCall.Cells[9, 0] := '副司机';
      strGridCall.Cells[10, 0] := '副司机状态';
      strGridCall.Cells[11, 0] := '叫班状态';
      {$ENDREGION '初始化列'}
      while not eof do
      begin
        {$REGION '赋值'}
        Inc(i);
        strGridCall.RowHeights[i] := 30;
        strGridCall.Cells[0, i] := IntToStr(i);
        strGridCall.Cells[1, i] := FieldByName('strTrainNo').AsString;
        strGridCall.Cells[2, i] := FieldByName('strRoomNumber').AsString;
        strGridCall.Cells[3, i] := FormatDateTime('yy-MM-dd HH:nn',
          FieldByName('dtSigninTime').asDateTime);
        strGridCall.Cells[4, i] := FormatDateTime('yy-MM-dd HH:nn',
          FieldByName('dtCallTime').asDateTime);
        strGridCall.Cells[5, i] := FormatDateTime('yy-MM-dd HH:nn',
          FieldByName('dtOutDutyTime').asDateTime);
        strGridCall.Cells[6, i] := FieldByName('strTrainmanTypeName').AsString;
        strGridCall.Cells[7, i] := FieldByName('strMainDriverName').AsString +
          '[' + FieldByName('strMainDriverNumber').AsString + ']';
        strGridCall.Cells[8, i] :=
          FieldByName('strMainDriverStateName').AsString;
        strGridCall.Cells[9, i] := FieldByName('strSubDriverName').AsString + '['
          + FieldByName('strSubDriverNumber').AsString + ']';
        strGridCall.Cells[10, i] :=
          FieldByName('strSubDriverStateName').AsString;
        strGridCall.Cells[11, i] :=
          CalledToStr(FieldByName('bCalled').AsBoolean);
         strGridCall.Cells[12, i] :=
          FieldByName('strStateName').AsString;  
        strGridCall.Cells[99, i] := FieldByName('strGUID').AsString;
        InsertCall(ado, 1);
        if  (FieldByName('nCall').AsInteger < 1) then
        begin
          Inc(waitCount);
        end;
        if FieldByName('nCall').AsInteger >=1 then
        begin
           Inc(callCount);
        end;
        lblCallCount.Caption :=
          Format('当前共有%d条强休计划，其中%d条未叫班,%d条已叫班。',
          [totalCount, waitCount, callCount]);
        {$ENDREGION '赋值'}
        next;
      end;
      DeleteCall(ado,1);
      RefreshAllBGColor(1);
    end;
  finally
    if Assigned(ado) then
      ado.Free;
  end;
end;

procedure TfrmMain_RoomSign.InitData;
begin
  //初始化计划列表信息
   //代称
   InitRoomPlan();
  //初始化叫班列表信息
   InitCalls;
end;


procedure TfrmMain_RoomSign.InitRoomPlan;
var
  ado: TADOQuery;
  i,j,recCount: Integer;
  RoomWaitingGUID,strTemp: string;
  TrainmanArray: TRsTrainmanArray;
begin
  ado := nil;
  try
    //创建需要创建的计划
    TWaitPlanOpt.CreatePlans(DMCallRoom.LocalArea);
    //获取待乘计划
    TWaitPlanOpt.GetPlansByStateEx(m_AppStartTime,ado);
    RoomPlanGrid.ClearRows(1,10000);
    i := 0;
    with ado do
    begin
      //计划需要的计划的数量
      First;
      recCount := 0;
      while not eof do
      begin
        Inc(recCount);
        next;
      end;

      RoomPlanGrid.RowCount := recCount+ 2;
      RoomPlanGrid.Cells[0, 0] := '序号';
      RoomPlanGrid.Cells[1, 0] := '待班车次';
      RoomPlanGrid.Cells[2, 0] := '房间号';
      RoomPlanGrid.Cells[3, 0] := '正司机';
      RoomPlanGrid.Cells[4, 0] := '副司机';
      RoomPlanGrid.Cells[5, 0] := '到达时间';
      RoomPlanGrid.Cells[6, 0] := '叫班时间';
      RoomPlanGrid.Cells[7, 0] := '出勤时间';
      RoomPlanGrid.Cells[8, 0] := '状态';
      First;
      while not eof do
      begin
        RoomWaitingGUID := FieldByName('strGUID').AsString;
        Inc(i);
        RoomPlanGrid.RowHeights[i] := 30;
        RoomPlanGrid.Cells[0, i] := IntToStr(i);
        RoomPlanGrid.Cells[1, i] := FieldByName('strTrainNo').AsString;
        RoomPlanGrid.Cells[2, i] := Trim(FieldByName('nRoomID').AsString);


        TrainmanArray := TWaitPlanOpt.GetRoomWaitingTrainman(RoomWaitingGUID);
        for j := 0 to Length(TrainmanArray) - 1 do
        begin
          if j > 1 then Break;
          if trainmanarray[j].strTrainmanNumber = '' then Break ;
          strTemp := trainmanarray[j].strTrainmanName + '['
            + trainmanarray[j].strTrainmanNumber + ']';
          RoomPlanGrid.Cells[j + 3,i] := strTemp;
        end;


//        RoomPlanGrid.Cells[3, i] := FieldByName('strTrainmanNo').AsString;
//        RoomPlanGrid.Cells[4, i] := FieldByName('strTrainmanName').AsString;
        RoomPlanGrid.Cells[5, i] := '';
        if not (FieldByName('dtStartTime').IsNull) then
        begin
          RoomPlanGrid.Cells[5, i] := FormatdateTime('yyyy-MM-dd HH:nn', FieldByName('dtStartTime').asDateTime);
        end;

        RoomPlanGrid.Cells[6, i] := '';
        if not ((FieldByName('dtCallTime').IsNull)  or (FieldByName('dtCallTime').asdatetime = 0) ) then
        begin
          RoomPlanGrid.Cells[6, i] := FormatdateTime('yyyy-MM-dd HH:nn', FieldByName('dtCallTime').asDateTime);
        end;

        RoomPlanGrid.Cells[7, i] := '';
        if not ((FieldByName('dtOutDutyTime').IsNull)  or (FieldByName('dtOutDutyTime').asdatetime = 0) ) then
        begin
          RoomPlanGrid.Cells[7, i] := FormatdateTime('yyyy-MM-dd HH:nn', FieldByName('dtOutDutyTime').asDateTime);
        end;
        RoomPlanGrid.Cells[99, i] := RoomWaitingGUID;
        InsertCall(ado, 2);
        next;
      end;
      DeleteCall(ado,2);
      RefreshAllBGColor(2);
    end;
  finally
    if ado <> nil then
      ado.Free;
  end;
end;

procedure TfrmMain_RoomSign.InOutRoom(trainman: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag);
var
  ADOQuery :TADOQuery;
begin
  if not TDBPlan.ExistTrainmanPlan(TrainMan.strTrainmanGUID) then
  begin
    BoxErr('没有找到该人员的计划,请检查');
    Exit;
  end;
  
  TDBPlan.GetTrainmanPlan(TrainMan.strTrainmanGUID,ADOQuery);
  if ADOQuery.FieldByName('strMainDriverGUID').AsString = trainman.strTrainmanGUID then
  begin

    Exit ;
  end;
  if ADOQuery.FieldByName('strSubDriverGUID').AsString = trainman.strTrainmanGUID then
  begin

  end;
end;

function TfrmMain_RoomSign.InSecondCallTime(callTime,
  nowTime: TDateTime): boolean;
var
  strBoolean : string;
begin
  Result := false;
  try
    if nowTime < callTime then exit;
    if (MinutesBetween(IncMinute(callTime, DMCallRoom.RecallSpace), nowTime) < DMCallRoom.OutTimeDelay)
      and ((nowTime > IncMinute(callTime, DMCallRoom.RecallSpace))) then
      Result := true;
  finally
    strBoolean := '';
    if not Result then
      strBoolean := '不';
    OutputDebugString(PChar(Format('%s在催叫时间范围内',[strBoolean])));
  end;
end;

procedure TfrmMain_RoomSign.InsertCall(ado: TADOQuery; nType: Integer);
var
  callData, newCall: TCallData;
  callGUID: string;
  bInserted: Boolean;
  i: Integer;
begin
  callGUID := ado.FieldByName('strGUID').AsString;
  {$REGION '判断要插入的计划是否已经插入,如果有择更新呼叫次数，房间号，叫班时间'}
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    if callGUID = callData.strGUID then
    begin
      callData.dtDutyTime := ado.FieldByName('dtOutDutyTime').AsDateTime;
      callData.dtCallTime := ado.FieldByName('dtCallTime').AsDateTime;
      if nType = 1 then
      begin
        //callData.nCallState := ado.FieldByName('nCall').AsInteger;
        callData.strRoomNumber := ado.FieldByName('strRoomNumber').AsString;
        callData.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end
      else
      begin
        //callData.nCallState := ado.FieldByName('nCallCount').AsInteger;
        callData.strRoomNumber := Trim(ado.FieldByName('nRoomID').AsString);
        callData.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end;
      callData.nDeviceID := GetDeveiceID(callData.strRoomNumber);
      callData.strTrainNo := ado.FieldByName('strTrainNo').AsString;
      exit;
    end;
  end;
  {$ENDREGION '判断要插入的计划是否已经插入'}
  {$region '如果需要插入数据'}
  bInserted := false;
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    {$REGION '时间最小插入最前'}
    if TimeOf(callData.dtCallTime) > TimeOf(ado.FieldByName('dtCallTime').AsDateTime) then
    begin
      newCall := TCallData.Create;
      newCall.strGUID := ado.FieldByName('strGUID').AsString;
      newCall.dtDutyTime := ado.FieldByName('dtOutDutyTime').AsDateTime;
      newCall.dtCallTime := ado.FieldByName('dtCallTime').AsDateTime;
      newCall.nType := nType;
      if nType = 1 then
      begin
        newCall.nCallState := ado.FieldByName('nCall').AsInteger;
        newCall.strRoomNumber := ado.FieldByName('strRoomNumber').AsString;
        newCall.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end
      else
      begin
        newCall.nCallState := ado.FieldByName('nCallCount').AsInteger;
        newCall.strRoomNumber := ado.FieldByName('nRoomID').AsString;
        newCall.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end;
      newCall.nDeviceID := GetDeveiceID(newCall.strRoomNumber);
      newCall.strTrainNo := ado.FieldByName('strTrainNo').AsString;
      m_CallList.Add(newCall);
      bInserted := true;
      break;
    end;
    {$ENDREGION '时间最小插入最前'}
  end;
  if not bInserted then
  begin
    {$REGION '时间最大插入最后'}
    newCall := TCallData.Create;
    newCall.strGUID := ado.FieldByName('strGUID').AsString;
    newCall.dtDutyTime := ado.FieldByName('dtOutDutyTime').AsDateTime;
    newCall.dtCallTime := ado.FieldByName('dtCallTime').AsDateTime;
    newCall.nType := nType;
     if nType = 1 then
      begin
        newCall.nCallState := ado.FieldByName('nCall').AsInteger;
        newCall.strRoomNumber := ado.FieldByName('strRoomNumber').AsString;
        newCall.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end
      else
      begin
        newCall.nCallState := ado.FieldByName('nCallCount').AsInteger;
        newCall.strRoomNumber := ado.FieldByName('nRoomID').AsString;
        newCall.nCallSucceed := ado.FieldByName('bCallSucceed').AsInteger
      end;
    newCall.nDeviceID := GetDeveiceID(newCall.strRoomNumber);
    newCall.strTrainNo := ado.FieldByName('strTrainNo').AsString;
    m_CallList.Add(newCall);
    {$ENDREGION '时间最大插入最后'}
  end;
  {$endregion '如果需要插入数据'}
end;

procedure TfrmMain_RoomSign.KaiShiJiaoBan(JiaoBanCommand: string);
var
  i,j : Integer;
  strCommand : string;
  strRoomNumber : string;
  strGUID : string;
  Calldata : TCallData;
begin
  j := 1;
  strCommand := '';
  strRoomNumber := '';
  strGUID := '';
  try
    if (not DMCallRoom.bInstallAddress) and (JiaoBanCommand[1] = '#') and
      (JiaoBanCommand[Length(JiaoBanCommand)] = '#') then
    begin
      for I := 1 to Length(JiaoBanCommand) do
      begin
        if JiaoBanCommand[i] = '#' then Continue;
        if JiaoBanCommand[i] = ':' then
        begin
          j := j + 1;
          Continue;
        end;
        if j = 1 then strCommand := strCommand + JiaoBanCommand[i]
        else if j = 2 then strRoomNumber := strRoomNumber + JiaoBanCommand[i]
        else if j = 3 then strGUID := strGUID + JiaoBanCommand[i];
      end;
      if strCommand = '0' then
      begin
         m_strRecGUID := '';
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Calldata.nCallSucceed := 0;
        end;
        InitRoomPlan();
        ShowMessage(strRoomNumber + ' 房间叫班失败！');
      end
      else if strCommand = '1' then
      begin
        m_strRecGUID := strGUID;
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Calldata.nCallState := 1;
        end;
        ShowMessage('开始呼叫 ' + strRoomNumber + '房间！');
      end
      else if strCommand = '2' then
      begin
        m_strRecGUID := '';
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Calldata.nCallState := 1;
        end;
        InitRoomPlan();
        //ShowMessage(strRoomNumber + ' 房间叫班完成！')
      end
      else if strCommand = '3' then
      begin
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Inc(Calldata.nCallState);
        end;
        InitRoomPlan();
        //ShowMessage(strRoomNumber + ' 房间催叫完成！');
      end
      else if strCommand = '11' then
      begin
        m_strRecGUID := strGUID;
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Calldata.nCallState := 1;
        end;
      end;
    end;
    strCommand := '';
    if (JiaoBanCommand[1] = '*') and (JiaoBanCommand[Length(JiaoBanCommand)] = '#') then
    begin
      for I := 1 to Length(JiaoBanCommand) do
      begin
        if (JiaoBanCommand[i] = '#') or (JiaoBanCommand[i] = '*') then Continue;
        strCommand := strCommand + JiaoBanCommand[i];
      end;
      if strCommand = 'CSKS' then DMCallRoom.UDPControl.SendCommand('*CSJS#');
      if strCommand = 'CSJS' then DMCallRoom.bUDPConnect := True;
    end;

  finally
    //Calldata.Free;
  end;
end;

class procedure TfrmMain_RoomSign.LeaveRoomSign;
begin
  GlobalDM.OnAppVersionChange := nil;
  
  if frmMain_RoomSign <> nil then
    FreeAndNil(frmMain_RoomSign);
end;




procedure TfrmMain_RoomSign.ManualCall;
var
  frmManualCall2: TfrmManualCall2;
begin
  frmManualCall2 := TfrmManualCall2.Create(nil);
  frmManualCall2.ShowModal;
end;

procedure TfrmMain_RoomSign.miAboutClick(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(nil);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain_RoomSign.miDCJLClick(Sender: TObject);
var
  frmDCJS: TfrmDCJS;
begin
  frmDCJS := TfrmDCJS.Create(nil);
  try
    frmDCJS.ShowModal;
  finally
    frmDCJS.Free;
  end;
end;

procedure TfrmMain_RoomSign.miExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain_RoomSign.miQueryCallRecordClick(Sender: TObject);
begin
  frmQueryCallRecord := TfrmQueryCallRecord.Create(nil);
  try
    frmQueryCallRecord.ShowModal;
  finally
    frmQueryCallRecord.Free;
  end;
end;

procedure TfrmMain_RoomSign.miQueryLeaderExamClick(Sender: TObject);
var
  frm : TFrmLeaderInspect;
begin
  frm := TFrmLeaderInspect.Create(nil) ;
  try
    frm.ShowModal ;
  finally
    frm.Free ;
  end;

  {
  Exit ;
  frmQueryLeaderExam := TfrmQueryLeaderExam.Create(nil);
  try
    frmQueryLeaderExam.ShowModal;
  finally
    frmQueryLeaderExam.Free;
  end;
  }
end;

procedure TfrmMain_RoomSign.miQueryRoomStateClick(Sender: TObject);
begin
  ShowFrmRoomState(Self.Handle);
end;

procedure TfrmMain_RoomSign.miRoomClick(Sender: TObject);
begin
  frmRoom := TfrmRoom.Create(nil);
  try
    frmRoom.ShowModal;
  finally
    frmRoom.Free;
  end;
end;

procedure TfrmMain_RoomSign.miUDPConfigClick(Sender: TObject);
begin
  TfrmUDPConfig.init;
end;

procedure TfrmMain_RoomSign.mniCallOnfigClick(Sender: TObject);
begin
  frmCallConfig := TfrmCallConfig.Create(nil);
  try
    frmCallConfig.ShowModal;
  finally
    frmCallConfig.Free;
  end;
end;

procedure TfrmMain_RoomSign.mniFTPConfigClick(Sender: TObject);
begin
  TfrmFTPConfig.init();
end;

function TfrmMain_RoomSign.UpdateWaitPlan(
  PlanGUIDS: TStrings): Boolean;
var
  planRest : RPlan ;
  //人员计划
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray;
  strError,strTrainPlanGUID :string;
  i : Integer ;
begin
  Result := False ;
  //获取需要强休的人员计划
  GlobalDM.LogManage.InsertLog('获取需要强休的人员计划');
  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;
  try
    GlobalDM.LogManage.InsertLog('开始修改强休的人员计划');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;

      //排除过期的计划
      if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
        Continue ;

      strTrainPlanGUID := TrainmanPlan.TrainPlan.strTrainPlanGUID ;
      if not TDBPlan.FindByID(strTrainPlanGUID) then
        Continue ;

      //修改
      with planRest do
      begin
        strGUID := strTrainPlanGUID ;
        strTrainNo := TrainmanPlan.TrainPlan.strTrainNo ;

        dtSigninTime := TrainmanPlan.TrainPlan.dtArriveTime;
        dtCallTime := TrainmanPlan.TrainPlan.dtCallTime ;
        dtOutDutyTime := TrainmanPlan.TrainPlan.dtStartTime ;
        dtStartTime := TrainmanPlan.TrainPlan.dtChuQinTime ;

        strMainDriverGUID := TrainmanPlan.Group.Trainman1.strTrainmanGUID;
        nMainDriverState := 2 ;

        strSubDriverGUID := TrainmanPlan.Group.Trainman2.strTrainmanGUID ;
        nSubDriverState := 2 ;

        strInputGUID := TrainmanPlan.TrainPlan.strCreateUserGUID;
        dtInputTime := TrainmanPlan.TrainPlan.dtCreateTime ;

        nTrainmanTypeID := 2;
        nState := 1 ;
        strAreaGUID := '' ;
      end;
      TDBPlan.EditPlan(planRest);

      Application.ProcessMessages ;
    end;
    Result := True ;
  finally
    ; ;
  end;
end;

procedure TfrmMain_RoomSign.UploadRoomSignInfo(Sender: TObject);
//var
//  nCount,nSuccess:Integer;
//  strHint : string ;
begin

//
//  try
//    GlobalDM.ConnecDB;
//  except on e : exception do
//    begin
//      Box(Format('连接服务器失败:%s...',[e.Message]));
//      Exit;
//    end;
//  end;
//
//  try
//    try
//      TfrmProgressEx.CreateProgress();
//
//      nCount := 0;
//      TfrmProgressEx.SetHint('正在回传入寓信息，请稍后');
//      nSuccess := m_obUpload.UploadSignInInfo(nCount) ;
//      strHint := Format('入寓信息:总共[%d条],成功回传[%d条]!',[nCount,nSuccess]) ;
//      TfrmProgressEx.SetHint('strHint');
//
//      nCount:= 0 ;
//      TfrmProgressEx.SetHint('正在回传离寓信息，请稍后');
//      nSuccess := m_obUpload.UploadSignOutInfo(nCount) ;
//      strHint := Format('离寓信息:总共[%d条],成功回传[%d条]!',[nCount,nSuccess]) ;
//      TfrmProgressEx.SetHint('strHint');
//      {
//      TfrmProgressEx.SetHint('正在上传查岗信息，请稍后');
//      nSuccess := obUpload.UploadLeaderInspectInfo(nCount) ;
//      }
//      TtfPopBox.ShowBox('回传信息完毕!');
//    except
//      on e:Exception do
//      begin
//        BoxErr('回传信息错误,错误信息:' + e.Message );
//      end;
//    end;
//  finally
//    TfrmProgressEx.CloseProgress;
//  end;
end;

procedure TfrmMain_RoomSign.mniModifyPasswordClick(Sender: TObject);
begin
  if GlobalDM.DutyUser = nil then
    Exit;
  TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_RoomSign.mniTrainmanManagerClick(Sender: TObject);
begin
  TfrmTrainmanManageAccess.OpenTrainmanQuery(m_obRoomSignConfig.RoomSignConfigInfo.bIsUseNetwork);
end;

procedure TfrmMain_RoomSign.N10Click(Sender: TObject);
begin
  TFrmImportTrainman.ImportTrainman ;
end;

procedure TfrmMain_RoomSign.N11Click(Sender: TObject);
begin
  FrmRestTrainNo := TFrmRestTrainNo.Create(nil);
  try
    FrmRestTrainNo.ShowModal;
  finally
    FrmRestTrainNo.Free;
  end;
end;

procedure TfrmMain_RoomSign.N4Click(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
end;

procedure TfrmMain_RoomSign.N6Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_RoomSign.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag;
  plan : RPlan;
  needState : integer;
  strError:string ;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,eVerifyFlag,
    '','','','') then
  begin
    exit;
  end;


  //需要的计划类型：1=签到，2=入寓，3=离寓，4=出勤
  needState := 1;
  plan :=  TDBPlan.GetTrainmanPlanState(TrainMan.strTrainmanGUID,needState);
  if plan.strGUID = '' then
  begin
    strError := Format('没有找到:[%s]%s的强休计划!!!',[TrainMan.strTrainmanNumber,TrainMan.strTrainmanName]) ;
    TtfPopBox.ShowBox(strError,3000);
    Exit ;
  end;
  {$region '弹出出入寓登记窗口'}
  if (plan.strMainDriverGUID = trainman.strTrainmanGUID)  then
  begin
    //正司机已签到
    if plan.nMainDriverState = 2 then
    begin
      frmInRoom := TfrmInRoom.Create(nil);
      frmInRoom.PlanGUID := plan.strGUID;
      frmInRoom.SetMainDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmInRoom.Show;
    end;
    //正司机已入寓
    if plan.nMainDriverState = 3 then
    begin

      if GlobalDM.GetNow < IncHour(plan.dtCallTime,-1) then
      begin
        if not AlarmNoTime then exit;              
      end;

      frmOutRoom := TfrmOutRoom.Create(nil);
      frmOutRoom.PlanGUID := plan.strGUID;
      frmOutRoom.SetMainDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmOutRoom.Show;
    end;
  end;

  if (plan.strSubDriverGUID = trainman.strTrainmanGUID)  then
  begin
    //副司机已签到
    if plan.nSubDriverState = 2 then
    begin
      frmInRoom := TfrmInRoom.Create(nil);
      frmInRoom.PlanGUID := plan.strGUID;
      frmInRoom.SetSubDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmInRoom.Show;
    end;
    //副司机已入寓
    if plan.nSubDriverState = 3 then
    begin
      frmOutRoom := TfrmOutRoom.Create(nil);
      frmOutRoom.PlanGUID := plan.strGUID;
      frmOutRoom.SetSubDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmOutRoom.Show;
    end;
  end;
 {$endregion '弹出出入寓登记窗口'};

    m_bCapturing := false;
end;

procedure TfrmMain_RoomSign.OnTFMessage(TFMessages: TTFMessageList);
var
  GUIDS: TStrings ;
  i: Integer;
begin
  GUIDS := TStringList.Create ;
  try
    for I := 0 to TFMessages.Count - 1 do
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;

      if not m_DBTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
        GlobalDM.SiteInfo.strSiteGUID) then
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;

      case TFMessages.Items[i].msg of
        TFM_PLAN_RENYUAN_PUBLISH :
        //接收到发布人员的叫班信息
        begin
          GlobalDM.LogManage.InsertLog('公寓端接收到接收到发布人员的叫班信息');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          InsertWaitPlan(GUIDS);
          InitCalls ;
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
          //修改候班计划
        TFM_PLAN_RENYUAN_UPDATE ,
        TFM_PLAN_RENYUAN_RMTRAINMAN ,
        TFM_PLAN_RENYUAN_RMGROUP:
        begin
          GlobalDM.LogManage.InsertLog('公寓端接收到接收到修改候班计划的叫班信息');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          UpdateWaitPlan(GUIDS);
          InitCalls ;
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
        //删除候班计划
        TFM_PLAN_RENYUAN_DELETE ,
        TFM_PLAN_TRAIN_CANCEL :
        begin
          GlobalDM.LogManage.InsertLog('公寓端接收到接收到删除候班计划的叫班信息');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          DeleteWaitPlan(GUIDS);
          InitCalls ;
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
      else
        begin
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
          Continue;
        end;
      end;
    end;
  finally
    GUIDS.Free ;
  end;

end;

procedure TfrmMain_RoomSign.pngbtbtnManualClick(Sender: TObject);
begin
  ManualCall();
end;

procedure TfrmMain_RoomSign.ReadFingerprintState;
begin

  if GlobalDM.FingerprintInitSuccess then
  begin
    lblFingerState.Font.Color := clBlack;
    lblFingerState.Caption := '指纹仪连接正常';
  end
  else
  begin
    lblFingerState.Font.Color := clRed;
    lblFingerState.Caption := '指纹仪连接失败;双击重新连接！';
  end;
end;




procedure TfrmMain_RoomSign.RefreshAll;
begin
  InitCalls;
  InitRoomPlan;
end;

procedure TfrmMain_RoomSign.RefreshAllBGColor(nTypeID: Integer);
var
  planGUID: string;
  dtNow, callTime: TDateTime;
  i, callState: Integer;
  callData : TCallData;
begin
  PColor1.Color := DMCallRoom.ColorOutTime;
  PColor2.Color := DMCallRoom.ColorUnenter;
  PColor3.Color := DMCallRoom.ColorWaitingCall;
  PColor4.Color := DMCallRoom.ColorCalling;
  PColor5.Color := DMCallRoom.ColorOutDutyAlarm;
  try
    dtNow := GlobalDM.GetNow;
    {$REGION '刷新待乘颜色'}
    if nTypeID = 2 then
    begin
      RoomPlanGrid.BeginUpdate;
      for i := 1 to RoomPlanGrid.RowCount - 2 do
      begin
        planGUID := RoomPlanGrid.Cells[99, i];
        OutputDebugString(PChar('planGUID: '+ planGUID));
         OutputDebugString(PChar('m_strRecGUID: '+ m_strRecGUID));
        if planGUID = '' then continue;
        callData := GetCallData(planGUID);
        if callData = nil then continue;
        if callData.dtCallTime = 0 then
        begin
          RoomPlanGrid.Cells[8, i] := '未确定';
          continue;
        end;
        callTime := StrToDateTime(RoomPlanGrid.Cells[6, i] + ':00');
        RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
        callState := GetCallCount(planGUID);
        {闫，如果叫班列表中有已催叫的计划，则重新写一下数据库，原因可能是由叫班}
        {成功后写数据库时没有成功造成的}
        if (callState = 2) and (DMCallRoom.Comming = False) then
          TWaitPlanOpt.SetRoomWaitingOver(planGUID,2);

        //已过期：叫班时间在程序启动前
        if (IncMinute(callTime,DMCallRoom.OutTimeDelay) < m_AppStartTime) and (callState < 1) then
        begin
          RoomPlanGrid.Cells[8, i] := '已过期';
          RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
        end
        else begin
          callState := GetCallCount(planGUID);

          //未到叫班时间或者在叫班排列中
          if callState = 0 then
          begin
            if StrToDateTime(RoomPlanGrid.Cells[5, i]) < dtNow then
            begin
              RoomPlanGrid.Cells[8, i] := '待叫班';
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorWaitingCall;
            end
            else begin
              RoomPlanGrid.Cells[8, i] := '未到达';
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorUnenter;
            end;
          end
          else begin
            //当前叫班中的
            if m_strRecGUID = planGUID then
            begin
              //当前正在叫班
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorCalling;
              RoomPlanGrid.Cells[8, i] := '叫班中';
            end
            else begin

              //正在叫班或需要叫班
              if (m_strRecGUID <> planGUID) then
              begin
                if callState = 1 then
                begin
                  RoomPlanGrid.Cells[8, i] := '已叫班';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[8, i] := '叫班失败';
                  
                  if IncMinute(callTime,DMCallRoom.OutTimeDelay) > m_AppStartTime then
                  begin
                    RoomPlanGrid.RowColor[i] := DMCallRoom.ColorWaitingCall;
                  end
                  else begin
                    RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
                  end;
                end;

                if callState = 2 then
                begin
                  RoomPlanGrid.Cells[8, i] := '已催叫';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[8, i] := '催叫失败';
                  RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
                end;
              end;
            end;
          end;
        end;
      end;
      RoomPlanGrid.EndUpdate;
      Application.ProcessMessages;
    end;

    {$ENDREGION '刷新颜色'}


    {$region '刷新强休颜色'}
    if nTypeID = 1 then
    begin
      strGridCall.BeginUpdate;
      for i := 1 to strGridCall.RowCount - 2 do
      begin
        planGUID := strGridCall.Cells[99, i];
        if planGUID = '' then continue;

        callData := GetCallData(planGUID);
        if callData = nil then continue;
        
        callTime :=  StrToDateTime(strGridCall.Cells[4, i]);
        callState := GetCallCount(planGUID);

        if strGridCall.Cells[2,i] = '' then
        begin
          strGridCall.Cells[11, i] := '未到达';
          strGridCall.RowColor[i] := DMCallRoom.ColorUnenter;
        end
        else begin

          //已过期：叫班时间在程序启动前
          if (IncMinute(callTime,DMCallRoom.OutTimeDelay) < m_AppStartTime) and (callState = 0) then
          begin
            strGridCall.Cells[11, i] := '已过期';
            strGridCall.RowColor[i] := DMCallRoom.ColorOutTime;
          end
          else begin
            callState := GetCallCount(planGUID);

            //未到叫班时间或者在叫班排列中
            if callState = 0 then
            begin
              strGridCall.Cells[11, i] := '待叫班';
              strGridCall.RowColor[i] := DMCallRoom.ColorWaitingCall;
            end
            else begin
              //当前叫班中的
              if m_strRecGUID = planGUID then
              begin
                //当前正在叫班
                strGridCall.RowColor[i] := DMCallRoom.ColorCalling;
                strGridCall.Cells[11, i] := '叫班中';
              end
              else begin

                //正在叫班或需要叫班
                if (m_strRecGUID <> planGUID) then
                begin
                  if callState = 1 then
                  begin
                    strGridCall.Cells[11, i] := '已叫班';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[11, i] := '叫班失败';
                  
                    if IncMinute(callTime,DMCallRoom.OutTimeDelay) > m_AppStartTime then
                    begin
                      strGridCall.RowColor[i] := DMCallRoom.ColorWaitingCall;
                    end
                    else begin
                      strGridCall.RowColor[i] := DMCallRoom.ColorOutTime;
                    end;
                  end;

                  if callState = 2 then
                  begin
                    strGridCall.Cells[11, i] := '已催叫';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[11, i] := '催叫失败';
                    strGridCall.RowColor[i] := DMCallRoom.ColorOutTime;
                    if (strGridCall.Cells[11,i] <> '已离寓') and (strGridCall.Cells[11,i] <> '已出勤') then
                    begin
                      callData := GetCallData(planGUID);
                      if IncMinute(callData.dtCallTime,30) <= dtNow then
                      begin
                        strGridCall.RowColor[i] :=DMCallRoom.ColorOutDutyAlarm;
                        if not callData.bAlarm then
                        begin
                          callData.bAlarm := true;
                          DMCallRoom.CallControl.SetPlayMode(2);
                          PlaySound(PChar(GlobalDM.AppPath + 'Sounds\乘务员已叫班但还未登记值班员请检查.wav'),0,SND_FILENAME or SND_ASYNC);
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      strGridCall.EndUpdate;
      Application.ProcessMessages;
    end;
    {$endregion '刷新强休颜色'}
 except on e : exception do
    begin
      Tlog.SaveLog(now,e.Message);
    end;
  end;
end;

procedure TfrmMain_RoomSign.RzTrayIcon1QueryEndSession(Sender: TObject;
  var AllowSessionToEnd: Boolean);
begin
  AllowSessionToEnd := True ;
end;

procedure TfrmMain_RoomSign.SaveCallResult(strGUID: string);
begin
  TDBPlan.EditCallState(True, strGUID);
end;

procedure TfrmMain_RoomSign.ShowAlarm(msg: string);
begin
  if m_FrmAlarm.Visible then exit;
  m_FrmAlarm.lblErrorMsg.Caption := msg;
  m_FrmAlarm.Show;
end;

procedure TfrmMain_RoomSign.ShowCallFailure(msg: string);
var
  fm : TfrmCallFailure;
begin
  //(闫)
  if not DMCallRoom.bCallModel then Exit;
  
  fm := TfrmCallFailure.Create(nil);
  fm.lblErrorMsg.Caption := msg;
  fm.Show;
end;





procedure TfrmMain_RoomSign.TestMessage;
var
  plan:TStringList ;
begin
  plan := TStringList.Create;
  try
    plan.Add('76A1A06B-FBC4-4195-858F-9DB618DCB66D') ;
    //plan.Add('0F5AFE7E-EEB1-4E21-821F-712F306DB30F') ;
    //plan.Add('13E1EBAF-6418-4BB2-B7E7-B5118C732CEE');
    InsertWaitPlan(plan);
    InitCalls;
  finally
    plan.Free;
  end;
end;

procedure TfrmMain_RoomSign.timerAutoCallTimer(Sender: TObject);
//自动叫班扫描
var
  i: Integer;
  callData: TCallData;
  dtNow: TDateTime;
begin
  //数据库连接失败退出
  if DMCallRoom.Comming then
  begin
    TLog.SaveLog(now,'自动叫班定时器按检测到COMMINT标志位为1退出!');
    exit;
  end;
  try
    dtNow := GlobalDM.getNOW;
    timerAutoCall.Enabled := false;
    try
      //如果正在叫班则退出
      if TCallFunction.InCallWaitingTime(m_dtLastCallTime,dtNow,DMCallRoom.CallWaiting) then
      begin
        TLog.SaveLog(now,Format('当前正在叫班中，最后一次叫班时间%s，当前时间%s,需等候%d秒'
          ,[FormatDateTime('yyyy-mm-dd hh:mm',m_dtLastCallTime),
            FormatDateTime('yyyy-mm-dd hh:mm',dtNow),
            DMCallRoom.CallWaiting]));
        exit;
      end;
      {$region '先循环所有的数据确定把所有的首叫都执行'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime,m_AppStartTime,DMCallRoom.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //未叫班的
        if TCallFunction.CanCall(callData,dtNow,DMCallRoom.OutTimeDelay) then
        begin
          tlog.SaveLog(Now,'开始叫班!');
          CallRoom(dtNow, callData,false);
          {启动叫班线程后再刷新叫班状态（闫）}
          Inc(callData.nCallState);
          exit;
        end;
      end;
      {$endregion '先循环所有的数据确定把所有的首叫都执行'}

      {$region '然后执行需要催叫的数据'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime,m_AppStartTime,DMCallRoom.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //已叫班，需要追叫的
        if (callData.nCallState = 1) and InSecondCallTime(callData.dtCallTime, dtNow) then
        begin
          CallRoom(dtNow, callData,true);
          {启动叫班线程后再刷新叫班状态（闫）}
          Inc(callData.nCallState);
          exit;
        end;
      end;
      {$endregion '然后执行需要催叫的数据'}
    finally
      timerAutoCall.Enabled := true;
    end;
  except on  e : exception do
    begin
      Tlog.SaveLog(now,e.Message);
    end;
  end;
end;

procedure TfrmMain_RoomSign.timerAutoRefreshTimer(Sender: TObject);
begin
  timerAutoRefresh.Enabled := false;
  try
    try
      RefreshAll;
    except on e : exception do
      begin
        Tlog.SaveLog(now,e.Message);
      end;
    end;
  finally
    timerAutoRefresh.Enabled := true;
  end;
end;

procedure TfrmMain_RoomSign.timerDBAutoConnectTimer(Sender: TObject);
var
   wDeviceNum : Word;
   rlt : word;
begin
  timerDBAutoConnect.Enabled := false;
  try
    try
      {$endregion '检测指纹仪库是否有更新'}

      {$region '发射器复位,12小时后在非叫班时间内复位单片机'}
      if now > IncHour(m_dtLastResetTime,12) then
      begin
        if not TCallFunction.InCallWaitingTime(m_dtLastCallTime,now,DMCallRoom.CallWaiting) then
        begin
          DMCallRoom.CallControl.Reset;
          m_dtLastResetTime := now;
          Sleep(1000);
        end;
      end;
      {$endregion '发射器复位,12小时后在非叫班时间内复位单片机'}

      {$region '串口设备状态检测'}
    //(闫)
    //if (not DMCallRoom.bCallModel) and (not DMCallRoom.bInstallAddress) then Exit;


    if DMCallRoom.Comming then
    begin
      TLog.SaveLog(now,'呼叫中不检测串口');
      exit;
    end;

    {
    if IncMinute(DMCallRoom.HangupTime,1) >= GlobalDM.GetNow then
    begin
      TLog.SaveLog(now,'挂断未到1分钟，不检测串口');
      exit;
    end;
    }
    
    if DMCallRoom.SerialConnected then
    begin
      rlt := DMCallRoom.CallControl.GetCallControlNum(wDeviceNum);
      OutputDebugString(PChar('串口检测:' + inttostr(rlt)));
      if rlt <> 1 then
      begin
        lblSerialState.Font.Color := clRed;
        TLog.SaveLog(now,'串口状态：设备未连接');
        lblSerialState.Caption := '串口状态：设备未连接';
        DMCallRoom.SerialConnected := false;
      end
      else begin
        lblSerialState.Font.Color := clBlack;
        lblSerialState.Caption := '串口状态：打开成功';
      end;
    end
    else
    begin
      if DMCallRoom.CallControl.OpenPort(DMCallRoom.Port) <> 1 then
      begin
        lblSerialState.Font.Color:= clRed;
        TLog.SaveLog(now,'串口状态：设备未连接');
        lblSerialState.Caption := '串口状态：打开失败';
      end else begin
        DMCallRoom.SerialConnected := true;
      end;
    end;
    {$endregion '串口设备状态检测'}
    except on e : exception do
      TLog.SaveLog(NOW,E.Message);
    end;
  finally
    timerDBAutoConnect.Enabled := true;
  end;
end;

procedure TfrmMain_RoomSign.TimerSystemTimeTimer(Sender: TObject);
begin
  //显示当前服务器时间，如果服务器连接不上则显示本地时间
  if GlobalDM.LocalADOConnection.Connected then
  begin
    try
      lblSysTime.Caption :=
          FormatDateTime('yyyy年MM月dd日 hh时nn分ss秒', GlobalDM.GetNow);
      exit;
    except
      //GlobalDM.DBConnected := false;
    end;
  end;
  lblSysTime.Caption :=FormatDateTime('yyyy年MM月dd日 hh时nn分ss秒', now);
end;

procedure TfrmMain_RoomSign.timerTestLineBeginTimer(Sender: TObject);
var
  dtNow : TDateTime;
  bFlag : boolean;
  i,topHandle : integer;
  callData : TCallData;
begin
  //没有开始线路检测则不检测
  if not DMCallRoom.CheckAudioLine then
  begin
    lblTestLine.Font.Color := clBlack;
    lblTestLine.Caption := '未开启音频线路检测功能';
    exit;
  end;
  lblTestLine.Font.Color := clBlack;
  lblTestLine.Caption := '音频线路检测暂停...';
  TTimer(Sender).Enabled := false;
  TTimer(Sender).Interval := 60000;
  bFlag := false;
  try
    topHandle := Application.ActiveFormHandle;
    //当前窗口不在最顶端不检测
    if topHandle <> Integer(Self.Handle) then exit;

    //当前在叫班状态中不检测
    dtNow := GlobalDM.GetNow;
    if DMCallRoom.Comming then exit;

    //当前在叫班过程中或5分钟后有叫班不检测
    for i := 0 to m_CallList.Count  - 1 do
    begin
      callData := TCallData(m_CallList.Items[i]);
      //在叫前5分钟之内不检测
      if (callData.dtCallTime <= IncMinute(dtNow,5)) and (dtNow <= callData.dtCallTime)  then
      begin
        exit;
      end;
      //开始叫班10分钟之内不检测(首叫和催叫之间)
      if (callData.dtCallTime <= IncMinute(dtNow)) and (dtNow <= IncMinute(callData.dtCallTime,12))  then
      begin
        exit;
      end;      
    end;

    lblTestLine.Font.Color := clBlack;
    lblTestLine.Caption := '音频线路检测中...';
    //开始检测    
    bFlag := true;
    DMCallRoom.CallControl.SetRecordMode(2);
    if not FileExists(PChar(ExtractFilePath(Application.ExeName) + '\Sounds\testline.wav')) then
    begin
      lblTestLine.Font.Color := clBlack;
      lblTestLine.Caption := '音频测试文件丢失...';
      exit;
    end;

    PlaySound(PChar(ExtractFilePath(Application.ExeName) + '\Sounds\testline.wav'),0,SND_ASYNC);
    m_TestRecord := TMixerRecord.Create();
    m_TestRecord.Start;
    timerTestLineEnd.Enabled := true;
  finally
    if not bFlag  then
    begin
      TTimer(Sender).Enabled := true;
    end;
  end;
end;

procedure TfrmMain_RoomSign.timerTestLineEndTimer(Sender: TObject);
var
  i,nMidValue,nMaxValue: Integer;
  mixer : TMixerControl;
  lineInEnabled,lineInRecording : boolean;
begin
  TTimer(Sender).Enabled := false;
  try
    m_TestRecord.Stop;
    PlaySound(PChar(GlobalDM.AppPath + '\Sounds\nil'),0,SND_ASYNC);
    nMaxValue := 0;
    for i := 0 to Length(m_TestRecord.SaveBuf) - 1  do
    begin
      if i mod 2 = 1 then
      begin
        nMidValue := m_TestRecord.SaveBuf[i];
        if nMidValue > 127 then
        begin
          nMidValue :=  (not nMidValue) and $FF;
        end;
        if nMaxValue < nMidValue then
        begin
          nMaxValue := nMidValue;
        end;        
      end;
    end;
    
    if nMaxValue >120 then
    begin
      lblTestLine.Font.Color := clBlack;
      lblTestLine.Caption := '音频线路检测：正常';
    end
    else
    begin
      lblTestLine.Font.Color :=clRed;
      lblTestLine.Caption := '音频线路检测：断开';
      mixer := TMixerControl.Create;
      try
        lineInRecording := mixer.IsRecordLineIn(lineInEnabled);
        if not lineInEnabled then
        begin
          lblTestLine.Caption := '音频线路检测失败:没有发现LineIn输入口';
          exit;
        end;
        if not lineInRecording then
        begin
          lblTestLine.Caption := '音频线路检测失败:当前录音设备不是LineIn';
          exit;
        end;
        if mixer.GetRecordLineInVolumn < 40000 then
        begin
          lblTestLine.Caption := '音频线路检测失败:录音音量过低';
          exit;
        end;
        if mixer.GetMasterMute = true then
        begin
          lblTestLine.Caption := '音频线路检测失败:主音量关闭';
          exit;
        end;
        if mixer.GetMasterVolumn < 40000 then
        begin
          lblTestLine.Caption := '音频线路检测失败:主音量过低';
          exit;
        end;
        if mixer.GetWaveOutMute = true then
        begin
          lblTestLine.Caption := '音频线路检测失败:WaveOut静音';
          exit;
        end;
        if mixer.GetWaveOutVolumn < 40000 then
        begin
          lblTestLine.Caption := '音频线路检测失败:WaveOut音量过低';
          exit;
        end;
        lblTestLine.Caption := '音频线路检测失败:线路断开';
      finally
        mixer.Free;
      end;
    end;
  finally
    FreeAndNil(m_TestRecord);
    DMCallRoom.CallControl.SetRecordMode(1);
    timerTestLineBegin.Enabled := true;
  end;
end;

procedure TfrmMain_RoomSign.WMHotkey(var msg: TWMHotkey);
begin
  if msg.HotKey  = 1   then
  begin
    if IsIconic(Application.Handle)   then
    begin
      Application.Restore;
      WindowState := wsMaximized;
      BringToFront;
    end;
  end;
end;

procedure TfrmMain_RoomSign.WMMSGCallEnd(var Message: TMessage);
var
  dtNow : TDateTime;
  recordData : RCallRecord;
  strRoomNumber : string;
  callType : integer;
begin
  TLog.SaveLog(now,'接受到停止呼叫消息');
  try
    dtNow := GlobalDM.GetNow;
    try
      if m_CallData = nil then
      begin
        TLog.SaveLog(dtNow,'叫班数据为空');
        exit;
      end;      
      recordData.strPlanGUID := m_CallData.strGUID;
      recordData.strRoomNumber := m_CallData.strRoomNumber;
      recordData.strTrainNo := m_CallData.strTrainNo;
      recordData.bIsRecall := Message.LParam;
      recordData.strDutyGUID := GlobalDM.DutyUser.strDutyGUID;
      recordData.strAreaGUID := '';
      recordData.dtCreateTime := dtNow;
      recordData.bCallSucceed :=  0;
      if Message.WParam = 0 then
      begin
        recordData.bCallSucceed :=  1;
      end else begin
        ShowCallFailure(Format('%s房间叫班失败，请检查！！！',[m_CallData.strRoomNumber]));
      end;
      TLog.SaveLog(now,'获取录音内容');  
      recordData.CallRecord := m_MixerRecord.GetRecordStream;
      try
        TLog.SaveLog(now,'保存录音记录');
        TCallRecordOpt.AddRecord(GlobalDM.LocalADOConnection,recordData);
        TLog.SaveLog(now,'保存录音记录成功');
      finally
        FreeAndNil(recordData.CallRecord);
      end;
      TLog.SaveLog(now,'刷新叫班显示');

      strRoomNumber := m_CallData.strRoomNumber;
      callType := m_CallData.nType;
      TLog.SaveLog(now,PChar(Format('开始保存%s房间叫班数据',[strRoomNumber])));
      if callType = 1 then
        SaveCallResult(m_strRecGUID)
      else
        TDBPlan.EditRoomWaitingState(m_strRecGUID,m_CallData.nCallState);

      TLog.SaveLog(now,PChar(Format('保存%s房间叫班数据成功',[strRoomNumber])));

      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
      RefreshAllBGColor(callType);
      OutputDebugString(PChar(Format('房间%s叫班完成',[strRoomNumber])));
    finally
      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
    end;
  except on e : exception do
    begin
      Tlog.SaveLog(now,e.Message);
    end;
  end;
end;



procedure TfrmMain_RoomSign.WMMSGRecordBegin(var Message: TMessage);
begin
  TLog.SaveLog(now,'开始录音');
  m_MixerRecord.Start;
  TLog.SaveLog(now,'录音启动成功');
end;

procedure TfrmMain_RoomSign.WMMSGRecordEnd(var Message: TMessage);
begin
  TLog.SaveLog(now,'停止录音');
  m_MixerRecord.Stop;
  TLog.SaveLog(now,'录音停止成功');
end;

procedure TfrmMain_RoomSign.WMMSGTestFTPEnd(var message: TMessage);
begin
  if DMCallRoom.bFTPConnect then lblFTPState.Caption := 'FTP:连接正常'
  else
  begin
    lblFTPState.Caption := 'FTP:连接中断';
    ShowAlarm('FTP服务器连接中断,请联系值班人员！');
  end;
  TLog.SaveLog(Now,lblFTPState.Caption);
end;

procedure TfrmMain_RoomSign.WMMSGTestUDPEnd(var message: TMessage);
begin
  if DMCallRoom.bUDPConnect then lblUDPState.Caption := 'UDP:连接正常'
  else
  begin
    lblUDPState.Caption := 'UDP:连接中断';
    if not DMCallRoom.bInstallAddress then
      ShowAlarm('公寓连接中断，请联系值班人员！');
  end;
  TLog.SaveLog(Now,lblUDPState.Caption);
end;

procedure TfrmMain_RoomSign.WMMSGWaitingForConfirm(var Message: TMessage);
begin
  TLog.SaveLog(now,Format('等待管理员确认通话:%d',[Message.WParam]));
  try
    WaitforConfirm(IntToStr(Message.WParam));
    TLog.SaveLog(now,'等待管理员确认通话结束成功');
  except on  e : exception  do
    begin
      TLog.SaveLog(now,Format('等待管理员确认通话失败%s',[e.Message]));
    end;
  end;
end;

procedure TfrmMain_RoomSign.WMSGCallBegin(var Message: TMessage);
begin
  ;
end;


procedure TfrmMain_RoomSign.WriteDutyTime(RoomPlanID: string;
  dtDutyTime: TDateTime);
begin

end;



end.
