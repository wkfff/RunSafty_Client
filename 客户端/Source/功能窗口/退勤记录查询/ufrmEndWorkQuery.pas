unit ufrmEndWorkQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, RzPanel, ExtCtrls, Grids, AdvObj, BaseGrid, AdvGrid,
  RzButton, ImgList, Buttons, PngSpeedButton, RzEdit, StdCtrls, RzCmboBx, Mask,
  uTrainJiaolu,DateUtils,uTrainPlan,uTFSystem,comobj;

type
  TFrmEndWorkQuery = class(TForm)
    planGrid: TAdvStringGrid;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    ImageList1: TImageList;
    RzToolbar1: TRzToolbar;
    BtnExport: TRzToolButton;
    Label4: TLabel;
    dtEditBegin: TRzDateTimeEdit;
    Label5: TLabel;
    dtEditEnd: TRzDateTimeEdit;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    RzSpacer5: TRzSpacer;
    BtnView: TRzToolButton;
    RzSpacer6: TRzSpacer;
    SaveDialog1: TSaveDialog;
    procedure BtnViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
    { Private declarations }
    m_PlanArray : TRsTuiQinPlanArray;
    procedure InitData();
    procedure ShowPlans();
    procedure ExportGridToXls(grid: TAdvStringGrid;fileName: string);
  public
    { Public declarations }
    class procedure ShowForm();
  end;


implementation

uses uGlobalDM, uLCBaseDict,uLCTrainPlan, uBaseWebInterface,uSaftyEnum,uTrainman,
uApparatusCommon, ufrmHint;

{$R *.dfm}

{ TFrmEndWorkQuery }

procedure TFrmEndWorkQuery.BtnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    TfrmHint.ShowHint('正在导出数据，请稍候……');
    try
      ExportGridToXls(planGrid,SaveDialog1.FileName);
    finally
      TfrmHint.CloseHint;
    end;

  end;
end;

procedure TFrmEndWorkQuery.BtnViewClick(Sender: TObject);
var
  strError:string;
  dtBeginTime,dtEndTime : TDateTime;
begin
  dtBeginTime := dtEditBegin.Date;
  dtEndTime := dtEditEnd.Date;
  with TRsLCTrainPlan.Create('','','') do
  begin
    TfrmHint.ShowHint('正在查询数据，请稍候……');
    try
      SetConnConfig(GlobalDM.HttpConnConfig);
      if not GetTuiQinPlanByClient(dtBeginTime,dtEndTime,1,m_PlanArray,strError) then
      begin
        BoxErr(strError);
      end
      else
      begin
        ShowPlans();
      end;
    finally
      Free;
      TfrmHint.CloseHint;
    end;
  end;
end;





procedure TFrmEndWorkQuery.ExportGridToXls(grid: TAdvStringGrid;
  fileName: string);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  procedure CreateTitle();
  var
    I: Integer;
    Range: Variant;
  begin
    for I := 0 to grid.ColumnHeaders.Count - 1 do
    begin
      Range := MSExcelWorkSheet.Columns[i + 1];
      Range.HorizontalAlignment := $FFFFEFDD;   //左对齐
      
      //序号列不设列宽
      if I > 0 then
        Range.ColumnWidth := 20;
        
      MSExcelWorkSheet.Cells[1,i + 1] := grid.ColumnHeaders.Strings[i];
    end;
    
  end;
  procedure FillXlsData();
  var
    I,J: Integer;
  begin
    for I := grid.FixedRows to grid.RowCount - grid.FixedRows - 1 do
    begin
      for J := 0 to grid.ColumnHeaders.Count - 1 do
      begin
        MSExcelWorkSheet.Cells[i + 1,j + 1] := grid.Cells[j,i];
      end;
    end;
  end;
begin
  MSExcel := CreateOleObject('Excel.Application');

  try
    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];
    
    CreateTitle();

    FillXlsData();

    MSExcelWorkBook.SaveAs(FileName);
  finally
    MSExcel.Quit;
  end;

end;
procedure TFrmEndWorkQuery.FormShow(Sender: TObject);
begin
  InitData();
end;

procedure TFrmEndWorkQuery.InitData;
begin
  dtEditBegin.Date := IncDay(Now,-1);
  dtEditEnd.Date := Now;
end;

class procedure TFrmEndWorkQuery.ShowForm;
begin
  with TFrmEndWorkQuery.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TFrmEndWorkQuery.ShowPlans;
  function GetRealCount: integer;
  var
    i: integer;
  begin
    Result := 0;
    for I := 0 to Length(m_PlanArray) - 1 do
    begin
      if m_PlanArray[i].TrainPlan.nPlanState <> psEndWork then Continue;
      Inc(Result);
    end;

  end;
var
  I,nIndex: Integer;
  nCount: integer;
begin
  with planGrid do
  begin
    ClearRows(FixedRows,RowCount - FixedRows);

    nCount := GetRealCount;

    RzStatusPane1.Caption := Format('查询到 %d 条记录',[nCount]);
    
    if nCount > 0 then
      RowCount := nCount + FixedRows
    else begin
      RowCount := FixedRows + 1;
    end;


    nIndex := 0;
    for I := 0 to Length(m_PlanArray) - 1 do
    begin
      if m_PlanArray[i].TrainPlan.nPlanState <> psEndWork then Continue;
      Cells[0, nIndex + 1] := IntToStr(nIndex + 1);
      Cells[1, nIndex + 1] := m_PlanArray[i].TrainPlan.strTrainJiaoluName;
      Cells[2, nIndex + 1] :=  m_PlanArray[i].TrainPlan.strTrainTypeName + '-' +  m_PlanArray[i].TrainPlan.strTrainNumber;
      Cells[3, nIndex + 1] :=  m_PlanArray[i].TrainPlan.strTrainNo;
      Cells[4, nIndex + 1] := FormatDateTime('mm-dd hh:nn',m_PlanArray[i].TrainPlan.dtStartTime);


      if m_PlanArray[i].TrainPlan.dtLastArriveTime > 0  then
      begin
        Cells[5, nIndex + 1] := FormatDateTime('MM-dd HH:nn',m_PlanArray[i].TrainPlan.dtLastArriveTime);
      end
      else
        Cells[5, nIndex + 1] := '';
      if m_PlanArray[i].TuiQinGroup.Group.strGroupGUID  <> '' then
      begin
        Cells[6, nIndex + 1] := GetTrainmanText(m_PlanArray[i].TuiQinGroup.Group.Trainman1);
        Cells[7, nIndex + 1] := GetTrainmanText(m_PlanArray[i].TuiQinGroup.Group.Trainman2);
        Cells[8, nIndex + 1] := GetTrainmanText(m_PlanArray[i].TuiQinGroup.Group.Trainman3);
      end;
      Inc(nIndex);
    end;

  end;


end;

end.
