unit uSiWeiICKGLControler;

interface
uses
  Windows,Messages,SysUtils,uWinCtrlAPIController,shellapi,Graphics,Classes,
  uProcedureControl,uCardControlerBase,Forms,uICCDefines,uJieShiFileReader,
  uTFSystem;
const
  {�����ڱ���}
  MainForm_Title = 'IC������ת��ϵͳ';


type

  TOnGetJieShiRecArray = function(var JieShiRecArray: TICCJieShiRecArray):Boolean of Object;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSiWeiIckglControler
  /// ����:˼άIC������д��������
  //////////////////////////////////////////////////////////////////////////////
  TSiWeiIckglControler = class(TCardContorler)
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
    {����:���ó���ͷ}
    function SetCheCiTou():Boolean;override;
  protected
    function CheckWriteSuccess(JieShiRecArray: TICCJieShiRecArray): Boolean;
    {����:��ȡ��ʾ�ļ�}
    function OpenJieShiFile():Boolean;
    {����:д��ʾ��Ϣ}
    function WriteJieShi():Boolean;
    {����:����Ƿ�д���ɹ�}
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
{����:����Ƿ�д���ɹ�}
var
  JieShiRecArray: TICCJieShiRecArray;
begin
  Result := False;

  if Assigned(OnGetJieShiRecArray) then
  begin
    if OnGetJieShiRecArray(JieShiRecArray) = False then
    begin
      m_strLastError := 'У��д�����ʧ��,�޷�����!';
      Exit;
    end;
  end
  else
  begin
    m_strLastError := 'δ���ö����ӿ�!�޷��鿨!';
    Exit;
  end;

  try
    if CheckWriteSuccess(JieShiRecArray) = False then
    begin
      m_strLastError := 'У��д�����ʧ��!������д��.';
      Exit;
    end;
  except
    on E: Exception do
    begin
      m_strLastError := 'У��д���������,����:('+E.Message+')';
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
{����:��ʼ��д�����ڿؼ��������}
begin
  //�ͻ��ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbKeHuo_TabOrders,[2,1]);
  //�ͳ��ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbKeChe_TabOrders,[16,0]);
  //�����ؼ��������
  SetIntArray(m_WriteICCarChildOrders.rbHuoChe_TabOrders,[16,1]);
  //����ͷ������ؼ��������
  SetIntArray(m_WriteICCarChildOrders.cbxCheCiTou_TabOrders,[3]);
  //���κſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtCheCiNumber_TabOrders,[21]);
  //˾���ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders,[25]);
  //��˾���ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders,[23]);
  //��·�ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders,[15]);
  //��վ�ſؼ��������
  SetIntArray(m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders,[14]);
  //д����ť�ؼ��������
  SetIntArray(m_WriteICCarChildOrders.btnWriteICCar_TabOrders,[11]);
  //������ť�ؼ��������
  SetIntArray(m_WriteICCarChildOrders.btnEraseICCar_TabOrders,[12]);
  //����ʾ�ļ��ؼ��������
  SetIntArray(m_WriteICCarChildOrders.btnReadJieShiFile_TabOrders,[7]);

end;


function TSiWeiIckglControler.OpenJieShiFile: Boolean;
{����:��ȡ��ʾ�ļ�}
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
      m_strLastError := '�޷���ȡ����ʾ�ļ���ť!';
      Exit;
    end;
    TWinCtrlAPIController.ClickButton(ControlHWND);
    
    //�ȴ��򿪴��ھ��
    //#32770 (�Ի���)
    FormHWND := TWinCtrlAPIController.WaitWindowRun(3000,'��','#32770');
    if FormHWND = 0 then
    begin
      m_strLastError := '�޷�������ʾ�ļ��򿪴���!';
      Exit;
    end;

    RefSleep(2000);

    SetIntArray(ControlNos,[8,0,0]);

    ControlHWND := TWinCtrlAPIController.GetChildHandle(FormHWND,ControlNos);

    if ControlHWND = 0 then
    begin
      m_strLastError := '�޷���ý�ʾ�ļ��������!';
      Exit;
    end;

    TWinCtrlAPIController.SetEditText(ControlHWND,m_JsFilename);

    RefSleep(1000);
    
    {���ȷ����ť}
    ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,12);

    if ControlHWND = 0 then
    begin
      m_strLastError := '�޷����ȷ����ʾ�ļ�����ť!';
      Exit;
    end;

    TWinCtrlAPIController.ClickButton(ControlHWND);
  end;
  
  Result := True;
end;

function TSiWeiIckglControler.SetCheCiTou: Boolean;
{����:���ó���ͷ}
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
    m_strLastError := '�޷��ҵ�����ͷ������!';
    Exit;
  end;

  strCheCiTou := WriteICCarDutyInfo.CheCiTou;
  if strCheCiTou = '' then
    strCheCiTou := '��';

  if TWinCtrlAPIController.SetComboSelect(ControlHWND,strCheCiTou) = False then
  begin
    m_strLastError := '�޷����ó���ͷ('+strCheCiTou+')';
    Exit;
  end;
  Result := True;
end;

function TSiWeiIckglControler.UpdateJieShi: Boolean;
{����:���½�ʾ,IC��������Ҫ���½�ʾ,����ֱ�ӷ���True}
begin
  Result := True;
end;

function TSiWeiIckglControler.WriteCard:Boolean;
begin
  Result := False;

  //����д������
  StateNotice('��������д��ģ��......');
  if RunWriteICCarProgram() = False then exit;
  RefSleep(3000);
  try
    //��д������
    StateNotice('д��ģ�������ɹ�,���ڴ�д������......');
    if OpenICKGLWriteCardFrm() = False then exit;
    RefSleep(1000);

    //��д����Ϣ
    if SetICKGLDutyInfo() = False then Exit;
    RefSleep(1000);
    StateNotice('������Ϣ�ύ�ɹ�,���ڴ򿪽�ʾ�ļ�......');

    //�򿪽�ʾ�ļ�
    if OpenJieShiFile() = False then Exit;
    RefSleep(1000);
    StateNotice('��ʾ�ļ��򿪳ɹ�,����д��......');

    //д��
    if WriteJieShi() = False Then Exit;
    RefSleep(1000);
    StateNotice('д���ɹ�,����У��д�����......');

    //У��д�����
    if CheckWriteICCarSuccess = False then Exit;
    RefSleep(1000);
    StateNotice('д�����,���ڹر�д��ģ��......');
    
    Result := True;
   
  finally
    CloseWriteICCarProgram;
  end;

end;

function TSiWeiIckglControler.WriteJieShi: Boolean;
{����:д��ʾ��Ϣ}
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
    m_strLastError := '�޷���ȡд����ť!';
    exit;
  end;

  TWinCtrlAPIController.ClickButton(ControlHWND);

  Sleep(1000);

  FormHWND :=
      TWinCtrlAPIController.WaitWindowRun(30000,'IC��ת������','TMessageForm');

  if FormHWND = 0 then
  begin
    m_strLastError := 'д������Ӧ,������д��!';
    exit;
  end;

  PostMessage(FormHWND,WM_Close,0,0);
  Result := True;

end;

end.
