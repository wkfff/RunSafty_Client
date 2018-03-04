unit ufrmConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, PngImageList, Buttons, PngCustomButton,
  DB, ADODB, ImgList, ActnList, ComCtrls, Mask, RzEdit, RzLabel, uFrmSQLConfig,
  utfSQLConn, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, AdvSpin,uTFSystem, RzDTP, RzButton,
  RzRadChk,uLLCommonFun;

type
  TfrmConfig = class(TForm)
    Panel1: TPanel;
    PageControl: TPageControl;
    tvItemSelect: TTreeView;
    Panel2: TPanel;
    RzPanel4: TRzPanel;
    btnSave: TButton;
    btnCancel: TButton;
    PngImageList1: TPngImageList;
    SQLConfigDialog1: TSQLConfigDialog;
    IdFTP1: TIdFTP;
    tabBaseConfig: TTabSheet;
    RzPanel1: TRzPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    edtSiteNumber: TEdit;
    Label3: TLabel;
    edtWebHost: TEdit;
    chkUseMealTicket: TCheckBox;
    chkUseDelGroup: TCheckBox;
    tsLocalDB: TTabSheet;
    SQLConfigPanelLocal: TSQLConfigPanel;
    btnLocalConfig: TButton;
    RzPanel2: TRzPanel;
    Label4: TLabel;
    lbl1: TLabel;
    edtSendPlanNoticeMin: TAdvSpinEdit;
    lbl2: TLabel;
    tsDLFTP: TTabSheet;
    chkPrintDL: TCheckBox;
    rzpnl1: TRzPanel;
    Label5: TLabel;
    rzpnlDLFTP: TRzPanel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    btnRemoteConTest: TButton;
    edt_RFTP_Host: TEdit;
    edt_RFTP_Port: TEdit;
    edt_RFTP_UserName: TEdit;
    edt_RFTP_Psw: TEdit;
    chkSign: TCheckBox;
    Label6: TLabel;
    dtpShowSignPlanTime: TRzDateTimePicker;
    chkRoomRemind: TCheckBox;
    TabSheet1: TTabSheet;
    RzPanel3: TRzPanel;
    Label7: TLabel;
    chkBWShowTMPic: TRzCheckBox;
    chkBWShowWorkFlow: TRzCheckBox;
    chkUserFinger: TCheckBox;
    chkWorkFlow: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure tvItemSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLocalConfigClick(Sender: TObject);
    procedure chkPrintDLClick(Sender: TObject);
    procedure btnRemoteConTestClick(Sender: TObject);
  private
    { Private declarations }
    procedure Init;
    //检测输入
    function CheckInput : boolean;
    {功能:获取远程FTP配置}
    procedure GetRemoteFTPConfigInput(out rsconfig:RFTPConfig);
    {功能:校验远程FTP配置信息}
    function CheckRemoteFTPConfigInput():Boolean;
    {功能：显示调令FTP配置信息}
    procedure ShowDLFTPConfig();
    {功能：保存调令fTP配置信息}
    procedure SaveDLFTPConfig();
  public
    { Public declarations }
    class function EditConfig() : boolean;
  end;



implementation
uses
  uGlobalDM, uFrmWorkFlowCheck;
{$R *.dfm}

{ TfrmConfig }

procedure TfrmConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmConfig.btnLocalConfigClick(Sender: TObject);
begin
  if not SQLConfigDialog1.Execute(GlobalDM.SQLConfig_Local) then exit;
  SQLConfigPanelLocal.SQLConfig := GlobalDM.SQLConfig_Local;
end;

procedure TfrmConfig.btnRemoteConTestClick(Sender: TObject);
var
  ftpConfig :RFTPConfig;
begin
  if CheckRemoteFTPConfigInput= False then Exit;
  GetRemoteFTPConfigInput(ftpConfig);
  with ftpConfig do
  begin
    IdFTP1.Host := ftpConfig.strHost;
    IdFTP1.Port := ftpConfig.nPort;
    IdFTP1.Username := ftpConfig.strUserName;
    IdFTP1.Password := ftpConfig.strPassWord;
  end;
  try
    IdFTP1.Connect;
    IdFTP1.Disconnect;
    ShowMessage('连接成功!');
  except on e:Exception do
    ShowMessage('连接失败!,原因:' + e.Message);
  end;
end;

procedure TfrmConfig.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then exit;
  GlobalDM.SQLConfig.Save;
  GlobalDM.SQLConfig_Local.save;
  GlobalDM.SiteNumber := edtSiteNumber.Text;
  GlobalDM.WebHost := edtWebHost.Text;
  GlobalDM.UsesMealTicket := chkUseMealTicket.Checked;
  GlobalDM.RoomRemind := chkRoomRemind.Checked;
  GlobalDM.UsesDelGroup := chkUseDelGroup.Checked ;
  GlobalDM.SendPlanNoticeMin := edtSendPlanNoticeMin.Value;
  GlobalDM.UsesOutWorkSign:= chkSign.Checked;
  GlobalDM.ShowSignPlanStartTime := dtpShowSignPlanTime.DateTime;
  GlobalDM.UseFinger := chkUserFinger.Checked;
  TFrmWorkFlowCheck.WorkFlowEnable := chkWorkFlow.Checked;

  WriteIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowTMPic',chkBWShowTMPic.Checked);

  WriteIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowWorkFlow', chkBWShowWorkFlow.Checked);
  
  SaveDLFTPConfig;
  ModalResult := mrOk;
end;

function TfrmConfig.CheckInput: boolean;
begin
  result := true;
end;

function TfrmConfig.CheckRemoteFTPConfigInput: Boolean;
begin
  result := False;
  if Trim(edt_RFTP_Host.Text) = '' then
  begin
    ShowMessage('地址不能为空!');
    edt_RFTP_Host.SetFocus;
    Exit;
  end;
  if Trim(edt_RFTP_Port.Text) = '' then
  begin
    ShowMessage('端口不能为空!');
    edt_RFTP_Port.SetFocus;
    Exit;
  end;
  if Trim(edt_RFTP_UserName.Text) ='' then
  begin
    ShowMessage('用户名称不能为空!');
    edt_RFTP_UserName.SetFocus;
    Exit;
  end;
  Result := True;

end;

procedure TfrmConfig.chkPrintDLClick(Sender: TObject);
begin
  rzpnlDLFTP.Enabled := chkPrintDL.Checked;
end;

class function TfrmConfig.EditConfig: boolean;
var
  frmConfig : TfrmConfig;
begin
  result := false;
  frmConfig := TfrmConfig.Create(nil);
  try
    frmConfig.Init;
    if frmConfig.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmConfig.Free;
  end;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;

procedure TfrmConfig.GetRemoteFTPConfigInput(out rsconfig: RFTPConfig);
var
  strTemp:string;
begin
  rsconfig.strHost := Trim(edt_RFTP_Host.Text);
  strTemp := Trim(edt_RFTP_Port.Text);
  if TryStrToInt(strTemp,rsconfig.nPort) = False then
    rsconfig.nPort := 21;
  rsconfig.strUserName := Trim(edt_RFTP_UserName.Text);
  rsconfig.strPassWord := Trim(edt_RFTP_Psw.Text);
end;

procedure TfrmConfig.Init;
begin
  //数据库连接信息
  SQLConfigPanelLocal.SQLConfig := GlobalDM.SQLConfig_Local;
  edtSiteNumber.Text := GlobalDM.SiteNumber;
  edtWebHost.Text := GlobalDM.WebHost ;
  chkUseMealTicket.Checked := GlobalDM.UsesMealTicket;
  chkUseDelGroup.Checked := GlobalDM.UsesDelGroup ;
  edtSendPlanNoticeMin.Value := GlobalDM.SendPlanNoticeMin;
  chkRoomRemind.Checked := GlobalDM.RoomRemind;
  
  chkSign.Checked := GlobalDM.UsesOutWorkSign;
  dtpShowSignPlanTime.DateTime := GlobalDM.ShowSignPlanStartTime;

  chkBWShowTMPic.Checked := ReadIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowTMPic',True);

  chkBWShowWorkFlow.Checked := ReadIniFileBoolean(GlobalDM.AppPath + 'Config.ini','UserData','BWShowWorkFlow', True);
   ShowDLFTPConfig();

  chkUserFinger.Checked := GlobalDM.UseFinger;

  chkWorkFlow.Checked := TFrmWorkFlowCheck.WorkFlowEnable;
end;

procedure TfrmConfig.SaveDLFTPConfig;
var
  ftpConfig :RFTPConfig;
begin
  GlobalDM.UsesPrintDL := chkPrintDL.Checked;
  GetRemoteFTPConfigInput(ftpConfig);
  GlobalDM.DLFTPConfig := ftpConfig;

end;

procedure TfrmConfig.ShowDLFTPConfig;
var
  ftpConfig :RFTPConfig;
begin
  chkPrintDL.Checked := GlobalDM.UsesPrintDL;
  ftpConfig := GlobalDM.DLFTPConfig;
  edt_RFTP_Host.Text := ftpConfig.strHost;
  edt_RFTP_Port.Text := IntToStr(ftpConfig.nPort);
  edt_RFTP_UserName.Text := ftpConfig.strUserName;
  edt_RFTP_Psw.Text := ftpConfig.strPassWord;
  rzpnlDLFTP.Enabled := chkPrintDL.Checked
end;

procedure TfrmConfig.tvItemSelectClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := tvItemSelect.Selected.Index;
end;

end.
