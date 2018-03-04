unit uFrmMinRestLength;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList;

type
  TfrmMinRestLength = class(TForm)
    edtMinRestLength: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnClose: TSpeedButton;
    btnSave: TSpeedButton;
    ActionList1: TActionList;
    actEnter: TAction;
    actClose: TAction;
    Label3: TLabel;
    procedure actEnterExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMinRestLength: TfrmMinRestLength;

implementation

{$R *.dfm}
uses
  uDataModule;
procedure TfrmMinRestLength.actCloseExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TfrmMinRestLength.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmMinRestLength.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmMinRestLength.btnSaveClick(Sender: TObject);
var
  restLength : double;
begin
  if not TryStrToFloat(edtMinRestLength.Text,restLength) then
  begin
    Application.MessageBox('最小强休时长必须为整数或1位小数','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  DMGlobal.MinRestLength := restLength;
  Application.MessageBox('保存成功','提示',MB_OK + MB_ICONINFORMATION);
  ModalResult := mrOk;
end;

procedure TfrmMinRestLength.FormCreate(Sender: TObject);
begin
  edtMinRestLength.Text := FloatToStr(DMGlobal.MinRestLength);
end;

end.
