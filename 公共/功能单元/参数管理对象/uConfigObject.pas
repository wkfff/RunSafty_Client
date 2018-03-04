unit uConfigObject;

interface
uses ADODB,DB,SysUtils, Variants, Classes,IniFiles;

Type
  {配置文件类型,可以是数据库或者配置文件}
  ConfigType = (ctDB,ctIni);

  {TConfigObject 配置文件操作对象}
  TConfigObject = class
  public
    constructor Create();
    destructor Destroy; override; 
  private
    m_ADOQuery : TADOQuery;
    m_ADOConnection : TADOConnection;
    {INI文件名称}
    m_strIniFileName : String;
    {表名称}
    m_strTableName : string;
    {Section字段名称}
    m_strSection : String;
    {Ident字段名称}
    m_strIdent : String;
    {Value字段名称}
    m_strValue : String;
  private
    procedure SetADOConnection(ADOConnection : TADOConnection);
  public
    {功能:从数据库中获得配置文件的值}
    function GetValue_DB(strSection,strIdent:String):String;
    {功能:从INI文件中获得配置文件的值}
    function GetValue_INI(strSection,strIdent:String):String;

    {功能:保存配置项到数据库中}
    procedure SetValue_DB(strSection,strIdent,strValue:String);
    {功能:保存配置项到INI文件中}
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
{功能:从数据库中获得配置文件的值}
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
{功能:从INI文件中获得配置文件的值}
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
{功能:保存配置项到数据库中}
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
{功能:保存配置项到INI文件中}
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
