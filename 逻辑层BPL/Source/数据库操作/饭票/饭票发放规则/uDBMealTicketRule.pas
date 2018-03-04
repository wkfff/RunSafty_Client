unit uDBMealTicketRule;

interface

uses
  SysUtils,Classes,DB,ADODB,utfsystem,uMealTicketRule,uTrainmanJiaolu,DateUtils;

type
  //饭票发放规则数据库操作类
  TRsDBMealTicketRule = class(TDBOperate)
  public
    //根据饭票人员信息获取饭票张数
    function GetTicket(MealTicketPersonInfo:RRsMealTicketPersonInfo;var CanQuanA,CanQuanB:Integer):Boolean;
  public
    {规则信息}
    //查询规则
    procedure QueryRule(WorkShopGUID:string;AType :TRsJiaoluType;out MealTicketRuleList: TRsMealTicketRuleList);
    //增加规则
    function  AddRule(MealTicketRule: RRsMealTicketRule):Boolean;
    //删除规则
    function  DeleteRule(RuleGUID:string):Boolean;
    //修改规则
    function  ModifyRule(RuleGUID:string;MealTicketRule: RRsMealTicketRule):Boolean;
  public
    {车次信息}
    //根据RULE的GUID查询下面的所有车次
    procedure QueryCheCiInfo(RuleGUID:string;out CheCiList:TRsMealTicketCheCiList);
    //增加
    function  AddCheCiInfo(CheCiInfo:RRsMealTicketCheCi):Boolean;
    //删除
    function  DeleteChiCiInfo(CheCiGUID:string):Boolean;
    //修改
    function ModifyCheCiInfo(CheCiGUID:string;CheCiInfo:RRsMealTicketCheCi):Boolean;
  private
    //饭票规则->ado
    procedure RuleDataToAdo(AdoQuery:TADOQuery;MealTicketRule: RRsMealTicketRule);
    //ADO->饭票规则
    procedure AdoToRuleData(AdoQuery:TADOQuery;var MealTicketRule: RRsMealTicketRule);

    //车次->ado
    procedure CheCiDataToAdo(AdoQuery:TADOQuery;CheCiInfo:RRsMealTicketCheCi);
    //ado->车次
    procedure AdoToCheCiData(AdoQuery:TADOQuery;var CheCiInfo:RRsMealTicketCheCi);
  end;

implementation

{ TRsDBMealTicketRule }

function TRsDBMealTicketRule.AddCheCiInfo(
  CheCiInfo: RRsMealTicketCheCi): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      Sql.Text := 'select * from  Tab_MealTicket_CheCi where 1 = 2 ' ;
      Open;
      Append;
      CheCiDataToAdo(ado,CheCiInfo);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

function TRsDBMealTicketRule.AddRule(
  MealTicketRule: RRsMealTicketRule): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      Sql.Text := 'select * from  Tab_MealTicket_Rule where 1 = 2 ' ;
      Open;
      Append;
      RuleDataToAdo(ado,MealTicketRule);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBMealTicketRule.AdoToCheCiData(AdoQuery: TADOQuery;
  var CheCiInfo: RRsMealTicketCheCi);
begin
  with AdoQuery do
  begin
    CheCiInfo.strWorkShopGUID :=   FieldByName('strWorkShopGUID').AsString ;
    CheCiInfo.iType :=  FieldByName('iType').AsInteger ;
    CheCiInfo.strQuDuan :=   FieldByName('strQuDuan').AsString ;
    CheCiInfo.strRuleGUID := FieldByName('strRuleGUID').AsString;
    CheCiInfo.strGUID := FieldByName('strGUID').AsString;
    CheCiInfo.strCheCi := FieldByName('strCheCi').AsString;
    CheCiInfo.dtStartTime := FieldByName('dtStartTime').AsDateTime;
    CheCiInfo.dtEndTime := FieldByName('dtEndTime').AsDateTime;
  end;
end;

procedure TRsDBMealTicketRule.AdoToRuleData(AdoQuery: TADOQuery;
  var MealTicketRule: RRsMealTicketRule);
begin
  with AdoQuery do
  begin
    MealTicketRule.strName :=  FieldByName('strName').AsString;
    MealTicketRule.strGUID := FieldByName('strGUID').AsString ;
    MealTicketRule.strWorkShopGUID :=  FieldByName('strWorkShopGUID').AsString;
    MealTicketRule.iA := FieldByName('iA').AsInteger;
    MealTicketRule.iB := FieldByName('iB').AsInteger;
    MealTicketRule.iType := FieldByName('iType').AsInteger;
  end;
end;

procedure TRsDBMealTicketRule.CheCiDataToAdo(AdoQuery: TADOQuery;
  CheCiInfo: RRsMealTicketCheCi);
begin
  with AdoQuery do
  begin
    FieldByName('strWorkShopGUID').AsString :=  CheCiInfo.strWorkShopGUID ;
    FieldByName('iType').AsInteger :=  CheCiInfo.iType ;
    FieldByName('strQuDuan').AsString :=  CheCiInfo.strQuDuan ;
    FieldByName('strRuleGUID').AsString := CheCiInfo.strRuleGUID;
    FieldByName('strGUID').AsString := CheCiInfo.strGUID;
    FieldByName('strCheCi').AsString := CheCiInfo.strCheCi;
    FieldByName('dtStartTime').AsDateTime := CheCiInfo.dtStartTime ;
    FieldByName('dtEndTime').AsDateTime := CheCiInfo.dtEndTime  ;
  end;
end;

function TRsDBMealTicketRule.DeleteChiCiInfo(CheCiGUID: string): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      Sql.Text := 'delete from  Tab_MealTicket_CheCi where strGUID = ' + QuotedStr(CheCiGUID) ;
      ExecSQL;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

function TRsDBMealTicketRule.DeleteRule(RuleGUID: string): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      //删除下属的所有车次
      Sql.Text := 'delete from  Tab_MealTicket_CheCi where strRuleGUID = ' + QuotedStr(RuleGUID) ;
      ExecSQL;

      Sql.Text := 'delete from  Tab_MealTicket_Rule where strGUID = ' + QuotedStr(RuleGUID) ;
      ExecSQL;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

function TRsDBMealTicketRule.GetTicket(MealTicketPersonInfo:RRsMealTicketPersonInfo; var CanQuanA,
  CanQuanB: Integer): Boolean;
label
  lbOk;
var
  ado : TADOQuery;
  strSql:string;
  strQuDuan:string;
  dtPaiBanTime:TDateTime;
  strCheCi:string;
begin
  Result := False ;
  ado := NewADOQuery;
  strQuDuan := MealTicketPersonInfo.strQuDuan ;
  strCheCi := MealTicketPersonInfo.strCheCi ;
  dtPaiBanTime := MealTicketPersonInfo.dtPaiBan ;
  try

    with ado do
    begin

      //检查是是否有指定车次或者指定区段
      strSql := Format(' ( select top 1 strRuleGUID from Tab_MealTicket_CheCi where ( strCheCi = %s  or strQuDuan = %s )   and ( %s between dtStartTime and dtEndTime ) and strWorkShopGUID = %s  )',
        [QuotedStr(strCheCi),QuotedStr(strQuDuan),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtPaiBanTime)),QuotedStr(MealTicketPersonInfo.strWorkShopGUID)]);
      strSql := Format('select iA,iB from  Tab_MealTicket_Rule where strGUID = %s',[strSql]);
      Sql.Text := strSql ;
      Open;
      if IsEmpty then
      begin
        Close;

        //检查是否有通用车次
        strSql := Format(' ( select top 1 strRuleGUID from Tab_MealTicket_CheCi where  ( strQuDuan = '''' )and ( strCheCi = '''' ) and ( %s between dtStartTime and dtEndTime ) and strWorkShopGUID = %s   )',
          [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtPaiBanTime)),QuotedStr(MealTicketPersonInfo.strWorkShopGUID)]);
        strSql := Format('select iA,iB from  Tab_MealTicket_Rule where strGUID = %s',[strSql]);
        Sql.Text := strSql ;
        Open;
        if IsEmpty then
          Exit
        else
          goto
           lbOk;
        Exit;

      end;
lbOk:
      CanQuanA := ado.FieldByName('iA').AsInteger ;
      CanQuanB := ado.FieldByName('iB').AsInteger ;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
  Result := True ;
end;

function TRsDBMealTicketRule.ModifyCheCiInfo(CheCiGUID: string;
  CheCiInfo: RRsMealTicketCheCi): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      Sql.Text := 'select * from  Tab_MealTicket_CheCi where strGUID = ' + QuotedStr(CheCiGUID) ;
      Open;
      Edit;
      CheCiDataToAdo(ado,CheCiInfo);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

function TRsDBMealTicketRule.ModifyRule(RuleGUID: string;
  MealTicketRule: RRsMealTicketRule): Boolean;
var
  ado : TADOQuery;
begin
  Result := False ;
  ado := NewADOQuery;
  try
    with ado do
    begin
      Sql.Text := 'select * from  Tab_MealTicket_Rule where strGUID = ' + QuotedStr(RuleGUID) ;
      Open;
      Edit;
      RuleDataToAdo(ado,MealTicketRule);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBMealTicketRule.QueryCheCiInfo(RuleGUID: string;
  out CheCiList: TRsMealTicketCheCiList);
var
  ado : TADOQuery;
  i:Integer ;
  strText:string;
begin
  ado := NewADOQuery;
  try
    with ado do
    begin
      strText := Format('SELECT * from Tab_MealTicket_CheCi where strRuleGUID = %s ',[
        QuotedStr(RuleGUID)]);
      Sql.Text := strText;
      Open;
      if RecordCount <= 0 then
        Exit;
      i := 0 ;
      SetLength(CheCiList,RecordCount);
      while not eof do
      begin
        AdoToCheCiData(ado,CheCiList[i]);
        Next;
        Inc(i);
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBMealTicketRule.QueryRule(WorkShopGUID: string;AType :TRsJiaoluType;
  out MealTicketRuleList: TRsMealTicketRuleList);
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
      strText := Format('SELECT * from Tab_MealTicket_Rule where strWorkShopGUID = %s and iType = %d',[
        QuotedStr(WorkShopGUID),ord(atype)]);
      Sql.Text := strText;
      Open;
      if RecordCount <= 0 then
        Exit;
      i := 0 ;
      SetLength(MealTicketRuleList,RecordCount);
      while not eof do
      begin
        AdoToRuleData(ado,MealTicketRuleList[i]);
        Next;
        Inc(i);
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBMealTicketRule.RuleDataToAdo(AdoQuery: TADOQuery;
  MealTicketRule: RRsMealTicketRule);
begin
  with AdoQuery do
  begin
    FieldByName('strName').AsString := MealTicketRule.strName;
    FieldByName('strGUID').AsString := MealTicketRule.strGUID;
    FieldByName('strWorkShopGUID').AsString := MealTicketRule.strWorkShopGUID;
    FieldByName('iA').AsInteger := MealTicketRule.iA;
    FieldByName('iB').AsInteger := MealTicketRule.iB;
    FieldByName('iType').AsInteger := MealTicketRule.iType;
  end;
end;

end.
