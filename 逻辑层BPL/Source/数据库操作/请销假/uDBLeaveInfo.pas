unit uDBLeaveInfo;

interface
uses
  ADODB, uTFSystem, uLeaveListInfo,uSaftyEnum,uTrainman;
type


  TRsDBLeaveInfo = class(TDBOperate)
  private
    procedure ADOQueryToDataOnFollowLeave(ADOQuery: TADOQuery; out FollowLeaveDetail: RRsFollowLeaveDetail);

    procedure ADOQueryToDataOnCancelLeave(ADOQuery: TADOQuery; out CancelLeaveDetail: RRsCancelLeaveDetail);

    procedure ADOQueryToDataOnAskLeaveDetail(ADOQuery: TADOQuery; out AskLeaveDetail: RRsAskLeaveDetail);

    procedure DataToADOQueryOnAskLeaveDetail(out ADOQuery: TADOQuery; AskLeaveDetail: RRsAskLeaveDetail);

    procedure ADOQueryToDataOnValidAskLeave(ADOQuery: TADOQuery; out AskLeave: RRsAskLeave);

    procedure DataToADOQueryOnAskLeave(out ADOQuery: TADOQuery; AskLeave: RRsAskLeave);

    procedure ADOQueryToDataOnLeaveType(ADOQuery: TADOQuery; out LeaveType: RRsLeaveType);

    procedure DataToADOQueryOnLeaveType(out ADOQuery: TADOQuery; LeaveType: RRsLeaveType);

    procedure ADOQueryToDataOnLeaveClass(ADOQuery: TADOQuery; out LeaveClass: RRsLeaveClass);

    procedure DataToADOQueryOnFollowLeave(out ADOQuery: TADOQuery; FollowLeaveDetail: RRsFollowLeaveDetail);

    procedure DataToADOQueryOnCancelLeave(out ADOQuery: TADOQuery; CancelLeaveDetail: RRsCancelLeaveDetail);

    procedure ADOQueryToDataOnAskLeaveWithType(ADOQuery: TADOQuery; out AskLeaveWithType: RRsAskLeaveWithType);
  public
    function GetCancelLeaveDetail(strAskLeaveGUID: string; out CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;

    function GetAskLeaveDetail(strAskLeaveGUID: string; out AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;

    //查询所有请假类型
    function QueryLeaveTypes(out LeaveTypeArray: TRsLeaveTypeArray; out ErrMsg: string): boolean;

    //通过指定的请假类型名称获取请假类型信息
    function GetLeaveType(strTypeName: string; out LeaveType: RRsLeaveType; out bExist: boolean; out ErrMsg: string): boolean;

    //获取全部请假类别
    function GetLeaveClasses(out LeaveClassArray: TRsLeaveClassArray; out ErrMsg: string): boolean;

    //添加请假类型
    function AddLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;

    //指定一个请假GUID，返回一个最新的续假记录的时间
    function GetValidFollowLeave(strAskLeaveGUID: string; out EndTime: TDateTime; out bExist: boolean; out ErrMsg: string): boolean;

    //判断是否存在某种请假类型组合
    function ExistLeaveType(LeaveType: RRsLeaveType): boolean;

    //判断是否存在某种请假类型组合，在编辑请假类型时使用
    function ExistLeaveTypeWhenEdit(LeaveType: RRsLeaveType): boolean;

    //删除请假类型
    function DeleteLeaveType(LeaveID: string; out ErrMsg: string): boolean;

    //更新请假类型
    function UpdateLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;

    //添加请假详情
    function AddAskLeaveDetail(AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;

    //添加续假详情
    function AddFollowLeaveDetail(AskLeaveDetail: RRsFollowLeaveDetail; out ErrMsg: string): boolean;

    //添加销假详情
    function AddCancelLeaveDetail(CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;

    //给定一个工号，判断该职工是否有未销假的记录
    function CheckWhetherAskLeaveByID(strTrainManID: string; out bExist: boolean; out ErrMsg: string): boolean;

    //添加请假记录
    function AddAskLeave(AskLeave: RRsAskLeave; out ErrMsg: string): boolean;
    //撤销请假记录
    procedure CancelLeave(AskLeaveGUID : string);

    //给定一个工号，返回该职工的请假信息以及所请假的请假类型名称
    function GetValidAskLeaveInfoByID(strTrainManID: string; out AskLeave: RRsAskLeave; out strTypeName: string; out bExist: boolean; out ErrMsg: string): boolean;

    //传入查询条件，该函数返回相应的请假记录
    procedure GetLeaves(strBeginDateTime: string;strEndDateTime: string;strNumber: string;strType: string;
      strStatus: string; strWorkShopGUID: string; strPost: string; strGroup: string; out AskLeaveWithTypeArray: TRsAskLeaveWithTypeArray);

    function GetFollowLeaveDetails(strAskLeaveGUID: string; out FollowLeaveDetailArray: TRsFollowLeaveDetailArray; out ErrMsg: string): boolean;
  end;
implementation
uses
  SysUtils, DB;

{ TDBUserInfo }

procedure TRsDBLeaveInfo.ADOQueryToDataOnLeaveClass(ADOQuery: TADOQuery; out LeaveClass: RRsLeaveClass);
begin
  with ADOQuery do
  begin
    LeaveClass.nClassID := FieldByName('nClassID').AsInteger;
    LeaveClass.strClassName := FieldByName('strClassName').AsString;
  end;
end;

procedure TRsDBLeaveInfo.DataToADOQueryOnLeaveType(out ADOQuery: TADOQuery; LeaveType: RRsLeaveType);
begin
  with ADOQuery do
  begin
    FieldByName('strTypeGUID').AsString := LeaveType.strTypeGUID;
    FieldByName('strTypeName').AsString := LeaveType.strTypeName;
    FieldByName('nClassID').AsInteger := LeaveType.nClassID;
  end;
end;

procedure TRsDBLeaveInfo.DataToADOQueryOnAskLeaveDetail(out ADOQuery: TADOQuery; AskLeaveDetail: RRsAskLeaveDetail);
begin
  with ADOQuery do
  begin
    FieldByName('strAskLeaveDetailGUID').AsString := AskLeaveDetail.strAskLeaveDetailGUID;
    FieldByName('strAskLeaveGUID').AsString := AskLeaveDetail.strAskLeaveGUID;
    FieldByName('strMemo').AsString := AskLeaveDetail.strMemo;
    FieldByName('dBeginTime').AsDateTime := AskLeaveDetail.dtBeginTime;
    FieldByName('dEndTime').AsDateTime := AskLeaveDetail.dtEndTime;
    FieldByName('strProverID').AsString := AskLeaveDetail.strProverID;
    FieldByName('strProverName').AsString := AskLeaveDetail.strProverName;
    FieldByName('dCreateTime').AsDateTime := AskLeaveDetail.dtCreateTime;
    FieldByName('strDutyUserID').AsString := AskLeaveDetail.strDutyUserID;
    FieldByName('strDutyUserName').AsString := AskLeaveDetail.strDutyUserName;
    FieldByName('strSiteID').AsString := AskLeaveDetail.strSiteID;
    FieldByName('strSiteName').AsString := AskLeaveDetail.strSiteName;
    FieldByName('nValidWay').AsInteger := Ord(AskLeaveDetail.Verify);
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnAskLeaveDetail(ADOQuery: TADOQuery; out AskLeaveDetail: RRsAskLeaveDetail);
begin
  with ADOQuery do
  begin
    AskLeaveDetail.strAskLeaveDetailGUID := FieldByName('strAskLeaveDetailGUID').AsString;
    AskLeaveDetail.strAskLeaveGUID := FieldByName('strAskLeaveGUID').AsString;
    AskLeaveDetail.strMemo := FieldByName('strMemo').AsString;
    AskLeaveDetail.dtBeginTime := FieldByName('dBeginTime').AsDateTime;
    AskLeaveDetail.dtEndTime := FieldByName('dEndTime').AsDateTime;
    AskLeaveDetail.strProverID := FieldByName('strProverID').AsString;
    AskLeaveDetail.strProverName := FieldByName('strProverName').AsString;
    AskLeaveDetail.dtCreateTime := FieldByName('dCreateTime').AsDateTime;
    AskLeaveDetail.strDutyUserID := FieldByName('strDutyUserID').AsString;
    AskLeaveDetail.strDutyUserName := FieldByName('strDutyUserName').AsString;
    AskLeaveDetail.strSiteID := FieldByName('strSiteID').AsString;
    AskLeaveDetail.strSiteName := FieldByName('strSiteName').AsString;
    AskLeaveDetail.Verify  := TRsRegisterFlag(FieldByName('nValidWay').AsInteger);

  end;
end;

procedure TRsDBLeaveInfo.DataToADOQueryOnFollowLeave(out ADOQuery: TADOQuery; FollowLeaveDetail: RRsFollowLeaveDetail);
begin
  with ADOQuery do
  begin
    FieldByName('strFollowLeaveGUID').AsString := FollowLeaveDetail.strFollowLeaveGUID;
    FieldByName('strAskLeaveGUID').AsString := FollowLeaveDetail.strAskLeaveGUID;
    FieldByName('dEndTime').AsDateTime := FollowLeaveDetail.dtEndTime;
    FieldByName('strMemo').AsString := FollowLeaveDetail.strMemo;
    FieldByName('strProverID').AsString := FollowLeaveDetail.strProverID;
    FieldByName('strProverName').AsString := FollowLeaveDetail.strProverName;
    FieldByName('dCreateTime').AsDateTime := FollowLeaveDetail.dtCreateTime;
    FieldByName('strDutyUserID').AsString := FollowLeaveDetail.strDutyUserID;
    FieldByName('strDutyUserName').AsString := FollowLeaveDetail.strDutyUserName;
    FieldByName('strSiteID').AsString := FollowLeaveDetail.strSiteID;
    FieldByName('strSiteName').AsString := FollowLeaveDetail.strSiteName;
    FieldByName('nValidWay').AsInteger := Ord(FollowLeaveDetail.Verify);
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnFollowLeave(ADOQuery: TADOQuery; out FollowLeaveDetail: RRsFollowLeaveDetail);
begin
  with ADOQuery do
  begin
    FollowLeaveDetail.strFollowLeaveGUID := FieldByName('strFollowLeaveGUID').AsString;
    FollowLeaveDetail.strAskLeaveGUID := FieldByName('strAskLeaveGUID').AsString;
    FollowLeaveDetail.dtEndTime := FieldByName('dEndTime').AsDateTime;
    FollowLeaveDetail.strMemo := FieldByName('strMemo').AsString;
    FollowLeaveDetail.strProverID := FieldByName('strProverID').AsString;
    FollowLeaveDetail.strProverName := FieldByName('strProverName').AsString;
    FollowLeaveDetail.dtCreateTime := FieldByName('dCreateTime').AsDateTime;
    FollowLeaveDetail.strDutyUserID := FieldByName('strDutyUserID').AsString;
    FollowLeaveDetail.strDutyUserName := FieldByName('strDutyUserName').AsString;
    FollowLeaveDetail.strSiteID := FieldByName('strSiteID').AsString;
    FollowLeaveDetail.strSiteName := FieldByName('strSiteName').AsString;
    FollowLeaveDetail.Verify := TRsRegisterFlag(FieldByName('nValidWay').asInteger);

  end;
end;

procedure TRsDBLeaveInfo.DataToADOQueryOnCancelLeave(out ADOQuery: TADOQuery; CancelLeaveDetail: RRsCancelLeaveDetail);
begin
  with ADOQuery do
  begin
    FieldByName('strCancelLeaveGUID').AsString := CancelLeaveDetail.strCancelLeaveGUID;
    FieldByName('strAskLeaveGUID').AsString := CancelLeaveDetail.strAskLeaveGUID;
    FieldByName('strProverID').AsString := CancelLeaveDetail.strProverID;
    FieldByName('strProverName').AsString := CancelLeaveDetail.strProverName;
    FieldByName('dtCancelTime').AsDateTime := CancelLeaveDetail.dtCancelTime;
    FieldByName('dCreateTime').AsDateTime := CancelLeaveDetail.dtCreateTime;
    FieldByName('strDutyUserID').AsString := CancelLeaveDetail.strDutyUserID;
    FieldByName('strDutyUserName').AsString := CancelLeaveDetail.strDutyUserName;
    FieldByName('strSiteID').AsString := CancelLeaveDetail.strSiteID;
    FieldByName('strSiteName').AsString := CancelLeaveDetail.strSiteName;
    FieldByName('nValidWay').AsInteger := Ord(CancelLeaveDetail.Verify);
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnCancelLeave(ADOQuery: TADOQuery; out CancelLeaveDetail: RRsCancelLeaveDetail);
begin
  with ADOQuery do
  begin
    CancelLeaveDetail.strCancelLeaveGUID := FieldByName('strCancelLeaveGUID').AsString;
    CancelLeaveDetail.strAskLeaveGUID := FieldByName('strAskLeaveGUID').AsString;
    CancelLeaveDetail.strProverID := FieldByName('strProverID').AsString;
    CancelLeaveDetail.strProverName := FieldByName('strProverName').AsString;
    CancelLeaveDetail.dtCancelTime := FieldByName('dtCancelTime').AsDateTime;
    CancelLeaveDetail.dtCreateTime := FieldByName('dCreateTime').AsDateTime;
    CancelLeaveDetail.strDutyUserID := FieldByName('strDutyUserID').AsString;
    CancelLeaveDetail.strDutyUserName := FieldByName('strDutyUserName').AsString;
    CancelLeaveDetail.strSiteID := FieldByName('strSiteID').AsString;
    CancelLeaveDetail.strSiteName := FieldByName('strSiteName').AsString;
    CancelLeaveDetail.Verify := TRsRegisterFlag(FieldByName('nValidWay').asInteger);
    
  end;
end;

procedure TRsDBLeaveInfo.DataToADOQueryOnAskLeave(out ADOQuery: TADOQuery; AskLeave: RRsAskLeave);
begin
  with ADOQuery do
  begin
    FieldByName('strAskLeaveGUID').AsString := AskLeave.strAskLeaveGUID;
    FieldByName('strTrainManID').AsString := AskLeave.strTrainManID;
    FieldByName('dBeginTime').AsDateTime := AskLeave.dtBeginTime;
    FieldByName('dEndTime').AsDateTime := AskLeave.dtEndTime;
    FieldByName('strLeaveTypeGUID').AsString := AskLeave.strLeaveTypeGUID;
    FieldByName('nStatus').AsInteger := AskLeave.nStatus;
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnLeaveType(ADOQuery: TADOQuery; out LeaveType: RRsLeaveType);
begin
  with ADOQuery do
  begin
    LeaveType.strTypeGUID := FieldByName('strTypeGUID').AsString;
    LeaveType.strTypeName := FieldByName('strTypeName').AsString;
    LeaveType.nClassID := FieldByName('nClassID').AsInteger;
    LeaveType.strClassName := FieldByName('strClassName').AsString;
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnValidAskLeave(ADOQuery: TADOQuery; out AskLeave: RRsAskLeave);
begin

  with ADOQuery do
  begin
    AskLeave.strAskLeaveGUID := FieldByName('strAskLeaveGUID').AsString;
    AskLeave.strTrainManID := FieldByName('strTrainManID').AsString;
    AskLeave.dtBeginTime := FieldByName('dBeginTime').AsDateTime;
    AskLeave.dtEndTime := FieldByName('dEndTime').AsDateTime;
    AskLeave.strLeaveTypeGUID := FieldByName('strLeaveTypeGUID').AsString;
    AskLeave.nStatus := FieldByName('nStatus').AsInteger;
  end;
end;

procedure TRsDBLeaveInfo.ADOQueryToDataOnAskLeaveWithType(ADOQuery: TADOQuery; out AskLeaveWithType: RRsAskLeaveWithType);
begin

  with ADOQuery do
  begin
    AskLeaveWithType.AskLeave.strAskLeaveGUID := FieldByName('strAskLeaveGUID').AsString;
    AskLeaveWithType.AskLeave.strTrainManID := FieldByName('strTrainManID').AsString;      
    AskLeaveWithType.AskLeave.strTrainmanName := FieldByName('strTrainmanName').AsString;
    AskLeaveWithType.AskLeave.dtBeginTime := FieldByName('dBeginTime').AsDateTime;
    AskLeaveWithType.AskLeave.dtEndTime := FieldByName('dEndTime').AsDateTime;
    AskLeaveWithType.AskLeave.strLeaveTypeGUID := FieldByName('strLeaveTypeGUID').AsString;
    AskLeaveWithType.AskLeave.nStatus := FieldByName('nStatus').AsInteger;
    AskLeaveWithType.strTypeName := FieldByName('strTypeName').AsString;
    
    //liulin add 20131029   
    AskLeaveWithType.AskLeave.strAskProverID := FieldByName('strAskProverID').AsString;
    AskLeaveWithType.AskLeave.strAskProverName := FieldByName('strAskProverName').AsString;
    AskLeaveWithType.AskLeave.dtAskCreateTime := FieldByName('dtAskCreateTime').AsDateTime;
    AskLeaveWithType.AskLeave.strAskDutyUserName := FieldByName('strAskDutyUserName').AsString;   
    AskLeaveWithType.AskLeave.strMemo := FieldByName('strMemo').AsString;
    AskLeaveWithType.AskLeave.nPostID := TRsPost(FieldByName('nPostID').AsInteger);
    AskLeaveWithType.AskLeave.strGuideGroupName := FieldByName('strGuideGroupName').AsString;
  end;
end;

function TRsDBLeaveInfo.AddLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_LeaveType where 1 = 2 ';
        Sql.Text := strSql;

        Open;
        Append;
        DataToADOQueryOnLeaveType(adoQuery, LeaveType);
        Post;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;

    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.AddAskLeaveDetail(AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_AskLeaveDetail where 1 = 2 ';
        Sql.Text := strSql;

        Open;
        Append;
        DataToADOQueryOnAskLeaveDetail(adoQuery, AskLeaveDetail);
        Post;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;

    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.DeleteLeaveType(LeaveID: string; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'delete from TAB_LeaveMgr_LeaveType where strTypeGUID = %s ';
        strSql := Format(strSql, [QuotedStr(LeaveID)]);
        Sql.Text := strSql;
        ExecSQL;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.GetLeaveClasses(out LeaveClassArray: TRsLeaveClassArray; out ErrMsg: string): boolean;
var
  strSql: string;
  LeaveClass: RRsLeaveClass;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_LeaveClass';
        Sql.Text := strSql;

        Open;
        while not eof do
        begin
          ADOQueryToDataOnLeaveClass(adoQuery, LeaveClass);
          SetLength(LeaveClassArray, length(LeaveClassArray) + 1);
          LeaveClassArray[length(LeaveClassArray) - 1] := LeaveClass;
          next;
        end;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;



function TRsDBLeaveInfo.GetLeaveType(strTypeName: string; out LeaveType: RRsLeaveType; out bExist: boolean; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from VIEW_LeaveMgr_AllLeaveTypes where strTypeName like %s';
        strSql := Format(strSql, [QuotedStr('%' + strTypeName + '%')]);
        Sql.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          bExist := false;
          result := true;
          exit;
        end
        else
        begin
          bExist := true;
        end;
        ADOQueryToDataOnLeaveType(adoQuery, LeaveType);
        bExist := true;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.QueryLeaveTypes(out LeaveTypeArray: TRsLeaveTypeArray; out ErrMsg: string): boolean;
var
  strSql: string;
  LeaveType: RRsLeaveType;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from VIEW_LeaveMgr_AllLeaveTypes where 1=1';
        Sql.Text := strSql;
        Open;
        while not eof do
        begin
          ADOQueryToDataOnLeaveType(adoQuery, LeaveType);
          SetLength(LeaveTypeArray, length(LeaveTypeArray) + 1);
          LeaveTypeArray[length(LeaveTypeArray) - 1] := LeaveType;
          next;
        end;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.ExistLeaveType(LeaveType: RRsLeaveType): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_LeaveMgr_LeaveType where strTypeName = %s';
      strSql := Format(strSql, [QuotedStr(LeaveType.strTypeName)]);

      Sql.Text := strSql;

      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.ExistLeaveTypeWhenEdit(LeaveType: RRsLeaveType): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_LeaveMgr_LeaveType where strTypeName = %s and nClassID=%d';
      strSql := Format(strSql, [QuotedStr(LeaveType.strTypeName), LeaveType.nClassID]);

      Sql.Text := strSql;

      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.AddFollowLeaveDetail(AskLeaveDetail: RRsFollowLeaveDetail; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_FollowLeaveDetail where 1 = 2 ';
        Sql.Text := strSql;
        Open;
        Append;
        DataToADOQueryOnFollowLeave(adoQuery, AskLeaveDetail);
        Post;
        strSql := 'update TAB_LeaveMgr_AskLeave set nStatus = 2,dEndTime = %s where strAskLeaveGUID = %s';
        strSql := Format(strSql, [
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',AskLeaveDetail.dtEndTime)),
          QuotedStr(AskLeaveDetail.strAskLeaveGUID)
          ]);
        Sql.Text := strSql;
        ExecSQL;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;

    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.AddCancelLeaveDetail(CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_CancelLeaveDetail where 1 = 2 ';
        Sql.Text := strSql;

        Open;
        Append;
        DataToADOQueryOnCancelLeave(adoQuery, CancelLeaveDetail);
        Post;

        strSql := 'update TAB_LeaveMgr_AskLeave set nStatus = 3, dEndTime = %s where strAskLeaveGUID = %s';
        strSql := Format(strSql, [QuotedStr(DateTimeToStr(CancelLeaveDetail.dtCancelTime)), QuotedStr(CancelLeaveDetail.strAskLeaveGUID)]);
        Sql.Text := strSql;
        ExecSql;

        strSql := 'update TAB_Org_Trainman set nTrainmanState = %d where strTrainmanNumber = %s ';
        strSql := Format(strSql,[Ord(tsReady),QuotedStr(CancelLeaveDetail.strTrainManID)]);
        SQL.Text := strSql;
        ExecSql;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;

    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.UpdateLeaveType(LeaveType: RRsLeaveType; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  try
    result := false;
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_LeaveType where strTypeGUID = %s';
        strSql := Format(strSql, [QuotedStr(LeaveType.strTypeGUID)]);
        Sql.Text := strSql;
        Open;
        Edit;
        DataToADOQueryOnLeaveType(adoQuery, LeaveType);
        Post;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;


function TRsDBLeaveInfo.AddAskLeave(AskLeave: RRsAskLeave; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_AskLeave where 1 = 2 ';
        Sql.Text := strSql;
        Open;
        Append;
        DataToADOQueryOnAskLeave(adoQuery, AskLeave);
        Post;
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID1= %s  ' +
          ' where strTrainmanGUID1 = (select top 1 strTrainmanGUID from TAB_Org_Trainman where strTrainmanNumber = %s)';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(AskLeave.strTrainManID)]);
        SQL.Text := strSql;
        ExecSQL;
        
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID2= %s  ' +
          ' where strTrainmanGUID2 = (select top 1 strTrainmanGUID from TAB_Org_Trainman where strTrainmanNumber = %s)';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(AskLeave.strTrainManID)]);
        SQL.Text := strSql;
        ExecSQL;

        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID3= %s  ' +
          ' where strTrainmanGUID3 = (select top 1 strTrainmanGUID from TAB_Org_Trainman where strTrainmanNumber = %s)';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(AskLeave.strTrainManID)]);
        SQL.Text := strSql;
        ExecSQL;  

        strSql := 'update TAB_Org_Trainman set nTrainmanState = %d where strTrainmanNumber = %s ';
        strSql := Format(strSql,[Ord(tsUnRuning),QuotedStr(AskLeave.strTrainManID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;

    result := true;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBLeaveInfo.CancelLeave(AskLeaveGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_LeaveMgr_AskLeave set nStatus = 10000 where strAskLeaveGUID = %s';
      strSql := Format(strSql,[QuotedStr(AskLeaveGUID)]);      
      Sql.Text := strSql;
      ExecSQL;

      strSql := 'update tab_org_trainman set nTrainmanState = %d where strTrainmanNumber = ' +
        ' (select strTrainManID from TAB_LeaveMgr_AskLeave where strAskLeaveGUID = %s)';
      strSql := Format(strSql,[Ord(tsReady),QuotedStr(AskLeaveGUID)]);      
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.CheckWhetherAskLeaveByID(strTrainManID: string; out bExist: boolean; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select top 1 * from TAB_LeaveMgr_AskLeave where strTrainManID = %s and nStatus < 3';
        strSql := Format(strSql, [QuotedStr(strTrainManID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          bExist := false;
        end
        else
        begin
          bExist := true;
        end;
        Result := true;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;


function TRsDBLeaveInfo.GetValidFollowLeave(strAskLeaveGUID: string; out EndTime: TDateTime; out bExist: boolean; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select top 1 dEndTime from TAB_LeaveMgr_FollowLeaveDetail where strAskLeaveGUID = %s order by dEndTime desc';
        strSql := Format(strSql, [QuotedStr(strAskLeaveGUID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          bExist := false;
          result := true;
          exit;
        end
        else
        begin
          bExist := true;
        end;

        EndTime := FieldByName('dEndTime').AsDateTime;
        bExist := true;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.GetValidAskLeaveInfoByID(strTrainManID: string; out AskLeave: RRsAskLeave; out strTypeName: string; out bExist: boolean; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from VIEW_LeaveMgr_AskLeaveWithTypeName where strTrainManID = %s and nStatus < 3';
        strSql := Format(strSql, [QuotedStr(strTrainManID)]);
        Sql.Text := strSql;
        Open;                                                                
        if RecordCount = 0 then
        begin
          bExist := false;
          result := true;
          exit;
        end
        else
        begin
          bExist := true;
        end;

        ADOQueryToDataOnValidAskLeave(adoQuery, AskLeave);
        strTypeName := ADOQuery.FieldByName('strTypeName').AsString;
        bExist := true;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBLeaveInfo.GetLeaves(strBeginDateTime: string;strEndDateTime: string;strNumber: string;strType: string;
      strStatus, strWorkShopGUID: string; strPost: string; strGroup: string; out AskLeaveWithTypeArray: TRsAskLeaveWithTypeArray);
var
  strSql: string;
  AskLeaveWithType: RRsAskLeaveWithType;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select A.*,B.strTrainmanName,B.nPostID,D.strGuideGroupName,C.strProverID strAskProverID,' +
        ' C.strProverName strAskProverName,C.strDutyUserName strAskDutyUserName,' +
        ' C.dCreateTime dtAskCreateTime,C.strMemo strMemo from VIEW_LeaveMgr_AskLeaveWithTypeName A' +
        ' left join TAB_Org_Trainman B on A.strTrainmanID=B.strTrainmanNumber' +
        ' left join TAB_LeaveMgr_AskLeaveDetail C on A.strAskLeaveGUID=C.strAskLeaveGUID' +   
        ' left join TAB_Org_GuideGroup D on B.strGuideGroupGUID=D.strGuideGroupGUID' +
        ' where 1=1 ';
      strSql := Format(strSql,[]);
      if Trim(strBeginDateTime) <> '' then
      begin
        strSql := strSql + ' and A.dBeginTime>=%s ';
        strSql := Format(strSql,[QuotedStr(strBeginDateTime)]);
      end;
      if Trim(strEndDateTime) <> '' then
      begin
        strSql := strSql + ' and A.dBeginTime<=%s ';
        strSql := Format(strSql,[QuotedStr(strEndDateTime)]);
      end;
      if Trim(strNumber) <> '' then
      begin
        strSql := strSql + Format(' and A.strTrainmanID like %s ', [QuotedStr('%'+strNumber+'%')]);
      end;
      if Trim(strType) <> '' then
      begin
        strSql := strSql + Format(' and A.strLeaveTypeGUID=%s ', [QuotedStr(strType)]);
      end;       
      if Trim(strStatus) <> '' then
      begin
        strSql := strSql + Format(' and A.nStatus=%s ', [strStatus]);
      end;
      if Trim(strWorkShopGUID) <> '' then
      begin
        strSql := strSql + Format(' and B.strWorkShopGUID=%s ', [QuotedStr(strWorkShopGUID)]);
      end;    
      if Trim(strPost) <> '' then
      begin
        strSql := strSql + Format(' and B.nPostID=%s ', [strPost]);
      end;
      if Trim(strGroup) <> '' then
      begin
        strSql := strSql + Format(' and B.strGuideGroupGUID=%s ', [QuotedStr(strGroup)]);
      end;
      strSql := strSql + ' order by A.dBeginTime desc';
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToDataOnAskLeaveWithType(adoQuery, AskLeaveWithType);
        SetLength(AskLeaveWithTypeArray, length(AskLeaveWithTypeArray) + 1);
        AskLeaveWithTypeArray[length(AskLeaveWithTypeArray) - 1] := AskLeaveWithType;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.GetAskLeaveDetail(strAskLeaveGUID: string; out AskLeaveDetail: RRsAskLeaveDetail; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_AskLeaveDetail where strAskLeaveGUID=%s';
        strSql := Format(strSql, [QuotedStr(strAskLeaveGUID)]);
        Sql.Text := strSql;
        Open;
        ADOQueryToDataOnAskLeaveDetail(adoQuery, AskLeaveDetail);
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.GetCancelLeaveDetail(strAskLeaveGUID: string; out CancelLeaveDetail: RRsCancelLeaveDetail; out ErrMsg: string): boolean;
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_CancelLeaveDetail where strAskLeaveGUID=%s';
        strSql := Format(strSql, [QuotedStr(strAskLeaveGUID)]);
        Sql.Text := strSql;
        Open;
        ADOQueryToDataOnCancelLeave(adoQuery, CancelLeaveDetail);
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLeaveInfo.GetFollowLeaveDetails(strAskLeaveGUID: string; out FollowLeaveDetailArray: TRsFollowLeaveDetailArray; out ErrMsg: string): boolean;
var
  strSql: string;
  FollowLeaveDetail: RRsFollowLeaveDetail;
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try

    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        strSql := 'select * from TAB_LeaveMgr_FollowLeaveDetail where strAskLeaveGUID=%s';
        strSql := Format(strSql, [QuotedStr(strAskLeaveGUID)]);
        Sql.Text := strSql;

        Open;
        while not eof do
        begin
          ADOQueryToDataOnFollowLeave(adoQuery, FollowLeaveDetail);
          SetLength(FollowLeaveDetailArray, length(FollowLeaveDetailArray) + 1);
          FollowLeaveDetailArray[length(FollowLeaveDetailArray) - 1] := FollowLeaveDetail;
          next;
        end;
      end;
    except
      on e: Exception do
      begin
        ErrMsg := e.Message;
        exit;
      end;
    end;
    result := true;
  finally
    adoQuery.Free;
  end;
end;
end.

