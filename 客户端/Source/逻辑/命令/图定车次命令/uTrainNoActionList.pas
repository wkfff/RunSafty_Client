unit uTrainNoActionList;

interface

uses
  SysUtils,ActnList,uTrainNoCommand,uTrainNoAction ;

type
  //ϵͳ�����б���
  TTrainNoActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //�������������
    procedure CreateTrainNoCmd();
    procedure DestroyTrainNoCmd();

    //����ACT��
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
  actTrainNoManager.Caption:= 'ͼ�����α����';
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
