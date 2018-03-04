unit uFrmBeginworkVIEW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uBeginworkViewDraw, StdCtrls, ExtCtrls,uTFSystem, jpeg,uLCBeginwork;

type

  
  TfrmBeginworkView = class(TForm)
    pFlowCanvas: TPanel;
    Panel2: TPanel;
    memoBrief: TMemo;
    btnAllow: TButton;
    btnCancel: TButton;
    imgCanvas: TImage;
    btnRefresh: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnAllowClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_strTrainPlanGUID : string;
    m_LCBeginWork:  TLCBeginwork;
    procedure Init;
  public
    { Public declarations }
    class function ShowView(TrainPlanGUID : string) : boolean;
  end;
  

implementation

uses uGlobalDM, DB;





{$R *.dfm}

procedure TfrmBeginworkView.btnAllowClick(Sender: TObject);
var
  AllowInfo : RRsTrainplanBeginworkFlow;
begin
  if not TBox('��ȷ��Ҫ����üƻ�������') then exit;

  AllowInfo.strTrainPlanGUID := m_strTrainPlanGUID;
  AllowInfo.strWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  AllowInfo.nFlowState := 1;
  AllowInfo.strDutyUserName := GlobalDM.DutyUser.strDutyName;
  AllowInfo.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID;
  AllowInfo.strDutyUserNumber := GlobalDM.DutyUser.strDutyNumber;
  AllowInfo.dtConfirmTime := GlobalDM.GetNow;
  AllowInfo.dtCreateTime := AllowInfo.dtConfirmTime;
  AllowInfo.strBrief := memoBrief.Text;
  m_LCBeginWork.AllowBeginwork(AllowInfo);
  
  modalResult := mrOk;
end;

procedure TfrmBeginworkView.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBeginworkView.btnRefreshClick(Sender: TObject);
begin
  Init;
end;

procedure TfrmBeginworkView.FormCreate(Sender: TObject);
begin
  m_LCBeginWork := TLCBeginwork.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmBeginworkView.FormDestroy(Sender: TObject);
begin
  m_LCBeginWork.Free;
end;

procedure TfrmBeginworkView.Init;
var
  viewDraw : TBeginworkViewDraw;
begin
  viewDraw := TBeginworkViewDraw.Create;
  try
    with ViewDraw do
    begin
//      //ÿ���˵Ĳ���߶�
      StepHeight := 100;
//      //����Ŀհ׼��
      StepPadding := 5 ;
//      //��Ƭ�ĸ߶�(���Ϊ3*2����)
      PicHeight := 60;
//      //��Ƭ�Ŀ��
      PicWidth := 90 ;
//      //�������ƿ��
      StepNameWidth :=  80;
//      //�������Ƹ߶�
      StepNameHeight := 25;
//      //���豳��ɫ
//      StepNameBgcolor : TColor;
//      //��������
      StepNameFont.Size := 12;
//      //�������ƾඥ�˸߶�
      StepNameTop := 20;//

//      //����������ɫ
      Font.Size := 9;
//
//      //��İ뾶
      DotWidth := 20;
    end;
    
    viewDraw.Draw(imgCanvas.Canvas,Rect(0,0,imgCanvas.Width,imgCanvas.Height),
      m_strTrainPlanGUID,GlobalDM.SiteInfo.WorkShopGUID,true);
  finally
    viewDraw.Free;
  end;
end;

class function TfrmBeginworkView.ShowView(TrainPlanGUID: string) : boolean;
var
  frmBeginworkView: TfrmBeginworkView;
begin
  result := false;
  frmBeginworkView := TfrmBeginworkView.Create(nil);
  try
    frmBeginworkView.m_strTrainPlanGUID := TrainPlanGUID;
    frmBeginworkView.Init;
    if frmBeginworkView.ShowModal = mrOk then
      result := true;
  finally
    frmBeginworkView.Free;
  end;
end;

end.
