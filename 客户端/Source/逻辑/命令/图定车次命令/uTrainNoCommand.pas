unit uTrainNoCommand;

interface

uses
  Classes,uTrainNoAction ;

type

  //图定命令基类
  TTrainNoCommand = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //执行动作
    procedure ActionExecute(Sender: TObject);
    //执行动作
    procedure Action();virtual;
  protected
    m_actTrainNoAction:TTrainNoAction ;
  end;

  //图定管理类
  TTrainNoManagerCmd = class(TTrainNoCommand)
  public
    procedure Action();override;
  end;





implementation

{ TTrainNoCommand }

procedure TTrainNoCommand.Action;
begin
  ;
end;

procedure TTrainNoCommand.ActionExecute(Sender: TObject);
begin
  Action ;
end;

constructor TTrainNoCommand.Create();
begin
  m_actTrainNoAction := TTrainNoAction.Create ;
end;

destructor TTrainNoCommand.Destroy;
begin
  m_actTrainNoAction.Free ;
end;


{ TTrainNoManagerCmd }

procedure TTrainNoManagerCmd.Action;
begin
  m_actTrainNoAction.ManagerTrainNo ;
end;

end.
