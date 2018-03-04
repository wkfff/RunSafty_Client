unit uZZKDXKControler;

{*******************************************************}
{ 类名：TZZKDXKControler                                }
{ 功能：实现株洲跨段写卡控制                            }
{                                                       }
{*******************************************************}
interface

uses
  Windows,Messages,SysUtils,Dialogs,Forms,uCardControlerBase, uProcedureControl,
  uTFSystem;
const

  //主窗体标题
  MainForm_Title = '跨段写卡管理系统';    //(思维株州不同)

  {$region '将要写卡的揭示信息定义'}
  WriteViewForm_Title = '将要写卡的揭示信息'; //写卡确认窗体
  WriteViewForm_Panel = 3;                    //确认按钮面板
  WriteViewForm_Class = 'Txkxxform';      //写卡确认类名
  WriteViewForm_Panel_OKButton = 7;           //确认按钮
  {$endregion}

  {$region '读卡显示定义'}
  ReadViewForm_Title = '读卡显示';         //读卡显示窗口标题
  ReadViewForm_Class = 'Tfrm_disp';   //读卡显示类名
  ReadViewForm_Panel = 1;                 //返回按钮父面板序号
  ReadViewForm_Panel_ReturnButton = 13;   //返回按钮序号
  {$endregion}

type

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TZZKDXKControler
  /// 功能:株洲跨段写卡控制类
  //////////////////////////////////////////////////////////////////////////////
  TZZKDXKControler = class(TCardContorler)
  public
    constructor Create();override;
  public
    {功能:写卡}
    function WriteCard():Boolean;override;
    {功能:更新揭示}
    function UpdateJieShi():Boolean;override;
  protected
    {功能:初始化写卡窗口控件查找序号}
    procedure InitWriteICCarWindowControlNos();override;
  protected
    {功能:设置车次头}
    function SetCheCiTou():Boolean;override;
    {功能:确认写卡}
    function ConfirmWriteICCar():Boolean;
    {功能:检查写卡结果}
    function CheckWriteICCarResult():Boolean;
    {功能:检查揭示更新结果}
    function CheckRefJieShiResult():Boolean;
  private
    //下载揭示
    function DownLoadJS():Boolean;
    {功能:点击下载揭示按钮}
    function ClickDownLoadJieShi():Boolean;
    //关闭读卡显示窗口
    function CloseJSDisplayFrm():Boolean;
    //关闭分解提示窗口
    procedure CloseRemindFrm();
  end;

implementation
uses
  Shellapi,uWinCtrlAPIController;

{ TZZKDXKControler }
function TZZKDXKControler.CheckRefJieShiResult: Boolean;
{功能:检查揭示更新结果}
var
  FormHWND : HWND;
  ControlHWND : HWND;
  strWindowCaption : String;
begin
  Result := False;
  FormHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeout,'提示','#32770');

  if FormHWND = 0 then
  begin
    m_strLastError := '揭示更新无响应!';
    Exit;
  end;

  RefSleep(1000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,2);

  strWindowCaption := TWinCtrlAPIController.GetFormCaption(ControlHWND);

  if Pos('更新完毕',strWindowCaption) = 0 then
  begin
    m_strLastError := '请重新更新!';
    Exit;
  end;

  PostMessage(FormHWND,WM_Close,0,0);

  Result := True;

end;

function TZZKDXKControler.CheckWriteICCarResult: Boolean;
{功能:检查写卡结果}
var
  FormHWND : HWND;
  ControlHWND : HWND;
begin
  Result := False;

  FormHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeOut,'提示','#32770');

  if FormHWND = 0 then
  begin
    m_strLastError := '无法找到写卡结果窗口!';
    Exit;
  end;

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,1);

  if TWinCtrlAPIController.GetFormCaption(ControlHWND) <> '写卡成功' then
  begin
    m_strLastError := '请重新写卡!';
    Exit;
  end;

  RefSleep(1000);

  PostMessage(FormHWND,WM_Close,0,0);

  Result := True;
end;

function TZZKDXKControler.ClickDownLoadJieShi():Boolean;
{功能:点击下载揭示按钮}
var
  nTickCount :int64;
  ToolHandle :HWND;
begin
  Result := False;
  nTickCount := GetTickCount;
  ToolHandle := TWinCtrlAPIController.GetChildControlHandle(
      m_SoftHandles.MainFormHandle,0);

  while (ToolHandle = 0) and
      ((GetTickCount - nTickCount) < m_WriteICCarParam.WaitTimeout) do
  begin
    Sleep(100);
    ToolHandle := TWinCtrlAPIController.GetChildControlHandle(
      m_SoftHandles.MainFormHandle,0);
  end;

  if ToolHandle = 0 then
  begin
    m_strLastError := '无法获取工具栏!';
    Exit;
  end;

  PostMessage(ToolHandle,WM_LBUTTONDOWN,$00000001,$001202A8);
  Sleep(20);
  PostMessage(ToolHandle,WM_LBUTTONUP,$00000000,$001202A8);
  Result := True;

end;

function TZZKDXKControler.CloseJSDisplayFrm():Boolean;
{功能：关闭读卡显示窗口}
var
  ControlHWND : HWND;
  FormHWND : HWND;
  btnConfirmNos : TIntArray;
begin

  Result := False;

  FormHWND :=  TWinCtrlAPIController.WaitWindowRun(m_WriteICCarParam.WaitTimeOut,
      ReadViewForm_Title,ReadViewForm_Class);

  if FormHWND = 0 then
  begin
    m_strLastError := '等待"读卡显示"窗口超时!';
    Exit;
  end;

  RefSleep(1000);

  SetIntArray(btnConfirmNos,[ReadViewForm_Panel,ReadViewForm_Panel_ReturnButton]);

  ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHWND,btnConfirmNos);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到"返回"按钮!';
    Exit;
  end;

  //执行“返回”
  TWinCtrlAPIController.ClickButton(ControlHWND);

  Result := True;
end;

procedure TZZKDXKControler.CloseRemindFrm;
var
  subh :HWND;
begin
   subh := TWinCtrlAPIController.GetFormHandle('TKdxk_MsClient','分解服务器(1)');
   if subh <> 0 then
    PostMessage(subh,WM_CLOSE,0,0);
end;

function TZZKDXKControler.ConfirmWriteICCar: Boolean;
{功能:确认写卡}
var
  FormHandle : HWND;
  ControlHWND : HWND;
  btnConfirmNos : TIntArray;
begin
  Result := False;

  FormHandle := TWinCtrlAPIController.WaitWindowRun(m_WriteICCarParam.WaitTimeOut,
      WriteViewForm_Title,WriteViewForm_Class);

  if FormHandle = 0 then
  begin
    m_strLastError := '等待确认写卡窗口超时!';
    Exit;
  end;

  RefSleep(3000);

  SetIntArray(btnConfirmNos,[WriteViewForm_Panel,WriteViewForm_Panel_OKButton]);

  ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHandle,btnConfirmNos);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到确认写卡按钮!';
    Exit;
  end;

  TWinCtrlAPIController.ClickButton(ControlHWND);

  Result := True;

end;

constructor TZZKDXKControler.create;
begin
  inherited;
  m_WriteICCarParam.MainFormTitle := MainForm_Title;  
end;

function TZZKDXKControler.DownLoadJS():Boolean;
begin
  Result := False;

  if ClickDownLoadJieShi() = False then exit;

  RefSleep(2000);

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

  RefSleep(3000);

  if CheckRefJieShiResult() = False then Exit;

  Result := True;

end;

procedure TZZKDXKControler.InitWriteICCarWindowControlNos;
{功能:初始化写卡窗口控件查找序号}
begin
  //区段控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxQuDuan_TabOrders,[2]);
  //机务段控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxJWD_TabOrders,[5]);
  //客货控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeHuo_TabOrders,[15,0]);
  //客车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeChe_TabOrders,[15,1]);
  //货车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbHuoChe_TabOrders,[15,2]);
  //车次头下拉框控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxCheCiTou_TabOrders,[4]);
  //车次号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheCiNumber_TabOrders,[3]);
  //司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders,[23]);
  //副司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders,[21]);
  //交路号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders,[14]);
  //车站号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders,[11]);
  //写卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnWriteICCar_TabOrders,[6,4]);
  //擦卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnEraseICCar_TabOrders,[3,6]);
end;

function TZZKDXKControler.SetCheCiTou: Boolean;
{功能:设置车次头}
var
  ControlHWND : HWND;
  strCheCiTou : String;
begin
  Result := False;
  ControlHWND := TWinCtrlAPIController.GetChildHandle(m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxCheCiTou_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到车次头下拉框!';
    Exit;
  end;

  strCheCiTou := WriteICCarDutyInfo.CheCiTou;
  if strCheCiTou = '' then
    strCheCiTou := '默认';

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strCheCiTou) = False then
  begin
    m_strLastError := '无法设置车次头('+strCheCiTou+')';
    Exit;
  end;

  Result := True;
end;

function TZZKDXKControler.UpdateJieShi: Boolean;
begin
  Result := False;
  try
    if RunWriteICCarProgram = False then Exit;
    RefSleep(6000);    
    //下载揭示
    if AttendantLogin() = False then Exit;
    RefSleep(1000);    
    if DownLoadJS() = False then Exit;
    RefSleep(1000);
    Result := True;
  finally
    CloseWriteICCarProgram;
  end;
end;


function TZZKDXKControler.WriteCard: Boolean;
begin
  Result := False;
  //启动写卡程序
  StateNotice('正在启动写卡模块......');
  if RunWriteICCarProgram() = False then Exit;
  RefSleep(5000);
  try
    StateNotice('写卡模块启动成功,正在自动登录值班员信息......');

    //值班员登录
    if AttendantLogin() = False Then Exit;
    RefSleep(1000);
    StateNotice('值班员登录成功,正在打开写卡功能......');

    //打开写卡窗口
    if OpenKDXKWriteCardFrm() = False then Exit;
    RefSleep(1000);
    StateNotice('写卡功能打开成功,正在提交出勤信息......');

    //填写出信息
    if SetKDXKDutyInfo() = False then Exit;
    RefSleep(1000);
    StateNotice('出勤信息提交成功,正在准备写卡......');

    //提交写卡
    if SubmitWriteICCard() = False then Exit;
    RefSleep(1000);
    StateNotice('正在写卡......');

    //确认写卡
    if ConfirmWriteICCar() = False then Exit;
    RefSleep(1000);

    //检查写卡结果
    if CheckWriteICCarResult() = False then Exit;
    RefSleep(1000);

    //关闭写卡确认窗口
    if CloseJSDisplayFrm() = False then Exit;
    RefSleep(1000);

    StateNotice('写卡完毕,正在关闭写卡模块......');
    
    //关闭写卡窗口
    PostMessage(m_SoftHandles.WriteCardFormHandle,WM_CLOSE,0,0);
    RefSleep(2000);
    Result := True;
  finally
    CloseWriteICCarProgram;
  end;


end;



end.
