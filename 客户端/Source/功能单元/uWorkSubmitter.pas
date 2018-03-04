unit uWorkSubmitter;

interface
uses
  Classes,SysUtils,ADODB,uRsThreadTask,uLocalConn,uOffLine;
type
  TWorkSubmitter = class
  public
    constructor Create();
    destructor Destroy;override;
  private
    m_Active: Boolean;                                           
    m_ThreadHost: TCircleThreadHost;
    m_Conn: TADOConnection;
    procedure ThreadFun(Sender: TObject);
    procedure SubmitData(OffLineData: TOffLineData);
  public
    procedure Start();
    procedure Stop();
  end;

    
implementation

{ TBWSubmitter }

constructor TWorkSubmitter.Create;
begin
  m_Conn := TADOConnection.Create(nil);
  m_Conn.LoginPrompt := False;
  m_ThreadHost := TCircleThreadHost.Create(ThreadFun);
  m_ThreadHost.Resume();
end;

destructor TWorkSubmitter.Destroy;
begin
  m_Active := False;
  m_ThreadHost.Free;
  m_Conn.Free;
  inherited;
end;

procedure TWorkSubmitter.Start;
begin
  m_Active := True;
end;

procedure TWorkSubmitter.Stop;
begin
  m_Active := False;
end;

procedure TWorkSubmitter.SubmitData(OffLineData: TOffLineData);
begin
  case OffLineData.WorkType of
    2:;
    3:;
    4:;
    5:;  
  end;
end;

procedure TWorkSubmitter.ThreadFun(Sender: TObject);
var
  OffLineData: TOffLineData; 
begin
  OffLineData := TOffLineData.Create;
  try
    while not TCircleThreadHost(Sender).Terminated do
    begin
      TCircleThreadHost(Sender).Delay(10000);

      if m_Active then
      begin
        if TDBOffLineWorkData.GetTop1(OffLineData) then
        begin
          SubmitData(OffLineData);
          TDBOffLineWorkData.Del(OffLineData.ID);
        end;
        
      end;
    end;
  finally
    OffLineData.Free;
  end;

end;

end.
