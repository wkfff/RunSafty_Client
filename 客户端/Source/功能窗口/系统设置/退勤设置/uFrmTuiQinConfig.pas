unit uFrmTuiQinConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzTabs,uRsDBConfigOpr, Mask, RzEdit, uGlobalDM;

type
  TFrmTuiQinConfig = class(TForm)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    Label14: TLabel;
    edtOutWorkHours: TRzNumericEdit;
    Label1: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowForm: TModalResult;
  end;

implementation

{$R *.dfm}
          
class function TFrmTuiQinConfig.ShowForm: TModalResult;
begin
  result := mrNone;
  with TFrmTuiQinConfig.Create(nil) do
  try
    result := ShowModal;
  finally
    Free;
  end;
end;

procedure TFrmTuiQinConfig.FormShow(Sender: TObject);
begin
  edtOutWorkHours.Value := GlobalDM.OutWorkHours;
end;

procedure TFrmTuiQinConfig.btnOkClick(Sender: TObject);
var
  nOutWorkHours: word;
begin
  nOutWorkHours := StrToIntDef(edtOutWorkHours.Text, 17);
  if nOutWorkHours <= 0 then nOutWorkHours := 17;
  GlobalDM.OutWorkHours := nOutWorkHours;
  ModalResult := mrOk;
end;

procedure TFrmTuiQinConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
