unit RsLibHelper;

interface
uses
  Forms,RsGlobal_TLB,RsNameplateLib_TLB,uTFComObject;
type
  //运安类库调用助手
  TRsLibHelper = class
  private
    _LibPath : string;
    _GlobalLib : IGlobal;
    _NameplateLib : IRsNameplate;
    procedure Unload;
  public
    constructor Create(LibPath : string);
    destructor Destroy;override;
  public
    //全局基础数据类库对象
    function GlobalLib : IGlobal;
    //全局名牌类库对象
    function NameplateLib : IRsNameplate;
  end;
  //运安类库助手工厂类
  TRsLibHelperFactory = class
    class function Helper : TRsLibHelper; 
  end;
implementation
uses
  SysUtils,uGlobalDM;
var
  _RsLibHelper :  TRsLibHelper;
{ TRsLibHelper }

constructor TRsLibHelper.Create(LibPath: string);
begin
  _LibPath := LibPath;
  _GlobalLib := nil;
  _NameplateLib := nil;
end;

destructor TRsLibHelper.Destroy;
begin
  Unload;
end;

function TRsLibHelper.GlobalLib: IGlobal;
begin
  if _GlobalLib = nil then
  begin
    _GlobalLib := TTFComObject.GetIF(_LibPath + 'RsGlobal.dll',CLASS_Global) as IGlobal;
    _GlobalLib.GetProxy.AppHandle := Application.Handle;

    _GlobalLib.GetProxy.Site.ID := GlobalDM.SiteInfo.strSiteGUID;
    _GlobalLib.GetProxy.Site.Number :=GlobalDM.SiteInfo.strSiteIP;
    _GlobalLib.GetProxy.Site.Name := GlobalDM.SiteInfo.strSiteName;


    _GlobalLib.GetProxy.User.ID := GlobalDM.LogUserInfo.strDutyUserGUID;
    _GlobalLib.GetProxy.User.Number := GlobalDM.LogUserInfo.strDutyNumber;
    _GlobalLib.GetProxy.User.Name := GlobalDM.LogUserInfo.strDutyUserName;

    _GlobalLib.GetProxy.WorkShop.ID := GlobalDM.SiteInfo.WorkShopGUID;
    _GlobalLib.GetProxy.WorkShop.Name := '';
  end;
  Result := _GlobalLib;
end;

function TRsLibHelper.NameplateLib: IRsNameplate;
begin
  if _NameplateLib = nil then
  begin
    _NameplateLib := TTFComObject.GetIF(_LibPath + 'RsNameplateLib.dll',CLASS_RsNameplate) as IRsNameplate;
  end;
  Result := _NameplateLib;
end;

procedure TRsLibHelper.Unload;
begin
  _LibPath := '';
  _GlobalLib := nil;
  _NameplateLib := nil;
  inherited;
end;

{ TRsLibHelperFactory }

class function TRsLibHelperFactory.Helper: TRsLibHelper;
begin
  if _RsLibHelper = nil then
  begin
    _RsLibHelper := TRsLibHelper.Create(GlobalDM.AppPath + 'libs\');
    _RsLibHelper.GlobalLib;
  end;
  result := _RsLibHelper;  
end;


initialization

finalization
  if _RsLibHelper <> nil then
    FreeAndNil(_RsLibHelper);
end.
