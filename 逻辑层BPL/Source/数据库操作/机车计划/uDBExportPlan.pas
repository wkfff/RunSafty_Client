unit uDBExportPlan;

interface

uses
  ADODB, Classes, Variants, ComObj, SysUtils, DateUtils,
  uTFSystem, uSaftyEnum, uTrainPlan, uTrainman;

type
  //导出进度事件
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;

type
  //////////////////////////////////////////////////////////////////////////////
  ///导出机车计划类
  //////////////////////////////////////////////////////////////////////////////
  TDBExportPlan = class(TDBOperate)
  private                   
    m_OnExportPlanProgress: TOnExportPlanProgress; //导出进度事件

    //从ADOQuery填充机车计划
    procedure ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan: RRsTrainPlan);
  public 
    //功能：获取机车计划
    procedure GetTrainPlans(BeginTime, EndTime: TDateTime; TrainJiaoluGUID: string; out TrainPlanArray: TRsTrainPlanArray);
    function SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean; overload;
    function SaveToExcel(BeginTime, EndTime: TDateTime; TrainJiaoluGUID: string; ExcelFile: string): boolean; overload;
  published
    //导出进度事件
    property OnExportPlanProgress: TOnExportPlanProgress read m_OnExportPlanProgress write m_OnExportPlanProgress;
  end;

implementation

{ TRsDBExportPlan }

procedure TDBExportPlan.ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan: RRsTrainPlan);
begin
  with ADOQuery do
  begin
    TrainPlan.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    TrainPlan.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainPlan.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainPlan.strTrainNo := FieldByName('strTrainNo').AsString;
    TrainPlan.dtStartTime :=  FieldByName('dtStartTime').Value;
    TrainPlan.dtRealStartTime :=  0;
    if not FieldByName('dtRealStartTime').IsNull then
    begin
      TrainPlan.dtRealStartTime := FieldByName('dtRealStartTime').Value;
      TrainPlan.dtFirstStartTime := FieldByName('dtRealStartTime').Value;
    end;
    TrainPlan.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainPlan.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainPlan.strStartStation := FieldByName('strStartStation').AsString;
    TrainPlan.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainPlan.strEndStation := FieldByName('strEndStation').AsString;
    TrainPlan.strEndStationName := FieldByName('strEndStationName').AsString;
    TrainPlan.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').AsInteger);
    TrainPlan.nPlanType := TRsPlanType(FieldByName('nPlanType').AsInteger);
    TrainPlan.nDragType := TRsDragType(FieldByName('nDragType').AsInteger);
    TrainPlan.nKeHuoID := TRsKehuo(FieldByName('nKeHuoID').asInteger);
    TrainPlan.nRemarkType := TRsPlanRemarkType(FieldByName('nRemarkType').AsInteger);
    TrainPlan.strRemark := FieldByName('strRemark').AsString;
    TrainPlan.nPlanState := TRsPlanState(FieldByName('nPlanState').AsInteger);
    if not FieldByName('dtLastArriveTime').IsNull then
      TrainPlan.dtLastArriveTime := FieldByName('dtLastArriveTime').asdatetime;
    if not FieldByName('dtCreateTime').IsNull then
      TrainPlan.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    TrainPlan.strCreateSiteGUID := FieldByName('strCreateSiteGUID').AsString;
    TrainPlan.strCreateUserGUID := FieldByName('strCreateUserGUID').AsString;
    TrainPlan.strMainPlanGUID := FieldByName('strMainPlanGUID').AsString 
  end;
end;

procedure TDBExportPlan.GetTrainPlans(BeginTime, EndTime: TDateTime; TrainJiaoluGUID: string; out TrainPlanArray: TRsTrainPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Train where nPlanState>=2 and dtStartTime>=%s and dtStartTime<=%s ';
  strSql := Format(strSql, [QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss', BeginTime)),
                            QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss', EndTime))]);
  if TrainJiaoluGUID <> '' then strSql := strSql + ' and strTrainJiaoluGUID=' + QuotedStr(TrainJiaoluGUID);
  strSql := strSql + ' order by dtStartTime ';
   
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainPlan(adoQuery, TrainPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBExportPlan.SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean;
var
  excelApp, workBook, workSheet: Variant;
  i, n, nRow: integer;
  strErrorInfo: string;
begin
  result := false;
  if Length(TrainPlanArray) = 0 then
  begin
    strErrorInfo := '没有要导出的数据！';
    exit;
  end;

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strErrorInfo := '你还没有安装Microsoft Excel，请先安装！';
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(ExcelFile) then
    begin
      excelApp.workBooks.Open(ExcelFile);
      excelApp.Worksheets[1].activate;
    end
    else
    begin
      excelApp.WorkBooks.Add;
      workBook := excelApp.Workbooks.Add;
      workSheet := workBook.Sheets.Add;
    end;

    nRow := 1;                            
    excelApp.Cells[nRow, 1].Value := '序号';
    excelApp.Cells[nRow, 2].Value := '状态';
    excelApp.Cells[nRow, 3].Value := '行车区段';
    excelApp.Cells[nRow, 4].Value := '车型';
    excelApp.Cells[nRow, 5].Value := '车号';
    excelApp.Cells[nRow, 6].Value := '车次';  
    excelApp.Cells[nRow, 7].Value := '备注类型';
    excelApp.Cells[nRow, 8].Value := '计划开车时间';
    excelApp.Cells[nRow, 9].Value := '值乘类型';       
    excelApp.Cells[nRow, 10].Value := '计划类型';
    excelApp.Cells[nRow, 11].Value := '牵引状态';
    excelApp.Cells[nRow, 12].Value := '客货';

    Inc(nRow);
    n := Length(TrainPlanArray);
    for i := 0 to n - 1 do
    begin
      excelApp.Cells[nRow, 1].Value := IntToStr(i + 1);
      excelApp.Cells[nRow, 2].Value := TRsPlanStateNameAry[TrainPlanArray[i].nPlanState];
      excelApp.Cells[nRow, 3].Value := TrainPlanArray[i].strTrainJiaoluName;     
      excelApp.Cells[nRow, 4].Value := TrainPlanArray[i].strTrainTypeName;
      excelApp.Cells[nRow, 5].Value := TrainPlanArray[i].strTrainNumber;   
      excelApp.Cells[nRow, 6].Value := TrainPlanArray[i].strTrainNo;  
      excelApp.Cells[nRow, 7].Value := TRsPlanRemarkTypeName[TrainPlanArray[i].nRemarkType];
      excelApp.Cells[nRow, 8].Value := FormatDateTime('yy-MM-dd hh:nn', TrainPlanArray[i].dtStartTime); 
      excelApp.Cells[nRow, 9].Value := TRsTrainmanTypeName[TrainPlanArray[i].nTrainmanTypeID];
      excelApp.Cells[nRow, 10].Value := TRsPlanTypeName[TrainPlanArray[i].nPlanType];
      excelApp.Cells[nRow, 11].Value := TRsDragTypeName[TrainPlanArray[i].nDragType];
      excelApp.Cells[nRow, 12].Value := TRsKeHuoNameArray[TrainPlanArray[i].nKeHuoID];

      if Assigned(m_OnExportPlanProgress) then m_OnExportPlanProgress(i+1, n);
      Inc(nRow);
    end;
    if not FileExists(ExcelFile) then workSheet.SaveAs(excelFile);
    result := true;
  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

function TDBExportPlan.SaveToExcel(BeginTime, EndTime: TDateTime; TrainJiaoluGUID, ExcelFile: string): boolean;
var
  TrainPlanArray: TRsTrainPlanArray;
begin
  GetTrainPlans(BeginTime, EndTime, TrainJiaoluGUID, TrainPlanArray);
  result := SaveToExcel(TrainPlanArray, ExcelFile);
end;

end.
