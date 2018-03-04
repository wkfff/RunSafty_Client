unit uFrmViewGroupOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzChkLst, Grids, AdvObj, BaseGrid, AdvGrid,
  Buttons, PngSpeedButton, ExtCtrls, RzPanel, RzRadGrp,uTrainmanJiaolu,
  uTFSystem,uSaftyEnum,uTrainman,DateUtils,ComObj,
  ufrmProgressEx,uLCNameBoardEx;

type
  TfrmViewGroupOrder = class(TForm)
    RzPanel3: TRzPanel;
    btnExport: TPngSpeedButton;
    strGridLeaveInfo: TAdvStringGrid;
    RzPanel1: TRzPanel;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    rgTrainmanJiaolu: TRzRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure rgTrainmanJiaoluClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    m_GroupArray : TRsGroupArray;
    m_RsLCGroup: TRsLCGroup;
    procedure Init;
  public
    { Public declarations }
    class procedure Open();
  end;
implementation

{$R *.dfm}
uses
   uGlobalDM,uLCBaseDict;
var
  frmViewGroupOrder: TfrmViewGroupOrder;
{ TfrmViewGroupOrder }

procedure TfrmViewGroupOrder.btnExportClick(Sender: TObject);
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
begin
  if length(m_GroupArray) < 1 then
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;
  if (strGridLeaveInfo.RowCount = 2) and (strGridLeaveInfo.Cells[999, 1] = '') then 
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;

  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
      excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;

    m_nIndex := 1;
    excelApp.Cells[m_nIndex,1].Value := strGridLeaveInfo.ColumnHeaders[0];
    excelApp.Cells[m_nIndex,2].Value := strGridLeaveInfo.ColumnHeaders[1];
    excelApp.Cells[m_nIndex,3].Value := strGridLeaveInfo.ColumnHeaders[2];
    excelApp.Cells[m_nIndex,4].Value := strGridLeaveInfo.ColumnHeaders[3];
    excelApp.Cells[m_nIndex,5].Value := strGridLeaveInfo.ColumnHeaders[4];

    
    Inc(m_nIndex);
    for i := 1 to strGridLeaveInfo.RowCount - 1 do
    begin
      if strGridLeaveInfo.Cells[999, i] <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := strGridLeaveInfo.Cells[0, i];
        excelApp.Cells[m_nIndex,2].Value := strGridLeaveInfo.Cells[1, i];
        excelApp.Cells[m_nIndex,3].Value := strGridLeaveInfo.Cells[2, i];
        excelApp.Cells[m_nIndex,4].Value := strGridLeaveInfo.Cells[3, i];
        excelApp.Cells[m_nIndex,5].Value := strGridLeaveInfo.Cells[4, i];
        excelApp.Cells[m_nIndex,6].Value := strGridLeaveInfo.Cells[5, i];
      end;
      TfrmProgressEx.ShowProgress('正在导出实时班序，请稍后',i,strGridLeaveInfo.RowCount-1);
      Inc(m_nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Box('导出完毕！');
end;

procedure TfrmViewGroupOrder.FormCreate(Sender: TObject);
begin
  SetLength(m_TrainmanJiaoluArray,0);
  m_RsLCGroup := TRsLCGroup.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmViewGroupOrder.FormDestroy(Sender: TObject);
begin
  m_RsLCGroup.Free;
end;

procedure TfrmViewGroupOrder.Init;
var
  i: Integer;
begin
  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.SiteInfo.strSiteGUID,'',m_TrainmanjiaoluArray);
  rgTrainmanJiaolu.Items.Clear;
  for i := 0 to length(m_TrainmanjiaoluArray) - 1 do
  begin
    rgTrainmanJiaolu.Items.Add(m_TrainmanjiaoluArray[i].strTrainmanJiaoluName);
  end;
end;

class procedure TfrmViewGroupOrder.Open;
begin
  frmViewGroupOrder:= TfrmViewGroupOrder.Create(nil);
  try
    frmViewGroupOrder.Init;
    frmViewGroupOrder.ShowModal;
  finally
    frmViewGroupOrder.Free;
  end;
end;

procedure TfrmViewGroupOrder.rgTrainmanJiaoluClick(Sender: TObject);
var
  nSelectedIndex : integer;
  trainmanjiaolus : TStrings;
  i: Integer;
  jiaoluType : TRsJiaoluType;
begin
  nSelectedIndex := rgTrainmanJiaolu.ItemIndex;
  if nSelectedIndex < 0 then exit;
  trainmanjiaolus := TStringList.Create;
  try
    jiaoluType := jltOrder;
    //组合选择的人员交路
    trainmanjiaolus.Add(m_TrainmanJiaoluArray[nSelectedIndex].strTrainmanJiaoluGUID);
    m_RsLCGroup.GetGroupArrayInTrainmanJiaolus(trainmanjiaolus.CommaText,Ord(jiaoluType),m_GroupArray);

     with strGridLeaveInfo do
    begin
      ClearRows(1,10000);
      if length(m_GroupArray) > 0  then
        RowCount := length(m_GroupArray) + 1
      else
      begin
        RowCount := 2;
        Cells[999,1] := ''
      end;
      for i := 0 to length(m_GroupArray) - 1 do
      begin
        Cells[0, i + 1] := IntToStr(i + 1);
        Cells[1, i + 1] := GetTrainmanText(m_GroupArray[i].Trainman1);
        Cells[2, i + 1] := GetTrainmanText(m_GroupArray[i].Trainman2);
        Cells[3, i + 1] := GetTrainmanText(m_GroupArray[i].Trainman3);
        Cells[4, i + 1] :=  FormatDateTime('yy-MM-dd hh:nn', m_GroupArray[i].dtArriveTime);
        Cells[5, i + 1] :=  TRsTrainmanStateNameAry[m_GroupArray[i].GroupState];
        Cells[999, i + 1] := m_GroupArray[i].strGroupGUID;
      end;
      Invalidate;
    end;
  finally
    trainmanjiaolus.Free;
  end;
  
end;

end.
