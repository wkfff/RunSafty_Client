unit uFrmTrainNoAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ADODB,uTFSystem,uTrainJiaolu,
  uTrainman,DateUtils, ExtCtrls, RzPanel, RzCmboBx, Buttons,
  PngCustomButton,uTrainNo,uTrainPlan,uSaftyEnum, RzDTP, Mask,
  RzEdit,uStation,uTrainnos,uLCTrainnos,uDutyPlace,uLCDutyPlace,
  uLCBaseDict;

type
  TfrmTrainNoadd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PngCustomButton1: TPngCustomButton;
    Label15: TLabel;
    Label16: TLabel;
    Label5: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ComboKehuo: TRzComboBox;
    RzPanel2: TRzPanel;
    btnCancel: TButton;
    btnSave: TButton;
    comboPlanType: TRzComboBox;
    comboDragType: TRzComboBox;
    comboRemark: TRzComboBox;
    comboTrainJiaolu: TRzComboBox;
    comboStartStation: TRzComboBox;
    comboEndStation: TRzComboBox;
    comboTrainmanType: TRzComboBox;
    edtTrainNo: TRzEdit;
    dtpPlanStart: TRzDateTimePicker;
    edtTrainTypeName: TRzEdit;
    edtTrainTypeNumber: TRzEdit;
    edtRemark: TRzEdit;
    comboPlaceName: TRzComboBox;
    dtpPlanKaiChe: TRzDateTimePicker;
    Label13: TLabel;
    GroupBox1: TGroupBox;
    chkMon: TCheckBox;
    chkTues: TCheckBox;
    chkWes: TCheckBox;
    chkThur: TCheckBox;
    chkFri: TCheckBox;
    chkSat: TCheckBox;
    chkSun: TCheckBox;
    dtpCallWorkTime: TRzDateTimePicker;
    Label14: TLabel;
    dtpWaitWorkTime: TRzDateTimePicker;
    Label17: TLabel;
    cbbbRest: TComboBox;
    Label20: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpPlanStartChange(Sender: TObject);
    procedure comboTrainSectionChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edtTrainNoExit(Sender: TObject);
    procedure edtRemarkExit(Sender: TObject);
    procedure edtTrainTypeNameExit(Sender: TObject);
    procedure edtTrainTypeNumberExit(Sender: TObject);
    procedure dtpPlanKaiCheChange(Sender: TObject);
  private
    //图定车次接口
    m_webTrainNo : TRsLCTrainnos;
    //出勤点
    m_webDutyPlace: TRsLCDutyPlace ;
    m_strTrainNoGUID : string;
    m_strDefaultTrainJiaoluGUID : string;
  private
    { Private declarations }
    procedure InitBase;
    procedure InitData;
    procedure InitStations;
    procedure InitChuQinPlace();
    function  CheckInput : boolean;
  public
    class function EditTrainNo(PlanGUID,TrainJiaoluGUID : string) : boolean;
  end;


implementation
{$R *.dfm}

uses
  ukehuo,uGlobalDM,uRSCommonFunctions;

procedure TfrmTrainNoadd.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainNoadd.btnSaveClick(Sender: TObject);
var
  strWorkDay:string ;
  strError:string;
  TrainnosInfo:RRsTrainnosInfo;
  bRet : Boolean ;
begin
  //检测输入
  if not CheckInput then exit;

  //添加初始数据
  TrainnosInfo.trainNoID := NewGUID;
  if m_strTrainNoGUID <> '' then
  begin
    //获取计划信息
    TrainnosInfo.trainNoID := m_strTrainNoGUID;
    if not  m_webTrainNo.GetByID(m_strTrainNoGUID,TrainnosInfo,strError) then
    begin
      Box(strError);
      exit;
    end
  end;

  //收集数据
  TrainnosInfo.trainNo := trim(edtTrainNo.Text);
  TrainnosInfo.remark := Trim(edtRemark.Text);
  TrainnosInfo.startTime := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtpPlanStart.DateTime);
  TrainnosInfo.kaiCheTime := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtpPlanKaiChe.DateTime);

  TrainnosInfo.placeID := comboPlaceName.Value;
  TrainnosInfo.placeName := comboPlaceName.Text ;


  TrainnosInfo.trainjiaoluID := comboTrainJiaolu.Values[comboTrainJiaolu.ItemIndex];
  TrainnosInfo.trainjiaoluName := comboTrainJiaolu.Text ;
  
  TrainnosInfo.startStationName := ComboStartStation.Text ;
  TrainnosInfo.startStationID := ComboStartStation.Values[ComboStartStation.ItemIndex] ;

  TrainnosInfo.endStationName := ComboEndStation.Text;
  TrainnosInfo.endStationID := ComboEndStation.Values[ComboEndStation.ItemIndex];

  TrainnosInfo.TrainmanTypeID := comboTrainmanType.Value;
  TrainnosInfo.trainmanTypeName := comboTrainmanType.Text ;

  
  TrainnosInfo.planTypeID := comboPlanType.Value;
  TrainnosInfo.planTypeName := comboPlanType.Text ;

  TrainnosInfo.dragTypeID := comboDragType.Value;
  TrainnosInfo.dragTypeName := comboDragType.Text ;

  TrainnosInfo.KeHuoID := ComboKehuo.Value;
  TrainnosInfo.kehuoName := ComboKehuo.Text ;

  TrainnosInfo.remarkTypeID := comboRemark.Value;
  TrainnosInfo.remarkTypeName := comboRemark.Text ;
  TrainnosInfo.TrainTypeName := UpperCase(Trim(edtTrainTypeName.Text));

  TrainnosInfo.trainNumber := Trim(edtTrainTypeNumber.Text);

  TrainnosInfo.nNeedRest := cbbbRest.ItemIndex;
  TrainnosInfo.dtArriveTime := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtpWaitWorkTime.DateTime);
  TrainnosInfo.dtCallTime := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtpCallWorkTime.DateTime);


  strWorkDay := '' ;
  if chkMon.Checked then
    strWorkDay := strWorkDay + '1' + ',' ;

  if chkTues.Checked then
    strWorkDay := strWorkDay + '2' + ',' ;

  if chkWes.Checked then
    strWorkDay := strWorkDay + '3' + ',' ;

  if chkThur.Checked then
    strWorkDay := strWorkDay + '4' + ',' ;

  if chkFri.Checked then
    strWorkDay := strWorkDay + '5' + ',' ;

  if chkSat.Checked then
    strWorkDay := strWorkDay + '6' + ',' ;

  if chkSun.Checked then
    strWorkDay := strWorkDay + '7' + ',' ;

  TrainnosInfo.strWorkDay := strWorkDay ;

  try
    if m_strTrainNoGUID = '' then
      bRet := m_webTrainNo.Add(TrainnosInfo,strError)
    else
      bRet := m_webTrainNo.Modify(TrainnosInfo,strError);
    if bRet then
      Box('保存成功。')
    else
      Box(strError);
    ModalResult := mrOk;
  except on e: exception do
    begin
      Box(Format('保存失败，错误信息:%s',[e.Message]));
    end;
  end;
end;

function TfrmTrainNoadd.CheckInput: boolean;
begin
  result := false;
  if comboTrainJiaolu.ItemIndex < 0 then
  begin
    Box('请选择行车区段信息');
    comboTrainJiaolu.SetFocus;
    exit;
  end;

  if comboPlanType.ItemIndex < 0 then
  begin
    BoxErr('请选择一个计划类型');
    Exit ;
  end;

  if comboStartStation.ItemIndex < 0 then
  begin
    Box('请确认出发站信息');
    exit;
  end;
  if comboEndStation.ItemIndex < 0 then
  begin
    Box('请确认终到站信息');
    exit;
  end;

  if comboPlaceName.ItemIndex < 0 then
  begin
    BoxErr('请选择一个出勤点');
    Exit ;
  end;
  

  result := true;
end;

procedure TfrmTrainNoadd.comboTrainSectionChange(Sender: TObject);
begin
  InitStations;
end;

procedure TfrmTrainNoadd.dtpPlanKaiCheChange(Sender: TObject);
var
  nRemarkType:Integer ;
  strPlaceID:string;
  dtTime : TDateTime ;
  nMinute : Integer ;
begin
  nMinute := 60 ;

  strPlaceID := comboPlaceName.Value ;
  nRemarkType := StrToInt( comboRemark.Value );

  dtTime :=  dtpPlanKaiChe.DateTime ;

  //计算间隔
  RsLCBaseDict.LCWorkPlan.GetPlanTimes(nRemarkType,strPlaceID,nMinute) ;
  dtTime := IncMinute(dtTime,-nMinute)  ;

  dtpPlanStart.Time := TimeOf(dtTime);
end;

procedure TfrmTrainNoadd.dtpPlanStartChange(Sender: TObject);
begin
//  dtpRealStart.DateTime := dtpPlanStart.DateTime;
end;

class function TfrmTrainNoadd.EditTrainNo(PlanGUID,
  TrainJiaoluGUID: string): boolean;
var
  frmTrainNoadd : TfrmTrainNoadd;
begin
  result := false;
  frmTrainNoadd:= TfrmTrainNoadd.Create(nil);
  try
    frmTrainNoadd.m_strTrainNoGUID:= PlanGUID;
    frmTrainNoadd.m_strDefaultTrainJiaoluGUID := TrainJiaoluGUID;
    frmTrainNoadd.InitBase;
    frmTrainNoadd.InitData;
    if frmTrainNoadd.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmTrainNoadd.Free;
  end;
end;

procedure TfrmTrainNoadd.edtRemarkExit(Sender: TObject);
begin
  edtRemark.Text := UpperCase(edtRemark.Text);
end;

procedure TfrmTrainNoadd.edtTrainNoExit(Sender: TObject);
begin
  edtTrainNo.Text := UpperCase(edtTrainNo.Text);
  ComboKehuo.ItemIndex := ComboKehuo.Items.IndexOf(RsLCBaseDict.LCTrainType.GetKehuoByCheCi(edtTrainNo.Text));
end;

procedure TfrmTrainNoadd.edtTrainTypeNameExit(Sender: TObject);
begin
edtTrainTypeName.Text := UpperCase(edtTrainTypeName.Text);
end;
function FormatTrainNumber(TrainNumber: string): string;
begin
  Result := Trim(TrainNumber);
  if length(Result) = 3 then
    Result := '0' + Result;
  if length(Result) = 2 then
    Result := '00' + Result;
  if length(Result) = 1 then
    Result := '000' + Result;  
end;
procedure TfrmTrainNoadd.edtTrainTypeNumberExit(Sender: TObject);
begin
  edtTrainTypeNumber.Text := FormatTrainNumber(edtTrainTypeNumber.Text);
end;


procedure TfrmTrainNoadd.FormCreate(Sender: TObject);
begin
  //数据库操作类
  m_webTrainNo := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
end;

procedure TfrmTrainNoadd.FormDestroy(Sender: TObject);
begin
  m_webTrainNo.Free;
  m_webDutyPlace.Free ;
end;

procedure TfrmTrainNoadd.InitBase;
var
  i : integer;
  tJiaoluArray : TRsTrainJiaoluArray;
begin
  {$region '初始化机车交路'}
  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,tJiaoluArray);
  comboTrainJiaolu.Items.Clear;
  comboTrainJiaolu.Values.Clear;
  for i := 0 to length(tJiaoluArray) - 1 do
  begin
    comboTrainJiaolu.AddItemValue(tJiaoluArray[i].strTrainJiaoluName,tJiaoluArray[i].strTrainJiaoluGUID);
  end;
  comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(m_strDefaultTrainJiaoluGUID); 
  {$endregion '初始化机车交路'}

  InitStations;
  InitChuQinPlace;
  dtpPlanKaiChe.Time := IncHour(DateOf(GlobalDM.GetNow),19);
  dtpPlanStart.Time := IncHour(DateOf(GlobalDM.GetNow),18);
  cbbbRest.ItemIndex := 0;
end;

procedure TfrmTrainNoadd.InitChuQinPlace;
var
  strError:string;
  DutyPlaceList:TRsDutyPlaceList;
  i : Integer ;
begin

  comboPlaceName.Items.Clear;
  comboPlaceName.Values.Clear;
  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(m_strDefaultTrainJiaoluGUID,DutyPlaceList,strError) then
  begin
    BoxErr(strError);
    Exit;
  end ;
  for I := 0 to Length(DutyPlaceList) - 1 do
  begin
    comboPlaceName.AddItemValue(DutyPlaceList[i].placeName,DutyPlaceList[i].placeID) ;
  end;
  comboPlaceName.ItemIndex := 0 ;
end;

procedure TfrmTrainNoadd.InitData;
var
  I:Integer ;
  strList:TStringList ;
  strError:string;
  TrainnosInfo:RRsTrainnosInfo;
begin
  if m_strTrainNoGUID <> '' then
  begin
    if not m_webTrainNo.GetByID(m_strTrainNoGUID,TrainnosInfo,strError) then
    begin
      Box(strError);
      btnSave.Enabled := false;
      exit;
    end;
    edtTrainNo.Text := TrainnosInfo.trainNo;
    edtRemark.Text := TrainnosInfo.Remark;
    dtpPlanStart.Time := TimeOf(StrToDateTime(TrainnosInfo.StartTime));
    dtpPlanKaiChe.Time := TimeOf(StrToDateTime(TrainnosInfo.kaiCheTime));

    comboPlaceName.ItemIndex := comboPlaceName.Values.IndexOf(TrainnosInfo.placeID);
    comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(TrainnosInfo.trainjiaoluID);
    comboStartStation.ItemIndex := comboStartStation.Values.IndexOf(TrainnosInfo.startStationID);
    comboEndStation.ItemIndex := comboEndStation.Values.IndexOf(TrainnosInfo.endStationID);
    comboTrainmanType.ItemIndex := comboTrainmanType.Values.IndexOf(TrainnosInfo.trainmanTypeID);
    comboPlanType.ItemIndex := comboPlanType.Values.IndexOf(TrainnosInfo.PlanTypeID);
    comboDragType.ItemIndex := comboDragType.Values.IndexOf(TrainnosInfo.DragTypeID);
    ComboKehuo.ItemIndex := ComboKehuo.Values.IndexOf(TrainnosInfo.KeHuoID);
    comboRemark.ItemIndex := comboRemark.Values.IndexOf(TrainnosInfo.RemarkTypeID);
    edtTrainTypeName.Text := TrainnosInfo.TrainTypeName;
    edtTrainTypeNumber.Text := TrainnosInfo.TrainNumber;

    cbbbRest.ItemIndex := TrainnosInfo.nNeedRest;
    if TrainnosInfo.nNeedRest = 1 then
    begin
      dtpWaitWorkTime.Time := TimeOf(StrToDateTime(TrainnosInfo.dtArriveTime));
      dtpCallWorkTime.Time := TimeOf(StrToDateTime(TrainnosInfo.dtCallTime));
    end;

    strList := TStringList.Create;
    try
      strList.CommaText := TrainnosInfo.strWorkDay;
      for I := 0 to strList.Count - 1 do
      begin
        if Trim(strList.Strings[i]) = '' then Continue;
        
        case StrToInt( strList.Strings[i] ) of
        1: chkMon.Checked := True ;
        2: chkTues.Checked := True ;
        3: chkWes.Checked := True ;
        4: chkThur.Checked := True ;
        5: chkFri.Checked  := True ;
        6: chkSat.Checked  := True ;
        7: chkSun.Checked  := True ;
        end;
      end;
    finally
      strList.Free;
    end;

  end;
end;

procedure TfrmTrainNoadd.InitStations;
var
  stationArray : TRsStationArray;
  i: Integer;
  trainJiaolu : RRsTrainJiaolu;
  ErrInfo: string;
begin
  {$region '初始化开始站结束站'}
  if not RsLCBaseDict.LCStation.GetStationsOfJiaoJu(m_strDefaultTrainJiaoluGUID,stationArray,ErrInfo) then
  begin
    BoxErr(ErrInfo);
  end;

  if not RsLCBaseDict.LCTrainJiaolu.GetTrainJiaolu(m_strDefaultTrainJiaoluGUID,trainJiaolu) then
  begin
    BoxErr('未获取当前行车区段的信息');
    btnSave.Enabled := false;
    exit;
  end;
  
  comboStartStation.Items.Clear;
  comboStartStation.Values.Clear;

  comboEndStation.Items.Clear;
  comboEndStation.Values.Clear;

  for i := 0 to length(stationArray) - 1 do
  begin
    comboStartStation.AddItemValue(stationArray[i].strStationName,stationArray[i].strStationGUID);
    comboEndStation.AddItemValue(stationArray[i].strStationName,stationArray[i].strStationGUID);
  end;


  if trainJiaolu.strStartStation = '' then
    comboStartStation.ItemIndex := 0
  else
    comboStartStation.ItemIndex := comboStartStation.Values.IndexOf(trainJiaolu.strStartStation);

  if trainJiaolu.strEndStation = '' then
    comboEndStation.ItemIndex := 0
  else
    comboEndStation.ItemIndex := comboEndStation.Values.IndexOf(trainJiaolu.strEndStation);
  {$endregion '初始化开始站结束站'}
end;




end.
