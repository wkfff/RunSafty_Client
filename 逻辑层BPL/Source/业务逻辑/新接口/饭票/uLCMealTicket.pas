unit uLCMealTicket;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uTemplateDayPlan,uSaftyEnum,Contnrs,uMealTicketRule,
uTrainmanJiaolu,uMealTicket;
type
  TRsLCMealTicket = class(TWepApiBase)
  public
    //���ݷ�Ʊ��Ա��Ϣ��ȡ��Ʊ����
    function GetTicket(MealTicketPersonInfo:RRsMealTicketPersonInfo;var CanQuanA,CanQuanB:Integer):Boolean;
  public
    //��ѯ����
    procedure QueryRule(WorkShopGUID:string;AType :TRsJiaoluType;out MealTicketRuleList: TRsMealTicketRuleList);
    //���ӹ���
    function  AddRule(MealTicketRule: RRsMealTicketRule):Boolean;
    //ɾ������
    function  DeleteRule(RuleGUID:string):Boolean;
    //�޸Ĺ���
    function  ModifyRule(RuleGUID:string;MealTicketRule: RRsMealTicketRule):Boolean;
  public
    {������Ϣ}
    //����RULE��GUID��ѯ��������г���
    procedure QueryCheCiInfo(RuleGUID:string;out CheCiList:TRsMealTicketCheCiList);
    //����
    function  AddCheCiInfo(CheCiInfo:RRsMealTicketCheCi):Boolean;
    //ɾ��
    function  DeleteChiCiInfo(CheCiGUID:string):Boolean;
    //�޸�
    function ModifyCheCiInfo(CheCiGUID:string;CheCiInfo:RRsMealTicketCheCi):Boolean;

  public
    //��¼���ŷ�Ʊ����־
    procedure LogMealTicket(Ticket: RRsMealTicket);
    //
    procedure QueryLog(StartDate,EndDate:TDateTime;DriverCode,ShenHeCode:string;out MealTicketList:TRsMealTicketList);

    procedure DelLog(ID: integer);
  private
    function JsonToTicketRule(iJson: ISuperObject): RRsMealTicketRule;
    function TicketRoleToJson(TicketRule: RRsMealTicketRule): ISuperObject;
    function JsonToTicketCheCi(iJson: ISuperObject): RRsMealTicketCheCi;
    function TicketCheCiToJson(TicketCheCi: RRsMealTicketCheCi): ISuperObject;
    function TicketToJson(Ticket: RRsMealTicket): ISuperObject;
    function JsonToTicket(json: ISuperObject): RRsMealTicket;
  end;
implementation

{ TRsLCMealTicket }

function TRsLCMealTicket.AddCheCiInfo(CheCiInfo: RRsMealTicketCheCi): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.O['CheciRule'] := TicketCheCiToJson(CheCiInfo);
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.CheCiRule.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCMealTicket.AddRule(MealTicketRule: RRsMealTicketRule): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.O['Rule'] := TicketRoleToJson(MealTicketRule);
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.Rule.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCMealTicket.DeleteChiCiInfo(CheCiGUID: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.S['CheCiGUID'] := CheCiGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.ChiCiRule.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
function TRsLCMealTicket.DeleteRule(RuleGUID: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.S['RuleGUID'] := RuleGUID;
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.Rule.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCMealTicket.DelLog(ID: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['nID'] := ID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.LogMealTicket.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCMealTicket.GetTicket(
  MealTicketPersonInfo: RRsMealTicketPersonInfo; var CanQuanA,
  CanQuanB: Integer): Boolean;
  function PersonInfoToJson(PersonInfo: RRsMealTicketPersonInfo): ISuperObject;
  begin
    Result := SO;
    //��Ա����
    Result.S['strTrainmanNumber'] := PersonInfo.strTrainmanNumber;
    //��������
    Result.S['strWorkShopGUID'] := PersonInfo.strWorkShopGUID;
    //����
    Result.S['strQuDuan'] := PersonInfo.strQuDuan;
    //����
    Result.S['strCheCi'] := PersonInfo.strCheCi;
    //�ɰ�ʱ��
    Result.S['dtPaiBan'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',PersonInfo.dtPaiBan);
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['TickPersion'] := PersonInfoToJson(MealTicketPersonInfo);
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.Ticket.GetCount',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;
  if Result then
  begin
    CanQuanA := JSON.I['CanQuanA'];
    CanQuanB := JSON.I['CanQuanB'];
  end;
end;

function TRsLCMealTicket.JsonToTicket(json: ISuperObject): RRsMealTicket;
begin
  Result.ID := json.I['ID'];
  Result.CANJUAN_INFO_ID := json.I['CANJUAN_INFO_ID'];
  Result.PAIBAN_INFO_ID := json.I['PAIBAN_INFO_ID'];
  //ʱ��+����
  Result.PAIBAN_STR := json.S['PAIBAN_STR'];
  
  Result.DRIVER_CODE := json.S['DRIVER_CODE'];
  Result.DRIVER_NAME := json.S['DRIVER_NAME'];
  Result.CHEJIAN_NAME := json.S['CHEJIAN_NAME'];
  
  //��ͷ�Ʊ����
  Result.CANQUAN_A := json.I['CANQUAN_A'];
  //���ͷ�Ʊ����
  Result.CANQUAN_B := json.I['CANQUAN_B'];
  //��ͷ�Ʊ����
  Result.CANQUAN_C := json.I['CANQUAN_C'];
  
  Result.PAIBAN_CHECI := json.S['PAIBAN_CHECI'];
  Result.CHUQIN_TIME := json.S['CHUQIN_TIME'];
  Result.CHUQIN_YEAR := json.I['CHUQIN_YEAR'];
  Result.CHUQIN_MONTH := json.I['CHUQIN_MONTH'];
  Result.CHUQIN_DAY := json.I['CHUQIN_DAY'];
  Result.CHUQIN_YMD := json.I['CHUQIN_YMD'];
  Result.CHUQIN_DEPART := json.S['CHUQIN_DEPART'];
  
  Result.SHENHEREN_CODE := json.S['SHENHEREN_CODE'];
  Result.SHENHEREN_NAME := json.S['SHENHEREN_NAME'];
  Result.CHECK_FLAG := json.I['CHECK_FLAG'];
  
  Result.REC_TIME := json.S['REC_TIME'];
end;

function TRsLCMealTicket.JsonToTicketCheCi(
  iJson: ISuperObject): RRsMealTicketCheCi;
begin
  //GUID          
  Result.strGUID := iJson.S['strGUID'];
  //����GUID��ITYPE���ݿ��ѯ��Ʊʹ�õ�
  //����GUID          
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  // ��·����
  Result.iType := iJson.I['iType'];      
  //����
  Result.strQuDuan := iJson.S['strQuDuan'];
  //����
  Result.strCheCi := iJson.S['strCheCi'];
  //��ʼʱ��(���ŷ�Ʊ�ǿ�ʼ-����ʱ���TIME������Ч)
  //���� 06:00 ~ 09:00
  Result.dtStartTime := StrToDateTime(iJson.S['dtStartTime']);
  //ֹͣʱ��
  Result.dtEndTime := StrToDateTime(iJson.S['dtEndTime']);
  //����GUID
  Result.strRuleGUID := iJson.S['strRuleGUID'];
end;

function TRsLCMealTicket.JsonToTicketRule(
  iJson: ISuperObject): RRsMealTicketRule;
begin
  //������¼��GUID
  Result.strGUID := iJson.S['strGUID'];
  //��������
  Result.strName := iJson.S['strName'];
  //����GUID
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  // ��·����
  Result.iType := iJson.I['iType'];
  //���
  Result.iA := iJson.I['iA'];
  //����
  Result.iB := iJson.I['iB'];
end;

procedure TRsLCMealTicket.LogMealTicket(Ticket: RRsMealTicket);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['Ticket'] := TicketToJson(Ticket);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.LogMealTicket',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;
function TRsLCMealTicket.ModifyCheCiInfo(CheCiGUID: string;
  CheCiInfo: RRsMealTicketCheCi): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.S['CheCiGUID'] := CheCiGUID;
  JSON.O['Rule'] := TicketCheCiToJson(CheCiInfo);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.CheCiRule.Modify',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
function TRsLCMealTicket.ModifyRule(RuleGUID: string;
  MealTicketRule: RRsMealTicketRule): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  Result := True;
  JSON := SO();
  JSON.S['RuleGUID'] := RuleGUID;
  JSON.O['Rule'] := TicketRoleToJson(MealTicketRule);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.Rule.Modify',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
procedure TRsLCMealTicket.QueryCheCiInfo(RuleGUID: string;
  out CheCiList: TRsMealTicketCheCiList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['RuleGUID'] := RuleGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.CheCiRule.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['RuleList'];
  SetLength(CheCiList,JSON.AsArray.Length);

  for I := 0 to Length(CheCiList) - 1 do
  begin
    CheCiList[i] := JsonToTicketCheCi(JSON.AsArray[i]);
  end;
end;
procedure TRsLCMealTicket.QueryLog(StartDate, EndDate: TDateTime; DriverCode,
  ShenHeCode: string; out MealTicketList: TRsMealTicketList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['StartDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',StartDate);
  JSON.S['EndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);;
  JSON.S['DriverCode'] := DriverCode;
  JSON.S['ShenHeCode'] := ShenHeCode;

  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.GetMealTicketlog',json.AsString);
  
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(MealTicketList,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    MealTicketList[i] := JsonToTicket(JSON.AsArray[i]);
  end;
end;

procedure TRsLCMealTicket.QueryRule(WorkShopGUID: string; AType: TRsJiaoluType;
  out MealTicketRuleList: TRsMealTicketRuleList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.I['AType'] := Ord(AType);
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCMealTicket.Rule.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['RuleList'];
  SetLength(MealTicketRuleList,JSON.AsArray.Length);

  for I := 0 to Length(MealTicketRuleList) - 1 do
  begin
    MealTicketRuleList[i] := JsonToTicketRule(JSON.AsArray[i]);
  end;
end;


function TRsLCMealTicket.TicketCheCiToJson(
  TicketCheCi: RRsMealTicketCheCi): ISuperObject;
begin
  Result := SO();
  //GUID
  Result.S['strGUID'] := TicketCheCi.strGUID;
  //����GUID��ITYPE���ݿ��ѯ��Ʊʹ�õ�
  //����GUID
  Result.S['strWorkShopGUID'] := TicketCheCi.strWorkShopGUID;
  // ��·����
  Result.I['iType'] := TicketCheCi.iType;
  //����
  Result.S['strQuDuan'] := TicketCheCi.strQuDuan;
  //����
  Result.S['strCheCi'] := TicketCheCi.strCheCi;
  //��ʼʱ��(���ŷ�Ʊ�ǿ�ʼ-����ʱ���TIME������Ч)
  //���� 06:00 ~ 09:00
  Result.S['dtStartTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',TicketCheCi.dtStartTime);
  //ֹͣʱ��
  Result.S['dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',TicketCheCi.dtEndTime);
  //����GUID
  Result.S['strRuleGUID'] := TicketCheCi.strRuleGUID;
end;

function TRsLCMealTicket.TicketRoleToJson(
  TicketRule: RRsMealTicketRule): ISuperObject;
begin
  Result := SO();
  //������¼��GUID
  Result.S['strGUID'] := TicketRule.strGUID;
  //��������        
  Result.S['strName'] := TicketRule.strName;
  //����GUID
  Result.S['strWorkShopGUID'] := TicketRule.strWorkShopGUID;
  // ��·����
  Result.I['iType'] := TicketRule.iType;
  //���
  Result.I['iA'] := TicketRule.iA;
  //����
  Result.I['iB'] := TicketRule.iB;          
end;

function TRsLCMealTicket.TicketToJson(Ticket: RRsMealTicket): ISuperObject;
begin
  Result := SO();
  Result.I['CANJUAN_INFO_ID'] := Ticket.CANJUAN_INFO_ID;
  Result.I['PAIBAN_INFO_ID'] := Ticket.PAIBAN_INFO_ID;
  //ʱ��+����
  Result.S['PAIBAN_STR'] := Ticket.PAIBAN_STR;
  
  Result.S['DRIVER_CODE'] := Ticket.DRIVER_CODE;
  Result.S['DRIVER_NAME'] := Ticket.DRIVER_NAME;
  Result.S['CHEJIAN_NAME'] := Ticket.CHEJIAN_NAME;
  
  //��ͷ�Ʊ����
  Result.I['CANQUAN_A'] := Ticket.CANQUAN_A;
  //���ͷ�Ʊ����
  Result.I['CANQUAN_B'] := Ticket.CANQUAN_B;
  //��ͷ�Ʊ����
  Result.I['CANQUAN_C'] := Ticket.CANQUAN_C;
  
  Result.S['PAIBAN_CHECI'] := Ticket.PAIBAN_CHECI;
  Result.S['CHUQIN_TIME'] := Ticket.CHUQIN_TIME;
  Result.I['CHUQIN_YEAR'] := Ticket.CHUQIN_YEAR;
  Result.I['CHUQIN_MONTH'] := Ticket.CHUQIN_MONTH;
  Result.I['CHUQIN_DAY'] := Ticket.CHUQIN_DAY;
  Result.I['CHUQIN_YMD'] := Ticket.CHUQIN_YMD;
  Result.S['CHUQIN_DEPART'] := Ticket.CHUQIN_DEPART;
  
  Result.S['SHENHEREN_CODE'] := Ticket.SHENHEREN_CODE;
  Result.S['SHENHEREN_NAME'] := Ticket.SHENHEREN_NAME;
  Result.I['CHECK_FLAG'] := Ticket.CHECK_FLAG;
  
  Result.S['REC_TIME'] := Ticket.REC_TIME;
end;

end.
