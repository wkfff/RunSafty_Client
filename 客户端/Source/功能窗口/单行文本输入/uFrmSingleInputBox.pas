unit uFrmSingleInputBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem;

type
  TfrmSingleInputBox = class(TForm)
    lblHint: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtText: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function InputBox(FormCaption : string;LabelHint : string ;var InputText : string) : boolean;
  end;



implementation

{$R *.dfm}

procedure TfrmSingleInputBox.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSingleInputBox.btnOKClick(Sender: TObject);
begin
  if Trim(edtText.Text) = '' then
  begin
    Box('输入内容不能为空');
    exit;
  end;
  ModalResult := mrOk;
end;

class function TfrmSingleInputBox.InputBox(FormCaption : string;LabelHint : string ;
  var InputText: string): boolean;
var
  frmSingleInputBox: TfrmSingleInputBox;
begin
  result := false;
  frmSingleInputBox:= TfrmSingleInputBox.Create(nil);
  try
    frmSingleInputBox.Caption := FormCaption;
    frmSingleInputBox.lblHint.Caption := LabelHint;
    frmSingleInputBox.edtText.Text := InputText;
    if frmSingleInputBox.ShowModal = mrCancel then exit;
    InputText := frmSingleInputBox.edtText.Text;
    result := true;
  finally
    frmSingleInputBox.Free;
  end;
end;

end.
