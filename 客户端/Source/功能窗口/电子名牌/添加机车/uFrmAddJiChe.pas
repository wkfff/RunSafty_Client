unit uFrmAddJiChe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, ExtCtrls,uLCBaseDict;

type
  TFrmAddJiChe = class(TForm)
    ComboTrainType: TComboBox;
    Label1: TLabel;
    edtTrainNumber: TEdit;
    Label2: TLabel;
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FJiCheType: string;
    FJiCheNo: string;
    { Private declarations }
    procedure InitData;
  public
    class function InputTrainInfo(var JieCheType : string;var JiCheNo : string) : boolean;
  end;

var
  FrmAddJiChe: TFrmAddJiChe;

implementation
uses
  uGlobalDM;
{$R *.dfm}

procedure TFrmAddJiChe.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmAddJiChe.btnOkClick(Sender: TObject);
begin
  if Trim(ComboTrainType.Text) = '' then
  begin
    ComboTrainType.SetFocus;
    Application.MessageBox(PChar('请选择机车类型'),'提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Trim(edtTrainNumber.Text) = '' then
  begin
    edtTrainNumber.SetFocus;
    Application.MessageBox(PChar('请输入机车号'),'提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if ComboTrainType.Items.IndexOf(ComboTrainType.Text) < 0 then
  begin
    if Application.MessageBox(PChar('您输入的机车类型在预定义列表中不存在，确认没有输错吗？'),'提示',MB_OKCANCEL + MB_ICONINFORMATION) = mrCancel then exit;
  end;

  FJiCheType := ComboTrainType.Text;
  FJiCheNo := edtTrainNumber.Text;
  ModalResult := mrOk;
end;

procedure TFrmAddJiChe.FormShow(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TFrmAddJiChe.InitData;
var
  strTrainTypes : TStrings;
  i: Integer;
begin
  strTrainTypes := TStringList.Create;
  try
    RsLCBaseDict.LCTrainType.GetTrainTypes(strTrainTypes);
    for i := 0 to strTrainTypes.Count - 1 do
    begin
      ComboTrainType.Items.Add(strTrainTypes[i]);
    end;
    ComboTrainType.ItemIndex := ComboTrainType.Items.IndexOf(FJiCheType);
    edtTrainNumber.Text := FJiCheNo;
  finally
    strTrainTypes.Free;
  end;
end;

class function TFrmAddJiChe.InputTrainInfo(var JieCheType,
  JiCheNo: string): boolean;
var
  frmAddJiChe : TFrmAddJiChe;
begin
  result := false;
  frmAddJiChe := TFrmAddJiChe.Create(nil);
  try
    frmAddJiChe.FJiCheType := JieCheType;
    frmAddJiChe.FJiCheNo :=  JiCheNo;
    if frmAddJiChe.ShowModal = mrCancel then exit;
    JieCheType := UpperCase(frmAddJiChe.FJiCheType);
    JiCheNo  := UpperCase(frmAddJiChe.FJiCheNo);
    result := true;
  finally
    frmAddJiChe.Free;
  end;
end;

procedure TFrmAddJiChe.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  try
    InitData;
  except on e : exception do
    Application.MessageBox(PChar('加载数据失败：' + e.Message),'提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

end.
