unit uSiWeiKDXKControler;

interface
uses uCardControlerBase,Classes,Windows,Messages,SysUtils,uProcedureControl,
    Forms,Dialogs,uTFSystem,uWriteICCarSoftDefined;




const

  //主窗体标题
  MainForm_Title = '跨段写卡管理系统';

  {$region '将要写卡的揭示信息定义'}
  WriteViewForm_Title = '将要写卡的揭示信息'; //写卡确认窗体
  WriteViewForm_Panel = 3;                    //确认按钮面板
  WriteViewForm_Class = 'Txkxx_newform';      //写卡确认类名 }
  WriteViewForm_Panel_OKButton = 6;
  {$endregion}

  {$region '读卡显示定义'}
  ReadViewForm_Title = '读卡显示';         //读卡显示窗口标题
  ReadViewForm_Class =  'Tfrm_dispnew';
  ReadViewForm_Panel = 0;
  ReadViewForm_Panel_ReturnButton = 11;
  {$endregion}

  {打印份数设置窗口标题}
  PRINTPAGECOUNT_TITLE = '输入打印份数';
  {打印份数设置窗口类名}
  PRINTPAGECOUNT_CLASSNAME = 'TForm';
  {打印份数编辑框序号}
  PRINTPAGECOUNT_EDIT_SN = 2;
  {打印份数确认按钮序号}
  PRINTPAGECOUNT_BTN_SN = 1;
  {打印完毕窗口标题}
  PRINTOVER_TITLE = '跨段写卡管理';
  {打印完毕窗口类名}
  PRINTOVER_CLASSNAME = 'TMessageForm';
  {调度命令窗口标题}
  DIAODUMINGLING_TITLE = '调度命令输入';
  {调度命令窗口类名}
  DIAODUMINGLING_CLASSNAME = 'TfrmgwJsTxtEdit';
  {调度命令管理按钮X坐标}
  DiaoDuMingLingBtn_X  = 200;
  {调度命令管理按钮Y坐标}
  DiaoDuMingLingBtn_Y  = 130;
  {调度命令管理按钮Y坐标}
  DiaoDuMingLingBtn_1680_Y  = 150;
  {调度命令管理按钮坐标}
  JiaoFuJieShiPrintPreviewBtn_X  = 610;
  {调度命令管理按钮坐标}
  JiaoFuJieShiPrintPreviewBtn_Y  = 16;

  {南京跨段写卡交付揭示打印按钮X坐标}
  JiaoFuJieShiPrintBtn_NANJING_X  = 500;
  JiaoFuJieShiPrintBtn_NANJING_Y  = 45;

  {哈尔滨跨段写卡交付揭示打印按钮X坐标}
  JiaoFuJieShiPrintBtn_HAERBIN_X  = 410;
  {交付揭示打印按钮Y坐标}
  JiaoFuJieShiPrintBtn_HAERBIN_Y  = 45;



  {交付揭示打印 区段Combobox}
  JiaoFuJieShiPrint_Section_SN = 4;
  {交付揭示打印 方向Combobox}
  JiaoFuJieShiPrint_Direction_SN = 2;
  {交付揭示打印 客货Combobox}
  JiaoFuJieShiPrint_KeHuo_SN = 1;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSiWeiKDXKControler
  /// 功能:思维跨段写卡控制类
  //////////////////////////////////////////////////////////////////////////////
  TSiWeiKDXKControler = class(TCardContorler)
  public
    Constructor Create();override;
  private
    {调度命令管理窗口句柄}
    m_nDiaoDuMingLingGuanLiHWND : HWND;
    {打印按钮面板句柄}
    m_nPrintParentHWND : HWND;
    {思维跨段写卡类型}
    m_SiWeiKDXKType : TSiWeiKDXKType;
  public
    {功能:写卡}
    function WriteCard():Boolean;override;
    {功能:更新揭示}
    function UpdateJieShi():Boolean;override;
    {功能:打印交付揭示}
    function PrintJiaoFuJieShi():Boolean;
  protected
    {功能:初始化写卡窗口控件查找序号}
    procedure InitWriteICCarWindowControlNos();override;
  private
    //下载揭示
    function DownLoadJieShi():Boolean;
    //点击下载揭示按钮
    function ClickDownLoadJieShi():Boolean;
    {功能:点击调度命令管理}
    function ClickDiaoDuMingLingGuanLi():Boolean;
    {功能:点击交付预览按钮}
    function ClickJiaoFuJieShiPrintPreview():Boolean;
    {功能:执行打印交付揭示}
    function RunPrintJiaoFuJieShi():Boolean;
    {功能:设置交付揭示打印区段}
    function SetJiaoFuJieShiPrintQuDuan():Boolean;
    {功能:设置交付揭示打印方向}
    function SetJiaoFuJieShiPrintDirection():Boolean;
    {功能:设置交付揭示打印客货}
    function SetJiaoFuJieShiPrintKeHuo():Boolean;
    {功能:设置打印份数}
    function SetPrintPageCount():Boolean;
    //关闭揭示对话框
    function CheckRefJieShiResult():Boolean;
    {功能:确认写卡}
    function ConfirmWriteICCar():Boolean;
    //关闭读卡显示窗口
    function CloseJSDisplayFrm():Boolean;
  public
    {思维跨段写卡类型}
    property SiWeiKDXKType : TSiWeiKDXKType read
        m_SiWeiKDXKType write m_SiWeiKDXKType;
  end;

implementation

uses shellapi,uWinCtrlAPIController;

{ TSiWeiKDXKControler }

function TSiWeiKDXKControler.ClickDiaoDuMingLingGuanLi: Boolean;
{功能:点击调度命令管理}
begin
  Result := False;

  if Screen.Height > 768 then
  begin
    TWinCtrlAPIController.ClickWindow(m_SoftHandles.MainFormHandle,
        DiaoDuMingLingBtn_X,DiaoDuMingLingBtn_1680_Y);
  end
  else
  begin
    TWinCtrlAPIController.ClickWindow(m_SoftHandles.MainFormHandle,
        DiaoDuMingLingBtn_X,DiaoDuMingLingBtn_Y);
  end;

  RefSleep(1500);

  m_nDiaoDuMingLingGuanLiHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeOut,DIAODUMINGLING_TITLE,
      DIAODUMINGLING_CLASSNAME);

  if (IsWindow(m_nDiaoDuMingLingGuanLiHWND) = False)
      or (IsWindowVisible(m_nDiaoDuMingLingGuanLiHWND) = False) then
  begin
    m_strlastError := '无法打开调度命令管理窗口!';
    Exit;
  end;
  Result := True;
end;

function TSiWeiKDXKControler.ClickDownLoadJieShi():Boolean;
{功能：点击下载揭示按钮}
var
  nTickCount :Cardinal;
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

  PostMessage(ToolHandle,WM_LBUTTONDOWN,$00000001,$001001FA);
  Sleep(20);
  PostMessage(ToolHandle,WM_LBUTTONUP,$00000000,$001001FA);

  Result := True;

end;

function TSiWeiKDXKControler.ClickJiaoFuJieShiPrintPreview: Boolean;
{功能:点击交付预览按钮}
var
  btnPrintPreviewParentHWND : HWND;
  ParentHWNDSN : TIntArray;
begin
  Result := False;

  SetIntArray(ParentHWNDSN,[1,1]);

  btnPrintPreviewParentHWND :=
      TWinCtrlAPIController.GetChildHandle(
      m_nDiaoDuMingLingGuanLiHWND,ParentHWNDSN);


  if btnPrintPreviewParentHWND = 0 then
  begin
    m_strLastError := '无法获取交付预览按钮面板!';
    Exit;
  end;

  TWinCtrlAPIController.ClickWindow(btnPrintPreviewParentHWND,
      JiaoFuJieShiPrintPreviewBtn_X,JiaoFuJieShiPrintPreviewBtn_Y);

  RefSleep(1000);

  case m_SiWeiKDXKType of
    skNanJing : SetIntArray(ParentHWNDSN,[0,0]);
    skHaErBin : SetIntArray(ParentHWNDSN,[0,1]);
  end;

  m_nPrintParentHWND :=
      TWinCtrlAPIController.GetChildHandle(
          m_nDiaoDuMingLingGuanLiHWND,ParentHWNDSN);

  if m_nPrintParentHWND = 0 then
  begin
    m_strLastError := '无法获取打印按钮面板!';
    Exit;
  end;

  Result := True;
end;

function TSiWeiKDXKControler.RunPrintJiaoFuJieShi: Boolean;
{功能:点击打印交付揭示}
begin
  Result := False;
  //设置区段
  if SetJiaoFuJieShiPrintQuDuan() = False then exit;
  RefSleep(1000);
  //设置方向
  if SetJiaoFuJieShiPrintDirection() = False then exit;
  RefSleep(1000);
  //设置客货
  if SetJiaoFuJieShiPrintKeHuo() = False then exit;
  RefSleep(1000);
  //设置打印份数
  if SetPrintPageCount() = False then Exit;
  RefSleep(1000);
  Result := True;
end;

function TSiWeiKDXKControler.SetJiaoFuJieShiPrintDirection: Boolean;
{功能:设置交付揭示打印方向}
var
  ControlHWND : HWND;
  strDirection : String;
begin
  Result := False;
  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
      m_nPrintParentHWND,JiaoFuJieShiPrint_Direction_SN);

  if ControlHWND = 0 then
  begin
    m_strLastError := '找到设置方向选择控件!';
    Exit;
  end;

  case WriteICCarDutyInfo.TravelDirection of
    tdUp : strDirection := '上行';
    tdDown : strDirection := '下行';
  else
    strDirection := '全部';
  end;

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strDirection) = false then
  begin
    m_strLastError := '设置方向失败!';
    Exit;
  end;
  Result := True;
end;

function TSiWeiKDXKControler.SetJiaoFuJieShiPrintKeHuo: Boolean;
{功能:设置交付揭示打印客货}
var
  ControlHWND : HWND;
  strKeHuo : String;
begin
  Result := False;
  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
      m_nPrintParentHWND,JiaoFuJieShiPrint_KeHuo_SN);

  if ControlHWND = 0 then
  begin
    m_strLastError := '找到设置客货选择控件!';
    Exit;
  end;

  case WriteICCarDutyInfo.KeHuo of
    khHuoChe : strKeHuo := '货车';
    khKeChe : strKeHuo := '客车';
  else
    strKeHuo := '全部';
  end;

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strKeHuo) = false then
  begin
    m_strLastError := '设置客货失败!';
    Exit;
  end;
  Result := True;

end;

function TSiWeiKDXKControler.SetJiaoFuJieShiPrintQuDuan: Boolean;
{功能:设置交付揭示打印区段}
var
  ControlHWND : HWND;
begin
  Result := False;
  {设置区段}
  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(
      m_nPrintParentHWND,JiaoFuJieShiPrint_Section_SN);

  if ControlHWND = 0 then
  begin
    m_strLastError := '未找到设置区段选择控件!';
    Exit;
  end;

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,
      WriteICCarDutyInfo.QuDuan) = false then
  begin
    m_strLastError := '设置区段失败!';
    Exit;
  end;
  Result := True;
end;

function TSiWeiKDXKControler.SetPrintPageCount: Boolean;
{功能:设置打印份数}
var
  WindowHWND : HWND;
  ControlHWND : HWND;
begin
  Result := False;
  //点击打印按钮
  case m_SiWeiKDXKType of
    skNanJing :
      begin
        TWinCtrlAPIController.ClickWindow(m_nPrintParentHWND,
            JiaoFuJieShiPrintBtn_NANJING_X,JiaoFuJieShiPrintBtn_NANJING_Y);
      end;
    skHaErBin :
      begin
        TWinCtrlAPIController.ClickWindow(m_nPrintParentHWND,
            JiaoFuJieShiPrintBtn_HAERBIN_X,JiaoFuJieShiPrintBtn_HAERBIN_Y);
      end;
  end;

  //输入打印份数
  WindowHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeOut,PRINTPAGECOUNT_TITLE,PRINTPAGECOUNT_CLASSNAME);

  if WindowHWND = 0 then
  begin
    m_strLastError := '无法获取打印份数设置窗口!';
    Exit;
  end;

  RefSleep(2000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(WindowHWND,
      PRINTPAGECOUNT_EDIT_SN);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法获取打印份数编辑框!';
    Exit;
  end;

  if TWinCtrlAPIController.SetEditText(ControlHWND,
      IntToStr(WriteICCarDutyInfo.PrintPageCount)) = False then
  begin
    m_strLastError := '设置打印份数失败!';
    Exit;
  end;

  RefSleep(2000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(WindowHWND,
      PRINTPAGECOUNT_BTN_SN);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法获取打印份数确认按钮!';
    Exit;
  end;

  TWinCtrlAPIController.ClickButton(ControlHWND);

  RefSleep(2000);

  WindowHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeOut,PRINTOVER_TITLE,PRINTOVER_CLASSNAME);

  if WindowHWND = 0 then
  begin
    m_strLastError := '打印无响应!';
    Exit;
  end;

  RefSleep(1000);

  PostMessage(WindowHWND,WM_Close,0,0);

  Result := True;
end;

function TSiWeiKDXKControler.CheckRefJieShiResult():Boolean;
{功能：关闭提示信息对话框}
var
  FormHWND : HWND;
  ControlHWND : HWND;
begin
  Result := False;
  FormHWND := TWinCtrlAPIController.WaitWindowRun(
      60000,'提示','#32770');

  if FormHWND = 0 then
  begin
    m_strLastError := '揭示更新无响应!';
    Exit;
  end;

  RefSleep(1000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,1);

  if TWinCtrlAPIController.GetFormCaption(ControlHWND) <> '揭示信息更新完毕' then
  begin
    m_strLastError := '请重新更新!';
    Exit;
  end;

  PostMessage(FormHWND,WM_Close,0,0);

  Result := True;
end;

function TSiWeiKDXKControler.ConfirmWriteICCar: Boolean;
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

  TWinCtrlAPIController.ClickButtonWait(ControlHWND);

  Result := True;
end;

constructor TSiWeiKDXKControler.Create;
begin
  inherited;
  m_WriteICCarParam.MainFormTitle := MainForm_Title;
end;

function TSiWeiKDXKControler.DownLoadJieShi():Boolean;
{功能：下载揭示}
begin
  Result := False;
  if ClickDownLoadJieShi() = False then Exit;
  RefSleep(3000);
  if CheckRefJieShiResult() = False then Exit;
  Result := True;
end;

procedure TSiWeiKDXKControler.InitWriteICCarWindowControlNos;
{功能:初始化写卡窗口控件查找序号}
begin
  //区段控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxQuDuan_TabOrders,[23]);
  //机务段控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxJWD_TabOrders,[1]);
  //客货控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeHuo_TabOrders,[13,0]);
  //客车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeChe_TabOrders,[13,1]);
  //货车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbHuoChe_TabOrders,[13,2]);
  //车次头下拉框控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxCheCiTou_TabOrders,[24]);
  //车次头下拉框中的Edit控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheCiTou_TabOrders,[24,0]);
  //车次号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheCiNumber_TabOrders,[18]);
  //司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders,[22]);
  //副司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders,[20]);
  //交路号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders,[12]);
  //车站号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders,[11]);
  //写卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnWriteICCar_TabOrders,[3,4]);
  //擦卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnEraseICCar_TabOrders,[3,6]);
end;

function TSiWeiKDXKControler.PrintJiaoFuJieShi: Boolean;
{功能:打印交付揭示}
begin
  Result := False;
  //启动写卡程序
  RunWriteICCarProgram;
  //由于主窗口启动之后,直接发送F2打开管理员登陆,会出现问题,所以延迟6秒
  RefSleep(6000);
  try
    //管理员登录
    if AttendantLogin() = False then Exit;
    RefSleep(1500);
    //点击调度命令管理按钮
    if ClickDiaoDuMingLingGuanLi() = False then Exit;
    RefSleep(1500);
    //点击交付揭示预览按钮
    if ClickJiaoFuJieShiPrintPreview() = False then Exit;
    RefSleep(1500);
    //执行打印揭示预览按钮
    if RunPrintJiaoFuJieShi() = False then Exit;
    RefSleep(1500);
    //关闭调度命令窗口
    PostMessage(m_nDiaoDuMingLingGuanLiHWND,WM_Close,0,0);
    RefSleep(1500);
    //关闭主窗口
    PostMessage(m_SoftHandles.MainFormHandle,WM_Close,0,0);
    RefSleep(1500);
    Result := True;
  finally
    CloseWriteICCarProgram;
  end;
  
end;

function TSiWeiKDXKControler.CloseJSDisplayFrm():Boolean;
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


function TSiWeiKDXKControler.UpdateJieShi: Boolean;
{功能:更新揭示}
begin
  Result := False;
  try
    //启动写卡程序
    if RunWriteICCarProgram = False then Exit;
    //由于主窗口启动之后,直接发送F2打开管理员登陆,会出现问题,所以延迟6秒
    RefSleep(6000);
    //管理员登录
    if AdminLogin() = False then Exit;
    RefSleep(1500);
    //下载揭示
    if DownLoadJieShi() = False then Exit;
    RefSleep(1500);
    Result := True;
  finally
    CloseWriteICCarProgram;
  end;
end;

function TSiWeiKDXKControler.WriteCard: Boolean;
{功能:写卡}
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

    //关闭读卡显示窗口
    if CloseJSDisplayFrm() = False then Exit;
    RefSleep(1000);
    StateNotice('写卡完毕,正在关闭写卡模块......');

    //关闭写卡窗口
    PostMessage(m_SoftHandles.WriteCardFormHandle,WM_CLOSE,0,0);
    RefSleep(2000);
    Result := True;
  finally
    //关闭写卡程序
    CloseWriteICCarProgram;
  end;
end;


end.
