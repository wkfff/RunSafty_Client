unit uLCDict_WorkShop;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uWorkShop,superobject;
type
  //������Ϣ�ӿ�
  TRsLCWorkShop = class(TBaseWebInterface)
  public
    {����:��ȡ����������г���}
    function GetWorkShopOfArea(AreaGUID : string;out WorkShopArray : TRsWorkShopArray;
      out ErrStr: string): Boolean;
    {����:���ݳ������ƻ�ȡ��Ӧ��GUID}
    function GetWorkShopGUIDByName(WorkShopName : string): string;
  private
    {����:JSON�����л�Ϊ�ṹ��}
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
  //����GUID
  WorkShop.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //���������GUID
  WorkShop.strAreaGUID := iJson.S['strAreaGUID'];
  //��������                              
  WorkShop.strWorkShopName := iJson.S['strWorkShopName'];     
end;                          
end.
