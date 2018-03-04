unit uDBRoom;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,uRoom;
type
  //////////////////////////////////////////////////////////////////////////////
  ///房间信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBRoom = class
  public
    //功能：是否已经存在指定的房间号
    class function ExistRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string) : boolean;
    //功能：根据房间号获取房间信息
    class function GetRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string) : RRsRoom;
    //功能：获取所有房间信息
    class procedure GetRooms(ADOConn:TADOConnection ;areaGUID : string;out Rlt : TADOQuery);
    //功能：获取所有房间信息,包括入住的信息
    class procedure GetRoomsWithIn(ADOConn:TADOConnection ;areaGUID : string; out Rlt :  TADOQuery);
    //功能：获取所有空闲的房间
    class procedure GetSpaceRooms(ADOConn:TADOConnection ;areaGUID : string;out Rlt : TADOQuery);
    //功能：添加房间
    class function AddRoom(ADOConn:TADOConnection ;room:RRsRoom):boolean;
    //功能：修改房间
    class function UpdateRoom(ADOConn:TADOConnection ;room:RRsRoom):boolean;
    //功能：删除房间信息
    class function DeleteRoom(ADOConn:TADOConnection ;roomNumber:string;AreaGUID : string):boolean;
    //功能：是否已经存在指定的设备ID
    class function ExistDeveice(ADOConn:TADOConnection ;areaGUID:string;nDeveiceID:Integer) : boolean;
    //功能：获取指定房间的所有车次
    class procedure GetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber : string;AreaGUID : string;out Rlt  : TStrings);
    //功能：获取房间内入住的车次的字符串表示形式
    class function  GetTrainNosInRoomString(ADOConn:TADOConnection ;strRoomNumber : string;AreaGUID : string) : string;
    //功能：设置房间经常入住的车次
    class procedure SetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber : string; trainNos:TStrings;AreaGUID : string);
    //功能：获取所有车次信息
    class procedure GetTrainNos(ADOConn : TADOConnection;AreaGUID : string;out Rlt : TADOQuery);

  end;
implementation

{ TRoomOpt }
class function TRsDBRoom.AddRoom(ADOConn:TADOConnection ;room: RRsRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'insert into TAB_System_Room (strRoomNumber,nMaxCount,strAreaGUID,nDeveiceID) values '+
        ' (%s,%d,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(room.RoomNumber),
        room.MaxCount,QuotedStr(room.AreaGUID),room.nDeveiveID]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TRsDBRoom.DeleteRoom(ADOConn:TADOConnection ;roomNumber: string;AreaGUID : string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'delete from TAB_System_Room where strRoomNumber = %s and strAreaGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(roomNumber),QuotedStr(AreaGUID)]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TRsDBRoom.ExistDeveice(ADOConn:TADOConnection ;areaGUID: string;
  nDeveiceID: Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'select top 1 * from TAB_System_Room  where strAreaGUID = %s  and nDeveiceID = %d';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID),nDeveiceID]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;
class function TRsDBRoom.ExistRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string) : boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'select top 1 * from TAB_System_Room  where strAreaGUID = %s  and strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID),QuotedStr(roomNumber)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;


class function TRsDBRoom.GetRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string): RRsRoom;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_System_Room  where strAreaGUID = %s and strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID),QuotedStr(roomNumber)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.RoomNumber := FieldByName('strRoomNumber').AsString;
        Result.MaxCount := FieldByName('nMaxCount').AsInteger;
        Result.AreaGUID := FieldByName('strAreaGUID').AsString;
        Result.nDeveiveID := FieldByName('nDeveiceID').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TRsDBRoom.GetRooms(ADOConn:TADOConnection ;areaGUID : string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Close;
    Sql.Text := 'select  * from VIEW_System_Room  where strAreaGUID = %s ' +
      ' order by strAreaName,strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class procedure TRsDBRoom.GetRoomsWithIn(ADOConn:TADOConnection ;areaGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Close;
    Sql.Text := 'select ' +
      ' dbo.GetTrainmanCountInRoom(strAreaGUID,strRoomNumber) as nTrainmanCount ' +
      ',strRoomNumber,strAreaGUID,strAreaName,nMaxCount from VIEW_System_Room where strAreaGUID=%s order by nTrainmanCount,strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class procedure TRsDBRoom.GetSpaceRooms(ADOConn:TADOConnection ;areaGUID : string;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := ADOConn;
    Close;
    Sql.Text := 'select  * from VIEW_System_Room  where (strRoomNumber not in (select strRoomNumber from VIEW_RestInWaiting_InOutRoom where nState > 1 and strAreaGUID=%s  and nState < 4 and (not strRoomNumber is null)))' +
      ' and strAreaGUID=%s order by strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID),QuotedStr(areaGUID)]);
    Open;
  end;
end;


class procedure TRsDBRoom.GetTrainNos(ADOConn : TADOConnection;areaGUID: string; out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Close;
    Sql.Text := 'select strTrainNo from VIEW_Plan_Train where strAreaGUID = %s group by strTrainNo order by strTrainNo';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class PROCEDURE TRsDBRoom.GetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber: string;AreaGUID : string; out Rlt : TStrings );
var
  ado : TADOQuery;
begin
  Rlt := TStringList.Create;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'select strTrainNo from TAB_Base_TrainNoInRoom where strRoomNumber = %s and strAreaGUID = %s order by strTrainNo';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(AreaGUID)]);
      Open;
      while not eof  do
      begin
        Rlt.Add(FieldByName('strTrainNo').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TRsDBRoom.GetTrainNosInRoomString(ADOConn:TADOConnection ;strRoomNumber: string;AreaGUID : string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'select strTrainNo from TAB_Base_TrainNoInRoom where strRoomNumber = %s and strAreaGUID = %s order by strTrainNo';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(AreaGUID)]);
      Open;
      while not eof  do
      begin
        if Result = '' then
          Result := FieldByName('strTrainNo').AsString
        else
          Result := Result + ',' + FieldByName('strTrainNo').AsString;
        next;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TRsDBRoom.SetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber: string;
  trainNos: TStrings;AreaGUID : string);
var
  i : integer;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Connection.BeginTrans;
      try
        Close;
        Sql.Text := 'delete from  TAB_Base_TrainNoInRoom where   strRoomNumber=%s and strAreaGUID = %s';
        Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(AreaGUID)]);
        ExecSQL;
          
        for i := 0 to trainNos.Count - 1 do
        begin
          Close;
          if Trim(trainNos[i]) = '' then continue;
          
          Sql.Text := 'insert into TAB_Base_TrainNoInRoom (strRoomNumber,strTrainNo,strAreaGUID) values (%s,%s,%s)';
          Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(trainNos[i]),QuotedStr(AreaGUID)]);
          ExecSQL;
        end;
        Connection.CommitTrans;
      except
        Connection.RollbackTrans;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TRsDBRoom.UpdateRoom(ADOConn:TADOConnection ;room: RRsRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text :=
      'update TAB_System_Room set nMaxCount=%d,nDeveiceID=%d ' +
      '  where strRoomNumber = %s and strAreaGUID = %s';
      Sql.Text := Format(Sql.Text,[
        room.MaxCount,room.nDeveiveID,
        QuotedStr(room.RoomNumber),QuotedStr(room.AreaGUID)]);

      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;


end.
