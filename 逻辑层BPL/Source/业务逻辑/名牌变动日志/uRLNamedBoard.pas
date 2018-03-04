unit uRLNamedBoard;

interface
uses
  uTFSystem,ADODB,uTrainman,uTrainmanJiaolu,uDBTrainmanJiaolu,uDBNameBoard,
  SysUtils,uDutyUser,Windows,Classes, forms, Controls;
type
  TRSLBoardChangeType = (btNone=0,btcAddTrainman{�����Ա},btcDeleteTrainman{ɾ����Ա},
    btcExchangeTrainman{������Ա},btcAddGroup{��ӻ���},btcDeleteGroup{ɾ������},
    bctExchangeGroup{��������},btcChangeGroupOrder{�޸Ļ����˳��});
  //�䶯��־
  RRsChangeLog = record
    //��־GUID
    strLogGUID : string;
    //��Ա��·GUID
    strTrainmanJiaoluGUID : string;
    //��Ա��·����
    strTrainmanJiaoluName : string;
    //�䶯����
    nBoardChangeType : TRSLBoardChangeType;
    //�䶯����
    strContent : string;
    //ֵ��ԱGUID
    strDutyUserGUID : string;
    //ֵ��Ա����
    strDutyUserNumber : string;
    //ֵ��Ա����
    strDutyUserName : string;
    //�䶯ʱ��
    dtEventTime : TDatetime;
    //����id
    nid : integer;
  end;
  TRsChangeLogArray = array of RRsChangeLog;
  TRSLNamedBoard = class(TDBOperate)
  private
    //��Ա��·���ݿ������
    m_DBTrainmanJiaolu : TRsDBTrainmanJiaolu;
    //�������ݿ������
    m_DBNameBoard : TRsDBNameBoard;
  public
    //
    constructor Create(ADOConnection: TADOConnection); override;
    destructor Destroy;override;
  public
    //������������Ա
    procedure AddTrainmanToGroup(Trainman:RRsTrainman;TrainmanJiaoLu:RRsTrainmanJiaolu;
      Group : RRsGroup;TrainmanIndex : integer;ParentGUID : string);
    //�ӻ�����ɾ����Ա
    procedure DeleteTrainmanFromGroup(TrainmanJiaolu : RRsTrainmanJiaolu;Group : RRsGroup;
      TrainmanIndex : integer;Trainman : RRsTrainman);
    //������Ա
    procedure ExchangeTrainman(Trainman:RRsTrainman;TrainmanJiaoLu:RRsTrainmanJiaolu;
      Group : RRsGroup;TrainmanIndex : integer;ParentGUID : string);
    procedure AddGroup(TrainmanJiaolu : RRsTrainmanJiaolu;NamedGroup:RRsNamedGroup;
      OrderGroup : RRsOrderGroup;OrderGroupInTrain : RRsOrderGroupInTrain);
    //ɾ������,������Ա��·���;���ɾ�����ֻ���
    procedure DeleteGroup(TrainmanJiaolu : RRsTrainmanJiaolu;Group:RRsGroup);

    //��������
    procedure ExchangeGroup(TrainmanJiaolu : RRsTrainmanJiaolu;SourceGroup,DestGroup : RRsGroup);
    //�ƶ�����,nInserBefore��Ŀ��֮ǰ����
    procedure ChangeGroupOrder(TrainmanJiaolu : RRsTrainmanJiaolu;Group : RRsGroup;
      ParentGUID,SourceOrder,DestOrder : string);
    //��ȡ������Ա��������Ϣ
    function  GetGroupTrainmanText(Group : RRsGroup;var TrainmanArray : TRsTrainmanArray) : string;  
     //������Ա��·��Ϣ����Ա��
     procedure UpdateTrainmanJiaoLuToTrainman(Group : RRsGroup;TrainmanJiaoLu:string);


     //�������Ʊ䶯��־
    procedure SaveChangeLog(TrainmanJiaolu : RRsTrainmanJiaolu;BoardChangeType : TRSLBoardChangeType;
      LogContent : string;DutyUserGUID,DutyUserName,DutyUserNumber : string;
      TrainmanArray : TRsTrainmanArray);
    //��ѯ���Ʊ䶯��־  
    procedure QueryBoardChangeLog(BeginTime,EndTime : TDateTime;
      Trainmanjiaolus : TStrings;out ChangeLogArray : TRsChangeLogArray);  
  public
     DutyUser : TRsDutyUser;   
  end;
const
  TRSLBoardChangeTypeNameArray : array[TRSLBoardChangeType] of string =
    ('δ֪','�����Ա','ɾ����Ա','������Ա','��ӻ���','ɾ������','��������',
    '�޸Ļ���˳��');
implementation

uses DB;

{ TRSLBoardChangLog }

procedure TRSLNamedBoard.AddGroup(TrainmanJiaolu: RRsTrainmanJiaolu;
  NamedGroup: RRsNamedGroup; OrderGroup: RRsOrderGroup;
  OrderGroupInTrain: RRsOrderGroupInTrain);
var
  strContent,strTrainmanText : string;
  trainmanArray : TRsTrainmanArray;
  strGroupGUID : string;
  group : RRsGroup;
begin
  try
    case TrainmanJiaolu.nJiaoluType of
      jltNamed :
      begin
        m_DBNameBoard.AddNamedGroup(trainmanJiaolu.strTrainmanJiaoluGUID,namedGroup);
        group := NamedGroup.Group;
      end;
      jltOrder :
      begin
        m_DBNameBoard.AddOrderGroup(trainmanJiaolu.strTrainmanJiaoluGUID,trainmanJiaolu.nTrainmanRunType,orderGroup);
        group := OrderGroup.Group;
      end;
      jltTogether :
      begin
        m_DBNameBoard.AddGroupToTrain(orderGroupInTrain.strTrainGUID,orderGroupInTrain);
        group := OrderGroupInTrain.Group;
      end else begin
        exit;
      end;
    end;
    strGroupGUID := Group.strGroupGUID;
    //��ӽ�·��Ϣ����Ա�б�
    UpdateTrainmanJiaoLuToTrainman(namedGroup.Group,trainmanJiaolu.strTrainmanJiaoluGUID);
  finally
    strContent := '���顾%s��ִ�����';
    setlength(trainmanArray,0);
    strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
    strContent := Format(strContent,[strTrainmanText]);
    SaveChangeLog(TrainmanJiaolu,btcAddGroup,strContent,DutyUser.strDutyGUID,
      DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
  end;
end;

procedure TRSLNamedBoard.AddTrainmanToGroup(Trainman: RRsTrainman;
  TrainmanJiaoLu: RRsTrainmanJiaolu; Group: RRsGroup; TrainmanIndex: integer;
  ParentGUID: string);
var
  JiaoluType : TRsJiaoluType;
  TrainmanJiaoluGUID:string;
  groupOld : RRsGroup;
  strGroupGUID : string;
  strContent,strTrainmanText : string;
  trainmanArray : TRsTrainmanArray;
begin
  try
    //��ȡ���ڵĽ�·
    TrainmanJiaoluGUID := TrainmanJiaoLu.strTrainmanJiaoluGUID;
    if TrainmanJiaoluGUID = '' then exit ;

    //��ȡ�¼���Ա�����Ļ���
    m_DBTrainmanJiaolu.GetTrainmanGroup(trainman.strTrainmanGUID,groupOld) ;
    //����Ա��������������ɾ��
    m_DBTrainmanJiaolu.DeleteTrainman(trainman.strTrainmanGUID);
    //ɾ������Ա�����������Ϊ�ջ�����ɾ����
    strGroupGUID :=  groupOld.strGroupGUID ;
    //�����Ա��ָ������
    m_DBTrainmanJiaolu.AddTrainman(Group.strGroupGUID,TrainmanIndex,trainman.strTrainmanGUID);
    //�����Աԭ�������ڱ���Ա��·����Ա��ӵ�����Ա��·��
    if Trainman.strTrainmanJiaoluGUID <> trainmanJiaoLu.strTrainmanJiaoluGUID then
    begin
      m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(trainman.strTrainmanGUID,trainmanJiaoLu.strTrainmanJiaoluGUID);
    end;
    //��·����
    JiaoluType :=  TrainmanJiaoLu.nJiaoluType;
    case JiaoluType of
      jltNamed : begin end;
      jltOrder :
      begin
        //�ֳ˽�·�Զ�ɾ���ƶ�������Ŀջ���
        if m_DBTrainmanJiaolu.GetGroupInfo(strGroupGUID,groupOld) then
        begin
          //����ϻ����Ƿ�Ϊ�գ����Ϊ��զɾ���ϻ���
          if  (groupOld.Trainman1.strTrainmanGUID = '') and
          (groupOld.Trainman2.strTrainmanGUID = '')  and
          (groupOld.Trainman3.strTrainmanGUID = '')  and
          (groupOld.Trainman4.strTrainmanGUID = '')
          then
          begin
            m_DBNameBoard.DeleteTogetherGroup(groupOld.strGroupGUID);
          end;
        end;
      end;
      jltTogether : begin end;
    end;
  finally
    strContent := '����顾%s���ĵڡ�%d��λ�����Ա��%s��';
    setlength(trainmanArray,0);
    strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
    strContent := Format(strContent,[strTrainmanText,TrainmanIndex,GetTrainmanText(Trainman)]);
    SaveChangeLog(TrainmanJiaoLu,btcAddTrainman,strContent,DutyUser.strDutyGUID,
      DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
  end;
end;

procedure TRSLNamedBoard.ChangeGroupOrder(TrainmanJiaolu: RRsTrainmanJiaolu;
  Group: RRsGroup; ParentGUID, SourceOrder, DestOrder: string);
var
  dtArriveTime : TDateTime;
  strContent,strTrainmanText : string;
  trainmanArray : TRsTrainmanArray;
begin
  //Ŀ��˳��Ϊʱ��
  dtArriveTime := StrToDateTime(DestOrder);
  m_DBNameBoard.SetGroupArriveTime(ParentGUID,dtArriveTime);
  strContent := '���顾%s����λ���ɡ�%s���޸�Ϊ��%s��';
  strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);

  strContent := Format(strContent,[strTrainmanText,SourceOrder,
    DestOrder]);
  SaveChangeLog(TrainmanJiaolu,btcChangeGroupOrder,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);  
end;

constructor TRSLNamedBoard.Create(ADOConnection: TADOConnection);
begin
  inherited;
//��Ա��·���ݿ������
  m_DBTrainmanJiaolu := TRsDBTrainmanJiaolu.Create(ADOConnection);
  //�������ݿ������
  m_DBNameBoard := TRsDBNameBoard.Create(ADOConnection);
end;

procedure TRSLNamedBoard.DeleteGroup(TrainmanJiaolu: RRsTrainmanJiaolu;
  Group: RRsGroup);
var
  trainmanArray : TRsTrainmanArray;
  strContent,strTrainmanText : string;
begin
  try
    case TrainmanJiaolu.nJiaoluType of
      jltNamed :
      begin
        m_DBNameBoard.DeleteNamedGroup(Group.strGroupGUID);
      end;
      jltOrder :
      begin
        m_DBNameBoard.DeleteOrderGroup(Group.strGroupGUID);
      end;
      jltTogether :
      begin
        m_DBNameBoard.DeleteTogetherGroup(Group.strGroupGUID);
      end else begin
        exit;
      end;
    end;
  finally
    strContent := '���顾%s��ִ��ɾ��';
    setlength(trainmanArray,0);
    strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
    strContent := Format(strContent,[strTrainmanText]);
    SaveChangeLog(TrainmanJiaolu,btcDeleteGroup,strContent,DutyUser.strDutyGUID,
      DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray); 
  end;
end;

procedure TRSLNamedBoard.DeleteTrainmanFromGroup(
  TrainmanJiaolu: RRsTrainmanJiaolu; Group: RRsGroup; TrainmanIndex: integer;
  Trainman: RRsTrainman);
var
  strContent,strTrainmanText : string;
  trainmanArray : TRsTrainmanArray;  
begin
  m_DBTrainmanJiaolu.DeleteTrainman(Trainman.strTrainmanGUID);
  strContent := '�ӻ��顾%s���ĵڡ�%d��λɾ����Ա��%s��';
  setlength(trainmanArray,0);
  strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
  strContent := Format(strContent,[strTrainmanText,TrainmanIndex,GetTrainmanText(Trainman)]);
  SaveChangeLog(TrainmanJiaolu,btcDeleteTrainman,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
end;

destructor TRSLNamedBoard.Destroy;
begin
 //��Ա��·���ݿ������
  m_DBTrainmanJiaolu.Free;
  //�������ݿ������
  m_DBNameBoard.Free;
  inherited;
end;

procedure TRSLNamedBoard.ExchangeGroup(TrainmanJiaolu: RRsTrainmanJiaolu;
  SourceGroup, DestGroup: RRsGroup);
var
  trainmanArray : TRsTrainmanArray;
  strContent,strSourceTrainman,strDestTrainman : string;
begin
  m_DBNameBoard.ExchangeGroup(TrainmanJiaolu.nJiaoluType,SourceGroup.strGroupGUID,DestGroup.strGroupGUID);
  
  strContent := '���顾%s%s������顾%s%s��ִ�н���';
  strSourceTrainman := GetGroupTrainmanText(SourceGroup,trainmanArray);
  strDestTrainman := GetGroupTrainmanText(DestGroup,trainmanArray);
  strContent := Format(strContent,[strSourceTrainman,FormatDateTime('yyyy-MM-dd HH:nn:ss',SourceGroup.dtArriveTime),
    strDestTrainman,FormatDateTime('yyyy-MM-dd HH:nn:ss',DestGroup.dtArriveTime)]);
  SaveChangeLog(trainmanJiaolu,bctExchangeGroup,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
end;

procedure TRSLNamedBoard.ExchangeTrainman(Trainman: RRsTrainman;
  TrainmanJiaoLu: RRsTrainmanJiaolu; Group: RRsGroup; TrainmanIndex: integer;
  ParentGUID: string);
var
  strContent,strTrainmanText : string;
  trainmanArray : TRsTrainmanArray;
begin
  AddTrainmanToGroup(Trainman,TrainmanJiaolu,Group,TrainmanIndex,ParentGUID);
  strContent := '����Ա��%s�����������顾%d���ĵڡ�%s��λ';
  setlength(trainmanArray,0);
  strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
  strContent := Format(strContent,[GetTrainmanText(Trainman),TrainmanIndex,strTrainmanText]);
  SaveChangeLog(TrainmanJiaolu,btcExchangeTrainman,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
end;

function TRSLNamedBoard.GetGroupTrainmanText(Group: RRsGroup;
  var TrainmanArray: TRsTrainmanArray): string;
begin
 Result := '';
  if Group.Trainman1.strTrainmanGUID <> '' then
  begin
    SetLength(trainmanArray,length(trainmanArray) + 1);
    trainmanArray[length(trainmanArray) - 1] := Group.Trainman1;
    Result := Result + GetTrainmanText(Group.Trainman1) + ',';
  end;
  if Group.Trainman2.strTrainmanGUID <> '' then
  begin
    SetLength(trainmanArray,length(trainmanArray) + 1);
    trainmanArray[length(trainmanArray) - 1] := Group.Trainman2;
    Result := Result + GetTrainmanText(Group.Trainman2) + ',';
  end;
  if Group.Trainman3.strTrainmanGUID <> '' then
  begin
    SetLength(trainmanArray,length(trainmanArray) + 1);
    trainmanArray[length(trainmanArray) - 1] := Group.Trainman3;
    Result := Result + GetTrainmanText(Group.Trainman3) + ',';
  end;
  if Group.Trainman4.strTrainmanGUID <> '' then
  begin
    SetLength(trainmanArray,length(trainmanArray) + 1);
    trainmanArray[length(trainmanArray) - 1] := Group.Trainman4;
    Result := Result + GetTrainmanText(Group.Trainman4) + ',';
  end;
end;

procedure TRSLNamedBoard.QueryBoardChangeLog(BeginTime, EndTime: TDateTime;
  Trainmanjiaolus: TStrings; out ChangeLogArray: TRsChangeLogArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i: integer;
  strTrainmanJiaolus : string;
begin
  for i := 0 to TrainmanJiaolus.Count - 1 do
  begin
    if strTrainmanJiaolus = '' then
      strTrainmanJiaolus := QuotedStr(TrainmanJiaolus[i])
    else
      strTrainmanJiaolus := strTrainmanJiaolus + ',' + QuotedStr(TrainmanJiaolus[i]);
  end;
  if strTrainmanJiaolus = '' then
    strTrainmanJiaolus := Format('(%s)',[QuotedStr(strTrainmanJiaolus)])
  else
    strTrainmanJiaolus := Format('(%s)',[strTrainmanJiaolus]);  
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Nameplate_Log where dtEventTime>=:dtBeginTime' +
        ' and dtEventTime <=:dtEndTime and strTrainmanJiaoluGUID in ' + strTrainmanJiaolus + 
        ' order by dtEventTime';
      Sql.Text := strSql;
      Parameters.ParamByName('dtBeginTime').Value :=  BeginTime;
      Parameters.ParamByName('dtEndTime').Value :=  EndTime;

      Open;
      SetLength(ChangeLogArray,RecordCount);
      while not eof do
      begin
        ChangelogArray[RecNo - 1].strLogGUID := FieldByName('strLogGUID').AsString;
        ChangelogArray[RecNo - 1].strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        ChangelogArray[RecNo - 1].strTrainmanJiaoluName := FieldByName('strTrainmanJiaoluName').AsString;
        ChangelogArray[RecNo - 1].nBoardChangeType := TRSLBoardChangeType(FieldByName('nBoardChangeType').AsInteger);
        ChangelogArray[RecNo - 1].strContent := FieldByName('strContent').AsString;
        ChangelogArray[RecNo - 1].strDutyUserGUID := FieldByName('strDutyUserGUID').AsString;
        ChangelogArray[RecNo - 1].strDutyUserNumber := FieldByName('strDutyUserNumber').AsString;
        ChangelogArray[RecNo - 1].strDutyUserName := FieldByName('strDutyUserName').AsString;
        ChangelogArray[RecNo - 1].dtEventTime := FieldByName('dtEventTime').AsDateTime;
        ChangelogArray[RecNo - 1].nid := FieldByName('nid').AsInteger;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRSLNamedBoard.SaveChangeLog(TrainmanJiaolu: RRsTrainmanJiaolu;
  BoardChangeType: TRSLBoardChangeType; LogContent, DutyUserGUID, DutyUserName,
  DutyUserNumber: string; TrainmanArray: TRsTrainmanArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  strLogGUID : string;
  i: integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strLogGUID := NewGUID;
      strSql := 'insert into TAB_Nameplate_Log (strLogGUID,strTrainmanJiaoluGUID,' +
        ' strTrainmanJiaoluName,nBoardChangeType,strContent,strDutyUserGUID,' +
        ' strDutyUserNumber,strDutyUserName,dtEventTime) values ' +
        ' (:strLogGUID,:strTrainmanJiaoluGUID,:strTrainmanJiaoluName,:nBoardChangeType,' +
        ':strContent,:strDutyUserGUID,:strDutyUserNumber,:strDutyUserName,:dtEventTime)';
      Sql.Text := strSql;
      Parameters.ParamByName('strLogGUID').Value :=  strLogGUID;
      Parameters.ParamByName('strTrainmanJiaoluGUID').Value :=  TrainmanJiaolu.strTrainmanJiaoluGUID;
      Parameters.ParamByName('strTrainmanJiaoluName').Value :=  TrainmanJiaolu.strTrainmanJiaoluName;
      Parameters.ParamByName('nBoardChangeType').Value :=  Ord(BoardChangeType);
      Parameters.ParamByName('strContent').Value :=  LogContent;
      Parameters.ParamByName('strDutyUserGUID').Value :=  DutyUserGUID;
      Parameters.ParamByName('strDutyUserNumber').Value :=  DutyUserNumber;
      Parameters.ParamByName('strDutyUserName').Value :=  DutyUserName;
      Parameters.ParamByName('dtEventTime').Value :=  Now;
      ExecSQL;
      for i := 0 to length(TrainmanArray) - 1 do
      begin
        strSql := 'insert into TAB_Nameplate_Log_Trainman ' +
          ' (strLogGUID,strTrainmanGUID,strTrainmanName,strTrainmanNumber) ' +
          ' values (:strLogGUID,:strTrainmanGUID,:strTrainmanName,:strTrainmanNumber)';
        Sql.Text := strSql;
        Parameters.ParamByName('strLogGUID').Value :=  strLogGUID;
        Parameters.ParamByName('strTrainmanGUID').Value :=  TrainmanArray[i].strTrainmanGUID;
        Parameters.ParamByName('strTrainmanName').Value :=  TrainmanArray[i].strTrainmanName;
        Parameters.ParamByName('strTrainmanNumber').Value :=  TrainmanArray[i].strTrainmanNumber;
        ExecSQL;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRSLNamedBoard.UpdateTrainmanJiaoLuToTrainman(Group: RRsGroup;
  TrainmanJiaoLu: string);
begin
  if (Group.Trainman1.strTrainmanGUID <> '') and  (Group.Trainman1.strTrainJiaoluGUID <> TrainmanJiaoLu) then
    m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(Group.Trainman1.strTrainmanGUID,TrainmanJiaoLu);

  if (Group.Trainman2.strTrainmanGUID <> '') and (Group.Trainman2.strTrainJiaoluGUID <> TrainmanJiaoLu) then
    m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(Group.Trainman2.strTrainmanGUID,TrainmanJiaoLu);

  if (Group.Trainman3.strTrainmanGUID <> '') and (Group.Trainman3.strTrainJiaoluGUID <> TrainmanJiaoLu) then
    m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(Group.Trainman3.strTrainmanGUID,TrainmanJiaoLu);

  if (Group.Trainman4.strTrainmanGUID <> '') and (Group.Trainman4.strTrainJiaoluGUID <> TrainmanJiaoLu) then
    m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(Group.Trainman4.strTrainmanGUID,TrainmanJiaoLu);
end;

end.
