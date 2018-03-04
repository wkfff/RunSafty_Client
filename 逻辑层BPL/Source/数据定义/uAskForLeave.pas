unit uAskForLeave;

interface
type
    //���������Ϣ
  RRsLeaveType = record
    //�������ID
    nLeaveTypeID  : integer;
    //�����������
    strLeaveTypeName : string;
  end;
  TRsLeaveTypeArray = array of RRsLeaveType;
  
  ///�����Ϣ
  RRsAskForLeave = record
    //�������
    strTrainmanGUID : string;
    //�������
    LeaveType : RRsLeaveType;
    //���ԭ��
    strLeaveReason : string;
    //���ʱ��
    dtLeaveTime : TDateTime;
    //���ʱ�����죩
    nLeaveLength : integer;
    //��������
    dtCreateTime : TDateTime;
    //ֵ��Ա����
    strDutyUserGUID : string;
  end;
implementation

end.
