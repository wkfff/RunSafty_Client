unit uDBLendingManage;

interface
uses
  Classes,SysUtils,DateUtils,uTFSystem,ADODB,uLendingDefine,uGoodsRange;
type
////////////////////////////////////////////////////////////////////////////////
/// TQueryCondition  ��ѯ����������
////////////////////////////////////////////////////////////////////////////////
  TRsQueryCondition = class(TPersistent)
  public
    constructor Create();
  private
    {��ʼʱ��}
    m_dtBeginTime: tdatetime;
    {����ʱ��}
    m_dtEndTime: tdatetime;
    {�黹״̬}
    m_nReturnState: integer;
    {��Ʒ����}
    m_nLendingType: integer;
    {����Ա����}
    m_strTrainmanNumber: string;
    {����Ա����}
    m_strTrainmanName: string;
    {����GUID}
    m_strWorkShopGUID: string;
    {��Ʒ���}
    m_nLendingNumber: integer;
  public
    {����:����SQL�������}
    function GetSQLCondition(): string;
  published
    property dtBeginTime: tdatetime read m_dtBeginTime write m_dtBeginTime;
    property dtEndTime: tdatetime read m_dtEndTime write m_dtEndTime;
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property strWorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property nLendingNumber: integer read m_nLendingNumber write m_nLendingNumber;
  end;


  TRsDetailsQueryCondition = class(TPersistent)
  public
    constructor Create();
  private
    {�黹״̬}
    m_nReturnState: integer;
    {��Ʒ����}
    m_nLendingType: integer;
    {����Ա����}
    m_strTrainmanNumber: string;
    {����Ա����}
    m_strTrainmanName: string;
    {��Ʒ���}
    m_nBianHao: integer;
    {����ID}
    m_WorkShopGUID: string;
    {�����ֶ�}
    m_strOrderField: string;
  public
    {����:����SQL�������}
    function GetSQLCondition(): string;
  published
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property nBianHao: integer read m_nBianHao write m_nBianHao;
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property strOrderField: string read m_strOrderField write m_strOrderField;
  end;
  //��Ʒ��ѯ��������
  TGoodsOrderType = (gotNumber=1,gotBorrowTime);
////////////////////////////////////////////////////////////////////////////////
/// TDBLendingManage  ��Ʒ�������ݿ������
////////////////////////////////////////////////////////////////////////////////
  TRsDBLendingManage = class(TDBOperate)
  private
    procedure DataSetToLendDetail(ADOQuery: TADOQuery;LendingDetail:TRsLendingDetail);
    {����:�����Ʒ}
    procedure AddLendingDetails(LendingDetailList: TRsLendingDetailList);
    {����:������Ʒ�б�}
    procedure LoadLendingDetails(strLendingInfoGUID: string;
        LendingDetailList: TRsLendingDetailList);

    {����:�黹��Ʒ}
    procedure GiveBackDetail(LendingDetailList: TRsLendingDetailList);

    procedure SetSendDetailFields(ADOQuery: TADOQuery;LendingDetail:TRsLendingDetail);

    procedure UpdateLendingInfoRemark(strGUID,strRemark: string);

    function InsertLendingInfo(strRemark: string): string;
 public
    //�޸���Ʒ������
    function ModifyLeadintInfoName(strGUID,strNewName:string;out Error:string):Boolean;

     {����:��ȡ��Ʒ�ķ�Χ}
    procedure GetGoodsCodeRange(WorkShopGUID:string;AType:string;out ListGoodsRange:TRsGoodsRangeList) ;
     {����:������Ʒ�ķ�Χ}
     function InsertGoodsCodeRange(GoodsRange : RRsGoodsRange;out Error:string):Boolean ;
     {����:�޸���Ʒ�ķ�Χ}
     function UpdateGoodsCodeRange(GoodsRange : RRsGoodsRange;out Error:string):Boolean ;
     {����:ɾ����Ʒ�ķ�Χ}
     function DeleteGoodsCodeRange(Guid:string;out Error:string):Boolean ;
     {����:�����Ʒ�Ƿ���ָ���ķ�Χ}
     function IsInGoodsCodeRange(WorkShopGUID:string;AType:Integer;Code:Integer):Boolean;
  public

    {����:��ȡ�黹״̬�б�}
    procedure GetReturnStateList(ReturnStateList: TRsReturnStateList);

    {����:��ȡ��Ʒ�����б�}
    procedure GetLengingTypeList(LendingTypeList: TRsLendingTypeList);

    {����:���س����¼}
    procedure LoadLendingInfo(QueryCondition: TRsQueryCondition;
        LendingInfoList: TRsLendingInfoList);

    {����:��ȡ����Աδ�黹����Ϣ}
    function GetTrainmanNotReturnLendingInfo(strTrainmanGUID: string;
        var LendingDetailList: TRsLendingDetailList): Boolean;

    {����:�жϳ���Ա�Ƿ���δ�黹��¼}
    function IsHaveNotReturnGoods(strTrainmanGUID: string): Boolean;
    
    {����:������Ʒ}
    procedure SendLendingInfo(strTrainmanGUID: string;strRemark: string;
        LendingDetailList: TRsLendingDetailList);

    {����:�黹��Ʒ}
    procedure GiveBackLendingInfo(strTrainmanGUID: string;
        strRemark: string;LendingDetailList: TRsLendingDetailList);

    {����:�ж���Ʒ�Ƿ�ɹ黹}
    function CheckReturnAble(strTrainmanGUID: string;LendingDetail: TRsLendingDetail): Boolean;

    {����:�ж���Ʒ�Ƿ�ɽ��}
    function CheckLendAble(LendingDetail: TRsLendingDetail;strWorkShopGUID: string): Boolean;

    procedure QueryDetails(Condition: TRsDetailsQueryCondition;
        LendingDetailList: TRsLendingDetailList;strOrderField: string;WorkShopGUID : string);

    procedure GetTongJiInfo(lendingToJiList: TRslendingToJiList;WorkShopGUID: string);
    //��ѯ��Ʒ��������ѽ������ʾ���������ѹ黹����ʾ��Ʒ���
    procedure QueryGoodsNow(WorkShopGUID : string;GoodType:integer;
      GoodID:string;OrderType :TGoodsOrderType;LendingDetailList : TRsLendingDetailList);
    //ɾ����Ʒ����Ʒ��صķ��Ź黹��¼
    procedure DeleteGoods(LendingType : integer;LendingExInfo : string;WorkShopGUID : string);

  end;


implementation

{ TDBLendingManage }

procedure TRsDBLendingManage.SendLendingInfo(strTrainmanGUID: string;strRemark: string;
    LendingDetailList: TRsLendingDetailList);
{����:������Ʒ}
var
  ADOQuery: TADOQuery;
  strSQL: string;
  strGUID: string;
  i: Integer;
begin
  ADOQuery := NewADOQuery;
  try
    try
      m_ADOConnection.BeginTrans;
      strSQL := 'select strGUID from View_LendingInfo where strBorrowTrainmanGUID = %s ' +
        'and nReturnState = 0';


      ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(strTrainmanGUID)]);

      ADOQuery.Open();

      if ADOQuery.RecordCount = 0 then
      begin
        strGUID := InsertLendingInfo(strRemark);
      end
      else
      begin
        strGUID := ADOQuery.FieldByName('strGUID').AsString;
      end;

      
      for I := 0 to LendingDetailList.Count - 1 do
      begin
        LendingDetailList[i].strLendingInfoGUID := strGUID;
      end;

      
      AddLendingDetails(LendingDetailList);
      
      m_ADOConnection.CommitTrans;
    finally
      ADOQuery.Free;
    end;
  except
    on E: Exception do
    begin
      m_ADOConnection.RollbackTrans;
      raise Exception.Create(E.Message);
    end;
  end;

end;


function TRsDBLendingManage.UpdateGoodsCodeRange(
  GoodsRange: RRsGoodsRange; out Error: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSql : string ;
begin
  Result := False;
  ADOQuery := NewADOQuery;
  try
    try
      strSql := Format('select * from Tab_Base_LendingManager where strGUID = %s',[QuotedStr(GoodsRange.strGUID)]);
      ADOQuery.SQL.Text :=  strSql;
      ADOQuery.Open();

      ADOQuery.Edit;
      with GoodsRange do
      begin
        ADOQuery.FieldByName('nLendingTypeID').AsInteger := nLendingTypeID ; //��Ʒ���� {��̨/IC��/����}
        ADOQuery.FieldByName('nStartCode').AsInteger := nStartCode ;          //��ʼ���
        ADOQuery.FieldByName('nStopCode').AsInteger := nStopCode ;          //��ֹ���
        ADOQuery.FieldByName('strExceptCodes').AsString := strExceptCodes ;  //�ų��ı��
        ADOQuery.FieldByName('strWorkShopGUID').AsString := strWorkShopGUID  ; //������
      end;
      ADOQuery.Post;
      Result := True ;
    except
      on e:Exception do
      begin
        Error := e.Message ;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.UpdateLendingInfoRemark(strGUID,strRemark: string);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_LendingManage set ' +
      'strRemark = %s where strGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(strRemark),QuotedStr(strGUID)]);

    ADOQuery.ExecSQL;

  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.AddLendingDetails(LendingDetailList: TRsLendingDetailList);
{����:�����Ʒ}
var
  ADOQuery: TADOQuery;
  i: Integer;
begin
  ADOQuery := NewADOQuery;
  try
    if LendingDetailList.Count = 0 then
      Exit;
      
    ADOQuery.SQL.Text := 'select * from TAB_LendingDetail where 1=2';
    ADOQuery.Open();

    for I := 0 to LendingDetailList.Count - 1 do
    begin
      ADOQuery.Append;

      SetSendDetailFields(ADOQuery,LendingDetailList.Items[i]);

      ADOQuery.Post;
    end;

  finally
    ADOQuery.Free;
  end;
end;


procedure TRsDBLendingManage.SetSendDetailFields(ADOQuery: TADOQuery;
  LendingDetail: TRsLendingDetail);
begin
  ADOQuery.FieldByName('strGUID').AsString :=
      LendingDetail.strGUID;
  ADOQuery.FieldByName('dtBorrowTime').AsDateTime :=
      LendingDetail.dtBorrwoTime;
  ADOQuery.FieldByName('dtBorrowTime').AsDateTime :=
      LendingDetail.dtBorrwoTime;
  ADOQuery.FieldByName('nBorrowLoginType').AsInteger :=
      LendingDetail.nBorrowVerifyType;
  ADOQuery.FieldByName('strBorrowTrainmanGUID').AsString :=
      LendingDetail.strTrainmanGUID;
  ADOQuery.FieldByName('strLenderGUID').AsString :=
      LendingDetail.strLenderGUID;
  ADOQuery.FieldByName('strLendingInfoGUID').AsString :=
      LendingDetail.strLendingInfoGUID;
  ADOQuery.FieldByName('nLendingType').AsInteger :=
      LendingDetail.nLendingType;
  ADOQuery.FieldByName('strLendingExInfo').AsInteger :=
      LendingDetail.strLendingExInfo;
  ADOQuery.FieldByName('nReturnState').AsInteger :=
      LendingDetail.nReturnState;
  ADOQuery.FieldByName('dtModifyTime').AsDateTime :=
      LendingDetail.dtModifyTime;
end;

function TRsDBLendingManage.CheckLendAble(LendingDetail: TRsLendingDetail;
  strWorkShopGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    if LendingDetail.strLendingExInfo = 0 then
    begin
      Result := True;
      Exit;
    end;
    strSQL := 'select TAB_LendingDetail.nid,TAB_Org_Trainman.strWorkShopGUID ' +
      'from TAB_LendingDetail Left Join TAB_Org_Trainman On ' +
      'TAB_LendingDetail.strBorrowTrainmanGUID = Tab_Org_Trainman.strTrainmanGUID ' +
      'where strWorkShopGUID = %s and strLendingExInfo = %d and nReturnState = 0 and nLendingType = %d';
      
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(strWorkShopGUID),
      LendingDetail.strLendingExInfo,LendingDetail.nLendingType]);

    ADOQuery.Open();
    Result := ADOQuery.RecordCount = 0;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLendingManage.CheckReturnAble(strTrainmanGUID: string;
  LendingDetail: TRsLendingDetail): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from View_LendingInfoDetail where strBorrowTrainmanGUID = '
      + '%s and nReturnState = 0 and nLendingType = %d and strLendingExInfo = %d'; 
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(strTrainmanGUID),
      LendingDetail.nLendingType,LendingDetail.strLendingExInfo]);
    ADOQuery.Open();
    Result := ADOQuery.RecordCount > 0;

    if Result then
    begin
      LendingDetail.strGUID := ADOQuery.FieldByName('strGUID').AsString;
      LendingDetail.strLendingInfoGUID := ADOQuery.FieldByName('strLendingInfoGUID').AsString;
    end;
    
  finally
    ADOQuery.Free;
  end;
end;


procedure TRsDBLendingManage.DataSetToLendDetail(ADOQuery: TADOQuery;
  LendingDetail: TRsLendingDetail);
begin
  LendingDetail.strGUID := ADOQuery.FieldByName('strGUID').AsString;
  LendingDetail.strLendingInfoGUID := ADOQuery.FieldByName('strLendingInfoGUID').AsString;
  LendingDetail.nLendingType := ADOQuery.FieldByName('nLendingType').AsInteger;
  LendingDetail.strLendingTypeName := ADOQuery.FieldByName('strLendingTypeName').AsString;
  LendingDetail.strLendingTypeAlias := ADOQuery.FieldByName('strAlias').AsString;
  LendingDetail.strLendingExInfo := ADOQuery.FieldByName('strLendingExInfo').AsInteger;
  LendingDetail.strTrainmanGUID := ADOQuery.FieldByName('strBorrowTrainmanGUID').AsString;
  LendingDetail.strTrainmanNumber := ADOQuery.FieldByName('strBorrowTrainmanNumber').AsString;
  LendingDetail.strTrainmanName := ADOQuery.FieldByName('strBorrowTrainmanName').AsString;
  LendingDetail.dtModifyTime := ADOQuery.FieldByName('dtModifyTime').AsDateTime;
  LendingDetail.strStateName := ADOQuery.FieldByName('strStateName').AsString;
  LendingDetail.dtBorrwoTime := ADOQuery.FieldByName('dtBorrowTime').AsDateTime;
  LendingDetail.dtGiveBackTime := ADOQuery.FieldByName('dtGiveBackTime').AsDateTime;
  LendingDetail.nReturnState := ADOQuery.FieldByName('nReturnState').AsInteger;
  LendingDetail.strLenderNumber := ADOQuery.FieldByName('strLenderNumber').AsString;
  LendingDetail.strLenderName := ADOQuery.FieldByName('strLenderName').AsString;
  LendingDetail.strBorrowVerifyTypeName := ADOQuery.FieldByName('strBorrowLoginTypeName').AsString;
  LendingDetail.strGiveBackTrainmanGUID := ADOQuery.FieldByName('strGiveBackTrainmanGUID').AsString;
  LendingDetail.strGiveBackTrainmanNumber := ADOQuery.FieldByName('strGiveBackTrainmanNumber').AsString;
  LendingDetail.strGiveBackTrainmanName := ADOQuery.FieldByName('strGiveBackTrainmanName').AsString;
  LendingDetail.strGiveBackVerifyTypeName := ADOQuery.FieldByName('strGiveBackLoginTypeName').AsString;
  LendingDetail.nKeepMunites := ADOQuery.FieldByName('nMinutes').AsInteger; 
end;

procedure TRsDBLendingManage.DeleteGoods(LendingType: integer;
  LendingExInfo: string;WorkShopGUID : string);
var
  adoQuery: TADOQuery;
  strSQL: string;
begin
  adoQuery := NewADOQuery;
  adoQuery.Connection.BeginTrans;
  try
    with adoQuery do
    begin

      try
        strSQL := 'delete from TAB_LendingManage where strGUID in ' +
          ' (select strLendingInfoGUID from View_LendingInfoDetail where  nLendingType = %d and strLendingExInfo = %s and strWorkShopGUID = %s)';
        SQL.Text := Format(strSQL,[LendingType,QuotedStr(LendingExInfo),QuotedStr(WorkShopGUID)]);
        ExecSQL;

        strSQL := 'delete from TAB_LendingDetail where strGUID in ' +
          ' (select strGUID from View_LendingInfoDetail where  nLendingType = %d and strLendingExInfo = %s and strWorkShopGUID = %s)';
        SQL.Text := Format(strSQL,[LendingType,QuotedStr(LendingExInfo),QuotedStr(WorkShopGUID)]);
        ExecSQL;
        Connection.CommitTrans;
      except on e : exception do
        begin
          Connection.RollbackTrans;
          raise Exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBLendingManage.DeleteGoodsCodeRange(Guid: string;
  out Error: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('delete from Tab_Base_LendingManager where strGUID = %s ',[
      QuotedStr(Guid)]) ;
    try
      ADOQuery.SQL.Text := strSQL;
      ADOQuery.ExecSQL;
      Result := True ;
    except
      on e:Exception do
      begin
        Error := e.Message ;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.GetGoodsCodeRange(WorkShopGUID, AType: string;
  out ListGoodsRange: TRsGoodsRangeList);
var
  ADOQuery: TADOQuery;
  strSql:string;
  i : Integer ;
begin
  i := 0 ;
  ADOQuery := NewADOQuery;
  try
    strSql := Format('Select * from Tab_Base_LendingManager where strWorkShopGUID = %s ',[QuotedStr(WorkShopGUID)]);
    if AType <> '' then
    begin
      strSql := strSql + Format(' and nLendingTypeID = %d',[StrToInt(AType)]);
    end;
    ADOQuery.SQL.Text := strSql;
    ADOQuery.Open();
    if ADOQuery.IsEmpty then
      Exit ;
    SetLength(ListGoodsRange,ADOQuery.RecordCount);
    while not ADOQuery.Eof do
    begin
      with ListGoodsRange[i] do
      begin
        strGUID :=   ADOQuery.FieldByName('strGUID').AsString ;
        nLendingTypeID := ADOQuery.FieldByName('nLendingTypeID').AsInteger ; //��Ʒ���� {��̨/IC��/����}
        nStartCode := ADOQuery.FieldByName('nStartCode').AsInteger ;          //��ʼ���
        nStopCode := ADOQuery.FieldByName('nStopCode').AsInteger ;          //��ֹ���
        strExceptCodes := ADOQuery.FieldByName('strExceptCodes').AsString ;  //�ų��ı��
        strWorkShopGUID := ADOQuery.FieldByName('strWorkShopGUID').AsString ; //������
      end;
      inc(i);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;



procedure TRsDBLendingManage.GetLengingTypeList(
  LendingTypeList: TRsLendingTypeList);
{����:��ȡ��Ʒ�����б�}
var
  ADOQuery: TADOQuery;
  LendingType: TRsLendingType;
begin
  ADOQuery := NewADOQuery;
  try
    LendingTypeList.Clear;
    ADOQuery.SQL.Text := 'Select * from TAB_System_LendingType';
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LendingType := TRsLendingType.Create;
      LendingType.nLendingTypeID := ADOQuery.FieldByName('nLendingTypeID').AsInteger;
      LendingType.strLendingTypeName := ADOQuery.FieldByName('strLendingTypeName').AsString;
      LendingType.strAlias := ADOQuery.FieldByName('strAlias').AsString;
      LendingTypeList.Add(LendingType);

      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.GetReturnStateList(
  ReturnStateList: TRsReturnStateList);
{����:��ȡ�黹״̬�б�}
var
  ADOQuery: TADOQuery;
  ReturnState: TRsReturnState;
begin
  ADOQuery := NewADOQuery;
  try
    ReturnStateList.Clear;
    ADOQuery.SQL.Text := 'Select * from TAB_System_ReturnStateType';
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      ReturnState := TRsReturnState.Create;
      ReturnState.nReturnStateID := ADOQuery.FieldByName('nReturnStateID').AsInteger;
      ReturnState.strStateName := ADOQuery.FieldByName('strStateName').AsString;
      ReturnStateList.Add(ReturnState);

      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;


procedure TRsDBLendingManage.GetTongJiInfo(lendingToJiList: TRslendingToJiList;
    WorkShopGUID: string);
var
  ADOQuery: TADOQuery;
  LendingTongJi: TRsLendingTongJi;
begin
  lendingToJiList.Clear;
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'select * from VIEW_LendingTongJi where strWorkShopGUID = '
      + QuotedStr(WorkShopGUID);
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LendingTongJi := TRsLendingTongJi.Create;
      LendingTongJi.nLendingType := ADOQuery.FieldByName('nLendingType').AsInteger;
      LendingTongJi.strLendingTypeName := ADOQuery.FieldByName('strLendingTypeName').AsString;
      LendingTongJi.strTypeAlias := ADOQuery.FieldByName('strAlias').AsString;
      LendingTongJi.nTotalCount := ADOQuery.FieldByName('nTotalCount').AsInteger;
      LendingTongJi.nNoReturnCount := ADOQuery.FieldByName('nNoReturnCount').AsInteger;
      lendingToJiList.Add(LendingTongJi);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
  
end;

function TRsDBLendingManage.GetTrainmanNotReturnLendingInfo(
  strTrainmanGUID: string; var LendingDetailList: TRsLendingDetailList): Boolean;
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'select strGUID from View_LendingInfo where strBorrowTrainmanGUID = ' +
        QuotedStr(strTrainmanGUID)  + ' and nReturnState = 0';

    ADOQuery.Open();
    Result := ADOQuery.RecordCount > 0;
    
    if ADOQuery.RecordCount > 0 then
    begin
      
      LoadLendingDetails(Trim(ADOQuery.FieldByName('strGUID').AsString),
          LendingDetailList);
    end;
  finally
    ADOQuery.Free;
  end;
end;



function TRsDBLendingManage.InsertGoodsCodeRange(GoodsRange: RRsGoodsRange;
  out Error: string): Boolean;
var
  ADOQuery: TADOQuery;
begin
  Result := False;
  ADOQuery := NewADOQuery;
  try
    try
      ADOQuery.SQL.Text :=  'select * from Tab_Base_LendingManager where 1=2';
      ADOQuery.Open();

      ADOQuery.Append;
      with GoodsRange do
      begin
        ADOQuery.FieldByName('strGUID').AsString :=  strGUID ;
        ADOQuery.FieldByName('nLendingTypeID').AsInteger := nLendingTypeID ; //��Ʒ���� {��̨/IC��/����}
        ADOQuery.FieldByName('nStartCode').AsInteger := nStartCode ;          //��ʼ���
        ADOQuery.FieldByName('nStopCode').AsInteger := nStopCode ;          //��ֹ���
        ADOQuery.FieldByName('strExceptCodes').AsString := strExceptCodes ;  //�ų��ı��
        ADOQuery.FieldByName('strWorkShopGUID').AsString := strWorkShopGUID  ; //������
      end;
      ADOQuery.Post;
      Result := True ;
    except
      on e:Exception do
      begin
        Error := e.Message ;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLendingManage.InsertLendingInfo(strRemark: string): string;
var
  ADOQuery: TADOQuery;
begin
  Result := '';
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text :=  'select * from TAB_LendingManage where 1=2';
    ADOQuery.Open();

    ADOQuery.Append;
    Result := NewGUID;
    ADOQuery.FieldByName('strGUID').AsString := Result;
    ADOQuery.FieldByName('strRemark').AsString := strRemark;
    ADOQuery.Post;

  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLendingManage.IsHaveNotReturnGoods(
  strTrainmanGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'select * from View_LendingInfo where strBorrowTrainmanGUID = ' +
        QuotedStr(strTrainmanGUID)  + ' and nReturnState = 0';

    ADOQuery.Open();

    Result := ADOQuery.RecordCount > 0;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLendingManage.IsInGoodsCodeRange(WorkShopGUID:string; AType: Integer;
  Code: Integer): Boolean;
var
  strSql:string;
  ADOQuery: TADOQuery;
begin

  ADOQuery := NewADOQuery;
  try
    strSql := Format('select top 1 * from Tab_Base_LendingManager where strWorkShopGUID = %s and nLendingTypeID = %d ' +
      'and %d between nStartCode and nStopCode ',
      [QuotedStr(WorkShopGUID),AType,Code]);
    ADOQuery.SQL.Text := strSql ;
    ADOQuery.Open ;
    Result := not ADOQuery.IsEmpty ;
  finally
    ADOQuery.Free ;
  end;
end;

procedure TRsDBLendingManage.LoadLendingDetails(strLendingInfoGUID: string;
  LendingDetailList: TRsLendingDetailList);
{����:������Ʒ�б�}
const
  QUERY_SQL = 'select * from View_LendingInfoDetail where strLendingInfoGUID = %s';
var
  ADOQuery: TADOQuery;
  LendingDetail: TRsLendingDetail;
begin
  ADOQuery := NewADOQuery;
  try
    LendingDetailList.Clear;

    ADOQuery.SQL.Text := Format(QUERY_SQL,[QuotedStr(strLendingInfoGUID)]);

    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LendingDetail := TRsLendingDetail.Create;
      DataSetToLendDetail(ADOQuery,LendingDetail);
      LendingDetailList.Add(LendingDetail);

      ADOQuery.Next; 
    end;   

  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.LoadLendingInfo(
    QueryCondition: TRsQueryCondition;LendingInfoList: TRsLendingInfoList);
var
  ADOQuery: TADOQuery;
  LendingInfo: TRsLendingInfo;
begin
  ADOQuery := NewADOQuery;
  try
    LendingInfoList.Clear;
    ADOQuery.SQL.Text := 'Select * from View_LendingInfo ' +
        QueryCondition.GetSQLCondition + ' order by dtBorrowTime desc' ;
        
    ADOQuery.Open();


    while not ADOQuery.Eof do
    begin
      LendingInfo := TRsLendingInfo.Create;
      LendingInfo.strGUID := ADOQuery.FieldByName('strGUID').AsString;
      LendingInfo.nReturnState :=
          ADOQuery.FieldByName('nReturnState').AsInteger;

      LendingInfo.strBorrowTrainmanGUID :=
          ADOQuery.FieldByName('strBorrowTrainmanGUID').AsString;
      LendingInfo.strBorrowTrainmanName :=
          ADOQuery.FieldByName('strBorrowTrainmanName').AsString;
      LendingInfo.strBorrowTrainmanNumber :=
          ADOQuery.FieldByName('strBorrowTrainmanNumber').AsString;

      LendingInfo.nBorrowLoginType :=
          ADOQuery.FieldByName('nBorrowLoginType').AsInteger;

      LendingInfo.strGiveBackTrainmanGUID :=
          ADOQuery.FieldByName('strGiveBackTrainmanGUID').AsString;
      LendingInfo.strGiveBackTrainmanName :=
          ADOQuery.FieldByName('strGiveBackTrainmanName').AsString;
      LendingInfo.strGiveBackTrainmanNumber :=
          ADOQuery.FieldByName('strGiveBackTrainmanNumber').AsString;

      LendingInfo.nGiveBackLoginType :=
          ADOQuery.FieldByName('nGiveBackLoginType').AsInteger;
          
      LendingInfo.strLenderGUID :=
          ADOQuery.FieldByName('strLenderGUID').AsString;

      LendingInfo.strLenderNumber :=
          ADOQuery.FieldByName('strLenderNumber').AsString;
          
      LendingInfo.strLenderName :=
          ADOQuery.FieldByName('strLenderName').AsString;

      LendingInfo.dtBorrowTime :=
          ADOQuery.FieldByName('dtBorrowTime').AsDateTime;

      LendingInfo.dtGiveBackTime :=
          ADOQuery.FieldByName('dtGiveBackTime').AsDateTime;
          
      LendingInfo.dtModifyTime :=
          ADOQuery.FieldByName('dtModifyTime').AsDateTime;

      LendingInfo.strDetails :=
          ADOQuery.FieldByName('strLendingDetail').AsString;

      LendingInfo.strRemark :=
          ADOQuery.FieldByName('strRemark').AsString;

      LendingInfo.strStateName :=
          ADOQuery.FieldByName('strStateName').AsString;

      LendingInfo.strBorrowLoginName :=
          ADOQuery.FieldByName('strBorrowLoginTypeName').AsString;

      LendingInfo.strGiveBackLoginName :=
          ADOQuery.FieldByName('strGiveBackLoginTypeName').AsString;

      LendingInfoList.Add(LendingInfo);
      
      ADOQuery.Next; 
    end;

  finally
    ADOQuery.Free;
  end;
end;

function TRsDBLendingManage.ModifyLeadintInfoName(strGUID, strNewName: string;
  out Error: string): Boolean;
begin
  Result := True ;
end;

procedure TRsDBLendingManage.QueryDetails(Condition: TRsDetailsQueryCondition;
  LendingDetailList: TRsLendingDetailList; strOrderField: string;WorkShopGUID : string);
var
  ADOQuery: TADOQuery;
  LendingDetail: TRsLendingDetail;
begin
  ADOQuery := NewADOQuery;
  try
    LendingDetailList.Clear;
    ADOQuery.SQL.Text := 'select * from View_LendingInfoDetail where 1=1 ';
    

    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LendingDetail := TRsLendingDetail.Create;
      DataSetToLendDetail(ADOQuery,LendingDetail);
      LendingDetailList.Add(LendingDetail);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.QueryGoodsNow(WorkShopGUID : string;
  GoodType:integer;GoodID:string;OrderType :TGoodsOrderType;
  LendingDetailList : TRsLendingDetailList);
var
  ADOQuery: TADOQuery;
  LendingDetail: TRsLendingDetail;
begin
  ADOQuery := NewADOQuery;
  try
    LendingDetailList.Clear;
    ADOQuery.SQL.Text := 'select * from VIEW_Lending_Last where 1=1 ';
    if (WorkShopGUID <> '') then
    begin
       ADOQuery.SQL.Text := ADOQuery.SQL.Text + ' and strWorkShopGUID = ' + QuotedStr(WorkShopGUID);
    end;
    if (GoodType >= 0) then
    begin
       ADOQuery.SQL.Text := ADOQuery.SQL.Text + ' and nLendingType = ' + IntToStr(GoodType);
    end;
    if GoodID <> '-1' then
    begin
      ADOQuery.SQL.Text := ADOQuery.SQL.Text + ' and strLendingExInfo = ' + QuotedStr(GoodID);
    end;


    if OrderType = gotNumber then
    begin
      ADOQuery.SQL.Text := ADOQuery.SQL.Text + ' order by cast (strLendingExInfo as int)';
    end else begin
      ADOQuery.SQL.Text := ADOQuery.SQL.Text + ' order by nReturnState,dtBorrowTime ';
    end;

    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LendingDetail := TRsLendingDetail.Create;
      DataSetToLendDetail(ADOQuery,LendingDetail);
      LendingDetailList.Add(LendingDetail);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLendingManage.GiveBackDetail(
  LendingDetailList: TRsLendingDetailList);
{����:�黹��Ʒ}
const
  UPDATE_SQL = 'Update TAB_LendingDetail set dtModifyTime = %s,nReturnState = %d ' +
    ',dtGiveBackTime = %s,nGiveBackLoginType = %d,strGiveBackTrainmanGUID = %s ' +
    'where strGUID = %s';
var
  ADOQuery: TADOQuery;
  i: Integer;
begin
  ADOQuery := NewADOQuery;
  try
    for I := 0 to LendingDetailList.Count - 1 do
    begin
      ADOQuery.SQL.Text :=
        Format(UPDATE_SQL,[
          QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now)),2,
          QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Now)),
          LendingDetailList.Items[i].nGiveBackVerifyType,
          QuotedStr(LendingDetailList.Items[i].strGiveBackTrainmanGUID),
          QuotedStr(LendingDetailList.Items[i].strGUID)]);

      ADOQuery.ExecSQL;
    end;
  finally
    ADOQuery.Free;
  end;
end;


procedure TRsDBLendingManage.GiveBackLendingInfo(strTrainmanGUID: string;strRemark: string;
    LendingDetailList: TRsLendingDetailList);
{����:�黹��Ʒ}
var
  i: Integer;
begin
  for I := 0 to LendingDetailList.Count - 1 do
  begin
    if not CheckReturnAble(strTrainmanGUID,LendingDetailList[i]) then
    raise Exception.Create('δ�ҵ�' + LendingDetailList[i].CombineAliasName + '�Ľ��ü�¼!');
  end;

  m_ADOConnection.BeginTrans;
  try
    GiveBackDetail(LendingDetailList);

    for I := 0 to LendingDetailList.Count - 1 do
    begin
      UpdateLendingInfoRemark(LendingDetailList[i].strLendingInfoGUID,
        strRemark);
    end;

    m_ADOConnection.CommitTrans;
  except
    on E: Exception do
    begin
      m_ADOConnection.RollbackTrans;
      raise Exception.Create(E.Message);
    end;
  end;

    

end;


{ TQueryCondition }

constructor TRsQueryCondition.Create;
begin
  dtBeginTime := 0;
  dtEndTime := 0;
  nReturnState := -1;
  nLendingType := -1;
  nLendingNumber := -1;
end;

function TRsQueryCondition.GetSQLCondition: string;
{����:����SQL�������}
begin
  Result := ' where (1=1) ';

  if (dtBeginTime > 1) and (dtEndTime > 1) then
    Result := Result +
    Format('and (dtBorrowTime >= %s and dtBorrowTime <= %s) ',
      [QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTime)),
       QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndTime))]);

  if nReturnState > -1 then
    Result := Result + ' and (nReturnState = ' + IntToStr(nReturnState) + ') ';

  if nLendingType > -1 then
    Result := Result +
      Format('and (%d in (select nLendingType from TAB_LendingDetail where ' +
        'strLendingInfoGUID = View_LendingInfo.strGUID) ) ',[nLendingType]);


  if strTrainmanNumber <> '' then
    Result := Result + Format('and (strBorrowTrainmanNumber = %s) ',[QuotedStr(strTrainmanNumber)]);

  if strTrainmanName <> '' then
    Result := Result + Format('and (strBorrowTrainmanName = %s)',[QuotedStr(strTrainmanName)]);

  if strWorkShopGUID <> '' then
    Result := Result + Format('and (strWorkShopGUID = %s)',[QuotedStr(strWorkShopGUID)]);
    
  if nLendingNumber > -1 then  
    Result := Result + Format('and (strGUID in (select strLendingInfoGUID from TAB_LendingDetail where ' +
        'strLendingExInfo = %d) ) ',[nLendingNumber]);

  
end;

{ TDetailsQueryCondition }
constructor TRsDetailsQueryCondition.Create;
begin
  nBianHao := -1;
end;

function TRsDetailsQueryCondition.GetSQLCondition: string;
begin
  if nReturnState <> -1 then
    Result := Result + ' and nReturnState = ' + IntToStr(nReturnState);

  if nLendingType <> -1 then
    Result := Result + ' and nLendingType = ' + IntToStr(nLendingType);

  if strTrainmanNumber <> '' then
    Result := Result + ' and strBorrowTrainmanNumber = ' + QuotedStr(strTrainmanNumber);

  if strTrainmanName <> '' then
    Result := Result + ' and strBorrowTrainmanName= ' + QuotedStr(strTrainmanName);

  if nBianHao <> -1 then
    Result := Result + ' and strLendingExInfo= ' + IntToStr(nBianHao);


  if WorkShopGUID <> '' then
    Result := Result + ' and strWorkShopGUID = ' + QuotedStr(WorkShopGUID);


  if strOrderField = '' then
    Result := Result + ' order by dtBorrowTime Desc'
  else
    Result := Result + ' order by ' + strOrderField + ' Desc';



  
end;

end.

