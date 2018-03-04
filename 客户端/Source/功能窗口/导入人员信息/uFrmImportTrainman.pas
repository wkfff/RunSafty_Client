unit uFrmImportTrainman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs ,uTFSystem, ActnList,uDownLoadSignInfo, Menus, StdCtrls, ExtCtrls,
  RzPanel, Buttons, PngSpeedButton, pngimage, uTFRotationPicture, RzPrgres,
  RzStatus,uTrainman, PngCustomButton, AdvMemo;

const
  WM_START = WM_USER + 1;
  WM_FRESH = WM_User + 4;
  WM_END = WM_User + 2;

type

  //人员下载
  TThreadDownTrainmanInfo = class(TThread)
  public
    procedure Execute;override;
  private
    m_OnExecute : TNotifyEvent;
  public
    property OnExecute : TNotifyEvent read m_OnExecute write m_OnExecute;
  end;

  TFrmImportTrainman = class(TForm)
    ActionList1: TActionList;
    actStart: TAction;
    actStop: TAction;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    N1: TMenuItem;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    psgsTrainman: TRzProgressStatus;
    btnStart: TPngCustomButton;
    btnStop: TPngCustomButton;
    mmoRec: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
  private
    procedure WM_Start(var MSG : TMessage) ; message WM_START;
    procedure WM_Fresh(var Msg : TMessage) ; message WM_FRESH;
    procedure WM_Stop(var Msg : TMessage) ; message WM_END;
  private
      {功能:下载人员信息}
    procedure DownLoadTrainmanInfo(Sender: TObject) ;
    //显示当前正在下载的人员的信息
    procedure ShowTrainmanInfo(Trainman:RRsTrainman);
    //显示进度
    procedure DisplayProgess(Index,Count : integer);
  private
    { Private declarations }
    // 下载人员类
      obDownload:TDownloadSignInfo;
    //司机信息更新
    m_threadUploadTrainman : TThreadDownTrainmanInfo ;
  public
    { Public declarations }
    class procedure ImportTrainman();
  end;

var
  FrmImportTrainman: TFrmImportTrainman;

implementation

uses
  uFrmProgressExEx,
  utfPopBox,
  uGlobalDM;

{$R *.dfm}

procedure TFrmImportTrainman.actPauseExecute(Sender: TObject);
begin
  if m_threadUploadTrainman <> nil then
  begin
    m_threadUploadTrainman.Suspend
  end;
end;

procedure TFrmImportTrainman.actStartExecute(Sender: TObject);
var
  nCount: Integer ;
  strTxt : string ;
begin
  if not TBox('本地的司机信息将会被清空，确定导入服务器上的司机信息吗？') then
    Exit ;

  //清空本地人员信息
  mmoRec.Lines.Add('正在删除本地旧的人员信息,请耐心等待...');
  obDownload.ClearTrainmanInfo ;
  mmoRec.Lines.Add('删除本地旧的人员成功');

  nCount := obDownload.GetServerTrainmanCount;
  strTxt := Format('一共有%d个人员',[nCount]) ;
  mmoRec.Lines.Clear;
  mmoRec.Lines.Add('开始同步人员:'+strTxt + '请耐心等待');

  if m_threadUploadTrainman = nil then
  begin
    m_threadUploadTrainman := TThreadDownTrainmanInfo.Create(true);
    m_threadUploadTrainman.OnExecute := DownLoadTrainmanInfo;
    m_threadUploadTrainman.Resume ;
  end ;
end;

procedure TFrmImportTrainman.actStopExecute(Sender: TObject);
begin
  if not TBox('确定停止更新人员信息吗') then
    Exit ;
  //停止更新
  obDownload.Stop ;
end;

procedure TFrmImportTrainman.DisplayProgess(Index, Count: integer);
begin
  psgsTrainman.Percent  := Round((Index * 100)/Count);
end;

procedure TFrmImportTrainman.DownLoadTrainmanInfo(Sender: TObject);
var
  nSuccess:Integer;
  strTxt:string;
begin
  nSuccess := 0;
  try
    nSuccess := obDownload.UpdateTrainman() ;
    mmoRec.Lines.Add('下载服务器人员信息完毕!');
  finally
    m_threadUploadTrainman := nil ;
  end;
end;

procedure TFrmImportTrainman.FormCreate(Sender: TObject);
begin
//  m_threadUploadTrainman := nil ;
//  obDownload := TDownloadSignInfo.Create() ;
//
//  obDownload.SetShowTrainmanFunc(ShowTrainmanInfo);
//  obDownload.SetConnect(GlobalDM.ADOConnection,GlobalDM.LocalADOConnection,
//        DisplayProgess,nil);
end;

procedure TFrmImportTrainman.FormDestroy(Sender: TObject);
begin
  if m_threadUploadTrainman <> nil then
  begin
    TerminateThread(m_threadUploadTrainman.Handle,$dead) ; ;
    m_threadUploadTrainman.Free ;
  end;

  obDownload.Free ;

end;

class procedure TFrmImportTrainman.ImportTrainman;
VAR
  frm : TFrmImportTrainman ;
begin
  try
    frm := TFrmImportTrainman.Create(nil);
    frm.ShowModal ;
  finally
    frm.Free ;
  end;
end;

procedure TFrmImportTrainman.N1Click(Sender: TObject);
begin
  if TBox('确定要退出吗') then
    Close ;
end;

procedure TFrmImportTrainman.ShowTrainmanInfo(Trainman:RRsTrainman);
var
  strText : string ;
  strTrainman : string ;
begin
  strText := FormatDateTime('[ yyyy-MM-DD HH:mm:ss ] ',Now);
  strTrainman := Format(' [%s]%s',[Trainman.strTrainmanNumber,Trainman.strTrainmanName]) ;
  strText := strText + ' 正在下载___ ' + strTrainman ;
  mmoRec.Lines.Add(strText) ;
end;

procedure TFrmImportTrainman.WM_Fresh(var Msg: TMessage);
begin
  ;
end;

procedure TFrmImportTrainman.WM_Start(var MSG: TMessage);
begin
  ;
end;

procedure TFrmImportTrainman.WM_Stop(var Msg: TMessage);
begin
  TtfPopBox.ShowBox('更新人员完毕');
end;

{ TThreadDownTrainmanInfo }

procedure TThreadDownTrainmanInfo.Execute;
begin
  if Assigned(m_OnExecute) then
    m_OnExecute(Self);
end;

end.
