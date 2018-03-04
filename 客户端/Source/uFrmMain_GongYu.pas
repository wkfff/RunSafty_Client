unit uFrmMain_GongYu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, PngCustomButton, RzPanel, StdCtrls, ExtCtrls, Grids, AdvObj,
  BaseGrid, AdvGrid, Buttons, RzStatus, PngSpeedButton, Contnrs, uCallRecord,
  uCallUtils, ADODB, uRoomWait, uDBRoomWait, ufrmPlanNoCallEdit,
  uFrmTrainNoSelect, ufrmFindRoom, uMixerRecord,uTrainPlan,
  uGlobalDM,uTrainMan,ufrmCallConfig,uSaftyEnum;

type
  RCallTempData = record
  public
    strTrainPlanGUID : string;
    strRoomNumber : string;
    dtCallTime : TDateTime;
    nCallCount  : integer;
    nCallSucceed : Integer;
    strTrainNo : string;
  end;
  TCallTempDataArray = array of RCallTempData;
  
  TfrmMain_GongYu = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miExit: TMenuItem;
    N3: TMenuItem;
    miLeaderExam: TMenuItem;
    N10: TMenuItem;
    mniRoomEditPlan: TMenuItem;
    N2: TMenuItem;
    mniCallOnfig: TMenuItem;
    N9: TMenuItem;
    miRoom: TMenuItem;
    N7: TMenuItem;
    miQueryPlanDetail: TMenuItem;
    miQueryLeaderExam: TMenuItem;
    miQueryDrink: TMenuItem;
    miQueryCallRecord: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    Panel3: TPanel;
    lblCallCount: TLabel;
    btnInRoom: TSpeedButton;
    btnLeaderExam: TSpeedButton;
    btnChanngeRoom: TSpeedButton;
    strGridCall: TAdvStringGrid;
    Splitter1: TSplitter;
    grpRoomPlan: TGroupBox;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    PColor1: TPanel;
    pColor2: TPanel;
    pColor3: TPanel;
    pColor4: TPanel;
    pColor5: TPanel;
    GroupBox2: TGroupBox;
    RzPanel1: TRzPanel;
    RoomPlanGrid: TAdvStringGrid;
    RzPanel2: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    statusSysTime: TRzGlyphStatus;
    statusDutyUser: TRzGlyphStatus;
    statusSerialState: TRzGlyphStatus;
    statusFinger: TRzGlyphStatus;
    statusArea: TRzGlyphStatus;
    btnOutRoom: TPngSpeedButton;
    btnCall: TPngSpeedButton;
    btnCallNow2: TPngSpeedButton;
    btnCallNow: TPngSpeedButton;
    btnAddTemp: TPngSpeedButton;
    btnEditTemp: TPngSpeedButton;
    btnDeleteTemp: TPngSpeedButton;
    TimerSystemTime: TTimer;
    timerAutoRefresh: TTimer;
    timerAutoCall: TTimer;
    timerDBAutoConnect: TTimer;
    mmChangeClientPos: TMenuItem;
    mmJiDiao: TMenuItem;
    mmPaiBanShi: TMenuItem;
    mmChuQin: TMenuItem;
    mmTuiQin: TMenuItem;
    Panel2: TPanel;
    btnExchangeModule: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure TimerSystemTimeTimer(Sender: TObject);
    procedure timerDBAutoConnectTimer(Sender: TObject);
    procedure timerAutoCallTimer(Sender: TObject);
    procedure timerAutoRefreshTimer(Sender: TObject);
    procedure btnCallNowClick(Sender: TObject);
    procedure btnAddTempClick(Sender: TObject);
    procedure btnEditTempClick(Sender: TObject);
    procedure btnDeleteTempClick(Sender: TObject);
    procedure btnLeaderExamClick(Sender: TObject);
    procedure miLeaderExamClick(Sender: TObject);
    procedure btnCallNow2Click(Sender: TObject);
    procedure btnChanngeRoomClick(Sender: TObject);
    procedure btnOutRoomClick(Sender: TObject);
    procedure btnInRoomClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure mniRoomEditPlanClick(Sender: TObject);
    procedure miRoomClick(Sender: TObject);
    procedure mniCallOnfigClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure mmJiDiaoClick(Sender: TObject);
    procedure mmPaiBanShiClick(Sender: TObject);
    procedure mmChuQinClick(Sender: TObject);
    procedure mmTuiQinClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnExchangeModuleClick(Sender: TObject);
  private
    { Private declarations }
    m_CallList: TObjectList;
    m_CallThread: TCallThread;
    m_CallData: TCallData;
    m_strRecGUID: string; //当前叫班GUID
    m_MixerRecord: TMixerRecord;
    procedure CallRoom(dtNow: TDateTime; callData: TCallData; secondCall: boolean);
    //刷新所有的数据
    procedure RefreshAll;
    //判断追叫时间,判断当前时间在规定叫班时间5分钟虎1个小时之内
    function InSecondCallTime(callTime, nowTime: TDateTime): boolean;
    //刷新所有背景色
    procedure RefreshAllBGColor(nTypeID: Integer);
    //获取待班车次的呼叫此次
    function GetCallCount(strGUID: string): Integer;
    //获取待乘车次的数据
    function GetCallData(strGUID: string): TCallData;

    procedure InitRoomPlan();
    //初始化叫班列表信息
    procedure InitCalls;
    //添加叫班数据
    procedure InsertCall(TempData: RCallTempData; nType: Integer);
    //删除已取消的叫班数据
    procedure DeleteCall(TempDataArray: TCallTempDataArray; nType: Integer);

    //管理员登录状态变化消息
    procedure WMSGRepartChanged(var Message: TMessage); message WM_MSGRepartChanged;
    //开始录音
    procedure WMMSGRecordBegin(var Message: TMessage); message WM_MSGRecordBegin;
    //结束录音
    procedure WMMSGRecordEnd(var Message: TMessage); message WM_MSGRecordEnd;
    //开始叫班
    procedure WMSGCallBegin(var Message: TMessage); message WM_MSGCallBegin;
    //叫班结束
    procedure WMMSGCallEnd(var Message: TMessage); message WM_MSGCallEnd;

    procedure WMMSGWaitingForConfirm(var Message: TMessage); message WM_MSGWaitingForConfirm;


    {功能:按下指纹}
    procedure OnFingerTouching(Sender: TObject);
  public
    { Public declarations }
    m_dtLastCallTime: TDateTime; //上一次叫班时间
    m_dtLastResetTime: TDateTime;
    m_AppStartTime: TDateTime;
    {功能:读取指纹状态}
    procedure ReadFingerprintState;

    class procedure EnterGongYu;
    class procedure LeaveGongYu;
  end;

var
  frmMain_GongYu: TfrmMain_GongYu;

implementation
uses
  uLogs, DateUtils, uArea, uDBArea, uRoom, uDBRoom, uDBTrainPlan, MMSystem,
  uFrmPlanNoCall, uFrmLeaderExam, uFrmCallConfirm, uFrmCallFailure, uDBCallRecord,
  ufrmTrainmanIdentity,uFrmInRoom2,ufrmReadFingerprintTemplates,uFrmOutRoom2,
  uFrmManualCall2,uFrmWaitPlanEdit,uFrmRoom, uRunSaftyDefine,uFrmExchangeModule,
  uSite;
{$R *.dfm}

function CalledToStr(bValue: Boolean): string;
begin
  if bValue then
    Result := '已叫班'
  else
    Result := '未叫班';
end;

function GetDeveiceID(strRoom: string): Integer;
//功能：根据房间号获得设备ID号
var
  room: RRsRoom;
begin
  room := TRsDBRoom.GetRoom(GlobalDM.ADOConnection, GlobalDM.SiteInfo.strAreaGUID, strRoom);
  Result := room.nDeveiveID;
end;

procedure TfrmMain_GongYu.btnAddTempClick(Sender: TObject);
var
  frmPlanNoCall: TfrmPlanNoCall;
begin
  frmPlanNoCall := TfrmPlanNoCall.Create(nil);
  try
    frmPlanNoCall.ShowModal;
  finally
    frmPlanNoCall.Free;
  end;
end;

procedure TfrmMain_GongYu.btnCallClick(Sender: TObject);
var
  frmManualCall2: TfrmManualCall2;
begin
  frmManualCall2 := TfrmManualCall2.Create(nil);
  frmManualCall2.ShowModal;
end;

procedure TfrmMain_GongYu.btnCallNow2Click(Sender: TObject);
var
  strGUID: string;
  inOutPlan : RRsInOutPlan;
begin
  if (strGridCall.Row = 0) or (strGridCall.Row = strGridCall.RowCount - 1) then exit;

  strGUID :=  strGridCall.Cells[99, strGridCall.Row];
  if strGUID = '' then exit;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection,strGUID,inOutPlan) then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if inOutPlan.InOutGroup.CallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if GlobalDM.Comming then
  begin
    Application.MessageBox('叫班中，请勿重复叫班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('您确定要现在就对车次【'+inOutPlan.TrainPlan.strTrainno+'】进行叫班吗？')
    ,'提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TRsDBTrainPlan.UpdatePlanRecordTime(GlobalDM.ADOConnection,strGUID) then
  begin
    TLog.SaveLog(now,Format('%s立即叫班',[inOutPlan.TrainPlan.strTrainNo]));
    InitCalls;
    Application.MessageBox('立即叫班失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('叫班成功！，请稍等！', '提示', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_GongYu.btnCallNowClick(Sender: TObject);
var
  strGUID: string;
  roomPlan: RRsWaitPlanRecord;
begin
  if (RoomPlanGrid.Row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;
  strGUID := RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;
  roomPlan := TRsDBWaitPlan.GetPlanRecord(GlobalDM.ADOConnection, strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('叫班中，请勿重复叫班！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('您确定要现在就对车次【' + roomPlan.strTrainno + '】进行叫班吗？')
    , '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TRsDBWaitPlan.UpdatePlanRecordTime(GlobalDM.ADOConnection, strGUID) then
  begin
    TLog.SaveLog(now, Format('%s立即叫班', [roomPlan.strTrainNo]));
    InitRoomPlan;
    Application.MessageBox('立即叫班失败，请联系管理员！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('叫班成功！，请稍等！', '提示', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_GongYu.btnChanngeRoomClick(Sender: TObject);
var
  strGUID: string;
  inOutPlan : RRsInOutPlan;
  roomNumber: string;
begin
  if (strGridCall.Row = 0) or (strGridCall.Row = strGridCall.RowCount - 1) then exit;
  strGUID :=  strGridCall.Cells[99, strGridCall.Row];
  if strGUID = '' then exit;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection,strGUID,inOutPlan) then
  begin
    Application.MessageBox('该计划已经变动，请重试！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if (inOutPlan.InOutGroup.strRoomNumber = '') then
  begin
    Application.MessageBox('还未给此计划分配房间,不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (inOutPlan.InOutGroup.Group.Trainman1.nTrainmanState >= tsOutRoom) or
    (inOutPlan.InOutGroup.Group.Trainman2.nTrainmanState >= tsOutRoom) or
     (inOutPlan.InOutGroup.Group.Trainman3.nTrainmanState >= tsOutRoom) then
  begin
    Application.MessageBox('入住人员已经办理离寓，不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if inOutPlan.InOutGroup.CallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班,不能修改房间！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if FindRoom(roomNumber) then
  begin
    if not TRsDBTrainPlan.EditPlanRoom(GlobalDM.ADOConnection,strGUID,roomNumber) then
    begin
      Application.MessageBox('修改失败，请联系管理员！','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
     Application.MessageBox('修改成功！','提示',MB_OK + MB_ICONINFORMATION);
  end;

end;

procedure TfrmMain_GongYu.btnDeleteTempClick(Sender: TObject);
var
  strGUID: string;
  roomPlan: RRsWaitPlanRecord;
begin
  if (RoomPlanGrid.row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;
  strGUID := RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;
  roomPlan := TRsDBWaitPlan.GetPlanRecord(GlobalDM.ADOConnection, strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班，不能删除！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('叫班中，不能删除计划！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;


  if Application.MessageBox('您确定要删除该计划吗？', '提示', MB_OKCANCEL) = mrCancel then exit;

  if not TRsDBWaitPlan.DeletePlanRecord(GlobalDM.ADOConnection, strGUID) then
  begin
    Application.MessageBox('删除异常，请联系管理员！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  Application.MessageBox('删除成功！', '提示', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain_GongYu.btnEditTempClick(Sender: TObject);
var
  frmPlanNoCallEdit: TfrmPlanNoCallEdit;
  strGUID: string;
  roomPlan: RRsWaitPlanRecord;
begin
  if (RoomPlanGrid.row = 0) or (RoomPlanGrid.Row = RoomPlanGrid.RowCount - 1) then exit;

  strGUID := RoomPlanGrid.Cells[99, RoomPlanGrid.Row];
  if strGUID = '' then exit;
  roomPlan := TRsDBWaitPlan.GetPlanRecord(GlobalDM.ADOConnection, strGUID);
  if roomPlan.strGUID = '' then
  begin
    Application.MessageBox('该计划已经变动，请重试！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('该计划已经叫过班，不能修改！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('叫班中，不能修改计划！', '提示', MB_OK + MB_ICONINFORMATION);
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

procedure TfrmMain_GongYu.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
end;

procedure TfrmMain_GongYu.btnInRoomClick(Sender: TObject);
var
  strPlanGUID: string;
  trainPlan: RRsInOutPlan;
  frmInRoom : TfrmInRoom2;
begin
  strPlanGUID := strGridCall.Cells[99, strGridCall.row];
  if strPlanGUID = '' then
  begin
    Application.MessageBox('请选择要入寓的计划!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  trainPlan.TrainPlan.strTrainPlanGUID := strPlanGUID;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection, strPlanGUID,trainPlan) then
  begin
    Application.MessageBox('计划已经更新，请刷新后重新操作!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
//  if trainPlan.TrainPlan.nPlanState <> Ord(psPublish) then
//  begin
//    Application.MessageBox('该计划目前不能入寓!', '提示', MB_OK + MB_ICONINFORMATION);
//    exit;
//  end;
//  if trainPlan.TrainPlan.Rest.nNeedRest <> 1 then
//  begin
//    Application.MessageBox('该计划不是强休计划!', '提示', MB_OK + MB_ICONINFORMATION);
//    exit;
//  end;
  frmInRoom := TfrmInRoom2.Create(nil);
  try
    frmInRoom.TrainPlan :=  trainPlan;
    if frmInRoom.ShowModal = mrCancel then exit;
    InitCalls;
    
  finally
    frmInRoom.Free;
  end;
end;

procedure TfrmMain_GongYu.btnLeaderExamClick(Sender: TObject);
begin
  miLeaderExamClick(self);
end;

procedure TfrmMain_GongYu.btnOutRoomClick(Sender: TObject);
var
  strPlanGUID: string;
  trainPlan: RRsInOutPlan;
  frmOutRoom : TFrmOutRoom2;
begin
  strPlanGUID := strGridCall.Cells[99, strGridCall.row];
  if strPlanGUID = '' then
  begin
    Application.MessageBox('请选择要离寓的计划!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  trainPlan.TrainPlan.strTrainPlanGUID := strPlanGUID;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection, strPlanGUID,trainPlan) then
  begin
    Application.MessageBox('计划已经更新，请刷新后重新操作!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
//  if trainPlan.TrainPlan.Rest.nNeedRest <> 1 then
//  begin
//    Application.MessageBox('该计划不是强休计划!', '提示', MB_OK + MB_ICONINFORMATION);
//    exit;
//  end;
  
  if not (((trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID <> '') and
     (trainPlan.InOutGroup.Group.Trainman1.nTrainmanState = tsInRoom)) or
     ((trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID  <> '') and
     (trainPlan.InOutGroup.Group.Trainman2.nTrainmanState = tsInRoom)) or
     ((trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID  <> '') and
     (trainPlan.InOutGroup.Group.Trainman3.nTrainmanState = tsInRoom)) )
  then
  begin
    Application.MessageBox('该计划目前不能离寓!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  frmOutRoom := TfrmOutRoom2.Create(nil);
  try
    frmOutRoom.TrainPlan :=  trainPlan;
    if frmOutRoom.ShowModal = mrCancel then exit;
    InitCalls;
    
  finally
    frmOutRoom.Free;
  end;
end;

procedure TfrmMain_GongYu.CallRoom(dtNow: TDateTime; callData: TCallData;
  secondCall: boolean);
begin
  OutputDebugString(PChar(Format('开始呼叫%s房间', [callData.strRoomNumber])));
  m_CallData := callData;
  try
    //如果存在以前的叫班线程，则释放线程重新创建叫班线程
    if Assigned(m_CallThread) then
      FreeAndNil(m_CallThread);
    m_CallThread := TCallThread.Create(true);
    TLog.SaveLog(now, '创建呼叫线程成功');
      //记录当前叫班的数据
    m_strRecGUID := m_CallData.strGUID;
    m_dtLastCallTime := StrToDateTime('9999-01-01 00:00:00');
    //保存叫班数据的状态
    Inc(callData.nCallState);

    //刷新叫班数据显示
    RefreshAllBGColor(callData.nType);
    //开始执行叫班线程
    m_CallThread.CallData := callData;
    m_CallThread.IsRecall := secondCall;
    TLog.SaveLog(now, '启动叫班数据线程');
    m_CallThread.Resume;
    TLog.SaveLog(now, '启动叫班数据线程成功');
  except
    //叫班过程异常则复位叫班数据
    dtNow := GlobalDM.GetNow;
    m_dtLastCallTime := dtNow;
    m_strRecGUID := '';
    RefreshAllBGColor(callData.nType);
    TLog.SaveLog(now, '启动叫班数据线程失败');
  end;
end;

procedure TfrmMain_GongYu.DeleteCall(TempDataArray: TCallTempDataArray; nType: Integer);
var
  i,j: Integer;
  bFind: Boolean;
  callGUID: string;
  callData: TCallData;
begin
  for i := m_CallList.Count - 1 downto 0 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    if callData.nType = nType then
    begin
      bFind := false;
      for j := 0 to Length(TempDataArray) - 1 do
      begin
        callGUID := TempDataArray[j].strTrainPlanGUID;
        if callGUID = callData.strGUID then
        begin
          bFind := true;
          break;
        end;;
      end;
      if not bFind then
      begin
        //已过期的计划的叫班时间在23：30分以后的数据，在当前时间为00：30分以前不删除
        if TimeOf(callData.dtCallTime) > TimeOf(StrToDateTime('2000-01-01 23:30:00')) then
        begin
          if TimeOf(GlobalDM.GetNow) < TimeOf(StrToDateTime('2000-01-01 00:30:00')) then
          begin
            OutputDebugString(PChar(FormatDateTime('HH:nn', TimeOf(callData.dtCallTime))));
            continue;
          end;
        end;
        m_callList.Delete(i);
      end;
    end;
  end;
end;


class procedure TfrmMain_GongYu.EnterGongYu;
begin
  //初始化需要的硬件驱动
  frmMain_GongYu := TfrmMain_GongYu.Create(nil);
  frmMain_GongYu.Show;
end;

procedure TfrmMain_GongYu.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_GongYu.FormCreate(Sender: TObject);
begin
  strGridCall.SelectionRectangleColor := clred;
  RoomPlanGrid.SelectionRectangleColor := clred;
  m_CallList := TObjectList.Create;
  m_dtLastCallTime := 0;
  m_AppStartTime := GlobalDM.GetNow;
  m_MixerRecord := TMixerRecord.Create;
  m_dtLastResetTime := GlobalDM.GetNow;
  TLog.SaveLog(now,'程序启动');
  CallMsgHandle := Handle;
  GlobalDM.OnFingerTouching := OnFingerTouching;  
end;

procedure TfrmMain_GongYu.FormDestroy(Sender: TObject);
begin
  TLog.SaveLog(now,'程序退出');
  GlobalDM.OnFingerTouching := nil;
  CallMsgHandle := 0;
  if assigned(m_CallThread) then
    FreeAndNil(m_CallThread);
  m_MixerRecord.Stop;
  m_MixerRecord.Free;
  m_CallList.Free;

end;

procedure TfrmMain_GongYu.FormShow(Sender: TObject);
begin
  mmChangeClientPos.Visible := GlobalDM.SiteInfo.nSiteJob = 0;
  GlobalDM.InitCallCtrol;
  //初始化指纹仪
  GlobalDM.InitFingerPrintting;

    //查看指纹仪状态
  ReadFingerprintState();
  //读取指纹库内容
  if GlobalDM.FingerprintInitSuccess then
    ReadFingerprintTemplates();
end;

function TfrmMain_GongYu.GetCallCount(strGUID: string): Integer;
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

function TfrmMain_GongYu.GetCallData(strGUID: string): TCallData;
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

procedure TfrmMain_GongYu.InitCalls;
var
  i, totalCount, waitCount, callCount: Integer;
  beginTime, endTime: TDateTime;
  InOutPlanArray: TRsInOutPlanArray;
  TempDataArray : TCallTempDataArray;
begin
  GlobalDM.GetTimeSpan(GlobalDM.GetNow, beginTime, endTime);

  TRsDBTrainPlan.GetInOutPlans(GlobalDM.ADOConnection, beginTime, endTime,
    GlobalDM.SiteInfo.strSiteGUID, InOutPlanArray);
  totalCount := Length(InOutPlanArray);
  waitCount := 0;
  callCount := 0;
  strGridCall.Clear;
  strGridCall.ClearRows(1, 10000);

  strGridCall.RowCount := totalCount + 2;
  {$REGION '初始化列'}
  strGridCall.Cells[0, 0] := '序号';
  strGridCall.Cells[1, 0] := '待班车次';
  strGridCall.Cells[2, 0] := '房间号';
  strGridCall.Cells[3, 0] := '强休时间';
  strGridCall.Cells[4, 0] := '叫班时间';
  strGridCall.Cells[5, 0] := '单双司机';
  strGridCall.Cells[6, 0] := '司机';
  strGridCall.Cells[7, 0] := '司机状态';
  strGridCall.Cells[8, 0] := '副司机';
  strGridCall.Cells[9, 0] := '副司机状态';
  strGridCall.Cells[10, 0] := '学员';
  strGridCall.Cells[11, 0] := '副司机状态';
  strGridCall.Cells[12, 0] := '叫班状态';
  {$ENDREGION '初始化列'}
  SetLength(TempDataArray,length(InOutPlanArray));
  for i := 0 to Length(InOutPlanArray) - 1 do
  begin
    {$REGION '赋值'}
    strGridCall.RowHeights[i + 1] := 30;
    strGridCall.Cells[0, i + 1] := IntToStr(i);
    strGridCall.Cells[1, i + 1] := InOutPlanArray[i].TrainPlan.strTrainNo;
    strGridCall.Cells[2, i + 1] := InOutPlanArray[i].InOutGroup.strRoomNumber;

//    strGridCall.Cells[3, i + 1] := FormatDateTime('yy-MM-dd HH:nn',InOutPlanArray[i].TrainPlan.Rest.dtArriveTime);
//    strGridCall.Cells[4, i + 1] := FormatDateTime('yy-MM-dd HH:nn',InOutPlanArray[i].TrainPlan.Rest.dtCallTime);

    strGridCall.Cells[5, i + 1] := InOutPlanArray[i].TrainPlan.strTrainTypeName;

    strGridCall.Cells[6, i + 1] := InOutPlanArray[i].InOutGroup.Group.Trainman1.strTrainmanName +
      '[' + InOutPlanArray[i].InOutGroup.Group.Trainman1.strTrainmanNumber + ']';
    strGridCall.Cells[7, i + 1] := TRsTrainmanStateNameAry[InOutPlanArray[i].InOutGroup.Group.Trainman1.nTrainmanState];

    strGridCall.Cells[8, i + 1] := InOutPlanArray[i].InOutGroup.Group.Trainman2.strTrainmanName +
      '[' + InOutPlanArray[i].InOutGroup.Group.Trainman2.strTrainmanNumber + ']';
    strGridCall.Cells[9, i + 1] := TRsTrainmanStateNameAry[InOutPlanArray[i].InOutGroup.Group.Trainman2.nTrainmanState];

    strGridCall.Cells[10, i + 1] := InOutPlanArray[i].InOutGroup.Group.Trainman3.strTrainmanName +
      '[' + InOutPlanArray[i].InOutGroup.Group.Trainman3.strTrainmanNumber + ']';
    strGridCall.Cells[11, i + 1] :=TRsTrainmanStateNameAry[InOutPlanArray[i].InOutGroup.Group.Trainman3.nTrainmanState];

    strGridCall.Cells[12, i + 1] := CalledToStr(InOutPlanArray[i].InOutGroup.CallCount > 1);
    strGridCall.Cells[13, i + 1] := InOutPlanArray[i].TrainPlan.strPlanStateName;
    strGridCall.Cells[99, i + 1] := InOutPlanArray[i].TrainPlan.strTrainPlanGUID;


    if (InOutPlanArray[i].InOutGroup.CallCount < 1) then
    begin
      Inc(waitCount);
    end;
    if InOutPlanArray[i].InOutGroup.CallCount >= 1 then
    begin
      Inc(callCount);
    end;
    TempDataArray[i].strTrainPlanGUID := InOutPlanArray[i].TrainPlan.strTrainPlanGUID;
    TempDataArray[i].strRoomNumber := InOutPlanArray[i].InOutGroup.strRoomNumber;
    //TempDataArray[i].dtCallTime :=InOutPlanArray[i].TrainPlan.Rest.dtCallTime;
    TempDataArray[i].nCallCount := InOutPlanArray[i].InOutGroup.CallCount;
    TempDataArray[i].nCallSucceed :=InOutPlanArray[i].nCallSucceed;
    TempDataArray[i].strTrainNo :=  InOutPlanArray[i].TrainPlan.strTrainNo;

    InsertCall(TempDataArray[i], 1);   

    {$ENDREGION '赋值'}
  end;
  lblCallCount.Caption := Format('当前共有%d条强休计划，其中%d条未叫班,%d条已叫班。',
      [totalCount, waitCount, callCount]);

  DeleteCall(TempDataArray, 1);
  RefreshAllBGColor(1);
end;

procedure TfrmMain_GongYu.InitRoomPlan;
var
  ado: TADOQuery;
  i, recCount: Integer;
  tempDataArray : TCallTempDataArray;
begin
  ado := nil;
  try
    //创建需要创建的计划
    TRsDBWaitPlan.CreatePlans(GlobalDM.ADOConnection, GlobalDM.SiteInfo.strAreaGUID);
    //获取待乘计划
    TRsDBWaitPlan.GetPlansByStateEx(GlobalDM.ADOConnection, m_AppStartTime, GlobalDM.SiteInfo.strAreaGUID, ado);
    RoomPlanGrid.Clear;
    RoomPlanGrid.ClearRows(1, 10000);

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

      setLength(tempDataArray,recCount);
      RoomPlanGrid.RowCount := recCount + 2;
      RoomPlanGrid.Cells[0, 0] := '序号';
      RoomPlanGrid.Cells[1, 0] := '待班车次';
      RoomPlanGrid.Cells[2, 0] := '房间号';
      RoomPlanGrid.Cells[3, 0] := '到达时间';
      RoomPlanGrid.Cells[4, 0] := '叫班时间';
      RoomPlanGrid.Cells[5, 0] := '状态';
      First;
      while not eof do
      begin
        Inc(i);
        RoomPlanGrid.RowHeights[i] := 30;
        RoomPlanGrid.Cells[0, i] := IntToStr(i);
        RoomPlanGrid.Cells[1, i] := FieldByName('strTrainNo').AsString;
        RoomPlanGrid.Cells[2, i] := FieldByName('nRoomID').AsString;
        RoomPlanGrid.Cells[3, i] := '';
        if not (FieldByName('dtStartTime').IsNull) then
        begin
          RoomPlanGrid.Cells[3, i] := FormatdateTime('yyyy-MM-dd HH:nn', FieldByName('dtStartTime').asDateTime);
        end;

        RoomPlanGrid.Cells[4, i] := '';
        if not ((FieldByName('dtCallTime').IsNull) or (FieldByName('dtCallTime').asdatetime = 0)) then
        begin
          RoomPlanGrid.Cells[4, i] := FormatdateTime('yyyy-MM-dd HH:nn', FieldByName('dtCallTime').asDateTime);
        end;
        RoomPlanGrid.Cells[99, i] := FieldByName('strGUID').AsString;


        TempDataArray[i-1].strTrainPlanGUID := RoomPlanGrid.Cells[99, i];
        TempDataArray[i-1].strRoomNumber := RoomPlanGrid.Cells[2, i];
        TempDataArray[i-1].dtCallTime := 0;
         if not (FieldByName('dtStartTime').IsNull) then
        begin
          TempDataArray[i-1].dtCallTime :=  FieldByName('dtCallTime').AsDateTime;
        end;
        
        TempDataArray[i-1].nCallCount := FieldByName('CallCount').asInteger;
        TempDataArray[i-1].nCallSucceed := FieldByName('nCallSucceed').asInteger;
        
        TempDataArray[i-1].strTrainNo := FieldByName('strTrainNo').AsString;
        InsertCall(TempDataArray[i-1], 2);
        next;
      end;
      DeleteCall(TempDataArray, 2);
      RefreshAllBGColor(2);
    end;
  finally
    if ado <> nil then
      ado.Free;
  end;
end;

function TfrmMain_GongYu.InSecondCallTime(callTime,
  nowTime: TDateTime): boolean;
var
  strBoolean: string;
begin
  Result := false;
  try
    if nowTime < callTime then exit;
    if (MinutesBetween(IncMinute(callTime, GlobalDM.RecallSpace), nowTime) < GlobalDM.OutTimeDelay)
      and ((nowTime > IncMinute(callTime, GlobalDM.RecallSpace))) then
      Result := true;
  finally
    strBoolean := '';
    if not Result then
      strBoolean := '不';
    OutputDebugString(PChar(Format('%s在催叫时间范围内', [strBoolean])));
  end;
end;

procedure TfrmMain_GongYu.InsertCall(TempData: RCallTempData;  nType: Integer);
var
  callData, newCall: TCallData;
  callGUID: string;
  bInserted: Boolean;
  i: Integer;
begin
  callGUID := TempData.strTrainPlanGUID;
  {$REGION '判断要插入的计划是否已经插入,如果有择更新呼叫次数，房间号，叫班时间'}
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    if callGUID = callData.strGUID then
    begin
      callData.dtCallTime :=TempData.dtCallTime;
      if nType = 1 then
      begin
        callData.strRoomNumber := TempData.strRoomNumber;
        callData.nCallSucceed := TempData.nCallSucceed;
        //callData.nCallState := TempData.nCallCount;
      end
      else
      begin
        callData.strRoomNumber := TempData.strRoomNumber;
        callData.nCallSucceed := TempData.nCallSucceed;
        //callData.nCallState := TempData.nCallCount;
      end;
      callData.nDeviceID := GetDeveiceID(callData.strRoomNumber);
      callData.strTrainNo := TempData.strTrainNo;
      exit;
    end;
  end;
  {$ENDREGION '判断要插入的计划是否已经插入'}
  {$REGION '如果需要插入数据'}
  bInserted := false;
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
  {$REGION '时间最小插入最前'}
    if TimeOf(callData.dtCallTime) > TempData.dtCallTime then
    begin
      newCall := TCallData.Create;
      newCall.strGUID := TempData.strTrainPlanGUID;
      newCall.dtCallTime := TempData.dtCallTime;
      newCall.nType := nType;
      if nType = 1 then
      begin
        callData.nCallState := TempData.nCallCount;
        callData.strRoomNumber := TempData.strRoomNumber;
        callData.nCallSucceed := TempData.nCallSucceed
      end
      else
      begin
        callData.nCallState := TempData.nCallCount;
        callData.strRoomNumber := TempData.strRoomNumber;
        callData.nCallSucceed := TempData.nCallSucceed;
      end;
      newCall.nDeviceID := GetDeveiceID(newCall.strRoomNumber);
      newCall.strTrainNo := TempData.strTrainNo;
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
    newCall.strGUID := TempData.strTrainPlanGUID;
    newCall.dtCallTime := TempData.dtCallTime;
    newCall.nType := nType;
    if nType = 1 then
    begin
      newCall.nCallState := TempData.nCallCount;
      newCall.strRoomNumber := TempData.strRoomNumber;
      newCall.nCallSucceed := TempData.nCallSucceed;
    end
    else
    begin
      newCall.nCallState := TempData.nCallCount;
      newCall.strRoomNumber := TempData.strRoomNumber;
      newCall.nCallSucceed := TempData.nCallSucceed;
    end;
    newCall.nDeviceID := GetDeveiceID(newCall.strRoomNumber);
    newCall.strTrainNo := TempData.strTrainNo;
    m_CallList.Add(newCall);
  {$ENDREGION '时间最大插入最后'}
  end;
  {$ENDREGION '如果需要插入数据'}
end;


class procedure TfrmMain_GongYu.LeaveGongYu;
begin
  //释放已硬件驱动
  if frmMain_GongYu <> nil then
    FreeAndNil(frmMain_GongYu);
end;

procedure TfrmMain_GongYu.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_GongYu.miLeaderExamClick(Sender: TObject);
begin
  frmLeaderExam := TfrmLeaderExam.Create(nil);
  try
    frmLeaderExam.ShowModal;
  finally
    frmLeaderExam.Free;
  end;
end;

procedure TfrmMain_GongYu.miRoomClick(Sender: TObject);
var
  frmRoom : TFrmRoom;
begin
  frmRoom := TfrmRoom.Create(nil);
  try
    frmRoom.ShowModal;
  finally
    frmRoom.Free;
  end;
end;

procedure TfrmMain_GongYu.mmChuQinClick(Sender: TObject);
begin
//  ShowClient(ct_ChuQin);
end;

procedure TfrmMain_GongYu.mmJiDiaoClick(Sender: TObject);
begin
//  ShowClient(ct_JiDiao);
end;

procedure TfrmMain_GongYu.mmPaiBanShiClick(Sender: TObject);
begin
//  ShowClient(ct_PaiBanShi);
end;

procedure TfrmMain_GongYu.mmTuiQinClick(Sender: TObject);
begin
//  ShowClient(ct_TuiQin);
end;

procedure TfrmMain_GongYu.mniCallOnfigClick(Sender: TObject);
begin
  frmCallConfig := TfrmCallConfig.Create(nil);
  try
    frmCallConfig.ShowModal;
  finally
    frmCallConfig.Free;
  end;
end;

procedure TfrmMain_GongYu.mniRoomEditPlanClick(Sender: TObject);
var
  frmWaitPlanEdit: TfrmWaitPlanEdit;
begin
  frmWaitPlanEdit := TfrmWaitPlanEdit.Create(nil);
  try
    frmWaitPlanEdit.ShowModal();
  finally
    FreeAndNil(frmWaitPlanEdit);
  end;
end;

procedure TfrmMain_GongYu.OnFingerTouching(Sender: TObject);
var
  trainPlan: RRsInOutPlan;
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
  frmInRoom: TfrmInRoom2;
  frmOutRoom : TfrmOutRoom2;
  post: TRsPost;
begin
  if not IdentfityTrainman(Sender,TrainMan,Verify,
    trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID,
    trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID,
    trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID,
    trainPlan.InOutGroup.Group.Trainman4.strTrainmanGUID) then
  begin
    Application.MessageBox('没有找到相应的乘务员信息', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not TRsDBTrainPlan.GetTrainmanInOutPlan(GlobalDM.ADOConnection, TrainMan.strTrainmanGUID, trainPlan) then
  begin
    Application.MessageBox('没有找到该人员的行车计划!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if ((Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID) and
    (Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID) and
    (Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID)) then
  begin
    Application.MessageBox('司机与指定的计划人员不符!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (TrainMan.nTrainmanState <> tsPlaning) and (TrainMan.nTrainmanState <> tsInRoom) then
  begin
    Application.MessageBox('该人员不能进行入寓或离寓操作!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
 
  trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID := '';
  trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID := '';
  trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID := '';
  post := ptTrainman;
  if Trainman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID then
  begin
    trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID := TrainMan.strTrainmanGUID;
    post := ptTrainman;
  end;
  if Trainman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID then
  begin
    trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID := TrainMan.strTrainmanGUID;
    post := ptSubTrainman;
  end;
  if Trainman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID then
  begin
    trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID := TrainMan.strTrainmanGUID;
    post := ptLearning;
  end;

  if TrainMan.nTrainmanState = tsPlaning then
  begin
    //打开计划窗口
    frmInRoom := TfrmInRoom2.Create(nil);
    try
      frmInRoom.Trainman := Trainman;
      frmInRoom.Verify := Verify;
      frmInRoom.TrainPlan := TrainPlan;
      frmInRoom.Post := post;
      if frmInRoom.ShowModal = mrOk then
      begin
        InitCalls;
      end;
    finally
      frmInRoom.Free;
    end;
  end;

  if TrainMan.nTrainmanState = tsInRoom then
  begin
    //打开计划窗口
    frmOutRoom := TfrmOutRoom2.Create(nil);
    try
      frmOutRoom.Trainman := Trainman;
      frmOutRoom.Verify := Verify;
      frmOutRoom.TrainPlan := TrainPlan;
      frmOutRoom.Post := post;
      if frmOutRoom.ShowModal = mrOk then
      begin
        InitCalls;
      end;
    finally
      frmOutRoom.Free;
    end;
  end;
end;

procedure TfrmMain_GongYu.ReadFingerprintState;
begin
  if GlobalDM.FingerprintInitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪连接正常';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪连接失败;双击重新连接！';
  end;
end;

procedure TfrmMain_GongYu.RefreshAll;
begin
  InitCalls;
  InitRoomPlan;
end;

procedure TfrmMain_GongYu.RefreshAllBGColor(nTypeID: Integer);
var
  planGUID: string;
  dtNow, callTime: TDateTime;
  i, callState: Integer;
  callData: TCallData;
begin
  PColor1.Color := GlobalDM.ColorOutTime;
  PColor2.Color := GlobalDM.ColorUnenter;
  PColor3.Color := GlobalDM.ColorWaitingCall;
  PColor4.Color := GlobalDM.ColorCalling;
  PColor5.Color := GlobalDM.ColorOutDutyAlarm;
  try
    dtNow := GlobalDM.GetNow;
{$REGION '刷新待乘颜色'}
    if nTypeID = 2 then
    begin
      RoomPlanGrid.BeginUpdate;
      for i := 1 to RoomPlanGrid.RowCount - 2 do
      begin
        planGUID := RoomPlanGrid.Cells[99, i];
        if planGUID = '' then continue;
        callData := GetCallData(planGUID);
        if callData = nil then continue;
        if callData.dtCallTime = 0 then
        begin
          RoomPlanGrid.Cells[5, i] := '未确定';
          continue;
        end;

        callTime := StrToDateTime(RoomPlanGrid.Cells[4, i] + ':00');
        RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
        callState := GetCallCount(planGUID);
        //已过期：叫班时间在程序启动前
        if (IncMinute(callTime, GlobalDM.OutTimeDelay) < m_AppStartTime) and (callState < 1) then
        begin
          RoomPlanGrid.Cells[5, i] := '已过期';
          RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
        end
        else begin
          callState := GetCallCount(planGUID);

          //未到叫班时间或者在叫班排列中
          if callState = 0 then
          begin
            if StrToDateTime(RoomPlanGrid.Cells[3, i]) < dtNow then
            begin
              RoomPlanGrid.Cells[5, i] := '待叫班';
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorWaitingCall;
            end
            else begin
              RoomPlanGrid.Cells[5, i] := '未到达';
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorUnenter;
            end;
          end
          else begin
            //当前叫班中的
            if m_strRecGUID = planGUID then
            begin
              //当前正在叫班
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorCalling;
              RoomPlanGrid.Cells[5, i] := '叫班中';
            end
            else begin

              //正在叫班或需要叫班
              if (m_strRecGUID <> planGUID) then
              begin
                if callState = 1 then
                begin
                  RoomPlanGrid.Cells[5, i] := '已叫班';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[5, i] := '叫班失败';

                  if IncMinute(callTime, GlobalDM.OutTimeDelay) > m_AppStartTime then
                  begin
                    RoomPlanGrid.RowColor[i] := GlobalDM.ColorWaitingCall;
                  end
                  else begin
                    RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
                  end;
                end;

                if callState = 2 then
                begin
                  RoomPlanGrid.Cells[5, i] := '已催叫';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[5, i] := '催叫失败';
                  RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
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


{$REGION '刷新强休颜色'}
    if nTypeID = 1 then
    begin
      strGridCall.BeginUpdate;
      for i := 1 to strGridCall.RowCount - 2 do
      begin
        planGUID := strGridCall.Cells[99, i];
        if planGUID = '' then continue;

        callData := GetCallData(planGUID);
        if callData = nil then continue;

        callTime := StrToDateTime(strGridCall.Cells[4, i]);
        callState := GetCallCount(planGUID);

        if strGridCall.Cells[2, i] = '' then
        begin
          strGridCall.Cells[12, i] := '未到达';
          strGridCall.RowColor[i] := GlobalDM.ColorUnenter;
        end
        else begin

          //已过期：叫班时间在程序启动前
          if (IncMinute(callTime, GlobalDM.OutTimeDelay) < m_AppStartTime) and (callState = 0) then
          begin
            strGridCall.Cells[12, i] := '已过期';
            strGridCall.RowColor[i] := GlobalDM.ColorOutTime;
          end
          else begin
            callState := GetCallCount(planGUID);

            //未到叫班时间或者在叫班排列中
            if callState = 0 then
            begin
              strGridCall.Cells[12, i] := '待叫班';
              strGridCall.RowColor[i] := GlobalDM.ColorWaitingCall;
            end
            else begin
              //当前叫班中的
              if m_strRecGUID = planGUID then
              begin
                //当前正在叫班
                strGridCall.RowColor[i] := GlobalDM.ColorCalling;
                strGridCall.Cells[12, i] := '叫班中';
              end
              else begin

                //正在叫班或需要叫班
                if (m_strRecGUID <> planGUID) then
                begin
                  if callState = 1 then
                  begin
                    strGridCall.Cells[12, i] := '已叫班';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[12, i] := '叫班失败';

                    if IncMinute(callTime, GlobalDM.OutTimeDelay) > m_AppStartTime then
                    begin
                      strGridCall.RowColor[i] := GlobalDM.ColorWaitingCall;
                    end
                    else begin
                      strGridCall.RowColor[i] := GlobalDM.ColorOutTime;
                    end;
                  end;

                  if callState = 2 then
                  begin
                    strGridCall.Cells[12, i] := '已催叫';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[12, i] := '催叫失败';
                    strGridCall.RowColor[i] := GlobalDM.ColorOutTime;
                    if (strGridCall.Cells[13, i] <> '已离寓') and (strGridCall.Cells[13, i] <> '已出勤') then
                    begin
                      callData := GetCallData(planGUID);
                      if IncMinute(callData.dtCallTime, 30) <= dtNow then
                      begin
                        strGridCall.RowColor[i] := GlobalDM.ColorOutDutyAlarm;
                        if not callData.bAlarm then
                        begin
                          callData.bAlarm := true;
                          GlobalDM.CallControl.SetPlayMode(2);
                          PlaySound(PChar(GlobalDM.AppPath + 'Sounds\乘务员已叫班但还未登记值班员请检查.wav'), 0, SND_FILENAME or SND_ASYNC);
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
{$ENDREGION '刷新强休颜色'}
  except on e: exception do
    begin
      Tlog.SaveLog(now, e.Message);
    end;
  end;
end;

procedure TfrmMain_GongYu.timerAutoCallTimer(Sender: TObject);
//自动叫班扫描
var
  i: Integer;
  callData: TCallData;
  dtNow: TDateTime;
begin
  //数据库连接失败退出
  if GlobalDM.Comming then exit;
  try
    dtNow := GlobalDM.GetNow;
    timerAutoCall.Enabled := false;
    try
      //如果正在叫班则退出
      if TCallFunction.InCallWaitingTime(m_dtLastCallTime, dtNow, GlobalDM.CallWaiting) then
      begin
        TLog.SaveLog(now, Format('当前正在叫班中，最后一次叫班时间%s，当前时间%s,需等候%d秒'
          , [FormatDateTime('yyyy-mm-dd hh:mm', m_dtLastCallTime),
          FormatDateTime('yyyy-mm-dd hh:mm', dtNow),
            GlobalDM.CallWaiting]));
        exit;
      end;
      {$REGION '先循环所有的数据确定把所有的首叫都执行'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime, m_AppStartTime, GlobalDM.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //未叫班的
        if TCallFunction.CanCall(callData, dtNow, GlobalDM.OutTimeDelay) then
        begin
          CallRoom(dtNow, callData, false);
          exit;
        end;
      end;
      {$ENDREGION '先循环所有的数据确定把所有的首叫都执行'}

      {$REGION '然后执行需要催叫的数据'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime, m_AppStartTime, GlobalDM.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //已叫班，需要追叫的
        if (callData.nCallState = 1) and InSecondCallTime(callData.dtCallTime, dtNow) then
        begin
          CallRoom(dtNow, callData, true);
          exit;
        end;
      end;
      {$ENDREGION '然后执行需要催叫的数据'}
    finally
      timerAutoCall.Enabled := true;
    end;
  except on e: exception do
    begin
      Tlog.SaveLog(now, e.Message);
    end;
  end;
end;

procedure TfrmMain_GongYu.timerAutoRefreshTimer(Sender: TObject);
var
  area: RRsArea;
begin
  timerAutoRefresh.Enabled := false;
  try
    try
      RefreshAll;
      {$REGION '工作区域'}
      if GlobalDM.SiteInfo.strAreaGUID = '' then
      begin
        statusArea.Font.Color := clRed;
        statusArea.Caption := '未设置工作区域';
      end else begin
        if not TRsDBArea.GetAreaByGUID(GlobalDM.ADOConnection, GlobalDM.SiteInfo.strAreaGUID, area) then
        begin
          statusArea.Font.Color := clRed;
          statusArea.Caption := '未设置工作区域';
        end else begin
          statusArea.Font.Color := clBlack;
          statusArea.Caption := area.strAreaName;
        end;
      end;
    {$ENDREGION '工作区域'}
    except on e: exception do
      begin
        Tlog.SaveLog(now, e.Message);
      end;
    end;
  finally
    timerAutoRefresh.Enabled := true;
  end;
end;

procedure TfrmMain_GongYu.timerDBAutoConnectTimer(Sender: TObject);
var
  wDeviceNum: Word;
  rlt: word;
begin
  timerDBAutoConnect.Enabled := false;
  try
    if GlobalDM.Comming then
    begin
      TLog.SaveLog(now, '呼叫中不检测串口');
      exit;
    end;
    if IncMinute(GlobalDM.HangupTime, 1) >= GlobalDM.GetNow then
    begin
      TLog.SaveLog(now, '挂断未到1分钟，不检测窗口');
      exit;
    end;
    //串口状态
    if GlobalDM.SerialConnected then
    begin
      rlt := GlobalDM.CallControl.GetCallControlNum(wDeviceNum);
      OutputDebugString(PChar('串口检测:' + inttostr(rlt)));
      if rlt <> 1 then
      begin
        statusSerialState.Font.Color := clRed;
        TLog.SaveLog(now, '串口状态：设备未连接');
        statusSerialState.Caption := '串口状态：设备未连接';
        GlobalDM.SerialConnected := false;
      end
      else begin
        statusSerialState.Font.Color := clBlack;
        statusSerialState.Caption := '串口状态：打开成功';
      end;
    end
    else begin
      if GlobalDM.CallControl.OpenPort(GlobalDM.Port) <> 1 then
      begin
        statusSerialState.Font.Color := clRed;
        TLog.SaveLog(now, '串口状态：设备未连接');
        statusSerialState.Caption := '串口状态：打开失败';
      end else begin
        GlobalDM.SerialConnected := true;
      end;
    end;

    //发射器复位,12小时后在非叫班时间内复位单片机
    if now > IncHour(m_dtLastResetTime, 12) then
    begin
      if not TCallFunction.InCallWaitingTime(m_dtLastCallTime, now, GlobalDM.CallWaiting) then
      begin
        GlobalDM.CallControl.Reset;
        m_dtLastResetTime := now;
        Sleep(1000);
      end;
    end;

    if GlobalDM.FingerprintInitSuccess then
    begin
      if GlobalDM.NeedUpdateFingerLib then
      begin
        statusFinger.Font.Color := clRed;
        statusFinger.Caption := '指纹库已有更新，请双击更新指纹库';
      end else begin
        if GlobalDM.FingerLibGUID <> GlobalDM.NewLibGUID then
        begin
          statusFinger.Font.Color := clRed;
          statusFinger.Caption := '指纹库已有更新，请双击更新指纹库';
        end else begin
          statusFinger.Font.Color := clBlack;
          statusFinger.Caption := '指纹库已经最新';
        end;
      end;
    end;
  finally
    timerDBAutoConnect.Enabled := true;
  end;
end;

procedure TfrmMain_GongYu.TimerSystemTimeTimer(Sender: TObject);
begin
  statusSysTime.Caption :=
    FormatDateTime('yyyy年MM月dd日 hh时nn分ss秒', GlobalDM.GetNow);
end;


procedure TfrmMain_GongYu.WMMSGCallEnd(var Message: TMessage);
var
  dtNow: TDateTime;
  recordData: RCallRecord;
  strRoomNumber: string;
  callType: integer;
begin
  TLog.SaveLog(now, '接受到停止呼叫消息');
  try
    dtNow := GlobalDM.GetNow;
    try
      if m_CallData = nil then
      begin
        TLog.SaveLog(dtNow, '叫班数据为空');
        exit;
      end;
      recordData.strPlanGUID := m_CallData.strGUID;
      recordData.strRoomNumber := m_CallData.strRoomNumber;
      recordData.strTrainNo := m_CallData.strTrainNo;
      recordData.bIsRecall := Message.LParam;
      recordData.strDutyGUID := GlobalDM.DutyUser.strDutyGUID;
      recordData.strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
      recordData.dtCreateTime := dtNow;
      recordData.bCallSucceed := 0;
      if Message.WParam = 0 then
      begin
        recordData.bCallSucceed := 1;
      end else begin
        ShowCallFailure(Format('%s房间叫班失败，请检查！！！', [m_CallData.strRoomNumber]));
      end;
      TLog.SaveLog(now, '获取录音内容');
      recordData.CallRecord := m_MixerRecord.GetRecordStream;

      try
       //保存叫班记录
        TLog.SaveLog(now, '保存录音记录');
        try
          TRsCallRecordOpt.AddRecord(GlobalDM.ADOConnection,recordData);
          TLog.SaveLog(now, '保存录音记录成功');
        except on e : exception do
          begin
            TLog.SaveLog(now, '保存录音记录失败:' + e.Message);
          end;
        end;
      finally
         FreeAndNil(recordData.CallRecord);
      end;
      callType := m_CallData.nType;
      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
      RefreshAllBGColor(callType);
      OutputDebugString(PChar(Format('房间%s叫班完成', [strRoomNumber])));
    finally
      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
    end;
  except on e: exception do
    begin
      Tlog.SaveLog(now, e.Message);
    end;
  end;
end;


procedure TfrmMain_GongYu.WMMSGRecordBegin(var Message: TMessage);
begin
  TLog.SaveLog(now, '开始录音');
  m_MixerRecord.Start;
  TLog.SaveLog(now, '录音启动成功');
end;

procedure TfrmMain_GongYu.WMMSGRecordEnd(var Message: TMessage);
begin
  TLog.SaveLog(now, '停止录音');
  m_MixerRecord.Stop;
  TLog.SaveLog(now, '录音停止成功');
end;

procedure TfrmMain_GongYu.WMMSGWaitingForConfirm(var Message: TMessage);
begin
  TLog.SaveLog(now, Format('等待管理员确认通话:%d', [Message.WParam]));
  try
    WaitforConfirm(IntToStr(Message.WParam));
    TLog.SaveLog(now, '等待管理员确认通话结束成功');
  except on e: exception do
    begin
      TLog.SaveLog(now, Format('等待管理员确认通话失败%s', [e.Message]));
    end;
  end;
end;

procedure TfrmMain_GongYu.WMSGCallBegin(var Message: TMessage);
begin

end;

procedure TfrmMain_GongYu.WMSGRepartChanged(var Message: TMessage);
begin
  InitRoomPlan;
  InitCalls;  
end;

end.

