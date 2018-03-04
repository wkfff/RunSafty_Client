unit uFrmWorkTimeDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ExtCtrls, RzPanel, ImgList,uRunEvent,
  Menus,uTFSystem,uLCEvent;

type
  TfrmWorkTimeDetail = class(TForm)
    RzPanel1: TRzPanel;
    lstviewTurn: TRzListView;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    miDeleteEvent: TMenuItem;
    procedure miDeleteEventClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_strTrainPlanGUID : string;
    runEventArray : TRsRunEventArray;
    m_RsLCEvent: TRsLCEvent;
    procedure InitData(TrainPlanGUID : string);
  public
    { Public declarations }
    //显示趟劳时的详细信息
    class procedure ShowWorkTimeDetail(TrainPlanGUID : string);
  end;



implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TfrmWorkTimeDetail }

procedure TfrmWorkTimeDetail.FormCreate(Sender: TObject);
begin
  m_RsLCEvent := TRsLCEvent.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmWorkTimeDetail.FormDestroy(Sender: TObject);
begin
  m_RsLCEvent.Free;
end;

procedure TfrmWorkTimeDetail.InitData(TrainPlanGUID: string);
var
  i: Integer;
  item : TListItem;
begin
  m_strTrainPlanGUID := TrainPlanGUID;
  m_RsLCEvent.GetPlanRunEvents(TrainPlanGUID,runEventArray);
  lstviewTurn.Items.Clear;
  for i := 0 to length(runEventArray) - 1 do
  begin
    Application.ProcessMessages;
      
    item := lstviewTurn.Items.Add;
    item.Caption := FormatDateTime('yyyy-MM-dd HH:nn',runEventArray[i].dtEventTime);
    item.SubItems.Add(Format('[%d]%s',[runEventArray[i].nTMIS,runEventArray[i].strStationName]));
    item.SubItems.Add(runEventArray[i].strEventName);
    item.SubItems.Add(runEventArray[i].strTrainNumber);
    item.SubItems.Add(runEventArray[i].strTrainNo);
  end;
end;

procedure TfrmWorkTimeDetail.miDeleteEventClick(Sender: TObject);
begin
  if lstviewTurn.Selected = nil then exit;
  if not TBOX('您确认要删除该事件吗？') then exit;
  m_RsLCEvent.DeleteRunEvent(runEventArray[lstviewTurn.Selected.Index].strRunEventGUID);
     InitData(m_strTrainPlanGUID);
end;

class procedure TfrmWorkTimeDetail.ShowWorkTimeDetail(TrainPlanGUID: string);
var
  frmWorkTimeDetail: TfrmWorkTimeDetail;
begin
  frmWorkTimeDetail := TfrmWorkTimeDetail.Create(nil);
  try
    frmWorkTimeDetail.InitData(TrainPlanGUID);
    frmWorkTimeDetail.ShowModal;
  finally
    frmWorkTimeDetail.Free;
  end;
end;

end.
