unit uLCKeyMan;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uJsonSerialize,Contnrs;
type

  //关键人操作类型
  EKeyTrainmanOpt  = (KTMAdd{增加},KTMModify{修改},KTMdel{删除});
  //查询条件
  TKeyTM_QC = class(TPersistent)
  private
    //车间编号
    m_WorkShopGUID: string;
    //车队编号
    m_CheDuiGUID: string;
    //关键人工号
    m_KeyTMNumber: string;
    //关键人姓名
    m_KeyTMName: string;
    //登记开始时间
    m_RegisterStartTime: tdatetime;
    //登记截止时间
    m_RegisterEndTime: tdatetime;
  published
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property CheDuiGUID: string read m_CheDuiGUID write m_CheDuiGUID;
    property KeyTMNumber: string read m_KeyTMNumber write m_KeyTMNumber;
    property KeyTMName: string read m_KeyTMName write m_KeyTMName;
    property RegisterStartTime: tdatetime read m_RegisterStartTime write m_RegisterStartTime;
    property RegisterEndTime: tdatetime read m_RegisterEndTime write m_RegisterEndTime;
  end;

  TKeyTrainman = class(TPersistent)
  private
    //id
    m_ID: string;
    //关键人工号
    m_KeyTMNumber: string;
    //关键人姓名
    m_KeyTMName: string;
    //关键人所属车间id
    m_KeyTMWorkShopGUID: string;
    //关键人所属车间名称
    m_KeyTMWorkShopName: string;
    //关键人所属车队id
    m_KeyTMCheDuiGUID: string;
    //关键人所属车队名称
    m_KeyTMCheDuiName: string;
    //关键人开始时间
    m_KeyStartTime: tdatetime;
    //关键人截止时间
    m_KeyEndTime: tdatetime;
    //登记原因
    m_KeyReason: string;
    //登记注意事项
    m_KeyAnnouncements: string;
    //登记人工号
    m_RegisterNumber: string;
    //登记人姓名
    m_RegisterName: string;
    //登记日期
    m_RegisterTime: tdatetime;
    //客户端编号
    m_ClientNumber: string;
    //客户端名称
    m_ClientName: string;
    //操作类型
    m_eOpt: EKeyTrainmanOpt;
  public
    procedure clone(src: TKeyTrainman);
  published
    property ID: string read m_ID write m_ID;
    property KeyTMNumber: string read m_KeyTMNumber write m_KeyTMNumber;
    property KeyTMName: string read m_KeyTMName write m_KeyTMName;
    property KeyTMWorkShopGUID: string read m_KeyTMWorkShopGUID write m_KeyTMWorkShopGUID;
    property KeyTMWorkShopName: string read m_KeyTMWorkShopName write m_KeyTMWorkShopName;
    property KeyTMCheDuiGUID: string read m_KeyTMCheDuiGUID write m_KeyTMCheDuiGUID;
    property KeyTMCheDuiName: string read m_KeyTMCheDuiName write m_KeyTMCheDuiName;
    property KeyStartTime: tdatetime read m_KeyStartTime write m_KeyStartTime;
    property KeyEndTime: tdatetime read m_KeyEndTime write m_KeyEndTime;
    property KeyReason: string read m_KeyReason write m_KeyReason;
    property KeyAnnouncements: string read m_KeyAnnouncements write m_KeyAnnouncements;
    property RegisterNumber: string read m_RegisterNumber write m_RegisterNumber;
    property RegisterName: string read m_RegisterName write m_RegisterName;
    property RegisterTime: tdatetime read m_RegisterTime write m_RegisterTime;
    property ClientNumber: string read m_ClientNumber write m_ClientNumber;
    property ClientName: string read m_ClientName write m_ClientName;
    property eOpt: EKeyTrainmanOpt read m_eOpt write m_eOpt;
  end;

  TKeyTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TKeyTrainman;
    procedure SetItem(Index: Integer; AObject: TKeyTrainman);
  public
    property Items[Index: Integer]: TKeyTrainman read GetItem write SetItem; default;
  end;

              
  TRsLCKeyMan = class(TWepApiBase)
  public
    procedure Add(KeyTrainman: TKeyTrainman);
    procedure Update(KeyTrainman: TKeyTrainman);
    procedure Del(KeyTrainman: TKeyTrainman);
    procedure Get(KeyTM_QC: TKeyTM_QC;KeyTrainmanList: TKeyTrainmanList);
    procedure GetHistory(KeyTM_QC: TKeyTM_QC;KeyTrainmanList: TKeyTrainmanList);
  end;

const EKeyTrainmanOptName: array [EKeyTrainmanOpt] of string=('添加','修改','删除');
implementation
function TKeyTrainmanList.GetItem(Index: Integer): TKeyTrainman;
begin
  result := TKeyTrainman(inherited GetItem(Index));
end;
procedure TKeyTrainmanList.SetItem(Index: Integer; AObject: TKeyTrainman);
begin
  Inherited SetItem(Index,AObject);
end;        
{ TRsLCKeyMan }

procedure TRsLCKeyMan.Add(KeyTrainman: TKeyTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(KeyTrainman);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCKeyMan.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCKeyMan.Del(KeyTrainman: TKeyTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(KeyTrainman);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCKeyMan.Del',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCKeyMan.Get(KeyTM_QC: TKeyTM_QC;
  KeyTrainmanList: TKeyTrainmanList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(KeyTM_QC);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCKeyMan.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(JSON,KeyTrainmanList,TKeyTrainman);

end;


procedure TRsLCKeyMan.GetHistory(KeyTM_QC: TKeyTM_QC;
  KeyTrainmanList: TKeyTrainmanList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(KeyTM_QC);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCKeyMan.GetHistory',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(JSON,KeyTrainmanList,TKeyTrainman);

end;


procedure TRsLCKeyMan.Update(KeyTrainman: TKeyTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(KeyTrainman);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCKeyMan.Update',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


{ TKeyTrainman }

procedure TKeyTrainman.clone(src: TKeyTrainman);
var
  iJson: ISuperObject;
begin
  iJson := TJsonSerialize.Serialize(src);
  TJsonSerialize.DeSerialize(iJson,self);
end;

end.
