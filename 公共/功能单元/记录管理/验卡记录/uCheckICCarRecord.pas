unit uCheckICCarRecord;

interface
uses
  Classes, SysUtils,uTFSystem,Contnrs;
type
  /////////////////////////////////
  ///  类名:TCheckICCarRecord
  ///  说明:验卡记录
  /////////////////////////////////
  TCheckICCarRecord = class
  public
    GUID : String;
    {乘务员ID}
    strTrainmanGUID : String;
    {验卡时间}
    dtCreateTime : TDateTime;
    {验卡结果}
    strCheckResult : String;
    {揭示数量}
    nJSCount : Integer;
    {特殊揭示数量}
    nTsJsCount : Integer;
    {工作流ID}
    strWorkID : String;
    {区域ID}
    strAreaGUID : String;
    {记录ID}
    nRecordID : Integer;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TCheckICCarRecordList
  /// 说明:验卡记录列表
  //////////////////////////////////////////////////////////////////////////////
  TCheckICCarRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCheckICCarRecord;
    procedure SetItem(Index: Integer; CheckICCarRecord: TCheckICCarRecord);
  public
    function Add(Obj: TCheckICCarRecord): Integer;
    property Items[Index: Integer]: TCheckICCarRecord read GetItem write SetItem;
  end;


implementation

{ TCheckICCarRecordList }

function TCheckICCarRecordList.Add(Obj: TCheckICCarRecord): Integer;
begin
  Result := inherited Add(Obj);
end;

function TCheckICCarRecordList.GetItem(Index: Integer): TCheckICCarRecord;
begin
  Result := TCheckICCarRecord(inherited GetItem(Index));
end;

procedure TCheckICCarRecordList.SetItem(Index: Integer;
  CheckICCarRecord : TCheckICCarRecord);
begin
  inherited SetItem(Index,CheckICCarRecord);
end;

end.
