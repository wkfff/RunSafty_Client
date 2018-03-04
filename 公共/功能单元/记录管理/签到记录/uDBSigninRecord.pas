unit uDBSigninRecord;

interface
uses uTFSystem, uSigninRecord, SysUtils, ADODB, DB;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBSigninRecord
  /// 说明:签到记录数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBSigninRecord = Class(TDBOperate)
  private
    {功能:将记录保存到对象中}
    procedure CopyDataToObject(ADOQuery:TADOQuery;Item:TSigninRecord);
    {功能:将记录保存到数据库中}
    procedure CopyDataToDB(ADOQuery:TADOQuery;Item:TSigninRecord);
  public
    {功能:保存签到记录}
    procedure SaveSigninRecord(Item:TSigninRecord;TrainmanIndex : integer);
  end;

implementation
uses uDBPlan,uPlan;

{ TDBSigninRecord }

procedure TDBSigninRecord.CopyDataToDB(ADOQuery: TADOQuery;
  Item: TSigninRecord);
{功能:将记录保存到数据库中}
begin
  ADOQuery.FieldByName('strGUID').AsString := Item.strGUID;
  ADOQuery.FieldByName('strTrainmanGUID').AsString := Item.strTrainmanGUID;
  ADOQuery.FieldByName('strPlanGUID').AsString := Item.strPlanGUID;
  ADOQuery.FieldByName('dtSigninTime').AsDateTime := Item.dtSigninTime;
  ADOQuery.FieldByName('nVerifyID').AsInteger := Item.nVerifyID;
  ADOQuery.FieldByName('strDutyGUID').AsString := Item.strDutyGUID;
  ADOQuery.FieldByName('strAreaGUID').AsString := Item.strAreaGUID;
end;

procedure TDBSigninRecord.CopyDataToObject(ADOQuery: TADOQuery;
  Item: TSigninRecord);
{功能:将记录保存到对象中}
begin
  Item.strGUID := ADOQuery.FieldByName('strGUID').AsString;
  Item.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
  Item.strPlanGUID := ADOQuery.FieldByName('strPlanGUID').AsString;
  Item.dtSigninTime := ADOQuery.FieldByName('dtSigninTime').AsDateTime;
  Item.nVerifyID := ADOQuery.FieldByName('nVerifyID').AsInteger;
  Item.strDutyGUID := ADOQuery.FieldByName('strDutyGUID').AsString;
  Item.strAreaGUID := ADOQuery.FieldByName('strAreaGUID').AsString;  
end;

procedure TDBSigninRecord.SaveSigninRecord(Item : TSigninRecord;TrainmanIndex : integer);
{功能:保存签到记录}
var
  DBPlan : TDBPlan;
  ADOQuery : TADOQuery;
begin
  ADOQuery := NewADOQuery;
  DBPlan := TDBPlan.Create(m_ADOConnection);
  ADOQuery.SQL.Text := 'Select * from TAB_WORK_Signin where strGUID = ' +
      QuotedStr(Item.strGUID);
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      ADOQuery.Edit
    else
      ADOQuery.Append;
    CopyDataToDB(ADOQuery,Item);
    ADOQuery.Post;
    if Item.strPlanGUID <> '' then
    begin
      DBPlan.UpdatePlanState(Item.strPlanGUID,Item.strTrainmanGUID,PLANSTATE_SIGNIN,TrainmanIndex);
    end;
  finally
    DBPlan.Free;
    ADOQuery.Free;
  end;
end;

end.
