unit uDBGuideSign;

interface

uses
  ADODB, Variants, uTFSystem, DateUtils, uTrainman, uGuideSign, uSaftyEnum;
  
type
  TRsDBGuideSign = class(TDBOperate)
  private
    //从adoquery中读取数据放入RRsGuideSign结构中
    class procedure ADOQueryToData(var GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
    //将数据从RRsGuideSign结构中放入到ADOQUERY中
    procedure DataToADOQuery(GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
  public
    //功能：添加签到信息
    procedure AddGuideSignIn(GuideSign: RRsGuideSign);     
    //功能：添加签退信息
    procedure AddGuideSignOut(GuideSign: RRsGuideSign);
    //功能：查询签到信息
    procedure QueryGuideSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray);     
    //功能：查询未签到信息
    procedure QueryGuideNotSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray);
    //获取指定GUID的签到信息
    function  GetGuideSign(strGuideSignGUID: string; out GuideSign: RRsGuideSign) : boolean;
    //获取指定司机工号的签到信息
    function  GetTrainmanGuideSign(strTrainmanNumber, strGuideGroupGUID: string; out GuideSign: RRsGuideSign) : boolean;
  public
    //获取所有车间
    procedure GetWorkShop(out SimpleInfoArray : TRsSimpleInfoArray);
    //获取车间GUID
    function GetWorkShopGUID(strGuideGroupGUID: string): string;
    //获取指导队名称
    function GetGuideGroupName(strGuideGroupGUID: string): string;

    //获取车间名称－指导队名称
    function GetWorkShop_GuideGroup(strGuideGroupGUID: string): string;
    //根据车间，获取指导队
    procedure GetGuideGroup(strWorkShopGUID: string; out SimpleInfoArray : TRsSimpleInfoArray);
    //更新司机表中的指导队GUID
    procedure UpdateGuideGroupByTrainmanNumber(strTrainmanNumber, strGuideGroupGUID: string; bNotUpdateExist: boolean=true);
    procedure UpdateGuideGroupByTrainmanGUID(strTrainmanGUID, strGuideGroupGUID: string);
    procedure UpdatePostGroupByTrainmanGUID(strTrainmanGUID: string; nPostID: integer);
    //根据查询条件和过滤条件，得到司机列表
    procedure GetTrainmanList(QueryTrainman, FilterTrainman: RRsQueryTrainman; out TrainmanArray: TRsTrainmanArray);
    procedure GetSrcTrainmanListByPost(strWorkShopGUID: string; nPostID: integer; out TrainmanArray: TRsTrainmanArray);
    procedure GetSelTrainmanListByPost(strWorkShopGUID: string; nPostID: integer; out TrainmanArray: TRsTrainmanArray);

  end;

implementation

uses
  SysUtils,Classes,DB,ZKFPEngXUtils;
  
{ TDBTrainman }
                       
class procedure TRsDBGuideSign.ADOQueryToData(var GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
begin
  GuideSign.strGuideSignGUID := adoQuery.FieldByName('strGuideSignGUID').AsString;
  GuideSign.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  GuideSign.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  GuideSign.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
  GuideSign.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
  GuideSign.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
  GuideSign.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
  GuideSign.dtSignInTime := adoQuery.FieldByName('dtSignInTime').AsDateTime;
  GuideSign.nSignInFlag :=  TRsSignFlag(adoQuery.FieldByName('nSignInFlag').AsInteger);
  GuideSign.dtSignOutTime := adoQuery.FieldByName('dtSignOutTime').AsDateTime;
  GuideSign.nSignOutFlag :=  TRsSignFlag(adoQuery.FieldByName('nSignOutFlag').AsInteger);
end;

procedure TRsDBGuideSign.DataToADOQuery(GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
begin
  if GuideSign.strGuideSignGUID <> '' then adoQuery.FieldByName('strGuideSignGUID').AsString := GuideSign.strGuideSignGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := GuideSign.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := GuideSign.strTrainmanName;
  adoQuery.FieldByName('strWorkShopGUID').AsString := GuideSign.strWorkShopGUID;
  adoQuery.FieldByName('strGuideGroupGUID').AsString := GuideSign.strGuideGroupGUID;
  if GuideSign.dtSignInTime >= OneSecond then adoQuery.FieldByName('dtSignInTime').AsDateTime := GuideSign.dtSignInTime;
  adoQuery.FieldByName('nSignInFlag').AsInteger := Ord(GuideSign.nSignInFlag);     
  if GuideSign.dtSignOutTime >= OneSecond then adoQuery.FieldByName('dtSignOutTime').AsDateTime := GuideSign.dtSignOutTime;
  adoQuery.FieldByName('nSignOutFlag').AsInteger := Ord(GuideSign.nSignOutFlag);
end;

//==============================================================================

procedure TRsDBGuideSign.AddGuideSignIn(GuideSign: RRsGuideSign);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Sign_GuideGroup where 1=2 ';
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      if GuideSign.strGuideSignGUID <> '' then FieldByName('strGuideSignGUID').AsString := GuideSign.strGuideSignGUID;
      FieldByName('strTrainmanNumber').AsString := GuideSign.strTrainmanNumber;
      FieldByName('strTrainmanName').AsString := GuideSign.strTrainmanName;
      FieldByName('strWorkShopGUID').AsString := GuideSign.strWorkShopGUID;
      FieldByName('strGuideGroupGUID').AsString := GuideSign.strGuideGroupGUID;
      if GuideSign.dtSignInTime >= OneSecond then FieldByName('dtSignInTime').AsDateTime := GuideSign.dtSignInTime;
      FieldByName('nSignInFlag').AsInteger := Ord(GuideSign.nSignInFlag);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;
         
procedure TRsDBGuideSign.AddGuideSignOut(GuideSign: RRsGuideSign);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Sign_GuideGroup where strGuideSignGUID=%s ';
      strSql := Format(strSql,[QuotedStr(GuideSign.strGuideSignGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      if GuideSign.dtSignOutTime >= OneSecond then FieldByName('dtSignOutTime').AsDateTime := GuideSign.dtSignOutTime;
      FieldByName('nSignOutFlag').AsInteger := Ord(GuideSign.nSignOutFlag);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBGuideSign.QueryGuideSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray);
var
  i : integer;
  strSql, sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select * From VIEW_Sign_GuideGroup %s order by dtSignInTime desc ';
  {$region '组合查询条件'}
  sqlCondition :=  ' where 1=1 ';
  with QueryGuideSign do
  begin
    if strTrainmanName <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanName = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainmanName)])
    end;
    if (strWorkShopGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strWorkShopGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
    end;
    if (strGuideGroupGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strGuideGroupGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
    end;
    if (dtSignTimeBegin >= OneSecond) and (dtSignTimeEnd >= OneSecond) then
    begin
      sqlCondition := sqlCondition + ' and (dtSignInTime >= %s and dtSignInTime <= %s)';
      sqlCondition := Format(sqlCondition,[QuotedStr(DateTimeToStr(dtSignTimeBegin)),QuotedStr(DateTimeToStr(dtSignTimeEnd))]);
    end;
    if (Ord(nSignFlag) > 0) then
    begin
      sqlCondition := sqlCondition + ' and nSignInFlag = %d';
      sqlCondition := Format(sqlCondition,[Ord(nSignFlag)]);
    end;   
    if strTrainmanNumber <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanNumber like %s';
      sqlCondition := Format(sqlCondition,[QuotedStr('%'+strTrainmanNumber+'%')])
    end;
  end;
  {$endregion '组合查询条件'}
  strSql := Format(strSql,[sqlCondition]);


  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(GuideSignArray, RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(GuideSignArray[i], adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
           
procedure TRsDBGuideSign.QueryGuideNotSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray);
var
  i : integer;
  strSql, sqlCondition : String;
  adoQuery : TADOQuery;
begin
  sqlCondition :=  ' where 1=1 ';
  with QueryGuideSign do
  begin
    if (dtSignTimeBegin >= OneSecond) and (dtSignTimeEnd >= OneSecond) then
    begin
      sqlCondition := sqlCondition + ' and (dtSignInTime >= %s and dtSignInTime <= %s)';
      sqlCondition := Format(sqlCondition,[QuotedStr(DateTimeToStr(dtSignTimeBegin)),QuotedStr(DateTimeToStr(dtSignTimeEnd))]);
    end;
  end;

  strSql := Format('select strTrainmanNumber From VIEW_Sign_GuideGroup %s', [sqlCondition]);
  strSql := Format('select strTrainmanNumber,strTrainmanName from TAB_Org_Trainman where strGuideGroupGUID=%s and strTrainmanNumber not in (%s) order by strTrainmanNumber',
                    [QuotedStr(QueryGuideSign.strGuideGroupGUID), strSql]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(GuideSignArray, RecordCount);
      i := 0;
      while not eof do
      begin
        GuideSignArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        GuideSignArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBGuideSign.GetGuideSign(strGuideSignGUID: string; out GuideSign: RRsGuideSign): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Sign_GuideGroup where strGuideSignGUID = %s';
      strSql := Format(strSql,[QuotedStr(strGuideSignGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToData(GuideSign,adoQuery);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;
     
function TRsDBGuideSign.GetTrainmanGuideSign(strTrainmanNumber, strGuideGroupGUID: string; out GuideSign: RRsGuideSign): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from VIEW_Sign_GuideGroup where strTrainmanNumber=%s and strGuideGroupGUID=%s order by dtSignInTime desc';
      strSql := Format(strSql,[QuotedStr(strTrainmanNumber), QuotedStr(strGuideGroupGUID)]);
      SQL.Text := strSql;
      Open;
      if not eof then
      begin
        ADOQueryToData(GuideSign,adoQuery);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

//==============================================================================

procedure TRsDBGuideSign.GetWorkShop(out SimpleInfoArray : TRsSimpleInfoArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  SimpleInfo : RRsSimpleInfo;
begin
  SetLength(SimpleInfoArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_WorkShop order by strWorkShopName';
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        SimpleInfo.strGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        SimpleInfo.strName := adoQuery.FieldByName('strWorkShopName').AsString;

        SetLength(SimpleInfoArray,length(SimpleInfoArray) + 1);
        SimpleInfoArray[length(SimpleInfoArray) - 1] := SimpleInfo;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
        
function TRsDBGuideSign.GetWorkShopGUID(strGuideGroupGUID: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_GuideGroup where strGuideGroupGUID=%s';
      strSql := Format(strSql,[QuotedStr(strGuideGroupGUID)]);
      SQL.Text := strSql;
      Open;
      if not eof then
      begin
        result := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBGuideSign.GetGuideGroupName(strGuideGroupGUID: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := '';
  if strGuideGroupGUID = '' then exit;
  
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strGuideGroupName from TAB_Org_GuideGroup where strGuideGroupGUID=%s';
      strSql := Format(strSql,[QuotedStr(strGuideGroupGUID)]);
      SQL.Text := strSql;
      Open;
      if not eof then result := adoQuery.FieldByName('strGuideGroupName').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;
    
function TRsDBGuideSign.GetWorkShop_GuideGroup(strGuideGroupGUID: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := '';
  if strGuideGroupGUID = '' then exit;
  
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select A.strGuideGroupName,B.strWorkShopName from TAB_Org_GuideGroup A left join TAB_Org_WorkShop B on A.strWorkShopGUID=B.strWorkShopGUID';
      strSql := strSql + ' where A.strGuideGroupGUID=%s';
      strSql := Format(strSql,[QuotedStr(strGuideGroupGUID)]);
      SQL.Text := strSql;
      Open;
      if not eof then
      begin
        result := adoQuery.FieldByName('strWorkShopName').AsString + ' · ' + adoQuery.FieldByName('strGuideGroupName').AsString;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBGuideSign.GetGuideGroup(strWorkShopGUID: string; out SimpleInfoArray : TRsSimpleInfoArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  SimpleInfo : RRsSimpleInfo;
begin
  SetLength(SimpleInfoArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_GuideGroup where strWorkShopGUID=%s order by nid';
      strSql := Format(strSql,[QuotedStr(strWorkShopGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        SimpleInfo.strGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
        SimpleInfo.strName := adoQuery.FieldByName('strGuideGroupName').AsString;

        SetLength(SimpleInfoArray,length(SimpleInfoArray) + 1);
        SimpleInfoArray[length(SimpleInfoArray) - 1] := SimpleInfo;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
     
procedure TRsDBGuideSign.UpdateGuideGroupByTrainmanNumber(strTrainmanNumber, strGuideGroupGUID: string; bNotUpdateExist: boolean);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'update TAB_Org_Trainman set strGuideGroupGUID=%s where strTrainmanNumber=%s';
      if bNotUpdateExist then strSql := strSql + ' and (strGuideGroupGUID='''' or (strGuideGroupGUID is null))';
      strSql := Format(strSql,[QuotedStr(strGuideGroupGUID), QuotedStr(strTrainmanNumber)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;
  
procedure TRsDBGuideSign.UpdateGuideGroupByTrainmanGUID(strTrainmanGUID, strGuideGroupGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'update TAB_Org_Trainman set strGuideGroupGUID=%s where strTrainmanGUID=%s';
      strSql := Format(strSql,[QuotedStr(strGuideGroupGUID), QuotedStr(strTrainmanGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;
      
procedure TRsDBGuideSign.UpdatePostGroupByTrainmanGUID(strTrainmanGUID: string; nPostID: integer);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'update TAB_Org_Trainman set nPostID=%d where strTrainmanGUID=%s';
      strSql := Format(strSql,[nPostID, QuotedStr(strTrainmanGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBGuideSign.GetTrainmanList(QueryTrainman, FilterTrainman: RRsQueryTrainman; out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  //strSql := 'select strTrainmanGUID,strTrainmanNumber,strTrainmanName,strWorkShopGUID,strWorkShopName,strGuideGroupGUID,strGuideGroupName From VIEW_Org_Trainman %s order by strTrainmanNumber ';
  strSql := 'select A.strTrainmanGUID,A.strTrainmanNumber,A.strTrainmanName,A.strWorkShopGUID,B.strWorkShopName,A.strGuideGroupGUID,C.strGuideGroupName From Tab_Org_Trainman A';
  strSql := strSql + ' left join TAB_Org_WorkShop B on A.strWorkShopGUID=B.strWorkShopGUID';
  strSql := strSql + ' left join TAB_Org_GuideGroup C on A.strGuideGroupGUID=C.strGuideGroupGUID';
  strSql := strSql + ' %s order by strTrainmanNumber';

  sqlCondition :=  ' where 1=1 ';
  with QueryTrainman do
  begin
    if (strWorkShopGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and A.strWorkShopGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
    end;
    if (strGuideGroupGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and A.strGuideGroupGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
    end;
  end;       
  with FilterTrainman do
  begin
    if (strWorkShopGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and (A.strWorkShopGUID is null or A.strWorkShopGUID <> %s)';
      sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
    end;
    if (strGuideGroupGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and (A.strGuideGroupGUID is null or A.strGuideGroupGUID <> %s)';
      sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
    end;
  end;

  strSql := Format(strSql,[sqlCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        TrainmanArray[i].strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
        TrainmanArray[i].strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
        TrainmanArray[i].strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
      
procedure TRsDBGuideSign.GetSrcTrainmanListByPost(strWorkShopGUID: string; nPostID: integer; out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select A.strTrainmanGUID,A.strTrainmanNumber,A.strTrainmanName,A.strWorkShopGUID,B.strWorkShopName,A.nPostID From Tab_Org_Trainman A';
  strSql := strSql + ' left join TAB_Org_WorkShop B on A.strWorkShopGUID=B.strWorkShopGUID';
  strSql := strSql + ' %s order by A.strTrainmanNumber';

  sqlCondition :=  ' where 1=1 ';
  if (strWorkShopGUID <> '') then
  begin
    sqlCondition := sqlCondition + ' and A.strWorkShopGUID = %s';
    sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
  end;
  if (nPostID = 0) then
  begin
    sqlCondition := sqlCondition + ' and (A.nPostID is null or A.nPostID = 0)';
  end;

  if (nPostID >= 1) and (nPostID <= 3) then
  begin
    sqlCondition := sqlCondition + ' and (A.nPostID is null or A.nPostID <> %d)';
    sqlCondition := Format(sqlCondition,[nPostID])
  end;
 

  strSql := Format(strSql,[sqlCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        TrainmanArray[i].strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
        TrainmanArray[i].nPostID := TRsPost(adoQuery.FieldByName('nPostID').AsInteger);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
        
procedure TRsDBGuideSign.GetSelTrainmanListByPost(strWorkShopGUID: string; nPostID: integer; out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'select A.strTrainmanGUID,A.strTrainmanNumber,A.strTrainmanName,A.strWorkShopGUID,B.strWorkShopName,A.nPostID From Tab_Org_Trainman A';
  strSql := strSql + ' left join TAB_Org_WorkShop B on A.strWorkShopGUID=B.strWorkShopGUID';
  strSql := strSql + ' %s order by A.strTrainmanNumber';

  sqlCondition :=  ' where 1=1 ';
  if (strWorkShopGUID <> '') then
  begin
    sqlCondition := sqlCondition + ' and A.strWorkShopGUID = %s';
    sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
  end;
  if (nPostID >= 1) and (nPostID <= 3) then
  begin
    sqlCondition := sqlCondition + ' and A.nPostID = %d';
    sqlCondition := Format(sqlCondition,[nPostID])
  end;

  strSql := Format(strSql,[sqlCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strTrainmanGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        TrainmanArray[i].strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
        TrainmanArray[i].nPostID := TRsPost(adoQuery.FieldByName('nPostID').AsInteger);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.

