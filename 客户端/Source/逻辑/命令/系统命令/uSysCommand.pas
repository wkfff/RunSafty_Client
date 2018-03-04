unit uSysCommand;

interface

uses
  Classes,uSysAction ;

type

  TSysCommand = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //执行动作
    procedure ActionExecute(Sender: TObject);
    //执行动作
    procedure Action();virtual;
  protected
    m_actSysAction:TSystemAction ;
  end;

  //修改密码命令
  TSysModifyPassWordCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //切换用户
  TSysChangeUserCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //切换功能
  TSysChangeModuleCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //退出程序
  TSysExitApplicationCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //系统设置
  TSysSysConfigCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //关于
  TSysAboutCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;



implementation

{ TSysCommand }

procedure TSysCommand.Action;
begin
  ;
end;

procedure TSysCommand.ActionExecute(Sender: TObject);
begin
  Action ;
end;

constructor TSysCommand.Create();
begin
  m_actSysAction :=  TSystemAction.Create;
end;

destructor TSysCommand.Destroy;
begin
  m_actSysAction.Free ;
end;


{ TSysModifyPassWordCmd }

procedure TSysModifyPassWordCmd.Action;
begin
  m_actSysAction.ModifyPassWord ;
end;

{ TSysChangeUserCmd }

procedure TSysChangeUserCmd.Action;
begin
  m_actSysAction.ChangeUser ;
end;

{ TSysChangeModuleCmd }

procedure TSysChangeModuleCmd.Action;
begin
  m_actSysAction.ChangeModule ;
end;

{ TSysExitApplicationCmd }

procedure TSysExitApplicationCmd.Action;
begin
  m_actSysAction.ExitApplication ;
end;

{ TSysSysConfigCmd }

procedure TSysSysConfigCmd.Action;
begin
  m_actSysAction.SysConfig ;
end;

{ TSysAboutCmd }

procedure TSysAboutCmd.Action;
begin
  m_actSysAction.About ;
end;

end.
