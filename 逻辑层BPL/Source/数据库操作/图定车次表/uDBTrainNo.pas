unit uDBTrainNo;

interface
uses
  adodb,uTrainNo,uTFSystem,uSaftyEnum;
type
  TRsDBTrainNo = class(TDBOperate)
  private
    procedure ADOQueryToData(ADOQuery : TADOQuery; OUT TrainNo:RRsTrainNo);
    procedure DataToADOQuery(TrainNo : RRsTrainNo;ADOQuery : TADOQuery);
  public
    //根据GUID获取图定车次表信息
    function GetTrainNo(TrainNoGUID : string ; out TrainNo : RRsTrainNo) : boolean;
    //添加图定车次信息
    procedure Add(TrainNo : RRsTrainNo);
    //修改图定车次信息
    procedure Update(TrainNo : RRsTrainNo);
    //删除图定车次信息
    procedure Delete(TrainNoGUID : string);
    //获取指定机车交路的图定车次信息
    procedure GetTrainNos(TrainJiaoluGUID : string;out TrainNoArray : TRsTrainNoArray);
  end;
implementation
uses
  SysUtils, DB,Forms;
{ TDBTrainNo }

procedure TRsDBTrainNo.Add(TrainNo : RRsTrainNo);
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  strSql := 'Select * from TAB_Base_TrainNo where strGUID = %s';
  strSql := Format(strSql,[QuotedStr(strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      DataToADOQuery(TrainNo,ADOQuery);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainNo.ADOQueryToData(ADOQuery: TADOQuery; out TrainNo: RRsTrainNo);
begin
  with ADOQuery do
  begin
    TrainNo.strGUID := FieldByName('strGUID').AsString;
    TrainNo.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainNo.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainNo.strTrainNo := FieldByName('strTrainNo').AsString;
    TrainNo.dtStartTime :=  FieldByName('dtStartTime').Value;
    TrainNo.dtRealStartTime :=  0;
    if not FieldByName('dtRealStartTime').IsNull then
      TrainNo.dtRealStartTime := FieldByName('dtRealStartTime').Value;
    TrainNo.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainNo.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainNo.strStartStation := FieldByName('strStartStation').AsString;
    TrainNo.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainNo.strEndStation := FieldByName('strEndStation').AsString;
    TrainNo.strEndStationName := FieldByName('strEndStationName').AsString;
    TrainNo.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').AsInteger);
    TrainNo.nPlanType := TRsPlanType(FieldByName('nPlanType').AsInteger);
    TrainNo.nDragType := TRsDragType(FieldByName('nDragType').AsInteger);
    TrainNo.nKeHuoID := TRsKehuo(FieldByName('nKeHuoID').asInteger);
    TrainNo.nRemarkType := TRsPlanRemarkType(FieldByName('nRemarkType').AsInteger);
    TrainNo.strRemark := FieldByName('strRemark').AsString;
    TrainNo.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    TrainNo.strCreateSiteGUID := FieldByName('strCreateSiteGUID').AsString;
    TrainNo.strCreateUserGUID := FieldByName('strCreateUserGUID').AsString;
  end;
end;

procedure TRsDBTrainNo.DataToADOQuery(TrainNo: RRsTrainNo; ADOQuery: TADOQuery);
begin
with ADOQuery do
  begin
    FieldByName('strGUID').AsString := TrainNo.strGUID;
    FieldByName('strTrainTypeName').AsString := TrainNo.strTrainTypeName;
    FieldByName('strTrainNumber').AsString := TrainNo.strTrainNumber;
    FieldByName('strTrainNo').AsString := TrainNo.strTrainNo;
    FieldByName('dtStartTime').AsDateTime := TrainNo.dtStartTime;
    FieldByName('dtRealStartTime').AsDateTime := TrainNo.dtRealStartTime;
    FieldByName('strTrainJiaoluGUID').AsString := TrainNo.strTrainJiaoluGUID;
    FieldByName('strStartStation').AsString := TrainNo.strStartStation;
    FieldByName('strEndStation').AsString := TrainNo.strEndStation;
    FieldByName('nTrainmanTypeID').AsInteger := Ord(TrainNo.nTrainmanTypeID);
    FieldByName('nPlanType').AsInteger := Ord(TrainNo.nPlanType);
    FieldByName('nDragType').AsInteger := Ord(TrainNo.nDragType);
    FieldByName('nKeHuoID').AsInteger := Ord(TrainNo.nKeHuoID);
    FieldByName('nRemarkType').AsInteger := Ord(TrainNo.nRemarkType);
    FieldByName('strRemark').AsString := TrainNo.strRemark;
    FieldByName('dtCreateTime').AsDateTime := TrainNo.dtCreateTime;
    FieldByName('strCreateSiteGUID').AsString := TrainNo.strCreateSiteGUID;
    FieldByName('strCreateUserGUID').AsString := TrainNo.strCreateUserGUID;
  end;
end;

procedure TRsDBTrainNo.Delete(TrainNoGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'delete from TAB_Base_TrainNo where strGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainNoGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainNo.GetTrainNo(TrainNoGUID : string ; out TrainNo : RRsTrainNo) : boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  strSql := 'Select * from VIEW_Base_TrainNo where strGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainNoGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToData(adoQuery,TrainNo);
      result := true;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainNo.GetTrainNos(TrainJiaoluGUID : string;out TrainNoArray : TRsTrainNoArray);
var
  strSql : string;
  adoQuery : TADOQuery;
  trainNo : RRsTrainNo;
begin
  strSql := 'Select * from VIEW_Base_TrainNo where 1=1 ';
  if TrainJiaoluGUID <> '' then
  begin
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);
  end;
  strSql := strSql + '  order by dtStartTime';
  SetLength(TrainNoArray,0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        ADOQueryToData(ADOQuery,trainNo);
        SetLength(TrainNoArray,length(TrainNoArray) + 1);
        TrainNoArray[length(TrainNoArray) - 1] :=trainNo; 
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainNo.Update(TrainNo : RRsTrainNo);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'Select * from TAB_Base_TrainNo where strGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainNo.strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Edit;
      DataToADOQuery(TrainNo,ADOQuery);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
