unit uFrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList,uDutyUser, RzPanel, jpeg, pngimage,
  Buttons, PngSpeedButton, Mask, RzEdit, RzStatus,uTFSystem,
  PngCustomButton,uGlobalDM, Menus, RzButton,  uTrainman,
  uConnAccess, uApparatusCommon, RzCommon, RzPrgres,
  uClientAppInfo,uLCDutyPlace,uLCDutyUser,uLCBaseDict;

type
    //登录窗体配置信息
  RLoginFrmUI = record
    //LOGO图标路径
    ImgLogo : string;
    //系统中文名称
    SysCaptionCHN : string;
    //系统英文名称
    SysCaptionEN : string;
    //主界面背景图片路径
    ImgBodyBG : string;
    //标题背景图片路径
    ImgTitleBG : string;
    //用户登录背景
    ImgUserBG : string;
  end;
  TfrmLogin = class(TForm)
    RzPanel1: TRzPanel;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    RzVersionInfo1: TRzVersionInfo;
    imgBodyBG: TImage;
    RzPanel2: TRzPanel;
    imgTitleBG: TImage;
    lblCaptionCHN: TLabel;
    lblCaptionEN: TLabel;
    btnDBConfig: TPngCustomButton;
    LblBrief: TLabel;
    lblVersion: TLabel;
    btnDrinkTest: TPngCustomButton;
    imgLogo: TImage;
    ProgressBar: TRzProgressBar;
    edtDutyNumber: TRzEdit;
    lblDutyNumber: TLabel;
    Label2: TLabel;
    edtDutyPWD: TRzEdit;
    btnLogin: TPngCustomButton;
    btnCancel: TPngCustomButton;
    imgUserBG: TImage;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDBConfigClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure imgTitleBGMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTitleBGMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgTitleBGMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnDrinkTestClick(Sender: TObject);
  private
    { Private declarations }

    m_InOffLine: Boolean;
    //登录用户信息操作类
    m_RsLCDutyPlace: TRsLCDutyPlace;
    m_RsLCDutyUser: TRsLCDutyUser;
    //拖动点
    m_ptDragStart : TPoint;
    //本地数据库连接对象
    m_dbConnAccess: TConnAccess;
    //初始化窗体显示
    procedure InitUI;
    //禁用窗体控件
    procedure DisableForm;
    //启用窗体控件
    procedure EnableForm;
    //检测输入合法性
    function CheckInput : boolean;

    procedure LoadCustomUI(var UIconfig : RLoginFrmUI);
  public
    { Public declarations }
     //初始化自定义界面
    procedure InitCustomUI;
    property InOffLine: Boolean read m_InOffLine;
    class procedure Login();
  end;

var
  frmLogin: TfrmLogin;

implementation
uses
  uSite,uFrmConfig, ufrmTextInput, utfPopBox, ufrmTestDrinking, uFrmLocalDrink;
{$R *.dfm}


procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  errorMsg : string;
  localIP : string;
begin
  if Trim(edtDutyNumber.Text) = '' then
  begin
    Box('请输入值班员工号');
    edtDutyNumber.SetFocus;
    exit;
  end;
  DisableForm;
  try
    LblBrief.Visible := true;
    {$region '加载本地配置文件'}
    LblBrief.Caption := '正在加载本地配置文件...';
    Application.ProcessMessages;
    GlobalDM.LoadConfig;
    {$endregion '加载本地配置文件'}


    {$region '验证值班员账户'}
    errorMsg := '';
    LblBrief.Caption := '正在验证值班员账户信息...';
    Application.ProcessMessages;
    if GlobalDM.DutyUser <> nil then
      FreeAndNil(GlobalDM.DutyUser);    
    GlobalDM.DutyUser := TRsDutyUser.Create;
    if not m_RsLCDutyUser.GetDutyUserByNumber(Trim(edtDutyNumber.Text),GlobalDM.DutyUser) then
    begin
      Box(Format('验证登录信息错误，错误信息：%s',['不存在此值班员工号']));
      exit;
    end;
    if GlobalDM.DutyUser.strPassword <> Trim(edtDutyPWD.Text) then
    begin
      Box(Format('验证登录信息错误，错误信息：%s',['密码错误']));
      exit;
    end;
    
    LblBrief.Caption := '验证值班员账户信息成功...';
    Application.ProcessMessages;
    {$endregion '验证值班员账户'}

    localIP := GlobalDM.SiteNumber;
    GlobalDM.SiteNumberMem :=   localIP ;
    //if not GetLocalIP(localIP) then exit;

    {$region '获取客户端岗位信息'}
    LblBrief.Caption := '正在获取客户端岗位信息...';
    Application.ProcessMessages;
    if GlobalDM.SiteInfo <> nil then
      FreeAndNil(GlobalDM.SiteInfo);
    GlobalDM.SiteInfo := TRsSiteInfo.Create;
    try


      if not RsLCBaseDict.LCSite.GetSiteByIP(localIP,GlobalDM.SiteInfo) then
      begin
        Box(Format('该客户端没有在服务器上注册',[]));
        exit;
      end;

    except on e : exception do
      begin
        Box('登录失败：' + e.Message);
        exit;
      end;
    end;
    
    LblBrief.Caption := '获取客户端岗位信息成功...';
    Application.ProcessMessages;


    GlobalDM.LoadSiteConfig();
    GlobalDM.LoadDB_Config();

    LblBrief.Caption := '获取出勤点信息...';

    m_RsLCDutyPlace.GetSiteDutyPlace(GlobalDM.SiteInfo.strSiteGUID,GlobalDM.DutyPlace);


    {$ENDREGION} ;
    //
    GlobalDM.LogUserInfo.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID;
    GlobalDM.LogUserInfo.strDutyUserName := GlobalDM.DutyUser.strDutyName;
    GlobalDM.LogUserInfo.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID;
    GlobalDM.LogUserInfo.strSiteName := GlobalDM.SiteInfo.strSiteName ;
    GlobalDM.LogUserInfo.strWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID ;
    GlobalDM.LogUserInfo.strDutyNumber := GlobalDM.DutyUser.strDutyNumber ;

    lblBrief.Caption := '登录成功';
    ModalResult := mrOk;
  finally
    LblBrief.Visible := false;
    EnableForm;
    if not edtDutyNumber.Focused then
      edtDutyNumber.SetFocus;
  end;
end;



function TfrmLogin.CheckInput: boolean;
begin
  result := false;
  if Trim(edtDutyNumber.Text) = '' then
  begin
    Box('请输入值班员工号');
    exit;
  end;
  result := true;
end;

procedure TfrmLogin.DisableForm;
begin
  btnLogin.Enabled := false;
  btnCancel.Enabled := false;
  edtDutyNumber.Enabled := false;
  edtDutyPWD.Enabled := false;
end;

procedure TfrmLogin.EnableForm;
begin
  btnLogin.Enabled := true;
  btnCancel.Enabled := true;
  edtDutyNumber.Enabled := true;
  edtDutyPWD.Enabled := true;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  m_RsLCDutyUser := TRsLCDutyUser.Create(GlobalDM.WebAPIUtils);
  m_dbConnAccess := TConnAccess.Create(Application);
  m_RsLCDutyPlace := TRsLCDutyPlace.Create('','','');
  m_RsLCDutyPlace.SetConnConfig(GlobalDM.HttpConnConfig);

  LblBrief.Visible := false;
  RzPanel1.DoubleBuffered := true;
  InitUI;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  m_dbConnAccess.Free;
  m_RsLCDutyUser.Free;
  m_RsLCDutyPlace.Free;
end;

procedure TfrmLogin.imgTitleBGMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  m_ptDragStart := ClientToScreen(Point(X,Y))
end;

procedure TfrmLogin.imgTitleBGMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  pt : TPoint;
begin
  if (m_ptDragStart.X > 0) then
  begin
    pt := ClientToScreen(Point(X,Y));
    Left := Left + pt.X - m_ptDragStart.X;
    Top := Top + pt.Y - m_ptDragStart.Y;
    m_ptDragStart := pt;
  end;
end;

procedure TfrmLogin.imgTitleBGMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  m_ptDragStart := Point(-1,-1);
end;

procedure TfrmLogin.InitCustomUI;
var
  uiconfig : RLoginFrmUI;
  exePath : string;
begin
  exePath := GlobalDM.AppPath;
  LoadCustomUI(uiconfig);
  //70*70
  if (FileExists(exePath + uiconfig.ImgLogo)) then
  begin
    imgLogo.Picture.LoadFromFile(exePath + uiconfig.ImgLogo);
  end;
  //693*343
  if (FileExists(exePath + uiconfig.ImgBodyBG)) then
  begin
    imgBodyBG.Picture.LoadFromFile(exePath + uiconfig.imgBodyBG);
  end;
  //693*71
  if (FileExists(exePath + uiconfig.ImgTitleBG)) then
  begin
    ImgTitleBG.Picture.LoadFromFile(exePath + uiconfig.ImgTitleBG);
  end;

  if (FileExists(exePath + uiconfig.ImgUserBG)) then
  begin
    ImgUserBG.Picture.LoadFromFile(exePath + uiconfig.ImgUserBG);
  end;
  if Trim(uiconfig.SysCaptionCHN) <> '' then
  begin
    lblCaptionCHN.Caption := uiconfig.SysCaptionCHN;
  end;

  if Trim(uiconfig.SysCaptionEN) <> '' then
  begin
    lblCaptionEN.Caption := uiconfig.SysCaptionEN;
  end;  
end;

procedure TfrmLogin.InitUI;
begin
  lblVersion.Caption := '版本：' + RzVersionInfo1.FileVersion;
end;

procedure TfrmLogin.LoadCustomUI(var UIconfig: RLoginFrmUI);
var
  strConfigPath : string;
begin
  strConfigPath := GlobalDM.AppPath + 'user\UI.ini';
  uiconfig.ImgLogo := ReadIniFile(strConfigPath,'LoginForm','ImgLoco');
  uiconfig.SysCaptionCHN := ReadIniFile(strConfigPath,'LoginForm','SysCaptionCHN');
  uiconfig.SysCaptionEN := ReadIniFile(strConfigPath,'LoginForm','SysCaptionEN');
  uiconfig.ImgBodyBG := ReadIniFile(strConfigPath,'LoginForm','ImgBodyBG');
  uiconfig.ImgTitleBG := ReadIniFile(strConfigPath,'LoginForm','ImgTitleBG');
  uiconfig.ImgUserBG := ReadIniFile(strConfigPath,'LoginForm','ImgUserBG');
end;

class procedure TfrmLogin.Login;
var
  frmLogin:TfrmLogin;
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.InitCustomUI;
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;


procedure TfrmLogin.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmLogin.actEnterExecute(Sender: TObject);
begin
  if edtDutyNumber.Focused then
  begin
    if not CheckInput then exit;
    edtDutyPWD.SetFocus;
    exit;
  end;
  if edtDutyPWD.Focused then
  begin
    btnLogin.Click;
  end;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnDBConfigClick(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TfrmLogin.btnDrinkTestClick(Sender: TObject);
begin
  if Trim(edtDutyNumber.Text) = '' then
  begin
    Box('请输入值班员工号');
    edtDutyNumber.SetFocus;
    exit;
  end;
  if GlobalDM.DutyUser <> nil then
    FreeAndNil(GlobalDM.DutyUser);
  GlobalDM.DutyUser := TRsDutyUser.Create;
  GlobalDM.DutyUser.strDutyNumber := Trim(edtDutyNumber.Text);
  m_InOffLine := True;
  ModalResult := mrOk;
end;


end.
