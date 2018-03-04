unit uFrmTrainPlanChangeLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngCustomButton, ExtCtrls, RzPanel, ComCtrls,
  Mask, RzEdit, RzDTP, RzCmboBx, PngSpeedButton,utfsystem,uTrainPlan,
  RzStatus,uLCPaiBan;

type
  TFrmTrainPlanChangeLog = class(TForm)
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    lvRecord: TListView;
    RzStatusBar1: TRzStatusBar;
    statusPanelSum: TRzStatusPane;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //日志数组
    m_listTrainPlanChangeLog:TRsTrainPlanChangeLogArray;
    m_LCPaiBan: TLCPaiBan;
  private
    { Private declarations }
    //初始化数据
    procedure InitData(TrainPlanGUID:string);
    //
    procedure DataToListView(TrainPlanChangeLogList:TRsTrainPlanChangeLogArray);
  public
    { Public declarations }
    class procedure ShowForm(TrainPlanGUID:string);
  end;

var
  FrmTrainPlanChangeLog: TFrmTrainPlanChangeLog;

implementation

uses
  uGlobalDM ;

{$R *.dfm}



procedure TFrmTrainPlanChangeLog.DataToListView(
  TrainPlanChangeLogList: TRsTrainPlanChangeLogArray);
var
  i,nCount:Integer;
  listItem:TListItem;
  strText:string;
begin
  lvRecord.Items.Clear;
  nCount :=  Length(TrainPlanChangeLogList) ;
  for I := 0 to nCount - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr( nCount - i ) ;

      SubItems.Add(TrainPlanChangeLogList[i].strTrainJiaoluName);

      SubItems.Add(TrainPlanChangeLogList[i].strTrainTypeName);
      SubItems.Add(TrainPlanChangeLogList[i].strTrainNumber);
      SubItems.Add(TrainPlanChangeLogList[i].strTrainNo);

      strText := FormatDateTime('yyyy-MM-dd HH:mm:ss',(TrainPlanChangeLogList[i].dtStartTime));
      SubItems.Add(strText);

      strText := FormatDateTime('yyyy-MM-dd HH:mm:ss',(TrainPlanChangeLogList[i].dtChangeTime));
      SubItems.Add(strText);
    end;
  end;
  strText := Format('总计: %d 条',[nCount]);
  statusPanelSum.Caption := strText ;
end;

procedure TFrmTrainPlanChangeLog.FormCreate(Sender: TObject);
begin
  m_LCPaiBan := TLCPaiBan.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmTrainPlanChangeLog.FormDestroy(Sender: TObject);
begin
  m_LCPaiBan.Free;
end;

procedure TFrmTrainPlanChangeLog.InitData(TrainPlanGUID:string);
begin
  //查询数据库
  SetLength(m_listTrainPlanChangeLog,0);

  m_LCPaiBan.GetChangeTrainPlanLog(TrainPlanGUID,m_listTrainPlanChangeLog);
  //显示结果集
  DataToListView(m_listTrainPlanChangeLog);
end;

class procedure TFrmTrainPlanChangeLog.ShowForm(TrainPlanGUID:string);
var
  frm : TFrmTrainPlanChangeLog;
begin
  frm := TFrmTrainPlanChangeLog.Create(nil);
  try
    frm.InitData(TrainPlanGUID);
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
