unit uFrmQueryTestDrink;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, Buttons, ExtCtrls,ADODB,
  PngSpeedButton, Grids, AdvObj, BaseGrid, AdvGrid, asgprev;

type
  TfrmQueryTestDrink = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnQuery: TSpeedButton;
    btnCancel: TSpeedButton;
    Label3: TLabel;
    dtpBeginDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    CombArea: TComboBox;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    actEsc: TAction;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    edtTrainmanName: TEdit;
    edtTrainmanNumber: TEdit;
    Label5: TLabel;
    strGridExam: TAdvStringGrid;
    btnToExcel: TPngSpeedButton;
    btnPrint: TPngSpeedButton;
    AdvPreviewDialog: TAdvPreviewDialog;
    SaveDialog1: TSaveDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lvDrinkDblClick(Sender: TObject);
    procedure btnToExcelClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    m_AreaGUIDs : TStrings;
    procedure InitHead;
  public
    { Public declarations }
  end;

var
  frmQueryTestDrink: TfrmQueryTestDrink;

implementation

{$R *.dfm}
uses
  uDrink,uOrg, uDataModule,uFrmQueryDrinkPhoto;
procedure TfrmQueryTestDrink.actEscExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmQueryTestDrink.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmQueryTestDrink.btnPrintClick(Sender: TObject);
begin
  AdvPreviewDialog.Execute;
end;

procedure TfrmQueryTestDrink.btnQueryClick(Sender: TObject);
var
  ado : TADOQuery;
  i : Integer;
begin
  strGridExam.ClearRows(1,9999);
  InitHead;

  TDrinkOpt.GetDrinks(dtpBeginDate.DateTime,dtpEndDate.DateTime,m_AreaGUIDs[CombArea.ItemIndex],edtTrainmanName.Text,edtTrainmanNumber.Text,-1,ado);
  strGridExam.RowCount := ado.RecordCount + 2;
  try
    i :=0;
    with ado do
    begin
      while not eof do
      begin
        Inc(i);
        strGridExam.RowHeights[i] := 25;
        strGridExam.Cells[0,i] := IntToStr(i);
        strGridExam.Cells[1,i] := FieldByName('strAreaName').AsString;
        strGridExam.Cells[2,i] := FieldByName('strTrainNo').AsString;
        strGridExam.Cells[3,i] := FieldByName('strTrainmanName').AsString + '['+FieldByName('strTrainmanNumber').AsString+']';
        strGridExam.Cells[4,i] := TDrinkOpt.GetDrinkTypeName(TDrinkTypeEnum(FieldByName('nDrinkType').Asinteger));

        strGridExam.Cells[5,i] := FieldByName('strDrinkResultName').AsString;        
        strGridExam.Colors[5,i] := clWhite;
        if strGridExam.Cells[5,i] = '饮酒' then
        begin
          strGridExam.Colors[5,i] :=  $00114DD9;
        end;

        if strGridExam.Cells[5,i] = '酗酒' then
        begin
          strGridExam.Colors[5,i] :=  clred;
        end;

        strGridExam.Cells[6,i] := FieldByName('strVerifyName').AsString;
        strGridExam.Cells[7,i] := FormatDateTime('yyyy-MM-dd HH:nn', FieldByName('dtCreateTime').AsDateTime);
        if FieldByName('nIsLocal').AsInteger > 0 then
          strGridExam.Cells[8,i] := '是'
        else
          strGridExam.Cells[8,i] := '否';

        strGridExam.Cells[9,i] := FieldByName('strDutyName').AsString + '['+FieldByName('strDutyNumber').AsString+']';
        strGridExam.Cells[99,i] := FieldByName('strGUID').AsString;      
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmQueryTestDrink.btnToExcelClick(Sender: TObject);
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
    strGridExam.SaveToXLS(SaveDialog1.FileName);
    Application.MessageBox('保存成功','提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmQueryTestDrink.FormCreate(Sender: TObject);
var
  ado : TADOQuery;
begin
  dtpBeginDate.Date := DMGlobal.GetNow;
  dtpEndDate.Date := DMGlobal.GetNow;
  m_AreaGUIDs := TStringList.Create;
  CombArea.Items.Add('请选择');
  m_AreaGUIDs.Add('');
  TAreaOpt.GetAreas(ado);
  try
    with ado do
    begin
      while not eof  do
      begin
        CombArea.Items.Add(FieldByName('strAreaName').AsString);
        m_AreaGUIDs.Add(FieldByName('strGUID').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
  CombArea.ItemIndex := m_AreaGUIDs.IndexOf(DMGlobal.LocalArea);
end;

procedure TfrmQueryTestDrink.FormDestroy(Sender: TObject);
begin
  m_AreaGUIDs.Free;
end;

procedure TfrmQueryTestDrink.InitHead;
begin
  strGridExam.RowHeights[0] := 30;
  strGridExam.Cells[0,0] := '序号';
  strGridExam.ColWidths[0] := 50;

  strGridExam.Cells[1,0] := '乘务员所属车间';
  strGridExam.ColWidths[1] := 150;

  strGridExam.Cells[2,0] := '值乘车次';
  strGridExam.ColWidths[2] := 120;

  strGridExam.Cells[3,0] := '乘务员信息';
  strGridExam.ColWidths[3] := 150;

  strGridExam.Cells[4,0] := '测酒类型';
  strGridExam.ColWidths[4] := 80;

  strGridExam.Cells[5,0] := '测酒结果';
  strGridExam.ColWidths[5] := 80;

  strGridExam.Cells[6,0] := '验证类型';
  strGridExam.ColWidths[6] := 80;

  strGridExam.Cells[7,0] := '测酒时间';
  strGridExam.ColWidths[7] := 150;

  strGridExam.Cells[8,0] := '本段人员';
  strGridExam.ColWidths[8] := 80;

  strGridExam.Cells[9,0] := '值班员';
  strGridExam.ColWidths[9] := 120;
end;

procedure TfrmQueryTestDrink.lvDrinkDblClick(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TfrmQueryTestDrink.SpeedButton1Click(Sender: TObject);
begin
  if strGridExam.Row = strGridExam.RowCount - 1 then
  begin
    Application.MessageBox('请选择测酒记录。','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  frmQueryDrinkPhoto := TfrmQueryDrinkPhoto.Create(nil);
  try
    frmQueryDrinkPhoto.DrinkGUID := strGridExam.Cells[99,strGridExam.row];
    frmQueryDrinkPhoto.ShowModal;
  finally
    frmQueryDrinkPhoto.Free;
  end;
end;

end.
