unit ufrmReadICCarInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, fe_flashole, fe_flashwnd, fe_flashplayer,uICCDefines,
  uGlobalDM,uICCardReader,ActiveX,uTFSystem, RzPanel, StdCtrls, RzAnimtr,
  ImgList, PngImageList;

const
  WM_ICCAR_READ_SUCCESS = WM_USER+1010;
  WM_ICCAR_READ_FAILURE = WM_USER+1011;
  TEMP_RUNTIMEFILE_DIRNAME = 'RuntimeFile';

type
  ICCarInfo = (ciDutyInfo,ciRuntimeInfo,ciJieShi,ciDownRuntimeInfo);
  TICCarInfo = Set of ICCarInfo;
  TConnectResult = (crSuccess,crFailure);
  {RICCarAllInfo IC����ȫ����Ϣ�ṹ��}
  RICCarAllInfo = Record
    {������Ϣ}
    DutyInfo : RDutyInfo;
    {���м�¼�ļ���Ϣ}
    RuntimeInfoArray : TRuntimeInfoArray;
    {��ʾ��Ϣ}
    JieShiRecArray : TICCJieShiRecArray;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TICCarReadThread IC����ȡ�߳�
  //////////////////////////////////////////////////////////////////////////////
  TICCarReadThread = class(TThread)
  public
    constructor Create(ICCardReader: TICCardReader);
  private
    { Private declarations }
    m_Result : TConnectResult;//ִ�н��
    m_strResultMessage : String;//ִ����Ϣ
    m_DutyInfo : RDutyInfo;//������Ϣ
    m_RuntimeInfoArray : TRuntimeInfoArray;//���м�¼
    m_JieShiRecArray : TICCJieShiRecArray;//��ʾ��Ϣ
    m_ICCardReader: TICCardReader;//IC����ȡ����
    {Ҫ��ȡ�Ŀ�����Ϣ}
    m_ICCarInfo : TICCarInfo;
  protected
    procedure Execute; override;
  public
    property Result : TConnectResult read m_Result;
    property ResultMessage : string read m_strResultMessage;

    property DutyInfo : RDutyInfo read m_DutyInfo;
    property RuntimeInfoArray : TRuntimeInfoArray read m_RuntimeInfoArray;
    property JieShiRecArray : TICCJieShiRecArray read m_JieShiRecArray;

  end;


  TfrmReadICCarInfo = class(TForm)
    Timer: TTimer;
    RzPanel1: TRzPanel;
    Label1: TLabel;
    RzAnimator1: TRzAnimator;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    m_ICCarAllInfo : RICCarAllInfo;
    {���һ�δ�����Ϣ}
    m_strLastError : String;
    {Ҫ��ȡ�Ŀ�����Ϣ}
    m_ICCarInfo : TICCarInfo;
    {IC����λ����}
    m_nResetCount : Integer;
    procedure OnICCarReadThreadTerminate(Sender:TObject);
    {���ܣ�����IC����ȡ�ɹ�����Ϣ֪ͨ}
    procedure WMICCarReadSuccess(var Message: TMessage);
        message WM_ICCAR_READ_SUCCESS;
    {���ܣ�����IC����ȡʧ�ܵ���Ϣ֪ͨ}
    procedure WMICCarReadFailure(var Message: TMessage);
        message WM_ICCAR_READ_FAILURE;
  public
  end;

  {����:��ȡIC���ڵ���Ϣ}
  function ReadIcCardInfo(var ICCarAllInfo : RICCarAllInfo ;
      ICCarInfo:TICCarInfo):Boolean;

implementation

{$R *.dfm}


{ TfrmReadIcRead }

procedure TfrmReadICCarInfo.FormCreate(Sender: TObject);
begin
  m_nResetCount := 0;
end;

procedure TfrmReadICCarInfo.OnICCarReadThreadTerminate(Sender: TObject);
//����:�߳�ִ�����֪ͨ�¼�
begin
  if TICCarReadThread(Sender).Result = crSuccess then
  begin
    m_ICCarAllInfo.RuntimeInfoArray := TICCarReadThread(Sender).m_RuntimeInfoArray;
    m_ICCarAllInfo.JieShiRecArray := TICCarReadThread(Sender).m_JieShiRecArray;
    m_ICCarAllInfo.DutyInfo := TICCarReadThread(Sender).m_DutyInfo;
    m_strLastError := TICCarReadThread(Sender).m_strResultMessage;
    PostMessage(Handle,WM_ICCAR_READ_SUCCESS,0,0)
  end
  else
  begin
    PostMessage(Handle,WM_ICCAR_READ_FAILURE,0,0);
  end;
end;

procedure TfrmReadICCarInfo.TimerTimer(Sender: TObject);
var
  ICCarReadThread : TICCarReadThread;
begin
  Timer.Enabled := False;

  try
    GlobalDM.ICCardReader.InitReaderDev(GlobalDM.ICardReaderType);
  except
    on E: Exception do
    begin
      m_strLastError := E.Message;
      PostMessage(Handle,WM_ICCAR_READ_FAILURE,0,0);
      Exit;
    end;
  end;

  ICCarReadThread := TICCarReadThread.Create(GlobalDM.ICCardReader);
  ICCarReadThread.OnTerminate := OnICCarReadThreadTerminate;
  ICCarReadThread.m_ICCarInfo := m_ICCarInfo;
  ICCarReadThread.Resume;
  
end;

procedure TfrmReadICCarInfo.WMICCarReadFailure(var Message: TMessage);
//����:IC����ȡʧ��
begin
{  if m_nResetCount < 2 then
  begin
    GlobalDM.ICCardReader.CloseReaderDev;
    Inc(m_nResetCount);
    Timer.Interval := 10000;
    Timer.Enabled := True;
    Exit;
  end;}
  Box('IC����ȡʧ��!����:('+m_strLastError+')');
  Close;
end;

procedure TfrmReadICCarInfo.WMICCarReadSuccess(var Message: TMessage);
//����:IC����ȡ�ɹ�
begin
  ModalResult := mrok;
end;

{ TICCarReadThread }

constructor TICCarReadThread.Create(ICCardReader: TICCardReader);
begin
  inherited Create(True);
  m_ICCardReader := ICCardReader;
end;

procedure TICCarReadThread.Execute;
var
  ICCarReadLogs : TStringList;
begin
  FreeOnTerminate := True;
  CoInitialize(nil);
  try
    if ciDutyInfo in m_ICCarInfo then
      m_DutyInfo := m_ICCardReader.ReadDutyInfo;

    if ciRuntimeInfo in m_ICCarInfo then
      m_RuntimeInfoArray := m_ICCardReader.GetRuntimezfileInfo;

    if (ciRuntimeInfo in m_ICCarInfo) And
      (ciDownRuntimeInfo in m_ICCarInfo) then
    begin
      {�����ʱ���м�¼Ŀ¼�е��ļ�}
      ClearDirFile(ExtractFilePath(Application.ExeName)+TEMP_RUNTIMEFILE_DIRNAME);
      {�������м�¼�ļ�}
      if DirectoryExists(ExtractFilePath(Application.ExeName)+TEMP_RUNTIMEFILE_DIRNAME) = false then
        Mkdir(ExtractFilePath(Application.ExeName)+TEMP_RUNTIMEFILE_DIRNAME);

       GlobalDM.ICCardReader.OutputSelectRuntimeFile(
          ExtractFilePath(Application.ExeName)+TEMP_RUNTIMEFILE_DIRNAME,m_RuntimeInfoArray);
    end;

    if ciJieShi in m_ICCarInfo then
      m_JieShiRecArray := m_ICCardReader.ReadJieShiInfo;

    m_Result := crSuccess;
  except
    On E:Exception Do
    begin
      m_Result := crFailure;
      ICCarReadLogs := TStringList.Create;
      try

        if FileExists(ExtractFilePath(Application.ExeName) + 'ICCarReadError.log') then
          ICCarReadLogs.LoadFromFile(ExtractFilePath(Application.ExeName) + 'ICCarReadError.log');

        ICCarReadLogs.Add(formatDateTime('[yyyy-mm-dd hh:nn:ss] ',Now)+E.Message);

        ICCarReadLogs.SaveToFile(ExtractFilePath(Application.ExeName) + 'ICCarReadError.log');
      finally
        ICCarReadLogs.Free;
      end;
      m_strResultMessage := E.Message;
    end;
  end;
  CoUninitialize;
end;

end.
