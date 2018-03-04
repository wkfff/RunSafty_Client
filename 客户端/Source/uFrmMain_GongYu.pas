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
    m_strRecGUID: string; //��ǰ�а�GUID
    m_MixerRecord: TMixerRecord;
    procedure CallRoom(dtNow: TDateTime; callData: TCallData; secondCall: boolean);
    //ˢ�����е�����
    procedure RefreshAll;
    //�ж�׷��ʱ��,�жϵ�ǰʱ���ڹ涨�а�ʱ��5���ӻ�1��Сʱ֮��
    function InSecondCallTime(callTime, nowTime: TDateTime): boolean;
    //ˢ�����б���ɫ
    procedure RefreshAllBGColor(nTypeID: Integer);
    //��ȡ���೵�εĺ��д˴�
    function GetCallCount(strGUID: string): Integer;
    //��ȡ���˳��ε�����
    function GetCallData(strGUID: string): TCallData;

    procedure InitRoomPlan();
    //��ʼ���а��б���Ϣ
    procedure InitCalls;
    //��ӽа�����
    procedure InsertCall(TempData: RCallTempData; nType: Integer);
    //ɾ����ȡ���Ľа�����
    procedure DeleteCall(TempDataArray: TCallTempDataArray; nType: Integer);

    //����Ա��¼״̬�仯��Ϣ
    procedure WMSGRepartChanged(var Message: TMessage); message WM_MSGRepartChanged;
    //��ʼ¼��
    procedure WMMSGRecordBegin(var Message: TMessage); message WM_MSGRecordBegin;
    //����¼��
    procedure WMMSGRecordEnd(var Message: TMessage); message WM_MSGRecordEnd;
    //��ʼ�а�
    procedure WMSGCallBegin(var Message: TMessage); message WM_MSGCallBegin;
    //�а����
    procedure WMMSGCallEnd(var Message: TMessage); message WM_MSGCallEnd;

    procedure WMMSGWaitingForConfirm(var Message: TMessage); message WM_MSGWaitingForConfirm;


    {����:����ָ��}
    procedure OnFingerTouching(Sender: TObject);
  public
    { Public declarations }
    m_dtLastCallTime: TDateTime; //��һ�νа�ʱ��
    m_dtLastResetTime: TDateTime;
    m_AppStartTime: TDateTime;
    {����:��ȡָ��״̬}
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
    Result := '�ѽа�'
  else
    Result := 'δ�а�';
end;

function GetDeveiceID(strRoom: string): Integer;
//���ܣ����ݷ���Ż���豸ID��
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if inOutPlan.InOutGroup.CallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
   if GlobalDM.Comming then
  begin
    Application.MessageBox('�а��У������ظ��а࣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('��ȷ��Ҫ���ھͶԳ��Ρ�'+inOutPlan.TrainPlan.strTrainno+'�����на���')
    ,'��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TRsDBTrainPlan.UpdatePlanRecordTime(GlobalDM.ADOConnection,strGUID) then
  begin
    TLog.SaveLog(now,Format('%s�����а�',[inOutPlan.TrainPlan.strTrainNo]));
    InitCalls;
    Application.MessageBox('�����а�ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('�а�ɹ��������Եȣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣡', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('�а��У������ظ��а࣡', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox(PChar('��ȷ��Ҫ���ھͶԳ��Ρ�' + roomPlan.strTrainno + '�����на���')
    , '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  if not TRsDBWaitPlan.UpdatePlanRecordTime(GlobalDM.ADOConnection, strGUID) then
  begin
    TLog.SaveLog(now, Format('%s�����а�', [roomPlan.strTrainNo]));
    InitRoomPlan;
    Application.MessageBox('�����а�ʧ�ܣ�����ϵ����Ա��', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('�а�ɹ��������Եȣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if (inOutPlan.InOutGroup.strRoomNumber = '') then
  begin
    Application.MessageBox('��δ���˼ƻ����䷿��,�����޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (inOutPlan.InOutGroup.Group.Trainman1.nTrainmanState >= tsOutRoom) or
    (inOutPlan.InOutGroup.Group.Trainman2.nTrainmanState >= tsOutRoom) or
     (inOutPlan.InOutGroup.Group.Trainman3.nTrainmanState >= tsOutRoom) then
  begin
    Application.MessageBox('��ס��Ա�Ѿ�������Ԣ�������޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if inOutPlan.InOutGroup.CallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й���,�����޸ķ��䣡','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if FindRoom(roomNumber) then
  begin
    if not TRsDBTrainPlan.EditPlanRoom(GlobalDM.ADOConnection,strGUID,roomNumber) then
    begin
      Application.MessageBox('�޸�ʧ�ܣ�����ϵ����Ա��','��ʾ',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
     Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣬����ɾ����', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('�а��У�����ɾ���ƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;


  if Application.MessageBox('��ȷ��Ҫɾ���üƻ���', '��ʾ', MB_OKCANCEL) = mrCancel then exit;

  if not TRsDBWaitPlan.DeletePlanRecord(GlobalDM.ADOConnection, strGUID) then
  begin
    Application.MessageBox('ɾ���쳣������ϵ����Ա��', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  Application.MessageBox('ɾ���ɹ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ��Ѿ��䶯�������ԣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if roomPlan.nCallCount > 0 then
  begin
    Application.MessageBox('�üƻ��Ѿ��й��࣬�����޸ģ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if GlobalDM.Comming then
  begin
    Application.MessageBox('�а��У������޸ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('��ѡ��Ҫ��Ԣ�ļƻ�!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  trainPlan.TrainPlan.strTrainPlanGUID := strPlanGUID;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection, strPlanGUID,trainPlan) then
  begin
    Application.MessageBox('�ƻ��Ѿ����£���ˢ�º����²���!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
//  if trainPlan.TrainPlan.nPlanState <> Ord(psPublish) then
//  begin
//    Application.MessageBox('�üƻ�Ŀǰ������Ԣ!', '��ʾ', MB_OK + MB_ICONINFORMATION);
//    exit;
//  end;
//  if trainPlan.TrainPlan.Rest.nNeedRest <> 1 then
//  begin
//    Application.MessageBox('�üƻ�����ǿ�ݼƻ�!', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('��ѡ��Ҫ��Ԣ�ļƻ�!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  trainPlan.TrainPlan.strTrainPlanGUID := strPlanGUID;
  if not TRsDBTrainPlan.GetInOutPlanDetail(GlobalDM.ADOConnection, strPlanGUID,trainPlan) then
  begin
    Application.MessageBox('�ƻ��Ѿ����£���ˢ�º����²���!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
//  if trainPlan.TrainPlan.Rest.nNeedRest <> 1 then
//  begin
//    Application.MessageBox('�üƻ�����ǿ�ݼƻ�!', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�üƻ�Ŀǰ������Ԣ!', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
  OutputDebugString(PChar(Format('��ʼ����%s����', [callData.strRoomNumber])));
  m_CallData := callData;
  try
    //���������ǰ�Ľа��̣߳����ͷ��߳����´����а��߳�
    if Assigned(m_CallThread) then
      FreeAndNil(m_CallThread);
    m_CallThread := TCallThread.Create(true);
    TLog.SaveLog(now, '���������̳߳ɹ�');
      //��¼��ǰ�а������
    m_strRecGUID := m_CallData.strGUID;
    m_dtLastCallTime := StrToDateTime('9999-01-01 00:00:00');
    //����а����ݵ�״̬
    Inc(callData.nCallState);

    //ˢ�½а�������ʾ
    RefreshAllBGColor(callData.nType);
    //��ʼִ�на��߳�
    m_CallThread.CallData := callData;
    m_CallThread.IsRecall := secondCall;
    TLog.SaveLog(now, '�����а������߳�');
    m_CallThread.Resume;
    TLog.SaveLog(now, '�����а������̳߳ɹ�');
  except
    //�а�����쳣��λ�а�����
    dtNow := GlobalDM.GetNow;
    m_dtLastCallTime := dtNow;
    m_strRecGUID := '';
    RefreshAllBGColor(callData.nType);
    TLog.SaveLog(now, '�����а������߳�ʧ��');
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
        //�ѹ��ڵļƻ��Ľа�ʱ����23��30���Ժ�����ݣ��ڵ�ǰʱ��Ϊ00��30����ǰ��ɾ��
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
  //��ʼ����Ҫ��Ӳ������
  frmMain_GongYu := TfrmMain_GongYu.Create(nil);
  frmMain_GongYu.Show;
end;

procedure TfrmMain_GongYu.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'��ȷ��Ҫ�˳���?','����',
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
  TLog.SaveLog(now,'��������');
  CallMsgHandle := Handle;
  GlobalDM.OnFingerTouching := OnFingerTouching;  
end;

procedure TfrmMain_GongYu.FormDestroy(Sender: TObject);
begin
  TLog.SaveLog(now,'�����˳�');
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
  //��ʼ��ָ����
  GlobalDM.InitFingerPrintting;

    //�鿴ָ����״̬
  ReadFingerprintState();
  //��ȡָ�ƿ�����
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
  {$REGION '��ʼ����'}
  strGridCall.Cells[0, 0] := '���';
  strGridCall.Cells[1, 0] := '���೵��';
  strGridCall.Cells[2, 0] := '�����';
  strGridCall.Cells[3, 0] := 'ǿ��ʱ��';
  strGridCall.Cells[4, 0] := '�а�ʱ��';
  strGridCall.Cells[5, 0] := '��˫˾��';
  strGridCall.Cells[6, 0] := '˾��';
  strGridCall.Cells[7, 0] := '˾��״̬';
  strGridCall.Cells[8, 0] := '��˾��';
  strGridCall.Cells[9, 0] := '��˾��״̬';
  strGridCall.Cells[10, 0] := 'ѧԱ';
  strGridCall.Cells[11, 0] := '��˾��״̬';
  strGridCall.Cells[12, 0] := '�а�״̬';
  {$ENDREGION '��ʼ����'}
  SetLength(TempDataArray,length(InOutPlanArray));
  for i := 0 to Length(InOutPlanArray) - 1 do
  begin
    {$REGION '��ֵ'}
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

    {$ENDREGION '��ֵ'}
  end;
  lblCallCount.Caption := Format('��ǰ����%d��ǿ�ݼƻ�������%d��δ�а�,%d���ѽаࡣ',
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
    //������Ҫ�����ļƻ�
    TRsDBWaitPlan.CreatePlans(GlobalDM.ADOConnection, GlobalDM.SiteInfo.strAreaGUID);
    //��ȡ���˼ƻ�
    TRsDBWaitPlan.GetPlansByStateEx(GlobalDM.ADOConnection, m_AppStartTime, GlobalDM.SiteInfo.strAreaGUID, ado);
    RoomPlanGrid.Clear;
    RoomPlanGrid.ClearRows(1, 10000);

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

      setLength(tempDataArray,recCount);
      RoomPlanGrid.RowCount := recCount + 2;
      RoomPlanGrid.Cells[0, 0] := '���';
      RoomPlanGrid.Cells[1, 0] := '���೵��';
      RoomPlanGrid.Cells[2, 0] := '�����';
      RoomPlanGrid.Cells[3, 0] := '����ʱ��';
      RoomPlanGrid.Cells[4, 0] := '�а�ʱ��';
      RoomPlanGrid.Cells[5, 0] := '״̬';
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
      strBoolean := '��';
    OutputDebugString(PChar(Format('%s�ڴ߽�ʱ�䷶Χ��', [strBoolean])));
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
  {$REGION '�ж�Ҫ����ļƻ��Ƿ��Ѿ�����,���������º��д���������ţ��а�ʱ��'}
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
  {$ENDREGION '�ж�Ҫ����ļƻ��Ƿ��Ѿ�����'}
  {$REGION '�����Ҫ��������'}
  bInserted := false;
  for i := 0 to m_CallList.Count - 1 do
  begin
    callData := TCallData(m_CallList.Items[i]);
  {$REGION 'ʱ����С������ǰ'}
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
  {$ENDREGION 'ʱ����С������ǰ'}
  end;
  if not bInserted then
  begin
  {$REGION 'ʱ�����������'}
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
  {$ENDREGION 'ʱ�����������'}
  end;
  {$ENDREGION '�����Ҫ��������'}
end;


class procedure TfrmMain_GongYu.LeaveGongYu;
begin
  //�ͷ���Ӳ������
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
    Application.MessageBox('û���ҵ���Ӧ�ĳ���Ա��Ϣ', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not TRsDBTrainPlan.GetTrainmanInOutPlan(GlobalDM.ADOConnection, TrainMan.strTrainmanGUID, trainPlan) then
  begin
    Application.MessageBox('û���ҵ�����Ա���г��ƻ�!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if ((Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID) and
    (Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID) and
    (Trainman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID)) then
  begin
    Application.MessageBox('˾����ָ���ļƻ���Ա����!', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (TrainMan.nTrainmanState <> tsPlaning) and (TrainMan.nTrainmanState <> tsInRoom) then
  begin
    Application.MessageBox('����Ա���ܽ�����Ԣ����Ԣ����!', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    //�򿪼ƻ�����
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
    //�򿪼ƻ�����
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
    statusFinger.Caption := 'ָ������������';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := 'ָ��������ʧ��;˫���������ӣ�';
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
{$REGION 'ˢ�´�����ɫ'}
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
          RoomPlanGrid.Cells[5, i] := 'δȷ��';
          continue;
        end;

        callTime := StrToDateTime(RoomPlanGrid.Cells[4, i] + ':00');
        RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
        callState := GetCallCount(planGUID);
        //�ѹ��ڣ��а�ʱ���ڳ�������ǰ
        if (IncMinute(callTime, GlobalDM.OutTimeDelay) < m_AppStartTime) and (callState < 1) then
        begin
          RoomPlanGrid.Cells[5, i] := '�ѹ���';
          RoomPlanGrid.RowColor[i] := GlobalDM.ColorOutTime;
        end
        else begin
          callState := GetCallCount(planGUID);

          //δ���а�ʱ������ڽа�������
          if callState = 0 then
          begin
            if StrToDateTime(RoomPlanGrid.Cells[3, i]) < dtNow then
            begin
              RoomPlanGrid.Cells[5, i] := '���а�';
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorWaitingCall;
            end
            else begin
              RoomPlanGrid.Cells[5, i] := 'δ����';
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorUnenter;
            end;
          end
          else begin
            //��ǰ�а��е�
            if m_strRecGUID = planGUID then
            begin
              //��ǰ���ڽа�
              RoomPlanGrid.RowColor[i] := GlobalDM.ColorCalling;
              RoomPlanGrid.Cells[5, i] := '�а���';
            end
            else begin

              //���ڽа����Ҫ�а�
              if (m_strRecGUID <> planGUID) then
              begin
                if callState = 1 then
                begin
                  RoomPlanGrid.Cells[5, i] := '�ѽа�';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[5, i] := '�а�ʧ��';

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
                  RoomPlanGrid.Cells[5, i] := '�Ѵ߽�';
                  if callData.nCallSucceed = 0 then
                    RoomPlanGrid.Cells[5, i] := '�߽�ʧ��';
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

{$ENDREGION 'ˢ����ɫ'}


{$REGION 'ˢ��ǿ����ɫ'}
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
          strGridCall.Cells[12, i] := 'δ����';
          strGridCall.RowColor[i] := GlobalDM.ColorUnenter;
        end
        else begin

          //�ѹ��ڣ��а�ʱ���ڳ�������ǰ
          if (IncMinute(callTime, GlobalDM.OutTimeDelay) < m_AppStartTime) and (callState = 0) then
          begin
            strGridCall.Cells[12, i] := '�ѹ���';
            strGridCall.RowColor[i] := GlobalDM.ColorOutTime;
          end
          else begin
            callState := GetCallCount(planGUID);

            //δ���а�ʱ������ڽа�������
            if callState = 0 then
            begin
              strGridCall.Cells[12, i] := '���а�';
              strGridCall.RowColor[i] := GlobalDM.ColorWaitingCall;
            end
            else begin
              //��ǰ�а��е�
              if m_strRecGUID = planGUID then
              begin
                //��ǰ���ڽа�
                strGridCall.RowColor[i] := GlobalDM.ColorCalling;
                strGridCall.Cells[12, i] := '�а���';
              end
              else begin

                //���ڽа����Ҫ�а�
                if (m_strRecGUID <> planGUID) then
                begin
                  if callState = 1 then
                  begin
                    strGridCall.Cells[12, i] := '�ѽа�';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[12, i] := '�а�ʧ��';

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
                    strGridCall.Cells[12, i] := '�Ѵ߽�';
                    if callData.nCallSucceed = 0 then
                      strGridCall.Cells[12, i] := '�߽�ʧ��';
                    strGridCall.RowColor[i] := GlobalDM.ColorOutTime;
                    if (strGridCall.Cells[13, i] <> '����Ԣ') and (strGridCall.Cells[13, i] <> '�ѳ���') then
                    begin
                      callData := GetCallData(planGUID);
                      if IncMinute(callData.dtCallTime, 30) <= dtNow then
                      begin
                        strGridCall.RowColor[i] := GlobalDM.ColorOutDutyAlarm;
                        if not callData.bAlarm then
                        begin
                          callData.bAlarm := true;
                          GlobalDM.CallControl.SetPlayMode(2);
                          PlaySound(PChar(GlobalDM.AppPath + 'Sounds\����Ա�ѽа൫��δ�Ǽ�ֵ��Ա����.wav'), 0, SND_FILENAME or SND_ASYNC);
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
{$ENDREGION 'ˢ��ǿ����ɫ'}
  except on e: exception do
    begin
      Tlog.SaveLog(now, e.Message);
    end;
  end;
end;

procedure TfrmMain_GongYu.timerAutoCallTimer(Sender: TObject);
//�Զ��а�ɨ��
var
  i: Integer;
  callData: TCallData;
  dtNow: TDateTime;
begin
  //���ݿ�����ʧ���˳�
  if GlobalDM.Comming then exit;
  try
    dtNow := GlobalDM.GetNow;
    timerAutoCall.Enabled := false;
    try
      //������ڽа����˳�
      if TCallFunction.InCallWaitingTime(m_dtLastCallTime, dtNow, GlobalDM.CallWaiting) then
      begin
        TLog.SaveLog(now, Format('��ǰ���ڽа��У����һ�νа�ʱ��%s����ǰʱ��%s,��Ⱥ�%d��'
          , [FormatDateTime('yyyy-mm-dd hh:mm', m_dtLastCallTime),
          FormatDateTime('yyyy-mm-dd hh:mm', dtNow),
            GlobalDM.CallWaiting]));
        exit;
      end;
      {$REGION '��ѭ�����е�����ȷ�������е��׽ж�ִ��'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime, m_AppStartTime, GlobalDM.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //δ�а��
        if TCallFunction.CanCall(callData, dtNow, GlobalDM.OutTimeDelay) then
        begin
          CallRoom(dtNow, callData, false);
          exit;
        end;
      end;
      {$ENDREGION '��ѭ�����е�����ȷ�������е��׽ж�ִ��'}

      {$REGION 'Ȼ��ִ����Ҫ�߽е�����'}
      for i := 0 to m_CallList.Count - 1 do
      begin
        callData := TCallData(m_CallList.Items[i]);
        if TCallFunction.HasExpired(callData.dtCallTime, m_AppStartTime, GlobalDM.OutTimeDelay) then continue;
        if callData.strRoomNumber = '' then continue;
        //�ѽа࣬��Ҫ׷�е�
        if (callData.nCallState = 1) and InSecondCallTime(callData.dtCallTime, dtNow) then
        begin
          CallRoom(dtNow, callData, true);
          exit;
        end;
      end;
      {$ENDREGION 'Ȼ��ִ����Ҫ�߽е�����'}
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
      {$REGION '��������'}
      if GlobalDM.SiteInfo.strAreaGUID = '' then
      begin
        statusArea.Font.Color := clRed;
        statusArea.Caption := 'δ���ù�������';
      end else begin
        if not TRsDBArea.GetAreaByGUID(GlobalDM.ADOConnection, GlobalDM.SiteInfo.strAreaGUID, area) then
        begin
          statusArea.Font.Color := clRed;
          statusArea.Caption := 'δ���ù�������';
        end else begin
          statusArea.Font.Color := clBlack;
          statusArea.Caption := area.strAreaName;
        end;
      end;
    {$ENDREGION '��������'}
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
      TLog.SaveLog(now, '�����в���⴮��');
      exit;
    end;
    if IncMinute(GlobalDM.HangupTime, 1) >= GlobalDM.GetNow then
    begin
      TLog.SaveLog(now, '�Ҷ�δ��1���ӣ�����ⴰ��');
      exit;
    end;
    //����״̬
    if GlobalDM.SerialConnected then
    begin
      rlt := GlobalDM.CallControl.GetCallControlNum(wDeviceNum);
      OutputDebugString(PChar('���ڼ��:' + inttostr(rlt)));
      if rlt <> 1 then
      begin
        statusSerialState.Font.Color := clRed;
        TLog.SaveLog(now, '����״̬���豸δ����');
        statusSerialState.Caption := '����״̬���豸δ����';
        GlobalDM.SerialConnected := false;
      end
      else begin
        statusSerialState.Font.Color := clBlack;
        statusSerialState.Caption := '����״̬���򿪳ɹ�';
      end;
    end
    else begin
      if GlobalDM.CallControl.OpenPort(GlobalDM.Port) <> 1 then
      begin
        statusSerialState.Font.Color := clRed;
        TLog.SaveLog(now, '����״̬���豸δ����');
        statusSerialState.Caption := '����״̬����ʧ��';
      end else begin
        GlobalDM.SerialConnected := true;
      end;
    end;

    //��������λ,12Сʱ���ڷǽа�ʱ���ڸ�λ��Ƭ��
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
        statusFinger.Caption := 'ָ�ƿ����и��£���˫������ָ�ƿ�';
      end else begin
        if GlobalDM.FingerLibGUID <> GlobalDM.NewLibGUID then
        begin
          statusFinger.Font.Color := clRed;
          statusFinger.Caption := 'ָ�ƿ����и��£���˫������ָ�ƿ�';
        end else begin
          statusFinger.Font.Color := clBlack;
          statusFinger.Caption := 'ָ�ƿ��Ѿ�����';
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
    FormatDateTime('yyyy��MM��dd�� hhʱnn��ss��', GlobalDM.GetNow);
end;


procedure TfrmMain_GongYu.WMMSGCallEnd(var Message: TMessage);
var
  dtNow: TDateTime;
  recordData: RCallRecord;
  strRoomNumber: string;
  callType: integer;
begin
  TLog.SaveLog(now, '���ܵ�ֹͣ������Ϣ');
  try
    dtNow := GlobalDM.GetNow;
    try
      if m_CallData = nil then
      begin
        TLog.SaveLog(dtNow, '�а�����Ϊ��');
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
        ShowCallFailure(Format('%s����а�ʧ�ܣ����飡����', [m_CallData.strRoomNumber]));
      end;
      TLog.SaveLog(now, '��ȡ¼������');
      recordData.CallRecord := m_MixerRecord.GetRecordStream;

      try
       //����а��¼
        TLog.SaveLog(now, '����¼����¼');
        try
          TRsCallRecordOpt.AddRecord(GlobalDM.ADOConnection,recordData);
          TLog.SaveLog(now, '����¼����¼�ɹ�');
        except on e : exception do
          begin
            TLog.SaveLog(now, '����¼����¼ʧ��:' + e.Message);
          end;
        end;
      finally
         FreeAndNil(recordData.CallRecord);
      end;
      callType := m_CallData.nType;
      m_dtLastCallTime := dtNow;
      m_strRecGUID := '';
      RefreshAllBGColor(callType);
      OutputDebugString(PChar(Format('����%s�а����', [strRoomNumber])));
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
  TLog.SaveLog(now, '��ʼ¼��');
  m_MixerRecord.Start;
  TLog.SaveLog(now, '¼�������ɹ�');
end;

procedure TfrmMain_GongYu.WMMSGRecordEnd(var Message: TMessage);
begin
  TLog.SaveLog(now, 'ֹͣ¼��');
  m_MixerRecord.Stop;
  TLog.SaveLog(now, '¼��ֹͣ�ɹ�');
end;

procedure TfrmMain_GongYu.WMMSGWaitingForConfirm(var Message: TMessage);
begin
  TLog.SaveLog(now, Format('�ȴ�����Աȷ��ͨ��:%d', [Message.WParam]));
  try
    WaitforConfirm(IntToStr(Message.WParam));
    TLog.SaveLog(now, '�ȴ�����Աȷ��ͨ�������ɹ�');
  except on e: exception do
    begin
      TLog.SaveLog(now, Format('�ȴ�����Աȷ��ͨ��ʧ��%s', [e.Message]));
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

