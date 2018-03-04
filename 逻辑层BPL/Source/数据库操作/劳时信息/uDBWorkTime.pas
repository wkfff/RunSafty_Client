unit uDBWorkTime;

interface
uses
  Classes,SysUtils,ADODB,uTFSystem,uWorkTime,uSaftyEnum,uTrainPlan,uDBTrainPlan;
type

	TShowProgessEvent = procedure(Pos:Double) of object ;

  ///����ʱ���ݿ������
  TRsDBWorkTime = class(TDBOperate)
  private
	//����ʱ��Ϣ��䵽ADOQuery��
	procedure WorkTimeToADOQuery(WorkTime : RRsWorkTime ; ADOQuery : TADOQuery);
	//��ADOQUERY��ȡ���ݷŵ���ʱ��Ϣ��
	procedure ADOQueryToWorkTime(ADOQuery : TADOQuery;var WorkTime : RRsWorkTime);
	public
    //��ѯ����ʱ
    procedure QueryWorkTime(BeginTime,EndTime : TDateTime;trainjiaoluGUID : string;
      TrainmanNumber,TrainmanName  : string; OnUnconfirm : boolean;
		out WorkTimeArray : TWorkTimeArray);overload;
	//��ѯ����ʱ
    procedure QueryWorkTime(BeginTime,EndTime : TDateTime;
      WorkShopGUID,TrainmanNumber,TrainmanName  : string; 
	  out WorkTimeArray : TRsWorkTimeArray);overload;
	//�������ʱ
    procedure AddWorkTime(WorkTime :RRsWorkTime);
	//�޸�����ʱ
    procedure UpdateWorkTime(WorkTime : RRsWorkTime);
    //ɾ������ʱ
    procedure DeleteWorkTime(WorkTimeID : string);
    procedure QueryWorkTimeByWorkShop(BeginTime,EndTime : TDateTime;WorkShopGUID:string;trainjiaoluGUID : string;
      TrainmanNumber,TrainmanName  : string; OnUnconfirm : boolean;
      out WorkTimeArray : TWorkTimeArray;ShowProgessEvent:TShowProgessEvent);
    //��ȡָ���ƻ�������ʱ
    function  GetWorkTime(FlowID : string;out WorkTime : RRsWorkTime) : boolean;
    //ǩ�������
    procedure SignOutWork(TrainPlanGUID : string;SignText : string;DutyUser : string);
    //��ȡ�ƻ��ĳ���ǩ����Ϣ
    function GetPlanSignText(TrainPlanGUID : string) : string;
    //��ȡ���õĳ������
    procedure GetSignType(var TypeList : TStrings);
    //��ӳ���ǩ�����
    procedure AddSignType(SignText : string);
    //ɾ������ǩ�����
    procedure DeleteSignType(SignText : string);
	//ȷ����ʱ��Ϣ
    procedure ConfirmWorkTime(FlowID : string;DutyUserGUID : string);
    //ȡ��ȷ��
    procedure CancelConfirmWorkTime(FlowID : string;DutyUserGUID : string);
    //�޸���ʱ��Ϣ
    function ModifyWorkTime(WorkTime : RRsWorkTime):Boolean;
	//�������ĵ���ʱ��
	function UpdateArriveTime(GroupGUID : string;LastArriveTime:TDateTime):Boolean;
 	//�ж��Ƿ���ָ������
	function IsFingerTuiQin():Boolean;
 	//��������ʱID��ȡGROUP ID
	function GetGroupIDFromFlowID(FlowID : string):string;
  end;
implementation

uses DB;

{ TRsDBWorkTime }

procedure TRsDBWorkTime.ADOQueryToWorkTime(ADOQuery: TADOQuery;
  var WorkTime: RRsWorkTime);
begin
  with ADOQuery do
  begin
    WOrkTime.nid := FieldByName('nid').AsInteger;
    WOrkTime.strFlowID := FieldByName('strFlowID').AsString;
    WOrkTime.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    WOrkTime.strWorkShopName := FieldByName('strWorkShopName').AsString;
    WOrkTime.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
    WOrkTime.strTrainmanName := FieldByName('strTrainmanName').AsString;
    WOrkTime.dtBeginWorkTime := FieldByName('dtBeginWorkTime').AsDateTime;
    WOrkTime.dtStartTime := FieldByName('dtkcTime').AsDateTime;
    WOrkTime.dtArriveTime := FieldByName('dtArriveTime').AsDateTime;
    WOrkTime.dtInRoomTime := FieldByName('dtInRoomTime').AsDateTime;
    WOrkTime.dtOutRoomTime := FieldByName('dtOutRoomTime').AsDateTime;
    WOrkTime.dtStartTime2 := FieldByName('dtStartTime2').AsDateTime;
    WOrkTime.dtArriveTime2 := FieldByName('dtArriveTime2').AsDateTime;
    WOrkTime.dtEndWorkTime := FieldByName('dtEndWorkTime').AsDateTime;
    WOrkTime.fRunTotalTime := FieldByName('fRunTotalTime').AsInteger;
    WOrkTime.fBeginTotalTime := FieldByName('fBeginTotalTime').AsInteger;
    WOrkTime.fEndTotalTime := FieldByName('fEndTotalTime').AsInteger;
    WOrkTime.fTotalTime := FieldByName('fTotalTime').AsInteger;

    WOrkTime.nFlowState := FieldByName('nFlowState').AsInteger;
    WOrkTime.nkehuoID := FieldByName('nkehuoID').AsInteger;
    WOrkTime.nNoticeState := FieldByName('nNoticeState').AsInteger;


    WOrkTime.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    WOrkTime.strTrainNumber := FieldByName('strTrainNumber').AsString;
    WOrkTime.strTrainNo := FieldByName('strTrainNo').AsString;
    WOrkTime.strWorkShopNumber := FieldByName('strWorkShopNumber').AsString;
    WOrkTime.strDestStationTMIS := FieldByName('strDestStationTMIS').AsString;
    WOrkTime.strDestStationName := FieldByName('strDestStationName').AsString;

    WOrkTime.bLocalOutDepots  := FieldByName('bLocalOutDepots').AsInteger;
    WOrkTime.dtLocalOutDepotsTime  := FieldByName('dtLocalOutDepotsTime').AsDateTime;

    WOrkTime.bDestInDepots  := FieldByName('bDestInDepots').AsInteger;
    WOrkTime.dtDestInDepotsTime  := FieldByName('dtDestInDepotsTime').AsDateTime;

    WOrkTime.bDestOutDepots   := FieldByName('bDestOutDepots').AsInteger;
    WOrkTime.dtDestOutDepotsTime   := FieldByName('dtDestOutDepotsTime').AsDateTime;

    WOrkTime.bLocalInDepots   := FieldByName('bLocalInDepots').AsInteger;
    WOrkTime.dtLocalInDepotsTime   := FieldByName('dtLocalInDepotsTime').AsDateTime;

    WOrkTime.strBackTrainTypeName   := FieldByName('strBackTrainTypeName').AsString;
    WOrkTime.strBackTrainNumber   := FieldByName('strBackTrainNumber').AsString;
    WOrkTime.strBackTrainNo    := FieldByName('strBackTrainNo').AsString;
    WOrkTime.dtRealArriveTime    := FieldByName('dtRealArriveTime').AsDateTime;
    WOrkTime.bConfirm    := FieldByName('bConfirm').AsInteger;
    WOrkTime.dtConfirmTime    := FieldByName('dtConfirmTime').AsDateTime;
    WOrkTime.strConfirmDutyUser     := FieldByName('strConfirmDutyUser').AsString;
    WOrkTime.nLocalStopMinutes     := FieldByName('nLocalStopMinutes').AsInteger;
    WOrkTime.nRemoteStopMinutes     := FieldByName('nRemoteStopMinutes').AsInteger;
    WOrkTime.strArriveStationTMIS     := FieldByName('strArriveStationTMIS').AsString;
    WOrkTime.strArriveStationName      := FieldByName('strArriveStationName').AsString;

    WOrkTime.nAlarmMinutes      := FieldByName('nAlarmMinutes').AsInteger;
    WOrkTime.nOutMinutes      := FieldByName('nOutMinutes').AsInteger;

    //�������ʱС��0����Ϊ0
    if FieldByName('nOutTotalTime').AsInteger < 0 then
      WOrkTime.nOutTotalTime   := 0
    else
      WOrkTime.nOutTotalTime      := FieldByName('nOutTotalTime').AsInteger;

    WOrkTime.dtFileBeginTime      := FieldByName('dtFileBeginTime').AsDateTime;
    WOrkTime.dtFileEndTime      := FieldByName('dtFileEndTime').AsDateTime;

    WorkTime.nChuQinTypeID := FieldByName('nChuQinTypeID').AsInteger;
    WorkTime.nTuiQinTypeID := FieldByName('nTuiQinTypeID').AsInteger;

    //ͣ��ʱ��
    WorkTime.nGoRunTotalMinutes := FieldByName('nGoRunTotalMinutes').AsInteger;
    WorkTime.nBackRunTotalMinutes := FieldByName('nBackRunTotalMinutes').AsInteger;

    //�����ٶ�
    WorkTime.fGoSpeed := FieldByName('fGoSpeed').AsFloat;
    WorkTime.fBackSpeed := FieldByName('fBackSpeed').AsFloat;


    {WorkTime.TrainmanPlan.Group.strGroupGUID :=  FieldByName('strGroupGUID').AsString;  }
    WorkTime.TrainmanPlan.TrainPlan.strTrainJiaoluName :=  FieldByName('strTrainJiaoluName').AsString;
    WorkTime.TrainmanPlan.TrainPlan.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    WorkTime.TrainmanPlan.TrainPlan.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    WorkTime.TrainmanPlan.TrainPlan.strTrainNumber := FieldByName('strTrainNumber').AsString;
    WorkTime.TrainmanPlan.TrainPlan.strTrainNo := FieldByName('strTrainNo').AsString;
    WorkTime.TrainmanPlan.TrainPlan.nKeHuoID := trsKehuo(FieldByName('nKeHuoID').AsInteger);

    WorkTime.TrainmanPlan.Group.Trainman1.strTrainmanGUID := FieldByName('strTrainmanGUID1').AsString;
    WorkTime.TrainmanPlan.Group.Trainman1.strTrainmanName := FieldByName('strTrainmanName1').AsString;
    WorkTime.TrainmanPlan.Group.Trainman1.strTrainmanNumber := FieldByName('strTrainmanNumber1').AsString;

    WorkTime.TrainmanPlan.Group.Trainman2.strTrainmanGUID := FieldByName('strTrainmanGUID2').AsString;
    WorkTime.TrainmanPlan.Group.Trainman2.strTrainmanName := FieldByName('strTrainmanName2').AsString;
    WorkTime.TrainmanPlan.Group.Trainman2.strTrainmanNumber := FieldByName('strTrainmanNumber2').AsString;

    WorkTime.TrainmanPlan.Group.Trainman3.strTrainmanGUID := FieldByName('strTrainmanGUID3').AsString;
    WorkTime.TrainmanPlan.Group.Trainman3.strTrainmanName := FieldByName('strTrainmanName3').AsString;
    WorkTime.TrainmanPlan.Group.Trainman3.strTrainmanNumber := FieldByName('strTrainmanNumber3').AsString;

  end;

end;

procedure TRsDBWorkTime.WorkTimeToADOQuery(WorkTime: RRsWorkTime;
  ADOQuery: TADOQuery);
begin
 with ADOQuery do
  begin
    //�� ����
    FieldByName('strTrainTypeName').AsString := WOrkTime.strTrainTypeName;
    FieldByName('strTrainNumber').AsString := WOrkTime.strTrainNumber;
    FieldByName('strTrainNo').AsString := WOrkTime.strTrainNo;
    //���γ���
    FieldByName('nChuQinTypeID').AsInteger := WOrkTime.nChuQinTypeID;
    FieldByName('bLocalOutDepots').AsInteger := WOrkTime.bLocalOutDepots;
    FieldByName('dtLocalOutDepotsTime').AsDateTime := WOrkTime.dtLocalOutDepotsTime;
    //,������ͣ��
    FieldByName('dtStartTime').AsDateTime := WOrkTime.dtStartTime;
    FieldByName('dtArriveTime').AsDateTime := WOrkTime.dtArriveTime;
    //�յ�վ����
    FieldByName('strDestStationName').AsString := WOrkTime.strDestStationName;
    //�� ���� ,������ͣ��
    FieldByName('strBackTrainTypeName').AsString := WOrkTime.strBackTrainTypeName;
    FieldByName('strBackTrainNumber').AsString := WOrkTime.strBackTrainNumber;
    FieldByName('strBackTrainNo').AsString := WOrkTime.strBackTrainNo;
    FieldByName('dtStartTime2').AsDateTime := WOrkTime.dtStartTime2;
    FieldByName('dtArriveTime2').AsDateTime := WOrkTime.dtArriveTime2;


    //���γ����
    FieldByName('nTuiQinTypeID').AsInteger := WOrkTime.nTuiQinTypeID;
    FieldByName('bLocalInDepots').AsInteger := WOrkTime.bLocalInDepots;
    FieldByName('dtLocalInDepotsTime').AsDateTime := WOrkTime.dtLocalInDepotsTime;

    //����ʱ
    FieldByName('fTotalTime').AsInteger := WOrkTime.fTotalTime;
    //����ʱ
    FieldByName('nOutTotalTime').AsInteger := WOrkTime.nOutTotalTime;

    //ͣ��ʱ��
    FieldByName('nLocalStopMinutes').AsInteger := WOrkTime.nLocalStopMinutes;
    FieldByName('nRemoteStopMinutes').AsInteger := WOrkTime.nRemoteStopMinutes;
    //��ʱ
    FieldByName('nGoRunTotalMinutes').AsInteger := WOrkTime.nGoRunTotalMinutes;
    FieldByName('nBackRunTotalMinutes').AsInteger := WOrkTime.nBackRunTotalMinutes;
    //�����ٶ�
    FieldByName('fGoSpeed').AsFloat := WOrkTime.fGoSpeed;
    FieldByName('fBackSpeed').AsFloat := WOrkTime.fBackSpeed;
  end;
end;

procedure TRsDBWorkTime.QueryWorkTime(BeginTime, EndTime: TDateTime;
  WorkShopGUID, TrainmanNumber, TrainmanName: string;
  out WorkTimeArray: TRsWorkTimeArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_WorkTime_Turn where dtBeginWorkTime >= %s and dtBeginWorkTime <=%s ';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime))]);
      if Trim(WorkShopGUID) <> '' then
      begin
        strSql := strSql + ' and strWorkShopGUID = %s ';
        strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
      end;
      if Trim(TrainmanNumber) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanNumber1 = %s or  strTrainmanNumber2 = %s or strTrainmanNumber3 = %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
      end;
      if Trim(TrainmanName) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName+ '%'),QuotedStr(TrainmanName+ '%')]);
      end;
      strSql := strSql + ' order by dtBeginWorkTime';
      SQL.Text := strSql;
      Open;
      SetLength(WorkTimeArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToWorkTime(ADOQuery,WorkTimeArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;  
end;

procedure TRsDBWorkTime.QueryWorkTime(BeginTime, EndTime: TDateTime;
  trainjiaoluGUID : string;TrainmanNumber, TrainmanName: string;
  OnUnconfirm : boolean;out WorkTimeArray: TWorkTimeArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_WorkTime_Turn where dtBeginWorkTime >= %s and dtBeginWorkTime <=%s ';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime))]);
      if Trim(trainjiaoluGUID) <> '' then
      begin
        strSql := strSql + ' and (strtrainjiaoluGUID = %s)';
        strSql := Format(strSql,[QuotedStr(trainjiaoluGUID)]);
      end;
      if Trim(TrainmanNumber) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanNumber1 = %s or  strTrainmanNumber2 = %s or strTrainmanNumber3 = %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
      end;
      if Trim(TrainmanName) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName+ '%'),QuotedStr(TrainmanName+ '%')]);
      end;
      if (OnUnconfirm) then
      begin
        strSql := strSql + ' and (bConfirm is null  or bConfirm = 0)';
      end;
      strSql := strSql + ' order by dtBeginWorkTime';
      SQL.Text := strSql;
      Open;
      SetLength(WorkTimeArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToWorkTime(ADOQuery,WorkTimeArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.QueryWorkTimeByWorkShop(BeginTime, EndTime: TDateTime;
  WorkShopGUID, trainjiaoluGUID, TrainmanNumber, TrainmanName: string;
  OnUnconfirm: boolean; out WorkTimeArray: TWorkTimeArray;ShowProgessEvent:TShowProgessEvent);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_WorkTime_Turn where dtBeginWorkTime >= %s and dtBeginWorkTime <=%s ';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime))]);
      if Trim(WorkShopGUID) <> '' then
      begin
        strSql := strSql + ' and (strTrainJiaoluGUID in (select strTrainJiaoluGUID from tab_base_trainjiaolu where strWorkShopGUID = %s))';
        strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);
      end;

      if Trim(trainjiaoluGUID) <> '' then
      begin
        strSql := strSql + ' and (strtrainjiaoluGUID = %s)';
        strSql := Format(strSql,[QuotedStr(trainjiaoluGUID)]);
      end;
      if Trim(TrainmanNumber) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanNumber1 = %s or  strTrainmanNumber2 = %s or strTrainmanNumber3 = %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
      end;
      if Trim(TrainmanName) <> '' then
      begin
        strSql := strSql + ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s)';
        strSql := Format(strSql,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName+ '%'),QuotedStr(TrainmanName+ '%')]);
      end;
      if (OnUnconfirm) then
      begin
        strSql := strSql + ' and (bConfirm is null  or bConfirm = 0)';
      end;
      strSql := strSql + ' order by dtBeginWorkTime';
      SQL.Text := strSql;
      Open;
      if RecordCount <= 0 then
        Exit ;
      
      SetLength(WorkTimeArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToWorkTime(ADOQuery,WorkTimeArray[i]);
        Inc(i);
        if Assigned(ShowProgessEvent) then
          ShowProgessEvent( i / RecordCount  );
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBWorkTime.GetWorkTime(FlowID: string;
  out WorkTime: RRsWorkTime): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_WorkTime_Turn where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(FlowID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToWorkTime(ADOQuery,WorkTime);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.AddWorkTime(WorkTime :RRsWorkTime);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_WorkTime_Turn where 1 = 2';
      SQL.Text := strSql;
      Open;
      Append;
      WorkTimeToADOQuery(WorkTime,ADOQuery);
      Post;           
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.UpdateWorkTime(WorkTime: RRsWorkTime);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_WorkTime_Turn where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(WorkTime.strFlowID)]);
      SQL.Text := strSql;
      Open;
      Edit;
      WorkTimeToADOQuery(WorkTime,ADOQuery);
      Post;           
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.DeleteWorkTime(WorkTimeID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from TAB_WorkTime_Turn where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(WorkTimeID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.GetSignType(var TypeList: TStrings);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_WorkTime_SignType order by nid';
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      while not eof do
      begin
        TypeList.Add(FieldByName('strSignText').AsString);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.AddSignType(SignText: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'insert into TAB_WorkTime_SignType (strSignText) values (%s)';
      strSql := Format(strSql,[QuotedStr(SignText)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.DeleteSignType(SignText: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from TAB_WorkTime_SignType where strSignText = %s';
      strSql := Format(strSql,[QuotedStr(SignText)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;
 
function TRsDBWorkTime.ModifyWorkTime(WorkTime: RRsWorkTime): Boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := False ;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_WorkTime_Turn where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(WorkTime.strFlowID)]);
      SQL.Text := strSql;
      Open;
      Edit;
      WorkTimeToADOQuery(WorkTime,ADOQuery);
      Result := True ;
      Post;           
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.CancelConfirmWorkTime(FlowID, DutyUserGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update tab_worktime_turn set bConfirm = 0,dtConfirmTime=getdate(),strConfirmDutyUser=%s where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(DutyUserGUID),QuotedStr(FlowID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.ConfirmWorkTime(FlowID, DutyUserGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update tab_worktime_turn set bConfirm = 1,dtConfirmTime=getdate(),strConfirmDutyUser=%s where strFlowID = %s';
      strSql := Format(strSql,[QuotedStr(DutyUserGUID),QuotedStr(FlowID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBWorkTime.GetGroupIDFromFlowID(FlowID: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from tab_plan_trainman where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(FlowID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
        Result := FieldByName('strGroupGUID').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBWorkTime.IsFingerTuiQin: Boolean;
begin
  Result := False ;
end;

function TRsDBWorkTime.GetPlanSignText(TrainPlanGUID: string): string;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 strSignBrief from TAB_WorkTime_Turn_Branch where strFlowID = %s order by dtStartTime desc';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      result := FieldByName('strSignBrief').AsString;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBWorkTime.SignOutWork(TrainPlanGUID, SignText,DutyUser: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_WorkTime_Turn_Branch set strSignBrief = %s,' +
      ' bSigned=%d,dtSignTime=getdate(),strSignUser = %s where strFlowID = %s and bIsOver = 0';
      strSql := Format(strSql,[QuotedStr(SignText),1,QuotedStr(DutyUser),QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBWorkTime.UpdateArriveTime(GroupGUID: string;
  LastArriveTime: TDateTime): Boolean;
label
  labelModifyTime ;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;

      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Named where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;

      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Order where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;


      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;
      Close;
      Exit;

labelModifyTime:

      edit;
      FieldByName('dtLastArriveTime').AsDateTime := LastArriveTime;
      Post;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID1 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID2 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID3 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;

      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;


end.
