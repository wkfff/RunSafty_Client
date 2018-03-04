unit ufrmManualCall2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,uRoom,uUDPControl;
const
  WM_MESSAGE_FORMSHOW = WM_USER + 10;
  WM_BeginCall = WM_User + 1;
  WM_EndCall = WM_User + 4;
  WM_CallSucceed = WM_User + 2;
  WM_CallFail = WM_User + 3;
  WM_HangSucceed = WM_User + 5;
  WM_HangFail = WM_User + 6;
  WM_Message_EndPlay = WM_User + 7;
type
  TThreadManualThread = class(TThread)
  public
    procedure Execute;override;
  private
    m_OnExecute : TNotifyEvent;
  public
    property OnExecute : TNotifyEvent read m_OnExecute write m_OnExecute;
  end;
  TfrmManualCall2 = class(TForm)
    Label1: TLabel;
    ListView1: TListView;
    btnPlayMusic: TButton;
    btnCall: TButton;
    Label2: TLabel;
    btnCancelCall: TButton;
    btnHangCall: TButton;
    edtRoomNumber: TEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelCallClick(Sender: TObject);
    procedure btnHangCallClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnPlayMusicClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtRoomNumberChange(Sender: TObject);
  private
    { Private declarations }

    m_dbRoom : TDBRoomOperate ;
    m_arrayRoom : RRoomArray ;

    m_strRoomNo : string;
    m_nDeviceNo : Integer;
    m_strTrainNo : string;

    m_CallThread : TThreadManualThread;
    m_PlayThread : TThreadManualThread;
    m_bCall : boolean;
    m_bCancel : boolean;
    procedure InitRoomCbb();
    procedure RefreshRooms(RoomArray: RRoomArray);
    procedure WMMESSAGEFORMSHOW(var Message : TMessage);message WM_MESSAGE_FORMSHOW;
    procedure WMBeginCall(var MSG : TMessage) ; message WM_BeginCall;
    procedure WMCallSucceed(var Msg : TMessage) ; message WM_CallSucceed;
    procedure WMCallFail(var Msg : TMessage) ; message WM_CallFail;
    PROCEDURE WMEndCall(var Msg : TMessage);message WM_EndCall;
    PROCEDURE WMHangSucceed(var Msg : TMessage);message WM_HangSucceed;
    PROCEDURE WMHangFail(var Msg : TMessage);message WM_HangFail;



    PROCEDURE WMMessageEndPlay(var Msg : TMessage);message WM_Message_EndPlay;
  public
    { Public declarations }
    procedure OnCall(Sender : TObject);
    procedure OnPlayMusic(Sender : TObject);
  end;

var
  frmManualCall2: TfrmManualCall2;

implementation
uses
  uCallRoomDM,uGlobalDM;
{$R *.dfm}

procedure TfrmManualCall2.btnCallClick(Sender: TObject);
begin
  if ListView1.Selected = nil then
  begin
    Application.MessageBox('请选择要呼叫的房间','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Integer(ListView1.Selected.Data) = 0 then
  begin
    Application.MessageBox('该房间还未安装设备','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if DMCallRoom.Comming then
  begin
    Application.MessageBox('叫班中，请勿重复叫班！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  
  edtRoomNumber.Enabled := false;
  btnCancelCall.Enabled := true;
  btnPlayMusic.Enabled := false;
  btnHangCall.Enabled := false;

  ListView1.Enabled := false;
  btnCall.Enabled := false;
  
  m_bCall := true;
  m_CallThread := TThreadManualThread.Create(true);
  m_CallThread.OnExecute := OnCall;
  m_CallThread.Resume;
end;

procedure TfrmManualCall2.btnCancelCallClick(Sender: TObject);
begin
 try
    if m_CallThread <> nil then
    begin
      btnCancelCall.Enabled := false;
      m_bCancel := true;
    end;
  finally
    
  end;
end;

procedure TfrmManualCall2.btnHangCallClick(Sender: TObject);
begin
  m_bCall := false;
  btnHangCall.Enabled := false;
  btnPlayMusic.Enabled := false;
  m_CallThread := TThreadManualThread.Create(true);
  m_CallThread.OnExecute := OnCall;
  m_CallThread.Resume;
end;

procedure TfrmManualCall2.btnPlayMusicClick(Sender: TObject);
begin
  if ListView1.Selected = nil then
  begin
    Application.MessageBox('请选择要呼叫的房间','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Integer(ListView1.Selected.Data) = 0 then
  begin
    Application.MessageBox('该房间还未安装设备','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
 

  m_PlayThread := TThreadManualThread.Create(true);
  m_PlayThread.OnExecute :=OnPlayMusic;
  m_PlayThread.Resume;
  btnHangCall.Enabled := false;
  btnPlayMusic.Enabled := false;
end;

procedure TfrmManualCall2.edtRoomNumberChange(Sender: TObject);
begin
  InitRoomCbb ;
end;

procedure TfrmManualCall2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TfrmManualCall2.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not btnCall.Enabled then
  begin
    Application.MessageBox(PChar(Format('请先挂断房间%s的通话。',[ListView1.Selected.Caption]))
      ,'提示',mb_ok + MB_ICONINFORMATION);
    CanClose := false;
    exit;
  end;
end;

procedure TfrmManualCall2.FormCreate(Sender: TObject);
begin
  m_bCall := false;
  m_bCancel := false;

  btnCancelCall.Enabled := false;
  btnPlayMusic.Enabled := false;
  btnHangCall.Enabled := false;

  ListView1.Enabled := true;
  btnCall.Enabled := true;

  m_dbRoom := TDBRoomOperate.Create(GlobalDM.LocalADOConnection);
end;

procedure TfrmManualCall2.FormDestroy(Sender: TObject);
begin
  if assigned(m_dbRoom) then
    FreeAndNil(m_dbRoom);
end;

procedure TfrmManualCall2.FormShow(Sender: TObject);
begin
  PostMessage(Handle,WM_MESSAGE_FORMSHOW,0,0);
end;

procedure TfrmManualCall2.InitRoomCbb();
var
  strRoomNumber:string ;
begin
  strRoomNumber := edtRoomNumber.Text ;
  SetLength(m_arrayRoom, 0);
  m_dbRoom.QueryRooms(strRoomNumber,m_arrayRoom);
  RefreshRooms(m_arrayRoom);
end;

procedure TfrmManualCall2.OnCall(Sender: TObject);
var
  ncallSucceed : integer;
  nDeviceID : Integer ;
  room : PRoom ;
begin
  ncallSucceed := 0;
  DMCallRoom.Comming := True;
  PostMessage(Handle,WM_BeginCall,0,0);
  try
    m_bCancel := false;
    if m_bCall then
    begin

      if not DMCallRoom.SerialConnected then
      begin
        PostMessage(Handle,WM_CallFail,1,0);
        exit;
      end;
      room :=  PRoom (ListView1.Selected.Data) ;
      nDeviceID := room^.nDeveiveID ;
      if DMCallRoom.AutoConnectCall(ListView1.Selected.Caption,'',nDeviceID,m_bCancel,false) then
      begin
        ncallSucceed := 1;
        PostMessage(Handle, WM_CallSucceed,0,0)
      end
      else begin
        PostMessage(Handle,WM_CallFail,0,0);
      end;
    end
    else begin
      if DMCallRoom.HangCall then
      begin
        ncallSucceed := 1;
        PostMessage(Handle,WM_HangSucceed,0,0);
      end
      else begin
        PostMessage(Handle,WM_HangFail,0,0);
      end;
    end;
  finally
    DMCallRoom.Comming := False;
    PostMessage(Handle, WM_EndCall,ncallSucceed,0);
  end;
end;

procedure TfrmManualCall2.OnPlayMusic(Sender: TObject);
begin
  DMCallRoom.PlayFirstCall(ListView1.Selected.Caption, '');
  PostMessage(Handle,WM_Message_EndPlay,0,0);
end;

procedure TfrmManualCall2.RefreshRooms(RoomArray: RRoomArray);
var
  item : TListItem;
  i: Integer ;
begin
  ListView1.Items.Clear;
  for I := 0 to Length(RoomArray) - 1 do
  begin
    item := ListView1.Items.Add;
    item.Caption := RoomArray[i].RoomNumber;
    item.SubItems.Add(IntToStr( RoomArray[i].nDeveiveID ));
    item.SubItems.Add(IntToStr( RoomArray[i].MaxCount ) );
    item.Data := @RoomArray[i];
  end;
end;

procedure TfrmManualCall2.WMMessageEndPlay(var Msg: TMessage);
begin
  FreeAndNil(m_PlayThread);
  btnPlayMusic.Enabled := true;
  btnHangCall.Enabled := true;
end;

procedure TfrmManualCall2.WMMESSAGEFORMSHOW(var Message: TMessage);
begin
  InitRoomCbb();
end;

procedure TfrmManualCall2.WMBeginCall(var MSG: TMessage);
begin
  Caption :=  '通信中，请稍后....';
end;

procedure TfrmManualCall2.WMCallFail(var Msg: TMessage);
begin
  if not m_bCancel  then
  begin
    if Msg.WParam = 1 then
      Application.MessageBox('串口未连接，呼叫失败.','提示',MB_OK + MB_ICONINFORMATION)
    else
      Application.MessageBox('连接异常，呼叫失败.','提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmManualCall2.WMCallSucceed(var Msg: TMessage);
begin
  Caption := ('呼叫成功....');
end;

procedure TfrmManualCall2.WMEndCall(var Msg: TMessage);
begin
  FreeAndNil(m_CallThread);
   m_bCancel := false;
  if m_bCancel then
  begin
    DMCallRoom.HangCall;
    Caption := '取消呼叫...';
    Application.MessageBox('呼叫取消成功.','提示',MB_OK + MB_ICONINFORMATION);
  end;

  if m_bCall then
  begin
    ////呼叫操作
    if msg.WParam = 1 then
    begin
      //呼叫成功
      btnCancelCall.Enabled := false;
      btnPlayMusic.Enabled := true;
      btnHangCall.Enabled := true;

      ListView1.Enabled := false;
      btnCall.Enabled := false;
    end else begin
      //呼叫失败
      btnCancelCall.Enabled := false;
      btnPlayMusic.Enabled := false;
      btnHangCall.Enabled := false;

      ListView1.Enabled := true;
      btnCall.Enabled := true;
      edtRoomNumber.Enabled := true;
    end;
  end else begin
    ////挂断操作
    if msg.WParam = 1 then
    begin
      //挂断成功
      btnCancelCall.Enabled := false;
      btnPlayMusic.Enabled := false;
      btnHangCall.Enabled := false;

      ListView1.Enabled := true;
      btnCall.Enabled := true;
      edtRoomNumber.Enabled := true;
    end else begin
      //挂断失败
      btnCancelCall.Enabled := false;
      btnPlayMusic.Enabled := false;
      btnHangCall.Enabled := false;

      ListView1.Enabled := true;
      btnCall.Enabled := true;
      edtRoomNumber.Enabled := true;
    end;
  end;
end;

procedure TfrmManualCall2.WMHangFail(var Msg: TMessage);
begin
  if not m_bCancel then  
    Application.MessageBox('连接异常，挂断失败.','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmManualCall2.WMHangSucceed(var Msg: TMessage);
begin
  Caption := ('挂断成功....');
end;
{ TThreadManualThread }

procedure TThreadManualThread.Execute;
begin
  if Assigned(m_OnExecute) then
    m_OnExecute(Self);
end;

end.
