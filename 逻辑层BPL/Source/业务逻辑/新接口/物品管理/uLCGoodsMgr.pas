unit uLCGoodsMgr;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uLendingDefine,uGoodsRange,
  uJsonSerialize;
type
////////////////////////////////////////////////////////////////////////////////
/// TQueryCondition  ��ѯ����������
////////////////////////////////////////////////////////////////////////////////
  TRsQueryCondition = class(TPersistent)
  public
    constructor Create();
  private
    {��ʼʱ��}
    m_dtBeginTime: tdatetime;
    {����ʱ��}
    m_dtEndTime: tdatetime;
    {�黹״̬}
    m_nReturnState: integer;
    {��Ʒ����}
    m_nLendingType: integer;
    {����Ա����}
    m_strTrainmanNumber: string;
    {����Ա����}
    m_strTrainmanName: string;
    {����GUID}
    m_strWorkShopGUID: string;
    {��Ʒ���}
    m_nLendingNumber: integer;
  public
    {����:����SQL�������}
    function GetSQLCondition(): string;
  published
    property dtBeginTime: tdatetime read m_dtBeginTime write m_dtBeginTime;
    property dtEndTime: tdatetime read m_dtEndTime write m_dtEndTime;
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property strWorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property nLendingNumber: integer read m_nLendingNumber write m_nLendingNumber;
  end;


  TRsDetailsQueryCondition = class(TPersistent)
  public
    constructor Create();
  private
    {�黹״̬}
    m_nReturnState: integer;
    {��Ʒ����}
    m_nLendingType: integer;
    {����Ա����}
    m_strTrainmanNumber: string;
    {����Ա����}
    m_strTrainmanName: string;
    {��Ʒ���}
    m_nBianHao: integer;
    {����ID}
    m_WorkShopGUID: string;
    {�����ֶ�}
    m_strOrderField: string;
  public
    {����:����SQL�������}
    function GetSQLCondition(): string;
  published
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property nBianHao: integer read m_nBianHao write m_nBianHao;
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property strOrderField: string read m_strOrderField write m_strOrderField;
  end;
  //��Ʒ��ѯ��������
  TGoodsOrderType = (gotNumber=1,gotBorrowTime);

  
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCCodeRange
  /// ˵��:TLCCodeRange�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TRsLCCodeRange = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //����:1.6.11    ��ȡ���뷶Χ
    procedure Get(WorkShopGUID : String;lendingType : Integer;out codeRangeArray : TRsGoodsRangeList);
    //����:1.6.12    ���ӱ�ŷ�Χ
    function Add(codeRangeEntity : RRsGoodsRange;out Error:string): Boolean;
    //����:1.6.13    �޸ı�ŷ�Χ
    function Update(codeRangeEntity : RRsGoodsRange;out Error:string): Boolean;
    //����:1.6.14    ɾ����ŷ�Χ
    function Delete(rangeGUID : String;out Error:string): Boolean;
  Private
    m_WebAPIUtils:TWebAPIUtils;
  public
    function JsonToCodeRange(iJson: ISuperObject): RRsGoodsRange;
    function CodeRangeToJson(Range: RRsGoodsRange): ISuperObject;
  end;

  
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCGoodsMgr
  /// ˵��:TLCGoodsMgr�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TRsLCGoodsMgr = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  public
    //����:1.6.1    ��ȡ��Ʒ����
    procedure GetGoodType(lendingTypeList : TRsLendingTypeList);
    //����:1.6.2    ��ȡ��Ʒ״̬����
    procedure GetStateNames(returnStateList : TRsReturnStateList);
    //����:1.6.3    ������Ʒ
    procedure Send(TrainmanGUID,WorkShopGUID,remark : String;UsesGoodsRange: Boolean;lendingDetailList : TRsLendingDetailList);
    //����:1.6.4    �黹��Ʒ
    procedure Recieve(TrainmanGUID : String;remark : String;lendingDetailList : TRsLendingDetailList);
    //����:1.6.5    ��ѯ���ż�¼
    procedure QueryRecord(queryParam : TRsQueryCondition;lendingInfoList : TRsLendingInfoList);
    //����:1.6.6    ��ѯ��Ʒ��������ѽ������ʾ���������ѹ黹����ʾ��Ʒ���
    procedure QueryGoodsNow(WorkShopGUID : String;GoodType,GoodID: Integer;orderType:TGoodsOrderType;
      lendingDetailList: TRsLendingDetailList);
    //����:1.6.7    ��ѯ������ϸ
    procedure QueryDetails(queryParam : TRsDetailsQueryCondition;lendingDetailList : TRsLendingDetailList);
    //����:1.6.8    ��ȡͳ����Ϣ
    procedure GetTongJiInfo(lendingTjList : TRslendingToJiList;WorkShopGUID : String);
    //����:1.6.9    �ж�ָ����Ա�Ƿ���δ�黹����Ʒ
    function IsHaveNotReturnGoods(TrainmanGUID : String): Boolean;
    //����:1.6.10    ���ָ����Աδ�黹��Ʒ�б�
    function GetTrainmanNotReturnLendingInfo(TrainmanGUID : String;lendingDetailList : TRsLendingDetailList): Boolean;
    //ɾ����Ʒ����Ʒ��صķ��Ź黹��¼
    procedure DeleteGoods(LendingType: integer;LendingExInfo: string;WorkShopGUID : string);
  Private
    m_WebAPIUtils:TWebAPIUtils;
    m_CodeRange: TRsLCCodeRange;
  public
    property CodeRange: TRsLCCodeRange read m_CodeRange;
  end;           
implementation

{ TLCGoodsMgr }

constructor TRsLCGoodsMgr.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
  m_CodeRange := TRsLCCodeRange.Create(WebAPIUtils);
end;

procedure TRsLCGoodsMgr.DeleteGoods(LendingType: integer; LendingExInfo,
  WorkShopGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['LendingType'] := LendingType;
  JSON.S['LendingExInfo'] := LendingExInfo;
  JSON.S['WorkShopGUID'] := WorkShopGUID;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.DeleteGoods',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


destructor TRsLCGoodsMgr.Destroy;
begin
  m_CodeRange.Free;
  inherited;
end;

procedure TRsLCGoodsMgr.GetGoodType(lendingTypeList: TRsLendingTypeList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.GetGoodType',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingTypeList'];

  TJsonSerialize.DeSerialize(JSON,lendingTypeList,TRsLendingType);
end;



procedure TRsLCGoodsMgr.GetStateNames(returnStateList: TRsReturnStateList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.GetStateNames',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['returnStateList'];

  TJsonSerialize.DeSerialize(JSON,returnStateList,TRsReturnState);
end;



procedure TRsLCGoodsMgr.GetTongJiInfo(lendingTjList: TRslendingToJiList;
  WorkShopGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.GetTongJiInfo',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingTjList'];

  TJsonSerialize.DeSerialize(JSON,lendingTjList,TRsLendingTongJi);
end;

function TRsLCGoodsMgr.GetTrainmanNotReturnLendingInfo(TrainmanGUID: String;
  lendingDetailList: TRsLendingDetailList): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.GetTrainmanNotReturnLendingInfo',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingDetailList'];

  TJsonSerialize.DeSerialize(JSON,lendingDetailList,TRsLendingDetail);

  Result := lendingDetailList.Count > 0;
end;
function TRsLCGoodsMgr.IsHaveNotReturnGoods(TrainmanGUID: String): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.IsHaveNotReturnGoods',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['result'];
end;

procedure TRsLCGoodsMgr.QueryDetails(queryParam: TRsDetailsQueryCondition;
  lendingDetailList: TRsLendingDetailList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['queryParam'] := TJsonSerialize.Serialize(queryParam);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.QueryDetails',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingDetailList'];

  TJsonSerialize.DeSerialize(JSON,lendingDetailList,TRsLendingDetail);
end;

procedure TRsLCGoodsMgr.QueryGoodsNow(WorkShopGUID: String; GoodType,
  GoodID: Integer; orderType: TGoodsOrderType;
  lendingDetailList: TRsLendingDetailList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.I['GoodType'] := GoodType;
  JSON.I['GoodID'] := GoodID;
  JSON.I['orderType'] := Ord(orderType);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.QueryGoodsNow',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingDetailList'];

  TJsonSerialize.DeSerialize(JSON,lendingDetailList,TRsLendingDetail);
end;

procedure TRsLCGoodsMgr.QueryRecord(queryParam: TRsQueryCondition;
  lendingInfoList: TRsLendingInfoList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['queryParam'] := TJsonSerialize.Serialize(queryParam);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.QueryRecord',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['lendingInfoList'];

  TJsonSerialize.DeSerialize(JSON,lendingInfoList,TRsLendingInfo);
end;


procedure TRsLCGoodsMgr.Recieve(TrainmanGUID, remark: String;
  lendingDetailList: TRsLendingDetailList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  JSON.S['remark'] := remark;
  JSON.O['lendingDetailList'] := TJsonSerialize.Serialize(lendingDetailList);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.Recieve',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCGoodsMgr.Send(TrainmanGUID, WorkShopGUID, remark: String;
  UsesGoodsRange: Boolean;lendingDetailList: TRsLendingDetailList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  JSON.S['remark'] := remark;
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.B['UsesGoodsRange'] := UsesGoodsRange;
  JSON.O['lendingDetailList'] := TJsonSerialize.Serialize(lendingDetailList);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.Send',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
{ TLCCodeRange }

function TRsLCCodeRange.Add(codeRangeEntity: RRsGoodsRange;
  out Error: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  JSON := SO();
  try
    json.O['codeRangeEntity'] := CodeRangeToJson(codeRangeEntity);
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.CodeRange.Add',json.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Error := E.Message;
    end;
  end;

end;

function TRsLCCodeRange.CodeRangeToJson(Range: RRsGoodsRange): ISuperObject;
begin
  Result := SO;
  Result.S['strGUID'] := Range.strGUID;
  Result.I['nLendingTypeID'] := Range.nLendingTypeID;
  Result.I['nStartCode'] := Range.nStartCode;
  Result.I['nStopCode'] := Range.nStopCode;
  Result.S['strExceptCodes'] := Range.strExceptCodes;
  Result.S['strWorkShopGUID'] := Range.strWorkShopGUID;
end;

constructor TRsLCCodeRange.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCCodeRange.Delete(rangeGUID: String; out Error: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  JSON := SO();
  try
    json.S['rangeGUID'] := rangeGUID;
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.CodeRange.Delete',json.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Error := E.Message;
    end;
  end;

end;
procedure TRsLCCodeRange.Get(WorkShopGUID: String; lendingType: Integer;
  out codeRangeArray: TRsGoodsRangeList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.S['WorkShopGUID'] := WorkShopGUID;
  json.I['lendingType'] := lendingType;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.CodeRange.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['codeRangeArray'];

  SetLength(codeRangeArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    codeRangeArray[i] := JsonToCodeRange(json.AsArray[i]);
  end;
end;


function TRsLCCodeRange.JsonToCodeRange(iJson: ISuperObject): RRsGoodsRange;
begin
  Result.strGUID := iJson.S['strGUID'];
  Result.nLendingTypeID := iJson.I['nLendingTypeID'];
  Result.nStartCode := iJson.I['nStartCode'];
  Result.nStopCode := iJson.I['nStopCode'];
  Result.strExceptCodes := iJson.S['strExceptCodes'];
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
end;

function TRsLCCodeRange.Update(codeRangeEntity: RRsGoodsRange;
  out Error: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := False;
  JSON := SO();
  try
    json.O['codeRangeEntity'] := CodeRangeToJson(codeRangeEntity);
    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCGoodsMgr.CodeRange.Update',json.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Error := E.Message;
    end;
  end;

end;

{ TQueryCondition }

constructor TRsQueryCondition.Create;
begin
  dtBeginTime := 0;
  dtEndTime := 0;
  nReturnState := -1;
  nLendingType := -1;
  nLendingNumber := -1;
end;

function TRsQueryCondition.GetSQLCondition: string;
{����:����SQL�������}
begin
  Result := ' where (1=1) ';

  if (dtBeginTime > 1) and (dtEndTime > 1) then
    Result := Result +
    Format('and (dtBorrowTime >= %s and dtBorrowTime <= %s) ',
      [QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTime)),
       QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndTime))]);

  if nReturnState > -1 then
    Result := Result + ' and (nReturnState = ' + IntToStr(nReturnState) + ') ';

  if nLendingType > -1 then
    Result := Result +
      Format('and (%d in (select nLendingType from TAB_LendingDetail where ' +
        'strLendingInfoGUID = View_LendingInfo.strGUID) ) ',[nLendingType]);


  if strTrainmanNumber <> '' then
    Result := Result + Format('and (strBorrowTrainmanNumber = %s) ',[QuotedStr(strTrainmanNumber)]);

  if strTrainmanName <> '' then
    Result := Result + Format('and (strBorrowTrainmanName = %s)',[QuotedStr(strTrainmanName)]);

  if strWorkShopGUID <> '' then
    Result := Result + Format('and (strWorkShopGUID = %s)',[QuotedStr(strWorkShopGUID)]);
    
  if nLendingNumber > -1 then  
    Result := Result + Format('and (strGUID in (select strLendingInfoGUID from TAB_LendingDetail where ' +
        'strLendingExInfo = %d) ) ',[nLendingNumber]);

  
end;

{ TDetailsQueryCondition }
constructor TRsDetailsQueryCondition.Create;
begin
  nBianHao := -1;
end;

function TRsDetailsQueryCondition.GetSQLCondition: string;
begin
  if nReturnState <> -1 then
    Result := Result + ' and nReturnState = ' + IntToStr(nReturnState);

  if nLendingType <> -1 then
    Result := Result + ' and nLendingType = ' + IntToStr(nLendingType);

  if strTrainmanNumber <> '' then
    Result := Result + ' and strBorrowTrainmanNumber = ' + QuotedStr(strTrainmanNumber);

  if strTrainmanName <> '' then
    Result := Result + ' and strBorrowTrainmanName= ' + QuotedStr(strTrainmanName);

  if nBianHao <> -1 then
    Result := Result + ' and strLendingExInfo= ' + IntToStr(nBianHao);


  if WorkShopGUID <> '' then
    Result := Result + ' and strWorkShopGUID = ' + QuotedStr(WorkShopGUID);


  if strOrderField = '' then
    Result := Result + ' order by dtBorrowTime Desc'
  else
    Result := Result + ' order by ' + strOrderField + ' Desc';



  
end;
end.
