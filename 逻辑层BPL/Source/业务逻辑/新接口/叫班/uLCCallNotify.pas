unit uLCCallNotify;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,uCallNotify;
type
  //叫班接口
  TRsLCCallNotify = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  private
    m_WebAPIUtils:TWebAPIUtils;
  public
    //功能:取消叫班通知
    procedure CancelNotify(strGUID : String;strUser : String;dtCancelTime : TDateTime;strReason : String);
    //功能:添加叫班通知
    procedure AddNotify(callWork : RRsCallNotify);
    //功能:查询未取消的叫班通知
    function FindUnCancel(strTrainmanGUID : String;strTrainPlanGUID : String;
      out callWork : RRsCallNotify): Boolean;
    //功能:获取通知,按照状态范围
    procedure GetByStateRange(startState : Integer;endState : Integer;
      dtStartSendTime : TDateTime;NotCancel : Boolean;out callWorkAry : TRSCallNotifyAry);
  end;
implementation

{ TRsLCCallNotify }

procedure TRsLCCallNotify.AddNotify(callWork: RRsCallNotify);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  iSubJson: ISuperObject;
begin
  JSON := SO();
  iSubJson := SO;
  callWork.ToJson(iSubJson);
  JSON.O['callWork'] := iSubJson;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCJiaoBan.AddNotify',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCCallNotify.CancelNotify(strGUID, strUser: String;
  dtCancelTime: TDateTime; strReason: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strGUID'] := strGUID;
  JSON.S['strUser'] := strUser;
  JSON.S['dtCancelTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtCancelTime);
  JSON.S['strReason'] := strReason;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCJiaoBan.CancelNotify',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCCallNotify.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCCallNotify.FindUnCancel(strTrainmanGUID,
  strTrainPlanGUID: String; out callWork: RRsCallNotify): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strTrainmanGUID'] := strTrainmanGUID;
  JSON.S['strTrainPlanGUID'] := strTrainPlanGUID;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCJiaoBan.FindUnCancel',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.B['result'];

  if Result then
  begin
    callWork.FromJson(JSON.O['callWork']);
  end;
  
end;

procedure TRsLCCallNotify.GetByStateRange(startState, endState: Integer;
  dtStartSendTime: TDateTime; NotCancel: Boolean;
  out callWorkAry: TRSCallNotifyAry);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.I['startState'] := startState;
  JSON.I['endState'] := endState;
  JSON.S['dtStartSendTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStartSendTime);
  JSON.B['NotCancel'] := NotCancel;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCJiaoBan.GetByStateRange',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  JSON := JSON.O['callWorkAry'];

  SetLength(callWorkAry,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    callWorkAry[i].FromJson(JSON.AsArray[i]);
  end;
  
end;

end.
