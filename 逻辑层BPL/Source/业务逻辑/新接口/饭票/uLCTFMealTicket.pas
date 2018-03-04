unit uLCTFMealTicket;

interface
uses
  Classes,SysUtils,uHttpWebAPI,uJsonSerialize,superobject;
type
  TTFMealTicketEntity = class(TPersistent)
  private
    m_strTicketGUID: string;
    m_dtChuQinTime: tdatetime;
    m_strTrainNo: string;
    m_strTrainmanName: string;
    m_strTrainmanNumber: string;
    m_strWorkShopName: string;
    m_strWorkShopGUID: string;
    m_strChuQinPlaceID: string;
    m_strChuQinPlaceName: string;
    m_strShenHeNumber: string;
    m_strShenHeName: string;
    m_dtShenHeTime: tdatetime;
    m_dtCreateTime: tdatetime;
    m_nCanQuanA: integer;
    m_nCanQuanB: integer;
  published  
    property strTicketGUID: string read m_strTicketGUID write m_strTicketGUID;
    property dtChuQinTime: tdatetime read m_dtChuQinTime write m_dtChuQinTime;
    property strTrainNo: string read m_strTrainNo write m_strTrainNo;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strWorkShopName: string read m_strWorkShopName write m_strWorkShopName;
    property strWorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property strChuQinPlaceID: string read m_strChuQinPlaceID write m_strChuQinPlaceID;
    property strChuQinPlaceName: string read m_strChuQinPlaceName write m_strChuQinPlaceName;
    property strShenHeNumber: string read m_strShenHeNumber write m_strShenHeNumber;
    property strShenHeName: string read m_strShenHeName write m_strShenHeName;
    property dtShenHeTime: tdatetime read m_dtShenHeTime write m_dtShenHeTime;
    property dtCreateTime: tdatetime read m_dtCreateTime write m_dtCreateTime;
    property nCanQuanA: integer read m_nCanQuanA write m_nCanQuanA;
    property nCanQuanB: integer read m_nCanQuanB write m_nCanQuanB;
  end;


  TRsLCTFMealTicket = class(TWepApiBase)
  public
    procedure Add(MealTicket: TTFMealTicketEntity);
    procedure Del(TicketID: string);
    function Get(tmid: string;MealTicket: TTFMealTicketEntity): Boolean;
  end;                             
implementation

{ TRsLCTFMealTicket }

procedure TRsLCTFMealTicket.Add(MealTicket: TTFMealTicketEntity);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO();
  JSON.O['Ticket'] := TJsonSerialize.Serialize(MealTicket);

  strOutputData := m_WebAPIUtils.Post('TF.MealTicket.Ticket.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTFMealTicket.Del(TicketID: string);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO();
  JSON.S['TicketGUID'] := TicketID;
  
  strOutputData := m_WebAPIUtils.Post('TF.MealTicket.Ticket.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  
end;


function TRsLCTFMealTicket.Get(tmid: string;
  MealTicket: TTFMealTicketEntity): Boolean;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanNumber'] := tmid;

  strOutputData := m_WebAPIUtils.Post('TF.MealTicket.Ticket.Trainman.UnGive',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['Exist'] <> 0;

  if Result then
  begin
    TJsonSerialize.DeSerialize(JSON.O['Ticket'],MealTicket);
  end;

end;


end.
