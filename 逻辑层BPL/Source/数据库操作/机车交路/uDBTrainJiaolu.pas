unit uDBTrainJiaolu;

interface
uses
  ADODB,uTrainJiaolu,uTFSystem,uStation;
type
  //////////////////////////////////////////////////////////////////////////////
  ///������·������
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainJiaolu = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery;var TrainJiaoLu : RRsTrainJiaolu);
    procedure ADOQueryToQuJianData(ADOQuery : TADOQuery;out ZheFanQuJian : RRsZheFanQuJian);
  public
    //���ܣ���ȡ������·��Ϣ
    class procedure GetDBTrainJiaolu(ADOConn : TADOConnection;out ADOQuery : TADOQuery);
    //���ܣ���ȡ����ε���������
    procedure GetTrainJiaoluArrayOfWorkShop(WorkShopGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //��ȡ���е�����
    procedure GetAllTrainJiaolu( out TrainJiaoluArray : TRsTrainJiaoluArray);
    //�����г��������ƻ�ȡ��Ӧ��GUID
    function  GetTrainJiaoluGUIDByName(TrainJiaoluName : string) : string;
    //��ȡ�г���·��Ϣ
    function  GetTrainJiaolu(TrainJiaoluGUID : string;TrainJiaolu : RRsTrainJiaolu) : boolean;
    //��ȡָ���ͻ��˹�Ͻ���г�������Ϣ
    procedure GetTrainJiaoluArrayOfSite(SiteGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //��ȡָ���ͻ��˹�Ͻ�������г�������Ϣ
    procedure GetAllTrainJiaoluArrayOfSite(SiteGUID : string; out TrainJiaoluArray : TRsTrainJiaoluArray);
    //��ȡָ��������·���۷�����
    procedure GetZFQJOfTrainJiaolu(TrainJiaoluGUID : string; out ZheFanQuJianArray : TRsZheFanQuJianArray);
    //��ȡָ��������·�ĳ�վ��Ϣ
    procedure GetStationOfTrainJiaolu(TrainJiaoluGUID : string; out StationArray : TRsStationArray);
    //�жϽ�·�Ƿ����ڿͻ��˹�Ͻ
    function IsJiaoLuInSite(TrainJiaoluGUID,SiteGUID : string): Boolean;

  end;
implementation

uses DB,SysUtils;

{ TDBTrainJiaolu }

procedure TRsDBTrainJiaolu.ADOQueryToData(ADOQuery: TADOQuery;
  var TrainJiaoLu: RRsTrainJiaolu);
begin
  with ADOQuery do
  begin
    TrainJiaolu.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainJiaolu.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainJiaolu.strStartStation := FieldByName('strStartStation').AsString;
    TrainJiaolu.strEndStation := FieldByName('strEndStation').AsString;
    TrainJiaolu.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    TrainJiaolu.bIsBeginWorkFP := FieldByName('bIsBeginWorkFP').ASInteger;
    TrainJiaolu.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainJiaolu.strEndStationName := FieldByName('strEndStationName').AsString;
  end;
end;

procedure TRsDBTrainJiaolu.ADOQueryToQuJianData(ADOQuery: TADOQuery;
  out ZheFanQuJian: RRsZheFanQuJian);
begin
  with ADOQuery do
  begin
    ZheFanQuJian.strZFQJGUID := FieldByName('strZFQJGUID').AsString;
    ZheFanQuJian.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    ZheFanQuJian.nQuJianIndex := FieldByName('nQuJianIndex').AsInteger;
    ZheFanQuJian.strBeginStationGUID := FieldByName('strBeginStationGUID').AsString;
    ZheFanQuJian.strBeginStationName := FieldByName('strBeginStationName').AsString;
    ZheFanQuJian.strEndStationGUID := FieldByName('strEndStationGUID').AsString;
    ZheFanQuJian.strEndStationName := FieldByName('strEndStationName').AsString;
  end;
end;

procedure TRsDBTrainJiaolu.GetAllTrainJiaolu(
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu ';
      strSql := Format(strSql,[]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainJiaolu.GetAllTrainJiaoluArrayOfSite(SiteGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu where  ' +
      ' strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite ' +
      ' where strSiteGUID =%s union select strSubTrainJiaoluGUID as strTrainJiaoluGUID '  +
      ' from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in ' +
      ' (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s)) and (bIsDir = 0 or bIsDir is null)';
      strSql := Format(strSql,[QuotedStr(SiteGUID),QuotedStr(SiteGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery, trainJiaolu );
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainJiaolu.GetDBTrainJiaolu(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery);
var
  strSql : string;  
begin
  strSql := 'select * from TAB_Base_TrainJiaolu where order by strLineGUID,strTrainJiaoluName';
  adoQuery := TADOQuery.Create(nil);
  with adoQuery do
  begin
    Connection := ADOConn;
    Sql.Text := strSql;
    Open;
  end;
end;

procedure TRsDBTrainJiaolu.GetStationOfTrainJiaolu(TrainJiaoluGUID: string;
  out StationArray: TRsStationArray);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  SetLength(StationArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_StationInTrainJiaolu where  strTrainJiaoluGUID = %s order by nSortID';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin        
        SetLength(StationArray,length(StationArray) + 1);
        StationArray[length(StationArray) - 1].strStationGUID := FieldByName('strStationGUID').AsString;
        StationArray[length(StationArray) - 1].strStationName := FieldByName('strStationName').AsString;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainJiaolu.GetTrainJiaolu(TrainJiaoluGUID: string;
  TrainJiaolu: RRsTrainJiaolu): boolean;
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
      strSql := 'select * from VIEW_Base_TrainJiaolu where  strTrainJiaoluGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToData(adoQuery,TrainJiaolu);
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainJiaolu.GetTrainJiaoluArrayOfSite(SiteGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaoluInSite where  strSiteGUID = %s ';
      strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(WorkShopGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  trainJiaolu : RRsTrainJiaolu;
begin
  SetLength(TrainJiaoluArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainJiaolu where  strWorkShopGUID = %s ';
      strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(adoQuery,trainJiaolu);
        SetLength(TrainJiaoluArray,length(TrainJiaoluArray) + 1);
        TrainJiaoluArray[length(TrainJiaoluArray) - 1] := trainJiaolu;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainJiaolu.GetTrainJiaoluGUIDByName(
  TrainJiaoluName: string): string;
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
      strSql := 'select strTrainJiaoluGUID from TAB_Base_TrainJiaolu where  strTrainJiaoluName = %s ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluName)]);
      SQL.Text := strSql;
      Open;
      if RecordCount  > 0 then
        Result := FieldByName('strTrainJiaoluGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainJiaolu.GetZFQJOfTrainJiaolu(TrainJiaoluGUID: string;
  out ZheFanQuJianArray: TRsZheFanQuJianArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  zfqj : RRsZheFanQuJian;
begin
  SetLength(ZheFanQuJianArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_ZFQJ where  strTrainJiaoluGUID = %s order by nQuJianIndex';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToQuJianData(adoQuery,zfqj);
        SetLength(ZheFanQuJianArray,length(ZheFanQuJianArray) + 1);
        ZheFanQuJianArray[length(ZheFanQuJianArray) - 1] := zfqj;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainJiaolu.IsJiaoLuInSite(TrainJiaoluGUID,
  SiteGUID: string): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s ' +
        'and strTrainJiaoluGUID = %1:s union ' +
        'select strTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strSubTrainJiaoLuGUID in ' +
        '(select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s) ' +
        'union select strSubTrainJiaoLuGUID as strTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in ' +
        '(select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s and strSubTrainJiaoLuGUID = %1:s)  ';

      strSql := 'select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s ' +
              ' and strTrainJiaoluGUID = %1:s ' +
              ' union  ' +
              ' select strSubTrainJiaoLuGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in  ' +
              ' (select strTrainJiaoluGUID  from TAB_Base_TrainJiaoluInSite where strSiteGUID = %0:s) ' +
              '   and strSubTrainJiaoLuGUID = %1:s ' ;
      strSql := Format(strSql,[QuotedStr(SiteGUID),QuotedStr(TrainJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      Result := adoQuery.RecordCount > 0;
      Close;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
