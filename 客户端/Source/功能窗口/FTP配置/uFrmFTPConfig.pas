unit uFrmFTPConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IniFiles,idftp,uFTPTransportControl,uTFSystem;

type
  TfrmFTPConfig = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edtHost: TEdit;
    Label2: TLabel;
    edtPort: TEdit;
    edtUserName: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    edtPassword: TEdit;
    edtPath: TEdit;
    Label6: TLabel;
    btnTestConnection: TButton;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure init ();
  end;

var
  frmFTPConfig: TfrmFTPConfig;

implementation

uses uGlobalDM;

{$R *.dfm}

{ TfrmFTPConfig }

procedure TfrmFTPConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFTPConfig.btnOKClick(Sender: TObject);
var
  ini: TIniFile;
begin
  try
    ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
    ini.WriteString('FTP','Host',edtHost.Text);
    ini.WriteString('FTP','Port',edtPort.Text);
    ini.WriteString('FTP','UserName',edtUserName.Text);
    ini.WriteString('FTP','Password',edtPassword.Text);
    ini.WriteString('FTP','Path',edtPath.Text);
    DMCallRoom.FTPCon.SetFTPConfig();
  finally
    ini.Free;
    ModalResult := mrOk;
  end;
end;

procedure TfrmFTPConfig.btnTestConnectionClick(Sender: TObject);
var
  FTPCon: TIdFTP;
begin
  try
    FTPCon := TIdFTP.Create;
    FTPCon.Host := edtHost.Text;
    FTPCon.Port := StrToInt(edtPort.Text);
    FTPCon.UserName := edtUserName.Text;
    FTPCon.PassWord := edtPassword.Text;

    if not FTPCon.Connected then FTPCon.Connect;
    if not FTPCon.Connected then ShowMessage('≤‚ ‘ ß∞‹£°')
    else ShowMessage('≤‚ ‘≥…π¶£°');
  except
    on E: Exception do
      ShowMessage('≤‚ ‘ ß∞‹£°');
  end;
  if FTPCon.Connected then FTPCon.Disconnect;
  FTPCon.Free;
end;

class procedure TfrmFTPConfig.init;
var
  ini: TIniFile;
begin
  try
    frmFTPConfig := TfrmFTPConfig.Create(nil);
    ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
    frmFTPConfig.edtHost.Text := ini.ReadString('FTP','Host','127.0.0.1');
    frmFTPConfig.edtPort.Text := ini.ReadString('FTP','Port','21');
    frmFTPConfig.edtUserName.Text := ini.ReadString('FTP','UserName','');
    frmFTPConfig.edtPassword.Text := ini.ReadString('FTP','Password','');
    frmFTPConfig.edtPath.Text := ini.ReadString('FTP','Path','');
    frmFTPConfig.ShowModal;
  finally
    ini.Free;
    frmFTPConfig.Free;
  end;
end;

end.
