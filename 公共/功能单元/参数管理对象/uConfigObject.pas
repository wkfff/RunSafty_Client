unit uConfigObject;

interface
uses ADODB,DB,SysUtils, Variants, Classes,IniFiles;

Type
  {�����ļ�����,���������ݿ���������ļ�}
  ConfigType = (ctDB,ctIni);

  {TConfigObject �����ļ���������}
  TConfigObject = class
  public
    constructor Create();
    destructor Destroy; override; 
  private
    m_ADOQuery : TADOQuery;
    m_ADOConnection : TADOConnection;
    {INI�ļ�����}
    m_strIniFileName : String;
    {������}
    m_strTableName : string;
    {Section�ֶ�����}
    m_strSection : String;
    {Ident�ֶ�����}
    m_strIdent : String;
    {Value�ֶ�����}
    m_strValue : String;
  private
    procedure SetADOConnection(ADOConnection : TADOConnection);
  public
    {����:�����ݿ��л�������ļ���ֵ}
    function GetValue_DB(strSection,strIdent:String):String;
    {����:��INI�ļ��л�������ļ���ֵ}
    function GetValue_INI(strSection,strIdent:String):String;

    {����:������������ݿ���}
    procedure SetValue_DB(strSection,strIdent,strValue:String);
    {����:���������INI�ļ���}
    procedure SetValue_INI(strSection,strIdent,strValue:String);
  public
    property IniFileName : String read m_strIniFileName write m_strIniFileName;
    property ADOConnection : TADOConnection read m_ADOConnection
        write SetADOConnection;
  end;


implementation

{ TConfigObject }

constructor TConfigObject.Create();
begin
  m_ADOQuery := TADOQuery.Create(nil);
  m_strTableName := 'tabSysConfig';
  m_strSection := 'strSection';
  m_strIdent := 'strIdent';
  m_strValue := 'strValue';  
end;

destructor TConfigObject.Destroy;
begin
  m_ADOQuery.Free;
  inherited;
end;

function TConfigObject.GetValue_DB(strSection, strIdent: String): String;
{����:�����ݿ��л�������ļ���ֵ}
var
  strSQLText : String;
begin
  Result := '';
  if m_ADOConnection.Connected = False then Exit;  
  strSQLText := format('Select * from %s where %s = %s And %s = %s',
      [m_strTableName,m_strSection,QuotedStr(strSection),m_strIdent,
      QuotedStr(strIdent)]);

  m_ADOQuery.SQL.Text := strSQLText;
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount > 0 then
    Result := Trim(m_ADOQuery.FieldByName(m_strValue).AsString);
  m_ADOQuery.Close;

end;

function TConfigObject.GetValue_INI(strSection, strIdent: String): String;
{����:��INI�ļ��л�������ļ���ֵ}
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(m_strIniFileName);
  try
    Result := Trim(ini.ReadString(strSection, strIdent, ''));
  finally
    Ini.Free;
  end;
end;

procedure TConfigObject.SetADOConnection(ADOConnection: TADOConnection);
begin
  m_ADOConnection := ADOConnection;
  m_ADOQuery.Connection := ADOConnection;
end;

procedure TConfigObject.SetValue_DB(strSection, strIdent, strValue: String);
{����:������������ݿ���}
var
  strSQLText : String;
begin

  strSQLText := format('Select * from %s where %s = %s And %s = %s',
      [m_strTableName,m_strSection,QuotedStr(strSection),m_strIdent,
      QuotedStr(strIdent)]);

  m_ADOQuery.SQL.Text := strSQLText;
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount > 0 then
    m_ADOQuery.Edit
  else
    m_ADOQuery.Append;
  m_ADOQuery.FieldByName(m_strSection).AsString := strSection;
  m_ADOQuery.FieldByName(m_strIdent).AsString := strIdent;
  m_ADOQuery.FieldByName(m_strValue).AsString := Trim(strValue);
  m_ADOQuery.Post;
  m_ADOQuery.Close;
end;

procedure TConfigObject.SetValue_INI(strSection, strIdent, strValue: String);
{����:���������INI�ļ���}
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(m_strIniFileName);
  try
    ini.WriteString(strSection, strIdent, Trim(strValue));
  finally
    Ini.Free;
  end;
end;

end.
