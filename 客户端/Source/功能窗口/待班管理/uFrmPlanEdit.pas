unit uFrmPlanEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, AdvObj, BaseGrid, AdvGrid,
  ADODB,DateUtils, Buttons;

type
  TfrmPlanEdit = class(TForm)
    Panel1: TPanel;
    strGridPlan: TAdvStringGrid;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    btnLoad: TSpeedButton;
    btnEdit: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitColumns;
    procedure Init(planDate : TDateTime);
  public
    { Public declarations }
  end;

var
  frmPlanEdit: TfrmPlanEdit;

implementation

{$R *.dfm}
uses
  uPlan, DB,uTrainman,uDataModule,uTrainNo,uFrmPlanAdd,uFrmPlanModify;
{ TfrmPlanEdit }

procedure TfrmPlanEdit.btnAddClick(Sender: TObject);
var
  plan : RPlan;
begin
  frmPlanAdd := TfrmPlanAdd.Create(nil);
  try
    frmPlanAdd.dtPlanDate := DateTimePicker1.Date;
    if frmPlanAdd.ShowModal = mrCancel then exit;
    plan := frmPlanAdd.Plan;
    if not TDBPlan.AddPlan(plan) then
    begin
      Application.MessageBox('添加失败','提示',MB_OK + MB_ICONError);
      exit;
    end;
  finally
    frmPlanAdd.Free;
  end;
  Application.MessageBox('添加成功','提示',MB_OK + MB_ICONINFORMATION);
  Init(DateTimePicker1.DateTime);
end;

procedure TfrmPlanEdit.btnDeleteClick(Sender: TObject);
var
  plan : RPlan;
  planGUID : string;
begin
  if (strGridPlan.Row = 0) or (strGridPlan.Row = strGridPlan.RowCount - 1) then exit;
  planGUID := strGridPlan.Cells[10,strGridPlan.Row];
  if planGUID <> '' then
  begin

    plan := TDBPlan.GetPlan(planGUID);
    if (plan.nState > 1) or (plan.nSubDriverState > 1) or (plan.nMainDriverState > 1) then
    begin
      Application.MessageBox('已经有司机签到，不能删除。','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if Application.MessageBox('您确定要删除此信息吗?','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;    
    TDBPlan.DeletePlan(planGUID);
  end;
  Init(DateTimePicker1.DateTime);

end;

procedure TfrmPlanEdit.btnEditClick(Sender: TObject);
var
  plan : RPlan;
  planGUID : string;
begin

  if (strGridPlan.Row = 0) or (strGridPlan.Row = strGridPlan.RowCount - 1) then exit;

  planGUID := strGridPlan.Cells[10,strGridPlan.Row];
  if planGUID <> '' then
  begin
    plan := TDBPlan.GetPlan(planGUID);
    FrmPlanModify := TfrmPlanModify.Create(nil);
    try
      frmPlanModify.Plan := Plan;
      if frmPlanModify.ShowModal = mrCancel then exit;
      Plan := frmPlanModify.Plan;
      if not TDBPlan.EditPlan(Plan) then
      begin
        Application.MessageBox('修改失败','提示',MB_OK + MB_ICONError);
        exit;
      end;
    finally
      frmPlanModify.Free;
    end;
    Application.MessageBox('修改陈功','提示',MB_OK + MB_ICONINFORMATION);
    Init(DateTimePicker1.DateTime);
  end;
end;

procedure TfrmPlanEdit.DateTimePicker1Change(Sender: TObject);
begin
  Init(DateTimePicker1.DateTime);
  btnAdd.Enabled := true;
  btnDelete.Enabled := true;
  btnEdit.Enabled := true;
  btnLoad.Enabled := true;
  if DateOf(DateTimePicker1.DateTime) < DateOf(now) then
  begin
    btnAdd.Enabled := false;
    btnDelete.Enabled := false;
    btnEdit.Enabled := false;
    btnLoad.Enabled := false;    
  end;
end;

procedure TfrmPlanEdit.FormCreate(Sender: TObject);
begin
  InitColumns;
  DateTimePicker1.DateTime := DMGlobal.GetNow;
  Init(DateTimePicker1.DateTime);
end;

procedure TfrmPlanEdit.Init(planDate: TDateTime);
var
  ado : TADOQuery;
  i : Integer;
begin
  TDBPlan.GetPlansOnlyDate(planDate,ado);
  try
    i := 0;
    with ado do
    begin      
      strGridPlan.Clear;
      strGridPlan.ClearRows(0,9999);
      strGridPlan.Cells[0,0] := '序号';
      strGridPlan.Cells[1,0] := '待班车次';
      strGridPlan.Cells[2,0] := '强休时间';
      strGridPlan.Cells[3,0] := '叫班时间';
      strGridPlan.Cells[4,0] := '出勤时间';
      strGridPlan.Cells[5,0] := '开车时间';
      strGridPlan.Cells[6,0] := '正司机';
      strGridPlan.Cells[7,0] := '副司机';
      strGridPlan.Cells[8,0] := '单双司机';
      strGridPlan.Cells[9,0] := '状态';

      strGridPlan.RowCount := RecordCount + 2;
      while not eof  do
      begin
        Inc(i);
        strGridPlan.Cells[0,i] := IntToStr(i);
        strGridPlan.Cells[1,i] := FieldByName('strTrainNo').AsString;
        strGridPlan.Cells[2,i] := FormatdateTime('yyyy-MM-dd HH:nn',FieldByName('dtSigninTime').asDateTime);
        strGridPlan.Cells[3,i] := FormatdateTime('yyyy-MM-dd HH:nn',FieldByName('dtCallTime').asDateTime);
        strGridPlan.Cells[4,i] := FormatdateTime('yyyy-MM-dd HH:nn',FieldByName('dtOutDutyTime').asDateTime);
        strGridPlan.Cells[5,i] := FormatdateTime('yyyy-MM-dd HH:nn',FieldByName('dtStartTime').asDateTime);
        strGridPlan.Cells[6,i] := FieldByName('strMainDriverStateName').AsString;
        strGridPlan.Cells[7,i] := FieldByName('strSubDriverStateName').AsString ;
        strGridPlan.Cells[8,i] := FieldByName('strTrainmanTypeName').AsString; ;
        if FieldByName('nState').AsInteger = 0 then
        begin
          strGridPlan.Cells[9,i] := '未录入';
        end
        else
        begin
          strGridPlan.Cells[9,i] := FieldByName('strStateName').AsString;
          if (FieldByName('nState').AsInteger = 1) and ((FieldByName('nMainDriverState').AsInteger = 1)) and ((FieldByName('nSubDriverState').AsInteger = 1)) then
          begin
          end;
        end;
        strGridPlan.Cells[10,i] := FieldByName('strGUID').AsString;
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmPlanEdit.InitColumns;
begin
  strGridPlan.ColWidths[0] := 40;
  strGridPlan.ColWidths[1] := 80;
  strGridPlan.ColWidths[2] := 140;
  strGridPlan.ColWidths[3] := 140;
  strGridPlan.ColWidths[4] := 140;
  strGridPlan.ColWidths[5] := 140;
  strGridPlan.ColWidths[6] := 75;
  strGridPlan.ColWidths[7] := 75;
  strGridPlan.ColWidths[8] := 80;
  strGridPlan.ColWidths[9] := 60;
end;


procedure TfrmPlanEdit.btnLoadClick(Sender: TObject);
var
  ado : TADOQuery;
  plan : RPlan;
begin
  if Application.MessageBox(PChar('您确定要要从模版中加载计划吗？'),'提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  TTrainNoOpt.GetTrainNos(DMGlobal.LocalArea,ado);
  try
    with ado do
    begin
      while not eof do
      begin
        plan.strTrainNo := FieldByName('strTrainNo').AsString;
        plan.dtSigninTime := DateOf(DateTimePicker1.DateTime) + TimeOf(FieldByName('dtSignInTime').AsDateTime);
        plan.dtCallTime := DateOf(DateTimePicker1.DateTime) + TimeOf(FieldByName('dtCallTime').AsDateTime);
        plan.dtOutDutyTime := DateOf(DateTimePicker1.DateTime) + TimeOf(FieldByName('dtOutDutyTime').AsDateTime);
        plan.dtStartTime := DateOf(DateTimePicker1.DateTime) + TimeOf(FieldByName('dtStartTime').AsDateTime);
        if plan.dtCallTime < plan.dtSigninTime  then
        begin
          plan.dtCallTime := plan.dtCallTime + 1;
        end;
        if plan.dtOutDutyTime < plan.dtCallTime  then
        begin
           plan.dtOutDutyTime := plan.dtOutDutyTime + 1;
        end;
        if plan.dtStartTime < plan.dtOutDutyTime  then
        begin
          plan.dtStartTime := plan.dtStartTime + 1;
        end;
        

        plan.nTrainmanTypeID := FieldByName('nTrainmanType').AsInteger;
        plan.strInputGUID := DMGlobal.DutyUser.DutyGUID;
        plan.dtInputTime := DMGlobal.GetNow;
        plan.nMainDriverState := 1;
        plan.nSubDriverState := 1;
        plan.nState := 1;
        plan.strAreaGUID :=  FieldByName('strAreaGUID').AsString;
        if not TDBPlan.ExistPlanByTrainNo(plan) then
        begin
          TDBPlan.AddPlan(plan);
        end;
        next;
      end;
    end;
  finally
    ado.Free;
  end;
  Init(DateTimePicker1.DateTime);
end;

end.
