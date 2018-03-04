unit ufrmTrainmanPlanEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzDTP, ExtCtrls,uTrainPlan,uTFSystem, RzEdit;

type
  TfrmEditPlanTime = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblTrainNo: TLabel;
    lblPlanTime: TLabel;
    lblPlanJiaoLu: TLabel;
    lblTrainman1: TLabel;
    lblTrainman2: TLabel;
    lblTrainman3: TLabel;
    Bevel1: TBevel;
    Label7: TLabel;
    dtDatePicker: TRzDateTimePicker;
    dtTimePicker: TRzDateTimePicker;
    btnOk: TButton;
    btnCancel: TButton;
    Bevel2: TBevel;
    memRemark: TRzMemo;
    Label8: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetTrainmanPlan(TrainmanPlan: RRsTrainmanPlan);
  public
    { Public declarations }
    class function EditPlanTime(var TrainmanPlan: RRsTrainmanPlan;
      var strRemark: string): Boolean;
  end;
implementation

uses uGlobalDM;

{$R *.dfm}

{ TfrmEditPlanTime }

procedure TfrmEditPlanTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmEditPlanTime.btnOkClick(Sender: TObject);
begin
  if TBox('确定要修改计划时间为' + FormatDateTime('yy-mm-dd hh:nn:ss',
    AssembleDateTime(dtDatePicker.Date,dtTimePicker.Time)) + '吗?') then
    ModalResult := mrOk;
end;

class function TfrmEditPlanTime.EditPlanTime(var TrainmanPlan: RRsTrainmanPlan;
  var strRemark: string): Boolean;
var
  frmEditPlanTime: TfrmEditPlanTime;
begin
  Result := False;
  frmEditPlanTime := TfrmEditPlanTime.Create(nil);
  try
    frmEditPlanTime.SetTrainmanPlan(TrainmanPlan);

    if frmEditPlanTime.ShowModal = mrOk then
    begin
      TrainmanPlan.TrainPlan.dtStartTime :=
        AssembleDateTime(frmEditPlanTime.dtDatePicker.Date,frmEditPlanTime.dtTimePicker.Time);
      strRemark := frmEditPlanTime.memRemark.Lines.Text;
      Result := True;
    end;
    
  finally
    frmEditPlanTime.Free;
  end;

end;

procedure TfrmEditPlanTime.SetTrainmanPlan(TrainmanPlan: RRsTrainmanPlan);
begin
  lblTrainNo.Caption := TrainmanPlan.TrainPlan.strTrainNo;
  lblPlanTime.Caption := FormatDateTime('yy-mm-dd hh:nn:ss',TrainmanPlan.TrainPlan.dtStartTime);
  lblPlanJiaoLu.Caption := TrainmanPlan.TrainPlan.strTrainJiaoluName;

  if TrainmanPlan.Group.Trainman1.strTrainmanName <> '' then
    lblTrainman1.Caption := TrainmanPlan.Group.Trainman1.strTrainmanName;

  if TrainmanPlan.Group.Trainman2.strTrainmanName <> '' then
    lblTrainman2.Caption := TrainmanPlan.Group.Trainman2.strTrainmanName;

  if TrainmanPlan.Group.Trainman3.strTrainmanName <> '' then
    lblTrainman3.Caption := TrainmanPlan.Group.Trainman3.strTrainmanName;

  dtDatePicker.DateTime := TrainmanPlan.TrainPlan.dtStartTime;

  dtTimePicker.DateTime := TrainmanPlan.TrainPlan.dtStartTime;
end;

end.
