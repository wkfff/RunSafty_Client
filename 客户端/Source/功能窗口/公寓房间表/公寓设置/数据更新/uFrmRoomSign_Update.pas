unit uFrmRoomSign_Update;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls,utfsystem;

type
  TFrmRoomSign_Update = class(TForm)
    Image1: TImage;
    btnUpdateFinger: TButton;
    btnUpdateTrainman: TButton;
    procedure btnUpdateFingerClick(Sender: TObject);
    procedure btnUpdateTrainmanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRoomSign_Update: TFrmRoomSign_Update;

implementation

uses
  uGlobalDM,uDownLoadSignInfo,uFrmProgressEx,utfPopBox,ufrmAccessReadFingerprintTemplates;

{$R *.dfm}

procedure TFrmRoomSign_Update.btnUpdateFingerClick(Sender: TObject);
begin
  if not TBox('您确定要重新从网络中缓存数据库吗?') then exit;
  //出勤端需要初始化指纹仪
  GlobalDM.InitFingerPrintting;
   //读取指纹库内容
  if GlobalDM.FingerprintInitSuccess then
    ReadFingerprintTemplatesAccess(True);
end;

{ TODO : TFrmRoomSign_Update.btnUpdateTrainmanClick }
procedure TFrmRoomSign_Update.btnUpdateTrainmanClick(Sender: TObject);
var
  obDownload:TDownloadSignInfo;
  nCount,nSuccess:Integer;
  strTxt:string;
begin

//  try
//    GlobalDM.ConnecDB;
//  except on e : exception do
//    begin
//      Box(Format('连接数据库失败:%s ',[e.Message]));
//      Exit;
//    end;
//  end;
//
//  if not TBox('确定导入服务器上的司机信息吗？这个可能需要几分钟的时间！') then
//    Exit ;
//  
//  nCount := 0;
//  nSuccess := 0;
//  obDownload := TDownloadSignInfo.Create() ;
//  try
//    try
//      TfrmProgressEx.CreateProgress();
//      obDownload.SetConnect(GlobalDM.ADOConnection,GlobalDM.LocalADOConnection,
//        TfrmProgressEx.DisplayProgess,nil);
//
//      TfrmProgressEx.SetHint('正在导入司机信息，请稍后');
//      nSuccess := obDownload.DownloadTrainmanInfo(nCount) ;
//      strTxt := Format('导入完毕,共计 [%d] 条',[nSuccess]);
//      TtfPopBox.ShowBox(strTxt);
//    except
//      on e:Exception do
//      begin
//        BoxErr('导入错误:' + e.Message );
//      end;
//    end;
//  finally
//    TfrmProgressEx.CloseProgress;
//    obDownload.Free ;
//  end;
end;

end.
