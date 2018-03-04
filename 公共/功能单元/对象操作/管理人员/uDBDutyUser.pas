unit uDBDutyUser;

interface
uses SysUtils,Classes,ADODB,DB,uDutyUser,Variants,uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDutyUserObjectDB
  /// 说明:管理人员数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TDutyUserDB = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
  public
    {功能:保存管理人员信息}
    procedure SaveDutyUser(DutyUser:TDutyUser);
    {功能:删除管理人员信息}
    procedure DeleteDutyUser(strDutyUserID : String);
    {功能:根据ID获取管理人员信息}
    function GetDutyUserByGUID(strDutyUserID : String;DutyUser:TDutyUser):Boolean;
    //根据工号获取值班员信息
    function GetDutyUserByNumber(strDutyNumber : string;DutyUser : TDutyUser) : boolean;
    {功能:判断指定工号的乘务员是否已经存在}
    function ExistDutyUserByNumber(strDutyUserNumber : String;
        strExcludeGUID:String=''): Boolean;

  protected
    m_ADOConnection : TADOConnection;
  end;

implementation


{ TDutyUserObjectDB }

constructor TDutyUserDB.Create(ADOConnection: TADOConnection);
begin
  m_ADOConnection := ADOConnection;
end;

procedure TDutyUserDB.DeleteDutyUser(strDutyUserID: String);
{功能:删除管理人员信息}
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Update TAB_Org_DutyUser Set nDeleteState = 1 '+
        ' Where strDutyGUID = '+QuotedStr(strDutyUserID);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TDutyUserDB.ExistDutyUserByNumber(strDutyUserNumber: String;
    strExcludeGUID:String): Boolean;
{功能:判断指定工号的乘务员是否已经存在}
var
  ADOQuery : TADOQuery;
begin
  Result := False;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_DutyUser where strDutyNumber = '+
        QuotedStr(strDutyUserNumber);

    if strExcludeGUID <> '' then
    begin
      ADOQuery.SQL.Text := ADOQuery.SQL.Text +
          ' And strDutyGUID <> '+QuotedStr(strExcludeGUID);
    end;
   
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
end;

function TDutyUserDB.GetDutyUserByGUID(strDutyUserID: String;
  DutyUser: TDutyUser): Boolean;
{功能:根据ID获取管理人员信息}
var
  ADOQuery : TADOQuery;
begin
  Result := False;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_DutyUser where strDutyGUID = '+
        QuotedStr(strDutyUserID);
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      DutyUser.DutyUserGUID := Trim(ADOQuery.FieldByName('strDutyGUID').AsString);
      DutyUser.DutyNumber := Trim(ADOQuery.FieldByName('strDutyNumber').AsString);
      DutyUser.DutyName := Trim(ADOQuery.FieldByName('strDutyName').AsString);
      DutyUser.Password := Trim(ADOQuery.FieldByName('strPassword').AsString);
      DutyUser.AreaGUID := Trim(ADOQuery.FieldByName('strAreaGUID').AsString);
      DutyUser.AreaName := Trim(ADOQuery.FieldByName('strAreaName').AsString);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TDutyUserDB.GetDutyUserByNumber(strDutyNumber: string;
  DutyUser: TDutyUser) : boolean;
{功能:根据ID获取管理人员信息}
var
  ADOQuery : TADOQuery;
begin
  Result := false;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_DutyUser where strDutyNumber = '+
        QuotedStr(strDutyNumber);
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      Result := true;
      DutyUser.DutyUserGUID := Trim(ADOQuery.FieldByName('strDutyGUID').AsString);
      DutyUser.DutyNumber := Trim(ADOQuery.FieldByName('strDutyNumber').AsString);
      DutyUser.DutyName := Trim(ADOQuery.FieldByName('strDutyName').AsString);
      DutyUser.Password := Trim(ADOQuery.FieldByName('strPassword').AsString);
      DutyUser.AreaGUID := Trim(ADOQuery.FieldByName('strAreaGUID').AsString);
      DutyUser.AreaName := Trim(ADOQuery.FieldByName('strAreaName').AsString);
    end;
  finally
    ADOQuery.Free;
  end;

end;

procedure TDutyUserDB.SaveDutyUser(DutyUser: TDutyUser);
{功能:保存管理人员信息}
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;  
    if DutyUser.DutyUserGUID = '' then
      DutyUser.DutyUserGUID := NewGUID;

    ADOQuery.SQL.Text := 'Select * from TAB_Org_DutyUser where strDutyGUID = '+
        QuotedStr(DutyUser.DutyUserGUID);
    ADOQuery.Open;
    if ADOQuery.RecordCount = 0 then
      ADOQuery.Append
    else
      ADOQuery.Edit;
    ADOQuery.FieldByName('strDutyGUID').AsString := DutyUser.DutyUserGUID;
    ADOQuery.FieldByName('strDutyNumber').AsString := DutyUser.DutyNumber;
    ADOQuery.FieldByName('strDutyName').AsString := DutyUser.DutyName;
    ADOQuery.FieldByName('strPassword').AsString := DutyUser.Password;
    ADOQuery.FieldByName('strAreaGUID').AsString := DutyUser.AreaGUID;
    ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;
end;

end.

