unit uFrmTrainPlanAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ADODB, uGlobalDM, uTrainPlan, RzCmboBx, ExtCtrls,
  RzPanel, Buttons, PngCustomButton,uTFSystem,uDBTrainJiaolu,uTrainJiaolu,
  uDBTrainPlan,uTrainman,DateUtils,uSaftyEnum;

type
  TfrmTrainPlanAdd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edtTrainNo: TEdit;
    dtpRealStart: TDateTimePicker;
    Label11: TLabel;
    Label12: TLabel;
    edtTrainNumber: TEdit;
    ComboKehuo: TRzComboBox;
    PngCustomButton1: TPngCustomButton;
    Label15: TLabel;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    comboPlanType: TRzComboBox;
    Label16: TLabel;
    Label17: TLabel;
    Label5: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    dtpPlanStart: TDateTimePicker;
    edtRemark: TEdit;
    comboDragType: TRzComboBox;
    comboRemark: TRzComboBox;
    comboTrainJiaolu: TRzComboBox;
    comboTrainSection: TRzComboBox;
    comboStartStation: TRzComboBox;
    comboEndStation: TRzComboBox;
    comboTrainmanType: TRzComboBox;
    comboTrainType: TRzComboBox;
    btnSend: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure comboTrainSectionChange(Sender: TObject);
    procedure comboTrainJiaoluChange(Sender: TObject);
    procedure comboRemarkChange(Sender: TObject);
    procedure dtpPlanStartChange(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
  private
    m_DBTrainJiaolu : TRsDBTrainJiaolu;
    m_DBTrainPlan : TRsDBTrainPlan;
    m_strPlanGUID : string;
    m_strDefaultTrainJiaoluGUID : string;
  private
    { Private declarations }
    procedure InitBase;
    procedure InitZFQJ;
    procedure InitData;
    procedure InitStations;
    function  CheckInput : boolean;
  public
    class function EditTrainPlan(PlanGUID,TrainJiaoluGUID : string) : boolean;
  end;

implementation
uses
  uDBStation,uDBTrainmanType,uDBTrainType,ukehuo,udbkehuo;
{$R *.dfm}

procedure TfrmTrainPlanAdd.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainPlanAdd.btnSaveClick(Sender: TObject);
var
  trainPlan : RRsTrainPlan;
begin
  //检测输入
  if not CheckInput then exit;

  //添加初始数据
  trainPlan.dtCreateTime := GlobalDM.GetNow;
  trainPlan.strTrainPlanGUID := NewGUID;
  trainPlan.nPlanState := psEdit;
  trainPlan.strCreateSiteGUID := GlobalDM.SiteInfo.strSiteGUID;
  trainPlan.strCreateUserGUID := GlobalDM.DutyUser.strDutyGUID;
   
  if m_strPlanGUID <> '' then
  begin
    //获取计划信息
    trainPlan.strTrainPlanGUID := m_strPlanGUID;
    if not  m_DBTrainPlan.GetPlan(m_strPlanGUID,trainPlan) then
    begin
      Box('该计划已被删除，请选择其他计划');
      exit;
    end;
  end;

  //收集数据
  trainPlan.strTrainTypeName := comboTrainType.Text;
  trainPlan.strTrainNumber := Trim(edtTrainNumber.Text);
  trainPlan.strTrainNo := trim(edtTrainNo.Text);
  trainPlan.dtStartTime := dtpPlanStart.DateTime;
  trainPlan.dtRealStartTime := dtpRealStart.DateTime;
  trainPlan.strTrainJiaoluGUID := comboTrainJiaolu.Values[comboTrainJiaolu.ItemIndex];
  trainPlan.strStartStation := ComboStartStation.Values[ComboStartStation.ItemIndex];
  trainPlan.strEndStation := ComboEndStation.Values[ComboEndStation.ItemIndex];

  trainPlan.nTrainmanTypeID := TRsTrainmanType(StrToInt(comboTrainmanType.Value));
  trainPlan.nPlanType := TRsPlanType(StrToInt(comboPlanType.Value));
  trainPlan.nDragType := TRsDragType(StrToInt(comboDragType.Value));
  trainPlan.nKeHuoID := TRsKehuo(StrToInt(ComboKehuo.Value));

  trainPlan.nRemarkType := TRsPlanRemarkType(StrToInt(comboRemark.Value));
  trainPlan.strRemark := Trim(edtRemark.Text);
  
  try
    if m_strPlanGUID = '' then
    begin
      m_DBTrainPlan.Add(trainPlan);
    end else begin
      m_DBTrainPlan.Update(trainPlan,GlobalDM.GetNow,
        GlobalDM.SiteInfo.strSiteGUID,GlobalDM.DutyUser.strDutyGUID);
    end;
    Box('保存成功。');
    ModalResult := mrOk;
  except on e: exception do
    begin
      Box(Format('保存失败，错误信息:%s',[e.Message]));
    end;
  end;
end;

procedure TfrmTrainPlanAdd.btnSendClick(Sender: TObject);
var
  trainPlan : RRsTrainPlan;
  planGUIDs : TStrings;
begin
  //检测输入
  if not CheckInput then exit;

  //添加初始数据
  trainPlan.dtCreateTime := GlobalDM.GetNow;
  trainPlan.strTrainPlanGUID := NewGUID;
  trainPlan.nPlanState := psSent;
  trainPlan.strCreateSiteGUID := GlobalDM.SiteInfo.strSiteGUID;
  trainPlan.strCreateUserGUID := GlobalDM.DutyUser.strDutyGUID;
   
  if m_strPlanGUID <> '' then
  begin
    //获取计划信息
    trainPlan.strTrainPlanGUID := m_strPlanGUID;
    if not  m_DBTrainPlan.GetPlan(m_strPlanGUID,trainPlan) then
    begin
      Box('该计划已被删除，请选择其他计划');
      exit;
    end;
    if trainPlan.nPlanState in [psCancel] then
    begin
      Box('该计划已被撤销，不能操作');
      exit;
    end;
    if trainPlan.dtRealStartTime <= GlobalDM.GetNow then
    begin
      Box('计划已经过了开车时间，不能下发');
      exit;
    end;
  end;

  
  //收集数据
  trainPlan.strTrainTypeName := comboTrainType.Text;
  trainPlan.strTrainNumber := Trim(edtTrainNumber.Text);
  trainPlan.strTrainNo := trim(edtTrainNo.Text);
  trainPlan.dtStartTime := dtpPlanStart.DateTime;
  trainPlan.dtRealStartTime := dtpRealStart.DateTime;
  trainPlan.strTrainJiaoluGUID := comboTrainJiaolu.Values[comboTrainJiaolu.ItemIndex];
  trainPlan.strStartStation := ComboStartStation.Values[ComboStartStation.ItemIndex];
  trainPlan.strEndStation := ComboEndStation.Values[ComboEndStation.ItemIndex];

  trainPlan.nTrainmanTypeID := TRsTrainmanType(StrToInt(comboTrainmanType.Value));
  trainPlan.nPlanType := TRsPlanType(StrToInt(comboPlanType.Value));
  trainPlan.nDragType := TRsDragType(StrToInt(comboDragType.Value));
  trainPlan.nKeHuoID := TRsKehuo(StrToInt(ComboKehuo.Value));

  trainPlan.nRemarkType := TRsPlanRemarkType(StrToInt(comboRemark.Value));
  trainPlan.strRemark := Trim(edtRemark.Text);
  try
    if m_strPlanGUID = '' then
    begin
      m_DBTrainPlan.Add(trainPlan);
    end else begin
      m_DBTrainPlan.Update(trainPlan,GlobalDM.GetNow,
        GlobalDM.SiteInfo.strSiteGUID,GlobalDM.DutyUser.strDutyGUID);
    end;
    planGUIDs := TStringList.Create;
    try
      planGUIDs.Add(trainPlan.strTrainPlanGUID);
      m_DBTrainPlan.SendPlan(planGUIDs,GlobalDM.SiteInfo.strSiteGUID,
        GlobalDM.DutyUser.strDutyGUID);
    finally
      planGUIDs.Free;
    end;
    Box('保存成功。');
    ModalResult := mrOk;
  except on e: exception do
    begin
      Box(Format('保存失败，错误信息:%s',[e.Message]));
    end;
  end;
end;

function TfrmTrainPlanAdd.CheckInput: boolean;
begin
  result := false;
  if comboTrainType.ItemIndex < 0 then
  begin
    Box('请选择车型信息');
    comboTrainmanType.SetFocus;
    exit;
  end;
  if Trim(edtTrainNumber.Text) = '' then
  begin
    Box('请输入车号信息');
    edtTrainNumber.SetFocus;
    exit;
  end;

  if comboTrainJiaolu.ItemIndex < 0 then
  begin
    Box('请选择行车区段信息');
    comboTrainJiaolu.SetFocus;
    exit;
  end;

  if comboStartStation.ItemIndex < 0 then
  begin
    Box('请确认出发站信息');
    comboTrainSection.SetFocus;
    exit;
  end;
  if comboEndStation.ItemIndex < 0 then
  begin
    Box('请确认终到站信息');
    comboTrainSection.SetFocus;
    exit;
  end;
  result := true;
end;

procedure TfrmTrainPlanAdd.comboRemarkChange(Sender: TObject);
begin
  edtRemark.Enabled := false;
  edtRemark.Color := clBtnface;
  if comboRemark.ItemIndex = 2 then
  begin
    edtRemark.Enabled := true;
    edtRemark.Color := clWhite;
  end;
end;

procedure TfrmTrainPlanAdd.comboTrainJiaoluChange(Sender: TObject);
begin
  InitZFQJ;
end;

procedure TfrmTrainPlanAdd.comboTrainSectionChange(Sender: TObject);
begin
  InitStations;
end;

procedure TfrmTrainPlanAdd.dtpPlanStartChange(Sender: TObject);
begin
  dtpRealStart.DateTime := dtpPlanStart.DateTime;
end;

class function TfrmTrainPlanAdd.EditTrainPlan(PlanGUID,TrainJiaoluGUID : string): boolean;
var
  frmTrainPlanAdd: TfrmTrainPlanAdd;
begin
  result := false;
  frmTrainPlanAdd:= TfrmTrainPlanAdd.Create(nil);
  try
    frmTrainPlanAdd.m_strPlanGUID:= PlanGUID;
    frmTrainPlanAdd.m_strDefaultTrainJiaoluGUID := TrainJiaoluGUID;
    frmTrainPlanAdd.InitBase;
    frmTrainPlanAdd.InitData;
    if frmTrainPlanAdd.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmTrainPlanAdd.Free;
  end;
end;

procedure TfrmTrainPlanAdd.FormCreate(Sender: TObject);
begin
  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_DBTrainPlan := TRsDBTrainPlan.Create(GlobalDM.ADOConnection);
end;

procedure TfrmTrainPlanAdd.FormDestroy(Sender: TObject);
begin
  m_DBTrainJiaolu.Free;
  m_DBTrainPlan.Free;
end;

procedure TfrmTrainPlanAdd.InitBase;
var
  adoQuery : TADOQuery;
  i : integer;
  tJiaoluArray : TRsTrainJiaoluArray;

begin
  {$region '初始化机车类型'}
  try
    TRsDBTrainType.GetTrainTypes(GlobalDM.ADOConnection,adoQuery);
    comboTrainType.Items.Clear;
    while not adoQuery.Eof do
    begin
      comboTrainType.Items.Add(adoQuery.FieldByName('strTrainTypeName').AsString);
      adoQuery.next;
    end;
  finally
    adoQuery.Free;
  end;
  {$endregion '初始化机车类型'}

  {$region '初始化机车交路'}
  m_DBTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,tJiaoluArray);
  comboTrainJiaolu.Items.Clear;
  comboTrainJiaolu.Values.Clear;
  for i := 0 to length(tJiaoluArray) - 1 do
  begin
    comboTrainJiaolu.AddItemValue(tJiaoluArray[i].strTrainJiaoluName,tJiaoluArray[i].strTrainJiaoluGUID);
  end;
  comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(m_strDefaultTrainJiaoluGUID); 
  {$endregion '初始化机车交路'}

  {$region '初始化折返区段'}
  InitZFQJ;
  {$endregion '初始化折返区段'}

  dtpPlanStart.DateTime := IncHour(DateOf(GlobalDM.GetNow),18);
  dtpRealStart.DateTime := IncHour(DateOf(GlobalDM.GetNow),18);
end;

procedure TfrmTrainPlanAdd.InitData;
var
  trainPlan : RRsTrainPlan;
begin  
  if m_strPlanGUID <> '' then
  begin
    if not m_DBTrainPlan.GetPlan(m_strPlanGUID,trainPlan) then
    begin
      Box('未找到指定的计划信息');
      btnSave.Enabled := false;
      btnSend.Enabled := false;
      exit;
    end;
    comboTrainType.ItemIndex := comboTrainType.Items.IndexOf(trainPlan.strTrainTypeName);
    edtTrainNumber.Text := trainPlan.strTrainNumber;
    edtTrainNo.Text := trainPlan.strTrainNo;
    dtpPlanStart.DateTime := trainPlan.dtStartTime;
    dtpRealStart.DateTime := trainPlan.dtRealStartTime;
    comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(trainPlan.strTrainJiaoluGUID);
    InitZFQJ;
    comboTrainSection.ItemIndex := comboTrainSection.Values.IndexOf(trainPlan.strStartStation + ',' + trainPlan.strEndStation);
    InitStations;
    comboTrainmanType.ItemIndex := comboTrainmanType.Values.IndexOf(IntToStr(Ord(trainPlan.nTrainmanTypeID)));
    comboPlanType.ItemIndex := comboPlanType.Values.IndexOf(IntToStr(Ord(trainPlan.nPlanType)));
    comboDragType.ItemIndex := comboDragType.Values.IndexOf(IntToStr(Ord(trainPlan.nDragType)));
    ComboKehuo.ItemIndex := ComboKehuo.Values.IndexOf(IntToStr(Ord(trainPlan.nKeHuoID)));
    comboRemark.ItemIndex := comboRemark.Values.IndexOf(IntToStr(Ord(trainPlan.nRemarkType)));
    comboRemarkChange(comboRemark);
    edtRemark.Text := trainPlan.strRemark;
    if trainPlan.nPlanState <> psEdit then
      btnSave.Enabled := false;
  end;
end;

procedure TfrmTrainPlanAdd.InitStations;
var
  strStationName,strStationGUID : string;
  sName1,sName2,sGUID1,sGUID2 : string;
begin
  {$region '初始化开始站结束站'}
  strStationName := comboTrainSection.Items[comboTrainSection.ItemIndex];
  sName1 := Copy(strStationName,1,Pos('--',strStationName) -1 );
  sName2 := Copy(strStationName,Pos('--',strStationName) + length('--') ,length(strStationName) - Pos('--',strStationName) - length('--') + 1);
  strStationGUID := comboTrainSection.Values[comboTrainSection.ItemIndex];
  sGUID1 := Copy(strStationGUID,1,Pos(',',strStationGUID) -1 );
  sGUID2 := Copy(strStationGUID,Pos(',',strStationGUID) + length(',') ,length(strStationGUID) - Pos(',',strStationGUID) - length(',') + 1);

  comboStartStation.Items.Clear;
  comboStartStation.Values.Clear;
  comboStartStation.AddItemValue(sName1,sGUID1);
  comboStartStation.ItemIndex := 0;

  comboEndStation.Items.Clear;
  comboEndStation.Values.Clear;
  comboEndStation.AddItemValue(sName2,sGUID2);
  comboEndStation.ItemIndex := 0;
  {$endregion '初始化开始站结束站'}
end;

procedure TfrmTrainPlanAdd.InitZFQJ;
var
  trainJiaoluGUID : string;
  zfqjArray : TRsZheFanQuJianArray;
  i: Integer;
begin
  comboTrainSection.Items.Clear;
  comboTrainSection.Values.Clear;
  if comboTrainJiaolu.ItemIndex < 0 then exit;
  trainJiaoluGUID := comboTrainJiaolu.Values[comboTrainJiaolu.ItemIndex];
  m_DBTrainJiaolu.GetZFQJOfTrainJiaolu(trainJiaoluGUID,zfqjArray);
  for i := 0 to length(zfqjArray) - 1 do
  begin
    comboTrainSection.AddItemValue(
      Format('%s--%s',[zfqjArray[i].strBeginStationName,zfqjArray[i].strEndStationName]),
      Format('%s,%s',[zfqjArray[i].strBeginStationGUID,zfqjArray[i].strEndStationGUID]));
  end;
  if comboTrainSection.Items.Count = 1 then
  begin
    comboTrainSection.ItemIndex := 0;
    InitStations;
  end;
end;

end.
