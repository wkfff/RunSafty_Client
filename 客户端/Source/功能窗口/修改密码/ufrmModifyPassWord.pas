unit ufrmModifyPassWord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Buttons, ADODB, uGlobalDM, ExtCtrls, pngimage, DB,
  uTFSystem,uDutyUser,uLCDutyUser;


type
  TfrmModifyPassWord = class(TForm)
    lbl1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    btnConfirm: TBitBtn;
    btnCancel: TBitBtn;
    edtYMM: TEdit;
    edtNewPassWord: TEdit;
    edtConfirmNewPassWord: TEdit;
    Image1: TImage;
    Label3: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    CheckBox1: TCheckBox;
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtYMMKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_strUserID : string;
    m_RsLCDutyUser: TRsLCDutyUser;
  public
    { Public declarations }
    {功能:修改密码}
    class procedure ModifyPassWord(UserID : string);
  end;




implementation

{$R *.dfm}


class procedure TfrmModifyPassWord.ModifyPassWord(UserID : string);
{功能:修改密码}
var
  frmModifyPassWord : TfrmModifyPassWord;
begin
  frmModifyPassWord := TfrmModifyPassWord.Create(nil);
  try
    frmModifyPassWord.m_strUserID := UserID;
    if frmModifyPassWord.ShowModal = mrok then
  finally
    frmModifyPassWord.Free;
  end;
end;

procedure TfrmModifyPassWord.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmModifyPassWord.btnConfirmClick(Sender: TObject);
var
  userInfo : TRsDutyUser;
begin
  userInfo := TRsDutyUser.Create;
  try
    if not m_RsLCDutyUser.GetDutyUserByNumber(m_strUserID,userInfo) then
    begin
      Box('获取用户信息失败');
      exit;
    end;
    if (EdtyMM.Text) <> userInfo.strPassword then
    begin
      Box('原密码输入错误!');
      EdtyMM.SetFocus;
      edtYMM.SelectAll;
      Exit;
    end;

    if (edtNewPassWord.Text <> edtConfirmNewPassWord.Text) then
    begin
      Box('两次输入的密码不一致,请重新输入!');
      edtNewPassWord.SetFocus;
      edtNewPassWord.Text := '';
      edtConfirmNewPassWord.Text := '';
      Exit;
    end;

    m_RsLCDutyUser.ResetPassword(m_strUserID,Trim(edtNewPassWord.Text));
    Box('修改密码成功');
    ModalResult := mrOK;
  finally
    userInfo.Free;
  end;
end;

procedure TfrmModifyPassWord.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    edtNewPassWord.PasswordChar := #0;
    edtConfirmNewPassWord.PasswordChar := #0;
  end
  else
  begin
    edtNewPassWord.PasswordChar := '*';
    edtConfirmNewPassWord.PasswordChar := '*';
  end;
end;

procedure TfrmModifyPassWord.edtYMMKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    edtNewPassWord.SetFocus;
  end;
end;

procedure TfrmModifyPassWord.FormCreate(Sender: TObject);
begin
  m_RsLCDutyUser := TRsLCDutyUser.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmModifyPassWord.FormDestroy(Sender: TObject);
begin
  m_RsLCDutyUser.Free;
end;

end.
