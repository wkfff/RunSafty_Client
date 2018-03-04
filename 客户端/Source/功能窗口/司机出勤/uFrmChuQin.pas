unit uFrmChuQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, PngImageList, RzPanel, jpeg, RzLabel, StdCtrls, pngimage,
  ExtCtrls,uFrmThirdInfo,uTrainPlan,uTrainman,uApparatusCommon, Buttons,
  PngSpeedButton,uTFVariantUtils,uSaftyEnum,uTFSystem,utfPopBox,
  RzEdit,uLCBeginwork;

type
  TfrmChuQin = class(TForm)
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
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    memTestRemark: TRzMemo;
    Label9: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //��������֮ǰָ���ǵ�ʱ��
    Trainman : RRsTrainman;
    TrainPlan : RRsTrainmanPlan;
    Verify : TRsRegisterFlag;
    Post : TRsPost;
    TestAlcoholInfo : RTestAlcoholInfo;
    m_LCBeginWork: TLCBeginwork;
    procedure  LoadCheckPoints;
    procedure InitTrainPlan;
    procedure InitTrainman;
    procedure InitData;
    //ָ�ƴ���������
    procedure FingerTouchingProc(Sender : TObject);
  public
    //��ʾȷ�ϳ��ڴ���
    class function ShowChuQinForm(Trainman : RRsTrainman;Verify :TRsRegisterFlag;
      Post : TRsPost;TestAlcoholInfo : RTestAlcoholInfo;Trainmanplan:RRsTrainmanPlan;var strRemark: string):boolean;
  end;

implementation
uses
  uGlobalDM,uCheckRecord;
{$R *.dfm}

procedure TfrmChuQin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmChuQin.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmChuQin.FingerTouchingProc(Sender: TObject);
begin
  //�˴���������Ϊ����ָ���ǵ��¼��ͷ�
end;

procedure TfrmChuQin.FormCreate(Sender: TObject);
begin
  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := FingerTouchingProc;

  m_LCBeginWork := TLCBeginwork.Create(GlobalDM.WebAPIUtils);
  lblTrainPlan.Caption := '';
  lblStationSection.Caption := '';
  lblTrainNo.Caption := '';

  lblKehuo.Caption := '';
  lblTrainmanType.Caption := '';
  lblTrain.Caption := '';

  lblChuQin.Caption := '';
  lblStart.Caption := '';
end;

procedure TfrmChuQin.FormDestroy(Sender: TObject);
begin
  GlobalDM.FingerPrintCtl.EventHolder.Restore();
  m_LCBeginWork.Free;
end;

procedure TfrmChuQin.FormShow(Sender: TObject);
begin
  InitData;
end;

procedure TfrmChuQin.InitData;
begin
  InitTrainPlan;
  InitTrainman;
  LoadCheckPoints;
end;

procedure TfrmChuQin.InitTrainman;
var
  strVerifyName : string;
begin
  {$region '˾����֤��Ϣ'}
  //��ʼ����Ա��Ϣ
  if Verify = rfFingerprint then
    strVerifyName := 'ָ��'
  else
    strVerifyName := '����';
  lblTrainman.Caption := Format('%s:%s��%s��',[Trainman.strTrainmanName,Trainman.strTrainmanNumber,strVerifyName]);
  lblTrainmanPos.Caption := TRsPostNameAry[Post];
  {$endregion '˾����֤��Ϣ'}
  
  {$region '˾����Ƭ'}
  if (VarIsType(Trainman.Picture,varArray)) and (VarArrayHighBound(Trainman.Picture,1) > 0) then
  TTFVariantUtils.CopyJPEGVariantToImage(Trainman.Picture,ImgTrainmanStandard);
  {$endregion '˾����Ƭ'}
  
  {$region '�����Ϣ'}
    case TestAlcoholInfo.taTestAlcoholResult of
      taNormal: begin
        lblDrinkResult.Font.Color := clBlack;
        lblDrinkResult.Caption := '����';
        lblDrinkIsOk.Font.Color := clGreen;
        lblDrinkIsOk.Caption := '��֤ͨ��';
      end;
      taAlcoholContentMiddling: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '����';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '��֤ʧ��';
      end;

      taAlcoholContentHeight: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '���';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '��֤ʧ��';
      end;

      taNoTest: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := 'δ���';
        lblDrinkIsOk.Font.Color := clRed;
        lblDrinkIsOk.Caption := '��֤ʧ��';
      end;
      tsError: begin
        lblDrinkResult.Font.Color := clRed;
        lblDrinkResult.Caption := '����ǹ���';
        lblDrinkIsOk.Font.Color := clGreen;
        lblDrinkIsOk.Caption := '��֤ͨ��';
      end;
    end;
    if (VarIsType(TestAlcoholInfo.Picture,varArray)) and (VarArrayHighBound(TestAlcoholInfo.Picture,1) > 0) then
    TTFVariantUtils.CopyJPEGVariantToImage(TestAlcoholInfo.Picture,ImgTrainmanDrink);
  {$endregion '�����Ϣ'}
end;

procedure TfrmChuQin.InitTrainPlan;
begin
  {$region '�����ƻ���Ϣ'}
  //��ʼ��������Ϣ
  lblTrainPlan.Caption := TrainPlan.TrainPlan.strTrainJiaoluName;
  lblStationSection.Caption := trainPlan.TrainPlan.strStartStationName + '--' +TrainPlan.TrainPlan.strEndStationName;
  lblTrainNo.Caption := trainPlan.TrainPlan.strTrainNo;
  lblKehuo.Caption := TRsKeHuoNameArray[trainPlan.TrainPlan.nKehuoID];

  lblTrainmanType.Caption :=  TRsTrainmanTypeName[trainPlan.TrainPlan.nTrainmanTypeID];
  lblTrain.Caption := trainPlan.TrainPlan.strTrainTypeName + '-' + trainPlan.TrainPlan.strTrainNumber;
  lblChuQin.Caption := FormatDateTime('yyyy-MM-dd hh:nn',trainPlan.dtBeginWorkTime);
  lblStart.Caption := FormatDateTime('yyyy-MM-dd hh:nn',trainPlan.TrainPlan.dtRealStartTime);
  {$endregion '�����ƻ���Ϣ'}
end;

procedure TfrmChuQin.LoadCheckPoints;
var
  i : integer;
  CheckRecordArray : TRsCheckRecordArray;
begin
  m_LCBeginWork.GetTrainmanCheckRecord(Trainman.strTrainmanNumber,
    GlobalDM.GetNow,CheckRecordArray);
  for i := 0 to Length(CheckRecordArray) - 1 do
  begin
    ShowThirdInfo(ScrollBox1,'FrameCheckPoint'+IntToStr(i),CheckRecordArray[i].strPointName,
     CheckRecordArray[i].strItemContent,CheckRecordArray[i].nCheckResult = 0 ,
     CheckRecordArray[i].nIsHold);
  end;
end;

class function TfrmChuQin.ShowChuQinForm(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag; Post: TRsPost; TestAlcoholInfo: RTestAlcoholInfo;
  Trainmanplan: RRsTrainmanPlan;var strRemark: string): boolean;
var
  frmChuQin : TfrmChuQin;  
begin
  result := false;
  frmChuQin := TfrmChuQin.Create(nil);
  try
    if GlobalDM.BeginWorkRightBottomShow then
    begin
      frmChuQin.Position := poDesigned;
      frmChuQin.Left := Screen.Width - frmChuQin.Width;
      frmChuQin.Top := Screen.Height - frmChuQin.Height; 
    end;
    frmChuQin.Trainman := Trainman;
    frmChuQin.Verify := Verify;
    frmChuQin.TrainPlan := trainmanPlan;
    frmChuQin.Post := post;
    frmChuQin.TestAlcoholInfo := TestAlcoholInfo;
    if frmChuQin.ShowModal = mrOk then
    begin
      strRemark := frmChuQin.memTestRemark.Lines.Text;
      result := true;
    end;
  finally
    frmChuQin.Free;
  end;
end;

end.
