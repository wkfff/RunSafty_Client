unit uFrmPlanMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvListV,uTrainPlan;

type
  TFrmPlanMessage = class(TForm)
    lstviewMsg: TAdvListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //显示计划信息
    procedure ShowPlanMessage(MsgType:string;TrainPlan: RRsTrainPlan);
  end;

var
  FrmPlanMessage: TFrmPlanMessage;

implementation

{$R *.dfm}

{ TFrmPlanMessage }

procedure TFrmPlanMessage.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TFrmPlanMessage.FormDestroy(Sender: TObject);
begin
  ;
end;



procedure TFrmPlanMessage.ShowPlanMessage(MsgType: string;
  TrainPlan: RRsTrainPlan);
var
  item : TListItem;
  strTime:string;
begin
  item := lstviewMsg.Items.Insert(0);
  item.Caption := MsgType;
  with TrainPlan do
  begin
    item.SubItems.Add(strTrainJiaoluName);
    item.SubItems.Add(strTrainTypeName);  //车型
    item.SubItems.Add(strTrainNumber);    //车号
    item.SubItems.Add(strTrainNo);       //车次
    strTime := FormatDateTime('yyyy-MM-dd HH:nn:ss',dtStartTime) ;
    item.SubItems.Add(strTime);
    {
    item.SubItems.Add(TFMessage.StrField['strTrainman1']);      //司机1
    item.SubItems.Add(TFMessage.StrField['strTrainman2']);      //司机2
    item.SubItems.Add(TFMessage.StrField['strTrainman3']);      //司机3
    item.SubItems.Add(TFMessage.StrField['strTrainman4']);      //司机4
    }
    item.SubItems.Add(Format('该计划于"%s"时开车!',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',dtStartTime)]));
  end;
end;

end.
