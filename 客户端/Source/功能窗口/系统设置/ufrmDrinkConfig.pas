unit ufrmDrinkConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uDataModule, RzShellDialogs, Buttons, ActnList;

type
  TfrmDrinkConfig = class(TForm)
    Label1: TLabel;
    edtDrinkPath: TEdit;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    btnBrowser: TSpeedButton;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    ActionList1: TActionList;
    actEnter: TAction;
    actClose: TAction;
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDrinkConfig: TfrmDrinkConfig;

implementation

{$R *.dfm}

procedure TfrmDrinkConfig.actCloseExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmDrinkConfig.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmDrinkConfig.btnBrowserClick(Sender: TObject);
begin
   if RzSelectFolderDialog1.Execute then
     edtDrinkPath.Text := RzSelectFolderDialog1.SelectedPathName;
end;

procedure TfrmDrinkConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDrinkConfig.btnSaveClick(Sender: TObject);
begin
  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;  
  DMGlobal.DrinkPath := edtDrinkPath.Text;
  DMGlobal.SaveConfig;
  ModalResult := mrOk;
end;

procedure TfrmDrinkConfig.FormCreate(Sender: TObject);
begin
  edtDrinkPath.Text :=  DMGlobal.DrinkPath;
end;

end.
