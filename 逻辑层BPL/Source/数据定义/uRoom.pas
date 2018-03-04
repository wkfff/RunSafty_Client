unit uRoom;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //房价信息
  //////////////////////////////////////////////////////////////////////////////
  RRsRoom = record
    RoomNumber : string;  //房间号
    MaxCount : Integer;     //最大容纳人数
    AreaGUID : string ;   //所属区域
    nDeveiveID:Integer;//设备ID
    public
      procedure Init;
  end;


implementation

{ RRoom }

procedure RRsRoom.Init;
begin
  RoomNumber := '';
  MaxCount := 2;
  nDeveiveID :=0 ;
  AreaGUID := '';
end;

end.
