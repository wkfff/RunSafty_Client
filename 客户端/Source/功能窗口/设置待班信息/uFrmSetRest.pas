unit uFrmSetRest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTrainPlan, StdCtrls, ComCtrls, Buttons, PngCustomButton, RzPanel,
  AdvDateTimePicker, ExtCtrls,uTFSystem,uLCPaiBan;

type
  TfrmSetRest = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    dtpCallTime: TAdvDateTimePicker;
    dtpArriveTime: TAdvDateTimePicker;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label3: TLabel;
    RzPanel1: TRzPanel;
    checkNeedRest: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure checkNeedRestClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_TrainmanPlan : RRsTrainmanPlan ;
    m_LCPaiBan: TLCPaiBan;
    procedure InitData;
  public
    { Public declarations }
    class function SetPlanRestInfo(var TrainmanPlan : RRsTrainmanPlan):boolean;
  end;



implementation
{$R *.dfm}
uses
  uGlobalDM,DateUtils;
class  function TfrmSetRest.SetPlanRestInfo(var TrainmanPlan : RRsTrainmanPlan):boolean;
var
  frmSetRest: TfrmSetRest;
begin
  Result :=false;
  frmSetRest:= TfrmSetRest.Create(nil);
  try
    frmSetRest.m_TrainmanPlan := trainmanPlan;
    frmSetRest.InitData;
    if frmSetRest.ShowModal = mrOk  then
    begin
      trainmanPlan.RestInfo :=  frmSetRest.m_TrainmanPlan.RestInfo ;
      Result := true;
    end;
  finally
    frmSetRest.Free;
  end;
end;
procedure TfrmSetRest.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetRest.btnOKClick(Sender: TObject);
begin
  if checkNeedRest.Checked then
  begin                                          //出勤时间
    if  dtpArriveTime.DateTime >=  m_TrainmanPlan.TrainPlan.dtChuQinTime then
    begin
      Application.MessageBox('侯班时间必须小于出勤时间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    
    if dtpCallTime.DateTime <= dtpArriveTime.DateTime then
    begin
      Application.MessageBox('叫班时间必须大于侯班时间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
  end;

  try
  
    m_TrainmanPlan.RestInfo.nNeedRest := 0;
    if checkNeedRest.Checked then
      m_TrainmanPlan.RestInfo.nNeedRest := 1;
    m_TrainmanPlan.RestInfo.dtArriveTime := dtpArriveTime.DateTime;
    m_TrainmanPlan.RestInfo.dtCallTime := dtpCallTime.DateTime;

    m_LCPaiBan.SetPlanRest(m_TrainmanPlan.TrainPlan.strTrainPlanGUID,m_TrainmanPlan.RestInfo);
    ModalResult := mrOk;
  except on e : exception do
    begin
      Box('设置侯班信息失败：' + e.Message);
    end;
  end;
end;

procedure TfrmSetRest.checkNeedRestClick(Sender: TObject);
begin
  dtpCallTime.Enabled := checkNeedRest.Checked;
  dtpArriveTime.Enabled := checkNeedRest.Checked;
end;

procedure TfrmSetRest.FormCreate(Sender: TObject);
begin
  dtpArriveTime.DateTime := GlobalDM.getnow ;
  dtpCallTime.DateTime := GlobalDM.getnow ;
  m_LCPaiBan := TLCPaiBan.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmSetRest.FormDestroy(Sender: TObject);
begin
  m_LCPaiBan.Free;
end;

procedure TfrmSetRest.InitData;
begin
  checkNeedRest.Checked := m_TrainmanPlan.RestInfo.nNeedRest > 0;
  checkNeedRestClick(checkNeedRest);
  dtpArriveTime.DateTime := m_TrainmanPlan.RestInfo.dtArriveTime;
  if m_TrainmanPlan.RestInfo.dtArriveTime = 0 then
  begin
    dtpArriveTime.DateTime := IncHour(m_TrainmanPlan.TrainPlan.dtRealStartTime,-6);
  end;

  dtpCallTime.DateTime := m_TrainmanPlan.RestInfo.dtCallTime;
  if m_TrainmanPlan.RestInfo.dtCallTime = 0 then
  begin
    dtpCallTime.DateTime := IncHour(m_TrainmanPlan.TrainPlan.dtRealStartTime,-5)
  end;
end;

end.
