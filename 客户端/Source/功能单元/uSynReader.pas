unit uSynReader;

interface
uses
  Classes,SysUtils,uTFSystem,ActiveX,Contnrs,IdHTTP,superobject,IniFiles,
  uLCCommon,uBaseWebInterface;
type
  TSynReader = class;
  TDataReader = class
  protected
    m_OnReadComplete: TNotifyEvent;
    m_OnGetParam: TNotifyEvent;
    m_SynReader: TSynReader;
    procedure Notify();
  public
    procedure Read();virtual;abstract;
    property OnReadComplete: TNotifyEvent read m_OnReadComplete write m_OnReadComplete;
    property OnGetParam: TNotifyEvent read m_OnGetParam write m_OnGetParam;
  end;


  TDataReaderList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TDataReader;
    procedure SetItem(Index: Integer; AObject: TDataReader);
  public                 
    property Items[Index: Integer]: TDataReader read GetItem write SetItem; default;
  end;

                  
  TAppVersionReader = class(TDataReader)
  private
    m_URL: string;
    m_ProjectID: string;
    m_ProjectVersion: string;
    procedure ReadParam();
  public
    procedure Read();override;
  end;

  TFingerReader = class(TDataReader)
  private

  public
    procedure Read();override;
  end;


  TSynReader = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_AppPath: string;
    m_Thread: TRunFunctionThread;
    m_OnLoadComplete: TNotifyEvent;
    m_OnGetLocalFinger: TNotifyEvent;
    m_ReaderList: TDataReaderList;
    m_RsLCCommon: TRsLCCommon;
    m_OnLogOut: TOnEventByString;
    procedure ThreadFun();
    function ServerConfig(Section,Ident: string;var Value: string): Boolean;
    function SetServerConfig(Section,Ident,Value: string): Boolean;
    procedure WriteLog(const log: string);
  public
    procedure Execute();
    procedure RegReader(Reader: TDataReader);
    procedure SetConnConfig(ConnConfig: RInterConnConfig);
    property AppPath: string read m_AppPath write m_AppPath;
    property RsLCCommon: TRsLCCommon read m_RsLCCommon;
    property OnLoadComplete: TNotifyEvent read m_OnLoadComplete write m_OnLoadComplete;
    property OnGetLocalFinger: TNotifyEvent read m_OnGetLocalFinger write m_OnGetLocalFinger;
    property OnLogOut: TOnEventByString read m_OnLogOut write m_OnLogOut;
  end;
  
implementation

{ TFingerLoader }

constructor TSynReader.Create;
begin
  m_RsLCCommon := TRsLCCommon.Create('','','');
  m_ReaderList := TDataReaderList.Create;
  m_Thread := TRunFunctionThread.Create(ThreadFun);
end;

destructor TSynReader.Destroy;
begin
  m_Thread.Free;
  m_ReaderList.Free;
  m_RsLCCommon.Free;
  inherited;
end;

procedure TSynReader.Execute;
begin
  m_Thread.Resume;
end;

procedure TSynReader.RegReader(Reader: TDataReader);
begin
  if not m_Thread.Suspended then
    raise Exception.Create('线程已启动，不允许添加新的数据读取对象');
  Reader.m_SynReader := self;
  m_ReaderList.Add(Reader);
end;

function TSynReader.ServerConfig(Section, Ident: string;var Value: string): Boolean;
var
  ErrInfo: string;
begin
  Value := m_RsLCCommon.GetDBSysConfig(Section, Ident, ErrInfo);

  Result := ErrInfo = '';
  if not Result then
  begin
    WriteLog(Format('读取配置信息失败[%s][%s]:',[Section,Ident]) + ErrInfo);
  end;
end;

procedure TSynReader.SetConnConfig(ConnConfig: RInterConnConfig);
begin
  m_RsLCCommon.SetConnConfig(ConnConfig);
end;

function TSynReader.SetServerConfig(Section, Ident, Value: string): Boolean;
var
  Error: string;
begin
  Result := m_RsLCCommon.SetDBSysConfig(Section,Ident,Value,Error);

  if not Result then
  begin
    WriteLog(Format('设置配置信息失败[%s][%s]:',[Section,Ident]) + Error);
  end;
end;

procedure TSynReader.ThreadFun;
var
  I: Integer;
begin
  while not m_Thread.Terminated do
  begin
    for I := 0 to m_ReaderList.Count - 1 do
    begin
      try
        if m_Thread.Terminated then break;

        m_ReaderList.Items[i].Read();
      except
        on E: Exception do
        begin

        end;
      end;
    end;
  end;
end;

procedure TSynReader.WriteLog(const log: string);
begin
  if Assigned(m_OnLogOut) then
    m_OnLogOut(Self.ClassName + ' - ' + log);
end;

{ TDataReader }

procedure TDataReader.Notify;
begin
  if Assigned(m_OnReadComplete) then
    m_OnReadComplete(self);
end;


{ TFingerReader }

procedure TFingerReader.Read;
var
  FingerLibID: string;
begin
  if not m_SynReader.ServerConfig('SysConfig','ServerFingerLibGUID',FingerLibID) then Exit;
  
  
  if FingerLibID = '' then
  begin
    FingerLibID := NewGUID;
    if not m_SynReader.SetServerConfig('SysConfig','ServerFingerLibGUID',FingerLibID) then
      FingerLibID := '';
  end;
  
//  if GlobalDM.LocalFingerLibGUID <> FingerLibID then
//  begin
//    statusUpdate.Caption := '本地指纹库正在更新';
//    Application.ProcessMessages;
//    GlobalDM.SaveLocalFingerTemplates;
//    statusUpdate.Caption := '本地指纹库已更新';
//    Application.ProcessMessages;
//  end;
end;

{ TAppVersionReader }

procedure TAppVersionReader.Read;
var
  IdHTTP: TIdHTTP;
  iJSON: ISuperObject;
  strUrl, strUpdateInfo: string;
begin
  ReadParam();
  strUrl := m_URL + Format('?pid=%s&version=%s', [m_ProjectID, m_ProjectVersion]);
    
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.Request.Pragma := 'no-cache';
    IdHTTP.Request.CacheControl := 'no-cache';
    IdHTTP.Request.Connection := 'close';
    IdHTTP.ReadTimeout := 1000;
    IdHTTP.ConnectTimeout := 1000;
    strUpdateInfo := IdHTTP.Get(strUrl);
    strUpdateInfo := Utf8ToAnsi(strUpdateInfo);
    IdHTTP.Disconnect;
  finally
    IdHTTP.Free;
  end;
  if strUpdateInfo = '' then exit;

  iJSON := SO(strUpdateInfo);
  if iJSON.B['NeedUpdate'] then
  begin
    m_SynReader.m_Thread.Synchronize(m_SynReader.m_Thread,Notify);
  end;
  
  iJSON := nil;
end;

function TDataReaderList.GetItem(Index: Integer): TDataReader;
begin
  result := TDataReader(inherited GetItem(Index));
end;
procedure TDataReaderList.SetItem(Index: Integer; AObject: TDataReader);
begin
  Inherited SetItem(Index,AObject);
end;       
procedure TAppVersionReader.ReadParam;
var
  Ini: TIniFile;
begin
  if FileExists(m_SynReader.AppPath + 'Update.ini') then
  begin
    Ini := TIniFile.Create(m_SynReader.AppPath + 'Update.ini');
    try                  
      m_URL := Trim(Ini.ReadString('SysConfig', 'GetNewVersionUrl', ''));
      m_ProjectID := Trim(Ini.ReadString('SysConfig', 'ProjectID', ''));
      m_ProjectVersion := Trim(Ini.ReadString('SysConfig', 'ProjectVersion', ''));
    finally
      Ini.Free();
    end;
  end;
end;

end.
