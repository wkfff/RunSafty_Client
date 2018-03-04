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

  //��Ա����
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
      {����:������Ա��Ϣ}
    procedure DownLoadTrainmanInfo(Sender: TObject) ;
    //��ʾ��ǰ�������ص���Ա����Ϣ
    procedure ShowTrainmanInfo(Trainman:RRsTrainman);
    //��ʾ����
    procedure DisplayProgess(Index,Count : integer);
  private
    { Private declarations }
    // ������Ա��
      obDownload:TDownloadSignInfo;
    //˾����Ϣ����
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
  if not TBox('���ص�˾����Ϣ���ᱻ��գ�ȷ������������ϵ�˾����Ϣ��') then
    Exit ;

  //��ձ�����Ա��Ϣ
  mmoRec.Lines.Add('����ɾ�����ؾɵ���Ա��Ϣ,�����ĵȴ�...');
  obDownload.ClearTrainmanInfo ;
  mmoRec.Lines.Add('ɾ�����ؾɵ���Ա�ɹ�');

  nCount := obDownload.GetServerTrainmanCount;
  strTxt := Format('һ����%d����Ա',[nCount]) ;
  mmoRec.Lines.Clear;
  mmoRec.Lines.Add('��ʼͬ����Ա:'+strTxt + '�����ĵȴ�');

  if m_threadUploadTrainman = nil then
  begin
    m_threadUploadTrainman := TThreadDownTrainmanInfo.Create(true);
    m_threadUploadTrainman.OnExecute := DownLoadTrainmanInfo;
    m_threadUploadTrainman.Resume ;
  end ;
end;

procedure TFrmImportTrainman.actStopExecute(Sender: TObject);
begin
  if not TBox('ȷ��ֹͣ������Ա��Ϣ��') then
    Exit ;
  //ֹͣ����
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
    mmoRec.Lines.Add('���ط�������Ա��Ϣ���!');
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
  if TBox('ȷ��Ҫ�˳���') then
    Close ;
end;

procedure TFrmImportTrainman.ShowTrainmanInfo(Trainman:RRsTrainman);
var
  strText : string ;
  strTrainman : string ;
begin
  strText := FormatDateTime('[ yyyy-MM-DD HH:mm:ss ] ',Now);
  strTrainman := Format(' [%s]%s',[Trainman.strTrainmanNumber,Trainman.strTrainmanName]) ;
  strText := strText + ' ��������___ ' + strTrainman ;
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
  TtfPopBox.ShowBox('������Ա���');
end;

{ TThreadDownTrainmanInfo }

procedure TThreadDownTrainmanInfo.Execute;
begin
  if Assigned(m_OnExecute) then
    m_OnExecute(Self);
end;

end.
