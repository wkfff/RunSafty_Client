unit uFtpConnect;

interface
uses Classes,IniFiles,IdFTP,SysUtils,Forms,Dialogs, uFTPTransportControl,uTFSystem,
idftplist,StrUtils,WINDOWS;
type
////////////////////////////////////////////////////////////////////////////////
// 类名：TFTPConnect
// 功能：FTP通讯
////////////////////////////////////////////////////////////////////////////////
  TFTPConnect = class
  public
    constructor Create();
    destructor Destroy; override;
  private
    //m_FTPCon: TIdFTP;
    m_FTPCon: TFTPTransportControl;
    m_strHost: string;
    m_nPort: Integer;
    m_strUserName: string;
    m_strPassword: string;
    m_strPath: string;
  public
    function SetFTPConfig(): Boolean;
    function TestConnect(): Boolean;
    function UpLoad(FileName: string;bPicSound: Boolean): Boolean;
    function DownLoad(FileName: string;bPicSound: Boolean): Boolean;
    function ClearFiles(bDrink: Boolean;bCall: Boolean;dtEndDate: TDateTime): Boolean;
  published
    property strHost: string read m_strHost write m_strHost;
    property nPort: Integer read m_nPort write m_nPort;
    property strUserName: string read m_strUserName write m_strUserName;
    property strPassword: string read m_strPassword write m_strPassword;
    property strPath: string read m_strPath write m_strPath;
  end;
implementation

{ TFTPConnect }

function TFTPConnect.ClearFiles(bDrink: Boolean;bCall: Boolean;dtEndDate: TDateTime): Boolean;
var
  IdFTPListItems: TIdFTPListItems;
  i,j: Integer;
  filename,strfile: string;
begin
  if bDrink then
  begin
    IdFTPListItems := TIdFTPListItems.Create;
    try
      strfile := '';
      m_FTPCon.GetDirectoryListing('picture',IdFTPListItems);
      for I := 0 to IdFTPListItems.Count - 1 do
      begin
        if IdFTPListItems[i].ItemType = ditDirectory then Continue;
        filename := IdFTPListItems[i].FileName;
        for j := 1 to Length(filename) do
        begin
          if filename[j] = '.' then Break
          else strfile := strfile + filename[j];
        end;
        strfile := RightStr(strfile,14);
        strfile := LeftStr(strfile,8);
        try
          if StrToInt(strfile) < StrToInt(FormatDateTime('yyyymmdd',dtEndDate)) then
            m_FTPCon.DeleteFile(IdFTPListItems[i].filename,'picture');
        except
          Continue;
        end;
      end;
    finally
      IdFTPListItems.Free;
    end;
  end;
  if bCall then
  begin
    IdFTPListItems := TIdFTPListItems.Create;
    try
      strfile := '';

      m_FTPCon.GetDirectoryListing('callrecord',IdFTPListItems);
      for I := 0 to IdFTPListItems.Count - 1 do
      begin
        if IdFTPListItems[i].ItemType = ditDirectory then Continue;
        filename := IdFTPListItems[i].FileName;
        for j := 1 to Length(filename) do
        begin
          if filename[j] = '.' then Break
          else strfile := strfile + filename[j];
        end;
        strfile := RightStr(strfile,12);
        strfile := LeftStr(strfile,8);
        try
          if StrToInt(strfile) < StrToInt(FormatDateTime('yyyymmdd',dtEndDate)) then
            m_FTPCon.DeleteFile(IdFTPListItems[i].filename,'callrecord');
        except
          Continue;
        end;
      end;
    finally
      IdFTPListItems.Free;
    end;
  end;
  Result := True;
end;

constructor TFTPConnect.Create;
begin
  m_FTPCon := TFTPTransportControl.Create(nil);
end;

destructor TFTPConnect.Destroy;
begin
  FreeAndNil(m_ftpcon);
  inherited;
end;

function TFTPConnect.DownLoad(FileName: string;bPicSound: Boolean): Boolean;
var
  LocalFileName,ServerPath: string;
begin
  Result := False;
  LocalFileName := ExtractFilePath(Application.ExeName) + '\temp\' + FileName;
  if bPicSound then ServerPath := 'picture'
  else ServerPath := 'callrecord';
  if m_FTPCon.Download(FileName,LocalFileName,ServerPath) then
    Result := True;
end;

function TFTPConnect.SetFTPConfig(): Boolean;
var
  ini: TIniFile;
  FTPConfig: RFTPConfig;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    strHost := ini.ReadString('FTP','Host','127.0.0.1');
    nPort := ini.ReadInteger('FTP','Port',21);
    strUserName := ini.ReadString('FTP','UserName','');
    strPassword := ini.ReadString('FTP','Password','');
    strPath := ini.ReadString('FTP','Path','');
    FTPConfig.strHost := m_strHost;
    FTPConfig.strUserName := m_strUserName;
    FTPConfig.strPassWord := m_strPassword;
    FTPConfig.strDir := m_strPath;
    FTPConfig.nPort := m_nPort;
    m_FTPCon.FTPConfig := FTPConfig;
    Result := True;
  finally
    ini.Free;
  end;
end;

function TFTPConnect.TestConnect(): Boolean;
var
  FileName,LocalFileName: string;
begin
  Result := False;
  FileName := 'config.ini';
  LocalFileName := ExtractFilePath(Application.ExeName) + FileName;
  if m_FTPCon.Upload(LocalFileName,FileName) then Result := True;
end;

function TFTPConnect.UpLoad(FileName: string;bPicSound: Boolean): Boolean;
var
  LocalFileName,ServerPath: string;
begin
  Result := False;
  if bPicSound then
  begin
    LocalFileName := ExtractFilePath(Application.ExeName) + '\upload\picture\' + FileName;
    ServerPath := 'picture';
  end
  else
  begin
    LocalFileName := ExtractFilePath(Application.ExeName) + '\upload\callrecord\' + FileName;
    ServerPath := 'callrecord';
  end;   
  if m_FTPCon.Upload(LocalFileName,FileName,ServerPath) then
  begin
    Sysutils.DeleteFile(LocalFileName);
    Result := True;
  end;
end;

end.
