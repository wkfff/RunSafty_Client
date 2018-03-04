unit uLCDict_WorkShop;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uWorkShop,superobject;
type
  //车间信息接口
  TRsLCWorkShop = class(TBaseWebInterface)
  public
    {功能:获取机务段下所有车间}
    function GetWorkShopOfArea(AreaGUID : string;out WorkShopArray : TRsWorkShopArray;
      out ErrStr: string): Boolean;
    {功能:根据车间名称获取对应的GUID}
    function GetWorkShopGUIDByName(WorkShopName : string): string;
  private
    {功能:JSON反序列化为结构体}
    procedure jsonToJwd(iJson: ISuperObject;var WorkShop: RRsWorkShop);
  end;
implementation

{ TRsLCJwd }

function TRsLCWorkShop.GetWorkShopGUIDByName(WorkShopName : string): string;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['WorkShopName'] := WorkShopName;
  strResult := Post('TF.RunSafty.BaseDict.LCWorkShop.GetWorkShopGUIDByName',json.AsString);

  json.Clear();
    
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;
  
  Result := json.S['strWorkShopGUID'];
end;

function TRsLCWorkShop.GetWorkShopOfArea(AreaGUID : string;out WorkShopArray : TRsWorkShopArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  try
    json.S['AreaGUID'] := AreaGUID;
    strResult := Post('TF.RunSafty.BaseDict.LCWorkShop.GetWorkShopOfArea',json.AsString);

    json.Clear();
    
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;


    SetLength(WorkShopArray,json.AsArray.Length);
    for I := 0 to json.AsArray.Length - 1 do
    begin
      jsonToJwd(json.AsArray[i],WorkShopArray[i]);
    end;

    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

procedure TRsLCWorkShop.jsonToJwd(iJson: ISuperObject; var WorkShop: RRsWorkShop);
begin
  //车间GUID
  WorkShop.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //所属机务段GUID
  WorkShop.strAreaGUID := iJson.S['strAreaGUID'];
  //车间名称                              
  WorkShop.strWorkShopName := iJson.S['strWorkShopName'];     
end;                          
end.
