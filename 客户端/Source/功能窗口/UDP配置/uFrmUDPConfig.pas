unit uFrmUDPConfig; //叫班模式配置窗口（闫）

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,IniFiles, ExtCtrls,StrUtils;

type
  TfrmUDPConfig = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    grpUDPConfig: TGroupBox;
    Label2: TLabel;
    edtRemoteAddress: TEdit;
    edtRemotePort: TEdit;
    Label3: TLabel;
    grpInstallAddress: TGroupBox;
    rbGongYu: TRadioButton;
    rbPaiBanShi: TRadioButton;
    grpModelConfig: TGroupBox;
    rbNormalCall: TRadioButton;
    rbRemotCall: TRadioButton;
    Label1: TLabel;
    edtLocalPort: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure rbGongYuClick(Sender: TObject);
    procedure rbPaiBanShiClick(Sender: TObject);
    procedure rbNormalCallClick(Sender: TObject);
    procedure rbRemotCallClick(Sender: TObject);
  private
    m_nLocalPort: Integer;//本地UDP端口
    m_strHost: string;//远程UDP地址
    m_nHostPort: Integer;//远程UDP端口
    m_bInstallAddress: Boolean;//客户端安装地点（True公寓，False派班室）
    m_bCallModel: Boolean;//叫班模式（True正常叫班，False远程叫班）
  private
    procedure CheckgrpUDPConfig;
    procedure CheckgrpInstallAddress;
    procedure CheckgrpCallModel;
    { Private declarations }
  public
    class procedure init();
  published
    property nLocalPort: Integer read m_nLocalPort write m_nLocalPort;
    property strHost: string read m_strHost write m_strHost;
    property nHostPort: Integer read m_nHostPort write m_nHostPort;
    property bInstallAddress: Boolean read m_bInstallAddress write m_bInstallAddress;
    property bCallModel: Boolean read m_bCallModel write m_bCallModel;
    { Public declarations }
  end;

var
  frmUDPConfig: TfrmUDPConfig;

implementation

{$R *.dfm}

{ TfrmUDPConfig }

procedure TfrmUDPConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmUDPConfig.btnOKClick(Sender: TObject);
var
  ini: TIniFile;
begin
  if Trim(edtLocalPort.Text) = '' then Exit;
  if Trim(edtRemoteAddress.Text) = '' then Exit;
  if Trim(edtRemotePort.Text) = '' then Exit;
  try
    StrToInt(edtLocalPort.Text);
    StrToInt(edtRemotePort.Text);
  except on e : exception do
    begin
      ShowMessage('端口栏中必须输入数字');
      Exit;
    end;
  end;
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  try
    ini.WriteInteger('UDP','LocalPort',StrToInt(edtLocalPort.Text));
    ini.WriteInteger('UDP','HostPort',StrToInt(edtRemotePort.Text));
    ini.WriteString('UDP','Host',edtRemoteAddress.Text);
    ini.WriteString('InstallAddress','Address',IfThen(m_bInstallAddress,'0','1'));
    ini.WriteString('CallModel','Model',IfThen(m_bCallModel,'0','1'));
  finally
    ini.Free;
    ShowMessage('保存成功');
    ModalResult := mrOk;
  end;
end;

procedure TfrmUDPConfig.CheckgrpCallModel;
begin
  if m_bCallModel then rbNormalCall.Checked := True
  else rbRemotCall.Checked := True;
end;

procedure TfrmUDPConfig.CheckgrpInstallAddress;
begin
  if m_bInstallAddress then rbGongYu.Checked := True
  else rbPaiBanShi.Checked := True;
  if m_bCallModel then
  begin
    rbGongYu.Enabled := False;
    rbPaiBanShi.Enabled := False;
  end
  else begin
    rbGongYu.Enabled := True;
    rbPaiBanShi.Enabled := True;
  end;    
end;

procedure TfrmUDPConfig.CheckgrpUDPConfig;
begin
  if m_bCallModel  then
  begin
    edtLocalPort.Enabled := False;
    edtRemotePort.Enabled := False;
    edtRemoteAddress.Enabled := False;
    Label1.Enabled := False;
    Label2.Enabled := False;
    Label3.Enabled := False;
  end
  else begin
    edtLocalPort.Enabled := True;
    edtRemotePort.Enabled := True;
    edtRemoteAddress.Enabled := True;
    Label1.Enabled := True;
    Label2.Enabled := True;
    Label3.Enabled := True;
  end;
end;

procedure TfrmUDPConfig.FormShow(Sender: TObject);
begin
  edtLocalPort.Text := IntToStr(m_nLocalPort);
  edtRemoteAddress.Text := m_strHost;
  edtRemotePort.Text := IntToStr(m_nHostPort);
  CheckgrpCallModel();
  CheckgrpInstallAddress();
  CheckgrpUDPConfig();
end;

class procedure TfrmUDPConfig.init;
var
  ini: TIniFile;
begin
  frmUDPConfig := TfrmUDPConfig.Create(nil);
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  try
    frmUDPConfig.nLocalPort := ini.ReadInteger('UDP','LocalPort',9089);
    frmUDPConfig.nHostPort := ini.ReadInteger('UDP','HostPort',9089);
    frmUDPConfig.strHost := ini.ReadString('UDP','Host','127.0.0.1');
    frmUDPConfig.bInstallAddress := ini.ReadInteger('InstallAddress','Address',0) = 0;
    frmUDPConfig.bCallModel := ini.ReadInteger('CallModel','Model',0) = 0;
    frmUDPConfig.ShowModal;
  finally
    ini.Free;
    frmUDPConfig.Free;
  end;
end;

procedure TfrmUDPConfig.rbNormalCallClick(Sender: TObject);
begin
  if rbNormalCall.Checked then
  begin
    bCallModel := True;
    CheckgrpUDPConfig();
    CheckgrpInstallAddress();
  end
  else
  begin
    bCallModel := False;
    CheckgrpUDPConfig();
    CheckgrpInstallAddress();
  end;
end;

procedure TfrmUDPConfig.rbGongYuClick(Sender: TObject);
begin
  if rbGongYu.Checked then bInstallAddress := True
  else bInstallAddress := False;
  CheckgrpUDPConfig();
end;

procedure TfrmUDPConfig.rbPaiBanShiClick(Sender: TObject);
begin
  if rbPaiBanShi.Checked then bInstallAddress := False
  else bInstallAddress := False;
  CheckgrpUDPConfig();
end;

procedure TfrmUDPConfig.rbRemotCallClick(Sender: TObject);
begin
  if rbRemotCall.Checked then
  begin
    bCallModel := False;
    CheckgrpUDPConfig();
    CheckgrpInstallAddress();
  end
  else
  begin
    bCallModel := True;
    CheckgrpUDPConfig();
    CheckgrpInstallAddress();
  end;
end;

end.
