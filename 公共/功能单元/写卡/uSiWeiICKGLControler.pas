unit uSiWeiICKGLControler;

interface
uses
  Windows,Messages,SysUtils,uWinCtrlAPIController,shellapi,Graphics,Classes,
  uProcedureControl,uCardControlerBase,Forms,uICCDefines,uJieShiFileReader,
  uTFSystem;
const
  {主窗口标题}
  MainForm_Title = 'IC卡管理、转储系统';


type

  TOnGetJieShiRecArray = function(var JieShiRecArray: TICCJieShiRecArray):Boolean of Object;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSiWeiIckglControler
  /// 功能:思维IC卡管理写卡控制类
  //////////////////////////////////////////////////////////////////////////////
  TSiWeiIckglControler = class(TCardContorler)
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
    {功能:设置车次头}
    function SetCheCiTou():Boolean;override;
  protected
    function CheckWriteSuccess(JieShiRecArray: TICCJieShiRecArray): Boolean;
    {功能:读取揭示文件}
    function OpenJieShiFile():Boolean;
    {功能:写揭示信息}
    function WriteJieShi():Boolean;
    {功能:检查是否写卡成功}
    function CheckWriteICCarSuccess():Boolean;
  public
    OnGetJieShiRecArray : TOnGetJieShiRecArray;
  end;

implementation

{ TSiWeiIckglControler }
function TSiWeiIckglControler.CheckWriteSuccess(
  JieShiRecArray: TICCJieShiRecArray): Boolean;
var
  FileJieShiRecArray : TICCJieShiRecArray;
  NewICKGLJieShiFileReader : TNewICKGLJieShiFileReader;
var
  i,j : Integer;
  nJsCount : Integer;
  bIsFind : Boolean;
begin
  Result := False;
  NewICKGLJieShiFileReader := TNewICKGLJieShiFileReader.Create(m_JSFileName);
  nJsCount := NewICKGLJieShiFileReader.GetRecCount;
  try
    SetLengTh(FileJieShiRecArray,0);
    for I := 0 to nJsCount - 1 do
    begin
      SetLengTh(FileJieShiRecArray,length(FileJieShiRecArray)+1);
      NewICKGLJieShiFileReader.GetRecord(i,
          FileJieShiRecArray[length(FileJieShiRecArray)-1]);
    end;
  finally
    NewICKGLJieShiFileReader.Free;
  end;

  if LengTh(JieShiRecArray) <> LengTh(FileJieShiRecArray) then Exit;

  for I := 0 to LengTh(JieShiRecArray) - 1 do
  begin
    bIsFind := False;
    for j := 0 to length(FileJieShiRecArray) - 1 do
    begin
      if (JieShiRecArray[i].dwCommandNO = FileJieShiRecArray[j].dwCommandNO) And
         (JieShiRecArray[i].nPos_Begin = FileJieShiRecArray[j].nPos_Begin) And
         (JieShiRecArray[i].nPos_End = FileJieShiRecArray[j].nPos_End) then
      begin
        bIsFind := True;
        Break;
      end;
    end;

    if bIsFind = False then Exit;


  end;

  Result := True;
  
end;
function TSiWeiIckglControler.CheckWriteICCarSuccess(): Boolean;
{功能:检查是否写卡成功}
var
  JieShiRecArray: TICCJieShiRecArray;
begin
  Result := False;

  if Assigned(OnGetJieShiRecArray) then
  begin
    if OnGetJieShiRecArray(JieShiRecArray) = False then
    begin
      m_strLastError := '校验写卡结果失败,无法读卡!';
      Exit;
    end;
  end
  else
  begin
    m_strLastError := '未设置读卡接口!无法验卡!';
    Exit;
  end;

  try
    if CheckWriteSuccess(JieShiRecArray) = False then
    begin
      m_strLastError := '校验写卡结果失败!请重新写卡.';
      Exit;
    end;
  except
    on E: Exception do
    begin
      m_strLastError := '校验写卡结果出错,错误:('+E.Message+')';
      Exit;
    end;
  end;
  
  Result := True;
end;


constructor TSiWeiIckglControler.Create;
begin
  inherited;
  m_WriteICCarParam.MainFormTitle := MainForm_Title;
end;




procedure TSiWeiIckglControler.InitWriteICCarWindowControlNos;
{功能:初始化写卡窗口控件查找序号}
begin
  //客货控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeHuo_TabOrders,[2,1]);
  //客车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbKeChe_TabOrders,[16,0]);
  //货车控件查找序号
  SetIntArray(m_WriteICCarChildOrders.rbHuoChe_TabOrders,[16,1]);
  //车次头下拉框控件查找序号
  SetIntArray(m_WriteICCarChildOrders.cbxCheCiTou_TabOrders,[3]);
  //车次号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheCiNumber_TabOrders,[21]);
  //司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders,[25]);
  //副司机号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders,[23]);
  //交路号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders,[15]);
  //车站号控件查找序号
  SetIntArray(m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders,[14]);
  //写卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnWriteICCar_TabOrders,[11]);
  //擦卡按钮控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnEraseICCar_TabOrders,[12]);
  //读揭示文件控件查找序号
  SetIntArray(m_WriteICCarChildOrders.btnReadJieShiFile_TabOrders,[7]);

end;


function TSiWeiIckglControler.OpenJieShiFile: Boolean;
{功能:读取揭示文件}
var
  ControlHWND : HWND;
  FormHWND : HWND;
  ControlNos : TIntArray;
begin
  Result := False;
  if m_JSFileName <> '' then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildHandle(
        m_SoftHandles.WriteCardFormHandle,
        m_WriteICCarChildOrders.btnReadJieShiFile_TabOrders);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法获取读揭示文件按钮!';
      Exit;
    end;
    TWinCtrlAPIController.ClickButton(ControlHWND);
    
    //等待打开窗口句柄
    //#32770 (对话框)
    FormHWND := TWinCtrlAPIController.WaitWindowRun(3000,'打开','#32770');
    if FormHWND = 0 then
    begin
      m_strLastError := '无法启动揭示文件打开窗口!';
      Exit;
    end;

    RefSleep(2000);

    SetIntArray(ControlNos,[8,0,0]);

    ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHWND,ControlNos);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法获得揭示文件名输入框!';
      Exit;
    end;

    TWinCtrlAPIController.SetEditText(ControlHWND,m_JsFilename);

    RefSleep(1000);
    
    {获得确定按钮}
    ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,12);

    if ControlHWND = 0 then
    begin
      m_strLastError := '无法获得确定揭示文件名按钮!';
      Exit;
    end;

    TWinCtrlAPIController.ClickButton(ControlHWND);
  end;
  
  Result := True;
end;

function TSiWeiIckglControler.SetCheCiTou: Boolean;
{功能:设置车次头}
var
  ControlHWND : HWND;
  strCheCiTou : String;
begin
  Result := False;
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxCheCiTou_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法找到车次头下拉框!';
    Exit;
  end;

  strCheCiTou := WriteICCarDutyInfo.CheCiTou;
  if strCheCiTou = '' then
    strCheCiTou := '无';

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strCheCiTou) = False then
  begin
    m_strLastError := '无法设置车次头('+strCheCiTou+')';
    Exit;
  end;
  Result := True;
end;

function TSiWeiIckglControler.UpdateJieShi: Boolean;
{功能:更新揭示,IC卡管理不需要更新揭示,所以直接返回True}
begin
  Result := True;
end;

function TSiWeiIckglControler.WriteCard:Boolean;
begin
  Result := False;

  //启动写卡程序
  StateNotice('正在启动写卡模块......');
  if RunWriteICCarProgram() = False then exit;
  RefSleep(3000);
  try
    //打开写卡窗口
    StateNotice('写卡模块启动成功,正在打开写卡功能......');
    if OpenICKGLWriteCardFrm() = False then exit;
    RefSleep(1000);

    //填写出信息
    if SetICKGLDutyInfo() = False then Exit;
    RefSleep(1000);
    StateNotice('出勤信息提交成功,正在打开揭示文件......');

    //打开揭示文件
    if OpenJieShiFile() = False then Exit;
    RefSleep(1000);
    StateNotice('揭示文件打开成功,正在写卡......');

    //写卡
    if WriteJieShi() = False Then Exit;
    RefSleep(1000);
    StateNotice('写卡成功,正在校验写卡结果......');

    //校验写卡结果
    if CheckWriteICCarSuccess = False then Exit;
    RefSleep(1000);
    StateNotice('写卡完毕,正在关闭写卡模块......');
    
    Result := True;
   
  finally
    CloseWriteICCarProgram;
  end;

end;

function TSiWeiIckglControler.WriteJieShi: Boolean;
{功能:写揭示信息}
var
  ControlHWND : HWND;
  FormHWND : HWND;
begin
  Result := False;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.btnWriteICCar_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '无法获取写卡按钮!';
    exit;
  end;

  TWinCtrlAPIController.ClickButton(ControlHWND);

  Sleep(1000);

  FormHWND :=
      TWinCtrlAPIController.WaitWindowRun(30000,'IC卡转储管理','TMessageForm');

  if FormHWND = 0 then
  begin
    m_strLastError := '写卡无响应,请重新写卡!';
    exit;
  end;

  PostMessage(FormHWND,WM_Close,0,0);
  Result := True;

end;

end.
