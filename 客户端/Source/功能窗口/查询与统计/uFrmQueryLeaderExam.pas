unit uFrmQueryLeaderExam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls,ADODB, ActnList, Grids, AdvObj,
  BaseGrid, AdvGrid, RzCmboBx, PngSpeedButton, asgprev;

type
  TfrmQueryLeaderExam = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnQuery: TSpeedButton;
    btnCancel: TSpeedButton;
    Label3: TLabel;
    dtpBeginDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    actEsc: TAction;
    strGridExam: TAdvStringGrid;
    CombArea: TRzComboBox;
    btnPrint: TPngSpeedButton;
    AdvPreviewDialog: TAdvPreviewDialog;
    btnToExcel: TPngSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnToExcelClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitHead;
  public
    { Public declarations }
  end;

var
  frmQueryLeaderExam: TfrmQueryLeaderExam;

implementation

{$R *.dfm}
uses
  uLeaderExamOpt, uGlobalDM;
procedure TfrmQueryLeaderExam.actEscExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmQueryLeaderExam.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmQueryLeaderExam.btnPrintClick(Sender: TObject);
begin
  AdvPreviewDialog.Execute;
end;

procedure TfrmQueryLeaderExam.btnQueryClick(Sender: TObject);
var
  adoQuery : TADOQuery;
  i : Integer;
begin

  strGridExam.ClearRows(1,9999);
  InitHead;
  try
    TLeaderExanOpt.GetLeaderExams(dtpBeginDate.DateTime,dtpEndDate.DateTime,CombArea.Value,adoQuery);
    strGridExam.RowCount := adoQuery.RecordCount + 2;
    i :=0;
    with adoQuery do
    begin
      while not eof do
      begin
        Inc(i);
        strGridExam.RowHeights[i] := 25;
        strGridExam.Cells[0,i] := IntToStr(i);
        strGridExam.Cells[1,i] := FieldByName('strAreaName').AsString;
        strGridExam.Cells[2,i] := FieldByName('strTrainmanName').AsString + '['+FieldByName('strTrainmanNumber').AsString+']';
        strGridExam.Cells[3,i] := FieldByName('strVerifyName').AsString;
        strGridExam.Cells[4,i] := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtCreateTime').AsDateTime);
        strGridExam.Cells[5,i] := FieldByName('strDutyName').AsString;
        next;
      end;
    end;
  finally
    if assigned(adoQuery) then
      adoQuery.Free;
  end;
end;

procedure TfrmQueryLeaderExam.btnToExcelClick(Sender: TObject);
var
  FileName: string;
begin
  if SaveDialog1.Execute then
  begin
    strGridExam.SaveWithHTML := false;
    FileName := SaveDialog1.FileName;
    if FileExists(FileName) then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName) then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    if FileExists(FileName + '.xls') then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName + '.xls') then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    if FileExists(FileName + '.xlsx') then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName + '.xlsx') then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    strGridExam.SaveToXLS(FileName);
    Application.MessageBox('保存成功','提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmQueryLeaderExam.FormCreate(Sender: TObject);
begin

  InitHead;
  dtpBeginDate.Date := GlobalDM.GetNow;
  dtpEndDate.Date := GlobalDM.GetNow;


end;

procedure TfrmQueryLeaderExam.InitHead;
begin
  strGridExam.RowHeights[0] := 30;
  strGridExam.Cells[0,0] := '序号';
  strGridExam.ColWidths[0] := 50;

  strGridExam.Cells[1,0] := '检查区域';
  strGridExam.ColWidths[1] := 150;

  strGridExam.Cells[2,0] := '检查人';
  strGridExam.ColWidths[2] := 120;

  strGridExam.Cells[3,0] := '登记方式';
  strGridExam.ColWidths[3] := 80;

  strGridExam.Cells[4,0] := '检查时间';
  strGridExam.ColWidths[4] := 150;

  strGridExam.Cells[5,0] := '值班员';
  strGridExam.ColWidths[5] := 120;
end;

end.
