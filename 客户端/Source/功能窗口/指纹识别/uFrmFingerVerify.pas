unit uFrmFingerVerify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Buttons,uGlobalDM;

type
  TfrmFingerVerify = class(TForm)
    Label1: TLabel;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    Label2: TLabel;
    edtPartName: TEdit;
    Label3: TLabel;
    edtWorkShopName: TEdit;
    Label4: TLabel;
    edtGroupName: TEdit;
    Label5: TLabel;
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
  public
    { Public declarations }
    property TrainmanGUID : string read m_strTrainmanGUID;
  end;

var
  frmFingerVerify: TfrmFingerVerify;

implementation

{$R *.dfm}
uses
  uTrainman,MMSystem,uDBTrainman;
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


procedure TfrmFingerVerify.FormCreate(Sender: TObject);
begin
  GlobalDM.FingerMsgList.Add(IntToStr(Handle));
  btnSave.Enabled := false;
end;

procedure TfrmFingerVerify.FormDestroy(Sender: TObject);
begin
  GlobalDM.FingerMsgList.Delete(GlobalDM.FingerMsgList.Count - 1);
end;


end.
