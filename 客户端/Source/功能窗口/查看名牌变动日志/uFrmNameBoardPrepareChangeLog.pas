unit uFrmNameBoardPrepareChangeLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzChkLst, Grids, AdvObj, BaseGrid, AdvGrid,
  Buttons, PngSpeedButton, ExtCtrls, RzPanel, RzRadGrp,uTrainmanJiaolu,
  uTFSystem,uSaftyEnum,uTrainman,DateUtils,ComObj,
  ufrmProgressEx, ComCtrls, RzDTP,uFrmShowText,uLCNameBoardEx, Mask, RzEdit,
  RzCmboBx, RzButton, ImgList;

type
  TfrmNameBoardPrepareChangeLog = class(TForm)
    strGridLeaveInfo: TAdvStringGrid;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    RzPanel1: TRzPanel;
    SaveDialog2: TSaveDialog;
    SaveDialog3: TSaveDialog;
    dtpEndDate: TRzDateTimePicker;
    Label2: TLabel;
    dtpBeginDate: TRzDateTimePicker;
    Label1: TLabel;
    Label4: TLabel;
    edtKey: TRzEdit;
    BtnView: TSpeedButton;
    BtnExport: TSpeedButton;
    Label3: TLabel;
    comboTrainmanJiaolu: TRzComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  private
    { Private declarations }
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    m_RsLCNameBoardEx: TRsLCBoardTrainman;
    m_ChangeLogArray : TRsPrepareTMOrderLogArray;
  public
    { Public declarations }
    procedure Init;
    class procedure Open();
  end;

var
  frmNameBoardPrepareChangeLog: TfrmNameBoardPrepareChangeLog;

implementation
uses
   uGlobalDM,uLCBaseDict;
{$R *.dfm}

{ TfrmNameBoardPrepareChangeLog }

procedure TfrmNameBoardPrepareChangeLog.BtnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    strGridLeaveInfo.SaveToXLS(SaveDialog1.FileName);
    Box('导出完毕!');
  end;
end;

procedure TfrmNameBoardPrepareChangeLog.BtnViewClick(Sender: TObject);
var
  i: Integer;
  dtBeginTime,dtEndTime : TDateTime;
begin
  //组合选择的人员交路
  dtBeginTime := DateOf(dtpBeginDate.DateTime);
  dtEndTime := IncSecond(IncDay(DateOf(dtpEndDate.Date),1),-1);

  if comboTrainmanJiaolu.ItemIndex < 0 then
    Exit;
  m_ChangeLogArray := m_RsLCNameBoardEx.QueryPrepareChangeLog(dtBeginTime,dtEndTime,
    comboTrainmanJiaolu.Value,edtKey.Text);


  with strGridLeaveInfo do
  begin
    ClearRows(1,10000);
    if length(m_ChangeLogArray) > 0  then
      RowCount := length(m_ChangeLogArray) + 1
    else
    begin
      RowCount := 2;
      Cells[999,1] := ''
    end;
    for i := 0 to length(m_ChangeLogArray) - 1 do
    begin
      Cells[0, i + 1] := IntToStr(i + 1);
      Cells[1, i + 1] := m_ChangeLogArray[i].TMJiaoluName;
      Cells[2, i + 1] := m_ChangeLogArray[i].LogText;
      Cells[3, i + 1] := m_ChangeLogArray[i].UserName;
      Cells[4, i + 1] := m_ChangeLogArray[i].UserNumber;
      Cells[5, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',m_ChangeLogArray[i].LogTime);

    end;
    Invalidate;
  end;
end;

procedure TfrmNameBoardPrepareChangeLog.FormCreate(Sender: TObject);
begin
  SetLength(m_TrainmanJiaoluArray,0);
  m_RsLCNameBoardEx := TRsLCBoardTrainman.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmNameBoardPrepareChangeLog.FormDestroy(Sender: TObject);
begin
  m_RsLCNameBoardEx.Free;
end;

procedure TfrmNameBoardPrepareChangeLog.Init;
var
  i: Integer;
begin
  dtpBeginDate.DateTime := now - 1;
  dtpEndDate.DateTime := now;
  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.SiteInfo.strSiteGUID,'',m_TrainmanjiaoluArray);
  comboTrainmanJiaolu.Items.Clear;
  for i := 0 to length(m_TrainmanjiaoluArray) - 1 do
  begin
    if m_TrainmanJiaoluArray[i].nJiaoluType = jltOrder then
    
    comboTrainmanJiaolu.AddItemValue(m_TrainmanjiaoluArray[i].strTrainmanJiaoluName,
      m_TrainmanjiaoluArray[i].strTrainmanJiaoluGUID);
  end;
  if comboTrainmanJiaolu.Count > 0 then
    comboTrainmanJiaolu.ItemIndex := 0;
end;

class procedure TfrmNameBoardPrepareChangeLog.Open;
begin
  frmNameBoardPrepareChangeLog:= TfrmNameBoardPrepareChangeLog.Create(nil);
  try
    frmNameBoardPrepareChangeLog.Init;
    frmNameBoardPrepareChangeLog.ShowModal;
  finally
    frmNameBoardPrepareChangeLog.Free;
  end;
end;

end.
