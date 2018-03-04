unit uLCDict_GuideGroup;

interface
  uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject,uGuideGroup;
type
  //指导组接口
  TRsLCGuideGroup = class(TBaseWebInterface)
  public
    //获取车间下所有指导队
    procedure GetGuideGroupOfWorkShop(WorkShopGUID : string;out GuideGroupArray : TRsGuideGroupArray);
    //根据指导队名称获取对应的GUID
    function GetGuideGroupGUIDByName(GuideGroupName : string) : string;
  private
    //JSON转指导组
    procedure jsonToGuideGroup(json: ISuperObject; out GuideGroup: RRsGuideGroup);
  end;
implementation

{ TRsLCGuideGroup }

function TRsLCGuideGroup.GetGuideGroupGUIDByName(
  GuideGroupName: string): string;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  try
    json.S['GuideGroupName'] := GuideGroupName;
    strResult := Post('TF.RunSafty.BaseDict.LCGuideGroup.GetGuideGroupGUIDByName',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    Result := json.S['result'];
  except
    on e:Exception do
    begin
      Raise Exception.Create('获取指导组失败：' + E.Message);
    end;
  end;
end;


procedure TRsLCGuideGroup.GetGuideGroupOfWorkShop(WorkShopGUID: string;
  out GuideGroupArray: TRsGuideGroupArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;

  json.S['strWorkShopGUID'] := WorkShopGUID ;
  
  strResult := Post('TF.RunSafty.BaseDict.LCGuideGroup.GetGuideGroupOfWorkShop',json.AsString);
    
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
    raise Exception.Create(ErrStr);

  jsonArray := json.AsArray;

  SetLength(GuideGroupArray,jsonArray.Length);
  for I := 0 to jsonArray.Length - 1 do
  begin
    jsonToGuideGroup(jsonArray[i],GuideGroupArray[i]);
  end;

end;


procedure TRsLCGuideGroup.jsonToGuideGroup(json: ISuperObject;
  out GuideGroup: RRsGuideGroup);
begin
  //指导组GUID
  GuideGroup.strGuideGroupGUID := json.S['strGuideGroupGUID'];
  //所属车间
  GuideGroup.strWorkShopGUID := json.S['strWorkShopGUID'];
  //指导组名称
  GuideGroup.strGuideGroupName := json.S['strGuideGroupName'];    
end;

end.
