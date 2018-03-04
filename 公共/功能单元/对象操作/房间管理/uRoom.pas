unit uRoom;

interface

type
//////////////////////////////////////////////////////////////////////////////
//房间信息
//////////////////////////////////////////////////////////////////////////////
RRoom = record
  RoomNumber : string;  //房间号
  MaxCount : Integer;     //最大容纳人数
  AreaGUID : string ;   //所属区域
  nDeveiveID:Integer;//设备ID
  public
    procedure Init;
end;
implementation

{ RRoom }

procedure RRoom.Init;
begin
  RoomNumber := '';
  MaxCount := 2;
  nDeveiveID :=0 ;
  AreaGUID := '';
end;

end.
