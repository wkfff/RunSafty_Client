unit uRoomWaitDBOprate;

interface
uses
  Classes, SysUtils, Forms, windows, adodb,uTrainman,Contnrs;
type
  TRoomTrainman = class
    RoomWaitingGUID: string;
    RoomNumber: string;
    TrainmanArray: TRsTrainmanArray;
  end;
  TRoomTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRoomTrainman;
    procedure SetItem(Index: Integer; RoomTrainman: TRoomTrainman);
  public
    function Add(RoomTrainman: TRoomTrainman): Integer;
    property Items[Index: Integer]: TRoomTrainman read GetItem write SetItem; default;
  end;
  RWaitPlan = record
    strGUID: string;
    strTrainNo: string; //����
    nRoomID: string; //�����
    dtCallTime: TDateTime; //�а�ʱ��
    dtStartTime: TDateTime; //����ʱ��
    bIsUsed: Boolean; //�Ƿ�����
    strAreaGUID: string; //��������
  public
  procedure Init;
  end;

  RWaitPlanRecord = record
    strGUID : string;
    strTrainNo : string;
    strTrainmanNo : string;
    strTrainmanName : string;
    nRoomID : string;
    dtCallTime : TDateTime;
    dtStartTime : TDateTime;
    strAreaGUID : string;
    nCallCount : integer;
    strPlanGUID : string;
    //����ʱ��
    dtDutyTime: TDateTime;
  end;
  ////////////////////////////////////////////////////////////////////////////////
  ///    ������TWaitPlanOpt
  ///    ���ܣ����˹������ݿ������
  ///  ///////////////////////////////////////////////////////////////////////////
  TWaitPlanOpt = class
  public

    {���ܣ���Ӽƻ�}
    class function AddPlan(plan: RWaitPlan): boolean;

    {���ܣ�ɾ���ƻ�}
    class function DeletePlan(planGUID: string): boolean;
    {���ܣ���Ӵ��˼�¼}
    class function AddPlanRecord(planRecord : RWaitPlanRecord) : boolean;
    {���ܣ��޸Ĵ��˼�¼}
    class function EditPlanRecord(planRecord : RWaitPlanRecord) : boolean;
    {���ܣ���ȡ���˼�¼}
    class function GetPlanRecord(planGUID: string) : RWaitPlanRecord;
    {���ܣ���ȡ���һ�εǼǵĽа��¼}
    class function GetLastPlanRecord(strTrainNo : string):RWaitPlanRecord;
    {���ܣ���Ӵ��˼�¼}
    class function DeletePlanRecord(planGUID : string) : boolean;
    {���ܣ����Ŵ��˼�¼�Ľа�ʱ��}
    class function UpdatePlanRecordTime(planGUID : string) : boolean;
    {���ܣ����Ŵ��˼�¼�ĳ���ʱ��(��)}
    class function UpdatePlanDutyTime(planGUID : string;dtDutyTime: TDateTime) : boolean;


    {��ȡ��ǰ���˼ƻ�����}
    class procedure GetPlans(out Rlt : TADOQuery);

    class procedure CreatePlans(strAreaGUID : string);

    {��ȡ��ǰ���˼ƻ�����}
    class procedure GetPlansByState(appTime : TDateTime;out Rlt : TADOQuery);
    {��ȡ��ǰ���˼ƻ�����}
    class procedure GetPlansByStateEx(appTime : TDateTime;out Rlt : TADOQuery);

    {���ܣ��Ƿ��и÷����δ�а�Ĵ��˼�¼}
    class function CheckRoomWaitingByRoom(RoomNo: string;var nCallCount: Integer): string;
    {���ܣ��ó���Ա�Ƿ��Ѿ���Ԣ}
    class function CheckTrainmanInRoom(TrainmanNo: string): string;
    {���ܣ�ͳ�Ƹ������˼�¼��Ӧ�����ס����Ա����}
    class function GetRoomWaitingTrainmanCount(RoomWaitingGUID: string): Integer;
    {���ܣ��������˼�¼��Ӧ����������Ա}
    class function AddRoomWaitingTrainman(RoomWaitingGUID,TrainmanNo,TrainmanName: string):Boolean;
    {���ܣ���ȡ�������˼�¼��Ӧ�ĳ���Ա��Ϣ}
    class function GetRoomWaitingTrainman(RoomWaitingGUID : string): TRsTrainmanArray;
    {���ܣ����ýа��¼Ϊ�ѽа࣬��Ҫ��Դ���Ľа��¼���ƣ�}
    class function SetRoomWaitingOver(RoomWaitingGUID : string;nCallCount: Integer): Boolean;
  end;

implementation
uses
  uGlobalDM, DB,utfsystem;
{ TWaitPlanOpt }



class function TWaitPlanOpt.EditPlanRecord(
  planRecord: RWaitPlanRecord): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  strSql := 'select * from TAB_RoomWaiting_CallRecord where strGUID=%s';
  strSql := Format(strSql,[QuotedStr(planRecord.strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        Edit;
        FieldByName('strTrainNo').AsString := planRecord.strTrainNo;
        FieldByName('nRoomID').AsString := planRecord.nRoomID;
        FieldByName('dtCallTime').AsDateTime := 0;
        if planRecord.dtCallTime > 0 then
          FieldByName('dtCallTime').AsDateTime := planRecord.dtCallTime;
        if planRecord.dtDutyTime > 0 then
          FieldByName('dtOutDutyTime').AsDateTime := planRecord.dtDutyTime;
        FieldByName('dtStartTime').AsDateTime := planRecord.dtStartTime;
        FieldByName('strAreaGUID').AsString := planRecord.strAreaGUID;
        Post;
        Result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

class function TWaitPlanOpt.GetLastPlanRecord(strTrainNo : string): RWaitPlanRecord;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select top 1 * from TAB_RoomWaiting_CallRecord where strTrainNo=%s order by dtCallTime desc';
      Sql.Text := Format(Sql.Text, [QuotedStr(strTrainNo)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin
          strGUID := FieldByName('strGUID').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          nRoomID := FieldByName('nRoomID').AsString;
          dtCallTime := FieldByName('dtCallTime').AsDateTime;
          dtStartTime := FieldByName('dtStartTime').AsDateTime;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
          nCallCount := FieldByName('nCallCount').AsInteger;
          strPlanGUID := FieldByName('strPlanGUID').AsString;
        end;
      end;
    end;
  finally
    ado.Free;
  end;


end;



class function TWaitPlanOpt.GetPlanRecord(planGUID: string): RWaitPlanRecord;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select * from TAB_RoomWaiting_CallRecord where strGUID=%s';
      Sql.Text := Format(Sql.Text, [QuotedStr(planGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin
          strGUID := FieldByName('strGUID').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          nRoomID := Trim(FieldByName('nRoomID').AsString);
          dtCallTime := FieldByName('dtCallTime').AsDateTime;
          dtDutyTime := FieldByName('dtOutDutyTime').AsDateTime;
          dtStartTime := FieldByName('dtStartTime').AsDateTime;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
          nCallCount := FieldByName('nCallCount').AsInteger;
          strPlanGUID := FieldByName('strPlanGUID').AsString;
        end;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TWaitPlanOpt.GetPlansByState(appTime : TDateTime;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select *,    ' +
             ' (case when ((DATEADD(n,30,dtCallTime) < %s) or (nCallCount > 1 and dateadd(n,20,dtCallTime) < getdate())) then 1 else 0 end) as ViewOrder ' +
             ' from VIEW_RoomWaiting_CallRecord where strAreaGUID = %s and ((dtCallTime >= dbo.GetDateString(getdate()) +'+ ''' 00:00:00'') or (dtCallTime is null))' +
             ' order by ViewOrder,dtCallTime,nRoomID';
    Sql.Text := Format(Sql.Text, [QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',appTime)),
      QuotedStr(GlobalDM.LocalArea)]);
    Open;
  end;
end;

class procedure TWaitPlanOpt.GetPlansByStateEx(appTime: TDateTime;
  out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select *,    ' +
             ' (case when ((DATEADD(n,30,dtCallTime) < %s) or (nCallCount > 1 and dateadd(n,20,dtCallTime) < getdate())) then 1 else 0 end) as ViewOrder ' +
             ' from VIEW_RoomWaiting_CallRecord where (nCallCount < 2)  and ((dtCallTime >= dbo.GetDateString(getdate()-1) +'+ ''' 23:30:00'') or (dtCallTime is null) or (convert(float,dtCallTime) = -2.0))' +
             ' order by ViewOrder,dtCallTime,nRoomID';
    Sql.Text := Format(Sql.Text, [QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',appTime))]);
    Open;
  end;
end;

class function TWaitPlanOpt.GetRoomWaitingTrainman(
  RoomWaitingGUID: string): TRsTrainmanArray;
{���ܣ���ȡ�������˼�¼��Ӧ�ĳ���Ա��Ϣ}
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  SetLength(Result,0);
  strSql := 'select * from TAB_RoomWaiting_Trainman where strRoomWaitingGUID = '
    + QuotedStr(RoomWaitingGUID);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := strSql;
      Open;
      while not Eof do
      begin
        SetLength(Result,length(Result) + 1);
        Result[Length(Result) - 1].strTrainmanNumber := Trim(FieldByName('strTrainmanNo').AsString);
        Result[Length(Result) - 1].strTrainmanName := Trim(FieldByName('strTrainmanName').AsString);
        Next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TWaitPlanOpt.GetRoomWaitingTrainmanCount(
  RoomWaitingGUID: string): Integer;
{���ܣ�ͳ�Ƹ������˼�¼��Ӧ�����ס����Ա����}
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select * from TAB_RoomWaiting_Trainman where '
        + 'strRoomWaitingGUID = ' + QuotedStr(RoomWaitingGUID);
      open;
      Result := RecordCount;
    end;
  finally
    ado.Free;
  end;

end;

class function TWaitPlanOpt.SetRoomWaitingOver(
  RoomWaitingGUID: string;nCallCount: Integer): Boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'update TAB_RoomWaiting_CallRecord set nCallCount = %d where strGUID=%s';
      Sql.Text := Format(Sql.Text, [nCallCount,QuotedStr(RoomWaitingGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TWaitPlanOpt.UpdatePlanDutyTime(planGUID: string;
  dtDutyTime: TDateTime): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'update TAB_RoomWaiting_CallRecord set dtOutDutyTime = ' +
       ':dtOutDutyTime where strGUID = :strGUID and nCallCount = 0';
      Parameters.ParamByName('dtOutDutyTime').Value := dtDutyTime;
      Parameters.ParamByName('strGUID').Value := planGUID;
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TWaitPlanOpt.UpdatePlanRecordTime(planGUID: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'update TAB_RoomWaiting_CallRecord set dtCallTime = getdate() where strGUID=%s and nCallCount = 0';
      Sql.Text := Format(Sql.Text, [QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TWaitPlanOpt.GetPlans(out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select * from TAB_RoomWaiting_Plan order by  (DATEPART(hh, dtCallTime)*10000)+(DATEPART(mi,dtCallTime)*100)+(DATEPART(ss, dtCallTime)),nRoomID';
    Open;
  end;
end;

class function TWaitPlanOpt.AddPlanRecord(planRecord: RWaitPlanRecord): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_RoomWaiting_CallRecord where 1=2';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := strSql;
      Open;
      Append;
      FieldByName('strGUID').AsString := NewGUID;
      FieldByName('strTrainNo').AsString := planRecord.strTrainNo;
      FieldByName('strTrainmanNo').AsString := planRecord.strTrainmanNo;
      FieldByName('strTrainmanName').AsString := planRecord.strTrainmanName;
      FieldByName('nRoomID').AsString := planRecord.nRoomID;
      FieldByName('dtCallTime').AsDateTime := 0;
      if planRecord.dtCallTime > 0 then
        FieldByName('dtCallTime').AsDateTime := planRecord.dtCallTime;
      FieldByName('dtOutDutyTime').AsDateTime := 0;
      if planRecord.dtDutyTime > 0 then
        FieldByName('dtOutDutyTime').AsDateTime := planRecord.dtDutyTime;
      FieldByName('dtStartTime').AsDateTime := planRecord.dtStartTime;
      FieldByName('strAreaGUID').AsString := planRecord.strAreaGUID;
      FieldByName('nCallCount').AsInteger := planRecord.nCallCount;
      FieldByName('strPlanGUID').AsString := planRecord.strPlanGUID;
      Post;
      AddRoomWaitingTrainman(FieldByName('strGUID').AsString,
        planRecord.strTrainmanNo,planRecord.strTrainmanName);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TWaitPlanOpt.AddRoomWaitingTrainman(RoomWaitingGUID, TrainmanNo,
  TrainmanName: string): Boolean;
{���ܣ��������˼�¼��Ӧ����������Ա}
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_RoomWaiting_Trainman where 1=2';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := strSql;
      Open;
      Append;
      FieldByName('strRoomWaitingGUID').AsString := RoomWaitingGUID;
      FieldByName('strTrainmanNo').AsString := TrainmanNo;
      FieldByName('strTrainmanName').AsString := TrainmanName;
      Post;
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;
class function TWaitPlanOpt.CheckRoomWaitingByRoom(RoomNo: string;var nCallCount: Integer): string;
{���ܣ��Ƿ��и÷����δ��ʼ�а�Ĵ��˼�¼������з�����GUID}
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := '';
  strSql := 'select top 1 * from TAB_RoomWaiting_CallRecord where nCallCount < 2 and '
    + 'nRoomID = ' + QuotedStr(RoomNo);
  strSql := strSql + ' order by dtStartTime desc';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        Result := FieldByName('strGUID').AsString;
        nCallCount := FieldByName('nCallCount').AsInteger;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TWaitPlanOpt.CheckTrainmanInRoom(TrainmanNo: string): string;
var
  strSql,RoomWaitingGUID : string;
  adoQuery : TADOQuery;
  adoQuery1: TADOQuery;
begin
  Result := '';
  strSql := 'select * from TAB_RoomWaiting_CallRecord where nCallCount < 2 ';
  strSql := strSql + ' order by dtStartTime desc';
  adoQuery := TADOQuery.Create(nil);
  adoQuery1 := TADOQuery.Create(nil);
  try
    adoQuery.Connection := GlobalDM.LocalADOConnection;
    adoQuery1.Connection := GlobalDM.LocalADOConnection ;
    adoQuery.Sql.Text := strSql;
    adoQuery.Open;
    while not adoQuery.Eof do
    begin
      RoomWaitingGUID := adoQuery.FieldByName('strGUID').AsString;
      strSql := 'select * from Tab_RoomWaiting_Trainman where '
        + 'strRoomWaitingGUID = %s and strTrainmanNo = %s';
      strSql := Format(strSql,[QuotedStr(RoomWaitingGUID),QuotedStr(TrainmanNo)]);
      adoQuery1.SQL.Text := strSql;
      adoQuery1.Open;
      if adoQuery1.RecordCount > 0 then
      begin
        Result := Trim(adoQuery.FieldByName('nRoomID').AsString);
        Break;
      end;
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
    adoQuery1.Free;
  end;
end;
class procedure TWaitPlanOpt.CreatePlans(strAreaGUID : string);
var
  strSql : string;
  ado: TADOQuery;
begin
  strSql := 'insert into tab_RoomWaiting_CallRecord ' +
            ' (strGUID,strTrainNo,nRoomID,dtCallTime,dtStartTime,strAreaGUID,nCallCount,strPlanGUID) ' +
            ' (select newid(),strTrainNo,nRoomID,dtCallTime,dtStartTime,strAreaGUID,0,strGUID ' +
            ' from VIEW_RoomWaiting_Exist where strRecordGUID is null and strAreaGUID = %s  ' +
            ' and (dbo.GetDateString(dtStartTime) = dbo.GetDateString(getdate()) or ' +
            ' dbo.GetDateString(dtStartTime) <> dbo.GetDateString(getdate())  and dtCallTime > getdate())'  +
            ' )' ;
  strSql := Format(strSql,[QuotedStr(strAreaGUID)]);

  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    ado.Free;
  end;

end;

class function TWaitPlanOpt.DeletePlan(planGUID: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'delete from TAB_RoomWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text, [QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TWaitPlanOpt.DeletePlanRecord(planGUID: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'delete from TAB_RoomWaiting_CallRecord where strGUID=%s';
      Sql.Text := Format(Sql.Text, [QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TWaitPlanOpt.AddPlan(plan: RWaitPlan): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select * from TAB_RoomWaiting_Plan where 1=2';
      Open;
      Append;
      FieldByName('strGUID').AsString := NewGUID;
      FieldByName('strTrainNo').AsString := plan.strTrainNo;
      FieldByName('nRoomID').AsString := plan.nRoomID;
      FieldByName('dtCallTime').AsDateTime := plan.dtCallTime;
      FieldByName('dtStartTime').AsDateTime := plan.dtStartTime;
      FieldByName('bIsUsed').AsBoolean := plan.bIsUsed;
      FieldByName('strAreaGUID').AsString := plan.strAreaGUID;
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

{ RWaitPlan }

procedure RWaitPlan.Init;
begin
  strGUID := '';
  bIsUsed := False;
  nRoomID := '';
  strAreaGUID := '';
end;

{ TRoomTrainmanList }

function TRoomTrainmanList.Add(RoomTrainman: TRoomTrainman): Integer;
begin
  Result := inherited Add(RoomTrainman);
end;

function TRoomTrainmanList.GetItem(Index: Integer): TRoomTrainman;
begin
  Result := TRoomTrainman(inherited GetItem(Index));
end;

procedure TRoomTrainmanList.SetItem(Index: Integer;
  RoomTrainman: TRoomTrainman);
begin
  inherited SetItem(Index,RoomTrainman);
end;

end.

