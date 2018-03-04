unit uSysAction;

interface

uses
  uSite,Windows,SysUtils ;

type

  //ϵͳ������
  TSystemAction = class
  public
    //�޸�����
    procedure ModifyPassWord();
    //�л��û�
    procedure ChangeUser();
    //�л�����
    procedure ChangeModule();
    //�˳�����
    procedure ExitApplication();
    //ϵͳ����
    procedure SysConfig();
    //����
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
