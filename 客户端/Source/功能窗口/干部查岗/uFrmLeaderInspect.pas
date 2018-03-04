unit uFrmLeaderInspect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ActnList, StdCtrls, ExtCtrls, RzPanel,uLeaderExam,
  uBaseDBRoomSign,uDBAccessRoomSign,uSaftyEnum,uTrainman,utfsystem,uTrainPlan,uDBTrainman, Menus,
  Buttons, PngSpeedButton, Grids, PngCustomButton;

type
  TFrmLeaderInspect = class(TForm)
    rzpnl1: TRzPanel;
    actlst1: TActionList;
    actInspect: TAction;
    btnCheck: TPngSpeedButton;
    btnRefresh: TPngSpeedButton;
    lb1: TLabel;
    dtpStartDate: TDateTimePicker;
    lvRecord: TListView;
    lb2: TLabel;
    dtpEndDate: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpEndTime: TDateTimePicker;
    Panel1: TPanel;
    PngCustomButton1: TPngCustomButton;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCheckClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    procedure InitData();
    procedure DataToListView(LeaderInspectList:TRsLeaderInspectList);
    procedure ExcuteInspect(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
  private

    { Private declarations }

    //前一个调用的事件  ,指纹仪事件
    m_OldFingerTouch : TNotifyEvent;

    m_dbLeaderInspect:TRsBaseDBLeaderInspect;
    m_listLeaderInspect:TRsLeaderInspectList;
    m_dbTrainman:TRsDBAccessTrainman ;
  public
    { Public declarations }
    procedure OnFingerTouching(Sender: TObject);
    procedure RefreshData;
  end;

var
  FrmLeaderInspect: TFrmLeaderInspect;

implementation


uses
  uGlobalDM,uFrmGetInput,ufrmTrainmanIdentityAccess,ufrmTextInput;

{$R *.dfm}

procedure TFrmLeaderInspect.btnCheckClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
begin
  GlobalDM.OnFingerTouching := nil;
  try
    begin
      if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
        Exit;
      if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
      begin
        Box('错误的乘务员工号');
        exit;
      end;
    end;
    strNumber := trainman.strTrainmanGUID;
    Verify :=  rfInput;
    ExcuteInspect(Trainman,Verify);
  finally
    GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

procedure TFrmLeaderInspect.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;



procedure TFrmLeaderInspect.DataToListView(LeaderInspectList:TRsLeaderInspectList);
var
  listItem:TListItem;
  i : Integer ;
  strText:string;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(LeaderInspectList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := Format('[%s]%s',[LeaderInspectList[i].strTrainmanNumber,LeaderInspectList[i].strTrainmanName]) ;
      SubItems.Add( FormatDateTime('yyyy-MM-dd HH:nn:ss',LeaderInspectList[i].CreateTime) );
      if LeaderInspectList[i].VerifyID = 1 then
        strText := '指纹'
      else
        strText := '手动' ;
      SubItems.Add(strText);
      SubItems.Add(LeaderInspectList[i].strContext);
    end;
  end;

end;

procedure TFrmLeaderInspect.ExcuteInspect(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
var
  strText:string;
  leaderInspect:RRsLeaderInspect ;
begin
  {
    if not TFrmGetInput.GetInputText(strText) then
        Exit;

    }
  leaderInspect.GUID := NewGUID ;
  leaderInspect.strContext := strText ;
  leaderInspect.LeaderGUID := Trainman.strTrainmanGUID ;
  leaderInspect.strTrainmanName := Trainman.strTrainmanName;
  leaderInspect.strTrainmanNumber := Trainman.strTrainmanNumber ;
  leaderInspect.VerifyID := ord(Verify);
  leaderInspect.CreateTime := Now ;
  leaderInspect.DutyGUID := '' ;
  m_dbLeaderInspect.AddLeaderInspect(leaderInspect) ;

  InitData;
end;

procedure TFrmLeaderInspect.FormCreate(Sender: TObject);
begin
  //挂接指纹仪点击事件
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;

  m_dbLeaderInspect := TRsAccessDBLeaderInspect.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);

  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';

  InitData;
end;

procedure TFrmLeaderInspect.FormDestroy(Sender: TObject);
begin
  //挂接指纹仪点击事件
  GlobalDM.OnFingerTouching := m_OldFingerTouch ;

  m_dbLeaderInspect.Free;
  m_dbTrainman.Free;
end;

procedure TFrmLeaderInspect.InitData;
var
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
begin
  //获取开始和结束的查询时间
  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  //查询数据库
  SetLength(m_listLeaderInspect,0);
  m_dbLeaderInspect.GetLeaderInspectList(dtStart,dtEnd,m_listLeaderInspect);

  //显示结果集
  DataToListView(m_listLeaderInspect);
end;



procedure TFrmLeaderInspect.OnFingerTouching(Sender: TObject);
var
  trainmanPlan: RRsTrainmanPlan;
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,Verify,
    trainmanPlan.Group.Trainman1.strTrainmanGUID,
    trainmanPlan.Group.Trainman2.strTrainmanGUID,
    trainmanPlan.Group.Trainman3.strTrainmanGUID,
    trainmanPlan.Group.Trainman4.strTrainmanGUID) then
  begin
    exit;
  end;

  ExcuteInspect(TrainMan,verify)
end;

procedure TFrmLeaderInspect.RefreshData;
begin
  InitData;
end;


end.
