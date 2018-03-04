unit uFrmOutRoom2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uTrainman, uApparatusCommon, uTrainPlan, ExtCtrls, jpeg, Buttons,
  PngSpeedButton, RzLabel, RzPanel, StdCtrls, pngimage, uTFVariantUtils,uSaftyEnum;

type
  TfrmOutRoom2 = class(TForm)
    Panel1: TPanel;
    RzPanel4: TRzPanel;
    Image1: TImage;
    Label2: TLabel;
    RzGroupBox1: TRzGroupBox;
    lblTrainPlan: TRzLabel;
    lblStationSection: TRzLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTrainNo: TRzLabel;
    lblTrain: TRzLabel;
    Label1: TLabel;
    lblKehuo: TRzLabel;
    Label6: TLabel;
    lblTrainmanType: TRzLabel;
    Label12: TLabel;
    Label9: TLabel;
    lblArriveTime: TRzLabel;
    Label13: TLabel;
    lblCallTime: TRzLabel;
    RzPanel9: TRzPanel;
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    pTrainman: TRzPanel;
    lblTrainmanPos: TLabel;
    lblTrainman: TLabel;
    ScrollBox1: TScrollBox;
    pDrink: TPanel;
    RzPanel6: TRzPanel;
    ImgTrainmanStandard: TImage;
    Label5: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    lblTrainmanState: TLabel;
    lblInRoomTime: TLabel;
    lblRoomNumber: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    m_oldTouchingEvent: TNotifyEvent;
    procedure StartTuiQinStep(Sender: TObject);
    procedure InitAll;
  public
    { Public declarations }
    Trainman: RRsTrainman;
    Verify: TRsRegisterFlag;
    TrainPlan: RRsInOutPlan;
    Post: TRsPost;
    {功能:按下鼠标}
    procedure FingerTouching(Sender: TObject);
  end;

implementation
uses
  uGlobalDM, uFrmTrainmanIdentity, uDBTrainPlan, uFrmFindRoom;
{$R *.dfm}

procedure TfrmOutRoom2.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOutRoom2.btnOKClick(Sender: TObject);
var
  OutRoomInfo: RRsOutRoomInfo;
begin
  OutRoomInfo.strTrainPlanGUID := TrainPlan.TrainPlan.strTrainPlanGUID;
  OutRoomInfo.strTrainmanGUID := Trainman.strTrainmanGUID;
  OutRoomInfo.nVerifyID := Verify;

  OutRoomInfo.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID;
  if not TRsDBTrainPlan.OutRoom(GlobalDM.ADOConnection, OutRoomInfo) then
  begin
    Application.MessageBox('离寓失败', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.MessageBox('离寓完成', '提示', MB_OK + MB_ICONINFORMATION);
  ModalResult := mrOk;
end;

procedure TfrmOutRoom2.FingerTouching(Sender: TObject);
begin
  StartTuiQinStep(Sender);
  btnOK.Enabled := false;
  InitAll;
  if Trainman.strTrainmanGUID <> '' then
  begin
    btnOK.Enabled := true;
  end;
end;

procedure TfrmOutRoom2.FormCreate(Sender: TObject);
begin
  lblTrainPlan.Caption := '';
  lblStationSection.Caption := '';
  lblTrainNo.Caption := '';

  lblKehuo.Caption := '';
  lblTrainmanType.Caption := '';
  lblTrain.Caption := '';

  lblArriveTime.Caption := '';
  lblCallTime.Caption := '';
  m_oldTouchingEvent := GlobalDM.OnFingerTouching;
  //挂接指纹仪点击事件

  GlobalDM.OnFingerTouching := FingerTouching;
end;

procedure TfrmOutRoom2.FormDestroy(Sender: TObject);
begin
  GlobalDM.OnFingerTouching := m_oldTouchingEvent;
end;

procedure TfrmOutRoom2.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TfrmOutRoom2.InitAll;
var
  strVerifyName: string;
begin
{$REGION '机车计划信息'}
  //初始化机车信息
  lblTrainPlan.Caption := TrainPlan.TrainPlan.strTrainJiaoluName;
  lblStationSection.Caption := trainPlan.TrainPlan.strStartStationName + '--' + TrainPlan.TrainPlan.strEndStationName;
  lblTrainNo.Caption := trainPlan.TrainPlan.strTrainNo;
//  lblKehuo.Caption := trainPlan.TrainPlan.strKeHuoName;
  lblTrainmanType.Caption := '双司机';
//  if trainPlan.TrainPlan.nTrainmanTypeID = 1 then
//    lblTrainmanType.Caption := '双司机';
  lblTrain.Caption := trainPlan.TrainPlan.strTrainTypeName + '-' + trainPlan.TrainPlan.strTrainNumber;
  //lblArriveTime.Caption := FormatDateTime('yyyy-MM-dd hh:nn', trainPlan.TrainPlan.Rest.dtArriveTime);
  //lblCallTime.Caption := FormatDateTime('yyyy-MM-dd hh:nn', trainPlan.TrainPlan.Rest.dtCallTime);

  if trainPlan.InOutGroup.strRoomNumber <> '' then
  begin
    lblRoomNumber.Caption := trainPlan.InOutGroup.strRoomNumber;

  end;
{$ENDREGION '机车计划信息'}

{$REGION '司机验证信息'}
  //初始化人员信息
  if Verify = rfFingerprint then
    strVerifyName := '指纹'
  else
    strVerifyName := '工号';
  lblTrainman.Caption := Format('%s:%s【%s】', [Trainman.strTrainmanName, Trainman.strTrainmanNumber, strVerifyName]);
  lblTrainmanPos.Caption := TRsPostNameAry[Post];
{$ENDREGION '司机验证信息'}

{$REGION '司机照片'}
  if Trainman.strTrainmanGUID <> '' then
  begin
    TTFVariantUtils.CopyJPEGVariantToImage(Trainman.Picture, ImgTrainmanStandard);
  end;
{$ENDREGION '司机照片'}
end;

procedure TfrmOutRoom2.StartTuiQinStep(Sender: TObject);
var
  tMan: RRsTrainman;
  vf: TRsRegisterFlag;
begin

{$REGION '验证司机身份'}
  if not IdentfityTrainman(Sender, tMan, vf,'','','','') then
  begin
    Application.MessageBox('没有找到相应的乘务员信息', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
{$ENDREGION '验证司机身份'}

{$REGION '验证司机所属计划及状态'}
  if TrainPlan.TrainPlan.strTrainPlanGUID = '' then
  begin
    if not TRsDBTrainPlan.GetTrainmanInOutPlan(GlobalDM.ADOConnection, tman.strTrainmanGUID, TrainPlan) then
    begin
      Application.MessageBox('没有找到该人员的行车计划!', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
  end;
  if ((tman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID) and
    (tman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID) and
    (tman.strTrainmanGUID <> trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID)) then
  begin
    Application.MessageBox('司机与指定的计划人员不符!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if tman.nTrainmanState <> tsInRoom then
  begin
    Application.MessageBox('该人员不在入寓状态!', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
{$ENDREGION '验证司机所属计划及状态'}

  post := ptTrainman;
  if tman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman1.strTrainmanGUID then
  begin
    post := ptTrainman;
  end;
  if tman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman2.strTrainmanGUID then
  begin
    post := ptSubTrainman;
  end;
  if tman.strTrainmanGUID = trainPlan.InOutGroup.Group.Trainman3.strTrainmanGUID then
  begin
    post := ptLearning;
  end;
  Trainman.Assign(tman);
end;

procedure TfrmOutRoom2.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  btnOK.Enabled := false;
  InitAll;
  if Trainman.strTrainmanGUID <> '' then
  begin
    btnOK.Enabled := true;
  end else begin

    StartTuiQinStep(nil);
    if Trainman.strTrainmanGUID = '' then
    begin
      ModalResult := mrCancel;
    end else begin
      InitAll;
      btnOK.Enabled := true;
    end;

  end;
end;

end.

