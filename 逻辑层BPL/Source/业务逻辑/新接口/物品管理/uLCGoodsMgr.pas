unit uLCGoodsMgr;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uLendingDefine,uGoodsRange,
  uJsonSerialize;
type
////////////////////////////////////////////////////////////////////////////////
/// TQueryCondition  查询条件数据类
////////////////////////////////////////////////////////////////////////////////
  TRsQueryCondition = class(TPersistent)
  public
    constructor Create();
  private
    {开始时间}
    m_dtBeginTime: tdatetime;
    {结束时间}
    m_dtEndTime: tdatetime;
    {归还状态}
    m_nReturnState: integer;
    {物品类型}
    m_nLendingType: integer;
    {乘务员工号}
    m_strTrainmanNumber: string;
    {乘务员姓名}
    m_strTrainmanName: string;
    {车间GUID}
    m_strWorkShopGUID: string;
    {物品编号}
    m_nLendingNumber: integer;
  public
    {功能:生成SQL条件语句}
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
    {归还状态}
    m_nReturnState: integer;
    {物品类型}
    m_nLendingType: integer;
    {乘务员工号}
    m_strTrainmanNumber: string;
    {乘务员姓名}
    m_strTrainmanName: string;
    {物品编号}
    m_nBianHao: integer;
    {车间ID}
    m_WorkShopGUID: string;
    {排序字段}
    m_strOrderField: string;
  public
    {功能:生成SQL条件语句}
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
  //物品查询排序类型
  TGoodsOrderType = (gotNumber=1,gotBorrowTime);

  
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLCCodeRange
  /// 说明:TLCCodeRange接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCCodeRange = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:1.6.11    获取编码范围
    procedure Get(WorkShopGUID : String;lendingType : Integer;out codeRangeArray : TRsGoodsRangeList);
    //功能:1.6.12    增加编号范围
    function Add(codeRangeEntity : RRsGoodsRange;out Error:string): Boolean;
    //功能:1.6.13    修改编号范围
    function Update(codeRangeEntity : RRsGoodsRange;out Error:string): Boolean;
    //功能:1.6.14    删除编号范围
    function Delete(rangeGUID : String;out Error:string): Boolean;
  Private
    m_WebAPIUtils:TWebAPIUtils;
  public
    function JsonToCodeRange(iJson: ISuperObject): RRsGoodsRange;
    function CodeRangeToJson(Range: RRsGoodsRange): ISuperObject;
  end;

  
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLCGoodsMgr
  /// 说明:TLCGoodsMgr接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCGoodsMgr = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  public
    //功能:1.6.1    获取物品类型
    procedure GetGoodType(lendingTypeList : TRsLendingTypeList);
    //功能:1.6.2    获取物品状态类型
    procedure GetStateNames(returnStateList : TRsReturnStateList);
    //功能:1.6.3    发放物品
    procedure Send(TrainmanGUID,WorkShopGUID,remark : String;UsesGoodsRange: Boolean;lendingDetailList : TRsLendingDetailList);
    //功能:1.6.4    归还物品
    procedure Recieve(TrainmanGUID : String;remark : String;lendingDetailList : TRsLendingDetailList);
    //功能:1.6.5    查询发放记录
    procedure QueryRecord(queryParam : TRsQueryCondition;lendingInfoList : TRsLendingInfoList);
    //功能:1.6.6    查询物品最新情况已借出则显示借出情况，已归还仅显示物品情况
    procedure QueryGoodsNow(WorkShopGUID : String;GoodType,GoodID: Integer;orderType:TGoodsOrderType;
      lendingDetailList: TRsLendingDetailList);
    //功能:1.6.7    查询发放明细
    procedure QueryDetails(queryParam : TRsDetailsQueryCondition;lendingDetailList : TRsLendingDetailList);
    //功能:1.6.8    获取统计信息
    procedure GetTongJiInfo(lendingTjList : TRslendingToJiList;WorkShopGUID : String);
    //功能:1.6.9    判断指定人员是否有未归还的物品
    function IsHaveNotReturnGoods(TrainmanGUID : String): Boolean;
    //功能:1.6.10    获得指定人员未归还物品列表
    function GetTrainmanNotReturnLendingInfo(TrainmanGUID : String;lendingDetailList : TRsLendingDetailList): Boolean;
    //删除物品及物品相关的发放归还记录
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
{功能:生成SQL条件语句}
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
