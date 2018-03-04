unit uThreadUploadSign;

interface

uses

  Classes,SysUtils,Forms,Windows,DB,ADODB,ActiveX,uExchangeSignInfo,uUploadSignInfo;

type
  TThreadUploadSign = class(TThread)
  public
    constructor Create(DutyUserGUID, SiteGUID: string);
    destructor Destroy();override;
  public
    procedure   ExitThread();
    function    InitData():Boolean;
    procedure   SetSleepTime(Interval:Integer);
  private
    //�ش�����
    procedure   UploadData();
  private
    { Private declarations }
    //���ݻش�(��Ԣ����Ԣ��Ϣ)
    m_obUpload:TUploadSignInfo;
    //�����ϴ�ʱ����
    m_nInterval:Integer;
    //�˳��¼�
    m_hExitEvent : Cardinal ;
    //������CON,
    m_conServer : TADOConnection ;
    //��������CON
    m_conLocal : TADOConnection ;
  protected
    procedure Execute; override;
  end;

implementation

uses
  uGlobalDM;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TThreadUploadSign.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TThreadUploadSign }

constructor TThreadUploadSign.Create(DutyUserGUID, SiteGUID: string);
begin
  inherited Create(True);

  m_conServer := TADOConnection.Create(nil);
  m_conLocal := TADOConnection.Create(nil);

  m_hExitEvent := CreateEvent(nil,False,False,nil);
  m_obUpload := TUploadSignInfo.Create;
  m_obUpload.SetDutyUser(DutyUserGUID,SiteGUID);
  m_nInterval := 10 ;
end;

destructor TThreadUploadSign.Destroy;
begin
  m_obUpload.Free ;
  
  if m_hExitEvent <> 0 then
    CloseHandle(m_hExitEvent);

  FreeAndNil(m_conServer);
  FreeAndNil(m_conLocal);

  inherited;
end;

procedure TThreadUploadSign.Execute;
begin
  { Place thread code here }
  CoInitialize(nil);
  while True do
  begin
    //���ȴ��¼�
    if WaitForSingleObject(m_hExitEvent, m_nInterval * 1000 ) = WAIT_OBJECT_0 then
      Exit
    else
      UploadData;
  end;
end;

procedure TThreadUploadSign.ExitThread;
begin
  SetEvent(m_hExitEvent);
  Sleep(1000);
  CloseHandle(m_hExitEvent);
  m_hExitEvent := 0 ;
end;

function TThreadUploadSign.InitData:Boolean;
var
  strDatabase : string;
  strConnection:string;
begin
  Result := False ;
  with m_conServer do
  begin
    LoginPrompt := False ;
    KeepConnection := True ;
    ConnectionString := GlobalDM.m_SQLConfig.ConnString;
    try
      Connected := true;
    except
      Exit;
    end;
  end;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'RunSafty.mdb';
    strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  with m_conLocal do
  begin
    LoginPrompt := False ;
    KeepConnection := True ;
    try
      Close;
      ConnectionString := strConnection;
      Open;
    except
    end;
    if  Connected then
      result := true;
  end;

  m_obUpload.SetConnect(m_conServer,m_conLocal,nil,nil);
end;


procedure TThreadUploadSign.SetSleepTime(Interval: Integer);
begin
  if ( Interval < 0) then
    Interval := 10 ;
  m_nInterval := Interval ;
end;


procedure TThreadUploadSign.UploadData;
var
  nCount,nSuccess:Integer;
begin
  nCount := 0;
  nSuccess := 0;

  try
    nSuccess := m_obUpload.UploadSignInInfo(nCount) ;
    nSuccess := m_obUpload.UploadSignOutInfo(nCount) ;
    //nSuccess := m_obUpload.UploadLeaderInspectInfo(nCount) ;
  except
    on e:Exception do
    begin
      GlobalDM.LogManage.InsertLog('�ش����ݴ���:' + e.Message );
    end;
  end;
end;

end.
