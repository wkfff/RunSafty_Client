unit uRLNamedBoard;

interface
uses
  uTFSystem,ADODB,uTrainman,uTrainmanJiaolu,uDBTrainmanJiaolu,uDBNameBoard,
  SysUtils,uDutyUser,Windows,Classes, forms, Controls;
type
  TRSLBoardChangeType = (btNone=0,btcAddTrainman{添加人员},btcDeleteTrainman{删除人员},
    btcExchangeTrainman{交换人员},btcAddGroup{添加机组},btcDeleteGroup{删除机组},
    bctExchangeGroup{交换机组},btcChangeGroupOrder{修改机组的顺序});
  //变动日志
  RRsChangeLog = record
    //日志GUID
    strLogGUID : string;
    //人员交路GUID
    strTrainmanJiaoluGUID : string;
    //人员交路名称
    strTrainmanJiaoluName : string;
    //变动类型
    nBoardChangeType : TRSLBoardChangeType;
    //变动内容
    strContent : string;
    //值班员GUID
    strDutyUserGUID : string;
    //值班员工号
    strDutyUserNumber : string;
    //值班员名称
    strDutyUserName : string;
    //变动时间
    dtEventTime : TDatetime;
    //自增id
    nid : integer;
  end;
  TRsChangeLogArray = array of RRsChangeLog;
  TRSLNamedBoard = class(TDBOperate)
  private
    //人员交路数据库操作类
    m_DBTrainmanJiaolu : TRsDBTrainmanJiaolu;
    //名牌数据库操作类
    m_DBNameBoard : TRsDBNameBoard;
  public
    //
    constructor Create(ADOConnection: TADOConnection); override;
    destructor Destroy;override;
  public
    //向机组内添加人员
    procedure AddTrainmanToGroup(Trainman:RRsTrainman;TrainmanJiaoLu:RRsTrainmanJiaolu;
      Group : RRsGroup;TrainmanIndex : integer;ParentGUID : string);
    //从机组中删除人员
    procedure DeleteTrainmanFromGroup(TrainmanJiaolu : RRsTrainmanJiaolu;Group : RRsGroup;
      TrainmanIndex : integer;Trainman : RRsTrainman);
    //交换人员
    procedure ExchangeTrainman(Trainman:RRsTrainman;TrainmanJiaoLu:RRsTrainmanJiaolu;
      Group : RRsGroup;TrainmanIndex : integer;ParentGUID : string);
    procedure AddGroup(TrainmanJiaolu : RRsTrainmanJiaolu;NamedGroup:RRsNamedGroup;
      OrderGroup : RRsOrderGroup;OrderGroupInTrain : RRsOrderGroupInTrain);
    //删除机组,根据人员交路类型决定删除那种机组
    procedure DeleteGroup(TrainmanJiaolu : RRsTrainmanJiaolu;Group:RRsGroup);

    //交换机组
    procedure ExchangeGroup(TrainmanJiaolu : RRsTrainmanJiaolu;SourceGroup,DestGroup : RRsGroup);
    //移动机组,nInserBefore在目标之前插入
    procedure ChangeGroupOrder(TrainmanJiaolu : RRsTrainmanJiaolu;Group : RRsGroup;
      ParentGUID,SourceOrder,DestOrder : string);
    //获取机组人员的文字信息
    function  GetGroupTrainmanText(Group : RRsGroup;var TrainmanArray : TRsTrainmanArray) : string;  
     //更新人员交路信息到人员表
     procedure UpdateTrainmanJiaoLuToTrainman(Group : RRsGroup;TrainmanJiaoLu:string);


     //保存名牌变动日志
    procedure SaveChangeLog(TrainmanJiaolu : RRsTrainmanJiaolu;BoardChangeType : TRSLBoardChangeType;
      LogContent : string;DutyUserGUID,DutyUserName,DutyUserNumber : string;
      TrainmanArray : TRsTrainmanArray);
    //查询名牌变动日志  
    procedure QueryBoardChangeLog(BeginTime,EndTime : TDateTime;
      Trainmanjiaolus : TStrings;out ChangeLogArray : TRsChangeLogArray);  
  public
     DutyUser : TRsDutyUser;   
  end;
const
  TRSLBoardChangeTypeNameArray : array[TRSLBoardChangeType] of string =
    ('未知','添加人员','删除人员','交换人员','添加机组','删除机组','交换机组',
    '修改机组顺序');
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
    //添加交路信息到人员列表
    UpdateTrainmanJiaoLuToTrainman(namedGroup.Group,trainmanJiaolu.strTrainmanJiaoluGUID);
  finally
    strContent := '机组【%s】执行添加';
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
    //获取所在的交路
    TrainmanJiaoluGUID := TrainmanJiaoLu.strTrainmanJiaoluGUID;
    if TrainmanJiaoluGUID = '' then exit ;

    //获取新加人员所属的机组
    m_DBTrainmanJiaolu.GetTrainmanGroup(trainman.strTrainmanGUID,groupOld) ;
    //将人员从其所属机组中删除
    m_DBTrainmanJiaolu.DeleteTrainman(trainman.strTrainmanGUID);
    //删除后人员所属机组如果为空机组则删除点
    strGroupGUID :=  groupOld.strGroupGUID ;
    //添加人员到指定机组
    m_DBTrainmanJiaolu.AddTrainman(Group.strGroupGUID,TrainmanIndex,trainman.strTrainmanGUID);
    //如果人员原来不属于本人员交路则将人员添加到本人员交路中
    if Trainman.strTrainmanJiaoluGUID <> trainmanJiaoLu.strTrainmanJiaoluGUID then
    begin
      m_DBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(trainman.strTrainmanGUID,trainmanJiaoLu.strTrainmanJiaoluGUID);
    end;
    //交路类型
    JiaoluType :=  TrainmanJiaoLu.nJiaoluType;
    case JiaoluType of
      jltNamed : begin end;
      jltOrder :
      begin
        //轮乘交路自动删除移动后产生的空机组
        if m_DBTrainmanJiaolu.GetGroupInfo(strGroupGUID,groupOld) then
        begin
          //检查老机组是否为空，如果为空咋删除老机组
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
    strContent := '向机组【%s】的第【%d】位添加人员【%s】';
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
  //目标顺序为时间
  dtArriveTime := StrToDateTime(DestOrder);
  m_DBNameBoard.SetGroupArriveTime(ParentGUID,dtArriveTime);
  strContent := '机组【%s】的位置由【%s】修改为【%s】';
  strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);

  strContent := Format(strContent,[strTrainmanText,SourceOrder,
    DestOrder]);
  SaveChangeLog(TrainmanJiaolu,btcChangeGroupOrder,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);  
end;

constructor TRSLNamedBoard.Create(ADOConnection: TADOConnection);
begin
  inherited;
//人员交路数据库操作类
  m_DBTrainmanJiaolu := TRsDBTrainmanJiaolu.Create(ADOConnection);
  //名牌数据库操作类
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
    strContent := '机组【%s】执行删除';
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
  strContent := '从机组【%s】的第【%d】位删除人员【%s】';
  setlength(trainmanArray,0);
  strTrainmanText := GetGroupTrainmanText(Group,trainmanArray);
  strContent := Format(strContent,[strTrainmanText,TrainmanIndex,GetTrainmanText(Trainman)]);
  SaveChangeLog(TrainmanJiaolu,btcDeleteTrainman,strContent,DutyUser.strDutyGUID,
    DutyUser.strDutyName,DutyUser.strDutyNumber,trainmanArray);
end;

destructor TRSLNamedBoard.Destroy;
begin
 //人员交路数据库操作类
  m_DBTrainmanJiaolu.Free;
  //名牌数据库操作类
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
  
  strContent := '机组【%s%s】与机组【%s%s】执行交换';
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
  strContent := '将人员【%s】交换到机组【%d】的第【%s】位';
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
