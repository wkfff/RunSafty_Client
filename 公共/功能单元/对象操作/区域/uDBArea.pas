unit uDBArea;

interface
uses SysUtils,Classes,ADODB,DB,uArea,Variants, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TAreaObjectDB
  /// ˵��:�������ݲ�����
  //////////////////////////////////////////////////////////////////////////////
  TDBArea = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
  public
    {����:��ȡȫ����������Ϣ}
    procedure GetAreas(var AreaList:TAreaList);
    {����:ɾ��������Ϣ}
    procedure DeleteArea(strAreaGUID:String);
    {����:��������ID��ȡ�������}
    function GetAreaByGUID(strAreaGUID:String;var AreaObject:TArea):Boolean;
    {����:�����������Ƽ���Ƿ��Ѿ�����}
    function ExistAreaByName(strName : String;strExcludeGUID:String=''): Boolean;
    {����:����������Ϣ}
    procedure SaveArea(Area:TArea);
  protected
    m_ADOConnection : TADOConnection;
  end;

implementation

{ TAreaObjectDB }

constructor TDBArea.Create(ADOConnection: TADOConnection);
begin
  m_ADOConnection := ADOConnection;
end;


procedure TDBArea.DeleteArea(strAreaGUID: String);
{����:ɾ��������Ϣ}
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Update Tab_Org_Area Set nDeleteState = 1 where '+
        'strGUID = '+QuotedStr(strAreaGUID);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
end;

function TDBArea.ExistAreaByName(strName: String;strExcludeGUID:String): Boolean;
{����:�����������Ƽ���Ƿ��Ѿ�����}
var
  ADOQuery : TADOQuery;
begin
  Result := False;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_Area where strAreaName = '+
        QuotedStr(strName);

    if strExcludeGUID <> '' then
    begin
      ADOQuery.SQL.Text := ADOQuery.SQL.Text +
          ' And strGUID <> '+QuotedStr(strExcludeGUID);
    end;
   
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;

end;

function TDBArea.GetAreaByGUID(strAreaGUID: String;
  var AreaObject: TArea): Boolean;
{����:��������ID��ȡ�������}
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  Result := False;
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from View_Org_Area where '+
        'strGUID = '+QuotedStr(strAreaGUID);
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      AreaObject.AreaGUID := strAreaGUID;
      AreaObject.AreaName := Trim(ADOQuery.FieldByName('strAreaName').AsString);
      AreaObject.JWDNumber := Trim(ADOQuery.FieldByName('strJWDNumber').AsString);
      AreaObject.JWDName := Trim(ADOQuery.FieldByName('strJWDName').AsString);
      Result := True;
    end;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
end;

procedure TDBArea.GetAreas(var AreaList: TAreaList);
{����:��ȡȫ����������Ϣ}
var
  AreaObject : TArea;
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_Area';
    ADOQuery.Open;
    AreaList.Clear;
    while ADOQuery.Eof = False do
    begin
      AreaObject := TArea.Create;
      AreaObject.AreaGUID := Trim(ADOQuery.FieldByName('strGUID').AsString);
      AreaObject.AreaName := Trim(ADOQuery.FieldByName('strAreaName').AsString);
      AreaObject.JWDNumber := Trim(ADOQuery.FieldByName('strJWDNumber').AsString);
      AreaObject.JWDName := Trim(ADOQuery.FieldByName('strJWDName').AsString);
      AreaList.Add(AreaObject);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
end;

procedure TDBArea.SaveArea(Area: TArea);
{����:����������Ϣ}
var
  ADOQuery : TADOQuery;
begin
  if Area.AreaGUID = '' then
    Area.AreaGUID := NewGUID();

  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := 'Select * from VIEW_Org_Area where strGUID = '+
        QuotedStr(Area.AreaGUID);
    ADOQuery.Open;
    if ADOQuery.RecordCount = 0 then
      ADOQuery.Append
    else
      ADOQuery.Edit;
    ADOQuery.FieldByName('strGUID').AsString := Area.AreaGUID;
    ADOQuery.FieldByName('strAreaName').AsString := Area.AreaName;
    ADOQuery.FieldByName('strJWDNumber').AsString := Area.JWDNumber;
    ADOQuery.FieldByName('strJWDName').AsString := Area.JWDName;
    ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;
end;

end.
