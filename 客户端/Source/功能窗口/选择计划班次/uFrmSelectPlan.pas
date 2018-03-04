unit uFrmSelectPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, StdCtrls,uTFSystem, Mask, RzEdit, ActnList;

type
  TFrmSelectPlan = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    edtTrainNo: TRzEdit;
    edtTrainTypeName: TRzEdit;
    edtTrainNumber: TRzEdit;
    btnCance: TPngCustomButton;
    btnSave: TPngCustomButton;
    PngCustomButton3: TPngCustomButton;
    lblHint: TLabel;
    ActionList1: TActionList;
    actOk: TAction;
    actCancel: TAction;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    //检查输入条件是否合格
    function CheckInput():Boolean;
    // 获取结果
    procedure GetResult();
  private
    { Private declarations }
    //车次
    m_strTrainNo : string ;
    //车号
    m_strTrainNumber : string ;
    //车型
    m_strTrainTypeName : string ;
  public
    { Public declarations }
    class function GetSelectTrain(var TrainNo,TrainNumber,TrainTypeName:string):Boolean;
  end;

var
  FrmSelectPlan: TFrmSelectPlan;

implementation

{$R *.dfm}

procedure TFrmSelectPlan.actCancelExecute(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmSelectPlan.actOkExecute(Sender: TObject);
begin
  if not CheckInput then
    exit ;
  ModalResult := mrOk ;
end;

procedure TFrmSelectPlan.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmSelectPlan.btnSaveClick(Sender: TObject);
begin
  if not CheckInput then
    exit ;
  ModalResult := mrOk
end;

function TFrmSelectPlan.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtTrainNo.Text) = '' then
  begin
    edtTrainNo.SetFocus ;
    BoxErr('车次不能为空,请输入车次!');
    Exit ;
  end;

  //获取结果
  GetResult();
  Result := True ;
end;

procedure TFrmSelectPlan.FormCreate(Sender: TObject);
begin
  m_strTrainNo := '' ;
  m_strTrainNumber := '' ;
  m_strTrainTypeName := '' ;
end;

procedure TFrmSelectPlan.GetResult;
begin
  m_strTrainNo := Trim(edtTrainNo.Text) ;
  m_strTrainNumber := Trim(edtTrainNumber.Text) ;
  m_strTrainTypeName := Trim(edtTrainTypeName.Text) ;
end;

class function TFrmSelectPlan.GetSelectTrain(var TrainNo, TrainNumber,
  TrainTypeName: string): Boolean;
var
  frm : TFrmSelectPlan ;
begin
  Result := False ;
  frm := TFrmSelectPlan.Create(nil);
  try
    if frm.ShowModal = mrOk then
    begin
      TrainNo := frm.m_strTrainNo ;
      TrainNumber := frm.m_strTrainNumber ;
      TrainTypeName := frm.m_strTrainTypeName ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

end.
