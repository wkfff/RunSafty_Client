unit uRsDBLocalPlan;

interface
uses
  Classes,ADODB,DB,uTFSystem,uTrainPlan,uRsLocalDataDefine,SysUtils,uSaftyEnum;
type
  TRsDBLocalPlan = class(TDBOperate)
  private
    procedure ADOQueryToServerPlan(ADOQuery: TADOQuery;Plan: TRsServerPlan);
  public
    procedure SignLocalPlan(strTrainPlanGUID: string);
    procedure LoadLocalPlan(LocalPlanList: TRsLocalPlanList);
    procedure LoadServerPlan(SiteGUID: string;ServerPlanList: TRsServerPlanList);
    function LoadServerPlanByGUID(strPlanGUID: string;Plan: TRsServerPlan): Boolean;
  end;
implementation

{ TDBLocalPlan }

procedure TRsDBLocalPlan.ADOQueryToServerPlan(ADOQuery: TADOQuery;
  Plan: TRsServerPlan);
begin
  Plan.strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
  Plan.strTrainNo := ADOQuery.FieldByName('strTrainNo').AsString;
  Plan.dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime;
  Plan.nPlanState := ADOQuery.FieldByName('nPlanState').AsInteger;
  Plan.dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
  Plan.strGroupGUID := ADOQuery.FieldByName('strGroupGUID').AsString;
  Plan.strTrainJiaoluGUID := ADOQuery.FieldByName('strTrainJiaoluGUID').AsString;
  Plan.strTrainmanGUID1 := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  Plan.strTrainmanNumber1 := ADOQuery.FieldByName('strTrainmanNumber1').AsString;
  Plan.strTrainmanName1 := ADOQuery.FieldByName('strTrainmanName1').AsString;

  Plan.strTrainmanGUID2 := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  Plan.strTrainmanNumber2 := ADOQuery.FieldByName('strTrainmanNumber2').AsString;
  Plan.strTrainmanName2 := ADOQuery.FieldByName('strTrainmanName2').AsString;

  Plan.strTrainmanGUID3 := ADOQuery.FieldByName('strTrainmanGUID3').AsString;
  Plan.strTrainmanNumber3 := ADOQuery.FieldByName('strTrainmanNumber3').AsString;
  Plan.strTrainmanName3 := ADOQuery.FieldByName('strTrainmanName3').AsString;
  Plan.strTrainJiaoLuName := ADOQuery.FieldByName('strTrainJiaoLuName').AsString;

end;

procedure TRsDBLocalPlan.LoadLocalPlan(LocalPlanList: TRsLocalPlanList);
var
  ADOQuery: TADOQuery;
  LocalPlan: TRsLocalPlan;
begin
  LocalPlanList.Clear;
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'select * from VIEW_Plan_Trainman where nPlanState > 3 and (nFlag is null or nFlag = 0) order by dtStartTime';
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LocalPlan := TRsLocalPlan.Create;
      LocalPlan.nID := ADOQuery.FieldByName('nID').AsInteger;
      LocalPlan.strTrainPlanGUID := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
      LocalPlan.strTrainNo := ADOQuery.FieldByName('strTrainNo').AsString;
      LocalPlan.dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime;
      LocalPlan.dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      LocalPlan.strTrainmanGUID1 := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
      LocalPlan.strTrainmanGUID2 := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
      LocalPlan.strTrainmanGUID3 := ADOQuery.FieldByName('strTrainmanGUID3').AsString;

      LocalPlan.strTrainmanNumber1 := ADOQuery.FieldByName('strTrainmanNumber1').AsString;
      LocalPlan.strTrainmanNumber2 := ADOQuery.FieldByName('strTrainmanNumber2').AsString;
      LocalPlan.strTrainmanNumber3 := ADOQuery.FieldByName('strTrainmanNumber3').AsString;

      LocalPlan.strTrainmanName1 := ADOQuery.FieldByName('strTrainmanName1').AsString;
      LocalPlan.strTrainmanName2 := ADOQuery.FieldByName('strTrainmanName2').AsString;
      LocalPlan.strTrainmanName3 := ADOQuery.FieldByName('strTrainmanName3').AsString;
      
      LocalPlan.nPlanState := ADOQuery.FieldByName('nPlanState').AsInteger;
      LocalPlanList.Add(LocalPlan);


      ADOQuery.Next; 
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBLocalPlan.LoadServerPlan(SiteGUID: string;ServerPlanList: TRsServerPlanList);
var
  strSql : string;
  ADOQuery : TADOQuery;
  ServerPlan: TRsServerPlan;
begin
  ServerPlanList.Clear;
  strSql := 'select * from VIEW_Plan_Trainman where ' +
  ' (nPlanState in (%d,%d,%d))';
  strSql := Format(strSql,[Ord(psPublish),Ord(psReceive),Ord(psBeginWork)]);

  strSql := strSql + ' and (strTrainJiaoluGUID in (select strTrainJiaoLuGUID from tab_base_TrainJiaoLuInSite where strSiteGUID = %s ' +
  ' union ' +
  ' select strSubTrainJiaoLuGUID as strTrainJiaoLuGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoLuGUID in ' +
  ' (select strTrainJiaoLuGUID from tab_base_TrainJiaoLuInSite where strSiteGUID = %s)) ) ';
  strSql := Format(strSql,[QuotedStr(SiteGUID),QuotedStr(SiteGUID)]);

  strSql := strSql + ' order by dtStartTime,nID Desc ';
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := strSql;
    ADOQuery.Open;

    while not ADOQuery.Eof do
    begin
      ServerPlan := TRsServerPlan.Create;
      ADOQueryToServerPlan(ADOQuery,ServerPlan);
      ServerPlanList.Add(ServerPlan);
      ADOQuery.Next;
    end;

  finally
    adoQuery.Free;
  end;

end;

function TRsDBLocalPlan.LoadServerPlanByGUID(strPlanGUID: string;
  Plan: TRsServerPlan): Boolean;
var
  strSql : string;
  ADOQuery : TADOQuery;
  ServerPlan: TRsServerPlan;
begin
  strSql := 'select * from VIEW_Plan_Trainman where ' +
  ' (nPlanState in (%d,%d,%d)) and strTrainPlanGUID = %s';
  strSql := Format(strSql,[Ord(psPublish),Ord(psReceive),Ord(psBeginWork),
    QuotedStr(strPlanGUID)]);


  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := strSql;
    ADOQuery.Open;
    Result := ADOQuery.RecordCount > 0;
    
    if Result then
    begin
      ADOQueryToServerPlan(ADOQuery,Plan);
    end;

  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBLocalPlan.SignLocalPlan(strTrainPlanGUID: string);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'Update TAB_Plan_Train set nFlag = 1 where strTrainPlanGUID = '
      + QuotedStr(strTrainPlanGUID);

    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
  
end;

end.
