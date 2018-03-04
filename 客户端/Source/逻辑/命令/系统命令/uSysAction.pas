unit uSysAction;

interface

uses
  uSite,Windows,SysUtils ;

type

  //系统动作类
  TSystemAction = class
  public
    //修改密码
    procedure ModifyPassWord();
    //切换用户
    procedure ChangeUser();
    //切换功能
    procedure ChangeModule();
    //退出程序
    procedure ExitApplication();
    //系统设置
    procedure SysConfig();
    //关于
    procedure About();
  end;

implementation

uses
  uGlobalDM,uFrmLogin,ufrmConfig,ufrmModifyPassWord,uFrmExchangeModule;



{ TSystemAction }

procedure TSystemAction.About;
begin
  
end;

procedure TSystemAction.ChangeModule;
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TSystemAction.ChangeUser;
begin
  TfrmLogin.Login
end;

procedure TSystemAction.ExitApplication;
begin
  ;
end;

procedure TSystemAction.ModifyPassWord;
begin
  TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TSystemAction.SysConfig;
begin
  TfrmConfig.EditConfig;
end;

end.
