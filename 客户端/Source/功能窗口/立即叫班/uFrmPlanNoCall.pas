unit uFrmPlanNoCall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ComCtrls, RzDTP,uRoomWaitDBOprate,ADODB,
  AdvDateTimePicker,uFrmFindRoom, Buttons,uTrainman,uSaftyEnum,
  uRoom,uTFSystem,uDBAccessRoomSign;

type
  TfrmPlanNoCall = class(TForm)
    edtTrainNo: TEdit;
    Label2: TLabel;
    edtRoomNumber: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnAdd: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    checkEnableCallTime: TCheckBox;
    dtpInTime: TAdvDateTimePicker;
    dtpCallTime: TAdvDateTimePicker;
    btnFind: TSpeedButton;
    Label6: TLabel;
    edtTrainmanName: TEdit;
    Label7: TLabel;
    edtTrainmanNo: TEdit;
    checkEnableDutyTime: TCheckBox;
    Label8: TLabel;
    dtpDutyTime: TAdvDateTimePicker;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
    procedure checkEnableCallTimeClick(Sender: TObject);
    procedure edtTrainNoExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtTrainmanNoExit(Sender: TObject);
    procedure checkEnableDutyTimeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
      //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
  private
    { Private declarations }
    isFirst : boolean;
        //前一个调用的事件  ,指纹仪事件
    m_OldFingerTouch : TNotifyEvent;
    m_DBTrainman :TRsDBAccessTrainman;
  //(闫)
  private
    m_strTrainmanGUID : string;
    procedure ClearTrainman;
    {功能：判断房间是否已经住满}
    function CheckRoomIsFull(RoomWaitingGUID: string;RoomNo: string):Boolean;
  public
    { Public declarations }

  //(闫)
  published
    property TrainmanGUID : string read m_strTrainmanGUID;
    
  end;

var
  frmPlanNoCall: TfrmPlanNoCall;

implementation
uses
  DateUtils,MMSystem,uGlobalDM, uCallRoomDM,ufrmTrainmanIdentityAccess;
{$R *.dfm}

procedure TfrmPlanNoCall.btnAddClick(Sender: TObject);
var
  plan : RWaitPlanRecord;
  RoomWaitingGUID,strTemp: string;
  nCallCount: Integer;
begin

//  if Trim(comboArea.Text) = '' then
//  begin
//    Application.MessageBox('您还为设置当前工作区域！','提示',MB_OK);
//    exit;
//  end;

  if Trim(edtRoomNumber.Text) = '' then
  begin
    edtRoomNumber.SetFocus;
    Application.MessageBox('请输入房间号！','提示',MB_OK);
    exit;    
  end;

//(闫)
//  if Trim(edtTrainNo.Text) = '' then
//  begin
//    edtTrainNo.SetFocus;
//    Application.MessageBox('请输入车次！','提示',MB_OK);
//    exit;
//  end;

  if not checkEnableCallTime.Checked then
  begin
    if (dtpCallTime.DateTime <= dtpInTime.DateTime) then
    begin
      dtpCallTime.SetFocus;
      Application.MessageBox('叫班时间不能小于到达时间！','提示',MB_OK);
      exit;
    end;
  end;
  if not checkEnableDutyTime.Checked then
  begin
    if (dtpDutyTime.DateTime <= dtpCallTime.DateTime) then
    begin
      dtpDutyTime.SetFocus;
      Application.MessageBox('出勤时间不能小于叫班时间！','提示',MB_OK);
      exit;
    end;
  end;

  if Trim(edtTrainmanNo.Text) <> '' then
  begin
    strTemp := TWaitPlanOpt.CheckTrainmanInRoom(Trim(edtTrainmanNo.Text));
    if strTemp <> '' then
    begin
      Box('该人员已经入寓到' + strTemp + '房间');
      Exit;
    end;
  end;

  RoomWaitingGUID := TWaitPlanOpt.CheckRoomWaitingByRoom(Trim(edtRoomNumber.Text),nCallCount);
  if RoomWaitingGUID = '' then
  begin
    plan.strTrainNo := edtTrainNo.Text;
    plan.nRoomID := edtRoomNumber.Text;
    plan.dtStartTime := dtpInTime.DateTime ;
    plan.dtCallTime := 0;
    if not checkEnableCallTime.Checked then
      plan.dtCallTime := dtpCallTime.DateTime ;
    if not checkEnableDutyTime.Checked then
      plan.dtDutyTime :=  dtpDutyTime.DateTime ;
    plan.strAreaGUID := '' ;
    plan.nCallCount := 0;
    plan.strPlanGUID := '';
    plan.strTrainmanNo := edtTrainmanNo.Text;
    plan.strTrainmanName := edtTrainmanName.Text;
    if TWaitPlanOpt.AddPlanRecord(plan) then
    begin
      Application.MessageBox('计划添加成功！','提示',MB_OK + MB_ICONINFORMATION);
      ModalResult := mrOk;
    end;
  end
  else
  begin
    if nCallCount = 1 then
    begin
      Box('该房间正在叫班，不允许继续住人');
      Exit;
    end;  
    if CheckRoomIsFull(RoomWaitingGUID,Trim(edtRoomNumber.Text)) then
    begin
      Box('该房间已经住满');
      Exit;
    end
    else
    begin
      if TBox('该房间已经住人，确定要入住该房间吗？') = False then Exit;
      
      if TWaitPlanOpt.AddRoomWaitingTrainman(RoomWaitingGUID,Trim(edtTrainmanNo.Text),
        Trim(edtTrainmanName.Text)) then
        Application.MessageBox('计划添加成功！','提示',MB_OK + MB_ICONINFORMATION)
      else
        Application.MessageBox('计划添加失败！','提示',MB_OK + MB_ICONINFORMATION);
      ModalResult := mrOk;
    end;
  end;
  WriteIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','ConfirmCallTime',
    BoolToStr(checkEnableCallTime.Checked));
  WriteIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','ConfirmDutyTime',
    BoolToStr(checkEnableDutyTime.Checked));
end;

procedure TfrmPlanNoCall.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPlanNoCall.btnFindClick(Sender: TObject);
begin
  frmFindRoom := TfrmFindRoom.Create(nil);
  try
    if frmFindRoom.ShowModal = mrCancel then exit;
    edtRoomNumber.Text := frmFindRoom.lvRoom.Selected.SubItems[0];
  finally
    frmFindRoom.Free;
  end;
end;

procedure TfrmPlanNoCall.checkEnableCallTimeClick(Sender: TObject);
begin
  dtpCallTime.Enabled := not checkEnableCallTime.Checked;
end;

procedure TfrmPlanNoCall.checkEnableDutyTimeClick(Sender: TObject);
begin
  dtpDutyTime.Enabled := not checkEnableDutyTime.Checked;
end;

function TfrmPlanNoCall.CheckRoomIsFull(RoomWaitingGUID,
  RoomNo: string): Boolean;
{功能：判断房间是否已经住满}
var
  Room: RRoom;
begin
  Room := TRoomOpt.GetRoom(GlobalDM.LocalArea,RoomNo);
  if TWaitPlanOpt.GetRoomWaitingTrainmanCount(RoomWaitingGUID) >= Room.MaxCount then
    Result := True
  else
    Result := False;
end;

procedure TfrmPlanNoCall.ClearTrainman;
begin
  m_strTrainmanGUID := '';
  edtTrainmanName.Text := '';
  edtTrainmanNo.Text := '';
end;

procedure TfrmPlanNoCall.edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then
    key := #0;
end;

procedure TfrmPlanNoCall.edtTrainmanNoExit(Sender: TObject);
var
  trainman : RRsTrainman;
begin
  if not m_DBTrainman.GetTrainmanByNumber(edtTrainmanNo.Text,trainman) then
  begin
    Application.MessageBox('错误的乘务员工号','提示',MB_OK);
    exit;
  end;
  edtTrainmanName.Text := trainman.strTrainmanName;
end;

procedure TfrmPlanNoCall.edtTrainNoExit(Sender: TObject);
var
  PlanRecord : RWaitPlanRecord;
begin
  if trim(edtTrainNo.Text) = '' then exit;
  try
    PlanRecord := TWaitPlanOpt.GetLastPlanRecord(Trim((edtTrainNo.Text)));
    if PlanRecord.strGUID <> '' then
    begin
      dtpInTime.DateTime := GlobalDM.GetNow;
      dtpCallTime.DateTime := DateOf(GlobalDM.GetNow) +  TimeOf(PlanRecord.dtCallTime);
    end;
  except

  end;
end;

procedure TfrmPlanNoCall.FormActivate(Sender: TObject);
begin
  ;
end;

procedure TfrmPlanNoCall.FormCreate(Sender: TObject);
begin
  dtpInTime.DateTime := now;
  dtpCallTime.DateTime := Now;
  dtpDutyTime.DateTime := IncMinute(Now,10);

  m_DBTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
    //挂接指纹仪点击事件
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;
end;

procedure TfrmPlanNoCall.FormDestroy(Sender: TObject);
begin
  GlobalDM.OnFingerTouching := m_OldFingerTouch;
  m_DBTrainman.Free ;
end;

procedure TfrmPlanNoCall.FormShow(Sender: TObject);
begin
  try
    checkEnableCallTime.Checked :=
      StrToBool(ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','ConfirmCallTime'));
  except
    checkEnableCallTime.Checked := True;
  end;
  try
    checkEnableDutyTime.Checked :=
      StrToBool(ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','ConfirmDutyTime'));
  except
    checkEnableDutyTime.Checked := True;
  end;
end;


procedure TfrmPlanNoCall.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag;
  strError:string ;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,eVerifyFlag,
    '','','','') then
  begin
    exit;
  end;
  ClearTrainman;
  edtTrainmanNo.Text := trainman.strTrainmanNumber;
  edtTrainmanName.Text := trainman.strTrainmanName;
  m_strTrainmanGUID := trainman.strTrainmanGUID;

end;

end.
