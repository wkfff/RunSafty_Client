unit uFrmFingerVerify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons,uDataModule;

type
  TfrmFingerVerify = class(TForm)
    Label1: TLabel;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    Label2: TLabel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    procedure actEnterExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //挂接全局的指纹通知的对象
    m_strTrainmanGUID : string;
    procedure ClearTrainman;
    //捕获指纹仪消息
    procedure WMMSGFingerCapture(var Message: TMessage); message WM_MSGFingerCapture;  
  public
    { Public declarations }
    property TrainmanGUID : string read m_strTrainmanGUID;
  end;

var
  frmFingerVerify: TfrmFingerVerify;

implementation

{$R *.dfm}
uses
  uTrainman,MMSystem,uOrg;
procedure TfrmFingerVerify.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmFingerVerify.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmFingerVerify.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFingerVerify.btnSaveClick(Sender: TObject);
begin
  if edtTrainmanNumber.Text = '' then
  begin
    Application.MessageBox('请按压指纹查找司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmFingerVerify.ClearTrainman;
begin
  m_strTrainmanGUID := '';
  edtTrainmanNumber.Text := '';
  edtTrainmanName.Text := '';

end;

procedure TfrmFingerVerify.FormCreate(Sender: TObject);
begin
  DMGlobal.FingerMsgList.Add(IntToStr(Handle));
  btnSave.Enabled := false;
end;

procedure TfrmFingerVerify.FormDestroy(Sender: TObject);
begin
  DMGlobal.FingerMsgList.Delete(DMGlobal.FingerMsgList.Count - 1);
end;

procedure TfrmFingerVerify.WMMSGFingerCapture(var Message: TMessage);
var
  trainman : RTrainman;
begin
  try
    btnSave.Enabled := false;
    try
      ClearTrainman;
      trainman := TTrainmanOpt.GetTrainmanByFinger(DMGlobal.ZKFPEng,DMGlobal.ZKFPEng.GetTemplate);
      if trainman.GUID = '' then
      begin
        DMGlobal.ZKFPEng.SaveJPG(DMGlobal.ErrorFingerPath + FormatDateTime('yyyyMMddHHnnss',DMGlobal.GetNow) + '.jpg');
        DMGlobal.CallControl.SetPlayMode(2);
        PlaySound(PChar(DMGlobal.AppPath + 'Sounds\错误的指纹信息或指纹没有登记.wav'),0,SND_FILENAME or SND_ASYNC);
        exit;
      end;
      edtTrainmanNumber.Text := trainman.TrainmanNumber;
      edtTrainmanName.Text := trainman.TrainmanName;
      m_strTrainmanGUID := trainman.GUID;

    finally
      btnSave.Enabled := true;
    end;
  except
    DMGlobal.CallControl.SetPlayMode(2);
    PlaySound(PChar(DMGlobal.AppPath + 'Sounds\错误的指纹信息或指纹没有登记.wav'),0,SND_FILENAME or SND_ASYNC);
    exit;
  end;
end;

end.
