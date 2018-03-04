unit uFrmDrinkTestQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, RzPanel, PngCustomButton, RzCmboBx, StdCtrls, Buttons,
  PngSpeedButton, ExtCtrls, ComCtrls, jpeg, ActnList,uDutyPlace,uTrainman,
  uWorkShop,uSystemDict,uDrink, RzDTP, Mask,uJWD,
  RzEdit, OleCtrls, SHDocVw, ExtDlgs, Menus, ImgList, PngImageList,ZKFPEngXUtils,
  StrUtils,uFrmPrintTMRpt,uLCBaseDict,uLCTrainmanMgr,uLCDict_System,uLCDrink,
  uLCDutyUser,uLCDutyPlace, RzLabel, RzSpnEdt, RzBorder,RzCommon,uLCDict_GanBu,
  uFrmHint,Contnrs;

type
  TfrmDrinkTestQuery = class(TForm)
    RzPanel2: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    comboWorkShop: TRzComboBox;
    comboDrinkType: TRzComboBox;
    comboVerify: TRzComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    RzPanel1: TRzPanel;
    lvTrainman: TListView;
    ActionList1: TActionList;
    Action1: TAction;
    comboDrinkResult: TRzComboBox;
    dtpBeginDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    edtTrainmanNumber: TRzEdit;
    edtTrainmanName: TRzEdit;
    actDownLoadPic: TAction;
    dlgSavePic: TSavePictureDialog;
    actModifyDrinkTime: TAction;
    Label10: TLabel;
    cmbDrinkPlace: TRzComboBox;
    RzGroupBox2: TRzGroupBox;
    imgStand: TImage;
    PngImageList1: TPngImageList;
    RzGroupBox1: TRzGroupBox;
    imgDrink: TImage;
    Label11: TLabel;
    cmbJwd: TRzComboBox;
    Label12: TLabel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    btnQuery: TPngSpeedButton;
    btnDownLoadPic: TPngSpeedButton;
    btnPrintTMRpt: TPngSpeedButton;
    cbbDepartment: TRzComboBox;
    Label13: TLabel;
    Label14: TLabel;
    cbbGanbuType: TRzComboBox;
    btnMore: TPngSpeedButton;
    imgLstBtnMore: TPngImageList;
    btnExport: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure Action1Execute(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvTrainmanClick(Sender: TObject);
    procedure actDownLoadPicExecute(Sender: TObject);
    procedure lvTrainmanAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure btnPrintTMRptClick(Sender: TObject);
    procedure cbbDepartmentChange(Sender: TObject);
    procedure btnMoreClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCDutyPlace: TRsLCDutyPlace;
    m_RsDrinkImage: TRsDrinkImage;
    m_RsLCDrink: TRsLCDrink;
    m_TypeList: TGanBuTypeList;
    m_drinkArray: TRsDrinkArray;
    m_Departments: TObjectList;
    procedure InitData;
    procedure ExportToFile(const FileName: string);
  public
    { Public declarations }
    procedure QueryDrinkTest;
    class procedure OpenDrinkTestQuery;
  end;



implementation
uses
  uGlobalDM,DateUtils,utfsystem,uFrmGetDateTime,comobj, uLCDict_Department;
{$R *.dfm}

procedure TfrmDrinkTestQuery.actDownLoadPicExecute(Sender: TObject);
var
  RDrink: RRsDrink;
begin
  if lvTrainman.Selected = nil then
  begin
    BoxErr('û��ѡ��Ҫ������Ƭ����Ա��');
    exit;
  end;

  if m_RsLCDrink.GetDrinkInfo(lvTrainman.Selected.SubItems[lvTrainman.Selected.SubItems.Count - 1],RDrink) then
  begin
    if RDrink.strPictureURL <> '' then
    begin
      if  dlgSavePic.Execute(0)  then
      begin
        if m_RsDrinkImage.DownLoad(GlobalDM.WebHost + RDrink.strPictureURL,dlgSavePic.FileName) then
          Box('������Ƭ�����鿴!')
        else
          BoxErr('������Ƭ����!');
      end;
    end
    else
      BoxErr('����Աû����Ƭ!');
  end
  else
    BoxErr('��ȡ��Ա��Ϣ����');
end;

procedure TfrmDrinkTestQuery.Action1Execute(Sender: TObject);
begin
  QueryDrinkTest;
end;

procedure TfrmDrinkTestQuery.btnPrintTMRptClick(Sender: TObject);
begin
  TFrmPrintTMRpt.printTMRpt_NoPlan;
end;

procedure TfrmDrinkTestQuery.btnQueryClick(Sender: TObject);
begin
  QueryDrinkTest;
end;

procedure TfrmDrinkTestQuery.cbbDepartmentChange(Sender: TObject);
var
  I: Integer;
begin
  cbbGanbuType.ClearItemsValues();

  cbbGanbuType.AddItemValue('ȫ��','');

  cbbGanbuType.ItemIndex := 0;




  if cbbDepartment.Value <> '' then
  begin
    RsLCBaseDict.LCGanBu.LCGanBuType.Query(cbbDepartment.Value,m_TypeList);
    
    for I := 0 to m_TypeList.Count - 1 do
    begin
      cbbGanbuType.AddItemValue(m_TypeList.Items[i].TypeName,m_TypeList.Items[i].TypeID);
    end;
  end;



  
end;
type
  RXlsColWith = record
    colName: string;
    width: integer;
  end;

const
  XlsColWithArray: array[0..10] of RXlsColWith =
  (
  (colName:'���';width:-1),
  (colName:'�����';width:20),
  (colName:'����';width:20),
  (colName:'����';width:-1),
  (colName:'����';width:-1),
  (colName:'���ʱ��';width:20),
  (colName:'��ƽ��';width:-1),
  (colName:'�ƾ���';width:-1),
  (colName:'��֤��ʽ';width:-1),
  (colName:'����';width:20),
  (colName:'��Ƶص�';width:20));

procedure TfrmDrinkTestQuery.ExportToFile(const FileName: string);
var
  I: Integer;
  JWDArray: TRsJWDArray;
  error: string;
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  function GetJwdName(code: string): string;
  var
    i: integer;
  begin
    result := '';
    for I := 0 to Length(JWDArray) - 1 do
    begin
      if JWDArray[i].strUserCode = code then
      begin
        Result := JWDArray[i].strName;
        break;
      end;
    end;
  end;
  
  procedure CreateTitle();
  var
    Range: Variant;
    i: integer;
  begin
    Range := MSExcelWorkSheet.Columns;
    Range.HorizontalAlignment := $FFFFEFDD;   //�����
    for I := 0 to Length(XlsColWithArray) - 1 do
    begin
      MSExcelWorkSheet.Cells[1,i + 1] := XlsColWithArray[i].colName;
      if XlsColWithArray[i].width > 0 then
      begin
        Range := MSExcelWorkSheet.Columns[i + 1];
        Range.ColumnWidth := XlsColWithArray[i].width;
      end;
    end;
  end;
  
  procedure FillXlsData();
  var
    I: Integer;
  begin
    for I := 0 to Length(m_drinkArray) - 1 do
    begin
      with m_drinkArray[i] do
      begin
        MSExcelWorkSheet.Cells[i + 2,1] := IntToStr(i + 1);
        MSExcelWorkSheet.Cells[i + 2,2] := GetJwdName(strAreaGUID);
        MSExcelWorkSheet.Cells[i + 2,3] := strWorkShopName;
        MSExcelWorkSheet.Cells[i + 2,4] := strTrainmanNumber;
        MSExcelWorkSheet.Cells[i + 2,5] := strTrainmanName;
        MSExcelWorkSheet.Cells[i + 2,6] := FormatDateTime('yy-MM-dd HH:nn',m_drinkArray[i].dtCreateTime);
        MSExcelWorkSheet.Cells[i + 2,7] := m_drinkArray[i].strDrinkResultName;
        MSExcelWorkSheet.Cells[i + 2,8] := IntToStr( m_drinkArray[i].dwAlcoholicity );
        MSExcelWorkSheet.Cells[i + 2,9] := strVerifyName;
        MSExcelWorkSheet.Cells[i + 2,10] := Format('[%s-%s]%s',[m_drinkArray[i].strTrainTypeName,
      m_drinkArray[i].strTrainNumber,m_drinkArray[i].strTrainNo]);
        MSExcelWorkSheet.Cells[i + 2,11] := strPlaceName;

      end;

    end;
  end;
begin
  if not RsLCBaseDict.LCJwd.GetAllJwdList(JWDArray,error) then
  begin
    Box(error);
    Exit;
  end;

  MSExcel := CreateOleObject('Excel.Application');

  try
    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];
    
    CreateTitle();

    FillXlsData();

    MSExcelWorkBook.SaveAs(FileName);
  finally
    MSExcel.Quit;
  end;
  
  for I := 0 to Length(m_drinkArray) - 1 do
  begin

    m_drinkArray[i].strAreaGUID;
  end;
end;

procedure TfrmDrinkTestQuery.FormCreate(Sender: TObject);
begin
  Panel1.DoubleBuffered := True;
  RzPanel2.DoubleBuffered := True;
  m_TypeList := TGanBuTypeList.Create;
  m_RsLCDrink := TRsLCDrink.Create(GlobalDM.WebAPIUtils);
  m_RsLCDutyPlace := TRsLCDutyPlace.Create('','','');
  m_RsLCDutyPlace.SetConnConfig(GlobalDM.HttpConnConfig);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_RsDrinkImage := TRsDrinkImage.Create(GlobalDM.WebHost + GlobalDM.WebDrinkImgPage);
  m_Departments := TObjectList.Create;
end;

procedure TfrmDrinkTestQuery.FormDestroy(Sender: TObject);
begin
  m_RsLCDrink.Free;
  m_RsLCDutyPlace.Free ;
  m_RsLCTrainmanMgr.Free ;
  m_RsDrinkImage.Free;
  m_TypeList.Free;
  m_Departments.Free;
end;

procedure TfrmDrinkTestQuery.InitData;
var
  DutyPlaceArray:TRsDutyPlaceList;
  workShopArray : TRsWorkShopArray;
  drinkTypeArray : TSysDictItemArray;
  drinkResultArray : TSysDictItemArray;
  jwdArray : TRsJWDArray ;
  verifyArray : TSysDictItemArray;
  i: Integer;
  Error: string;
begin
  //��ʼ��������Ϣ
  dtpBeginDate.DateTime := GlobalDM.GetNow ;
  dtpEndDate.DateTime := GlobalDM.GetNow ;

  if not RsLCBaseDict.LCJwd.GetAllJwdList(jwdArray,Error) then
  begin
    Box(Error);
  end;
  
  cmbJwd.ClearItems;
  cmbJwd.AddItemValue('���л����','');
  for I := 0 to Length(jwdArray) - 1 do
  begin
    cmbJwd.AddItemValue(JWDArray[i].strName,JWDArray[i].strUserCode);
  end;
  cmbJwd.ItemIndex := cmbJwd.Values.IndexOf(LeftStr(GlobalDM.SiteInfo.strSiteIP,2));

  if cmbJwd.ItemIndex = -1 then
    cmbJwd.ItemIndex := 0;




  //��ʼ��������Ϣ
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(GlobalDM.SiteInfo.strAreaGUID,workShopArray,Error) then
  begin
    Box(Error);
  end;
  comboWorkShop.ClearItemsValues;
  comboWorkShop.AddItemValue('���г���','');
  comboWorkShop.ItemIndex := 0;
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID);



  RsLCBaseDict.LCDepartment.Query(m_Departments);

  cbbDepartment.ClearItemsValues;
  cbbDepartment.AddItemValue('ȫ��','');
  cbbDepartment.ItemIndex := 0;

  for I := 0 to m_Departments.Count - 1 do
  begin
    cbbDepartment.AddItemValue((m_Departments[i] as TDepartment).Name,(m_Departments[i] as TDepartment).ID);
  end;


  cbbGanbuType.ClearItems();
  cbbGanbuType.AddItemValue('ȫ��','');
  cbbGanbuType.ItemIndex := 0;

  RsLCBaseDict.LCGanBu.LCGanBuType.Query('',m_TypeList);
  
  //��ʼ���������
  RsLCBaseDict.LCSysDict.GetDrinkTypeArray(drinkTypeArray);
  comboDrinkType.ClearItems;
  comboDrinkType.AddItemValue('��������','-1');
  comboDrinkType.ItemIndex := 0;
  for i := 0 to length(drinkTypeArray) - 1 do
  begin
    comboDrinkType.AddItemValue(drinkTypeArray[i].TypeName,IntToStr(drinkTypeArray[i].TypeID));
  end;
  //��ʼ����ƽ��
  RsLCBaseDict.LCSysDict.GetDrinkResult(drinkResultArray);
  comboDrinkResult.ClearItems;
  comboDrinkResult.AddItemValue('���н��','-1');
  comboDrinkResult.ItemIndex := 0;
  for i := 0 to length(drinkResultArray) - 1 do
  begin
    comboDrinkResult.AddItemValue(drinkResultArray[i].TypeName,IntToStr(drinkResultArray[i].TypeID));
  end;
  //��ʼ��ָ����֤��ʽ
  RsLCBaseDict.LCSysDict.GetVerifyArray(verifyArray);
  comboVerify.ClearItems;
  comboVerify.AddItemValue('���з�ʽ','-1');
  comboVerify.ItemIndex := 0;
  for i := 0 to length(verifyArray) - 1 do
  begin
    comboVerify.AddItemValue(verifyArray[i].TypeName,IntToStr(verifyArray[i].TypeID));
  end;

  //�ͻ��˱��
  m_RsLCDutyPlace.GetDutyPlaceList(DutyPlaceArray);
  cmbDrinkPlace.ClearItems;
  cmbDrinkPlace.AddItemValue('���еص�','');
  cmbDrinkPlace.ItemIndex := 0;
  for i := 0 to length(DutyPlaceArray) - 1 do
  begin
    cmbDrinkPlace.AddItemValue(DutyPlaceArray[i].placeName,DutyPlaceArray[i].placeID );
  end;

end;

procedure TfrmDrinkTestQuery.lvTrainmanAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if Item.SubItems[5] <> '����' then
    Sender.Canvas.Brush.Color := clRed ;
end;

procedure TfrmDrinkTestQuery.lvTrainmanClick(Sender: TObject);
const
  TESTPICTURE_DEFAULT = 'Images\�����Ƭ\noPhoto.jpg';
  TESTPICTURE_CURRENT = 'Images\�����Ƭ\DrinkTest.jpg';
var
  RDrink: RRsDrink;
  trainman:RRsTrainman ;
  pictureStream : TMemoryStream;
  JpegImage : TJpegImage ;
begin
  if lvTrainman.Selected = nil then exit;


  if m_RsLCTrainmanMgr.GetTrainmanByNumber(lvTrainman.Selected.SubItems[3],trainman,2) then
  begin
    if not (VarIsNull(trainman.Picture) or VarIsEmpty(trainman.Picture)) then
    begin
      PictureStream := TMemoryStream.Create;
      TemplateOleVariantToStream(trainman.Picture,PictureStream);

      JpegImage := TJpegImage.Create;
      PictureStream.Position := 0;
      JpegImage.LoadFromStream(PictureStream);
      imgStand.Picture.Graphic := JpegImage;
      JpegImage.Free;
      PictureStream.Free;
      if imgStand.Picture.Width = 0 then
        imgStand.Picture.Graphic := nil;
    end
    else
     imgStand.Picture.Graphic := nil;
  end;


  if m_RsLCDrink.GetDrinkInfo(lvTrainman.Selected.SubItems[lvTrainman.Selected.SubItems.Count - 1],RDrink) then
  begin
    if RDrink.strPictureURL <> '' then
    begin
      if m_RsDrinkImage.DownLoad(GlobalDM.WebHost + RDrink.strPictureURL,GlobalDM.AppPath + TESTPICTURE_CURRENT) then
        imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_CURRENT)
      else
      begin
        imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
      end;
    end
    else
      imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
  end
  else
    imgDrink.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);

end;



class procedure TfrmDrinkTestQuery.OpenDrinkTestQuery;
var
  frmDrinkTestQuery: TfrmDrinkTestQuery;
begin
  frmDrinkTestQuery := TfrmDrinkTestQuery.Create(nil);
  try
    frmDrinkTestQuery.InitData;
    frmDrinkTestQuery.ShowModal;
  finally
    frmDrinkTestQuery.Free;
  end;
end;

procedure TfrmDrinkTestQuery.btnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    TfrmHint.ShowHint('���ڵ������ݣ����Ժ򡭡�');
    try
      ExportToFile(SaveDialog1.FileName);
      TfrmHint.CloseHint;
      Box('�������');
    finally
      TfrmHint.CloseHint;
    end;

  end;

end;

procedure TfrmDrinkTestQuery.btnMoreClick(Sender: TObject);
begin
  if Panel1.Height < 100 then
  begin
    Panel1.Height := 107;
    TPngSpeedButton(Sender).PngImage :=  imgLstBtnMore.PngImages.Items[1].PngImage;
  end
  else
  begin
    Panel1.Height := 68;
    TPngSpeedButton(Sender).PngImage :=  imgLstBtnMore.PngImages.Items[0].PngImage;
  end;
end;

procedure TfrmDrinkTestQuery.QueryDrinkTest;
var
  i: Integer;
  item : TListItem;
  strTrainNo:string ;
  strText : string ;
  QueryParam: TDrinkQueryParam;
begin
  QueryParam := TDrinkQueryParam.Create;

  try
    QueryParam.dtBeginTime := DateOf(dtpBeginDate.DateTime);
    QueryParam.dtEndTime := IncSecond(DateOf(IncDay(dtpEndDate.DateTime,1)),-1);
    QueryParam.WorkShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
    QueryParam.PlaceId := cmbDrinkPlace.Values[cmbDrinkPlace.ItemIndex];
    QueryParam.strJwdId := cmbJwd.Values[cmbJwd.ItemIndex] ;
    QueryParam.VerifyID := strToInt(comboVerify.Values[comboVerify.ItemIndex]);
    QueryParam.DrinkTypeID := strToInt(comboDrinkType.Values[comboDrinkType.ItemIndex]);
    QueryParam.DrinkResultID := strToInt(comboDrinkResult.Values[comboDrinkResult.ItemIndex]);
    QueryParam.TrainmanName := Trim(edtTrainmanName.Text);
    QueryParam.TrainmanNumber := Trim(edtTrainmanNumber.Text);
    QueryParam.DepartmentID := cbbDepartment.Values.Strings[cbbDepartment.ItemIndex];
    QueryParam.CadreTypeID := cbbGanbuType.values[cbbGanbuType.ItemIndex];


    m_RsLCDrink.QueryDrink(QueryParam,m_drinkArray);

  finally
    QueryParam.Free;
  end;


  lvTrainman.Items.Clear;


  for i := 0 to length(m_drinkArray) - 1 do
  begin
    item := lvTrainman.Items.Add;
    item.Data := @m_drinkArray[i];
    item.Caption := IntToStr(i + 1);
    if m_drinkArray[i].bLocalAreaTrainman   then
      strText := '��'
    else
      strText := '��' ;

    item.SubItems.Add(strText) ;
    item.SubItems.Add(m_drinkArray[i].strWorkShopName);
    item.SubItems.Add(m_drinkArray[i].strTrainmanName);
    item.SubItems.Add(m_drinkArray[i].strTrainmanNumber);
    item.SubItems.Add(FormatDateTime('yy-MM-dd HH:nn',m_drinkArray[i].dtCreateTime));
    item.SubItems.Add(m_drinkArray[i].strDrinkResultName);
    item.SubItems.Add(m_drinkArray[i].strVerifyName);
    item.SubItems.Add(m_drinkArray[i].strWorkTypeName);
    item.SubItems.Add( IntToStr( m_drinkArray[i].dwAlcoholicity ) );

    strTrainNo := Format('[%s-%s]%s',[m_drinkArray[i].strTrainTypeName,
      m_drinkArray[i].strTrainNumber,m_drinkArray[i].strTrainNo]) ;

    item.SubItems.Add(strTrainNo);

    item.SubItems.Add(m_drinkArray[i].strDepartmentName);
    item.SubItems.Add(m_drinkArray[i].strCadreTypeName);
    item.SubItems.Add(m_drinkArray[i].strPlaceName);
    item.SubItems.Add(m_drinkArray[i].strSiteName);
    item.SubItems.Add(Format('[%s]%s',[m_drinkArray[i].strDutyNumber,m_drinkArray[i].strDutyName]));
    item.SubItems.Add(m_drinkArray[i].strGUID);
  end;
end;
end.
