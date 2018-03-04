unit uFrmTuiQinThird;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, RzEdit,
  uTrainPlan,uTrainman,uSaftyEnum,uworkTime,uRunEvent,
  uTFSystem,uFrmProgressEx,ADODB, pngimage, RzTabs, jpeg, OleCtrls, SHDocVw,
  uLCEvent;

type
  RSJBD = record
    strStationName : string;
    strArriveTime : string;
    strPassTime : string;
    strStopMinutes : string;
    strTrainNO : string;
  end;
  TSJBDArray = array of RSJBD;
  
  TfrmTuiQinThird = class(TForm)
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    edtTrainman1: TRzEdit;
    edtStartTime1: TRzEdit;
    edtTotalTime: TRzEdit;
    edtTrainman2: TRzEdit;
    edtArriveTime1: TRzEdit;
    edtOutTime: TRzEdit;
    edtTrainman3: TRzEdit;
    edtRestLength: TRzEdit;
    edtKehuoName: TRzEdit;
    edtStartTime2: TRzEdit;
    edtTrainmanTypeName: TRzEdit;
    edtArriveTime2: TRzEdit;
    Panel1: TPanel;
    btnClose: TButton;
    Timer1: TTimer;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    GroupBox2: TGroupBox;
    lstItems: TListView;
    GroupBox1: TGroupBox;
    lstviewTurn: TListView;
    Image2: TImage;
    lblIsStored: TLabel;
    WebBrowser1: TWebBrowser;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }

//    m_RsLCEvent: TRsLCEvent;
    m_strTrainPlanGUID : string;
    //格式化秒为时间的字符串形式
    function FormatSeconds(Seconds : integer) : string;
//    procedure ShowEventList(TrainPlanGUID : string);
    //显示司机保单
    procedure ShowSJBD(BeginTime,EndTime : TDateTIME;TrainmanNumber : string);
    //显示计划信息
    procedure ShowPlanInfo(TrainPlanGUID : string;out trainmanPlan : RRsTrainmanPlan);
    //显示运行记录是否已经转储
    procedure ShowRestored(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
    //显示劳时信息
    procedure ShowWorkTimeTurn(TrainPlanGUID : string);
    //判断转储运行记录是否转储
    function IsRestored(BeginTime,EndTime : TDateTime;TrainmanNumber : string) : boolean;
    //显示运计项点信息
    procedure ShowRecordItems(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
    //显示运行报警信息
    procedure ShowOnlineAlarm(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
    //格式化日期时间的字符串形式，并将空置为-
    function FormatDT(DateTime : TDateTime) : string;
  public
    { Public declarations }
    class procedure ShowTuiQinThird(TrainPlanGUID : string);

  end;
  



implementation
uses
  ufrmWorkTimeDetail,uGlobalDM, DB,DateUtils, uLCTrainPlan,uLCWorkTime;
{$R *.dfm}
 function GetIntakeTime(StartDate, EndDate: TDateTime): string;
var
  dtDiff:TDateTime ;
  nMinute:Integer ;

begin
  dtDiff := EndDate - StartDate ;
  nMinute := Round ( dtDiff * 24 * 60 ) ;

  Result := Format('%d小时%d分钟',[nMinute div 60, nMinute mod 60] ) ;
  if (StartDate = 0) or (EndDate = 0) then
    result := '-';
  
end;
function GetMinutesText(Minutes : integer):string;
begin
  Result := Format('%d小时%d分钟',[Minutes div 60, Minutes mod 60] ) ;
  if Minutes = 0 then
    result := '-';
end;
procedure TfrmTuiQinThird.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

function TfrmTuiQinThird.FormatDT(DateTime: TDateTime): string;
begin
  result := '-';
  if datetime = 0 then exit;
  result := FormatDateTime('yyyy-MM-dd HH:nn',DateTime);
end;

function TfrmTuiQinThird.FormatSeconds(Seconds: integer): string;
var
  datetime : TDateTime;
begin
  datetime := 0;
  datetime := IncSecond(datetime,seconds);
  result := Formatdatetime('hh:nn:ss',datetime);
end;

procedure TfrmTuiQinThird.FormResize(Sender: TObject);
begin
  GroupBox1.Width := Width div 2;
end;

procedure TfrmTuiQinThird.FormShow(Sender: TObject);
begin
  timer1.Enabled := true;
end;

function TfrmTuiQinThird.IsRestored(BeginTime, EndTime: TDateTime;
  TrainmanNumber: string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  if not GlobalDM.GSCLConnection.Connected then
  begin
    GlobalDM.GSCLConnection.ConnectionString := GlobalDM.GSCLSQLConfig.ConnString;
    GlobalDM.GSCLConnection.Open;
  end;
  strSql := 'select top 1 fid from cljg where jg02 > :BeginTime and jg02 < :EndTime and ((jg39=:TrainmanNumber1) or (jg38=:TrainmanNumber2))';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.GSCLConnection;
      Sql.Text := strSql;
      Parameters.ParamByName('BeginTime').Value := BeginTime;
      Parameters.ParamByName('EndTime').Value := EndTime;
      Parameters.ParamByName('TrainmanNumber1').Value := TrainmanNumber;
      Parameters.ParamByName('TrainmanNumber2').Value := TrainmanNumber;
      Open;
      result := (RecordCount > 0);
    end;
  finally
    adoQuery.Free;
  end;
end;
//
//procedure TfrmTuiQinThird.ShowEventList(TrainPlanGUID: string);
//var
//  i,nLastArrive: Integer;
//  item : TListItem;
//  runEventArray : TRsRunEventArray;
//begin
//  m_strTrainPlanGUID := TrainPlanGUID;
//  m_RsLCEvent.GetPlanStationRunEvents(TrainPlanGUID,runEventArray);
//  lstviewTurn.Items.Clear;
//  for i := 0 to length(runEventArray) - 1 do
//  begin
//    Application.ProcessMessages;
//    if runEventArray[i].nEventID = eteEnterStation then
//    begin
//      item := lstviewTurn.Items.Add;
//      item.Caption := Format('%s',[runEventArray[i].strStationName]);
//      item.SubItems.Add('');
//      item.SubItems.Add(FormatDT(runEventArray[i].dtEventTime));
//      item.SubItems.Add('');
//      item.SubItems.Add(runEventArray[i].strTrainNo);
//      nLastArrive := -1;
//      continue;
//    end;
//
//    if runEventArray[i].nEventID = eteStopInStation then
//    begin
//      item := lstviewTurn.Items.Add;
//      item.Caption := Format('%s',[runEventArray[i].strStationName]);
//      item.SubItems.Add(FormatDT(runEventArray[i].dtEventTime));
//      item.SubItems.Add('');
//      item.SubItems.Add('');
//      item.SubItems.Add(runEventArray[i].strTrainNo);
//      nLastArrive := i;
//      continue;
//    end;
//      
//    if runEventArray[i].nEventID = eteStartFromStation then
//    begin
//        if (nLastArrive > -1) and  (lstviewTurn.Items.Count > 0) then
//        begin
//          item := lstviewTurn.Items[lstviewTurn.Items.COUNt -1];
//          if item <> nil then
//          begin
//            item.Caption := Format('%s',[runEventArray[i].strStationName]);
//
//            item.SubItems[1] := FormatDT(runEventArray[i].dtEventTime);
//            item.SubItems[2] := GetIntakeTime(runEventArray[nLastArrive].dtEventTime,runEventArray[i].dtEventTime);
//
//            nLastArrive := i;
//            continue;
//          end;
//        end;
//    end;
//  end;
//end;

procedure TfrmTuiQinThird.ShowOnlineAlarm(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
var
  url : string;
begin
  url := 'http://10.78.174.155:84/train/perfect/pointAlarm?option=show_driver&driverid=%s&s_time=%s';
  url := Format(url,[TrainmanNumber,FormatDateTIME('yyyy-MM-dd HH:nn:ss',BeginTime)]);
  WebBrowser1.Navigate(url);
end;

procedure TfrmTuiQinThird.ShowPlanInfo(TrainPlanGUID: string;out trainmanPlan : RRsTrainmanPlan);
var
  RsLCTrainPlan: TRsLCTrainPlan;
  ErrInfo: string;
begin
  RsLCTrainPlan := TRsLCTrainPlan.Create('','','');
  RsLCTrainPlan.SetConnConfig(GlobalDM.HttpConnConfig);
  try

    if RsLCTrainPlan.GetTrainmanPlanByGUID(trainplanGUID,trainmanPlan,ErrInfo) then
    begin
      edtTrainman1.Text := GetTrainmanText(trainmanPlan.Group.Trainman1);
      edtTrainman2.Text := GetTrainmanText(trainmanPlan.Group.Trainman2);
      edtTrainman3.Text := GetTrainmanText(trainmanPlan.Group.Trainman3);
      edtKehuoName.Text :=  TRsKeHuoName[trainmanPlan.TrainPlan.nKeHuoID];
      edtTrainmanTypeName.Text := trsTrainmanTypeNAME[trainmanPlan.TrainPlan.ntrainmanTypeID];
    end;
  finally
    RsLCTrainPlan.Free;
  end;
end;

procedure TfrmTuiQinThird.ShowRecordItems(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
var
  strSql : string;
  adoQuery : TADOQuery;
  item : TListItem;
begin
  if not GlobalDM.GSCLConnection.Connected then
  begin
    GlobalDM.GSCLConnection.ConnectionString := GlobalDM.GSCLSQLConfig.ConnString; 
    GlobalDM.GSCLConnection.Open;
  end;
  strSql := 'select (select top 1 xm09 from item where i02=xm01 and i03=xm02) as ItemName,i04 as glb,i09 as xs from itemDetail ' +
             ' where fid in(select fid from cljg where jg02 > :BeginTime and jg02 < :EndTime and ((jg39=:TrainmanNumber1) or (jg38=:TrainmanNumber2 )))' +
             ' ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.GSCLConnection;
      Sql.Text := strSql;
      Parameters.ParamByName('BeginTime').Value := BeginTime;
      Parameters.ParamByName('EndTime').Value := EndTime;
      Parameters.ParamByName('TrainmanNumber1').Value := TrainmanNumber;
      Parameters.ParamByName('TrainmanNumber2').Value := TrainmanNumber;
      Open;
      lstItems.Items.Clear;
      while not eof do
      begin
        item := lstItems.Items.Add;
        item.Caption := IntToStr(RecNo);
        item.SubItems.Add('运计');
        item.SubItems.Add(FieldByName('ItemName').AsString);
        item.SubItems.Add(FieldByName('glb').AsString);
        item.SubItems.Add(FieldByName('xs').AsString);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TfrmTuiQinThird.ShowRestored(BeginTime,EndTime : TDateTime;TrainmanNumber : string);
begin
  lblIsStored.Font.Color := clGreen;
  lblIsStored.Caption := 'IC卡运行记录已转储';
  if not IsRestored(BeginTime,EndTime,TrainmanNumber) then
  begin
    lblIsStored.Font.Color := clRed;
    lblIsStored.Caption := '未转储IC卡运行记录';
  end;
end;

procedure TfrmTuiQinThird.ShowSJBD(BeginTime, EndTime: TDateTIME;
  TrainmanNumber: string);
var
  strSql : string;
  adoQuery : TADOQuery;
  item : TListItem;
  strArriveTime,strPassTime,strStopMinutes,strRunMinutes : string;
begin
  if not GlobalDM.GSCLConnection.Connected then
  begin
    GlobalDM.GSCLConnection.ConnectionString := GlobalDM.GSCLSQLConfig.ConnString; 
    GlobalDM.GSCLConnection.Open;
  end;
  strSql := 'select (select jg02 from cljg where cljg.fid=sjbd.fid) as dtCreateTime,* from sjbd ' +
      ' where fid in(select fid from cljg where jg02 > %s and jg02 <  %s  and ' +
      ' ((jg39=%s ) or (jg38=%s  ))) '  +
      ' order by dtCreateTime,sjbd01 ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime)),
    QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.GSCLConnection;
      Sql.Text := strSql;
      Open;
      lstItems.Items.Clear;
      while not eof do
      begin
        item :=lstviewTurn.Items.Add;
        item.Caption := FieldByName('Sjbd02').AsString;
        strArriveTime := '';
        if FieldByName('Sjbd03').AsInteger > 0 then
        begin
          strArriveTime := FormatSeconds(FieldByName('Sjbd03').AsInteger);
        end;
        item.SubItems.Add(strArriveTime);

        strPassTime := '';
        if FieldByName('Sjbd04').AsInteger > 0 then
        begin
          strPassTime := FormatSeconds(FieldByName('Sjbd04').AsInteger);
        end;
        item.SubItems.Add(strPassTime);

        strStopMinutes := '';
        if FieldByName('Sjbd05').AsInteger > 0 then
        begin
          strStopMinutes := FormatSeconds(FieldByName('Sjbd05').AsInteger);
        end;
        item.SubItems.Add(strStopMinutes);

        strRunMinutes := '';
        if FieldByName('Sjbd10').AsInteger > 0 then
        begin
          strRunMinutes := FormatSeconds(FieldByName('Sjbd10').AsInteger);
        end;
        item.SubItems.Add(strRunMinutes);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


class procedure TfrmTuiQinThird.ShowTuiQinThird(TrainPlanGUID: string);
var
  frmTuiQinThird: TfrmTuiQinThird;
begin
  frmTuiQinThird := TfrmTuiQinThird.Create(nil);
  try
    frmTuiQinThird.m_strTrainPlanGUID := TrainPlanGUID;
    frmTuiQinThird.ShowModal;
  finally
    frmTuiQinThird.Free;
  end;
end;

procedure TfrmTuiQinThird.ShowWorkTimeTurn(TrainPlanGUID: string);
var
  worktime : RRsWorkTime;
  RsLCWorkTime: TRsLCWorkTime;
begin

  RsLCWorkTime := TRsLCWorkTime.Create(GlobalDM.WebAPIUtils);
  try
    RsLCWorkTime.CalcWorkTime(TrainPlanGUID);
    if RsLCWorkTime.GetWorkTime(TrainPlanGUID,worktime) then
    begin
      RsLCWorkTime.CalcWorkTime(TrainPlanGUID);
      edtStartTime1.Text := FormatDT(workTime.dtStartTime);
      edtArriveTime1.Text := FormatDT(workTime.dtArriveTime);
      edtStartTime2.Text := FormatDT(workTime.dtStartTime2);
      edtArriveTime2.Text := FormatDT(workTime.dtArriveTime2);
      edtRestLength.Text := GetIntakeTime(worktime.dtInRoomTime,workTime.dtOutRoomTime);
      edtTotalTime.Text := GetMinutesText(workTime.fTotalTime);
      edtOutTime.Text := GetMinutesText(worktime.nOutTotalTime);
    end;
  finally
    RsLCWorkTime.Free;
  end;
end;

procedure TfrmTuiQinThird.Timer1Timer(Sender: TObject);
var
  tuiqinPlan : RRsTrainmanPlan;
begin
  Timer1.Enabled := false;
  TfrmProgressEx.ShowProgress('正在加载数据。。。',1,5);
  try
    //显示计划信息
    ShowPlanInfo(m_strTrainPlanGUID,tuiqinPlan);
    //显示劳时信息
    ShowWorkTimeTurn(m_strTrainPlanGUID);
      //显示司机报单事件列表
    ShowSJBD(tuiqinPlan.TrainPlan.dtStartTime,now,tuiqinPlan.Group.Trainman1.strTrainmanNumber);
    //显示运计项点信息
    ShowRecordItems(tuiqinPlan.TrainPlan.dtStartTime,now,tuiqinPlan.Group.Trainman1.strTrainmanNumber);
    //显示运行记录是否已经转储
    ShowRestored(tuiqinPlan.TrainPlan.dtStartTime,now,tuiqinPlan.Group.Trainman1.strTrainmanNumber);
    //显示运行报警信息
    ShowOnlineAlarm(tuiqinPlan.TrainPlan.dtStartTime,now,tuiqinPlan.Group.Trainman1.strTrainmanNumber);

  finally
    TfrmProgressEx.CloseProgress;
  end;
end;

end.
