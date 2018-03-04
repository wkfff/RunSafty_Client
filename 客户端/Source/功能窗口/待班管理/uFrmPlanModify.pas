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
    Application.MessageBox('����ָ����ǰ����Ĺ�������','��ʾ',MB_OK + MB_ICONINFORMATION);
    EXIT;
  end;
  if Trim(edtTrainNo.Text) = '' then
  begin
    edtTrainNo.SetFocus;
    Application.MessageBox('�����복��','��ʾ',MB_OK + MB_ICONINFORMATION);
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
    Application.MessageBox('�а�ʱ�䲻��С�ڻ����ǿ��ʱ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Plan.dtOutDutyTime <= Plan.dtCallTime then
  begin
    Application.MessageBox('����ʱ�䲻��С�ڻ���ڽа�ʱ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Plan.dtStartTime <= Plan.dtOutDutyTime then
  begin
    Application.MessageBox('����ʱ�䲻��С�ڻ���ڽа�ʱ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;    
  if TDBPlan.ExistPlanByTrainNo(Plan) then
  begin
    Application.MessageBox('ָ�����εļƻ������ظ�����','��ʾ',MB_OK + MB_ICONINFORMATION);
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
  //�ѳ��ڲ����޸��κ�����
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
