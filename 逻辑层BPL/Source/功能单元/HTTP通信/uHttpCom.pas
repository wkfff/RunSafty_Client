unit uHttpCom;

interface

uses
  SysUtils,Classes,IdBaseComponent, IdComponent,IdTCPConnection, IdTCPClient, IdHTTP,IdURI,
  wininet,windows,uwiniNet;

type
  //HTTP通信类
  //用于数据的交互
  TRsHttpCom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //发送数据并获取数据
    //URL:地址URL
    //Sendstr：发送数据
    function Post(AUrl:string;DataType:string;const SendStr:string):string;
    function PostStrings(URL: string; Values: TStringS): string;
  private
    //连接超时
    m_ConnectTimeOut: Integer;
  public
    //连接超时属性
    property ConnectTimeOut:Integer read m_ConnectTimeOut write m_ConnectTimeOut ;
  end;

implementation

{ TRsHttp }

constructor TRsHttpCom.Create;
begin
  //m_ConnectTimeOut := 10 ;
end;


destructor TRsHttpCom.Destroy;
begin

  inherited;
end;




function TRsHttpCom.Post(AUrl: string;DataType:string;const SendStr: string): string;
//var
//  strResult : string;
//  http:TIdHTTP;
//  listStr: TStrings;
//  ret: PChar;
begin
  Result := WebPagePost(AUrl,AnsiToUtf8(Format('DataType=%s&data=%s',[DataType,SendStr])));
//  listStr := TStringList.Create;
//  http := TIdHTTP.Create(nil);
//  try
//
//    with http do
//    begin
//      Request.Pragma := 'no-cache';
//      Request.CacheControl := 'no-cache';
//      Request.Connection := 'close';
//      listStr.Values['DataType'] := DataType ;
//      listStr.Values['data'] := AnsiToUtf8(SendStr);
//      strResult := http.Post(AUrl,listStr);
//      Result := Utf8ToAnsi(strResult) ;
//    end;
//  finally
//    listStr.Free;
//    http.Free;
//  end;
end;

function TRsHttpCom.PostStrings(URL: string; Values: TStringS): string;
var
  idHttp: TIdHTTP;
begin
  idHttp := TIdHTTP.Create(nil);
  try
    idHttp.Request.Pragma := 'no-cache';
    idHttp.Request.CacheControl := 'no-cache';
    idHttp.Request.Connection := 'close';

    Result := idHttp.Post(URL, Values);
  finally
    idHttp.Free;
  end;

end;

end.
