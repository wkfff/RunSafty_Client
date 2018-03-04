unit ufrmTrainmanNumberInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFSystem, RzCmboBx;

type

  TFrmTrainmanNumberInput = class(TForm)
    edtText: TEdit;
    btnConfirm: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {功能:文本输入}
  function TrainmanNumberInput(strTitle,strCaption:String;var strText:String):Boolean;

var
  FrmTrainmanNumberInput: TFrmTrainmanNumberInput;

implementation

uses
  uGlobalDM ;

{$R *.dfm}

procedure TFrmTrainmanNumberInput.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTrainmanNumberInput.btnConfirmClick(Sender: TObject);
const
  TrianmanNumberLength : ShortInt = 7 ;
var
  strTrainmanNumber:string;
begin

  strTrainmanNumber := Trim ( edtText.Text );

  if strTrainmanNumber = '' then
  begin
    Box('工号不能为空!');
    Exit;
  end;

  if Length(strTrainmanNumber) <> TrianmanNumberLength then
  begin
    Box('工号必须为7位!');
    Exit;
  end;

  ModalResult := mrok;
end;

{功能:文本输入}
function TrainmanNumberInput(strTitle,strCaption:String;var strText:String):Boolean;
{功能:文本输入}
var
  frmTextInput: TFrmTrainmanNumberInput;
begin
  Result := False;
  frmTextInput:= TFrmTrainmanNumberInput.Create(nil);
  try
    frmTextInput.Caption := strTitle;
    frmTextInput.edtText.Text := strText;
    if frmTextInput.ShowModal = mrok then
    begin
      Result := True;
      strText := Trim(frmTextInput.edtText.Text);
    end;
  finally
    frmTextInput.Free;
  end;
end;


end.
