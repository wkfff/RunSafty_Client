unit uFrmTrainNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls,ADODB,uGlobalDM, RzPanel, ImgList,
  Buttons, RzTabs, PngSpeedButton, RzStatus, PngCustomButton,
  uTrainJiaolu,uTrainNo, Grids, AdvObj,uTrainPlan,
  uTrainman,uTFSystem,uSaftyEnum,ComObj,uStation,uDutyPlace,uLCDutyPlace,
  BaseGrid,AdvGrid,uTrainnos,uLCTrainnos;


const
  INDEX_COL_GUID = 21 ;

type
  TfrmTrainNo = class(TForm)
    ImageList1: TImageList;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label3: TLabel;
    Panel1: TPanel;
    RzPanel1: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    RzStatusBar1: TRzStatusBar;
    statuspanelSum: TRzStatusPane;
    RzPanel3: TRzPanel;
    strGridTrainTrainNo: TAdvStringGrid;
    btnAdd: TPngSpeedButton;
    btnUpdate: TPngSpeedButton;
    btnDelete: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    btnImport: TPngSpeedButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure tabTrainJiaoluChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
  private
    { Private declarations }
    m_webTrainNo : TRsLCTrainnos ;
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    m_webDutyPlace: TRsLCDutyPlace ;
    m_ErrInfo: string;
    procedure InitTrainJiaolus;
    procedure InitTrainNos;
    procedure UpdateTrainPlan(TrainJiaoluGUID:string);

    //导出图定车次excel
    procedure ExportTrainNos(TrainJiaoluGUID:string;FileName:string);
    //导入图定车次
    procedure ImportTrainNos(TrainJiaoluGUID,JiaoLuName:string; FileName:string);
    //获取要选择图定车次的GUID
    function GetSelectedTrainNo(out TrainNoGUID : string) : boolean;
  public
    { Public declarations }
    class procedure ManageTrainNo;
  end;



implementation
{$R *.dfm}
uses
  uFrmTrainNoAdd, DB,DateUtils,uFrmProgressEx,uLCDict_TrainJiaoLu,
  uLCBaseDict;

procedure TfrmTrainNo.btnAddClick(Sender: TObject);
var
  strTrainJiaoluGUID : string;
begin
  if tabTrainJiaolu.TabIndex > -1 then
    strTrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;

  if not TfrmTrainNoAdd.EditTrainNo('',strTrainJiaoluGUID) then Exit;
  InitTrainNos;
end;

procedure TfrmTrainNo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTrainNo.btnDeleteClick(Sender: TObject);
var
  strError:string;
  trainNoGUID : string;
begin
  if not GetSelectedTrainNo(trainNoGUID) then
  begin
    Box('请选择要删除的图定车次信息');
    exit;
  end;
  if Application.MessageBox('您确定要删除此图定车次信息吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  if m_webTrainNo.Delete(TrainNoGUID,strError) then
  begin
    Box('删除成功!');
    InitTrainNos;
  end
  else
    BoxErr(strError);
end;

procedure TfrmTrainNo.btnExportClick(Sender: TObject);
var
  strFileName:string;
  strJiaoLuGUID : string;
begin
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  strJiaoLuGUID := m_TrainJiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  if not SaveDialog.Execute(Self.Handle)  then
    exit ;
  strFileName := SaveDialog.FileName ;
  ExportTrainNos(strJiaoLuGUID,strFileName);
end;

procedure TfrmTrainNo.btnImportClick(Sender: TObject);
var
  strJiaoLuGUID,strJiaoLuName,strFileName : string;
  strText : string ;
  strError:string ;
begin
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  strJiaoLuGUID := m_TrainJiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID ;
  strJiaoLuName := m_TrainJiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluName ;

  if TBox('导入前,是否删除该交路下面的图定车次?') then
  begin
    if not m_webTrainNo.DeleteByJiaoLu(strJiaoLuGUID,strError) then
    begin
      BoxErr(strError);
      Exit ;
    end;
  end;
  

  strText := Format('当前选中的交路为: [%s] ,是否继续导入?',[strJiaoLuName]);
  if not TBox(strText) then
    Exit ;

  if not OpenDialog.Execute then exit;
  strFileName := OpenDialog.FileName ;
  ImportTrainNos(strJiaoLuGUID,strJiaoLuName,strFileName);
  InitTrainNos;
end;

procedure TfrmTrainNo.btnUpdateClick(Sender: TObject);
var
  trainNoGUID : string;
  strTrainJiaoluGUID : string;
begin
  if not GetSelectedTrainNo(trainNoGUID) then
  begin
    Box('请选择要修改的图定车次信息');
    exit;
  end;

  if tabTrainJiaolu.TabIndex > -1 then
    strTrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  if not TfrmTrainNoadd.EditTrainNo(trainNoGUID,strTrainJiaoluGUID) then Exit;
  InitTrainNos;
end;

procedure TfrmTrainNo.ExportTrainNos(TrainJiaoluGUID: string;FileName:string);
var
  excelApp, workBook, workSheet: Variant;
  i,nRow,nCol: integer;
  strError: string;
  TrainnosInfoList: TRsTrainnosInfoList;
begin

  if not m_webTrainNo.GetByJiaoLu(TrainJiaoluGUID, TrainnosInfoList,strError) then
  begin
    BoxErr(strError);
    exit ;
  end;

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strError := '你还没有安装Microsoft Excel，请先安装！';
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(FileName) then
    begin
      excelApp.workBooks.Open(FileName);
      excelApp.Worksheets[1].activate;
      workSheet :=  excelApp.ActiveSheet ;
    end
    else
    begin
      excelApp.WorkBooks.Add;
      workBook := excelApp.Workbooks.Add;
      workSheet := workBook.Sheets.Add;
    end;

    nRow := 1 ;
    nCol := 1 ;
    {
HorizontalAlignment:=3；  
其中1：常规；2：左缩进；3：居中；4：靠右；5：填充  

VerticalAlignment:=2；  
其中1：靠上；2：居中；3：靠下；4：两端对齐  
}
    workSheet.columns.HorizontalAlignment:=3;  //左对齐
    excelApp.Cells[nRow,nCol].Value := '序号';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '机车交路';
    workSheet.Columns[nCol].ColumnWidth := 17;    //设置附注的宽度
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '车型';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '车号';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '车次';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '计划出勤时间';
    workSheet.Columns[nCol].ColumnWidth := 15;    //设置附注的宽度
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '计划开车时间';
    workSheet.Columns[nCol].ColumnWidth := 15;    //设置附注的宽度
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '是否候班';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '候班时间';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '叫班时间';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '客货';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '备注类型';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '出勤点';
    Inc(nCol);

    Inc(nRow);

    for i := 0 to Length(TrainnosInfoList) - 1 do
    begin
        nCol := 1 ;
        excelApp.Cells[nRow,nCol].Value := IntToStr(i + 1);
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value := TrainnosInfoList[i].TrainJiaoluName;
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value :=  TrainnosInfoList[i].TrainTypeName;
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value :=  TrainnosInfoList[i].TrainNumber;
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value := TrainnosInfoList[i].TrainNo;
        Inc(nCol);

        excelApp.Cells[nRow,nCol].Value := FormatDateTime('hh:nn', StrToDateTime(TrainnosInfoList[i].StartTime));
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value := FormatDateTime('hh:nn', StrToDateTime(TrainnosInfoList[i].kaiCheTime));
        Inc(nCol);

        if TrainnosInfoList[i].nNeedRest = 1 then
        begin
          excelApp.Cells[nRow,nCol].Value := '候班';
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtArriveTime) );
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtCallTime) );
          Inc(nCol);
        end
        else
        begin
          excelApp.Cells[nRow,nCol].Value := '不候班';
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := '';
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := '';
          Inc(nCol);
        end;

        excelApp.Cells[nRow,nCol].Value := TrainnosInfoList[i].kehuoName;
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value := TrainnosInfoList[i].remarkTypeName;
        Inc(nCol);
        excelApp.Cells[nRow,nCol].Value := TrainnosInfoList[i].placeName ;
        Inc(nCol);

        TfrmProgressEx.ShowProgress('正在导出信息，请稍后',i + 1,length(TrainnosInfoList));
        Inc(nRow);
    end;

    Box('导出完毕请查看!');
    if not FileExists(FileName) then
      workSheet.SaveAs(FileName);
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

procedure TfrmTrainNo.FormCreate(Sender: TObject);
begin
  //记录strGrid的列宽
  strGridTrainTrainNo.ColumnSize.Key := 'FormColWidths.ini';
  strGridTrainTrainNo.ColumnSize.Section := 'TrainNo';
  strGridTrainTrainNo.ColumnSize.Save := true;
  strGridTrainTrainNo.ColumnSize.Location := clIniFile;
  //

  strGridTrainTrainNo.HideColumn( 21 );
  strGridTrainTrainNo.HideColumn( 22 );
  //数据库操作累
//  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  //出勤点
  m_webDutyPlace  := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webTrainNo := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
end;

procedure TfrmTrainNo.FormDestroy(Sender: TObject);
begin
//  m_DBTrainJiaolu.Free;
  m_webTrainNo.Free;
  m_webDutyPlace.Free ;
end;

function TfrmTrainNo.GetSelectedTrainNo(out TrainNoGUID: string): boolean;
begin
  result := false;
  TrainNoGUID :=  strGridTrainTrainNo.Cells[INDEX_COL_GUID, strGridTrainTrainNo.row];
  if Trim(TrainNoGUID) = '' then exit;
  result := true;
end;

procedure TfrmTrainNo.ImportTrainNos(TrainJiaoluGUID,JiaoLuName: string;
  FileName:string);
const
  INDEX_COL_TRAINTYPENAME = 3 ;
  INDEX_COL_TRAINNUMBER = 4 ;
  INDEX_COL_TRAINNO = 5 ;
  INDEX_COL_STARTTIME = 6 ;
  INDEX_COL_KAICHETIME = 7 ;
  INDEX_COL_PLACE =    13;
  INDEX_COL_KEHUO   = 11 ;
  INDEX_COL_REMARKTYPE = 12  ;
  INDEX_COL_NEEDREST = 8 ;
  INDEX_COL_ARRIVETIME = 9;
  INDEX_COL_CALLTIME = 10 ;
var
  excelApp: Variant;
  nIndex,nTotalCount : integer;
  j: Integer;
  strError,strTrainNo:string;
  TrainnosInfo:RRsTrainnosInfo;
  stationArray : TRsStationArray;
  DutyPlaceList:TRsDutyPlaceList;
  Kehuo :TRsKehuo ;
  PlanRemarkType :TRsPlanRemarkType ;
begin

  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(TrainJiaoluGUID,DutyPlaceList,strError) then
  begin
    BoxErr(strError);
    Exit;
  end ;

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(FileName);
    excelApp.Worksheets[1].activate;
    //从第二行开始，第一行是标题
    nIndex := 2;
    nTotalCount := 0;

    //计算有多少个车次列
    while true do
    begin
      strTrainNo := excelApp.Cells[nIndex,INDEX_COL_TRAINNO].Value;
      if strTrainNo = '' then
        break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;

    if nTotalCount = 0 then
    begin
       Application.MessageBox('没有可导入的图定车次信息！','提示',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    nIndex := 2;

    //公共数据部分
    TrainnosInfo.trainjiaoluID := TrainJiaoluGUID ;
    TrainnosInfo.trainjiaoluName := JiaoLuName ;
    TrainnosInfo.strWorkDay := '1,2,3,4,5,6,7' ;

    RsLCBaseDict.LCStation.GetStationsOfJiaoJu(TrainJiaoluGUID,stationArray,m_ErrInfo);
//    m_DBTrainJiaolu.GetStationOfTrainJiaolu(TrainJiaoluGUID,stationArray);
    TrainnosInfo.startStationName := stationArray[0].strStationName ;
    TrainnosInfo.startStationID := stationArray[0].strStationGUID ;

    TrainnosInfo.endStationName := stationArray[0].strStationName ;
    TrainnosInfo.endStationID := stationArray[0].strStationGUID;

    TrainnosInfo.planTypeID := '1';
    TrainnosInfo.planTypeName := '运用' ;

    TrainnosInfo.dragTypeID := '2';
    TrainnosInfo.dragTypeName := '本务' ;

    TrainnosInfo.TrainmanTypeID := '1';
    TrainnosInfo.trainmanTypeName := '正常' ;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
     //收集数据
      TrainnosInfo.trainNoID := NewGUID ;
      TrainnosInfo.trainTypeName := excelApp.Cells[nIndex,INDEX_COL_TRAINTYPENAME].Value;
      TrainnosInfo.trainNumber := excelApp.Cells[nIndex,INDEX_COL_TRAINNUMBER].Value;
      TrainnosInfo.trainNo := excelApp.Cells[nIndex,INDEX_COL_TRAINNO].Value;

      TrainnosInfo.remark := '';
      TrainnosInfo.startTime := FormatDateTime('hh:mm:ss',excelApp.Cells[nIndex,INDEX_COL_STARTTIME].Value);
      TrainnosInfo.kaiCheTime := FormatDateTime('hh:mm:ss',excelApp.Cells[nIndex,INDEX_COL_KAICHETIME].Value);

      for j := 0 to  Length(DutyPlaceList)- 1 do
      begin
        if DutyPlaceList[j].placeName = excelApp.Cells[nIndex,INDEX_COL_PLACE].Value  then
        begin
          TrainnosInfo.placeID := DutyPlaceList[j].placeID;
          TrainnosInfo.placeName := DutyPlaceList[j].placeName ;
          Break ;
        end;
      end;

      Kehuo := KeHuoNameToType(excelApp.Cells[nIndex,INDEX_COL_KEHUO].Value) ;
      TrainnosInfo.KeHuoID := IntToStr( ord(Kehuo) );
      TrainnosInfo.kehuoName := excelApp.Cells[nIndex,INDEX_COL_KEHUO ].Value ;

      PlanRemarkType := PlanRemarkTypeNameToType(excelApp.Cells[nIndex,INDEX_COL_REMARKTYPE].Value);
      TrainnosInfo.remarkTypeID := IntToStr( ord(PlanRemarkType) ) ;
      TrainnosInfo.remarkTypeName := excelApp.Cells[nIndex,INDEX_COL_REMARKTYPE ].Value ;

      if excelApp.Cells[nIndex,INDEX_COL_NEEDREST].Value = '候班' then
      begin
        TrainnosInfo.nNeedRest := 1 ;
        TrainnosInfo.dtArriveTime := FormatDateTime('hh:mm:ss',excelApp.Cells[nIndex,INDEX_COL_ARRIVETIME].Value);
        TrainnosInfo.dtCallTime := FormatDateTime('hh:mm:ss',excelApp.Cells[nIndex,INDEX_COL_CALLTIME].Value);
      end
      else
      begin
        TrainnosInfo.nNeedRest :=  0;
        TrainnosInfo.dtArriveTime := '18:00:00';
        TrainnosInfo.dtCallTime := '18:00:00';
      end;

      m_webTrainNo.Add(TrainnosInfo,strError) ;
      TfrmProgressEx.ShowProgress('正在导入图定车次信息，请稍后',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导入完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmTrainNo.InitTrainJiaolus;
var
  i,tempIndex:Integer;
  tab:TRzTabCollectionItem;
begin
  tempIndex := tabTrainJiaolu.TabIndex;

  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(
    GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);

//  m_DBTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);
  tabTrainJiaolu.Tabs.Clear;
  for I := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    tab := tabTrainJiaolu.Tabs.Add;
    tab.Caption := m_TrainJiaoluArray[i].strTrainJiaoluName;
  end;
  if length(m_TrainJiaoluArray) > 0 then
  begin
    tabTrainJiaolu.TabIndex := 0;
    if (tempIndex > -1) and (tempIndex < tabTrainJiaolu.Tabs.Count) then
      tabTrainJiaolu.TabIndex := tempIndex;
  end;

//  InitTrainNos;
end;

procedure TfrmTrainNo.InitTrainNos;
var
  strJiaoLuGUID : string;
begin
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  strJiaoLuGUID := m_TrainJiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  UpdateTrainPlan(strJiaoLuGUID);
end;

class procedure TfrmTrainNo.ManageTrainNo;
var
  frmTrainNo: TfrmTrainNo;
begin
  frmTrainNo:= TfrmTrainNo.Create(nil);
  frmTrainNo.InitTrainJiaolus;
  frmTrainNo.ShowModal;
  frmTrainNo.Free;
end;

procedure TfrmTrainNo.tabTrainJiaoluChange(Sender: TObject);
begin
  InitTrainNos;
end;

procedure TfrmTrainNo.UpdateTrainPlan(TrainJiaoluGUID: string);
var
  strError:string;
  i: integer;
  index:Integer;
  TrainnosInfoList: TRsTrainnosInfoList;
begin
  try
    if not m_webTrainNo.GetByJiaoLu(TrainJiaoluGUID, TrainnosInfoList,strError) then
    begin
      BoxErr(strError);
      exit ;
    end;
    with strGridTrainTrainNo do
    begin
      ClearRows(1, 10000);
      RowCount := length(TrainnosInfoList) + 1;
      for i := 0 to length(TrainnosInfoList) - 1 do
      begin
        index := 0 ;
        Cells[index, i + 1] := IntToStr(i + 1);
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].TrainJiaoluName;
        Inc(index);

        Cells[index, i + 1] :=  TrainnosInfoList[i].TrainTypeName + '-' +  TrainnosInfoList[i].TrainNumber;
        Inc(index);

        Cells[index, i + 1] :=  TrainnosInfoList[i].TrainNo;
        Inc(index);

        Cells[index, i + 1] :=  TrainnosInfoList[i].Remark;
        Inc(index);

        if TrainnosInfoList[i].nNeedRest = 1 then
        begin
          Cells[index , i + 1] := '候班';
          Inc(index);

          Cells[index , i + 1] := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtArriveTime) );
          Inc(index);
          Cells[index , i + 1] := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtCallTime) );
          Inc(index);
        end
        else
          index := index + 3 ;


        Cells[index, i + 1] := FormatDateTime('hh:nn', StrToDateTime(TrainnosInfoList[i].StartTime));
        Inc(index);

        Cells[index , i + 1] :=  FormatDateTime('hh:nn', StrToDateTime(TrainnosInfoList[i].kaiCheTime));
        Inc(index);

        Cells[index, i + 1] := FormatDateTime('hh:nn', StrToDateTime(TrainnosInfoList[i].kaiCheTime));
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].StartStationName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].EndStationName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].trainmanTypeName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].planTypeName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].dragTypeName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].kehuoName;
        Inc(index);

        Cells[index, i + 1] := TrainnosInfoList[i].remarkTypeName;
        Inc(index);

        Cells[index , i + 1] := TrainnosInfoList[i].placeName ;
        Inc(index);

        Cells[index , i +1 ] := TrainnosInfoList[i].strWorkDay ;
        Cells[INDEX_COL_GUID, i +1] := TrainnosInfoList[i].trainNoID;

      end;
    end;
  except on e: exception do
    begin
      Box('获取图定车次信息失败：' + e.Message);
    end;
  end;
end;

end.
