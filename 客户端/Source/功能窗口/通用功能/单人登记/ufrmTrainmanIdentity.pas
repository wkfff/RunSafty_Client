unit ufrmTrainmanIdentity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngBitBtn, RzAnimtr, PngSpeedButton, ExtCtrls,
  pngimage, RzPanel,uTrainman,uTFSystem,uGlobalDM,uTrainPlan,ufrmTextInput,
  Mask, RzEdit,uTFVariantUtils,uSaftyEnum,ZKFPEngXControl_TLB,
  uLCTrainmanMgr;
const
  WM_TRAINMANFINHERPRINTLOGIN = WM_User+ 1;
  //指纹识别失败，wParam=0 指纹仪故障，wParam=1 找不到司机的指纹
  WM_FingerFail = WM_User + 2;
  //窗体显示
  WM_FormShow = WM_User + 3;
type
  TFrmTrainmanIdentity = class(TForm)
    RzPanel7: TRzPanel;
    Label11: TLabel;
    Image4: TImage;
    Panel1: TPanel;
    Label12: TLabel;
    lblAnalysis: TLabel;
    RzPanel2: TRzPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblTrainmanName1: TLabel;
    lblTrainmanNumber1: TLabel;
    imgTrainmanPicture1: TPaintBox;
    btnCancelTrainman1: TPngSpeedButton;
    RzPanel1: TRzPanel;
    Label10: TLabel;
    btnCancel: TPngBitBtn;
    tmrAutoHideHint: TTimer;
    tmrRevocation: TTimer;
    Animator: TRzAnimator;
    edtGongHaoInput: TRzEdit;
    lbl1: TLabel;
    pngbtnOK: TPngBitBtn;
    RzPanel3: TRzPanel;
    ImgFinger: TImage;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelTrainman1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrRevocationTimer(Sender: TObject);
    procedure tmrAutoHideHintTimer(Sender: TObject);
    procedure imgTrainmanPicture1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pngbtnOKClick(Sender: TObject);
  public
    {初始化窗体显示}
    procedure ClearInfo;    
  private
    {功能:按下指纹仪}
    procedure OnFingerTouching(Sender:TObject);
    {功能:识别失败}
    procedure OnFingerLoginFailure(Sender:TObject);
    {功能：乘务员登录}
    procedure OnFingerLoginSuccess(strUserNumber : String);
    {功能:指纹图像捕捉}
    procedure OnZKFPEngXOnImageReceived(ASender: TObject; var AImageValid: WordBool);
    
    procedure LoadTrainman(strTrainmanNumber: String;
      RegisterFlag: TRsRegisterFlag;bFingureSucess:Boolean);
    procedure ShowTrainmanInfo ;
    {功能:响应乘务员指纹登录消息}
    procedure WMTrainmanLogin(var Message:TMessage);Message WM_TRAINMANFINHERPRINTLOGIN;
    //指纹识别失败消息
    procedure WMFingerFail(var Message:TMessage);Message WM_FingerFail;
    procedure WMFormShow(var message : TMessage);message WM_FormShow;
  private
    {是否有功能在运行}
    m_bIsRunFunction : Boolean;
    {最后一次登记的工号}
    m_strLastTrainmanNumber : String;
    {乘务员列表}
    m_TrainMan : RRsTrainman;
    m_nVerify : TRsRegisterFlag;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_bInputShowed : Boolean;
    m_nFingureErr : Integer;
    m_bFirst : boolean;

    m_strTrainmanGUID1:string;
    m_strTrainmanGUID2:string;
    m_strTrainmanGUID3:string;
    m_strTrainmanGUID4:string;

  published
    property TrainmanGUID1:string read m_strTrainmanGUID1 write m_strTrainmanGUID1; 
    property TrainmanGUID2:string read m_strTrainmanGUID2 write m_strTrainmanGUID2;
    property TrainmanGUID3:string read m_strTrainmanGUID3 write m_strTrainmanGUID3;
    property TrainmanGUID4:string read m_strTrainmanGUID4 write m_strTrainmanGUID4;
  end;

  const MAX_ERROR_CNT = 20;
var
  nFailureCnt:Integer;

  function IdentfityTrainman(Sender : TObject;var Trainman:RRsTrainman;
    out Verify : TRsRegisterFlag;strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3:string;strTrainmanGUID4:string;DefaultTrainmanNumber:string = '') : boolean;


  function TmLogin(var Trainman:RRsTrainman;
    out Verify : TRsRegisterFlag;AllowNumber: Boolean = false) : boolean;
implementation

{$R *.dfm}

function TmLogin(var Trainman:RRsTrainman;
    out Verify : TRsRegisterFlag;AllowNumber: Boolean = false) : boolean;
var
  frmIdentity: TFrmTrainmanIdentity;
begin
  Result := false;

  frmIdentity := TFrmTrainmanIdentity.Create(nil);
  try
    if not AllowNumber then
    begin
      frmIdentity.edtGongHaoInput.Enabled := False;
      frmIdentity.pngbtnOK.Enabled := False;
    end;
    
    if frmIdentity.ShowModal = mrOk then
    begin
      TrainMan := frmIdentity.m_TrainMan;
      Verify := frmIdentity.m_nVerify;
      Result := true;
    end;
  finally
    frmIdentity.Free;
  end;
end;
function IdentfityTrainman(Sender : TObject;var Trainman:RRsTrainman;
  out Verify : TRsRegisterFlag;
  strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3:string;strTrainmanGUID4:string;DefaultTrainmanNumber:string = '') : boolean;
var
  frmIdentity: TFrmTrainmanIdentity;
begin
  Result := false;

  frmIdentity := TFrmTrainmanIdentity.Create(nil);
  try
    frmIdentity.TrainmanGUID1 := strTrainmanGUID1;
    frmIdentity.TrainmanGUID2 := strTrainmanGUID2;
    frmIdentity.TrainmanGUID3 := strTrainmanGUID3;
    frmIdentity.TrainmanGUID4 := strTrainmanGUID4;
    frmIdentity.edtGongHaoInput.Text := DefaultTrainmanNumber;
    if Sender <> nil then
      frmIdentity.OnFingerTouching(Sender);
    if frmIdentity.ShowModal = mrOk then
    begin
      TrainMan := frmIdentity.m_TrainMan;
      Verify := frmIdentity.m_nVerify;
      Result := true;
    end;
  finally
    frmIdentity.Free;
  end;
end;

procedure TFrmTrainmanIdentity.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TFrmTrainmanIdentity.btnCancelTrainman1Click(Sender: TObject);
begin
  ShowTrainmanInfo();
end;

procedure TFrmTrainmanIdentity.FormCreate(Sender: TObject);
begin
  Animator.Visible := False;
  m_bFirst := true;
  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  GlobalDM.FingerPrintCtl.OnLoginFail := OnFingerLoginFailure;
  GlobalDM.FingerPrintCtl.OnLoginSuccess := OnFingerLoginSuccess;
  if GlobalDM.FingerPrintCtl.ZKFPEngX <> nil then
    GlobalDM.FingerPrintCtl.ZKFPEngX.OnImageReceived := OnZKFPEngXOnImageReceived;

  m_bIsRunFunction := False;
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmTrainmanIdentity.FormDestroy(Sender: TObject);
begin
  GlobalDM.FingerPrintCtl.EventHolder.Restore;
  m_RsLCTrainmanMgr.Free;
end;

procedure TFrmTrainmanIdentity.FormShow(Sender: TObject);
begin
  if not m_bFirst then exit;
  m_bFirst := false;
  PostMessage(Handle,WM_FormShow,0,0);;

end;

procedure TFrmTrainmanIdentity.imgTrainmanPicture1Paint(Sender: TObject);
begin
  TTFVariantUtils.CopyJPEGVariantToPaintBox(m_TrainMan.Picture,TPaintBox(Sender));
end;

procedure TFrmTrainmanIdentity.OnFingerLoginFailure(Sender: TObject);
var
  strNumber:string;
  nCnt :Integer;
begin
  m_nFingureErr := m_nFingureErr+1;
  tmrRevocation.Enabled := False;
  tmrAutoHideHint.Enabled := False;
  tmrAutoHideHint.Enabled := True;
  Animator.Visible := False;
  nCnt := MAX_ERROR_CNT - m_nFingureErr;

  if m_nFingureErr = MAX_ERROR_CNT then
  begin
    m_nFingureErr := 0;

    if TextInput('乘务员身份验证','指纹识别失败,请输入乘务员工号:',strNumber) = False then
      Exit;

    if m_RsLCTrainmanMgr.ExistNumber('',strNumber) = False then
    begin
      m_bInputShowed := false;
      //ModalResult := mrCancel;
      Box('错误的工号');
      exit;
    end
    else
    begin
      m_strLastTrainmanNumber := strNumber;
      PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,
        Ord(rfFingerprint),0);
    end;
  end;
  lblAnalysis.Caption := '指纹识别失败!,还可按压'+IntToStr(nCnt)+'次';
  GlobalDM.PlaySoundFile('指纹识别失败.wav');
end;

procedure TFrmTrainmanIdentity.OnFingerLoginSuccess(strUserNumber: String);
{功能：乘务员登录}
begin
  lblAnalysis.Caption := '识别成功!';
  
  if m_bIsRunFunction then Exit;
  if StrComp(PAnsiChar(m_strLastTrainmanNumber),PAnsiChar(strUserNumber)) = 0 then  Exit;
  m_nFingureErr := 0;
  tmrAutoHideHint.Enabled := True;
  tmrRevocation.Enabled := False;
  Animator.Visible := False;

  GlobalDM.PlaySoundFile('指纹识别成功请等待测酒仪就绪.wav');
  if m_strLastTrainmanNumber = '' then
  begin
    m_strLastTrainmanNumber := strUserNumber;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfFingerprint),0);
  end;
end;

procedure TFrmTrainmanIdentity.OnFingerTouching(Sender: TObject);
begin
  tmrAutoHideHint.Enabled := False;
  tmrRevocation.Enabled := True;
  lblAnalysis.Caption := '正在识别指纹...';
  lblAnalysis.Visible := True;
  Animator.Visible := True;
end;

procedure TFrmTrainmanIdentity.OnZKFPEngXOnImageReceived(ASender: TObject;
  var AImageValid: WordBool);
begin
  if AImageValid = False then Exit;
  GlobalDM.FingerPrintCtl.ZKFPEngX.SaveBitmap('Finger.bmp');
  ImgFinger.Picture.LoadFromFile('Finger.bmp');
end;

procedure TFrmTrainmanIdentity.pngbtnOKClick(Sender: TObject);
begin
  if Trim(edtGongHaoInput.Text) = '' then
  begin
    MessageBox(Handle,'请输入工号!','错误',MB_ICONHAND);
    Exit;
  end;
  m_strLastTrainmanNumber := Trim(edtGongHaoInput.Text);

  if GlobalDM.FingerPrintCtl.ExistNumber(m_strLastTrainmanNumber) = False then
  begin
    edtGongHaoInput.SetFocus;
    MessageBox(Handle,'输入的工号不存在,请重新输入!','错误',MB_ICONHAND);
    Exit;
  end
  else
  begin
    if not((TrainmanGUID1 = '') and (TrainmanGUID2= '') and (TrainmanGUID3='') and (TrainmanGUID4='')) then
    begin
      GlobalDM.FingerPrintCtl.FindTmByNumber(m_strLastTrainmanNumber,m_TrainMan);
      if (m_TrainMan.strTrainmanGUID <> TrainmanGUID1) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID2) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID3) and
        (m_TrainMan.strTrainmanGUID <> TrainmanGUID4) then
      begin
        edtGongHaoInput.SetFocus;
        MessageBox(Handle,'不是本班人员,请重新输入!','错误',MB_ICONHAND);
        Exit;
      end;
    end;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,
      Ord(rfInput),0);
  end;
end;

procedure TFrmTrainmanIdentity.LoadTrainman(strTrainmanNumber: String;
  RegisterFlag: TRsRegisterFlag;bFingureSucess:Boolean);
{功能:有新的乘务员登记}
begin
  if not bFingureSucess then
  begin
    lblAnalysis.Show;
    lblAnalysis.Caption := '指纹识别失败!,还可按压2次';
    m_nFingureErr := 1;
    Exit;
  end;

  if Length(Trim(strTrainmanNumber)) = 0 then
    Exit;

  if not GlobalDM.FingerPrintCtl.FindTmByNumber(strTrainmanNumber,m_TrainMan) then
  begin
    lblAnalysis.Show;
    lblAnalysis.Caption := '没有找到人员!';
  end;
end;

procedure TFrmTrainmanIdentity.ShowTrainmanInfo;
{功能:显示乘务员信息}
begin
  if m_TrainMan.strTrainmanGUID <> '' then
  begin
    lblTrainmanName1.Caption := m_TrainMan.strTrainmanName;
    lblTrainmanNumber1.Caption := m_TrainMan.strTrainmanNumber;
    btnCancelTrainman1.Visible := True;
    imgTrainmanPicture1.Repaint;
  end
  else
  begin
    lblTrainmanName1.Caption := '';
    lblTrainmanNumber1.Caption := '';
    btnCancelTrainman1.Visible := False;
    imgTrainmanPicture1.Repaint;
  end;
end;
procedure TFrmTrainmanIdentity.tmrAutoHideHintTimer(Sender: TObject);
begin
  tmrAutoHideHint.Enabled := False;
  //Animator.Visible := False;
  //lblAnalysis.Visible := False;
end;

procedure TFrmTrainmanIdentity.tmrRevocationTimer(Sender: TObject);
begin
   OnFingerLoginFailure(nil);
end;

procedure TFrmTrainmanIdentity.WMFingerFail(var Message: TMessage);
var
  strNumber : string;
begin
  if not GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    if TextInput('乘务员身份验证','指纹仪故障,请输入乘务员工号:',strNumber) = False then
    begin
      ModalResult := mrCancel;
      Exit;
    end;
  end else begin
    if TextInput('乘务员身份验证','没有找到匹配的指纹,请输入乘务员工号:',strNumber) = False then
    begin
      Exit;
    end;
  end;

  if m_RsLCTrainmanMgr.ExistNumber('',strNumber) = False then
  begin
    m_bInputShowed := false;
    Box('错误的工号');
    exit;
  end
  else
  begin
    m_strLastTrainmanNumber := strNumber;
    PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfInput),0);
  end;
end;

procedure TFrmTrainmanIdentity.WMFormShow(var message: TMessage);
var
  strNumber : string;
begin
  if m_Trainman.strTrainmanGUID <> '' then
    PostMessage(Handle,WM_FingerFail,0,0)
  else begin
    if not GlobalDM.FingerPrintCtl.InitSuccess then
    begin
      if TextInput('乘务员身份验证','指纹仪故障,请输入乘务员工号:',strNumber) = False then
      begin
        ModalResult := mrCancel;
        Exit;
      end;
      if m_RsLCTrainmanMgr.ExistNumber('',strNumber) = False then
      begin
        m_bInputShowed := false;
        Box('错误的工号');
        exit;
      end
      else
      begin
        m_strLastTrainmanNumber := strNumber;
        PostMessage(Handle,WM_TRAINMANFINHERPRINTLOGIN,Ord(rfInput),0);
      end;
    end;
  end;
end;

procedure TFrmTrainmanIdentity.WMTrainmanLogin(var Message: TMessage);
begin
  if Message.WParam = Ord(rfFingerprint) then
  begin
    LoadTrainman(m_strLastTrainmanNumber,rfFingerprint,true);
    m_nVerify := rfFingerprint;
  end
  else
  begin
    LoadTrainman(m_strLastTrainmanNumber,rfInput,True);
    m_nVerify := rfInput;
  end;
  ShowTrainmanInfo;
  ModalResult := mrOk;
end;
procedure TFrmTrainmanIdentity.ClearInfo;
begin
  m_strLastTrainmanNumber := '';
  Invalidate;
end;

end.
