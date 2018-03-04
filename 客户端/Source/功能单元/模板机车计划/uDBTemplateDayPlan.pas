unit uDBTemplateDayPlan;

interface

uses
  SysUtils,adodb,uTemplateDayPlan,uTFSystem,uSaftyEnum,DateUtils,ComObj,Variants,Classes;


const
  INDEX_LEFT_TRAIN_NO1 = 1 ;
  INDEX_LEFT_TRAIN_INFO = 2 ;
  INDEX_LEFT_TRAIN_NO2 = 3 ;
  INDEX_LEFT_TRAIN_REMARK = 4 ;

  INDEX_SEPRATOR = 5 ;

  INDEX_RIGHT_TRAIN_NO1 = 6 ;
  INDEX_RIGHT_TRAIN_INFO = 7 ;
  INDEX_RIGHT_TRAIN_NO2 = 8 ;
  INDEX_RIGHT_TRAIN_REMARK = 9 ;

  xlHAlignCenter = -4108;   //excel���ж���

  EXCEL_ROW_HEIGHT  = 16 ;

type

  //���������¼�
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;
  //
  //�����ƻ����ݿ������
  //
  TRsDBTemplateDayPlan = class(TDBOperate)
  public
    //���һ�������ƻ�
    function InsertDayPlan(DayPlan:TRsDayPlan):Boolean;
    //�޸�һ�������ƻ�
    function UpdateDayPlan(DayPlan:TRsDayPlan):Boolean;
    //ɾ�����������ƻ�
    function DeleteDayPlan(DayPlan:TRsDayPlan):Boolean;
    //��ѯ�����ƻ�
    function QueryDayPlan(ID:Integer;DayPlan:TRsDayPlan):Boolean;
    //��ȡuoyou���г��ƻ�
    function QueryDayPlanList(DayPlanList:TRsDayPlanList):Boolean ;
  public
    //��ָ���Ļ����ƻ������һ������Ϣ
    function InsertGroup(DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //��ָ���Ļ����ƻ����޸�һ������Ϣ
    function UpdateGroup(DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //��ָ���Ļ����ƻ���ɾ��һ������Ϣ
    function DeleteGroup(DayPlanID: Integer;GroupID:Integer):Boolean;
    //��ȡ������������
    function QueryGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //��ȡEXCEL��ߵ�
    function QueryLeftGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //��ȡEXCEL�ұߵ�
    function QueryRightGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //��ȡָ�������ƻ���һ����Ϣ
    function QueryGroupInfo(DayPlanID: Integer;GroupID:Integer;DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //�Ƿ����
    //function IsExistGroup(Name:string):Boolean;
  public
    //��ָ���Ļ����ƻ������һ������Ϣ
    function InsertItem(DayPlanItem:TRsDayPlanItem):Boolean;
    //��ָ���Ļ����ƻ����޸�һ������Ϣ
    function UpdateItem(DayPlanItem:TRsDayPlanItem):Boolean;
    //��ָ���Ļ����ƻ���ɾ��һ������Ϣ
    function DeleteItem(ItemID:Integer):Boolean;
    //��ָ���Ļ����ƻ��ϲ���һ������Ϣ
    function QueryItem(ItemID:Integer;DayPlanItem:TRsDayPlanItem):Boolean ;
    //��ָ���Ļ����ƻ��ϲ���һ������Ϣ
    function QueryItemList(GroupD:Integer;DayPlanType:Integer;DayPlanItemList:TRsDayPlanItemList):Boolean;
  public
    //�Ƿ��Ѿ����ع��ƻ�
    function IsLoadedDayPlanInfo(BeginDate,EndDate: TDateTime; DayPlanID: Integer;DayOrNight: integer):Boolean;
    //����һ����־
    procedure AddModifyPlanLog(PlanGUID:string;DayPlanLog:RsDayPlanLog);
    //��ȡһ���ƻ���������־
    function GetModifyPlanLogs(PlanGUID:string;out DayPlanLogArray:RsDayPlanLogArray):Boolean;
    //�����ƻ�
    function SendDayPlan(BeginDate,EndDate: TDateTime; DayPlanID: Integer):Boolean;
    //�����ƻ�
    function GetPaiBanPlans(BeginDate,EndDate: TDateTime; DayPlanID: Integer;var PlanList:TStrings):Boolean;
    //�����ѷ����ƻ�Ϊ����״��
    procedure SetPlansSendState(BeginDate,EndDate: TDateTime; DayPlanID: Integer;var PlanList:TStrings);
    //�޸��ư��ƻ��ĳ��ͺͳ���
    function UpdatePaiPlan(PlanGUID:string;TrainTypeName,TrainNumber,Remark:string;SiteGUID:String;DutyUserGUID:string):Boolean;
    //���ؼƻ�
    procedure LoadDayPlanInfo(DayPlanDate,DtNow: TDateTime; DayOrNight: integer;
      DayPlanID,QuDuan:Integer;DayPlanItemList:TRsDayPlanItemList);
    //���Ӽ��ؼƻ�LOG
    procedure AddLoadPlanLog(BeginDate,EndDate,DtNow: TDateTime; DayPlanID: Integer;DayOrNight: integer);
    //�½��ƻ�
    function AddDayPlanInfo(DayPlanInfo:RsDayPlanInfo):Boolean;
    //�޸ļƻ�
    function ModifyDayPlanInfo(DayPlanInfo:RsDayPlanInfo):Boolean;
    //ɾ���ƻ�
    function DeleteDayPlanInfoByGUID(GUID:string):Boolean;
    //ɾ��һ����ƻ�
    function DeleteDayPlanInfoByGroupID(BeginDate,EndDate: TDateTime;
      QuDuan:Integer):Boolean;
    //��ѯ�ƻ�
    function QueryDayPlanInfoByID(GUID:string; var DayPlanInfo:RsDayPlanInfo):Boolean;
    //��ѯ�ƻ�
    function QueryDayPlanInfoListByGroupID(BeginDate,EndDate: TDateTime;
      GroupID:Integer;var DayPlanInfoList:RsDayPlanInfoArray):Boolean ;
    //��ѯ�·��ƻ�
    function QueryPublishDayPlanInfoListByGroupID(BeginDate,EndDate: TDateTime;
      GroupID:Integer;var DayPlanInfoList:RsDayPlanInfoArray):Boolean ;
    //ɾ�������ƻ�
    function DeleteTrainPlanByDayPlanID(BeginDate,EndDate: TDateTime;DayPlanID:Integer):Boolean;
  public
    //����
    function GetTrainTypeName(ShortName:string):string;
    //�õ����е�����
    function GetTrainTypes(var ShortTrainArray:TRsShortTrainArray):Boolean;

    {������������Ӧ����������Ҫ�ǵ�������}
  public
    //���浽EXCEL
    function SaveToExcel(BeginDate,EndDate: TDateTime;DayPlanID:Integer;DayOrNight: integer; ExcelFile: string): boolean;
  private
    //��ѯһ���ж�����
    function GetTotalPlanCount(BeginDate,EndDate: TDateTime;DayPlanID:Integer):Integer;
    //��ȡ��������
    function GetPlanTitle(BeginDate,EndDate: TDateTime;DayOrNight: integer):string;
    //��ӱ���
    procedure AddTitle(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //////////////////���
    //���ͷ
    procedure AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //�������
    procedure AddLeftContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��Ӵ���
    procedure AddLeftDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��ӽ�����
    procedure AddLeftFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);

    /////////////////�Ҳ�
    //���ͷ
    procedure AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //�������
    procedure AddRightContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��Ӵ���
    procedure AddRightDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //��ӽ�����
    procedure AddRightFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);

    //��ӱ߿�
    procedure AddBorder(excelApp, workBook, workSheet: Variant;Row:Integer);
  private
    //��������
    procedure DataItemToAdo( DayPlanItem:TRsDayPlanItem;Ado:TADOQuery);
    procedure AdoToDataItem( DayPlanItem:TRsDayPlanItem;Ado:TADOQuery);

    procedure DataGroupToAdo( DayPlanItemGroup:TRsDayPlanItemGroup;Ado:TADOQuery);
    procedure AdoToDataGroup( DayPlanItemGroup:TRsDayPlanItemGroup;Ado:TADOQuery);

    procedure DataDayPlanToAdo( DayPlan:TRsDayPlan;Ado:TADOQuery);
    procedure AdoToDataDayPlan( DayPlan:TRsDayPlan;Ado:TADOQuery);

    procedure DataPlanInfoToAdo(var DayPlanInfo:RsDayPlanInfo;Ado:TADOQuery);
    procedure AdoToDataPlanInfo(var DayPlanInfo:RsDayPlanInfo;Ado:TADOQuery) ;

    procedure DataDayPlanLogToAdo(DayPlanLog:RsDayPlanLog;Ado:TADOQuery);
    procedure AdoToDataDayPlanLog(VAR DayPlanLog:RsDayPlanLog;Ado:TADOQuery);
  private
      m_OnExportPlanProgress: TOnExportPlanProgress;          //���������¼�
  published
    //���������¼�
    property OnExportPlanProgress: TOnExportPlanProgress read m_OnExportPlanProgress write m_OnExportPlanProgress;
  end;

implementation

{ TRsDBTemplateDayPlan }

function TRsDBTemplateDayPlan.InsertItem(
  DayPlanItem: TRsDayPlanItem): Boolean;
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  Result := False ;
  strSql := 'Select * from Tab_Base_DayPlan_Item where  1 = 2 ';
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataItemToAdo(DayPlanItem,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.IsLoadedDayPlanInfo(BeginDate,EndDate: TDateTime;
  DayPlanID, DayOrNight: integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  try
    adoQuery.Sql.Text := 'select top 1 strGUID from Tab_DayPlan_Send  where ' +
    ' nDayPlanID =:nDayPlanID  and nDayOrNight =:nDayOrNight and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate )';
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('nDayOrNight').Value := DayOrNight ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.Open;
    if adoQuery.RecordCount <= 0 then
      Exit ;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTemplateDayPlan.LoadDayPlanInfo(DayPlanDate,DtNow: TDateTime; DayOrNight,
  DayPlanID,QuDuan: Integer; DayPlanItemList: TRsDayPlanItemList);
var
  i : Integer ;
  DayPlanInfo:RsDayPlanInfo ;
  dtBeginTime,dtEndTime : TDateTime ;
begin
  for I := 0 to DayPlanItemList.Count - 1 do
  begin
    with DayPlanInfo do
    begin
      strDayPlanGUID:= NewGUID ;  //�ƻ�ID
      nPlanState := psEdit ;

      if DayOrNight = 0 then  //�װ�
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),8);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
      end
      else if DayOrNight = 1  then  //ҹ��
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),18);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
      end
      else                            //ȫ��
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),18);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
      end;

      dtBeginTime:= dtBeginTime ;   //��ʼʱ��
      dtEndTime:= dtEndTime ;    //����ʱ��
      dtCreateTime:= DtNow ;  //�����¼�
      strTrainNo1:= DayPlanItemList.Items[i].TrainNo1 ;     //����1
      strTrainInfo:= DayPlanItemList.Items[i].TrainInfo;    //������Ϣ
      strTrainNo2:= DayPlanItemList.Items[i].TrainNo2;      //���� 2
      strTrainNo := DayPlanItemList.Items[i].TrainNo;      //����
      strTrainTypeName:= '' ; //����
      strTrainNumber:= '' ;  //����
      strRemark:= DayPlanItemList.Items[i].Remark;
      IF DayPlanItemList.Items[i].IsTomorrow > 0then
       strRemark := Format('%d��',[DayOf(DayPlanDate)+1]);
      bIsTomorrow := DayPlanItemList.Items[i].IsTomorrow ;

      nDayPlanID := DayPlanID ;
      nQuDuanID:= DayPlanItemList.Items[i].GroupID ;      //������Ϣ

      //����ר��
      strDaWenCheXing := DayPlanItemList.Items[i].DaWenCheXing ;
      strDaWenCheHao1 := DayPlanItemList.Items[i].DaWenCheHao1 ;
      strDaWenCheHao2 := DayPlanItemList.Items[i].DaWenCheHao2 ;
      strDaWenCheHao3 := DayPlanItemList.Items[i].DaWenCheHao3 ;

      nPlanID := DayPlanItemList.Items[i].ID ;
      bIsSend := 0 ;

      strTrainPlanGUID := '' ;
    end;
    AddDayPlanInfo(DayPlanInfo) ;

  end;
end;

function TRsDBTemplateDayPlan.ModifyDayPlanInfo(DayPlanInfo: RsDayPlanInfo): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result:= False ;
  strSql := 'Select * from TAB_DayPlan_TrainRelation where strDayPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(DayPlanInfo.strDayPlanGUID)]);
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      DataPlanInfoToAdo(DayPlanInfo,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTemplateDayPlan.AddBorder(excelApp, workBook, workSheet: Variant;Row:Integer);
var
  strRange : string ;
begin
  strRange := Format('A1:I%d',[Row]);
  workSheet.range[strRange].borders.linestyle:=1;//���ñ߿���ʽ
end;



procedure TRsDBTemplateDayPlan.AddLeftContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo:RsDayPlanInfo;var Row:Integer);
begin

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].WrapText:= False;//�ı��Զ�����

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//�и�

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddLeftDaWen(excelApp, workBook,
  workSheet: Variant; DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//�и�

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddLeftFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
begin

end;

procedure TRsDBTemplateDayPlan.AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //����
  strRange := Format('A%d:D%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,1].Font.Name := '����';
  excelApp.Cells[Row,1].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,1].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, 1].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);


  if DayPlanItemGroup.IsDaWen = 0 then
  begin

    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '����';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '����';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '����';
  end;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := '��ע';

  inc(row);
end;

procedure TRsDBTemplateDayPlan.AddLoadPlanLog(BeginDate,EndDate, DtNow: TDateTime;
  DayPlanID, DayOrNight: integer);
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  strSql := 'Select * from Tab_DayPlan_Send where 1 = 2';
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      adoQuery.FieldByName('strGUID').AsString := NewGUID ;
      adoQuery.FieldByName('dtBeginTime').AsDateTime := BeginDate;
      adoQuery.FieldByName('dtEndTime').AsDateTime := EndDate;
      adoQuery.FieldByName('dtCreateTime').AsDateTime := DtNow;
      adoQuery.FieldByName('nDayPlanID').AsInteger := DayPlanID;
      adoQuery.FieldByName('nDayOrNight').AsInteger := DayOrNight;
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTemplateDayPlan.AddModifyPlanLog(PlanGUID: string;
  DayPlanLog: RsDayPlanLog);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'Select * from TAB_DayPlan_ChangeLog where 1 = 2';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataDayPlanLogToAdo(DayPlanLog,ADOQuery);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.AddDayPlanInfo(DayPlanInfo: RsDayPlanInfo): Boolean;
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  Result := False ;
  strSql := 'Select * from TAB_DayPlan_TrainRelation where 1 = 2';
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataPlanInfoToAdo(DayPlanInfo,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTemplateDayPlan.AddRightContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo:RsDayPlanInfo;var Row:Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].WrapText:= False;//�ı��Զ�����

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//�и�

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddRightDaWen(excelApp, workBook,
  workSheet: Variant; DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//�и�
  
  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddRightFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
begin

end;

procedure TRsDBTemplateDayPlan.AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //����
  strRange := Format('F%d:I%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,6].Font.Name := '����';
  excelApp.Cells[Row,6].font.size:=12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,6].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,6].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, 6].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);

  if DayPlanItemGroup.IsDaWen = 0 then
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '����';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '����';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '����';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //���õ�Ԫ��������С
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//��������Ϊ����
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//���ж���
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '����';
  end;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '����';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 12;  //���õ�Ԫ��������С
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.bold:=true;//��������Ϊ����
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//���ж���
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := '��ע';
  inc(row);
end;

procedure TRsDBTemplateDayPlan.AddTitle(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
begin
  
  workSheet.Rows[Row].Font.Name := '����';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size := 24 ;
  workSheet.range['A1:I1'].Merge(true);
  excelApp.Cells[Row, 1].Value :=  '������·�ƻ�';
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//���ж���
  workSheet.rows[Row].rowheight:= 28.5;//�и�

  inc(Row);
  workSheet.range['A2:I2'].Merge;
  workSheet.Rows[Row].Font.Name := '����';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size :=12 ;
  excelApp.Cells[Row, 1].Value := Title ;
  inc(Row);

  workSheet.Columns[INDEX_LEFT_TRAIN_REMARK].ColumnWidth := 16;    //���ø�ע�Ŀ��
  workSheet.Columns[INDEX_RIGHT_TRAIN_REMARK].ColumnWidth := 16;   //���ø�ע�Ŀ��
  workSheet.Columns[INDEX_SEPRATOR].ColumnWidth := 1 ;             //�м�ķָ��ߵĿ��
end;

procedure TRsDBTemplateDayPlan.AdoToDataDayPlan(DayPlan: TRsDayPlan;
  Ado: TADOQuery);
begin
  with DayPlan do
  begin
    ID := Ado.FieldByName('nID').AsInteger ;
    Name := Ado.FieldByName('strName').AsString ;
  end;
end;

procedure TRsDBTemplateDayPlan.AdoToDataDayPlanLog(var DayPlanLog: RsDayPlanLog;
  Ado: TADOQuery);
begin
  with DayPlanLog do
  begin
    strLogGUID := Ado.FieldByName('strLogGUID').AsString  ;
    strDayPlanGUID := Ado.FieldByName('strDayPlanGUID').AsString;

    strTrainNo1 := Ado.FieldByName('strTrainNo1').AsString;
    strTrainInfo := Ado.FieldByName('strTrainInfo').AsString;
    strTrainNo2 := Ado.FieldByName('strTrainNo2').AsString;
    strRemark := Ado.FieldByName('strRemark').AsString ;
    dtChangeTime := Ado.FieldByName('dtChangeTime').AsDateTime ;
  end;
end;

procedure TRsDBTemplateDayPlan.AdoToDataGroup(
  DayPlanItemGroup: TRsDayPlanItemGroup; Ado: TADOQuery);
begin
  with DayPlanItemGroup do
  begin
    ID := Ado.FieldByName('nID').AsInteger ;
    Name := Ado.FieldByName('strName').AsString ;
    DayPlanID := ado.FieldByName('nDayPlanID').AsInteger;
    ExcelSide :=  Ado.FieldByName('nExcelSide').AsInteger;
    ExcelPos := Ado.FieldByName('nExcelPos').AsInteger ;
    IsDaWen := Ado.FieldByName('bIsDaWen').AsInteger ;
  end;
end;

procedure TRsDBTemplateDayPlan.AdoToDataItem(DayPlanItem: TRsDayPlanItem;
  Ado: TADOQuery);
begin
  with DayPlanItem do
  begin
    ID := Ado.FieldByName('nID').AsInteger ;
    DayPlanType  := TDayPlanType ( Ado.FieldByName('nDayPlanType').AsInteger );
    TrainNo1 := Ado.FieldByName('strTrainNo1').AsString ;
    TrainInfo := Ado.FieldByName('strTrainInfo').AsString ;
    TrainNo2 := Ado.FieldByName('strTrainNo2').AsString ;
    TrainNo := Ado.FieldByName('strTrainNo').AsString ;
    Remark := Ado.FieldByName('strRemark').AsString ;
    IsTomorrow := Ado.FieldByName('bIsTomorrow').AsInteger ;
    //����
    DaWenCheXing := Ado.FieldByName('strDaWenCheXing').AsString;
    DaWenCheHao1 := Ado.FieldByName('strDaWenCheHao1').AsString ;
    DaWenCheHao2 := Ado.FieldByName('strDaWenCheHao2').AsString ;
    DaWenCheHao3 := Ado.FieldByName('strDaWenCheHao3').AsString ;

    GroupID := Ado.FieldByName('nGroupID').AsInteger ;
  end;
end;

procedure TRsDBTemplateDayPlan.AdoToDataPlanInfo(var DayPlanInfo: RsDayPlanInfo;
  Ado: TADOQuery);
begin
  with DayPlanInfo do
  begin
    strDayPlanGUID:= Ado.FieldByName('strDayPlanGUID').AsString;  //�ƻ�ID
    nPlanState :=  TRsPlanState(  Ado.FieldByName('nPlanState').AsInteger );   //�ƻ�״̬
    dtBeginTime:= Ado.FieldByName('dtBeginTime').AsDateTime;  //��ʼʱ��
    dtEndTime := Ado.FieldByName('dtEndTime').AsDateTime ;    //����ʱ��
    dtCreateTime:= Ado.FieldByName('dtCreateTime').AsDateTime ;   //�����¼�
    strTrainNo1:= Ado.FieldByName('strTrainNo1').AsString;     //����1
    strTrainInfo:= Ado.FieldByName('strTrainInfo').AsString;    //������Ϣ
    strTrainNo2:= Ado.FieldByName('strTrainNo2').AsString ;      //���� 2
    strTrainNo:= Ado.FieldByName('strTrainNo').AsString ;      //����
    strTrainTypeName:= Ado.FieldByName('strTrainTypeName').AsString ; //����
    strTrainNumber:= Ado.FieldByName('strTrainNumber').AsString ;  //����

    //����ר��
    strDaWenCheXing:= Ado.FieldByName('strDaWenCheXing').AsString ;  //���³���
    strDaWenCheHao1:= Ado.FieldByName('strDaWenCheHao1').AsString ;  //���³���1
    strDaWenCheHao2:= Ado.FieldByName('strDaWenCheHao2').AsString ; //���³��� 2
    strDaWenCheHao3:= Ado.FieldByName('strDaWenCheHao3').AsString ;  //���³��� 3


    nid:= Ado.FieldByName('nid').AsInteger ;            //
    strRemark:= Ado.FieldByName('strRemark').AsString ;       //��ע
    bIsTomorrow := Ado.FieldByName('bIsTomorrow').AsInteger  ; //�Ƿ���ճ���
    nDayPlanID := Ado.FieldByName('nDayPlanID').AsInteger ;
    nQuDuanID:= Ado.FieldByName('nQuDuanID').AsInteger ;      //������Ϣ
    nPlanID := Ado.FieldByName('nPlanID').AsInteger ;      //�����ļƻ���Ϣ

    bIsSend := Ado.FieldByName('bIsSend').AsInteger ;
    strTrainPlanGUID := Ado.FieldByName('strTrainPlanGUID').AsString ;
  end;
end;

procedure TRsDBTemplateDayPlan.DataDayPlanLogToAdo(DayPlanLog: RsDayPlanLog;
  Ado: TADOQuery);
begin
  with DayPlanLog do
  begin
    Ado.FieldByName('strLogGUID').AsString := strLogGUID ;
    Ado.FieldByName('strlogType').AsString := strlogType ;
    Ado.FieldByName('strDayPlanGUID').AsString := strDayPlanGUID ;

    Ado.FieldByName('strTrainNo1').AsString := strTrainNo1 ;
    Ado.FieldByName('strTrainInfo').AsString := strTrainInfo ;
    Ado.FieldByName('strTrainNo2').AsString := strTrainNo2 ;
    Ado.FieldByName('strRemark').AsString := strRemark ;
    Ado.FieldByName('dtChangeTime').AsDateTime := dtChangeTime ;
  end;
end;

procedure TRsDBTemplateDayPlan.DataDayPlanToAdo(DayPlan: TRsDayPlan;
  Ado: TADOQuery);
begin
  with DayPlan do
  begin
    Ado.FieldByName('nID').AsInteger := ID ;
    Ado.FieldByName('strName').AsString := Name ;
  end;
end;

procedure TRsDBTemplateDayPlan.DataGroupToAdo(
  DayPlanItemGroup: TRsDayPlanItemGroup; Ado: TADOQuery);
begin
  with DayPlanItemGroup do
  begin
    //Ado.FieldByName('nID').AsInteger := ID ;
    Ado.FieldByName('strName').AsString := Name ;
    Ado.FieldByName('nDayPlanID').AsInteger := DayPlanID  ;
    Ado.FieldByName('nExcelSide').AsInteger := ExcelSide ;
    Ado.FieldByName('nExcelPos').AsInteger := ExcelPos ;
    Ado.FieldByName('bIsDaWen').AsInteger := IsDaWen ;
  end;
end;

procedure TRsDBTemplateDayPlan.DataItemToAdo(DayPlanItem: TRsDayPlanItem;
  Ado: TADOQuery);
begin
  with DayPlanItem do
  begin
    //Ado.FieldByName('nID').AsInteger := ID ;
    Ado.FieldByName('nDayPlanType').AsInteger := Ord ( DayPlanType ) ;
    Ado.FieldByName('strTrainNo1').AsString := TrainNo1 ;
    Ado.FieldByName('strTrainInfo').AsString := TrainInfo ;
    Ado.FieldByName('strTrainNo2').AsString := TrainNo2 ;
    Ado.FieldByName('strTrainNo').AsString := TrainNo ;
    Ado.FieldByName('strRemark').AsString := Remark ;
    Ado.FieldByName('bIsTomorrow').AsInteger := IsTomorrow ;
    //����
    Ado.FieldByName('strDaWenCheXing').AsString := DaWenCheXing ;
    Ado.FieldByName('strDaWenCheHao1').AsString := DaWenCheHao1 ;
    Ado.FieldByName('strDaWenCheHao2').AsString := DaWenCheHao2 ;
    Ado.FieldByName('strDaWenCheHao3').AsString := DaWenCheHao3 ;

    Ado.FieldByName('nGroupID').AsInteger :=  GroupID ;
  end;
end;

procedure TRsDBTemplateDayPlan.DataPlanInfoToAdo(var DayPlanInfo: RsDayPlanInfo;
  Ado: TADOQuery);
begin
  with DayPlanInfo do
  begin
    Ado.FieldByName('strDayPlanGUID').AsString:= strDayPlanGUID;  //�ƻ�ID
    Ado.FieldByName('nPlanState').AsInteger := Ord(nPlanState) ;   //�ƻ�״̬
    Ado.FieldByName('dtBeginTime').AsDateTime:= dtBeginTime;  //��ʼʱ��
    Ado.FieldByName('dtEndTime').AsDateTime := dtEndTime;    //����ʱ��
    Ado.FieldByName('dtCreateTime').AsDateTime := dtCreateTime ;   //�����¼�
    Ado.FieldByName('strTrainNo1').AsString := strTrainNo1 ;     //����1
    Ado.FieldByName('strTrainInfo').AsString := strTrainInfo ;    //������Ϣ
    Ado.FieldByName('strTrainNo2').AsString := strTrainNo2  ;      //����2
    Ado.FieldByName('strTrainNo').AsString := strTrainNo  ;      //����
    Ado.FieldByName('strTrainTypeName').AsString :=  strTrainTypeName ; //����
    Ado.FieldByName('strTrainNumber').AsString :=strTrainNumber ;  //����
    Ado.FieldByName('strRemark').AsString := strRemark ;       //��ע

    //����ר��
    Ado.FieldByName('strDaWenCheXing').AsString := strDaWenCheXing ;  //���³���
    Ado.FieldByName('strDaWenCheHao1').AsString :=strDaWenCheHao1 ;  //���³���1
    Ado.FieldByName('strDaWenCheHao2').AsString := strDaWenCheHao2 ; //���³��� 2
    Ado.FieldByName('strDaWenCheHao3').AsString := strDaWenCheHao3 ;  //���³��� 3

    Ado.FieldByName('bIsTomorrow').AsInteger := bIsTomorrow ;       //�Ƿ���ճ���
    Ado.FieldByName('nDayPlanID').AsInteger := nDayPlanID ;
    Ado.FieldByName('nQuDuanID').AsInteger := nQuDuanID;      //������Ϣ
    Ado.FieldByName('nPlanID').AsInteger := nPlanID;      //������Ϣ

    Ado.FieldByName('bIsSend').AsInteger := bIsSend ;

    Ado.FieldByName('strTrainPlanGUID').AsString := strTrainPlanGUID ;  //���³��� 3
  end;
end;

function TRsDBTemplateDayPlan.DeleteDayPlan(DayPlan: TRsDayPlan): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from Tab_Base_DayPlan where nid = %d';
  strSql := Format(strSql,[DayPlan.ID]);
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.DeleteGroup(DayPlanID: Integer;
  GroupID:Integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from Tab_Base_DayPlan_Group where nid = %d and nDayPlanID = %d';
  strSql := Format(strSql,[GroupID,DayPlanID]);
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.DeleteItem(
  ItemID:Integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from Tab_Base_DayPlan_Item where nid = %d';
  strSql := Format(strSql,[ItemID]);
  adoQuery :=  NewADOQuery ;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.DeleteDayPlanInfoByGUID(GUID: string): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from TAB_DayPlan_TrainRelation where strDayPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(GUID)]);
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.DeleteTrainPlanByDayPlanID(BeginDate, EndDate: TDateTime;
  DayPlanID: Integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from TAB_DayPlan_TrainRelation where ' +
  ' nDayPlanID =:nDayPlanID   and dtBeginTime Between :BeginDate and :EndDate';

  adoQuery := NewADOQuery;
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.DeleteDayPlanInfoByGroupID(BeginDate, EndDate: TDateTime;
  QuDuan: Integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'delete from TAB_DayPlan_TrainRelation where ' + 
  ' nQuDuanID =:nQuDuanID  and dtBeginTime Between :BeginTime and :EndTime';

  adoQuery := NewADOQuery;
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Parameters.ParamByName('nQuDuanID').Value := QuDuan ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;

    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      if ExecSQL > 0 then;
        Result:= True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.GetModifyPlanLogs(PlanGUID: string;
  out DayPlanLogArray: RsDayPlanLogArray): Boolean;
begin
  ;
end;

function TRsDBTemplateDayPlan.GetPaiBanPlans(BeginDate, EndDate: TDateTime;
  DayPlanID: Integer; var PlanList: TStrings): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
  strTrainPlanGUID : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  try
    adoQuery.Sql.Text := 'select strTrainPlanGUID from TAB_DayPlan_TrainRelation where ' +
    ' nDayPlanID =:nDayPlanID  and bIsSend = 0 and ( strTrainPlanGUID <> '''' and strTrainPlanGUID is not null ) ' +
    ' and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate ) ';
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.Open;
    while not adoQuery.Eof do
    begin
      strTrainPlanGUID := adoQuery.FieldByName('strTrainPlanGUID').AsString;
      PlanList.Add(strTrainPlanGUID);
      adoQuery.Next ;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.GetPlanTitle(BeginDate, EndDate: TDateTime;
  DayOrNight: integer): string;
var
  strTtitle : string ;
  strDateBegin : string ;
  strDateEnd : string ;
  strPlan : string;
begin
  strDateBegin := FormatDateTime('yyyy-MM-dd',BeginDate) ;
  strDateEnd :=  FormatDateTime('yyyy-MM-dd',IncDay(BeginDate,1)) ;
  case DayOrNight  of
  ord(dptDay) :
    begin
      strPlan := ' �װ�';
      strTtitle := 'ʱ�䣺' + strDateBegin + strPlan ;
    end;
  ord(dptNight) :
    begin
      strPlan := ' ҹ��';
      strTtitle := 'ʱ�䣺' + strDateBegin + strPlan ;
    end;
  ord(dtpAll) :
    begin
      strTtitle := Format('%s 18��00��%s 18��00',[strDateBegin,strDateEnd]) ;
    end;
  else
    begin
      ;
    end;
  end;
  Result := strTtitle ;
end;

function TRsDBTemplateDayPlan.GetTotalPlanCount(BeginDate, EndDate: TDateTime;
  DayPlanID:Integer): Integer;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := 0 ;
  adoQuery := NewADOQuery;
  try

    adoQuery.Sql.Text := 'select count(*) as nCount from TAB_DayPlan_TrainRelation  where ' +
    ' nDayPlanID =:nDayPlanID  and dtBeginTime Between :BeginDate and :EndDate';
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.Open;
    if adoQuery.RecordCount <0 then
      Exit;
    Result := adoQuery.FieldByName('nCount').AsInteger;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.GetTrainTypeName(ShortName: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := 'δ�ҵ�';
  strSql := 'Select top 1 * from Tab_Base_DayPlan_ShortTrain where strShortName = %s';
  strSql := Format(strSql,[QuotedStr(ShortName)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
        exit
      else
      begin
        Result := adoQuery.FieldByName('strLongName').AsString  ;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.GetTrainTypes(
  var ShortTrainArray: TRsShortTrainArray): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
  i : Integer ;
begin
  i := 0 ;
  strSql := 'Select * from Tab_Base_DayPlan_ShortTrain order by nid';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
        Exit;
      SetLength(ShortTrainArray,adoQuery.RecordCount);
      while not adoQuery.Eof do
      begin
        ShortTrainArray[i].strShortName := adoQuery.FieldByName('strShortName').AsString  ;
        ShortTrainArray[i].strLongName := adoQuery.FieldByName('strLongName').AsString  ;
        adoQuery.Next;
        inc(i);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.InsertDayPlan(DayPlan: TRsDayPlan): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'Select * from Tab_Base_DayPlan_Item where 1 = 2';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataDayPlanToAdo(DayPlan,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.InsertGroup(
  DayPlanItemGroup: TRsDayPlanItemGroup): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'Select * from Tab_Base_DayPlan_Group where 1 = 2 ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataGroupToAdo(DayPlanItemGroup,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryDayPlan(ID: Integer;
  DayPlan: TRsDayPlan): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  strSql := 'Select * from Tab_Base_DayPlan where nid = %d';
  strSql := Format(strSql,[ID]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
        exit;
      if Assigned(DayPlan) then
      begin
        DayPlan.ID := adoQuery.FieldByName('nID').AsInteger  ;
        DayPlan.Name := adoQuery.FieldByName('strName').AsString  ;
      end;
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryDayPlanList(
  DayPlanList: TRsDayPlanList): Boolean;
var
  adoQuery : TADOQuery;
  DayPlan:TRsDayPlan ;
  strSql : string;
begin
  result := false;
  strSql := 'Select * from Tab_Base_DayPlan order by nid';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      while not adoQuery.eof do
      begin
        DayPlan := TRsDayPlan.Create;
        AdoToDataDayPlan(DayPlan,adoQuery);
        DayPlanList.Add(DayPlan);
        adoQuery.Next ;
      end;
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryGroupInfo(DayPlanID: Integer;GroupID:Integer;
  DayPlanItemGroup: TRsDayPlanItemGroup): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select top 1 * from Tab_Base_DayPlan_Group where  nDayPlanID = %d and  nID = %d ',[DayPlanID,GroupID]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    if adoQuery.RecordCount < 0 then
      Exit;
    AdoToDataGroup(DayPlanItemGroup,adoQuery);
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryGroupListByID(ID: Integer;
  DayPlanItemGroupList: TRsDayPlanItemGroupList): Boolean;
var
  DayPlanItemGroup : TRsDayPlanItemGroup;
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := NewADOQuery;
  strSql := Format('select * from Tab_Base_DayPlan_Group where nDayPlanID = %d order by  nExcelSide,nExcelPos,nid',[ID]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    while not adoQuery.eof do
    begin
      DayPlanItemGroup := TRsDayPlanItemGroup.Create;
      AdoToDataGroup(DayPlanItemGroup,adoQuery);
      DayPlanItemGroupList.Add(DayPlanItemGroup);
      adoQuery.Next ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryItem(ItemID: Integer;
  DayPlanItem: TRsDayPlanItem): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select top 1 * from Tab_Base_DayPlan_Item where  nID = %d  ',[ItemID]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    if adoQuery.RecordCount < 0 then
      Exit;
    AdoToDataItem(DayPlanItem,adoQuery);
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryItemList(GroupD: Integer;DayPlanType:Integer;
  DayPlanItemList: TRsDayPlanItemList): Boolean;
var
  DayPlanItem : TRsDayPlanItem;
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select * from Tab_Base_DayPlan_Item where nGroupID = %d and  nDayPlanType = %d order by nid',[GroupD,DayPlanType]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    while not adoQuery.eof do
    begin
      DayPlanItem := TRsDayPlanItem.Create;
      AdoToDataItem(DayPlanItem,adoQuery);
      DayPlanItemList.Add(DayPlanItem);
      adoQuery.Next ;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryLeftGroupListByID(ID: Integer;
  DayPlanItemGroupList: TRsDayPlanItemGroupList): Boolean;
var
  DayPlanItemGroup : TRsDayPlanItemGroup;
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select * from Tab_Base_DayPlan_Group where nDayPlanID = %d and nExcelSide = 1 order by  nExcelPos,nid',[ID]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    while not adoQuery.eof do
    begin
      DayPlanItemGroup := TRsDayPlanItemGroup.Create;
      AdoToDataGroup(DayPlanItemGroup,adoQuery);
      DayPlanItemGroupList.Add(DayPlanItemGroup);
      adoQuery.Next ;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;



function TRsDBTemplateDayPlan.QueryDayPlanInfoByID(GUID: string;
  var DayPlanInfo: RsDayPlanInfo): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select top 1 * from TAB_DayPlan_TrainRelation where  strDayPlanGUID = %s  ',[QuotedStr(GUID)]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    if adoQuery.RecordCount < 0 then
      Exit;
    AdoToDataPlanInfo(DayPlanInfo,adoQuery);
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryDayPlanInfoListByGroupID(BeginDate,EndDate:TDateTime;
  GroupID: Integer; var DayPlanInfoList: RsDayPlanInfoArray): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
  i : Integer ;
begin
  i := 0 ;
  Result := False ;
  adoQuery := NewADOQuery;
  try

    adoQuery.Sql.Text := 'select * from TAB_DayPlan_TrainRelation  where ' +
    ' nQuDuanID =:nQuDuanID  and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate )';
    adoQuery.Parameters.ParamByName('nQuDuanID').Value := GroupID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.Open;
    if adoQuery.RecordCount <= 0 then
      Exit ;
    SetLength(DayPlanInfoList,adoQuery.RecordCount);
    while not adoQuery.Eof do
    begin
      AdoToDataPlanInfo(DayPlanInfoList[i],adoQuery);
      adoQuery.Next ;
      inc(i);
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryPublishDayPlanInfoListByGroupID(BeginDate,
  EndDate: TDateTime; GroupID: Integer;
  var DayPlanInfoList: RsDayPlanInfoArray): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
  i : Integer ;
begin
  i := 0 ;
  Result := False ;
  adoQuery := NewADOQuery;
  try

    adoQuery.Sql.Text := 'select * from TAB_DayPlan_TrainRelation  where nPlanState = 2 and ' +
    ' nQuDuanID =:nQuDuanID  and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate )';
    adoQuery.Parameters.ParamByName('nQuDuanID').Value := GroupID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.Open;
    if adoQuery.RecordCount <= 0 then
      Exit ;
    SetLength(DayPlanInfoList,adoQuery.RecordCount);
    while not adoQuery.Eof do
    begin
      AdoToDataPlanInfo(DayPlanInfoList[i],adoQuery);
      adoQuery.Next ;
      inc(i);
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.QueryRightGroupListByID(ID: Integer;
  DayPlanItemGroupList: TRsDayPlanItemGroupList): Boolean;
var
  DayPlanItemGroup : TRsDayPlanItemGroup;
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  strSql := Format('select * from Tab_Base_DayPlan_Group where nDayPlanID = %d and nExcelSide = 2 order by  nExcelPos,nid',[ID]);
  try
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open;
    while not adoQuery.eof do
    begin
      DayPlanItemGroup := TRsDayPlanItemGroup.Create;
      AdoToDataGroup(DayPlanItemGroup,adoQuery);
      DayPlanItemGroupList.Add(DayPlanItemGroup);
      adoQuery.Next ;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;



function TRsDBTemplateDayPlan.SaveToExcel(BeginDate, EndDate: TDateTime;
  DayPlanID,DayOrNight : Integer; ExcelFile: string): boolean;

var
  DayPlanItemGroupList:TRsDayPlanItemGroupList ;
  DayPlanInfoList: RsDayPlanInfoArray ;
  excelApp, workBook, workSheet: Variant;
  i,j, n, nRow,nTempRow,nLeftMax,nRightMax,nMaxRow,nCurrentPos,nTotalCount: integer;
  strErrorInfo,strTitle: string;
begin
  nCurrentPos := 0 ;
  result := false;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    strErrorInfo := '�㻹û�а�װMicrosoft Excel�����Ȱ�װ��';
    BoxErr(strErrorInfo);
    exit;
  end;

  try
    DayPlanItemGroupList  := TRsDayPlanItemGroupList.Create;
    //excelApp.DisplayAlerts:=false ;
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    if FileExists(ExcelFile) then
    begin
      excelApp.workBooks.Open(ExcelFile);
      workBook := excelApp.Worksheets[1].activate;
      workSheet :=  excelApp.ActiveSheet ;
    end
    else
    begin
      excelApp.WorkBooks.Add;
      workBook := excelApp.Workbooks.Add;
      workSheet := workBook.Sheets.Add;
    end;

    nRow := 1;


    strTitle := GetPlanTitle(BeginDate, EndDate,DayOrNight ) ;
    AddTitle(excelApp,workBook,workSheet,strTitle,nRow );

    //��ȡ������
    nTotalCount := GetTotalPlanCount(BeginDate, EndDate,DayPlanID);

    nTempRow := nRow ;
    //��ȡ����������б�

    DayPlanItemGroupList.Clear;
    QueryLeftGroupListByID(DayPlanID,DayPlanItemGroupList) ;
    for j := 0 to DayPlanItemGroupList.Count - 1 do
    begin
      AddLeftHead(excelApp, workBook, workSheet,DayPlanItemGroupList.Items[j],nRow);
      //��ѯ�ƻ�
      SetLength(DayPlanInfoList,0); ;
      QueryDayPlanInfoListByGroupID(BeginDate,EndDate,DayPlanItemGroupList.Items[j].ID,DayPlanInfoList) ;

      //�ж��Ƿ��Ǵ��³���
      if DayPlanItemGroupList.Items[j].IsDaWen = 0 then
      begin
        for I := 0 to Length(DayPlanInfoList) - 1 do
        begin
          AddLeftContext(excelApp, workBook, workSheet,DayPlanInfoList[i],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress( nCurrentPos , nTotalCount - 1);
            inc(nCurrentPos);
          end;
        end;
      end
      else
      begin
        for I := 0 to Length(DayPlanInfoList) - 1 do
        begin
          AddLeftDaWen(excelApp, workBook, workSheet,DayPlanInfoList[i],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1);
            inc(nCurrentPos);
          end;
        end;
      end;
    end;

    nLeftMax :=  nRow ;
    nRow := nTempRow ;

    //��ȡ����������б�

    DayPlanItemGroupList.Clear;
    QueryRightGroupListByID(DayPlanID,DayPlanItemGroupList) ;
    for j := 0 to DayPlanItemGroupList.Count - 1 do
    begin
      AddRightHead(excelApp, workBook, workSheet,DayPlanItemGroupList.Items[j],nRow);
      //��ѯ�ƻ�
      SetLength(DayPlanInfoList,0); ;
      QueryDayPlanInfoListByGroupID(BeginDate,EndDate,DayPlanItemGroupList.Items[j].ID,DayPlanInfoList) ;

      //�ж��Ƿ��Ǵ��³���
      if DayPlanItemGroupList.Items[j].IsDaWen = 0 then
      begin
        for I := 0 to Length(DayPlanInfoList) - 1 do
        begin
          AddRightContext(excelApp, workBook, workSheet,DayPlanInfoList[i],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1 );
            inc(nCurrentPos);
          end;
        end;
      end
      else
      begin
        for I := 0 to Length(DayPlanInfoList) - 1 do
        begin
          AddRightDaWen(excelApp, workBook, workSheet,DayPlanInfoList[i],nRow);
          if Assigned(m_OnExportPlanProgress) then
          begin
            m_OnExportPlanProgress(nCurrentPos, nTotalCount - 1 );
            inc(nCurrentPos);
          end;
        end;
      end;
    end;


    nRightMax := nRow ;
    nMaxRow := nRightMax ;
    if nLeftMax > nMaxRow then
      nMaxRow := nLeftMax ;

    //��ӱ߿� (��Ϊ����������һ��������ȥ������Ҫ��ȥһ��)
    AddBorder(excelApp, workBook, workSheet,nMaxRow - 1 )  ;

    if not FileExists(ExcelFile) then
      workSheet.SaveAs(excelFile);
    result := true;
  finally

    DayPlanItemGroupList.Free;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

function TRsDBTemplateDayPlan.SendDayPlan(BeginDate, EndDate: TDateTime; DayPlanID:Integer): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := NewADOQuery;
  try
    adoQuery.Sql.Text := 'update TAB_DayPlan_TrainRelation set nPlanState = 2  where ' +
    ' nDayPlanID =:nDayPlanID  and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate )';
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    if adoQuery.ExecSQL > 0 then
      Result := True ;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTemplateDayPlan.SetPlansSendState(BeginDate, EndDate: TDateTime;
  DayPlanID: Integer; var PlanList: TStrings);
var
  adoQuery : TADOQuery;
  strSql : string;
  strTrainNo : string;
begin
  adoQuery := NewADOQuery;
  try
    adoQuery.Sql.Text := 'update TAB_DayPlan_TrainRelation set bIsSend = 1 where ' +
    ' nDayPlanID =:nDayPlanID  and bIsSend = 0' +
    ' and ( dtBeginTime >= :BeginDate and dtEndTime <= :EndDate ) ';
    adoQuery.Parameters.ParamByName('nDayPlanID').Value := DayPlanID ;
    adoQuery.Parameters.ParamByName('BeginDate').Value := BeginDate;
    adoQuery.Parameters.ParamByName('EndDate').Value := EndDate ;
    adoQuery.ExecSQL;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.UpdateDayPlan(DayPlan: TRsDayPlan): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result:= False ;
  strSql := 'Select * from Tab_Base_DayPlan where nid = %d';
  strSql := Format(strSql,[DayPlan.id]);
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      DataDayPlanToAdo(DayPlan,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.UpdateGroup(
  DayPlanItemGroup: TRsDayPlanItemGroup): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result:= False ;
  strSql := 'Select * from Tab_Base_DayPlan_Group where nID = %d';
  strSql := Format(strSql,[DayPlanItemGroup.ID]);
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      DataGroupToAdo(DayPlanItemGroup,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.UpdateItem(
  DayPlanItem: TRsDayPlanItem): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result:= False ;
  strSql := 'Select * from Tab_Base_DayPlan_Item where nID = %d';
  strSql := Format(strSql,[DayPlanItem.ID]);
  adoQuery := NewADOQuery;
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      DataItemToAdo(DayPlanItem,ADOQuery);
      Post;
    end;
    Result := True ;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTemplateDayPlan.UpdatePaiPlan(PlanGUID,
  TrainTypeName,TrainNumber,Remark:string;SiteGUID:String;DutyUserGUID:string): Boolean;
var
  strTrainPlanGUID : string;
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  strSql := 'Select strTrainPlanGUID from TAB_DayPlan_TrainRelation where strDayPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(PlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      try
          Sql.Text := strSql;
          Open;
          strTrainPlanGUID := adoQuery.FieldByName('strTrainPlanGUID').AsString;
          Close;
          if strTrainPlanGUID = '' then
            Exit;


          strSql := 'update  TAB_Plan_Train set strTrainTypeName =%s, ' +
          ' strTrainNumber = %s , strRemark = %s '    +
          ' where strTrainPlanGUID = %s';
          strSql := Format(strSql,[
            QuotedStr(TrainTypeName),
            QuotedStr(TrainNumber),
            QuotedStr(Remark),
            QuotedStr(strTrainPlanGUID)]);
          SQL.Text := strSql;
          ExecSQL;

          strSql := 'PROC_Plan_WriteChangeLog %s,%s,%s';;
          SQL.Text := Format(strSql,[QuotedStr(strTrainPlanGUID),
            QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          ExecSQL;

      except
        on E: Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
