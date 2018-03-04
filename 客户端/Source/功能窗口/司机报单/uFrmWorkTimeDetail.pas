unit uFrmWorkTimeDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, ExtCtrls, RzPanel, ImgList,uRunEvent,uDBRunEvent;

type
  TfrmWorkTimeDetail = class(TForm)
    RzPanel1: TRzPanel;
    lstviewTurn: TRzListView;
    ImageList1: TImageList;
  private
    { Private declarations }
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

procedure TfrmWorkTimeDetail.InitData(TrainPlanGUID: string);
var
  runEventArray : TRsRunEventArray;
  dbRunEvent : TRsDBRunEvent;
  i: Integer;
  item : TListItem;
begin
  dbRunEvent := TRsDBRunEvent.Create(GlobalDM.ADOConnection);
  try
    dbRunEvent.GetPlanRunEvents(TrainPlanGUID,runEventArray);
    lstviewTurn.Items.Clear;
    for i := 0 to length(runEventArray) - 1 do
    begin
      item := lstviewTurn.Items.Add;
      item.Caption := FormatDateTime('yyyy-MM-dd HH:nn',runEventArray[i].dtEventTime);
      item.SubItems.Add(Format('[%d]%s',[runEventArray[i].nTMIS,runEventArray[i].strStationName]));
      item.SubItems.Add(runEventArray[i].strEventName);
      item.SubItems.Add(runEventArray[i].strTrainNumber);
      item.SubItems.Add(runEventArray[i].strTrainNo);
    end;
  finally
    dbRunEvent.Free;
  end;
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
