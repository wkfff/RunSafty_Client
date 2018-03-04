unit uDBPlan;

interface

uses SysUtils,Windows,Classes,ADODB,DB,uTrainman,ZKFPEngXUtils,Variants,
    uTFSystem,uPlan, DateUtils;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBPlan
  /// ˵��:�ƻ����ݲ�����
  //////////////////////////////////////////////////////////////////////////////
  TDBPlan = class(TDBOperate)
  private
    {����:�����ݿ�����������}
    procedure CopyDataToObject(ADOQuery:TADOQuery;Item:TPlan);
    {����:�����ݿ���������Դ��}
    procedure CopyDataToDB(ADOQuery:TADOQuery;Item:TPlan);
  public
    {����:�жϼƻ��Ƿ����}
    function PlanExist(strPlanGUID:String):Boolean;
    {����:���ݳ����жϼƻ��Ƿ����}
    function PlanExistByTrainNo(strTrainNo : String;dtPlanDate:TDateTime;
        strAreaGUID:String):Boolean;

    {����:��ȡ�ƻ���Ϣ}
    function GetPlan(strPlanGUID:String;var Plan:TPlan):Boolean;
    {����:��ȡ�ƻ���Ϣ�б�}
    procedure GetPlanList(strAreaGUID:String;var PlanList:TPlanList);
    {����:����ƻ���Ϣ}
    procedure SavePlan(Plan:TPlan);
    {����:ɾ���ƻ���Ϣ}
    procedure DeletePlan(strPlanGUID:String);

    {����:���ݳ��λ�ȡ�ƻ���Ϣ}
    function GetPlanByTrainNo(strTrainNo:String;dtPlanDate:TDateTime;
        strAreaGUID:String;var Plan:TPlan):Boolean;overload;


    {����:���ݳ��λ�üƻ�,�ڶ�������Ϊ�ƻ�״̬��
      �÷����Ὣ���ε���strCheCi,״̬С��nPlanState�ļƻ����򷵻������һ��}
    function GetPlanByTrainNo(strTrainNo:String;nPlanState:Integer;
        strAreaGUID:String;var Plan:TPlan):Boolean;overload;



    {����:���ݳ���ԱID��üƻ�,�ڶ�������Ϊ�ƻ�״̬��
      �÷����Ὣ����ԱID����strTrainmanGUID,״̬С��nPlanState�ļƻ����򷵻������һ��}
    function GetPlanByTrainmanGUID(strTrainmanGUID:String;nPlanState:Integer;
        Plan:TPlan):Boolean;
    {����:���¼ƻ�״̬}
    procedure UpdatePlanState(strPlanGUID,strTrainmanGUID:String;nPlanState:Integer;nTrainmanIndex : integer);
    
    {����:���һ��ʱ�����мƻ�������}
    function GetContainPlanDate(dtBeginDate,dtEndDate:TDateTime) : TDateTimeArray;
  public
    //��ȡ����Ա�ܽа�ļƻ�
    class function GetTrainmanCallPlan(trainmanGUID : string;Plan : TPlan;ADOConn : TADOConnection) : boolean;
    //����Ա��Ԣ
    class function InRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer;ADOConn : TADOConnection;
        DutyUserGUID : string): boolean;
    //����Ա��Ԣ
    class function OutRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer;ADOConn : TADOConnection;
        DutyUserGUID : string): boolean;
    class procedure GetCallsByGUID(planGUID : string;out Rlt : TADOQuery;ADOConn:TADOConnection);
    //�޸Ĵ��˽а��־
    class procedure EditRoomWaitingState(strGUID: string;callCount : integer;ADOConn : TADOConnection);
    //�޸Ľа��־
    class function EditCallState(bCalled:Boolean;strGUID:string;ADOConn : TADOConnection) : boolean;
    //��ȡ��ǰ��Ҫ�а�ļƻ���Ϣ
    class procedure GetCalls(AreaGUID:string;planDate : TDateTime;out Rlt  : TADOQuery;ADOConn : TADOConnection);
    //��ȡ��ǰ��Ҫ�а�ļƻ���Ϣ
    class procedure GetBeginWorks(AreaGUID:string;planDate : TDateTime;out Rlt  : TADOQuery;ADOConn : TADOConnection);
    //��ȡָ���ƻ���ǩ����Ϣ
    class procedure GetPlanSignIn(PlanGUID : string;TrainmanGUID : string;out  Rlt: TADOQuery;ADOConn : TADOConnection);
    //��ȡ��ǰ�������мƻ��ĳ���
    class procedure GetNowPlanTrainNos(AreaGUID : string;var TrainNos : TStrings;ADOConn : TADOConnection);
    //��ȡ��ǰ�������мƻ��ĳ���
    class procedure GetNowCallTrainNos(AreaGUID : string;var TrainNos : TStrings;ADOConn : TADOConnection);
   //��ѯָ�����ڷ�Χ�ڵĳ��ڼƻ�
    class procedure QueryPlan(AreaGUID : string; beginTime,endTime : string;bUnPlanTrain:boolean;
      out Rlt : TADOQuery;adoconn : TADOConnection);
  end;

implementation

{ TDBPlan }

procedure TDBPlan.CopyDataToDB(ADOQuery: TADOQuery; Item: TPlan);
{����:�����ݿ���������Դ��}
begin
  ADOQuery.FieldByName('strGUID').AsString := Item.strGUID;
  ADOQuery.FieldByName('strTrainNo').AsString := Item.strTrainNo;
  ADOQuery.FieldByName('strSectionName').AsString := Item.strSectionName;
  ADOQuery.FieldByName('strJiaoLuNumber').AsString := Item.strJiaoLuNumber;
  ADOQuery.FieldByName('strCheZhanNumber').AsString := Item.strCheZhanNumber;
  ADOQuery.FieldByName('dtRestTime').AsDateTime := Item.dtRestTime;
  ADOQuery.FieldByName('dtCallTime').AsDateTime := Item.dtCallTime;
  ADOQuery.FieldByName('dtOutDutyTime').AsDateTime := Item.dtOutDutyTime;
  ADOQuery.FieldByName('dtStartTime').AsDateTime := Item.dtStartTime;
  ADOQuery.FieldByName('nTrainmanTypeID').AsInteger := Item.nTrainmanTypeID;
  ADOQuery.FieldByName('strAreaGUID').AsString := Item.strAreaGUID;
  ADOQuery.FieldByName('dtCreateTime').AsDateTime := Item.dtCreateTime;
  ADOQuery.FieldByName('strTrainType').AsString := Item.strTrainType;
  ADOQuery.FieldByName('strTrainNumber').AsString := Item.strTrainNumber;
  ADOQuery.FieldByName('strTrainmanGUID1').AsString := Item.strTrainmanGUID1;
  ADOQuery.FieldByName('nTrainmanState1').AsInteger := Item.nTrainmanState1;
  ADOQuery.FieldByName('strTrainmanGUID2').AsString := Item.strTrainmanGUID2;
  ADOQuery.FieldByName('nTrainmanState2').AsInteger := Item.nTrainmanState2;
  ADOQuery.FieldByName('nState').AsInteger := Item.nState;
  ADOQuery.FieldByName('nIsEnforceRest').AsInteger := Item.nIsEnforceRest;
  ADOQuery.FieldByName('strInputGUID').AsString := Item.strInputGUID;
  ADOQuery.FieldByName('dtPlanDate').AsDateTime := Item.dtPlanDate;
  ADOQuery.FieldByName('strKeHuo').AsString := Item.strKeHuo;
  ADOQuery.FieldByName('strStartStation').AsString := Item.strStartStation;
  ADOQuery.FieldByName('strEndStation').AsString := Item.strEndStation;
end;

procedure TDBPlan.CopyDataToObject(ADOQuery: TADOQuery; Item: TPlan);
{����:�����ݿ�����������}
begin
  Item.strGUID := ADOQuery.FieldByName('strGUID').AsString;
  Item.strTrainNo := ADOQuery.FieldByName('strTrainNo').AsString;
  Item.strSectionName := ADOQuery.FieldByName('strSectionName').AsString;
  Item.strJiaoLuNumber := ADOQuery.FieldByName('strJiaoLuNumber').AsString;
  Item.strCheZhanNumber := ADOQuery.FieldByName('strCheZhanNumber').AsString;
  Item.dtRestTime := ADOQuery.FieldByName('dtRestTime').AsDateTime;
  Item.dtCallTime := ADOQuery.FieldByName('dtCallTime').AsDateTime;
  Item.dtOutDutyTime := ADOQuery.FieldByName('dtOutDutyTime').AsDateTime;
  Item.dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime;
  Item.nTrainmanTypeID := ADOQuery.FieldByName('nTrainmanTypeID').AsInteger;
  Item.strAreaGUID := ADOQuery.FieldByName('strAreaGUID').AsString;
  Item.dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
  Item.strTrainType := ADOQuery.FieldByName('strTrainType').AsString;
  Item.strTrainNumber := ADOQuery.FieldByName('strTrainNumber').AsString;
  Item.strTrainmanGUID1 := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  Item.nTrainmanState1 := ADOQuery.FieldByName('nTrainmanState1').AsInteger;
  Item.strTrainmanGUID2 := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  Item.nTrainmanState2 := ADOQuery.FieldByName('nTrainmanState2').AsInteger;
  Item.nState := ADOQuery.FieldByName('nState').AsInteger;
  Item.nIsEnforceRest := ADOQuery.FieldByName('nIsEnforceRest').AsInteger;
  Item.strInputGUID := ADOQuery.FieldByName('strInputGUID').AsString;
  Item.dtPlanDate := ADOQuery.FieldByName('dtPlanDate').AsDateTime;
  Item.strKeHuo := ADOQuery.FieldByName('strKeHuo').AsString;
  Item.strStartStation := ADOQuery.FieldByName('strStartStation').AsString;
  Item.strEndStation := ADOQuery.FieldByName('strEndStation').AsString;
end;

procedure TDBPlan.DeletePlan(strPlanGUID: String);
{����:ɾ���ƻ���Ϣ}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  strSQLText := 'Delete from TAB_Plan_Record where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strPlanGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.ExecSQL;;
  finally
    ADOQuery.Free;
  end;
end;

class function TDBPlan.EditCallState(bCalled: Boolean; strGUID: string;
  ADOConn: TADOConnection): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'Select * from TAB_RestInWaiting_Plan  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strGUID)]);
      Open;
      if RecordCount > 0  then
      begin
        Edit;
        FieldByName('nCall').AsInteger := FieldByName('nCall').AsInteger + 1;
        FieldByName('bCalled').AsBoolean := bCalled;
        Post;
      end;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TDBPlan.EditRoomWaitingState(strGUID: string;
  callCount: integer;ADOConn : TADOConnection);
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'Select * from TAB_RoomWaiting_CallRecord  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strGUID)]);
      Open;
      if RecordCount > 0  then
      begin
        Edit;
        FieldByName('nCallCount').AsInteger := callCount;
        Post;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TDBPlan.GetBeginWorks(AreaGUID: string; planDate: TDateTime;
  out Rlt: TADOQuery; ADOConn: TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Sql.Text := 'select * from VIEW_RestInWaiting_InOutRoom where dtStartTime >= %s and strAreaGUID=%s and nState >=1  order by dtCallTime asc,strRoomNumber';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(planDate))),QuotedStr(AreaGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetCalls(AreaGUID:string;planDate: TDateTime; out Rlt: TADOQuery;
  ADOConn: TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Sql.Text := 'select * from VIEW_RestInWaiting_InOutRoom where dtStartTime >= %s and strAreaGUID=%s and nState >=1 and nIsEnforceRest > 0  order by dtCallTime asc,strRoomNumber';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(planDate))),QuotedStr(AreaGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetCallsByGUID(planGUID: string; out Rlt: TADOQuery;
  ADOConn:TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_InOutRoom where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

function TDBPlan.GetContainPlanDate(dtBeginDate,
  dtEndDate: TDateTime): TDateTimeArray;
{����:���һ��ʱ�����мƻ�������}
var
  i : Integer;
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  strSQLText := 'Select dtPlanDate from TAB_Plan_Record where dtPlanDate >= %s '+
      ' And dtPlanDate <= %s Group By dtPlanDate';

  strSQLText := Format(strSQLText,[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginDate)),
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndDate))]);

  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    SetLengTh(Result,ADOQuery.RecordCount);
    for I := 0 to ADOQuery.RecordCount - 1 do
    begin
      Result[i] := ADOQuery.Fields[0].AsDateTime;
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
  
end;

class procedure TDBPlan.GetNowCallTrainNos(AreaGUID : string;var TrainNos: TStrings;
  ADOConn: TADOConnection);
var
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from TAB_Plan_Record where dtStartTime >= %s and strAreaGUID=%s and nState >=1 and nIsEnforceRest > 0  order by strTrainNo';
      Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(Now))),QuotedStr(AreaGUID)]);
      Open;
      while not eof do
      begin
        TrainNos.Add(FieldByName('strTrainNo').AsString);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBPlan.GetNowPlanTrainNos(AreaGUID : string;var TrainNos: TStrings;
  ADOConn: TADOConnection);
var
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from TAB_Plan_Record where dtStartTime >= %s and strAreaGUID=%s and nState >=1  order by strTrainNo';
      Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(Now))),QuotedStr(AreaGUID)]);
      Open;
      while not eof do
      begin
        TrainNos.Add(FieldByName('strTrainNo').AsString);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBPlan.GetPlan(strPlanGUID: String; var Plan: TPlan): Boolean;
{����:��ȡ�ƻ���Ϣ}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Plan_Record where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strPlanGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      CopyDataToObject(ADOQuery,Plan);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TDBPlan.GetPlanByTrainNo(strTrainNo: String; nPlanState: Integer;
    strAreaGUID : String;var Plan:TPlan):Boolean;
{����:���ݳ��λ�üƻ�,�ڶ�������Ϊ�ƻ�״̬��
  �÷����Ὣ���ε���strCheCi,״̬С��nPlanState�ļƻ����򷵻������һ��}
{����:��ȡ�ƻ���Ϣ}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Plan_Record '+
      ' where strTrainNo = %s And nState < %d And strAreaGUID = %s '+
      ' order by dtRestTime ';

  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),nPlanState,
      QuotedStr(strAreaGUID)]);

  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      CopyDataToObject(ADOQuery,Plan);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;



function TDBPlan.GetPlanByTrainNo(strTrainNo:String;dtPlanDate:TDateTime;
    strAreaGUID:String;var Plan:TPlan):Boolean;
{����:���ݳ��λ�ȡ�ƻ���Ϣ}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Plan_Record where strTrainNo = %s '+
      ' And dtPlanDate >= %s And dtPlanDate <= %s And strAreaGUID = %s ';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),
      QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',StartOfTheDay(dtPlanDate))),
      QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',EndOfTheDay(dtPlanDate))),
      QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    CopyDataToObject(ADOQuery,Plan);
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Free;
  end;

end;


function TDBPlan.GetPlanByTrainmanGUID(strTrainmanGUID: String;
  nPlanState: Integer; Plan: TPlan): Boolean;
{����:���ݳ���ԱID��üƻ�,�ڶ�������Ϊ�ƻ�״̬��
  �÷����Ὣ����ԱID����strTrainmanGUID,״̬С��nPlanState�ļƻ����򷵻������һ��}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Plan_Record '+
      ' where (strTrainmanGUID1 = %s or strTrainmanGUID2 = %s)'+
      ' And nState < %d and ((getdate() <= dtOutDutyTime) or (dbo.GetDateString(getDate()) = dbo.GetDateString(dtOutDutyTime)))';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainmanGUID),
      QuotedStr(strTrainmanGUID),nPlanState]);
  ADOQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := m_ADOConnection;
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      CopyDataToObject(ADOQuery,Plan);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBPlan.GetPlanList(strAreaGUID: String; var PlanList: TPlanList);
{����:��ȡ�ƻ���Ϣ�б�}
var
  Item : TPlan;
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  strSQLText := 'Select * from TAB_Plan_Record where strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    while ADOQuery.Eof = False do
    begin
      Item := TPlan.Create;
      CopyDataToObject(ADOQuery,Item);
      PlanList.Add(Item);
    end;
  finally
    ADOQuery.Free;
  end;
end;

class procedure TDBPlan.GetPlanSignIn(PlanGUID, TrainmanGUID: string;
  out Rlt: TADOQuery;ADOConn : TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    SQL.Text := 'select top 1 * from VIEW_Plan_SignIn where strTrainmanGUID = %s and strPlanGUID=%s';
    SQL.Text := Format(SQL.Text,[QuotedStr(TrainmanGUID),QuotedStr(PlanGUID)]);
    Open;
  end;
end;

class function TDBPlan.GetTrainmanCallPlan(trainmanGUID: string;
  Plan: TPlan;ADOConn : TADOConnection): boolean;
var
  ado : TADOQuery;
begin
  Result := false;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      SQL.Text := 'select top 1 * from TAB_Plan_Record ' +
      ' where dbo.GetDateString(dtCallTime) >= dbo.GetDateString(getdate())  ' +
      ' and (((strTrainmanGUID1 =%s) and (nTrainmanState1>1) and (nTrainmanState1<4)) or ((strTrainmanGUID2=%s)  and (nTrainmanState2>1 ) and (nTrainmanState2<4 ))) ' +
      ' and (nState>0 and nState < 4) order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(trainmanGUID),QuotedStr(trainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result := true;
        Plan.strGUID := FieldByName('strGUID').AsString;
        Plan.strTrainNo := FieldByName('strTrainNo').AsString;
        Plan.dtStartTime := FieldByName('dtStartTime').AsDateTime;
        Plan.strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
        Plan.nTrainmanState1 := FieldByName('nTrainmanState1').AsInteger;
        Plan.strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
        Plan.nTrainmanState2 := FieldByName('nTrainmanState2').AsInteger;
        Plan.nState := FieldByName('nState').AsInteger;
      end;
    end;
  finally
    ado.Free
  end;
end;

class function TDBPlan.InRoom(strPlanGUID, strRoomNumber, strMainGUID: string;
  nMainVerify: Integer; strSubGUID: string; nSubVerify: Integer;ADOConn : TADOConnection;
  DutyUserGUID : string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'exec PROC_InRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(DutyUserGUID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(DutyUserGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.OutRoom(strPlanGUID, strRoomNumber, strMainGUID: string;
  nMainVerify: Integer; strSubGUID: string; nSubVerify: Integer;
  ADOConn: TADOConnection; DutyUserGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'exec PROC_OutRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(DutyUserGUID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(DutyUserGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

function TDBPlan.PlanExist(strPlanGUID: String):Boolean;
{����:�жϼƻ��Ƿ����}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select strGUID from TAB_Plan_Record where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strPlanGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Free;
  end;
end;

function TDBPlan.PlanExistByTrainNo(strTrainNo: String;dtPlanDate:TDateTime;
    strAreaGUID:String): Boolean;
{����:���ݳ����жϼƻ��Ƿ����}
{����:�жϼƻ��Ƿ����}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select strGUID from TAB_Plan_Record where strTrainNo = %s '+
      ' And dtPlanDate >= %s And dtPlanDate <= %s And strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),
      QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',StartOfTheDay(dtPlanDate))),
      QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',EndOfTheDay(dtPlanDate))),
      QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Free;
  end;
end;

class procedure TDBPlan.QueryPlan(AreaGUID, beginTime, endTime: string;bUnPlanTrain:boolean;
  out Rlt: TADOQuery; adoconn: TADOConnection);
var
  strSql : string;
begin
  Rlt := TADOQuery.Create(nil);
  strSql := 'select * from VIEW_Plan_Record where strAreaGUID=%s and dtStartTime >=%s and dtStartTime<=%s ';
  strSql := Format(strSql,[QuotedStr(AreaGUID),QuotedStr(beginTime),QuotedStr(endTime)]);
  if bUnPlanTrain then
  begin
    strSql := strSql + ' and ((strTrainType = '') and (strTrainNumber = ''))';
  end;
  strSql := strSql + ' order by dtStartTime';
  rlt.Connection := adoconn;
  rlt.SQL.Text := strSql;
  rlt.Open;
end;

procedure TDBPlan.SavePlan(Plan: TPlan);
{����:����ƻ���Ϣ}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  if Plan.strGUID = '' then
    Plan.strGUID := NewGUID();

  strSQLText := 'Select * from TAB_Plan_Record where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(Plan.strGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      if (ADOQuery.FieldByName('nIsEnforceRest').AsInteger > 0) and (plan.nIsEnforceRest = 0) then
      begin
        plan.nTrainmanState1 := 4;
        plan.nTrainmanState2 := 4;
        plan.nState := 4;
      end;
      if (ADOQuery.FieldByName('nIsEnforceRest').AsInteger = 0) and (plan.nIsEnforceRest > 0) then
      begin
        plan.nTrainmanState1 := 1;
        plan.nTrainmanState2 := 1;
        plan.nState := 1;
      end;
      ADOQuery.Edit;
    end
    else begin
      if plan.nIsEnforceRest = 0 then
      begin
        plan.nTrainmanState1 := 4;
        plan.nTrainmanState2 := 4;
        plan.nState := 4;
      end;    
      ADOQuery.Append;
    end;
    CopyDataToDB(ADOQuery,plan);
    ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBPlan.UpdatePlanState(strPlanGUID,strTrainmanGUID: String;
    nPlanState: Integer;nTrainmanIndex : integer);
{����:���¼ƻ�״̬}
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  strSQLText := 'Select * from TAB_Plan_Record where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strPlanGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      ADOQuery.Edit;

      if nTrainmanIndex = 0 then
      begin
        if Trim(ADOQuery.FieldByName('strTrainmanGUID1').AsString) = '' then
            ADOQuery.FieldByName('strTrainmanGUID1').AsString :=  strTrainmanGUID;

        if Trim(ADOQuery.FieldByName('strTrainmanGUID1').AsString) = strTrainmanGUID then
            ADOQuery.FieldByName('nTrainmanState1').AsInteger := nPlanState;
      end;

      if nTrainmanIndex = 1 then
      begin
        if Trim(ADOQuery.FieldByName('strTrainmanGUID2').AsString) = '' then
            ADOQuery.FieldByName('strTrainmanGUID2').AsString :=  strTrainmanGUID;

        if Trim(ADOQuery.FieldByName('strTrainmanGUID2').AsString) = strTrainmanGUID then
            ADOQuery.FieldByName('nTrainmanState2').AsInteger := nPlanState;
      end;

      if (ADOQuery.FieldByName('nTrainmanState1').AsInteger = nPlanState) And
         ((ADOQuery.FieldByName('nTrainmanTypeID').AsInteger = 1) or (ADOQuery.FieldByName('nTrainmanState2').AsInteger = nPlanState)) then
      begin
        ADOQuery.FieldByName('nState').AsInteger := nPlanState;
      end;
      ADOQuery.Post;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
