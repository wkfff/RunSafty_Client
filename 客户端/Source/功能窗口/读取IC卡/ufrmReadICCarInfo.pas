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
  {RICCarAllInfo IC卡的全部信息结构体}
  RICCarAllInfo = Record
    {出勤信息}
    DutyInfo : RDutyInfo;
    {运行记录文件信息}
    RuntimeInfoArray : TRuntimeInfoArray;
    {揭示信息}
    JieShiRecArray : TICCJieShiRecArray;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TICCarReadThread IC卡读取线程
  //////////////////////////////////////////////////////////////////////////////
  TICCarReadThread = class(TThread)
  public
    constructor Create(ICCardReader: TICCardReader);
  private
    { Private declarations }
    m_Result : TConnectResult;//执行结果
    m_strResultMessage : String;//执行消息
    m_DutyInfo : RDutyInfo;//出勤信息
    m_RuntimeInfoArray : TRuntimeInfoArray;//运行记录
    m_JieShiRecArray : TICCJieShiRecArray;//揭示信息
    m_ICCardReader: TICCardReader;//IC卡读取对象
    {要读取的卡内信息}
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
    {最后一次错误信息}
    m_strLastError : String;
    {要读取的卡内信息}
    m_ICCarInfo : TICCarInfo;
    {IC卡复位次数}
    m_nResetCount : Integer;
    procedure OnICCarReadThreadTerminate(Sender:TObject);
    {功能：接收IC卡读取成功的消息通知}
    procedure WMICCarReadSuccess(var Message: TMessage);
        message WM_ICCAR_READ_SUCCESS;
    {功能：接收IC卡读取失败的消息通知}
    procedure WMICCarReadFailure(var Message: TMessage);
        message WM_ICCAR_READ_FAILURE;
  public
  end;

  {功能:读取IC卡内的信息}
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
//功能:线程执行完毕通知事件
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
//功能:IC卡读取失败
begin
{  if m_nResetCount < 2 then
  begin
    GlobalDM.ICCardReader.CloseReaderDev;
    Inc(m_nResetCount);
    Timer.Interval := 10000;
    Timer.Enabled := True;
    Exit;
  end;}
  Box('IC卡读取失败!错误:('+m_strLastError+')');
  Close;
end;

procedure TfrmReadICCarInfo.WMICCarReadSuccess(var Message: TMessage);
//功能:IC卡读取成功
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
      {清空临时运行记录目录中的文件}
      ClearDirFile(ExtractFilePath(Application.ExeName)+TEMP_RUNTIMEFILE_DIRNAME);
      {下载运行记录文件}
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
