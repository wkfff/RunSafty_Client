unit uGlobalDM;

interface

uses
  SysUtils, Classes,uBaseWebInterface,uLLCommonFun,Forms,uHttpWebAPI;

type
  TTestMethod = procedure of object;
  TGlobalDM = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    m_URL: string;
    m_ClientID: string;
    m_SiteID: string;
    m_AppPath: string;
    m_WebAPIUtils: TWebAPIUtils;
  public
    { Public declarations }
    function HttpConnConfig: RInterConnConfig;
    procedure InitSystem();
    property AppPath: string read m_AppPath;
    property WebAPIUtils: TWebAPIUtils read m_WebAPIUtils;
  end;

var
  GlobalDM: TGlobalDM;

implementation

{$R *.dfm}

{ TGlobalDM }

procedure TGlobalDM.DataModuleCreate(Sender: TObject);
begin
  m_WebAPIUtils := TWebAPIUtils.Create;
end;

procedure TGlobalDM.DataModuleDestroy(Sender: TObject);
begin
  m_WebAPIUtils.Free;
end;

function TGlobalDM.HttpConnConfig: RInterConnConfig;
begin
  Result.URL := m_URL;
  Result.ClientID := m_ClientID;
  Result.SiteID := m_SiteID;
end;

procedure TGlobalDM.InitSystem;
begin
  m_AppPath := ExtractFilePath(Application.ExeName);

  m_URL := ReadIniFileString(m_AppPath + 'Config.ini','HttpConfig','URL','');
  m_ClientID := ReadIniFileString(m_AppPath + 'Config.ini','HttpConfig','ClientID','');
  m_SiteID := ReadIniFileString(m_AppPath + 'Config.ini','HttpConfig','SiteID','');

  m_WebAPIUtils.Host := ReadIniFileString(m_AppPath + 'Config.ini','HttpConfig','Host','');
  m_WebAPIUtils.Port := ReadIniFileInt(m_AppPath + 'Config.ini','HttpConfig','Port',80); 
end;

end.
