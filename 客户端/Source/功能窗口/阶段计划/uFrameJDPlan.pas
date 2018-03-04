unit uFrameJDPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ImgList, Menus,uLCJDPlan,DateUtils, StdCtrls,
  Buttons, Grids, AdvObj, BaseGrid, AdvGrid;

type
  TNotifyPlanEvent = procedure(train_id: string) of object;
  TCreatePlanCallback = procedure(train_id: string;JDPlan: TJDPlan;var planid: string) of object;
  TFrameJDPlan = class(TFrame)
    ImageList: TImageList;
    grdPlan: TAdvStringGrid;
    procedure FrameResize(Sender: TObject);
    procedure grdPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grdPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure grdPlanClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdPlanDblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure grdPlanSelectionChanged(Sender: TObject; ALeft, ATop, ARight,
      ABottom: Integer);
  private
    { Private declarations }
    m_OnClickPlan: TNotifyPlanEvent;
    m_PlanList: TJDPlanList;
    m_CreatePlanCallback: TCreatePlanCallback;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;
    procedure RefreshPlan(SrcPlans: TJDPlanList);
    property OnClickPlan: TNotifyPlanEvent read m_OnClickPlan write m_OnClickPlan;
    property CreatePlanCallback: TCreatePlanCallback read m_CreatePlanCallback write m_CreatePlanCallback;
  end;

implementation
uses
  uTFSystem;
{$R *.dfm}
function GetStateString(plan: TJDPlan): string;
begin
//  if plan.IsUpdate = 0 then
//    Result := '新接收'
//  else
  if plan.PlanGUID = '' then
    Result := '未安排'
  else
    Result := '已安排';
end;
{ TFrameJDPlan }

constructor TFrameJDPlan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_PlanList := TJDPlanList.Create();
end;

destructor TFrameJDPlan.Destroy;
begin
  m_PlanList.Free;
  inherited;
end;
procedure TFrameJDPlan.FrameResize(Sender: TObject);
begin
//  lstView.Left := 0;
//  lstView.Top := 0;
//  lstView.Width := Width;
//  lstView.Height := Height;
//  OutputDebugString(pchar(Format('frame width: %d frame height: %d',[Width,Height])));
end;

procedure TFrameJDPlan.grdPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
  var CanEdit: Boolean);
begin
  CanEdit := False;
end;

procedure TFrameJDPlan.grdPlanClickCell(Sender: TObject; ARow, ACol: Integer);
begin
//  if grdPlan.Objects[0,ARow] <> nil then
//  begin
//    if TJDPlan(grdPlan.Objects[0,ARow]).IsUpdate = 0 then
//    begin
//      if Assigned(m_OnClickPlan) then
//      begin
//        m_OnClickPlan(TJDPlan(grdPlan.Objects[0,ARow]).Train_id);
//        TJDPlan(grdPlan.Objects[0,ARow]).IsUpdate := 1;
//        grdPlan.Cells[0,ARow] := GetStateString(TJDPlan(grdPlan.Objects[0,ARow]));
//      end;
//    end;
//  end;
  
  
end;

procedure TFrameJDPlan.grdPlanDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  planid: string;
begin
  if grdPlan.Objects[0,ARow] <> nil then
  begin
    if TJDPlan(grdPlan.Objects[0,ARow]).PlanGUID <> '' then
    begin
      if not TBox('此条阶段计划已经创建过对应的机车计划，是否重新创建？') then Exit;
    end;

    //回调中更新了JDPlan的计划ID
    m_CreatePlanCallback(TJDPlan(grdPlan.Objects[0,ARow]).Train_id,
      TJDPlan(grdPlan.Objects[0,ARow]),planid);

    
    grdPlan.Cells[0,ARow] := GetStateString(TJDPlan(grdPlan.Objects[0,ARow]));
  end;
end;

procedure TFrameJDPlan.grdPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
  AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if ACol = 0 then
  begin
    if grdPlan.Objects[ACol,ARow] <> nil then
    begin
      with TJDPlan(grdPlan.Objects[ACol,ARow]) do
      begin
//        if IsUpdate = 0 then
//          ABrush.Color := $008582FB
//        else
        if PlanGUID = '' then
          ABrush.Color := $007AED94
        else
          ABrush.Color := $00DBD8D5;

      end;
    end;
  end;
end;


procedure TFrameJDPlan.grdPlanSelectionChanged(Sender: TObject; ALeft, ATop,
  ARight, ABottom: Integer);
begin
;
end;

function ComparePlanTime(Item1, Item2: Pointer): Integer;
begin
  Result := -CompareDateTime(TJDPlan(Item1).Time_deptart,TJDPlan(Item2).Time_deptart);
end;
procedure TFrameJDPlan.RefreshPlan(SrcPlans: TJDPlanList);
  function FindPlan(train_id: string;PlanList: TJDPlanList): integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to PlanList.Count - 1 do
    begin
      if PlanList[i].Train_id = train_id then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
var
  I,index: Integer;
begin
  for I := 0 to SrcPlans.Count - 1 do
  begin
    if SrcPlans[i].Section_id = TTMISSection(Self.Tag).Section_id then
    begin
      index := FindPlan (SrcPlans[i].Train_id,m_PlanList);
      if index = -1 then
        m_PlanList.Add(SrcPlans[i].CreateClone())
      else
        m_PlanList[index].Assign(SrcPlans[i]);
    end;
  end;

  i := 0;
  while i < m_PlanList.Count - 1 do
  begin
    if  FindPlan(m_PlanList.Items[i].Train_id,SrcPlans) = -1 then
    begin
      m_PlanList.Delete(i);
    end
    else
      Inc(i);
  end;

  m_PlanList.Sort(ComparePlanTime);
  
  grdPlan.BeginUpdate;


  grdPlan.ClearRows(grdPlan.FixedRows,grdPlan.RowCount - grdPlan.FixedRows);
  
  if m_PlanList.Count <> 0 then
    grdPlan.RowCount := m_PlanList.Count + grdPlan.FixedRows
  else
    grdPlan.RowCount := grdPlan.FixedRows + 1;


  for I := 0 to m_PlanList.Count - 1 do
  begin
    grdPlan.Objects[0,grdPlan.FixedRows + i] := m_PlanList[i];
    grdPlan.Cells[0,grdPlan.FixedRows + i] := GetStateString(m_PlanList[i]);
    grdPlan.Cells[1,grdPlan.FixedRows + i] := FormatDateTime('mm-dd hh:nn',m_PlanList[i].Time_deptart);
    grdPlan.Cells[2,grdPlan.FixedRows + i] := m_PlanList[i].Train_code;
    grdPlan.Cells[3,grdPlan.FixedRows + i] := m_PlanList[i].Station_deptart;
    grdPlan.Cells[4,grdPlan.FixedRows + i] := m_PlanList[i].Station_arrived;
    grdPlan.Cells[5,grdPlan.FixedRows + i] := m_PlanList[i].Train_id;
  end;

  grdPlan.EndUpdate;
end;

end.
