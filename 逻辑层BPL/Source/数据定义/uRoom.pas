unit uRoom;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RRsRoom = record
    RoomNumber : string;  //�����
    MaxCount : Integer;     //�����������
    AreaGUID : string ;   //��������
    nDeveiveID:Integer;//�豸ID
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
