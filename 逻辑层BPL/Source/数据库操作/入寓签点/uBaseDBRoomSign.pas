unit uBaseDBRoomSign;

interface

uses
  DateUtils,Classes,SysUtils,ADODB,uTFSystem,uRoomSign,uLeaderExam;

type
  //入寓离寓操作类接口
  TRsBaseDBRoomSign = class(TDBOperate)
  public
    //获取入寓记录
    procedure GetSignRecord(dtBegin,dtEnd: TDateTime;strWorkShopGUID: string;out RoomSignArray: TRsRoomSignArray);virtual;
    //根据入寓号获取信息
    procedure GetSignInRecordByID(RoomGUID:string;var RoomSign:TRsRoomSign);virtual;
    //更新入寓时间
    procedure UpdateSignTime(RoomSign: RRsRoomSign);virtual;
    //查询
    procedure QuerySignList(RoomNumber,TrainmanNumber,TrainmanName:string;
      dtBegin,dtEnd: TDateTime;strSiteGUID: string;
      var RoomSignList: TRsRoomSignList;IsShowUnnormal:Boolean);virtual;
    //
    procedure QuerySignListLessThanTime(RoomNumber,TrainmanNumber,TrainmanName:string;
      dtBegin,dtEnd,dtNow: TDateTime;strSiteGUID: string;
      var RoomSignList: TRsRoomSignList);virtual;
   //增加出寓
    procedure InsertSignIn(const RoomSign:TRsRoomSign);virtual;
    //增加离寓
    procedure InsertSignOut(const RoomSign:TRsRoomSign);virtual;
    //判断是否入寓,如果是入寓则获取信息
    function  IsSignIn(Date:TDateTime;const TrainNumber:string;
      var GUID: string;var DateTime:TDateTime):Boolean;virtual;
    //更新入寓时间
    function  UpdateSignInTime(RoomGUID:string;Date:TDateTime):Boolean;virtual;
    //更新入寓房间号
    function  UpdateSignInRoomNumber(RoomGUID,RoomNumber:string;BedNumber:Integer):Boolean;virtual;
    //更新离寓时间
    function  UpdateSignOutTime(RoomGUID:string;Date:TDateTime):Boolean;virtual;
    //删除入寓记录
    function  DelSignInRecord(RoomGUID:string):Boolean;virtual;
    //删除离寓记录
    function  DelSignOutRecord(RoomGUID:string):Boolean;virtual;
    //删除 入寓管理的离寓的记录
    function  DelSignInOutRecord(RoomGUID:string):Boolean;virtual;
    //是否有入寓记录
    function  IsExistSignInRecord(RoomGUID:string):Boolean;virtual;
    //是否有离寓记录
    function  IsExistSignOutRecord(RoomGUID:string):Boolean;virtual;
    //得到最近入寓时间
    function  GetSignInTime(const TrainNumber:string;var DateTime:TDateTime):Boolean;virtual;
    //得到最近的入寓的GUID
    function  GetLastInGUID(const TrainNumber:string):string;virtual;
  protected
    procedure SingInToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);
    procedure SignOutToAdo(ADOQuery:TADOQuery;RoomSign: TRsRoomSign);
  end;


  //房间操作数据库类 基类{主要是接口定义}{access _ sqlserver}
  TRsBaseDBRoomInfo = class(TDBOperate)
  public
    //获取现有的入驻情况
    procedure GetEnterRoomList(var RoomInfoList : TRsRoomInfoArray);virtual;
    //获取所有的房间
    procedure GetAllRoom(var RoomInfoList : TRsRoomInfoArray);virtual;
    //增加一个房间
    function  InsertRoom(RoomNumber:string):Boolean;virtual;
    //清空房间的入驻人员信息
    procedure ClearRoom(RoomNumber:string);virtual;
    //清空所有的房间信息
    procedure ClearAllRoom();virtual;
    //删除一个房间
    function  DeleteRoom(RoomNumber:string):Boolean; virtual;
    //检查房间是否存在
    function  IsRoomExist(RoomNumber:string):Boolean; virtual;
  public
    //获取所有的房间和人员的关联
    function  GetAllTrainmanRoomRelation(RoomNumber:string;var BedInfoArray:TRsBedInfoArray):Boolean;virtual;
    //查询某人
    function  QueryTrainmanRoomRelation(TrainmanNumber,TrainmanName:string;var RoomNumber:string):Boolean;virtual;
    //增加指定人员的房间信息
    function  InsertTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;virtual;
   //删除指定人员的房间信息
    function  RemoveTrainmanRoomRelation(RoomNumber:string;BedInfo:RRsBedInfo):Boolean;virtual;
    //修改指定人员的房间信息
    function  ModifyTrainmanRoomRelation(RoomNumber:string;BedInfoOld:RRsBedInfo;BedInfoNew:RRsBedInfo):Boolean;virtual;
    //获取指定人员的房间信息
    function  GetTrainmanRoomRelation(TrainmanGUID:string;var BedInfo:RRsBedInfo):Boolean;virtual;
        //检查是否已经有房间和人员的关系
    function  IsHaveTrainmanRoomRelation(TrainmanGUID:string;out RoomNumber:string):Boolean;virtual;
    //记录人员的房间号
    function SaveTrainmanRoomRelation(TrainmanGUID:string;var BedInfo:RRsBedInfo):Boolean;virtual;
  public
    function IsRoomEmpty(RoomNumber:string):Boolean; virtual;
    //检查房间是否是满员
    function  IsRoomFull(RoomNumber:string):Boolean;virtual;
    //检查在房间否在XX
    function  IsExistTrainman(TrainmanGUID,RoomNumber:string):Boolean;virtual;
    //添加一个人到房间
    function  AddTrainmanToRoom(TrainmanGUID,RoomNumber:string;BedNumber:Integer):Boolean; virtual;
    //从房间删除一个人
    procedure  DelTrainmanFromRoom(TrainmanGUID:string);virtual;
    //获取一个空的床位
    function   GetEmptyBedNumber(RoomNumber:string):Integer; virtual;

  protected
    procedure AdoToData(AdoQuery:TADOQuery;var RoomInfo:RRsRoomInfo;Index:Integer);
  end;


  TRsBaseDBLeaderInspect = class(TDBOperate)
  public
      //获取干部检查列表信息
    procedure  GetLeaderInspectList(BeginDate,EndDate:TDateTime;var LeaderInspectList:TRsLeaderInspectList);virtual;
    function   AddLeaderInspect(LeaderInspect:RRsLeaderInspect):boolean;virtual;
  protected
    procedure  AdoToData(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
    procedure  DataToAdo(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
  end;



implementation

{ TRsBaseDBRoomInfo }

function TRsBaseDBRoomInfo.AddTrainmanToRoom(TrainmanGUID, RoomNumber: string;
  BedNumber: Integer): Boolean;
begin
  Result := False ;
end;

procedure TRsBaseDBRoomInfo.AdoToData(AdoQuery: TADOQuery;
  var RoomInfo: RRsRoomInfo; Index: Integer);
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

procedure TRsBaseDBRoomInfo.ClearAllRoom;
begin

end;

procedure TRsBaseDBRoomInfo.ClearRoom(RoomNumber: string);
begin

end;

function TRsBaseDBRoomInfo.DeleteRoom(RoomNumber: string): Boolean;
begin
  Result := False ;
end;

procedure TRsBaseDBRoomInfo.DelTrainmanFromRoom(TrainmanGUID: string);
begin

end;

procedure TRsBaseDBRoomInfo.GetAllRoom(var RoomInfoList: TRsRoomInfoArray);
begin
  ;
end;

function TRsBaseDBRoomInfo.GetAllTrainmanRoomRelation(RoomNumber: string;
  var BedInfoArray: TRsBedInfoArray): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.GetEmptyBedNumber(RoomNumber: string): Integer;
begin
  Result := 1 ;
end;

procedure TRsBaseDBRoomInfo.GetEnterRoomList(
  var RoomInfoList: TRsRoomInfoArray);
begin

end;

function TRsBaseDBRoomInfo.GetTrainmanRoomRelation(TrainmanGUID: string;
  var BedInfo: RRsBedInfo): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.InsertRoom(RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.InsertTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.IsExistTrainman(TrainmanGUID,
  RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.IsHaveTrainmanRoomRelation(TrainmanGUID:string;out RoomNumber:string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.IsRoomEmpty(RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.IsRoomExist(RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.IsRoomFull(RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.ModifyTrainmanRoomRelation(RoomNumber: string;
  BedInfoOld, BedInfoNew: RRsBedInfo): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.QueryTrainmanRoomRelation(TrainmanNumber,
  TrainmanName: string; var RoomNumber: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomInfo.RemoveTrainmanRoomRelation(RoomNumber: string;
  BedInfo: RRsBedInfo): Boolean;
begin
  Result := False ;
end;



function TRsBaseDBRoomInfo.SaveTrainmanRoomRelation(TrainmanGUID: string;
  var BedInfo: RRsBedInfo): Boolean;
begin
  ;
end;

{ TRsBaseDBRoomSign }

function TRsBaseDBRoomSign.DelSignInOutRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.DelSignInRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.DelSignOutRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.GetLastInGUID(const TrainNumber: string): string;
begin

end;

procedure TRsBaseDBRoomSign.GetSignInRecordByID(RoomGUID: string;
  var RoomSign: TRsRoomSign);
begin

end;

function TRsBaseDBRoomSign.GetSignInTime(const TrainNumber: string;
  var DateTime: TDateTime): Boolean;
begin

end;

procedure TRsBaseDBRoomSign.GetSignRecord(dtBegin, dtEnd: TDateTime;
  strWorkShopGUID: string; out RoomSignArray: TRsRoomSignArray);
begin
  ;
end;

procedure TRsBaseDBRoomSign.InsertSignIn(const RoomSign: TRsRoomSign);
begin

end;

procedure TRsBaseDBRoomSign.InsertSignOut(const RoomSign: TRsRoomSign);
begin

end;

function TRsBaseDBRoomSign.IsExistSignInRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.IsExistSignOutRecord(RoomGUID: string): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.IsSignIn(Date: TDateTime; const TrainNumber: string;
  var GUID: string; var DateTime: TDateTime): Boolean;
begin
  Result := False ;
end;

procedure TRsBaseDBRoomSign.QuerySignList(RoomNumber, TrainmanNumber,
  TrainmanName: string; dtBegin, dtEnd: TDateTime; strSiteGUID: string;
  var RoomSignList: TRsRoomSignList; IsShowUnnormal: Boolean);
begin

end;

procedure TRsBaseDBRoomSign.QuerySignListLessThanTime(RoomNumber,
  TrainmanNumber, TrainmanName: string; dtBegin, dtEnd, dtNow: TDateTime;
  strSiteGUID: string; var RoomSignList: TRsRoomSignList);
begin

end;

procedure TRsBaseDBRoomSign.SignOutToAdo(ADOQuery: TADOQuery;
  RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strOutRoomGUID').AsString := RoomSign.strOutRoomGUID ;
    FieldByName('strTrainPlanGUID').AsString := RoomSign.strTrainPlanGUID;
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtOutRoomTime').AsDateTime := RoomSign.dtOutRoomTime;
    FieldByName('nOutRoomVerifyID').AsInteger := RoomSign.nOutRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    FieldByName('dtCreateTime').AsDateTime := RoomSign.dtOutRoomTime;
    //FieldByName('strInRoomGUID').AsString := RoomSign.strInRoomGUID;
  end;
end;

procedure TRsBaseDBRoomSign.SingInToAdo(ADOQuery: TADOQuery;
  RoomSign: TRsRoomSign);
begin
  with ADOQuery do
  begin
    FieldByName('strInRoomGUID').AsString := RoomSign.strInRoomGUID;
    FieldByName('strTrainPlanGUID').AsString := RoomSign.strTrainPlanGUID;
    FieldByName('strTrainmanGUID').AsString := RoomSign.strTrainmanGUID;
    FieldByName('dtInRoomTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('nInRoomVerifyID').AsInteger := RoomSign.nInRoomVerifyID;
    FieldByName('strDutyUserGUID').AsString := RoomSign.strDutyUserGUID;
    FieldByName('strSiteGUID').AsString := RoomSign.strSiteGUID;
    FieldByName('strTrainmanNumber').AsString := RoomSign.strTrainmanNumber;
    FieldByName('dtCreatetTime').AsDateTime := RoomSign.dtInRoomTime;
    FieldByName('strRoomNumber').AsString := RoomSign.strRoomNumber;
    //FieldByName('nBedNumber').AsInteger := RoomSign.nBedNumber;
  end;
end;

function TRsBaseDBRoomSign.UpdateSignInRoomNumber(RoomGUID, RoomNumber: string;
  BedNumber: Integer): Boolean;
begin
  Result := False ;
end;

function TRsBaseDBRoomSign.UpdateSignInTime(RoomGUID: string;
  Date: TDateTime): Boolean;
begin

end;

function TRsBaseDBRoomSign.UpdateSignOutTime(RoomGUID: string;
  Date: TDateTime): Boolean;
begin
  Result := False ;
end;

procedure TRsBaseDBRoomSign.UpdateSignTime(RoomSign: RRsRoomSign);
begin
  ;
end;

{ TRsBaseDBLeaderInspect }

function TRsBaseDBLeaderInspect.AddLeaderInspect(
  LeaderInspect: RRsLeaderInspect): boolean;
begin
  Result := False ;
end;

procedure TRsBaseDBLeaderInspect.AdoToData(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    LeaderInspect.GUID := FieldByName('strGUID').AsString;
    LeaderInspect.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;;
    LeaderInspect.strTrainmanName := FieldByName('strTrainmanName').AsString;
    LeaderInspect.LeaderGUID := FieldByName('strLeaderGUID').AsString;
    LeaderInspect.AreaGUID := FieldByName('strAreaGUID').AsString;
    LeaderInspect.VerifyID := FieldByName('nVerifyID').AsInteger;
    LeaderInspect.CreateTime := FieldByName('dtCreateTime').AsDateTime;
    LeaderInspect.DutyGUID := FieldByName('strDutyGUID').AsString;
    //LeaderInspect.strContext  := FieldByName('strContext').AsString;
  end;
end;

procedure TRsBaseDBLeaderInspect.DataToAdo(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    FieldByName('strGUID').AsString := LeaderInspect.GUID;
    FieldByName('strLeaderGUID').AsString := LeaderInspect.LeaderGUID;
    FieldByName('strAreaGUID').AsString := LeaderInspect.AreaGUID;
    FieldByName('nVerifyID').AsInteger := LeaderInspect.VerifyID;
    FieldByName('dtCreateTime').AsDateTime := LeaderInspect.CreateTime;
    FieldByName('strDutyGUID').AsString := LeaderInspect.DutyGUID;
    //FieldByName('strContext').AsString := LeaderInspect.strContext;
  end;  
end;

procedure TRsBaseDBLeaderInspect.GetLeaderInspectList(BeginDate,
  EndDate: TDateTime; var LeaderInspectList: TRsLeaderInspectList);
begin

end;

end.
