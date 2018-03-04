unit uTrainNo;

interface
uses
  SysUtils,uTFSystem,Contnrs;


const
  {��˾��}
  TRAINMANTYPE_SINGLE  = 1;
  {˫˾��}
  TRAINMANTYPE_DOUBLE  = 2;


type

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTrainNo
  /// ˵��:������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TTrainNo = Class
  public
    constructor Create();
  public
    {����:��������}
    procedure CopyFrom(Item:TTrainNo);
    {����:�����͵�˫˾������ת��Ϊ�ַ���}
    class function TrainmanTypeToString(nTypeID : Integer) : String;
    {����:���ַ�����˫˾��ת��Ϊ����}
    class function TrainmanTypeToInt(strType : string) : Integer;
  public
    strGUID : String;
    {����}
    strTrainNo : String;
    {�ͻ�}
    strKeHuo : String;
    {����}
    strSectionName : String;
    {��·��}
    strJiaoLuNumber : String;
    {��վ��}
    strCheZhanNumber : String;
    {��Ϣʱ��}
    dtRestTime : TDateTime;
    {�а�ʱ��}
    dtCallTime : TDateTime;
    {����ʱ��}
    dtOutDutyTime : TDateTime;
    {����ʱ��}
    dtStartTime : TDateTime;
    {��˫˾�� 1Ϊ��˾�� 2Ϊ˫˾��}
    nTrainmanTypeID : Integer;
    {�Ƿ���Ҫǿ��}
    nIsEnforceRest : Integer;
    {����ID}
    strAreaGUID : String;
    {��¼����ʱ��}
    dtCreateTime : TDateTime;
    {��ʼվ}
    strStartStation : string;
    {�յ�վ}
    strEndStation : string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTrainNoList
  /// ˵��:������Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TTrainNoList = Class(TObjectList)
  protected
    function GetItem(Index: Integer): TTrainNo;
    procedure SetItem(Index: Integer; Item: TTrainNo);
  public
  public
    function Add(Item: TTrainNo): Integer;
    property Items[Index: Integer]: TTrainNo read GetItem write SetItem; default;
  end;

implementation

{ TTrainNoOpt }
{ TTrainNo }

procedure TTrainNo.CopyFrom(Item: TTrainNo);
{����:��������}
begin
  strGUID := Item.strGUID;
  {����}
  strTrainNo := Item.strTrainNo;
  {����}
  strSectionName := Item.strSectionName;
  {��·��}
  strJiaoLuNumber := Item.strJiaoLuNumber;
  {��վ��}
  strCheZhanNumber := Item.strCheZhanNumber;
  {��Ϣʱ��}
  dtRestTime := Item.dtRestTime;
  {�а�ʱ��}
  dtCallTime := Item.dtCallTime;
  {����ʱ��}
  dtOutDutyTime := Item.dtOutDutyTime;
  {����ʱ��}
  dtStartTime := Item.dtStartTime;
  {��˫˾�� 1Ϊ��˾�� 2Ϊ˫˾��}
  nTrainmanTypeID := Item.nTrainmanTypeID;
  {�Ƿ���Ҫǿ��}
  nIsEnforceRest := Item.nIsEnforceRest;
  {����ID}
  strAreaGUID := Item.strAreaGUID;
  {��¼����ʱ��}
  dtCreateTime := Item.dtCreateTime;
  {�ͻ�}
  strKeHuo := Item.strKeHuo;
end;

constructor TTrainNo.Create;
begin
  dtCreateTime := Now;
end;

class function TTrainNo.TrainmanTypeToInt(strType: String): Integer;
{����:���ַ�����˫˾��ת��Ϊ����}
begin
  Result := 0;
  if strType = '��˾��' then
    Result := 1;
  if strType = '˫˾��' then
    Result := 2;
end;

class function TTrainNo.TrainmanTypeToString(nTypeID: Integer): String;
{����:�����͵�˫˾������ת��Ϊ�ַ���}
begin
  Result := '';
  case nTypeID of
    1 : Result := '��˾��';
    2 : Result := '˫˾��';
  end;
end;

{ TTrainNoList }

function TTrainNoList.Add(Item: TTrainNo): Integer;
begin
  Result := inherited Add(Item);
end;

function TTrainNoList.GetItem(Index: Integer): TTrainNo;
begin
  Result := TTrainNo(inherited GetItem(Index));
end;

procedure TTrainNoList.SetItem(Index: Integer; Item: TTrainNo);
begin
  inherited SetItem(Index,Item);
end;

end.
