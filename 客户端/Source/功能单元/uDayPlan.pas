unit uDayPlan;

interface
uses
  Windows,ComObj,Forms,Variants,Classes,SysUtils,ADODB,uTFSystem,DateUtils,StrUtils;

const
  DAY_FLAG = '※' ;    //次日的标记符
type
  //
  TDayPlanCols = array[0..3] of string;
  //日班计划数据行
  TDayPlanItem = record
    OrginData : TDayPlanCols;
    FormatedCheCi:string ; //来的车次
    FormatedRemark:string ; //备注
    FormatedCC : string;    //调度所用车次
    FormatedCC1 : string;    //派班所用车次
    FormatedCX : string;
    FormatedCH : string;
    FormatedDay : string ;  //出发日期
  end;
  //日班计划数据行列表
  TDayPlanArray = array of TDayPlanItem;
  
  //日班计划区域
  RDayPlanRect = record
    //区域标题
    Caption : string;
    //区域左上坐标(行、列)
    LeftTop : TPoint;
    //区域右上坐标(行、列)
    RightTop : TPoint;
    //区域左下坐标(行、列)
    LeftBottom : TPoint;
    //区域右下坐标(行、列)
    RightBottom : TPoint;
    //计划类型(0:计划;1:打温)
    PlanType : integer;
    //计划内容
    Rows : TDayPlanArray;
  end;
  //计划区域列表
  TDayPlanRectArray = array of RDayPlanRect;

  //车次机车信息关系
  RTrainRelation = Record
    strCheCi:string ; //来的车次
    strRemark:string ; //备注
    Caption : string;
    CC : string;
    CX : string;
    CH : string;
  end;
  
  //车次机车信息关系列表
  TTrainRelationArray = array of RTrainRelation;
  
  //进度事件
  TProgressEvent = procedure(Position,Max : integer) of object;
  //日班数据分析类
  TDayPlanAnalysis = class
  public
    constructor Create;
    destructor Destroy();override;
  public
    //是否是汉字
    //如果是汉字那么，返回 True，如果不是汉字，那么返回 False
    function IsMBCSChar(const ch: Char): Boolean;
  private
    //机车计划的列头
    m_JHCol : TDayPlanCols;
    //打温计划的列表
    m_DWCol : TDayPlanCols;
    //最大行
    m_nMaxRow : integer;
    //最大列
    m_nMaxCol : integer;
    //进度
    m_OnProgress : TProgressEvent;
    //计划标题
    m_strPlanTitle:string;
    //计划时间
    m_strPlanName:string;
  public
    //捕获的区域列表
    MatchedRectArray : TDayPlanRectArray;
    //车次机车关系列表
    MatchedRelationArray : TTrainRelationArray;
    //分析数据
    procedure Analysis(ExcelFile : string);
    //清空数组
    procedure ClearData();
    //格式化数据
    function FormatData(planRect : RDayPlanRect) : RDayPlanRect;
    //是否已经被检索过
    function HasRead(Row,Col : integer) : boolean;
    //是否是匹配区域
    function MatchRect(Row,Col : integer;excelApp: Variant;out planRect : RDayPlanRect) : boolean;
    //是否为匹配列头
    function MatchHead(Row,Col : integer;excelApp: Variant;PlanHead : TDayPlanCols) : boolean;
    //格式化车次
    function FormatCC(SourceString : string) : string ;
    //格式化车型
    function FormatCX(SourceString : string) : string ;
    //格式化车号
    function FormatCH(SourceString : string) : string ;
  public
    property  OnProgress : TProgressEvent read m_OnProgress write m_OnProgress;
    //机车计划的列头
    property  JHCol : TDayPlanCols read m_JHCol;
    //打温计划的列表
    property DWCol : TDayPlanCols read  m_DWCol;
    //最大行
    property MaxRow : integer read m_nMaxRow;
    //最大列
    property MaxCol : integer read m_nMaxCol;
    //计划标题
    property  PlanTitle:string read m_strPlanTitle ;
    //计划时间
    property PlanName:string read m_strPlanName;
  end;
  //日计划数据库操作
  TDBDayPlan = class(TDBOperate)
  public
    //导入数据库
    procedure ImportToDB(DayPlanDate : TDateTime;DayOrNight : integer; strDutyPlaceID:string;FileName:string;
      MatchedRectArray : TDayPlanRectArray;MatchedRelationArray : TTrainRelationArray;ShowProgress:TProgressEvent);
    //从数据库读出
    function LoadFromDB(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;
      out MatchedRectArray : TDayPlanRectArray;out MatchedRelationArray : TTrainRelationArray) : boolean;
    //导出
    function SaveToFile(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;FileName:string):Boolean;
    //检查是否存在导入记录
    function IsExist(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string):Boolean;
  public
    function SaveToStream(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;Stream:TStream):Boolean;
  end;




implementation

uses
  DB;

{ TDayPlanAnalysis }

procedure TDayPlanAnalysis.Analysis(ExcelFile: string);
var
  excelApp: Variant;
  nCurRow,nCurCol : integer;
  planRect :RDayPlanRect;
  relation : RTrainRelation;
  i: Integer;
  k: Integer;
begin
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  try


    SetLength(MatchedRectArray,0);
    SetLength(MatchedRelationArray,0);

    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(ExcelFile);
    excelApp.Worksheets[1].activate;
    //获取头部
    m_strPlanTitle :=  excelApp.Cells[1,1].Value  ;
    m_strPlanName  :=  excelApp.Cells[2,1].Value  ;
    //遍历行列
    for nCurRow := 1 to m_nMaxRow do
    begin
      for nCurCol := 1 to m_nMaxCol do
      begin
        if assigned(m_OnProgress) then
          m_OnProgress((nCurRow-1) * m_nMaxCol + nCurCol - 1,m_nMaxRow*m_nMaxCol);
        //如果当前行列已经在被检索的区域内则继续下一行列
        if HasRead(nCurRow,nCurCol) then continue;
        //如果当前行列不是被匹配的区域则继续下一行列
        if MatchRect(nCurRow,nCurCol,excelApp,planRect) then
        begin
          planRect := FormatData(planRect);
          SetLength(MatchedRectArray,length(MatchedRectArray) + 1);
          MatchedRectArray[length(MatchedRectArray) - 1] := planRect;
        end;
      end;
    end;
    for i := 0 to length(MatchedRectArray) - 1 do
    begin
      for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
      begin
        //排除是次日的车次
        if Trim(MatchedRectArray[i].Rows[k].FormatedDay) = ''  then
        begin
          relation.strCheCi := MatchedRectArray[i].Rows[k].FormatedCheCi ;
          relation.strRemark := MatchedRectArray[i].Rows[k].FormatedRemark ;

          relation.Caption := MatchedRectArray[i].Caption;

          relation.CX := MatchedRectArray[i].Rows[k].FormatedCX;
          relation.CH := MatchedRectArray[i].Rows[k].FormatedCH;
          relation.CC := MatchedRectArray[i].Rows[k].FormatedCC;

          SetLength(MatchedRelationArray,length(MatchedRelationArray) + 1);
          MatchedRelationArray[length(MatchedRelationArray) - 1] := relation;
        end ;
      end;  
    end;
  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;  
end;

procedure TDayPlanAnalysis.ClearData;
begin
  SetLength(MatchedRectArray,0);
  SetLength(MatchedRelationArray,0);
end;

constructor TDayPlanAnalysis.Create;
begin
  m_JHCol[0] := '车次';
  m_JHCol[1] := '机车';
  m_JHCol[2] := '车次';
  m_JHCol[3] := '附注';

  m_DWCol[0] := '车型';
  m_DWCol[1] := '机车';
  m_DWCol[2] := '机车';
  m_DWCol[3] := '附注';
  
  m_nMaxRow := 200;
  m_nMaxCol := 20;
end;

destructor TDayPlanAnalysis.Destroy;
begin

  inherited;
end;


function TDayPlanAnalysis.FormatCC(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;
  if b > 0 then
  begin
    e := b;
    for i := b+1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-']) then
      begin
        e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if (e <b) or (e*b = 0) then
    result := SourceString;
end;




function TDayPlanAnalysis.FormatCH(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b;
    for i := b + 1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','+','-']) then
      begin
         e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if length(result) = 1 then
    result := '000' + result;
   if length(result) = 2 then
    result := '00' + result;
  if length(result) = 3 then
    result := '0' + result;
end;

function TDayPlanAnalysis.FormatCX(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b - 1;
    if SourceString[b] in ['A'..'Z','a'..'z'] then
    begin
      for i := b  to length(SourceString) do
      begin
        if (SourceString[i] in ['A'..'Z','a'..'z']) then
        begin
          e := i;
        end else begin
          break;
        end;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  IF SourceString <> '' then
  begin
  if UpperCase(result) = 'C' then
    result := 'HDX3C';
  if UpperCase(result) = 'H' then
    result := 'HDX3D';
  if UpperCase(result) = 'G' then
    result := 'DF11G';
  if UpperCase(result) = '' then
    result := 'SS8';
   if UpperCase(result) = 'S' then
    result := 'SS9';
  end;
end;

function TDayPlanAnalysis.FormatData(planRect: RDayPlanRect): RDayPlanRect;
const
  FORMATED_CHECI = 0 ;
  FORMATED_CX = 1 ;
  FORMATED_CH = 1 ;
  FORMATED_CC = 2 ;
  FORMATED_REMARK = 3 ;
var
  i: Integer;
  nFind : Integer ;
begin
  result := planRect;
  if planRect.PlanType = 1  then exit;
  for i := 0 to length(planRect.Rows) - 1 do
  begin
    Result.Rows[i].FormatedCheCi :=  planRect.Rows[i].OrginData[FORMATED_CHECI] ;
    result.Rows[i].FormatedCX := FormatCX(planRect.Rows[i].OrginData[FORMATED_CX]);
    result.Rows[i].FormatedCH := FormatCH(planRect.Rows[i].OrginData[FORMATED_CH]);
    result.Rows[i].FormatedCC := FormatCC(planRect.Rows[i].OrginData[FORMATED_CC]) ;
    Result.Rows[i].FormatedRemark :=  planRect.Rows[i].OrginData[FORMATED_REMARK] ;

    if ( Length( result.Rows[i].FormatedCC )  = 5  ) and
    (  LeftStr(result.Rows[i].FormatedCC,2)  = '50'  )
    then
    begin
      Result.Rows[i].FormatedCC1 := FormatCC(planRect.Rows[i].OrginData[FORMATED_REMARK]) ;
      result.Rows[i].FormatedCC := Result.Rows[i].FormatedCC1 ;
    end;

    nFind := Pos(DAY_FLAG,planRect.Rows[i].OrginData[FORMATED_REMARK]);
    if nFind <> 0  then
      Result.Rows[i].FormatedDay :=  '明天'
    else
      Result.Rows[i].FormatedDay :=  '' ;
  end;
end;

function TDayPlanAnalysis.HasRead(Row, Col : integer): boolean;
var
  i: Integer;
  r : TRect;
  pt : TPoint;
begin
  result := false;
  for i := 0 to length(MatchedRectArray) - 1 do
  begin
    r := Rect(MatchedRectArray[i].LeftTop.X,MatchedRectArray[i].LeftTop.Y,
      MatchedRectArray[i].RightBottom.X,MatchedRectArray[i].RightBottom.Y);
    if PtInRect(r,pt) then
    begin
      result := true;
      exit;    
    end;
  end;
end;



function TDayPlanAnalysis.IsMBCSChar(const ch: Char): Boolean;
begin
  Result := (ByteType(ch, 1) <> mbSingleByte);
end;

function TDayPlanAnalysis.MatchHead(Row, Col: integer; excelApp: Variant;
  PlanHead: TDayPlanCols): boolean;
var
  i : integer;  
begin
  result := true;
  for i := 0 to length(PlanHead) - 1 do
  begin
    if VarToStr(Trim( excelApp.Cells[Row,Col + i].Value ) ) <> PlanHead[i] then
    begin
      result := false;
      exit;
    end;    
  end;
end;

function TDayPlanAnalysis.MatchRect(Row, Col: integer;
  excelApp: Variant;out planRect : RDayPlanRect): boolean;
var
  i,k,nullCount: Integer;
  nullRow : boolean;
begin
  result := false;
  //匹配计划区域的列头
  if MatchHead(Row,Col,excelApp,m_JHCol) then
  begin
    //设置捕获区域的名称
    planRect.Caption := excelApp.Cells[Row-1,Col].Value;
    planRect.PlanType := 0;
    //记录区域左上右上位置
    planRect.LeftTop := Point(Row-1,Col);
    planRect.RightTop := Point(Row-1,Col + length(m_JHCol) - 1);
    planRect.LeftBottom := Point(m_nMaxRow,Col);
    planRect.RightBottom := Point(m_nMaxRow,Col + length(m_JHCol) - 1);
    nullCount := 0;
    //向下开始检索行数据
    for i := Row + 1 to m_nMaxRow do
    begin
      //当出现再次捕获时标记为上一次捕获退出
      if MatchHead(i,Col,excelApp,m_JHCol) or MatchHead(i,Col,excelApp,m_DWCol) then
      begin
        //记录上一次捕获区域结束坐标
        planRect.LeftBottom := Point(i-2,Col);
        planRect.RightBottom := Point(i-2,Col + length(m_JHCol) - 1);
        //减去上一次捕获中多余部分
        setlength(planRect.Rows,length(planRect.Rows) -1);
        break;
      end;
      nullRow := true;
      //添加捕获的数据行
      Setlength(planRect.Rows,length(planRect.Rows) +  1);
      for k := 0 to length(m_JHCol) - 1 do
      begin
        planRect.Rows[length(planRect.Rows) - 1].OrginData[k] := excelApp.Cells[i,col + k];
        if planRect.Rows[length(planRect.Rows) - 1].OrginData[k] <> '' then
          nullRow := false;
      end;
      planRect.LeftBottom := Point(i,Col);
      planRect.RightBottom := Point(i,Col + length(m_JHCol) - 1);
      if nullRow then
        nullCount := nullCount + 1;
      if nullCount > 10 then break;
    end;
    result := true;
    exit;
  end;

  //匹配计划打温区域的列头
  if MatchHead(Row,Col,excelApp,m_DWCol) then
  begin
    //设置捕获区域的名称
    planRect.Caption := excelApp.Cells[Row-1,Col].Value;
    planRect.PlanType := 1;
    //记录区域左上右上位置
    planRect.LeftTop := Point(Row-1,Col);
    planRect.RightTop := Point(Row-1,Col + length(m_JHCol) - 1);
    planRect.LeftBottom := Point(m_nMaxRow,Col);
    planRect.RightBottom := Point(m_nMaxRow,Col + length(m_JHCol) - 1);
    nullCount := 0;
    //向下开始检索行数据
    for i := Row + 1 to m_nMaxRow do
    begin
      //当出现再次捕获时标记为上一次捕获退出
      if MatchHead(i,Col,excelApp,m_JHCol) or MatchHead(i,Col,excelApp,m_DWCol) then
      begin
        //记录上一次捕获区域结束坐标
        planRect.LeftBottom := Point(i-2,Col);
        planRect.RightBottom := Point(i-2,Col + length(m_JHCol) - 1);
        //减去上一次捕获中多余部分
        setlength(planRect.Rows,length(planRect.Rows) -1);
        break;
      end;
      nullRow := true;
      //添加捕获的数据行
      Setlength(planRect.Rows,length(planRect.Rows) +  1);
      for k := 0 to length(m_JHCol) - 1 do
      begin
        planRect.Rows[length(planRect.Rows) - 1].OrginData[k] := excelApp.Cells[i,col + k];
        if planRect.Rows[length(planRect.Rows) - 1].OrginData[k] <> '' then
          nullRow := false;
      end;
      planRect.LeftBottom := Point(i,Col);
      planRect.RightBottom := Point(i,Col + length(m_JHCol) - 1);
      if nullRow then
        nullCount := nullCount + 1;
      if nullCount > 10 then break;
    end;
    result := true;
    exit;
  end;

end;




procedure TDBDayPlan.ImportToDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
FileName:string; MatchedRectArray: TDayPlanRectArray;
  MatchedRelationArray: TTrainRelationArray;ShowProgress:TProgressEvent);
var
  i,k : integer;
  adoQuery : TADOQuery;
  strDayGUID,strRectGUID,strUpdateCode : string;
  strDayOrNight : string;
  dtBeginTime,dtEndTime : TDateTime;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      strDayGUID := NewGUID;
      strDayOrNight := '夜班';

      dtBeginTime := IncHour(DateOf(DayPlanDate),18);
      dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);

      if DayOrNight = 1 then
      begin
        strDayOrNight := '白班';
        dtBeginTime := IncHour(DateOf(DayPlanDate),8);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
      end;
      
      //添加计划信息
      if RecordCount = 0 then
      begin
        Append;
        FieldByName('strDayPlanGUID').Value := strDayGUID;
        FieldByName('strDayPlanName').Value := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight;
        FieldByName('strDutyPlaceID').Value := strDutyPlaceID ;
        FieldByName('dtDay').Value := DateOf(DayPlanDate);
        FieldByName('nDayOrNight').Value := DayOrNight;
        FieldByName('dtBeginTime').Value := dtBeginTime;
        FieldByName('dtEndTime').Value := dtEndTime;
        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
        Post;
      end
      else
      begin
        Edit ;
        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
        Post;
        strDayGUID  := FieldByName('strDayPlanGUID').AsString;
      end;
      //清空之前的记录
      Sql.Text := 'delete from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      ExecSQL;
      //添加车次机车关联
      for i := 0 to length(MatchedRelationArray) - 1 do
      begin
        if (MatchedRelationArray[i].CC + MatchedRelationArray[i].CX + MatchedRelationArray[i].CH) = '' then continue;

        begin
          Sql.Text := 'insert into TAB_DayPlan_TrainRelation (strDayPlanGUID,' +
            'dtBeginTime,dtEndTime,dtCreateTime,strTrainNo,strTrainTypeName,' +
            'strTrainNumber,strRemark  ) values (:strDayPlanGUID,:dtBeginTime,' +
            ':dtEndTime,getdate(),:strTrainNo,:strTrainTypeName,:strTrainNumber,:strRemark)';
          Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
          Parameters.ParamByName('dtBeginTime').Value := dtBeginTime;
          Parameters.ParamByName('dtEndTime').Value := dtEndTime;
          Parameters.ParamByName('strTrainNo').Value := MatchedRelationArray[i].CC;
          Parameters.ParamByName('strTrainTypeName').Value := MatchedRelationArray[i].CX;
          Parameters.ParamByName('strTrainNumber').Value := MatchedRelationArray[i].CH;
          Parameters.ParamByName('strRemark').Value := MatchedRelationArray[i].strRemark;
          ExecSQL;
        end;
      end;
      strUpdateCode := NewGUID;
      for i := 0 to length(MatchedRectArray) - 1 do
      begin
        //添加车次机车关联
        Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID and strRectName=:RectName';
        Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
        Parameters.ParamByName('RectName').Value := MatchedRectArray[i].Caption;
        Open;
        strRectGUID := NewGUID;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strRectGUID').Value :=  strRectGUID;
        end else begin
          strRectGUID := FieldByName('strRectGUID').AsString;
          Edit;
        end;
        FieldByName('strDayPlanGUID').Value :=  strDayGUID;
        FieldByName('strRectName').Value :=  MatchedRectArray[i].Caption;
        FieldByName('nLeftTopX').Value :=  MatchedRectArray[i].LeftTop.X;
        FieldByName('nLeftTopY').Value :=  MatchedRectArray[i].LeftTop.Y;
        FieldByName('nRightTopX').Value :=  MatchedRectArray[i].RightTop.X;
        FieldByName('nRightTopY').Value :=  MatchedRectArray[i].RightTop.Y;
        FieldByName('nLeftBottomX').Value :=  MatchedRectArray[i].LeftBottom.X;
        FieldByName('nLeftBotoomY').Value :=  MatchedRectArray[i].LeftBottom.Y;
        FieldByName('nRightBottomX').Value :=  MatchedRectArray[i].RightBottom.X;
        FieldByName('nRightBottomY').Value :=  MatchedRectArray[i].RightBottom.Y;
        FieldByName('nRectType').Value :=  MatchedRectArray[i].PlanType;
        FieldByName('strUpdateCode').Value :=  strUpdateCode;
        Post;
        for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
        begin
          Sql.Text := 'insert into TAB_DayPlan_Item (strRectItemGUID,strRectGUID, ' +
            ' nRow,strFormatedTrainNo,strTrainNo,strTrainNo1,nDay,strArriveTrainNo,strTrain, ' +
            ' strBrief,nChanged,strUpdateCode) values (:strRectItemGUID,' +
            ' :strRectGUID,:nRow,:strFormatedTrainNo,:strTrainNo,:strTrainNo1,:nDay,:strArriveTrainNo,' +
            ' :strTrain,:strBrief,:nChanged,:strUpdateCode)';
          Parameters.ParamByName('strRectItemGUID').Value := NewGUID;
          Parameters.ParamByName('strRectGUID').Value := strRectGUID;
          Parameters.ParamByName('nRow').Value := k + 1;
          Parameters.ParamByName('strFormatedTrainNo').Value := MatchedRectArray[i].Rows[k].FormatedCC;
          Parameters.ParamByName('strTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[2];
          Parameters.ParamByName('strArriveTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[0];
          Parameters.ParamByName('strTrain').Value := MatchedRectArray[i].Rows[k].OrginData[1];
          Parameters.ParamByName('strTrainNo1').Value := '';
          Parameters.ParamByName('nDay').Value := 0;
          Parameters.ParamByName('strBrief').Value := MatchedRectArray[i].Rows[k].OrginData[3];
          Parameters.ParamByName('nChanged').Value := 0;
          Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;   
          ExecSQL;
        end;
        //删除多余的数据行
        SQL.Text := 'delete from TAB_DayPlan_Item where strRectGUID=:strRectGUID and strUpdateCode <> :strUpdateCode';
        Parameters.ParamByName('strRectGUID').Value := strRectGUID;
        Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;
        ExecSQL;
      end;
      //清除本次更新后已经没有了的区域的数据
      Sql.Text := 'delete from TAB_DayPlan_Item where strRectGUID in (select strRectGUID from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID and strUpdateCode <> :strUpdateCode)';
      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
      Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
      ExecSQL;
      //清除本次更新后已经没有了的区域
      Sql.Text := 'delete from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID and strUpdateCode <> :strUpdateCode';
      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
      Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;


//procedure TDBDayPlan.ImportToDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
//FileName:string; MatchedRectArray: TDayPlanRectArray;
//  MatchedRelationArray: TTrainRelationArray);
//var
//  i,k : integer;
//  adoQuery : TADOQuery;
//  strDayGUID,strRectGUID,strUpdateCode : string;
//  strDayOrNight : string;
//  dtBeginTime,dtEndTime : TDateTime;
//begin
//  adoQuery := TADOQuery.Create(nil);
//  try
//    with adoQuery do
//    begin
//      Connection := m_ADOConnection;
//      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
//      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
//      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
//      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
//      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate) + 1,-1);
//      Parameters.ParamByName('DayOrNight').Value := DateOf(DayOrNight);
//      Open;
//      strDayGUID := NewGUID;
//      strDayOrNight := '白班';
//      dtBeginTime := IncHour(DateOf(DayPlanDate),18);
//      dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
//
//      if DayOrNight = 2 then
//      begin
//        strDayOrNight := '夜班';
//        dtBeginTime := IncHour(DateOf(DayPlanDate)+1,8);
//        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
//      end;
//      
//      //添加计划信息
//      if RecordCount = 0 then
//      begin
//        Append;
//        FieldByName('strDayPlanGUID').Value := strDayGUID;
//        FieldByName('strDayPlanName').Value := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight;
//        FieldByName('strDutyPlaceID').Value := strDutyPlaceID ;
//        FieldByName('dtDay').Value := DateOf(DayPlanDate);
//        FieldByName('nDayOrNight').Value := DayOrNight;
//        FieldByName('dtBeginTime').Value := dtBeginTime;
//        FieldByName('dtEndTime').Value := dtEndTime;
//        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
//        Post;
//      end
//      else
//      begin
//        Edit ;
//        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
//        Post;
//        strDayGUID  := FieldByName('strDayPlanGUID').AsString;
//      end;
//      //清空之前的记录
//      Sql.Text := 'delete from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
//      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//      ExecSQL;
//
//      //删除历史记录
//      //清除本次更新后已经没有了的区域的数据
//      Sql.Text := 'delete from TAB_DayPlan_Item where strRectGUID in (select strRectGUID from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID )';
//      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
//      //Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
//      ExecSQL;
//      //清除本次更新后已经没有了的区域
//      Sql.Text := 'delete from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID ';
//      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
//      //Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
//      ExecSQL;
//
//      //添加车次机车关联
//      for i := 0 to length(MatchedRelationArray) - 1 do
//      begin
//        if (MatchedRelationArray[i].CC + MatchedRelationArray[i].CX + MatchedRelationArray[i].CH) = '' then continue;
//
//        //段和京端的添加到关系表
//        if  ( MatchedRelationArray[i].strCheCi  = '京段' ) or
//          ( MatchedRelationArray[i].strCheCi  =   '段' )
//        then
//        begin
//          Sql.Text := 'insert into TAB_DayPlan_TrainRelation (strDayPlanGUID,' +
//            'dtBeginTime,dtEndTime,dtCreateTime,strTrainNo,strTrainTypeName,' +
//            'strTrainNumber  ) values (:strDayPlanGUID,:dtBeginTime,' +
//            ':dtEndTime,getdate(),:strTrainNo,:strTrainTypeName,:strTrainNumber)';
//          Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//          Parameters.ParamByName('dtBeginTime').Value := dtBeginTime;
//          Parameters.ParamByName('dtEndTime').Value := dtEndTime;
//          Parameters.ParamByName('strTrainNo').Value := MatchedRelationArray[i].CC;
//          Parameters.ParamByName('strTrainTypeName').Value := MatchedRelationArray[i].CX;
//          Parameters.ParamByName('strTrainNumber').Value := MatchedRelationArray[i].CH;
//          ExecSQL;
//        end;
//      end;
//      strUpdateCode := NewGUID;
//      for i := 0 to length(MatchedRectArray) - 1 do
//      begin
//
//        //添加车次机车关联
//        Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID and strRectName=:RectName';
//        Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//        Parameters.ParamByName('RectName').Value := MatchedRectArray[i].Caption;
//        Open;
//        strRectGUID := NewGUID;
//        if RecordCount = 0 then
//        begin
//          Append;
//          FieldByName('strRectGUID').Value :=  strRectGUID;
//        end else begin
//          strRectGUID := FieldByName('strRectGUID').AsString;
//          Edit;
//        end;
//        FieldByName('strDayPlanGUID').Value :=  strDayGUID;
//        FieldByName('strRectName').Value :=  MatchedRectArray[i].Caption;
//        FieldByName('nLeftTopX').Value :=  MatchedRectArray[i].LeftTop.X;
//        FieldByName('nLeftTopY').Value :=  MatchedRectArray[i].LeftTop.Y;
//        FieldByName('nRightTopX').Value :=  MatchedRectArray[i].RightTop.X;
//        FieldByName('nRightTopY').Value :=  MatchedRectArray[i].RightTop.Y;
//        FieldByName('nLeftBottomX').Value :=  MatchedRectArray[i].LeftBottom.X;
//        FieldByName('nLeftBotoomY').Value :=  MatchedRectArray[i].LeftBottom.Y;
//        FieldByName('nRightBottomX').Value :=  MatchedRectArray[i].RightBottom.X;
//        FieldByName('nRightBottomY').Value :=  MatchedRectArray[i].RightBottom.Y;
//        FieldByName('nRectType').Value :=  MatchedRectArray[i].PlanType;
//        FieldByName('strUpdateCode').Value :=  strUpdateCode;
//        Post;
//
//
//
//
//        for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
//        begin
//          Sql.Text := 'insert into TAB_DayPlan_Item (strRectItemGUID,strRectGUID, ' +
//            ' nRow,strFormatedTrainNo,strTrainNo,nDay,strArriveTrainNo,strTrain, ' +
//            ' strBrief,strPlaceName,nChanged,strUpdateCode) values (:strRectItemGUID,' +
//            ' :strRectGUID,:nRow,:strFormatedTrainNo,:strTrainNo,:nDay,:strArriveTrainNo,' +
//            ' :strTrain,:strBrief,:strPlaceName,:nChanged,:strUpdateCode)';
//          Parameters.ParamByName('strRectItemGUID').Value := NewGUID;
//          Parameters.ParamByName('strRectGUID').Value := strRectGUID;
//          Parameters.ParamByName('nRow').Value := k + 1;
//          Parameters.ParamByName('strFormatedTrainNo').Value := MatchedRectArray[i].Rows[k].FormatedCC;
//          Parameters.ParamByName('strTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[2];
//          Parameters.ParamByName('strArriveTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[0];
//          Parameters.ParamByName('strTrain').Value := MatchedRectArray[i].Rows[k].OrginData[1];
//          Parameters.ParamByName('strBrief').Value := MatchedRectArray[i].Rows[k].OrginData[3];
//          Parameters.ParamByName('nChanged').Value := 0;
//          Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;   
//          ExecSQL;
//        end;
//      end;
//    end;
//  finally
//    adoQuery.Free;
//  end;
//end;


function TDBDayPlan.IsExist(DayPlanDate: TDateTime;
  DayOrNight: integer;strDutyPlaceID:string): Boolean;
var
  adoQuery: TADOQuery;
  strDayOrNight : string ;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    strDayOrNight := '夜班';
    if DayOrNight = 1 then
       strDayOrNight := '白班' ;
    strDayOrNight := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight ;
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and ( strDayPlanName = :strDayPlanName  )and nDayOrNight=:DayOrNight';

      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('strDayPlanName').Value := strDayOrNight;
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;

      Open;
      //添加计划信息
      if RecordCount = 0 then
      begin
        exit;
      end;
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBDayPlan.LoadFromDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  out MatchedRectArray: TDayPlanRectArray;
  out MatchedRelationArray: TTrainRelationArray) : boolean;
var
  i,k : integer;
  adoQuery,adoQuery2 : TADOQuery;
  strDayGUID,strRectGUID : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1 ,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight;
      Open;
      //添加计划信息
      if RecordCount = 0 then
      begin
        exit;
      end;
      strDayGUID  := FieldByName('strDayPlanGUID').AsString;

      //添加车次机车关联
      Sql.Text := 'select * from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      Open;
      SetLength(MatchedRelationArray,RecordCount);
      i := 0 ;
      while not eof do
      begin
        MatchedRelationArray[i].CC := FieldByName('strTrainNo').Value;
        MatchedRelationArray[i].CX := FieldByName('strTrainTypeName').Value;
        MatchedRelationArray[i].CH := FieldByName('strTrainNumber').Value;
        MatchedRelationArray[i].strCheCi := FieldByName('strTrainNo').Value;
        //MatchedRelationArray[i].Caption := FieldByName('strTrainNumber').Value;
        MatchedRelationArray[i].strRemark :=  FieldByName('strRemark').Value;
        Inc(i);
        next;
      end;

      Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      Open;
      i := 0;
      SetLength(MatchedRectArray,RecordCount);
      while not eof do
      begin
        MatchedRectArray[i].Caption := FieldByName('strRectName').Value;
        MatchedRectArray[i].LeftTop.X := FieldByName('nLeftTopX').Value;
        MatchedRectArray[i].LeftTop.Y := FieldByName('nLeftTopY').Value;
        MatchedRectArray[i].RightTop.X := FieldByName('nRightTopX').Value;
        MatchedRectArray[i].RightTop.Y := FieldByName('nRightTopY').Value;
        MatchedRectArray[i].LeftBottom.X := FieldByName('nLeftBottomX').Value;
        MatchedRectArray[i].LeftBottom.Y := FieldByName('nLeftBotoomY').Value;
        MatchedRectArray[i].RightBottom.X := FieldByName('nRightBottomX').Value;
        MatchedRectArray[i].RightBottom.Y := FieldByName('nRightBottomY').Value;
        MatchedRectArray[i].PlanType := FieldByName('nRectType').Value;
        strRectGUID := FieldByName('strRectGUID').Value;
        adoQuery2 := TADOQuery.Create(nil);
        try
          adoQuery2.Connection := m_ADOConnection;
          //添加车次机车关联
          adoQuery2.Sql.Text := 'select * from TAB_DayPlan_Item where strRectGUID=:strRectGUID order by nRow';
          adoQuery2.Parameters.ParamByName('strRectGUID').Value := strRectGUID;
          adoQuery2.Open;
          k := 0;
          SetLength(MatchedRectArray[i].Rows,adoQuery2.RecordCount);
          while not adoQuery2.Eof do
          begin
            MatchedRectArray[i].Rows[k].OrginData[0] := adoQuery2.FieldByName('strArriveTrainNo').AsString;
            MatchedRectArray[i].Rows[k].OrginData[1] := adoQuery2.FieldByName('strTrain').AsString;
            MatchedRectArray[i].Rows[k].OrginData[2] := adoQuery2.FieldByName('strTrainNo').AsString;
            MatchedRectArray[i].Rows[k].OrginData[3] := adoQuery2.FieldByName('strBrief').AsString;
            Inc(k);
            adoQuery2.Next;
          end;
        finally
          adoQuery2.Free;
        end;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;



function TDBDayPlan.SaveToFile(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  FileName: string): Boolean;
var
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      //添加计划信息
      if RecordCount = 0 then
      begin
        exit;
      end;
      ( FieldByName('oleDayPlan') As TBlobField).SaveToFile(FileName);
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBDayPlan.SaveToStream(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  Stream:TStream): Boolean;
var
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      //添加计划信息
      if RecordCount = 0 then
      begin
        exit;
      end;
      ( FieldByName('oleDayPlan') As TBlobField).SaveToStream(Stream);
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
