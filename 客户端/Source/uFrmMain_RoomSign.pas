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
    m_strRecGUID: string; //��ǰ�а�GUID
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
    //��ʼ������
    procedure InitRoomPlan();
    //��ʼ���а��б���Ϣ{ǿ��}
    procedure InitCalls;
    //�ж�׷��ʱ��,�жϵ�ǰʱ���ڹ涨�а�ʱ��5���ӻ�1��Сʱ֮��
    function InSecondCallTime(callTime, nowTime: TDateTime): boolean;
    //��ӽа�����
    procedure InsertCall(ado: TADOQuery; nType: Integer);
    //ɾ����ȡ���Ľа�����
    procedure DeleteCall(ado:TADOQuery;nType:Integer);
    //�����Զ��а�����
    procedure SaveCallResult(strGUID: string);
    //ˢ�����е�����
    procedure RefreshAll;
    //ˢ�����б���ɫ
    procedure RefreshAllBGColor(nTypeID : Integer);
    //��ȡ���೵�εĺ��д˴�
    function GetCallCount(strGUID: string): Integer;
    //��ȡ���˳��ε�����
    function GetCallData(strGUID: string) :  TCallData;
    //��ʾ�а�ʧ�ܴ���
    procedure  ShowCallFailure(msg : string);
    procedure ShowAlarm(msg : string);
    procedure CloseAlarm();
    //��ȡָ���ǵ�״̬����
    procedure ReadFingerprintState;
    //��ʼ¼��
    procedure WMMSGRecordBegin(var Message : TMessage); message WM_MSGRecordBegin;
    //����¼��
    procedure WMMSGRecordEnd(var Message : TMessage); message WM_MSGRecordEnd;
    //��ʼ�а�
    procedure WMSGCallBegin(var Message : TMessage); message WM_MSGCallBegin;
    //�а����
    procedure WMMSGCallEnd(var Message : TMessage); message WM_MSGCallEnd;
    procedure WMMSGWaitingForConfirm(var Message : TMessage); message WM_MSGWaitingForConfirm;
    //ȫ���ȼ���Ϣ
    procedure WMHotkey(var msg:TWMHotkey);message WM_HOTKEY;
    //(��)
    //����UDP����
    procedure WMMSGTestUDPEnd(var message : TMessage); message WM_MSGTestUDPEnd;
    //����FTP����
    procedure WMMSGTestFTPEnd(var message : TMessage); message WM_MSGTestFTPEnd;
    {���ܣ��ֹ��а�}
    procedure ManualCall();
    procedure WriteDutyTime(RoomPlanID: string;dtDutyTime: TDateTime);

  public
    { Public declarations }
    m_dtLastCallTime: TDateTime; //��һ�νа�ʱ��
    m_dtLastResetTime : TDateTime;
    //�����пؼ����Բ���
    procedure EnableAll;
    //�����пؼ����ܲ���
    procedure DisableAll;

    //Զ�̽а�ģʽ���ƣ�
    procedure KaiShiJiaoBan(JiaoBanCommand: string);

  private
    //���ݻش�(��Ԣ����Ԣ��Ϣ)
    m_obUpload:TUploadSignInfo;
    //���ù���
    m_obRoomSignConfig : TRoomSignConfigOper;
    //ǰһ�����õ��¼�  ,ָ�����¼�
    m_OldFingerTouch : TNotifyEvent;
    //�г��������ݿ����
    m_DBTrainJiaolu : TRsDBTrainJiaolu;
    //WEB�ƻ��ӿ�
    m_webTrainPlan:TRsLCTrainPlan;
  private

      //������Ϣ�����PLANGUID����ƻ� Ĭ��Ϊǩ��״̬
    function InsertWaitPlan(PlanGUIDS:TStrings):Boolean;
    {����:�޸ĺ��ƻ� Ĭ��Ϊǩ��״̬}
    function UpdateWaitPlan(PlanGUIDS:TStrings):Boolean;
    {����:�޸ĺ��ƻ�}
    function DeleteWaitPlan(PlanGUIDS:TStrings):Boolean;
    {����:�ش���Ϣ}
    procedure UploadRoomSignInfo(Sender: TObject);

    //��Ӳ���ǿ�ݼƻ�
    procedure AddQiangXiuPlan();

  private
    procedure TestMessage();
      //����ϵͳ��Ϣ�¼�
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //����ָ����
    procedure OnFingerTouching(Sender: TObject);
    //���ݿ�������
    procedure DBConnected(Sender : TObject);
    //���ݿ��ѶϿ�
    procedure DBDisconnected(Sender : TObject);
  public
    procedure InitData();
    {����:���빫Ԣ}
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
//���ܣ����ݷ���Ż���豸ID��
var
  room: RRoom;
begin
  room := TRoomOpt.GetRoom(DMCallRoom.LocalArea, strRoom);
  Result := room.nDeveiveID;
end;


function CalledToStr(bValue: Boolean): string;
begin
  if bValue then
    Result := '�ѽа�'
  else
    Result := 'δ�а�';
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
//      Box(Format('���ӷ�����ʧ��:%s...',[e.Message]));
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
//      TfrmProgressEx.SetHint('���ڵ��뷿����Ϣ�����Ժ�');
//      obDownload.DownloadRoomInfo(nCount) ;
//
//      TfrmProgressEx.SetHint('���ڵ�����Ԣ��Ϣ�����Ժ�');
//      obDownload.DownloadSignInInfo(nCount) ;
//
//      TfrmProgressEx.SetHint('���ڵ�����Ԣ��Ϣ�����Ժ�');
//      obDownload.DownloadSignOutInfo(nCount) ;
//
//      TtfPopBox.ShowBox('�������',1000);
//    except
//      on e:Exception do
//      begin
//        BoxErr('�������:' + e.Message );
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
    GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
      //�ų����ڵļƻ�
    with planRest do
    begin
      strGUID :=  '123456' ;
      strTrainNo := 'k105' ;

      dtSigninTime := StrToDateTime('2015-06-03 10:20:07') ;
      dtCallTime := StrToDateTime('2015-06-03 10:20:07')  ;
      dtOutDutyTime := StrToDateTime('2015-06-03 10:20:07') ;
      dtStartTime := StrToDateTime('2015-06-03 10:20:07')  ;

      strMainDriverGUID := '001367E1-17D5-46A3-A800-54FA962C9817';
      nMainDriverState := 2 ;   //��ǩ��

      strSubDriverGUID := '' ;
      nSubDriverState := 2 ;   //��ǩ��

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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 3) and  (plan.nSubDriverState < 3) then
  begin
    Application.MessageBox('��û����Ա��Ԣ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if DMCallRoom.Comming then
  begin
    Application.MessageBox('�а��У������ظ��а࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('��ȷ��Ҫ���ھͶԳ��Ρ�'+plan.strTrainno+'�����на���')
    ,'��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TDBPlan.UpdatePlanRecordTime(strGUID) then
  begin
    TLog.SaveLog(now,Format('%s�����а�',[plan.strTrainNo]));
    InitCalls;
    Application.MessageBox('�����а�ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('�а�ɹ��������Եȣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if DMCallRoom.Comming then
  begin
    Application.MessageBox('�а��У������ظ��а࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('��ȷ��Ҫ���ھͶԳ��Ρ�'+roomPlan.strTrainno+'�����на���')
    ,'��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if (ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','MustDutyTime') = '1')
    and (roomPlan.dtDutyTime <= 0) then
  begin
    if ShowFrmInPutDutyTime(dtDutyTime) = False then Exit;
    WriteDutyTime(strGUID,dtDutyTime);
  end;


  if not TWaitPlanOpt.UpdatePlanRecordTime(strGUID) then
  begin
    TLog.SaveLog(now,Format('%s�����а�',[roomPlan.strTrainNo]));
    InitRoomPlan;
    Application.MessageBox('�����а�ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  //Զ�̽а�ģʽ�ɰ�ˣ��ƣ�
  if (not DMCallRoom.bCallModel) and (not DMCallRoom.bInstallAddress ) then
  begin
    //InitRoomPlan;
    Application.MessageBox('�а������ѷ��������Եȣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  Application.MessageBox('�а�ɹ��������Եȣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState > 3) or (plan.nSubDriverState > 3) then
  begin
    Application.MessageBox('��ס��Ա�Ѿ�������Ԣ�������޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 3) and (plan.nMainDriverState < 3) then
  begin
    Application.MessageBox('��δ���˼ƻ����䷿��,�����޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й���,�����޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  frmFindRoom := TfrmFindRoom.Create(nil);
  try
    if frmFindRoom.ShowModal = mrCancel then exit;
    roomNumber := frmFindRoom.lvRoom.Selected.SubItems[0];
    if not TDBPlan.EditPlanRoom(strGUID,roomNumber) then
    begin
      Application.MessageBox('�޸�ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣬����ɾ����','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if DMCallRoom.Comming then
  begin
    Application.MessageBox('�а��У�����ɾ���ƻ���','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  

  if Application.MessageBox('��ȷ��Ҫɾ���üƻ���','��ʾ',MB_OKCANCEL) = mrCancel then exit;

  if not TWaitPlanOpt.DeletePlanRecord(strGUID) then
  begin
    Application.MessageBox('ɾ���쳣������ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  Application.MessageBox('ɾ���ɹ���','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (plan.nMainDriverState < 2) and  (plan.nSubDriverState < 2) then
  begin
    Application.MessageBox('��û����Աǩ����','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if plan.bCalled > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if DMCallRoom.Comming then
  begin
    Application.MessageBox('�а��У����ܽ��д˲�����','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not TfrmEditCallTime.EditForm(plan.dtCallTime) then exit;

  if not TDBPlan.UpdateCalTime(strGUID,plan.dtCallTime) then
  begin
    TLog.SaveLog(now,Format('%s�޸Ľа�ʱ��:%s',[plan.strTrainNo,FormatDateTime('yyyy-MM-dd HH:nn',plan.dtCallTime)]));
    InitCalls;
    Application.MessageBox('�޸Ľа�ʱ��ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('�޸Ľа�ʱ��ɹ���','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣬�����޸ģ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if DMCallRoom.Comming then
  begin
    Application.MessageBox('�а��У������޸ļƻ���','��ʾ',MB_OK + MB_ICONINFORMATION);
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
        Application.MessageBox('û���ҵ�ָ�����εļƻ���Ϣ.',
          '��ʾ', MB_OK + MB_ICONINFORMATION);
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
        Application.MessageBox('û���ҵ�ָ�����εļƻ���Ϣ.',
          '��ʾ', MB_OK + MB_ICONINFORMATION);
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
  ;//Զ�̽а�ģʽ���ƣ�
  if not DMCallRoom.bCallModel then
  begin
    TLog.SaveLog(Now,'���ǽа�ģʽ');
    if not secondCall then
      DMCallRoom.UDPControl.SendCommand('#1:' + callData.strRoomNumber + ':' + callData.strGUID + '#')
    else
      DMCallRoom.UDPControl.SendCommand('#11:' + callData.strRoomNumber + ':' + callData.strGUID + '#');
  end;

  OutputDebugString(PChar(Format('��ʼ����%s����',[callData.strRoomNumber])));
  m_CallData := callData;
  try
    //���������ǰ�Ľа��̣߳����ͷ��߳����´����а��߳�
    if Assigned(m_CallThread) then
      FreeAndNil(m_CallThread);
    m_CallThread := TCallThread.Create(true);
    TLog.SaveLog(now,'���������̳߳ɹ�');
      //��¼��ǰ�а������
    m_strRecGUID := m_CallData.strGUID;
    m_dtLastCallTime := StrToDateTime('9999-01-01 00:00:00');
    //����а����ݵ�״̬
    //Inc(callData.nCallState);
    //ˢ�½а�������ʾ
    RefreshAllBGColor(callData.nType);
    //��ʼִ�на��߳�

    m_CallThread.CallData := callData;
    m_CallThread.IsRecall := secondCall;
    TLog.SaveLog(now,'�����а������߳�');
    m_CallThread.Resume;
    TLog.SaveLog(now,'�����а������̳߳ɹ�');
  except
    //�а�����쳣��λ�а�����
    dtNow := GlobalDM.GetNow;
    m_dtLastCallTime := dtNow;
    m_strRecGUID := '';
    RefreshAllBGColor(callData.nType);
    TLog.SaveLog(now,'�����а������߳�ʧ��');
  end;
end;

procedure TfrmMain_RoomSign.CloseAlarm;
begin
  m_FrmAlarm.Hide;
end;

function TfrmMain_RoomSign.InsertWaitPlan(
  PlanGUIDS: TStrings): Boolean;
var
  //��Ա�ƻ�
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray ;
  strError:string;
  i : Integer ;
  planRest : RPlan;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  GlobalDM.LogManage.InsertLog('��ȡ��Ҫǿ�ݵ���Ա�ƻ�');

  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;


  try
    GlobalDM.LogManage.InsertLog('������Ҫǿ�ݵ���Ա�ƻ�');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //�ų����ڵļƻ�
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
        nMainDriverState := 2 ;   //��ǩ��

        strSubDriverGUID := TrainmanPlan.Group.Trainman2.strTrainmanGUID ;
        nSubDriverState := 2 ;   //��ǩ��

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
        //�ѹ��ڵļƻ��Ľа�ʱ����23��30���Ժ�����ݣ��ڵ�ǰʱ��Ϊ00��30����ǰ��ɾ��
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
  //��Ա�ƻ�
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray;
  strError,strPlanGUID :string;
  i : Integer ;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;
  try
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;
      //�ų����ڵļƻ�
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
    CanClose := MessageBox(Handle,'��ȷ��Ҫ�˳���?','����',
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
    PageControl1.Pages[i].TabVisible := False;//����
  end ;
  PageControl1.ActivePage  := tabCall ;


  //ע��ȫ��F10��ݼ�
  //RegisterHotkey(Handle,1,0,VK_F10);
  //���ӱ������ݿ�
  GlobalDM.ConnectLocal_SQLDB();
  GlobalDM.m_bIsAccessMode := True ;
  //GlobalDM.blnIsLocalMode := True;
//  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  
  GlobalDM.LogManage.InsertLog('��ʼ��ָ����');
  //��ʼ��ָ����
  GlobalDM.InitFingerPrintting;

    //��ǰ��¼�û�
  //statusDutyUser.Caption := 'ֵ��Ա: ' + '';
  GlobalDM.LogManage.InsertLog('�鿴ָ����״̬');
  //�鿴ָ����״̬
  ReadFingerprintState();

  GlobalDM.LogManage.InsertLog('��ȡָ�ƿ�����');
  //��ȡָ�ƿ�����
  if GlobalDM.FingerprintInitSuccess then
  begin
    GlobalDM.LogManage.InsertLog('��ʼ��ָ���ǳɹ�!');
    ReadFingerprintTemplatesAccess(True);
  end;
  GlobalDM.LogManage.InsertLog('��ȡָ��ģ��');


  //�ҽ�ָ���ǵ���¼�
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;
  GlobalDM.OnDBConnected := DBConnected;
  GlobalDM.OnDBDisconnected := DBDisconnected;

  //���ʹ����������ֹ�޸���Ա��Ϣ
  //��������������Ա�����ǲ��ܻش�����
  //m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  m_obRoomSignConfig.ReadFromFile;


  m_bCapturing := false;
  m_CallList := TObjectList.Create;
  m_dtLastCallTime := 0;

  m_AppStartTime := GlobalDM.GetNow;

  m_MixerRecord := TMixerRecord.Create;
  //����������λ������
  DMCallRoom.CallControl.Reset;
  m_dtLastResetTime := Now;
  m_FrmAlarm := TfrmErrorAlarm.Create(NIL);

  TLog.SaveLog(now,'��������');

  TestFTPUDPThread := TTestFTPUDPThread.Create;


  //���ݻش�
  {$REGION '���ݻش�'}
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


  //��ȡ���ݻش���ʱ��


  {
  with m_obRoomSignConfig.RoomSignConfigInfo do
  begin
    if  True  then
    begin
      m_obUploadThread := TThreadUploadSign.Create(strDutyGUID,strSiteGUID);
      if not m_obUploadThread.InitData then
      begin
        GlobalDM.LogManage.InsertLog('�������ݿ�ʧ��');
        Exit;
      end;
      //����
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

  //(��)
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
      {$REGION '��ʼ����'}
      strGridCall.Cells[0, 0] := '���';
      strGridCall.Cells[1, 0] := '���೵��';
      strGridCall.Cells[2, 0] := '�����';
      strGridCall.Cells[3, 0] := 'ǿ��ʱ��';
      strGridCall.Cells[4, 0] := '�а�ʱ��';
      strGridCall.Cells[5, 0] := '����ʱ��';
      strGridCall.Cells[6, 0] := '��˫˾��';
      strGridCall.Cells[7, 0] := '��˾��';
      strGridCall.Cells[8, 0] := '��˾��״̬';
      strGridCall.Cells[9, 0] := '��˾��';
      strGridCall.Cells[10, 0] := '��˾��״̬';
      strGridCall.Cells[11, 0] := '�а�״̬';
      {$ENDREGION '��ʼ����'}
      while not eof do
      begin
        {$REGION '��ֵ'}
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
          Format('��ǰ����%d��ǿ�ݼƻ�������%d��δ�а�,%d���ѽаࡣ',
          [totalCount, waitCount, callCount]);
        {$ENDREGION '��ֵ'}
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
  //��ʼ���ƻ��б���Ϣ
   //����
   InitRoomPlan();
  //��ʼ���а��б���Ϣ
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
    //������Ҫ�����ļƻ�
    TWaitPlanOpt.CreatePlans(DMCallRoom.LocalArea);
    //��ȡ���˼ƻ�
    TWaitPlanOpt.GetPlansByStateEx(m_AppStartTime,ado);
    RoomPlanGrid.ClearRows(1,10000);
    i := 0;
    with ado do
    begin
      //�ƻ���Ҫ�ļƻ�������
      First;
      recCount := 0;
      while not eof do
      begin
        Inc(recCount);
        next;
      end;

      RoomPlanGrid.RowCount := recCount+ 2;
      RoomPlanGrid.Cells[0, 0] := '���';
      RoomPlanGrid.Cells[1, 0] := '���೵��';
      RoomPlanGrid.Cells[2, 0] := '�����';
      RoomPlanGrid.Cells[3, 0] := '��˾��';
      RoomPlanGrid.Cells[4, 0] := '��˾��';
      RoomPlanGrid.Cells[5, 0] := '����ʱ��';
      RoomPlanGrid.Cells[6, 0] := '�а�ʱ��';
      RoomPlanGrid.Cells[7, 0] := '����ʱ��';
      RoomPlanGrid.Cells[8, 0] := '״̬';
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
    BoxErr('û���ҵ�����Ա�ļƻ�,����');
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
      strBoolean := '��';
    OutputDebugString(PChar(Format('%s�ڴ߽�ʱ�䷶Χ��',[strBoolean])));
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
  {$REGION '�ж�Ҫ����ļƻ��Ƿ��Ѿ�����,���������º��д���������ţ��а�ʱ��'}
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
  {$ENDREGION '�ж�Ҫ����ļƻ��Ƿ��Ѿ�����'}
  {$region '�����Ҫ��������'}
  bInserted := false;
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
    {$REGION 'ʱ����С������ǰ'}
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
    {$ENDREGION 'ʱ����С������ǰ'}
  end;
  if not bInserted then
  begin
    {$REGION 'ʱ�����������'}
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
    {$ENDREGION 'ʱ�����������'}
  end;
  {$endregion '�����Ҫ��������'}
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
        ShowMessage(strRoomNumber + ' ����а�ʧ�ܣ�');
      end
      else if strCommand = '1' then
      begin
        m_strRecGUID := strGUID;
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Calldata.nCallState := 1;
        end;
        ShowMessage('��ʼ���� ' + strRoomNumber + '���䣡');
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
        //ShowMessage(strRoomNumber + ' ����а���ɣ�')
      end
      else if strCommand = '3' then
      begin
        for I := 0 to m_CallList.Count - 1 do
        begin
          Calldata := TCallData(m_CallList[i]);
          if Calldata.strGUID = strGUID then Inc(Calldata.nCallState);
        end;
        InitRoomPlan();
        //ShowMessage(strRoomNumber + ' ����߽���ɣ�');
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
  //��Ա�ƻ�
  TrainmanPlan :RRsTrainmanPlan;
  TrainmanPlanArray:TRsTrainmanPlanArray;
  strError,strTrainPlanGUID :string;
  i : Integer ;
begin
  Result := False ;
  //��ȡ��Ҫǿ�ݵ���Ա�ƻ�
  GlobalDM.LogManage.InsertLog('��ȡ��Ҫǿ�ݵ���Ա�ƻ�');
  if not m_webTrainPlan.GetTrainmanPlanOfNeedRest(PlanGUIDS,TrainmanPlanArray,strError) then
    Exit  ;
  try
    GlobalDM.LogManage.InsertLog('��ʼ�޸�ǿ�ݵ���Ա�ƻ�');
    for I := 0 to Length(TrainmanPlanArray) - 1 do
    begin
      TrainmanPlan := TrainmanPlanArray[i] ;

      //�ų����ڵļƻ�
      if GlobalDM.GetNow >= TrainmanPlan.TrainPlan.dtArriveTime then
        Continue ;

      strTrainPlanGUID := TrainmanPlan.TrainPlan.strTrainPlanGUID ;
      if not TDBPlan.FindByID(strTrainPlanGUID) then
        Continue ;

      //�޸�
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
//      Box(Format('���ӷ�����ʧ��:%s...',[e.Message]));
//      Exit;
//    end;
//  end;
//
//  try
//    try
//      TfrmProgressEx.CreateProgress();
//
//      nCount := 0;
//      TfrmProgressEx.SetHint('���ڻش���Ԣ��Ϣ�����Ժ�');
//      nSuccess := m_obUpload.UploadSignInInfo(nCount) ;
//      strHint := Format('��Ԣ��Ϣ:�ܹ�[%d��],�ɹ��ش�[%d��]!',[nCount,nSuccess]) ;
//      TfrmProgressEx.SetHint('strHint');
//
//      nCount:= 0 ;
//      TfrmProgressEx.SetHint('���ڻش���Ԣ��Ϣ�����Ժ�');
//      nSuccess := m_obUpload.UploadSignOutInfo(nCount) ;
//      strHint := Format('��Ԣ��Ϣ:�ܹ�[%d��],�ɹ��ش�[%d��]!',[nCount,nSuccess]) ;
//      TfrmProgressEx.SetHint('strHint');
//      {
//      TfrmProgressEx.SetHint('�����ϴ������Ϣ�����Ժ�');
//      nSuccess := obUpload.UploadLeaderInspectInfo(nCount) ;
//      }
//      TtfPopBox.ShowBox('�ش���Ϣ���!');
//    except
//      on e:Exception do
//      begin
//        BoxErr('�ش���Ϣ����,������Ϣ:' + e.Message );
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


  //��Ҫ�ļƻ����ͣ�1=ǩ����2=��Ԣ��3=��Ԣ��4=����
  needState := 1;
  plan :=  TDBPlan.GetTrainmanPlanState(TrainMan.strTrainmanGUID,needState);
  if plan.strGUID = '' then
  begin
    strError := Format('û���ҵ�:[%s]%s��ǿ�ݼƻ�!!!',[TrainMan.strTrainmanNumber,TrainMan.strTrainmanName]) ;
    TtfPopBox.ShowBox(strError,3000);
    Exit ;
  end;
  {$region '��������Ԣ�ǼǴ���'}
  if (plan.strMainDriverGUID = trainman.strTrainmanGUID)  then
  begin
    //��˾����ǩ��
    if plan.nMainDriverState = 2 then
    begin
      frmInRoom := TfrmInRoom.Create(nil);
      frmInRoom.PlanGUID := plan.strGUID;
      frmInRoom.SetMainDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmInRoom.Show;
    end;
    //��˾������Ԣ
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
    //��˾����ǩ��
    if plan.nSubDriverState = 2 then
    begin
      frmInRoom := TfrmInRoom.Create(nil);
      frmInRoom.PlanGUID := plan.strGUID;
      frmInRoom.SetSubDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmInRoom.Show;
    end;
    //��˾������Ԣ
    if plan.nSubDriverState = 3 then
    begin
      frmOutRoom := TfrmOutRoom.Create(nil);
      frmOutRoom.PlanGUID := plan.strGUID;
      frmOutRoom.SetSubDriver(trainman.strTrainmanGUID,trainman.strTrainmanName,trainman.strTrainmanNumber,1);
      frmOutRoom.Show;
    end;
  end;
 {$endregion '��������Ԣ�ǼǴ���'};

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
        //���յ�������Ա�Ľа���Ϣ
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ�������Ա�Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          InsertWaitPlan(GUIDS);
          InitCalls ;
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
          //�޸ĺ��ƻ�
        TFM_PLAN_RENYUAN_UPDATE ,
        TFM_PLAN_RENYUAN_RMTRAINMAN ,
        TFM_PLAN_RENYUAN_RMGROUP:
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ��޸ĺ��ƻ��Ľа���Ϣ');
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          UpdateWaitPlan(GUIDS);
          InitCalls ;
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        end;
        //ɾ�����ƻ�
        TFM_PLAN_RENYUAN_DELETE ,
        TFM_PLAN_TRAIN_CANCEL :
        begin
          GlobalDM.LogManage.InsertLog('��Ԣ�˽��յ����յ�ɾ�����ƻ��Ľа���Ϣ');
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
    lblFingerState.Caption := 'ָ������������';
  end
  else
  begin
    lblFingerState.Font.Color := clRed;
    lblFingerState.Caption := 'ָ��������ʧ��;˫���������ӣ�';
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
    {$REGION 'ˢ�´�����ɫ'}
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
          RoomPlanGrid.Cells[8, i] := 'δȷ��';
          continue;
        end;
        callTime := StrToDateTime(RoomPlanGrid.Cells[6, i] + ':00');
        RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
        callState := GetCallCount(planGUID);
        {�ƣ�����а��б������Ѵ߽еļƻ���������дһ�����ݿ⣬ԭ��������ɽа�}
        {�ɹ���д���ݿ�ʱû�гɹ���ɵ�}
        if (callState = 2) and (DMCallRoom.Comming = False) then
          TWaitPlanOpt.SetRoomWaitingOver(planGUID,2);

        //�ѹ��ڣ��а�ʱ���ڳ�������ǰ
        if (IncMinute(callTime,DMCallRoom.OutTimeDelay) < m_AppStartTime) and (callState < 1) then
        begin
          RoomPlanGrid.Cells[8, i] := '�ѹ���';
          RoomPlanGrid.RowColor[i] := DMCallRoom.ColorOutTime;
        end
        else begin
          callState := GetCallCount(planGUID);

          //δ���а�ʱ������ڽа�������
          if callState = 0 then
          begin
            if StrToDateTime(RoomPlanGrid.Cells[5, i]) < dtNow then
            begin
              RoomPlanGrid.Cells[8, i] := '���а�';
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorWaitingCall;
            end
            else begin
              RoomPlanGrid.Cells[8, i] := 'δ����';
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorUnenter;
            end;
          end
          else begin
            //��ǰ�а��е�
            if m_strRecGUID = planGUID then
            begin
              //��ǰ���ڽа�
              RoomPlanGrid.RowColor[i] := DMCallRoom.ColorCalling;
              RoomPlanGrid.Cells[8, i] := '�а���';
            end
            else begin

              //���ڽа����Ҫ�а�
              if (m_strRecGUID <> planGUID) then
              begin
                if callState = 1 then
                begin
                  RoomPlanGrid.Cells[8, i] := '�ѽа�';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[8, i] := '�а�ʧ��';
                  
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
                  RoomPlanGrid.Cells[8, i] := '�Ѵ߽�';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[8, i] := '�߽�ʧ��';
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

    {$ENDREGION 'ˢ����ɫ'}


    {$region 'ˢ��ǿ����ɫ'}
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
          strGridCall.Cells[11, i] := 'δ����';
          strGridCall.RowColor[i] := DMCallRoom.ColorUnenter;
        end
        else begin

          //�ѹ��ڣ��а�ʱ���ڳ�������ǰ
          if (IncMinute(callTime,DMCallRoom.OutTimeDelay) < m_AppStartTime) and (callState = 0) then
          begin
            strGridCall.Cells[11, i] := '�ѹ���';
            strGridCall.RowColor[i] := DMCallRoom.ColorOutTime;
          end
          else begin
            callState := GetCallCount(planGUID);

            //δ���а�ʱ������ڽа�������
            if callState = 0 then
            begin
              strGridCall.Cells[11, i] := '���а�';
              strGridCall.RowColor[i] := DMCallRoom.ColorWaitingCall;
            end
            else begin
              //��ǰ�а��е�
              if m_strRecGUID = planGUID then
              begin
                //��ǰ���ڽа�
                strGridCall.RowColor[i] := DMCallRoom.ColorCalling;
                strGridCall.Cells[11, i] := '�а���';
              end
              else begin

                //���ڽа����Ҫ�а�
                if (m_strRecGUID <> planGUID) then
                begin
                  if callState = 1 then
                  begin
                    strGridCall.Cells[11, i] := '�ѽа�';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[11, i] := '�а�ʧ��';
                  
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
                    strGridCall.Cells[11, i] := '�Ѵ߽�';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[11, i] := '�߽�ʧ��';
                    strGridCall.RowColor[i] := DMCallRoom.ColorOutTime;
                    if (strGridCall.Cells[11,i] <> '����Ԣ') and (strGridCall.Cells[11,i] <> '�ѳ���') then
                    begin
                      callData := GetCallData(planGUID);
                      if IncMinute(callData.dtCallTime,30) <= dtNow then
                      begin
                        strGridCall.RowColor[i] :=DMCallRoom.ColorOutDutyAlarm;
                        if not callData.bAlarm then
                        begin
                          callData.bAlarm := true;
                          DMCallRoom.CallControl.SetPlayMode(2);
                          PlaySound(PChar(GlobalDM.AppPath + 'Sounds\����Ա�ѽа൫��δ�Ǽ�ֵ��Ա����.wav'),0,SND_FILENAME or SND_ASYNC);
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
    {$endregion 'ˢ��ǿ����ɫ'}
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
  //(��)
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
//�Զ��а�ɨ��
var
  i: Integer;
  callData: TCallData;
  dtNow: TDateTime;
begin
  //���ݿ�����ʧ���˳�
  if DMCallRoom.Comming then
  begin
    TLog.SaveLog(now,'�Զ��аඨʱ������⵽COMMINT��־λΪ1�˳�!');
    exit;
  end;
  try
    dtNow := GlobalDM.getNOW;
    timerAutoCall.Enabled := false;
    try
      //������ڽа����˳�
      if TCallFunction.InCallWaitingTime(m_dtLastCallTime,dtNow,DMCallRoom.CallWaiting) then
      begin
        TLog.SaveLog(now,Format('��ǰ���ڽа��У����һ�νа�ʱ��%s����ǰʱ��%s,��Ⱥ�%d��'
          ,[FormatDateTime('yyyy-mm-dd hh:mm',m_dtLastCallTime),
            FormatDateTime('yyyy-mm-dd hh:mm',dtNow),
            DMCallRoom.CallWaiting]));
        exit;
      end;
      {$region '��ѭ�����е�����ȷ�������е��׽ж�ִ��'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime,m_AppStartTime,DMCallRoom.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //δ�а��
        if TCallFunction.CanCall(callData,dtNow,DMCallRoom.OutTimeDelay) then
        begin
          tlog.SaveLog(Now,'��ʼ�а�!');
          CallRoom(dtNow, callData,false);
          {�����а��̺߳���ˢ�½а�״̬���ƣ�}
          Inc(callData.nCallState);
          exit;
        end;
      end;
      {$endregion '��ѭ�����е�����ȷ�������е��׽ж�ִ��'}

      {$region 'Ȼ��ִ����Ҫ�߽е�����'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime,m_AppStartTime,DMCallRoom.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //�ѽа࣬��Ҫ׷�е�
        if (callData.nCallState = 1) and InSecondCallTime(callData.dtCallTime, dtNow) then
        begin
          CallRoom(dtNow, callData,true);
          {�����а��̺߳���ˢ�½а�״̬���ƣ�}
          Inc(callData.nCallState);
          exit;
        end;
      end;
      {$endregion 'Ȼ��ִ����Ҫ�߽е�����'}
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
      {$endregion '���ָ���ǿ��Ƿ��и���'}

      {$region '��������λ,12Сʱ���ڷǽа�ʱ���ڸ�λ��Ƭ��'}
      if now > IncHour(m_dtLastResetTime,12) then
      begin
        if not TCallFunction.InCallWaitingTime(m_dtLastCallTime,now,DMCallRoom.CallWaiting) then
        begin
          DMCallRoom.CallControl.Reset;
          m_dtLastResetTime := now;
          Sleep(1000);
        end;
      end;
      {$endregion '��������λ,12Сʱ���ڷǽа�ʱ���ڸ�λ��Ƭ��'}

      {$region '�����豸״̬���'}
    //(��)
    //if (not DMCallRoom.bCallModel) and (not DMCallRoom.bInstallAddress) then Exit;


    if DMCallRoom.Comming then
    begin
      TLog.SaveLog(now,'�����в���⴮��');
      exit;
    end;

    {
    if IncMinute(DMCallRoom.HangupTime,1) >= GlobalDM.GetNow then
    begin
      TLog.SaveLog(now,'�Ҷ�δ��1���ӣ�����⴮��');
      exit;
    end;
    }
    
    if DMCallRoom.SerialConnected then
    begin
      rlt := DMCallRoom.CallControl.GetCallControlNum(wDeviceNum);
      OutputDebugString(PChar('���ڼ��:' + inttostr(rlt)));
      if rlt <> 1 then
      begin
        lblSerialState.Font.Color := clRed;
        TLog.SaveLog(now,'����״̬���豸δ����');
        lblSerialState.Caption := '����״̬���豸δ����';
        DMCallRoom.SerialConnected := false;
      end
      else begin
        lblSerialState.Font.Color := clBlack;
        lblSerialState.Caption := '����״̬���򿪳ɹ�';
      end;
    end
    else
    begin
      if DMCallRoom.CallControl.OpenPort(DMCallRoom.Port) <> 1 then
      begin
        lblSerialState.Font.Color:= clRed;
        TLog.SaveLog(now,'����״̬���豸δ����');
        lblSerialState.Caption := '����״̬����ʧ��';
      end else begin
        DMCallRoom.SerialConnected := true;
      end;
    end;
    {$endregion '�����豸״̬���'}
    except on e : exception do
      TLog.SaveLog(NOW,E.Message);
    end;
  finally
    timerDBAutoConnect.Enabled := true;
  end;
end;

procedure TfrmMain_RoomSign.TimerSystemTimeTimer(Sender: TObject);
begin
  //��ʾ��ǰ������ʱ�䣬������������Ӳ�������ʾ����ʱ��
  if GlobalDM.LocalADOConnection.Connected then
  begin
    try
      lblSysTime.Caption :=
          FormatDateTime('yyyy��MM��dd�� hhʱnn��ss��', GlobalDM.GetNow);
      exit;
    except
      //GlobalDM.DBConnected := false;
    end;
  end;
  lblSysTime.Caption :=FormatDateTime('yyyy��MM��dd�� hhʱnn��ss��', now);
end;

procedure TfrmMain_RoomSign.timerTestLineBeginTimer(Sender: TObject);
var
  dtNow : TDateTime;
  bFlag : boolean;
  i,topHandle : integer;
  callData : TCallData;
begin
  //û�п�ʼ��·����򲻼��
  if not DMCallRoom.CheckAudioLine then
  begin
    lblTestLine.Font.Color := clBlack;
    lblTestLine.Caption := 'δ������Ƶ��·��⹦��';
    exit;
  end;
  lblTestLine.Font.Color := clBlack;
  lblTestLine.Caption := '��Ƶ��·�����ͣ...';
  TTimer(Sender).Enabled := false;
  TTimer(Sender).Interval := 60000;
  bFlag := false;
  try
    topHandle := Application.ActiveFormHandle;
    //��ǰ���ڲ�����˲����
    if topHandle <> Integer(Self.Handle) then exit;

    //��ǰ�ڽа�״̬�в����
    dtNow := GlobalDM.GetNow;
    if DMCallRoom.Comming then exit;

    //��ǰ�ڽа�����л�5���Ӻ��на಻���
    for i := 0 to m_CallList.Count  - 1 do
    begin
      callData := TCallData(m_CallList.Items[i]);
      //�ڽ�ǰ5����֮�ڲ����
      if (callData.dtCallTime <= IncMinute(dtNow,5)) and (dtNow <= callData.dtCallTime)  then
      begin
        exit;
      end;
      //��ʼ�а�10����֮�ڲ����(�׽кʹ߽�֮��)
      if (callData.dtCallTime <= IncMinute(dtNow)) and (dtNow <= IncMinute(callData.dtCallTime,12))  then
      begin
        exit;
      end;      
    end;

    lblTestLine.Font.Color := clBlack;
    lblTestLine.Caption := '��Ƶ��·�����...';
    //��ʼ���    
    bFlag := true;
    DMCallRoom.CallControl.SetRecordMode(2);
    if not FileExists(PChar(ExtractFilePath(Application.ExeName) + '\Sounds\testline.wav')) then
    begin
      lblTestLine.Font.Color := clBlack;
      lblTestLine.Caption := '��Ƶ�����ļ���ʧ...';
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
      lblTestLine.Caption := '��Ƶ��·��⣺����';
    end
    else
    begin
      lblTestLine.Font.Color :=clRed;
      lblTestLine.Caption := '��Ƶ��·��⣺�Ͽ�';
      mixer := TMixerControl.Create;
      try
        lineInRecording := mixer.IsRecordLineIn(lineInEnabled);
        if not lineInEnabled then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:û�з���LineIn�����';
          exit;
        end;
        if not lineInRecording then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:��ǰ¼���豸����LineIn';
          exit;
        end;
        if mixer.GetRecordLineInVolumn < 40000 then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:¼����������';
          exit;
        end;
        if mixer.GetMasterMute = true then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:�������ر�';
          exit;
        end;
        if mixer.GetMasterVolumn < 40000 then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:����������';
          exit;
        end;
        if mixer.GetWaveOutMute = true then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:WaveOut����';
          exit;
        end;
        if mixer.GetWaveOutVolumn < 40000 then
        begin
          lblTestLine.Caption := '��Ƶ��·���ʧ��:WaveOut��������';
          exit;
        end;
        lblTestLine.Caption := '��Ƶ��·���ʧ��:��·�Ͽ�';
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
  TLog.SaveLog(now,'���ܵ�ֹͣ������Ϣ');
  try
    dtNow := GlobalDM.GetNow;
    try
      if m_CallData = nil then
      begin
        TLog.SaveLog(dtNow,'�а�����Ϊ��');
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
        ShowCallFailure(Format('%s����а�ʧ�ܣ����飡����',[m_CallData.strRoomNumber]));
      end;
      TLog.SaveLog(now,'��ȡ¼������');  
      recordData.CallRecord := m_MixerRecord.GetRecordStream;
      try
        TLog.SaveLog(now,'����¼����¼');
        TCallRecordOpt.AddRecord(GlobalDM.LocalADOConnection,recordData);
        TLog.SaveLog(now,'����¼����¼�ɹ�');
      finally
        FreeAndNil(recordData.CallRecord);
      end;
      TLog.SaveLog(now,'ˢ�½а���ʾ');

      strRoomNumber := m_CallData.strRoomNumber;
      callType := m_CallData.nType;
      TLog.SaveLog(now,PChar(Format('��ʼ����%s����а�����',[strRoomNumber])));
      if callType = 1 then
        SaveCallResult(m_strRecGUID)
      else
        TDBPlan.EditRoomWaitingState(m_strRecGUID,m_CallData.nCallState);

      TLog.SaveLog(now,PChar(Format('����%s����а����ݳɹ�',[strRoomNumber])));

      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
      RefreshAllBGColor(callType);
      OutputDebugString(PChar(Format('����%s�а����',[strRoomNumber])));
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
  TLog.SaveLog(now,'��ʼ¼��');
  m_MixerRecord.Start;
  TLog.SaveLog(now,'¼�������ɹ�');
end;

procedure TfrmMain_RoomSign.WMMSGRecordEnd(var Message: TMessage);
begin
  TLog.SaveLog(now,'ֹͣ¼��');
  m_MixerRecord.Stop;
  TLog.SaveLog(now,'¼��ֹͣ�ɹ�');
end;

procedure TfrmMain_RoomSign.WMMSGTestFTPEnd(var message: TMessage);
begin
  if DMCallRoom.bFTPConnect then lblFTPState.Caption := 'FTP:��������'
  else
  begin
    lblFTPState.Caption := 'FTP:�����ж�';
    ShowAlarm('FTP�����������ж�,����ϵֵ����Ա��');
  end;
  TLog.SaveLog(Now,lblFTPState.Caption);
end;

procedure TfrmMain_RoomSign.WMMSGTestUDPEnd(var message: TMessage);
begin
  if DMCallRoom.bUDPConnect then lblUDPState.Caption := 'UDP:��������'
  else
  begin
    lblUDPState.Caption := 'UDP:�����ж�';
    if not DMCallRoom.bInstallAddress then
      ShowAlarm('��Ԣ�����жϣ�����ϵֵ����Ա��');
  end;
  TLog.SaveLog(Now,lblUDPState.Caption);
end;

procedure TfrmMain_RoomSign.WMMSGWaitingForConfirm(var Message: TMessage);
begin
  TLog.SaveLog(now,Format('�ȴ�����Աȷ��ͨ��:%d',[Message.WParam]));
  try
    WaitforConfirm(IntToStr(Message.WParam));
    TLog.SaveLog(now,'�ȴ�����Աȷ��ͨ�������ɹ�');
  except on  e : exception  do
    begin
      TLog.SaveLog(now,Format('�ȴ�����Աȷ��ͨ��ʧ��%s',[e.Message]));
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
