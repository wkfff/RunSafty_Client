unit uLeaderExam;

interface
type
  //////////////////////////////////////////////////////////////////////////////
  //�ɲ����
  //////////////////////////////////////////////////////////////////////////////
  RLeaderExam = record
    GUID : string;
    LeaderGUID : string;    //�ɲ�GUID
    AreaGUID : string;     //�������GUID
    VerifyID :  Integer;     //��֤��ʽID
    CreateTime : TDateTime; //���ʱ��
    DutyGUID : string;      //ֵ��ԱGUID
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
