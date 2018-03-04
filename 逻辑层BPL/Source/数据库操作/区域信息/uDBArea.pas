unit uDBArea;

interface
uses
  SysUtils,Classes,ADODB,DB,uArea,Variants, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBArea
  /// 说明:区域数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBArea = class
  public
    {功能:根据区域ID获取区域对象}
    class function GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
    {功能:根据所有区域信息}
    class procedure GetAreas(ADOConn : TADOConnection;out AreaArray:TAreaArray);
  end;

implementation

{ TAreaObjectDB }
class function TRsDBArea.GetAreaByGUID(ADOConn : TADOConnection;AreaGUID:String;out Area:RRsArea):Boolean;
{功能:根据区域ID获取区域对象}
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
{功能:根据区域ID获取区域对象}
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
