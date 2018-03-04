unit uRoomWait;

interface
type
  RWaitPlan = record
    strGUID: string;
    strTrainNo: string; //����
    nRoomID: Integer; //�����
    dtCallTime: TDateTime; //�а�ʱ��
    dtStartTime: TDateTime; //����ʱ��
    bIsUsed: Boolean; //�Ƿ�����
    strAreaGUID: string; //��������
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
