unit ufrmFindJDPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmFindJDPlan = class(TForm)
    Label1: TLabel;
    edtTrainNo: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure edtTrainNoExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowDialog(var TrainNo : string) : boolean;
  end;



implementation

{$R *.dfm}

procedure TfrmFindJDPlan.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFindJDPlan.btnOKClick(Sender: TObject);
begin
  if Trim(edtTrainNo.Text) = '' then
  begin
    application.MessageBox('请输入车次','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := mrOk;  
end;

procedure TfrmFindJDPlan.edtTrainNoExit(Sender: TObject);
begin
  TEdit(sender).Text := UpperCase(TEdit(sender).Text);
end;

class function TfrmFindJDPlan.ShowDialog(var TrainNo: string): boolean;
var
  frmFindJDPlan: TfrmFindJDPlan;
begin
  result := false;
  frmFindJDPlan:= TfrmFindJDPlan.Create(nil);
  frmFindJDPlan.edtTrainNo.Text := TrainNo;
  if frmFindJDPlan.ShowModal = mrCancel then
  begin
    exit;
  end;
  TrainNo := UpperCase(Trim(frmFindJDPlan.edtTrainNo.Text));
  result := true;
end;


end.
