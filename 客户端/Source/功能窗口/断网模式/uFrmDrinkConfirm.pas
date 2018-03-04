unit uFrmDrinkConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, PngImageList, RzPanel, jpeg, RzLabel, StdCtrls, pngimage,
  ExtCtrls,uTrainPlan,uTrainman,uApparatusCommon, Buttons,
  PngSpeedButton,uTFVariantUtils,uSaftyEnum,uDBTrainPlan,uTFSystem,utfPopBox;

type
  TFrmDrinkConfirm = class(TForm)
    Panel1: TPanel;
    RzPanel4: TRzPanel;
    Image1: TImage;
    Label2: TLabel;
    RzGroupBox1: TRzGroupBox;
    Label4: TLabel;
    lblTrainNo: TRzLabel;
    lblTrain: TRzLabel;
    Label1: TLabel;
    lblChuQin: TRzLabel;
    Label10: TLabel;
    lblStart: TRzLabel;
    Label11: TLabel;
    RzPanel9: TRzPanel;
    pTrainman: TRzPanel;
    lblTrainmanPos: TLabel;
    lblTrainman: TLabel;
    ScrollBox1: TScrollBox;
    pDrink: TPanel;
    RzPanel6: TRzPanel;
    ImgTrainmanDrink: TImage;
    Label8: TLabel;
    lblDrinkResult: TLabel;
    RzPanel7: TRzPanel;
    Label32: TLabel;
    lblDrinkIsOk: TRzLabel;
    RzPanel5: TRzPanel;
    Label30: TLabel;
    RzLabel1: TRzLabel;
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_DBTrainPlan : TRsDBTrainPlan;
    //创建创建之前指纹仪的时间
    m_OldOnTouching : TNotifyEvent;
    Trainman : RRsTrainman;
    TrainmanPlan : RRsTrainmanPlan;
    Verify : TRsRegisterFlag;
    Post : TRsPost;
    TestAlcoholInfo : RTestAlcoholInfo;
    procedure InitTrainPlan;
    procedure InitTrainman;
    procedure InitData;
    //指纹触摸处理函数
    procedure FingerTouchingProc(Sender : TObject);
  public
    //显示确认出勤窗口
    class function ShowChuQinForm(Trainman : RRsTrainman;Verify :TRsRegisterFlag;
      Post : TRsPost;TestAlcoholInfo : RTestAlcoholInfo;Trainmanplan:RRsTrainmanPlan):boolean;
  end;

implementation
uses
  uGlobalDM;
{$R *.dfm}

procedure TFrmDrinkConfirm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmDrinkConfirm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmDrinkConfirm.FingerTouchingProc(Sender: TObject);
begin
  //此处不处理，仅为了让指纹仪的事件释放
end;

procedure TFrmDrinkConfirm.FormCreate(Sender: TObject);
begin
  m_OldOnTouching := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := FingerTouchingProc;
  m_DBTrainPlan := TRsDBTrainPlan.Create(GlobalDM.ADOConnection);
  lblTrainNo.Caption := '';

  lblTrain.Caption := '';

  lblChuQin.Caption := '';
  lblStart.Caption := '';
end;

procedure TFrmDrinkConfirm.FormDestroy(Sender: TObject);
begin
  GlobalDM.OnFingerTouching := m_OldOnTouching;
  m_DBTrainPlan.Free;
end;

procedure TFrmDrinkConfirm.FormShow(Sender: TObject);
begin
  InitData;
end;

procedure TFrmDrinkConfirm.InitData;
begin
  InitTrainPlan;
  InitTrainman;
end;

procedure TFrmDrinkConfirm.InitTrainman;
var
  strVerifyName : string;
begin
  {$region '司机验证信息'}
  //初始化人员信息
  if Verify = rfFingerprint then
    strVerifyName := '指纹'
  else
    strVerifyName := '工号';
  lblTrainman.Caption := Format('%s:%s【%s】',[Trainman.strTrainmanName,Trainman.strTrainmanNumber,strVerifyName]);
  lblTrainmanPos.Caption := TRsPostNameAry[Post];
  {$endregion '司机验证信息'}

  {$region '测酒信息'}
    case TestAlcoholInfo.taTestAlcoholResult of
      taNormal: begin
        lblDrinkResult.Font.Color := clBlack;
        lblDrinkResult.Caption := '正常';
        lblDrinkIsOk.Font.Color := clGreen;
        lblDrinkIsOk.Caption := '验证通过';
      end;
      taAlcoholContentMiddling: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '饮酒';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '验证失败';
      end;

      taAlcoholContentHeight: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '酗酒';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '验证失败';
      end;

      taNoTest: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '未测酒';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '验证失败';
      end;
      tsError: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '测酒仪故障';
        lblDrinkIsOk.Font.Color := clGreen;
        lblDrinkIsOk.Caption := '验证通过';
      end;
    end;
    TTFVariantUtils.CopyJPEGVariantToImage(TestAlcoholInfo.Picture,ImgTrainmanDrink);
  {$endregion '测酒信息'}
end;

procedure TFrmDrinkConfirm.InitTrainPlan;
begin
  {$region '机车计划信息'}
  //初始化机车信息
  lblTrainNo.Caption := TrainmanPlan.TrainPlan.strTrainNo;
  lblTrain.Caption := TrainmanPlan.TrainPlan.strTrainTypeName + '-' + TrainmanPlan.TrainPlan.strTrainNumber;
  if TrainmanPlan.dtBeginWorkTime > 0 then
  lblChuQin.Caption := FormatDateTime('yyyy-MM-dd hh:nn',TrainmanPlan.dtBeginWorkTime);
  if TrainmanPlan.TrainPlan.dtRealStartTime > 0 then
    lblStart.Caption := FormatDateTime('yyyy-MM-dd hh:nn',TrainmanPlan.TrainPlan.dtRealStartTime);
  {$endregion '机车计划信息'}
end;

class function TFrmDrinkConfirm.ShowChuQinForm(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag; Post: TRsPost; TestAlcoholInfo: RTestAlcoholInfo;
  Trainmanplan: RRsTrainmanPlan): boolean;
var
  frmChuQin : TFrmDrinkConfirm;  
begin
  result := false;
  frmChuQin := TFrmDrinkConfirm.Create(nil);
  try
    if GlobalDM.BeginWorkRightBottomShow then
    begin
      frmChuQin.Position := poDesigned;
      frmChuQin.Left := Screen.Width - frmChuQin.Width;
      frmChuQin.Top := Screen.Height - frmChuQin.Height; 
    end;
    frmChuQin.Trainman := Trainman;
    frmChuQin.Verify := Verify;
    frmChuQin.Trainmanplan := trainmanPlan;
    frmChuQin.Post := post;
    frmChuQin.TestAlcoholInfo := TestAlcoholInfo;
    if frmChuQin.ShowModal = mrOk then
    begin
      result := true;
    end;
  finally
    frmChuQin.Free;
  end;
end;

end.
