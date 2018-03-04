unit uDBRoomSign;

interface
uses
  DateUtils,Classes,SysUtils,ADODB,uTFSystem,uRoomSign,uBaseDBRoomSign;
type

  //入寓离寓操作类
  TRsDBRoomSign = class(TRsBaseDBRoomSign)
  public
    procedure GetSignRecord(dtBegin,dtEnd: TDateTime;strWorkShopGUID: string;out RoomSignArray: TRsRoomSignArray);override;
    procedure UpdateSignTime(RoomSign: RRsRoomSign);override;
  //add by lyq 2014-06-13

  public
    //根据入寓号获取信息
    procedure GetSignInRecordByID(RoomGUID:string;var RoomSign:TRsRoomSign); override;
    //查询
    procedure QuerySignList(RoomNumber,TrainmanNumber,TrainmanName:string;dtBegin,dtEnd: TDateTime;strSiteGUID: string;var RoomSignList: TRsRoomSignList;IsShowUnnormal:Boolean); override;
    //
    procedure QuerySignListLessThanTime(RoomNumber,TrainmanNumber,TrainmanName:string;dtBegin,dtEnd,dtNow: TDateTime;strSiteGUID: string;var RoomSignList: TRsRoomSignList); override;
   //增加出寓
    procedure InsertSignIn(const RoomSign:TRsRoomSign); override;
    //增加离寓
    procedure InsertSignOut(const RoomSign:TRsRoomSign); override;
    //判断是否入寓,如果是入寓则获取信息
    function  IsSignIn(Date:TDateTime;const TrainNumber:string;var GUID: string;var DateTime:TDateTime):Boolean; override;
    //更新入寓时间
    function  UpdateSignInTime(RoomGUID:string;Date:TDateTime):Boolean;override;
    //更新入寓房间号
    function  UpdateSignInRoomNumber(RoomGUID,RoomNumber:string;BedNumber:Integer):Boolean; override;
    //更新离寓时间
    function  UpdateSignOutTime(RoomGUID:string;Date:TDateTime):Boolean; override;
    //删除入寓记录
    function  DelSignInRecord(RoomGUID:string):Boolean;  override;
    //删除离寓记录
    function  DelSignOutRecord(RoomGUID:string):Boolean; override;
    //删除 入寓管理的离寓的记录
    function  DelSignInOutRecord(RoomGUID:string):Boolean; override;
    //是否有入寓记录
    function  IsExistSignInRecord(RoomGUID:string):Boolean;  override;
    //是否有离寓记录
    function  IsExistSignOutRecord(RoomGUID:string):Boolean;  override;
    //得到最近入寓时间
    function  GetSignInTime(const TrainNumber:string;var DateTime:TDateTime):Boolean;  override;
    //得到最近的入寓的GUID
    function  GetLastInGUID(const TrainNumber:string):string;  override;

    //离线部分导入
   public
    //导入离寓信息
    procedure ImportSignOut(OutRoomInfo:TRsOutRoomInfo);
    //导入入寓信息
    procedure ImportSignIn(InRoomInfo:TRsInRoomInfo);

   private
    procedure SingInToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);
    procedure SignOutToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);

  end;

  //房间操作数据库类
  TRsDBRoomInfo = class(TRsBaseDBRoomInfo)
  public
    //获取现有的入驻情况
    procedure GetEnterRoomList(var RoomInfoList : TRsRoomInfoArray);override;
    //增加一个房间
    function  InsertRoom(RoomNumber:string):Boolean;override;
    //清空房间的入驻人员信息
    procedure ClearRoom(RoomNumber:string);override;
    //清空所有的房间信息
    procedure ClearAllRoom();override;
    //删除一个房间
    function  DeleteRoom(RoomNumber:string):Boolean;override;
    //检查房间是否存在
    function  IsRoomExist(RoomNumber:string):Boolean;override;
  public
    function IsRoomEmpty(RoomNumber:string):Boolean;override;
    //检查房间是否是满员
    function  IsRoomFull(RoomNumber:string):Boolean;override;
    //检查在房间否在XX
    function  IsExistTrainman(TrainmanGUID,RoomNumber:string):Boolean;override;
    //添加一个人到房间
    function  AddTrainmanToRoom(TrainmanGUID,RoomNumber:string;BedNumber:Integer):Boolean;override;
    //从房间删除一个人
    procedure  DelTrainmanFromRoom(TrainmanGUID,RoomNumber:string);overload;
    procedure  DelTrainmanFromRoom(TrainmanGUID:string);overload;override;
    //获取一个空的床位
    function   GetEmptyBedNumber(RoomNumber:string):Integer;override;

  private
    procedure AdoToData(AdoQuery:TADOQuery;var RoomInfo:RRsRoomInfo;Index:Integer);
  end;

implementation

{ TRsDBRoomSign }

function TRsDBRoomSign.DelSignInOutRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
  DelSignInRecord(RoomGUID);
  DelSignOutRecord(RoomGUID);
end;

function TRsDBRoomSign.DelSignInRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from  TAB_Plan_InRoom where  strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomSign.DelSignOutRecord(RoomGUID: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'delete from  TAB_Plan_OutRoom where  strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(RoomGUID)]);
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomSign.GetLastInGUID(const TrainNumber: string):string;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    //检查是否有入寓记录
    strSQL := 'Select * from TAB_Plan_InRoom where '+
    ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
    ' and strTrainmanNumber = %s  order by dtInRoomTime desc';
    strSQL := Format(strSQL,[
    QuotedStr(TrainNumber)]);
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



procedure TRsDBRoomSign.GetSignInRecordByID(RoomGUID: string;
  var RoomSign: TRsRoomSign);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    //检查是否有入寓记录
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

function TRsDBRoomSign.GetSignInTime(const TrainNumber: string;
  var DateTime: TDateTime): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    //检查是否有入寓记录
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

procedure TRsDBRoomSign.GetSignRecord(dtBegin, dtEnd: TDateTime;strWorkShopGUID: string;
  out RoomSignArray: TRsRoomSignArray);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  I: Integer;

begin
  ADOQuery := NewADOQuery;
  try

    strSQL := 'Select TAB_Plan_InRoom.*,TAB_Org_Trainman.strTrainmanName,TAB_Org_Trainman.strWorkShopGUID ' +
    'from TAB_Plan_InRoom Left Join TAB_Org_Trainman On TAB_Plan_InRoom.strTrainmanGUID = TAB_Org_Trainman.strTrainmanGUID ' +
    'where dtInRoomTime >= %s and dtInRoomTime <= %s and strWorkShopGUID = %s order by dtInRoomTime Desc';
        ADOQuery.SQL.Text := Format(strSQL,[
    QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin)),
    QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)),
    QuotedStr(strWorkShopGUID)]);
    ADOQuery.Open();

    SetLength(RoomSignArray,ADOQuery.RecordCount);

    for I := 0 to ADOQuery.RecordCount - 1 do
    begin
      RoomSignArray[i].strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
      RoomSignArray[i].strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
      RoomSignArray[i].strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
      RoomSignArray[i].strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
      RoomSignArray[i].strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
      RoomSignArray[i].strTrainmanName := ADOQuery.FieldByName('strTrainmanName').AsString;
      RoomSignArray[i].dtInRoomTime := ADOQuery.FieldByName('dtInRoomTime').AsDateTime;
      RoomSignArray[i].SignType := stInRoom;
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBRoomSign.ImportSignIn(InRoomInfo: TRsInRoomInfo);
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
        FieldByName('strInRoomGUID').AsString := InRoomInfo.strInRoomGUID;
        FieldByName('strTrainPlanGUID').AsString := InRoomInfo.strTrainPlanGUID;
        FieldByName('strTrainmanGUID').AsString := InRoomInfo.strTrainmanGUID;
        FieldByName('dtInRoomTime').AsDateTime := InRoomInfo.dtInRoomTime;
        FieldByName('nInRoomVerifyID').AsInteger := InRoomInfo.nInRoomVerifyID;
        FieldByName('strDutyUserGUID').AsString := InRoomInfo.strDutyUserGUID;
        FieldByName('strSiteGUID').AsString := InRoomInfo.strSiteGUID;
        FieldByName('strTrainmanNumber').AsString := InRoomInfo.strTrainmanNumber;
        FieldByName('dtCreatetTime').AsDateTime := InRoomInfo.dtInRoomTime;
        FieldByName('strRoomNumber').AsString := InRoomInfo.strRoomNumber;
        FieldByName('nBedNumber').AsInteger := InRoomInfo.nBedNumber;
      Post();
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBRoomSign.ImportSignOut(OutRoomInfo: TRsOutRoomInfo);
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
        begin
          FieldByName('strOutRoomGUID').AsString := OutRoomInfo.strOutRoomGUID ;
          FieldByName('strTrainPlanGUID').AsString := OutRoomInfo.strTrainPlanGUID;
          FieldByName('strTrainmanGUID').AsString := OutRoomInfo.strTrainmanGUID;
          FieldByName('dtOutRoomTime').AsDateTime := OutRoomInfo.dtOutRoomTime;
          FieldByName('nOutRoomVerifyID').AsInteger := OutRoomInfo.nOutRoomVerifyID;
          FieldByName('strDutyUserGUID').AsString := OutRoomInfo.strDutyUserGUID;
          FieldByName('strSiteGUID').AsString := OutRoomInfo.strSiteGUID;
          FieldByName('strTrainmanNumber').AsString := OutRoomInfo.strTrainmanNumber;
          FieldByName('dtCreateTime').AsDateTime := OutRoomInfo.dtCreatetTime;
          FieldByName('strInRoomGUID').AsString := OutRoomInfo.strInRoomGUID;
        end;
      Post();
    end;

  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBRoomSign.InsertSignIn(const RoomSign: TRsRoomSign);
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

procedure TRsDBRoomSign.InsertSignOut(const RoomSign: TRsRoomSign);
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
      Edit();
      SignOutToAdo(ADOQuery,RoomSign);
      Post();
    end;

  finally
    ADOQuery.Free;
  end;
end;



function TRsDBRoomSign.IsExistSignInRecord(RoomGUID: string): Boolean;
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

function TRsDBRoomSign.IsExistSignOutRecord(RoomGUID: string): Boolean;
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


function TRsDBRoomSign.IsSignIn(Date:TDateTime;const TrainNumber:string;
var GUID: string;var DateTime:TDateTime): Boolean;
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
  try
    //检查最近7天内是否与有入寓记录
    strSQL := 'Select strInRoomGUID,dtInRoomTime from TAB_Plan_InRoom where ' +
    ' strInRoomGUID not in ( select strInRoomGUID from TAB_Plan_outRoom where strInRoomGUID is not null) ' +
    ' and strTrainmanNumber = %s and ( dtInRoomTime >= %s and  dtInRoomTime <= %s ) order by dtInRoomTime desc ';
    strSQL := Format(strSQL,[
    QuotedStr(TrainNumber),
    QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin)),
    QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd))]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.Open();
    //如果有入寓记录则表示要离寓
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



procedure TRsDBRoomSign.QuerySignList(RoomNumber,TrainmanNumber,TrainmanName:string;dtBegin,dtEnd: TDateTime;
  strSiteGUID: string; var RoomSignList: TRsRoomSignList;IsShowUnnormal:Boolean);
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
  try
    strSQL := 'Select TAB_Plan_InRoom.*,TAB_Plan_OutRoom.dtOutRoomTime,TAB_Plan_OutRoom.strOutRoomGUID,TAB_Plan_OutRoom.nOutRoomVerifyID, '   +
      'TAB_Org_Trainman.strTrainmanName ' +
      'from TAB_Plan_InRoom Left Join TAB_Plan_OutRoom on TAB_Plan_OutRoom.strInRoomGUID = TAB_Plan_InRoom.strInRoomGUID  Left Join TAB_Org_Trainman On TAB_Plan_InRoom.strTrainmanGUID = TAB_Org_Trainman.strTrainmanGUID ' +
      'where ( dtInRoomTime >= %s and  dtInRoomTime <= %s )  and TAB_Plan_InRoom.strSiteGUID = %s ';
    strSQL := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin)),
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)),
      QuotedStr(strSiteGUID)]);

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

      //是否显示不正常信息
      if not IsShowUnnormal then
      begin
      //过滤 手工离寓切时间小于4小时
        if ( roomSign.nOutRoomVerifyID  = 0 ) and ( roomSign.dtOutRoomTime <> 0) then
        begin
          dtDiff := roomSign.dtOutRoomTime - roomSign.dtInRoomTime ;
          nMinute := Round ( dtDiff * 24 * 60 ) ;//分钟数
          if   nMinute <= 260   then
          begin
            goto lbError ;
          end;
        end;
      end;


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

procedure TRsDBRoomSign.QuerySignListLessThanTime(RoomNumber, TrainmanNumber,
  TrainmanName: string; dtBegin, dtEnd,dtNow: TDateTime; strSiteGUID: string;
  var RoomSignList: TRsRoomSignList);
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
  try
    strSQL := 'Select TAB_Plan_InRoom.*, TAB_Org_Trainman.strTrainmanName,TAB_Org_DutyUser.strDutyName ' +
      'from TAB_Plan_InRoom  Left Join TAB_Org_Trainman On TAB_Plan_InRoom.strTrainmanGUID = TAB_Org_Trainman.strTrainmanGUID ' +
      'left join TAB_Org_DutyUser on TAB_Org_DutyUser.strDutyGUID = TAB_Plan_InRoom.strDutyUserGUID ' +
      'where TAB_Plan_InRoom.strInRoomGUID NOT in (SELECT strInRoomGUID from TAB_Plan_OutRoom WHERE strInRoomGUID is NOT NULL) and ( dtInRoomTime >= %s and  dtInRoomTime <= %s )  and TAB_Plan_InRoom.strSiteGUID = %s ';
    strSQL := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin)),
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)),
      QuotedStr(strSiteGUID)]);

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
      nMinute :=Round ( dtDiff * 24 * 60 ) ;//分钟数
      if   nMinute > 260   then
      begin
        Continue ;
      end;
      

      roomSign := TRsRoomSign.Create;
      roomSign.strInRoomGUID := ADOQuery.FieldByName('strInRoomGUID').AsString;
      roomSign.strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
      roomSign.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID').AsString;
      roomSign.strDutyUserGUID := ADOQuery.FieldByName('strDutyUserGUID').AsString;
      roomSign.strDutyUserName :=  ADOQuery.FieldByName('strDutyName').AsString;
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

procedure TRsDBRoomSign.SignOutToAdo(ADOQuery: TADOQuery;
  RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strOutRoomGUID').AsString := NewGUID ;
    FieldByName('strTrainPlanGUID').AsString := '';
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtOutRoomTime').AsDateTime := RoomSign.dtOutRoomTime;
    FieldByName('nOutRoomVerifyID').AsInteger := RoomSign.nOutRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    FieldByName('dtCreateTime').AsDateTime := RoomSign.dtOutRoomTime;
    FieldByName('strInRoomGUID').AsString := RoomSign.strInRoomGUID;
  end;
end;

procedure TRsDBRoomSign.SingInToAdo(ADOQuery: TADOQuery; RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strInRoomGUID').AsString := NewGUID;
    FieldByName('strTrainPlanGUID').AsString := '';
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtInRoomTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('nInRoomVerifyID').AsInteger := RoomSign.nInRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    FieldByName('dtCreatetTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('strRoomNumber').AsString := RoomSign.strRoomNumber;
    FieldByName('nBedNumber').AsInteger := RoomSign.nBedNumber;

  end;
end;

function TRsDBRoomSign.UpdateSignInRoomNumber(RoomGUID,RoomNumber:string;BedNumber:Integer): Boolean;
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

function TRsDBRoomSign.UpdateSignInTime(RoomGUID: string;
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

function TRsDBRoomSign.UpdateSignOutTime(RoomGUID: string;
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

procedure TRsDBRoomSign.UpdateSignTime(RoomSign: RRsRoomSign);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_Plan_InRoom set dtInRoomTime = %s where strInRoomGUID = %s';
    ADOQuery.SQL.Text := Format(strSQL,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',RoomSign.dtInRoomTime)),
      QuotedStr(RoomSign.strInRoomGUID)]);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

{ TRsDBRoomInfo }

function TRsDBRoomInfo.InsertRoom(RoomNumber: string): Boolean;
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
      strSQL1 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)',[QuotedStr(RoomNumber),1]);
      strSQL2 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)',[QuotedStr(RoomNumber),2]);
      strSQL3 := Format('Insert into  tab_base_room  ( strRoomNumber , strTrainmanGUID  ,nBedNumber ) values (%s,'''',%d)',[QuotedStr(RoomNumber),3]);
      ADOQuery.SQL.Add(strSQL1);
      ADOQuery.SQL.Add(strSQL2);
      ADOQuery.SQL.Add(strSQL3);
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

function TRsDBRoomInfo.IsRoomEmpty(RoomNumber: string): Boolean;
const
  ROOM_IS_FULL = 3 ;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select * from tab_base_room where strRoomNumber = %s and strTrainmanGUID = '''' ',[QuotedStr(RoomNumber)]) ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount = ROOM_IS_FULL then
      Result := True  ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomInfo.IsRoomExist(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select * from tab_base_room where strRoomNumber = '  + QuotedStr(RoomNumber)  ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomInfo.IsExistTrainman(TrainmanGUID, RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := False ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select * from tab_base_room where strRoomNumber = %d and strTrainmanGUID  =%s',[RoomNumber,TrainmanGUID]) ;
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

function TRsDBRoomInfo.IsRoomFull(RoomNumber: string): Boolean;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := True ;
  ADOQuery := NewADOQuery;
  try
    strSQL := Format('select * from tab_base_room where strRoomNumber = %s and strTrainmanGUID = '''' ',[QuotedStr(RoomNumber)]) ;
    ADOQuery.SQL.Text := strSQL ;
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := False ;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomInfo.AddTrainmanToRoom(TrainmanGUID,
  RoomNumber: string;BedNumber:Integer): Boolean;
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
    ADOQuery.ExecSQL;
    Result := True ;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBRoomInfo.AdoToData(AdoQuery: TADOQuery;
  var RoomInfo: RRsRoomInfo;Index:Integer);
begin
  with AdoQuery do
  begin
    RoomInfo.nID := FieldByName('nid').AsInteger;
    RoomInfo.strRoomNumber := FieldByName('strRoomNumber').AsString;
    RoomInfo.listBedInfo[Index].strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
    RoomInfo.listBedInfo[Index].strTrainmanName := FieldByName('strTrainmanName').AsString;
    RoomInfo.listBedInfo[Index].strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
    RoomInfo.listBedInfo[Index].nBedNumber := FieldByName('nBedNumber').AsInteger;
  end;
end;

procedure TRsDBRoomInfo.ClearAllRoom;
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

procedure TRsDBRoomInfo.ClearRoom(RoomNumber: string);
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

function TRsDBRoomInfo.DeleteRoom(RoomNumber: string): Boolean;
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



procedure TRsDBRoomInfo.DelTrainmanFromRoom(TrainmanGUID:string);
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

procedure TRsDBRoomInfo.DelTrainmanFromRoom(TrainmanGUID, RoomNumber: string);
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'update TAB_base_Room set strTrainmanGUID = ''''  where strRoomNumber = %s and strTrainmanGUID = %s ';
    strSQL := Format(strSQL,[QuotedStr(RoomNumber),QuotedStr(TrainmanGUID)]);
    ADOQuery.SQL.Text := strSQL;
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBRoomInfo.GetEmptyBedNumber(RoomNumber: string): Integer;
var
  ADOQuery: TADOQuery;
  strSQL: string;
begin
  Result := 0 ;
  ADOQuery := NewADOQuery;
  try
    strSQL := 'select *  from TAB_base_Room where strRoomNumber = %s and strTrainmanGUID = ''''';
    strSQL :=  Format(strSQL,[QuotedStr(RoomNumber)]);
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

procedure TRsDBRoomInfo.GetEnterRoomList(var RoomInfoList: TRsRoomInfoArray);
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
      ADOQuery.Next;
      Inc(j);
      strTemp := strNumber ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
