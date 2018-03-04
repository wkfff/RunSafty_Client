unit uGanbuXlsExport;

interface
uses
  ComObj,Classes,SysUtils,uLCDict_GanBu;
type
  TGanBuXlsExport = class
  private
    class procedure CreateTitle(MSExcelWorkSheet: Variant);
  public
    class procedure ExportToXls(GanBuList: TGanBuList;const FileName: string);
    class procedure ImportFromXls(GanBuList: TGanBuList;const FileName: string);
  end;
implementation

{ TGanBuXlsExport }
const XLSTITLEARRAY : array[0..2] of string = ('工号','姓名','职务');
class procedure TGanBuXlsExport.CreateTitle(MSExcelWorkSheet: Variant);
var
  I: Integer;
  Range: Variant;
begin
  for I := 0 to Length(XLSTITLEARRAY) - 1 do
  begin
    Range := MSExcelWorkSheet.Columns[i + 1];
    Range.HorizontalAlignment := $FFFFEFDD;   //左对齐
    MSExcelWorkSheet.Cells[1,i + 1] := XLSTITLEARRAY[i];
  end;
  Range := MSExcelWorkSheet.Columns[1];
  Range.ColumnWidth := 18;

  Range := MSExcelWorkSheet.Columns[2];
  Range.ColumnWidth := 18;

  Range := MSExcelWorkSheet.Columns[3];
  Range.ColumnWidth := 15;
end;

class procedure TGanBuXlsExport.ExportToXls(GanBuList: TGanBuList;
  const FileName: string);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  I: Integer;
begin
  MSExcel := CreateOleObject('Excel.Application');

  try
    MSExcel.DisplayAlerts := 0;
    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];
    CreateTitle(MSExcelWorkSheet);

    for I := 0 to GanBuList.Count - 1 do
    begin

      MSExcelWorkSheet.Cells[i + 2,1] := GanBuList.Items[i].TrainmanNumber;
      MSExcelWorkSheet.Cells[i + 2,2] := GanBuList.Items[i].TrainmanName;
      MSExcelWorkSheet.Cells[i + 2,3] := GanBuList.Items[i].TypeName;
    end;
   
    MSExcelWorkBook.SaveAs(FileName);
  finally
    MSExcel.Quit;
  end;

end;
class procedure TGanBuXlsExport.ImportFromXls(GanBuList: TGanBuList;
  const FileName: string);
var
   MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
   i : Integer;
   Temp : string;
   GanBu: TGanBu;
begin
  MSExcel := CreateOleObject('Excel.Application');
  try
    MSExcel.WorkBooks.Open(FileName);
    MSExcelWorkBook :=MSExcel.Workbooks[1];
    MSExcelWorkSheet := MSExcelWorkBook.WorkSheets['sheet1'];
    i := 2;
    Temp := MSExcelWorkSheet.Cells[i,1];
    while Temp <> '' do
    begin
      GanBu := TGanBu.Create;
      GanBu.TrainmanNumber := MSExcelWorkSheet.Cells[i,1];
      GanBu.TrainmanNumber := MSExcelWorkSheet.Cells[i,2];
      GanBu.TypeName := MSExcelWorkSheet.Cells[i,3];
      inc(i);
      Temp := MSExcelWorkSheet.Cells[i,1];
    end;
  finally
    MSExcel.Quit;
  end;

end;


end.
