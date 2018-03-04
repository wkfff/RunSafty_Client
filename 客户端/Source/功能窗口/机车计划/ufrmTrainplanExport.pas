unit ufrmTrainplanExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngSpeedButton, RzPrgres, StdCtrls, ComCtrls, RzDTP,
  ExtCtrls, RzPanel,uTFSystem, RzCmboBx,uTrainJiaolu,uLCTrainPlan,
  uTrainPlan;

type
  TfrmTrainplanExport = class(TForm)
    RzGroupBox1: TRzGroupBox;
    dtBeginDate: TRzDateTimePicker;
    dtBeginTime: TRzDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    RzProgressBar1: TRzProgressBar;
    dtEndDate: TRzDateTimePicker;
    dtEndTime: TRzDateTimePicker;
    PngSpeedButton1: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    cbbJiaoLu: TRzComboBox;
    Label3: TLabel;
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_RsLCTrainPlan: TRsLCTrainPlan;
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    procedure InitTrainJiaoLu();
    procedure OnProgress(nCompleted, nTotal: integer);
  public
    { Public declarations }
  end;
procedure ExportTrainPlan(TrainjiaoluArray : TRsTrainJiaoluArray);
implementation

uses uGlobalDM, uExportPlan;
procedure ExportTrainPlan(TrainjiaoluArray : TRsTrainJiaoluArray);
var
  frmTrainplanExport: TfrmTrainplanExport;
begin
  if Length(TrainjiaoluArray) = 0 then
  begin
    Box('该客户端没有管辖的交路!');
    Exit;
  end;
  frmTrainplanExport := TfrmTrainplanExport.Create(nil);
  try
    frmTrainplanExport.m_TrainjiaoluArray := TrainjiaoluArray;
    frmTrainplanExport.InitTrainJiaoLu();
    frmTrainplanExport.ShowModal;
  finally
    frmTrainplanExport.Free;
  end;
end;
{$R *.dfm}

procedure TfrmTrainplanExport.FormCreate(Sender: TObject);
begin
  dtBeginDate.DateTime := GlobalDM.GetNow ;
  dtEndDate.DateTime :=  GlobalDM.GetNow ;
  m_RsLCTrainPlan := TRsLCTrainPlan.Create('','','');
  m_RsLCTrainPlan.SetConnConfig(GlobalDM.HttpConnConfig);
end;

procedure TfrmTrainplanExport.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainPlan.Free;
end;

procedure TfrmTrainplanExport.InitTrainJiaoLu;
var
  I: Integer;
begin
  cbbJiaoLu.Items.Clear;

  for I := 0 to Length(m_TrainjiaoluArray) - 1 do
  begin
    cbbJiaoLu.Items.Add(m_TrainjiaoluArray[i].strTrainJiaoluName);
  end;

  if cbbJiaoLu.Items.Count > 0 then
    cbbJiaoLu.ItemIndex := 0;
end;

procedure TfrmTrainplanExport.OnProgress(nCompleted, nTotal: integer);
begin
  RzProgressBar1.TotalParts := nTotal;
  RzProgressBar1.PartsComplete := nCompleted;
end;

procedure TfrmTrainplanExport.PngSpeedButton1Click(Sender: TObject);
var
  ExportPlan: TXlsExportPlan;
  dtBeginDateTime,dtEndDateTime: TDateTime;
  TrainPlanArray: TRsTrainPlanArray;
begin
  if SaveDialog.Execute then
  begin
    ExportPlan := TXlsExportPlan.Create();
    try
      dtBeginDateTime := AssembleDateTime(dtBeginDate.Date,dtBeginTime.Time);
      dtEndDateTime := AssembleDateTime(dtEndDate.Date,dtEndTime.Time);

      ExportPlan.OnExportPlanProgress := OnProgress;
      TrainPlanArray := m_RsLCTrainPlan.ExportTrainPlan(dtBeginDateTime,dtEndDateTime,
      m_TrainjiaoluArray[cbbJiaoLu.ItemIndex].strTrainJiaoluGUID);

      ExportPlan.SaveToExcel(TrainPlanArray,SaveDialog.FileName);
      Box('导出完毕!');
    finally
      ExportPlan.Free;
    end;
  end;

end;

end.
