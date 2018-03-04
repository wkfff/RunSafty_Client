unit uTrainNoActionList;

interface

uses
  SysUtils,ActnList,uTrainNoCommand,uTrainNoAction ;

type
  //系统动作列表类
  TTrainNoActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //创建命令操作类
    procedure CreateTrainNoCmd();
    procedure DestroyTrainNoCmd();

    //创建ACT类
    procedure CreateTrainNoAct();
    procedure DestroyTrainNoAct();
  public
    actTrainNoManager : TAction ;
  private
    m_cmdTrainNoManager: TTrainNoManagerCmd ;
  end;


implementation

{ TTrainNoActionList }

constructor TTrainNoActionList.Create;
begin
  CreateTrainNoCmd ;
  CreateTrainNoAct ;
end;

procedure TTrainNoActionList.CreateTrainNoAct;
begin
  actTrainNoManager := TAction.Create(nil);
  actTrainNoManager.Caption:= '图定车次表管理';
  actTrainNoManager.OnExecute := m_cmdTrainNoManager.ActionExecute ;
end;

procedure TTrainNoActionList.CreateTrainNoCmd;
begin
  m_cmdTrainNoManager := TTrainNoManagerCmd.Create ;
end;

destructor TTrainNoActionList.Destroy;
begin
  DestroyTrainNoCmd ;
  DestroyTrainNoAct ;
end;

procedure TTrainNoActionList.DestroyTrainNoAct;
begin
  actTrainNoManager.Free;
end;

procedure TTrainNoActionList.DestroyTrainNoCmd;
begin
  m_cmdTrainNoManager.Free ;
end;

end.
