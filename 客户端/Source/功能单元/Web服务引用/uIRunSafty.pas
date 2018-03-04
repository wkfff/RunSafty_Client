// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://192.168.1.29:9001/RunSaftyService.dll/wsdl/IRunSafty
// Encoding : utf-8
// Version  : 1.0
// (2012-8-8 15:32:39 - 16.03.2006)
// ************************************************************************ //

unit uIRunSafty;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns,uDutyUser,uSite;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:int             - "http://www.w3.org/2001/XMLSchema"
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"

//  TSiteInfo            = class;                 { "192.168.1.29" }
//  TDutyUser            = class;                 { "192.168.1.29" }



//  // ************************************************************************ //
//  // Namespace : 192.168.1.29
//  // ************************************************************************ //
//  TSiteInfo = class(TRemotable)
//  private
//    FstrSiteGUID: string;
//    FstrSiteNumber: string;
//    FstrSiteName: string;
//    FstrAreaGUID: string;
//    FnSiteEnable: Integer;
//    FstrSiteIP: string;
//    FnSiteJob: Integer;
//    FnDeleteState: Integer;
//  published
//    property strSiteGUID: string read FstrSiteGUID write FstrSiteGUID;
//    property strSiteNumber: string read FstrSiteNumber write FstrSiteNumber;
//    property strSiteName: string read FstrSiteName write FstrSiteName;
//    property strAreaGUID: string read FstrAreaGUID write FstrAreaGUID;
//    property nSiteEnable: Integer read FnSiteEnable write FnSiteEnable;
//    property strSiteIP: string read FstrSiteIP write FstrSiteIP;
//    property nSiteJob: Integer read FnSiteJob write FnSiteJob;
//  end;
//
//
//
//  // ************************************************************************ //
//  // Namespace : 192.168.1.29
//  // ************************************************************************ //
//  TDutyUser = class(TRemotable)
//  private
//    FstrDutyGUID: string;
//    FstrDutyNumber: string;
//    FstrDutyName: string;
//    FstrPassword: string;
//    FnDeleteState: Integer;
//    FstrTokenID: string;
//  published
//    property strDutyGUID: string read FstrDutyGUID write FstrDutyGUID;
//    property strDutyNumber: string read FstrDutyNumber write FstrDutyNumber;
//    property strDutyName: string read FstrDutyName write FstrDutyName;
//    property strPassword: string read FstrPassword write FstrPassword;
//    property nDeleteState: Integer read FnDeleteState write FnDeleteState;
//    property strTokenID: string read FstrTokenID write FstrTokenID;
//  end;

  TStringArray = array of string;           { "192.168.1.29" }

  // ************************************************************************ //
  // Namespace : urn:RunSaftyIntf-IRunSafty
  // soapAction: urn:RunSaftyIntf-IRunSafty#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : IRunSaftybinding
  // service   : IRunSaftyservice
  // port      : IRunSaftyPort
  // URL       : http://192.168.1.29:9001/RunSaftyService.dll/soap/IRunSafty
  // ************************************************************************ //
  IRunSafty = interface(IInvokable)
  ['{031C1F5C-A111-10CC-FE92-103CA8C8FFCA}']
    function  GetClientJob(var SiteInfo: TSiteInfo; var ErrorMsg: string): Boolean; stdcall;
    function  GetDutyUser(const DutyNumber: string; const Password: string; var DutyUser: TDutyUser; var ErrorMsg: string): Integer; stdcall;
    function  NotifySendPlan(const PlanGUIDs: TStringArray; var ErrorMsg: string): Boolean; stdcall;
    function  NotifyCancelPlan(const PlanGUIDs: TStringArray; var ErrorMsg: string): Boolean; stdcall;
    function  NotifyReceivePlan(const PlanGUIDs: TStringArray; var ErrorMsg: string): Boolean; stdcall;
    function  GetNotifyCode(const NotifyType: string; var NotifyCode: string; var ErrorMsg: string): Boolean; stdcall;
  end;

function GetIRunSafty(WebServerHost:string;WebServerPort:string;UseWSDL: Boolean=System.False; HTTPRIO: THTTPRIO = nil): IRunSafty;


implementation
uses
  uGlobalDM;
function GetIRunSafty(WebServerHost:string;WebServerPort:string;UseWSDL: Boolean=System.False; HTTPRIO: THTTPRIO = nil): IRunSafty;
const
  defSvc  = 'IRunSaftyservice';
  defPrt  = 'IRunSaftyPort';
var
  RIO: THTTPRIO;
  defWSDL : string;
  defURL : string;
  Addr: string;
begin
  InvRegistry.RegisterInterface(TypeInfo(IRunSafty), 'urn:RunSaftyIntf-IRunSafty', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IRunSafty), 'urn:RunSaftyIntf-IRunSafty#%operationName%');
  RemClassRegistry.RegisterXSClass(TSiteInfo,WebServerHost, 'TSiteInfo');
  RemClassRegistry.RegisterXSClass(TDutyUser, WebServerHost, 'TDutyUser');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TStringArray),WebServerHost, 'TStringArray');
  
  defWSDL := 'http://'+WebServerHost+':'+WebServerPort+'/RunSaftyService.dll/wsdl/IRunSafty';
  defURL  := 'http://'+WebServerHost+':'+WebServerPort+'/RunSaftyService.dll/soap/IRunSafty';

  Result := nil;
  if UseWSDL then
    Addr := defWSDL
  else
    Addr := defURL;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IRunSafty);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;





end.
