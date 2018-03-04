unit uFrmTuiQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, RzLabel, RzPanel, StdCtrls, pngimage,ADODB, Buttons,
  PngSpeedButton,uTrainPlan,uTrainman,uApparatusCommon,uTFVariantUtils,
  uSaftyEnum,uTFSystem,utfPopBox, RzEdit;
type
  TfrmTuiQin = class(TForm)
    Panel1: TPanel;
    RzPanel4: TRzPanel;
    Image1: TImage;
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
    lblChuQin: TRzLabel;
    Label10: TLabel;
    lblStart: TRzLabel;
    Label11: TLabel;
    Label2: TLabel;
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    RzPanel9: TRzPanel;
    pTrainman: TRzPanel;
    lblTrainmanPos: TLabel;
    lblTrainman: TLabel;
    ScrollBox1: TScrollBox;
    pDrink: TPanel;
    RzPanel6: TRzPanel;
    ImgTrainmanStandard: TImage;
    ImgTrainmanDrink: TImage;
    Label5: TLabel;
    Label8: TLabel;
    lblDrinkResult: TLabel;
    RzPanel7: TRzPanel;
    Label32: TLabel;
    lblDrinkIsOk: TRzLabel;
    RzPanel5: TRzPanel;
    Label30: TLabel;
    RzLabel1: TRzLabel;
    memTestRemark: TRzMemo;
    Label9: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //创建创建之前指纹仪的时间
    TrainPlan : RRsTrainmanPlan;
    Trainman : RRsTrainman;
    Verify : TRsRegisterFlag;
    Post : TRsPost;
    TestAlcoholInfo : RTestAlcoholInfo;
    //初始化计划信息
    procedure InitPlan;
    //初始化人员信息
    procedure InitTrainman;
    //初始化全部数据
    procedure InitAll;
    //指纹触摸处理函数
    procedure FingerTouchingProc(Sender : TObject);
  public
    { Public declarations }
    class function ShowTuiQinForm(Trainman : RRsTrainman;Verify :TRsRegisterFlag;
      Post : TRsPost;TestAlcoholInfo : RTestAlcoholInfo;Trainmanplan:RRsTrainmanPlan;var strRemark: string):boolean;
  end;
implementation

{$R *.dfm}
uses
  DateUtils,uGlobalDM;
procedure TfrmTuiQin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTuiQin.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmTuiQin.FingerTouchingProc(Sender: TObject);
begin
  //此处不处理，仅为了让指纹仪的事件释放
end;

procedure TfrmTuiQin.FormCreate(Sender: TObject);
begin
  GlobalDM.FingerPrintCtl.EventHolder.Hold;
  GlobalDM.FingerPrintCtl.OnTouch := FingerTouchingProc;
  lblTrainPlan.Caption := '';
  lblStationSection.Caption := '';
  lblTrainNo.Caption := '';

  lblKehuo.Caption := '';
  lblTrainmanType.Caption := '';
  lblTrain.Caption := '';

  lblChuQin.Caption := '';
  lblStart.Caption := '';
end;

procedure TfrmTuiQin.FormDestroy(Sender: TObject);
begin
  GlobalDM.FingerPrintCtl.EventHolder.Restore;
end;

procedure TfrmTuiQin.FormShow(Sender: TObject);
begin
  InitAll;
end;


procedure TfrmTuiQin.InitAll;
begin
  //初始化计划信息
  InitPlan;
  //初始化司机信息
  InitTrainman;
end;

procedure TfrmTuiQin.InitPlan;
begin
  {$region '机车计划信息'}
  //初始化机车信息
  lblTrainPlan.Caption := TrainPlan.TrainPlan.strTrainJiaoluName;
  lblStationSection.Caption := trainPlan.TrainPlan.strStartStationName + '--' +TrainPlan.TrainPlan.strEndStationName;
  lblTrainNo.Caption := trainPlan.TrainPlan.strTrainNo;
  lblKehuo.Caption := TRsKeHuoNameArray[trainPlan.TrainPlan.nKehuoID];

  lblTrainmanType.Caption :=  TRsTrainmanTypeName[trainPlan.TrainPlan.nTrainmanTypeID];
  lblTrain.Caption := trainPlan.TrainPlan.strTrainTypeName + '-' + trainPlan.TrainPlan.strTrainNumber;
  lblChuQin.Caption := FormatDateTime('yyyy-MM-dd hh:nn',trainPlan.dtBeginWorkTime);
  lblStart.Caption := FormatDateTime('yyyy-MM-dd hh:nn',trainPlan.TrainPlan.dtRealStartTime);
  {$endregion '机车计划信息'}
end;

procedure TfrmTuiQin.InitTrainman;
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
  
  {$region '司机照片'}
  TTFVariantUtils.CopyJPEGVariantToImage(Trainman.Picture,ImgTrainmanStandard);
  {$endregion '司机照片'}
  
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

class function TfrmTuiQin.ShowTuiQinForm(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag; Post: TRsPost; TestAlcoholInfo: RTestAlcoholInfo;
  Trainmanplan: RRsTrainmanPlan;var strRemark: string): boolean;
var
  frmTuiQin : TfrmTuiQin;
begin
  result := false;
  frmTuiQin := TfrmTuiQin.Create(nil);
  try

    frmTuiQin.Trainman := Trainman;
    frmTuiQin.Verify := Verify;
    frmTuiQin.TrainPlan := trainmanPlan;
    frmTuiQin.Post := post;
    frmTuiQin.TestAlcoholInfo := TestAlcoholInfo;
    if frmTuiQin.ShowModal = mrOk then
    begin
      strRemark := frmTuiQin.memTestRemark.Lines.Text;
      result := true;
    end;
  finally
    frmTuiQin.Free;
  end;
end;

end.
