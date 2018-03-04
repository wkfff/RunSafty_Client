unit uFrmTrainmanManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, PngSpeedButton, ExtCtrls, StdCtrls,
   RzCmboBx,uArea, uTrainman, PngCustomButton, RzPanel,
  RzStatus,uTFSystem,uWorkShop,uGuideGroup,
  uTrainJiaoLU,uSaftyEnum, Grids, AdvObj, BaseGrid,uGlobalDM, AdvGrid,
  Mask, RzEdit,uJWD,StrUtils,uLCBaseDict,uLCTrainmanMgr, RzButton, ImgList,
  Menus;

type
  TfrmTrainmanManage = class(TForm)
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    RzPanel1: TRzPanel;
    strGridTrainman: TAdvStringGrid;
    dlgOpen1: TOpenDialog;
    rzpnl1: TRzPanel;
    btnPrePage: TButton;
    btnNextPage: TButton;
    edtGoPage: TEdit;
    btn3: TButton;
    lbl1: TLabel;
    lbl_PageIndex: TLabel;
    lbl_TotalPages: TLabel;
    lblRecordCount: TLabel;
    lbl2: TLabel;
    ImageList1: TImageList;
    popMenuImport: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SaveDialog: TSaveDialog;
    RzPanel2: TRzPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    comboWorkShop: TRzComboBox;
    comboTrainmanJiaolu: TRzComboBox;
    comboGuideGroup: TRzComboBox;
    edtTrainmanName: TRzEdit;
    comboPhoto: TRzComboBox;
    comboArea: TRzComboBox;
    Label3: TLabel;
    Label9: TLabel;
    comboFingerCount: TRzComboBox;
    edtTrainmanNumber: TRzEdit;
    Label2: TLabel;
    Label8: TLabel;
    RzToolbar1: TRzToolbar;
    BtnView: TRzToolButton;
    BtnInsertRecord: TRzToolButton;
    BtnEdit: TRzToolButton;
    BtnDelete: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    btnSetOrg: TRzToolButton;
    BtnImport1: TRzToolButton;
    BtnExport1: TRzToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comboWorkShopChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtTrainmanNumberKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrePageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure comboAreaChange(Sender: TObject);
    procedure edtTrainmanNumberExit(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure BtnInsertRecordClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnExport1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure btnSetOrgClick(Sender: TObject);
  private
    /// <summary>是否为查找乘务员的窗口</summary>
    m_bIsQueryForm:Boolean;
    /// <summary>当前选中的人员</summary>
    m_SelectTrainMan:RRsTrainman;

    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //人员列表    
    m_TrainmanArray : TRsTrainmanArray;
    //人员信息当前页
    m_nCurPage:Integer;
    //人员信息总页数
    m_nTotalPages:Integer;
    //人员信息总个数
    m_nTotalCount:Integer; 
    m_JWDArray:TRsJWDArray;
    //初始化界面
    procedure Init;
    //查询乘务员信息
    procedure QueryTrainmans;
    //导出人员信息
    procedure ExportTrainmans;
    //导入人员信息
    procedure ImportTrainmans;
    //初始化机务段
    procedure InitJWD();
    //初始化车间
    procedure InitWorkShop();
    //初始化车间
    procedure InitTrainJiaoLu();
    procedure InitGuideGroup();
    {功能:显示分页信息}
    procedure ShowPageInfo();
    procedure OnLoadXls(nMax,nPosition: integer);
    function CollectQueryParam(): RRsQueryTrainman;
    function GetJWDName(TM : RRsTrainman) : string;
  public
    //打开乘务员查询窗口
    class procedure OpenTrainmanQuery;

    property bIsQueryForm:Boolean read m_bIsQueryForm write m_bIsQueryForm;
    property SelectTrainMan:RRsTrainman read m_SelectTrainMan;
  end;

implementation
uses
  uFrmUserInfoEdit,ComObj,uFrmProgressEx, uTMImporter,uFrmSetOrg;
var
  trainmanManage :  TfrmTrainmanManage;  
{$R *.dfm}

procedure TfrmTrainmanManage.btnPrePageClick(Sender: TObject);
begin
  m_nCurPage := m_nCurPage -1;
  QueryTrainmans();

end;
procedure TfrmTrainmanManage.btnSetOrgClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('没有可操作的司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0) then
    exit;

  if (strGridTrainman.Row > length(m_TrainmanArray))  then
    Exit;
  
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];
  if not TFrmSetOrg.ShowDialog(strTrainmanGUID) then
  begin
    exit;
  end;
  QueryTrainmans;
end;

procedure TfrmTrainmanManage.btn3Click(Sender: TObject);
var
  nPage:Integer;
begin
  if Trim(edtGoPage.Text) = '' then
  begin
    Box('页面号不能为空!');
    Exit;
  end;
  if TryStrToInt(Trim(edtGoPage.Text),nPage) = False then
  begin
    Box('页面号必须是数字!');
    Exit;
  end;

  if not( (nPage >= 1) and (nPage <= m_nTotalPages)) then
  begin
    Box('页面号必须为1到最大页面数之间的数字');
    Exit;
  end;
  m_nCurPage := nPage;
  QueryTrainmans();
end;

procedure TfrmTrainmanManage.btnCloseClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfrmTrainmanManage.BtnDeleteClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
  if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('没有可操作的司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0)  then
    exit;
  if Application.MessageBox('您确定要删除选中的司机吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];

  try
    m_RsLCTrainmanMgr.DeleteTrainman(strTrainmanGUID);
    BtnView.Click;
    exit;
  except on e : exception do
    begin
      Box('删除失败：' + e.Message);
    end;
  end;
end;

procedure TfrmTrainmanManage.BtnEditClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
    if length(m_TrainmanArray) = 0 then
  begin
    Application.MessageBox('没有可操作的司机','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if (strGridTrainman.Row = 0) then
    exit;

  if (strGridTrainman.Row > length(m_TrainmanArray))  then
    Exit;

  
  strTrainmanGUID := strGridTrainman.Cells[99,strGridTrainman.Row];
  if not ModifyTrainmanInfo(strTrainmanGUID) then
  begin
    exit;
  end;
  //btnQuery.Click;
end;
procedure TfrmTrainmanManage.BtnExport1Click(Sender: TObject);
begin
  ExportTrainmans;
end;

procedure TfrmTrainmanManage.BtnInsertRecordClick(Sender: TObject);
begin
  if not AppendTrainmanInfo then
  begin
    exit;
  end;

  BtnViewClick(nil);
end;

procedure TfrmTrainmanManage.btnNextPageClick(Sender: TObject);
begin
  m_nCurPage := m_nCurPage +1;
  QueryTrainmans();
end;

procedure TfrmTrainmanManage.BtnViewClick(Sender: TObject);
begin
  m_nCurPage := 1;
  QueryTrainmans;
end;

function TfrmTrainmanManage.CollectQueryParam: RRsQueryTrainman;
begin
  Result.strTrainmanNumber := Trim(edtTrainmanNumber.Text);
  Result.strTrainmanName := Trim(edtTrainmanName.Text);

  Result.strAreaGUID := comboArea.Values[comboArea.ItemIndex];
  //如果是本段人员才进行交路和车间的选择
  if Result.strAreaGUID = LeftStr(GlobalDM.SiteInfo.strSiteIP,2) then
  begin
    Result.strWorkShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
    Result.strTrainJiaoluGUID := comboTrainmanJiaolu.Values[comboTrainmanJiaolu.ItemIndex];
    Result.strGuideGroupGUID := comboGuideGroup.Values[comboGuideGroup.ItemIndex];
  end;

  Result.nFingerCount := comboFingerCount.ItemIndex - 1;
  Result.nPhotoCount := comboPhoto.ItemIndex - 1;
end;

procedure TfrmTrainmanManage.comboAreaChange(Sender: TObject);
begin
  InitWorkshop();
end;

procedure TfrmTrainmanManage.comboWorkShopChange(Sender: TObject);
begin
  InitGuideGroup();
  InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.edtTrainmanNumberExit(Sender: TObject);
var
  strJwd : string ;
  TrainmanNumber : string ;
  i : Integer ;
begin
  TrainmanNumber := edtTrainmanNumber.Text ;
  strJwd :=  LeftStr(TrainmanNumber,2) ;
  for I := 0 to comboArea.Items.Count - 1 do
  begin
    if comboArea.Values[i] =  strJwd  then
    begin
      comboArea.ItemIndex := i ;
      comboAreaChange(nil);
      Break ;
    end;
  end;
end;

procedure TfrmTrainmanManage.edtTrainmanNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    BtnViewClick(nil);
end;

procedure ExportProgress(position,max : integer);
begin
  TfrmProgressEx.ShowProgress('正在导出人员……',position,max);
end;
procedure TfrmTrainmanManage.ExportTrainmans;
var
  TMArray: TRsTrainmanArray;
begin
  if not SaveDialog.Execute then exit;
  try    
    m_RsLCTrainmanMgr.ListTrainman(CollectQueryParam,TMArray,ExportProgress);
    
    TTMXlsExporter.SaveAs(SaveDialog.FileName,TMArray,ExportProgress);
    Box('导出完毕!');
  finally
    TfrmProgressEx.CloseProgress;
  end;

end;

procedure TfrmTrainmanManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  trainmanManage := nil;
end;

procedure TfrmTrainmanManage.FormCreate(Sender: TObject);
begin
  m_bIsQueryForm := False;
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);


  //机务段
  m_nCurPage := 1;
  m_nTotalCount := 0;
  m_nTotalPages := 0;
end;

procedure TfrmTrainmanManage.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TfrmTrainmanManage.FormShow(Sender: TObject);
begin
  FillChar(m_SelectTrainMan,SizeOf(m_SelectTrainMan),0);
  m_SelectTrainMan.strTrainmanGUID := '';
  BtnInsertRecord.Enabled := not m_bIsQueryForm;
  BtnEdit.Enabled := not m_bIsQueryForm;
  BtnDelete.Enabled := not m_bIsQueryForm;
  
  BtnViewClick(nil);
end;

function TfrmTrainmanManage.GetJWDName(TM: RRsTrainman): string;
var
  i: Integer;
  strTMJWD : string;
begin

  result := '';
  for i := 0 to length(m_JWDArray) - 1 do
  begin
    strTMJWD := tm.strAreaGUID;
    if (length(TM.strTrainmanNumber) = 7) then
      strTMJWD  := leftstr(TM.strTrainmanNumber,2);
       
    if (strTMJWD)= (m_JWDArray[i].strUserCode)then
    begin
      result := m_JWDArray[i].strName;
      exit;
    end;
  end;
end;

procedure TfrmTrainmanManage.ImportTrainmans;
var
  TMImporter: TTMImporter;
  TMArray: TRsTrainmanArray;
  TM: RRsTrainman;
  I: Integer;
begin
  if not dlgOpen1.Execute then exit;

  TMImporter := TTMXlsImporter.Create;
  try
    TMImporter.OnProgress := OnLoadXls;
    
    TMImporter.Import(dlgOpen1.FileName,TMArray);

    for I := 0 to Length(TMArray) - 1 do
    begin
      if not m_RsLCTrainmanMgr.ExistNumber('',TMArray[i].strTrainmanNumber) then
        m_RsLCTrainmanMgr.AddTrainman(TMArray[i])
      else
      begin
        //如果工号存在就仅修改电话号码
        m_RsLCTrainmanMgr.GetTrainmanByNumber(TMArray[i].strTrainmanNumber,TM);


        TM.nPostID := TMArray[i].nPostID;
        TM.strPostName := TMArray[i].strPostName;
        if TMArray[i].strWorkShopGUID <> '' then
          TM.strWorkShopGUID := TMArray[i].strWorkShopGUID;

        if TMArray[i].strGuideGroupGUID <> '' then
          TM.strGuideGroupGUID := TMArray[i].strGuideGroupGUID;

        if TMArray[i].strAreaGUID <> '' then
          TM.strAreaGUID := TMArray[i].strAreaGUID;

        TM.strTelNumber := TMArray[i].strTelNumber;
        TM.strAdddress := TMArray[i].strAdddress;
        TM.strRemark := TMArray[i].strRemark;
        TM.strMobileNumber := TMArray[i].strMobileNumber;
        TM.nDriverType := TMArray[i].nDriverType;
        TM.nDriverLevel := TMArray[i].nDriverLevel;
        TM.strABCD := TMArray[i].strABCD;
        TM.strJP := TMArray[i].strJP;

        TM.dtRuZhiTime := TMArray[i].dtRuZhiTime;
        TM.dtJiuZhiTime := TMArray[i].dtJiuZhiTime;
        TM.nKeHuoID := TMArray[i].nKeHuoID;

        m_RsLCTrainmanMgr.UpdateTrainman(TM);

//        m_RsLCTrainmanMgr.UpdateTrainmanTel(TM.strTrainmanGUID,TMArray[i].strTelNumber,
//          TMArray[i].strMobileNumber,TMArray[i].strAdddress,TMArray[i].strRemark)  ;
      end;


      TfrmProgressEx.ShowProgress('正在导入司机信息，请稍后',i + 1,Length(TMArray));
      

    end;
    TfrmProgressEx.CloseProgress;

    Application.MessageBox('导入完毕！','提示',MB_OK + MB_ICONINFORMATION);
  finally
    TfrmProgressEx.CloseProgress;
    TMImporter.Free;
  end;





end;

procedure TfrmTrainmanManage.InitJWD();
var
  i:Integer;  
  strError : string;
begin
  if not (RsLCBaseDict.LCJwd.GetAllJwdList(m_JWDArray,strError)) then
  begin
    box(strError);
    exit;
  end;
  comboArea.Items.Clear;
  comboArea.Values.Clear;
  comboArea.AddItemValue('全部人员','');
  for i := 0 to length(m_JWDArray) - 1 do
  begin
    comboArea.AddItemValue(m_JWDArray[i].strName,m_JWDArray[i].strUserCode);
  end;
  comboArea.ItemIndex := comboArea.Values.IndexOf(LeftStr(GlobalDM.SiteInfo.strSiteIP,2));
end;
//初始化车间
procedure TfrmTrainmanManage.InitWorkShop();
var
  i:integer;
  workshopArray : TRsWorkShopArray;
  strAreaGUID:string;
  Error: string;
begin
  if leftStr(GlobalDM.SiteInfo.strSiteIP,2) = comboArea.Values[comboArea.ItemIndex] then
    strAreaGUID := GlobalDM.SiteInfo.strAreaGUID
  else
    strAreaGUID := comboArea.Values[comboArea.ItemIndex];
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,workshopArray,Error) then
  begin
    Box(Error);
  end;
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('全部车间','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  if comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID) >0 then
    comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID)
  else
    comboWorkShop.ItemIndex := 0;

  comboWorkShopChange(nil);

end;
procedure TfrmTrainmanManage.N1Click(Sender: TObject);
var
  TMImporter: TTMXlsImporter;
begin
  if SaveDialog.Execute then
  begin
    TMImporter := TTMXlsImporter.Create;
    try
      TMImporter.CreateTemplate(SaveDialog.FileName);
    finally
      TMImporter.Free;
    end;  
  end;

end;

procedure TfrmTrainmanManage.N2Click(Sender: TObject);
begin
  ImportTrainmans;
end;

procedure TfrmTrainmanManage.Init;
begin
  InitJWD();
  InitWorkShop();
  //InitGuideGroup();
  //InitTrainJiaoLu();
end;

procedure TfrmTrainmanManage.InitGuideGroup;
var
  guideGroupArray : TRsGuideGroupArray;
  i: Integer;
  workShopGUID : string;
begin
  comboGuideGroup.Items.Clear;
  comboGuideGroup.Values.Clear;
  comboGuideGroup.AddItemValue('全部指导队','');
  comboGuideGroup.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //添加指导队信息
    RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop(workShopGUID,guideGroupArray);
    for i := 0 to length(guideGroupArray) - 1 do
    begin
      comboGuideGroup.AddItemValue(guideGroupArray[i].strGuideGroupName,
          guideGroupArray[i].strGuideGroupGUID);
    end;
  end;
end;


procedure TfrmTrainmanManage.InitTrainJiaoLu;
var
  trainJiaoluArray : TRsTrainJiaoluArray;
  i: Integer;
  workShopGUID : string;
begin
  comboTrainmanJiaolu.Items.Clear;
  comboTrainmanJiaolu.Values.Clear;
  comboTrainmanJiaolu.AddItemValue('全部区段','');
  comboTrainmanJiaolu.ItemIndex := 0;

  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
  if workShopGUID <> '' then
  begin
    //添加区段信息
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(workShopGUID,trainJiaoluArray);
    for i := 0 to length(trainJiaoluArray) - 1 do
    begin
      comboTrainmanJiaolu.AddItemValue(trainJiaoluArray[i].strTrainJiaoluName,
          trainJiaoluArray[i].strTrainJiaoluGUID);
    end;
  end;
end;


procedure TfrmTrainmanManage.OnLoadXls(nMax,nPosition: integer);
begin
  TfrmProgressEx.ShowProgress('正在加载EXCEL文件，请稍后',nPosition,nMax);
end;

class procedure TfrmTrainmanManage.OpenTrainmanQuery;
begin
  if trainmanManage = nil then
  begin
    trainmanManage :=  TfrmTrainmanManage.Create(nil);
    trainmanManage.Init;
    trainmanManage.Show;
  end
  else
  begin
    trainmanManage.Show;
    trainmanManage.WindowState := wsMaximized;
  end;
end;

procedure TfrmTrainmanManage.QueryTrainmans;
var
  QueryTrainman : RRsQueryTrainman;
  i: Integer;
  strTemp : string;
begin
  //当前查询结果共有0人
  QueryTrainman := CollectQueryParam();

  strGridTrainman.BeginUpdate;
  try
    try

      m_RsLCTrainmanMgr.QueryTrainmans_blobFlag(QueryTrainman,m_nCurPage,m_TrainmanArray,m_nTotalCount);
      statusSum.Caption := Format('当前查询结果共有%d人！',[length(m_TrainmanArray)]);
      strGridTrainman.ClearRows(1,9999);
      if length(m_TrainmanArray) = 0  then
        strGridTrainman.RowCount := 2
      else
        strGridTrainman.RowCount := Length(m_TrainmanArray) + 1;
      for i := 0 to Length(m_TrainmanArray) - 1 do
      begin
        with strGridTrainman do
        begin
          Cells[0,i + 1] := IntToStr(i+1);

          Cells[1,i + 1] := GetJWDName(m_TrainmanArray[i]);
          Cells[2,i + 1] := m_TrainmanArray[i].strWorkShopName;
          Cells[3,i + 1] := m_TrainmanArray[i].strTrainJiaoluName;
          Cells[4,i + 1] := m_TrainmanArray[i].strGuideGroupName;
          Cells[5,i + 1] := m_TrainmanArray[i].strTrainmanName;
          Cells[6,i + 1] := m_TrainmanArray[i].strTrainmanNumber;
          Cells[7,i + 1] := TRsPostNameAry[m_TrainmanArray[i].nPostID];
          Cells[8,i + 1] := TRsDriverTypeNameArray[m_TrainmanArray[i].nDriverType];
          Cells[9,i + 1] := TRsKeHuoNameArray[m_TrainmanArray[i].nKeHuoID];
          strTemp := '';
          if m_TrainmanArray[i].bIsKey <> 0 then
            strTemp := '是';
          Cells[10,i + 1] := strTemp;
          Cells[11,i + 1] := m_TrainmanArray[i].strABCD;
          Cells[12,i + 1] := m_TrainmanArray[i].strTelNumber;
          Cells[13,i + 1] := m_TrainmanArray[i].strMobileNumber;
          Cells[14,i + 1] := m_TrainmanArray[i].strAdddress;
          Cells[15,i + 1] := TRsTrainmanStateNameAry[m_TrainmanArray[i].nTrainmanState];
          Cells[16,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtRuZhiTime);
          Cells[17,i + 1] := FormatDateTime('yy-MM-dd',m_TrainmanArray[i].dtJiuZhiTime);
          strTemp := '√';

          if (m_TrainmanArray[i].nFingerPrint1_Null = 0) then
            strTemp := '空';
          Cells[18,i + 1] := strTemp;
           strTemp := '√';
          if (m_TrainmanArray[i].nFingerPrint2_Null = 0) then
            strTemp := '空';
          Cells[19,i + 1] := strTemp;
          strTemp := '√';
          if (m_TrainmanArray[i].nPicture_Null = 0) then
            strTemp := '空';
          Cells[20,i + 1] := strTemp;
          
          Cells[99,i + 1] := m_TrainmanArray[i].strTrainmanGUID;
        end;
      end;
      ShowPageInfo();
    except on e : exception do
      begin
        Box('查询失败：' + e.Message);
      end;
    end;
  finally
    strGridTrainman.EndUpdate;
  end;
end;

procedure TfrmTrainmanManage.ShowPageInfo;
begin
  lbl_PageIndex.Caption := Format('第%d页',[m_nCurPage]);
  m_nTotalPages := m_nTotalCount div 100 + 1;
  lbl_TotalPages.Caption := Format('共%d页',[m_nTotalPages]);
  lblRecordCount.Caption := Format('共%d条记录',[m_nTotalCount]);
  
  if m_nCurPage = 1 then
    btnPrePage.Enabled := False
  else
    btnPrePage.Enabled := True;
  if m_nCurPage >= m_nTotalPages  then
    btnNextPage.Enabled := False
  else
    btnNextPage.Enabled := True;
end;

end.
