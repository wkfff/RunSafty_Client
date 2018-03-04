unit uFrmLeaderExam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ActnList,ADODB;

type
  TfrmLeaderExam = class(TForm)
    btnMainFinger: TSpeedButton;
    btnMainInput: TSpeedButton;
    Label1: TLabel;
    edtLeaderName: TEdit;
    Label2: TLabel;
    edtLeaderNumber: TEdit;
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
    procedure btnMainInputClick(Sender: TObject);
    procedure btnMainFingerClick(Sender: TObject);
  private
    { Private declarations }
    m_strLeaderGUID : string;
    m_nVerifyID : integer;
  public
    { Public declarations }
  end;

var
  frmLeaderExam: TfrmLeaderExam;

implementation

{$R *.dfm}
uses
  uTrainman,uDataModule,uFrmFingerVerify,uLeaderExam;
procedure TfrmLeaderExam.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmLeaderExam.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmLeaderExam.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLeaderExam.btnMainFingerClick(Sender: TObject);
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      edtLeaderName.Text := frmFingerVerify.edtTrainmanName.Text;
      edtLeaderNumber.Text := frmFingerVerify.edtTrainmanNumber.Text;
      m_strLeaderGUID := frmFingerVerify.TrainmanGUID;
      m_nVerifyID := 1;
    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmLeaderExam.btnMainInputClick(Sender: TObject);
var
  mainNumber : string;
  trainman : RTrainman;
begin
  if Application.MessageBox('您确认要工号验证吗？','提示',MB_OKCANCEL) = mrCancel then exit;
  mainNumber := InputBox('请输入工号','请输入干部工号','');
  if mainNumber = '' then exit;

  trainman := TTrainmanOpt.GetTrainmanByNumber(mainNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('错误的乘务员工号','提示',MB_OK);
    exit;
  end;
  edtLeaderName.Text := trainman.TrainmanName;
  edtLeaderNumber.Text := trainman.TrainmanNumber;
  m_strLeaderGUID := trainman.GUID;
  m_nVerifyID := 2;
end;

procedure TfrmLeaderExam.btnSaveClick(Sender: TObject);
var
  exam : RLeaderExam;
begin
  if m_strLeaderGUID = '' then
  begin
    Application.MessageBox('请先验证干部信息。','提示',MB_OK);
    exit;
  end;
  if Application.MessageBox('您确定要保存信息吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  exam.LeaderGUID := m_strLeaderGUID;
  exam.VerifyID := m_nVerifyID;
  exam.DutyGUID := DMGlobal.DutyUser.DutyGUID;
  exam.AreaGUID := DMGlobal.LocalArea;
  if TLeaderExanOpt.AddLeaderExam(exam) then
  begin
    Application.MessageBox('检查成功。','提示',MB_OK);
    ModalResult := mrOk;
  end
  else
    Application.MessageBox('检查失败。','提示',MB_OK);
end;

procedure TfrmLeaderExam.FormCreate(Sender: TObject);
begin
  m_strLeaderGUID := '';
  m_nVerifyID := 0;
end;

end.
