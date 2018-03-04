unit uLeaderExam;

interface
type
  //////////////////////////////////////////////////////////////////////////////
  //干部检查
  //////////////////////////////////////////////////////////////////////////////
  RLeaderExam = record
    GUID : string;
    LeaderGUID : string;    //干部GUID
    AreaGUID : string;     //检查区域GUID
    VerifyID :  Integer;     //验证方式ID
    CreateTime : TDateTime; //检查时间
    DutyGUID : string;      //值班员GUID
    public
      procedure Init;
  end;
implementation

{ RLeaderExam }

procedure RLeaderExam.Init;
begin
  GUID := '';
  LeaderGUID := '';
  AreaGUID := '';
  VerifyID := 0;
  CreateTime := 0;
  DutyGUID := '';
end;

end.
