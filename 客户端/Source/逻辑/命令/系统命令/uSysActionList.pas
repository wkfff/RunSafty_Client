unit uSysActionList;

interface

uses
  SysUtils,Classes,ActnList,uSysAction,uSysCommand ;

type
  //系统动作列表类
  TSysActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //创建命令操作类
    procedure CreateSysCmd();
    procedure DestroySysCmd();

    //创建ACT类
    procedure CreateSysAct();
    procedure DestroySysAct();
  public
    //改变密码 ACTION
    actModifyPassWord :TAction ;
    //改变用户
    actChangeUser : TAction ;
    //切换功能
    actChangeModule : TAction ;
    //退出程序
    actExitApplication :TAction ;
    //系统配置
    actSysConfig : TAction ;
    //关于
    actAbout : TAction ;
  private
    //改变密码 _实际的操作类
    m_cmdModifyPassWord:TSysModifyPassWordCmd ;
    //改变用户
    m_cmdChangeUser : TSysChangeUserCmd ;
    //切换功能
    m_cmdChangeModule : TSysChangeModuleCmd ;
    //退出程序
    m_cmdExitApplication :TSysExitApplicationCmd ;
    //系统配置
    m_cmdSysConfig : TSysSysConfigCmd ;
    //关于
    m_cmdAbout : TSysAboutCmd ;
  end;




implementation

{ TSysActionList }

constructor TSysActionList.Create;
begin
  CreateSysCmd ;
  CreateSysAct ;
end;

procedure TSysActionList.CreateSysAct;
begin
  actModifyPassWord := TAction.Create(nil) ;
  actModifyPassWord.Caption := '修改密码' ;
  actModifyPassWord.OnExecute := m_cmdModifyPassWord.ActionExecute;

  actChangeUser := TAction.Create(nil) ;
  actChangeUser.Caption := '切换用户' ;
  actChangeUser.OnExecute := m_cmdChangeUser.ActionExecute;

  actChangeModule := TAction.Create(nil);
  actChangeModule.Caption := '切换功能' ;
  actChangeModule.OnExecute := m_cmdChangeModule.ActionExecute;

  actExitApplication := TAction.Create(nil) ;
  actExitApplication.Caption := '退出' ;
  actExitApplication.OnExecute := m_cmdExitApplication.ActionExecute;

  actSysConfig := TAction.Create(nil) ;
  actSysConfig.Caption := '系统设置' ;
  actSysConfig.OnExecute := m_cmdSysConfig.ActionExecute;

  actAbout := TAction.Create(nil);
  actAbout.Caption := '关于' ;
  actAbout.OnExecute := m_cmdAbout.ActionExecute;
end;

procedure TSysActionList.CreateSysCmd;
begin
  m_cmdModifyPassWord := TSysModifyPassWordCmd.Create ;
  m_cmdChangeUser := TSysChangeUserCmd.Create ;
  m_cmdChangeModule := TSysChangeModuleCmd.Create ;

  m_cmdExitApplication := TSysExitApplicationCmd.Create ;
  m_cmdSysConfig := TSysSysConfigCmd.Create ;
  m_cmdAbout := TSysAboutCmd.Create ;
end;

destructor TSysActionList.Destroy;
begin
  DestroySysCmd ;
  DestroySysAct ;
end;

procedure TSysActionList.DestroySysAct;
begin
  actModifyPassWord.Free ;
  actChangeUser.Free ;
  actChangeModule.Free ;
  actExitApplication.Free ;
  actSysConfig.Free ;
  actAbout.Free;
end;

procedure TSysActionList.DestroySysCmd;
begin
  m_cmdModifyPassWord.Free ;
  m_cmdChangeUser.Free ;
  m_cmdChangeModule.Free ;

  m_cmdExitApplication.Free ;
  m_cmdSysConfig.Free ;
  m_cmdAbout.Free ;
end;

end.
