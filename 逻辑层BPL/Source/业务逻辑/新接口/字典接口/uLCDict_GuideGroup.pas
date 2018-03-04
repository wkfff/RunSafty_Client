unit uLCDict_GuideGroup;

interface
  uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject,uGuideGroup;
type
  //ָ����ӿ�
  TRsLCGuideGroup = class(TBaseWebInterface)
  public
    //��ȡ����������ָ����
    procedure GetGuideGroupOfWorkShop(WorkShopGUID : string;out GuideGroupArray : TRsGuideGroupArray);
    //����ָ�������ƻ�ȡ��Ӧ��GUID
    function GetGuideGroupGUIDByName(GuideGroupName : string) : string;
  private
    //JSONתָ����
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
      Raise Exception.Create('��ȡָ����ʧ�ܣ�' + E.Message);
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
  //ָ����GUID
  GuideGroup.strGuideGroupGUID := json.S['strGuideGroupGUID'];
  //��������
  GuideGroup.strWorkShopGUID := json.S['strWorkShopGUID'];
  //ָ��������
  GuideGroup.strGuideGroupName := json.S['strGuideGroupName'];    
end;

end.
