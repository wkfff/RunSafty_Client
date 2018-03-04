unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTFMessageComponent,superobject,uTFMessageDefine, DB,
  DBClient,uTFSystem, ExtCtrls, RzPanel;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    RzGroupBox1: TRzGroupBox;
    Memo1: TMemo;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    TFMessageCompnent: TTFMessageCompnent;
    procedure OnTFMessage(TFMessages: TTFMessageList);
    procedure OnError(strError: string); 
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  TFMessageCompnent.CancelRecievedMessages();
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  TFMessage: TTFMessage;
  nTickCount: Cardinal;
begin
  TFMessage := TTFMessage.Create;
  TFMessage.msg := 10101;
  TFMessage.Mode := 0;
  TFMessage.StrField['tmid'] := '2301010';
  TFMessage.dtField['dttime'] := Now;
  TFMessage.IntField['Tmis'] := 10232;
  nTickCount := GetTickCount;

  TFMessageCompnent.PostMessage(TFMessage);
  Memo1.Lines.Add(IntToStr(GetTickCount - nTickCount))
end;

procedure TfrmMain.Button3Click(Sender: TObject);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  TFMessage.msg := 10101;
  TFMessage.Mode := 0;
  TFMessage.StrField['tmid'] := '2301010';
  TFMessage.StrField['name'] := '李磊';
  TFMessage.dtField['dttime'] := Now;
  TFMessage.IntField['Tmis'] := 10232;

  TFMessageCompnent.PostMessage(TFMessage);
  TFMessage.Free;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  i: Integer;
begin
  TFMessageCompnent.HttpRecieveMessage();

  
  Memo1.Lines.Add('接收到消息数:' + IntToStr(TFMessageCompnent.TFMessageList.Count));

  for I := 0 to TFMessageCompnent.TFMessageList.Count - 1 do
  begin
    Memo1.Lines.Add('消息:' + IntToStr(TFMessageCompnent.TFMessageList.Items[i].msg));
    Memo1.Lines.Add('消息ID:' + TFMessageCompnent.TFMessageList.Items[i].msgID);
    if TFMessageCompnent.TFMessageList.Items[i].msg = 10101 then
    begin
      Memo1.Lines.Add('工号:' + TFMessageCompnent.TFMessageList.Items[i].StrField['tmid']);
      Memo1.Lines.Add('姓名:' + TFMessageCompnent.TFMessageList.Items[i].StrField['name']);
      Memo1.Lines.Add('时间:' + TFMessageCompnent.TFMessageList.Items[i].StrField['dttime']);
    end;
    TFMessageCompnent.TFMessageList.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;
  end;

  TFMessageCompnent.CancelAllMessages();
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  TFMessageCompnent.ConfirmMessages(TFMessageCompnent.TFMessageList);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TFMessageCompnent := TTFMessageCompnent.Create(SynMode);
  TFMessageCompnent.OnMessage := OnTFMessage;
  TFMessageCompnent.ClientID := '10002';
  TFMessageCompnent.URL := 'http://192.168.10.231/Web接口/MsgReceive.ashx?';
  TFMessageCompnent.OnError := OnError;
  TFMessageCompnent.Open();
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  TFMessageCompnent.Free;
end;
                                  


procedure TfrmMain.OnError(strError: string);
begin
  Memo1.Lines.Add('Error:' + strError);
end;

procedure TfrmMain.OnTFMessage(TFMessages: TTFMessageList);
var
  i: Integer;
begin
  Memo1.Lines.Add('接收到消息数:' + IntToStr(TFMessages.Count));

  for I := 0 to TFMessages.Count - 1 do
  begin
    Memo1.Lines.Add('消息:' + IntToStr(TFMessages.Items[i].msg));
    Memo1.Lines.Add('消息ID:' + TFMessages.Items[i].msgID);
    if TFMessages.Items[i].msg = 10101 then
    begin
      Memo1.Lines.Add('工号:' + TFMessages.Items[i].StrField['tmid']);
      Memo1.Lines.Add('姓名:' + TFMessages.Items[i].StrField['name']);
      Memo1.Lines.Add('时间:' + TFMessages.Items[i].StrField['dttime']);
    end;
    TFMessages.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;
  end;
end;

end.
