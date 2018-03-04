unit uFrmPlanNoCallEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls,ADODB,uRoomWaitDBOprate,
  Buttons,DateUtils,uTFSystem;

type
  TfrmPlanNoCallEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtTrainNo: TEdit;
    comboArea: TComboBox;
    edtRoomNumber: TEdit;
    btnAdd: TButton;
    btnCancel: TButton;
    checkEnableCallTime: TCheckBox;
    dtpInTime: TAdvDateTimePicker;
    dtpCallTime: TAdvDateTimePicker;
    btnFind: TSpeedButton;
    Label8: TLabel;
    dtpDutyTime: TAdvDateTimePicker;
    checkEnableDutyTime: TCheckBox;
    procedure btnAddClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure checkEnableCallTimeClick(Sender: TObject);
    procedure edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure checkEnableDutyTimeClick(Sender: TObject);
  private
    { Private declarations }
    isFirst : boolean;
  public
    { Public declarations }
    PlanGUID : string;    
  end;

var
  frmPlanNoCallEdit: TfrmPlanNoCallEdit;

implementation
 uses
  uCallRoomDM,uFrmFindRoom, uGlobalDM;
{$R *.dfm}

procedure TfrmPlanNoCallEdit.btnAddClick(Sender: TObject);
var
  plan : RWaitPlanRecord;
begin
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
    if (dtpCallTime.DateTime <= dtpInTime.DateTime)  then
    begin
      dtpCallTime.SetFocus;
      Application.MessageBox('叫班时间不能小于到达时间！','提示',MB_OK);
      exit;
    end;
  end;
  if not checkEnableDutyTime.Checked then
  begin
    if (dtpDutyTime.DateTime <= dtpCallTime.DateTime)  then
    begin
      dtpDutyTime.SetFocus;
      Application.MessageBox('出勤时间不能小于叫班时间！','提示',MB_OK);
      exit;
    end;
  end;
  plan.strGUID := PlanGUID;
  plan.strTrainNo := edtTrainNo.Text;
  plan.nRoomID := edtRoomNumber.Text;
  plan.dtStartTime := dtpInTime.DateTime;
  plan.dtCallTime := 0;
  if not checkEnableCallTime.Checked then
    plan.dtCallTime := dtpCallTime.DateTime;
  plan.dtDutyTime := 0;
  if not checkEnableDutyTime.Checked then
    plan.dtDutyTime := dtpDutyTime.DateTime;
  plan.strAreaGUID := '' ;
  plan.nCallCount := 0;
  plan.strPlanGUID := '';
  if TWaitPlanOpt.EditPlanRecord(plan) then
  begin
    Application.MessageBox('计划修改成功！','提示',MB_OK + MB_ICONINFORMATION);
    ModalResult := mrOk;
  end;
end;

procedure TfrmPlanNoCallEdit.btnCancelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure TfrmPlanNoCallEdit.btnFindClick(Sender: TObject);
begin
  frmFindRoom := TfrmFindRoom.Create(nil);
  try
    if frmFindRoom.ShowModal = mrCancel then exit;
    edtRoomNumber.Text := frmFindRoom.lvRoom.Selected.SubItems[0];
  finally
    frmFindRoom.Free;
  end;
end;

procedure TfrmPlanNoCallEdit.checkEnableCallTimeClick(Sender: TObject);
begin
  if checkEnableCallTime.Checked then
    dtpCallTime.Enabled := false
  else
  begin
    dtpCallTime.Enabled := true;
    if ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','MustDutyTime') = '1' then
      checkEnableDutyTime.Checked := False;
  end;
end;

procedure TfrmPlanNoCallEdit.checkEnableDutyTimeClick(Sender: TObject);
begin
  if checkEnableDutyTime.Checked then
  begin
    if (ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','MustDutyTime') = '1')
      and (checkEnableCallTime.Checked = False) then
    begin
      checkEnableDutyTime.Checked := False;
      Exit;
    end;
    dtpDutyTime.Enabled := False;
  end
  else
  begin
    dtpDutyTime.Enabled := True;
  end;
end;

procedure TfrmPlanNoCallEdit.edtRoomNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then
    key := #0;
end;

procedure TfrmPlanNoCallEdit.FormActivate(Sender: TObject);
var
  ado : TADOQuery;
  plan : RWaitPlanRecord;
begin
  if isFirst then exit;
  isFirst := true;
  ComboArea.Enabled := false;
  plan := TWaitPlanOpt.GetPlanRecord(planGUID);
  dtpInTime.DateTime := plan.dtStartTime;
  dtpCallTime.DateTime := Now;
  dtpDutyTime.DateTime := IncMinute(Now,10);
//  if (plan.dtCallTime = 0) then
//  begin
//    checkEnableCallTime.Checked := true;
//    dtpCallTime.DateTime := Now;
//  end else begin
//    dtpCallTime.DateTime := plan.dtCallTime;
//  end;

  edtTrainNo.Text := plan.strTrainNo;
  edtRoomNumber.Text := plan.nRoomID;
end;

procedure TfrmPlanNoCallEdit.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TfrmPlanNoCallEdit.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TfrmPlanNoCallEdit.FormShow(Sender: TObject);
begin
  checkEnableCallTime.Checked := False;
  if ReadIniFile(GlobalDM.AppPath + 'Config.ini','RoomWaiting','MustDutyTime') = '1' then
    checkEnableDutyTime.Checked := False
  else
    checkEnableDutyTime.Checked := True;
end;

end.
