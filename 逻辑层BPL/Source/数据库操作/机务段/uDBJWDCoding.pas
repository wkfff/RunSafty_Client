unit uDBJWDCoding;

interface

uses
  uJWD,ADODB,uTFSystem;

type
  {机务段数据操作类}
  TRsDBJWDCoding = class(TDBOperate)
  public
    procedure GetAllJwdList(var JWDArray:TRsJWDArray);
  end;
  

implementation

{ TRsDBJWD }

procedure TRsDBJWDCoding.GetAllJwdList(var JWDArray: TRsJWDArray);
var
  i : Integer ;
  strSql : string;
  adoQuery : TADOQuery;
begin
  i := 0 ;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from Tab_Base_JWDCoding where 1 = 1  order by nid ';
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        SetLength(JWDArray,RecordCount);
        while Not adoQuery.Eof do
        begin
          JWDArray[i].nID :=  FieldByName('nID').AsInteger;
          JWDArray[i].strCode := FieldByName('strCode').AsString;
          JWDArray[i].strName := FieldByName('strName').AsString;

          JWDArray[i].strShortName := FieldByName('strShortName').AsString;
          JWDArray[i].strPinYinCode :=  FieldByName('strPinYinCode').AsString;
          JWDArray[i].strStatCode :=  FieldByName('strStatCode').AsString;
          JWDArray[i].strUserCode :=  FieldByName('strUserCode').AsString;
          JWDArray[i].strLJCode :=  FieldByName('strLJCode').AsString;
          JWDArray[i].dtLastModify := FieldByName('dtLastModify').AsDateTime;
          Inc(i);
          adoQuery.Next ;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
