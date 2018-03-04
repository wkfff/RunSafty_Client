unit uUDPControl; //闫

interface
uses Classes, IdBaseComponent, IdComponent, IdUDPBase,IdUDPServer, IniFiles,
 IdUDPClient,IdSocketHandle,IdGlobal,Windows,Messages,Dialogs,SysUtils,Forms;
type
  TOnJiaobanCommand = procedure(strCommand : String) of object;
////////////////////////////////////////////////////////////////////////////////
//类名： TUDPControl
//功能： UDP通讯
////////////////////////////////////////////////////////////////////////////////
  TUDPControl = Class
  public
    constructor Create();
    destructor Destroy; override;
  private
    m_nLocalPort : Integer;//本机开放UDP端口
    m_strDestHost : String;//目标地址
    m_nDestPort : Integer;//目标端口号
    m_IdUDPClient : TIdUDPClient;//UDP客户端
    m_IdUDPServer : TIdUDPServer;//UDP服务器
    m_OnJiaobanCommand : TOnJiaobanCommand;
  private
    procedure OnIdUDPServer1UDPRead(Sender: TObject; AData: TBytes;
        ABinding: TIdSocketHandle);
  protected

  public
    procedure SendCommand(strData : String);
    function OpenPort():Boolean;
    function TestConnect(): Boolean;
  published
    property DestHost : String read m_strDestHost write m_strDestHost;
    property DestPort : Integer read m_nDestPort write m_nDestPort;
    property LocalPort : Integer read m_nLocalPort write m_nLocalPort;
    property OnJiaobanCommand : TOnJiaobanCommand read m_OnJiaobanCommand write
      m_OnJiaobanCommand;
  end;

implementation

{ TUDPControl }

constructor TUDPControl.Create;
var
  ini: tinifile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  try
    LocalPort := ini.ReadInteger('UDP','LocalPort',9089);
    DestPort := ini.ReadInteger('UDP','HostPort',9089);
    DestHost := ini.ReadString('UDP','Host','127.0.0.1');
  finally
    ini.Free;
  end;
  m_IdUDPClient := TIdUDPClient.Create(nil);
  m_IdUDPServer := TIdUDPServer.Create(nil);
  m_IdUDPServer.OnUDPRead := OnIdUDPServer1UDPRead;
end;

destructor TUDPControl.Destroy;
begin
  m_IdUDPClient.Active := False;
  m_IdUDPClient.Free;
  m_IdUDPServer.Active := False;
  m_IdUDPServer.Free;
  inherited;
end;

procedure TUDPControl.OnIdUDPServer1UDPRead(Sender: TObject; AData: TBytes;
  ABinding: TIdSocketHandle);
var
  strCommand : String;
begin
  strCommand := BytesToString(AData);
  OnJiaobanCommand(strCommand);
end;
function TUDPControl.OpenPort():Boolean;
begin
  try
    m_IdUDPClient.Host := m_strDestHost;
    m_IdUDPClient.Port := m_nDestPort;
    m_IdUDPServer.DefaultPort := m_nLocalPort;
    if not m_IdUDPClient.Active then m_IdUDPClient.Active := True;
    if not m_IdUDPServer.Active then m_IdUDPServer.Active := True;
    Result := True;
  except
    on e : exception do
      Result := False;
  end;
end;

procedure TUDPControl.SendCommand(strData: String);
begin
  m_IdUDPClient.Send(m_strDestHost,m_nDestPort,strData);
end;
function TUDPControl.TestConnect: Boolean;
begin
  if m_IdUDPClient.Active and m_IdUDPServer.Active then
  begin
    Result := True;
    Exit;
  end
  else
  try
    m_IdUDPClient.Active := True;
    m_IdUDPServer.Active := True;
    Result := True;
  except
    on e : exception do
      Result := False;
  end;  
end;

end.

