unit uCardControlerBase;

interface

uses
  Classes,Windows,uWinCtrlAPIController,ShellApi,Messages,uProcedureControl,
  SysUtils,Forms,uTFSystem,uWriteICCarSoftDefined;


Const

  {$region '管理员登录定义'}
  //登录窗体标题
  LoginForm_Title = '口令输入';
  //登录窗体执行快捷键
  LoginForm_ShortCut = VK_F2;
  //登录窗体中密码框序号
  LoginForm_PasswordOffset = 2;
  //登录窗体中按钮序号
  LoginForm_ConfirmOffset = 1;
  {$endregion}

  {$region '值班员登录'}
  AttendantLoginShortCut = VK_F1;
  AttendantLoginForm_Title = '值班员登录';
  AttendantLoginForm_ClassName = 'Tw_zby';

  {值班员工号输入框查找序号}
  AttendantNumberEditNO = 4;
  {值班员密码输入框查找序号}
  AttendantPassWordEditNO = 1;
  {确认按钮查找序号}
  btnConfirmNO = 2;
  {$ENDREGION}

  CardForm_Title = '乘务员出勤管理';

type

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TCardContorler
  /// 功能:写卡软件调用控制器基类
  //////////////////////////////////////////////////////////////////////////////
  TCardContorler = class
  public
    constructor Create();virtual;
    function WriteCard():Boolean;virtual;abstract;
    {功能:准备写卡}
    procedure ReadyWrite();virtual;abstract;
    function UpdateJieShi():Boolean;virtual; abstract;
  public
    {功能:获得出勤信息}
    function GetKDXKWriteICCarDutyInfo():RWriteICCarDutyInfo;
    {功能:直接获得写卡窗口句柄}
    function GetWriteICCarHWND():HWND;virtual;abstract;
  protected
    {揭示文件位置}
    m_JSFileName : string;
    {写卡软件位置}
    m_SoftFileName : string;
    {最后一次错误信息}
    m_strLastError : String;
    {写卡参数结构体}
    m_WriteICCarParam : RWriteICCarParam;
    {写卡软件的各种窗口句柄}
    m_SoftHandles : RSoftHandles;
    {写卡状态通知事件}
    m_OnStateNotice : TOnStateNotice;
  protected
    {写卡窗口控件查找序号}
    m_WriteICCarChildOrders : RWriteICCarWindowChildOrders;
  protected
    {功能:打开写卡软件}
    function RunWriteICCarProgram():Boolean;
    {功能:关闭写卡软件}
    procedure CloseWriteICCarProgram();
    {功能:初始化写卡窗口控件查找序号}
    procedure InitWriteICCarWindowControlNos();virtual;abstract;
    {功能:管理员登陆}
    function AdminLogin():Boolean;
    {功能:值班员登录}
    function AttendantLogin():Boolean;
    {功能:打开跨段写卡的写卡窗口}
    function OpenKDXKWriteCardFrm():Boolean;
    {功能:打开IC卡管理的写卡窗口}
    function OpenICKGLWriteCardFrm():Boolean;
  protected
    {功能:设置值班员工号}
    function SetAttendantNumber():Boolean;
    {功能:设置值班员密码}
    function SetAttendantPassWord():Boolean;
    {功能:值班员确认登录}
    function SetAttendantConfirmLoging():Boolean;
    {功能:设置机务段}
    function SetJWD():Boolean;virtual;
    {功能:获取机务段信息}
    procedure GetJWD(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置区段}
    function SetQuDuan():Boolean;virtual;
    {功能:获得区段信息}
    procedure GetQuDuan(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置客货}
    function SetKeHuo():Boolean;virtual;
    {功能:获取客货信息}
    procedure GetKeHuo(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置车次头}
    function SetCheCiTou():Boolean;virtual;
    {功能:获取车次头}
    procedure GetCheCiTou(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置车次号}
    function SetCheCiNumber():Boolean;virtual;
    {功能:获取车次号}
    procedure GetCheCiNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置司机号}
    function SetTrainmanNumber():Boolean;virtual;
    {功能:获取司机号}
    procedure GetTrainmanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置副司机号}
    function SetSubTrainmanNumber():Boolean;virtual;
    {功能:获取副司机号}
    procedure GetSubTrainmanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置交路号}
    function SetJiaoLuNumber():Boolean;virtual;
    {功能:获取交路号}
    procedure GetJiaoLuNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:设置车站号}
    function SetCheZhanNumber():Boolean;virtual;
    {功能:获取车站号}
    procedure GetCheZhanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {功能:提交写卡}
    function SubmitWriteICCard():Boolean;
  protected
    {功能:界面刷新Sleep函数}
    procedure RefSleep(nTimeCount : Integer);
    {功能:状态通知}
    procedure StateNotice(strCommand:String);
  public
    {功能:设置写卡窗口句柄}
    procedure SetWriteCardFormHandle(Hwd:HWND);
    {功能:设置跨段写卡出勤信息}
    function SetKDXKDutyInfo():Boolean;
    {功能:设置IC卡管理出勤信息}
    function SetICKGLDutyInfo():Boolean;
  public
    {登录信息}
    LoginInfo : RLoginInfo;
    {写卡出勤信息}
    WriteICCarDutyInfo : RWriteICCarDutyInfo;
    property LastError : String read m_strLastError;
    property JSFileName:string read m_JSFileName write m_JSFileName;
    property SoftFileName:string read m_SoftFileName write m_SoftFileName;
    property WriteICCarParam : RWriteICCarParam Read m_WriteICCarParam
        write m_WriteICCarParam;
    property OnStateNotice : TOnStateNotice
        read m_OnStateNotice write m_OnStateNotice;
  end;


implementation

{ TCardContorler }

function TCardContorler.AdminLogin: Boolean;
{功能:管理员登陆}
var
  ControlHWND : HWND;
  nTickCount : int64;
begin
  Result := False;

  PostMessage(m_SoftHandles.MainFormHandle,WM_KEYDOWN,VK_F2,0);

  m_SoftHandles.AdminFormHandle := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeout,
      LoginForm_Title,'');

  if m_SoftHandles.AdminFormHandle = 0 then
  begin
    m_strLastError := '无法打开管理员登陆窗口!';
    Exit;
  end;

  RefSleep(1000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
      m_SoftHandles.AdminFormHandle,
      LoginForm_PasswordOffset);

  TWinCtrlAPIController.SetEditText(ControlHWND,LoginInfo.AdminPassword);

  RefSleep(1000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
      m_SoftHandles.AdminFormHandle,
      LoginForm_ConfirmOffset);

  TWinCtrlAPIController.ClickButton(ControlHWND);

  nTickCount := GetTickCount;
  
  while(((GetTickCount - nTickCount) < m_WriteICCarParam.WaitTimeout) and
   (TWinCtrlAPIController.GetFormHandle(LoginForm_Title) <> 0))do
  begin
     Sleep(100);
     TWinCtrlAPIController.ClickButton(ControlHWND);
  end;

  if TWinCtrlAPIController.GetFormHandle(LoginForm_Title) <> 0 then
  begin
    m_strLastError := '管理员登录失败!';
    Exit;
  end;

  Result := True;
end;

function TCardContorler.AttendantLogin: Boolean;
{功能：值班员登录}
begin
  Result := False;

  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyDown,AttendantLoginShortCut,0);
  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyUP,AttendantLoginShortCut,0);

  m_SoftHandles.AttendantFormHandle :=
      TWinCtrlAPIController.WaitWindowRun(m_WriteICCarParam.WaitTimeout,
      AttendantLoginForm_Title,AttendantLoginForm_ClassName);

  if m_SoftHandles.AttendantFormHandle = 0 then
  begin
    m_strLastError := '无法打开值班员登录窗口!';
    Exit;
  end;
  Sleep(1000);
  if SetAttendantNumber() = False then Exit;
  Sleep(500);
  if SetAttendantPassWord() = False then Exit;
  Sleep(500);
  if SetAttendantConfirmLoging() = False then Exit;
  Sleep(500);
  Result := True;
end;

procedure TCardContorler.CloseWriteICCarProgram;
{功能:关闭写卡软件}
var
  i : Integer;
begin
  /////////////////////////////////////////////////////////////////////////////
  ///  对主窗口发送关闭消息
  /////////////////////////////////////////////////////////////////////////////
  PostMessage(m_SoftHandles.MainFormHandle,WM_CLOSE,0,0);
  /////////////////////////////////////////////////////////////////////////////
  ///  等待主窗口句柄消失,程序退出,超过3秒的话直接关闭进程
  /////////////////////////////////////////////////////////////////////////////
  for I := 0 to 300 do
  begin
    m_SoftHandles.MainFormHandle :=
        TWinCtrlAPIController.GetFormHandleEx(m_WriteICCarParam.MainFormTitle);

    if m_SoftHandles.MainFormHandle = 0 then Break;
    Sleep(10);
  end;
  if m_SoftHandles.MainFormHandle <> 0 then
    CloseAllProcedure(m_SoftFileName);
end;

constructor TCardContorler.Create;
begin
  InitWriteICCarWindowControlNos();
  m_WriteICCarParam.WaitRunWriteICCarProgramTimeOut := 30000;
  m_WriteICCarParam.WaitTimeOut := 20000;
  m_SoftHandles.MainFormHandle := 0;
  m_SoftHandles.WriteCardFormHandle := 0;
  m_SoftHandles.AttendantFormHandle := 0;
  WriteICCarDutyInfo.KeHuo := khHuoChe;
  LoginInfo.AdminPassword :='';
  LoginInfo.OndutyPersonID :='1';
  LoginInfo.OndutyPersonPWD :='';
end;

procedure TCardContorler.GetCheCiNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取车次号}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheCiNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到车次号控件!';
    Exit;
  end;

  WriteICCarDutyInfo.CheCiNumber :=
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetCheCiTou(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取车次头}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheCiTou_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到车次头编辑框!';
    Exit;
  end;

  WriteICCarDutyInfo.CheCiTou :=
    TWinCtrlAPIController.GetEditText(ControlHWND);

end;

procedure TCardContorler.GetCheZhanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取车站号}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到车站号控件!';
    Exit;
  end;

  WriteICCarDutyInfo.CheZhanHao :=
      TWinCtrlAPIController.GetEditText(ControlHWND)
      
end;

procedure TCardContorler.GetJiaoLuNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取交路号}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到交路号控件!';
    Exit;
  end;

  WriteICCarDutyInfo.JiaoLuHao :=
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetJWD(var WriteICCarDutyInfo: RWriteICCarDutyInfo);
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxJWD_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到所属段别控件!';
    Exit;
  end;

  WriteICCarDutyInfo.DName := TWinCtrlAPIController.GetEditText(ControlHWND);
end;

function TCardContorler.GetKDXKWriteICCarDutyInfo: RWriteICCarDutyInfo;
{功能:获得出勤信息}
begin
  //获取机务段
  GetJWD(Result);
  //获取区段
  GetQuDuan(Result);
  //获取客货
  GetKeHuo(Result);
  //获取车次头
  GetCheCiTou(Result);
  //设置车次号
  GetCheCiNumber(Result);
  //设置司机号
  GetTrainmanNumber(Result);
  //设置副司机号
  GetSubTrainmanNumber(Result);
  //设置交路号
  GetJiaoLuNumber(Result);
  //设置车站号
  GetCheZhanNumber(Result);
end;

procedure TCardContorler.GetKeHuo(var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取客货信息}
var
  ControlHWND : HWND;
begin
  //检查是否为货车
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbHuoChe_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khHuoChe;

  //检查是否为客车
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbKeChe_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khKeChe;

  //检查是否为客货
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbKeHuo_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khKeHuo;

end;

procedure TCardContorler.GetQuDuan(var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获得区段信息}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxQuDuan_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到运用区段控件!';
    Exit;
  end;

  WriteICCarDutyInfo.QuDuan := TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetSubTrainmanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取副司机号}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到副司机号控件!';
    Exit;
  end;
  
  WriteICCarDutyInfo.SubTrainmanNumber :=
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetTrainmanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{功能:获取司机号}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到司机号控件!';
    Exit;
  end;
  WriteICCarDutyInfo.TrainmanNumber := 
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

function TCardContorler.OpenICKGLWriteCardFrm: Boolean;
{功能:打开IC卡管理的写卡窗口}
var
  ChildHWND : HWND;
  ChildOrders : TIntArray;
begin
  Result := False;
  SetIntArray(ChildOrders,[2,3,0]);
  ChildHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.MainFormHandle,ChildOrders);

  if ChildHWND = 0 then
  begin
    m_strLastError := '无法找到出勤信息按钮!';
    exit;
  end;
  TWinCtrlAPIController.ClickButton(ChildHWND);
  m_SoftHandles.WriteCardFormHandle :=
      TWinCtrlAPIController.WaitWindowRun(5000,'出勤信息','');
  if m_SoftHandles.WriteCardFormHandle = 0 then
  begin
    m_strLastError := '无法打开出勤信息窗口!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.OpenKDXKWriteCardFrm: Boolean;
{功能：打开写卡窗口}
begin
  Result := False;

  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyDown,VK_F5,0);
  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyUP,VK_F5,0);

  m_SoftHandles.WriteCardFormHandle :=
      TWinCtrlAPIController.WaitWindowRunEx(m_WriteICCarParam.WaitTimeOut,
        CardForm_Title);

  if m_SoftHandles.WriteCardFormHandle = 0 then
  begin
    m_strLastError := '等待写卡窗口超时!';
    Exit;
  end;

  Result := True;

end;

procedure TCardContorler.RefSleep(nTimeCount: Integer);
{功能:界面刷新Sleep函数}
var
  i : Integer;
begin
  if nTimeCount <= 1000 then
  begin
    Sleep(nTimeCount);
    Exit;
  end;
  for I := 0 to nTimeCount div 100 do
  begin
    Sleep(100);
    Application.ProcessMessages; 
  end;
end;

function TCardContorler.RunWriteICCarProgram: Boolean;
{功能:打开写卡软件}
begin
  Result := False;

  if FileExists(m_SoftFileName) = False then
  begin
    m_strLastError := '写卡软件不存在!';
    Exit;
  end;

  //如果程序已经启动,那么首先关闭,然后再打开
  m_SoftHandles.MainFormHandle :=
      TWinCtrlAPIController.GetFormHandleEx(m_WriteICCarParam.MainFormTitle);

  if m_SoftHandles.MainFormHandle <> 0 then
    CloseWriteICCarProgram();

  if ShellExecute(0,'Open',PChar(m_SoftFileName),nil,nil,SW_SHOWNORMAl) <= 32 then
  begin
    m_strLastError := '启动写卡软件失败!';
    Exit;
  end;

  m_SoftHandles.MainFormHandle :=
      TWinCtrlAPIController.WaitWindowRunEx(
          m_WriteICCarParam.WaitRunWriteICCarProgramTimeOut,
          m_WriteICCarParam.MainFormTitle);

  if m_SoftHandles.MainFormHandle = 0 then
  begin
    m_strLastError := '启动写卡软件失败!';
    Exit;
  end;

  Result := True;
end;



function TCardContorler.SetAttendantConfirmLoging: Boolean;
{功能:值班员确认登录}
var
  nTickCount : int64;
  ControlHWND : HWND;
begin
  Result := False;
  
  ControlHWND :=
      TWinCtrlAPIController.GetChildControlHandle(
      m_SoftHandles.AttendantFormHandle,btnConfirmNO);

  TWinCtrlAPIController.ClickButton(ControlHWND);

  nTickCount := GetTickCount;
  while((TWinCtrlAPIController.GetFormHandle(AttendantLoginForm_ClassName,
      AttendantLoginForm_Title) <> 0)
      and (GetTickCount - nTickCount < 2000)) do
  begin
    Sleep(100);
  end;

  if TWinCtrlAPIController.GetFormHandle(AttendantLoginForm_ClassName,
      AttendantLoginForm_Title) <> 0 then
  begin
    m_strLastError := '值班员登录失败!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.SetAttendantNumber: Boolean;
{功能:设置值班员工号}
var
  ControlHWND : HWND;
begin
  Result := False;
  if LoginInfo.OndutyPersonID <> '' then
  begin
    ControlHWND :=
        TWinCtrlAPIController.GetChildControlHandle(
        m_SoftHandles.AttendantFormHandle,
        AttendantNumberEditNO);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到值班员工号输入框!';
      Exit;
    end;
    
    TWinCtrlAPIController.SetEditText(ControlHWND,LoginInfo.OndutyPersonID);
  end;
  Result := True;
end;

function TCardContorler.SetAttendantPassWord: Boolean;
{功能:设置值班员密码}
var
  ControlHWND : HWND;
begin
  Result := False;
  if LoginInfo.OndutyPersonPWD <> '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
        m_SoftHandles.AttendantFormHandle,AttendantPassWordEditNO);
    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到值班员密码输入框!';
      Exit;
    end;
    TWinCtrlAPIController.SetEditText(ControlHWND,LoginInfo.OndutyPersonPWD);
  end;
  Result := True;
end;

procedure TCardContorler.StateNotice(strCommand: String);
{功能:状态通知}
begin
  if Assigned(m_OnStateNotice) then
    m_OnStateNotice(strCommand);
end;

function TCardContorler.SubmitWriteICCard: Boolean;
{功能：提交写卡}
var
  ChildHandle : HWND;
begin
  Result := False;
  ChildHandle := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.btnWriteICCar_TabOrders);
  if ChildHandle = 0 then
  begin
    m_strLastError := '无法找打写卡按钮!';
    Exit;
  end;
  //执行写卡
  TWinCtrlAPIController.ClickButton(ChildHandle);
  Result := True;
end;

function TCardContorler.SetCheCiNumber: Boolean;
{功能:设置车次号}
var
  ControlHWND : HWND;
begin
  Result := False;

  if WriteICCarDutyInfo.CheCiNumber <> '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.edtCheCiNumber_TabOrders);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到车次号控件!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        WriteICCarDutyInfo.CheCiNumber) = False then
    begin
      m_strLastError := '车次号填写失败!';
      Exit;
    end;
  end;

  Result := True;
end;

function TCardContorler.SetCheCiTou: Boolean;
{功能:设置车次}
var
  ControlHWND : HWND;
begin
  Result := False;
  if WriteICCarDutyInfo.CheCiTou = '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.edtCheCiTou_TabOrders);
    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到车次头编辑框!';
      Exit;
    end;
    TWinCtrlAPIController.SetEditText(ControlHWND,WriteICCarDutyInfo.CheCiTou);
  end
  else
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.cbxCheCiTou_TabOrders);
    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到车次头下拉框!';
      Exit;
    end;
    if TWinCtrlAPIController.SetComboSelect(ControlHWND,
        WriteICCarDutyInfo.CheCiTou) = False then
    begin
      m_strLastError := '无法设置车次头('+WriteICCarDutyInfo.CheCiTou+')';
      Exit;
    end;
  end;
  Result := True;
end;

function TCardContorler.SetCheZhanNumber: Boolean;
{功能:设置车站号}
var
  ControlHWND : HWND;
begin
  Result := False;
  if WriteICCarDutyInfo.CheZhanHao <> '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到车站号控件!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        PChar(WriteICCarDutyInfo.CheZhanHao)) = False then
    begin
      m_strLastError := '设置车站号('+WriteICCarDutyInfo.CheZhanHao+')失败!';
      Exit;
    end;
    
  end;
  Result := True;
end;

function TCardContorler.SetICKGLDutyInfo: Boolean;
{功能:设置IC卡管理出勤信息}
begin
  Result := False;
  
  //设置客货
  if SetKeHuo() = False then Exit;
  RefSleep(300);

  {设置车次头}
  if SetCheCiTou() = False then Exit;
  RefSleep(300);

  {设置车次号}
  if SetCheCiNumber() = False then Exit;
  RefSleep(300);

  {设置司机号}
  if SetTrainmanNumber() = False then Exit;
  RefSleep(300);

  {设置副司机号}
  if SetSubTrainmanNumber() = False then Exit;
  RefSleep(300);

  {设置交路号}
  if SetJiaoLuNumber() = False then Exit;
  RefSleep(300);

  {设置车站号}
  if SetCheZhanNumber() = False then Exit;
  RefSleep(300);

  Result := True;
end;

function TCardContorler.SetKDXKDutyInfo: Boolean;
{功能：填写出勤信息}
begin
  Result := False;

  RefSleep(1000);

  //设置机务段
  if SetJWD() = False then Exit;
  RefSleep(1000);

  //设置运用区段
  if SetQuDuan = False then Exit;
  RefSleep(1000);

  //设置客货
  if SetKeHuo() = False then Exit;
  RefSleep(300);

  {设置车次头}
  if SetCheCiTou() = False then Exit;
  RefSleep(300);

  {设置车次号}
  if SetCheCiNumber() = False then Exit;
  RefSleep(300);

  {设置司机号}
  if SetTrainmanNumber() = False then Exit;
  RefSleep(300);

  {设置副司机号}
  if SetSubTrainmanNumber() = False then Exit;
  RefSleep(300);

  {设置交路号}
  if SetJiaoLuNumber() = False then Exit;
  RefSleep(300);

  {设置车站号}
  if SetCheZhanNumber() = False then Exit;
  RefSleep(300);

  Result := True;

end;

function TCardContorler.SetJiaoLuNumber: Boolean;
{功能:设置交路号}
var
  ControlHWND : HWND;
begin
  Result := False;
  if WriteICCarDutyInfo.JiaoLuHao <> '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法找到交路号控件!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        PChar(WriteICCarDutyInfo.JiaoLuHao)) = False then
    begin
      m_strLastError := '设置交路号('+WriteICCarDutyInfo.JiaoLuHao+')失败!';
      Exit;
    end;
    
  end;
  Result := True;
end;

function TCardContorler.SetJWD: Boolean;
var
  ControlHWND : HWND;
  FormHWND : HWND;
begin
  Result := False;

  if WriteICCarDutyInfo.DName = '' then
  begin
    Result := True;
    Exit;
  end;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxJWD_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到所属段别控件!';
    Exit;
  end;

  TWinCtrlAPIController.SetComboSelect(ControlHWND,WriteICCarDutyInfo.DName);

  RefSleep(2000);

  FormHWND := TWinCtrlAPIController.GetFormHandle('段别选择');

  if FormHWND <> 0 then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,0);
    TWinCtrlAPIController.ClickButton(ControlHWND);
  end;

  RefSleep(2000);

  Result := True;
end;

function TCardContorler.SetKeHuo: Boolean;
{功能:设置客货}
var
  ControlHWND : HWND;
  ControlNos : TIntArray;
begin
  Result := False;
  case WriteICCarDutyInfo.KeHuo of
    khHuoChe: ControlNos := m_WriteICCarChildOrders.rbHuoChe_TabOrders;
    khKeChe: ControlNos := m_WriteICCarChildOrders.rbKeChe_TabOrders;
    khKeHuo: ControlNos := m_WriteICCarChildOrders.rbKeHuo_TabOrders;
  end;
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,ControlNos);

  if (ControlHWND = 0) then
  begin
    m_strLastError := '无法找到客货控件!';
    Exit;
  end;
  TWinCtrlAPIController.ClickButton(ControlHWND);
  Result := True;
end;

function TCardContorler.SetQuDuan: Boolean;
{功能:设置区段}
var
  nTickCount : int64;
  ControlHWND : HWND;
begin
  Result := False;
  
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxQuDuan_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到运用区段控件!';
    Exit;
  end;

  nTickCount := GetTickCount();

  while ((GetTickCount - nTickCount) < m_WriteICCarParam.WaitTimeOut) do
  begin
    Application.ProcessMessages;
    Sleep(200);
    if TWinCtrlAPIController.SetComboSelect(ControlHWND,
        PChar(WriteICCarDutyInfo.QuDuan)) then
    begin
      Break;
    end;
  end;

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,
      PChar(WriteICCarDutyInfo.QuDuan)) = False then
  begin
    m_strLastError := '无法使用运用区段('+WriteICCarDutyInfo.QuDuan+')!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.SetSubTrainmanNumber: Boolean;
{功能:设置副司机号}
var
  ControlHWND : HWND;
begin

  Result := False;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到副司机号控件!';
    Exit;
  end;

  TWinCtrlAPIController.SetEditText(
      ControlHWND,WriteICCarDutyInfo.SubTrainmanNumber);

  Result := True;

end;

function TCardContorler.SetTrainmanNumber: Boolean;
{功能:设置司机号}
var
  ControlHWND : HWND;
begin

  Result := False;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到司机号控件!';
    Exit;
  end;

  TWinCtrlAPIController.SetEditText(
      ControlHWND,WriteICCarDutyInfo.TrainmanNumber);

  Result := True;
end;

procedure TCardContorler.SetWriteCardFormHandle(Hwd: HWND);
begin
  m_SoftHandles.WriteCardFormHandle := Hwd;
end;

end.
