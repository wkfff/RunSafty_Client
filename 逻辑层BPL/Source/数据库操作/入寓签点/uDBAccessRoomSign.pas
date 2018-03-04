unit uDBAccessRoomSign;

interface

uses
  Classes,DB,Variants,ZKFPEngXUtils,
  ADODB,SysUtils,uLeaderExam,utfsystem,uSaftyEnum,
  uRoomSign,uTrainman,
  uBaseDBRoomSign;

type

  TRsDBAccessTrainman = class(TDBOperate)
  public
    {����:��ȡ��Ա������}
    function GetTrainmanSignature():string;
    {����:�޸���Ա������}
    procedure SetTrainmanSignature(strSignature:string);
    {����:��ȡָ��������}
    function GetFingerSignature():string;
    {����:�޸�ָ��������}
    procedure SetFingerSignature(strSignature:string);
    {����:ͬ����Ա��Ϣ}
    procedure SyncTrainman(trainman:RRsTrainman);

    //��ȡָ��ID�ĳ���Ա����Ϣ
    function GetTrainmanByNumber(TrainmanNumber : string;out Trainman : RRsTrainman) : boolean;
    //����GUID��ȡ����Ա��Ϣ
    function GetTrainman(TrainmanGUID : string;out Trainman : RRsTrainman) : boolean;
    //���ܣ�ɾ������Ա
    procedure DeleteTrainman(TrainmanGUID: string);
    //���ܣ���ӳ���Ա
    procedure AddTrainman(Trainman : RRsTrainman);
        //���ܣ��޸ĳ���Ա
    procedure UpdateTrainman(Trainman : RRsTrainman) ;
    //�Ƿ���ڷ�GUID��˾������
    function ExistNumber(TrainmanGUID,TrainmanNumber : string) : boolean;
        //���ܣ���ѯ˾����Ϣ
    procedure QueryTrainmans(QueryTrainman:RRsQueryTrainman;
      out TrainmanArray:TRsTrainmanArray);
          //��֤˾�������Ƿ����
    function ExistTrainmanByNumber(TrainmanNumber : string):boolean;

        //��ȡָ��ID�ĳ���Ա����Ϣ
    function GetTrainmanByID(ADOConn:TADOConnection;ID : integer;out Trainman : RRsTrainman) : boolean;
    //
    function GetTrainmanMaxID(out ID:Integer):Boolean;
      //��ȡ����Ա��Ҫ��Ϣ
    class procedure GetTrainmansBrief(ADOConn:TADOConnection; out TrainmanArray:TRsTrainmanArray);
  protected
    procedure ADOQueryToData(var Trainman:RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean = false);
    procedure DataToADOQuery(Trainman : RRsTrainman;ADOQuery : TADOQuery;NeedPicture : boolean=false);
  end;

  //ACCESS��Ԣ��Ԣ������
  TRsDBAccessRoomSign = class(TRsBaseDBRoomSign)
  public
    //������Ԣ�Ż�ȡ��Ϣ
    procedure GetSignInRecordByID(RoomGUID:string;var RoomSign:TRsRoomSign);override;
    //��ѯ
    procedure QuerySignList(RoomNumber,TrainmanNumber,TrainmanName:string;
      dtBegin,dtEnd: TDateTime;strSiteGUID: string;
      var RoomSignList: TRsRoomSignList;IsShowUnnormal:Boolean);override;
    //
    procedure QuerySignListLessThanTime(RoomNumber,TrainmanNumber,TrainmanName:string;
      dtBegin,dtEnd,dtNow: TDateTime;strSiteGUID: string;
      var RoomSignList: TRsRoomSignList);override;
   //���ӳ�Ԣ
    procedure InsertSignIn(const RoomSign:TRsRoomSign);override;
    //������Ԣ
    procedure InsertSignOut(const RoomSign:TRsRoomSign);override;
    //�ж��Ƿ���Ԣ,�������Ԣ���ȡ��Ϣ
    function  IsSignIn(Date:TDateTime;const TrainNumber:string;
      var GUID: string;var DateTime:TDateTime):Boolean;override;
    //������Ԣʱ��
    function  UpdateSignInTime(RoomGUID:string;Date:TDateTime):Boolean;override;
    //������Ԣ�����
    function  UpdateSignInRoomNumber(RoomGUID,RoomNumber:string;BedNumber:Integer):Boolean;override;
    //������Ԣʱ��
    function  UpdateSignOutTime(RoomGUID:string;Date:TDateTime):Boolean;override;
    //ɾ����Ԣ��¼
    function  DelSignInRecord(RoomGUID:string):Boolean;override;
    //ɾ����Ԣ��¼
    function  DelSignOutRecord(RoomGUID:string):Boolean;override;
    //ɾ�� ��Ԣ�������Ԣ�ļ�¼
    function  DelSignInOutRecord(RoomGUID:string):Boolean;override;
    //�Ƿ�����Ԣ��¼
    function  IsExistSignInRecord(RoomGUID:string):Boolean;override;
    //�Ƿ�����Ԣ��¼
    function  IsExistSignOutRecord(RoomGUID:string):Boolean;override;
    //�õ������Ԣʱ��
    function  GetSignInTime(const TrainNumber:string;var DateTime:TDateTime):Boolean;override;
    //�õ��������Ԣ��GUID
    function  GetLastInGUID(const TrainNumber:string):string;override;

    //ɾ����ʱ��¼
    procedure  DelOldInOutRecord(EndTime:TDateTime);
   private
    procedure  DelOldInRecord(EndTime:TDateTime);
    procedure  DelOldOutRecord(EndTime:TDateTime);
  end;



  //ACCESS��������������ݿ���
  TRsDBAccessRoomInfo = class(TRsBaseDBRoomInfo)
  public
    //��ȡ���е���פ���
    procedure GetEnterRoomList(var RoomInfoList : TRsRoomInfoArray);override;
    //��ȡ���еķ���
    procedure GetAllRoom(var RoomInfoList : TRsRoomInfoArray);override;
    //����һ������
    function  InsertRoom(RoomNumber:string):Boolean;override;
    //��շ������פ��Ա��Ϣ
    procedure ClearRoom(RoomNumber:string);override;
    //������еķ�����Ϣ
    procedure ClearAllRoom();override;
    //ɾ��һ������
    function  DeleteRoom(RoomNumber:string):Boolean; override;
    //��鷿���Ƿ����
    function  IsRoomExist(RoomNumber:string):Boolean; override;
  public
    //��ȡ���еķ������Ա�Ĺ���
    function  GetAllTrainmanRoomRelation(RoomNumber:string;var BedInfoArray:TRsBedInfoArray):Boolean;override;
    //��ѯĳ��
    function  QueryTrainmanRoomRelation(TrainmanNumber,TrainmanName:string;var RoomNumber:string):Boolean;override;
    //����ָ����Ա�ķ�����Ϣ
    function  InsertTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;override;
   //ɾ��ָ����Ա�ķ�����Ϣ
    function  RemoveTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;override;
    //�޸�ָ����Ա�ķ�����Ϣ
    function  ModifyTrainmanRoomRelation(RoomNumber:string;BedInfoOld:RRsBedInfo;BedInfoNew:RRsBedInfo):Boolean;override;
    //��ȡָ����Ա�ķ�����Ϣ
    function  GetTrainmanRoomRelation(TrainmanGUID:string;var BedInfo:RRsBedInfo):Boolean;override;
    //����Ƿ��Ѿ��з������Ա�Ĺ�ϵ
    function  IsHaveTrainmanRoomRelation(TrainmanGUID:string;out RoomNumber:string):Boolean;override;
        //��¼��Ա�ķ����
    function SaveTrainmanRoomRelation(TrainmanGUID:string;var BedInfo:RRsBedInfo):Boolean;override;
  public
    function IsRoomEmpty(RoomNumber:string):Boolean; override;
    //��鷿���Ƿ�����Ա
    function  IsRoomFull(RoomNumber:string):Boolean;override;
    //����ڷ������XX
    function  IsExistTrainman(TrainmanGUID,RoomNumber:string):Boolean;override;
    //���һ���˵�����
    function  AddTrainmanToRoom(TrainmanGUID,RoomNumber:string;BedNumber:Integer):Boolean; override;
    //�ӷ���ɾ��һ����
    procedure  DelTrainmanFromRoom(TrainmanGUID:string);override;
    //��ȡһ���յĴ�λ
    function   GetEmptyBedNumber(RoomNumber:string):Integer; override;
  end;


  TRsAccessDBLeaderInspect = class(TRsBaseDBLeaderInspect)
  public
      //��ȡ�ɲ�����б���Ϣ
    procedure  GetLeaderInspectList(BeginDate,EndDate:TDateTime;var LeaderInspectList:TRsLeaderInspectList);override;
    //���һ�������Ϣ
    function   AddLeaderInspect(LeaderInspect:RRsLeaderInspect):boolean;override;
    //ɾ����ʱ�ļ�¼
    procedure DelOldInpect(EndDate:TDateTime);
  end;


implementation

{ TRsDBAccessRoomInfo }

function TRsDBAccessRoomInfo.AddTrainmanToRoom(TrainmanGUID, RoomNumber: string;
  BedNumber: Integer): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update tab_base_room set strTrainmanGUID = %s where strRoomNumber = %s and nBedNumber = %d';
    strSQL := Format(strSQL,[QuotedStr(TrainmanGUID),QuotedStr(RoomNumber),BedNumber]);
    ADOQuery.SQL.Text := strSQL ;
    if ADOQuery.ExecSQL >= 0 then
       Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomInfo.ClearAllRoom;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update tab_base_room set strTrainmanGUID = ''''  ';
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomInfo.ClearRoom(RoomNumber: string);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update tab_base_room set strTrainmanGUID = ''''  where strRoomNumber = ' + QuotedStr(RoomNumber);
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.DeleteRoom(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    try
      strSQL := 'delete from  tab_base_room where strRoomNumber  = ' +QuotedStr(RoomNumber) ;
      ADOQuery.SQL.Text := strSQL ;
      ADOQuery.ExecSQL;
      Result := True ;
    except
      on e:Exception do
      begin
        Result := False ;
      end;
    end;
  finally
    ADOQuery.Free ;
  end;
end;

procedure TRsDBAccessRoomInfo.DelTrainmanFromRoom(TrainmanGUID: string);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_base_Room set strTrainmanGUID = ''''  where  strTrainmanGUID = %s ';
    strSQL := Format(strSQL,[QuotedStr(TrainmanGUID)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomInfo.GetAllRoom(var RoomInfoList: TRsRoomInfoArray);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  i:Integer ;
  strNumber:string;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection ;
    ADOQuery.ParamCheck := False ;
    strSQL := 'SELECT DISTINCT strRoomNumber from tab_base_room ' +
    ' order by strRoomNumber';

    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount <= 0 then
      Exit ;

    SetLength(RoomInfoList,ADOQuery.RecordCount )   ;
    i := 0 ;
    while not ADOQuery.eof do
    begin
      strNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
      RoomInfoList[i].strRoomNumber := strNumber ;
      ADOQuery.Next;
      Inc(i);
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.GetAllTrainmanRoomRelation(RoomNumber: string;
  var BedInfoArray: TRsBedInfoArray): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
  i :Integer ;
  BedInfo:RRsBedInfo ;
begin
  i := 0 ;
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select *  from Tab_RoomTrainman_Relation where strRoomNumber = %s ';
    strSQL :=  Format(strSQL,[QuotedStr(RoomNumber)]);
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.IsEmpty then
      Exit ;
    SetLength(BedInfoArray,ADOQuery.RecordCount);
    while not ADOQuery.Eof do
    begin
      BedInfo.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').asstring ;
      BedInfo.strTrainmanName := ADOQuery.FieldByName('strTrainmanName').asstring ;
      BedInfo.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').asstring ;
      BedInfo.nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger ;
      BedInfoArray[i] := BedInfo ;
      ADOQuery.Next ;
      Inc(i);
    end;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.GetEmptyBedNumber(RoomNumber: string): Integer;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := 0 ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select nBedNumber  from TAB_base_Room where strRoomNumber = %s and (strTrainmanGUID = '''' or strTrainmanGUID is null )';
    strSQL :=  Format(strSQL,[QuotedStr(RoomNumber)]);
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      Result := ADOQuery.FieldByName('nBedNumber').AsInteger ;
      Exit;
    end;
  finally
    ADOQuery.Free;
  end;
end;

{
procedure TRsDBAccessRoomInfo.GetEnterRoomList(
  var RoomInfoList: TRsRoomInfoArray);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  i:Integer ;
  j : Integer ;
  strNumber:string;
  strTemp:string;
  nLen :Integer ;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection ;
    ADOQuery.ParamCheck := False ;
//    strSQL := 'select * from tab_base_room order by strRoomNumber,nBedNumber';
    strSQL := 'select tab_base_room.*,TAB_Org_Trainman.strTrainmanName, '+
    ' TAB_Org_Trainman.strTrainmanNumber from tab_base_room '+
    ' LEFT JOIN TAB_Org_Trainman ON TAB_Org_Trainman.strTrainmanGUID = Tab_Base_Room.strTrainmanGUID ' +
    ' order by strRoomNumber,nBedNumber';

    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount <= 0 then
      Exit ;

    i := 0 ;
    j := 0 ;
    while not ADOQuery.eof do
    begin
      strNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
      if strNumber <> strTemp then
      begin
        SetLength(RoomInfoList,Length(RoomInfoList) + 1 )   ;
        j := 0 ;
      end ;

      nLen := Length(RoomInfoList) ;
      AdoToData(ADOQuery,RoomInfoList[ nLen -1],j);
      ADOQuery.Next;
      Inc(j);
      strTemp := strNumber ;
    end;
  finally
    ADOQuery.Free;
  end;
end;
}

procedure TRsDBAccessRoomInfo.GetEnterRoomList(
  var RoomInfoList: TRsRoomInfoArray);
var
  ADOQuery: TADOQuery;
  ADOQueryTime: TADOQuery;
  strSQL: string;
  i:Integer ;
  j : Integer ;
  strNumber:string;
  strTemp:string;
  nLen :Integer ;
begin
  ADOQuery := TADOQuery.Create(nil);
  ADOQueryTime := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection ;
    ADOQuery.ParamCheck := False ;

    ADOQueryTime.Connection := m_ADOConnection ;
    ADOQueryTime.ParamCheck := False ;

//    strSQL := 'select * from tab_base_room order by strRoomNumber,nBedNumber';
    strSQL := 'select tab_base_room.*,TAB_Org_Trainman.strTrainmanName, '+
    ' TAB_Org_Trainman.strTrainmanNumber from tab_base_room '+
    ' LEFT JOIN TAB_Org_Trainman ON TAB_Org_Trainman.strTrainmanGUID = Tab_Base_Room.strTrainmanGUID ' +
    ' order by strRoomNumber,nBedNumber';

    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount <= 0 then
      Exit ;

    j := 0 ;
    while not ADOQuery.eof do
    begin
      strNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
      if strNumber <> strTemp then
      begin
        SetLength(RoomInfoList,Length(RoomInfoList) + 1 )   ;
        j := 0 ;
      end ;

      nLen := Length(RoomInfoList) ;
      AdoToData(ADOQuery,RoomInfoList[ nLen -1],j);

      {
      //��ȡ��Ԣʱ��
      strSQL := 'Select dtInRoomTime from TAB_Plan_InRoom where ' +
      ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
      ' and strTrainmanNumber = %s  order by dtInRoomTime desc';
      strSQL := Format(strSQL,[QuotedStr(ADOQuery.FieldByName('strTrainmanNumber').AsString)]);
      ADOQueryTime.SQL.Text := strSQL;
      ADOQueryTime.Open();
      if ADOQueryTime.RecordCount > 0 then
        RoomInfoList[ nLen -1].listBedInfo[j].dtInRoomTime :=  ADOQueryTime.FieldByName('dtInRoomTime').AsDateTime ;
      ADOQueryTime.Close ;
       }

      ADOQuery.Next;
      Inc(j);
      strTemp := strNumber ;
    end;
  finally
    ADOQueryTime.Free ;
    ADOQuery.Free;
  end;
end;


function TRsDBAccessRoomInfo.GetTrainmanRoomRelation(TrainmanGUID: string;
  var BedInfo: RRsBedInfo): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select *  from Tab_RoomTrainman_Relation where strTrainmanGUID = %s ';
    strSQL :=  Format(strSQL,[QuotedStr(TrainmanGUID)]);
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.IsEmpty then
      Exit ;
    with BedInfo do
    begin
      strRoomNumber := ADOQuery.FieldByName('strRoomNumber').asstring ;
      nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger ;
    end;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

{��֧�ֶ������}
function TRsDBAccessRoomInfo.InsertRoom(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL1: string;
  strSQL2: string;
  strSQL3: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    try
      //������λ1
      strSQL1 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)  ',[QuotedStr(RoomNumber),1]);
      ADOQuery.SQL.Text := strSQL1;
      if ADOQuery.ExecSQL >= 0 then
        Result := True ;
      //������λ2
      strSQL2 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)  ',[QuotedStr(RoomNumber),2]);
      ADOQuery.SQL.Text := strSQL2;
      if ADOQuery.ExecSQL >= 0 then
        Result := True ;
      //������λ3
      strSQL3 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)  ',[QuotedStr(RoomNumber),3]);
      ADOQuery.SQL.Text := strSQL3;
      if ADOQuery.ExecSQL >= 0 then
        Result := True ;

    except
      on e:Exception do
      begin
        Result := False ;
      end;
    end;
  finally
    ADOQuery.Free ;
  end;
end;

function TRsDBAccessRoomInfo.InsertTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    //������λ1
    strSQL := Format('Insert into  Tab_RoomTrainman_Relation  ' +
    '( strRoomNumber , strTrainmanGUID  ,strTrainmanNumber,strTrainmanName,nBedNumber )  '+
      ' values (%s,%s,%s,%s,%d)  ',[QuotedStr(RoomNumber),QuotedStr(BedInfo.strTrainmanGUID),
        QuotedStr(BedInfo.strTrainmanNumber),QuotedStr(BedInfo.strTrainmanName),BedInfo.nBedNumber]);
    ADOQuery.SQL.Text := strSQL;
    if ADOQuery.ExecSQL >= 0 then
      Result := True ;
  finally
    ADOQuery.Free ;
  end;
end;

function TRsDBAccessRoomInfo.IsExistTrainman(TrainmanGUID,
  RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select strRoomNumber from tab_base_room where strRoomNumber = %d and strTrainmanGUID  =%s',[RoomNumber,TrainmanGUID]) ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      Result := True ;
      Exit ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.IsHaveTrainmanRoomRelation(
  TrainmanGUID: string;out RoomNumber:string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select strRoomNumber  from Tab_RoomTrainman_Relation where  strTrainmanGUID = %s ';
    strSQL :=  Format(strSQL,[QuotedStr(TrainmanGUID)]);

    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      RoomNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
      Result := True ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.IsRoomEmpty(RoomNumber: string): Boolean;
const
  ROOM_IS_FULL = 3 ;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select strRoomNumber from tab_base_room where strRoomNumber = %s and strTrainmanGUID = '''' ',[QuotedStr(RoomNumber)]) ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount = ROOM_IS_FULL then
      Result := True  ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.IsRoomExist(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select strRoomNumber from tab_base_room where strRoomNumber = '  + QuotedStr(RoomNumber)  ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.IsRoomFull(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := True ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select strRoomNumber from tab_base_room where strRoomNumber = %s and (strTrainmanGUID = '''' or strTrainmanGUID is null ) ',[QuotedStr(RoomNumber)]) ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := False ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.ModifyTrainmanRoomRelation(RoomNumber: string;
  BedInfoOld, BedInfoNew: RRsBedInfo): Boolean;
begin
  Result := False ;
end;

function TRsDBAccessRoomInfo.QueryTrainmanRoomRelation(TrainmanNumber,
  TrainmanName: string; var RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select strRoomNumber  from Tab_RoomTrainman_Relation where 1 = 1 ';
    if Trim(TrainmanNumber) <> '' then
    begin
      strSQL := strSQL + 'and strTrainmanNumber =  ' + QuotedStr(TrainmanNumber) ;
    end;

    if Trim(TrainmanName) <> '' then
    begin
      strSQL := strSQL + 'and strTrainmanName =  ' + QuotedStr(TrainmanName) ;
    end;
    

    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open;
    if ADOQuery.IsEmpty then
      Exit ;
    RoomNumber := ADOQuery.FieldByName('strRoomNumber').asstring ;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.RemoveTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from Tab_RoomTrainman_Relation where strRoomNumber = %s and strTrainmanGUID = %s ';
    strSQL := Format(strSQL,[QuotedStr(RoomNumber),QuotedStr(BedInfo.strTrainmanGUID)]) ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomInfo.SaveTrainmanRoomRelation(TrainmanGUID: string;
  var BedInfo: RRsBedInfo): Boolean;
var
  strRoomNumber: string;
begin
  Result := False ;
  if IsHaveTrainmanRoomRelation(TrainmanGUID,strRoomNumber)   then
    Result := True 
  else
    Result := InsertTrainmanRoomRelation(BedInfo.strRoomNumber,BedInfo) ;
end;

{ TRsAccessDBLeaderInspect }

function TRsAccessDBLeaderInspect.AddLeaderInspect(
  LeaderInspect: RRsLeaderInspect): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from  TAB_Exam_Information where 1 = 2 ' ;
      Open;
      Append;
      DataToAdo(ado,LeaderInspect);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsAccessDBLeaderInspect.DelOldInpect(EndDate: TDateTime);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    strSQL := Format('delete * from  TAB_Exam_Information where dtCreateTime < ''%s''  or nDelFlag = 1 ',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate)])  ;
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsAccessDBLeaderInspect.GetLeaderInspectList(BeginDate,
  EndDate: TDateTime; var LeaderInspectList: TRsLeaderInspectList);
var
  ado : TADOQuery;
  i:Integer ;
  strText:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      ParamCheck := False ;
      strText := Format('select a.*,b.strTrainmanNumber,b.strTrainmanName from TAB_Exam_Information a ' +
       ' LEFT OUTER JOIN TAB_Org_Trainman  b on a.strLeaderGUID = b.strGUID ' +
       ' where a.dtCreateTime >= ''%s'' and a.dtCreateTime <= ''%s'' order by a.dtCreateTime',[
      FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginDate),
      FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate)]);
      Sql.Text := strText;
      Open;
      if RecordCount <= 0 then
        Exit;
      i := 0 ;
      SetLength(LeaderInspectList,RecordCount);
      while not eof do
      begin
        AdoToData(ado,LeaderInspectList[i]);
        Next;Inc(i);
      end;
    end;
  finally
    ado.Free;
  end;
end;

{ TRsDBAccessRoomSign }

procedure TRsDBAccessRoomSign.DelOldInOutRecord(EndTime: TDateTime);
begin
  DelOldInRecord(EndTime);
  DelOldOutRecord(EndTime);
end;

procedure TRsDBAccessRoomSign.DelOldInRecord(EndTime: TDateTime);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('delete * from  TAB_Plan_InRoom where  dtInRoomTime < #%s#  or nDelFlag = 1',
    [FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime)])  ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomSign.DelOldOutRecord(EndTime: TDateTime);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('delete * from  TAB_Plan_OutRoom where  dtOutRoomTime < #%s#  or nDelFlag = 1',
    [FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime)])  ;
    ADOQuery.ParamCheck := False ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.DelSignInOutRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
  DelSignInRecord(RoomGUID);
  DelSignOutRecord(RoomGUID);
end;

function TRsDBAccessRoomSign.DelSignInRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from  TAB_Plan_InRoom where  strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[
      QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.DelSignOutRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from  TAB_Plan_OutRoom where  strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[
      QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.GetLastInGUID(const TrainNumber: string): string;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    //����Ƿ�����Ԣ��¼
    strSQL := 'Select strInRoomGUID from TAB_Plan_InRoom where '+
    ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
    ' and strTrainmanNumber = %s  order by dtInRoomTime desc';
    strSQL := Format(strSQL,[QuotedStr(TrainNumber)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    if ADOQuery.RecordCount > 0 then
    begin
      Result :=  ADOQuery.FieldByName('strInRoomGUID').asstring ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomSign.GetSignInRecordByID(RoomGUID: string;
  var RoomSign: TRsRoomSign);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    //����Ƿ�����Ԣ��¼
    strSQL := 'Select * from TAB_Plan_InRoom where strInRoomGUID = %s ';
    strSQL := Format(strSQL,[QuotedStr(RoomGUID)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    if ADOQuery.RecordCount > 0 then
    begin
      with ADOQuery do
      begin
        RoomSign.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString ;
         RoomSign.dtInRoomTime := FieldByName('dtInRoomTime').AsDateTime ;
         RoomSign.nInRoomVerifyID := FieldByName('nInRoomVerifyID').AsInteger ;
         RoomSign.strDutyUserGUID := FieldByName('strDutyUserGUID').AsString;
         RoomSign.strSiteGUID := FieldByName('strSiteGUID').AsString ;
         RoomSign.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;

         RoomSign.strRoomNumber := FieldByName('strRoomNumber').AsString ;
         RoomSign.nBedNumber := FieldByName('nBedNumber').AsInteger;
      end;

    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.GetSignInTime(const TrainNumber: string;
  var DateTime: TDateTime): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    //����Ƿ�����Ԣ��¼
    strSQL := 'Select * from TAB_Plan_InRoom where ' +
    ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
    ' and strTrainmanNumber = %s  order by dtInRoomTime desc';
    strSQL := Format(strSQL,[QuotedStr(TrainNumber)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    if ADOQuery.RecordCount > 0 then
    begin
      DateTime :=  ADOQuery.FieldByName('dtInRoomTime').AsDateTime ;
      Result := True ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomSign.InsertSignIn(const RoomSign: TRsRoomSign);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from TAB_Plan_InRoom where 1 = 2 ';
    ADOQuery.SQL.Text := strSQL ;
    with ADOQuery do
    begin
      Open();
      Append();
      SingInToAdo(ADOQuery,RoomSign);
      Post();
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomSign.InsertSignOut(const RoomSign: TRsRoomSign);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from TAB_Plan_OutRoom where 1 = 2 ';
    ADOQuery.SQL.Text := strSQL ;
    with ADOQuery do
    begin
      Open();
      Append();
      SignOutToAdo(ADOQuery,RoomSign);
      Post();
    end;

  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.IsExistSignInRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'Select strInRoomGUID from TAB_Plan_InRoom where strInRoomGUID = %s ';
    strSQL := Format(strSQL,[ QuotedStr(RoomGUID) ]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    if not ADOQuery.IsEmpty then
    begin
      Result := False ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.IsExistSignOutRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'Select strInRoomGUID from TAB_Plan_OutRoom where strInRoomGUID = %s ';
    strSQL := Format(strSQL,[ QuotedStr(RoomGUID) ]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    if not ADOQuery.IsEmpty then
    begin
      Result := False ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.IsSignIn(Date: TDateTime;
  const TrainNumber: string; var GUID: string;
  var DateTime: TDateTime): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
  dtBegin:TDateTime ;
  dtEnd:TDateTime ;
begin
  Result := True ;
  dtEnd :=  Date ;
  dtBegin := Date - 7 ;

  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    //������7�����Ƿ�������Ԣ��¼
    strSQL := 'Select strInRoomGUID,dtInRoomTime from TAB_Plan_InRoom where ' +
    ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
    ' and strTrainmanNumber = %s and ( dtInRoomTime >= #%s# and  dtInRoomTime <= #%s# ) order by dtInRoomTime desc ';
    strSQL := Format(strSQL,[
    QuotedStr(TrainNumber),FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin),FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    //�������Ԣ��¼���ʾҪ��Ԣ
    if not ADOQuery.IsEmpty then
    begin
      Result := false   ;
      DateTime :=  ADOQuery.FieldByName('dtInRoomTime').AsDateTime ;
      GUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
    end
    else
    begin
      Result := true ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBAccessRoomSign.QuerySignList(RoomNumber, TrainmanNumber,
  TrainmanName: string; dtBegin, dtEnd: TDateTime; strSiteGUID: string;
  var RoomSignList: TRsRoomSignList; IsShowUnnormal: Boolean);
label
  lbError;
var
  ADOQuery: TADOQuery;
  strSQL: string;
  I: Integer;
  roomSign : TRsRoomSign ;
  nMinute:Integer;
  dtDiff:TDateTime;
begin
  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    strSQL := 'Select TAB_Plan_InRoom.*,TAB_Plan_OutRoom.dtOutRoomTime,TAB_Plan_OutRoom.strOutRoomGUID,TAB_Plan_OutRoom.nOutRoomVerifyID, '   +
      'TAB_Org_Trainman.strTrainmanName ' +
      'from ( TAB_Plan_InRoom Left Join TAB_Plan_OutRoom on TAB_Plan_OutRoom.strInRoomGUID = TAB_Plan_InRoom.strInRoomGUID ) Left Join TAB_Org_Trainman On ( TAB_Plan_InRoom.strTrainmanGUID = TAB_Org_Trainman.strTrainmanGUID ) ' +
      'where ( dtInRoomTime >= #%s# and  dtInRoomTime <= #%s# )   ';
    strSQL := Format(strSQL,[
      FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin),
      FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)]);

    if Trim(RoomNumber) <> '' then
    begin
      strSQL := strSQL + ' and  TAB_Plan_InRoom.strRoomNumber like '  + QuotedStr(RoomNumber+ '%') ;
    end;

    if Trim(TrainmanNumber) <> '' then
    begin
      strSQL := strSQL + ' and TAB_Plan_InRoom.strTrainmanNumber like '  + QuotedStr(TrainmanNumber+ '%') ;
    end;

    if Trim(TrainmanName) <> '' then
    begin
      strSQL := strSQL + ' and TAB_Org_Trainman.strTrainmanName like  '  + QuotedStr(TrainmanName+ '%') ;
    end;

    strSQL := strSQL + ' order by dtInRoomTime Desc,strRoomNumber desc ';
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open();

    for I := 0 to ADOQuery.RecordCount - 1 do
    begin

      roomSign := TRsRoomSign.Create;
      roomSign.strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
      roomSign.strOutRoomGUID := ADOQuery.FieldByName('strOutRoomGUID').AsString;
      roomSign.strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
      roomSign.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
      roomSign.strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
      roomSign.strSiteGUID := ADOQuery.FieldByName('strSiteGUID').AsString;
      roomSign.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
      roomSign.strTrainmanName := ADOQuery.FieldByName('strTrainmanName').AsString;
      roomSign.dtInRoomTime := ADOQuery.FieldByName('dtInRoomTime').AsDateTime;
      roomSign.dtOutRoomTime := ADOQuery.FieldByName('dtOutRoomTime').AsDateTime;
      roomSign.nInRoomVerifyID := ADOQuery.FieldByName('nInRoomVerifyID').AsInteger;
      roomSign.nOutRoomVerifyID := ADOQuery.FieldByName('nOutRoomVerifyID').AsInteger;

      {$REGION '�Ƿ���ʾС��260���ӵ���ǰ��Ԣ'}
      if not IsShowUnnormal then
      begin
        //���� �ֹ���Ԣ��ʱ��С��4Сʱ
        if ( roomSign.nOutRoomVerifyID  = 0 ) and ( roomSign.dtOutRoomTime <> 0) then
        begin
          dtDiff := roomSign.dtOutRoomTime - roomSign.dtInRoomTime ;
          nMinute := Round ( dtDiff * 24 * 60 ) ;//������
          if   nMinute <= 260   then
          begin
            goto lbError ;
          end;
        end;
      end;
      {$ENDREGION}


      roomSign.strRoomNumber :=  ADOQuery.FieldByName('strRoomNumber').AsString;
      roomSign.nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger;
      RoomSignList.Add(roomSign);
lbError:
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free ;
  end;
end;

procedure TRsDBAccessRoomSign.QuerySignListLessThanTime(RoomNumber,
  TrainmanNumber, TrainmanName: string; dtBegin, dtEnd, dtNow: TDateTime;
  strSiteGUID: string; var RoomSignList: TRsRoomSignList);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  I: Integer;
  roomSign : TRsRoomSign ;
  InRoomTime : TDateTime ;
  dtDiff:TDateTime ;
  nMinute:Integer ;
begin
  ADOQuery := NewADOQuery;
  ADOQuery.ParamCheck := False ;
  try
    strSQL := 'Select TAB_Plan_InRoom.*, TAB_Org_Trainman.strTrainmanName ' +
      'from ( TAB_Plan_InRoom  Left Join TAB_Org_Trainman On TAB_Plan_InRoom.strTrainmanGUID = TAB_Org_Trainman.strTrainmanGUID )' +
      'where TAB_Plan_InRoom.strInRoomGUID NOT in (SELECT strInRoomGUID from TAB_Plan_OutRoom WHERE strInRoomGUID is NOT NULL) ' +
       ' and ( dtInRoomTime >= ''%s'' and  dtInRoomTime <= ''%s'' )   ';
    strSQL := Format(strSQL,[
      FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin),
      FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)]);

    if Trim(RoomNumber) <> '' then
    begin
      strSQL := strSQL + ' and  TAB_Plan_InRoom.strRoomNumber like '  + QuotedStr(RoomNumber+ '%') ;
    end;

    if Trim(TrainmanNumber) <> '' then
    begin
      strSQL := strSQL + ' and TAB_Plan_InRoom.strTrainmanNumber like '  + QuotedStr(TrainmanNumber+ '%') ;
    end;

    if Trim(TrainmanName) <> '' then
    begin
      strSQL := strSQL + ' and TAB_Org_Trainman.strTrainmanName like  '  + QuotedStr(TrainmanName+ '%') ;
    end;

    strSQL := strSQL + ' order by strRoomNumber  ';

    ADOQuery.SQL.Text := strSQL ;

    ADOQuery.Open();


    for I := 0 to ADOQuery.RecordCount - 1 do
    begin

      InRoomTime := ADOQuery.FieldByName('dtInRoomTime').AsDateTime;
      dtDiff := dtNow - InRoomTime ;
      nMinute :=Round ( dtDiff * 24 * 60 ) ;//������
      if   nMinute > 260   then
      begin
        Continue ;
      end;
      

      roomSign := TRsRoomSign.Create;
      roomSign.strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
      roomSign.strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
      roomSign.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
      roomSign.strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
      roomSign.strDutyUserName :=  '' ;
      roomSign.strSiteGUID := ADOQuery.FieldByName('strSiteGUID').AsString;
      roomSign.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
      roomSign.strTrainmanName := ADOQuery.FieldByName('strTrainmanName').AsString;
      roomSign.dtInRoomTime := ADOQuery.FieldByName('dtInRoomTime').AsDateTime;
      roomSign.nInRoomVerifyID := ADOQuery.FieldByName('nInRoomVerifyID').AsInteger;
      roomSign.strRoomNumber :=  ADOQuery.FieldByName('strRoomNumber').AsString;
      roomSign.nBedNumber := ADOQuery.FieldByName('nBedNumber').AsInteger;
      RoomSignList.Add(roomSign);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free ;
  end;
end;

function TRsDBAccessRoomSign.UpdateSignInRoomNumber(RoomGUID,
  RoomNumber: string; BedNumber: Integer): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_Plan_InRoom set strRoomNumber = %s, nBedNumber = %d  where strInRoomGUID = %s ';
    ADOQuery.SQL.Text := Format(strSQL,[
    QuotedStr(RoomNumber),BedNumber,QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.UpdateSignInTime(RoomGUID: string;
  Date: TDateTime): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_Plan_InRoom set dtInRoomTime = %s where strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Date)),
      QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBAccessRoomSign.UpdateSignOutTime(RoomGUID: string;
  Date: TDateTime): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_Plan_InRoom set dtInRoomTime = %s where strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Date)),
      QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

{ TRsDBAccessTrainman }

procedure TRsDBAccessTrainman.DataToADOQuery(Trainman: RRsTrainman;
  ADOQuery: TADOQuery; NeedPicture: boolean);
var
  StreamObject : TMemoryStream;
begin
  //ADOQuery.FieldByName('nID').AsInteger := Trainman.nID ;
  adoQuery.FieldByName('strGUID').AsString := Trainman.strTrainmanGUID;
  adoQuery.FieldByName('strTrainmanNumber').AsString := Trainman.strTrainmanNumber;
  adoQuery.FieldByName('strTrainmanName').AsString := Trainman.strTrainmanName;
  {
  adoQuery.FieldByName('nPostID').asInteger := Ord(Trainman.nPostID);
  adoQuery.FieldByName('strWorkShopGUID').AsString := Trainman.strWorkShopGUID;
  adoQuery.FieldByName('strGuideGroupGUID').AsString := Trainman.strGuideGroupGUID;
  adoQuery.FieldByName('strTelNumber').AsString := Trainman.strTelNumber;
  adoQuery.FieldByName('strMobileNumber').AsString := Trainman.strMobileNumber;
  adoQuery.FieldByName('strAddress').AsString := Trainman.strAdddress;
  adoQuery.FieldByName('nDriverType').asInteger := Ord(Trainman.nDriverType);
  adoQuery.FieldByName('bIsKey').AsInteger := Trainman.bIsKey;
  adoQuery.FieldByName('dtRuZhiTime').AsDateTime := Trainman.dtRuZhiTime;
  adoQuery.FieldByName('dtJiuZhiTime').AsDateTime := Trainman.dtJiuZhiTime;
  adoQuery.FieldByName('nDriverLevel').AsInteger := Trainman.nDriverLevel;
  adoQuery.FieldByName('strABCD').AsString := Trainman.strABCD;
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('nKeHuoID').AsInteger := Ord(Trainman.nKeHuoID);
  adoQuery.FieldByName('strRemark').AsString := Trainman.strRemark;
  adoQuery.FieldByName('strTrainJiaoluGUID').AsString := Trainman.strTrainJiaoluGUID;
  ADOQuery.FieldByName('strTrainmanJiaoluGUID').AsString :=  Trainman.strTrainmanJiaoluGUID;
  adoQuery.FieldByName('dtLastEndworkTime').AsDateTime := Trainman.dtLastEndworkTime;

  adoQuery.FieldByName('dtCreateTime').AsDateTime := Trainman.dtCreateTime;
  adoQuery.FieldByName('nTrainmanState').asInteger := Ord(Trainman.nTrainmanState);
  adoQuery.FieldByName('strJP').AsString := Trainman.strJP;
  }
  StreamObject := TMemoryStream.Create;
  try
    {��ȡָ��1}
    if not (VarIsNull(Trainman.FingerPrint1)  or VarIsEmpty(Trainman.FingerPrint1)) then
    begin
      TemplateOleVariantToStream(Trainman.FingerPrint1,StreamObject);
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).LoadFromStream(StreamObject);
      StreamObject.Clear;
    end;

    {��ȡָ��2}
    if not (VarIsNull(Trainman.FingerPrint2)  or VarIsEmpty(Trainman.FingerPrint2)) then
      begin
      TemplateOleVariantToStream(Trainman.FingerPrint2,StreamObject);
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).LoadFromStream(StreamObject);

      StreamObject.Clear;
    end;
  finally
    StreamObject.Free;
  end;
end;

procedure TRsDBAccessTrainman.DeleteTrainman(TrainmanGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'delete from tab_org_trainman where strTrainmanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainmanGUID)]);
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBAccessTrainman.ExistNumber(TrainmanGUID,
  TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select count(*) From tab_Org_Trainman Where strTrainmanNumber = %s and strTrainmanGUID <> %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.ParamCheck := False ;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBAccessTrainman.ExistTrainmanByNumber( TrainmanNumber: string): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select count(*) From tab_Org_Trainman Where strTrainmanNumber = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.ParamCheck := False ;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    Result := adoQuery.Fields[0].AsInteger > 0; 
  finally
    adoQuery.Free;
  end;
end;

function TRsDBAccessTrainman.GetTrainmanSignature(): string;
var
  query:TADOQuery;
begin
  result := '';
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'TrainmanInfo';
    query.Open;
    if query.RecordCount = 0 then Exit;
    result := query.FieldByName('strSignature').Value ;
  finally
    query.Free;
  end;
end;

function  TRsDBAccessTrainman.GetFingerSignature():string;
var
  query:TADOQuery;
begin
  result := '';
  query := NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'FingerInfo';
    query.Open;
    if query.RecordCount = 0 then Exit;
    result := query.FieldByName('strSignature').Value ;
  finally
    query.Free;
  end;
end;

function TRsDBAccessTrainman.GetTrainman(TrainmanGUID: string;
  out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where strGUID = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.ParamCheck := False ;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBAccessTrainman.GetTrainmanByID(ADOConn: TADOConnection;
  ID: integer; out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where nTrainmanID = %d';
  strSql := Format(strSql, [ID]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := ADOConn;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBAccessTrainman.GetTrainmanByNumber(TrainmanNumber: string;
  out Trainman: RRsTrainman): boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'Select Top 1 * From tab_Org_Trainman Where strTrainmanNumber = %s';
  strSql := Format(strSql, [QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      ADOQueryToData(Trainman,adoQuery,true);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;



function TRsDBAccessTrainman.GetTrainmanMaxID(out ID: Integer): Boolean;
var
  strSql : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSql := 'SELECT max(nid) as maxid From tab_Org_Trainman ';
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      if adoQuery.FieldByName('maxid').AsString = '' then
        ID := 1
      else
        ID := adoQuery.FieldByName('maxid').AsInteger + 1;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBAccessTrainman.GetTrainmansBrief(ADOConn: TADOConnection;
  out TrainmanArray: TRsTrainmanArray);
var
  i : integer;
  strSql : String;
  adoQuery : TADOQuery;
  StreamObject: TMemoryStream;
begin
  strSql := 'Select strGUID,strTrainmanNumber,strTrainmanName,'
    + 'nTrainmanID,FingerPrint1,FingerPrint2 '
    + 'From TAB_Org_Trainman order by nTrainmanID';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      ParamCheck := False ;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainmanArray[i].strTrainmanGUID := adoQuery.FieldByName('strGUID').AsString;
        TrainmanArray[i].strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
        TrainmanArray[i].strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
        //TrainmanArray[i].strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
        //TrainmanArray[i].strTelNumber := adoQuery.FieldByName('strTelNumber').AsString;
        TrainmanArray[i].nID := adoQuery.FieldByName('nTrainmanID').asInteger;

        //TrainmanArray[i].strJP := adoQuery.FieldByName('strJP').AsString;
        StreamObject := TMemoryStream.Create;
        try
          {��ȡָ��1}
          if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
          begin
            (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
            TrainmanArray[i].FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
            StreamObject.Clear;
          end;

          {��ȡָ��2}
          if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
          begin
            (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
            TrainmanArray[i].FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
            StreamObject.Clear;
          end;
        finally
          StreamObject.Free;
        end;

        
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBAccessTrainman.QueryTrainmans(QueryTrainman: RRsQueryTrainman;
  out TrainmanArray: TRsTrainmanArray);
{����:����ID��ȡ����Ա��Ϣ}
var
  i : integer;
  strSql,sqlCondition : String;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * From tab_Org_Trainman %s order by strTrainmanNumber ';

  {$region '��ϲ�ѯ����'}
  sqlCondition :=  ' where 1=1 ';
  with QueryTrainman do
  begin
    if strTrainmanNumber <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanNumber = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainmanNumber)])
    end;

    {
    if (strWorkShopGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strWorkShopGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strWorkShopGUID)])
    end;
    if (strGuideGroupGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strGuideGroupGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strGuideGroupGUID)]);
    end;
    if (strTrainJiaoluGUID <> '') then
    begin
      sqlCondition := sqlCondition + ' and strTrainJiaoluGUID = %s';
      sqlCondition := Format(sqlCondition,[QuotedStr(strTrainJiaoluGUID)]);    
    end;
    }
    if strTrainmanName <> '' then
    begin
      sqlCondition := sqlCondition + ' and strTrainmanName like %s';
      sqlCondition := Format(sqlCondition,[QuotedStr('%'+strTrainmanName+'%')])    
    end;
    if (nFingerCount >= 0) then
    begin
      if nFingerCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and ((FingerPrint1 is null) and (FingerPrint2 is null))';
      end;
      if nFingerCount = 1 then
      begin
        sqlCondition := sqlCondition + ' and (((FingerPrint1 is null) and not (FingerPrint2 is null)) or  ((FingerPrint2 is null) and not (FingerPrint1 is null)))';
      end;
      if nFingerCount = 2 then
      begin
        sqlCondition := sqlCondition + ' and (not(FingerPrint1 is null) and not(FingerPrint2 is null)) ';
      end;
    end;
    if (nPhotoCount >= 0) then
    begin
      if nPhotoCount = 0 then
      begin
        sqlCondition := sqlCondition + ' and (nPostID is null)';
      end;
      if nPhotoCount > 0 then
      begin
        sqlCondition := sqlCondition + ' and not (nPostID is null)';
      end;
    end;
  end;
  {$endregion '��ϲ�ѯ����'}
  strSql := Format(strSql,[sqlCondition]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(TrainmanArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToData(TrainmanArray[i],adoQuery);
        inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBAccessTrainman.SetTrainmanSignature(strSignature: string);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'TrainmanInfo';
    query.Open;
    if query.RecordCount = 0 then
    begin
      query.Append;
    end
    else
    begin
      query.Edit;
    end;
    query.FieldByName('strName').Value := 'TrainmanInfo';
    query.FieldByName('strSignature').Value := strSignature;
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TRsDBAccessTrainman.SetFingerSignature(strSignature:string);
var
  query:TADOQuery;
begin
  query:= NewADOQuery;
  try
    query.SQL.Text := 'select * from tab_Signature where strName =:strName';
    query.Parameters.ParamByName('strName').Value := 'FingerInfo';
    query.Open;
    if query.RecordCount = 0 then
    begin
      query.Append;
    end
    else
    begin
      query.Edit;
    end;
    query.FieldByName('strName').Value := 'FingerInfo';
    query.FieldByName('strSignature').Value := strSignature;
    query.Post;
  finally
    query.Free;
  end;
end;

procedure TRsDBAccessTrainman.SyncTrainman(trainman:RRsTrainman);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Org_Trainman where  strTrainmanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(Trainman.strTrainmanGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then begin
        Append;
      end
      else
      begin
        Edit;
      end;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;
procedure TRsDBAccessTrainman.UpdateTrainman(Trainman: RRsTrainman);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Org_Trainman where  strTrainmanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(Trainman.strTrainmanGUID)]);
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then begin
        raise Exception.Create('δ�ҵ�ָ���ĳ���Ա��Ϣ');
      end;
      Edit;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBAccessTrainman.AddTrainman(Trainman: RRsTrainman);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Org_Trainman where  1=2 ';
      Connection := m_ADOConnection;
      ParamCheck := False ;
      Sql.Text := strSql;
      Open;
      Append;
      DataToADOQuery(Trainman,adoQuery,true);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBAccessTrainman.ADOQueryToData(var Trainman: RRsTrainman;
  ADOQuery: TADOQuery;NeedPicture : boolean = false);
var
  StreamObject : TMemoryStream;
begin
  Trainman.strTrainmanGUID := adoQuery.FieldByName('strGUID').AsString;
  Trainman.strTrainmanNumber := adoQuery.FieldByName('strTrainmanNumber').AsString;
  Trainman.strTrainmanName := adoQuery.FieldByName('strTrainmanName').AsString;
  {
  //Trainman.nPostID := TRsPost(adoQuery.FieldByName('nPostID').asInteger);

  Trainman.strWorkShopGUID := adoQuery.FieldByName('strWorkShopGUID').AsString;
//  Trainman.strWorkShopName := adoQuery.FieldByName('strWorkShopName').AsString;
  Trainman.strGuideGroupGUID := adoQuery.FieldByName('strGuideGroupGUID').AsString;
 // Trainman.strGuideGroupName := adoQuery.FieldByName('strGuideGroupName').AsString;
  Trainman.strTelNumber := adoQuery.FieldByName('strTelNumber').AsString;
  Trainman.strMobileNumber := adoQuery.FieldByName('strMobileNumber').AsString;
  Trainman.strAdddress := adoQuery.FieldByName('strAddress').AsString;
  Trainman.nDriverType := TRsDriverType(adoQuery.FieldByName('nDriverType').asInteger);
  Trainman.bIsKey := adoQuery.FieldByName('bIsKey').AsInteger;
  Trainman.dtRuZhiTime := adoQuery.FieldByName('dtRuZhiTime').AsDateTime;
  Trainman.dtJiuZhiTime := adoQuery.FieldByName('dtJiuZhiTime').AsDateTime;
  Trainman.nDriverLevel := adoQuery.FieldByName('nDriverLevel').AsInteger;
  Trainman.strABCD := adoQuery.FieldByName('strABCD').AsString;
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  if adoQuery.FieldByName('nKeHuoID').AsString = '' then
    Trainman.nKeHuoID := khNone
  else
    Trainman.nKeHuoID :=  TRsKehuo(adoQuery.FieldByName('nKeHuoID').AsInteger);
  Trainman.strRemark := adoQuery.FieldByName('strRemark').AsString;
  Trainman.strTrainJiaoluGUID := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
  Trainman.strTrainmanJiaoluGUID := adoQuery.FieldByName('strTrainmanJiaoluGUID').AsString;
//  Trainman.strTrainJiaoluName := adoQuery.FieldByName('strTrainJiaoluName').AsString;
  Trainman.dtLastEndworkTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;

  Trainman.dtCreateTime := adoQuery.FieldByName('dtLastEndworkTime').AsDateTime;
  Trainman.nTrainmanState := TRsTrainmanState(adoQuery.FieldByName('nTrainmanState').asInteger);
  trainman.nID := adoQuery.FieldByName('nID').asInteger;
  if ADOQuery.Fields.FindField('strJP') <> nil then
    trainman.strJP := adoQuery.FieldByName('strJP').AsString;
    }
  trainman.nID := adoQuery.FieldByName('nTrainmanID').asInteger;
  StreamObject := TMemoryStream.Create;
  try
    {��ȡָ��1}
    if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;

    {��ȡָ��2}
    if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;
  finally
    StreamObject.Free;
  end;
end;


end.
