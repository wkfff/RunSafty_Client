unit uRoomWait;

interface
uses
  Classes, SysUtils, Forms, windows, adodb;
type
  RRsWaitPlan = record
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

  RRsWaitPlanRecord = record
    strGUID : string;
    strTrainNo : string;
    nRoomID : integer;
    dtCallTime : TDateTime;
    dtStartTime : TDateTime;
    strAreaGUID : string;
    nCallCount : integer;
    strPlanGUID : string;
  end;


implementation

{ RWaitPlan }

procedure RRsWaitPlan.Init;
begin
  strGUID := '';
  bIsUsed := False;
  nRoomID := -1;
  strAreaGUID := '';
end;

end.

