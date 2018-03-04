unit uFrmTrainNoSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList,ADODB;

type
  TfrmTrainNoSelect = class(TForm)
    Label1: TLabel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    edtTrainNo: TEdit;
    procedure actEnterExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    m_strTrainNo:string;

    class function InputTrainNo(var TrainNo : string) : boolean;
  end;

implementation

{$R *.dfm}
procedure TfrmTrainNoSelect.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmTrainNoSelect.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmTrainNoSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainNoSelect.btnSaveClick(Sender: TObject);
begin
  if Trim(edtTrainNo.Text) = '' then
  begin
    Application.MessageBox('请选择车次','提示',MB_OK + MB_ICONINFORMATION);
    edtTrainNo.SetFocus;
    exit;
  end;
  m_strTrainNo := Trim(edtTrainNo.Text) ;
  ModalResult := mrOk;
end;

class function TfrmTrainNoSelect.InputTrainNo(var TrainNo: string): boolean;
var
  frmTrainNoSelect : TfrmTrainNoSelect;
begin
  result := false;
  frmTrainNoSelect := TfrmTrainNoSelect.Create(nil);
  try
    frmTrainNoSelect.edtTrainNo.Text := TrainNo;
    if frmTrainNoSelect.ShowModal = mrCancel then exit;
    trainNo := frmTrainNoSelect.edtTrainNo.Text;
    result := true;
  finally
    frmTrainNoSelect.Free;
  end;
end;

end.
