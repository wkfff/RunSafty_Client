unit uTrainmanJiaolu;

interface
uses
  uTrainman,uStation,uSaftyEnum,uTrainJiaolu,uDutyPlace,Math;
type
  //��·����ö��
  TRsJiaoluType = (jltAny=-1,jltUnrun{����ת},jltReady{Ԥ��},jltNamed{����ʽ},jltOrder{�ֳ�},jltTogether{����});

  //��Ա��·
  RRsTrainmanJiaolu = record
    //��Ա��·GUID
    strTrainmanJiaoluGUID : string;
    //��Ա��·����
    strTrainmanJiaoluName : string;
    //��·����
    nJiaoluType : TRsJiaoluType;
    //������·
    strLineGUID : string;
    //��������
    strTrainJiaoluGUID : string;
    //�ͻ�����
    nKeHuoID : TRsKehuo;
    //ֵ������
    nTrainmanTypeID : TRsTrainmanType;
    //ǣ������
    nDragTypeID : TRsDragType;
    //��·��������
    nTrainmanRunType : TRsRunType;
    //��ʼ��վGUID
    strStartStationGUID : string;
    //��ʼ��վ����
    strStartStationName : string;
    //������վGUID
    strEndStationGUID : string;
    //������վ����
    strEndStationName : string;
    //��������
    strAreaGUID : string;

  end;
  PRsTrainmanJiaolu = ^RRsTrainmanJiaolu;
  //��Ա��·����
  TRsTrainmanJiaoluArray = array of RRsTrainmanJiaolu;

  RRsJLPlace = record
    ID : string;
    Name : string;
  end;
  TJLPlaceArray = array of RRsJLPlace;
  RRsSiteTMJL = record
    JlName : string;
    JlGUID : string;
    JlType : TRsJiaoluType;
    PlaceList : TJLPlaceArray;
  end;
  TRsSiteTMJLArray = array of RRsSiteTMJL;
  
  //��Ա��·���·��ƻ�������
  RRsTrainmanJiaoluSendCount = record
  public
     TrainmanJiaolu : RRsTrainmanJiaolu;
     SendCount : Integer; 
  end;  
  TRsTrainmanJiaoluSendCountArray = array of RRsTrainmanJiaoluSendCount;
  
  //��������
  TRsCheciType = (cctCheci{ʵ�ʳ���},cctRest{�ݰ�});
  //������Ϣ
  RRsGroup = record
    //����GUID
    strGroupGUID : string;
    //���ڵ͵�
    place:RRsDutyPlace;
    //�������ڳ�վ
    Station : RRsStation;
    //�����۷������GUID
    ZFQJ : RRsZheFanQuJian;
    //��˾��
    Trainman1 : RRsTrainman;
    //��˾��
    Trainman2 : RRsTrainman;
    //ѧԱ
    Trainman3 : RRsTrainman;
    //ѧԱ2
    Trainman4 : RRsTrainman;
    //����״̬
    GroupState : TRsTrainmanState;
    //��ǰֵ�˵ļƻ���GUID
    strTrainPlanGUID : string;

    strTrainNo : string;
    strTrainTypeName : string;
    strTrainNumber : string;
    //�������ʱ��
    dtArriveTime : TDateTime;

    //��i���һ����Ԣʱ��
    dtLastInRoomTime1 : TDateTime;
    dtLastOutRoomTime1 : TDateTime ;
    dtSleepTime1:TDateTime ;
    //��̬��Ա��һ������ʱ��
    dtLastEndworkTime1 : TDateTime;

    //˾��2���һ����Ԣʱ��
    dtLastInRoomTime2 : TDateTime;
    dtLastOutRoomTime2 : TDateTime ;
    dtSleepTime2:TDateTime ;
    dtLastEndworkTime2 : TDateTime;

    //ѧԱ���һ����Ԣʱ��
    dtLastInRoomTime3 : TDateTime;
    dtLastOutRoomTime3 : TDateTime ;
    dtSleepTime3:TDateTime ;
    dtLastEndworkTime3 : TDateTime;

    //ѧԱ���һ����Ԣʱ��
    dtLastInRoomTime4 : TDateTime;
    dtLastOutRoomTime4 : TDateTime ;
    dtSleepTime4:TDateTime ;
    dtLastEndworkTime4 : TDateTime;



    nTXState: integer;
    dtTXBeginTime: TDateTime;
  public
    function GetTrainmanCount(nTrainmanState:TRsTrainmanState):Integer;
  private
    function GetMinGroupState():TRsTrainmanState;
    function GetMaxGroupState():TRsTrainmanState;
  public
    property MinGroupState : TRsTrainmanState read GetMinGroupState ;
    property MaxGroupState : TRsTrainmanState read GetMaxGroupState ;

  end;
  TRsGroupArray = array of RRsGroup;
  
  //����ʽ��·�ڻ�����Ϣ
  RRsNamedGroup = record
    //����GUID
    strCheciGUID : string;
    //������Ա��·GUID
    strTrainmanJiaoluGUID : string;
    //ԭʼ���
    nOrgCheciOrder:Integer ;
    //��·�����
    nCheciOrder : integer;
    //��������
    nCheciType : TRsCheciType;
    //����1
    strCheci1 : string;
    //����2
    strCheci2 : string;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime;
  
  end;
  TRsNamedGroupArray = array of RRsNamedGroup;

  //�ֳ˽�·�ڻ�����Ϣ
  RRsOrderGroup = record
    //����GUID
    strOrderGUID : string;
    //������·GUID
    strTrainmanJiaoluGUID : string;
    //���
    nOrder : integer;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupArray = array of RRsOrderGroup;

  //���ɽ�·�ڻ�����Ϣ
  RRsOrderGroupInTrain = record
    //����GUID
    strOrderGUID : string;
    //��������GUID
    strTrainGUID : string;
    //���
    nOrder : integer;
    //�������
    Group : RRsGroup;
    //���һ�ε���ʱ��
    dtLastArriveTime : TDateTime;
  end;  
  TRsOrderGroupInTrainArray = array of RRsOrderGroupInTrain;

  //���˻�����Ϣ
  RRsTogetherTrain = record
    //���˻���GUID
    strTrainGUID : string;
    //������·GUID
    strTrainmanJiaoluGUID : string;
    //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    //�����Ļ���
    Groups : TRsOrderGroupInTrainArray;
  end;
  TRsTogetherTrainArray = array of RRsTogetherTrain;

  //����ת��Ԥ����
  RRsOtherGroup = record
    strTrainmanJiaoluGUID : string;
    Trainman : RRsTrainman;
    Station : RRsStation;
  end;
  TRsOtherGroupArray = array of RRsOtherGroup;

  //����Ա��Ϣ���������ڽ�·��Ϣ
  RRsTrainmanWithJL = record
    Trainman : RRsTrainman;
    TrainmanJiaolu : RRsTrainmanJiaolu;
  end;
  TRsTrainmanWithJLArray = array of RRsTrainmanWithJL;
  
  //����Ա�ڰ����ڵ���Ϣ
  RRsTrainmanInGroup = record
    strTrainmanGUID : string;
    strGroupGUID :string;
    nTrainmanIndex : integer;
  end;

  //�ɰ���ز�����Ϣ���Զ������ɰ�ʱ��1���Զ������ɰ�ʱ��2��˯��ʱ���
  RRsPlanParam = record
    dtAutoSaveTime1: TDateTime;     //�Զ�����ʱ��1
    dtAutoSaveTime2: TDateTime;     //�Զ�����ʱ��2
    dtPlanBeginTime: TDateTime;     //�ƻ���ʼʱ��
    dtPlanEndTime: TDateTime;       //�ƻ�����ʱ��
    dtKeepSleepTime: TDateTime;     //˯��ʱ��
    bEnableSleepCheck: Boolean;     //�Ƿ����Ԣ�ݿ���
  end;

   //////////////////////////////////////////////////////////////////////////////
  ///����:RRsKernelTimeConfig
  ///����:�˰�ϵͳʱ�����
  //////////////////////////////////////////////////////////////////////////////
  RRsKernelTimeConfig = record
    //�а�ʱ�� ���� �ƻ�����ʱ�� ������
    nMinCallBeforeChuQing:Integer;
    //վ�ӷ�ʽ �ƻ�����ʱ�� ���� �ƻ�����ʱ�� ������
    nMinChuQingBeforeStartTrain_Z :Integer;
    //��ӷ�ʽ �ƻ�����ʱ�� ���� �ƻ�����ʱ�� ������
    nMinChuQingBeforeStartTrain_K :Integer;
    //�װ࿪ʼʱ�� ����� 0��ķ�����
    nMinDayWorkStart:Integer;
    //ҹ�࿪ʼʱ�� ����� 0��ķ�����
    nMinNightWokrStart:TDateTime;

  end;
    RTrainmanRunStateCount = record
    strJiaoLuName : string;
    //������
    nRuningCount:Integer ;
    //������Ϣ
    nLocalCount : Integer ;
    //�����Ϣ
    nSiteCount:Integer;
    //����Ϣ
    group:TRsGroupArray;
  end;

  TRTrainmanRunStateCountArray = array of  RTrainmanRunStateCount;

const
  EmptyRsGroup: RRsGroup = ();
implementation


{ RRsGroup }
function RRsGroup.GetMaxGroupState():TRsTrainmanState;
var
  i:Integer;
begin
  i := -1;
  
  if Trainman1.strTrainmanGUID <> '' then
  begin
    i  := Ord(Trainman1.nTrainmanState);
  end;
  if Trainman2.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman2.nTrainmanState);
    end
    else
    begin
       i :=Math.Max(i,Ord(Trainman2.nTrainmanState));
    end;
  end;
  if Trainman3.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman3.nTrainmanState);
    end
    else
    begin
       i :=Math.Max(i,Ord(Trainman3.nTrainmanState));
    end;
  end;
  if Trainman4.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman4.nTrainmanState);
    end
    else
    begin
       i :=Math.Max(i,Ord(Trainman4.nTrainmanState));
    end;
  end;
  if i = -1 then
  begin
    Result := tsNormal;
  end
  else
  begin
    Result := TRsTrainmanState(i);
  end;
end;

function RRsGroup.GetMinGroupState: TRsTrainmanState;
var
  i:Integer;
begin
  result := self.GroupState;
  Exit;


  i := -1;
  
  if Trainman1.strTrainmanGUID <> '' then
  begin
    i  := Ord(Trainman1.nTrainmanState);
  end;
  if Trainman2.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman2.nTrainmanState);
    end
    else
    begin
       i :=Math.min(i,Ord(Trainman2.nTrainmanState));
    end;
  end;
  if Trainman3.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman3.nTrainmanState);
    end
    else
    begin
       i :=Math.min(i,Ord(Trainman3.nTrainmanState));
    end;
  end;
  if Trainman4.strTrainmanGUID <> '' then
  begin
    if i = -1 then
    begin
      i  := Ord(Trainman4.nTrainmanState);
    end
    else
    begin
       i :=Math.min(i,Ord(Trainman4.nTrainmanState));
    end;
  end;
  if i = -1 then
  begin
    Result := tsReady;
  end
  else
  begin
    Result := TRsTrainmanState(i);
  end;

end;

function RRsGroup.GetTrainmanCount(nTrainmanState: TRsTrainmanState): Integer;
var
  i:Integer;
begin
  i:= 0;
  if Trainman1.nTrainmanState = nTrainmanState then
    Inc(i);
  if Trainman2.nTrainmanState = nTrainmanState then
    Inc(i);
  if Trainman3.nTrainmanState = nTrainmanState then
    Inc(i);
  if Trainman4.nTrainmanState = nTrainmanState then
    Inc(i);
  result := i;
end;

end.
