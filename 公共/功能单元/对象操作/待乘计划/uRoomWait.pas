unit uRoomWait;

interface
type
  RWaitPlan = record
    strGUID: string;
    strTrainNo: string; //车次
    nRoomID: Integer; //房间号
    dtCallTime: TDateTime; //叫班时间
    dtStartTime: TDateTime; //开车时间
    bIsUsed: Boolean; //是否启用
    strAreaGUID: string; //所属区域
    public
  procedure Init;
  end;
implementation

{ RWaitPlan }

procedure RWaitPlan.Init;
begin
  strGUID := '';
  bIsUsed := False;
  nRoomID := -1;
  strAreaGUID := '';
end;

end.
