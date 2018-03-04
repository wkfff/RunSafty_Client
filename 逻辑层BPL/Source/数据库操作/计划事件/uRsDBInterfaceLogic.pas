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
    //出入库处理事件
    procedure DepotsEvent(EventID : TRunEventType;JCEvent : RRSJCEvent);
  public
    {功能:保存出勤事件}
    procedure SaveWorkBeginEvent(CWYEvent: RRSCWYEvent);
    {功能:保存退勤事件}
    procedure SaveWorkEndEvent(CWYEvent: RRSCWYEvent);
    {功能:保存入寓事件}
    procedure SaveRoomInEvent(CWYEvent: RRSCWYEvent);
    {功能:保存离寓事件}
    procedure SaveRoomOutEvent(CWYEvent: RRSCWYEvent);
    {功能:保存外点入寓事件}
    procedure SaveSiteRoomInEvent(CWYEvent: RRSCWYEvent);
    {功能:保存外点离寓事件}
    procedure SaveSiteRoomOutEvent(CWYEvent: RRSCWYEvent);
    {功能:保存验卡事件}
    procedure SaveOtherYanKaEvent(CWYEvent: RRSCWYEvent);
    {功能:保存机车事件,根据TJCEventType判断类型}
    procedure SaveOtherJCEvent(JCEvent: RRSJCEvent);
    {功能:保存到车事件}
    procedure SaveOtherReachEvent(JCEvent: RRSJCEvent);
    {功能:保存入库信息}
    procedure SaveInDepots(JCEvent: RRSJCEvent);
    {功能:保存出库事件}
    procedure SaveOutDepots(JCEvent: RRSJCEvent);
    {功能:保存文件开始事件}
    procedure SaveFileBegin(JCEvent: RRSJCEvent);
    {功能:保存文件结束事件}
    procedure SaveFileEnd(JCEvent: RRSJCEvent);
    //保存站停事件
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
      strResult := '添加成功';
    end;
    if (nResult = 1) then
    begin
      strResult := '没有指定乘务员的计划或机组信息';
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
      strResult := '添加成功';
    end;
    if (nResult = 1) then
    begin
      strResult := '没有指定乘务员的计划或机组信息';
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
          strResult := '添加成功';

      if (nResult = 1) then
          strResult := '没有指定乘务员的计划或机组信息';
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
      logManage.InsertLog('开始保存外点入寓信息:' + CWYEvent.tmid);
      recordGUID := dbRunEvent.TrainmanSubmit(CWYEvent.etime,CWYEvent.tmid,
        CWYEvent.stmis,1, CWYEvent.nresult, CWYEvent.strResult, EventID, nResult);
      logManage.InsertLog('保存外点入寓信息成功' );
    except
      on e : exception do
      begin
        nResult := 2;
        strResult := e.message;
        logManage.InsertLog('保存外点入寓异常' + strResult );
      end;
    end;
      if (nResult = 0) then
          strResult := '添加成功';

      if (nResult = 1) then
          strResult := '没有指定乘务员的计划或机组信息';
      try
        logManage.InsertLog('开始保存外点入寓信息日志:' + CWYEvent.tmid);
        dbRunEvent.SiteEventSubmit(recordGUID,EventID,CWYEvent.etime,
          CWYEvent.tmid,CWYEvent.stmis,1,CWYEvent.nresult,
          CWYEvent.strResult, nResult, strResult);
        logManage.InsertLog('开始保存外点入寓信息日志成功');
      except on e : exception do
        logManage.InsertLog('保存外点入寓信息日志异常' + e.Message);
      end;
  finally
    logManage.Free;
    dbRunEvent.Free;
  end;
end;

end.
