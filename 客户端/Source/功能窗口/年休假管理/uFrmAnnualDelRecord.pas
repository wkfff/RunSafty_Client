unit uFrmAnnualDelRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, RzPanel, RzButton, Grids, AdvObj, BaseGrid,
  AdvGrid, Buttons, PngSpeedButton, StdCtrls, RzCmboBx, RzStatus,uLCAnnualLeave,
  DateUtils,uTFSystem,math,comobj, Menus,uFrmAnnualLog;

type
  TFrmAnnualDelRecord = class(TForm)
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnExit: TRzToolButton;
    RzStatusBar1: TRzStatusBar;
    AdvGrid: TAdvStringGrid;
    RzStatusPane1: TRzStatusPane;
    popDropdow: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    btnQuery: TPngSpeedButton;
    cbbMonth: TRzComboBox;
    cbbYear: TRzComboBox;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    RzSpacer5: TRzSpacer;
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

uses uGlobalDM;

{$R *.dfm}

procedure TFrmAnnualDelRecord.AddLeaveToGridRow(AnnualLeave: TAnnualLeave;
  RowIndex: integer);
begin
  AdvGrid.Objects[0,RowIndex] := AnnualLeave;
  
  AdvGrid.Cells[0,RowIndex] := IntToStr(RowIndex);
  AdvGrid.Cells[1,RowIndex] := AnnualLeave.TrainmanNumber;
  AdvGrid.Cells[2,RowIndex] := AnnualLeave.TrainmanName;
  AdvGrid.Cells[3,RowIndex] := IntToStr(AnnualLeave.Year) + '-' + IntToStr(AnnualLeave.Month);
  AdvGrid.Cells[4,RowIndex] := AnnualLeave.DelReason;

end;

procedure TFrmAnnualDelRecord.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAnnualDelRecord.btnQueryClick(Sender: TObject);
var
  AnnualQC: TAnnualQC;
begin
  AnnualQC := TAnnualQC.Create;
  try
    AnnualQC.Year := StrToIntDef(cbbYear.Value,0);
    AnnualQC.Month := cbbMonth.ItemIndex;
    AnnualQC.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
    AnnualQC.State := 1;
    m_LCAnnualLeave.Get(AnnualQC,m_LeaveList);

    FillGrid();    
  finally
    AnnualQC.Free;
  end;

end;

procedure TFrmAnnualDelRecord.FillGrid;
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

procedure TFrmAnnualDelRecord.FormCreate(Sender: TObject);
begin
  Init();
  m_LCAnnualLeave := TRsLCAnnualLeave.Create(GlobalDM.WebAPIUtils);
  m_LeaveList := TAnnualLeaveList.Create;
end;

procedure TFrmAnnualDelRecord.FormDestroy(Sender: TObject);
begin
  m_LCAnnualLeave.Free;
  m_LeaveList.Free;
end;

procedure TFrmAnnualDelRecord.FormShow(Sender: TObject);
begin
  btnQuery.Click;
end;

procedure TFrmAnnualDelRecord.Init;
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

end.
