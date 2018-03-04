unit uTableOperate;

interface
uses SysUtils,Classes,ADODB,DB,Contnrs,uQryFilter,Windows;


type

  {RJiWuDuanBaseInfo 机务段信息结构体}
  RJiWuDuanBaseInfo = record
      m_nID: Integer; // 机务段号
      m_strName: string; // 机务段名称
      m_bIsLocal: Integer; // 是否为本段;0表示为本段,其它值表示外段
  end;
  PJiWuDuanBaseInfo = ^RJiWuDuanBaseInfo;
  TJiWuDuanBaseInfoArray = array of RJiWuDuanBaseInfo;

  {RYunYongQuDuanBaseInfo 运用区段信息结构体}
  RYunYongQuDuanBaseInfo = record
    m_nJWDID: Integer; // 机务段号
    m_nID: Integer; // 运用区段号
    m_strName: string; // 运用区段名称
  end;
  PYunYongQuDuanBaseInfo = ^RYunYongQuDuanBaseInfo;
  TYunYongQuDuanBaseInfoArray = array of RYunYongQuDuanBaseInfo;

  {RDiaoDuOrderBaseInfo 调令信息结构体}
  RDiaoDuOrderBaseInfo = record
      m_nSerialID: Integer; //序号ID
      m_nJWDID: Integer; // 机务段号
      m_nYYQDID: Integer; // 运用区段号
      m_strXLName: string; // 线路名称
      m_nOrderID: Integer; // 调度命令号
      m_strOrder: string; // 调度命令内容
      m_bIsICControl: Boolean; // 是否IC卡可控;0可控,-1不可控
      m_tStartDate: TDateTime; // 揭示启用日期
      m_tStartTime: TDateTime; // 揭示启用日间
      m_tEndDate: TDateTime; // 揭示结束日期
      m_tEndTime: TDateTime; // 揭示结束时间
      m_tShowDate: TDateTime; // 揭示出示日期
      m_tShowTime: TDateTime; // 揭示出示时间
      m_tDelDate: TDateTime; // 揭示撤除日期
      m_tDelTime: TDateTime; // 揭示撤除时间

      BeginDate : TDateTime;
      EndDate : TDateTime;
      ShowDate : TDateTime;
      DelDate : TDateTime;        

      m_strCopyPerson: string; // 调令抄录人
      m_strReviewPerson: string; // 调令审核人
      m_strDelPerson: string; // 调令撤除人
      m_dwStartPos: DWORD; // 调令开始启用公里标
      m_dwEndPos: DWORD; // 调令终止启用公里标
      m_bIsDel: Integer; // 是否为已删除调令
      m_dsTamp: Integer; //调令关联ID
      nStation: Integer; //车站
      nUpDown: Integer; //上下行 sxx 0:  上行，1：下行：2：上下
      bIsNoBeg: Boolean; //自接令时起  0，-1    IsNoBeg
      bIsNoEnd: Boolean; //另有令至         IsNoEnd
      bIsKeyJieShi: Boolean; //是否是重要揭示  Fxlable
      bXlbsbty: Boolean; //是否是新联闭设备停用  bitbak1
      shstatu: Integer; //0:未发送  1：待审核  2：已审核
      isDelete: Integer; //1:撤除 0：未撤除
      iEditDate: TDateTime; //编辑日期
      iEditTime: TDateTime; //编辑时间
      sFlag: string; //标识
      bIsOutTime : Boolean;
  end;
  PDiaoDuOrderBaseInfo = ^RDiaoDuOrderBaseInfo;
  TDiaoDuOrderBaseInfoArray = array of RDiaoDuOrderBaseInfo;

  {REditRecInfo 记录编辑信息的结构体}
  REditRecInfo = record
    iEditDate: TDateTime;
    iEditTime: TDateTime;
    nRecord: Integer;
  end;

  {版本类型}
  VersionType = (unknowtype, SiWei, ZhuZhou);

  RParamSetInfo = record
      m_VersionType: VersionType; // 版本类型
      m_strJWD_DB_Path: string; // 机务段信息存储数据库路径
      m_strYYQD_DB_Path: string; // 运用区段信息存储数据库路径
      m_strDDML_DB_Path: string; // 调度命令信息存储数据库路径
      m_strJSFilePath: string; // 揭示文件路径
  end;


  {RJieShiRecDB 揭示信息结构体}
  RJieShiRecDB = record
      nID: string; //揭示序号
      nLineNO: string; //线路号,交路号
      bUpDownType: string; //上下行
      nStationNO: string; //车站号
      nPos_Begin: string; //开始公里标/TMIS站号
      nPos_End: string; //结束公里标/侧线号
      nSpeedLimit: string; //限速
      dtStartDate: string; //开始日期
      dtStartTime: string; //开始时间
      dtEndDate: string; //结束日期
      dtEndTime: string; //结束时间
      jstType: string; //揭示类型
      nLimiteType: string; //限速类别
      nCommandNO: string; //命令号
      nGWLineNO: string; //工务线号
      nTrainType: string; //列车类型
      nRepeatNO: string; //公里标重复序号
      nLineType: string; //主线/三线
      nDirection: string; //正向/反向
      nGwUpdownType: string; //工务上下行
      nLineName: string; //线路名称
      jstLb: string; // 揭示类别   每天 昼夜
      nPos_BeginCL: string; // 开始公里标长链
      nPos_BeginID: string; // 开始公里标序号
      nPos_EndCL: string; // 终止公里标长链
      nPos_EndID: string; // 终止公里标序号
      nSpeedLimitLength: string; //限速长度
      nSpeedLimitKc: string; //客车限速
      nSpeedLimitHc: string; //货车限速
      Rst: string;
      sEndDateTime: string;
      sWriteCardDirection: string; //写卡方向
      sDutyDirection: string; //出乘方向
      sWriteCardMode: string; //写卡模式
      Dstamp: string; //调令关联ID
      iEditDate: TDateTime; //编辑日期
      iEditTime: TDateTime; //编辑时间
      strGWLineName:string[40]; // 工务线路号-工务线路名的合称,如1-京广线
      strStartTmisStation:string[40];// Tmis车站号-Tmis车站名的合称,如1-北京站
      strEndTmisStation:string[40];// Tmis车站号-Tmis车站名的合称,如1-北京站

  end;

  PRJieShiRec = ^RJieShiRecDB;

  ///////////////////
  /// 传递SQL语句条件的结构 ///
  ///////////////
  RFilterInfo = record
      strFilter: string;
      strStartDateTime: string;
      strEndDateTime: string;
      TrainKeHuo: string;
      TrainType: string;
      Train: Integer;
      bCJS: Boolean;
      nCommandNo: Integer;
      strTrainNo: string;
      bEspecialJs: Boolean;
  end;

    ////////////////////////////////////////////////////////////
    ///
    ///    类定义 TTableOperate 数据库操作类 Version 1.0.0.708
    ///     版本 Version 1.0.0.708
    ///       * Create方法增加传入参数 AdoConnect: TADOConnection
    ///         配置数据库调用外部函数SetUpSQLDB，SetAccessDB
    ///     版本 Version 1.0.703
    ///       + 增加子类 TUserTableOperate
    ///
    /////////////////////////////////////////////////////////////
    TTableOperate = class(TObject)
    public
        constructor Create(AdoConnect: TADOConnection);
        destructor Destroy; override;
    public
        procedure Insert(lstData: Tlist); virtual; abstract;
        procedure Updata(Conditions: TObjectList; var lst: TList); virtual; abstract;
        procedure Get(Conditions: TObjectList; var lst: TList); virtual; abstract;
        procedure Delete(Conditions: TObjectList);

        procedure DeleteTable(tableName: string);
        function IsChangedTable(EditRecInfo: REditRecInfo): Boolean;
    private
        procedure DeleteByConditions(Conditions: TObjectList; sTableName: string);
        procedure SelectByConditions(Conditions: TObjectList; sTableName: string);
        procedure GetEditRecInfo(var EditSQLRecInfo: REditRecInfo; sTableName: string);
    protected
        m_AdoConnction: TADOConnection;
        m_Query: TADOQuery;
        m_table: TADOTable;
        m_TableName: string;
    published
        property tableName: string read m_TableName write m_TableName;
    end;

    ///////////////////////////////////////////////////
    /// TJwdTableOperate 机务段表操作类
    ///
    ///  //////////////////// ////////////////////////
    TJwdTableOperate = class(TTableOperate)
    public
        constructor Create(AdoConnect: TADOConnection); overload;
        destructor Destroy; override;
    public
        procedure Insert(lstData: Tlist); override;
        procedure Get(Conditions: TObjectList;
            var JiWuDuanBaseInfoArray : TJiWuDuanBaseInfoArray); overload;
        procedure Updata(Conditions: TObjectList; var lst: TList); override;
    end;

    ///////////////////////////////////////////////////
    /// TYyqdTableOperate 运用区段操作类
    /////////////////////// //////////////////////////
    TYyqdTableOperate = class(TTableOperate)
    public
        constructor Create(AdoConnect: TADOConnection); overload;
        destructor Destroy; override;
    public
        procedure Insert(lstData: Tlist); override;
        procedure Get(Conditions: TObjectList;
            var YunYongQuDuanBaseInfoArray : TYunYongQuDuanBaseInfoArray); overload;
        procedure Updata(Conditions: TObjectList; var lst: TList); override;
    end;

    ///////////////////////////////////////////////////
    /// TDdmlTableOperate 调度命令操作类
    ///
    ///  //////////////////// ////////////////////////
    TDdmlTableOperate = class(TTableOperate)
    public
        constructor Create(AdoConnect: TADOConnection); overload;
        destructor Destroy; override;
    public
        procedure Insert(lstData: Tlist); override;
        procedure Get(Conditions: TObjectList;
            var DiaoDuOrderBaseInfoArray : TDiaoDuOrderBaseInfoArray); overload;
        procedure Updata(Conditions: TObjectList; var lst: TList); override;
        procedure InitGetDDMLCount();
        procedure CloseGetDDMLCount();
        function GetddmlCount(nJWDID,nYYQDID : Integer):Integer;
    protected
        procedure RecordToTable(var qryDdml: Tadoquery; DdmlInfo: RDiaoDuOrderBaseInfo);
    end;

    ///////////////////////////////////////////////////
    /// TJieShiTableOperate 揭示信息操作类
    ///
    ///  //////////////////// ////////////////////////
    TJieShiTableOperate = class(TTableOperate)
    public
        constructor Create(AdoConnect: TADOConnection); overload;
        destructor Destroy; override;
    public
        procedure Insert(lstData: Tlist); override;
        procedure Get(Conditions: TObjectList; var lst: TList); override;
        procedure Updata(Conditions: TObjectList; var lst: TList); override;
    public
        procedure RecordToTable(var qryJieShi: Tadoquery; JieShiInfo: RJieShiRecDB);
        procedure DeleteJieShiByCommandNo(StrCommandNo: string);
    end;

implementation


{ TTableOperate }

constructor TTableOperate.Create(AdoConnect: TADOConnection);
begin
    m_AdoConnction := AdoConnect;
    m_Query := TADOQuery.Create(nil);
    m_table := TADOTable.Create(nil);
    m_Query.Connection := m_AdoConnction;
    m_table.Connection := m_AdoConnction;
end;

//功能：根据条件执行删除操作
//异常：操作失败会产生异常

procedure TTableOperate.Delete(Conditions: TObjectList);
begin
    DeleteByConditions(Conditions, m_TableName);
end;

procedure TTableOperate.DeleteByConditions(Conditions: TObjectList;
    sTableName: string);
var
    I: integer;
    strSQL: string;
begin
    if (Conditions.Count = 0) then
    begin
        strSQL := Format('Delete from %s', [sTableName]);
    end
    else
    begin
        strSQL := Format('Delete from %s where %s',
            [sTableName, TSelectCondition(Conditions[0]).GetFilterSQLText()]);

        for I := 1 to Conditions.Count - 1 do
        begin
            strSQL := strSQL + ' and ' + TSelectCondition(Conditions[i]).GetFilterSQLText();
        end;
    end;

    m_Query.Close;
    m_Query.SQL.Clear;
    m_Query.Connection := m_AdoConnction;
    m_Query.SQL.Text := strSQL;
    m_Query.ExecSQL;
    m_Query.Close;
end;

procedure TTableOperate.DeleteTable(tableName: string);
begin
    m_Query.Close;
    m_Query.SQL.Text := 'Delete from ' + tableName;
    m_Query.ExecSQL;
    m_Query.Close;
end;

destructor TTableOperate.Destroy;
begin
    if Assigned(m_Query) then
        FreeAndNil(m_Query);
    if Assigned(m_table) then
        FreeAndNil(m_table);
    inherited;
end;

procedure TTableOperate.GetEditRecInfo(var EditSQLRecInfo: REditRecInfo;
    sTableName: string);
begin
    try
        m_Query.Close;
        m_Query.Connection := m_AdoConnction;
        m_Query.SQL.Text := Format('select iEditDate,iEditTime from %s order by iEditDate DESC,iEditTime DESC',
            [sTableName]);
        m_Query.Active := True;
        m_Query.First;
        EditSQLRecInfo.iEditDate := m_Query.FieldByName('iEditDate').AsDateTime;
        EditSQLRecInfo.iEditTime := m_Query.FieldByName('iEditTime').AsDateTime;
        EditSQLRecInfo.nRecord := m_Query.RecordCount;
    finally
        m_Query.Close;
    end;
end;
//功能：判断本地mdb表中的记录是否发生变化

function TTableOperate.IsChangedTable(EditRecInfo: REditRecInfo): Boolean;
var
    EditSQLRecInfo: REditRecInfo;
begin
    Result := False; //
    GetEditRecInfo(EditSQLRecInfo, m_TableName);

    if (EditRecInfo.nRecord <> EditSQLRecInfo.nRecord) or
        (EditRecInfo.iEditDate + EditRecInfo.iEditTime <>
        EditSQLRecInfo.iEditDate + EditSQLRecInfo.iEditTime) then
        Result := True;
end;

//功能：根据条件执行查询操作
//异常：操作失败会产生异常

procedure TTableOperate.SelectByConditions(Conditions: TObjectList;
    sTableName: string);
var
    I: integer;
    strSQL: string;
begin
    if (Conditions = nil) or (Conditions.Count = 0) then
    begin
        strSQL := Format('Select * from %s', [sTableName]);
    end
    else
    begin
        strSQL := Format('Select * from %s where %s',
            [sTableName, TSelectCondition(Conditions[0]).GetFilterSQLText()]);

        for I := 1 to Conditions.Count - 1 do
        begin
            strSQL := strSQL + ' and ' + TSelectCondition(Conditions[i]).GetFilterSQLText();
        end;
    end;

    m_Query.Close;
    m_Query.SQL.Clear;
    m_Query.Connection := m_AdoConnction;
    m_Query.SQL.Text := strSQL;
    m_Query.Open;
    m_Query.First;
end;

constructor TJwdTableOperate.Create(AdoConnect: TADOConnection);
begin
    inherited Create(AdoConnect);
end;


destructor TJwdTableOperate.Destroy;
begin

    inherited Destroy();
end;

//功能：根据条件更新记录
//异常：如果更新失败会有异常抛出

procedure TJwdTableOperate.Updata(Conditions: TObjectList; var lst: TList);
var
    I: Integer;
    JwdInfo: RJiWuDuanBaseInfo;
begin
    SelectByConditions(Conditions, m_TableName);
    for I := 0 to lst.Count - 1 do
    begin
        JwdInfo := PJiWuDuanBaseInfo(lst[I])^;
        if m_Query.Locate('m_nJWDID', JwdInfo.m_nID, []) then
        begin
            m_Query.Edit;
            m_Query.FieldByName('m_nJWDID').AsInteger := JwdInfo.m_nID;
            m_Query.FieldByName('m_strName').AsString := JwdInfo.m_strName;
            m_Query.Post;
        end;
    end;
    m_Query.Close;
end;

//功能：获得机务段信息
//异常：执行失败有异常

procedure TJwdTableOperate.Get(Conditions: TObjectList;
            var JiWuDuanBaseInfoArray : TJiWuDuanBaseInfoArray);
var
  I: Integer;
begin
  SelectByConditions(Conditions, m_TableName);
  SetLengTh(JiWuDuanBaseInfoArray,0);
  for I := 0 to m_Query.RecordCount - 1 do
  begin
    SetLengTh(JiWuDuanBaseInfoArray,length(JiWuDuanBaseInfoArray)+1);
    JiWuDuanBaseInfoArray[i].m_nID := m_Query.Fields[0].AsInteger;
    JiWuDuanBaseInfoArray[i].m_strName := m_Query.Fields[1].AsString;
    JiWuDuanBaseInfoArray[i].m_bIsLocal := m_Query.Fields[2].AsInteger;
    m_Query.Next;
  end;
  m_Query.Close;
end;

//功能：存储机务段信息
// 异常：执行失败会有异常

procedure TJwdTableOperate.Insert(lstData: Tlist);
var
    I: Integer;
    JiWuDuanBaseInfo: RJiWuDuanBaseInfo;
begin
    m_table.Close;
    m_table.TableName := m_TableName;
    m_table.Open;
    for I := 0 to lstData.Count - 1 do
    begin
        JiWuDuanBaseInfo := PJiWuDuanBaseInfo(lstData[I])^;
        m_table.Append;
        m_table.FieldByName('m_nJWDID').AsInteger := JiWuDuanBaseInfo.m_nID;
        m_table.FieldByName('m_strName').AsString := JiWuDuanBaseInfo.m_strName;
        m_table.FieldByName('m_bIsLocal').AsInteger := JiWuDuanBaseInfo.m_bIsLocal;
        m_table.Post;
    end;
    m_table.Close;
end;


{ TYyqdTableOperate }

constructor TYyqdTableOperate.Create(AdoConnect: TADOConnection);
begin
    inherited Create(AdoConnect);
end;

destructor TYyqdTableOperate.Destroy;
begin
    inherited Destroy();
end;

//功能：根据条件获得运用区段信息
//异常：操作失败会产生异常

procedure TYyqdTableOperate.Get(Conditions: TObjectList;
            var YunYongQuDuanBaseInfoArray : TYunYongQuDuanBaseInfoArray);
var
  I: Integer;
begin
  SelectByConditions(Conditions, m_TableName);
  SetLengTh(YunYongQuDuanBaseInfoArray,0);
  for I := 0 to m_Query.RecordCount - 1 do
  begin
    SetLengTh(YunYongQuDuanBaseInfoArray,LengTh(YunYongQuDuanBaseInfoArray)+1);
    YunYongQuDuanBaseInfoArray[i].m_nJWDID := m_Query.FieldByName('m_nJWDID').AsInteger;
    YunYongQuDuanBaseInfoArray[i].m_nID := m_Query.FieldByName('m_nYYQDID').AsInteger;
    YunYongQuDuanBaseInfoArray[i].m_strName := m_Query.FieldByName('m_strName').AsString;
    m_Query.Next;
  end;
  m_Query.Close;
end;
//功能：运用区段信息的插入
//异常：操作失败会有异常抛出

procedure TYyqdTableOperate.Insert(lstData: Tlist);
var
    I: Integer;
    YyqdInfo: RYunYongQuDuanBaseInfo;
begin
    m_table.Close;
    m_table.TableName := m_TableName;
    m_table.Open;
    for I := 0 to lstData.Count - 1 do
    begin
        YyqdInfo := PYunYongQuDuanBaseInfo(lstData[I])^;
        m_table.Append;
        m_table.FieldByName('m_nJWDID').AsInteger := YyqdInfo.m_nJWDID;
        m_table.FieldByName('m_strName').AsString := YyqdInfo.m_strName;
        m_table.FieldByName('m_nYYQDID').AsInteger := YyqdInfo.m_nID;
        m_table.Post;
    end;
    m_table.Close;
end;

procedure TYyqdTableOperate.Updata(Conditions: TObjectList; var lst: TList);
var
    I: Integer;
    YyqdInfo: RYunYongQuDuanBaseInfo;
begin
    SelectByConditions(Conditions, m_TableName);
    for I := 0 to lst.Count - 1 do
    begin
        YyqdInfo := PYunYongQuDuanBaseInfo(lst[I])^;
        if m_Query.Locate('m_strName', YyqdInfo.m_strName, []) then
        begin
            m_Query.Edit;
            m_Query.FieldByName('m_nJWDID').AsInteger := YyqdInfo.m_nID;
            m_Query.FieldByName('m_strName').AsString := YyqdInfo.m_strName;
            m_Query.Post;
        end;
    end;
    m_Query.Close;
end;

{ TDdmlTableOperate }

procedure TDdmlTableOperate.CloseGetDDMLCount;
begin
  m_Query.Close;
end;

constructor TDdmlTableOperate.Create(AdoConnect: TADOConnection);
begin
    inherited Create(AdoConnect);
end;

destructor TDdmlTableOperate.Destroy;
begin
    inherited Destroy();
end;

procedure TDdmlTableOperate.Get(Conditions: TObjectList;
    var DiaoDuOrderBaseInfoArray : TDiaoDuOrderBaseInfoArray);
var
  I: Integer;
begin
  SelectByConditions(Conditions, m_TableName);
  SetLengTh(DiaoDuOrderBaseInfoArray,0);
  for I := 0 to m_Query.RecordCount - 1 do
  begin
    SetLengTh(DiaoDuOrderBaseInfoArray,LengTh(DiaoDuOrderBaseInfoArray)+1);
    DiaoDuOrderBaseInfoArray[i].m_nSerialID := I + 1;
    DiaoDuOrderBaseInfoArray[i].m_nJWDID := m_Query.FieldByName('m_nJWDID').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_nYYQDID := m_Query.FieldByName('m_nYYQDID').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_strXLName := m_Query.FieldByName('m_strXLName').AsString;
    DiaoDuOrderBaseInfoArray[i].m_nOrderID := m_Query.FieldByName('m_nOrderID').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_strOrder := m_Query.FieldByName('m_strOrder').AsString;
    DiaoDuOrderBaseInfoArray[i].m_bIsICControl := m_Query.FieldByName('m_bIsICControl').AsBoolean;
    DiaoDuOrderBaseInfoArray[i].m_tStartDate := m_Query.FieldByName('m_tStartDate').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tStartTime := m_Query.FieldByName('m_tStartTime').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tEndDate := m_Query.FieldByName('m_tEndDate').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tEndTime := m_Query.FieldByName('m_tEndTime').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tShowDate := m_Query.FieldByName('m_tShowDate').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tShowTime := m_Query.FieldByName('m_tShowTime').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tDelDate := m_Query.FieldByName('m_tDelDate').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].m_tDelTime := m_Query.FieldByName('m_tDelTime').AsDateTime;

    DiaoDuOrderBaseInfoArray[i].BeginDate := StrToDateTime(FormatDateTime('yyyy-mm-dd',
        m_Query.FieldByName('m_tStartDate').AsDateTime)+
        ' '+FormatDateTime('hh:mm:ss',m_Query.FieldByName('m_tStartTime').AsDateTime));

    DiaoDuOrderBaseInfoArray[i].EndDate := StrToDateTime(FormatDateTime('yyyy-mm-dd',
        m_Query.FieldByName('m_tEndDate').AsDateTime)+
        ' '+FormatDateTime('hh:mm:ss',m_Query.FieldByName('m_tEndTime').AsDateTime));

    DiaoDuOrderBaseInfoArray[i].ShowDate := StrToDateTime(FormatDateTime('yyyy-mm-dd',
        m_Query.FieldByName('m_tShowDate').AsDateTime)+
        ' '+FormatDateTime('hh:mm:ss',m_Query.FieldByName('m_tShowTime').AsDateTime));
    DiaoDuOrderBaseInfoArray[i].DelDate := StrToDateTime(FormatDateTime('yyyy-mm-dd',
        m_Query.FieldByName('m_tDelDate').AsDateTime)+
        ' '+FormatDateTime('hh:mm:ss',m_Query.FieldByName('m_tDelTime').AsDateTime));


    DiaoDuOrderBaseInfoArray[i].m_strCopyPerson := m_Query.FieldByName('m_strCopyPerson').AsString;
    DiaoDuOrderBaseInfoArray[i].m_strReviewPerson := m_Query.FieldByName('m_strReviewPerson').AsString;
    DiaoDuOrderBaseInfoArray[i].m_strDelPerson := m_Query.FieldByName('m_strDelPerson').AsString;
    DiaoDuOrderBaseInfoArray[i].m_dwStartPos := m_Query.FieldByName('m_dwStartPos').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_dwEndPos := m_Query.FieldByName('m_dwEndPos').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_bIsDel := m_Query.FieldByName('m_bIsDel').AsInteger;
    DiaoDuOrderBaseInfoArray[i].m_dsTamp := m_Query.FieldByName('m_dsTamp').AsInteger;
    DiaoDuOrderBaseInfoArray[i].nStation := m_Query.FieldByName('nStation').AsInteger;
    DiaoDuOrderBaseInfoArray[i].nUpDown := m_Query.FieldByName('nUpDown').AsInteger;
    DiaoDuOrderBaseInfoArray[i].bIsNoBeg := m_Query.FieldByName('bIsNoBeg').AsBoolean;
    DiaoDuOrderBaseInfoArray[i].bIsNoEnd := m_Query.FieldByName('bIsNoEnd').AsBoolean;
    DiaoDuOrderBaseInfoArray[i].bIsKeyJieShi := m_Query.FieldByName('bIsKeyJieShi').AsBoolean;
    DiaoDuOrderBaseInfoArray[i].bXlbsbty := m_Query.FieldByName('bXlbsbty').AsBoolean;

    DiaoDuOrderBaseInfoArray[i].shstatu := m_Query.FieldByName('shstatu').AsInteger;
    DiaoDuOrderBaseInfoArray[i].isDelete := m_Query.FieldByName('isDelete').AsInteger;
    DiaoDuOrderBaseInfoArray[i].iEditDate := m_Query.FieldByName('iEditDate').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].iEditTime := m_Query.FieldByName('iEditTime').AsDateTime;
    DiaoDuOrderBaseInfoArray[i].sFlag := m_Query.FieldByName('sFlag').AsString;

    m_Query.Next;
  end;
  m_Query.Close;
end;


function TDdmlTableOperate.GetddmlCount(nJWDID, nYYQDID: Integer): Integer;
begin
    if m_Query.Active = False then
      InitGetDDMLCount();
    m_Query.Filter :=  ' m_nJWDID = '+IntToStr(nJWDID)+
        ' And m_nYYQDID = '+IntToStr(nYYQDID);
    m_Query.Filtered := True;
    Result := m_Query.RecordCount;
    m_Query.Filtered := False;

end;

procedure TDdmlTableOperate.RecordToTable(var qryDdml: Tadoquery; DdmlInfo: RDiaoDuOrderBaseInfo);
begin
    qryDdml.FieldByName('m_nJWDID').AsInteger := DdmlInfo.m_nJWDID;
    qryDdml.FieldByName('m_nYYQDID').AsInteger := DdmlInfo.m_nYYQDID;
    qryDdml.FieldByName('m_strXLName').AsString := DdmlInfo.m_strXLName;
    qryDdml.FieldByName('m_nOrderID').AsInteger := DdmlInfo.m_nOrderID;
    qryDdml.FieldByName('m_strOrder').AsString := DdmlInfo.m_strOrder;
    qryDdml.FieldByName('m_bIsICControl').AsBoolean := DdmlInfo.m_bIsICControl;
    qryDdml.FieldByName('m_tStartDate').AsDateTime := DdmlInfo.m_tStartDate;
    qryDdml.FieldByName('m_tStartTime').AsDateTime := DdmlInfo.m_tStartTime;
    qryDdml.FieldByName('m_tEndDate').AsDateTime := DdmlInfo.m_tEndDate;
    qryDdml.FieldByName('m_tEndTime').AsDateTime := DdmlInfo.m_tEndTime;
    qryDdml.FieldByName('m_tShowDate').AsDateTime := DdmlInfo.m_tShowDate;
    qryDdml.FieldByName('m_tShowTime').AsDateTime := DdmlInfo.m_tShowTime;
    qryDdml.FieldByName('m_tDelDate').AsDateTime := DdmlInfo.m_tDelDate;
    qryDdml.FieldByName('m_tDelTime').AsDateTime := DdmlInfo.m_tDelTime;
    qryDdml.FieldByName('m_strCopyPerson').AsString := DdmlInfo.m_strCopyPerson;
    qryDdml.FieldByName('m_strReviewPerson').AsString := DdmlInfo.m_strReviewPerson;
    qryDdml.FieldByName('m_strDelPerson').AsString := DdmlInfo.m_strDelPerson;
    qryDdml.FieldByName('m_dwStartPos').AsInteger := DdmlInfo.m_dwStartPos;
    qryDdml.FieldByName('m_dwEndPos').AsInteger := DdmlInfo.m_dwEndPos;
    qryDdml.FieldByName('m_bIsDel').AsInteger := DdmlInfo.m_bIsDel;
    qryDdml.FieldByName('m_bIsDel').AsInteger := DdmlInfo.m_bIsDel;

    qryDdml.FieldByName('m_dsTamp').AsInteger := DdmlInfo.m_dsTamp;
    qryDdml.FieldByName('nStation').AsInteger := DdmlInfo.nStation;
    qryDdml.FieldByName('nUpDown').AsInteger := DdmlInfo.nUpDown;
    qryDdml.FieldByName('bIsNoBeg').AsBoolean := DdmlInfo.bIsNoBeg;
    qryDdml.FieldByName('bIsNoEnd').AsBoolean := DdmlInfo.bIsNoEnd;
    qryDdml.FieldByName('bIsKeyJieShi').AsBoolean := DdmlInfo.bIsKeyJieShi;
    qryDdml.FieldByName('bXlbsbty').AsBoolean := DdmlInfo.bXlbsbty;

    qryDdml.FieldByName('shstatu').AsInteger := DdmlInfo.shStatu;
    qryDdml.FieldByName('isDelete').AsInteger := DdmlInfo.isDelete;
    qryDdml.FieldByName('iEditDate').AsDateTime := DdmlInfo.iEditDate;
    qryDdml.FieldByName('iEditTime').AsDateTime := DdmlInfo.iEditTime;
    qryDdml.FieldByName('sFlag').AsString := DdmlInfo.sFlag;
end;

//功能：调度命令信息的插入
//异常：操作异常会有异常抛出

procedure TDdmlTableOperate.InitGetDDMLCount;
begin
    m_Query.Close;
    m_Query.SQL.Text := 'Select * from yyqdddml ';
    m_Query.Open;
end;

procedure TDdmlTableOperate.Insert(lstData: Tlist);
var
    I: Integer;
    DdmlInfo: RDiaoDuOrderBaseInfo;
begin
    m_Query.Close;
    m_Query.SQL.Text := Format('select * from %s', [m_TableName]);
    m_Query.Active := True;
    for I := 0 to lstData.Count - 1 do
    begin
        DdmlInfo := PDiaoDuOrderBaseInfo(lstData[I])^;
        m_Query.Append;
        RecordToTable(m_Query, DdmlInfo);
        m_Query.Post;
    end;
    m_Query.Close;
end;

procedure TDdmlTableOperate.Updata(Conditions: TObjectList; var lst: TList);
var
    I: Integer;
    DdmlInfo: RDiaoDuOrderBaseInfo;
begin
    SelectByConditions(Conditions, m_TableName);
    for I := 0 to lst.Count - 1 do
    begin
        DdmlInfo := PDiaoDuOrderBaseInfo(lst[I])^;
        if m_Query.Locate('m_dsTamp', DdmlInfo.m_dsTamp, []) then
        begin
            m_Query.Edit;
            RecordToTable(m_Query, DdmlInfo);
            m_Query.Post;
        end;
    end;
    m_Query.Close;
end;

{ TJieShiTableOperate }

constructor TJieShiTableOperate.Create(AdoConnect: TADOConnection);
begin
    inherited Create(AdoConnect);
end;

procedure TJieShiTableOperate.DeleteJieShiByCommandNo(StrCommandNo: string);
var
    QryJieshi: TADOQuery;
begin
    QryJieshi := TADOQuery.Create(nil);
    try
        QryJieshi.Connection := m_AdoConnction;
        QryJieshi.SQL.Text := Format('Delete From %s where nCommandNO = %s', [m_TableName, StrCommandNo]);
        QryJieshi.ExecSQL;
    finally
        QryJieshi.Free;
    end;
end;

destructor TJieShiTableOperate.Destroy;
begin
    inherited Destroy();
end;
//功能：根据条件获得揭示信息
//异常：执行失败有异常抛出

procedure TJieShiTableOperate.Get(Conditions: TObjectList; var lst: TList);
var
    I: Integer;
    pJieShiRec: PRJieShiRec;
begin
    if not Assigned(Conditions) then
    begin
        raise Exception.Create('Conditions没有正确创建！');
    end;
    SelectByConditions(Conditions, m_TableName);
    for I := 0 to m_Query.RecordCount - 1 do
    begin
        New(pJieShiRec);
        pJieShiRec^.nLineNO := '';
        pJieShiRec^.nID := Trim(m_Query.FieldByName('bUpDownType').AsString);
        pJieShiRec^.bUpDownType := Trim(m_Query.FieldByName('bUpDownType').AsString);
        pJieShiRec^.nStationNO := Trim(m_Query.FieldByName('nStationNO').AsString);
        pJieShiRec^.nPos_Begin := Trim(m_Query.FieldByName('nPos_Begin').AsString);
        pJieShiRec^.nPos_End := Trim(m_Query.FieldByName('nPos_End').AsString);

        pJieShiRec^.dtStartDate := Trim(m_Query.FieldByName('dtStartDate').AsString);
        pJieShiRec^.dtStartTime := Trim(m_Query.FieldByName('dtStartTime').AsString);
        pJieShiRec^.dtEndDate := Trim(m_Query.FieldByName('dtEndDate').AsString);
        pJieShiRec^.dtEndTime := Trim(m_Query.FieldByName('dtEndTime').AsString);

        pJieShiRec^.nSpeedLimit := Trim(m_Query.FieldByName('nSpeedLimit').AsString);
        pJieShiRec^.jstType := Trim(m_Query.FieldByName('jstType').AsString);
        pJieShiRec^.nCommandNO := Trim(m_Query.FieldByName('nCommandNO').AsString);
        pJieShiRec^.nGWLineNO := Trim(m_Query.FieldByName('nGWLineNO').AsString);
        pJieShiRec^.nRepeatNO := Trim(m_Query.FieldByName('nRepeatNO').AsString);
        pJieShiRec^.nGwUpdownType := Trim(m_Query.FieldByName('nGwUpdownType').AsString);
        pJieShiRec^.nDirection := Trim(m_Query.FieldByName('nDirection').AsString);
        pJieShiRec^.nLineType := Trim(m_Query.FieldByName('nLineType').AsString);
        pJieShiRec^.jstLb := Trim(m_Query.FieldByName('jstLb').AsString);
        pJieShiRec^.nPos_BeginCL := Trim(m_Query.FieldByName('nPos_BeginCL').AsString);
        pJieShiRec^.nPos_BeginID := Trim(m_Query.FieldByName('nPos_BeginID').AsString);
        pJieShiRec^.nPos_EndCL := Trim(m_Query.FieldByName('nPos_EndCL').AsString);
        pJieShiRec^.nPos_EndID := Trim(m_Query.FieldByName('nPos_EndID').AsString);
        pJieShiRec^.nSpeedLimitLength := Trim(m_Query.FieldByName('nSpeedLimitLength').AsString);
        pJieShiRec^.nSpeedLimitKc := Trim(m_Query.FieldByName('nSpeedLimitKc').AsString);
        pJieShiRec^.nSpeedLimitHc := Trim(m_Query.FieldByName('nSpeedLimitHc').AsString);
        pJieShiRec^.nTrainType := Trim(m_Query.FieldByName('nTrainType').AsString);
        pJieShiRec^.Dstamp := Trim(m_Query.FieldByName('Dstamp').AsString);
        pJieShiRec^.strGWLineName := Trim(m_Query.FieldByName('strGWLineName').AsString);
        pJieShiRec^.strStartTmisStation := Trim(m_Query.FieldByName('strStartTmisStation').AsString);
        pJieShiRec^.strEndTmisStation := Trim(m_Query.FieldByName('strEndTmisStation').AsString);

        lst.Add(pJieShiRec);
        m_Query.Next;
    end;
    m_Query.close;
end;

//功能：揭示信息的添加
//异常：执行失败会有异常抛出

procedure TJieShiTableOperate.Insert(lstData: Tlist);
var
    I: Integer;
    JieShiInfo: RJieShiRecDB;
begin
    if not Assigned(lstData) then
    begin
        raise Exception.Create('lstData没有正确创建！');
    end;

    m_Query.Close;
    m_Query.SQL.Text := Format('select * from %s', [m_TableName]);
    m_Query.Active := True;
    for I := 0 to lstData.Count - 1 do
    begin
        JieShiInfo := PRJieShiRec(lstData[I])^;
        m_Query.Append;
        RecordToTable(m_Query, JieShiInfo);
        m_Query.Post;
    end;
    m_Query.Close;
end;

procedure TJieShiTableOperate.RecordToTable(var qryJieShi: Tadoquery;
    JieShiInfo: RJieShiRecDB);
begin
    qryJieShi.FieldByName('nLineNO').AsString := JieShiInfo.nLineNO;
    qryJieShi.FieldByName('bUpDownType').AsString := JieShiInfo.bUpDownType;
    qryJieShi.FieldByName('nStationNO').AsString := JieShiInfo.nStationNO;
    qryJieShi.FieldByName('nPos_Begin').AsString := JieShiInfo.nPos_Begin;
    qryJieShi.FieldByName('nPos_End').AsString := JieShiInfo.nPos_End;
    qryJieShi.FieldByName('dtStartDate').AsString := JieShiInfo.dtStartDate;
    qryJieShi.FieldByName('dtStartTime').AsString := JieShiInfo.dtStartTime;
    qryJieShi.FieldByName('dtEndDate').AsString := JieShiInfo.dtEndDate;
    qryJieShi.FieldByName('dtEndTime').AsString := JieShiInfo.dtEndTime;
    qryJieShi.FieldByName('nSpeedLimit').AsString := JieShiInfo.nSpeedLimit;
    qryJieShi.FieldByName('jstType').AsString := JieShiInfo.jstType;
    qryJieShi.FieldByName('nCommandNO').AsString := JieShiInfo.nCommandNO;
    qryJieShi.FieldByName('nGWLineNO').AsString := JieShiInfo.nGWLineNO;
    qryJieShi.FieldByName('nRepeatNO').AsString := JieShiInfo.nRepeatNO;
    qryJieShi.FieldByName('nGwUpdownType').AsString := JieShiInfo.nGwUpdownType;
    qryJieShi.FieldByName('nDirection').AsString := JieShiInfo.nDirection;
    qryJieShi.FieldByName('nLineType').AsString := JieShiInfo.nLineType;
    qryJieShi.FieldByName('jstLb').AsString := JieShiInfo.jstLb;
    qryJieShi.FieldByName('nPos_BeginCL').AsString := JieShiInfo.nPos_BeginCL;
    qryJieShi.FieldByName('nPos_BeginID').AsString := JieShiInfo.nPos_BeginID;
    qryJieShi.FieldByName('nPos_EndCL').AsString := JieShiInfo.nPos_EndCL;
    qryJieShi.FieldByName('nPos_EndID').AsString := JieShiInfo.nPos_EndID;
    qryJieShi.FieldByName('nSpeedLimitLength').AsString := JieShiInfo.nSpeedLimitLength;
    qryJieShi.FieldByName('nSpeedLimitKc').AsString := JieShiInfo.nSpeedLimitKc;
    qryJieShi.FieldByName('nSpeedLimitHc').AsString := JieShiInfo.nSpeedLimitHc;
    qryJieShi.FieldByName('nTrainType').AsString := JieShiInfo.nTrainType;
    qryJieShi.FieldByName('Dstamp').AsString := JieShiInfo.Dstamp;

    qryJieShi.FieldByName('strGWLineName').AsString := JieShiInfo.strGWLineName;
    qryJieShi.FieldByName('strStartTmisStation').AsString := JieShiInfo.strStartTmisStation;
    qryJieShi.FieldByName('strEndTmisStation').AsString := JieShiInfo.strEndTmisStation;
end;

procedure TJieShiTableOperate.Updata(Conditions: TObjectList; var lst: TList);
var
    I: Integer;
    JieShiInfo: RJieShiRecDB;
begin
    SelectByConditions(Conditions, m_TableName);
    for I := 0 to lst.Count - 1 do
    begin
        JieShiInfo := PRJieShiRec(lst[I])^;
        if m_Query.Locate('ID', JieShiInfo.nID, []) then
        begin
            m_Query.Edit;
            RecordToTable(m_Query, JieShiInfo);
            m_Query.Post;
        end;
    end;
    m_Query.Close;

end;

end.
