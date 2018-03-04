unit uFrmTrainNoSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList,ADODB;

type
  TfrmTrainNoSelect = class(TForm)
    Label1: TLabel;
    CombTrainNo: TComboBox;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    procedure actEnterExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_TrainNoGUIDs : TStrings;
  public
    { Public declarations }
  end;

var
  frmTrainNoSelect: TfrmTrainNoSelect;

implementation

{$R *.dfm}
uses
  uTrainNo,uDataModule;
procedure TfrmTrainNoSelect.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmTrainNoSelect.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmTrainNoSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainNoSelect.btnSaveClick(Sender: TObject);
begin
  if Trim(CombTrainNo.Text) = '' then
  begin
    Application.MessageBox('请选择车次','提示',MB_OK + MB_ICONINFORMATION);
    CombTrainNo.SetFocus;
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmTrainNoSelect.FormCreate(Sender: TObject);
var
  ado : TADOQuery;
begin
  m_TrainNoGUIDs := TStringList.Create;
  TTrainNoOpt.GetTrainNos(DMGlobal.LocalArea,ado);
  try
    with ado do
    begin
      while not eof do
      begin
        CombTrainNo.Items.Add(FieldByName('strTrainNo').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmTrainNoSelect.FormDestroy(Sender: TObject);
begin
  m_TrainNoGUIDs.Free;
end;

end.
