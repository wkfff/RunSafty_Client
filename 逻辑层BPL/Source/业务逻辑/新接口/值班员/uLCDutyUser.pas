unit uLCDutyUser;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uDutyUser;
type
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TRsLCDutyUser
  /// 说明:值班员信息接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDutyUser = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  Private
    m_WebAPIUtils:TWebAPIUtils;

  public
    class procedure JsonToDutyUser(iJson: ISuperObject;DutyUser: TRsDutyUser);
    //根据用户名获取登录人员信息
    function GetDutyUserByNumber(DutyNumber : string ; DutyUser : TRsDutyUser) : boolean;
    //修改密码
    procedure ResetPassword(UserID,NewPassword : string);

    //获取值班员列表
    procedure GetUserList(UserList: TRsDutyUserList);
  end;
implementation

{ TRsLCDutyUser }

constructor TRsLCDutyUser.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCDutyUser.GetDutyUserByNumber(DutyNumber: string;
  DutyUser: TRsDutyUser): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['DutyNumber'] := DutyNumber;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDutyUser.GetDutyUserByNumber',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.B['bExist'];
  if Result then
    JsonToDutyUser(JSON.O['dutyUser'],DutyUser);
end;

procedure TRsLCDutyUser.GetUserList(UserList: TRsDutyUserList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  DutyUser: TRsDutyUser;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDutyUser.GetUserList',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    DutyUser := TRsDutyUser.Create;
    UserList.Add(DutyUser);
    JsonToDutyUser(JSON.AsArray[i],DutyUser);
  end;

end;


class procedure TRsLCDutyUser.JsonToDutyUser(iJson: ISuperObject;
  DutyUser: TRsDutyUser);
begin
  DutyUser.strDutyGUID := iJson.S['strDutyGUID'];
  DutyUser.strDutyNumber := iJson.S['strDutyNumber'];
  DutyUser.strDutyName := iJson.S['strDutyName'];
  DutyUser.strPassword := iJson.S['strPassword'];
end;

procedure TRsLCDutyUser.ResetPassword(UserID, NewPassword: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['UserID'] := UserID;
  JSON.S['NewPassword'] := NewPassword;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDutyUser.ResetPassword',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

end.
