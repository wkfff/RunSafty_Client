unit uLCWriteCardSectionV2;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,uWriteCardSection;
type
  //写卡区段接口
  TRsLCWriteCardSectionV2 = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  private
    m_WebAPIUtils:TWebAPIUtils;
    function JsonToSection(iJson: ISuperObject): RRsWriteCardSection;
    function SectionToJson(Section: RRsWriteCardSection): ISuperObject;
  public
    //获取计划所有可选的写卡区段
    procedure GetPlanAllSections(TrainPlanGUID : String;out SectionArray : TRsWriteCardSectionArray);
    //获取计划已经选定的写卡区段
    procedure GetPlanSelectedSections(TrainPlanGUID : String; out SectionArray : TRsWriteCardSectionArray);
    //指定计划的写卡区段
    procedure SetPlanSections(TrainPlanGUID : String;SectionArray : TRsWriteCardSectionArray;
      DutyUserGUID : String;DutyUserNumber : String;DutyUserName : String);
  end;
implementation

{ TRsLCWriteCardSection }

constructor TRsLCWriteCardSectionV2.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCWriteCardSectionV2.GetPlanAllSections(TrainPlanGUID: String;
  out SectionArray: TRsWriteCardSectionArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWriteCardSection.GetPlanAllSections',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['SectionArray'];

  SetLength(SectionArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    SectionArray[i] := JsonToSection(json.AsArray[i]);
  end;
end;


procedure TRsLCWriteCardSectionV2.GetPlanSelectedSections(TrainPlanGUID: String;
  out SectionArray: TRsWriteCardSectionArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWriteCardSection.GetPlanSelectedSections',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['SectionArray'];

  SetLength(SectionArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    SectionArray[i] := JsonToSection(json.AsArray[i]);
  end;
end;
function TRsLCWriteCardSectionV2.JsonToSection(
  iJson: ISuperObject): RRsWriteCardSection;
begin
  Result.strJWDNumber := iJson.S['strJWDNumber'];
  Result.strSectionID := iJson.S['strSectionID'];
  Result.strSectionName := iJson.S['strSectionName'];
end;

function TRsLCWriteCardSectionV2.SectionToJson(
  Section: RRsWriteCardSection): ISuperObject;
begin
  Result := SO();
  Result.S['strJWDNumber'] := Section.strJWDNumber;
  Result.S['strSectionID'] := Section.strSectionID;
  Result.S['strSectionName'] := Section.strSectionName;
end;

procedure TRsLCWriteCardSectionV2.SetPlanSections(TrainPlanGUID: String;
  SectionArray: TRsWriteCardSectionArray; DutyUserGUID, DutyUserNumber,
  DutyUserName: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  jsonArray: ISuperObject;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['DutyUserNumber'] := DutyUserNumber;

  jsonArray := SO('[]');

  for I := 0 to length(SectionArray) - 1 do
  begin
    jsonArray.AsArray.Add(SectionToJson(SectionArray[i]));
  end;
  json.O['SectionArray'] := jsonArray;

  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWriteCardSection.SetPlanSections',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
end.
