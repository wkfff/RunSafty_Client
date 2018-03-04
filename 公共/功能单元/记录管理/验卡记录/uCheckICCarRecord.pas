unit uCheckICCarRecord;

interface
uses
  Classes, SysUtils,uTFSystem,Contnrs;
type
  /////////////////////////////////
  ///  ����:TCheckICCarRecord
  ///  ˵��:�鿨��¼
  /////////////////////////////////
  TCheckICCarRecord = class
  public
    GUID : String;
    {����ԱID}
    strTrainmanGUID : String;
    {�鿨ʱ��}
    dtCreateTime : TDateTime;
    {�鿨���}
    strCheckResult : String;
    {��ʾ����}
    nJSCount : Integer;
    {�����ʾ����}
    nTsJsCount : Integer;
    {������ID}
    strWorkID : String;
    {����ID}
    strAreaGUID : String;
    {��¼ID}
    nRecordID : Integer;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TCheckICCarRecordList
  /// ˵��:�鿨��¼�б�
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
