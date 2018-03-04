unit uSigninRecord;

interface
uses
  Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSigninRecord
  /// 说明:签到记录
  //////////////////////////////////////////////////////////////////////////////
  TSigninRecord = class
  public
    strGUID : String;
    {乘务员ID}
    strTrainmanGUID : String;
    {计划ID}
    strPlanGUID : String;
    {签到时间}
    dtSigninTime : TDateTime;
    {身份验证方式}
    nVerifyID : Integer;
    {值班员ID}
    strDutyGUID : String;
    {签到地点}
    strAreaGUID : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TSigninRecordList
  /// 说明:签到记录列表
  //////////////////////////////////////////////////////////////////////////////
  TSigninRecordList = Class(TObjectList)
  protected
    function GetItem(Index: Integer): TSigninRecord;
    procedure SetItem(Index: Integer; Item: TSigninRecord);
  public
  public
    function Add(Item: TSigninRecord): Integer;
    property Items[Index: Integer]: TSigninRecord read GetItem write SetItem; default;
  end;


implementation

{ TSigninRecordList }

function TSigninRecordList.Add(Item: TSigninRecord): Integer;
begin
  Result := inherited Add(Item);
end;

function TSigninRecordList.GetItem(Index: Integer): TSigninRecord;
begin
  Result := TSigninRecord(inherited GetItem(Index));
end;

procedure TSigninRecordList.SetItem(Index: Integer; Item: TSigninRecord);
begin
  inherited SetItem(Index,Item);
end;

end.
