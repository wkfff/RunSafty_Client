unit uRoom;

interface

type
//////////////////////////////////////////////////////////////////////////////
//������Ϣ
//////////////////////////////////////////////////////////////////////////////
RRoom = record
  RoomNumber : string;  //�����
  MaxCount : Integer;     //�����������
  AreaGUID : string ;   //��������
  nDeveiveID:Integer;//�豸ID
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
