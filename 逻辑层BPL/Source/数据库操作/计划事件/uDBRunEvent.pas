unit uDBRunEvent;

interface

uses
  uRunEvent,uTFSystem,uTrainmanJiaolu,uDBTrainmanJiaolu,ADODB,uTrainman,
  uDBTrainman,uTrainPlan,uDBTrainPlan,uSaftyEnum,DB;
type
  TRsDBRunEvent = class(TDBOperate)
  private
    procedure ADOQueryToRunEvent(ADOQuery : TADOQuery;var RunEvent : RRsRunEvent);
    procedure ADOQueryToRunEventVIEW(ADOQuery : TADOQuery;var RunEvent : RRsRunEvent);
    procedure RunEventToADOQuery(RunEvent : RRsRunEvent ; adoQuery : TADOQuery);
  private
    //��ȡ˾�����ڵĻ���
    function GetTrainmanGroup(TrainmanNumber : string;out Group : RRsGroup) : boolean;

    //��ȡ�ƶ������ļƻ���Ϣ
    function GetTrainPlan(TrainTypeName,TrainNumber : string;SubmitTime : TDateTime;
      InOrOut : integer; out TrainPlan: RRsTrainPlan) : boolean;
    //��ȡ��һ�������¼�
    function GetLastRunEvent(strTrainPlanGUID : string ;out lastEvent : RRsRunEvent) : boolean;
    //�Ƿ������ͬ������shijian
    function ExistRunEvent(RunEvent : RRsRunEvent;out ExistEvent : RRsRunEvent;EventIDNoCom : boolean) : boolean;

    //���������¼�
    function ReCoverRunEvent(ExistEvent: RRsRunEvent;RunEvent : RRsRunEvent;CoverRule : TRunEventCoverRule) : string;
  public
    //��ȡ˾�������ļƻ�
    //PreΪTrue������¼��������ڼƻ�����ʱ�����Ϊ���ڼƻ�����ʱ��
    function GetTrainmanPlan(TrainmanNumber : string;SubmitTime : TDateTime;
      out TrainPan: RRsTrainPlan;out TrainmanIndex : integer;Pre : boolean) : boolean;overload;
    //��������¼�
    procedure AddRunEvent(RunEvent : RRsRunEvent);
    //��ȡ�����¼����͵�����
    function GetRunEventTypeName(RunEventType : TRunEventType):string;
    //��ȡ�ƻ��������¼�
    function GetRunEventOfPlan(PlanGUID : string;EventType : TRunEventType;AllType : boolean;out RunEvent : RRsRunEvent) : boolean;
    //�޸ļƻ�������Ա��ʱ����Ϣ
    procedure UpdateEventTrainman(RunEventGUID,TrainmanNumber1,TrainmanNumber2 : string;
      EventTime : TDateTime;ResultContent : string);
    //����Ա�¼��ύ
    function TrainmanSubmit(SubmitTime : TDateTime;TrainmanNumber : string;
      TMIS,KeHuoID,ResultID : integer;ResultContent : string;
      EventType : TRunEventType;out nResult : integer) : string;
    //����Ա�¼���¼�ύ
    procedure TrainmanDetailSubmit(recordGUID : string; EventType : TRunEventType;
       EventTime :TDateTime;TrainmanNumber : string;
       TMIS,KeHuoID, ResultID : integer;ResultContent : string ;nResult : integer;
       strResult : string);
    //��פ���¼��ύ
    procedure SiteEventSubmit(recordGUID : string; EventType : TRunEventType;
       EventTime :TDateTime;TrainmanNumber : string;
       TMIS,KeHuoID, ResultID : integer;ResultContent : string ;nResult : integer;
       strResult : string);
    //�����¼��ύ
    function TrainSubmit(SubmitTime : TDateTime;TrainmanNumber1,TrainmanNumber2 : string;
      TMIS,KeHuoID : integer;TrainNo,TrainTypeName,TrainNumber :string;
      ResultID : integer ; ResultContent : string ;EventType : TRunEventType;
      out nResult : integer) : string;
    //������¼��ύ  
    function DepotsSubmit(SubmitTime : TDateTime;TrainmanNumber1,TrainmanNumber2 : string;
      TMIS,KeHuoID : integer;TrainNo,TrainTypeName,TrainNumber :string;
      ResultID : integer ; ResultContent : string ;EventType : TRunEventType;
      out nResult : integer) : string;
    //�����¼���ϸ�ύ
    procedure DepotsSubmitDetail(recordGUID : string; EventType : TRunEventType;
      SubmitTime : TDateTime ;TrainmanNumber1,TrainmanNumber2 : string;
      TMIS, KeHuoID : integer;TrainNo, TrainTypeName, TrainNumber : string ;
      ResultID : integer;ResultContent : string;nResult : integer;strResult : string);
      
    //�����¼���ϸ�ύ
    procedure TrainSubmitDetail(recordGUID : string; EventType : TRunEventType;
      SubmitTime : TDateTime ;TrainmanNumber1,TrainmanNumber2 : string;
      TMIS, KeHuoID : integer;TrainNo, TrainTypeName, TrainNumber : string ;
      ResultID : integer;ResultContent : string;nResult : integer;strResult : string);

    //������Ԣ
    procedure LocalInRoom(InRoomTime : TDateTime;TrainmanNumber : string;
      TMIS : integer ;Verify : integer ; TrainPlanGUID : string);
    //������Ԣ
    procedure LoacalOutRoom(OutRoomTime : TDateTime;TrainmanNumber : string ;
      TMIS : integer ;Verify : integer ;TrainPlanGUID : string);

    //��ȡ��Ԣ��Ϣ
    function GetTrainmanLastInRoom(TrainmanNumber : string;out LocalInRoom : RRsLocalInRoom):boolean;
    //��ȡ��Ԣ��Ϣ
    function GetTrainmanLastOutRoom(TrainmanNumber : string;out LocalOutRoom : RRsLocalOutRoom) : boolean;

    //��ȡ�ƻ��������¼���Ϣ
    procedure GetPlanRunEvents(TrainPlanGUID : string;out RunEventArray : TRsRunEventArray);
    //���¼����¼���Ϣ
    procedure ReCountRunEvent(TrainPlanGUID : string);
    //ɾ���¼�
    procedure DeleteRunEvent(RunEventGUID :  string);

  end;
implementation
uses
  SysUtils,DateUtils;
{ TRsDBRunEvent }

procedure TRsDBRunEvent.AddRunEvent(RunEvent: RRsRunEvent);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select dbo.CovnertTrainType(%s) as TrainTypeName,dbo.CovnertTrainNumber(%s) as TrainNumber';
      strSql := Format(strSql,[QuotedStr(RunEvent.strTrainTypeName),
          QuotedStr(RunEvent.strTrainNumber)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        RunEvent.strTrainTypeName := FieldByName('TrainTypeName').AsString;
        RunEvent.strTrainNumber := FieldByName('TrainNumber').AsString;
      end;

      strSql := 'insert into TAB_Plan_RunEvent (strRunEventGUID,strTrainPlanGUID, ' +
        ' nEventID,dtEventTime,strTrainNo,strTrainTypeName,strTrainNumber,nTMIS, ' +
        ' nKeHuo,strGroupGUID,strTrainmanNumber1,strTrainmanNumber2,dtCreateTime,nResult,strResult) ' +
        ' values (:strRunEventGUID,:strTrainPlanGUID,:nEventID,:dtEventTime,:strTrainNo, ' +
        ' :strTrainTypeName,:strTrainNumber,:nTMIS,:nKeHuo,:strGroupGUID,:strTrainmanNumber1,' +
        ' :strTrainmanNumber2,getdate(),:nResult,:strResult)';
      sql.Text := strSql;
      Parameters.ParamByName('strRunEventGUID').Value := RunEvent.strRunEventGUID;
      Parameters.ParamByName('strTrainPlanGUID').Value := RunEvent.strTrainPlanGUID;
      Parameters.ParamByName('nEventID').Value := Ord(RunEvent.nEventID);
      Parameters.ParamByName('dtEventTime').Value := FormatDateTime('yyyy-MM-dd HH:nn:ss',RunEvent.dtEventTime);
      Parameters.ParamByName('strTrainNo').Value := RunEvent.strTrainNo;
      Parameters.ParamByName('strTrainTypeName').Value := RunEvent.strTrainTypeName;
      Parameters.ParamByName('strTrainNumber').Value := RunEvent.strTrainNumber;
      Parameters.ParamByName('nTMIS').Value := RunEvent.nTMIS;
      Parameters.ParamByName('nKeHuo').Value := Ord(RunEvent.nKehuo);
      Parameters.ParamByName('strGroupGUID').Value := RunEvent.strGroupGUID;
      Parameters.ParamByName('strTrainmanNumber1').Value := RunEvent.strTrainmanNumber1;
      Parameters.ParamByName('strTrainmanNumber2').Value := RunEvent.strTrainmanNumber2;
      Parameters.ParamByName('nResult').Value := Ord(RunEvent.nEventID);
      Parameters.ParamByName('strResult').Value := RunEvent.strResult;

      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.ADOQueryToRunEvent(ADOQuery: TADOQuery;
  var RunEvent: RRsRunEvent);
begin
  with ADOQuery do
  begin
    RunEvent.strRunEventGUID := FieldByName('strRunEventGUID').AsString;
    RunEvent.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    RunEvent.nEventID := TRunEventType(FieldByName('nEventID').AsInteger);
    RunEvent.dtEventTime := FieldByName('dtEventTime').AsDateTime;
    RunEvent.strTrainNo := FieldByName('strTrainNo').AsString;
    RunEvent.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    RunEvent.strTrainNumber := FieldByName('strTrainNumber').AsString;
    RunEvent.nTMIS := FieldByName('nTMIS').AsInteger;;
    RunEvent.nKeHuo := TRsKeHuo(FieldByName('nKeHuo').AsInteger);
    RunEvent.strGroupGUID := FieldByName('strGroupGUID').AsString;
    RunEvent.strTrainmanNumber1 := FieldByName('strTrainmanNumber1').AsString;
    RunEvent.strTrainmanNumber2 := FieldByName('strTrainmanNumber2').AsString;
    RunEvent.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    RunEvent.nResultID := FieldByName('nResult').AsInteger ;
    RunEvent.strResult := FieldByName('strResult').AsString ;
  end;
end;

procedure TRsDBRunEvent.ADOQueryToRunEventVIEW(ADOQuery: TADOQuery;
  var RunEvent: RRsRunEvent);
begin
  with ADOQuery do
  begin
    RunEvent.strRunEventGUID := FieldByName('strRunEventGUID').AsString;
    RunEvent.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    RunEvent.nEventID := TRunEventType(FieldByName('nEventID').AsInteger);
    RunEvent.strEventName := GetRunEventTypeName(RunEvent.nEventID);
    RunEvent.dtEventTime := FieldByName('dtEventTime').AsDateTime;
    RunEvent.strTrainNo := FieldByName('strTrainNo').AsString;
    RunEvent.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    RunEvent.strTrainNumber := FieldByName('strTrainNumber').AsString;
    RunEvent.nTMIS := FieldByName('nTMIS').AsInteger;
    RunEvent.strStationName := FieldByName('strStationName').asstring;
    RunEvent.nKeHuo := TRsKeHuo(FieldByName('nKeHuo').AsInteger);
    RunEvent.strGroupGUID := FieldByName('strGroupGUID').AsString;
    RunEvent.strTrainmanNumber1 := FieldByName('strTrainmanNumber1').AsString;
    RunEvent.strTrainmanNumber2 := FieldByName('strTrainmanNumber2').AsString;
    RunEvent.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    RunEvent.nResultID := FieldByName('nResult').AsInteger ;
    RunEvent.strResult := FieldByName('strResult').AsString ;
  end;
end;

procedure TRsDBRunEvent.DeleteRunEvent(RunEventGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from TAB_Plan_RunEvent where strRunEventGUID = %s';
      strSql := Format(strSql,[QuotedStr(RunEventGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.DepotsSubmit(SubmitTime: TDateTime; TrainmanNumber1,
  TrainmanNumber2: string; TMIS, KeHuoID: integer; TrainNo, TrainTypeName,
  TrainNumber: string; ResultID: integer; ResultContent: string;
  EventType: TRunEventType; out nResult: integer): string;
var
  trainPlan : RRsTrainPlan;
  strTrainNo,strTrainTypeName,strTrainNumber : string;
  runEvent,existEvent : RRsRunEvent;
  nCoverRule : TRunEventCoverRule;
  bEventIDNoCom : boolean;
  trainmanIndex : integer;
begin
  result := NewGUID;
  nResult := 0;

  if not GetTrainmanPlan(TrainmanNumber1,SubmitTime,trainPlan,trainmanIndex,false) then
  begin
    if not GetTrainmanPlan(TrainmanNumber2,SubmitTime,trainPlan,trainmanIndex,false) then
    begin
      result := 'NoPlan';
      nResult := 2;
      exit;
    end;
  end;
  nCoverRule := ecrCover;
  bEventIDNoCom := false;
  //���ֻҪ���ʱ��ģ�����ֻҪ��Сʱ���
  if ((EventType = eteInDepots) or (EventType = eteOutDepots)) then
  begin
    bEventIDNoCom := true;
    if EventType = eteOutDepots then
      nCoverRule := ecrMin
    else
      nCoverRule := ecrMax;
  end;
  //�������¼��ڷ��ּƻ�����������ʱ���¼�ʱ����ڼƻ�ʵ������ʱ��������
  if (trainPlan.nPlanState >= psEndWork) then
  begin
    if EventType <> eteEndWork then
    begin
       if SubmitTime > trainPlan.dtLastArriveTime then
       begin
          result := '��ʱ������';
          nResult := 3;
          exit;
       end;
    end;
  end;

  strTrainNo := TrainNo;
  strTrainNumber := TrainNumber;
  strTrainTypeName := TrainTypeName;

  runEvent.strRunEventGUID := result;
  runEvent.strTrainPlanGUID := trainPlan.strTrainPlanGUID;
  runEvent.nEventID := EventType;
  runEvent.dtEventTime := SubmitTime;
  runEvent.strTrainNo := strTrainNo;
  runEvent.strTrainTypeName := strTrainTypeName;
  runEvent.strTrainNumber := strTrainNumber;
  runEvent.nTMIS := TMIS;
  runEvent.nKeHuo := TRsKehuo(KeHuoID);
  runEvent.strGroupGUID := trainPlan.strTrainPlanGUID;
  runEvent.strTrainmanNumber1 := TrainmanNumber1;
  runEvent.strTrainmanNumber2 := TrainmanNumber2;
  runEvent.nResultID := ResultID;
  runEvent.strResult := ResultContent;
  //�¼������򸲸��ϵ��¼�
  if (ExistRunEvent(runEvent,existEvent,bEventIDNoCom)) then
  begin
    result := ReCoverRunEvent(existEvent,runEvent,nCoverRule);
    exit;
  end;
  AddRunEvent(runEvent);
  
end;

procedure TRsDBRunEvent.DepotsSubmitDetail(recordGUID: string;
  EventType: TRunEventType; SubmitTime: TDateTime; TrainmanNumber1,
  TrainmanNumber2: string; TMIS, KeHuoID: integer; TrainNo, TrainTypeName,
  TrainNumber: string; ResultID: integer; ResultContent: string;
  nResult: integer; strResult: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      if EventType = eteOutDepots then
      begin
        strSql := 'insert into TAB_Plan_RunEvent_OutDepotsDetail (dtCreateTime, ' +
            ' strTrainTypeName,strTrainNumber,strTrainCode,dtOutDepotsTime,strRecGUID,strSourceID,strTrainmanNumber1,strTrainmanNumber2) values ' +
            ' (getdate(),:strTrainTypeName,:strTrainNumber,:strTrainCode,:dtOutDepotsTime,:strRecGUID,:strSourceID,:strTrainmanNumber1,:strTrainmanNumber2) ';
        Sql.Text := strSql;
        Parameters.ParamByName('strTrainTypeName').Value := TrainTypeName;
        Parameters.ParamByName('strTrainNumber').Value := TrainNumber;
        Parameters.ParamByName('strTrainCode').Value := '';
        Parameters.ParamByName('dtOutDepotsTime').Value := SubmitTime;
        Parameters.ParamByName('strRecGUID').Value := recordGUID;
        Parameters.ParamByName('strSourceID').Value := ResultContent;
        Parameters.ParamByName('strTrainmanNumber1').Value := TrainmanNumber1;
        Parameters.ParamByName('strTrainmanNumber2').Value := TrainmanNumber2;
      end else begin
        strSql := 'insert into TAB_Plan_RunEvent_InDepotsDetail (dtCreateTime, ' +
            ' strTrainTypeName,strTrainNumber,strTrainCode,dtInDepotsTime,strRecGUID,strSourceID,strTrainmanNumber1,strTrainmanNumber2) values ' +
            ' (getdate(),:strTrainTypeName,:strTrainNumber,:strTrainCode,:dtInDepotsTime,:strRecGUID,:strSourceID,:strTrainmanNumber1,:strTrainmanNumber2) ';
        Sql.Text := strSql;
        Parameters.ParamByName('strTrainTypeName').Value := TrainTypeName;
        Parameters.ParamByName('strTrainNumber').Value := TrainNumber;
        Parameters.ParamByName('strTrainCode').Value := '';
        Parameters.ParamByName('dtInDepotsTime').Value := SubmitTime;
        Parameters.ParamByName('strRecGUID').Value := recordGUID;
        Parameters.ParamByName('strSourceID').Value := ResultContent;
        Parameters.ParamByName('strTrainmanNumber1').Value := TrainmanNumber1;
        Parameters.ParamByName('strTrainmanNumber2').Value := TrainmanNumber2;
      end;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.ExistRunEvent(RunEvent: RRsRunEvent;out ExistEvent : RRsRunEvent;EventIDNoCom : boolean): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  ExistEvent.strRunEventGUID:= '';
  result :=false;
  strSql := 'select top 1 * from TAB_Plan_RunEvent where strTrainPlanGUID = %s and nEventID = %d and dtEventTime >=%s and dtEventTime <= %s';
  strSql := Format(strSql,[QuotedStr(RunEvent.strTrainPlanGUID),Ord(RunEvent.nEventID),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',IncMinute(RunEvent.dtEventTime,-1))),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',IncMinute(RunEvent.dtEventTime,1)))]);
  if EventIDNoCom then
  begin
    strSql := 'select top 1 * from TAB_Plan_RunEvent where strTrainPlanGUID = %s and nEventID = %d';
    strSql := Format(strSql,[QuotedStr(RunEvent.strTrainPlanGUID),Ord(RunEvent.nEventID)]);
  end;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToRunEvent(adoQuery,ExistEvent);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.GetLastRunEvent(strTrainPlanGUID: string;
  out lastEvent: RRsRunEvent): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from TAB_Plan_RunEvent where strTrainPlanGUID = %s order by dtEventTime desc ';
  strSql := Format(strSql,[QuotedStr(strTrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        //if (FieldByName('nEventID').AsInteger = Ord(eteEndWork)) or (FieldByName('nEventID').AsInteger = Ord(eteInRoom)) then exit;
        ADOQueryToRunEvent(adoQuery,lastEvent);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.GetPlanRunEvents(TrainPlanGUID: string;
  out RunEventArray: TRsRunEventArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_RunEvent where strTrainPlanGUID = %s  order by dtEventTime ';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      sql.Text := strSql;
      Open;
      SetLength(RunEventArray,RecordCount);
      i := 0 ;
      while not eof do
      begin
        ADOQueryToRunEventVIEW(adoQuery,RunEventArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.GetRunEventOfPlan(PlanGUID: string;
  EventType: TRunEventType;AllType : boolean ;out RunEvent: RRsRunEvent): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from TAB_Plan_RunEvent where strTrainPlanGUID = %s and nEventID = %d order by dtEventTime desc  ';
  strSql := Format(strSql,[QuotedStr(PlanGUID),Ord(eventType)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToRunEvent(adoQuery,RunEvent);
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.GetRunEventTypeName(RunEventType: TRunEventType): string;
begin
  result := '';
  case RunEventType of
    eteNull: Result := '��';
    eteInRoom: Result := '��Ԣ';
    eteOutRoom: Result := '��Ԣ';
    eteBeginWork: Result := '����';
    eteOutDepots: Result := '����';
    eteEndWork: Result := '����';
    eteInDepots: Result := '���';
    eteStopInStation: Result := 'վͣ';
    eteStartFromStation: Result := 'վ��';
    eteVerifyCard: Result := '�鿨';
    eteDrinkTest: Result := '���';
    eteFileBegin : Result := '�ļ���ʼ';
    eteFileEnd : Result := '�ļ�����';
    eteEnterStation : Result := '��վ';
    eteLeaveStation : Result := '��վ';
    eteLastStopStation : Result := '��ͣ';
  end;
end;

function TRsDBRunEvent.GetTrainmanGroup(TrainmanNumber: string;
  out Group: RRsGroup): boolean;
var
  trainman : RRsTrainman;
  dbTrainman : TRsDBTrainman;
  dbTrainmanJiaolu : TRsDBTrainmanJiaolu;
begin
  result := false;
  dbTrainman := TRsDBTrainman.Create(m_ADOConnection);
  try
    if dbTrainman.GetTrainmanByNumber(TrainmanNumber,trainman) then
    begin
      dbTrainmanJiaolu := TRsDBTrainmanJiaolu.Create(m_ADOConnection);
      try
        if dbTrainmanJiaolu.GetTrainmanGroup(trainman.strTrainmanGUID,Group) then
        begin
          result := true;
        end;
      finally
        dbTrainmanJiaolu.Free;
      end;
    end;
  finally
    dbTrainman.Free;
  end;
end;

function TRsDBRunEvent.GetTrainmanLastInRoom(TrainmanNumber: string;
  out LocalInRoom: RRsLocalInRoom): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_Plan_InRoom where strTrainmanNumber = %s order by dtInRoomTime desc';
      strSql := Format(strSql,[QuotedStr(TrainmanNumber)]);
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        LocalInRoom.strInRoomGUID := FieldByName('strInRoomGUID').AsString;
        LocalInRoom.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
        LocalInRoom.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        LocalInRoom.dtInRoomTime := FieldByName('dtInRoomTime').AsDateTime;
        LocalInRoom.nInRoomVerifyID :=  FieldByName('nInRoomVerifyID').AsInteger;
        LocalInRoom.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        Result := true;
      end;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.GetTrainmanLastOutRoom(TrainmanNumber: string;
  out LocalOutRoom: RRsLocalOutRoom): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_Plan_OutRoom where strTrainmanNumber = %s order by dtOutRoomTime desc';
      strSql := Format(strSql,[QuotedStr(TrainmanNumber)]);
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        LocalOutRoom.strOutRoomGUID := FieldByName('strOutRoomGUID').AsString;
        LocalOutRoom.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
        LocalOutRoom.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        LocalOutRoom.dtOutRoomTime := FieldByName('dtOutRoomTime').AsDateTime;
        LocalOutRoom.nOutRoomVerifyID :=  FieldByName('nOutRoomVerifyID').AsInteger;
        LocalOutRoom.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        Result := true;
      end;
    end;  
  finally
    adoQuery.Free;
  end;

end;

function TRsDBRunEvent.GetTrainmanPlan(TrainmanNumber: string;SubmitTime : TDateTime;
  out TrainPan: RRsTrainPlan;out TrainmanIndex : integer;Pre : boolean): boolean;
var
  dbTrainPlan : TRsDBTrainPlan;
begin
  dbTrainPlan := TRsDBTrainPlan.Create(m_ADOConnection);
  try
    if Pre then
      result := dbTrainPlan.GetPlanByTrainmanNumberPre(TrainmanNumber,SubmitTime,TrainPan,TrainmanIndex)
    else
      result := dbTrainPlan.GetPlanByTrainmanNumberBeh(TrainmanNumber,SubmitTime,TrainPan,TrainmanIndex);
  finally
    dbTrainPlan.Free;
  end;
end;

function TRsDBRunEvent.GetTrainPlan(TrainTypeName, TrainNumber: string;
  SubmitTime: TDateTime; InOrOut : integer; out TrainPlan: RRsTrainPlan): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
  dbTrainplan : TRsDBTrainPlan;
begin
  result := false;
  //��ȡ�ƻ���Ϣ
  strSql := 'select * from VIEW_Plan_Trainman where strTrainPlanGUID ' +
     ' in (select top 1 strFlowID from VIEW_WorkTime_Turn ' +
     ' where  %s >= dateAdd(n,-120,dtStartTime) ' +
     ' and strTrainTypeName = dbo.CovnertTrainType(%s) and strTrainNumber = dbo.CovnertTrainNumber(%s) and nPlanState >= 4 order by dtStartTime desc)  ';
  if InOrOut > 1 then
    strSql := 'select * from VIEW_Plan_Trainman where strTrainPlanGUID ' +
     ' in (select top 1 strFlowID from VIEW_WorkTime_Turn ' +
     ' where  %s >= dateAdd(n,-120,dtStartTime) ' +
     ' and strBackTrainTypeName = dbo.CovnertTrainType(%s) and strBackTrainNumber = dbo.CovnertTrainNumber(%s) and nPlanState >= 4 order by dtStartTime desc)  ';
     
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(TrainTypeName),
    QuotedStr(TrainNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        dbTrainplan := TRsDBTrainPlan.Create(nil);
        try
          dbTrainplan.ADOQueryToTrainPlan(adoQuery,TrainPlan);
        finally
          dbTrainplan.Free;
        end;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.LoacalOutRoom(OutRoomTime: TDateTime;
  TrainmanNumber: string; TMIS, Verify: integer; TrainPlanGUID: string);
var
  strSql,trainmanGUID : string;
  adoQuery : TADOQuery;
  dbTrainman : TRsDBTrainman;
  trainman : RRsTrainman;
begin
  dbTrainman := TRsDBTrainman.Create(m_ADOConnection);
  try
    if dbTrainman.GetTrainmanByNumber(TrainmanNumber,trainman) then
      trainmanGUID := trainman.strTrainmanGUID;
  finally
    dbTrainman.Free;
  end;

  strSql := 'insert into TAB_Plan_OutRoom (strOutRoomGUID,strTrainPlanGUID,strTrainmanGUID,dtOutRoomTime,nOutRoomVerifyID,strTrainmanNumber) values ' +
     '  (%s,%s,%s,%s,%d,%s) ';
  strSql := Format(strSql,[QuotedStr(NewGUID),QuotedStr(TrainPlanGUID),
    QuotedStr(trainmanGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',OutRoomTime)),
    Verify,QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.LocalInRoom(InRoomTime: TDateTime;
  TrainmanNumber: string; TMIS, Verify: integer; TrainPlanGUID: string);
var
  strSql,trainmanGUID : string;
  adoQuery : TADOQuery;
  dbTrainman : TRsDBTrainman;
  trainman : RRsTrainman;
begin
  dbTrainman := TRsDBTrainman.Create(m_ADOConnection);
  try
    if dbTrainman.GetTrainmanByNumber(TrainmanNumber,trainman) then
      trainmanGUID := trainman.strTrainmanGUID;
  finally
    dbTrainman.Free;
  end;

  strSql := 'insert into TAB_Plan_InRoom (strInRoomGUID,strTrainPlanGUID,strTrainmanGUID,dtInRoomTime,nInRoomVerifyID,strTrainmanNumber) values ' +
     '  (%s,%s,%s,%s,%d,%s) ';
  strSql := Format(strSql,[QuotedStr(NewGUID),QuotedStr(TrainPlanGUID),
    QuotedStr(trainmanGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',InRoomTime)),
    Verify,QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.ReCountRunEvent(TrainPlanGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 nid from TAB_Plan_RunEvent where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        strSql := 'update TAB_Plan_RunEvent set strFlowID = %s where nID = %d';
        strSql := Format(strSql,[QuotedStr(''),FieldByName('nID').AsInteger]);
        Sql.Text := strSql;
        ExecSql;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.ReCoverRunEvent(ExistEvent: RRsRunEvent;
  RunEvent: RRsRunEvent;CoverRule : TRunEventCoverRule) : string;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      case CoverRule of
        ecrCover : begin

        end;
        ecrIgnore : begin
          exit;
        end;
        ecrMin : begin
          if ExistEvent.dtEventTime < RunEvent.dtEventTime then exit;          
        end;
        ecrMax : begin
          if ExistEvent.dtEventTime > RunEvent.dtEventTime then exit;       
        end;
      end;
      RunEvent.strRunEventGUID := ExistEvent.strRunEventGUID;

      Connection := m_ADOConnection;
      strSql := 'select dbo.CovnertTrainType(%s) as TrainTypeName,dbo.CovnertTrainNumber(%s) as TrainNumber';
      strSql := Format(strSql,[QuotedStr(RunEvent.strTrainTypeName),
          QuotedStr(RunEvent.strTrainNumber)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        RunEvent.strTrainTypeName := FieldByName('TrainTypeName').AsString;
        RunEvent.strTrainNumber := FieldByName('TrainNumber').AsString;
      end;

      strSql := 'update TAB_Plan_RunEvent set strTrainPlanGUID=:strTrainPlanGUID, ' +
        ' nEventID=:nEventID,dtEventTime=:dtEventTime,strTrainNo=:strTrainNo, ' +
        ' strTrainTypeName=:strTrainTypeName,strTrainNumber=:strTrainNumber, ' + 
        ' nTMIS=:nTMIS, nKeHuo=:nKeHuo,strGroupGUID=:strGroupGUID, ' +
        ' strTrainmanNumber1=:strTrainmanNumber1,strTrainmanNumber2=:strTrainmanNumber2' +
        ' ,dtCreateTime = getdate(),nResult=:nResult,strResult=:strResult ' +
        ' where strRunEventGUID = :strRunEventGUID';
      sql.Text := strSql;
      Parameters.ParamByName('strRunEventGUID').Value := RunEvent.strRunEventGUID;
      Parameters.ParamByName('strTrainPlanGUID').Value := RunEvent.strTrainPlanGUID;
      Parameters.ParamByName('nEventID').Value := Ord(RunEvent.nEventID);
      Parameters.ParamByName('dtEventTime').Value := FormatDateTime('yyyy-MM-dd HH:nn:ss',RunEvent.dtEventTime);
      Parameters.ParamByName('strTrainNo').Value := RunEvent.strTrainNo;
      Parameters.ParamByName('strTrainTypeName').Value := RunEvent.strTrainTypeName;
      Parameters.ParamByName('strTrainNumber').Value := RunEvent.strTrainNumber;
      Parameters.ParamByName('nTMIS').Value := RunEvent.nTMIS;
      Parameters.ParamByName('nKeHuo').Value := Ord(RunEvent.nKehuo);
      Parameters.ParamByName('strGroupGUID').Value := RunEvent.strGroupGUID;
      Parameters.ParamByName('strTrainmanNumber1').Value := RunEvent.strTrainmanNumber1;
      Parameters.ParamByName('strTrainmanNumber2').Value := RunEvent.strTrainmanNumber2;
      Parameters.ParamByName('nResult').Value := Ord(RunEvent.nEventID);
      Parameters.ParamByName('strResult').Value := RunEvent.strResult;

      ExecSQL;
      result :=  RunEvent.strRunEventGUID;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.RunEventToADOQuery(RunEvent: RRsRunEvent;
  adoQuery: TADOQuery);
begin
  with ADOQuery do
  begin
    FieldByName('strRunEventGUID').AsString := RunEvent.strRunEventGUID;
    FieldByName('strTrainPlanGUID').AsString := RunEvent.strTrainPlanGUID;
    FieldByName('nEventID').AsInteger := Ord(RunEvent.nEventID);
    FieldByName('dtEventTime').AsDateTime := RunEvent.dtEventTime;
    FieldByName('strTrainNo').AsString := RunEvent.strTrainNo;
    FieldByName('strTrainTypeName').AsString := RunEvent.strTrainTypeName;
    FieldByName('strTrainNumber').AsString := RunEvent.strTrainNumber;
    FieldByName('nTMIS').AsInteger := RunEvent.nTMIS;
    FieldByName('nKeHuo').AsInteger := Ord(RunEvent.nKeHuo);
    FieldByName('strGroupGUID').AsString := RunEvent.strGroupGUID;
    FieldByName('strTrainmanNumber1').AsString := RunEvent.strTrainmanNumber1;
    FieldByName('strTrainmanNumber2').AsString := RunEvent.strTrainmanNumber2;
    FieldByName('dtCreateTime').AsDateTime := RunEvent.dtCreateTime;
    FieldByName('nResult').AsInteger := RunEvent.nResultID;
    FieldByName('strResult').AsString := RunEvent.strResult;
  end;

end;

procedure TRsDBRunEvent.SiteEventSubmit(recordGUID: string;
  EventType: TRunEventType; EventTime: TDateTime; TrainmanNumber: string; TMIS,
  KeHuoID, ResultID: integer; ResultContent: string; nResult: integer;
  strResult: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'insert into TAB_Plan_RunEvent_Site (strRunEventGUID,nEventID,dtEventTime,strTrainmanNumber,nTMIS,dtCreateTime, ' +
            ' nSubmitResult,strSubmitRemark,nResultID,strResult) values ' +
            ' (:strRunEventGUID,:nEventID,:dtEventTime,:strTrainmanNumber,:nTMIS,getdate(), ' +
            ' :nSubmitResult,:strSubmitRemark,:nResultID,:strResult)';
      Sql.Text := strSql;
      Parameters.ParamByName('strRunEventGUID').Value := recordGUID;
      Parameters.ParamByName('nEventID').Value := Ord(EventType);
      Parameters.ParamByName('dtEventTime').Value := EventTime;
      Parameters.ParamByName('strTrainmanNumber').Value := TrainmanNumber;
      Parameters.ParamByName('nTMIS').Value := TMIS;
      Parameters.ParamByName('nSubmitResult').Value := KeHuoID;
      Parameters.ParamByName('strSubmitRemark').Value := strResult;
      Parameters.ParamByName('nResultID').Value := nResult;
      Parameters.ParamByName('strResult').Value := ResultContent;
      ExecSql;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.TrainmanDetailSubmit(recordGUID : string; EventType : TRunEventType;
       EventTime :TDateTime;TrainmanNumber : string;
       TMIS,KeHuoID, ResultID : integer;ResultContent : string ;nResult : integer;
       strResult : string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'insert into TAB_Plan_RunEvent_TrainmanDetail (strGUID,strRunEventGUID,nEventID,dtEventTime,strTrainmanNumber,nTMIS,dtCreateTime, ' +
            ' nSubmitResult,strSubmitRemark,nResultID,strResult) values ' +
            ' (:strGUID,:strRunEventGUID,:nEventID,:dtEventTime,:strTrainmanNumber,:nTMIS,getdate(), ' +
            ' :nSubmitResult,:strSubmitRemark,:nResultID,:strResult)';
      strSql := Format(strSql,[QuotedStr(NewGUID),QuotedStr(recordGUID),
        Ord(EventType),QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',EventTime)),
        QuotedStr(TrainmanNumber),TMIS,KeHuoID,QuotedStr(ResultContent),nResult,
        QuotedStr(strResult)]);
      Sql.Text := strSql;
      Parameters.ParamByName('strGUID').Value := NewGUID;
      Parameters.ParamByName('strRunEventGUID').Value := recordGUID;
      Parameters.ParamByName('nEventID').Value := Ord(EventType);
      Parameters.ParamByName('dtEventTime').Value := FormatdateTime('yyyy-MM-dd HH:nn:ss',EventTime);
      Parameters.ParamByName('strTrainmanNumber').Value := TrainmanNumber;
      Parameters.ParamByName('nTMIS').Value := TMIS;
      Parameters.ParamByName('nSubmitResult').Value := KeHuoID;
      Parameters.ParamByName('strSubmitRemark').Value := strResult;
      Parameters.ParamByName('nResultID').Value := nResult;
      Parameters.ParamByName('strResult').Value := ResultContent;
      ExecSql;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBRunEvent.TrainmanSubmit(SubmitTime : TDateTime; TrainmanNumber: string; TMIS,
  KeHuoID, ResultID: integer; ResultContent: string;
  EventType: TRunEventType; out nResult: integer) : string;
var
  trainmanIndex : integer;
  plan : RRsTrainPlan;
  runEvent,lastEvent,existEvent : RRsRunEvent;
  trainmanNumber1,trainmanNumber2 : string;
  tempTime : TDateTime;
  strtrainNo,strtrainTypeName,strtrainNumber : string;
  nCoverRule : TRunEventCoverRule;
begin
  Result := NewGUID;
  nResult := 0;
  nCoverRule := ecrCover;
  if Trim(TrainmanNumber) = '' then
  begin
    result := '';
    nResult := 1;
    exit;
  end;
  case EventType of
    eteBeginWork,eteVerifyCard,eteDrinkTest: begin
      if (not GetTrainmanPlan(TrainmanNumber, SubmitTime,plan,trainmanIndex,TRUE)) then
      begin
        result := '';
        nResult := 2;
        exit;
      end;
    end;
    else begin
      if (not GetTrainmanPlan(TrainmanNumber, SubmitTime,plan,trainmanIndex,false)) then
      begin
        result := '';
        nResult := 2;
        exit;
      end;
      //�������¼��ڷ��ּƻ�����������ʱ���¼�ʱ����ڼƻ�ʵ������ʱ��������
      if (plan.nPlanState >= psEndWork) then
      begin
        if EventType <> eteEndWork then
        begin
           if SubmitTime > plan.dtLastArriveTime then
           begin
              result := '��ʱ������';
              nResult := 3;
              exit;
           end;
        end;
      end;
    end;
  end;


  if GetRunEventOfPlan(plan.strTrainPlanGUID,EventType,false,runEvent) then
  begin
    trainmanNumber1 := runEvent.strTrainmanNumber1;
    trainmanNumber2 := runEvent.strTrainmanNumber2;
    result := runEvent.strRunEventGUID;
    tempTime := runEvent.dtEventTime;
    if SubmitTime > tempTime then
      tempTime := SubmitTime;
    if trainmanIndex = 1 then
      trainmanNumber1 := trainmanNumber;
    if trainmanIndex = 2 then
      trainmanNumber2 := trainmanNumber;
    UpdateEventTrainman(result,trainmanNumber1,trainmanNumber2,tempTime,ResultContent);
    exit;
  end;

  strtrainNo := plan.strTrainNo;
  strtrainNumber := plan.strTrainNumber;
  strtrainTypeName := plan.strTrainTypeName;
  if eventType <> eteBeginWork then
  begin
    if GetLastRunEvent(plan.strTrainPlanGUID,lastEvent) then
    begin
      strTrainNo := lastEvent.strTrainNo;
      strTrainNumber := lastEvent.strTrainNumber;
      strTrainTypeName := lastEvent.strTrainTypeName;
    
    end;
  end;
  
    //����ʱ�Լƻ��Ļ�����ϢΪ׼
    if (EventType <> eteBeginWork) then
    begin
      strTrainNo := lastEvent.strTrainNo;
      strTrainNumber := lastEvent.strTrainNumber;
      strTrainTypeName := lastEvent.strTrainTypeName;
    end;

    trainmanNumber1 := '';
    trainmanNumber2 := '';
    if trainmanIndex = 1 then
      trainmanNumber1 := trainmanNumber;
    if trainmanIndex = 2 then
      trainmanNumber2 := trainmanNumber;

    runEvent.strRunEventGUID := result;
    runEvent.strTrainPlanGUID := plan.strTrainPlanGUID;
    runEvent.nEventID := EventType;
    runEvent.dtEventTime := SubmitTime;
    runEvent.strTrainNo := strtrainNo;
    runEvent.strTrainTypeName := strTrainTypeName;
    runEvent.strTrainNumber := strTrainNumber;
    runEvent.nTMIS := TMIS;
    runEvent.strGroupGUID := plan.strTrainPlanGUID;
    runEvent.strTrainmanNumber1 := trainmanNumber1;
    runEvent.strTrainmanNumber2 := trainmanNumber2;
    runEvent.nResultID := ResultID;
    runEvent.strResult := ResultContent;
    runEvent.nKeHuo := TRsKeHUO( KeHuoID);
    //�¼������򸲸��ϵ��¼�
  if (ExistRunEvent(runEvent,existEvent,false)) then
  begin
    result := ReCoverRunEvent(existEvent,runEvent,nCoverRule);
    exit;
  end;
  AddRunEvent(runEvent);
end;

function TRsDBRunEvent.TrainSubmit(SubmitTime: TDateTime; TrainmanNumber1,
  TrainmanNumber2: string; TMIS, KeHuoID: integer; TrainNo, TrainTypeName,
  TrainNumber: string; ResultID: integer; ResultContent: string;
  EventType: TRunEventType; out nResult: integer) : string;
var
  tm1,tm2 : string;
  trainPlan : RRsTrainPlan;
  trainmanIndex : integer;
  strTrainNo,strTrainTypeName,strTrainNumber : string;
  runEvent,existEvent : RRsRunEvent;
  //�¼�ID�Ƿ��ܹ��ظ�
  bEventIDNoCom : Boolean;
  //���ǹ���1���¸����ϵģ�2�����ϵģ�3ȡʱ����С�ģ�4ȡʱ������
  nCoverRule : TRunEventCoverRule;
begin
  result := NewGUID;
  tm1 := TrainmanNumber1;
  tm2 := TrainmanNumber2;
  nCoverRule := ecrCover;
  nResult := 0;
  bEventIDNoCom := false;
  if ((EventType = eteFileBegin) or (EventType = eteFileEnd)) then
  begin
    bEventIDNoCom := true;
    if EventType = eteFileBegin then
      nCoverRule := ecrMin
    else
      nCoverRule := ecrMax;
  end;
  
  //��ȡ����Ա���ڵĻ�����Ϣ��������ֵ�˼ƻ���Ϣ
  if (((Trim(TrainmanNumber1) = '') and (Trim(TrainmanNumber2) = '')) ) then
  begin
      Result := 'NullNumber';
      nResult := 1;
      //strResult = "δ�ҵ��ͻ����ύ����Ԣ��¼��صļƻ���������Ϣ";
      exit;
  end;


  case EventType of
    eteBeginWork,eteVerifyCard,eteDrinkTest: begin
      if not GetTrainmanPlan(TrainmanNumber1,SubmitTime,trainPlan,trainmanIndex,true) then
      begin
        if not GetTrainmanPlan(TrainmanNumber2,SubmitTime,trainPlan,trainmanIndex,true) then
        begin
          result := 'NoPlan';
          nResult := 2;
          exit;
        end;
      end;
    end;
    else begin
      if not GetTrainmanPlan(TrainmanNumber1,SubmitTime,trainPlan,trainmanIndex,false) then
      begin
        if not GetTrainmanPlan(TrainmanNumber2,SubmitTime,trainPlan,trainmanIndex,false) then
        begin
          result := 'NoPlan';
          nResult := 2;
          exit;
        end;
      end;
    end;
  end;
  //�������¼��ڷ��ּƻ�����������ʱ���¼�ʱ����ڼƻ�ʵ������ʱ��������
  if (trainPlan.nPlanState >= psEndWork) then
  begin
    if EventType <> eteEndWork then
    begin
       if SubmitTime > trainPlan.dtLastArriveTime then
       begin
          result := '��ʱ������';
          nResult := 3;
          exit;
       end;
    end;
  end;

  strTrainNo := TrainNo;
  strTrainNumber := TrainNumber;
  strTrainTypeName := TrainTypeName;

  runEvent.strRunEventGUID := result;
  runEvent.strTrainPlanGUID := trainPlan.strTrainPlanGUID;
  runEvent.nEventID := EventType;
  runEvent.dtEventTime := SubmitTime;
  runEvent.strTrainNo := strTrainNo;
  runEvent.strTrainTypeName := strTrainTypeName;
  runEvent.strTrainNumber := strTrainNumber;
  runEvent.nTMIS := TMIS;
  runEvent.nKeHuo := TRsKehuo(KeHuoID);
  runEvent.strGroupGUID := trainPlan.strTrainPlanGUID;
  runEvent.strTrainmanNumber1 := TrainmanNumber1;
  runEvent.strTrainmanNumber2 := TrainmanNumber2;
  runEvent.nResultID := ResultID;
  runEvent.strResult := ResultContent;
  //�¼������򸲸��ϵ��¼�
  if (ExistRunEvent(runEvent,existEvent,bEventIDNoCom)) then
  begin
    result := ReCoverRunEvent(existEvent,runEvent,nCoverRule);
    exit;
  end;
  AddRunEvent(runEvent);
  
end;

procedure TRsDBRunEvent.TrainSubmitDetail(recordGUID: string;
  EventType: TRunEventType; SubmitTime: TDateTime; TrainmanNumber1,
  TrainmanNumber2: string; TMIS, KeHuoID: integer; TrainNo, TrainTypeName,
  TrainNumber: string; ResultID: integer; ResultContent: string;
  nResult: integer; strResult: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'insert into TAB_Plan_RunEvent_TrainDetail (strGUID,strRunEventGUID,nEventID,dtEventTime,strTrainmanNumber1,strTrainmanNumber2,nTMIS,nKeHuo, ' +
          ' strTrainNo,strTrainTypeName,strTrainNumber,dtCreateTime,nResultID,strResult) values ' +
          ' (:strGUID,:strRunEventGUID,:nEventID,:dtEventTime,:strTrainmanNumber1,:strTrainmanNumber2,:nTMIS,:nKeHuo, ' +
          ' :strTrainNo,:strTrainTypeName,:strTrainNumber,getdate(), ' +
          ' :nResultID,:strResult) ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Parameters.ParamByName('strGUID').Value := NewGUID;
      Parameters.ParamByName('strRunEventGUID').Value := recordGUID;
      Parameters.ParamByName('nEventID').Value := Ord(EventType);
      Parameters.ParamByName('dtEventTime').Value := FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime);
      Parameters.ParamByName('strTrainmanNumber1').Value := TrainmanNumber1;
      Parameters.ParamByName('strTrainmanNumber2').Value := TrainmanNumber2;
      Parameters.ParamByName('nTMIS').Value := TMIS;
      Parameters.ParamByName('nKeHuo').Value := KeHuoID;
      Parameters.ParamByName('strTrainNo').Value := trainNo;
      Parameters.ParamByName('strTrainTypeName').Value := TrainTypeName;
      Parameters.ParamByName('strTrainNumber').Value := TrainNumber;
      Parameters.ParamByName('nResultID').Value := ResultID;
      Parameters.ParamByName('strResult').Value := ResultContent;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBRunEvent.UpdateEventTrainman(RunEventGUID, TrainmanNumber1,
  TrainmanNumber2: string; EventTime: TDateTime;ResultContent : string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Plan_RunEvent set strTrainmanNumber1=%s,strTrainmanNumber2=%s,dtEventTime=%s,strResult=%s where strRunEventGUID=%s';
      strSql := format(strSql,[QuotedStr(TrainmanNumber1),QuotedStr(TrainmanNumber2),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EventTime)),QuotedStr(ResultContent),
        QuotedStr(RunEventGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;



end.
