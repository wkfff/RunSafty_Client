unit uDBLocalAccess;

interface

uses
  ADODB, Variants, uTFSystem, DateUtils, uGuideSign;
  
type
  TRsDBLocalAccess = class(TDBOperate)
  private
    //从adoquery中读取数据放入RRsGuideSign结构中
    class procedure ADOQueryToData(var GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
    //将数据从RRsGuideSign结构中放入到ADOQUERY中
    procedure DataToADOQuery(GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
  public                
    //功能：添加签到信息
    procedure AddGuideSign(GuideSign: RRsGuideSign);
    //功能：查询签到信息
    procedure QueryGuideSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray); 
    //获取指定GUID的签到信息
    function  GetGuideSign(strGuideSignGUID: string; out GuideSign: RRsGuideSign) : boolean;
  public
    //获取所有车间
    procedure GetWorkShop(out SimpleInfoArray : TRsSimpleInfoArray);  
    //根据车间，获取指导队
    procedure GetGuideGroup(strWorkShopGUID: string; out SimpleInfoArray : TRsSimpleInfoArray);
  end;

implementation

uses
  SysUtils,Classes,DB,ZKFPEngXUtils;
  
{ TDBTrainman }
                       
class procedure TRsDBLocalAccess.ADOQueryToData(var GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
begin
  GuideSign.strGuideSignGUID := adoQuery.FieldByName('strGuideSignGUID').AsString;
  GuideSign.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  GuideSign.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  GuideSign.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
  GuideSign.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
  GuideSign.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
  GuideSign.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
  GuideSign.dtSignTime := adoQuery.FieldByName('dtSignTime').AsDateTime;
  GuideSign.nSignFlag :=  TRsSignFlag(adoQuery.FieldByName('nSignFlag').AsInteger);
end;

procedure TRsDBLocalAccess.DataToADOQuery(GuideSign: RRsGuideSign; ADOQuery: TADOQuery);
begin
  if GuideSign.strGuideSignGUID <> '' then adoQuery.FieldByName('strGuideSignGUID').AsString := GuideSign.strGuideSignGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := GuideSign.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := GuideSign.strTrainmanName;
  adoQuery.FieldByName('strWorkShopGUID').AsString := GuideSign.strWorkShopGUID;
  adoQuery.FieldByName('strGuideGroupGUID').AsString := GuideSign.strGuideGroupGUID;
  if GuideSign.dtSignTime >= OneSecond then adoQuery.FieldByName('dtSignTime').AsDateTime := GuideSign.dtSignTime;
  adoQuery.FieldByName('nSignFlag').AsInteger := Ord(GuideSign.nSignFlag);
end;

//==============================================================================

procedure TRsDBLocalAccess.AddGuideSign(GuideSign: RRsGuideSign);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Sign_GuideGroup where  1=2 ';
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataToADOQuery(GuideSign, adoQuery);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBLocalAccess.QueryGuideSign(QueryGuideSign: RRsQueryGuideSign; out GuideSignArray: TRsGuideSignArray);
{功能:根据ID获取乘务员信息}
var
  i : integer;
  strSql, sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From VIEW_Sign_GuideGroup %s order by dtSignTime desc ';

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
      sqlCondition := sqlCondition + ' and (dtSignTime >= %s and dtSignTime <= %s)';
      sqlCondition := Format(sqlCondition,[QuotedStr(DateTimeToStr(dtSignTimeBegin)),QuotedStr(DateTimeToStr(dtSignTimeEnd))]);
    end;
    
    if (Ord(nSignFlag) > 0) then
    begin
      sqlCondition := sqlCondition + ' and nSignFlag = %d';
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
   
function TRsDBLocalAccess.GetGuideSign(strGuideSignGUID: string; out GuideSign: RRsGuideSign): boolean;
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

//==============================================================================

procedure TRsDBLocalAccess.GetWorkShop(out SimpleInfoArray : TRsSimpleInfoArray);
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
        
procedure TRsDBLocalAccess.GetGuideGroup(strWorkShopGUID: string; out SimpleInfoArray : TRsSimpleInfoArray);
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

end.
