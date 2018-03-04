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
  if not TBox('��ȷ��Ҫ���´������л������ݿ���?') then exit;
  //���ڶ���Ҫ��ʼ��ָ����
  GlobalDM.InitFingerPrintting;
   //��ȡָ�ƿ�����
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
//      Box(Format('�������ݿ�ʧ��:%s ',[e.Message]));
//      Exit;
//    end;
//  end;
//
//  if not TBox('ȷ������������ϵ�˾����Ϣ�����������Ҫ�����ӵ�ʱ�䣡') then
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
//      TfrmProgressEx.SetHint('���ڵ���˾����Ϣ�����Ժ�');
//      nSuccess := obDownload.DownloadTrainmanInfo(nCount) ;
//      strTxt := Format('�������,���� [%d] ��',[nSuccess]);
//      TtfPopBox.ShowBox(strTxt);
//    except
//      on e:Exception do
//      begin
//        BoxErr('�������:' + e.Message );
//      end;
//    end;
//  finally
//    TfrmProgressEx.CloseProgress;
//    obDownload.Free ;
//  end;
end;

end.
