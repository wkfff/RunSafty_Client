unit uLCCommon;


interface

uses
  SysUtils,superobject,uBaseWebInterface,uJiWuDuan;

type

  RRsNameValue = record
    strName:string;   //����
    strValue:string;  //ֵ
  end;

  TRsNameValueList = array of  RRsNameValue ;



  TRsLCCommon = class(TBaseWebInterface)
  public
    //��ȡ���ݿ�����
    function GetDBSysConfig(SectionName, Ident: string;out ErrStr:string):string;
    //�������ݿ�����
    function SetDBSysConfig(const SectionName, Ident, Value: string;out ErrStr:string): boolean;
    //��ȡ�ͻ�������
    function GetSiteConfig(SiteNumber:string;var NameValueList:TRsNameValueList;out ErrStr:string):Boolean;
    //��ȡ������ʱ��
    function GetNow(out ErrStr:string):TDateTime;
    //���ݳ��λ�ȡ�ͻ�����
    function GetKehuoByCheCi(TrainNo:string;out ErrStr:string) : string;
    //��ȡ�������Ϣ
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
        nWebHtmlPort:= jsonArray[i].I['nWebHtmlPort']; //��ҳ�˿�
        nWebApiPort := jsonArray[i].I['nWebApiPort'];  //�ӿڶ˿�
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
