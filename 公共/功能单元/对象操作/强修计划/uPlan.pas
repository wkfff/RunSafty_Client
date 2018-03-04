unit uPlan;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,uTFSystem;
type

  RPlan = record
    strGUID : string;
    strTrainNo : string;
    dtSigninTime : TDateTime;
    dtCallTime : TDateTime;
    dtOutDutyTime : TDateTime;    
    dtStartTime : TDateTime;
    strMainDriverGUID : string;
    nMainDriverState : Integer;
    strSubDriverGUID : string;
    nSubDriverState :Integer;
    strInputGUID : string;
    dtInputTime : TDateTime;
    nState : Integer;
    nTrainmanTypeID : Integer;
    strAreaGUID : string;
    public
  procedure Init;
  end;
  TPlanOpt = class
  public
    {����:���¼ƻ�����ID}
    class procedure UpdatePlanWorkID(strPlanGUID,strWorkID:String);
    //��ѯָ�����ڷ�Χ�ڼƻ���Ϣ
    class function QueryPlan(beginDate,endDate : TDateTime;areaGUID : string) : TADOQuery;
    //����Աǩ��
    class function Signin(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
    //��ȡ���еļƻ�
    class function GetPlans(planDate : TDateTime) : TADOQuery;
    //��ȡû�����ƻ��ĳ���
    class function GetAllCanEditPlans(areaGUID : string ;planDate : TDateTime ) : TADOQuery;
    //��ȡָ��GUID�ļƻ�
    class function GetPlan(planGUID : string): RPlan;
    {����:���ݳ���ԱID��üƻ�}
    class function GetPlanByTrainmaGUID(strTrainmanGUID:String ;
        var Plan:RPlan):Boolean;
    //��Ӽƻ�
    class function AddPlan(plan:RPlan) : boolean;
    //�޸ļƻ�
    class function EditPlan(plan:RPlan) : boolean;
    //ɾ���ƻ�
    class function DeletePlan(planGUID : string) : boolean;
    //��ȡ����Ա�Ĵ���ƻ�
    class function GetTrainmanPlan(strTrainmanGUID:string ;
        var Plan:RPlan) : Boolean;
    //�Ƿ���ڳ���Ա�Ĵ���ƻ�
    class function ExistTrainmanPlan(strTrainmanGUID : string) : Boolean;

    //��ȡָ�����ε�ǩ����Ϣ
    class function GetSigninByTrainNo(trainNo : string ;planDate : TDateTime) : TADOQuery;
    //��ȡָ���ƻ���GUID��ǩ����Ϣ
    class function GetSigninByGUID(planGUID : string) : TADOQuery;
    
    //��ȡ��ǰ��Ҫ�а�ļƻ���Ϣ
    class function GetCalls(planDate : TDateTime) : TADOQuery;
    //��ȡָ�����ε�ǩ����Ϣ
    class function GetCallsByTrainNo(trainNo : string ;planDate : TDateTime) : TADOQuery;
    //��ȡָ���ƻ���GUID��ǩ����Ϣ
    class function GetCallsByGUID(planGUID : string) : TADOQuery;
    //����Ա��Ԣ
    class function InRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
    //����Ա��Ԣ
    class function OutRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
     //��ȡ����Ա���ڼƻ���״̬
    class function GetTrainmanCall(strTrainmanGUID : string) : TADOQuery;
    //��ȡ����Ա���ڼƻ���״̬
    class function GetTrainmanPlanState(strTrainmanGUID : string) : RPlan;

    //��ȡ��ǰ��Ҫ���ڵļƻ���Ϣ
    class function GetOutDuty(planDate : TDateTime) : TADOQuery;
    //��ȡ����Ա���ڳ��ڵ�״̬
    class function GetTrainmanOutDuties(strTrainmanGUID : string) : TADOQuery;
    //��ȡ����Ա���ڳ��ڵ���Ϣ
    class function GetTrainmanOutDuty(strTrainmanGUID : string) : RPlan;
    //��ȡָ�����εĳ�����Ϣ
    class function GetOutDutyByTrainNo(trainNo : string ;planDate : TDateTime) : TADOQuery;
    //��ȡָ���ƻ���GUID�ĳ�����Ϣ
    class function GetOutDutyByGUID(planGUID : string) : TADOQuery;
    //����Ա����
    class function OutDuty(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
    //�޸Ľа��־
    class function EditCallState(bCalled:Boolean;strGUID:string) : boolean;
  end;
implementation

{ TPlan }
uses
  uGlobalDM, DB;
class function TPlanOpt.GetPlan(planGUID: string): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text ,[QuotedStr(planGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin
          strGUID := FieldByName('strGUID').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          dtSigninTime := FieldByName('dtSigninTime').AsDateTime;
          dtCallTime := FieldByName('dtCallTime').AsDateTime;
          dtOutDutyTime := FieldByName('dtOutDutyTime').AsDateTime;
          dtStartTime := FieldByName('dtStartTime').AsDateTime;
          strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
          nMainDriverState := FieldByName('nMainDriverState').AsInteger;
          strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
          nSubDriverState := FieldByName('nSubDriverState').asInteger;
          strInputGUID := FieldByName('strInputGUID').AsString;
          dtInputTime := FieldByName('dtInputTime').AsDateTime;
          nState := FieldByName('nState').AsInteger;
          nTrainmanTypeID := FieldByName('nTrainmanTypeID').AsInteger;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TPlanOpt.GetPlanByTrainmaGUID(strTrainmanGUID: String;
  var Plan: RPlan): Boolean;
{����:���ݳ���ԱID��üƻ�}
var
  ado : TADOQuery;
begin
  Result := False;
  Plan.Init;
  Ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where '+
          ' (strMainDriverGUID = %s or strSubDriverGUID = %s) And '+
          ' (strWorkGUID is null)';
      Sql.Text := Format(Sql.Text ,[QuotedStr(strTrainmanGUID),
          QuotedStr(strTrainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result := True;
        with Plan do
        begin
          strGUID := FieldByName('strGUID').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          dtSigninTime := FieldByName('dtSigninTime').AsDateTime;
          dtCallTime := FieldByName('dtCallTime').AsDateTime;
          dtOutDutyTime := FieldByName('dtOutDutyTime').AsDateTime;
          dtStartTime := FieldByName('dtStartTime').AsDateTime;
          strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
          nMainDriverState := FieldByName('nMainDriverState').AsInteger;
          strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
          nSubDriverState := FieldByName('nSubDriverState').asInteger;
          strInputGUID := FieldByName('strInputGUID').AsString;
          dtInputTime := FieldByName('dtInputTime').AsDateTime;
          nState := FieldByName('nState').AsInteger;
          nTrainmanTypeID := FieldByName('nTrainmanTypeID').AsInteger;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
        end;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class function TPlanOpt.GetSigninByGUID(planGUID: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_Plan where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class function TPlanOpt.GetSigninByTrainNo(trainNo: string;
  planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_Plan where dbo.getdatestring(dtCallTime) >= %s and strAreaGUID=%s and strTrainNo = %s order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID),QuotedStr(trainNo)]);
    try
      Open;
    except
      Result.Free;
    end;

  end;
end;

class function TPlanOpt.GetPlans(planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select * from VIEW_RestInWaiting_Plan where dbo.getdatestring(dtStartTime) >= %s and strAreaGUID=%s and nState >=1 order by nState,dtStartTime';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID)]);
    Open;
  end;

end;

class function TPlanOpt.GetTrainmanCall(strTrainmanGUID: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Call ' +
    ' where ((strMainDriverGUID =%s) and (nMainDriverState>1) and (nMainDriverState<4)) or ((strSubDriverGUID=%s)  and (nSubDriverState>1 ) and (nSubDriverState<4 )) and (nState>1 and nState < 4) order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
    Open;
  end;
end;

class function TPlanOpt.GetTrainmanOutDuties(
  strTrainmanGUID: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    SQL.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty ' +
    ' where ((strMainDriverGUID =%s) and (nMainDriverState>3) and (nMainDriverState<5)) or ((strSubDriverGUID=%s)  and (nSubDriverState>3 ) and (nSubDriverState<5 )) and (nState>3 and nState < 5) order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
    Open;
  end;

end;

class function TPlanOpt.GetTrainmanOutDuty(strTrainmanGUID: string): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty ' +
        ' where ((strMainDriverGUID =%s) and (nMainDriverState>3) and (nMainDriverState<5)) or ((strSubDriverGUID=%s)  and (nSubDriverState>3 ) and (nSubDriverState<5 )) and (nState>3 and nState < 5) order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strTrainNo := FieldByName('strTrainNo').AsString;
        Result.dtStartTime := FieldByName('dtStartTime').AsDateTime;
        Result.strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
        Result.nMainDriverState := FieldByName('nMainDriverState').AsInteger;
        Result.strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
        Result.nSubDriverState := FieldByName('nSubDriverState').AsInteger;
        Result.nState := FieldByName('nState').AsInteger;
      end;
    end;
  finally
    ado.Free
  end;

end;

class function TPlanOpt.GetTrainmanPlan(strTrainmanGUID:string ;
    var Plan:RPlan): Boolean;
var
  strSQLText : String;
  ADOQuery : TADOQuery;
begin
  Result := False;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := GlobalDM.ADOConnection;
    strSQLText := 'select top 1 * from VIEW_RestInWaiting_Plan where '+
          '((strMainDriverGUID = %s) and (nMainDriverState = 2)) or '+
          '((strSubDriverGUID = %s)  and (nSubDriverState = 2)) '+
          'And nState = 1 Order by dtStartTime desc';

    strSQLText :=
        Format(strSQLText,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);

    ADOQuery.SQL.Text := strSQLText;

    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      Plan.strGUID := ADOQuery.FieldByName('strGUID').AsString;
      Plan.strTrainNo := ADOQuery.FieldByName('strTrainNo').AsString;
      Plan.dtSigninTime := ADOQuery.FieldByName('dtSigninTime').AsDateTime;
      Plan.dtCallTime := ADOQuery.FieldByName('dtCallTime').AsDateTime;
      Plan.dtOutDutyTime := ADOQuery.FieldByName('dtOutDutyTime').AsDateTime;
      Plan.dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime;
      Plan.strMainDriverGUID := ADOQuery.FieldByName('strMainDriverGUID').AsString;
      Plan.nMainDriverState := ADOQuery.FieldByName('nMainDriverState').AsInteger;
      Plan.strSubDriverGUID := ADOQuery.FieldByName('strSubDriverGUID').AsString;
      Plan.nSubDriverState := ADOQuery.FieldByName('nSubDriverState').asInteger;
      Plan.strInputGUID := ADOQuery.FieldByName('strInputGUID').AsString;
      Plan.dtInputTime := ADOQuery.FieldByName('dtInputTime').AsDateTime;
      Plan.nState := ADOQuery.FieldByName('nState').AsInteger;
      Plan.nTrainmanTypeID := ADOQuery.FieldByName('nTrainmanTypeID').AsInteger;
      Plan.strAreaGUID := ADOQuery.FieldByName('strAreaGUID').AsString;
      Result := True;
    end;
  finally
    ADOQuery.Close;
    ADOQuery.Free;
  end;
end;

class function TPlanOpt.GetTrainmanPlanState(strTrainmanGUID: string): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Call ' +
      ' where ((strMainDriverGUID =%s) and (nMainDriverState>1) and (nMainDriverState<4)) or ((strSubDriverGUID=%s)  and (nSubDriverState>1 ) and (nSubDriverState<4 )) and (nState>1 and nState < 4) order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strTrainNo := FieldByName('strTrainNo').AsString;
        Result.dtStartTime := FieldByName('dtStartTime').AsDateTime;
        Result.strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
        Result.nMainDriverState := FieldByName('nMainDriverState').AsInteger;
        Result.strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
        Result.nSubDriverState := FieldByName('nSubDriverState').AsInteger;
        Result.nState := FieldByName('nState').AsInteger;        
      end;
    end;
  finally
    ado.Free
  end;
end;

class function TPlanOpt.InRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'exec PROC_InRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(g_strUserID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(g_strUserID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TPlanOpt.OutDuty(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'exec PROC_OutDuty %s,%s,%d,%s,%d,%s,%d,%s,%d';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(g_strUserID),nMainDrinkResult,
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(g_strUserID),nSubDrinkResult]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TPlanOpt.OutRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'exec PROC_OutRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(g_strUserID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(g_strUserID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;end;

class function TPlanOpt.QueryPlan(beginDate, endDate: TDateTime;areaGUID : string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := GlobalDM.ADOConnection;
  Result.SQL.Text := 'select * from VIEW_RestInWaiting_Plan where strAreaGUID=%s and dtSigninTime >= %s and dtSigninTime <=%s order by dtSigninTime desc';
  Result.SQL.Text := Format(Result.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  Result.Open;
end;

class function TPlanOpt.Signin(strTrainmanGUID: string ;strMainGUID :string;
  nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'exec PROC_Signin %s,%s,%d,%s,%d,%s,%d,%s,%d';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(g_strUserID),nMainDrinkResult,
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(g_strUserID),nSubDrinkResult]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TPlanOpt.UpdatePlanWorkID(strPlanGUID, strWorkID: String);
{����:���¼ƻ�����ID}
var
  ADOQuery : TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := GlobalDM.ADOConnection;
    ADOQuery.SQL.Text := 'Update TAB_RestInWaiting_Plan set strWorkGUID = '+
        QuotedStr(strWorkID)+' where strGUID = '+QuotedStr(strPlanGUID);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;

end;

class function TPlanOpt.AddPlan(plan: RPlan): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where 1=2';
      Open;
      Append;
      FieldByName('strGUID').AsString := NewGUID;
      FieldByName('strTrainNo').AsString := plan.strTrainNo;
      FieldByName('dtSigninTime').AsDateTime := plan.dtSigninTime;
      FieldByName('dtCallTime').AsDateTime := plan.dtCallTime;
      FieldByName('dtOutDutyTime').AsDateTime := plan.dtOutDutyTime;
      FieldByName('dtStartTime').AsDateTime := plan.dtStartTime;
      FieldByName('strMainDriverGUID').AsString := plan.strMainDriverGUID;
      FieldByName('nMainDriverState').AsInteger := plan.nMainDriverState;
      FieldByName('strSubDriverGUID').AsString := plan.strSubDriverGUID;
      FieldByName('nSubDriverState').asInteger := plan.nSubDriverState;
      FieldByName('strInputGUID').AsString := plan.strInputGUID;
      FieldByName('dtInputTime').AsDateTime := plan.dtInputTime;
      FieldByName('nState').AsInteger := 1;
      FieldByName('nTrainmanTypeID').AsInteger := plan.nTrainmanTypeID;
      FieldByName('strAreaGUID').AsString := plan.strAreaGUID;
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TPlanOpt.DeletePlan(planGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'delete from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

function BooleanToInt(bValue:Boolean):Integer;
begin
   Result := 0;
   if bValue then
    Result := 1;
end;
class function TPlanOpt.EditCallState(bCalled:Boolean;strGUID:string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
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

class function TPlanOpt.EditPlan(plan: RPlan): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(plan.strGUID)]);
      Open;
      Edit;
      FieldByName('strMainDriverGUID').AsString := plan.strMainDriverGUID;
      FieldByName('strSubDriverGUID').AsString := plan.strSubDriverGUID;
      FieldByName('dtSigninTime').AsDateTime := plan.dtSigninTime;
      FieldByName('dtCallTime').AsDateTime := plan.dtCallTime;
      FieldByName('dtOutDutyTime').AsDateTime := plan.dtOutDutyTime;
      FieldByName('dtStartTime').AsDateTime := plan.dtStartTime;
      FieldByName('nTrainmanTypeID').AsInteger := plan.nTrainmanTypeID;
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TPlanOpt.ExistTrainmanPlan(strTrainmanGUID: string): Boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConnection;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Plan where ((strMainDriverGUID =%s) and (nMainDriverState=1)) or ((strSubDriverGUID=%s)  and (nSubDriverState=1)) and nState=1 order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free
  end;
end;

class function TPlanOpt.GetAllCanEditPlans(areaGUID : string ;planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'exec PROC_GetPlans %s,%s';
    Sql.Text := Format(Sql.Text ,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd',planDate))]);
    Open;
  end;
end;

class function TPlanOpt.GetCalls(planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select * from VIEW_RestInWaiting_InOutRoom where dbo.getdatestring(dtStartTime) >= %s and strAreaGUID=%s and nState >=1 order by dtCallTime,strRoomNumber';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID)]);
    Open;
  end;
end;

class function TPlanOpt.GetCallsByGUID(planGUID: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_InOutRoom where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class function TPlanOpt.GetCallsByTrainNo(trainNo: string;
  planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_InOutRoom where dbo.getdatestring(dtCallTime) >= %s and strAreaGUID=%s and nState >=1 and strTrainNo = %s order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID),QuotedStr(trainNo)]);
    Open;
  end;
end;

class function TPlanOpt.GetOutDuty(planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select * from VIEW_RestInWaiting_OutDuty where dbo.getdatestring(dtStartTime) >= %s and strAreaGUID=%s and (nState >=1 ) order by nState,dtStartTime';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID)]);
    Open;
  end;

end;

class function TPlanOpt.GetOutDutyByGUID(planGUID: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class function TPlanOpt.GetOutDutyByTrainNo(trainNo: string;
  planDate: TDateTime): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  with Result do
  begin
    Connection := GlobalDM.ADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty where dbo.getdatestring(dtCallTime) >= %s and strAreaGUID=%s and nState >=1 and strTrainNo = %s order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(GlobalDM.LocalAreaGUID),QuotedStr(trainNo)]);
    Open;
  end;
end;

{ RPlan }

procedure RPlan.Init;
begin
  strGUID := '';
  strTrainNo := '';
  dtStartTime := 0;
  strMainDriverGUID :='';
  nMainDriverState := 0;
  strSubDriverGUID := '';
  nSubDriverState := 0;
  strInputGUID := '';
  dtInputTime := 0;
  nState := 0;
  dtCallTime := 0;
  nTrainmanTypeID := 2;
  strAreaGUID := '';
end;

end.
