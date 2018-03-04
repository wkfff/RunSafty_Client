unit uRFTCPSockComm;

interface
uses
  uRFSocket,WinSock,Classes,Windows,SysUtils,Messages;
const
  WM_COMMERROR = WM_USER + 1001;
type

  {���ս��}
  TCommResult = (TCR_SUCESS{�շ��ɹ�},TCR_TIMEOUT{�շ���ʱ},TCR_CANCEL{ȡ���շ�},
    TCR_CONERROR{���ӳ���} ,TCR_RECVERROR{���ճ���} ,TRC_SENDERROR{���ͳ���} );



  //////////////////////////////////////////////////////////////////////////////
  ///���� :TTCPStrCommBlock
  ///����:TCP��ʽ�ַ�������ͨ����
  //////////////////////////////////////////////////////////////////////////////
  TTCPStrCommBlock = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {����:�����豸}
    function Connect(strIP:string;nPort:Integer):Boolean;
    {����:�Ƿ������ݵ���}
    function WaitRecvStr(var bCancelWait:Boolean;out strRecv:string;nWaitSecond:Integer = 0):TCommResult;
    {����:���Ͳ������ַ���}
    function SendRecvStr(var bCancelWait:Boolean;strSend:string ;out strRecv:string;nWaitSecond:Integer = 0):TCommResult;
  private
     //tcp�ͻ���
    m_TCPClient:TRFTCPClient;
    //�շ�������
    m_StrHandler:TRFTCPIOStrHandler;
    //IOģ��
    m_IOMode_Block:TRFIOMode_Block;
  public
    property TCPClient:TRFTCPClient read m_TCPClient write m_TCPClient;
  end;

  //ͨ���쳣�ص�
  TOnCommErrorEvent = procedure (TCPCommObj: TTCPStrCommBlock;nErrCode:Integer);

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTCPCommThread
  /// ����:TCPͨ���̻߳���
  //////////////////////////////////////////////////////////////////////////////
  
  TTCPCommThread = class(TThread)
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy();override;
  public
    {����:�˳�}
    procedure Terminate(); virtual;
  protected
    {����:�����û���Ϣ}
    function DealUserMsg(var Msg:TMessage):Boolean; virtual;
    {����:�����û���Ϣ}
    function PostMsg(msg:Cardinal;wparam:Integer;lparam:Integer):Boolean;
    {����:����ͨ�Ŵ�����Ϣ}
    function PostCommErrMsg():Boolean;
  private
    {��Ϣ������}
    procedure WndMethod(var Msg: TMessage);
  protected
    //�Ƿ�ȡ��ͨ��
    bCancelComm:Boolean;
  private
    //��Ϣ���
    m_MsgWnd:THandle;
     //�½�����ͨ�Ŷ���
    m_TCPComm:TTCPStrCommBlock;
    //ͨ�Ŵ���
    m_OnCommErrorEvent:TOnCommErrorEvent;
  public
    property TCPComm:TTCPStrCommBlock read m_TCPComm write m_TCPComm;
    //ͨ�Ŵ���
    property OnCommError:TOnCommErrorEvent read m_OnCommErrorEvent write m_OnCommErrorEvent;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTCPListenThread
  /// ����:����������
  //////////////////////////////////////////////////////////////////////////////
  TTCPListenThread = class(TTCPCommThread)
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy();override;
  public
    {����:��������}
    function StartListen(strIP:string;nPort:Integer;nListenQue:Integer):Boolean;
    {����:ֹͣ����}
    procedure StopListen();
  protected
    procedure Execute; override;
    {����:�������Ӳ���֤}
    procedure DoAccept(nSock:TSocket);
    {����:�����û���Ϣ}
    function DealUserMsg(var Msg:TMessage):Boolean;override;
  private
    //��������
    m_Listener:TRFTCPListener;
    //�����¼�
    m_OnAccpetEvent:TThreadMethod;
    //��������������
    m_StrRequest:string;
  public
    property OnAccpetEvent:TThreadMethod read m_OnAccpetEvent write m_OnAccpetEvent;

    property StrRequest:string read m_StrRequest write m_StrRequest ;
  end;

implementation

{ TTCPStrCommBlock }

function TTCPStrCommBlock.Connect(strIP: string; nPort: Integer): Boolean;
var
  nSock:Integer;
begin
  result := False;
  if m_TCPClient.RFSock.bActive then
  begin
    result := True;
    Exit;
  end;
  Self.m_TCPClient.RFCon.strIP := strIP;
  Self.m_TCPClient.RFCon.nPort := nPort;
  nSock := self.m_TCPClient.RFCon.Connect(5);
  if nSock <> INVALID_SOCKET then
  begin
    m_TCPClient.RFSock.Sock := nSock;
    m_TCPClient.RFSock.bActive := True;
    Result := True;
  end
end;

constructor TTCPStrCommBlock.Create;
begin
  m_TCPClient:=TRFTCPClient.Create;
  m_StrHandler:=TRFTCPIOStrHandler.Create;
  m_TCPClient.IOHandler := m_StrHandler;
  m_IOMode_Block:=TRFIOMode_Block.Create;
  m_TCPClient.IOMode := m_IOMode_Block;
end;

destructor TTCPStrCommBlock.Destroy;
begin
  m_TCPClient.Free;
  m_IOMode_Block.Free;
  m_StrHandler.Free;
  inherited;
end;

function TTCPStrCommBlock.SendRecvStr(var bCancelWait:Boolean;strSend: string;
  out strRecv: string;nWaitSecond:Integer = 0): TCommResult;
var
  nStart:Integer;
  bCanRecv:Boolean;
begin
  m_StrHandler.SendStr := strSend;
  if m_TCPClient.StartSend = False then
  begin
    result := TRC_SENDERROR;
    Exit;
  end;

  nStart:=GetTickCount;
  while True do
  begin
    bCanRecv := TCPClient.CanRecv();
    if bCanRecv = True then Break;
    if bCancelWait = True then
    begin
      result := TCR_CANCEL;
      Break;
    end;
    if bCanRecv = False then
    begin
      if nWaitSecond = 0 then
        Continue;
      if (GetTickCount - nStart) >= nWaitSecond * 1000 then
      begin
        Result := TCR_TIMEOUT;
        Exit;
      end;
    end;
  end;
  if TCPClient.StartRecv = False then
  begin
    Result := TCR_RECVERROR;
    Exit;
  end;
  strRecv := m_StrHandler.RecvStr;

  Result := TCR_SUCESS;
end;

function TTCPStrCommBlock.WaitRecvStr(var bCancelWait:Boolean;out strRecv: string;nWaitSecond:Integer = 0): TCommResult;
var
  bCanRecv:Boolean;
  nStart:Integer;
begin
  nStart := GetTickCount;
  while True do
  begin
    bCanRecv := TCPClient.CanRecv();
    if bCanRecv = True then
    begin
      if TCPClient.StartRecv = False then
      begin
        result := TCR_RECVERROR;
        Exit;
      end;
      strRecv := m_StrHandler.RecvStr;
      result := TCR_SUCESS;
      Exit;
    end;
    if bCancelWait = True then
    begin
      result := TCR_CANCEL;
      Exit;
    end;
    if nWaitSecond <> 0 then
    begin
      if GetTickCount - nStart > nWaitSecond * 1000 then
      begin
        result := TCR_TIMEOUT;
        Exit;
      end;
    end;
  end;
end;


{ TListenThread }

constructor TTCPListenThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  m_Listener := TRFTCPListener.Create;
end;

function TTCPListenThread.DealUserMsg(var Msg: TMessage): Boolean;
begin
  result := False;
end;

destructor TTCPListenThread.Destroy;
begin
  m_Listener.Free;

  inherited;
end;

procedure TTCPListenThread.DoAccept(nSock: TSocket);
var
  strRecv:string;
begin
  m_TCPComm := TTCPStrCommBlock.Create;
  m_TCPComm.TCPClient.RFSock.Sock := nSock;

  if m_TCPComm.WaitRecvStr(Self.bCancelComm ,strRecv,2) <> TCR_SUCESS then
  begin
    FreeAndNil(m_TCPComm);
    Exit;
  end;
  self.m_StrRequest := strRecv;
  Synchronize(self,m_OnAccpetEvent);
end;

procedure TTCPListenThread.Execute;
var
  nSock:Integer;
begin
  inherited;
  while not self.Terminated do
  begin
    nSock := m_Listener.Accept();
    if nSock <> INVALID_SOCKET then
    begin
      DoAccept(nSock);
    end;
  end;
end;

function TTCPListenThread.StartListen(strIP:string;nPort:Integer;nListenQue:Integer): Boolean;
begin
  m_Listener.nListenQueue := nListenQue;
  result := m_Listener.StartListen(strIP,nPort);
end;

procedure TTCPListenThread.StopListen;
begin
  Self.DoTerminate;
  Self.WaitFor;
  m_Listener.StopListen;
end;

{ TTCPCommThread }

constructor TTCPCommThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  m_MsgWnd := AllocateHWnd(WndMethod);
  bCancelComm := False;
end;

function TTCPCommThread.DealUserMsg(var Msg: TMessage): Boolean;
begin
  result := False;
  case Msg.Msg of
  WM_COMMERROR :
  begin
    if Assigned(self.m_OnCommErrorEvent) then
    begin
      m_OnCommErrorEvent(Self.m_TCPComm,Msg.WParam);
      Result := True;
    end;
  end;
  end;
end;

destructor TTCPCommThread.Destroy;
begin
  DeallocateHWnd(m_MsgWnd);
  if m_TCPComm <> nil then
    FreeAndNil(m_TCPComm);
end;

function TTCPCommThread.PostCommErrMsg: Boolean;
begin
  PostMsg(WM_COMMERROR,GetLastError,0);
end;

function TTCPCommThread.PostMsg(msg:Cardinal;wparam:Integer;lparam:Integer): Boolean;
begin
  Result := PostMessage(self.m_MsgWnd,msg,wparam,lparam);
end;

procedure TTCPCommThread.Terminate;
begin
  Self.bCancelComm := True;
  inherited Terminate;
end;

procedure TTCPCommThread.WndMethod(var Msg: TMessage);
begin
  if Self.DealUserMsg(msg) = True then Exit;
  Msg.Result := DefWindowProc(self.m_MsgWnd, Msg.Msg, Msg.wParam, Msg.lParam);
end;

end.
