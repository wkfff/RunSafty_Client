unit uLCWriteCardSection;

interface

uses
  SysUtils,Classes,uTrainman,uTrainPlan,superobject,uBaseWebInterface,uSaftyEnum,
    uTrainmanJiaolu,uSection,uHttpCom,IdHTTP;
const
     //获取写卡区段列表
  ADDRESS_SECTION_LIST = '%s/App_API/Public/Plan/SectionList.ashx';
type

    TRSLCWriteCardSection = class(TBaseWebInterface)
    public
      {功能:获取计划对应的写卡区段}
      function GetWriteCardSectionByPlan(strPlanGUID:string;var sectionList:TSectionList;var strErrMsg:string):Boolean;
    private
      {功能:发送http请求,使用老接口}
      function MyPost(AUrl: string;out ErrStr:string): string;
    end;
implementation

{ TRSLCWriteCardSection }

function TRSLCWriteCardSection.GetWriteCardSectionByPlan(strPlanGUID: string;
  var sectionList: TSectionList; var strErrMsg: string): Boolean;
var
  iJson: ISuperObject;
  rHttp: string;
  strURL:string;
begin
  strURL := Format(ADDRESS_SECTION_LIST + '?cid=%s&pid=%s',[m_strUrl,m_strSiteID, strPlanGUID]) ;
  rHttp := MyPost(strURL,strErrMsg);

  iJson := SO(rHttp);

  if (iJson.O['result'] = nil)  then
      raise Exception.Create('获取区段信息返回数据格式错误!');
      
  Result := iJson.I['result'] = 0;
  if not Result then
    raise Exception.Create(iJson.S['resultStr']);
  sectionList.FromString(rHttp);
  result := True;
end;

function TRSLCWriteCardSection.MyPost(AUrl: string;out ErrStr:string): string;
var
  strResult : string;
  http:TIdHTTP;
  listStr: TStrings;
begin
  Result := '' ;
  listStr := TStringList.Create;
  http := TIdHTTP.Create(nil);
  try
    try
      with http do
      begin
        Request.Pragma := 'no-cache';
        Request.CacheControl := 'no-cache';
        Request.Connection := 'close';
        strResult := http.Get(AUrl);
        Result := Utf8ToAnsi(strResult) ;
      end;
    except
      on e:Exception do
      begin
        ErrStr := e.Message ;
      end;
    end;
  finally
    listStr.Free;
    http.Free;
  end;
end;
end.
