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

    //����ͼ������excel
    procedure ExportTrainNos(TrainJiaoluGUID:string;FileName:string);
    //����ͼ������
    procedure ImportTrainNos(TrainJiaoluGUID,JiaoLuName:string; FileName:string);
    //��ȡҪѡ��ͼ�����ε�GUID
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
    Box('��ѡ��Ҫɾ����ͼ��������Ϣ');
    exit;
  end;
  if Application.MessageBox('��ȷ��Ҫɾ����ͼ��������Ϣ��', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  if m_webTrainNo.Delete(TrainNoGUID,strError) then
  begin
    Box('ɾ���ɹ�!');
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

  if TBox('����ǰ,�Ƿ�ɾ���ý�·�����ͼ������?') then
  begin
    if not m_webTrainNo.DeleteByJiaoLu(strJiaoLuGUID,strError) then
    begin
      BoxErr(strError);
      Exit ;
    end;
  end;
  

  strText := Format('��ǰѡ�еĽ�·Ϊ: [%s] ,�Ƿ��������?',[strJiaoLuName]);
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
    Box('��ѡ��Ҫ�޸ĵ�ͼ��������Ϣ');
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
    strError := '�㻹û�а�װMicrosoft Excel�����Ȱ�װ��';
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
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
HorizontalAlignment:=3��  
����1�����棻2����������3�����У�4�����ң�5�����  

VerticalAlignment:=2��  
����1�����ϣ�2�����У�3�����£�4�����˶���  
}
    workSheet.columns.HorizontalAlignment:=3;  //�����
    excelApp.Cells[nRow,nCol].Value := '���';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '������·';
    workSheet.Columns[nCol].ColumnWidth := 17;    //���ø�ע�Ŀ��
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '����';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '����';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '����';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '�ƻ�����ʱ��';
    workSheet.Columns[nCol].ColumnWidth := 15;    //���ø�ע�Ŀ��
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '�ƻ�����ʱ��';
    workSheet.Columns[nCol].ColumnWidth := 15;    //���ø�ע�Ŀ��
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '�Ƿ���';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '���ʱ��';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '�а�ʱ��';
    Inc(nCol);

    excelApp.Cells[nRow,nCol].Value := '�ͻ�';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '��ע����';
    Inc(nCol);
    excelApp.Cells[nRow,nCol].Value := '���ڵ�';
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
          excelApp.Cells[nRow,nCol].Value := '���';
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtArriveTime) );
          Inc(nCol);
          excelApp.Cells[nRow,nCol].Value := FormatDateTime('HH:mm',StrToDateTime(TrainnosInfoList[i].dtCallTime) );
          Inc(nCol);
        end
        else
        begin
          excelApp.Cells[nRow,nCol].Value := '�����';
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

        TfrmProgressEx.ShowProgress('���ڵ�����Ϣ�����Ժ�',i + 1,length(TrainnosInfoList));
        Inc(nRow);
    end;

    Box('���������鿴!');
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
  //��¼strGrid���п�
  strGridTrainTrainNo.ColumnSize.Key := 'FormColWidths.ini';
  strGridTrainTrainNo.ColumnSize.Section := 'TrainNo';
  strGridTrainTrainNo.ColumnSize.Save := true;
  strGridTrainTrainNo.ColumnSize.Location := clIniFile;
  //

  strGridTrainTrainNo.HideColumn( 21 );
  strGridTrainTrainNo.HideColumn( 22 );
  //���ݿ������
//  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  //���ڵ�
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
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    excelApp.workBooks.Open(FileName);
    excelApp.Worksheets[1].activate;
    //�ӵڶ��п�ʼ����һ���Ǳ���
    nIndex := 2;
    nTotalCount := 0;

    //�����ж��ٸ�������
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
       Application.MessageBox('û�пɵ����ͼ��������Ϣ��','��ʾ',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    nIndex := 2;

    //�������ݲ���
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
    TrainnosInfo.planTypeName := '����' ;

    TrainnosInfo.dragTypeID := '2';
    TrainnosInfo.dragTypeName := '����' ;

    TrainnosInfo.TrainmanTypeID := '1';
    TrainnosInfo.trainmanTypeName := '����' ;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
     //�ռ�����
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

      if excelApp.Cells[nIndex,INDEX_COL_NEEDREST].Value = '���' then
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
      TfrmProgressEx.ShowProgress('���ڵ���ͼ��������Ϣ�����Ժ�',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
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
          Cells[index , i + 1] := '���';
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
      Box('��ȡͼ��������Ϣʧ�ܣ�' + e.Message);
    end;
  end;
end;

end.
