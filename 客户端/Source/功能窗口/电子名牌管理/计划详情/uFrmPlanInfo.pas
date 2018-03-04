unit uFrmPlanInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTrainPlan, StdCtrls;

type
  //¼Æ»®ÏêÇé
  TFrmPlanInfo = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbTrainNumber: TLabel;
    lbTrainNo: TLabel;
    lbStartStationName: TLabel;
    lbEndStationName: TLabel;
    lbStartTime: TLabel;
    Label1: TLabel;
    lbJiaoLu: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    procedure InitData(TrainPlan:RRsTrainPlan);
  private
    { Private declarations }
    m_TrainPlan:RRsTrainPlan;
  public
    { Public declarations }
    class procedure ShowPlan(TrainPlan:RRsTrainPlan);
  end;

var
  FrmPlanInfo: TFrmPlanInfo;




implementation

{$R *.dfm}

procedure TFrmPlanInfo.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmPlanInfo.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk ;
end;

procedure TFrmPlanInfo.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TFrmPlanInfo.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TFrmPlanInfo.InitData(TrainPlan: RRsTrainPlan);
begin
  m_TrainPlan := TrainPlan ;

  lbJiaoLu.Caption := TrainPlan.strTrainJiaoluName ;

  lbTrainNumber.Caption := TrainPlan.strTrainNumber ;
  lbTrainNo.Caption := TrainPlan.strTrainNo ;

  lbStartStationName.Caption := TrainPlan.strStartStationName ;
  lbEndStationName.Caption := TrainPlan.strEndStationName ;
  lbStartTime.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss',TrainPlan.dtStartTime);

end;

class procedure TFrmPlanInfo.ShowPlan(TrainPlan: RRsTrainPlan);
var
  frm:TFrmPlanInfo;
begin
  frm := TFrmPlanInfo.Create(nil);
  try
    frm.InitData(TrainPlan);
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
