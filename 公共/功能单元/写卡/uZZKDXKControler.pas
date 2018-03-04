unit uZZKDXKControler;

{*******************************************************}
{ ������TZZKDXKControler                                }
{ ���ܣ�ʵ�����޿��д������                            }
{                                                       }
{*******************************************************}
interface

uses
  Windows,Messages,SysUtils,Dialogs,Forms,uCardControlerBase, uProcedureControl,
  uTFSystem;
const

  //���������
  MainForm_Title = '���д������ϵͳ';    //(˼ά���ݲ�ͬ)

  {$region '��Ҫд���Ľ�ʾ��Ϣ����'}
  WriteViewForm_Title = '��Ҫд���Ľ�ʾ��Ϣ'; //д��ȷ�ϴ���
  WriteViewForm_Panel = 3;                    //ȷ�ϰ�ť���
  WriteViewForm_Class = 'Txkxxform';      //д��ȷ������
  WriteViewForm_Panel_OKButton = 7;           //ȷ�ϰ�ť
  {$endregion}

  {$region '������ʾ����'}
  ReadViewForm_Title = '������ʾ';         //������ʾ���ڱ���
  ReadViewForm_Class = 'Tfrm_disp';   //������ʾ����
  ReadViewForm_Panel = 1;                 //���ذ�ť��������
  ReadViewForm_Panel_ReturnButton = 13;   //���ذ�ť���
  {$endregion}

type

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TZZKDXKControler
  /// ����:���޿��д��������
  //////////////////////////////////////////////////////////////////////////////
  TZZKDXKControler = class(TCardContorler)
  public
    constructor Create();override;
  public
    {����:д��}
    function WriteCard():Boolean;override;
    {����:���½�ʾ}
    function UpdateJieShi():Boolean;override;
  protected
    {����:��ʼ��д�����ڿؼ��������}
    procedure InitWriteICCarWindowControlNos();override;
  protected
    {����:���ó���ͷ}
    function SetCheCiTou():Boolean;override;
    {����:ȷ��д��}
    function ConfirmWriteICCar():Boolean;
    {����:���д�����}
    function CheckWriteICCarResult():Boolean;
    {����:����ʾ���½��}
    function CheckRefJieShiResult():Boolean;
  private
    //���ؽ�ʾ
    function DownLoadJS():Boolean;
    {����:������ؽ�ʾ��ť}
    function ClickDownLoadJieShi():Boolean;
    //�رն�����ʾ����
    function CloseJSDisplayFrm():Boolean;
    //�رշֽ���ʾ����
    procedure CloseRemindFrm();
  end;

implementation
uses
  Shellapi,uWinCtrlAPIController;

{ TZZKDXKControler }
function TZZKDXKControler.CheckRefJieShiResult: Boolean;
{����:����ʾ���½��}
var
  FormHWND : HWND;
  ControlHWND : HWND;
  strWindowCaption : String;
begin
  Result := False;
  FormHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeout,'��ʾ','#32770');

  if FormHWND = 0 then
  begin
    m_strLastError := '��ʾ��������Ӧ!';
    Exit;
  end;

  RefSleep(1000);

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,2);

  strWindowCaption := TWinCtrlAPIController.GetFormCaption(ControlHWND);

  if Pos('�������',strWindowCaption) = 0 then
  begin
    m_strLastError := '�����¸���!';
    Exit;
  end;

  PostMessage(FormHWND,WM_Close,0,0);

  Result := True;

end;

function TZZKDXKControler.CheckWriteICCarResult: Boolean;
{����:���д�����}
var
  FormHWND : HWND;
  ControlHWND : HWND;
begin
  Result := False;

  FormHWND := TWinCtrlAPIController.WaitWindowRun(
      m_WriteICCarParam.WaitTimeOut,'��ʾ','#32770');

  if FormHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�д���������!';
    Exit;
  end;

  ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,1);

  if TWinCtrlAPIController.GetFormCaption(ControlHWND) <> 'д���ɹ�' then
  begin
    m_strLastError := '������д��!';
    Exit;
  end;

  RefSleep(1000);

  PostMessage(FormHWND,WM_Close,0,0);

  Result := True;
end;

function TZZKDXKControler.ClickDownLoadJieShi():Boolean;
{����:������ؽ�ʾ��ť}
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
    m_strLastError := '�޷���ȡ������!';
    Exit;
  end;

  PostMessage(ToolHandle,WM_LBUTTONDOWN,$00000001,$001202A8);
  Sleep(20);
  PostMessage(ToolHandle,WM_LBUTTONUP,$00000000,$001202A8);
  Result := True;

end;

function TZZKDXKControler.CloseJSDisplayFrm():Boolean;
{���ܣ��رն�����ʾ����}
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
    m_strLastError := '�ȴ�"������ʾ"���ڳ�ʱ!';
    Exit;
  end;

  RefSleep(1000);

  SetIntArray(btnConfirmNos,[ReadViewForm_Panel,ReadViewForm_Panel_ReturnButton]);

  ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHWND,btnConfirmNos);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�"����"��ť!';
    Exit;
  end;

  //ִ�С����ء�
  TWinCtrlAPIController.ClickButton(ControlHWND);

  Result := True;
end;

procedure TZZKDXKControler.CloseRemindFrm;
var
  subh :HWND;
begin
   subh := TWinCtrlAPIController.GetFormHandle('TKdxk_MsClient','�ֽ������(1)');
   if subh <> 0 then
    PostMessage(subh,WM_CLOSE,0,0);
end;

function TZZKDXKControler.ConfirmWriteICCar: Boolean;
{����:ȷ��д��}
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
    m_strLastError := '�ȴ�ȷ��д�����ڳ�ʱ!';
    Exit;
  end;

  RefSleep(3000);

  SetIntArray(btnConfirmNos,[WriteViewForm_Panel,WriteViewForm_Panel_OKButton]);

  ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHandle,btnConfirmNos);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�ȷ��д����ť!';
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
    m_strLastError := '�޷���ֵ��Ա��¼����!';
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
{����:��ʼ��д�����ڿؼ��������}
begin
  //���οؼ��������
  SetIntArray(m_WriteICCarChildOrders.cbxQuDuan_TabOrders,[2]);
  //����οؼ��������
  SetIntArray(m_WriteICCarChildOrders.cbxJWD_TabOrders,[5]);
  //�ͻ��ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbKeHuo_TabOrders,[15,0]);
  //�ͳ��ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbKeChe_TabOrders,[15,1]);
  //�����ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbHuoChe_TabOrders,[15,2]);
  //����ͷ������ؼ��������
  SetIntArray(m_WriteICCarChildOrders.cbxCheCiTou_TabOrders,[4]);
  //���κſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtCheCiNumber_TabOrders,[3]);
  //˾���ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders,[23]);
  //��˾���ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders,[21]);
  //��·�ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders,[14]);
  //��վ�ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders,[11]);
  //д����ť�ؼ��������
  SetIntArray(m_WriteICCarChildOrders.btnWriteICCar_TabOrders,[6,4]);
  //������ť�ؼ��������
  SetIntArray(m_WriteICCarChildOrders.btnEraseICCar_TabOrders,[3,6]);
end;

function TZZKDXKControler.SetCheCiTou: Boolean;
{����:���ó���ͷ}
var
  ControlHWND : HWND;
  strCheCiTou : String;
begin
  Result := False;
  ControlHWND := TWinCtrlAPIController.GetChildHandle(m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxCheCiTou_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�����ͷ������!';
    Exit;
  end;

  strCheCiTou := WriteICCarDutyInfo.CheCiTou;
  if strCheCiTou = '' then
    strCheCiTou := 'Ĭ��';

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strCheCiTou) = False then
  begin
    m_strLastError := '�޷����ó���ͷ('+strCheCiTou+')';
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
    //���ؽ�ʾ
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
  //����д������
  StateNotice('��������д��ģ��......');
  if RunWriteICCarProgram() = False then Exit;
  RefSleep(5000);
  try
    StateNotice('д��ģ�������ɹ�,�����Զ���¼ֵ��Ա��Ϣ......');

    //ֵ��Ա��¼
    if AttendantLogin() = False Then Exit;
    RefSleep(1000);
    StateNotice('ֵ��Ա��¼�ɹ�,���ڴ�д������......');

    //��д������
    if OpenKDXKWriteCardFrm() = False then Exit;
    RefSleep(1000);
    StateNotice('д�����ܴ򿪳ɹ�,�����ύ������Ϣ......');

    //��д����Ϣ
    if SetKDXKDutyInfo() = False then Exit;
    RefSleep(1000);
    StateNotice('������Ϣ�ύ�ɹ�,����׼��д��......');

    //�ύд��
    if SubmitWriteICCard() = False then Exit;
    RefSleep(1000);
    StateNotice('����д��......');

    //ȷ��д��
    if ConfirmWriteICCar() = False then Exit;
    RefSleep(1000);

    //���д�����
    if CheckWriteICCarResult() = False then Exit;
    RefSleep(1000);

    //�ر�д��ȷ�ϴ���
    if CloseJSDisplayFrm() = False then Exit;
    RefSleep(1000);

    StateNotice('д�����,���ڹر�д��ģ��......');
    
    //�ر�д������
    PostMessage(m_SoftHandles.WriteCardFormHandle,WM_CLOSE,0,0);
    RefSleep(2000);
    Result := True;
  finally
    CloseWriteICCarProgram;
  end;


end;



end.
