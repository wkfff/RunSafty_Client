unit uLCDict_TrainJiaoLu;

interface
uses
  SysUtils,superobject,uBaseWebInterface,uTrainJiaolu;


type
  TRsLCTrainJiaolu = class(TBaseWebInterface)
  public
    //��ȡ������·�µ���Ա��·��Ϣ
    procedure GetTrainJiaoluArrayOfSite(SiteGUID: string;out TrainJiaoluArray: TRsTrainJiaoluArray);
    //��ȡ�������������
    procedure GetTrainJiaoluArrayOfWorkShop(WorkShopGUID: string;out TrainJiaoluArray: TRsTrainJiaoluArray);
    //��ȡȫ����·
    procedure GetAllTrainJiaolu(out TrainJiaoluArray: TRsTrainJiaoluArray);
    //ͨ����·����ȡ��·GUID
    function GetTrainJiaoluGUIDByName(TrainJiaoluName: string): string;
    //��ȡ��·��Ϣ
    function GetTrainJiaolu(TrainJiaoluGUID : string;var TrainJiaolu : RRsTrainJiaolu): Boolean;
    //�жϽ�·�Ƿ����ڿͻ��˹�Ͻ
    function IsJiaoLuInSite(TrainJiaoluGUID,SiteGUID: string): Boolean;
    //�޸���Ա��֯���
    procedure UpdateOrg(TrainmanNumber,AreaGUID,WorkShopGUID,TrainjiaoluGUID : string;
      UserID,UserName,UserNumber : string);

  private
      //json->trainmanjiaolu
    procedure JsonToTrainJiaolu(var RsTrainJiaolu: RRsTrainJiaolu;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainJiaolu }

procedure TRsLCTrainJiaolu.GetAllTrainJiaolu(
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.GetAllTrainJiaolu',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    jsonArray := json.AsArray;
    SetLength(TrainJiaoluArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainJiaolu(TrainJiaoluArray[i],jsonArray[i]);
    end;
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;

function TRsLCTrainJiaolu.GetTrainJiaolu(TrainJiaoluGUID: string;
  var TrainJiaolu: RRsTrainJiaolu): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['strTrainJiaoluGUID'] := TrainJiaoluGUID ;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.GetTrainJiaolu',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    jsonArray := json.AsArray;

    Result := jsonArray.Length > 0;
    if Result then
    begin
      JsonToTrainJiaolu(TrainJiaolu,json);
    end;
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;
procedure TRsLCTrainJiaolu.GetTrainJiaoluArrayOfSite(
  SiteGUID: string; out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['SiteGUID'] := SiteGUID ;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.GetTrainJiaoluArrayOfSite',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    jsonArray := json.AsArray;
    SetLength(TrainJiaoluArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainJiaolu(TrainJiaoluArray[i],jsonArray[i]);
    end;
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;




procedure TRsLCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(WorkShopGUID: string;
  out TrainJiaoluArray: TRsTrainJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  try
    json.S['strWorkShopGUID'] := WorkShopGUID;
    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.GetTrainJiaoluArrayOfWorkShop',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    jsonArray := json.AsArray;
    SetLength(TrainJiaoluArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainJiaolu(TrainJiaoluArray[i],jsonArray[i]);
    end;
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;

function TRsLCTrainJiaolu.GetTrainJiaoluGUIDByName(
  TrainJiaoluName: string): string;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  try
    json.S['TrainJiaoluName'] := TrainJiaoluName;
    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.GetTrainJiaoluGUIDByName',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    Result := json.S['strTrainJiaoluGUID'];
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;


function TRsLCTrainJiaolu.IsJiaoLuInSite(TrainJiaoluGUID,
  SiteGUID: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  try
    json.S['TrainJiaoluGUID'] := TrainJiaoluGUID;
    json.S['SiteGUID'] := SiteGUID;

    strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.IsJiaoLuInSite',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);

    Result := json.B['result'];
  except
    on e:Exception do
    begin
      Raise Exception.Create('��ȡ������·ʧ�ܣ�' + E.Message);
    end;
  end;
end;


procedure TRsLCTrainJiaolu.JsonToTrainJiaolu(
  var RsTrainJiaolu: RRsTrainJiaolu; Json: ISuperObject);
begin
  RsTrainJiaolu.strTrainJiaoluGUID := Json.S['strTrainJiaoluGUID'];
  RsTrainJiaolu.strTrainJiaoluName := Json.S['strTrainJiaoluName'];
  RsTrainJiaolu.strStartStation := Json.S['strStartStation'];
  RsTrainJiaolu.strEndStation := Json.S['strEndStation'];
  RsTrainJiaolu.strWorkShopGUID := Json.S['strWorkShopGUID'];
  RsTrainJiaolu.bIsBeginWorkFP := Json.i['bIsBeginWorkFP'];
  RsTrainJiaolu.strStartStationName := Json.S['strStartStationName'];
  RsTrainJiaolu.strEndStationName := Json.S['strEndStationName'];
end;

procedure TRsLCTrainJiaolu.UpdateOrg(TrainmanNumber, AreaGUID, WorkShopGUID,
  TrainjiaoluGUID, UserID, UserName, UserNumber: string);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['TrainmanNumber'] := TrainmanNumber ;
  json.S['AreaGUID'] := AreaGUID ;
  json.S['WorkShopGUID'] := WorkShopGUID ;
  json.S['TrainJiaoluGUID'] := TrainJiaoluGUID ;
  json.S['DutyUserGUID'] := UserID ;
  json.S['DutyUserNumber'] := UserNumber ;
  json.S['DutyUserName'] := UserName ;
  try
    strResult := Post('TF.RunSafty.LCTrainmanMgr.UpdateTMOrg',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      raise Exception.Create(ErrStr);
  except
    on e:Exception do
    begin
      Raise Exception.Create('�޸���Ա��֯���ʧ�ܣ�' + E.Message);
    end;
  end;
end;

end.
