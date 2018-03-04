unit ufrmManualCall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uCallControl, ComCtrls, ExtCtrls, AdvSplitter,
  MPlayer, ImgList, RzPanel,PngSpeedButton;
const
  WM_BeginCall = WM_User + 1;
  WM_EndCall = WM_User + 4;
  WM_CallSucceed = WM_User + 2;
  WM_CallFail = WM_User + 3;
  WM_HangSucceed = WM_User + 5;
  WM_HangFail = WM_User + 6;
type
  TThreadManualThread = class(TThread)
  public
    procedure Execute;override;
  private
    m_OnExecute : TNotifyEvent;
  public
    CallButton: TSpeedButton;
    property OnExecute : TNotifyEvent read m_OnExecute write m_OnExecute;
  end;

  TfrmManualCall = class(TForm)
    Panel1: TRzPanel;
    RzPanel1: TRzPanel;
    checkPlayMusic: TCheckBox;
    btnCancelCall: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelCallClick(Sender: TObject);
  private
    { Private declarations }
    m_CallThread : TThreadManualThread;
    m_bCancel : boolean;
    procedure InitRoomCbb(roomContainer : TWinControl);
    procedure RefreshRoomsPos(roomContainer : TWinControl);
    procedure RefreshRoomsEnable(roomContainer : TWinControl);
    procedure OnRoomBtnClick(Sender : TObject);
    procedure WMBeginCall(var MSG : TMessage) ; message WM_BeginCall;
    procedure WMCallSucceed(var Msg : TMessage) ; message WM_CallSucceed;
    procedure WMCallFail(var Msg : TMessage) ; message WM_CallFail;
    PROCEDURE WMEndCall(var Msg : TMessage);message WM_EndCall;
    PROCEDURE WMHangSucceed(var Msg : TMessage);message WM_HangSucceed;
    PROCEDURE WMHangFail(var Msg : TMessage);message WM_HangFail;
  public
    { Public declarations }
    procedure OnCall(Sender : TObject);
  end;

var
  frmManualCall: TfrmManualCall;

implementation
uses uRoom, uDataModule, ADODB,uFrmMain;
{$R *.dfm}

procedure TfrmManualCall.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmManualCall.btnCancelCallClick(Sender: TObject);
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

procedure TfrmManualCall.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmManualCall.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
begin
  for i := 0 to Panel1.ControlCount - 1 do
  begin
    if TSpeedButton(Panel1.Controls[i]).Down then
    begin
      Application.MessageBox(PChar(Format('请先挂断房间%s的通话。',[TSpeedButton(Panel1.Controls[i]).Caption]))
        ,'提示',mb_ok + MB_ICONINFORMATION);
      CanClose := false;  
      exit;
    end;
  end;
end;

procedure TfrmManualCall.FormCreate(Sender: TObject);
begin
  InitRoomCbb(Panel1);
  RefreshRoomsPos(Panel1);
  RefreshRoomsEnable(Panel1);
end;


procedure TfrmManualCall.FormResize(Sender: TObject);
begin
  RefreshRoomsPos(Panel1);
end;

procedure TfrmManualCall.InitRoomCbb(roomContainer : TWinControl);
var
  i : Integer;
  adoQuery: TadoQuery;
  btnRoom : TSpeedButton;
begin
  while roomContainer.ControlCount > 0  do
  begin
    btnRoom := TSpeedButton(roomContainer.Controls[roomContainer.ControlCount - 1]);
    roomContainer.RemoveControl(btnRoom);
    FreeAndNil(btnRoom);
  end;

  TRoomOpt.GetRooms(DMGlobal.LocalArea,adoQuery);
  try
    i := 0;
    while not adoQuery.eof do
    begin
      if roomContainer.ControlCount > 0 then
      begin
      end;  
      btnRoom := TSpeedButton.Create(roomContainer);
      btnRoom.Parent := roomContainer;
      btnRoom.Font.Size := 16;
      btnRoom.Font.Color := clWhite;
      btnRoom.Flat := true;
      btnRoom.Spacing := 0;
      btnRoom.Margin := -1;
      btnRoom.Layout := blGlyphTop;
      btnRoom.NumGlyphs := 2;
      try
        btnRoom.Glyph.LoadFromFile(DMGlobal.AppPath + 'Images\home.bmp');
      except
      end;
      btnRoom.Caption := adoQuery.FieldByName('strRoomNumber').AsString;
      btnRoom.Tag := adoQuery.FieldByName('nDeveiceID').AsInteger;
      btnRoom.Enabled := (btnRoom.Tag > 0);
      btnRoom.OnClick := OnRoomBtnClick;
      Inc(i);
      btnRoom.GroupIndex := i;
      btnRoom.AllowAllUp := true;
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TfrmManualCall.OnCall(Sender: TObject);
var
  btn : TSpeedButton ;
begin
  PostMessage(Handle,WM_BeginCall,0,0);
  try
    btn := TThreadManualThread(Sender).CallButton;
    m_bCancel := false;
    if btn.Down then
    begin
      if not DMGlobal.SerialConnected then
      begin
        btn.Down := false;
        PostMessage(Handle,WM_CallFail,1,0);
        exit;
      end;
      
      if DMGlobal.AutoConnectCall(btn.Caption,'',btn.Tag,m_bCancel,checkPlayMusic.Checked) then
      begin
        PostMessage(Handle, WM_CallSucceed,0,0)
      end
      else begin
        btn.Down := false;
        PostMessage(Handle,WM_CallFail,0,0);
      end;
    end
    else begin
      if DMGlobal.HangCall then
        PostMessage(Handle,WM_HangSucceed,0,0)
      else begin
        PostMessage(Handle,WM_HangFail,0,0);
      end;
    end;    
  finally
    PostMessage(Handle, WM_EndCall,0,0);
  end;
end;

procedure TfrmManualCall.OnRoomBtnClick(Sender: TObject);
begin
  Panel1.Enabled := false;
  checkPlayMusic.Enabled := false;
  m_CallThread := TThreadManualThread.Create(true);
  m_CallThread.CallButton := TSpeedButton(Sender);
  m_CallThread.OnExecute := OnCall;
  m_CallThread.Resume;
end;

procedure TfrmManualCall.RefreshRoomsEnable(roomContainer : TWinControl);
var
  i,j : Integer;
  btn : TSpeedButton;
begin
  for i := 0 to roomContainer.ControlCount - 1 do
  begin
    btn := TSpeedButton(roomContainer.Controls[i]);
    if btn.Tag = 0 then
      btn.Enabled := false
    else
      btn.Enabled := true;
      
    if btn.Down then
    begin
      for j := 0 to roomContainer.ControlCount - 1 do
      begin
        if roomContainer.Controls[j] <> btn then
          TSpeedButton(roomContainer.Controls[j]).Enabled := false;
      end;
      break;
    end;
  end;
end;

procedure TfrmManualCall.RefreshRoomsPos(roomContainer: TWinControl);
var
  i : Integer;
  btnRoom,btnPrevious : TSpeedButton;
  btnWidth,btnHeight,btnLeft,btnTop,btnRowSpace,btnColSpace : Integer;
  floor : string;
begin
  btnWidth := 80; btnHeight := 80;
  btnRowSpace := 30; btnColSpace := 20;
  btnLeft := btnRowSpace;btnTop := btnColSpace;


  for i := 0 to roomContainer.ControlCount - 1 do
  begin
    btnRoom :=  TSpeedButton(roomContainer.Controls[i]);
    if i = 0 then
    begin
      floor := btnRoom.Caption[1];
    end;
    if i > 0 then
    begin
      btnPrevious := TSpeedButton(roomContainer.Controls[i-1]);
      btnLeft := btnPrevious.Left + btnPrevious.Width + btnRowSpace;
      btnTop := btnPrevious.Top;
      if (roomContainer.Width <= (btnLeft + btnWidth)) or (floor <> btnRoom.Caption[1]) then
      begin
        btnTop := btnTop + btnPrevious.Height + btnColSpace;
        btnLeft := btnRowSpace;
        floor := btnRoom.Caption[1];
      end;
    end;
    btnRoom.SetBounds(btnLeft,btnTop,btnWidth,btnHeight);
  end;
end;



procedure TfrmManualCall.WMBeginCall(var MSG: TMessage);
begin
  Caption :=  '通信中，请稍后....';
end;

procedure TfrmManualCall.WMCallFail(var Msg: TMessage);
begin
  if not m_bCancel  then
  begin
    if Msg.WParam = 1 then
      Application.MessageBox('串口未连接，呼叫失败.','提示',MB_OK + MB_ICONINFORMATION)
    else
      Application.MessageBox('连接异常，呼叫失败.','提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmManualCall.WMCallSucceed(var Msg: TMessage);
begin
  Caption := ('呼叫成功....');
end;

procedure TfrmManualCall.WMEndCall(var Msg: TMessage);
begin
  FreeAndNil(m_CallThread);
   m_bCancel := false;
  if m_bCancel then
  begin
    DMGlobal.HangCall;
    Caption := '取消呼叫...';
    Application.MessageBox('呼叫取消成功.','提示',MB_OK + MB_ICONINFORMATION);
  end;
  btnCancelCall.Enabled := true;
  Panel1.Enabled := true;
  checkPlayMusic.Enabled := true;
  RefreshRoomsEnable(panel1);

end;

procedure TfrmManualCall.WMHangFail(var Msg: TMessage);
begin
  if not m_bCancel then  
    Application.MessageBox('连接异常，挂断失败.','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmManualCall.WMHangSucceed(var Msg: TMessage);
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

