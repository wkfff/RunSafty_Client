unit uTask;

interface


uses
  SysUtils,Contnrs;


type

  //普通的任务
  TBaseTask = class
  public
    procedure DoWork();virtual;abstract;
  end;

  TTaskList = class(TObjectList)
  public
    function GetItem(Index: Integer): TBaseTask;
    procedure SetItem(Index: Integer; AObject: TBaseTask);

    function Add(AObject: TBaseTask): Integer;
    function Remove(AObject: TBaseTask): Integer;
  public
    property Items[Index: Integer]: TBaseTask read GetItem write SetItem;
  end;


  TTaskManager = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    function AddTask(AObject: TBaseTask): Integer;
    procedure DoTask();
  private
    FTaskList : TTaskList ;
  public

  end;


implementation

{ TTaskManager }

function TTaskManager.AddTask(AObject: TBaseTask): Integer;
begin
  Result := FTaskList.Add(AObject)  ;
end;

constructor TTaskManager.Create;
begin
  FTaskList:= TTaskList.Create;
end;

destructor TTaskManager.Destroy;
begin
  FTaskList.Free ;
  inherited;
end;

procedure TTaskManager.DoTask;
var
  i : Integer ;
begin
  for I := 0 to FTaskList.Count - 1 do
  begin
    FTaskList.Items[i].DoWork ;
  end;
end;

{ TTaskList }

function TTaskList.Add(AObject: TBaseTask): Integer;
begin
    Result := inherited Add(AObject);
end;

function TTaskList.GetItem(Index: Integer): TBaseTask;
begin
  Result := TBaseTask ( GetItem(Index) ) ;
end;

function TTaskList.Remove(AObject: TBaseTask): Integer;
begin
  Result := inherited Remove(AObject) ;
end;

procedure TTaskList.SetItem(Index: Integer; AObject: TBaseTask);
begin
  SetItem(Index,AObject);
end;

end.
