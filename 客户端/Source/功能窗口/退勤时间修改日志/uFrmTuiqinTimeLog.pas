unit uFrmTuiqinTimeLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, Buttons, PngSpeedButton, ExtCtrls,
  RzPanel,uTuiQinTime,utfsystem,uLCNameBoardEx;

type
  TFrmTuiqinTimeLog = class(TForm)
    rzpnl1: TRzPanel;
    btnRefresh: TPngSpeedButton;
    lb1: TLabel;
    lb2: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpEndTime: TDateTimePicker;
    lvRecord: TListView;
    actlst1: TActionList;
    actInspect: TAction;
    
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_logList:TRsTuiQinTimeLogList;
    m_RsLCGroup: TRsLCGroup;
  private
    { Private declarations }
    procedure InitData();
    procedure DataToListView(LogList:TRsTuiQinTimeLogList);
  public
    { Public declarations }
    class procedure ShowForm();
  end;

var
  FrmTuiqinTimeLog: TFrmTuiqinTimeLog;

implementation

uses
  uGlobalDM;

{$R *.dfm}

{ TFrmTuiqinTimeLog }

procedure TFrmTuiqinTimeLog.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmTuiqinTimeLog.DataToListView(LogList: TRsTuiQinTimeLogList);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
   lvRecord.Items.Clear;
  for I := 0 to Length(LogList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      SubItems.Add(LogList[i].strGroupGUID) ;

      strText := FormatDateTime('yyyy-MM-dd HH:nn:ss',LogList[i].dtOldArriveTime);
      SubItems.Add(strText);

      strText := FormatDateTime('yyyy-MM-dd HH:nn:ss',LogList[i].dtNewArriveTime);
      SubItems.Add(strText);

      strText := Format('[%s]%s',[LogList[i].strDutyUserNumber,LogList[i].strDutyUserName]);
      SubItems.Add(LogList[i].strDutyUserNumber);

      strText := FormatDateTime('yyyy-MM-dd HH:nn:ss',LogList[i].dtCreateTime);
      SubItems.Add(strText);
    end;
  end;
end;

procedure TFrmTuiqinTimeLog.FormCreate(Sender: TObject);
begin
  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';
  m_RsLCGroup := TRsLCGroup.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmTuiqinTimeLog.FormDestroy(Sender: TObject);
begin
  m_RsLCGroup.Free;
end;

procedure TFrmTuiqinTimeLog.InitData;
var
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
begin
  //获取开始和结束的查询时间
  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  //查询数据库
  SetLength(m_logList,0);
  m_RsLCGroup.GetTuiqinTimeLog(dtStart,dtEnd,m_logList);
  //显示结果集
  DataToListView(m_logList);
end;

class procedure TFrmTuiqinTimeLog.ShowForm;
var
  frm : TFrmTuiqinTimeLog;
begin
  frm := TFrmTuiqinTimeLog.Create(nil);
  try
    frm.InitData;
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
