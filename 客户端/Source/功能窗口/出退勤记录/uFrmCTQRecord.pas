unit uFrmCTQRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, PngImageList, ExtDlgs, ComCtrls, StdCtrls, Mask, RzEdit,
  RzDTP, RzCmboBx, PngSpeedButton, ExtCtrls, RzStatus, RzPanel, Buttons,
  PngCustomButton, Grids, AdvObj, BaseGrid, AdvGrid,uTrainPlan;

type
  TfrmCTQRecord = class(TForm)
    Label12: TLabel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    Panel1: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    btnQuery: TPngSpeedButton;
    dtpUserBeginDate: TRzDateTimePicker;
    dtpUserEndDate: TRzDateTimePicker;
    Panel2: TPanel;
    imgLstBtnMore: TPngImageList;
    dtpDutyDate: TRzDateTimePicker;
    radioDay: TRadioButton;
    radioNight: TRadioButton;
    checkUserDate: TCheckBox;
    dtpUserBeginTime: TRzDateTimePicker;
    dtpUserEndTime: TRzDateTimePicker;
    strGridCTQRecord: TAdvStringGrid;
    procedure checkUserDateClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitData;
    procedure InitColumns;
    procedure InitPlans(BeginTime,EndTime : TDateTime);
    procedure SetUIEnabled(UserDate : boolean);
  public
    { Public declarations }
    class procedure ShowForm();
  end;



implementation
uses
  DateUtils,uLCWebAPI;
var
  frmCTQRecord: TfrmCTQRecord;  
{$R *.dfm}

{ TfrmCTQRecord }

procedure TfrmCTQRecord.btnQueryClick(Sender: TObject);
var
 bTime,eTime : TDateTime;
begin
  if checkUserDate.Checked then
  begin
    bTime := DateOf(dtpUserBeginDate.DateTime) + TimeOf(dtpUserBeginTime.DateTime);
    eTime := DateOf(dtpUserEndDate.DateTime) + TimeOf(dtpUserEndTime.DateTime);
  end else begin
    if radioDay.Checked then
    begin
      bTime := IncHour(DateOf(dtpDutyDate.DateTime),6);
      eTime := IncHour(DateOf(dtpDutyDate.DateTime),18);
    end else begin
      bTime := IncHour(DateOf(dtpDutyDate.DateTime) -1,18);
      eTime := IncHour(DateOf(dtpDutyDate.DateTime),6);
    end;
  end;
  InitColumns;
  InitPlans(bTime,eTime);
end;

procedure TfrmCTQRecord.checkUserDateClick(Sender: TObject);
begin
  SetUIEnabled(checkUserDate.Checked);
end;

procedure TfrmCTQRecord.InitColumns;
begin

  with strGridCTQRecord do
  begin
    ClearRows(0,9999);
    RowCount  := 4;
    FixedRows := 0;
    ColCount := 18;
    FixedCols := 0;

    ColWidths[0] :=60;
    ColWidths[1] :=60;
    ColWidths[2] :=60;
    ColWidths[3] :=60;
    ColWidths[4] :=100;
    ColWidths[5] :=100;
    ColWidths[6] :=100;
    ColWidths[7] :=100;

    ColWidths[8] :=5;

    ColWidths[9] :=60;
    ColWidths[10] :=60;
    ColWidths[11] :=60;
    ColWidths[12] :=60;
    ColWidths[13] :=100;
    ColWidths[14] :=100;
    ColWidths[15] :=100;
    ColWidths[16] :=100;

    ColWidths[17] :=200;
    //第一行
    MergeCells(0,0,18,1);
    RowHeights[0] := 50;
    FontSizes[0,0] := 30;
    Alignments[0,0] := taCenter;
    Cells[0,0] := '乘 务 员 出 勤 本';
    //第二行


    RowHeights[1] := 30;
    FontSizes[0,1] := 16;
    Alignments[0,1] := taCenter;
    MergeCells(0,1,18,1);
    if (not checkUserDate.Checked) then
    begin
      Cells[0,1] := FormatDateTime('yyyy年M月d日',dtpDutyDate.Date) + '   日班   ';
      if radioNight.Checked then
        Cells[0,1] := FormatDateTime('yyyy年M月d日',dtpDutyDate.Date) + '   夜班   ';
    end else begin
      Cells[0,1] := FormatDateTime('yyyy年M月d日 HH:mm',DateOf(dtpUserBeginDate.DateTime) + TimeOf(dtpUserBeginTime.DateTime) ) +
        '-----' +FormatDateTime('yyyy年M月d日 HH:mm',DateOf(dtpUserEndDate.DateTime) + TimeOf(dtpUserEndTime.DateTime) ) ;
    end;
    //第三行
    MergeCells(0,2,8,1);
    Alignments[0,2] := taCenter;
    FontSizes[0,2] := 12;

    Cells[0,2] := ('出             勤');

    FontSizes[9,2] := 12;
    MergeCells(9,2,9,1);
    Alignments[9,2] := taCenter;
    Cells[9,2] := ('退             勤');

    // 第四行
    FontSizes[0,3] := 12;
    Cells[0,3] := '机车';
    Cells[1,3] := '车次';
    Cells[2,3] := '开点';
    Cells[3,3] := '出勤点';
    Cells[4,3] := '司机';
    Cells[5,3] := '副司机';
    Cells[6,3] := '学员';
    Cells[7,3] := '签字';
    Cells[8,3] := '';
    Cells[9,3] := '机车';
    Cells[10,3] := '车次';
    Cells[11,3] := '到达点';
    Cells[12,3] := '退勤点';
    Cells[13,3] := '副司机';
    Cells[14,3] := '副司机';
    Cells[15,3] := '学员';
    Cells[16,3] := '签字';
    Cells[17,3] := '主意事项';
  end;
end;

procedure TfrmCTQRecord.InitData;
begin
  radioDay.Checked := true;
  if (HourOf(Now) >= 18) or (HourOf(Now) < 8) then
  begin
    radioNight.Checked := true;
  end;

  if HourOf(Now) >= 18 then
  begin
    dtpDutyDate.DateTime := DateOf(Now) + 1;


    dtpUserBeginDate.DateTime := DateOf(Now);
    dtpUserBeginTime.DateTime := IncHour(DateOf(Now),18);

    dtpUserEndDate.DateTime := DateOf(Now) + 1;
    dtpUserEndTime.DateTime := IncHour(DateOf(Now) + 1,6);
  end else begin
    dtpDutyDate.DateTime := DateOf(Now);
    

    dtpUserBeginDate.DateTime := DateOf(Now);
    dtpUserBeginTime.DateTime := IncHour(DateOf(Now),6);

    dtpUserEndDate.DateTime := DateOf(Now);
    dtpUserEndTime.DateTime := IncHour(DateOf(Now),18);
  end;
  
  SetUIEnabled(false);
  InitColumns;
end;

procedure TfrmCTQRecord.InitPlans(BeginTime,EndTime : TDateTime);
var
  CQPlans : TRsChuQinPlanArray;
  TQPlans : TRsTuiQinPlanArray;
  strError   : string;
  nCount : integer;
  i: Integer;
begin
  LCWebAPI.LCTrainPlan.GetCQTZByClient(BeginTime,EndTime,CQPlans,strError);
  LCWebAPI.LCTrainPlan.GetTQTZByClient(BeginTime,EndTime,TQPlans,strError);
  nCount := length(CQPlans);
  if (length(TQPlans) > nCount) then
    nCount := Length(TQPlans);
  with strGridCTQRecord do
  begin
    RowCount := 4 + nCount;
    for i := 4 to 4 + Length(CQPlans) - 1 do
    begin
      Cells[0,i] := CQPlans[i-4].TrainPlan.strTrainNumber;
      Cells[1,i] := CQPlans[i-4].TrainPlan.strTrainNo;
      Cells[2,i] := '';
      Cells[3,i] := FormatDateTime('HH:nn',cqplans[i-4].dtBeginworkTime);
      Cells[4,i] := cqplans[i-4].ChuQinGroup.Group.Trainman1.strTrainmanName;
      Cells[5,i] := cqplans[i-4].ChuQinGroup.Group.Trainman2.strTrainmanName;
      Cells[6,i] := cqplans[i-4].ChuQinGroup.Group.Trainman3.strTrainmanName;
      Cells[7,i] := '';
    end;
    for i := 4 to 4 + Length(TQPlans) - 1 do
    begin
      Cells[9,i] := TQPlans[i-4].TrainPlan.strTrainNumber;
      Cells[10,i] := TQPlans[i-4].TrainPlan.strTrainNo;
      Cells[11,i] := '';
      Cells[12,i] := FormatDateTime('HH:nn',TQPlans[i-4].TrainPlan.dtLastArriveTime);
      Cells[13,i] := TQPlans[i-4].TuiQinGroup.Group.Trainman1.strTrainmanName;
      Cells[14,i] := TQPlans[i-4].TuiQinGroup.Group.Trainman2.strTrainmanName;
      Cells[15,i] := TQPlans[i-4].TuiQinGroup.Group.Trainman3.strTrainmanName;
      Cells[16,i] := '';
      Cells[17,i] := '';
    end;
    MergeCells(8,2,1,nCount + 2);  
  end;

end;

procedure TfrmCTQRecord.SetUIEnabled(UserDate: boolean);
begin
  checkUserDate.Checked := UserDate;
  dtpUserBeginDate.Enabled := checkUserDate.Checked;
  dtpUserBeginTime.Enabled := checkUserDate.Checked;
  dtpUserEndDate.Enabled := checkUserDate.Checked;
  dtpUserEndTime.Enabled := checkUserDate.Checked;

  dtpDutyDate.Enabled := not checkUserDate.Checked;
  radioDay.Enabled := not checkUserDate.Checked;
  radioNight.Enabled := not checkUserDate.Checked;
end;

class procedure TfrmCTQRecord.ShowForm;
begin
  frmCTQRecord:= TfrmCTQRecord.Create(nil);
  frmCTQRecord.InitData;
  frmCTQRecord.ShowModal;
  frmCTQRecord.Free;
end;

end.
