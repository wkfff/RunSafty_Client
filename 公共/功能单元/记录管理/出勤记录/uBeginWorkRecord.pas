unit uBeginWorkRecord;

interface

uses Contnrs;

type
  //////////////////////////////
  /// ����:TBeginWorkRecord
  /// ˵��:���ڼ�¼����
  //////////////////////////////
  TBeginWorkRecord = class
  public
    strGUID : String;
    {��������}
    strSectionName : String;
    {��������}
    strCheCi : String;
    {��ʻ��������}
    strTrainType : String;
    {��ʻ��������}
    strTrainNumber : String;
    {�ͻ�����}
    strKeHuo : String;
    {����ʱ��}
    dtKaiCheTime : TDateTime;
    {����Ա1GUID}
    strTrainmanGUID1 : String;
    {����Ա1�����֤��ʽ}
    nTrainmanVerifyID1 : Integer;
    {����Ա2GUID}
    strTrainmanGUID2 : String;
    {����Ա2�����֤��ʽ}
    nTrainmanVerifyID2 : Integer;
    {����ID}
    strAreaGUID : String;
    {����ʱ��}
    dtCreateTime : TDateTime;
    {���������Ա}
    strDutyGUID : String;
    {�ƻ�ID}
    strPlanGUID : String;
  public
    {����:�ӱ�ĳ��ڼ�¼����һ��}
    procedure CopyFrom(Item:TBeginWorkRecord);
  end;

  //////////////////////////////
  /// ����:TBeginWorkRecordEx
  /// ˵��:���ڼ�¼��չ����
  //////////////////////////////
  TBeginWorkRecordEx = class(TBeginWorkRecord)
    {����Ա1����}
    strTrainmanName1 : String;
    {����Ա1����}
    strTrainmanNumber1 : String;
    {����Ա1��ƽ��}
    TestDrinkResult1 : Integer;
    {����Ա1�鿨���}
    CheckCardResult1 : String;
    {����Ա2����}
    strTrainmanName2 : String;
    {����Ա2����}
    strTrainmanNumber2 : String;
    {����Ա2��ƽ��}
    TestDrinkResult2 : Integer;
    {����Ա2�鿨���}
    CheckCardResult2 : String;
  public
    {����:���Ƴ��ڼ�¼��չ����}
    procedure CopyFrom(Item:TBeginWorkRecordEx);reintroduce;
    
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TBeginWorkRecordExList
  /// ˵��:���ڼ�¼��չ����
  //////////////////////////////////////////////////////////////////////////////
  TBeginWorkRecordExList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TBeginWorkRecordEx;
    procedure SetItem(Index: Integer; Item: TBeginWorkRecordEx);
  public
    {����:�ӱ�ĳ��ڼ�¼��չ������һ��}
    procedure CopyFrom(RecordList:TBeginWorkRecordExList);
    function Add(Item: TBeginWorkRecordEx): Integer;
    property Items[Index: Integer]: TBeginWorkRecordEx read GetItem write SetItem; default;
  end;

implementation
uses
  SysUtils;
{ TBeginWorkRecordExList }

function TBeginWorkRecordExList.Add(Item: TBeginWorkRecordEx): Integer;
begin
  Result := inherited Add(Item);
end;

procedure TBeginWorkRecordExList.CopyFrom(RecordList: TBeginWorkRecordExList);
{����:�ӱ�ĳ��ڼ�¼��չ������һ��}
var
  Item : TBeginWorkRecordEx;
  i : Integer;
begin
  Clear;
  for I := 0 to RecordList.Count - 1 do
  begin
    Item := TBeginWorkRecordEx.Create;
    Item.CopyFrom(RecordList.Items[i]);
    Add(Item);
  end;
end;

function TBeginWorkRecordExList.GetItem(Index: Integer): TBeginWorkRecordEx;
begin
  Result := TBeginWorkRecordEx(inherited GetItem(Index));
end;

procedure TBeginWorkRecordExList.SetItem(Index: Integer;
  Item: TBeginWorkRecordEx);
begin
  inherited SetItem(Index,Item);
end;

{ TBeginWorkRecord }

procedure TBeginWorkRecord.CopyFrom(Item: TBeginWorkRecord);
{����:�ӱ�ĳ��ڼ�¼����һ��}
begin
  strGUID := Item.strGUID;
  strSectionName := Item.strSectionName;
  strCheCi := Item.strCheCi;
  strTrainType := Item.strTrainType;
  strTrainNumber := Item.strTrainNumber;
  strKeHuo := Item.strKeHuo;
  dtKaiCheTime := Item.dtKaiCheTime;
  strTrainmanGUID1 := Item.strTrainmanGUID1;
  nTrainmanVerifyID1 := Item.nTrainmanVerifyID1;
  strTrainmanGUID2 := Item.strTrainmanGUID2;
  nTrainmanVerifyID2 := Item.nTrainmanVerifyID2;
  strAreaGUID := Item.strAreaGUID;
  dtCreateTime := Item.dtCreateTime;
  strDutyGUID := Item.strDutyGUID;
  strPlanGUID := Item.strPlanGUID;
end;

{ TBeginWorkRecordEx }

procedure TBeginWorkRecordEx.CopyFrom(Item: TBeginWorkRecordEx);
begin
  inherited CopyFrom(TBeginWorkRecord(Item));
  strTrainmanName1 := Item.strTrainmanName1;
  strTrainmanNumber1 := Item.strTrainmanNumber1;
  TestDrinkResult1 := Item.TestDrinkResult1;
  CheckCardResult1 := Item.CheckCardResult1;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanName2 := Item.strTrainmanName2;
  strTrainmanNumber2 := Item.strTrainmanNumber2;
  TestDrinkResult2 := Item.TestDrinkResult2;
  CheckCardResult2 := Item.CheckCardResult2;
end;


end.

