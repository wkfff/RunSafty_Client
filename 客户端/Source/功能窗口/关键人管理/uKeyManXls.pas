unit uKeyManXls;

interface
uses
  classes,SysUtils,ComObj,uTFSystem,AdvGrid,uFrmProgressEx,Variants,uLCKeyMan;
type
  TKeyManXls = class
  public
    class procedure ExportToXls(const FileName: string;Grid: TAdvStringGrid);
    class procedure ImportFromXls(const FileName: string;KeyTrainmanList: TKeyTrainmanList);
  end;
implementation

{ TKeyManXls }

class procedure TKeyManXls.ExportToXls(const FileName: string;Grid: TAdvStringGrid);
var
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
begin

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(FileName) then
    begin
      excelApp.workBooks.Open(FileName);
      workSheet := excelApp.Worksheets[1];
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;
    m_nIndex := 1;
    workSheet.Cells[m_nIndex,1] := '序号';
    workSheet.Cells[m_nIndex,2] := '车间';
    workSheet.Cells[m_nIndex,3] := '车队';
    workSheet.Cells[m_nIndex,4] := '工号';
    workSheet.Cells[m_nIndex,5] := '姓名';
    workSheet.Cells[m_nIndex,6] := '关键人原因';
    workSheet.Cells[m_nIndex,7] := '关键人注意事项';
    workSheet.Cells[m_nIndex,8] := '起始时间';
    workSheet.Cells[m_nIndex,9] := '截止时间';
    workSheet.Cells[m_nIndex,10] := '登记时间';
    workSheet.Cells[m_nIndex,11] := '登记人工号';
    workSheet.Cells[m_nIndex,12] := '登记人姓名';
    workSheet.Cells[m_nIndex,13] := '客户端编号';
    workSheet.Cells[m_nIndex,14] := '客户端名称';

    Inc(m_nIndex);
    for i := 1 to Grid.RowCount - 1 do
    begin
      if Grid.Cells[99, i] <> '' then
      begin
        workSheet.Cells[m_nIndex,1] := Grid.Cells[0, i];
        workSheet.Cells[m_nIndex,2] := Grid.Cells[2, i];
        workSheet.Cells[m_nIndex,3] := Grid.Cells[3, i];
        workSheet.Cells[m_nIndex,4] := Grid.Cells[4, i];
        workSheet.Cells[m_nIndex,5] := Grid.Cells[5, i];
        workSheet.Cells[m_nIndex,6] := Grid.Cells[6, i];
        workSheet.Cells[m_nIndex,7] := Grid.Cells[7, i];
        workSheet.Cells[m_nIndex,8] := Grid.Cells[8, i];
        workSheet.Cells[m_nIndex,9] := Grid.Cells[9, i];
        workSheet.Cells[m_nIndex,10] := Grid.Cells[10, i];
        workSheet.Cells[m_nIndex,11] := Grid.Cells[11, i];
        workSheet.Cells[m_nIndex,12] := Grid.Cells[12, i];
        workSheet.Cells[m_nIndex,13] := Grid.Cells[13, i];
        workSheet.Cells[m_nIndex,14] := Grid.Cells[14, i];
      end;
      TfrmProgressEx.ShowProgress('正在导出信息，请稍后',i,Grid.RowCount-1);
      Inc(m_nIndex);
    end;
    if not FileExists(FileName) then
    begin
      workSheet.SaveAs(FileName);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  
end;

class procedure TKeyManXls.ImportFromXls(const FileName: string;
  KeyTrainmanList: TKeyTrainmanList);
var
  excelApp,workSheet: Variant;
  nIndex : integer;
  KeyTrainman: TKeyTrainman;
  cellValue: string;
begin
  if not FileExists(FileName) then Exit;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(FileName);
    workSheet := excelApp.Worksheets[1];
    cellValue := workSheet.Cells[2,1];
    nIndex := 2;
    while cellValue <> '' do
    begin
      KeyTrainman := TKeyTrainman.Create;
      KeyTrainman.KeyTMNumber := workSheet.Cells[nIndex,1];
      KeyTrainman.KeyTMName := workSheet.Cells[nIndex,2];
      KeyTrainman.KeyTMCheDuiName := workSheet.Cells[nIndex,3];
      KeyTrainman.KeyStartTime := StrToDateDef(workSheet.Cells[nIndex,4],0);
      KeyTrainman.KeyEndTime := StrToDateDef(workSheet.Cells[nIndex,5],0);
      KeyTrainman.KeyReason := workSheet.Cells[nIndex,6];
      KeyTrainman.KeyAnnouncements := workSheet.Cells[nIndex,7];

      KeyTrainmanList.Add(KeyTrainman);
      Inc(nIndex);
      cellValue := workSheet.Cells[nIndex,1];
    end;

  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

end.
