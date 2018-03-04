unit uFrmPaiBanRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, ExtCtrls, StdCtrls, Buttons, PngSpeedButton,
  RzPanel, Grids, AdvObj, BaseGrid, AdvGrid, RzButton, RzRadChk, Mask, RzEdit,
  RzCmboBx,uTrainJiaolu,uTrainPlan,uTFSystem,
  RzLstBox, RzChkLst,uSaftyEnum,uTrainman,DateUtils,ComObj,ufrmProgressEx,
  uLCBaseDict,uLCPaiBan;

type
  TfrmPaibanRecord = class(TForm)
    RzPanel3: TRzPanel;
    btnQuery: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    dtpBeginDate: TRzDateTimePicker;
    strGridLeaveInfo: TAdvStringGrid;
    Label1: TLabel;
    radioDay: TRadioButton;
    radioNight: TRadioButton;
    RzPanel1: TRzPanel;
    rgTrainjiaolu: TRzCheckList;
    OpenDialog1: TOpenDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_TrainJiaoluArray : TRsTrainJiaoluArray;
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    m_LCPaiBan: TLCPaiBan;
    procedure Init;
  public
    { Public declarations }
    class procedure Open();
  end;



implementation

{$R *.dfm}
 uses
   uGlobalDM;
 var
  frmPaibanRecord: TfrmPaibanRecord;  
{ TfrmPaibanRecord }
function GetTimeText(BT,ET : TDateTime) : string;
var
  minutes : Int64;
begin
  minutes :=  MinutesBetween(ET,BT);
  result := Format('%d.%d',[minutes div 60, minutes mod 60]);
end;
procedure TfrmPaibanRecord.btnExportClick(Sender: TObject);
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
begin
  if length(m_TrainmanPlanArray) < 1 then
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;
  if (strGridLeaveInfo.RowCount = 2) and (strGridLeaveInfo.Cells[999, 1] = '') then 
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;

  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
      excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;

    m_nIndex := 1;
    excelApp.Cells[m_nIndex,1].Value := '序号';
    excelApp.Cells[m_nIndex,2].Value := '车次';
    excelApp.Cells[m_nIndex,3].Value := '接车地点';
    excelApp.Cells[m_nIndex,4].Value := '机车号';
    excelApp.Cells[m_nIndex,5].Value := '出勤时间';
    excelApp.Cells[m_nIndex,6].Value := '司机A';
    excelApp.Cells[m_nIndex,7].Value := '退勤时间';
    excelApp.Cells[m_nIndex,8].Value := '休息时长';
    excelApp.Cells[m_nIndex,9].Value := '司机B';
    excelApp.Cells[m_nIndex,10].Value := '退勤时间';
    excelApp.Cells[m_nIndex,11].Value := '休息时长';
    
    Inc(m_nIndex);
    for i := 1 to strGridLeaveInfo.RowCount - 1 do
    begin
      if strGridLeaveInfo.Cells[999, i] <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := strGridLeaveInfo.Cells[0, i];
        excelApp.Cells[m_nIndex,2].Value := strGridLeaveInfo.Cells[1, i];
        excelApp.Cells[m_nIndex,3].Value := strGridLeaveInfo.Cells[2, i];
        excelApp.Cells[m_nIndex,4].Value := strGridLeaveInfo.Cells[3, i];
        excelApp.Cells[m_nIndex,5].Value := strGridLeaveInfo.Cells[4, i];
        excelApp.Cells[m_nIndex,6].Value := strGridLeaveInfo.Cells[5, i];
        excelApp.Cells[m_nIndex,7].Value := strGridLeaveInfo.Cells[6, i];
        excelApp.Cells[m_nIndex,8].Value := strGridLeaveInfo.Cells[7, i];
        excelApp.Cells[m_nIndex,9].Value := strGridLeaveInfo.Cells[8, i];
        excelApp.Cells[m_nIndex,10].Value := strGridLeaveInfo.Cells[9, i];
        excelApp.Cells[m_nIndex,11].Value := strGridLeaveInfo.Cells[10, i];
      end;
      TfrmProgressEx.ShowProgress('正在导出派班日志写实，请稍后',i,strGridLeaveInfo.RowCount-1);
      Inc(m_nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Box('导出完毕！');
end;

procedure TfrmPaibanRecord.btnQueryClick(Sender: TObject);
var
  i: Integer;
  jiaolus : TStrings;
  dtBeginTime,dtEndTime : TDateTime;
begin
  if not (radioDay.Checked  or radioNight.Checked )then
  begin
    Box('请选择白班或者夜班');
    exit;
  end;

  dtBeginTime := DateOf(dtpBeginDate.Date) + StrToTime('09:00:00');
  dtEndTime := DateOf(dtpBeginDate.Date) + StrToTime('20:59:59');

  if radioNight.Checked then
  begin
    dtBeginTime := DateOf(dtpBeginDate.Date) + StrToTime('21:00:00');
    dtEndTime := DateOf(dtpBeginDate.Date) + 1 + StrToTime('08:59:59');
  end;
  jiaolus := TStringList.Create;
  try
    for i := 0 to rgTrainjiaolu.Count - 1 do
    begin
      if rgTrainjiaolu.ItemChecked[i] then
      begin
        jiaolus.Add(m_TrainjiaoluArray[i].strTrainJiaoluGUID);
      end;
    end;

  if jiaolus.Count =0 then
  begin
    Box('请选择行车交路');
    exit;
  end;
  m_LCPaiBan.GetXSTrainmanPlans(dtBeginTime,dtEndTime,jiaolus,m_TrainmanPlanArray);

  with strGridLeaveInfo do
  begin
    ClearRows(1,10000);
    if length(m_TrainmanPlanArray) > 0  then
      RowCount := length(m_TrainmanPlanArray) + 1
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
    for i := 0 to length(m_TrainmanPlanArray) - 1 do
    begin
      Cells[0, i + 1] := IntToStr(i + 1);
      Cells[1, i + 1] := m_TrainmanPlanArray[i].TrainPlan.strTrainNo;
      Cells[2, i + 1] := TRsPlanRemarkTypeName[m_TrainmanPlanArray[i].TrainPlan.nRemarkType];
      Cells[3, i + 1] :=  m_TrainmanPlanArray[i].TrainPlan.strTrainNumber;
      Cells[4, i + 1] :=  FormatDateTime('yy-MM-dd hh:nn', m_TrainmanPlanArray[i].TrainPlan.dtStartTime);
      if m_TrainmanPlanArray[i].Group.strGroupGUID  <> '' then
      begin
        Cells[5, i + 1] :=  GetTrainmanText(m_TrainmanPlanArray[i].Group.Trainman1);
        if m_TrainmanPlanArray[i].Group.dtLastEndworkTime1 > 0 then
        begin
          Cells[6, i + 1] :=  FormatDateTime('yy-MM-dd hh:nn', m_TrainmanPlanArray[i].Group.dtLastEndworkTime1);
          Cells[7, i + 1] :=  GetTimeText(m_TrainmanPlanArray[i].TrainPlan.dtStartTime,m_TrainmanPlanArray[i].Group.dtLastEndworkTime1);
        end;

        Cells[8, i + 1] :=  GetTrainmanText(m_TrainmanPlanArray[i].Group.Trainman2);
        if m_TrainmanPlanArray[i].Group.dtLastEndworkTime2> 0 then
        begin
          Cells[9, i + 1] :=  FormatDateTime('yy-MM-dd hh:nn', m_TrainmanPlanArray[i].Group.dtLastEndworkTime2);
          Cells[10, i + 1] :=  GetTimeText(m_TrainmanPlanArray[i].TrainPlan.dtStartTime,m_TrainmanPlanArray[i].Group.dtLastEndworkTime2);
        end;
        Cells[999, i + 1] := m_TrainmanPlanArray[i].TrainPlan.strTrainPlanGUID; 
      end;
    end;
    Invalidate;
  end;
  finally
    jiaolus.Free;
  end;
end;

procedure TfrmPaibanRecord.FormCreate(Sender: TObject);
begin
  m_LCPaiBan := TLCPaiBan.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmPaibanRecord.FormDestroy(Sender: TObject);
begin
  m_LCPaiBan.Free;
end;

procedure TfrmPaibanRecord.Init;
var
  i: Integer;
begin
  dtpBeginDate.DateTime := now;
  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainjiaoluArray);
  rgTrainjiaolu.Items.Clear;
  for i := 0 to length(m_TrainjiaoluArray) - 1 do
  begin
    rgTrainjiaolu.Items.Add(m_TrainJiaoluArray[i].strTrainJiaoluName);
  end;
end;

class procedure TfrmPaibanRecord.Open;
begin
  frmPaibanRecord:= TfrmPaibanRecord.Create(nil);
  try
    frmPaibanRecord.Init;
    frmPaibanRecord.ShowModal;
  finally
    frmPaibanRecord.Free;
  end;
end;

end.
