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

  xlHAlignCenter = -4108;   //excel居中对齐

  EXCEL_ROW_HEIGHT  = 16 ;

type

  //导出进度事件
  TOnExportPlanProgress = procedure(nCompleted, nTotal: integer) of object;
  //
  //机车计划数据库操作类
  //
  TRsDBTemplateDayPlan = class(TDBOperate)
  public
    //添加一个机车计划
    function InsertDayPlan(DayPlan:TRsDayPlan):Boolean;
    //修改一个机车计划
    function UpdateDayPlan(DayPlan:TRsDayPlan):Boolean;
    //删除几个机车计划
    function DeleteDayPlan(DayPlan:TRsDayPlan):Boolean;
    //查询机车计划
    function QueryDayPlan(ID:Integer;DayPlan:TRsDayPlan):Boolean;
    //获取uoyou的行车计划
    function QueryDayPlanList(DayPlanList:TRsDayPlanList):Boolean ;
  public
    //在指定的机车计划上添加一个组信息
    function InsertGroup(DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //在指定的机车计划上修改一个组信息
    function UpdateGroup(DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //在指定的机车计划上删除一个组信息
    function DeleteGroup(DayPlanID: Integer;GroupID:Integer):Boolean;
    //获取下属所有区段
    function QueryGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //获取EXCEL左边的
    function QueryLeftGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //获取EXCEL右边的
    function QueryRightGroupListByID(ID:Integer;DayPlanItemGroupList:TRsDayPlanItemGroupList):Boolean ;
    //获取指定机车计划的一组信息
    function QueryGroupInfo(DayPlanID: Integer;GroupID:Integer;DayPlanItemGroup:TRsDayPlanItemGroup):Boolean;
    //是否存在
    //function IsExistGroup(Name:string):Boolean;
  public
    //在指定的机车计划上添加一个组信息
    function InsertItem(DayPlanItem:TRsDayPlanItem):Boolean;
    //在指定的机车计划上修改一个组信息
    function UpdateItem(DayPlanItem:TRsDayPlanItem):Boolean;
    //在指定的机车计划上删除一个组信息
    function DeleteItem(ItemID:Integer):Boolean;
    //在指定的机车计划上查找一个组信息
    function QueryItem(ItemID:Integer;DayPlanItem:TRsDayPlanItem):Boolean ;
    //在指定的机车计划上查找一个组信息
    function QueryItemList(GroupD:Integer;DayPlanType:Integer;DayPlanItemList:TRsDayPlanItemList):Boolean;
  public
    //是否已经加载过计划
    function IsLoadedDayPlanInfo(BeginDate,EndDate: TDateTime; DayPlanID: Integer;DayOrNight: integer):Boolean;
    //增加一条日志
    procedure AddModifyPlanLog(PlanGUID:string;DayPlanLog:RsDayPlanLog);
    //获取一个计划的所有日志
    function GetModifyPlanLogs(PlanGUID:string;out DayPlanLogArray:RsDayPlanLogArray):Boolean;
    //发布计划
    function SendDayPlan(BeginDate,EndDate: TDateTime; DayPlanID: Integer):Boolean;
    //发布计划
    function GetPaiBanPlans(BeginDate,EndDate: TDateTime; DayPlanID: Integer;var PlanList:TStrings):Boolean;
    //设置已发布计划为发布状体
    procedure SetPlansSendState(BeginDate,EndDate: TDateTime; DayPlanID: Integer;var PlanList:TStrings);
    //修改云安计划的车型和车号
    function UpdatePaiPlan(PlanGUID:string;TrainTypeName,TrainNumber,Remark:string;SiteGUID:String;DutyUserGUID:string):Boolean;
    //加载计划
    procedure LoadDayPlanInfo(DayPlanDate,DtNow: TDateTime; DayOrNight: integer;
      DayPlanID,QuDuan:Integer;DayPlanItemList:TRsDayPlanItemList);
    //增加加载计划LOG
    procedure AddLoadPlanLog(BeginDate,EndDate,DtNow: TDateTime; DayPlanID: Integer;DayOrNight: integer);
    //新建计划
    function AddDayPlanInfo(DayPlanInfo:RsDayPlanInfo):Boolean;
    //修改计划
    function ModifyDayPlanInfo(DayPlanInfo:RsDayPlanInfo):Boolean;
    //删除计划
    function DeleteDayPlanInfoByGUID(GUID:string):Boolean;
    //删除一整组计划
    function DeleteDayPlanInfoByGroupID(BeginDate,EndDate: TDateTime;
      QuDuan:Integer):Boolean;
    //查询计划
    function QueryDayPlanInfoByID(GUID:string; var DayPlanInfo:RsDayPlanInfo):Boolean;
    //查询计划
    function QueryDayPlanInfoListByGroupID(BeginDate,EndDate: TDateTime;
      GroupID:Integer;var DayPlanInfoList:RsDayPlanInfoArray):Boolean ;
    //查询下发计划
    function QueryPublishDayPlanInfoListByGroupID(BeginDate,EndDate: TDateTime;
      GroupID:Integer;var DayPlanInfoList:RsDayPlanInfoArray):Boolean ;
    //删除机车计划
    function DeleteTrainPlanByDayPlanID(BeginDate,EndDate: TDateTime;DayPlanID:Integer):Boolean;
  public
    //根据
    function GetTrainTypeName(ShortName:string):string;
    //得到所有的数据
    function GetTrainTypes(var ShortTrainArray:TRsShortTrainArray):Boolean;

    {下面的这个部分应该提炼出主要是导出部分}
  public
    //保存到EXCEL
    function SaveToExcel(BeginDate,EndDate: TDateTime;DayPlanID:Integer;DayOrNight: integer; ExcelFile: string): boolean;
  private
    //查询一共有多少条
    function GetTotalPlanCount(BeginDate,EndDate: TDateTime;DayPlanID:Integer):Integer;
    //获取日期名字
    function GetPlanTitle(BeginDate,EndDate: TDateTime;DayOrNight: integer):string;
    //添加标题
    procedure AddTitle(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
    //////////////////左侧
    //添加头
    procedure AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //添加正文
    procedure AddLeftContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加打温
    procedure AddLeftDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加结束符
    procedure AddLeftFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);

    /////////////////右侧
    //添加头
    procedure AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup;var Row:Integer);
    //添加正文
    procedure AddRightContext(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加打温
    procedure AddRightDaWen(excelApp, workBook, workSheet: Variant;DayPlanInfo:RsDayPlanInfo;var Row:Integer);
    //添加结束符
    procedure AddRightFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);

    //添加边框
    procedure AddBorder(excelApp, workBook, workSheet: Variant;Row:Integer);
  private
    //公共部分
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
      m_OnExportPlanProgress: TOnExportPlanProgress;          //导出进度事件
  published
    //导出进度事件
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
      strDayPlanGUID:= NewGUID ;  //计划ID
      nPlanState := psEdit ;

      if DayOrNight = 0 then  //白班
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),8);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
      end
      else if DayOrNight = 1  then  //夜班
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),18);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
      end
      else                            //全天
      begin
        dtBeginTime := IncHour(DateOf(DayPlanDate),18);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
      end;

      dtBeginTime:= dtBeginTime ;   //开始时间
      dtEndTime:= dtEndTime ;    //结束时间
      dtCreateTime:= DtNow ;  //产生事件
      strTrainNo1:= DayPlanItemList.Items[i].TrainNo1 ;     //车次1
      strTrainInfo:= DayPlanItemList.Items[i].TrainInfo;    //机车信息
      strTrainNo2:= DayPlanItemList.Items[i].TrainNo2;      //车次 2
      strTrainNo := DayPlanItemList.Items[i].TrainNo;      //车次
      strTrainTypeName:= '' ; //车型
      strTrainNumber:= '' ;  //车号
      strRemark:= DayPlanItemList.Items[i].Remark;
      IF DayPlanItemList.Items[i].IsTomorrow > 0then
       strRemark := Format('%d日',[DayOf(DayPlanDate)+1]);
      bIsTomorrow := DayPlanItemList.Items[i].IsTomorrow ;

      nDayPlanID := DayPlanID ;
      nQuDuanID:= DayPlanItemList.Items[i].GroupID ;      //区段信息

      //打温专用
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
  workSheet.range[strRange].borders.linestyle:=1;//设置边框样式
end;



procedure TRsDBTemplateDayPlan.AddLeftContext(excelApp, workBook, workSheet: Variant;
  DayPlanInfo:RsDayPlanInfo;var Row:Integer);
begin

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].WrapText:= False;//文本自动换行

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//行高

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddLeftDaWen(excelApp, workBook,
  workSheet: Variant; DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing  ;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight:= EXCEL_ROW_HEIGHT ;//行高

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddLeftFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
begin

end;

procedure TRsDBTemplateDayPlan.AddLeftHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //标题
  strRange := Format('A%d:D%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,1].Font.Name := '宋体';
  excelApp.Cells[Row,1].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,1].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, 1].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);


  if DayPlanItemGroup.IsDaWen = 0 then
  begin

    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '车次';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '机车';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '车次';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO1].Value := '车型';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_INFO].Value := '机车';


    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.size:=12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_LEFT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_LEFT_TRAIN_NO2].Value := '机车';
  end;


  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,INDEX_LEFT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_LEFT_TRAIN_REMARK].Value := '附注';

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
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strTrainNo1   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strTrainInfo ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strTrainNo2   ;


  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strRemark  ;
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].WrapText:= False;//文本自动换行

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//行高

  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddRightDaWen(excelApp, workBook,
  workSheet: Variant; DayPlanInfo: RsDayPlanInfo; var Row: Integer);
begin
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := DayPlanInfo.strDaWenCheXing   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := DayPlanInfo.strDaWenCheHao1 ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := DayPlanInfo.strDaWenCheHao2   ;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 10;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := DayPlanInfo.strDaWenCheHao3  ;

  workSheet.rows[Row].rowheight := EXCEL_ROW_HEIGHT;//行高
  
  inc(Row)
end;

procedure TRsDBTemplateDayPlan.AddRightFooter(excelApp, workBook, workSheet: Variant;Title:string;var Row:Integer);
begin

end;

procedure TRsDBTemplateDayPlan.AddRightHead(excelApp, workBook, workSheet: Variant;DayPlanItemGroup:TRsDayPlanItemGroup; var Row: Integer);
var
  strRange:string;
begin
  //标题
  strRange := Format('F%d:I%d',[Row,Row]);
  workSheet.range[strRange].Merge(true);
  excelApp.Cells[Row,6].Font.Name := '宋体';
  excelApp.Cells[Row,6].font.size:=12;  //设置单元格的字体大小
  excelApp.Cells[Row,6].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,6].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, 6].Value := DayPlanItemGroup.Name ;
  //
  Inc(row);

  if DayPlanItemGroup.IsDaWen = 0 then
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '车次';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '机车';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '车次';
  end
  else
  begin
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO1].Value := '车型';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_INFO].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_INFO].Value := '机车';

    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].Font.Name := '宋体';
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.size:= 12;  //设置单元格的字体大小
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].font.bold:=true;//设置字体为黑体
    excelApp.Cells[Row,INDEX_RIGHT_TRAIN_NO2].HorizontalAlignment:= xlHAlignCenter;//居中对齐
    excelApp.Cells[Row, INDEX_RIGHT_TRAIN_NO2].Value := '机车';
  end;

  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].Font.Name := '宋体';
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.size:= 12;  //设置单元格的字体大小
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].font.bold:=true;//设置字体为黑体
  excelApp.Cells[Row,INDEX_RIGHT_TRAIN_REMARK].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  excelApp.Cells[Row, INDEX_RIGHT_TRAIN_REMARK].Value := '附注';
  inc(row);
end;

procedure TRsDBTemplateDayPlan.AddTitle(excelApp, workBook, workSheet: Variant;
  Title: string; var Row: Integer);
begin
  
  workSheet.Rows[Row].Font.Name := '宋体';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size := 24 ;
  workSheet.range['A1:I1'].Merge(true);
  excelApp.Cells[Row, 1].Value :=  '机车交路计划';
  excelApp.Cells[Row,1].HorizontalAlignment:= xlHAlignCenter;//居中对齐
  workSheet.rows[Row].rowheight:= 28.5;//行高

  inc(Row);
  workSheet.range['A2:I2'].Merge;
  workSheet.Rows[Row].Font.Name := '宋体';
  workSheet.Rows[Row].Font.Bold := True;
  workSheet.Rows[Row].Font.Size :=12 ;
  excelApp.Cells[Row, 1].Value := Title ;
  inc(Row);

  workSheet.Columns[INDEX_LEFT_TRAIN_REMARK].ColumnWidth := 16;    //设置附注的宽度
  workSheet.Columns[INDEX_RIGHT_TRAIN_REMARK].ColumnWidth := 16;   //设置附注的宽度
  workSheet.Columns[INDEX_SEPRATOR].ColumnWidth := 1 ;             //中间的分割线的宽度
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
    //打温
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
    strDayPlanGUID:= Ado.FieldByName('strDayPlanGUID').AsString;  //计划ID
    nPlanState :=  TRsPlanState(  Ado.FieldByName('nPlanState').AsInteger );   //计划状态
    dtBeginTime:= Ado.FieldByName('dtBeginTime').AsDateTime;  //开始时间
    dtEndTime := Ado.FieldByName('dtEndTime').AsDateTime ;    //结束时间
    dtCreateTime:= Ado.FieldByName('dtCreateTime').AsDateTime ;   //产生事件
    strTrainNo1:= Ado.FieldByName('strTrainNo1').AsString;     //车次1
    strTrainInfo:= Ado.FieldByName('strTrainInfo').AsString;    //机车信息
    strTrainNo2:= Ado.FieldByName('strTrainNo2').AsString ;      //车次 2
    strTrainNo:= Ado.FieldByName('strTrainNo').AsString ;      //车次
    strTrainTypeName:= Ado.FieldByName('strTrainTypeName').AsString ; //车型
    strTrainNumber:= Ado.FieldByName('strTrainNumber').AsString ;  //车号

    //打温专用
    strDaWenCheXing:= Ado.FieldByName('strDaWenCheXing').AsString ;  //打温车型
    strDaWenCheHao1:= Ado.FieldByName('strDaWenCheHao1').AsString ;  //打温车号1
    strDaWenCheHao2:= Ado.FieldByName('strDaWenCheHao2').AsString ; //打温车号 2
    strDaWenCheHao3:= Ado.FieldByName('strDaWenCheHao3').AsString ;  //打温车号 3


    nid:= Ado.FieldByName('nid').AsInteger ;            //
    strRemark:= Ado.FieldByName('strRemark').AsString ;       //备注
    bIsTomorrow := Ado.FieldByName('bIsTomorrow').AsInteger  ; //是否次日车次
    nDayPlanID := Ado.FieldByName('nDayPlanID').AsInteger ;
    nQuDuanID:= Ado.FieldByName('nQuDuanID').AsInteger ;      //区段信息
    nPlanID := Ado.FieldByName('nPlanID').AsInteger ;      //关联的计划信息

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
    //打温
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
    Ado.FieldByName('strDayPlanGUID').AsString:= strDayPlanGUID;  //计划ID
    Ado.FieldByName('nPlanState').AsInteger := Ord(nPlanState) ;   //计划状态
    Ado.FieldByName('dtBeginTime').AsDateTime:= dtBeginTime;  //开始时间
    Ado.FieldByName('dtEndTime').AsDateTime := dtEndTime;    //结束时间
    Ado.FieldByName('dtCreateTime').AsDateTime := dtCreateTime ;   //产生事件
    Ado.FieldByName('strTrainNo1').AsString := strTrainNo1 ;     //车次1
    Ado.FieldByName('strTrainInfo').AsString := strTrainInfo ;    //机车信息
    Ado.FieldByName('strTrainNo2').AsString := strTrainNo2  ;      //车次2
    Ado.FieldByName('strTrainNo').AsString := strTrainNo  ;      //车次
    Ado.FieldByName('strTrainTypeName').AsString :=  strTrainTypeName ; //车型
    Ado.FieldByName('strTrainNumber').AsString :=strTrainNumber ;  //车号
    Ado.FieldByName('strRemark').AsString := strRemark ;       //备注

    //打温专用
    Ado.FieldByName('strDaWenCheXing').AsString := strDaWenCheXing ;  //打温车型
    Ado.FieldByName('strDaWenCheHao1').AsString :=strDaWenCheHao1 ;  //打温车号1
    Ado.FieldByName('strDaWenCheHao2').AsString := strDaWenCheHao2 ; //打温车号 2
    Ado.FieldByName('strDaWenCheHao3').AsString := strDaWenCheHao3 ;  //打温车号 3

    Ado.FieldByName('bIsTomorrow').AsInteger := bIsTomorrow ;       //是否次日车次
    Ado.FieldByName('nDayPlanID').AsInteger := nDayPlanID ;
    Ado.FieldByName('nQuDuanID').AsInteger := nQuDuanID;      //区段信息
    Ado.FieldByName('nPlanID').AsInteger := nPlanID;      //区段信息

    Ado.FieldByName('bIsSend').AsInteger := bIsSend ;

    Ado.FieldByName('strTrainPlanGUID').AsString := strTrainPlanGUID ;  //打温车号 3
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
      strPlan := ' 白班';
      strTtitle := '时间：' + strDateBegin + strPlan ;
    end;
  ord(dptNight) :
    begin
      strPlan := ' 夜班';
      strTtitle := '时间：' + strDateBegin + strPlan ;
    end;
  ord(dtpAll) :
    begin
      strTtitle := Format('%s 18：00—%s 18：00',[strDateBegin,strDateEnd]) ;
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
  result := '未找到';
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
    strErrorInfo := '你还没有安装Microsoft Excel，请先安装！';
    BoxErr(strErrorInfo);
    exit;
  end;

  try
    DayPlanItemGroupList  := TRsDayPlanItemGroupList.Create;
    //excelApp.DisplayAlerts:=false ;
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
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

    //获取总条数
    nTotalCount := GetTotalPlanCount(BeginDate, EndDate,DayPlanID);

    nTempRow := nRow ;
    //获取左面的区域列表

    DayPlanItemGroupList.Clear;
    QueryLeftGroupListByID(DayPlanID,DayPlanItemGroupList) ;
    for j := 0 to DayPlanItemGroupList.Count - 1 do
    begin
      AddLeftHead(excelApp, workBook, workSheet,DayPlanItemGroupList.Items[j],nRow);
      //查询计划
      SetLength(DayPlanInfoList,0); ;
      QueryDayPlanInfoListByGroupID(BeginDate,EndDate,DayPlanItemGroupList.Items[j].ID,DayPlanInfoList) ;

      //判断是否是打温车型
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

    //获取右面的区域列表

    DayPlanItemGroupList.Clear;
    QueryRightGroupListByID(DayPlanID,DayPlanItemGroupList) ;
    for j := 0 to DayPlanItemGroupList.Count - 1 do
    begin
      AddRightHead(excelApp, workBook, workSheet,DayPlanItemGroupList.Items[j],nRow);
      //查询计划
      SetLength(DayPlanInfoList,0); ;
      QueryDayPlanInfoListByGroupID(BeginDate,EndDate,DayPlanItemGroupList.Items[j].ID,DayPlanInfoList) ;

      //判断是否是打温车型
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

    //添加边框 (因为上面自增了一个所以下去下面需要减去一个)
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
