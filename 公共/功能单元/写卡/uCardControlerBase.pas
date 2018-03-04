unit uCardControlerBase;

interface

uses
  Classes,Windows,uWinCtrlAPIController,ShellApi,Messages,uProcedureControl,
  SysUtils,Forms,uTFSystem,uWriteICCarSoftDefined;


Const

  {$region '����Ա��¼����'}
  //��¼�������
  LoginForm_Title = '��������';
  //��¼����ִ�п�ݼ�
  LoginForm_ShortCut = VK_F2;
  //��¼��������������
  LoginForm_PasswordOffset = 2;
  //��¼�����а�ť���
  LoginForm_ConfirmOffset = 1;
  {$endregion}

  {$region 'ֵ��Ա��¼'}
  AttendantLoginShortCut = VK_F1;
  AttendantLoginForm_Title = 'ֵ��Ա��¼';
  AttendantLoginForm_ClassName = 'Tw_zby';

  {ֵ��Ա���������������}
  AttendantNumberEditNO = 4;
  {ֵ��Ա���������������}
  AttendantPassWordEditNO = 1;
  {ȷ�ϰ�ť�������}
  btnConfirmNO = 2;
  {$ENDREGION}

  CardForm_Title = '����Ա���ڹ���';

type

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TCardContorler
  /// ����:д��������ÿ���������
  //////////////////////////////////////////////////////////////////////////////
  TCardContorler = class
  public
    constructor Create();virtual;
    function WriteCard():Boolean;virtual;abstract;
    {����:׼��д��}
    procedure ReadyWrite();virtual;abstract;
    function UpdateJieShi():Boolean;virtual; abstract;
  public
    {����:��ó�����Ϣ}
    function GetKDXKWriteICCarDutyInfo():RWriteICCarDutyInfo;
    {����:ֱ�ӻ��д�����ھ��}
    function GetWriteICCarHWND():HWND;virtual;abstract;
  protected
    {��ʾ�ļ�λ��}
    m_JSFileName : string;
    {д�����λ��}
    m_SoftFileName : string;
    {���һ�δ�����Ϣ}
    m_strLastError : String;
    {д�������ṹ��}
    m_WriteICCarParam : RWriteICCarParam;
    {д������ĸ��ִ��ھ��}
    m_SoftHandles : RSoftHandles;
    {д��״̬֪ͨ�¼�}
    m_OnStateNotice : TOnStateNotice;
  protected
    {д�����ڿؼ��������}
    m_WriteICCarChildOrders : RWriteICCarWindowChildOrders;
  protected
    {����:��д�����}
    function RunWriteICCarProgram():Boolean;
    {����:�ر�д�����}
    procedure CloseWriteICCarProgram();
    {����:��ʼ��д�����ڿؼ��������}
    procedure InitWriteICCarWindowControlNos();virtual;abstract;
    {����:����Ա��½}
    function AdminLogin():Boolean;
    {����:ֵ��Ա��¼}
    function AttendantLogin():Boolean;
    {����:�򿪿��д����д������}
    function OpenKDXKWriteCardFrm():Boolean;
    {����:��IC�������д������}
    function OpenICKGLWriteCardFrm():Boolean;
  protected
    {����:����ֵ��Ա����}
    function SetAttendantNumber():Boolean;
    {����:����ֵ��Ա����}
    function SetAttendantPassWord():Boolean;
    {����:ֵ��Աȷ�ϵ�¼}
    function SetAttendantConfirmLoging():Boolean;
    {����:���û����}
    function SetJWD():Boolean;virtual;
    {����:��ȡ�������Ϣ}
    procedure GetJWD(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:��������}
    function SetQuDuan():Boolean;virtual;
    {����:���������Ϣ}
    procedure GetQuDuan(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ÿͻ�}
    function SetKeHuo():Boolean;virtual;
    {����:��ȡ�ͻ���Ϣ}
    procedure GetKeHuo(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ó���ͷ}
    function SetCheCiTou():Boolean;virtual;
    {����:��ȡ����ͷ}
    procedure GetCheCiTou(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ó��κ�}
    function SetCheCiNumber():Boolean;virtual;
    {����:��ȡ���κ�}
    procedure GetCheCiNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:����˾����}
    function SetTrainmanNumber():Boolean;virtual;
    {����:��ȡ˾����}
    procedure GetTrainmanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ø�˾����}
    function SetSubTrainmanNumber():Boolean;virtual;
    {����:��ȡ��˾����}
    procedure GetSubTrainmanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ý�·��}
    function SetJiaoLuNumber():Boolean;virtual;
    {����:��ȡ��·��}
    procedure GetJiaoLuNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:���ó�վ��}
    function SetCheZhanNumber():Boolean;virtual;
    {����:��ȡ��վ��}
    procedure GetCheZhanNumber(var WriteICCarDutyInfo:RWriteICCarDutyInfo);virtual;
    {����:�ύд��}
    function SubmitWriteICCard():Boolean;
  protected
    {����:����ˢ��Sleep����}
    procedure RefSleep(nTimeCount : Integer);
    {����:״̬֪ͨ}
    procedure StateNotice(strCommand:String);
  public
    {����:����д�����ھ��}
    procedure SetWriteCardFormHandle(Hwd:HWND);
    {����:���ÿ��д��������Ϣ}
    function SetKDXKDutyInfo():Boolean;
    {����:����IC�����������Ϣ}
    function SetICKGLDutyInfo():Boolean;
  public
    {��¼��Ϣ}
    LoginInfo : RLoginInfo;
    {д��������Ϣ}
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
{����:����Ա��½}
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
    m_strLastError := '�޷��򿪹���Ա��½����!';
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
    m_strLastError := '����Ա��¼ʧ��!';
    Exit;
  end;

  Result := True;
end;

function TCardContorler.AttendantLogin: Boolean;
{���ܣ�ֵ��Ա��¼}
begin
  Result := False;

  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyDown,AttendantLoginShortCut,0);
  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyUP,AttendantLoginShortCut,0);

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
  Sleep(500);
  Result := True;
end;

procedure TCardContorler.CloseWriteICCarProgram;
{����:�ر�д�����}
var
  i : Integer;
begin
  /////////////////////////////////////////////////////////////////////////////
  ///  �������ڷ��͹ر���Ϣ
  /////////////////////////////////////////////////////////////////////////////
  PostMessage(m_SoftHandles.MainFormHandle,WM_CLOSE,0,0);
  /////////////////////////////////////////////////////////////////////////////
  ///  �ȴ������ھ����ʧ,�����˳�,����3��Ļ�ֱ�ӹرս���
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
{����:��ȡ���κ�}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheCiNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ����κſؼ�!';
    Exit;
  end;

  WriteICCarDutyInfo.CheCiNumber :=
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetCheCiTou(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ����ͷ}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheCiTou_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�����ͷ�༭��!';
    Exit;
  end;

  WriteICCarDutyInfo.CheCiTou :=
    TWinCtrlAPIController.GetEditText(ControlHWND);

end;

procedure TCardContorler.GetCheZhanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ��վ��}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtCheZhanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ���վ�ſؼ�!';
    Exit;
  end;

  WriteICCarDutyInfo.CheZhanHao :=
      TWinCtrlAPIController.GetEditText(ControlHWND)
      
end;

procedure TCardContorler.GetJiaoLuNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ��·��}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtJiaoLuNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ���·�ſؼ�!';
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
    m_strLastError := '�޷��ҵ������α�ؼ�!';
    Exit;
  end;

  WriteICCarDutyInfo.DName := TWinCtrlAPIController.GetEditText(ControlHWND);
end;

function TCardContorler.GetKDXKWriteICCarDutyInfo: RWriteICCarDutyInfo;
{����:��ó�����Ϣ}
begin
  //��ȡ�����
  GetJWD(Result);
  //��ȡ����
  GetQuDuan(Result);
  //��ȡ�ͻ�
  GetKeHuo(Result);
  //��ȡ����ͷ
  GetCheCiTou(Result);
  //���ó��κ�
  GetCheCiNumber(Result);
  //����˾����
  GetTrainmanNumber(Result);
  //���ø�˾����
  GetSubTrainmanNumber(Result);
  //���ý�·��
  GetJiaoLuNumber(Result);
  //���ó�վ��
  GetCheZhanNumber(Result);
end;

procedure TCardContorler.GetKeHuo(var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ�ͻ���Ϣ}
var
  ControlHWND : HWND;
begin
  //����Ƿ�Ϊ����
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbHuoChe_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khHuoChe;

  //����Ƿ�Ϊ�ͳ�
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbKeChe_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khKeChe;

  //����Ƿ�Ϊ�ͻ�
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,m_WriteICCarChildOrders.rbKeHuo_TabOrders);

  if IsDlgButtonChecked(GetParent(ControlHWND), GetDlgCtrlID(ControlHWND)) = BST_CHECKED then
    WriteICCarDutyInfo.KeHuo := khKeHuo;

end;

procedure TCardContorler.GetQuDuan(var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:���������Ϣ}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.cbxQuDuan_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ��������οؼ�!';
    Exit;
  end;

  WriteICCarDutyInfo.QuDuan := TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetSubTrainmanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ��˾����}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ���˾���ſؼ�!';
    Exit;
  end;
  
  WriteICCarDutyInfo.SubTrainmanNumber :=
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

procedure TCardContorler.GetTrainmanNumber(
  var WriteICCarDutyInfo: RWriteICCarDutyInfo);
{����:��ȡ˾����}
var
  ControlHWND : HWND;
begin
  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�˾���ſؼ�!';
    Exit;
  end;
  WriteICCarDutyInfo.TrainmanNumber := 
      TWinCtrlAPIController.GetEditText(ControlHWND);
end;

function TCardContorler.OpenICKGLWriteCardFrm: Boolean;
{����:��IC�������д������}
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
    m_strLastError := '�޷��ҵ�������Ϣ��ť!';
    exit;
  end;
  TWinCtrlAPIController.ClickButton(ChildHWND);
  m_SoftHandles.WriteCardFormHandle :=
      TWinCtrlAPIController.WaitWindowRun(5000,'������Ϣ','');
  if m_SoftHandles.WriteCardFormHandle = 0 then
  begin
    m_strLastError := '�޷��򿪳�����Ϣ����!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.OpenKDXKWriteCardFrm: Boolean;
{���ܣ���д������}
begin
  Result := False;

  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyDown,VK_F5,0);
  PostMessage(m_SoftHandles.MainFormHandle,WM_KeyUP,VK_F5,0);

  m_SoftHandles.WriteCardFormHandle :=
      TWinCtrlAPIController.WaitWindowRunEx(m_WriteICCarParam.WaitTimeOut,
        CardForm_Title);

  if m_SoftHandles.WriteCardFormHandle = 0 then
  begin
    m_strLastError := '�ȴ�д�����ڳ�ʱ!';
    Exit;
  end;

  Result := True;

end;

procedure TCardContorler.RefSleep(nTimeCount: Integer);
{����:����ˢ��Sleep����}
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
{����:��д�����}
begin
  Result := False;

  if FileExists(m_SoftFileName) = False then
  begin
    m_strLastError := 'д�����������!';
    Exit;
  end;

  //��������Ѿ�����,��ô���ȹر�,Ȼ���ٴ�
  m_SoftHandles.MainFormHandle :=
      TWinCtrlAPIController.GetFormHandleEx(m_WriteICCarParam.MainFormTitle);

  if m_SoftHandles.MainFormHandle <> 0 then
    CloseWriteICCarProgram();

  if ShellExecute(0,'Open',PChar(m_SoftFileName),nil,nil,SW_SHOWNORMAl) <= 32 then
  begin
    m_strLastError := '����д�����ʧ��!';
    Exit;
  end;

  m_SoftHandles.MainFormHandle :=
      TWinCtrlAPIController.WaitWindowRunEx(
          m_WriteICCarParam.WaitRunWriteICCarProgramTimeOut,
          m_WriteICCarParam.MainFormTitle);

  if m_SoftHandles.MainFormHandle = 0 then
  begin
    m_strLastError := '����д�����ʧ��!';
    Exit;
  end;

  Result := True;
end;



function TCardContorler.SetAttendantConfirmLoging: Boolean;
{����:ֵ��Աȷ�ϵ�¼}
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
    m_strLastError := 'ֵ��Ա��¼ʧ��!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.SetAttendantNumber: Boolean;
{����:����ֵ��Ա����}
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
      m_strLastError := '�޷��ҵ�ֵ��Ա���������!';
      Exit;
    end;
    
    TWinCtrlAPIController.SetEditText(ControlHWND,LoginInfo.OndutyPersonID);
  end;
  Result := True;
end;

function TCardContorler.SetAttendantPassWord: Boolean;
{����:����ֵ��Ա����}
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
      m_strLastError := '�޷��ҵ�ֵ��Ա���������!';
      Exit;
    end;
    TWinCtrlAPIController.SetEditText(ControlHWND,LoginInfo.OndutyPersonPWD);
  end;
  Result := True;
end;

procedure TCardContorler.StateNotice(strCommand: String);
{����:״̬֪ͨ}
begin
  if Assigned(m_OnStateNotice) then
    m_OnStateNotice(strCommand);
end;

function TCardContorler.SubmitWriteICCard: Boolean;
{���ܣ��ύд��}
var
  ChildHandle : HWND;
begin
  Result := False;
  ChildHandle := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.btnWriteICCar_TabOrders);
  if ChildHandle = 0 then
  begin
    m_strLastError := '�޷��Ҵ�д����ť!';
    Exit;
  end;
  //ִ��д��
  TWinCtrlAPIController.ClickButton(ChildHandle);
  Result := True;
end;

function TCardContorler.SetCheCiNumber: Boolean;
{����:���ó��κ�}
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
      m_strLastError := '�޷��ҵ����κſؼ�!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        WriteICCarDutyInfo.CheCiNumber) = False then
    begin
      m_strLastError := '���κ���дʧ��!';
      Exit;
    end;
  end;

  Result := True;
end;

function TCardContorler.SetCheCiTou: Boolean;
{����:���ó���}
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
      m_strLastError := '�޷��ҵ�����ͷ�༭��!';
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
      m_strLastError := '�޷��ҵ�����ͷ������!';
      Exit;
    end;
    if TWinCtrlAPIController.SetComboSelect(ControlHWND,
        WriteICCarDutyInfo.CheCiTou) = False then
    begin
      m_strLastError := '�޷����ó���ͷ('+WriteICCarDutyInfo.CheCiTou+')';
      Exit;
    end;
  end;
  Result := True;
end;

function TCardContorler.SetCheZhanNumber: Boolean;
{����:���ó�վ��}
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
      m_strLastError := '�޷��ҵ���վ�ſؼ�!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        PChar(WriteICCarDutyInfo.CheZhanHao)) = False then
    begin
      m_strLastError := '���ó�վ��('+WriteICCarDutyInfo.CheZhanHao+')ʧ��!';
      Exit;
    end;
    
  end;
  Result := True;
end;

function TCardContorler.SetICKGLDutyInfo: Boolean;
{����:����IC�����������Ϣ}
begin
  Result := False;
  
  //���ÿͻ�
  if SetKeHuo() = False then Exit;
  RefSleep(300);

  {���ó���ͷ}
  if SetCheCiTou() = False then Exit;
  RefSleep(300);

  {���ó��κ�}
  if SetCheCiNumber() = False then Exit;
  RefSleep(300);

  {����˾����}
  if SetTrainmanNumber() = False then Exit;
  RefSleep(300);

  {���ø�˾����}
  if SetSubTrainmanNumber() = False then Exit;
  RefSleep(300);

  {���ý�·��}
  if SetJiaoLuNumber() = False then Exit;
  RefSleep(300);

  {���ó�վ��}
  if SetCheZhanNumber() = False then Exit;
  RefSleep(300);

  Result := True;
end;

function TCardContorler.SetKDXKDutyInfo: Boolean;
{���ܣ���д������Ϣ}
begin
  Result := False;

  RefSleep(1000);

  //���û����
  if SetJWD() = False then Exit;
  RefSleep(1000);

  //������������
  if SetQuDuan = False then Exit;
  RefSleep(1000);

  //���ÿͻ�
  if SetKeHuo() = False then Exit;
  RefSleep(300);

  {���ó���ͷ}
  if SetCheCiTou() = False then Exit;
  RefSleep(300);

  {���ó��κ�}
  if SetCheCiNumber() = False then Exit;
  RefSleep(300);

  {����˾����}
  if SetTrainmanNumber() = False then Exit;
  RefSleep(300);

  {���ø�˾����}
  if SetSubTrainmanNumber() = False then Exit;
  RefSleep(300);

  {���ý�·��}
  if SetJiaoLuNumber() = False then Exit;
  RefSleep(300);

  {���ó�վ��}
  if SetCheZhanNumber() = False then Exit;
  RefSleep(300);

  Result := True;

end;

function TCardContorler.SetJiaoLuNumber: Boolean;
{����:���ý�·��}
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
      m_strLastError := '�޷��ҵ���·�ſؼ�!';
      Exit;
    end;

    if TWinCtrlAPIController.SetEditText(ControlHWND,
        PChar(WriteICCarDutyInfo.JiaoLuHao)) = False then
    begin
      m_strLastError := '���ý�·��('+WriteICCarDutyInfo.JiaoLuHao+')ʧ��!';
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
    m_strLastError := '�޷��ҵ������α�ؼ�!';
    Exit;
  end;

  TWinCtrlAPIController.SetComboSelect(ControlHWND,WriteICCarDutyInfo.DName);

  RefSleep(2000);

  FormHWND := TWinCtrlAPIController.GetFormHandle('�α�ѡ��');

  if FormHWND <> 0 then
  begin
    ControlHWND := TWinCtrlAPIController.GetChildControlHandle(FormHWND,0);
    TWinCtrlAPIController.ClickButton(ControlHWND);
  end;

  RefSleep(2000);

  Result := True;
end;

function TCardContorler.SetKeHuo: Boolean;
{����:���ÿͻ�}
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
    m_strLastError := '�޷��ҵ��ͻ��ؼ�!';
    Exit;
  end;
  TWinCtrlAPIController.ClickButton(ControlHWND);
  Result := True;
end;

function TCardContorler.SetQuDuan: Boolean;
{����:��������}
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
    m_strLastError := '�޷��ҵ��������οؼ�!';
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
    m_strLastError := '�޷�ʹ����������('+WriteICCarDutyInfo.QuDuan+')!';
    Exit;
  end;
  Result := True;
end;

function TCardContorler.SetSubTrainmanNumber: Boolean;
{����:���ø�˾����}
var
  ControlHWND : HWND;
begin

  Result := False;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtSubTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ���˾���ſؼ�!';
    Exit;
  end;

  TWinCtrlAPIController.SetEditText(
      ControlHWND,WriteICCarDutyInfo.SubTrainmanNumber);

  Result := True;

end;

function TCardContorler.SetTrainmanNumber: Boolean;
{����:����˾����}
var
  ControlHWND : HWND;
begin

  Result := False;

  ControlHWND := TWinCtrlAPIController.GetChildHandle(
      m_SoftHandles.WriteCardFormHandle,
      m_WriteICCarChildOrders.edtTrainmanNumber_TabOrders);

  if ControlHWND = 0 then
  begin
    m_strLastError := '�޷��ҵ�˾���ſؼ�!';
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
