unit uFrmWaitPlanEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, AdvObj, BaseGrid, AdvGrid,
  ADODB,DateUtils, Buttons;

type
  TfrmWaitPlanEdit = class(TForm)
    Panel1: TPanel;
    strGridPlan: TAdvStringGrid;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    btnUpdate: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure strGridPlanGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
  private
    { Private declarations }
    procedure Init();
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  DB,uTrainman,uGlobalDM,uDBRoomWait,uLogs,uFrmWaitPlanAdd,
  uFrmWaitPlanUpdate,uArea,uDBArea;
{ TfrmPlanEdit }

procedure TfrmWaitPlanEdit.btnAddClick(Sender: TObject);
var
  frmWaitPlanAdd : TfrmWaitPlanAdd;
begin
  frmWaitPlanAdd := TfrmWaitPlanAdd.Create(nil);
  try
    if (frmWaitPlanAdd.ShowModal = mrOk) then
    begin
      Init();
    end;
  finally
    frmWaitPlanAdd.Free;
  end;
end;

procedure TfrmWaitPlanEdit.btnDeleteClick(Sender: TObject);
var
  planGUID : string;
begin
  if (strGridPlan.Row = 0) or (strGridPlan.Row = strGridPlan.RowCount - 1) then exit;
  
  if Application.MessageBox('您确定要删除此计划吗','提示',MB_OKCANCEL +
    MB_ICONINFORMATION) = mrCancel then exit;
    
  planGUID := strGridPlan.Cells[99,strGridPlan.Row];
  if planGUID <> '' then
  begin
    TRsDBWaitPlan.DeletePlan(GlobalDM.ADOConnection,planGUID);
    TLog.SaveLog(now,Format('--删除计划：车次[%s],房间[%s]--',[strGridPlan.Cells[1,strGridPlan.Row],strGridPlan.Cells[2,strGridPlan.Row]]));
  end;
  Init;
end;

procedure TfrmWaitPlanEdit.btnUpdateClick(Sender: TObject);
var
  planGUID : string;
  frmWaitPlanUpdate : TfrmWaitPlanUpdate;
begin
  if (strGridPlan.Row = 0) or (strGridPlan.Row = strGridPlan.RowCount - 1) then
    exit;
  planGUID := strGridPlan.Cells[99,strGridPlan.Row];
  if planGUID = '' then   exit;
  frmWaitPlanUpdate := TfrmWaitPlanUpdate.Create(nil);
  try
    frmWaitPlanUpdate.PlanGUID := planGUID;
    if frmWaitPlanUpdate.ShowModal = mrOk then
    begin
      init;
    end;
  finally
    frmWaitPlanUpdate.Free;
  end;
end;

procedure TfrmWaitPlanEdit.FormCreate(Sender: TObject);
begin
  strGridPlan.ColWidths[0] := 60;
  strGridPlan.ColWidths[1] := 80;
  strGridPlan.ColWidths[2] := 80;
  strGridPlan.ColWidths[3] := 150;
  strGridPlan.ColWidths[4] := 150;
  strGridPlan.ColWidths[5] := 80;
  strGridPlan.ColWidths[6] := 100;  
  Init();
end;


procedure TfrmWaitPlanEdit.Init();
var
  ado : TADOQuery;
  i : Integer;
  Part:RRsArea;
begin
  TRsDBWaitPlan.GetPlans(GlobalDM.ADOConnection,GlobalDM.SiteInfo.strAreaGUID,ado);
  try
    i := 0;
    with ado do
    begin
      strGridPlan.Clear;
      strGridPlan.ClearRows(0,9999);
      strGridPlan.RowCount := RecordCount + 2;
      strGridPlan.Clear;
      strGridPlan.Cells[0,0] := '序号';
      strGridPlan.Cells[1,0] := '待班车次';
      strGridPlan.Cells[2,0] := '房间号';
      strGridPlan.Cells[3,0] := '到达时间';
      strGridPlan.Cells[4,0] := '叫班时间';
      strGridPlan.Cells[5,0] := '是否启用';
      strGridPlan.Cells[6,0] := '所属区域';
      while not eof  do
      begin
        Inc(i);
        strGridPlan.Cells[0,i] := IntToStr(i);
        strGridPlan.Cells[1,i] := FieldByName('strTrainNo').AsString;
        strGridPlan.Cells[2,i] := FieldByName('nRoomID').AsString;
        strGridPlan.Cells[3,i] := FormatdateTime('HH:NN',
          FieldByName('dtStartTime').asDateTime);
          
        strGridPlan.Cells[4,i] := FormatdateTime('HH:NN',
          FieldByName('dtCallTime').asDateTime);

        strGridPlan.Cells[5,i] := '';
        if FieldByName('bIsUsed').AsBoolean then
          strGridPlan.Cells[5,i] := '√';

        TRsDBArea.GetAreaByGUID(GlobalDM.ADOConnection,FieldByName('strAreaGUID').AsString,Part);
        strGridPlan.Cells[6,i] := Part.strAreaName;
        strGridPlan.Cells[99,i] := FieldByName('strGUID').AsString;
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmWaitPlanEdit.strGridPlanGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
begin
  if ARow = 0 then exit;
  if ARow = strGridPlan.RowCount - 1 then exit;
  if ACol in [3,4] then
  begin
    AEditor := edTimeEdit;
  end;
end;

end.
