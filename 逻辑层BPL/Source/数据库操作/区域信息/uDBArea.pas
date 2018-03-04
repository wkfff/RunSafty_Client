unit uDBArea;

interface
uses
  SysUtils,Classes,ADODB,DB,uArea,Variants, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBArea
  /// ˵��:�������ݲ�����
  //////////////////////////////////////////////////////////////////////////////
  TRsDBArea = class
  public
    {����:��������ID��ȡ�������}
    class function GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
    {����:��������������Ϣ}
    class procedure GetAreas(ADOConn : TADOConnection;out AreaArray:TAreaArray);
  end;

implementation

{ TAreaObjectDB }
class function TRsDBArea.GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
{����:��������ID��ȡ�������}
var
  adoQuery : TADOQuery;
begin
  Result := False;
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := 'Select * from View_Org_Area where '+
        'strGUID = '+QuotedStr(AreaGUID);
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      Area.strAreaGUID := ADOQuery.FieldByName('strGUID').AsString;
      Area.strAreaName := ADOQuery.FieldByName('strAreaName').AsString;
      Area.strJWDNumber := ADOQuery.FieldByName('strJWDNumber').AsString;
//      Area.strJWDName := ADOQuery.FieldByName('strJWDName').AsString;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;
class procedure TRsDBArea.GetAreas(ADOConn: TADOConnection; 
  out AreaArray: TAreaArray);
{����:��������ID��ȡ�������}
var
  i : integer;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := 'Select * from View_Org_Area order by strAreaName';
    adoQuery.Open;
    setLength(AreaArray,adoQuery.RecordCount);
    i := 0;
    while not adoQuery.Eof do
    begin
      if adoQuery.RecordCount > 0 then
      begin
        AreaArray[i].strAreaGUID := ADOQuery.FieldByName('strGUID').AsString;
        AreaArray[i].strAreaName := ADOQuery.FieldByName('strAreaName').AsString;
        AreaArray[i].strJWDNumber := ADOQuery.FieldByName('strJWDNumber').AsString;
        AreaArray[i].strJWDName := ADOQuery.FieldByName('strJWDName').AsString;
        inc(i);
      end;
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
  end;

end;

end.
