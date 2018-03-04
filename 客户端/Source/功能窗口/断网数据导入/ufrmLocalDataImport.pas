unit ufrmLocalDataImport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, RzTabs, ImgList, ExtCtrls,
  RzPanel, ADODB, RzButton, ComCtrls, RzListVw,uGlobalDM,uRsDBLocalPlan,uRsLocalDataDefine,
  uTrainPlan,uDBTrainPlan,uDBTrainmanJiaolu,uTFSystem, Grids, AdvObj, BaseGrid,
  AdvGrid, RzGrids, VirtualTrees,uRsPlanCombine,uRsWorkRecordCombine,
  uFrmNameBoardManage, RzStatus,uSaftyEnum, jpeg, StdCtrls,uApparatusCommon,
  PngImageList, Menus;

type
  TfrmLocalDataImport = class(TForm)
    RzPageControl1: TRzPageControl;
    ImageList1: TImageList;
    TabSheet2: TRzTabSheet;
    RzStatusBar1: TRzStatusBar;
    RzPanel3: TRzPanel;
    RzToolbar4: TRzToolbar;
    btnAutoCombine: TRzToolButton;
    btnRefreshRecord: TRzToolButton;
    LocalRecordTree: TVirtualStringTree;
    RzProgressStatus: TRzProgressStatus;
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LocalRecordTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure LocalRecordTreeBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure btnAutoCombineClick(Sender: TObject);
    procedure btnRefreshRecordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    class var frmLocalDataImport: TfrmLocalDataImport;
    m_LocalDataList: TRsLocalDataList;
    m_LocalImport: TRsLocalImport;
    procedure OnProgress(nMax,nPosition: Integer);
    procedure ShowLocalRecord(DataList: TRsLocalDataList);
  public
    { Public declarations }
    class procedure ShowForm();
  end;


implementation

{$R *.dfm}

procedure TfrmLocalDataImport.BtnExitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLocalDataImport.btnRefreshRecordClick(Sender: TObject);
begin
  m_LocalImport.ExtractData(m_LocalDataList);
  ShowLocalRecord(m_LocalDataList);
end;

procedure TfrmLocalDataImport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmLocalDataImport.FormCreate(Sender: TObject);
begin
  m_LocalImport := TRsLocalImport.Create(GlobalDM.ADOConnection,GlobalDM.LocalConnection);

  m_LocalDataList := TRsLocalDataList.Create;
  m_LocalImport.StationGUID := GlobalDM.SiteInfo.strStationGUID;
  m_LocalImport.SiteGUID := GlobalDM.SiteInfo.strSiteGUID;
  m_LocalImport.DutyGUID := GlobalDM.DutyUser.strDutyGUID;
  m_LocalImport.OnProgress := OnProgress;
end;

procedure TfrmLocalDataImport.FormDestroy(Sender: TObject);
begin
  m_LocalImport.Free;
  m_LocalDataList.Free;
end;

procedure TfrmLocalDataImport.LocalRecordTreeBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  p: PPointer;
  LocalData: TRsLocalData;
begin
  p := TVirtualStringTree(Sender).GetNodeData(Node);
  LocalData := TRsLocalData(p^);
  case LocalData.DataType of
    ldtBeginWorkRecord: ItemColor := $00E9E9E9;
    ldtEndWorkRecord: ItemColor := $008E8F70;
    ldtDrinkTest: ItemColor := $00D1CEA3;
  end;
  EraseAction := eaColor;
end;
procedure TfrmLocalDataImport.LocalRecordTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  p: PPointer;
  LocalData: TRsLocalData;
begin
  p := TVirtualStringTree(Sender).GetNodeData(Node);
  LocalData := TRsLocalData(p^);
  case Column of
    0: CellText := IntToStr(node.Index + 1);
    1:
      begin
        case LocalData.DataType of
          ldtBeginWorkRecord: CellText := '出勤';
          ldtEndWorkRecord: CellText := '退勤';
          ldtDrinkTest: CellText := '手工测酒';
        end;
      end;
    2: CellText := FormatDateTime('mm-dd hh:nn:ss',LocalData.EventTime);
    3: CellText := Format('[%.4s]%s',[LocalData.GenericData.StrField['strTrainmanNumber'],LocalData.GenericData.StrField['strTrainmanName']]);
  end;
end;

procedure TfrmLocalDataImport.OnProgress(nMax, nPosition: Integer);
begin
  RzProgressStatus.TotalParts := nMax;
  RzProgressStatus.PartsComplete := nPosition;
end;

procedure TfrmLocalDataImport.btnAutoCombineClick(Sender: TObject);
var
  I: Integer;
  nCount: Integer;
begin
  btnAutoCombine.Enabled := False;
  try
    m_LocalImport.ImportData(m_LocalDataList);
    nCount := 0;
    for I := 0 to m_LocalDataList.count - 1 do
    begin
      if m_LocalDataList.Items[i].GenericData.bField['bDeal'] then
      begin
        Inc(nCount);
      end;
    end;
    Box('共'+ IntToStr(m_LocalDataList.count)+'条记录,合并' + IntToStr(nCount) + '条!');

    btnRefreshRecord.Click();
  finally
    btnAutoCombine.Enabled := True;
  end;

end;

class procedure TfrmLocalDataImport.ShowForm;
begin
  if not GlobalDM.LocalDBEnable then
  begin
    Box('未启用本地数据库功能!');
    Exit;
  end;
  frmLocalDataImport := TfrmLocalDataImport.Create(nil);
  frmLocalDataImport.Width := Screen.Width;
  frmLocalDataImport.Top := Screen.Height - frmLocalDataImport.Height;
  frmLocalDataImport.Left := 0;
  frmLocalDataImport.Show;
end;

procedure TfrmLocalDataImport.ShowLocalRecord(DataList: TRsLocalDataList);
var
  i: Integer;
begin
  LocalRecordTree.Clear;
  for I := 0 to DataList.Count - 1 do
  begin
    LocalRecordTree.AddChild(nil,DataList.Items[i]);
  end;
end;


end.
