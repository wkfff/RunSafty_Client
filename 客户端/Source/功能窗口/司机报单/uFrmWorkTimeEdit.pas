unit uFrmWorkTimeEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ExtCtrls, RzPanel,uWorkTime,uDBWorkTime,
  ComCtrls, AdvDateTimePicker,uTrainman,uDBTrainman,uTFSystem;

type
  TfrmWorkTimeEdit = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    RzGroupBox1: TRzGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edtDestStation: TRzEdit;
    RzGroupBox2: TRzGroupBox;
    Label5: TLabel;
    Label4: TLabel;
    checkInOutRoom: TCheckBox;
    RzGroupBox3: TRzGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label16: TLabel;
    edtRemoteStop: TRzEdit;
    edtArriveStation: TRzEdit;
    RzGroupBox4: TRzGroupBox;
    Label11: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    edtTrainJiaolu: TRzEdit;
    edtTrainNo: TRzEdit;
    edtTrainNumber: TRzEdit;
    edtTrainman1: TRzEdit;
    edtTrainman2: TRzEdit;
    edtTrainman3: TRzEdit;
    RzGroupBox5: TRzGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    edtTotal: TRzEdit;
    edtChuQin: TRzEdit;
    edtRun: TRzEdit;
    edtTuiQin: TRzEdit;
    btnCancel: TButton;
    btnOk: TButton;
    checkLocalOutDepots: TCheckBox;
    checkDestInDepots: TCheckBox;
    checkDestOutDepotsTime: TCheckBox;
    checkLocalInDepotsTime: TCheckBox;
    dtpChuQin: TAdvDateTimePicker;
    dtpLocalOutDepots: TAdvDateTimePicker;
    dtpStartTime: TAdvDateTimePicker;
    dtpArriveTime: TAdvDateTimePicker;
    dtpDestInDepots: TAdvDateTimePicker;
    dtpInRoom: TAdvDateTimePicker;
    dtpOutRoom: TAdvDateTimePicker;
    dtpDestOutDepotsTime: TAdvDateTimePicker;
    dtpStartTime2: TAdvDateTimePicker;
    dtpArriveTime2: TAdvDateTimePicker;
    dtpLocalInDepotsTime: TAdvDateTimePicker;
    dtpFingerTuiQin: TAdvDateTimePicker;
    dtpRealTuiQinTime: TAdvDateTimePicker;
    edtLocalStop: TRzEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure checkLocalOutDepotsClick(Sender: TObject);
    procedure dtpStartTimeExit(Sender: TObject);
  private
    { Private declarations }
    m_WorkTime : RRsWorkTime;
    m_DBWorkTime : TDBWorkTime;
    procedure InitData(WorkTime : RRsWorkTime);
    procedure ReCheckDepots;
  public
    { Public declarations }
    class function EditWorkTime(WorkTime : RRsWorkTime) : boolean;
  end;



implementation

uses uTrainPlan,uGlobalDM;

{$R *.dfm}

procedure TfrmWorkTimeEdit.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmWorkTimeEdit.btnOkClick(Sender: TObject);
var
  tmpWorkTime : RRsWorkTime;
begin
  tmpWorkTime := m_WorkTime;
  tmpWorkTime.dtBeginWorkTime := dtpChuQin.DateTime;
  tmpWorkTime.dtLocalOutDepotsTime := 0;
  tmpWorkTime.bLocalOutDepots := 0;
  if not checkLocalOutDepots.Checked then
  begin
    tmpWorkTime.dtLocalOutDepotsTime := dtpLocalOutDepots.DateTime;
    tmpWorkTime.bLocalOutDepots := 1;
  end;

  tmpWorkTime.dtStartTime := dtpStartTime.DateTime;
  tmpWorkTime.dtArriveTime := dtpArriveTime.DateTime;
  tmpWorkTime.strDestStationName := edtDestStation.Text;
  tmpWorkTime.nLocalStopMinutes := StrToInt(edtLocalStop.Text);
  tmpWorkTime.dtDestInDepotsTime := 0;
  tmpWorkTime.bDestInDepots := 0;
  if not checkdestInDepots.Checked  then
  begin
    tmpWorkTime.dtDestInDepotsTime := dtpDestInDepots.DateTime;
    tmpWorkTime.bDestInDepots := 1;
  end;


  tmpWorkTime.dtInRoomTime := dtpInRoom.DateTime;
  tmpWorkTime.dtOutRoomTime := dtpOutRoom.DateTime;
  if checkInOutRoom.Checked then
  begin
    dtpInRoom.DateTime := 0;
    dtpOutRoom.DateTime := 0;
  end;

  tmpWorkTime.dtDestOutDepotsTime := dtpDestOutDepotsTime.DateTime;
  tmpWorkTime.bDestOutDepots := 1;
  if checkDestOutDepotsTime.Checked  then
  begin
    tmpWorkTime.dtDestOutDepotsTime := 0;
    tmpWorkTime.bDestOutDepots := 0;
  end;
    
  tmpWorkTime.dtStartTime2 := dtpStartTime2.DateTime;
  tmpWorkTime.dtArriveTime2 := dtpArriveTime2.DateTime;
  tmpWorkTime.strArriveStationName := edtArriveStation.Text;
  tmpWorkTime.nRemoteStopMinutes := StrToInt(edtRemoteStop.Text);
  tmpWorkTime.dtLocalInDepotsTime := dtpLocalInDepotsTime.DateTime;
  tmpWorkTime.bLocalInDepots := 1;
  if checkLocalInDepotsTime.Checked then
  begin
    tmpWorkTime.dtLocalInDepotsTime := 0;
    tmpWorkTime.bLocalInDepots := 0;
  end;

  tmpWorkTime.dtEndWorkTime := dtpFingerTuiQin.DateTime;
  tmpWorkTime.dtRealArriveTime := dtpRealTuiQinTime.DateTime;
  tmpWorkTime.fTotalTime := StrToInt(edtTotal.Text);
  tmpWorkTime.fBeginTotalTime := StrToInt(edtChuQin.Text);
  tmpWorkTime.fRunTotalTime := StrToInt(edtRun.Text);
  tmpWorkTime.fEndTotalTime := StrToInt(edtTuiQin.Text);
  tmpWorkTime.bConfirm := 1;
  tmpWorkTime.strConfirmDutyUser := GlobalDM.DutyUser.strDutyGUID;
  tmpWorkTime.dtConfirmTime := GlobalDM.GetNow;
  try
    m_DBWorkTime.UpdateWorkTime(tmpWorkTime);
    ModalResult := mrOk;
  except on e : exception do
    begin
      BoxErr(e.Message);
    end;
  end;
end;

procedure TfrmWorkTimeEdit.checkLocalOutDepotsClick(Sender: TObject);
begin
  ReCheckDepots;
end;

procedure TfrmWorkTimeEdit.dtpStartTimeExit(Sender: TObject);
begin
//
end;

class function TfrmWorkTimeEdit.EditWorkTime(WorkTime: RRsWorkTime): boolean;
var
  frmWorkTimeEdit : TfrmWorkTimeEdit;
begin
  Result := false;
  frmWorkTimeEdit := TfrmWorkTimeEdit.Create(nil);
  try
    frmWorkTimeEdit.InitData(WorkTime);
    if frmWorkTimeEdit.ShowModal = mrOk then
      Result := true;
  finally
    frmWorkTimeEdit.Free;
  end;
end;

procedure TfrmWorkTimeEdit.FormCreate(Sender: TObject);
begin
  m_DBWorkTime := TDBWorkTime.Create(GlobalDM.ADOConnection);
end;

procedure TfrmWorkTimeEdit.FormDestroy(Sender: TObject);
begin
  m_DBWorkTime.Free;
end;

procedure TfrmWorkTimeEdit.InitData(WorkTime: RRsWorkTime);
begin
  m_WorkTime := WorkTime;
  edtTrainJiaolu.Text := m_WorkTime.TrainmanPlan.TrainPlan.strTrainJiaoluName;
  edtTrainNo.Text := m_WorkTime.TrainmanPlan.TrainPlan.strTrainNo;
  edtTrainNumber.Text := m_WorkTime.TrainmanPlan.TrainPlan.strTrainNumber;
  edtTrainman1.Text := uTrainman.GetTrainmanText(m_WorkTime.TrainmanPlan.Group.Trainman1);
  edtTrainman2.Text := uTrainman.GetTrainmanText(m_WorkTime.TrainmanPlan.Group.Trainman2);
  edtTrainman3.Text := uTrainman.GetTrainmanText(m_WorkTime.TrainmanPlan.Group.Trainman3);
  dtpChuQin.DateTime := m_WorkTime.dtBeginWorkTime;
  dtpLocalOutDepots.DateTime := m_WorkTime.dtLocalOutDepotsTime;
  if m_WorkTime.bLocalOutDepots = 0 then
  begin
    checkLocalOutDepots.Checked := true;
  end;

  dtpStartTime.DateTime := m_WorkTime.dtStartTime;
  dtpArriveTime.DateTime := m_WorkTime.dtArriveTime;
  edtDestStation.Text := m_WorkTime.strDestStationName;
  edtLocalStop.Text := Format('%d',[m_WorkTime.nLocalStopMinutes]);
  dtpDestInDepots.DateTime := m_WorkTime.dtDestInDepotsTime;
  if m_WorkTime.bDestInDepots = 0  then
    checkdestInDepots.Checked := true;

  dtpInRoom.DateTime := m_WorkTime.dtInRoomTime;
  dtpOutRoom.DateTime := m_WorkTime.dtOutRoomTime;
  if (m_WorkTime.dtInRoomTime = 0) and (m_WorkTime.dtOutRoomTime = 0) then
  begin
    checkInOutRoom.Checked := true;
  end;

  dtpDestOutDepotsTime.DateTime := m_WorkTime.dtDestOutDepotsTime;
  if (m_WorkTime.bDestOutDepots = 0) then
    checkDestOutDepotsTime.Checked := true;

  dtpStartTime2.DateTime := m_WorkTime.dtStartTime2;
  dtpArriveTime2.DateTime := m_WorkTime.dtArriveTime2;
  edtArriveStation.Text := m_WorkTime.strArriveStationName;
  edtRemoteStop.Text := Format('%d',[m_WorkTime.nRemoteStopMinutes]);
  dtpLocalInDepotsTime.DateTime := m_WorkTime.dtLocalInDepotsTime;
  if m_WorkTime.bLocalInDepots = 0 then
    checkLocalInDepotsTime.Checked := true;

  dtpFingerTuiQin.DateTime := m_WorkTime.dtEndWorkTime;
  dtpRealTuiQinTime.DateTime := m_WorkTime.dtRealArriveTime;
  edtTotal.Text := Format('%d',[m_WorkTime.fTotalTime]);
  edtChuQin.Text := Format('%d',[m_WorkTime.fBeginTotalTime]);
  edtRun.Text := Format('%d',[m_WorkTime.fRunTotalTime]);
  edtTuiQin.Text := Format('%d',[m_WorkTime.fEndTotalTime]);

  ReCheckDepots;
end;

procedure TfrmWorkTimeEdit.ReCheckDepots;
begin
  dtpLocalOutDepots.Enabled := not checkLocalOutDepots.Checked;
  dtpDestInDepots.Enabled := not checkDestInDepots.Checked;
  dtpDestOutDepotsTime.Enabled := not checkDestOutDepotsTime.Checked;
  dtpLocalInDepotsTime.Enabled := not checkLocalInDepotsTime.Checked;
end;

end.
