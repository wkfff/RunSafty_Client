unit uRsDBInterfaceLogic;

interface
uses
  uRsInterfaceDefine,uTFSystem,uDBRunEvent,uRunEvent,uLogManage;
type
  TRsDBInterface = class(TDBOperate)
  private
    procedure SingleTrainmanEvent(EventID : TRunEventType;CWYEvent: RRSCWYEvent);
    procedure DoubleTrainmanEvent(JCEvent : RRSJCEvent);
    procedure SiteTrainmanEvent(EventID : TRunEventType;CWYEvent: RRSCWYEvent);
    //����⴦���¼�
    procedure DepotsEvent(EventID : TRunEventType;JCEvent : RRSJCEvent);
  public
    {����:��������¼�}
    procedure SaveWorkBeginEvent(CWYEvent: RRSCWYEvent);
    {����:���������¼�}
    procedure SaveWorkEndEvent(CWYEvent: RRSCWYEvent);
    {����:������Ԣ�¼�}
    procedure SaveRoomInEvent(CWYEvent: RRSCWYEvent);
    {����:������Ԣ�¼�}
    procedure SaveRoomOutEvent(CWYEvent: RRSCWYEvent);
    {����:���������Ԣ�¼�}
    procedure SaveSiteRoomInEvent(CWYEvent: RRSCWYEvent);
    {����:���������Ԣ�¼�}
    procedure SaveSiteRoomOutEvent(CWYEvent: RRSCWYEvent);
    {����:�����鿨�¼�}
    procedure SaveOtherYanKaEvent(CWYEvent: RRSCWYEvent);
    {����:��������¼�,����TJCEventType�ж�����}
    procedure SaveOtherJCEvent(JCEvent: RRSJCEvent);
    {����:���浽���¼�}
    procedure SaveOtherReachEvent(JCEvent: RRSJCEvent);
    {����:���������Ϣ}
    procedure SaveInDepots(JCEvent: RRSJCEvent);
    {����:��������¼�}
    procedure SaveOutDepots(JCEvent: RRSJCEvent);
    {����:�����ļ���ʼ�¼�}
    procedure SaveFileBegin(JCEvent: RRSJCEvent);
    {����:�����ļ������¼�}
    procedure SaveFileEnd(JCEvent: RRSJCEvent);
    //����վͣ�¼�
    procedure SaveStop(JCEvent: RRSJCEvent);
  end;

implementation
uses
  SysUtils;
{ TRsDBInterface }
procedure TRsDBInterface.DepotsEvent(EventID: TRunEventType;
  JCEvent: RRSJCEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
  dbRunEvent : TRsDBRunEvent;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  eventID :=  eteNull;
  case   JCEvent.sjbz of
    jceChuKu: eventID := eteOutDepots;
    jceRuKu: eventID := eteInDepots;
    jceTingChe: eventID := eteStopInStation;
    jceKaiChe: eventID := eteStartFromStation;
    jceFileBegin: eventID := eteFileBegin;
    jceFileEnd: eventID := eteFileEnd;
  end;
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    try
      recordGUID := dbRunEvent.DepotsSubmit(JCEvent.etime, JCEvent.tmid1,
        JCEvent.tmid2,JCEvent.stmis, 1, JCEvent.cc, JCEvent.cx,JCEvent.ch,
        0,'',eventID, nResult);
    except on e : exception do
      begin
      nResult := 2;
      strResult := e.message;
      end;
    end;
    if (nResult = 0) then
    begin
      strResult := '��ӳɹ�';
    end;
    if (nResult = 1) then
    begin
      strResult := 'û��ָ������Ա�ļƻ��������Ϣ';
    end;
      dbRunEvent.DepotsSubmitDetail(recordGUID,EventID,JCEvent.etime,
        JCEvent.tmid1,JCEvent.tmid2,JCEvent.stmis,1,JCEvent.cc,
        JCEvent.cx,JCEvent.ch,0,
        '', nResult, strResult);
  finally
    dbRunEvent.Free;
  end;

end;

procedure TRsDBInterface.DoubleTrainmanEvent(JCEvent: RRSJCEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
  dbRunEvent : TRsDBRunEvent;
  eventID : TRunEventType;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  eventID :=  eteNull;
  case   JCEvent.sjbz of
    jceChuKu: eventID := eteOutDepots;
    jceRuKu: eventID := eteInDepots;
    jceTingChe: eventID := eteStopInStation;
    jceKaiChe: eventID := eteStartFromStation;
    jceFileBegin: eventID := eteFileBegin;
    jceFileEnd: eventID := eteFileEnd;
    jceEnterStation: eventID := eteEnterStation;
    jceLeaveStation: eventID := eteLeaveStation;
    jceDiaoCheStop: eventID := eteLastStopStation;
  end;
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    try
      recordGUID := dbRunEvent.TrainSubmit(JCEvent.etime, JCEvent.tmid1,
        JCEvent.tmid2,JCEvent.stmis, 1, JCEvent.cc, JCEvent.cx,JCEvent.ch,
        0,'',eventID, nResult);
    except on e : exception do
      begin
      nResult := 2;
      strResult := e.message;
      end;
    end;
    if (nResult = 0) then
    begin
      strResult := '��ӳɹ�';
    end;
    if (nResult = 1) then
    begin
      strResult := 'û��ָ������Ա�ļƻ��������Ϣ';
    end;
      dbRunEvent.TrainSubmitDetail(recordGUID,EventID,JCEvent.etime,
        JCEvent.tmid1,JCEvent.tmid2,JCEvent.stmis,1,JCEvent.cc,
        JCEvent.cx,JCEvent.ch,0,
        '', nResult, strResult);
  finally
    dbRunEvent.Free;
  end;
end;

procedure TRsDBInterface.SaveFileBegin(JCEvent: RRSJCEvent);
begin
  DoubleTrainmanEvent(JCEvent);
end;

procedure TRsDBInterface.SaveFileEnd(JCEvent: RRSJCEvent);
begin
  DoubleTrainmanEvent(JCEvent);
end;

procedure TRsDBInterface.SaveInDepots(JCEvent: RRSJCEvent);
begin
  DepotsEvent(eteInDepots,JCEvent);
end;

procedure TRsDBInterface.SaveOtherJCEvent(JCEvent: RRSJCEvent);
begin
  DoubleTrainmanEvent(JCEvent);
end;

procedure TRsDBInterface.SaveOtherReachEvent(JCEvent: RRSJCEvent);
begin
  // JCEvent.
end;


procedure TRsDBInterface.SaveOtherYanKaEvent(CWYEvent: RRSCWYEvent);
begin
  SingleTrainmanEvent(eteVerifyCard,CWYEvent);
end;

procedure TRsDBInterface.SaveOutDepots(JCEvent: RRSJCEvent);
begin
  DepotsEvent(eteOutDepots,JCEvent);
end;

procedure TRsDBInterface.SaveRoomInEvent(CWYEvent: RRSCWYEvent);
var
  dbRunEvent : TRsDBRunEvent;
begin
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    dbRunEvent.LocalInRoom(CWYEvent.etime,CWYEvent.tmid,CWYEvent.stmis,CWYEvent.nVerify,'');
  finally
    dbRunEvent.Free;
  end;
end;

procedure TRsDBInterface.SaveRoomOutEvent(CWYEvent: RRSCWYEvent);
var
  dbRunEvent : TRsDBRunEvent;
begin
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    dbRunEvent.LoacalOutRoom(CWYEvent.etime,CWYEvent.tmid,CWYEvent.stmis,CWYEvent.nVerify,'');
  finally
    dbRunEvent.Free;
  end;
end;

procedure TRsDBInterface.SaveSiteRoomInEvent(CWYEvent: RRSCWYEvent);
begin
  SiteTrainmanEvent(eteInRoom,CWYEvent);
end;

procedure TRsDBInterface.SaveSiteRoomOutEvent(CWYEvent: RRSCWYEvent);
begin
  SiteTrainmanEvent(eteOutRoom,CWYEvent);
end;

procedure TRsDBInterface.SaveStop(JCEvent: RRSJCEvent);
begin
 DoubleTrainmanEvent(JCEvent);
end;

procedure TRsDBInterface.SaveWorkBeginEvent(CWYEvent: RRSCWYEvent);
begin
  SingleTrainmanEvent(eteBeginWork,CWYEvent);
end;

procedure TRsDBInterface.SaveWorkEndEvent(CWYEvent: RRSCWYEvent);
begin
  SingleTrainmanEvent(eteEndWork,CWYEvent);
end;

procedure TRsDBInterface.SingleTrainmanEvent(EventID: TRunEventType;
  CWYEvent: RRSCWYEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
  dbRunEvent : TRsDBRunEvent;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    try
      recordGUID := dbRunEvent.TrainmanSubmit(CWYEvent.etime,CWYEvent.tmid,
        CWYEvent.stmis,1, CWYEvent.nresult, CWYEvent.strResult, EventID, nResult);
    except
      on e : exception do
      begin
        nResult := 2;
        strResult := e.message;
      end;
    end;
      if (nResult = 0) then
          strResult := '��ӳɹ�';

      if (nResult = 1) then
          strResult := 'û��ָ������Ա�ļƻ��������Ϣ';
      dbRunEvent.TrainmanDetailSubmit(recordGUID,EventID,CWYEvent.etime,
        CWYEvent.tmid,CWYEvent.stmis,1,CWYEvent.nresult,
        CWYEvent.strResult, nResult, strResult);
  finally
    dbRunEvent.Free;
  end;
end;

procedure TRsDBInterface.SiteTrainmanEvent(EventID: TRunEventType;
  CWYEvent: RRSCWYEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
  dbRunEvent : TRsDBRunEvent;
  logManage :TLogManage;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  logManage := TLogManage.Create;
  logManage.FileNamePath := 'c:\';
  dbRunEvent := TRsDBRunEvent.Create(m_ADOConnection);
  try
    try
      logManage.InsertLog('��ʼ���������Ԣ��Ϣ:' + CWYEvent.tmid);
      recordGUID := dbRunEvent.TrainmanSubmit(CWYEvent.etime,CWYEvent.tmid,
        CWYEvent.stmis,1, CWYEvent.nresult, CWYEvent.strResult, EventID, nResult);
      logManage.InsertLog('���������Ԣ��Ϣ�ɹ�' );
    except
      on e : exception do
      begin
        nResult := 2;
        strResult := e.message;
        logManage.InsertLog('���������Ԣ�쳣' + strResult );
      end;
    end;
      if (nResult = 0) then
          strResult := '��ӳɹ�';

      if (nResult = 1) then
          strResult := 'û��ָ������Ա�ļƻ��������Ϣ';
      try
        logManage.InsertLog('��ʼ���������Ԣ��Ϣ��־:' + CWYEvent.tmid);
        dbRunEvent.SiteEventSubmit(recordGUID,EventID,CWYEvent.etime,
          CWYEvent.tmid,CWYEvent.stmis,1,CWYEvent.nresult,
          CWYEvent.strResult, nResult, strResult);
        logManage.InsertLog('��ʼ���������Ԣ��Ϣ��־�ɹ�');
      except on e : exception do
        logManage.InsertLog('���������Ԣ��Ϣ��־�쳣' + e.Message);
      end;
  finally
    logManage.Free;
    dbRunEvent.Free;
  end;
end;

end.
