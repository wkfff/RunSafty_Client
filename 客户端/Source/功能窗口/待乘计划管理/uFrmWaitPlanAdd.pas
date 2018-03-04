unit uFrmWaitPlanAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls, Mask, RzEdit, RzDTP,
  uDBRoomWait,uRoomWait;

type
  TfrmWaitPlanAdd = class(TForm)
    Label3: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    edtTrainNo: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtRoomNumber: TEdit;
    checkEnable: TCheckBox;

    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses
  uGlobalDM;
{$R *.dfm}

procedure TfrmWaitPlanAdd.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmWaitPlanAdd.btnOKClick(Sender: TObject);
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
  waitPlan.strTrainNo := Trim(edtTrainNo.Text);
  waitPlan.nRoomID := StrToInt(edtRoomNumber.Text);
//  waitPlan.dtCallTime := edtCallTime.EditValue;
//  waitPlan.dtStartTime := edtStartTime.EditValue;
  waitPlan.bIsUsed := checkEnable.Checked;
  waitPlan.strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
  if not TRsDBWaitPlan.AddPlan(GlobalDM.ADOConnection,waitPlan) then
  begin
    Application.MessageBox('添加失败','提示',MB_OK + MB_ICONERROR);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmWaitPlanAdd.edtRoomNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8]) then
    key := #0;
end;

end.
