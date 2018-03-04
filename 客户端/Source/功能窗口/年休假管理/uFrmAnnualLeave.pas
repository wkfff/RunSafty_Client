unit uFrmAnnualLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, RzPanel, RzButton, Grids, AdvObj, BaseGrid,
  AdvGrid, Buttons, PngSpeedButton, StdCtrls, RzCmboBx, RzStatus,uLCAnnualLeave,
  DateUtils,uTFSystem,math,comobj, Menus,uFrmAnnualLog,uFrmAnnualDelRecord;

type
  TAnnualImporter = class
  public
    class procedure Import(const FileName: string;LeaveList: TAnnualLeaveList);
  end;
  TFrmAnnualLeave = class(TForm)
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnInsertRecord: TRzToolButton;
    BtnDelete: TRzToolButton;
    BtnImport: TRzToolButton;
    BtnExit: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzStatusBar1: TRzStatusBar;
    AdvGrid: TAdvStringGrid;
    pnl4: TRzPanel;
    btnQuery: TPngSpeedButton;
    cbbYear: TRzComboBox;
    cbbMonth: TRzComboBox;
    RzStatusPane1: TRzStatusPane;
    Label1: TLabel;
    popDropdow: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    BtnViewDetails: TRzToolButton;
    RzSpacer3: TRzSpacer;
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure BtnInsertRecordClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure AdvGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormShow(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure BtnViewDetailsClick(Sender: TObject);
  private
    { Private declarations }
    m_LCAnnualLeave: TRsLCAnnualLeave;
    m_LeaveList: TAnnualLeaveList;
    procedure Init();
    procedure FillGrid();
    procedure AddLeaveToGridRow(AnnualLeave: TAnnualLeave;RowIndex: integer);
  public
    { Public declarations }
  end;


implementation

uses uGlobalDM, uFrmAnnualAdd, ufrmHint;

{$R *.dfm}

procedure TFrmAnnualLeave.AddLeaveToGridRow(AnnualLeave: TAnnualLeave;
  RowIndex: integer);
  function GetLeaveStateStr(LeaveState: integer): string;
  begin
    case LeaveState of
      0: result := '';
      1: result := '√';
      2: result := '-';
    end;
  end;

  function GetLeaveDays(): string;
  begin
    if AnnualLeave.LeaveState > 0 then
      Result := IntToStr(AnnualLeave.LeaveDays)
    else
      Result := '';
  end;
  function GetLeftDays(): string;
  begin
    Result := IntToStr(Max(AnnualLeave.NeedDays - AnnualLeave.LeaveDays,0));
  end;
begin
  AdvGrid.Objects[0,RowIndex] := AnnualLeave;
  
  AdvGrid.Cells[0,RowIndex] := IntToStr(RowIndex);
  AdvGrid.Cells[1,RowIndex] := AnnualLeave.TrainmanNumber;
  AdvGrid.Cells[2,RowIndex] := AnnualLeave.TrainmanName;
  AdvGrid.Cells[3,RowIndex] := IntToStr(AnnualLeave.Year) + '-' + IntToStr(AnnualLeave.Month);
  AdvGrid.Cells[4,RowIndex] := GetLeaveStateStr(AnnualLeave.LeaveState);
  AdvGrid.Cells[5,RowIndex] := GetLeaveDays();
  AdvGrid.Cells[6,RowIndex] := IntToStr(AnnualLeave.NeedDays);
  AdvGrid.Cells[7,RowIndex] := GetLeftDays();
end;

procedure TFrmAnnualLeave.AdvGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if AdvGrid.Objects[0,ARow] = nil then Exit;

  case TAnnualLeave(AdvGrid.Objects[0,ARow]).LeaveState of
    1: ABrush.Color := $00E9CB85;
    2: ABrush.Color := $00E3E3DF;
  else
    Exit;
  end;


end;

procedure TFrmAnnualLeave.BtnDeleteClick(Sender: TObject);
var
  log: string;
begin
  if AdvGrid.Row < 1 then Exit;


  if m_LeaveList.Count = 0 then Exit;
  
  if not TBox('确定要删除记录吗？') then Exit;

  if not TFrmAnnualLog.InputLog(log) then Exit;

  m_LCAnnualLeave.Del(TAnnualLeave(AdvGrid.Objects[0,AdvGrid.Row]).ID,log);
  btnQuery.Click;
end;

procedure TFrmAnnualLeave.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAnnualLeave.BtnInsertRecordClick(Sender: TObject);
var
  AnnualLeave: TAnnualLeave;
begin
  AnnualLeave := TAnnualLeave.Create;
  try
    AnnualLeave.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
    AnnualLeave.ID := NewGUID;

    if TFrmAnnualAdd.Add(AnnualLeave) then
    begin
      m_LCAnnualLeave.Add(AnnualLeave);
      btnQueryClick(nil);
    end;

  finally
    AnnualLeave.Free;
  end;

end;

procedure TFrmAnnualLeave.btnQueryClick(Sender: TObject);
var
  AnnualQC: TAnnualQC;
begin
  AnnualQC := TAnnualQC.Create;
  try
    AnnualQC.Year := StrToIntDef(cbbYear.Value,0);
    AnnualQC.Month := cbbMonth.ItemIndex;
    AnnualQC.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
    m_LCAnnualLeave.Get(AnnualQC,m_LeaveList);

    FillGrid();    
  finally
    AnnualQC.Free;
  end;

end;

procedure TFrmAnnualLeave.BtnViewDetailsClick(Sender: TObject);
var
  FrmAnnualDelRecord: TFrmAnnualDelRecord;
begin
  FrmAnnualDelRecord := TFrmAnnualDelRecord.Create(nil);
  try
    FrmAnnualDelRecord.ShowModal;
  finally
    FrmAnnualDelRecord.Free;
  end;
end;

procedure TFrmAnnualLeave.FillGrid;
var
  I: Integer;
begin
  AdvGrid.ClearRows(1,AdvGrid.RowCount - 1);
  AdvGrid.RowCount := Max(m_LeaveList.Count + 1,2);
  
  for I := 0 to m_LeaveList.Count - 1 do
  begin
    AddLeaveToGridRow(m_LeaveList.Items[i],i + 1);
  end;

end;

procedure TFrmAnnualLeave.FormCreate(Sender: TObject);
begin
  Init();
  m_LCAnnualLeave := TRsLCAnnualLeave.Create(GlobalDM.WebAPIUtils);
  m_LeaveList := TAnnualLeaveList.Create;
end;

procedure TFrmAnnualLeave.FormDestroy(Sender: TObject);
begin
  m_LCAnnualLeave.Free;
  m_LeaveList.Free;
end;

procedure TFrmAnnualLeave.FormShow(Sender: TObject);
begin
  btnQuery.Click;
end;

procedure TFrmAnnualLeave.Init;
var
  I: Integer;
begin
  cbbYear.Clear();

  cbbYear.Add('全部');
  for I := YearOf(Now) - 3 to YearOf(Now) do
  begin
    cbbYear.Add(IntToStr(i));
  end;

  cbbYear.ItemIndex := cbbYear.Items.IndexOf(IntToStr(YearOf(Now)));
  cbbMonth.Clear();
  cbbMonth.Add('全部');
  for I := 1 to 12 do
  begin
    cbbMonth.Add(IntToStr(i));
  end;

  cbbMonth.ItemIndex := MonthOf(Now);
end;

procedure TFrmAnnualLeave.N1Click(Sender: TObject);
begin
  SaveDialog1.FileName := '年休假导入模板.xls';
  if SaveDialog1.Execute then
  begin
    if not CopyFile(PChar(GlobalDM.AppPath + 'xlsTemplates\AnnualLeave.xls'),
      PChar(SaveDialog1.FileName),True) then
    begin
      Box(SysErrorMessage(GetLastError));
    end;
  end;

end;

procedure TFrmAnnualLeave.N2Click(Sender: TObject);
var
  LeaveList: TAnnualLeaveList;
  I: Integer;
begin
  if OpenDialog1.Execute then
  begin
    TfrmHint.ShowHint('正在导入数据，请稍候……');
    LeaveList := TAnnualLeaveList.Create;
    try
      TAnnualImporter.Import(OpenDialog1.FileName,LeaveList);

      for I := 0 to LeaveList.Count - 1 do
      begin
        LeaveList.Items[i].WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
        LeaveList.Items[i].ID := NewGUID;
      end;
      
      m_LCAnnualLeave.BatchAdd(LeaveList);
      
      btnQuery.Click;
    finally
      TfrmHint.CloseHint();
      LeaveList.Free;
    end;
    
  end;
  
end;

{ TAnnualImporter }

class procedure TAnnualImporter.Import(const FileName: string;
  LeaveList: TAnnualLeaveList);
var
   MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
   i : Integer;
   Temp : string;
   AnnualLeave: TAnnualLeave;
begin
  MSExcel := CreateOleObject('Excel.Application');
  try
    LeaveList.Clear;
    MSExcel.WorkBooks.Open(FileName);
    MSExcelWorkBook :=MSExcel.Workbooks[1];
    MSExcelWorkSheet := MSExcelWorkBook.WorkSheets[1];
    i := 2;
    Temp := MSExcelWorkSheet.Cells[i,1];
    while Temp <> '' do
    begin
      AnnualLeave := TAnnualLeave.Create;
      LeaveList.Add(AnnualLeave);
      AnnualLeave.TrainmanNumber := MSExcelWorkSheet.Cells[i,1];
      AnnualLeave.TrainmanName := MSExcelWorkSheet.Cells[i,2];
      AnnualLeave.Year := MSExcelWorkSheet.Cells[i,3];
      AnnualLeave.Month := MSExcelWorkSheet.Cells[i,4];
      AnnualLeave.NeedDays := StrToIntDef(MSExcelWorkSheet.Cells[i,5],0);
      inc(i);
      Temp := MSExcelWorkSheet.Cells[i,1];
    end;
  finally
    MSExcel.Quit;
  end;

end;

end.
