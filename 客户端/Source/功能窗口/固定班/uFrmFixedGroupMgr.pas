unit uFrmFixedGroupMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, StdCtrls, RzCmboBx, Mask, RzEdit,
  ExtCtrls, Buttons, PngSpeedButton, RzPanel,uLCTeamGuide,uGuideSign,uWorkShop,
  uGlobalDM,uLCBaseDict,uTFSystem,uFrmFixedGoupEdit,uFixedGroup,uDBFixedGroup,
  ComCtrls,uFrmAddUser,utrainman, RzTreeVw, RzStatus, RzTabs, RzButton, ImgList,
  uFrameFixGroup, Menus;

type
  TFrmFixedGroupMgr = class(TForm)
    RzTreeView1: TRzTreeView;
    Splitter1: TSplitter;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnPreviewNextPage: TRzToolButton;
    RzPageControl1: TRzPageControl;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    edtNumber: TRzEdit;
    lbl2: TLabel;
    RzSpacer4: TRzSpacer;
    BtnView: TRzToolButton;
    Bevel1: TBevel;
    MeneWorkGroup: TPopupMenu;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbbWorkShopChange(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure strGridFixedTrainmanDblClickCell(Sender: TObject; ARow,
      ACol: Integer);
    procedure btnModifyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    //车队接口
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //车队数组
//    m_GuideGroupArray : TRsSimpleInfoArray;
    //车间数据
//    m_WorkShopArray:TRsWorkShopArray;
    //固定班数据库操作
    m_dbFixedGroup:TDBFixedGroup;
    //固定班组列表
    m_FixedGroupList:TFixedGroupList;

  private
    //初始化指导对
    procedure InitCheDui();
    //初始化车间
    procedure InitWorkShop();
     //获取选中机组
    function GetSelectGroup(var group:TFixedGroup):Boolean;

    //构造查询条件
    procedure ConQryCd(var qc:RDBFixedGroup_QC);
    //填充列表
    procedure FillGrid();
    //填充行
    procedure FillLine(nRow:Integer;group:TFixedGroup);
    //初始化gird
    procedure InitGrid;
  public
    //固定班组管理
    class procedure Show();
  end;


implementation

{$R *.dfm}

{ TFrmFixedGroupMgr }

procedure TFrmFixedGroupMgr.btnAddClick(Sender: TObject);
var
  group:TFixedGroup;
begin
  group:= TFixedGroup.Create;
  try
    if TFrmFixedGroupEdit.Add(group) = False then   Exit;
    btnQueryClick(nil);
  finally
    group.Free;
  end;

end;

procedure TFrmFixedGroupMgr.btnDelClick(Sender: TObject);
var
  group:TFixedGroup;
begin
  if GetSelectGroup(group)= false then
  begin
    Box('未选择有效行');
    Exit;
  end;

  m_dbFixedGroup.DelGroup(group);
  btnQueryClick(nil);


end;

procedure TFrmFixedGroupMgr.btnModifyClick(Sender: TObject);
var
  group:TFixedGroup;
begin
  if GetSelectGroup(group)= false then
  begin
    Box('未选择有效行');
    Exit;
  end;

  if TFrmFixedGroupEdit.Modify(group) = False then Exit;
  btnQueryClick(nil);


end;

procedure TFrmFixedGroupMgr.btnQueryClick(Sender: TObject);
var
  qc:RDBFixedGroup_QC;
begin
  m_FixedGroupList.Clear;
  ConQryCd(qc);
  m_dbFixedGroup.Query(qc,m_FixedGroupList);
  FillGrid;
end;

procedure TFrmFixedGroupMgr.cbbWorkShopChange(Sender: TObject);
begin
  InitCheDui;
end;

procedure TFrmFixedGroupMgr.ConQryCd(var qc: RDBFixedGroup_QC);
begin

end;
procedure TFrmFixedGroupMgr.InitGrid;
begin
//  strGridFixedTrainman.ClearRows(1,strGridFixedTrainman.RowCount-1);
//  strGridFixedTrainman.RowCount := m_FixedGroupList.Count + 2;
end;
procedure TFrmFixedGroupMgr.FillGrid;
var
  i:Integer;
begin
  InitGrid;
  for i := 0 to Self.m_FixedGroupList.Count - 1 do
  begin
    FillLine(i+1,m_FixedGroupList.Items[i]);
  end;
end;

procedure TFrmFixedGroupMgr.FillLine(nRow: Integer; group: TFixedGroup);
begin
//  strGridFixedTrainman.cells[0,nRow] := IntToStr(nRow);
//  strGridFixedTrainman.cells[1,nRow] := group.rFixedGroup.strWorkShopName ;
//  strGridFixedTrainman.cells[2,nRow] := group.rFixedGroup.strCheDuiName;
//  strGridFixedTrainman.cells[3,nRow] := IntToStr( group.rFixedGroup.nGroupIndex);
//  strGridFixedTrainman.cells[4,nRow] := group.rFixedGroup.strGroupName;
//  if group.trainman1.strTrainmanGUID <> '' then
//    strGridFixedTrainman.cells[5,nRow] := Format('%s[%s]',[group.trainman1.strTrainmanName,group.trainman1.strTrainmanNumber]);
//  if group.trainman2.strTrainmanGUID <> '' then
//    strGridFixedTrainman.cells[6,nRow] := Format('%s[%s]',[group.trainman2.strTrainmanName,group.trainman2.strTrainmanNumber]);
//  if group.trainman3.strTrainmanGUID <> '' then
//    strGridFixedTrainman.cells[7,nRow] := Format('%s[%s]',[group.trainman3.strTrainmanName,group.trainman3.strTrainmanNumber]);
//  if group.trainman4.strTrainmanGUID <> '' then
//    strGridFixedTrainman.cells[8,nRow] := Format('%s[%s]',[group.trainman4.strTrainmanName,group.trainman4.strTrainmanNumber]);
//  strGridFixedTrainman.cells[99,nRow] := group.rFixedGroup.strGroupGUID;
end;

procedure TFrmFixedGroupMgr.FormCreate(Sender: TObject);
begin
  globalDM.ConnectLocal_SQLDB();
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
  //固定班数据库操作
  m_dbFixedGroup:=TDBFixedGroup.Create(GlobalDM.LocalADOConnection);
  m_FixedGroupList:=TFixedGroupList.Create;
end;

procedure TFrmFixedGroupMgr.FormDestroy(Sender: TObject);
begin
  m_RsLCGuideGroup.Free;
  m_dbFixedGroup.Free;
  m_FixedGroupList.Free;
end;

procedure TFrmFixedGroupMgr.FormShow(Sender: TObject);
begin
  InitWorkShop;
  btnQueryClick(nil);
end;

function TFrmFixedGroupMgr.GetSelectGroup(var group: TFixedGroup): Boolean;
//var
//  strGroupGUID:string;
begin
  result := False;
//  strGroupGUID := strGridFixedTrainman.Cells[99,strGridFixedTrainman.Row];
//  if strGroupGUID = '' then Exit;
//  group := m_FixedGroupList.Items[strGridFixedTrainman.Row -1];
//  result := true;
end;

procedure TFrmFixedGroupMgr.InitCheDui;
//var
//  i:Integer;
//  workShopGUID:string;
begin
//  workShopGUID := GlobalDM.SiteInfo.WorkShopGUID;

end;
procedure TFrmFixedGroupMgr.InitWorkShop;
//var
//  strAreaGUID:string;
//  i:Integer;
//  Error:string;
begin
//  strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
//  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,m_workshopArray,Error) then
//  begin
//    Box(Error);
//  end;
end;


class procedure TFrmFixedGroupMgr.Show;
var
  frm: TFrmFixedGroupMgr;
begin
  frm:= TFrmFixedGroupMgr.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TFrmFixedGroupMgr.strGridFixedTrainmanDblClickCell(Sender: TObject;
  ARow, ACol: Integer);
var
  s_Trainman,d_Trainman:RRStrainman;
  group:TFixedGroup;
  tmIndex:Integer;
begin
  if GetSelectGroup(group) = False then Exit;
  //tmIndex := GetSelectTrainmanIndex;
    tmIndex := ACol - 4;
  if not( (tmIndex >= 1) and (tmIndex <= 4)) then Exit;
  
  case tmIndex of
    1:s_Trainman := group.trainman1;
    2:s_Trainman := group.trainman2;
    3:s_Trainman := group.trainman3;
    4:s_Trainman := group.trainman4;
  end;
  if True then

  d_Trainman := s_Trainman;
  
  if not TFrmAddUser.InputTrainman('',d_Trainman) then exit;
  d_Trainman.strFixedGroupGUID := group.rFixedGroup.strGroupGUID;
  m_dbFixedGroup.ModifyTM(group,tmIndex,s_Trainman,d_Trainman);
  btnQueryClick(nil);
end;

end.
