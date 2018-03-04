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
    //��������֮ǰָ���ǵ�ʱ��
    TrainPlan : RRsTrainmanPlan;
    Trainman : RRsTrainman;
    Verify : TRsRegisterFlag;
    Post : TRsPost;
    TestAlcoholInfo : RTestAlcoholInfo;
    //��ʼ���ƻ���Ϣ
    procedure InitPlan;
    //��ʼ����Ա��Ϣ
    procedure InitTrainman;
    //��ʼ��ȫ������
    procedure InitAll;
    //ָ�ƴ���������
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
  //�˴���������Ϊ����ָ���ǵ��¼��ͷ�
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
  //��ʼ���ƻ���Ϣ
  InitPlan;
  //��ʼ��˾����Ϣ
  InitTrainman;
end;

procedure TfrmTuiQin.InitPlan;
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

procedure TfrmTuiQin.InitTrainman;
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
    TTFVariantUtils.CopyJPEGVariantToImage(TestAlcoholInfo.Picture,ImgTrainmanDrink);
  {$endregion '�����Ϣ'}
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
