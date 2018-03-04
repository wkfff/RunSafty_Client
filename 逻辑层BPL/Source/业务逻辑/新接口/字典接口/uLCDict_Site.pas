unit uLCDict_Site;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uSite,superobject,EncdDecd;
type
  //客户端信息接口
  TRsLCSite = class(TBaseWebInterface)
  public
    //根据IP获取相应的岗位信息
    function GetSiteByRelationIP(IP : string;out RealIP:string;SiteJob : integer ;Site : TRsSiteInfo) : boolean;
    //
    function GetSiteByIP(IP : string;Site : TRsSiteInfo) : boolean;
    //获取所有的SIte；
    procedure GetSites(out SiteArray: TRsSiteArray);
    //获取客户端步骤信息
    function GetSiteStepInfo( strSiteID:string; Stream: TMemoryStream;var strError:string):Boolean ;
  private
    function JsonToSite(iJson: ISuperObject): RRsSiteInfo;
    procedure JsonToSiteObj(iJson: ISuperObject;Site : TRsSiteInfo);
  private

  end;
implementation

{ TRsLCJwd }

function TRsLCSite.GetSiteByIP(IP: string; Site: TRsSiteInfo): boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strSiteIP'] := IP;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCSite.GetSiteByIP',json.AsString);

    json.Clear();
    
    if not GetJsonResult(strResult,json,ErrStr) then
      Raise Exception.Create(ErrStr);



    if not json.IsType(stObject) then
      Exit
    else
    begin
      JsonToSiteObj(json,Site);
      Result := True;
    end;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCSite.GetSiteByRelationIP(IP: string; out RealIP: string;
  SiteJob: integer; Site: TRsSiteInfo): boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  Result := False ;
  json := CreateInputJson;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCSite.GetSiteByRelationIP',json.AsString);

    json.Clear();
    
    if not GetJsonResult(strResult,json,ErrStr) then
    begin
      raise Exception.Create(ErrStr);
    end;

    RealIP := json.S['RealIP'];

    if not json.O['siteInfo'].IsType(stObject) then
      Exit
    else
    begin
      JsonToSiteObj(json.O['siteInfo'],Site);
      Result := True;
    end;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


procedure TRsLCSite.GetSites(out SiteArray: TRsSiteArray);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
  I: Integer;
begin
  json := CreateInputJson;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCSite.GetSites',json.AsString);

    json.Clear();
    
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;


    SetLength(SiteArray,json.AsArray.Length);
    for I := 0 to Length(SiteArray) - 1 do
    begin
      SiteArray[i] :=  JsonToSite(json.AsArray[i]);
    end;

  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCSite.GetSiteStepInfo(strSiteID: string; Stream: TMemoryStream;var strError:string):Boolean;
var
  json: ISuperObject;
  strResult : string ;
  StrMem: TStringStream;
begin
  result := false;
  json := CreateInputJson;
  json.S['strSiteID'] := strSiteID;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCSite.GetSiteStepFlowByIP',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,strError) then
      Exit;
    StrMem := TStringStream.Create(json.AsString);
    try
      //如果有Clear方法，则调用Clear.以防外部忘记先清除原有内容;
      if Stream is TMemoryStream then
      begin
        (Stream as TMemoryStream).Clear;
      end;
    
      DecodeStream(StrMem,Stream);
      result := true;
    finally
      StrMem.Free;
    end;
  except
    on e:Exception do
    begin
      strError := e.Message ;
    end;
  end;
end;

function TRsLCSite.JsonToSite(iJson: ISuperObject): RRsSiteInfo;
begin
  Result.strSiteGUID := iJson.S['strSiteGUID'];
  Result.strSiteNumber := iJson.S['strSiteNumber'];
  Result.strSiteName := iJson.S['strSiteName'];
  Result.strAreaGUID := iJson.S['strAreaGUID'];
  Result.nSiteEnable := iJson.I['nSiteEnable'];
  Result.strSiteIP := iJson.S['strSiteIP'];
  Result.nSiteJob := iJson.I['nSiteJob'];
  
  Result.strStationGUID := iJson.S['strStationGUID'];
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  
end;

procedure TRsLCSite.JsonToSiteObj(iJson: ISuperObject; Site: TRsSiteInfo);
var
  I: Integer;
begin
  Site.strSiteGUID := iJson.S['strSiteGUID'];
  Site.strSiteNumber := iJson.S['strSiteNumber'];
  Site.strSiteName := iJson.S['strSiteName'];
  Site.strAreaGUID := iJson.S['strAreaGUID'];
  Site.nSiteEnable := iJson.I['nSiteEnable'];
  Site.strSiteIP := iJson.S['strSiteIP'];
  Site.nSiteJob := iJson.I['nSiteJob'];
  
  Site.strStationGUID := iJson.S['strStationGUID'];
  Site.Tmis := StrToIntDef(iJson.S['strTMIS'],0);
  Site.WorkShopGUID := iJson.S['strWorkShopGUID'];


  SetLength(Site.TrainJiaolus,iJson.O['TrainJiaolus'].AsArray.Length);

  for I := 0 to Length(Site.TrainJiaolus) - 1 do
  begin
    Site.TrainJiaolus[i] := iJson.O['TrainJiaolus'].AsArray[i].AsString;
  end;

  SetLength(Site.JobLimits,iJson.O['JobLimits'].AsArray.Length);


  for I := 0 to Length(Site.JobLimits) - 1 do
  begin
    Site.JobLimits[i].Job := TRsSiteJob(iJson.O['JobLimits'].AsArray[i].I['Job']);
    Site.JobLimits[i].Limimt := TRsJobLimit(iJson.O['JobLimits'].AsArray[i].I['Limimt']);
  end;
end;

end.
