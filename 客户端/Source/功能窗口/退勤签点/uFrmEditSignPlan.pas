unit uFrmEditSignPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,uSignPlan,uTrainJiaolu,uTFSystem,uGlobalDM,
  uSaftyEnum,uLCSignPlan;

type
  TFrmEditSignPlan = class(TForm)
    lbl1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl6: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtCheCi: TEdit;
    dtpHouBanDay: TDateTimePicker;
    dtpJiaoBanDay: TDateTimePicker;
    dtpHouBanTime: TDateTimePicker;
    dtpJiaoBanTime: TDateTimePicker;
    lbl2: TLabel;
    dtpChuQinDay: TDateTimePicker;
    dtpChuQinTime: TDateTimePicker;
    lbl5: TLabel;
    dtpKaiCheDay: TDateTimePicker;
    dtpKaiCheTime: TDateTimePicker;
    cbbRest: TComboBox;
    lbl7: TLabel;
    edtTrainJiaoLu: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //目的签点计划
    m_DestSignPlan:TSignPlan;
    //原始签点计划
    m_SourceSignPlan:TSignPlan;
    //交路信息
    m_TrainJiaoLu:RRsTrainJiaolu;
    //是否修改模式
    m_bModifyMode:Boolean;
    //签点web操作
    m_WebOP:TRSLCSignPlan;
  private
    {功能:新建一个计划对象}
    procedure InitNewPlan();
    {功能:校验数据}
    function CheckInput():Boolean;
    {功能:UI赋值给对象}
    procedure UI2Obj();
    {功能:将对象数据显示到UI}
    procedure Obj2UI();
  public
    {功能:创建签点计划}
    class function CreateSignPlan(trainJiaolu:RRsTrainJiaolu;var plan:TSignPlan):Boolean;
    {功能:修改签点计划}
    class function ModifySignPlan(trainJiaolu:RRsTrainJiaolu;var sPlan:TSignPlan):Boolean;
    { Public declarations }
  end;
implementation

{$R *.dfm}

{ TFrmEditSignPlan }

procedure TFrmEditSignPlan.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmEditSignPlan.btnOKClick(Sender: TObject);
var
  strErrMsg:string;
begin
  if CheckInput = False then Exit;
  UI2Obj();
  if m_bModifyMode = True then
  begin
    if m_WebOP.ModifySignPlan(m_DestSignPlan,strErrMsg) = False then Exit;
  end
  else
  begin
    if m_WebOP.AddSignPlan(m_DestSignPlan,strErrMsg)= False then Exit;
  end;
  Self.ModalResult := mrOk;

end;

function TFrmEditSignPlan.CheckInput: Boolean;
begin
  result := False;
  if Trim(edtCheCi.Text) ='' then
  begin
    Box('车次不能为空!');
    Exit;
  end;
  Result := True;
end;

class function TFrmEditSignPlan.CreateSignPlan(trainJiaolu:RRsTrainJiaolu;
  var plan: TSignPlan): Boolean;
var
  FrmEditSignPlan: TFrmEditSignPlan;
begin
  result := False;
  FrmEditSignPlan := TFrmEditSignPlan.Create(nil);
  try
    plan := TSignPlan.Create;
    try
      FrmEditSignPlan.m_TrainJiaoLu := trainJiaolu;
      FrmEditSignPlan.InitNewPlan();
      if FrmEditSignPlan.ShowModal = mrOk then
      begin
        plan.Clone(FrmEditSignPlan.m_DestSignPlan);
        result := True;
      end;
    except on e:Exception do
      FreeAndNil(plan);
    end;
  finally
    FrmEditSignPlan.Free;
  end;
end;

procedure TFrmEditSignPlan.FormCreate(Sender: TObject);
begin
  m_WebOP:=TRSLCSignPlan.Create(GlobalDM.GetWebUrl,
  GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_DestSignPlan:= TSignPlan.Create;
end;

procedure TFrmEditSignPlan.FormDestroy(Sender: TObject);
begin
  m_DestSignPlan.Free;
  m_WebOP.Free;
end;

procedure TFrmEditSignPlan.FormShow(Sender: TObject);
begin
  edtTrainJiaoLu.Text := m_TrainJiaoLu.strTrainJiaoluName;
  Obj2UI();

end;

class function TFrmEditSignPlan.ModifySignPlan(trainJiaolu:RRsTrainJiaolu;
  var sPlan:TSignPlan): Boolean;
var
  FrmEditSignPlan: TFrmEditSignPlan;
begin
  result := False;
  FrmEditSignPlan:= TFrmEditSignPlan.Create(nil);
  try
    FrmEditSignPlan.m_TrainJiaoLu := trainJiaolu;
    FrmEditSignPlan.m_SourceSignPlan := sPlan;
    FrmEditSignPlan.m_bModifyMode := True;
    FrmEditSignPlan.m_DestSignPlan.Clone(sPlan);
    if FrmEditSignPlan.ShowModal = mrOk then
    begin
      sPlan.Clone(FrmEditSignPlan.m_DestSignPlan);
      result := True;
    end;
  finally
    FrmEditSignPlan.Free;
  end;
end;

procedure TFrmEditSignPlan.InitNewPlan();
begin
  m_DestSignPlan.strGUID := NewGUID;
  m_DestSignPlan.strTrainJiaoLuGUID  := m_TrainJiaoLu.strTrainJiaoluGUID;
  m_DestSignPlan.eState := psPublish;
end;

procedure TFrmEditSignPlan.Obj2UI;
begin
  edtTrainJiaoLu.Text := m_TrainJiaoLu.strTrainJiaoluName;
  dtpHouBanDay.DateTime := GlobalDM.GetNow;
  dtpJiaoBanDay.DateTime := GlobalDM.GetNow;
  dtpKaiCheDay.DateTime := GlobalDM.GetNow;
  dtpChuQinDay.DateTime := GlobalDM.GetNow;
  
  if m_SourceSignPlan = nil then Exit;
  edtCheCi.Text := m_SourceSignPlan.strTrainNo;
  cbbRest.ItemIndex := m_SourceSignPlan.nNeedRest;
  dtpHouBanDay.DateTime := m_SourceSignPlan.dtArriveTime;
  dtpHouBanTime.DateTime := m_SourceSignPlan.dtArriveTime;
  dtpJiaoBanDay.DateTime := m_SourceSignPlan.dtCallTime;
  dtpJiaoBanTime.DateTime := m_SourceSignPlan.dtCallTime;
  dtpChuQinDay.DateTime := m_SourceSignPlan.dtChuQinTime;
  dtpChuQinTime.DateTime := m_SourceSignPlan.dtChuQinTime;
  dtpKaiCheDay.DateTime := m_SourceSignPlan.dtStartTrainTime;
  dtpKaiCheDay.DateTime := m_SourceSignPlan.dtStartTrainTime;
end;

procedure TFrmEditSignPlan.UI2Obj;
begin
  m_DestSignPlan.strTrainNo := edtCheCi.Text;
  m_DestSignPlan.nNeedRest := cbbRest.ItemIndex;
  dtpHouBanDay.Time := dtpHouBanTime.Time;
  m_DestSignPlan.dtArriveTime := dtpHouBanDay.DateTime;

  dtpJiaoBanDay.Time := dtpJiaoBanTime.Time;
  m_DestSignPlan.dtCallTime := dtpJiaoBanDay.DateTime;

  dtpChuQinDay.Time :=dtpChuQinTime.Time;
  m_DestSignPlan.dtChuQinTime := dtpChuQinDay.DateTime;
  
  dtpKaiCheDay.Time:=dtpKaiCheTime.Time;
  m_DestSignPlan.dtStartTrainTime := dtpKaiCheDay.DateTime;
  
end;

end.
