unit uSickLeave;

interface
type
  //销假信息
  RRsSickLeave = record
    //销假人GUID
    strTrainmanGUID : string;
    //销假后归属车站GUID
    strStationGUID : string;
    //销假时间
    dtSickTime : TDateTime;
    //值班员GUID
    strDutyUserGUID : string;
  end;
implementation

end.
