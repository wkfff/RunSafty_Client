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
    //ִ�ж���
    procedure ActionExecute(Sender: TObject);
    //ִ�ж���
    procedure Action();virtual;
  protected
    m_actSysAction:TSystemAction ;
  end;

  //�޸���������
  TSysModifyPassWordCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //�л��û�
  TSysChangeUserCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //�л�����
  TSysChangeModuleCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //�˳�����
  TSysExitApplicationCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //ϵͳ����
  TSysSysConfigCmd = class(TSysCommand)
  public
    procedure Action();override;
  end;

  //����
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
