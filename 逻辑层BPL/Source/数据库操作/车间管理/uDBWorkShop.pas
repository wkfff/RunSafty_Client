unit uDBWorkShop;

interface
uses
  ADODB,uTFSystem,uWorkShop;
type
  //车间数据库操作类
  TRsDBWorkShop = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;out WorkShop : RRsWorkShop);
  public
    //获取机务段下所有车间
    procedure GetWorkShopOfArea(AreaGUID : string;out WorkShopArray : TRsWorkShopArray);
    //根据车间名称获取对应的GUID
    function GetWorkShopGUIDByName(WorkShopName : string) : string;
    {功能:获取所有车间}
    procedure GetWorkShopOfSite(strSiteGUID:string;out workShopArray:TRsWorkShopArray);
  end;
implementation
uses
  SysUtils;
{ TDBWorkShop }

procedure TRsDBWorkShop.ADOQueryToData(ADOQuery: TADOQuery;
  out WorkShop: RRsWorkShop);
begin
  with ADOQuery do
  begin
    WorkShop.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    WorkShop.strAreaGUID := FieldByName('strAreaGUID').AsString;
    WorkShop.strWorkShopName := FieldByName('strWorkShopName').AsString;
  end;
end;

procedure TRsDBWorkShop.GetWorkShopOfSite(strSiteGUID:string;out workShopArray: TRsWorkShopArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  workShop : RRsWorkShop;
begin
  SetLength(WorkShopArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'SELECT DISTINCT strAreaGUID, strWorkShopName, strWorkShopGUID'
        + ' FROM VIEW_Base_TrainJiaoluInSite WHERE (strSiteGUID =:strSiteGUID) '
        + 'and strWorkShopGUID <> ''''  '
        + ' GROUP BY strWorkShopGUID, strWorkShopName, strAreaGUID '
        + ' ORDER BY strWorkShopName';
      SQL.Text := strSql;
      Parameters.ParamByName('strSiteGUID').Value := strSiteGUID;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,workShop);
        SetLength(WorkShopArray,length(WorkShopArray) + 1);
        WorkShopArray[length(WorkShopArray) - 1] := workShop;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBWorkShop.GetWorkShopGUIDByName(WorkShopName: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strWorkShopGUID from TAB_Org_WorkShop where  strWorkShopName = %s ';
      strSql := Format(strSql,[QuotedStr(WorkShopName)]);
      SQL.Text := strSql;
      Open;
      if RecordCount  > 0 then
        Result := FieldByName('strWorkShopGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkShop.GetWorkShopOfArea(AreaGUID: string;
  out WorkShopArray: TRsWorkShopArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  workShop : RRsWorkShop;
begin
  SetLength(WorkShopArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with  adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Org_WorkShop where strAreaGUID = %s order by strWorkShopName';
      strSql := Format(strSql,[QuotedStr(AreaGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,workShop);
        SetLength(WorkShopArray,length(WorkShopArray) + 1);
        WorkShopArray[length(WorkShopArray) - 1] := workShop;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
