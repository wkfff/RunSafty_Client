unit uFrmWaitPlanUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uDBRoomWait,uRoomWait;

type
  TfrmWaitPlanUpdate = class(TForm)
    Label3: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    edtTrainNo: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtRoomNumber: TEdit;
    checkEnable: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    PlanGUID : string;
  end;


implementation
uses
  uGlobalDM;
{$R *.dfm}

procedure TfrmWaitPlanUpdate.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmWaitPlanUpdate.btnOKClick(Sender: TObject);
var
  waitPlan : RRsWaitPlan;
begin
  if trim(edtTrainNo.Text) = '' then
  begin
    edtTrainNo.SetFocus;
    Application.MessageBox('车次信息不能为空','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if trim(edtRoomNumber.Text) = '' then
  begin
    edtRoomNumber.SetFocus;
    Application.MessageBox('房间信息不能为空','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  waitPlan := TRsDBWaitPlan.GetPlanByGUID(GlobalDM.ADOConnection,PlanGUID);
  waitPlan.strTrainNo := Trim(edtTrainNo.Text);
  waitPlan.nRoomID := StrToInt(edtRoomNumber.Text);
//  waitPlan.dtCallTime := edtCallTime.EditValue;
//  waitPlan.dtStartTime := edtStartTime.EditValue;
  waitPlan.bIsUsed := checkEnable.Checked;
  waitPlan.strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
  if not TRsDBWaitPlan.EditPlan(GlobalDM.ADOConnection,waitPlan) then
  begin
    Application.MessageBox('修改失败','提示',MB_OK + MB_ICONERROR);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmWaitPlanUpdate.edtRoomNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then
    key := #0;
end;

procedure TfrmWaitPlanUpdate.FormShow(Sender: TObject);
var
  roomPlan : RRsWaitPlan;
begin
  roomPlan := TRsDBWaitPlan.GetPlanByGUID(GlobalDM.ADOConnection,PlanGUID);
  edtTrainNo.Text :=  roomPlan.strTrainNo;
  edtRoomNumber.Text := IntToStr(roomPlan.nRoomID);
  checkEnable.Checked := roomPlan.bIsUsed;
//  edtStartTime.Time := roomPlan.dtStartTime;
//  edtCallTime.Time := roomPlan.dtCallTime;
end;

end.
