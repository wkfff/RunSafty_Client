unit ufrmManagerConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uTFSystem,uLCDayPlan;

type
  TfrmManagerConfirm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lbl1: TLabel;
    edtPassWord: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtPassWordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  {功能：管理员身份确认}
  function ManagerConfirm():Boolean;


implementation
uses uGlobalDM;

{$R *.dfm}

function ManagerConfirm():Boolean;
{功能：管理员身份确认}   
var
  frmManagerConfirm: TfrmManagerConfirm;
begin
  frmManagerConfirm := TfrmManagerConfirm.Create(nil);
  try
    Result := frmManagerConfirm.ShowModal = mrOk;
  finally
    frmManagerConfirm.Free;
  end;
end;

procedure TfrmManagerConfirm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmManagerConfirm.btnOKClick(Sender: TObject);
var
  RsLCDayPlanSystem: TRsLCDayPlanSystem;
begin
  RsLCDayPlanSystem := TRsLCDayPlanSystem.Create(GlobalDM.WebAPIUtils);
  try
    if RsLCDayPlanSystem.IsAdmin(edtPassWord.Text) then
      ModalResult := mrOk
    else
    begin
      BoxErr('密码错误，请重新输入！');
      edtPassWord.Clear;
      edtPassWord.SetFocus;
    end;
  finally
    RsLCDayPlanSystem.Free;
  end;
end;

procedure TfrmManagerConfirm.edtPassWordKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnOK.Click;
end;

end.
