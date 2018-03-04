unit uFrmPlanModify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls,uPlan;

type
  TfrmPlanModify = class(TForm)
    edtTrainNo: TEdit;
    Label3: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    radioDouble: TRadioButton;
    radioSingle: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    edtSigninTime: TAdvDateTimePicker;
    edtCallTime: TAdvDateTimePicker;
    edtOutDutyTime: TAdvDateTimePicker;
    edtStartTime: TAdvDateTimePicker;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Plan : RPlan;
  end;

var
  frmPlanModify: TfrmPlanModify;

implementation
uses
  uDataModule;
{$R *.dfm}

procedure TfrmPlanModify.btnCancelClick(Sender: TObject);
begin
 ModalResult := mrCancel;
end;

procedure TfrmPlanModify.btnOKClick(Sender: TObject);
begin
 if DMGlobal.LocalArea = '' then
  begin
    Application.MessageBox('请先指定当前程序的工作区域','提示',MB_OK + MB_ICONINFORMATION);
    EXIT;
  end;
  if Trim(edtTrainNo.Text) = '' then
  begin
    edtTrainNo.SetFocus;
    Application.MessageBox('请输入车次','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  Plan.dtSigninTime := edtSigninTime.DateTime;
  Plan.dtCallTime := edtCallTime.DateTime ;
  Plan.dtOutDutyTime := edtOutDutyTime.DateTime ;
  Plan.dtStartTime := edtStartTime.DateTime;
  Plan.strAreaGUID := DMGlobal.LocalArea;

  Plan.nTrainmanTypeID := 1;
  if radioDouble.Checked then
    Plan.nTrainmanTypeID := 2;

  if Plan.dtCallTime <= Plan.dtSigninTime then
  begin
    Application.MessageBox('叫班时间不能小于或等于强休时间','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Plan.dtOutDutyTime <= Plan.dtCallTime then
  begin
    Application.MessageBox('出勤时间不能小于或等于叫班时间','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Plan.dtStartTime <= Plan.dtOutDutyTime then
  begin
    Application.MessageBox('开车时间不能小于或等于叫班时间','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;    
  if TDBPlan.ExistPlanByTrainNo(Plan) then
  begin
    Application.MessageBox('指定车次的计划不能重复输入','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := MrOk;
end;

procedure TfrmPlanModify.FormShow(Sender: TObject);
begin
  edtTrainNo.Text := plan.strTrainNo;
  radioSingle.Checked := true;
  if plan.nTrainmanTypeID = 2 then
    radioDouble.Checked := true;
  edtSigninTime.DateTime := plan.dtSigninTime;
  edtCallTime.DateTime := plan.dtCallTime;
  edtOutDutyTime.DateTime := plan.dtOutDutyTime;
  edtStartTime.DateTime := plan.dtStartTime;
  //已出勤不能修改任何数据
  if (Plan.nMainDriverState > 4) or (Plan.nSubDriverState > 4) then
  begin
    edtSigninTime.Enabled := false;
    edtCallTime.Enabled := false;
    edtOutDutyTime.Enabled := false;
    edtStartTime.Enabled := false;
    edtTrainNo.Enabled := false;
    radioDouble.Enabled := false;
    radioSingle.Enabled := false;
    btnOK.Enabled := false;
  end;
end;

end.
