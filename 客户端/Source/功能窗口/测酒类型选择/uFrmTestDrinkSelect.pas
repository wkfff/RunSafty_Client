unit uFrmTestDrinkSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngCustomButton,uGlobalDM,uTFSystem, RzButton,
  RzRadChk, ActnList, Mask, RzEdit;

type
  TFrmTestDrinkSelect = class(TForm)
    PngCustomButton1: TPngCustomButton;
    lblHint: TLabel;
    GroupBox1: TGroupBox;
    rbChuQin: TRzRadioButton;
    rbTuiQin: TRzRadioButton;
    rbTest: TRzRadioButton;
    btnSave: TButton;
    btnCancel: TButton;
    ActionList1: TActionList;
    actOk: TAction;
    actCancel: TAction;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    edtTrainNo: TRzEdit;
    edtTrainTypeName: TRzEdit;
    edtTrainNumber: TRzEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rbTestClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure InitData(DrinkType:Integer);
        //检查输入条件是否合格
    function CheckInput():Boolean;
        // 获取结果
    procedure GetResult();
  private
    { Private declarations }
    //传入的测酒类型
    m_DrinkType : Integer ;

    //车次
    m_strTrainNo : string ;
    //车号
    m_strTrainNumber : string ;
    //车型
    m_strTrainTypeName : string ;
  public
    { Public declarations }

    class function GetDrinkInfo(const DrinkType:Integer;out AType:Integer;var TrainNo,TrainNumber,TrainTypeName:string):Boolean ;
  end;

var
  FrmTestDrinkSelect: TFrmTestDrinkSelect;

implementation

{$R *.dfm}

procedure TFrmTestDrinkSelect.btnCancelClick(Sender: TObject);
begin
  if TBox('是否确定取消测酒?') then
  
  ModalResult := mrCancel ;
end;

procedure TFrmTestDrinkSelect.btnSaveClick(Sender: TObject);
begin

  if not CheckInput then
    exit ;

  if rbChuQin.Checked then
    m_DrinkType  :=  DRINK_TEST_CHU_QIN
  else if rbTuiQin.Checked then
    m_DrinkType :=   DRINK_TEST_TUI_QIN
  else
    m_DrinkType :=   DRINK_TEST_TEST ;


  //获取结果
  GetResult();

  ModalResult := mrOk ;
end;

function TFrmTestDrinkSelect.CheckInput: Boolean;
begin
  Result := False ;
  //换班测酒不需要输入车次信息
  if not rbTest.Checked then
  begin
    if Trim(edtTrainNo.Text) = '' then
    begin
      edtTrainNo.SetFocus ;
      BoxErr('车次不能为空,请输入车次!');
      Exit ;
    end;
  end;

  Result := True ;
end;

procedure TFrmTestDrinkSelect.FormCreate(Sender: TObject);
begin
  m_strTrainNo := '' ;
  m_strTrainNumber := '' ;
  m_strTrainTypeName := '' ;
end;

procedure TFrmTestDrinkSelect.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TFrmTestDrinkSelect.FormShow(Sender: TObject);
begin
    edtTrainNo.SetFocus ;
end;

class function TFrmTestDrinkSelect.GetDrinkInfo(const DrinkType: Integer;
  out AType: Integer; var TrainNo, TrainNumber, TrainTypeName: string): Boolean;
var
  frm : TFrmTestDrinkSelect ;
begin
  Result := False ;
  frm := TFrmTestDrinkSelect.Create(nil);
  try
    frm.InitData(DrinkType);
    if frm.ShowModal = mrOk then
    begin
      AType := frm.m_DrinkType ;
      TrainNo := frm.m_strTrainNo ;
      TrainNumber := frm.m_strTrainNumber ;
      TrainTypeName := frm.m_strTrainTypeName ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;



procedure TFrmTestDrinkSelect.GetResult;
begin
  m_strTrainNo := Trim(edtTrainNo.Text) ;
  m_strTrainNumber := Trim(edtTrainNumber.Text) ;
  m_strTrainTypeName := Trim(edtTrainTypeName.Text) ;
end;

procedure TFrmTestDrinkSelect.InitData(DrinkType: Integer);
begin
  m_DrinkType := DrinkType ;
  case DrinkType of
  DRINK_TEST_CHU_QIN :
    begin
      rbChuQin.Checked := True ;
      rbTuiQin.Checked := False ;
      rbTest.Checked := False ;
    end;
  DRINK_TEST_TUI_QIN :
    begin
    rbChuQin.Checked := False ;
    rbTuiQin.Checked := True ;
    rbTest.Checked := False ;
    end;
  DRINK_TEST_TEST :
    begin
      rbChuQin.Checked := False ;
      rbTuiQin.Checked := False ;
      rbTest.Checked := True ;
    end;
  end;
end;

procedure TFrmTestDrinkSelect.rbTestClick(Sender: TObject);
begin
  ;
end;

end.
