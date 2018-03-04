unit uFrmPlanAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit,uPlan, ComCtrls, AdvDateTimePicker;

type
  TfrmPlanAdd = class(TForm)
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
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    dtPlanDate : TDateTime;
    Plan : RPlan;
  end;

var
  frmPlanAdd: TfrmPlanAdd;

implementation
uses
  uDataModule;
{$R *.dfm}

procedure TfrmPlanAdd.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPlanAdd.btnOKClick(Sender: TObject);
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
  Plan.strTrainNo := edtTrainNo.Text;

  Plan.dtSigninTime := edtSigninTime.DateTime;
  Plan.dtCallTime := edtCallTime.DateTime ;
  Plan.dtOutDutyTime := edtOutDutyTime.DateTime ;
  Plan.dtStartTime := edtStartTime.DateTime;
  Plan.dtInputTime := DMGlobal.GetNow;
  Plan.strInputGUID := DMGlobal.DutyUser.DutyGUID;
  Plan.nMainDriverState := 1;
  Plan.nSubDriverState := 1;
  Plan.nState := 1;
  Plan.nTrainmanTypeID := 1;
  Plan.strAreaGUID := DMGlobal.LocalArea;
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

procedure TfrmPlanAdd.FormShow(Sender: TObject);
begin
  edtSigninTime.DateTime := dtPlanDate;
  edtCallTime.DateTime := dtPlanDate;
  edtOutDutyTime.DateTime := dtPlanDate;
  edtStartTime.DateTime := dtPlanDate;
end;

end.
