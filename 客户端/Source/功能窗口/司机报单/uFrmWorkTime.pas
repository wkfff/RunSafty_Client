unit uFrmWorkTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, RzCmboBx, PngSpeedButton, ExtCtrls,
  RzStatus, RzPanel, Buttons, PngCustomButton,uWorkTime,uDBWorkTime, Grids,
  AdvObj, BaseGrid, AdvGrid, RzDTP, Mask, RzEdit,uDBRunEvent,uGlobalDM ;

type
  TfrmWorkTime = class(TForm)
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    Panel2: TPanel;
    ActionList1: TActionList;
    Action1: TAction;
    strGridWorkTime: TAdvStringGrid;
    RzPanel1: TRzPanel;
    btnQuery: TPngSpeedButton;
    Label3: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    dtpBeginDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    edtTrainmanNumber: TRzEdit;
    edtTrainmanName: TRzEdit;
    btnViewDetail: TPngSpeedButton;
    btnDeport: TPngSpeedButton;
    btnReCount: TPngSpeedButton;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnViewDetailClick(Sender: TObject);
    procedure btnReCountClick(Sender: TObject);
    procedure strGridWorkTimeDblClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    { Private declarations }
    m_DBWorkTime : TDBWorkTime;
    m_DBRunEvent : TRsDBRunEvent;
    m_WorkTimeArray : TRsWorkTimeArray;
    procedure Init;
    procedure InitWorkTime;
  public
    { Public declarations }
    class procedure OpenWorkTimeForm;
  end;



implementation
uses
  DateUtils,uTrainman,uFrmWorkTimeDetail,uFrmWorkTimeEdit;
{$R *.dfm}

{ TfrmWorkTime }

procedure TfrmWorkTime.btnQueryClick(Sender: TObject);
begin
  InitWorkTime;
end;

procedure TfrmWorkTime.btnReCountClick(Sender: TObject);
var
  strTrainPlanGUID : string;
begin
  if length(m_WorkTimeArray) = 0 then exit;
  strTrainPlanGUID := m_WorkTimeArray[strGridWorkTime.Row - 1].TrainmanPlan.TrainPlan.strTrainPlanGUID;
  m_DBRunEvent.ReCountRunEvent(strTrainPlanGUID);
  InitWorkTime;
end;

procedure TfrmWorkTime.btnViewDetailClick(Sender: TObject);
var
  strTrainPlanGUID : string;
begin
  if length(m_WorkTimeArray) = 0 then exit;
  strTrainPlanGUID := m_WorkTimeArray[strGridWorkTime.Row - 1].TrainmanPlan.TrainPlan.strTrainPlanGUID;
  TfrmWorkTimeDetail.ShowWorkTimeDetail(strTrainPlanGUID);
end;

procedure TfrmWorkTime.FormCreate(Sender: TObject);
begin
  m_DBWorkTime := TRsDBWorkTime.Create(GlobalDM.ADOConnection);
  m_DBRunEvent := TRsDBRunEvent.Create(GlobalDM.ADOConnection);
end;

procedure TfrmWorkTime.FormDestroy(Sender: TObject);
begin
  m_DBWorkTime.Free;
  m_DBRunEvent.Free;
end;

procedure TfrmWorkTime.Init;
var
  dtNow : TDateTime;
begin
  dtNow := GlobalDM.GetNow;

  dtpBeginDate.DateTime := IncDay(dtNow,-1);
  dtpEndDate.DateTime := dtNow;
end;
function GetDateTimeString(DT : TdateTime) : string;
begin
  result := '';
  if DT > 0 then
    Result := FormatDateTime('yy-MM-dd HH:nn',DT);
end;
procedure TfrmWorkTime.InitWorkTime;
var
  dtBeginTime,dtEndTime : TDateTime;
  i : integer;
  nSum : integer;
begin
  dtBeginTime :=  DateOf(dtpBeginDate.DateTime);
  dtEndTime :=IncSecond(DateOf(dtpEndDate.DateTime),-1);
  m_DBWorkTime.QueryWorkTime(dtBeginTime,dtEndTime,GlobalDM.SiteInfo.WorkShopGUID,
    Trim(edtTrainmanNumber.Text),trim(edtTrainmanName.Text),m_WorkTimeArray);
  nSum := 0;  
  with strGridWorkTime do
  begin
    ClearRows(1, 10000);
    if length(m_WorkTimeArray) > 0 then
      RowCount := length(m_WorkTimeArray) + 1
    else begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
    for i := 0 to length(m_WorkTimeArray) - 1 do
    begin
      RowHeights[i + 1] := 40;
      Cells[0,i + 1] := IntToStr(i + 1);
      Cells[1,i + 1] := m_WorkTimeArray[i].TrainmanPlan.TrainPlan.strTrainJiaoluName;
      Cells[2,i + 1] := m_WorkTimeArray[i].TrainmanPlan.TrainPlan.strTrainNumber;
      Cells[3,i + 1] := GetTrainmanText(m_WorkTimeArray[i].TrainmanPlan.Group.Trainman1);
      Cells[4,i + 1] := GetTrainmanText(m_WorkTimeArray[i].TrainmanPlan.Group.Trainman2);
      Cells[5,i + 1] := GetTrainmanText(m_WorkTimeArray[i].TrainmanPlan.Group.Trainman3);
      Cells[6,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtBeginWorkTime);
      Cells[7,i + 1] := m_WorkTimeArray[i].TrainmanPlan.TrainPlan.strTrainNo;
      Cells[8,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtStartTime);
      Cells[9,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtArriveTime);
      Cells[10,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtInRoomTime);
      Cells[11,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtOutRoomTime);
      Cells[12,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtStartTime2);
      Cells[13,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtArriveTime2);
      Cells[14,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtEndWorkTime);
      Cells[15,i + 1] := IntToStr(m_WorkTimeArray[i].fBeginTotalTime);
      Cells[16,i + 1] := IntToStr(m_WorkTimeArray[i].fRunTotalTime);
      Cells[17,i + 1] := IntToStr(m_WorkTimeArray[i].fEndTotalTime);
      Cells[18,i + 1] := IntToStr(m_WorkTimeArray[i].fTotalTime);
      nSum := nSum + m_WorkTimeArray[i].fTotalTime;
      Cells[19,i + 1] := m_WorkTimeArray[i].strDestStationName;
      if (m_WorkTimeArray[i].bLocalOutDepots > 0) then
        Cells[20,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtLocalOutDepotsTime)
      else
        Cells[20,i + 1] := '直通';

      if (m_WorkTimeArray[i].bDestInDepots > 0) then
        Cells[21,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtDestInDepotsTime)
      else
        Cells[21,i + 1] := '直通';

      if (m_WorkTimeArray[i].bDestOutDepots > 0) then
        Cells[22,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtDestOutDepotsTime)
      else
        Cells[22,i + 1] := '直通';

      if (m_WorkTimeArray[i].bLocalInDepots > 0) then
        Cells[23,i + 1] := GetDateTimeString(m_WorkTimeArray[i].dtLocalInDepotsTime)
      else
        Cells[23,i + 1] := '直通';

      Cells[24,i + 1] := m_WorkTimeArray[i].strBackTrainNumber;
      Cells[25,i + 1] := m_WorkTimeArray[i].strBackTrainNo;
      Cells[26,i + 1] := FormatDateTime('yy-MM-dd HH:nn',m_WorkTimeArray[i].dtRealArriveTime);
      Cells[27,i + 1] := '';
      if m_WorkTimeArray[i].bConfirm > 0 then
        Cells[27,i + 1] := '已确认';
      Cells[28,i + 1] := IntToStr(m_WorkTimeArray[i].nLocalStopMinutes);
      Cells[29,i + 1] := IntToStr(m_WorkTimeArray[i].nRemoteStopMinutes);
      Cells[30,i + 1] := m_WorkTimeArray[i].strArriveStationName;

      Cells[99,i + 1] := m_WorkTimeArray[i].strFlowID;
    end;
    statusSum.Caption := Format('共计%d时%d分',[nSum div 60,nSum mod 60]);
  end;

end;

class procedure TfrmWorkTime.OpenWorkTimeForm;
var
  frmWorkTime: TfrmWorkTime;
begin
  frmWorkTime:= TfrmWorkTime.Create(nil);
  try
    frmWorkTime.Init;
    frmWorkTime.ShowModal;
  finally
    frmWorkTime.Free;
  end;
end;

procedure TfrmWorkTime.strGridWorkTimeDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
begin
  if (ARow) < 0 then exit;
  if (ARow) > length(m_WorkTimeArray) - 1 then exit;

  if TfrmWorkTimeEdit.EditWorkTime(m_WorkTimeArray[strGridWorkTime.Row - 1]) then
  begin
    InitWorkTime;
  end;
end;

end.
