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
      //����ָ����
    procedure OnFingerTouching(Sender: TObject);
  private
    { Private declarations }
    isFirst : boolean;
        //ǰһ�����õ��¼�  ,ָ�����¼�
    m_OldFingerTouch : TNotifyEvent;
    m_DBTrainman :TRsDBAccessTrainman;
  //(��)
  private
    m_strTrainmanGUID : string;
    procedure ClearTrainman;
    {���ܣ��жϷ����Ƿ��Ѿ�ס��}
    function CheckRoomIsFull(RoomWaitingGUID: string;RoomNo: string):Boolean;
  public
    { Public declarations }

  //(��)
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
//    Application.MessageBox('����Ϊ���õ�ǰ��������','��ʾ',MB_OK);
//    exit;
//  end;

  if Trim(edtRoomNumber.Text) = '' then
  begin
    edtRoomNumber.SetFocus;
    Application.MessageBox('�����뷿��ţ�','��ʾ',MB_OK);
    exit;    
  end;

//(��)
//  if Trim(edtTrainNo.Text) = '' then
//  begin
//    edtTrainNo.SetFocus;
//    Application.MessageBox('�����복�Σ�','��ʾ',MB_OK);
//    exit;
//  end;

  if not checkEnableCallTime.Checked then
  begin
    if (dtpCallTime.DateTime <= dtpInTime.DateTime) then
    begin
      dtpCallTime.SetFocus;
      Application.MessageBox('�а�ʱ�䲻��С�ڵ���ʱ�䣡','��ʾ',MB_OK);
      exit;
    end;
  end;
  if not checkEnableDutyTime.Checked then
  begin
    if (dtpDutyTime.DateTime <= dtpCallTime.DateTime) then
    begin
      dtpDutyTime.SetFocus;
      Application.MessageBox('����ʱ�䲻��С�ڽа�ʱ�䣡','��ʾ',MB_OK);
      exit;
    end;
  end;

  if Trim(edtTrainmanNo.Text) <> '' then
  begin
    strTemp := TWaitPlanOpt.CheckTrainmanInRoom(Trim(edtTrainmanNo.Text));
    if strTemp <> '' then
    begin
      Box('����Ա�Ѿ���Ԣ��' + strTemp + '����');
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
      Application.MessageBox('�ƻ���ӳɹ���','��ʾ',MB_OK + MB_ICONINFORMATION);
      ModalResult := mrOk;
    end;
  end
  else
  begin
    if nCallCount = 1 then
    begin
      Box('�÷������ڽа࣬���������ס��');
      Exit;
    end;  
    if CheckRoomIsFull(RoomWaitingGUID,Trim(edtRoomNumber.Text)) then
    begin
      Box('�÷����Ѿ�ס��');
      Exit;
    end
    else
    begin
      if TBox('�÷����Ѿ�ס�ˣ�ȷ��Ҫ��ס�÷�����') = False then Exit;
      
      if TWaitPlanOpt.AddRoomWaitingTrainman(RoomWaitingGUID,Trim(edtTrainmanNo.Text),
        Trim(edtTrainmanName.Text)) then
        Application.MessageBox('�ƻ���ӳɹ���','��ʾ',MB_OK + MB_ICONINFORMATION)
      else
        Application.MessageBox('�ƻ����ʧ�ܣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
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
{���ܣ��жϷ����Ƿ��Ѿ�ס��}
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
    Application.MessageBox('����ĳ���Ա����','��ʾ',MB_OK);
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
    //�ҽ�ָ���ǵ���¼�
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
