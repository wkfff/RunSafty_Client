unit uLCCommon;


interface

uses
  SysUtils,superobject,uBaseWebInterface,uJiWuDuan;

type

  RRsNameValue = record
    strName:string;   //名字
    strValue:string;  //值
  end;

  TRsNameValueList = array of  RRsNameValue ;



  TRsLCCommon = class(TBaseWebInterface)
  public
    //获取数据库配置
    function GetDBSysConfig(SectionName, Ident: string;out ErrStr:string):string;
    //设置数据库配置
    function SetDBSysConfig(const SectionName, Ident, Value: string;out ErrStr:string): boolean;
    //获取客户端配置
    function GetSiteConfig(SiteNumber:string;var NameValueList:TRsNameValueList;out ErrStr:string):Boolean;
    //获取服务器时间
    function GetNow(out ErrStr:string):TDateTime;
    //根据车次获取客货类型
    function GetKehuoByCheCi(TrainNo:string;out ErrStr:string) : string;
    //获取机务段信息
    function GetJiWuDuanInfo(var JiWuDuanList:TRsJiWuDuanArray;out ErrStr:string) : Boolean;
  end;


implementation

{ TRsLCCommon }

function TRsLCCommon.GetDBSysConfig(SectionName, Ident: string;
  out ErrStr: string): string;
var
  json: ISuperObject;
  strResult : string ;
begin
  ErrStr := '';
  json := CreateInputJson;
  json.S['SectionName'] := SectionName ;
  json.S['Ident'] := Ident ;
  try
    strResult := Post('TF.Runsafty.Utility.TGlobalDM.GetDBSysConfig',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    Result := json.S['strValue'] ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCCommon.GetJiWuDuanInfo(var JiWuDuanList: TRsJiWuDuanArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  try

    strResult := Post('TF.RunSafty.TGlobalDM.GetJwdInfo',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(JiWuDuanList,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      with JiWuDuanList[i] do
      begin
        nID := jsonArray[i].I['nID'] ;
        strJWDName := jsonArray[i].S['strJWDName'];
        strJWDNumber := jsonArray[i].S['strJWDNumber'];
        strIp := jsonArray[i].S['strIp'];          //ip
        nWebHtmlPort:= jsonArray[i].I['nWebHtmlPort']; //网页端口
        nWebApiPort := jsonArray[i].I['nWebApiPort'];  //接口端口
      end;
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCCommon.GetKehuoByCheCi(TrainNo: string;
  out ErrStr: string): string;
var
  json: ISuperObject;
  strResult : string ;
begin
  json := CreateInputJson;
  json.S['TrainNo'] := TrainNo ;
  try
    strResult := Post('TF.Runsafty.Utility.TGlobalDM.GetKehuoByCheCi',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    Result := json.S['Kehuo'] ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCCommon.GetNow(out ErrStr:string): TDateTime;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := Now;
  json := CreateInputJson;
  try
    strResult := Post('TF.Runsafty.Utility.TGlobalDM.GetNow',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    Result := StrToDateTime(json.S['now']) ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCCommon.GetSiteConfig(SiteNumber:string;var NameValueList: TRsNameValueList;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['SiteNumber'] := SiteNumber ;
  try

    strResult := Post('TF.Runsafty.Utility.TGlobalDM.GetSiteConfig',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(NameValueList,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      with NameValueList[i] do
      begin
        strName := jsonArray[i].S['strName'];
        strValue := jsonArray[i].S['strValue'];
      end;
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCCommon.SetDBSysConfig(const SectionName, Ident, Value: string;
  out ErrStr: string): boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['SectionName'] :=  SectionName ;
  json.S['Ident'] :=  Ident ;
  json.S['Value'] :=  Value ;
  try
    strResult := Post('TF.Runsafty.Utility.TGlobalDM.SetDBSysConfig',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

end.
