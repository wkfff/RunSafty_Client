unit uDBRoom;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,uRoom;
type
  //////////////////////////////////////////////////////////////////////////////
  ///������Ϣ������
  //////////////////////////////////////////////////////////////////////////////
  TRsDBRoom = class
  public
    //���ܣ��Ƿ��Ѿ�����ָ���ķ����
    class function ExistRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string) : boolean;
    //���ܣ����ݷ���Ż�ȡ������Ϣ
    class function GetRoom(ADOConn:TADOConnection ;areaGUID:string;roomNumber:string) : RRsRoom;
    //���ܣ���ȡ���з�����Ϣ
    class procedure GetRooms(ADOConn:TADOConnection ;areaGUID : string;out Rlt : TADOQuery);
    //���ܣ���ȡ���з�����Ϣ,������ס����Ϣ
    class procedure GetRoomsWithIn(ADOConn:TADOConnection ;areaGUID : string; out Rlt :  TADOQuery);
    //���ܣ���ȡ���п��еķ���
    class procedure GetSpaceRooms(ADOConn:TADOConnection ;areaGUID : string;out Rlt : TADOQuery);
    //���ܣ���ӷ���
    class function AddRoom(ADOConn:TADOConnection ;room:RRsRoom):boolean;
    //���ܣ��޸ķ���
    class function UpdateRoom(ADOConn:TADOConnection ;room:RRsRoom):boolean;
    //���ܣ�ɾ��������Ϣ
    class function DeleteRoom(ADOConn:TADOConnection ;roomNumber:string;AreaGUID : string):boolean;
    //���ܣ��Ƿ��Ѿ�����ָ�����豸ID
    class function ExistDeveice(ADOConn:TADOConnection ;areaGUID:string;nDeveiceID:Integer) : boolean;
    //���ܣ���ȡָ����������г���
    class procedure GetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber : string;AreaGUID : string;out Rlt  : TStrings);
    //���ܣ���ȡ��������ס�ĳ��ε��ַ�����ʾ��ʽ
    class function  GetTrainNosInRoomString(ADOConn:TADOConnection ;strRoomNumber : string;AreaGUID : string) : string;
    //���ܣ����÷��侭����ס�ĳ���
    class procedure SetTrainNosInRoom(ADOConn:TADOConnection ;strRoomNumber : string; trainNos:TStrings;AreaGUID : string);
    //���ܣ���ȡ���г�����Ϣ
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
