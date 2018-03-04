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
    //��ʾ�ƻ���Ϣ
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
    item.SubItems.Add(strTrainTypeName);  //����
    item.SubItems.Add(strTrainNumber);    //����
    item.SubItems.Add(strTrainNo);       //����
    strTime := FormatDateTime('yyyy-MM-dd HH:nn:ss',dtStartTime) ;
    item.SubItems.Add(strTime);
    {
    item.SubItems.Add(TFMessage.StrField['strTrainman1']);      //˾��1
    item.SubItems.Add(TFMessage.StrField['strTrainman2']);      //˾��2
    item.SubItems.Add(TFMessage.StrField['strTrainman3']);      //˾��3
    item.SubItems.Add(TFMessage.StrField['strTrainman4']);      //˾��4
    }
    item.SubItems.Add(Format('�üƻ���"%s"ʱ����!',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',dtStartTime)]));
  end;
end;

end.
