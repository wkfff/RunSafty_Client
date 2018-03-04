unit uSigninRecord;

interface
uses
  Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSigninRecord
  /// ˵��:ǩ����¼
  //////////////////////////////////////////////////////////////////////////////
  TSigninRecord = class
  public
    strGUID : String;
    {����ԱID}
    strTrainmanGUID : String;
    {�ƻ�ID}
    strPlanGUID : String;
    {ǩ��ʱ��}
    dtSigninTime : TDateTime;
    {�����֤��ʽ}
    nVerifyID : Integer;
    {ֵ��ԱID}
    strDutyGUID : String;
    {ǩ���ص�}
    strAreaGUID : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSigninRecordList
  /// ˵��:ǩ����¼�б�
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
