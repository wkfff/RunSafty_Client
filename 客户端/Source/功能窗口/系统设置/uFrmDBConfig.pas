unit uFrmDBConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ActnList;

type
  TfrmDBConfig = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtUserName: TEdit;
    edtPassword: TEdit;
    edtDBName: TEdit;
    edtIP: TEdit;
    Label4: TLabel;
    btnTest: TSpeedButton;
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    Panel1: TPanel;
    ActionList1: TActionList;
    actEnter: TAction;
    actClose: TAction;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBConfig: TfrmDBConfig;

implementation

{$R *.dfm}
uses
  uDataModule,adodb,ADOInt;
  
procedure TfrmDBConfig.actCloseExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmDBConfig.actEnterExecute(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TfrmDBConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDBConfig.btnOKClick(Sender: TObject);
begin
  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  DMGlobal.DBConfig.UserName := edtUserName.Text;
  DMGlobal.DBConfig.Password := edtPassword.Text;
  DMGlobal.DBConfig.DBName := edtDBName.Text;
  DMGlobal.DBConfig.IP := edtIP.Text;
  DMGlobal.SaveConfig;
  ModalResult := mrOk;
end;

procedure TfrmDBConfig.btnTestClick(Sender: TObject);
var
  adoConn : TADOConnection;
begin
  adoConn := TADOConnection.Create(nil);
  try
    adoConn.CommandTimeout := 10000;
    adoConn.ConnectionString := format(DMGlobal.DBConnExp,[edtIP.Text,edtUserName.Text,edtPassword.Text,edtDBName.Text]);
    adoConn.LoginPrompt := false;
    adoConn.ConnectOptions := coAsyncConnect;
    btnCancel.Enabled := false;
    btnOK.Enabled := false;
    btnTest.Enabled := false;
    adoConn.Open;
    try
      try
          //根据状态判断连接是否结束
          while adoConn.ConnectionObject.State = adStateConnecting do
          begin
            Application.ProcessMessages;
            Sleep(500);
          end;
          //完毕后判断是否连接通过
          if adoConn.Connected then
          begin
            Application.MessageBox('连接正常','提示',MB_OK + MB_ICONINFORMATION);
            exit;
          end;
          Application.MessageBox('连接异常','提示',MB_OK + MB_ICONERROR);
        except
          Application.MessageBox('连接异常','提示',MB_OK + MB_ICONERROR);
        end;
    finally
      btnCancel.Enabled := true;
      btnOK.Enabled := true;
      btnTest.Enabled := true;
    end;
  finally
    adoConn.Close;
    adoConn.Free;
  end;
end;

procedure TfrmDBConfig.FormCreate(Sender: TObject);
begin
  edtIP.Text := DMGlobal.DBConfig.IP;
  edtUserName.Text := DMGlobal.DBConfig.UserName;
  edtPassword.Text := DMGlobal.DBConfig.Password;
  edtDBName.Text := DMGlobal.DBConfig.DBName;
end;

end.
