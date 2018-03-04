unit uDBDutyUser;

interface
uses SysUtils,Classes,ADODB,DB,uDutyUser,Variants,uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDutyUserObjectDB
  /// ˵��:������Ա���ݲ�����
  //////////////////////////////////////////////////////////////////////////////
  TDutyUserDB = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
  public
    {����:���������Ա��Ϣ}
    procedure SaveDutyUser(DutyUser:TDutyUser);
    {����:ɾ��������Ա��Ϣ}
    procedure DeleteDutyUser(strDutyUserID : String);
    {����:����ID��ȡ������Ա��Ϣ}
    function GetDutyUserByGUID(strDutyUserID : String;DutyUser:TDutyUser):Boolean;
    //���ݹ��Ż�ȡֵ��Ա��Ϣ
    function GetDutyUserByNumber(strDutyNumber : string;DutyUser : TDutyUser) : boolean;
    {����:�ж�ָ�����ŵĳ���Ա�Ƿ��Ѿ�����}
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
{����:ɾ��������Ա��Ϣ}
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
{����:�ж�ָ�����ŵĳ���Ա�Ƿ��Ѿ�����}
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
{����:����ID��ȡ������Ա��Ϣ}
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
{����:����ID��ȡ������Ա��Ϣ}
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
{����:���������Ա��Ϣ}
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

