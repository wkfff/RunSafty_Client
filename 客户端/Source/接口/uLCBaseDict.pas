unit uLCBaseDict;

interface
uses
  Classes,SysUtils,uBaseWebInterface,
  uLCDict_Station,
  uLCDict_TrainJiaoLu,
  uLCDict_TrainmanJiaoLu,
  uLCDict_Jwd,
  uLCDict_WorkShop,
  uLCDict_GuideGroup,
  uLCDict_WorkPlan,
  uLCDict_System,
  uLCDict_Site,
  uLCDict_TrainType,
  uLCDict_EmbeddedPage,
  uLCDict_GanBu,
  uLCDict_Department;
type
  TRsLCBaseDict = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_LCJwd: TRsLCJwd;
    m_LCWorkShop: TRsLCWorkShop;
    m_LCGuideGroup: TRsLCGuideGroup;
    m_LCWorkPlan: TRsLCWorkPlan;
    m_LCStation: TRsLCStation;
    m_LCTrainJiaolu: TRsLCTrainJiaolu;
    m_LCTrainmanJiaolu: TRsLCTrainmanJiaolu;
    m_LCSysDict: TRsLCSystemDict;
    m_LCSite: TRsLCSite;
    m_LCTrainType: TRsLCTrainType;
    m_LCEmbeddedPage: TRsLCEmbeddedPage;
    m_LCGanBu: TRsLCGanBu;
    m_LCDepartment: TRsLCDepartment;
  public
    procedure SetConnConfig(ConnConfig: RInterConnConfig);
    property LCJwd: TRsLCJwd read m_LCJwd;
    property LCWorkShop: TRsLCWorkShop read m_LCWorkShop;
    property LCGuideGroup: TRsLCGuideGroup read m_LCGuideGroup;
    property LCWorkPlan: TRsLCWorkPlan read m_LCWorkPlan;
    property LCStation: TRsLCStation read m_LCStation;
    property LCTrainJiaolu: TRsLCTrainJiaolu read m_LCTrainJiaolu;
    property LCTrainmanJiaolu: TRsLCTrainmanJiaolu read m_LCTrainmanJiaolu;
    property LCSysDict: TRsLCSystemDict read m_LCSysDict;
    property LCSite: TRsLCSite read m_LCSite;
    property LCTrainType: TRsLCTrainType read m_LCTrainType;
    property LCEmbeddedPage: TRsLCEmbeddedPage read m_LCEmbeddedPage;
    property LCGanBu: TRsLCGanBu read m_LCGanBu;
    property LCDepartment: TRsLCDepartment read m_LCDepartment; 
  end;
function RsLCBaseDict: TRsLCBaseDict;
implementation

uses uGlobalDM;
var
  g_RsLCBaseDict: TRsLCBaseDict;
  
function RsLCBaseDict: TRsLCBaseDict;
begin
  if not Assigned(g_RsLCBaseDict) then
    g_RsLCBaseDict := TRsLCBaseDict.Create;

  g_RsLCBaseDict.SetConnConfig(GlobalDM.HttpConnConfig);
  Result := g_RsLCBaseDict;
end;


{ TRsLCBaseDict }

constructor TRsLCBaseDict.Create;
begin
  m_LCStation := TRsLCStation.Create('','','');
  m_LCTrainJiaolu := TRsLCTrainJiaolu.Create('','','');
  m_LCTrainmanJiaolu := TRsLCTrainmanJiaolu.Create('','','');
  m_LCJwd := TRsLCJwd.Create('','','');
  m_LCWorkShop := TRsLCWorkShop.Create('','','');
  m_LCGuideGroup := TRsLCGuideGroup.Create('','','');
  m_LCWorkPlan := TRsLCWorkPlan.Create('','','');
  m_LCSysDict := TRsLCSystemDict.Create('','','');
  m_LCSite := TRsLCSite.Create('','','');
  m_LCTrainType := TRsLCTrainType.Create('','','');
  m_LCEmbeddedPage := TRsLCEmbeddedPage.Create('','','');
  m_LCGanBu := TRsLCGanBu.Create('','','');
  m_LCDepartment := TRsLCDepartment.Create('','','');
end;

destructor TRsLCBaseDict.Destroy;
begin
  m_LCJwd.Free;
  m_LCWorkShop.Free;
  m_LCGuideGroup.Free;
  m_LCWorkPlan.Free;
  m_LCStation.Free;
  m_LCTrainJiaolu.Free;
  m_LCTrainmanJiaolu.Free;
  m_LCSite.Free;
  m_LCSysDict.Free;
  m_LCTrainType.Free;
  m_LCEmbeddedPage.Free;
  m_LCGanBu.Free;
  m_LCDepartment.Free;
  inherited;
end;

procedure TRsLCBaseDict.SetConnConfig(ConnConfig: RInterConnConfig);
begin
  m_LCStation.SetConnConfig(ConnConfig);
  m_LCTrainJiaolu.SetConnConfig(ConnConfig);
  m_LCTrainmanJiaolu.SetConnConfig(ConnConfig);
  m_LCWorkShop.SetConnConfig(ConnConfig);
  m_LCJwd.SetConnConfig(ConnConfig);
  m_LCGuideGroup.SetConnConfig(ConnConfig);
  m_LCWorkPlan.SetConnConfig(ConnConfig);
  m_LCSysDict.SetConnConfig(ConnConfig);
  m_LCSite.SetConnConfig(ConnConfig);
  m_LCTrainType.SetConnConfig(ConnConfig);
  m_LCEmbeddedPage.SetConnConfig(ConnConfig);
  m_LCGanBu.SetConnConfig(ConnConfig);;
  m_LCDepartment.SetConnConfig(ConnConfig);
end;

initialization

finalization
  if Assigned(g_RsLCBaseDict) then
    FreeAndNil(g_RsLCBaseDict);
end.
