unit uSysActionList;

interface

uses
  SysUtils,Classes,ActnList,uSysAction,uSysCommand ;

type
  //ϵͳ�����б���
  TSysActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //�������������
    procedure CreateSysCmd();
    procedure DestroySysCmd();

    //����ACT��
    procedure CreateSysAct();
    procedure DestroySysAct();
  public
    //�ı����� ACTION
    actModifyPassWord :TAction ;
    //�ı��û�
    actChangeUser : TAction ;
    //�л�����
    actChangeModule : TAction ;
    //�˳�����
    actExitApplication :TAction ;
    //ϵͳ����
    actSysConfig : TAction ;
    //����
    actAbout : TAction ;
  private
    //�ı����� _ʵ�ʵĲ�����
    m_cmdModifyPassWord:TSysModifyPassWordCmd ;
    //�ı��û�
    m_cmdChangeUser : TSysChangeUserCmd ;
    //�л�����
    m_cmdChangeModule : TSysChangeModuleCmd ;
    //�˳�����
    m_cmdExitApplication :TSysExitApplicationCmd ;
    //ϵͳ����
    m_cmdSysConfig : TSysSysConfigCmd ;
    //����
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
  actModifyPassWord.Caption := '�޸�����' ;
  actModifyPassWord.OnExecute := m_cmdModifyPassWord.ActionExecute;

  actChangeUser := TAction.Create(nil) ;
  actChangeUser.Caption := '�л��û�' ;
  actChangeUser.OnExecute := m_cmdChangeUser.ActionExecute;

  actChangeModule := TAction.Create(nil);
  actChangeModule.Caption := '�л�����' ;
  actChangeModule.OnExecute := m_cmdChangeModule.ActionExecute;

  actExitApplication := TAction.Create(nil) ;
  actExitApplication.Caption := '�˳�' ;
  actExitApplication.OnExecute := m_cmdExitApplication.ActionExecute;

  actSysConfig := TAction.Create(nil) ;
  actSysConfig.Caption := 'ϵͳ����' ;
  actSysConfig.OnExecute := m_cmdSysConfig.ActionExecute;

  actAbout := TAction.Create(nil);
  actAbout.Caption := '����' ;
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
