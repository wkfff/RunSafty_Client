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
  if Application.MessageBox('��ȷ��Ҫ������֤��','��ʾ',MB_OKCANCEL) = mrCancel then exit;
  mainNumber := InputBox('�����빤��','������ɲ�����','');
  if mainNumber = '' then exit;

  trainman := TTrainmanOpt.GetTrainmanByNumber(mainNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('����ĳ���Ա����','��ʾ',MB_OK);
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
    Application.MessageBox('������֤�ɲ���Ϣ��','��ʾ',MB_OK);
    exit;
  end;
  if Application.MessageBox('��ȷ��Ҫ������Ϣ��','��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  exam.LeaderGUID := m_strLeaderGUID;
  exam.VerifyID := m_nVerifyID;
  exam.DutyGUID := DMGlobal.DutyUser.DutyGUID;
  exam.AreaGUID := DMGlobal.LocalArea;
  if TLeaderExanOpt.AddLeaderExam(exam) then
  begin
    Application.MessageBox('���ɹ���','��ʾ',MB_OK);
    ModalResult := mrOk;
  end
  else
    Application.MessageBox('���ʧ�ܡ�','��ʾ',MB_OK);
end;

procedure TfrmLeaderExam.FormCreate(Sender: TObject);
begin
  m_strLeaderGUID := '';
  m_nVerifyID := 0;
end;

end.
