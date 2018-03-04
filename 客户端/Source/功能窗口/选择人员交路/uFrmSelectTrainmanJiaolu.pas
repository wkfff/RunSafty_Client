unit uFrmSelectTrainmanJiaolu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, ExtCtrls;

type
  TfrmSelectTrainmanJiaolu = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    comboTrainmanJiaolu: TRzComboBox;
    Timer1: TTimer;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure comboLineChange(Sender: TObject);
  private
    { Private declarations }
    procedure InitLines;
    procedure InitTrainmanJiaolus;
  public
    { Public declarations }
  end;

function SelectTrainmanJiaolu(var TrainmanJiaoluGUID : string) : boolean;

implementation

uses
  uGlobalDM,uDBTrainmanJiaolu,uTrainmanJiaolu,uLine,uDBLine;
{$R *.dfm}
function SelectTrainmanJiaolu(var TrainmanJiaoluGUID : string) : boolean;
var
  frmSelectTrainmanJiaolu: TfrmSelectTrainmanJiaolu;
begin
  Result := false;
  frmSelectTrainmanJiaolu:= TfrmSelectTrainmanJiaolu.Create(nil);
  try
    if frmSelectTrainmanJiaolu.ShowModal = mrOk then
    begin
      TrainmanJiaoluGUID := frmSelectTrainmanJiaolu.comboTrainmanJiaolu.Value;
      Result := true;
    end;
  finally
    frmSelectTrainmanJiaolu.Free;
  end;
end;

procedure TfrmSelectTrainmanJiaolu.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelectTrainmanJiaolu.btnOKClick(Sender: TObject);
begin
  if comboTrainmanJiaolu.Value = '' then
  begin
    Application.MessageBox('请选择人员交路','提示',MB_OK + MB_ICONINFORMATION);
  end;
  ModalResult := mrOk;
end;

procedure TfrmSelectTrainmanJiaolu.comboLineChange(Sender: TObject);
begin
  InitTrainmanJiaolus;
end;

procedure TfrmSelectTrainmanJiaolu.FormShow(Sender: TObject);
begin
  btnOK.Enabled := false;
  Timer1.Enabled := true;
end;

procedure TfrmSelectTrainmanJiaolu.InitLines;
begin

end;

procedure TfrmSelectTrainmanJiaolu.InitTrainmanJiaolus;
var
  i: Integer;
  dbtrainmanJiaolu : TRsDBTrainmanJiaolu;
  trainmanJiaoluArray : TRsTrainmanJiaoluArray;
begin
  comboTrainmanJiaolu.Items.Clear;
  comboTrainmanJiaolu.Values.Clear;

  dbtrainmanJiaolu := TRsDBTrainmanJiaolu.Create(GlobalDM.ADOConnection);
  try
    dbtrainmanJiaolu.GetTrainmanJiaolusOfSite(GlobalDM.SiteInfo.strSiteGUID,
      trainmanJiaoluArray);
  finally
    dbtrainmanJiaolu.Free;
  end;
  for i := 0 to length(trainmanJiaoluArray) - 1 do
  begin
    comboTrainmanJiaolu.AddItemValue(trainmanjiaoluarray[i].strTrainmanJiaoluName,trainmanjiaoluarray[i].strTrainmanJiaoluGUID);
  end;
  if comboTrainmanJiaolu.Items.Count > 0 then
  begin
    comboTrainmanJiaolu.ItemIndex := 0;
  end;
end;

procedure TfrmSelectTrainmanJiaolu.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  InitLines;
  InitTrainmanJiaolus;
  btnOK.Enabled := true;
end;

end.
