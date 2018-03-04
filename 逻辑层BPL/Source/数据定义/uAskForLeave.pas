unit uAskForLeave;

interface
type
    //请假类型信息
  RRsLeaveType = record
    //请假类型ID
    nLeaveTypeID  : integer;
    //请假类型名称
    strLeaveTypeName : string;
  end;
  TRsLeaveTypeArray = array of RRsLeaveType;
  
  ///请假信息
  RRsAskForLeave = record
    //请假人呢
    strTrainmanGUID : string;
    //请假类型
    LeaveType : RRsLeaveType;
    //请假原因
    strLeaveReason : string;
    //请假时间
    dtLeaveTime : TDateTime;
    //请假时长（天）
    nLeaveLength : integer;
    //创建日期
    dtCreateTime : TDateTime;
    //值班员工号
    strDutyUserGUID : string;
  end;
implementation

end.
