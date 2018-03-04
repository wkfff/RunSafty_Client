unit uLocalConn;

interface
uses
  Classes,SysUtils,ADODB,uTFSystem,uOffLine,SuperObject,DB,Windows,
  uJsonSerialize;
type
  TDBOffLineWorkData = class
  private
    class var  _CS: TRTLCriticalSection;
    class procedure Lock();static;
    class procedure Unlock();static;
  public
    class procedure Query(DataList: TOffLineDataList);
    class procedure Add(OffLineData: TOffLineData);
    class procedure Del(ID: integer);
    class function GetTop1(OffLineData: TOffLineData): Boolean;
  end;
  
implementation
type
  TLocalConn = class
  private
    class var _Conn: TADOConnection;
  public
    class procedure Init();
    class procedure Uninit();
    class property Conn: TADOConnection read _Conn;
  end;
  
{ TLocalConn }
class procedure TLocalConn.Init;
begin
  if not Assigned(_Conn) then
  begin
    _Conn := TADOConnection.Create(nil);
    _Conn.LoginPrompt := False;
    _Conn.ConnectionString := Format(ACCESS_CONNECTIONSTRING,[ExtractFilePath(ParamStr(0)) + 'RunSafty.mdb']);
    _Conn.Open();
  end;
end;

class procedure TLocalConn.Uninit;
begin
  if Assigned(_Conn) then
    _Conn.Free;
end;

{ TDBOffLineWorkData }

class procedure TDBOffLineWorkData.Add(OffLineData: TOffLineData);
var
  Qry: TADOQuery;
  Stream: TStringStream;
begin
  Qry := TADOQuery.Create(nil);
  Stream := TStringStream.Create('');
  Lock();
  try
    TLocalConn.Conn.BeginTrans;
    try
      Qry.Connection := TLocalConn.Conn;
      Qry.SQL.Text := 'select * from TAB_Work_OffLine where 1=2';
      Qry.Open();
      Qry.Append;
      Qry.FieldByName('workType').AsInteger := OffLineData.WorkType;
      Qry.FieldByName('createTime').AsDateTime := Now;
      Stream.WriteString(TJsonSerialize.SerializeAsString(OffLineData.Data));
      Stream.Position := 0;
      TBlobField(Qry.FieldByName('data')).LoadFromStream(Stream);
      Qry.Post;
      TLocalConn.Conn.CommitTrans;
    except
      TLocalConn.Conn.RollbackTrans;
      Raise;
    end;

  finally
    Unlock();
    Qry.Free;
    Stream.Free;
  end;
end;

class procedure TDBOffLineWorkData.Del(ID: integer);
var
  Qry: TADOQuery;
begin
  Qry := TADOQuery.Create(nil);
  Lock();
  try
    Qry.Connection := TLocalConn.Conn;
    Qry.SQL.Text := 'delete from TAB_Work_OffLine where  [ID] = :ParamID';
    Qry.Parameters.ParamByName('ParamID').Value := ID;
    Qry.ExecSQL;
  finally
    Unlock();
    Qry.Free;
  end;
end;

class function TDBOffLineWorkData.GetTop1(OffLineData: TOffLineData): Boolean;
var
  Qry: TADOQuery;
  Stream: TStringStream;
begin
  Qry := TADOQuery.Create(nil);
  Qry.Connection := TLocalConn.Conn;
  Stream := TStringStream.Create('');
  Lock();
  try
    Qry.SQL.Text := 'select top 1 * from TAB_Work_OffLine';
    Qry.Open();
    if Qry.RecordCount > 0 then
    begin
      offLineData.ID := Qry.FieldByName('ID').AsInteger;
      offLineData.WorkType := Qry.FieldByName('workType').AsInteger;
      offLineData.CreateTime := Qry.FieldByName('createTime').AsDateTime;

      Stream.Size := 0;
      TBlobField(Qry.FieldByName('data')).SaveToStream(Stream);

      TJsonSerialize.DeSerializeFromString(Stream.DataString,offLineData.Data);
    end;
  finally
    Unlock();
    Qry.Free;
    Stream.Free;
  end;
end;

class procedure TDBOffLineWorkData.Lock;
begin
  EnterCriticalSection(_CS);
end;

class procedure TDBOffLineWorkData.Query(DataList: TOffLineDataList);
var
  Qry: TADOQuery;
  offLineData: TOffLineData;
  Stream: TStringStream;
begin
  Qry := TADOQuery.Create(nil);
  Qry.Connection := TLocalConn.Conn;
  Stream := TStringStream.Create('');
  Lock();
  try
    Qry.SQL.Text := 'select top 1000 * from TAB_Work_OffLine order ID desc';
    Qry.Open();
    while not Qry.Eof do
    begin
      offLineData := TOffLineData.Create;
      DataList.Add(offLineData);
      offLineData.ID := Qry.FieldByName('ID').AsInteger;
      offLineData.WorkType := Qry.FieldByName('workType').AsInteger;
      offLineData.CreateTime := Qry.FieldByName('createTime').AsDateTime;

      Stream.Size := 0;
      TBlobField(Qry.FieldByName('data')).SaveToStream(Stream);

      TJsonSerialize.DeSerializeFromString(Stream.DataString,offLineData.Data);


      Qry.Next;
    end
  finally
    Unlock();
    Qry.Free;
    Stream.Free;
  end;
end;

class procedure TDBOffLineWorkData.Unlock;
begin
  LeaveCriticalSection(_CS);
end;
initialization
  InitializeCriticalSection(TDBOffLineWorkData._CS);
  try
    TLocalConn.Init();
  except
    on E: Exception do
    begin
      Raise Exception.Create('初始化本地连接失败：' + E.Message);
    end;
  end;

finalization
  DeleteCriticalSection(TDBOffLineWorkData._CS);
  TLocalConn.Uninit();
end.
