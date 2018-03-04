unit uDBRoom;

interface
uses
  Classes,uRoom,ADODB,uTFSystem;
type
  //////////////////////////////////////////////////////////////////////////////
  ///房间信息操作累
  //////////////////////////////////////////////////////////////////////////////
  TDBRoom = class
  public
    //是否已经存在指定的房间号
    class function ExistRoom(areaGUID:string;roomNumber:string) : boolean;
    //根据房间号获取房间信息
    class function GetRoom(areaGUID:string;roomNumber:string) : RRoom;
    //获取所有房间信息
    class procedure GetRooms(areaGUID : string;out Rlt : TADOQuery);
    //获取所有房间信息,包括入住的信息
    class procedure GetRoomsWithIn(areaGUID : string; out Rlt :  TADOQuery);
    //获取所有空闲的房间
    class procedure GetSpaceRooms(areaGUID : string;out Rlt : TADOQuery);    
    //添加房间
    class function AddRoom(room:RRoom):boolean;
    //修改房间
    class function UpdateRoom(room:RRoom):boolean;
    //删除房间信息
    class function DeleteRoom(roomNumber:string):boolean;
    //是否已经存在指定的设备ID
    class function ExistDeveice(areaGUID:string;nDeveiceID:Integer) : boolean;
    //获取指定房间的所有车次
    class procedure GetTrainNosInRoom(strRoomNumber : string;out Rlt  : TStrings);
    class function GetTrainNosInRoomString(strRoomNumber : string) : string;
    class procedure SetTrainNosInRoom(strRoomNumber : string; trainNos:TStrings);
    //获取指定车次所在的房间
    class function GetTrainNosRoom(strTrainNo : string) : string;
  end;
implementation
 
{ TRoomOpt }
uses
  uGlobalDM,SysUtils, DB;
  
class function TDBRoom.AddRoom(room: RRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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

class function TDBRoom.DeleteRoom(roomNumber: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Close;
      Sql.Text := 'delete from TAB_System_Room where strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(roomNumber)]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TDBRoom.ExistDeveice(areaGUID: string;
  nDeveiceID: Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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
class function TDBRoom.ExistRoom(areaGUID:string;roomNumber:string) : boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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


class function TDBRoom.GetRoom(areaGUID:string;roomNumber:string): RRoom;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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

class procedure TDBRoom.GetRooms(areaGUID : string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.ADOConn;
    Close;
    Sql.Text := 'select  * from VIEW_System_Room  where strAreaGUID = %s ' +
      ' order by strAreaName,strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class procedure TDBRoom.GetRoomsWithIn(areaGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.ADOConn;
    Close;
    Sql.Text := 'select ' +
      ' dbo.GetTrainmanCountInRoom(strAreaGUID,strRoomNumber) as nTrainmanCount ' +
      ',strRoomNumber,strAreaGUID,strAreaName,nMaxCount from VIEW_System_Room where strAreaGUID=%s order by nTrainmanCount,strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class procedure TDBRoom.GetSpaceRooms(areaGUID : string;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := GlobalDM.ADOConn;
    Close;
    Sql.Text := 'select  * from VIEW_System_Room  where (strRoomNumber not in (select strRoomNumber from VIEW_RestInWaiting_InOutRoom where nState > 1 and strAreaGUID=%s  and nState < 4 and (not strRoomNumber is null)))' +
      ' and strAreaGUID=%s order by strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID),QuotedStr(areaGUID)]);
    Open;
  end;
end;

class PROCEDURE TDBRoom.GetTrainNosInRoom(strRoomNumber: string; out Rlt : TStrings );
var
  ado : TADOQuery;
begin
  Rlt := TStringList.Create;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Close;
      Sql.Text := 'select * from Tab_Room_TrainNoInRoom where strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber)]);
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

class function TDBRoom.GetTrainNosInRoomString(strRoomNumber: string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Close;
      Sql.Text := 'select * from Tab_Room_TrainNoInRoom where strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber)]);
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

class function TDBRoom.GetTrainNosRoom(strTrainNo: string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Close;
      Sql.Text := 'select top 1 strRoomNumber from Tab_Room_TrainNoInRoom where strTrainNo = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strTrainNo)]);
      Open;
      if RecordCount > 0 then
      begin
        Result := Fields[0].Value;
      end;
      

    end;
  finally
    ado.Free;
  end;
end;

class procedure TDBRoom.SetTrainNosInRoom(strRoomNumber: string;
  trainNos: TStrings);
var
  i : integer;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Connection.BeginTrans;
      try
        Close;
        Sql.Text := 'update Tab_Room_TrainNoInRoom Set strRoomNumber = %s where   strRoomNumber=%s';
        Sql.Text := Format(Sql.Text,[QuotedStr(''),QuotedStr(strRoomNumber)]);
        ExecSQL;
          
        for i := 0 to trainNos.Count - 1 do
        begin
          Close;
          if Trim(trainNos[i]) = '' then continue;
          
          Sql.Text := 'update Tab_Room_TrainNoInRoom Set strRoomNumber = %s where strTrainNo = %s';
          Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(trainNos[i])]);
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

class function TDBRoom.UpdateRoom(room: RRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Close;
      Sql.Text :=
      'update TAB_System_Room set strAreaGUID = %s,nMaxCount=%d,nDeveiceID=%d ' +
      '  where strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[
        QuotedStr(room.AreaGUID),room.MaxCount,room.nDeveiveID,
        QuotedStr(room.RoomNumber)]);

      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

{ RRoom }


end.
