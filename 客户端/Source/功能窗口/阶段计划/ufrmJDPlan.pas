unit ufrmJDPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, RzTabs, uFrameJDPlan, Menus,uLCJDPlan, Buttons,
  ExtCtrls, RzPanel,DateUtils,uFrmRegionFilter, RzCommon, RzButton, RzRadChk,
  StdCtrls, ActnList;
type
  TNotifyPlanCreate = procedure of object;

  TFrmJDPlan = class(TForm)
    PageControl_Section: TRzPageControl;
    RzPanel1: TRzPanel;
    tmrRefreshPlan: TTimer;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzFrameController1: TRzFrameController;
    RzPanel2: TRzPanel;
    chkAutoRefresh: TRzCheckBox;
    RzPanel3: TRzPanel;
    SpeedButton1: TSpeedButton;
    btnFind: TButton;
    ActionList1: TActionList;
    actF2: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tmrRefreshPlanTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure chkAutoRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actF2Execute(Sender: TObject);
  private
    { Private declarations }
    m_JDPlanList: TJDPlanList;
    m_LCJDPlan: TLCJDPlan;
    m_Frames: TList;
    m_JLID: string;
    m_OnCreateJDPlan: TNotifyPlanCreate;
    m_Sections: TTMISSectionList;
    m_QueryTime: TDateTime;
    procedure CreateSectionTab();
    procedure ConfirmPlan(train_id: string);
    procedure CreateTrainPlan(train_id: string;plan: TJDPlan;var planid: string);
    procedure SetJL(const Value: string);
    procedure FillPlans();
    procedure SetQueryTime(const Value: TDateTime);
    function FindJDPlan(const train_id: string): TJDPlan;
    procedure SearchPlan;
  public
    { Public declarations }
    procedure RefreshPlan();
    function PlanInJDPlanLst(const planid: string): Boolean;
    procedure Init;
    property JLID: string read m_JLID write SetJL;
    property PlanQueryTime: TDateTime write SetQueryTime;
    property OnCreateJDPlan: TNotifyPlanCreate read m_OnCreateJDPlan write m_OnCreateJDPlan;
  end;

implementation

uses uGlobalDM,uFrmFindJDPlan,ufrmFindJDPlanFromList;



{$R *.dfm}

{ TFrmJDPlan }

procedure TFrmJDPlan.actF2Execute(Sender: TObject);
begin
  SearchPlan;
end;

procedure TFrmJDPlan.chkAutoRefreshClick(Sender: TObject);
begin
  tmrRefreshPlan.Enabled := chkAutoRefresh.Checked;
end;

procedure TFrmJDPlan.ConfirmPlan(train_id: string);
begin
  m_LCJDPlan.ConfirmPlan(train_id);
end;

procedure TFrmJDPlan.CreateSectionTab;
var
  I: Integer;
  Sheet: TRzTabSheet;
  FrameJDPlan: TFrameJDPlan;
  procedure ClearSheet();
  var
    lst: TList;
    i: integer;
  begin
    lst := TList.Create;
    try
      for I := 0 to PageControl_Section.ControlCount - 1 do
      begin
        if PageControl_Section.Controls[i] is TRzTabSheet then
        begin
          lst.Add(PageControl_Section.Controls[i]);
        end;
      end;


      while lst.Count > 0 do
      begin
        TRzTabSheet(lst[0]).Free;
        lst.Delete(0);
      end;

      m_Frames.clear;
    finally
      lst.Free;
    end;



  end;
begin
  ClearSheet();

  m_LCJDPlan.GetClientSection(GlobalDM.SiteInfo.strSiteIP,m_Sections);
//  TRegionFilter.DefaultFlter.GetJlRegions(m_JLID,m_Sections);

  m_Sections.Sort(CompareJlRegionByName);

  
  for I := 0 to m_Sections.Count - 1 do
  begin
    Sheet := TRzTabSheet.Create(Self);

    Sheet.Caption := Format('%s(%s)',[m_Sections[i].Section_name,m_Sections[i].Section_id]);

    Sheet.Tag := Integer(m_Sections[i]);

    Sheet.PageControl := PageControl_Section;

    FrameJDPlan := TFrameJDPlan.Create(Sheet);
    FrameJDPlan.Parent := Sheet;
    FrameJDPlan.Tag := Integer(m_Sections[i]);
    FrameJDPlan.OnClickPlan := ConfirmPlan;
    FrameJDPlan.CreatePlanCallback := CreateTrainPlan;

    m_Frames.Add(FrameJDPlan);
  end;
  if PageControl_Section.PageCount > 0 then
  begin
    PageControl_Section.ActivePageIndex := 0;
  end;
end;

procedure TFrmJDPlan.CreateTrainPlan(train_id: string;plan: TJDPlan;var planid: string);
var
  jdplan: TJDPlan;
begin
  m_LCJDPlan.CreatePlan(train_id,m_JLID,GlobalDM.SiteInfo.strSiteGUID,
  GlobalDM.DutyUser.strDutyGUID,
  GlobalDM.SiteNumber,
  GlobalDM.SiteInfo.strSiteName,planid);



  //各个FRAME中使用的JDPlan是m_JDPlanList中对象的副本，此时需要把两个对象都更新 planid
  plan.PlanGUID := planid;

  jdplan := FindJDPlan(train_id);
  if jdplan <> nil then
    jdplan.PlanGUID := planid;


  if Assigned(m_OnCreateJDPlan) then
    m_OnCreateJDPlan();

  RefreshPlan();
end;

procedure TFrmJDPlan.FillPlans;
var
  i: integer;
begin
  for I := 0 to m_Frames.Count - 1 do
  begin
    TFrameJDPlan(m_Frames[i]).RefreshPlan(m_JDPlanList);
  end;
end;

function TFrmJDPlan.FindJDPlan(const train_id: string): TJDPlan;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to m_JDPlanList.Count - 1 do
  begin
    if m_JDPlanList[i].Train_id = train_id then
    begin
      Result := m_JDPlanList[i];
      Break;
    end;
  end;
end;

procedure TFrmJDPlan.FormCreate(Sender: TObject);
begin
  m_Frames := TList.Create;
  m_Sections := TTMISSectionList.Create;
  m_JDPlanList := TJDPlanList.Create;
  m_LCJDPlan := TLCJDPlan.Create(GlobalDM.WebAPIUtils);
  
end;

procedure TFrmJDPlan.FormDestroy(Sender: TObject);
begin
  m_Frames.Free;
  m_JDPlanList.Free;
  m_LCJDPlan.Free;
  m_Sections.Free;
end;

procedure TFrmJDPlan.FormShow(Sender: TObject);
begin


  tmrRefreshPlan.Enabled := chkAutoRefresh.Checked;
end;

procedure TFrmJDPlan.Init;
begin
 CreateSectionTab();
  RefreshPlan;
end;

procedure TFrmJDPlan.N1Click(Sender: TObject);
begin
  if TFrmRegionFilter.ConfigRegion(m_LCJDPlan) then
  begin
    CreateSectionTab();
    FillPlans();
  end;
end;

function TFrmJDPlan.PlanInJDPlanLst(const planid: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to m_JDPlanList.Count - 1 do
  begin
    Result := m_JDPlanList[i].PlanGUID = planid;
    if Result then Break;
  end;
end;

procedure TFrmJDPlan.RefreshPlan;
begin

  m_LCJDPlan.QueryPlans('',GlobalDM.SiteNumber,IncHour(m_QueryTime,-2),IncHour(Now,6),m_JDPlanList);

  FillPlans();

  //刷新计划后重置定时时间，2分钟没有手动刷新则自动刷新
  tmrRefreshPlan.Enabled := False;
  tmrRefreshPlan.Enabled := True;
end;

procedure TFrmJDPlan.SearchPlan;
var
  trainno,tid : string;
  i : integer;
  jdPlan : TJDPlan;
  k: Integer;
  planList : TJDPlanList;
begin
  if not TfrmFindJDPlan.ShowDialog(trainno) then exit;
  jdPlan := nil;
  planList := TJDPlanList.Create;
  for i := 0 to m_JDPlanList.Count -1  do
  begin
    if Pos(trainno,UpperCase(m_JDPlanList.Items[i].Train_code) ) > 0 then
    begin
      jdPlan := m_JDPlanList.Items[i];
      planList.Add(jdPlan);
    end;
  end;
  if planList.Count = 0 then
  begin
    ShowMessage('未找到指定车次的计划信息');
    exit;
  end;
  tid := '';
  if planList.Count > 1 then
  begin
    if not TfrmFindJDPlanFromList.ShowDialog(planList,tid) then exit;
  end else begin
    tid := planList[0].Train_id;
  end;
  for i := 0 to PlanList.Count - 1 do
  begin
    if PlanList[i].Train_id = tid then
    begin

      jdPlan :=PlanList[i];
    end;
  end;
  for i := 0 to m_Frames.Count - 1 do
  begin
    if (jdPlan <> nil) and (TTMISSection(TFrameJDPlan(m_Frames[i]).Tag).Section_id = jdplan.Section_id) then
    begin
      PageControl_Section.ActivePage := TRzTabSheet(TFrameJDPlan(m_Frames[i]).Parent);
     for k := 1 to TFrameJDPlan(m_Frames[i]).grdPlan.RowCount - 1 do
      begin
        if TFrameJDPlan(m_Frames[i]).grdPlan.Cells[5,K] = tid then
        begin
          TFrameJDPlan(m_Frames[i]).grdPlan.ROW := k;
          exit;
        end;
      end;
    end;
  end;
end;

procedure TFrmJDPlan.SetJL(const Value: string);
begin
  if m_JLID <> Value then
  begin
    m_JLID := Value;
  end;
end;

procedure TFrmJDPlan.SetQueryTime(const Value: TDateTime);
begin
  m_QueryTime := Value;
end;

procedure TFrmJDPlan.SpeedButton1Click(Sender: TObject);
begin
  RefreshPlan();
end;

procedure TFrmJDPlan.tmrRefreshPlanTimer(Sender: TObject);
begin
  try
    RefreshPlan();
  except on e :exception do
    GlobalDM.LogManage.InsertLog('自动刷新机调计划异常:' + e.Message);
  end;
end;


end.
