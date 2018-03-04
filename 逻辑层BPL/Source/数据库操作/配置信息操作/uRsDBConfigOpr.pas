unit uRsDBConfigOpr;

interface
uses
  Classes,uTFSystem,SysUtils,ADODB;
type
  TRsDBConfig = class(TDBOperate)
  public
    function GetValue(Section,Ident: string): string;
    procedure SetValue(Section,Ident: string;strValue: string);
  end;
implementation

{ TRsDBConfig }

function TRsDBConfig.GetValue(Section, Ident: string): string;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from tabSysConfig where strSection = %s and strIdent = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(Section),QuotedStr(Ident)]);
    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
      Result := Trim(ADOQuery.FieldByName('strValue').AsString)
    else
      Result := '';
    
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBConfig.SetValue(Section, Ident, strValue: string);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from tabSysConfig where strSection = %s and strIdent = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(Section),QuotedStr(Ident)]);
    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
    begin
      ADOQuery.Edit;
      ADOQuery.FieldByName('strValue').AsString := strValue;
    end
    else
    begin
      ADOQuery.Append;
      ADOQuery.FieldByName('strSection').AsString := Section;
      ADOQuery.FieldByName('strIdent').AsString := Ident;
      ADOQuery.FieldByName('strValue').AsString := strValue; 
    end;

      ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;
end;


end.
