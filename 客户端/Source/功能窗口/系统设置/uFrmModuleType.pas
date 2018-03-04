unit uFrmModuleType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, Buttons;

type
  TfrmModuleType = class(TForm)
    Label4: TLabel;
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    ActionList1: TActionList;
    actEnter: TAction;
    actClose: TAction;
    CombModuleType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModuleType: TfrmModuleType;

implementation
uses
  uDataModule;
{$R *.dfm}

procedure TfrmModuleType.actCloseExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmModuleType.actEnterExecute(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TfrmModuleType.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmModuleType.btnOKClick(Sender: TObject);
begin
  if CombModuleType.ItemIndex < 0 then
  begin
    Application.MessageBox('��ѡ��һ������ģʽ.','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Application.MessageBox('��ȷ��Ҫ������','��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  
  DMGlobal.ModuleType := CombModuleType.ItemIndex + 1;
  DMGlobal.SaveConfig;
  Application.MessageBox('����ɹ����������������������Ч.','��ʾ',MB_OK + MB_ICONINFORMATION);
  ModalResult:= mrOk;
end;

procedure TfrmModuleType.FormCreate(Sender: TObject);
begin
  if DMGlobal.ModuleType in [1..3] then
  begin
    CombModuleType.ItemIndex := DMGlobal.ModuleType - 1;
    exit;
  end;
  CombModuleType.ItemIndex := -1;
end;

end.
