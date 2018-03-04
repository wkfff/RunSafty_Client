unit uModuleExchange;

interface
uses
  Messages,Forms,uSite,uFrmMain_JiDiao_Extra,uFrmMain_RenYuan,
  uFrmMain_ChuQin,uFrmMain_TuiQin,uFrmLogin,uFrmLocalDrink,uGlobalDM;
const
  //切换消息函数
  WM_MSG_ExchangeModule = WM_User + 111; 
  //重新登录系统消息函数
  WM_MSG_ReloginSystem = WM_User + 112;
type
  TModuleExchange = class
  private
    //消息句柄
    m_MsgHandle : THandle;
    //
    m_nMsg : integer;
    //消息处理函数
    procedure WndProc(var Msg : TMessage);
    procedure ReloginSystem;
  public
    constructor Create(Msg : integer);
    destructor Destroy;override;
  public
    procedure TurnToModule(FromModule,ToModule : TRsSiteJob);
    property MsgHandle : THandle read m_MsgHandle;
  end;
implementation

{ TModuleExchange }

constructor TModuleExchange.Create(Msg : integer);
begin
  m_nMsg := Msg;
  m_MsgHandle := AllocateHWnd(WndProc);  
end;

destructor TModuleExchange.Destroy;
begin
   DeallocateHWnd(m_MsgHandle);
  inherited;
end;

procedure TModuleExchange.TurnToModule(FromModule, ToModule: TRsSiteJob);
begin

  case FromModule of
    sjDiaodu: TFrmMain_JiDiao_Extra.LeaveJiDiao;
    sjPaiBan: TfrmMain_RenYuan.LeavePaiBan;
    sjChuQin: TfrmMain_ChuQin.LeaveChuQin;
    sjTuiQin: TfrmMain_TuiQin.LeaveTuiQin;
  end;

  case ToModule of
    sjDiaodu: TFrmMain_JiDiao_Extra.EnterJiDiao;
    sjPaiBan: TfrmMain_RenYuan.EnterPaiBan;
    sjChuQin: TfrmMain_ChuQin.EnterChuQin;
    sjTuiQin: TfrmMain_TuiQin.EnterTuiQin;
    sjDuanWang: TFrmLocalDrink.ShowForm; 
  end;

end;

procedure TModuleExchange.ReloginSystem;
begin
  TFrmLocalDrink.CloseForm; 
  GlobalDM.LoadConfig();
  frmLogin := TfrmLogin.Create(nil);
  try
    if frmLogin.ShowModal = 1 then
    begin
      //GlobalDM.TFDBAutoConnect.Enabled := False ;//DebugHook = 0;
      case GlobalDM.SiteInfo.nSiteJob of
        Ord(sjChuQin): begin
          GlobalDm.CurrentModule := sjChuQin;
          TfrmMain_ChuQin.EnterChuQin;
        end;
        Ord(sjTuiQin): begin
          GlobalDm.CurrentModule := sjTuiQin;
          TfrmMain_TuiQin.EnterTuiQin;
        end;  
      end;
    end;
  finally
    frmLogin.Free;
  end;
end;

procedure TModuleExchange.WndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_MSG_ExchangeModule :
    begin
      GlobalDM.CurrentModule := TRsSiteJob(Msg.LParam);
      TurnToModule(TRsSiteJob(Msg.WParam),TRsSiteJob(Msg.LParam));
    end;
    WM_MSG_ReloginSystem : ReloginSystem;
  end;
end;

end.
