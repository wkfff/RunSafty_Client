unit uExportPlan;

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
  TXlsExportPlan = class
  private                   
    m_OnExportPlanProgress: TOnExportPlanProgress; //导出进度事件
  public
    function SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean;
  published
    //导出进度事件
    property OnExportPlanProgress: TOnExportPlanProgress read m_OnExportPlanProgress write m_OnExportPlanProgress;
  end;

implementation

{ TRsDBExportPlan }


function TXlsExportPlan.SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean;
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

end.
