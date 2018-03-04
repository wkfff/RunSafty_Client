unit uFrmSetBeginWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, StdCtrls, ExtCtrls, RzPanel, ComCtrls,
  uTrainPlan,uDBTrainPlan,uTFSystem, AdvDateTimePicker;

type
  TfrmSetBeginWork = class(TForm)
    RzPanel1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label3: TLabel;
    Label2: TLabel;
    dtpBeginWorkTime: TAdvDateTimePicker;
    dtpRealStartTime: TAdvDateTimePicker;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    m_TrainmanPlan : RRsTrainmanPlan;
    m_DBTrainPlan : TRsDBTrainPlan;
    procedure InitData;
    function  CheckInput : boolean;
  public
    { Public declarations }
    //���üƻ��ĳ���ʱ��
    class function SetBeginWorkTime(TrainmanPlan : RRsTrainmanPlan) : boolean;
  end;

implementation
uses
  uGlobalDM,DateUtils;
{$R *.dfm}

{ TfrmSetBeginWork }

procedure TfrmSetBeginWork.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetBeginWork.btnOKClick(Sender: TObject);
begin
  if not CheckInput then exit;
  if not TBox('��ȷ��Ҫ�޸ļƻ��ĳ���ʱ����') then exit;
  try
    m_DBTrainPlan.SetBeginWorkTime(m_TrainmanPlan.TrainPlan.strTrainPlanGUID,
      m_TrainmanPlan.dtBeginWorkTime,dtpBeginWorkTime.DateTime,GlobalDM.DutyUser,
      GlobalDM.SiteInfo);
    ModalResult := mrOk;
  except on e : exception do
    Box('����ʧ�ܣ�' + e.Message);
  end;
end;

function TfrmSetBeginWork.CheckInput: boolean;
begin
  result := false;
  if dtpBeginWorkTime.DateTime >= m_TrainmanPlan.TrainPlan.dtRealStartTime then
  begin
    Box('����ʱ�����С�ڿ���ʱ��');
    exit;
  end;
  result := true;
end;

procedure TfrmSetBeginWork.FormCreate(Sender: TObject);
begin
 m_DBTrainPlan := TRsDBTrainPlan.Create(GlobalDM.ADOConnection);
end;

procedure TfrmSetBeginWork.FormDestroy(Sender: TObject);
begin
  m_DBTrainPlan.Free;
end;

procedure TfrmSetBeginWork.InitData;
begin
  dtpRealStartTime.DateTime := m_TrainmanPlan.TrainPlan.dtRealStartTime;
  dtpBeginWorkTime.DateTime := m_TrainmanPlan.dtBeginWorkTime;
  if m_TrainmanPlan.dtBeginWorkTime = 0 then
    dtpBeginWorkTime.DateTime := IncHour(m_TrainmanPlan.TrainPlan.dtRealStartTime,-1);
end;

class function TfrmSetBeginWork.SetBeginWorkTime(
  TrainmanPlan: RRsTrainmanPlan): boolean;
var
  frmSetBeginWork : TfrmSetBeginWork;
begin
  result := false;
  frmSetBeginWork:= TfrmSetBeginWork.create(nil);
  try
    frmSetBeginWork.m_TrainmanPlan := TrainmanPlan;
    frmSetBeginWork.InitData;
    if frmSetBeginWork.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmSetBeginWork.free;
  end;
end;

end.
