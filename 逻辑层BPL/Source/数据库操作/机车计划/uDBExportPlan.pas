unit uDBExportPlan;

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
  TDBExportPlan = class(TDBOperate)
  private                   
    m_OnExportPlanProgress: TOnExportPlanProgress; //���������¼�

    //��ADOQuery�������ƻ�
    procedure ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan: RRsTrainPlan);
  public 
    //���ܣ���ȡ�����ƻ�
    procedure GetTrainPlans(BeginTime, EndTime: TDateTime; TrainJiaoluGUID: string; out TrainPlanArray: TRsTrainPlanArray);
    function SaveToExcel(TrainPlanArray: TRsTrainPlanArray; ExcelFile: string): boolean; overload;
    function SaveToExcel(BeginTime, EndTime: TDateTime; TrainJiaoluGUID: string; ExcelFile: string): boolean; overload;
  published
    //���������¼�
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

function TDBExportPlan.SaveToExcel(BeginTime, EndTime: TDateTime; TrainJiaoluGUID, ExcelFile: string): boolean;
var
  TrainPlanArray: TRsTrainPlanArray;
begin
  GetTrainPlans(BeginTime, EndTime, TrainJiaoluGUID, TrainPlanArray);
  result := SaveToExcel(TrainPlanArray, ExcelFile);
end;

end.
