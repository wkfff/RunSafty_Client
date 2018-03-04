unit uExportPlan;

interface

uses
  ADODB, Classes, Variants, ComObj, SysUtils, DateUtils,
  uTFSystem, uSaftyEnum, uTrainPlan, uTrainman;

type
  //���������¼�
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;

type
  //////////////////////////////////////////////////////////////////////////////
  ///���������ƻ���
  //////////////////////////////////////////////////////////////////////////////
  TXlsExportPlan = class
  private                   
    m_OnExportPlanProgress: TOnExportPlanProgress; //���������¼�
  public
    function SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean;
  published
    //���������¼�
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
    strErrorInfo := 'û��Ҫ���������ݣ�';
    exit;
  end;

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strErrorInfo := '�㻹û�а�װMicrosoft Excel�����Ȱ�װ��';
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
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
    excelApp.Cells[nRow, 1].Value := '���';
    excelApp.Cells[nRow, 2].Value := '״̬';
    excelApp.Cells[nRow, 3].Value := '�г�����';
    excelApp.Cells[nRow, 4].Value := '����';
    excelApp.Cells[nRow, 5].Value := '����';
    excelApp.Cells[nRow, 6].Value := '����';  
    excelApp.Cells[nRow, 7].Value := '��ע����';
    excelApp.Cells[nRow, 8].Value := '�ƻ�����ʱ��';
    excelApp.Cells[nRow, 9].Value := 'ֵ������';       
    excelApp.Cells[nRow, 10].Value := '�ƻ�����';
    excelApp.Cells[nRow, 11].Value := 'ǣ��״̬';
    excelApp.Cells[nRow, 12].Value := '�ͻ�';

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
