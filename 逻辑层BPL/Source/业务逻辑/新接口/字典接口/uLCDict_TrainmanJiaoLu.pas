unit uLCDict_TrainmanJiaoLu;

interface
uses
  SysUtils,uTrainmanJiaolu,superobject,uBaseWebInterface,uSaftyEnum;


type
  TRsLCTrainmanJiaolu = class(TBaseWebInterface)
  public
    //��ȡ������·�µ���Ա��·��Ϣ
    procedure GetTMJLByTrainJL(TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);

    //��ȡ������·�µ���Ա��·�����������·Ϊ����ȡ�ͻ��˹�Ͻ�����н�·
    procedure GetTMJLByTrainJLWithSite(SiteGUID,TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);

    //��ȡ������·�µ���Ա��·�����������·Ϊ����ȡ�ͻ��˹�Ͻ�����н�·(�������⽻·)
    procedure GetTMJLByTrainJLWithSiteVirtual(SiteGUID,TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
    //��ȡ�ͻ��˹�Ͻ����Ա��·�б���·��Ӧ�����г��ڵ���Ϣ
    procedure GetTMJLOfSite(SiteNumber : string;out JLList : TRsSiteTMJLArray);
  private
      //json->trainmanjiaolu
    procedure JsonToTrainmanJiaolu(var TrainmanJiaolu: RRsTrainmanJiaolu;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainmanJiaolu }
procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJL(
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJL',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;




procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJLWithSite(SiteGUID,
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  json.S['SiteGUID'] := m_strSiteID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJLWithSite',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;
procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(SiteGUID,
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  json.S['SiteGUID'] := m_strSiteID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJLWithSiteVirtual',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;


procedure TRsLCTrainmanJiaolu.GetTMJLOfSite(SiteNumber: string;
  out JLList: TRsSiteTMJLArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
  K: Integer;
begin
  json := CreateInputJson;
  json.S['SiteNumber'] := SiteNumber ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.Site.Trainmanjiaolus',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(JLList,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JLList[i].JlName := jsonArray[i].S['JlName'];
    JLList[i].JlGUID := jsonArray[i].S['JlGUID'];
    JLList[i].JlType :=  TRsJiaoluType(jsonArray[i].I['JlType']);
    SetLength(JLList[i].PlaceList ,jsonArray[i].A['PlaceList'].Length);
    for K := 0 to jsonArray[i].A['PlaceList'].Length - 1 do
    begin
      JLList[i].PlaceList[k].ID := jsonArray[i].A['PlaceList'][k].S['ID'];
      JLList[i].PlaceList[k].Name := jsonArray[i].A['PlaceList'][k].S['Name'];
    end;
  end;
end;

procedure TRsLCTrainmanJiaolu.JsonToTrainmanJiaolu(
  var TrainmanJiaolu: RRsTrainmanJiaolu; Json: ISuperObject);
begin
  with TrainmanJiaolu do
  begin
    strTrainmanJiaoluGUID := Json.S['strTrainmanJiaoluGUID'];
    strTrainmanJiaoluName := Json.S['strTrainmanJiaoluName'];
    nJiaoluType := TRsJiaoluType(Json.I['nJiaoluType']);
    strLineGUID := Json.S['strLineGUID'];
    strTrainJiaoluGUID := Json.S['strTrainJiaoluGUID'];
    nKehuoID := TRsKehuo(Json.I['nKehuoID']);
    nTrainmanTypeID := TRsTrainmanType(Json.I['nTrainmanTypeID']);
    nDragTypeID := TRsDragType(Json.I['nDragTypeID']);
    nTrainmanRunType := TRsRunType(Json.I['nTrainmanRunType'])  ;
    //��ʼ��վGUID
    strStartStationGUID :=  Json.S['strStartStationGUID'];
    //��ʼ��վ����
    strStartStationName :=  Json.S['strStartStationName'];
    //������վGUID
    strEndStationGUID :=   Json.S['strEndStationGUID'];
    //������վ����
    strEndStationName :=  Json.S['strEndStationName'];
    //��������
    strAreaGUID :=   Json.S['strAreaGUID'];
  end;
end;

end.
