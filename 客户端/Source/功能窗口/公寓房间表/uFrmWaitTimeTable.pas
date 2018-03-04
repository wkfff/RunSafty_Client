unit uFrmWaitTimeTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, RzEdit, StdCtrls, ExtCtrls, RzPanel, ComCtrls,uFrmEditWaitTime,
  uWaitWork,uWaitWorkMgr,uTFSystem,uGlobalDM,ComObj,  ufrmProgressEx;

type
  TFrmWaitTimeTable = class(TForm)
    lvWaitTime: TListView;
    rzpnl1: TRzPanel;
    btnAdd: TButton;
    btnModfy: TButton;
    btnDel: TButton;
    btnImPort: TButton;
    dlgOpen1: TOpenDialog;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnModfyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnImPortClick(Sender: TObject);
  private
    //候班管理
    m_waitMgr:TWaitWorkMgr;
    m_WaitTimeAry:TWaitTimeAry;
  private
    {功能:刷新时刻表}
    procedure ReFresh();
    {功能:填充行数据}
    procedure fillLine(item:TListItem;waitTime:RWaitTime);
  public

  public
    {功能:图钉候班表管理}
    class procedure ManageWaitRoomTable();
  end;
  {功能:显示}



implementation

{$R *.dfm}

{ TFrmWaitRoomTable }

procedure TFrmWaitTimeTable.btnAddClick(Sender: TObject);
var
  waitTime:RWaitTime;
begin
  if TFrmEditWaitTime.AddWaitTable(waitTime) = False then Exit;
  try
    m_waitMgr.DBWaitTime.Add(waitTime);
  except on e:exception do
    begin
      Box('增加失败,原因:' + e.Message);
      Exit;
    end;
  end;
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnDelClick(Sender: TObject);
var
  item:TListItem;
  waitTime:RWaitTime;
begin
  item := lvWaitTime.Selected;
  if item = nil then
  begin
    Box('未选择有效行');
    Exit
  end;
  if TBox('确定删除吗?') = False then Exit;
  
  waitTime := m_WaitTimeAry[item.index];
  m_waitMgr.DBWaitTime.Delete(waitTime.strGUID);
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnImPortClick(Sender: TObject);
var
  excelApp: Variant;
  nIndex,nTotalCount : integer;
  strTrainNo:string;
  waittime:RWaitTime;
begin
  if not dlgOpen1.Execute then exit;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(dlgOpen1.FileName);
    excelApp.Worksheets[1].activate;
    nIndex := 2;
    nTotalCount := 0;
    while true do
    begin
      strTrainNo := excelApp.Cells[nIndex,2].Value;
      if strTrainNo = '' then break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;
    if nTotalCount = 0 then
    begin
       Application.MessageBox('没有可导入的候班时刻表！','提示',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    m_waitMgr.DBWaitTime.delAll();
    nIndex := 2;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
      waittime.strGUID := NewGUID;
      waittime.strTrainNo := excelApp.Cells[nIndex,1].Value;
      waittime.strRoomNum := excelApp.Cells[nIndex,2].Value;
      waittime.dtWaitTime := excelApp.Cells[nIndex,3].Value;
      waittime.dtCallTime := excelApp.Cells[nIndex,4].Value;
      waittime.dtChuQinTime := excelApp.Cells[nIndex,5].Value;
      waittime.dtKaiCheTime := excelApp.Cells[nIndex,6].Value;
      m_waitMgr.DBWaitTime.Add(waittime);
      TfrmProgressEx.ShowProgress('正在导入候班表，请稍后',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导入完毕！','提示',MB_OK + MB_ICONINFORMATION);
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnModfyClick(Sender: TObject);
var
  item:TListItem;
  waitTime:RWaitTime;
begin
  item := lvWaitTime.Selected;
  if item = nil then
  begin
    Box('未选择有效行');
    Exit
  end;
  waitTime := m_WaitTimeAry[item.index];
  if TFrmEditWaitTime.ModifyWaitTable(waitTime) = False then Exit;
  m_waitMgr.DBWaitTime.Modify(waitTime);
  ReFresh();
end;

procedure TFrmWaitTimeTable.fillLine(item: TListItem; waitTime: RWaitTime);
begin
  item.Caption := inttostr(item.Index+1);
  item.SubItems.Add(waitTime.strTrainNo);
  item.SubItems.Add(waitTime.strRoomNum);
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtWaitTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtCallTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtChuQinTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtKaiCheTime));
end;

procedure TFrmWaitTimeTable.FormCreate(Sender: TObject);
begin
  m_waitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TFrmWaitTimeTable.FormShow(Sender: TObject);
begin
  ReFresh();
end;

class procedure TFrmWaitTimeTable.ManageWaitRoomTable;
var
  frm: TFrmWaitTimeTable;
begin
  frm:= TFrmWaitTimeTable.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TFrmWaitTimeTable.ReFresh;
var
  i:Integer;
  nCount:Integer;
  item:TListItem;
begin
  m_waitMgr.DBWaitTime.GetAll(m_WaitTimeAry);
  nCount := Length(m_WaitTimeAry);
  lvWaitTime.Clear();
  for i := 0 to nCount - 1 do
  begin
    item :=lvWaitTime.Items.Add;
    fillLine(item,m_WaitTimeAry[i]);
  end;
    
end;

end.
