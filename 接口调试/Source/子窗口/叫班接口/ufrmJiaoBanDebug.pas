unit ufrmJiaoBanDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uLCCallNotify,uCallNotify,DateUtils;

type
  TFrmJiaoBanDebug = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    RsLCCallNotify: TRsLCCallNotify;
    callWork: RRsCallNotify;
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
    //功能:取消叫班通知
    procedure CancelNotify();
    //功能:添加叫班通知
    procedure AddNotify();
    //功能:查询未取消的叫班通知
    procedure FindUnCancel();
    //功能:获取通知,按照状态范围
    procedure GetByStateRange();
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
procedure TFrmJiaoBanDebug.AddNotify;
begin
  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;
  
  RsLCCallNotify.AddNotify(callWork);
end;


procedure TFrmJiaoBanDebug.Button1Click(Sender: TObject);
begin
  CancelNotify();
end;

procedure TFrmJiaoBanDebug.Button2Click(Sender: TObject);
begin
  AddNotify();
end;

procedure TFrmJiaoBanDebug.Button3Click(Sender: TObject);
begin
  FindUnCancel();
end;

procedure TFrmJiaoBanDebug.Button4Click(Sender: TObject);
begin
  GetByStateRange();
end;

procedure TFrmJiaoBanDebug.CancelNotify;
var
  strGUID, strUser: String;
  dtCancelTime: TDateTime;
  strReason: String;
begin
  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;
  
  dtCancelTime := Now;
  strGUID := callWork.strMsgGUID;
  strUser := callWork.strCancelUser;
  strReason := callWork.strCancelReason;

  
  RsLCCallNotify.CancelNotify(strGUID, strUser,dtCancelTime,strReason);
end;

procedure TFrmJiaoBanDebug.FindUnCancel;
var
  unCancelWork: RRsCallNotify;
begin
  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;
  RsLCCallNotify.FindUnCancel(callWork.strTrainmanGUID,callWork.strTrainPlanGUID,unCancelWork)
end;

procedure TFrmJiaoBanDebug.FormCreate(Sender: TObject);
begin
  RsLCCallNotify := TRsLCCallNotify.Create(GlobalDM.WebAPIUtils);
  callWork.strMsgGUID := 'TestGUID';
  callWork.strCancelUser := 'TestUser';
  callWork.strCancelReason := 'TestReason';
  callWork.strTrainmanGUID := 'TestTrainmanGUID';
  callWork.strTrainPlanGUID := 'TestTrainPlanGUID';
end;

procedure TFrmJiaoBanDebug.FormDestroy(Sender: TObject);
begin
  RsLCCallNotify.Free;
end;

procedure TFrmJiaoBanDebug.GetByStateRange;
var
  CallNotifyAry: TRSCallNotifyAry;
begin
  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;
  RsLCCallNotify.GetByStateRange(0,10,IncDay(Now,-10),False,CallNotifyAry);
end;

procedure TFrmJiaoBanDebug.OnRevHttpData(const data: string);
begin
  Memo1.Lines.Add('收到HTTP数据:');
  Memo1.Lines.Add(data);
end;

initialization
  ChildFrmMgr.Reg(TFrmJiaoBanDebug);
end.
