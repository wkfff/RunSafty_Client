unit uQryFilter;

interface
uses Classes, SysUtils;
type

////////////////////////////////////////////////////////////////////////////////
/// TQryFilter 查询过滤器基类   Version 1.0.0.622
////////////////////////////////////////////////////////////////////////////////

    TSelectCondition = class
    public
        function GetFilterSQLText(): string; virtual; abstract;
    end;

////////////////////////////////////////////////////////////////////////////////
/// TJwdIDCondition 机务段号过滤器  按机务段号进行筛选
////////////////////////////////////////////////////////////////////////////////

    TJwdIDCondition = class(TSelectCondition)
    public
        constructor Create(JwdID: Integer);
    public
        function GetFilterSQLText(): string; override;
    protected
        m_jwdId: Integer;
    end;



    TJwdIdConditonEx = class(TSelectCondition)
    public
        constructor Create(JwdID: Integer);
    public
        function GetFilterSQLText(): string; override;
    protected
        m_jwdId: Integer;

    end;

////////////////////////////////////////////////////////////////////////////////
/// TYyqdIDCondition 运用区段过滤器  按运用区段进行筛选
////////////////////////////////////////////////////////////////////////////////

    TYyqdIDCondition = class(TSelectCondition)
    public
        constructor Create(YyqdID: Integer);
    public
        function GetFilterSQLText(): string; override;
    protected
        m_YyqdID: Integer;
    end;

////////////////////////////////////////////////////////////////////////////////
/// TLineNameCondition  线路名称过滤器  按线路名称进行筛选
////////////////////////////////////////////////////////////////////////////////

    TLineNameCondition = class(TSelectCondition)
    public
        constructor Create(sLineName: String);
    public
        function GetFilterSQLText(): string; override;
    protected
        m_LineName: String;
    end;
////////////////////////////////////////////////////////////////////////////////
/// TDDMLIDCondition  命令号过滤器  按命令号进行筛选
////////////////////////////////////////////////////////////////////////////////
    TDDMLIDCondition = class(TSelectCondition)
    public
        constructor Create(OrderID: Integer);
    public
        function GetFilterSQLText(): string; override;
    protected
        m_nOrderID: Integer;
    end;
    ////////////////////////////////////////////////////////////////////////////////
    /// TDDMLBeginDateCondition  开始时间过滤器  按开始时间进行筛选
    ////////////////////////////////////////////////////////////////////////////////
    TDDMLBeginDateCondition = class(TSelectCondition)
    public
       constructor Create(BeginDate : TDateTime;compareFlag:Integer);//compareFlag为比较方式，0为=，1为>=，2为<=
    public
        function GetFilterSQLText(): string; override;
    protected
        FBeginDate: TDateTime;
        FcompareFlag : Integer;
    end;


    ////////////////////////////////////////////////////////////////////////////////
    /// TDDMLEndDateCondition  结束时间过滤器  按结束时间进行筛选
    ////////////////////////////////////////////////////////////////////////////////
    TDDMLEndDateCondition = class(TSelectCondition)
    public
       constructor Create(AEndDate : TDateTime;ACompareFlag:Integer);//compareFlag为比较方式，0为=，1为>=，2为<=
    public
        function GetFilterSQLText(): string; override;
    protected
        FEndDate: TDateTime;
        FcompareFlag : Integer;
    end;




implementation


{ TJwdIDCondition }

constructor TJwdIDCondition.Create(JwdID: Integer);
begin
    m_jwdId := JwdID;
end;

function TJwdIDCondition.GetFilterSQLText: string;
begin
    Result := Format('(m_nJWDID = ''%d'')', [m_jwdId]);
end;

{ TYyqdIDCondition }

constructor TYyqdIDCondition.Create(YyqdID: Integer);
begin
    m_YYQDID := YyqdID;
end;

function TYyqdIDCondition.GetFilterSQLText: string;
begin
    Result := Format('(m_nYyqdId = ''%d'')', [m_YYQDID]);
end;

{ TLineNameCondition }

constructor TLineNameCondition.Create(sLineName: String);
begin
  m_LineName := sLineName;
end;

function TLineNameCondition.GetFilterSQLText: string;
begin
  Result := Format('(m_strXLName = ''%s'')', [m_LineName]);
end;

{ TJwdIdConditonEx }

constructor TJwdIdConditonEx.Create(JwdID: Integer);
begin
    m_jwdId := JwdID;
end;

function TJwdIdConditonEx.GetFilterSQLText: string;
begin
    Result := Format('(m_nID = ''%d'')', [m_jwdId]);
end;

{ TDDMLIDCondition }

constructor TDDMLIDCondition.Create(OrderID: Integer);
begin
    m_nOrderID := OrderID;
end;

function TDDMLIDCondition.GetFilterSQLText: string;
begin
  Result := Format('(m_nOrderID = ''%d'')', [m_nOrderID]);
end;

{ TDDMLBeginDateCondition }

constructor TDDMLBeginDateCondition.Create(BeginDate: TDateTime;
  compareFlag: Integer);
begin
  FBeginDate := BeginDate;
  FCompareFlag := compareFlag;
end;

function TDDMLBeginDateCondition.GetFilterSQLText: string;
var
  TempFieldName : String;
begin
  TempFieldName := 'CAST(CONVERT(varchar(100), m_tStartDate, 23) + '+QuotedStr(' ')+' + CONVERT(varchar(100),'+
                              'm_tStartTime, 24) AS datetime)';

  case FCompareFlag of
    0 : Result := '('+TempFieldName+' = '+QuotedStr(DateTimeToStr(FBeginDate))+')';
    1 : Result := '('+TempFieldName+' >= '+QuotedStr(DateTimeToStr(FBeginDate))+')';
    2 : Result := '('+TempFieldName+' <= '+QuotedStr(DateTimeToStr(FBeginDate))+')';
  end;

end;

{ TDDMLEndDateCondition }

constructor TDDMLEndDateCondition.Create(AEndDate: TDateTime;
  ACompareFlag: Integer);
begin
  FEndDate := AEndDate;
  FCompareFlag := ACompareFlag;
end;

function TDDMLEndDateCondition.GetFilterSQLText: string;
var
  TempFieldName : String;
begin
  TempFieldName := 'CAST(CONVERT(varchar(100), m_tEndDate, 23)+'+QuotedStr(' ')+'+CONVERT(varchar(100),'+
                              'm_tEndTime, 24) AS datetime)';
  case FCompareFlag of
    0 : Result := '('+TempFieldName+' = '+QuotedStr(DateTimeToStr(FEndDate))+')';
    1 : Result := '('+TempFieldName+' >= '+QuotedStr(DateTimeToStr(FEndDate))+')';
    2 : Result := '('+TempFieldName+' <= '+QuotedStr(DateTimeToStr(FEndDate))+')';
  end;
end;

end.

