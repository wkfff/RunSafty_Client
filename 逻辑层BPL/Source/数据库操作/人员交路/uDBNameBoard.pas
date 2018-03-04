unit uDBNameBoard;

interface
uses
  Classes,ADODB, uTrainmanJiaolu, uTFSystem, uStation,uAskForLeave,uSaftyEnum,
  uTrainman, uTrainPlan;
type
  RNameBoardCondition = record
    strTrainmanNumber: string;
    strTrainmanName: string;
    strJP: string;
    strTrainmanJiaoluGUID: string;
  public
    procedure Init();
    function ToSQL: string;
  end;

  //人员交路数据库操作类
  TRsDBNameBoard = class(TDBOperate)   
  public
    //功能：从adoquery中读取数据放入RGroup结构中
    class procedure GroupFromADOQuery(var Group:RRsGroup;ADOQuery : TADOQuery;NeedPicture : boolean = false);
    //交换机组
    procedure ExchangeGroup(JiaoluType: TRsJiaoluType; SourceGroupGUID: string; DestGroupGUID: string);
    //获取人员所在交路信息
    procedure GetTrainmanJL(ADOConn: TADOConnection; TrainmanGUID: string; out TrainmanWithJL: RRsTrainmanWithJL);

  public

    //获取记名式交路的机班信息
    procedure GetNamedJiaoluGroups(
      TrainmanJiaoluGUID: string; out NamedGroupArray: TRsNamedGroupArray);
    //向人员交路中添加机班，是否成功根据NamedGroup的strGroupGUID是否为空判断，传入时请不要对此属性赋值
    //适用于记名式交路
    procedure AddNamedGroup(TrainmanJiaoluGUID: string; NamedGroup: RRsNamedGroup);
    //插入机组在左侧
    procedure InsertNamedGroupLeft(TrainmanJiaoluGUID: string; NamedGroupOld,NamedGroup: RRsNamedGroup);
    //插入机组在左侧
    procedure InsertNamedGroupRight(TrainmanJiaoluGUID: string; NamedGroupOld,NamedGroup: RRsNamedGroup);

    //修改记名式交路组的车次信息
    procedure UpdateCheciInfo(NamedGroup: RRsNamedGroup);
    //修改记名式交路机组的ORDER信息
    procedure UpdateNamedGroupOrder(NamedGroup: RRsNamedGroup;Order:Integer);
    //修改包乘机车信息
    procedure UpdateTrainInfo(TogetherTrain : RRsTogetherTrain);
    //删除记名式机组
    procedure DeleteNamedGroup(GroupGUID: string);
    //交换人员
    //目标机组的目标序号可能为空，为空时将源人员移动到目标机组的指定位置(1\2\3)
    procedure ExchangePerson(SourcePerson: string; DestPerson: string;
      DestGroupGUID: string; DestGroupIndex: Integer);
    //获取轮乘交路的机班信息,根据折返区间
    procedure GetOrderJiaoluGroups(TrainmanNumber,TrainmanName : string;
      TrainmanJiaoluGUID,ZFQJGUID: string;
      out OrderGroupArray: TRsOrderGroupArray);
    //获取轮乘交路的机班信息,根据车站
    procedure GetOrderJiaoluGroupsOfStation(TrainmanNumber,TrainmanName : string;
      TrainmanJiaoluGUID,StationGUID: string;
      out OrderGroupArray: TRsOrderGroupArray);
   // 获取轮乘交路的机班信息,车站是空的
    procedure GetUnormalOrderJiaoluGroupsOfStation(TrainmanNumber,TrainmanName : string;
      TrainmanJiaoluGUID,StationGUID: string;
      out OrderGroupArray: TRsOrderGroupArray);


    //获取轮乘交路的机班信息
    procedure GetOrderJiaoluGroup(strGroupGUID: string; out OrderGroup: RRsOrderGroup);
    procedure GetTogetherTrain(strTrainGUID: string; out TogetherTrain: RRsTogetherTrain);
    procedure GetNamedJiaoluGroup(strGroupGUID: string; out NamedGroup: RRsNamedGroup);
    procedure GetTogetherGroup(strGroupGUID: string; out GroupInTrain : RRsOrderGroupInTrain);
    //向人员交路中添加机班，传入时请不要对此属性赋值
    //适用于轮乘交路
    procedure AddOrderGroup(TrainmanJiaoluGUID: string;RunType : TRsRunType; OrderGroup: RRsOrderGroup);
    //获取包乘的机车信息
    procedure GetTogetherTrains(TrainmanJiaoluGUID: string; out TogetherTrainArray: TRsTogetherTrainArray);

    //获取包乘的机车信息
    procedure GetTogetherTrainsByCondition(Condition: RNameBoardCondition;
         out TogetherTrainArray: TRsTogetherTrainArray);
    //删除包乘机车
    procedure DeleteTogetherTrain(TrainGUID: string);
    //删除轮乘机组
    procedure DeleteOrderGroup(GroupGUID: string);
    //删除包乘机组
    procedure DeleteTogetherGroup(GroupGUID: string);
    //向机车中添加机班，是否成功根据OrderGroupInTrain的strGroupGUID是否为空判断，传入时请不要对此属性赋值
    //适用于包乘交路
    procedure AddGroupToTrain(TrainGUID: string; OrderGroupInTrain: RRsOrderGroupInTrain);
    //设置机组的到达时间(用于排序)
    procedure SetGroupArriveTime(OrderGUID : string;NewArriveTime : TDateTime);
    //记名式设置机组的到达时间
    procedure SetNamedGroupArriveTime(NamedGUID : string;NewArriveTime : TDateTime);
    //together设置机组的到达时间
    procedure SetTogetherGroupArriveTime(TogetherGUID : string;NewArriveTime : TDateTime);
  end;
implementation
uses
  SysUtils, DB, Windows,uDBTrainman;
{ TDBTrainmanJiaolu }

procedure TRsDBNameBoard.AddGroupToTrain(
  TrainGUID: string; OrderGroupInTrain: RRsOrderGroupInTrain);
var
  strSql: string;
  adoQuery: TADOQuery;
  groupGUID, orderGUID,strTrainmanJiaoluGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
begin

  adoQuery := TADOQuery.Create(nil);

  try
    m_ADOConnection.BeginTrans;
    try
      adoQuery.Connection := m_ADOConnection;

      strSql := 'select strTrainmanJiaoluGUID from TAB_Nameplate_TrainmanJiaolu_Train where strTrainGUID = ' + QuotedStr(TrainGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainmanJiaoluGUID := adoQuery.FieldByName('strTrainmanJiaoluGUID').AsString;
      end;


      strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(strTrainmanJiaoluGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;

      strSql := 'insert into TAB_Nameplate_Group ' +
    ' (strGroupGUID,strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4) ' +
    ' values (%s,%s,%s,%s,%s)';
  groupGUID := OrderGroupInTrain.Group.strGroupGUID;
  orderGUID := OrderGroupInTrain.strOrderGUID;
  strSql := Format(strSql, [QuotedStr(groupGUID),
   
      QuotedStr(OrderGroupInTrain.Group.Trainman1.strTrainmanGUID),
      QuotedStr(OrderGroupInTrain.Group.Trainman2.strTrainmanGUID),
      QuotedStr(OrderGroupInTrain.Group.Trainman3.strTrainmanGUID),
      QuotedStr(OrderGroupInTrain.Group.Trainman4.strTrainmanGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('添加机组信息错误');
        exit;
      end;


      if OrderGroupInTrain.Group.Trainman1.strTrainmanGUID <> '' then
      begin
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroupInTrain.Group.Trainman1.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('设置人员状态错误');
          exit;
        end;
      end;
      if OrderGroupInTrain.Group.Trainman2.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroupInTrain.Group.Trainman2.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('设置人员状态错误');
          exit;
        end;
      end;
      if OrderGroupInTrain.Group.Trainman3.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroupInTrain.Group.Trainman3.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('设置人员状态错误');
          exit;
        end;
      end;

      if OrderGroupInTrain.Group.Trainman4.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroupInTrain.Group.Trainman4.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('设置人员状态错误');
          exit;
        end;
      end;
      
      strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_OrderInTrain ' +
        ' (strOrderGUID,strTrainGUID,nOrder,strGroupGUID,dtLastArriveTime) '
        + ' (select %s,%s,(case  when max(nOrder) is null then 1 else max(nOrder) + 1 end),%s,getdate()' +
        ' from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strTrainGUID=%s)';
      strSql := Format(strSql, [QuotedStr(orderGUID), QuotedStr(TrainGUID),
        QuotedStr(groupGUID),QuotedStr(TrainGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('添加包乘机组顺序错误');
        exit;
      end;
      m_ADOConnection.CommitTrans;
    except on e : exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create(e.Message);
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBNameBoard.AddNamedGroup(TrainmanJiaoluGUID: string; NamedGroup: RRsNamedGroup);
var
  strSql: string;
  adoQuery: TADOQuery;
  groupGUID, checiGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    try
      adoQuery.Connection := m_ADOConnection;

      groupGUID := NamedGroup.Group.strGroupGUID;
      checiGUID := NamedGroup.strCheciGUID;

      strSql := 'insert into TAB_Nameplate_Group ' +
        ' (strGroupGUID,strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4) ' +
        ' values (%s,%s,%s,%s,%s)';

      strSql := Format(strSql, [QuotedStr(groupGUID),
          QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建机组错误');
        exit;
      end;
      strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(TrainmanJiaoluGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;
      if NamedGroup.Group.Trainman1.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman2.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改副司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman3.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;
      
      if NamedGroup.Group.Trainman4.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;
      
      strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Named ' +
        ' (strCheciGUID,strTrainmanJiaoluGUID,nCheciOrder,nCheciType,strCheci1,strCheci2,strGroupGUID,dtLastArriveTime) '
        + ' (select %s,%s, (case  when max(nCheCiOrder) is null then 1 else max(nCheCiOrder) + 1 end) ,%d,%s,%s,%s,getdate() from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID=%s)';
      strSql := Format(strSql, [QuotedStr(checiGUID), QuotedStr(NamedGroup.strTrainmanJiaoluGUID),
          Ord(NamedGroup.nCheciType),
          QuotedStr(NamedGroup.strCheci1), QuotedStr(NamedGroup.strCheci2),
          QuotedStr(groupGUID),QuotedStr(NamedGroup.strTrainmanJiaoluGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建记名式机组错误');
        exit;
      end;
      m_ADOConnection.CommitTrans;
    except on e : exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise Exception.Create(e.message);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.AddOrderGroup(
  TrainmanJiaoluGUID: string;RunType : TRsRunType; OrderGroup: RRsOrderGroup);
var
  strSql: string;
  adoQuery: TADOQuery;
  groupGUID, orderGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
begin
  strSql := 'insert into TAB_Nameplate_Group ' +
    ' (strGroupGUID,strZFQJGUID,strStationGUID,strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4,strPlaceID) ' +
    ' values (%s,%s,%s,%s,%s,%s,%s,%s)';
  groupGUID := OrderGroup.Group.strGroupGUID;
  orderGUID := OrderGroup.strOrderGUID;
  strSql := Format(strSql, [QuotedStr(groupGUID),
      QuotedStr(OrderGroup.Group.ZFQJ.strZFQJGUID),
      quotedStr(OrderGroup.Group.Station.strStationGUID),
      QuotedStr(OrderGroup.Group.Trainman1.strTrainmanGUID),
      QuotedStr(OrderGroup.Group.Trainman2.strTrainmanGUID),
      QuotedStr(OrderGroup.Group.Trainman3.strTrainmanGUID),
      QuotedStr(OrderGroup.Group.Trainman4.strTrainmanGUID),
      QuotedStr(OrderGroup.Group.place.placeID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    try
      adoQuery.Connection := m_ADOConnection;
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('添加机组信息错误');
        exit;
      end;

      strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(TrainmanJiaoluGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;

      if OrderGroup.Group.Trainman1.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroup.Group.Trainman1.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          raise exception.Create('修改人员状态信息错误');
          m_ADOConnection.RollbackTrans;
          exit;
        end;
      end;
      if OrderGroup.Group.Trainman2.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroup.Group.Trainman2.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          raise exception.Create('修改人员状态信息错误');
          m_ADOConnection.RollbackTrans;
          exit;
        end;
      end;
      if OrderGroup.Group.Trainman3.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroup.Group.Trainman3.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          raise exception.Create('修改人员状态信息错误');
          m_ADOConnection.RollbackTrans;
          exit;
        end;
      end;
      if OrderGroup.Group.Trainman4.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(OrderGroup.Group.Trainman4.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          raise exception.Create('修改人员状态信息错误');
          m_ADOConnection.RollbackTrans;
          exit;
        end;
      end;

      strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Order ' +
        ' (strOrderGUID,strTrainmanJiaoluGUID,strGroupGUID,nOrder,dtLastArriveTime) '
        + ' (select %s,%s,%s,(case  when max(nOrder) is null then 1 else max(nOrder) + 1 end),'
        + ' (case  when max(dtLastArriveTime) is null then getdate() else DATEADD (mi,1,max(dtLastArriveTime)) end) '
        + ' from view_Nameplate_TrainmanJiaolu_Order where strTrainmanJiaoluGUID=%s and strZFQJGUID=%s)';
      strSql := Format(strSql, [QuotedStr(orderGUID), QuotedStr(OrderGroup.strTrainmanJiaoluGUID),
         QuotedStr(groupGUID), QuotedStr(OrderGroup.strTrainmanJiaoluGUID),QuotedStr(OrderGroup.Group.ZFQJ.strZFQJGUID)]);
      if RunType = trtHunPao then
      begin
        strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Order ' +
          ' (strOrderGUID,strTrainmanJiaoluGUID,strGroupGUID,nOrder,dtLastArriveTime) '
          + ' (select %s,%s,%s,(case  when max(nOrder) is null then 1 else max(nOrder) + 1 end),' +
          ' (case  when max(dtLastArriveTime) is null then getdate() else DATEADD (mi,1,max(dtLastArriveTime)) end) ' +
          ' from view_Nameplate_TrainmanJiaolu_Order where strTrainmanJiaoluGUID=%s and strStationGUID=%s)';
        strSql := Format(strSql, [QuotedStr(orderGUID), QuotedStr(OrderGroup.strTrainmanJiaoluGUID),
           QuotedStr(groupGUID), QuotedStr(OrderGroup.strTrainmanJiaoluGUID),QuotedStr(OrderGroup.Group.Station.strStationGUID)]);
      end;
      
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('修改机组序号错误');
        exit;
      end;
      m_ADOConnection.CommitTrans;
    except on e : exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create(e.Message);
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;



procedure TRsDBNameBoard.DeleteNamedGroup(GroupGUID: string);
var
  strSql: string;
  strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 : string;
  adoQuery: TADOQuery;
begin

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'select strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount > 0 then
        begin
          strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
          strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
          strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString;
          strTrainmanGUID4 := FieldByName('strTrainmanGUID4').AsString;
        end;

        if strTrainmanGUID1 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID1)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID2 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID2)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID3 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID3)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID4 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID4)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        strSql := 'delete from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        ExecSql;
        
        strSql := 'delete from TAB_Nameplate_TrainmanJiaolu_Named where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        ExecSql;
        m_ADOConnection.CommitTrans;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.DeleteOrderGroup(
  GroupGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
  strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'select strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount > 0 then
        begin
          strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
          strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
          strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString;
          strTrainmanGUID4 := FieldByName('strTrainmanGUID4').AsString;
        end;

        if strTrainmanGUID1 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID1)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID2 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID2)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID3 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID3)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID4 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID4)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        strSql := 'delete from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('删除机组错误');
          exit;
        end;
        strSql := 'delete from TAB_Nameplate_TrainmanJiaolu_Order where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('删除机组序号错误');
          exit;
        end;
        m_ADOConnection.CommitTrans;
      except
        m_ADOConnection.RollbackTrans;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.DeleteTogetherGroup(GroupGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
  strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 : string;
begin

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'select strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        Open;
        if RecordCount > 0 then
        begin
          strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
          strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
          strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString;
          strTrainmanGUID4 := FieldByName('strTrainmanGUID4').AsString;
        end;

        if strTrainmanGUID1 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID1)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID2 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID2)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID3 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID3)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;
        if strTrainmanGUID4 <> '' then
        begin
          //修改人员状态为空
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
          strSql := Format(strSql, [Ord(tsReady),QuotedStr(strTrainmanGUID4)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            raise Exception.Create('修改人员状态错误');
            exit;
          end;
        end;

        strSql := 'delete from TAB_Nameplate_Group where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('删除机组信息错误');
          exit;
        end;
        strSql := 'delete from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s';
        strSql := Format(strSql, [QuotedStr(GroupGUID)]);
        Sql.Text := strSql;
        if ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('删除机组顺序错误');
          exit;
        end;
        m_ADOConnection.CommitTrans;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.DeleteTogetherTrain(TrainGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'delete from TAB_Nameplate_TrainmanJiaolu_Train where strTrainGUID = %s';
  strSql := Format(strSql, [QuotedStr(TrainGUID)]);
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

procedure TRsDBNameBoard.ExchangeGroup(JiaoluType: TRsJiaoluType; SourceGroupGUID: string;
  DestGroupGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'exec PROC_Nameplate_ExchangeGroup %d,%s,%s';
  strSql := Format(strSql, [Integer(JiaoluType), QuotedStr(SourceGroupGUID), QuotedStr(DestGroupGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      m_ADOConnection.BeginTrans;
      try
        ExecSQL;
        m_ADOConnection.CommitTrans;
      except on e: exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.ExchangePerson(SourcePerson: string; DestPerson: string;
  DestGroupGUID: string; DestGroupIndex: Integer);
var
  strSql: string;
  adoQuery: TADOQuery;
  execCount :integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;

      try
        m_ADOConnection.BeginTrans;
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID1=%s where strTrainmanGUID1 = %s';
        strSql := Format(strSql, [QuotedStr(DestPerson), QuotedStr(SourcePerson)]);
        SQL.Text := strSql;
        execCount := ExecSQL;

        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID2=%s where strTrainmanGUID2 = %s';
        strSql := Format(strSql, [QuotedStr(DestPerson), QuotedStr(SourcePerson)]);
        SQL.Text := strSql;
        execCount := execCount + ExecSQL;

        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID3=%s where strTrainmanGUID3 = %s';
        strSql := Format(strSql, [QuotedStr(DestPerson), QuotedStr(SourcePerson)]);
        SQL.Text := strSql;
        execCount := execCount + ExecSQL;

        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID4=%s where strTrainmanGUID4 = %s';
        strSql := Format(strSql, [QuotedStr(DestPerson), QuotedStr(SourcePerson)]);
        SQL.Text := strSql;
        execCount := execCount + ExecSQL;
        if (execCount = 0) then
        begin
          raise exception.Create('清空原机组人员错误');
          exit;
        end;
        
        if DestGroupIndex = 1 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID1=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(SourcePerson), QuotedStr(DestGroupGUID)]);
        end;
        if DestGroupIndex = 2 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID2=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(SourcePerson), QuotedStr(DestGroupGUID)]);
        end;
        if DestGroupIndex = 3 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID3=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(SourcePerson), QuotedStr(DestGroupGUID)]);
        end;
        if DestGroupIndex = 4 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID4=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(SourcePerson), QuotedStr(DestGroupGUID)]);
        end;
        SQL.Text := strSql;
        ExecSQL;
        if ExecSQL = 0 then
        begin
          raise exception.Create('设置新人员错误');
          exit;
        end;
        m_ADOConnection.CommitTrans;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBNameBoard.GetNamedJiaoluGroups(TrainmanJiaoluGUID: string; out NamedGroupArray: TRsNamedGroupArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql: string;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_Named ' +
    ' where strTrainmanJiaoluGUID= %s order by nCheciOrder';
  strSql := Format(strSql, [QuotedStr(TrainmanJiaoluGUID)]);
  SetLength(NamedGroupArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      SetLength(NamedGroupArray, RecordCount);
      i := 0;
      while not eof do
      begin
        NamedGroupArray[i].strCheciGUID := FieldByName('strCheciGUID').AsString;
        NamedGroupArray[i].strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        NamedGroupArray[i].nCheciOrder := FieldByName('nCheciOrder').AsInteger;
        NamedGroupArray[i].nCheciType := TRsCheciType(FieldByName('nCheciType').AsInteger);
        NamedGroupArray[i].strCheci1 := FieldByName('strCheci1').AsString;
        NamedGroupArray[i].strCheci2 := FieldByName('strCheci2').AsString;
        NamedGroupArray[i].dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(NamedGroupArray[i].Group,adoQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetNamedJiaoluGroup(strGroupGUID: string; out NamedGroup: RRsNamedGroup);
var
  adoQuery: TADOQuery;
  strSql: string;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_Named ' +
    ' where strGroupGUID= %s order by nCheciOrder';
  strSql := Format(strSql, [QuotedStr(strGroupGUID)]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if not eof then
      begin
        NamedGroup.strCheciGUID := FieldByName('strCheciGUID').AsString;
        NamedGroup.strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        NamedGroup.nCheciOrder := FieldByName('nCheciOrder').AsInteger;
        NamedGroup.nCheciType := TRsCheciType(FieldByName('nCheciType').AsInteger);
        NamedGroup.strCheci1 := FieldByName('strCheci1').AsString;
        NamedGroup.strCheci2 := FieldByName('strCheci2').AsString;
        NamedGroup.dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(NamedGroup.Group,adoQuery);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetOrderJiaoluGroups(TrainmanNumber,TrainmanName : string;
  TrainmanJiaoluGUID,ZFQJGUID: string; out OrderGroupArray: TRsOrderGroupArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql: string;
begin
  strSql := 'select *,(select nPlanState from TAB_Plan_Train where strTrainPlanGUID = VIEW_Nameplate_Group.strTrainPlanGUID) as GroupState ' +
        ' from VIEW_Nameplate_Group  from VIEW_Nameplate_TrainmanJiaolu_Order ' +
    ' where strTrainmanJiaoluGUID= %s and strZFQJGUID=%s ';
  strSql := Format(strSql, [QuotedStr(TrainmanJiaoluGUID),
    QuotedStr(ZFQJGUID)]);
  if Trim(TrainmanNumber) <> '' then
  begin
    strSql := strSql + ' and (strTrainmanNumber1 like %s or strTrainmanNumber2 like %s or strTrainmanNumber3 like %s  or strTrainmanNumber4 like %s) ';
    strSql := Format(strSql,[QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%')]);
  end;
  if Trim(TrainmanNumber) <> '' then
  begin
    strSql := strSql + ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s or strTrainmanName4 like %s) ';
    strSql := Format(strSql,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%')]);
  end;
  strSql := strSql + ' order by dtLastArriveTime';

  SetLength(OrderGroupArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      SetLength(OrderGroupArray, RecordCount);
      i := 0;
      while not eof do
      begin
        OrderGroupArray[i].strOrderGUID := FieldByName('strOrderGUID').AsString;
        OrderGroupArray[i].strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        OrderGroupArray[i].nOrder := FieldByName('nOrder').AsInteger;
        OrderGroupArray[i].dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(OrderGroupArray[i].Group,adoQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetOrderJiaoluGroupsOfStation(TrainmanNumber,TrainmanName : string;
  TrainmanJiaoluGUID,
  StationGUID: string; out OrderGroupArray: TRsOrderGroupArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql,strTemp: string;
begin



  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_Order ' +
    ' where strTrainmanJiaoluGUID= %s and strStationGUID=%s ';
  strSql := Format(strSql, [QuotedStr(TrainmanJiaoluGUID),
    QuotedStr(StationGUID)]);

  if Trim(TrainmanNumber) <> '' then
  begin
    strTemp := ' and (strTrainmanNumber1 like %s or strTrainmanNumber2 like %s or strTrainmanNumber3 like %s or strTrainmanNumber4 like %s) ';
    strTemp := Format(strTemp,[QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%')]);
    strSql := strSql + strTemp;

  end;
  if Trim(TrainmanName) <> '' then
  begin
    strTemp := ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s or strTrainmanName4 like %s) ';
    strTemp := Format(strTemp,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%')]);
    strSql := strSql +  strTemp;

  end;
  strSql := strSql + ' order by dtLastArriveTime';  
  SetLength(OrderGroupArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      SetLength(OrderGroupArray, RecordCount);
      i := 0;
      while not eof do
      begin
        OrderGroupArray[i].strOrderGUID := FieldByName('strOrderGUID').AsString;
        OrderGroupArray[i].strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        OrderGroupArray[i].nOrder := FieldByName('nOrder').AsInteger;
        OrderGroupArray[i].dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(OrderGroupArray[i].Group,adoQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetOrderJiaoluGroup(strGroupGUID: string; out OrderGroup: RRsOrderGroup);
var
  adoQuery: TADOQuery;
  strSql: string;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_Order where strGroupGUID=%s';
  strSql := Format(strSql, [QuotedStr(strGroupGUID)]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if not eof then
      begin
        OrderGroup.strOrderGUID := FieldByName('strOrderGUID').AsString;
        OrderGroup.strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        OrderGroup.nOrder := FieldByName('nOrder').AsInteger;
        OrderGroup.dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(OrderGroup.Group,adoQuery);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetTogetherGroup(strGroupGUID: string;
  out GroupInTrain: RRsOrderGroupInTrain);
var
  adoQuery: TADOQuery;
  strSql: string;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain where  1 = 1 ';

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;

      Close;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetTogetherTrain(strTrainGUID: string; out TogetherTrain: RRsTogetherTrain);
var
  adoQuery: TADOQuery;
  strSql: string;  
  bFind : boolean;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
    ' where strTrainGUID= %s order by dtCreateTime,nOrder';
  strSql := Format(strSql, [QuotedStr(strTrainGUID)]);
  
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        try
          bFind:= false;
          //已经存在此机车信息
          if TogetherTrain.strTrainGUID = FieldByName('strTrainGUID').AsString then
          begin
            //添加机车内的班组信息
            SetLength(TogetherTrain.Groups, Length(TogetherTrain.Groups) + 1);
            with TogetherTrain.Groups[Length(TogetherTrain.Groups) - 1] do
            begin
              strOrderGUID := FieldByName('strOrderGUID').AsString;
              strTrainGUID := FieldByName('strTrainGUID').AsString;
              nOrder := FieldByName('nOrder').AsInteger;
              dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
              GroupFromADOQuery(Group,adoQuery);
            end;
            bFind:= true;
          end;
          if bFind then continue;

          //不存在机车信息。添加机车信息
          with TogetherTrain do
          begin
            strTrainGUID := FieldByName('strTrainGUID').AsString;
            strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
            strTrainTypeName := FieldByName('strTrainTypeName').AsString;
            strTrainNumber := FieldByName('strTrainNumber').AsString;
          end;
          //添加机车内的班组
          SetLength(TogetherTrain.Groups, 0);
          if FieldByName('strOrderGUID').AsString <> '' then
          begin
            SetLength(TogetherTrain.Groups, Length(TogetherTrain.Groups) + 1);
            with TogetherTrain.Groups[Length(TogetherTrain.Groups) - 1] do
            begin
              strOrderGUID := FieldByName('strOrderGUID').AsString;
              strTrainGUID := FieldByName('strTrainGUID').AsString;
              nOrder := FieldByName('nOrder').AsInteger;
              GroupFromADOQuery(Group,adoQuery);
            end;
          end;
        finally
          next;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetTogetherTrains(
  TrainmanJiaoluGUID: string; out TogetherTrainArray: TRsTogetherTrainArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql: string;
  bFind : boolean;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
    ' where strTrainmanJiaoluGUID= %s order by dtCreateTime,nOrder';
  strSql := Format(strSql, [QuotedStr(TrainmanJiaoluGUID)]);
  SetLength(TogetherTrainArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        try
          bFind:= false;
          for i := 0 to Length(TogetherTrainArray) - 1 do
          begin
            //已经存在此机车信息
            if TogetherTrainArray[i].strTrainGUID = FieldByName('strTrainGUID').AsString then
            begin
              //添加机车内的班组信息
              SetLength(TogetherTrainArray[i].Groups, Length(TogetherTrainArray[i].Groups) + 1);
              with TogetherTrainArray[i].Groups[Length(TogetherTrainArray[i].Groups) - 1] do
              begin
                strOrderGUID := FieldByName('strOrderGUID').AsString;
                strTrainGUID := FieldByName('strTrainGUID').AsString;
                nOrder := FieldByName('nOrder').AsInteger;
                dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
                GroupFromADOQuery(Group,adoQuery);
              end;
              bFind:= true;
              break;
            end;
          end;
          if bFind then
            continue;
          //不存在机车信息。添加机车信息
          SetLength(TogetherTrainArray, Length(TogetherTrainArray) + 1);
          with TogetherTrainArray[Length(TogetherTrainArray) - 1] do
          begin
            strTrainGUID := FieldByName('strTrainGUID').AsString;
            strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
            strTrainTypeName := FieldByName('strTrainTypeName').AsString;
            strTrainNumber := FieldByName('strTrainNumber').AsString;
          end;
          //添加机车内的班组
          SetLength(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups, 0);
          if FieldByName('strOrderGUID').AsString <> '' then
          begin
            SetLength(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups,
              Length(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups) + 1);
            with TogetherTrainArray[Length(TogetherTrainArray) - 1].
              Groups[Length(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups) - 1] do
            begin
              strOrderGUID := FieldByName('strOrderGUID').AsString;
              strTrainGUID := FieldByName('strTrainGUID').AsString;
              nOrder := FieldByName('nOrder').AsInteger;
              GroupFromADOQuery(Group,adoQuery);
            end;
          end;
        finally
          next;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetTogetherTrainsByCondition(
  Condition: RNameBoardCondition;out TogetherTrainArray: TRsTogetherTrainArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql: string;
  bFind : boolean;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
    Condition.ToSQL + ' order by dtCreateTime,nOrder';

  SetLength(TogetherTrainArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        try
          bFind:= false;
          for i := 0 to Length(TogetherTrainArray) - 1 do
          begin
            //已经存在此机车信息
            if TogetherTrainArray[i].strTrainGUID = FieldByName('strTrainGUID').AsString then
            begin
              //添加机车内的班组信息
              SetLength(TogetherTrainArray[i].Groups, Length(TogetherTrainArray[i].Groups) + 1);
              with TogetherTrainArray[i].Groups[Length(TogetherTrainArray[i].Groups) - 1] do
              begin
                strOrderGUID := FieldByName('strOrderGUID').AsString;
                strTrainGUID := FieldByName('strTrainGUID').AsString;
                nOrder := FieldByName('nOrder').AsInteger;
                dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
                GroupFromADOQuery(Group,adoQuery);
              end;
              bFind:= true;
              break;
            end;
          end;
          if bFind then
            continue;
          //不存在机车信息。添加机车信息
          SetLength(TogetherTrainArray, Length(TogetherTrainArray) + 1);
          with TogetherTrainArray[Length(TogetherTrainArray) - 1] do
          begin
            strTrainGUID := FieldByName('strTrainGUID').AsString;
            strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
            strTrainTypeName := FieldByName('strTrainTypeName').AsString;
            strTrainNumber := FieldByName('strTrainNumber').AsString;
          end;
          //添加机车内的班组
          SetLength(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups, 0);
          if FieldByName('strOrderGUID').AsString <> '' then
          begin
            SetLength(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups,
              Length(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups) + 1);
            with TogetherTrainArray[Length(TogetherTrainArray) - 1].
              Groups[Length(TogetherTrainArray[Length(TogetherTrainArray) - 1].Groups) - 1] do
            begin
              strOrderGUID := FieldByName('strOrderGUID').AsString;
              strTrainGUID := FieldByName('strTrainGUID').AsString;
              nOrder := FieldByName('nOrder').AsInteger;
              GroupFromADOQuery(Group,adoQuery);
            end;
          end;
        finally
          next;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetTrainmanJL(ADOConn: TADOConnection;
  TrainmanGUID: string; out TrainmanWithJL: RRsTrainmanWithJL);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'select * from VIEW_Nameplate_TrainmanInJiaolu_All where strTrainmanGUID = %s order by strTrainmanNumber';
  strSql := Format(strSql, [QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        TrainmanWithJL.Trainman.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        TrainmanWithJL.Trainman.strTrainmanName := FieldByName('strTrainmanName').AsString;
        TrainmanWithJL.Trainman.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        TrainmanWithJL.Trainman.strTelNumber := FieldByName('strTelNumber').AsString;
        TrainmanWithJL.Trainman.nPostID := TRsPost(FieldByName('nPostID').AsInteger);
        TrainmanWithJL.Trainman.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState').AsInteger);

        TrainmanWithJL.TrainmanJiaolu.strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        TrainmanWithJL.TrainmanJiaolu.strTrainmanJiaoluName := FieldByName('strTrainmanJiaoluName').AsString;
        TrainmanWithJL.TrainmanJiaolu.nJiaoluType := TRsJiaoluType(FieldByName('nJiaoluType').AsInteger);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.GetUnormalOrderJiaoluGroupsOfStation(TrainmanNumber,
  TrainmanName, TrainmanJiaoluGUID, StationGUID: string;
  out OrderGroupArray: TRsOrderGroupArray);
var
  i: integer;
  adoQuery: TADOQuery;
  strSql,strTemp: string;
begin

  strSql := 'select * from VIEW_Nameplate_TrainmanJiaolu_Order ' +
    ' where strTrainmanJiaoluGUID= %s and strStationGUID=%s ';
  strSql := Format(strSql, [QuotedStr(TrainmanJiaoluGUID),
    QuotedStr(StationGUID)]);

  if Trim(TrainmanNumber) <> '' then
  begin
    strTemp := ' and (strTrainmanNumber1 like %s or strTrainmanNumber2 like %s or strTrainmanNumber3 like %s or strTrainmanNumber4 like %s) ';
    strTemp := Format(strTemp,[QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%'),QuotedStr(TrainmanNumber + '%')]);
    strSql := strSql + strTemp;

  end;
  if Trim(TrainmanName) <> '' then
  begin
    strTemp := ' and (strTrainmanName1 like %s or strTrainmanName2 like %s or strTrainmanName3 like %s or strTrainmanName4 like %s) ';
    strTemp := Format(strTemp,[QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%'),QuotedStr(TrainmanName + '%')]);
    strSql := strSql +  strTemp;

  end;
  strSql := strSql + ' order by dtLastArriveTime';  
  SetLength(OrderGroupArray, 0);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      SetLength(OrderGroupArray, RecordCount);
      i := 0;
      while not eof do
      begin
        OrderGroupArray[i].strOrderGUID := FieldByName('strOrderGUID').AsString;
        OrderGroupArray[i].strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
        OrderGroupArray[i].nOrder := FieldByName('nOrder').AsInteger;
        OrderGroupArray[i].dtLastArriveTime := FieldByName('dtLastArriveTime').AsDateTime;
        GroupFromADOQuery(OrderGroupArray[i].Group,adoQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBNameBoard.GroupFromADOQuery(var Group: RRsGroup;
  ADOQuery: TADOQuery;NeedPicture : boolean = false);
begin
  with ADOQuery do
  begin
    Group.strGroupGUID := FieldByName('strGroupGUID').AsString;

    Group.Trainman1.strTrainmanGUID := FieldByName('strTrainmanGUID1').AsString;
    Group.Trainman1.strTrainmanName := FieldByName('strTrainmanName1').AsString;
    Group.Trainman1.strTrainmanNumber := FieldByName('strTrainmanNumber1').AsString;
    Group.Trainman1.strTelNumber := FieldByName('strTelNumber1').AsString;
    if FieldByName('nTrainmanState1').IsNull then
      Group.Trainman1.nTrainmanState := tsNil
    else
      Group.Trainman1.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState1').AsInteger);

    Group.Trainman1.nPostID := TRsPost(adoQuery.FieldByName('nPost1').asInteger);

    

    Group.Trainman2.strTrainmanGUID := FieldByName('strTrainmanGUID2').AsString;
    Group.Trainman2.strTrainmanName := FieldByName('strTrainmanName2').AsString;
    Group.Trainman2.strTrainmanNumber := FieldByName('strTrainmanNumber2').AsString;
    Group.Trainman2.strTelNumber := FieldByName('strTelNumber2').AsString;
    if FieldByName('nTrainmanState2').IsNull then
      Group.Trainman2.nTrainmanState := tsNil
    else
      Group.Trainman2.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState2').AsInteger);
    Group.Trainman2.nPostID := TRsPost(adoQuery.FieldByName('nPost2').asInteger);

      

    Group.Trainman3.strTrainmanGUID := FieldByName('strTrainmanGUID3').AsString;
    Group.Trainman3.strTrainmanName := FieldByName('strTrainmanName3').AsString;
    Group.Trainman3.strTrainmanNumber := FieldByName('strTrainmanNumber3').AsString;
    Group.Trainman3.strTelNumber := FieldByName('strTelNumber3').AsString;
    if FieldByName('nTrainmanState3').IsNull then
      Group.Trainman3.nTrainmanState := tsNil
    else
      Group.Trainman3.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState3').AsInteger);
    Group.Trainman3.nPostID := TRsPost(adoQuery.FieldByName('nPost3').asInteger);

    Group.Trainman4.strTrainmanGUID := FieldByName('strTrainmanGUID4').AsString;
    Group.Trainman4.strTrainmanName := FieldByName('strTrainmanName4').AsString;
    Group.Trainman4.strTrainmanNumber := FieldByName('strTrainmanNumber4').AsString;
    Group.Trainman4.strTelNumber := FieldByName('strTelNumber4').AsString;
    if FieldByName('nTrainmanState4').IsNull then
      Group.Trainman4.nTrainmanState := tsNil
    else
      Group.Trainman4.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState4').AsInteger);
    Group.Trainman4.nPostID := TRsPost(adoQuery.FieldByName('nPost4').asInteger);

    Group.dtArriveTime := FieldByName('dtLastArriveTime').asDateTime;
    Group.GroupState := tsNormal;
    if not FieldByName('GroupState').IsNull then
    begin
      Group.GroupState := tsPlaning;
      if TRsPlanState(FieldByName('GroupState').AsInteger) = psBeginWork then
      begin
        Group.GroupState := tsRuning;
      end;
    end;
    
  end;
end;

procedure TRsDBNameBoard.InsertNamedGroupLeft(TrainmanJiaoluGUID: string;
  NamedGroupOld, NamedGroup: RRsNamedGroup);
var
  nCheciOrder,j:Integer ;
  strSql: string;
  adoQuery: TADOQuery;
  groupGUID, checiGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    try
      adoQuery.Connection := m_ADOConnection;

      groupGUID := NamedGroup.Group.strGroupGUID;
      checiGUID := NamedGroup.strCheciGUID;

      strSql := 'insert into TAB_Nameplate_Group ' +
        ' (strGroupGUID,strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4) ' +
        ' values (%s,%s,%s,%s,%s)';

      strSql := Format(strSql, [QuotedStr(groupGUID),
          QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建机组错误');
        exit;
      end;
      strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(TrainmanJiaoluGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;
      if NamedGroup.Group.Trainman1.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman2.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改副司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman3.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;
      
      if NamedGroup.Group.Trainman4.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;

      {$REGION '获取当前的车次'}

      strSql := format('select nCheciOrder from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s and strCheciGUID = %s order by nCheciOrder  ',[QuotedStr(TrainmanJiaoluGUID),QuotedStr(NamedGroupOld.strCheciGUID)]);
      adoQuery.SQL.Text := strSql;
      adoQuery.Open;
      nCheciOrder := adoQuery.FieldByName('nCheciOrder').AsInteger ;
      {$ENDREGION}

      {$REGION '修改其他车次'}
      j := 1 ;
      strSql := format('select nCheciOrder from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s ' +
       ' and nCheciOrder >= %d order by nCheciOrder  ', [QuotedStr(TrainmanJiaoluGUID),nCheciOrder]);
      adoQuery.SQL.Text := strSql;
      adoQuery.Open;
      while not adoQuery.Eof do
      begin
        adoQuery.Edit;
        adoQuery.FieldByName('nCheciOrder').AsInteger := nCheciOrder + j ;
        adoQuery.Post;
        adoQuery.Next;
        inc(j);
      end;



      strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Named ' +
        ' (strCheciGUID,strTrainmanJiaoluGUID,nCheciOrder,nCheciType,strCheci1,strCheci2,strGroupGUID,dtLastArriveTime) '
        + ' (select top 1 %s,%s, %d ,%d,%s,%s,%s,getdate() from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID=%s)';
      strSql := Format(strSql, [QuotedStr(checiGUID), QuotedStr(NamedGroup.strTrainmanJiaoluGUID),
          nCheciOrder,Ord(NamedGroup.nCheciType),
          QuotedStr(NamedGroup.strCheci1), QuotedStr(NamedGroup.strCheci2),
          QuotedStr(groupGUID),QuotedStr(NamedGroup.strTrainmanJiaoluGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建记名式机组错误');
        exit;
      end;
      m_ADOConnection.CommitTrans;
    except on e : exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise Exception.Create(e.message);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.InsertNamedGroupRight(TrainmanJiaoluGUID: string;
  NamedGroupOld, NamedGroup: RRsNamedGroup);
var
  nCheciOrder,j:Integer ;
  strSql: string;
  adoQuery: TADOQuery;
  groupGUID, checiGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    try
      adoQuery.Connection := m_ADOConnection;

      groupGUID := NamedGroup.Group.strGroupGUID;
      checiGUID := NamedGroup.strCheciGUID;

      strSql := 'insert into TAB_Nameplate_Group ' +
        ' (strGroupGUID,strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3,strTrainmanGUID4) ' +
        ' values (%s,%s,%s,%s,%s)';

      strSql := Format(strSql, [QuotedStr(groupGUID),
          QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID),
          QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建机组错误');
        exit;
      end;
      strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(TrainmanJiaoluGUID);
      adoQuery.Sql.Text := strSql;
      adoQuery.Open;
      if (adoQuery.Recordcount > 0) then
      begin
        strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
      end;
      if NamedGroup.Group.Trainman1.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman1.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman2.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman2.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改副司机状态错误');
          exit;
        end;
      end;
      if NamedGroup.Group.Trainman3.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman3.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;
      
      if NamedGroup.Group.Trainman4.strTrainmanGUID <> '' then
      begin
        //修改人员状态为正常状态
        //修改人员状态为正常状态
        strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(NamedGroup.Group.Trainman4.strTrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        if adoQuery.ExecSQL = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create('修改学员状态错误');
          exit;
        end;
      end;

      {$REGION '获取当前的车次'}

      strSql := format('select nCheciOrder from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s and strCheciGUID = %s order by nCheciOrder  ',[QuotedStr(TrainmanJiaoluGUID),QuotedStr(NamedGroupOld.strCheciGUID)]);
      adoQuery.SQL.Text := strSql;
      adoQuery.Open;
      nCheciOrder := adoQuery.FieldByName('nCheciOrder').AsInteger ;
      {$ENDREGION
      {$REGION '修改其他车次'}
      j := 1 ;
      strSql := format('select nCheciOrder from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s ' +
       ' and nCheciOrder > %d order by nCheciOrder  ', [QuotedStr(TrainmanJiaoluGUID),nCheciOrder]);
      adoQuery.SQL.Text := strSql;
      adoQuery.Open;
      while not adoQuery.Eof do
      begin
        adoQuery.Edit;
        adoQuery.FieldByName('nCheciOrder').AsInteger := nCheciOrder + j ;
        adoQuery.Post;
        adoQuery.Next;
        inc(j);
      end;
      {$ENDREGION}

      {$REGION '创建机组'}
      strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Named ' +
        ' (strCheciGUID,strTrainmanJiaoluGUID,nCheciOrder,nCheciType,strCheci1,strCheci2,strGroupGUID,dtLastArriveTime) '
        + ' (select top 1 %s,%s, %d ,%d,%s,%s,%s,getdate() from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID=%s)';
      strSql := Format(strSql, [QuotedStr(checiGUID), QuotedStr(NamedGroup.strTrainmanJiaoluGUID),
          nCheciOrder + 1 ,Ord(NamedGroup.nCheciType),
          QuotedStr(NamedGroup.strCheci1), QuotedStr(NamedGroup.strCheci2),
          QuotedStr(groupGUID),QuotedStr(NamedGroup.strTrainmanJiaoluGUID)]);
      adoQuery.SQL.Text := strSql;
      if adoQuery.ExecSQL = 0 then
      begin
        m_ADOConnection.RollbackTrans;
        raise exception.Create('创建记名式机组错误');
        exit;
      end;
      {$ENDREGION}

      m_ADOConnection.CommitTrans;
    except on e : exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise Exception.Create(e.message);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.SetGroupArriveTime(OrderGUID: string;
  NewArriveTime: TDateTime);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Nameplate_TrainmanJiaolu_Order set dtLastArriveTime = %s where strOrderGUID = %s';
      strSql := Format(strSql, [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewArriveTime)),QuotedStr(OrderGUID)]);
      Sql.Text := strSql;
      ExecSQL
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.SetNamedGroupArriveTime(NamedGUID: string;
  NewArriveTime: TDateTime);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set dtLastArriveTime = %s where strGroupGUID = %s';
      strSql := Format(strSql, [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewArriveTime)),QuotedStr(NamedGUID)]);
      Sql.Text := strSql;
      ExecSQL
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.SetTogetherGroupArriveTime(TogetherGUID: string;
  NewArriveTime: TDateTime);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Nameplate_TrainmanJiaolu_OrderInTrain set dtLastArriveTime = %s where strOrderGUID = %s';
      strSql := Format(strSql, [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',NewArriveTime)),QuotedStr(TogetherGUID)]);
      Sql.Text := strSql;
      ExecSQL
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.UpdateCheciInfo(NamedGroup: RRsNamedGroup);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strCheci1=%s,strCheci2=%s,nCheciType = %d where strCheciGUID = %s';
  strSql := Format(strSql, [QuotedStr(NamedGroup.strCheci1),
    QuotedStr(NamedGroup.strCheci2),Ord(NamedGroup.nCheciType),QuotedStr(NamedGroup.strCheciGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.UpdateNamedGroupOrder(NamedGroup: RRsNamedGroup;
  Order: Integer);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set nCheciOrder = %d where strCheciGUID = %s';
  strSql := Format(strSql, [Order,QuotedStr(NamedGroup.strCheciGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBNameBoard.UpdateTrainInfo(TogetherTrain: RRsTogetherTrain);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  strSql := 'update TAB_Nameplate_TrainmanJiaolu_Train set strTrainTypeName=%s,strTrainNumber=%s where strTrainGUID = %s';
  strSql := Format(strSql, [QuotedStr(TogetherTrain.strTrainTypeName),
    QuotedStr(TogetherTrain.strTrainNumber),QuotedStr(TogetherTrain.strTrainGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;

end;

{ RNameBoardCondition }

procedure RNameBoardCondition.Init;
begin
  strTrainmanJiaoluGUID := '';
  strTrainmanNumber := '';
  strTrainmanName := '';
  strJP := '';
end;

function RNameBoardCondition.ToSQL: string;
begin
  Result := 'where (1=1) ';

  if strTrainmanJiaoluGUID <> '' then
    Result := Result + ' and strTrainmanJiaoluGUID = ' + QuotedStr(strTrainmanJiaoluGUID);

  if strTrainmanNumber <> '' then
    Result := Result +
      Format(' and (strTrainmanNumber1 = %0:s or strTrainmanNumber2 = %0:s or strTrainmanNumber3 = %0:s or strTrainmanNumber4 = %0:s)',[QuotedStr(strTrainmanNumber)]);

  if strTrainmanName <> '' then
    Result := Result +
    Format(' and (strTrainmanName1 = %0:s or strTrainmanName2 = %0:s or strTrainmanName3 = %0:s or strTrainmanName4 = %0:s)',[QuotedStr(strTrainmanNumber)]);
end;

end.

