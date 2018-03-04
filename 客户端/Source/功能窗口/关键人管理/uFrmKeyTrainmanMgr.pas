unit uFrmKeyTrainmanMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, RzButton, RzRadChk, StdCtrls,
  RzCmboBx, Mask, RzEdit, ComCtrls, RzDTP, ExtCtrls, Buttons, PngSpeedButton,
  RzPanel,uFrmKeyTrainmanEdit,uLCTeamGuide,
  uGuideSign,uTFSystem,ComObj,uFrmProgressEx,uWorkShop,uLCBaseDict,uGlobalDM,
  uLCKeyMan,DateUtils, ImgList,uKeyManXls,uLCTrainmanMgr,uTrainman, Menus;

type
  TFrmKeyTrainmanMgr = class(TForm)
    pnl4: TRzPanel;
    lbl1: TLabel;
    btnQuery: TPngSpeedButton;
    lbl2: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    dtpBeginDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    edtNumber: TRzEdit;
    cbbCheDui: TRzComboBox;
    rzchckbxDataRange: TRzCheckBox;
    pnl5: TRzPanel;
    lbl7: TLabel;
    cbbWorkShop: TRzComboBox;
    edtName: TRzEdit;
    btnQryHis: TPngSpeedButton;
    strGridKeyTrainman: TAdvStringGrid;
    pnl6: TRzPanel;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnInsertRecord: TRzToolButton;
    BtnEdit: TRzToolButton;
    BtnDelete: TRzToolButton;
    RzSpacer1: TRzSpacer;
    BtnExit1: TRzToolButton;
    BtnImport: TRzToolButton;
    BtnExport1: TRzToolButton;
    RzSpacer2: TRzSpacer;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PopupImport: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure btnQryHisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbWorkShopChange(Sender: TObject);
    procedure BtnExit1Click(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnInsertRecordClick(Sender: TObject);
    procedure BtnExport1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    //列表
    m_KeyManList:TKeyTrainmanList;
    m_LCKeyMan: TRsLCKeyMan;
    m_LCTrainmanMgr: TRsLCTrainmanMgr;
    //车队接口
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //车队数组
    m_GuideGroupArray : TRsSimpleInfoArray;
    //车间数据
    m_WorkShopArray:TRsWorkShopArray;
    function GetWorkShopName(WorKShopID: string): string;
    function GetCheDuiGUID(Name: string): string;
  private
    //填充行
    procedure FillLine(keyTrainman:TKeyTrainman;nRow:Integer);
    //构造查询条件
    procedure constructQryCondition(var cdt:TKeyTM_QC);
    //填充关键人列表
    procedure FillKeyManList();
    //初始化列表
    procedure InitList();
    //初始化指导对
    procedure InitCheDui();
    //初始化车间
    procedure InitWorkShop();
    //获取填充对象
    function GetSelectData(var keyTrianman:TKeyTrainman):Boolean ;


  public
    //显示关键人管理窗体
    class procedure Show();
  end;



implementation

uses uSite, uDutyUser;

{$R *.dfm}

{ TFrmKeyTrainmanMgr }

procedure TFrmKeyTrainmanMgr.btnQryHisClick(Sender: TObject);
var
  cdt:TKeyTM_QC;
begin
  m_KeyManList.Clear;
  cdt := TKeyTM_QC.Create;
  TRY
    self.constructQryCondition(cdt);
    m_LCKeyMan.GetHistory(cdt,m_KeyManList);
    strGridKeyTrainman.UnHideColumn(1);
    self.FillKeyManList();
  FINALLY
    cdt.Free;
  END;

end;

procedure TFrmKeyTrainmanMgr.btnQueryClick(Sender: TObject);
var
  cdt:TKeyTM_QC;
begin
  m_KeyManList.Clear;
  cdt := TKeyTM_QC.Create;
  try
    self.constructQryCondition(cdt);
    m_LCKeyMan.Get(cdt,m_KeyManList);
    strGridKeyTrainman.HideColumn(1);
    self.FillKeyManList();

  finally
    cdt.Free;
  end;

end;

procedure TFrmKeyTrainmanMgr.BtnDeleteClick(Sender: TObject);
var
  keyTrainman:TKeyTrainman;
begin
  if GetSelectData(keyTrainman) = False then
  begin
    Box('未选择有效的记录');
    Exit;
  end;
  if TFrmKeyTrainmanEdit.Cancel(keyTrainman) = true then
  begin
    btnQueryClick(nil);
  end;

end;

procedure TFrmKeyTrainmanMgr.BtnExit1Click(Sender: TObject);
begin
    Self.ModalResult := mrOk;
end;

procedure TFrmKeyTrainmanMgr.BtnExport1Click(Sender: TObject);
begin
  if strGridKeyTrainman.RowCount <= 1 then
  begin
    Box('请先查询出您要导出的信息！');
    exit;
  end;
  if (strGridKeyTrainman.RowCount = 2) and (strGridKeyTrainman.Cells[999, 1] = '') then
  begin
    Box('请先查询出您要导出的信息！');
    exit;
  end;

  if not SaveDialog1.Execute then exit;
  
  TKeyManXls.ExportToXls(SaveDialog1.FileName,strGridKeyTrainman);

  Box('导出完毕！');
end;

procedure TFrmKeyTrainmanMgr.BtnInsertRecordClick(Sender: TObject);
var
  keyMan:TkeyTrainman;
begin
  keyMan := TkeyTrainman.Create;
  try
    if TFrmKeyTrainmanEdit.Add(keyMan) = true then
    begin
      btnQueryClick(nil);
    end
  finally
    keyMan.Free;
  end;
end;

procedure TFrmKeyTrainmanMgr.btnModifyClick(Sender: TObject);
var
  keyTrainman:TKeyTrainman;
begin
  if GetSelectData(keyTrainman) = False then
  begin
    Box('未选择有效的记录');
    Exit;
  end;
  if TFrmKeyTrainmanEdit.Modity(keyTrainman) = true then
    btnQueryClick(nil);
end;

procedure TFrmKeyTrainmanMgr.cbbWorkShopChange(Sender: TObject);
begin
  InitCheDui;
end;

procedure TFrmKeyTrainmanMgr.constructQryCondition(var cdt: TKeyTM_QC);
begin
  if rzchckbxDataRange.Checked then
  begin
    cdt.RegisterStartTime := dtpBeginDate.Date;
    cdt.RegisterEndTime := dtpEndDate.Date;
  end;
  if cbbWorkShop.ItemIndex > 0 then
  begin
    cdt.WorkShopGUID := '';
  end;

  cdt.CheDuiGUID := cbbCheDui.Values[cbbCheDui.ItemIndex];
  if edtNumber.Text <> '' then
  begin
    cdt.KeyTMNumber := Trim(edtNumber.Text) ;
  end;
  if edtName.Text <> '' then
  begin
    cdt.KeyTMName := Trim(edtName.Text);
  end;
  cdt.WorkShopGUID := cbbWorkShop.Values[cbbWorkShop.ItemIndex];
end;


procedure TFrmKeyTrainmanMgr.FillKeyManList;
var
  i:Integer;
begin
  InitList;
  for i := 0 to m_KeyManList.Count - 1 do
  begin
    FillLine(m_KeyManList.Items[i],i+1);
  end;
end;

procedure TFrmKeyTrainmanMgr.FillLine(keyTrainman: TKeyTrainman; nRow: Integer);
begin
  strGridKeyTrainman.Cells[0,nRow] := IntToStr(nRow);
  strGridKeyTrainman.Cells[1,nRow] := EKeyTrainmanOptName[keyTrainman.eOpt];
  strGridKeyTrainman.Cells[2,nRow] := keyTrainman.KeyTMWorkShopName;
  strGridKeyTrainman.Cells[3,nRow] := keyTrainman.KeyTMCheDuiName;
  strGridKeyTrainman.Cells[4,nRow] := keyTrainman.KeyTMNumber;
  strGridKeyTrainman.Cells[5,nRow] := keyTrainman.KeyTMName;
  strGridKeyTrainman.Cells[6,nRow] := keyTrainman.KeyReason;
  strGridKeyTrainman.Cells[7,nRow] := keyTrainman.KeyAnnouncements;
  strGridKeyTrainman.Cells[8,nRow] := FormatDateTime('yy-mm-dd',keyTrainman.KeyStartTime);
  strGridKeyTrainman.Cells[9,nRow] := FormatDateTime('yy-mm-dd',keyTrainman.KeyEndTime);
  strGridKeyTrainman.Cells[10,nRow] := FormatDateTime('yy-mm-dd hh:nn',keyTrainman.RegisterTime);
  strGridKeyTrainman.Cells[11,nRow] := keyTrainman.RegisterNumber;
  strGridKeyTrainman.Cells[12,nRow] := keyTrainman.RegisterName;
  strGridKeyTrainman.Cells[13,nRow] := keyTrainman.ClientNumber;
  strGridKeyTrainman.Cells[14,nRow] := keyTrainman.ClientName;
  strGridKeyTrainman.Cells[99,nRow] := keyTrainman.ID;
end;

procedure TFrmKeyTrainmanMgr.FormCreate(Sender: TObject);
begin
  m_KeyManList:=TKeyTrainmanList.Create;
  m_LCKeyMan := TRsLCKeyMan.Create(GlobalDM.WebAPIUtils);
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
  m_LCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);

  dtpBeginDate.Date :=  StartOfTheMonth(Now);
  dtpEndDate.Date := EndOfTheMonth(Now)
end;

procedure TFrmKeyTrainmanMgr.FormDestroy(Sender: TObject);
begin
  m_KeyManList.Free;
  m_LCKeyMan.Free;
  m_LCTrainmanMgr.Free;
  m_RsLCGuideGroup.Free;
end;

procedure TFrmKeyTrainmanMgr.FormShow(Sender: TObject);
begin
  InitWorkShop();
  InitCheDui();
  btnQueryClick(nil);
end;

function TFrmKeyTrainmanMgr.GetCheDuiGUID(Name: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(m_GuideGroupArray) - 1 do
  begin
    if m_GuideGroupArray[i].strName = Name then
    begin
      Result := m_GuideGroupArray[i].strGUID;
      break;
    end;
  end;
end;

function TFrmKeyTrainmanMgr.GetSelectData(var keyTrianman: TKeyTrainman): Boolean;
var
  strGUID:string;
begin
  result:= False;
  strGUID := strGridKeyTrainman.Cells[99,strGridKeyTrainman.Row];
  if strGUID <> '' then
  begin
    keyTrianman := m_KeyManList.Items[strGridKeyTrainman.Row-1];
    result := True;
  end;
end;

function TFrmKeyTrainmanMgr.GetWorkShopName(WorKShopID: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(m_WorkShopArray) - 1 do
  begin
    if m_WorkShopArray[i].strWorkShopGUID = WorKShopID then
    begin
      Result := m_WorkShopArray[i].strWorkShopName;
      break;
    end;
  end;
end;

procedure TFrmKeyTrainmanMgr.InitCheDui;
var
  i:Integer;
  workShopGUID:string;
begin
  workShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  if cbbWorkShop.ItemIndex > -1 then
    workShopGUID := cbbWorkShop.Values[cbbWorkShop.ItemIndex];
  m_RsLCGuideGroup.GetGroupArray(workShopGUID, m_GuideGroupArray);
  cbbCheDui.Items.Clear;
  cbbCheDui.Values.Clear;
  cbbCheDui.AddItemValue('全部','');
  for i := 0 to length(m_GuideGroupArray) - 1 do
  begin
    cbbCheDui.AddItemValue(m_GuideGroupArray[i].strName, m_GuideGroupArray[i].strGUID);
  end;
  cbbCheDui.ItemIndex := 0;
end;
procedure TFrmKeyTrainmanMgr.InitWorkShop;
var
  strAreaGUID:string;
  i:Integer;
  Error:string;
begin
  strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,m_workshopArray,Error) then
  begin
    Box(Error);
  end;
  cbbWorkShop.Items.Clear;
  cbbWorkShop.Values.Clear;
  cbbWorkShop.AddItemValue('全部车间','');
  for i := 0 to length(m_workshopArray) - 1 do
  begin
    cbbWorkShop.AddItemValue(m_workshopArray[i].strWorkShopName,m_workshopArray[i].strWorkShopGUID);
  end;
  if cbbWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID) >0 then
    cbbWorkShop.ItemIndex := cbbWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID)
  else
    cbbWorkShop.ItemIndex := 0;
  cbbWorkShopChange(nil);
end;

procedure TFrmKeyTrainmanMgr.N1Click(Sender: TObject);
var
  KeyTrainmanList: TKeyTrainmanList;
  I: Integer;
  Trainman: RRsTrainman;
  strError: string;
begin
  if OpenDialog1.Execute then
  begin
    KeyTrainmanList := TKeyTrainmanList.Create;
    try
      TKeyManXls.ImportFromXls(OpenDialog1.FileName,KeyTrainmanList);

      for I := 0 to KeyTrainmanList.Count - 1 do
      begin
        TfrmProgressEx.ShowProgress('正在导入请假信息，请稍后',i + 1,KeyTrainmanList.Count);
        KeyTrainmanList.Items[i].ID := NewGUID;
        KeyTrainmanList.Items[i].KeyTMWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
        KeyTrainmanList.Items[i].KeyTMWorkShopName := GetWorkShopName(GlobalDM.SiteInfo.WorkShopGUID);
        KeyTrainmanList.Items[i].KeyTMCheDuiGUID := GetCheDuiGUID(KeyTrainmanList.Items[i].KeyTMCheDuiName);
        KeyTrainmanList.Items[i].ClientNumber := GlobalDM.SiteInfo.strSiteNumber;
        KeyTrainmanList.Items[i].ClientName := GlobalDM.SiteInfo.strSiteName;
        KeyTrainmanList.Items[i].RegisterNumber := GlobalDM.DutyUser.strDutyNumber;
        KeyTrainmanList.Items[i].RegisterName := GlobalDM.DutyUser.strDutyName;
        KeyTrainmanList.Items[i].RegisterTime := Now;
        if not m_LCTrainmanMgr.GetTrainmanByNumber(KeyTrainmanList.Items[i].KeyTMNumber,Trainman) then
        begin
          strError := Format('[%s]%s 乘务员不存在!',[KeyTrainmanList.Items[i].KeyTMNumber,
            KeyTrainmanList.Items[i].KeyTMName]);
          Box(strError);
          Exit;
        end
        else
        begin
          KeyTrainmanList.Items[i].KeyTMName := Trainman.strTrainmanName;
        end;
      end;


      for I := 0 to KeyTrainmanList.Count - 1 do
      begin
        TfrmProgressEx.ShowProgress('正在导入请假信息，请稍后',i + 1,KeyTrainmanList.Count);
        m_LCKeyMan.Add(KeyTrainmanList.Items[i]);
      end;

      
    finally
      TfrmProgressEx.CloseProgress;
      KeyTrainmanList.Free;
    end;
  end;

end;

procedure TFrmKeyTrainmanMgr.N2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if not CopyFile(PChar(GlobalDM.AppPath + 'xlsTemplates\KeyManTemplate.xls'),
      PChar(SaveDialog1.FileName),True) then
    begin
      Box(SysErrorMessage(GetLastError));
    end;
  end;
  
end;

procedure TFrmKeyTrainmanMgr.InitList;
begin
  strGridKeyTrainman.ClearRows(1,strGridKeyTrainman.RowCount-1);
  strGridKeyTrainman.RowCount := m_KeyManList.Count + 2;
end;



class procedure TFrmKeyTrainmanMgr.Show;
var
  Frm: TFrmKeyTrainmanMgr;
begin
  Frm:= TFrmKeyTrainmanMgr.Create(nil);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

end.
