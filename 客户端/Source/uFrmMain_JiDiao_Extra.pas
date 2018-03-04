unit uFrmMain_JiDiao_Extra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, RzPanel, ComCtrls, RzDTP, ExtCtrls, StdCtrls, Buttons,
  PngSpeedButton, Menus, uTFMessageDefine, uTrainJiaolu, DateUtils,
  uRunSaftyMessageDefine, uTrainPlan, ActnList,
  uLCNameBoardEx, uLCTrainPlan, uLCBaseDict, uLCSendLog,
  utfSkin, RzTabs, Grids, AdvObj, BaseGrid, AdvGrid,uFrmTrainPlan,ufrmJDPlan;

type
  TFrmMain_JiDiao_Extra = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    mniModifyPassword: TMenuItem;
    mniChangeUser: TMenuItem;
    N30: TMenuItem;
    mniChangeModule: TMenuItem;
    N32: TMenuItem;
    mniExit: TMenuItem;
    N3: TMenuItem;
    mniTrainnoManager: TMenuItem;
    mniLoadPlan: TMenuItem;
    N13: TMenuItem;
    mniAddPlan: TMenuItem;
    mniSendPlan: TMenuItem;
    N19: TMenuItem;
    mniDeletePlan: TMenuItem;
    mniCancelPlan: TMenuItem;
    mniRefreshPlan: TMenuItem;
    mSet: TMenuItem;
    mniSysConfig: TMenuItem;
    N34: TMenuItem;
    N37: TMenuItem;
    mniExportPlan: TMenuItem;
    N6: TMenuItem;
    mniAbout: TMenuItem;
    pnlToolButton: TRzPanel;
    btnExchangeUser: TPngSpeedButton;
    btnRefreshPaln: TPngSpeedButton;
    btnLoadPlan: TPngSpeedButton;
    btnAddPlan: TPngSpeedButton;
    btnSendPlan: TPngSpeedButton;
    btnDeletePlan: TPngSpeedButton;
    btnCancelPlan: TPngSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    dtpPlanStartDate: TRzDateTimePicker;
    dtpPlanStartTime: TRzDateTimePicker;
    pnlClient: TRzPanel;
    pnlPlan: TRzPanel;
    pnlTrainJiaoLu: TRzPanel;
    pnlBottom: TRzPanel;
    TimerCheckUpdate: TTimer;
    tmrRefreshTime: TTimer;
    btnImportPlan: TPngSpeedButton;
    N2: TMenuItem;
    N4: TMenuItem;
    objectmniLoadPlanTMenuItem1: TMenuItem;
    tmrCheckPlanRecv: TTimer;
    RzStatusBar: TRzStatusBar;
    statusPanelDBState: TRzStatusPane;
    statusSysTime: TRzGlyphStatus;
    statusAppVersion: TRzGlyphStatus;
    statusMessage: TRzStatusPane;
    statusUpdate: TRzStatusPane;
    TabCtrlJL: TRzTabControl;
    PageControlBottom: TRzPageControl;
    SheetMessage: TRzTabSheet;
    SheetJDPlan: TRzTabSheet;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpPlanStartDateChange(Sender: TObject);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure mniExportPlanClick(Sender: TObject);
    procedure tmrRefreshTimeTimer(Sender: TObject);
    procedure TimerCheckUpdateTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure mniChangeUserClick(Sender: TObject);
    procedure btnExchangeUserClick(Sender: TObject);
    procedure btnImportPlanClick(Sender: TObject);
    procedure btnLoadPlanClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure objectmniLoadPlanTMenuItem1Click(Sender: TObject);
    procedure tmrCheckPlanRecvTimer(Sender: TObject);
    procedure TabCtrlJLChange(Sender: TObject);
    procedure btnAddPlanClick(Sender: TObject);
    procedure btnSendPlanClick(Sender: TObject);
    procedure btnDeletePlanClick(Sender: TObject);
    procedure btnCancelPlanClick(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure mniModifyPasswordClick(Sender: TObject);
    procedure mniChangeModuleClick(Sender: TObject);
    procedure mniSysConfigClick(Sender: TObject);
    procedure mniTrainnoManagerClick(Sender: TObject);
  private
    m_LCSendLog: TLCSendLog;
    //
    m_dtNow: TDateTime;
    m_RsLCTrainPlan: TRsLCTrainPlan;
    m_nDayPlanID: integer;

    m_JLArray : TRsTrainJiaoluArray;
    m_FrmTrainPlan: TFrmTrainPlan;
    m_FrmJDPlan: TFrmJDPlan;
  private
    { Private declarations }
    //导出计划
    procedure ExportPlan();

    procedure InitJL;

    function GetSelectJL():RRsTrainJiaolu;

    //更新状态栏应用程序的最新版本信息
    procedure OnAppVersionChange(Sender: TObject);
    //消息过程
    procedure OnTFMessage(TFMessages: TTFMessageList);

    procedure CreateSubForms();

    //初始化
    procedure InitData();
  public
    class procedure EnterJiDiao;
    class procedure LeaveJiDiao;
  end;

var
  FrmMain_JiDiao_Extra: TFrmMain_JiDiao_Extra;

implementation

uses
  uGlobalDM, ufrmTrainplanExport, uFrmLogin, uTFSystem,
  uFrmPlanMessage, uFrmTrainJiaoLu, ufrmTextInput, uFrmTemplateTrainNoManager,
  uFrmMainTemeplateTrainNo, ufrmManagerConfirm, ufrmModifyPassWord,
  uFrmExchangeModule,uSite, ufrmConfig, uFrmTrainNo,uFrmRegionFilter;

{$R *.dfm}

procedure TFrmMain_JiDiao_Extra.btnAddPlanClick(Sender: TObject);
begin
  m_FrmTrainPlan.InsertPlan();
end;

procedure TFrmMain_JiDiao_Extra.btnCancelPlanClick(Sender: TObject);
begin
  m_FrmTrainPlan.CancelPlan();
end;

procedure TFrmMain_JiDiao_Extra.btnDeletePlanClick(Sender: TObject);
begin
  m_FrmTrainPlan.RemovePlan();
end;

procedure TFrmMain_JiDiao_Extra.btnExchangeUserClick(Sender: TObject);
begin
  TfrmLogin.Login;
  InitData;
end;

procedure TFrmMain_JiDiao_Extra.btnImportPlanClick(Sender: TObject);
begin
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo();
end;

procedure TFrmMain_JiDiao_Extra.btnLoadPlanClick(Sender: TObject);
begin
  m_FrmTrainPlan.LoadPlan;
end;

procedure TFrmMain_JiDiao_Extra.btnRefreshPalnClick(Sender: TObject);
begin
  m_FrmTrainPlan.RefreshPlan();
  if Assigned(m_FrmJDPlan) then
    m_FrmJDPlan.RefreshPlan();
end;

procedure TFrmMain_JiDiao_Extra.btnSendPlanClick(Sender: TObject);
begin
  m_FrmTrainPlan.SendPlan();
end;

procedure TFrmMain_JiDiao_Extra.CreateSubForms;
begin
  {计划列表}
  m_FrmTrainPlan := TFrmTrainPlan.Create(Self);
  m_FrmTrainPlan.Parent := pnlPlan;
  m_FrmTrainPlan.Show;

  {消息}
  FrmPlanMessage := TFrmPlanMessage.Create(Self);
  FrmPlanMessage.Parent := SheetMessage;
  FrmPlanMessage.Show;


  if GlobalDM.SiteConfigs.Values['JDPlanEnable'] = '1' then
  begin
    m_FrmJDPlan := TFrmJDPlan.Create(Self);
    m_FrmJDPlan.Parent :=SheetJDPlan;
    m_FrmJDPlan.OnCreateJDPlan := m_FrmTrainPlan.RefreshPlan;
    m_FrmJDPlan.PlanQueryTime := StrToDateTime(GlobalDM.ShowPlanStartTime);
    m_FrmTrainPlan.CheckJDPlanCallback := m_FrmJDPlan.PlanInJDPlanLst;
    m_FrmJDPlan.Init;
    m_FrmJDPlan.Show;
  end
  else
  begin
    SheetJDPlan.Free;
    PageControlBottom.ActivePage := SheetMessage;
  end;
end;




procedure TFrmMain_JiDiao_Extra.dtpPlanStartDateChange(Sender: TObject);
begin
  m_FrmTrainPlan.StartDate := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  ;
  m_FrmTrainPlan.EndDate := m_FrmTrainPlan.StartDate + 2;

  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
  if assigned(m_FrmJDPlan) then
  begin
    m_FrmJDPlan.PlanQueryTime := m_FrmTrainPlan.StartDate;
  end;
end;

procedure TFrmMain_JiDiao_Extra.dtpPlanStartTimeChange(Sender: TObject);
begin
  m_FrmTrainPlan.StartDate := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  ;
  m_FrmTrainPlan.EndDate := m_FrmTrainPlan.StartDate + 2;

  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));

end;

class procedure TFrmMain_JiDiao_Extra.EnterJiDiao;
begin
  if FrmMain_JiDiao_Extra = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TFrmMain_JiDiao_Extra, FrmMain_JiDiao_Extra);
    
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,FrmMain_JiDiao_Extra);
    
    FrmMain_JiDiao_Extra.CreateSubForms();

    FrmMain_JiDiao_Extra.InitData;

  end;
  FrmMain_JiDiao_Extra.Show;
end;

procedure TFrmMain_JiDiao_Extra.ExportPlan;
begin
  ExportTrainPlan(m_JLArray);
end;

procedure TFrmMain_JiDiao_Extra.FormClick(Sender: TObject);
begin
  LeaveJiDiao;
end;

procedure TFrmMain_JiDiao_Extra.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle, '您确定要退出吗?', '请问', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TFrmMain_JiDiao_Extra.FormCreate(Sender: TObject);
begin
  m_RsLCTrainPlan := TRsLCTrainPlan.Create('', '', '');
  m_RsLCTrainPlan.SetConnConfig(GlobalDM.HttpConnConfig);
  m_LCSendLog := TLCSendLog.Create(GlobalDM.WebAPIUtils);
  dtpPlanStartTime.DateTime := StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime := StrToDateTime(GlobalDM.ShowPlanStartTime);

  tmrRefreshTime.Enabled := True;
end;

procedure TFrmMain_JiDiao_Extra.FormDestroy(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;

  tmrRefreshTime.Enabled := False;

  m_RsLCTrainPlan.Free;
  m_LCSendLog.Free;

end;

type
  PJLStruct = ^RRsTrainJiaolu;
  
function TFrmMain_JiDiao_Extra.GetSelectJL: RRsTrainJiaolu;
begin
  FillChar(Result,SizeOf(Result),0);
  
  if TabCtrlJL.TabIndex < 0 then Exit;

  Result := PJLStruct(TabCtrlJL.Tabs[TabCtrlJL.TabIndex].Data)^;
end;

procedure TFrmMain_JiDiao_Extra.InitData;
var
  strDutyPlaceID: string;
begin
  GlobalDM.OnAppVersionChange := OnAppVersionChange;

  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open;

  InitJL;

  
  //初始化界面计划
  m_FrmTrainPlan.StartDate := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);

  m_FrmTrainPlan.EndDate := m_FrmTrainPlan.StartDate + 2;
  
  strDutyPlaceID := GlobalDM.DutyPlaceID;
  if strDutyPlaceID = '' then
  begin
    Box('没有关注的外勤端,无法收到机车计划更新消息！');
  end
  else
  begin
    m_nDayPlanID := StrToInt(strDutyPlaceID);
  end;

  Caption := '机调管理 ' + GetFileVersion(Application.ExeName);
end;

procedure TFrmMain_JiDiao_Extra.InitJL;
var
  i:Integer;
begin
  SetLength(m_JLArray,0);

  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_JLArray);
  TabCtrlJL.Tabs.Clear;

  for I := 0 to length(m_JLArray) - 1 do
  begin
    with TabCtrlJL.Tabs.Add do
    begin
      Caption := m_JLArray[i].strTrainJiaoluName;
      Data := @m_JLArray[i];
    end;
  end;

  if length(m_JLArray) > 0 then
  begin
    TabCtrlJL.TabIndex := 0;
  end;

  TRegionFilter.DefaultFlter.AddJl(m_JLArray);
end;




class procedure TFrmMain_JiDiao_Extra.LeaveJiDiao;
begin
  GlobalDM.OnAppVersionChange := nil;
  //释放已硬件驱动
  if FrmMain_JiDiao_Extra <> nil then
    FreeAndNil(FrmMain_JiDiao_Extra);
end;

procedure TFrmMain_JiDiao_Extra.mniChangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TFrmMain_JiDiao_Extra.mniChangeUserClick(Sender: TObject);
begin
  TfrmLogin.Login;
  InitData;
end;

procedure TFrmMain_JiDiao_Extra.mniExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain_JiDiao_Extra.mniExportPlanClick(Sender: TObject);
begin
  ExportPlan;
end;

procedure TFrmMain_JiDiao_Extra.mniModifyPasswordClick(Sender: TObject);
begin
  TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TFrmMain_JiDiao_Extra.mniSysConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TFrmMain_JiDiao_Extra.mniTrainnoManagerClick(Sender: TObject);
begin
  TfrmTrainNo.ManageTrainNo;
end;

procedure TFrmMain_JiDiao_Extra.N2Click(Sender: TObject);
begin
  //获取密码才能进入管理
  if ManagerConfirm then
  begin
    TTemplateTrainNoManager.ManageTemplateTrainNo;
  end;
end;

procedure TFrmMain_JiDiao_Extra.objectmniLoadPlanTMenuItem1Click(Sender: TObject);
begin
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo();
end;

procedure TFrmMain_JiDiao_Extra.OnAppVersionChange(Sender: TObject);
begin
  statusAppVersion.Caption := '有新程序发布,请及时更新!';
end;




procedure TFrmMain_JiDiao_Extra.OnTFMessage(TFMessages: TTFMessageList);
var
  i, J: Integer;
  GUIDS: TStringList;
  strMessageType: string;
  TrainPlan: RRsTrainPlan;
begin
  GUIDS := TStringList.Create;
  try
    for I := 0 to TFMessages.Count - 1 do
    begin

      TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;

      if not RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'], GlobalDM.SiteInfo.strSiteGUID) then
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;

      case TFMessages.Items[i].msg of
        TFM_PLAN_RENYUAN_PUBLISH, TFM_PLAN_RENYUAN_RECIEVE, TFM_PLAN_RENYUAN_UPDATE, TFM_PLAN_RENYUAN_DELETE, TFM_PLAN_RENYUAN_RMTRAINMAN, TFM_PLAN_RENYUAN_RMGROUP:
          begin
            GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
            case TFMessages.Items[i].msg of
              TFM_PLAN_RENYUAN_PUBLISH:
                strMessageType := '已发布';
              TFM_PLAN_RENYUAN_UPDATE:
                strMessageType := '更新计划';
              TFM_PLAN_RENYUAN_DELETE:
                strMessageType := '撤销计划';
              TFM_PLAN_RENYUAN_RECIEVE:
                strMessageType := '已接收';
              TFM_PLAN_RENYUAN_RMTRAINMAN:
                strMessageType := '移除人员';
              TFM_PLAN_RENYUAN_RMGROUP:
                strMessageType := '移除机组';
            end;
            for J := 0 to GUIDS.Count - 1 do
            begin

              if m_RsLCTrainPlan.GetTrainPlanByID(GUIDS.Strings[j], TrainPlan) then
              begin
                FrmPlanMessage.ShowPlanMessage(strMessageType, trainPlan)
              end;
            end;
          end;
        TFM_WORK_BEGIN:
          begin
            if m_RsLCTrainPlan.GetTrainPlanByID(TFMessages.Items[i].StrField['planGuid'], TrainPlan) then
            begin
              strMessageType := '出勤';
              FrmPlanMessage.ShowPlanMessage(strMessageType, trainPlan)
            end;
          end
      else
        Continue;
      end;

    end;

  finally
    GUIDS.Free;
  end;
end;

procedure TFrmMain_JiDiao_Extra.TabCtrlJLChange(Sender: TObject);
begin
  m_FrmTrainPlan.TrainJiaolu := GetSelectJL;
  m_FrmTrainPlan.StartDate := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  m_FrmTrainPlan.EndDate := m_FrmTrainPlan.StartDate + 2;
  m_FrmTrainPlan.RefreshPlan;

  if Assigned(m_FrmJDPlan) then
    m_FrmJDPlan.JLID := m_FrmTrainPlan.TrainJiaolu.strTrainJiaoluGUID;
end;

procedure TFrmMain_JiDiao_Extra.TimerCheckUpdateTimer(Sender: TObject);
begin
  if GlobalDM.GetUpdateInfo then
  begin
    statusUpdate.Caption := '客户端需要更新，请重启系统';
    statusUpdate.Font.Color := clRed;
  end
  else
  begin
    statusUpdate.Caption := '客户端已是最新版本';
    statusUpdate.Font.Color := clBlack;
  end;
end;

procedure TFrmMain_JiDiao_Extra.tmrCheckPlanRecvTimer(Sender: TObject);
var
  sendLogAry: TRsTrainPlanSendLogArray;
  dtFrom: TDateTime;
begin
  if GlobalDM.SendPlanNoticeMin <= 0 then
  begin
    GlobalDM.StopPlaySound;
    Exit;
  end;

  dtFrom := IncMinute(GlobalDM.GetNow, -GlobalDM.SendPlanNoticeMin);

  m_LCSendLog.GetUnRecvSendLog(GlobalDM.SiteInfo.strSiteGUID, dtFrom, sendLogAry);

  if Length(sendLogAry) > 0 then
  begin
    GlobalDM.PlaySoundFileLoop('计划超时未接收,请注意查看.wav');
  end
  else
  begin
    GlobalDM.StopPlaySound;
  end;
end;

procedure TFrmMain_JiDiao_Extra.tmrRefreshTimeTimer(Sender: TObject);
begin

  TTimer(Sender).Enabled := false;
  try
    m_dtNow := GlobalDM.GetNow;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', m_dtNow);
    statusMessage.Caption := Format('消息缓存：%d条', [GlobalDM.TFMessageCompnent.MessageBufferCount]);


    if Assigned(m_FrmTrainPlan) then
      m_FrmTrainPlan.dtNow := m_dtNow;
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

end.

