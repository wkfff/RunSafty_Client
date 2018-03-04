unit uDBKeyTrainman;

interface
uses SysUtils,ADODB,uTFSystem,uKeyTrainman,StrUtils;
const
  CS_Table_KeyTrainman = 'tab_keyTrainman';
  CS_Table_KeyTrainman_His = 'tab_keyTrainman_His';
type

  //查询条件
  RDBKeyTM_QC = record
    //车间编号
    strWorkShopGUID:string;
    //车队编号
    strCheDuiGUID:string;
    //关键人工号
    strKeyTMNumber:string;
    //关键人姓名
    strKeyTMName:string;
    //登记开始时间
    dtRegisterStartTime:TDateTime;
    //登记截止时间
    dtRegisterEndTime:TDateTime;
  end;

  //关键人db操作
  TDBKeyTrainman = class(TDBOperate)
  public
    //增加
    procedure Add(keyMan:TKeyTrainman);
    //删除
    function Del(keyMan:TKeyTrainman):Boolean;
    //修改
    function Modify(KeyMan:TKeyTrainman):Boolean;

    //查询关键人
    procedure Query(qc:RDBKeyTM_QC; keyTrainmanList:TKeyTrainmanList);

    //查询关键人历史
    procedure QueryHis(qc:RDBKeyTM_QC; keyTrainmanList:TKeyTrainmanList);



  private
    //增加历史
    procedure AddHis(keyMan:TKeyTrainman);
    //构造查询
    procedure ConSql(qry:TADOQuery; qc: RDBKeyTM_QC;strTbName:string);
    //更新人员关键人状态
    procedure updateTMKeyState(strTrainmanNumber:string;bKey:Integer);
  public
    //数据集到对象
    procedure Data2DB(keyMan:TKeyTrainman;qry:TADOQuery);
    //对象到数据集
    procedure DB2Data(qry:TADOQuery;keyMan:TKeyTrainman);
  end;





implementation

{ TDBKeyTrainman }

procedure TDBKeyTrainman.Add(keyMan: TKeyTrainman);
var
  qry1:TADOQuery;
begin
  qry1 := NewADOQuery;
  try
    Self.GetADOConnection.BeginTrans;
    try
      qry1.SQL.Text := 'select * from ' + CS_Table_KeyTrainman + ' where 1<>1';
      qry1.Open;
      qry1.Append;
      self.Data2DB(keyMan,qry1);
      qry1.Post;
      updateTMKeyState(keyMan.rKeyTM.strKeyTMNumber,1);
      AddHis(keyMan);
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      begin
        self.GetADOConnection.RollbackTrans;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    qry1.Free;
  end;
end;

procedure TDBKeyTrainman.AddHis(keyMan: TKeyTrainman);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from ' + CS_Table_KeyTrainman_His + ' where 1<>1';
    qry.Open;
    qry.Append;
    self.Data2DB(keyMan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBKeyTrainman.ConSql(qry:TADOQuery ; qc: RDBKeyTM_QC; strTbName: string);
var
  strSql:string;
begin
  strSql := 'select * from ' + strTbName + ' where';
  if qc.strWorkShopGUID <> '' then
  begin
    strSql := strSql + ' strWorkShopGUID = :strWorkShopGUID and';
  end;
  if qc.strCheDuiGUID <> '' then
  begin
    strSql := strSql + ' strCheDuiGUID = :strCheDuiGUID and';
  end;
  if qc.strKeyTMNumber <> '' then
  begin
    strSql := strSql + ' strTrainmanNumber = :strTrainmanNumber and';
  end;
  if qc.strKeyTMName <> '' then
  begin
    strSql := strSql + ' strTrainmanName = :strTrainmanName and';
  end;
  if qc.dtRegisterStartTime > 1 then
  begin
    strSql := strSql + ' dtRegisterTime >= :dtRegisterTime and';
  end;
  if qc.dtRegisterEndTime > 1 then
  begin
    strSql := strSql + ' dtRegisterTime <= :dtRegisterTime';
  end;

  if StrUtils.EndsStr('and',strSql) = True then
    strSql := StrUtils.LeftStr(strSql,Length(strSql)-3);

  if StrUtils.EndsStr('where',strSql) = True then
    strSql := StrUtils.ReplaceText(strSql,'where','');

  strSql := strSql + 'order by dtRegisterTime' ;

  qry.SQL.Text := strSql;

  if qc.strWorkShopGUID <> '' then
  begin
    qry.Parameters.ParamByName('strWorkShopGUID').Value := qc.strWorkShopGUID
  end;
  if qc.strCheDuiGUID <> '' then
  begin
    qry.Parameters.ParamByName('strWorkShopGUID').Value := qc.strWorkShopGUID;
  end;
  if qc.strKeyTMNumber <> '' then
  begin
    qry.Parameters.ParamByName('strTrainmanNumber').Value := qc.strKeyTMNumber;
  end;
  if qc.strKeyTMName <> '' then
  begin
    qry.Parameters.ParamByName('strTrainmanName').Value := qc.strKeyTMName;
  end;
  if qc.dtRegisterStartTime > 1 then
  begin
    qry.Parameters.ParamByName('dtRegisterTime').Value := qc.dtRegisterStartTime
  end;
  if qc.dtRegisterEndTime > 1 then
  begin
    qry.Parameters.ParamByName('dtRegisterTime').Value := qc.dtRegisterEndTime
  end;

end;

procedure TDBKeyTrainman.Data2DB(keyMan: TKeyTrainman; qry: TADOQuery);
begin
  qry.FieldByName('strGUID').Value :=   keyMan.rKeyTM.strGUID;
  qry.FieldByName('strTrainmanNumber').Value :=   keyMan.rKeyTM.strKeyTMNumber;
  qry.FieldByName('strTrainmanName').Value :=   keyMan.rKeyTM.strKeyTMName;
  qry.FieldByName('strWorkShopGUID').Value :=   keyMan.rKeyTM. strKeyTMWorkShopGUID;
  qry.FieldByName('strWorkShopName').Value :=   keyMan.rKeyTM.strKeyTMWorkShopName;
  qry.FieldByName('strCheJianGUID').Value :=   keyMan.rKeyTM.strKeyTMCheDuiGUID;
  qry.FieldByName('strCheJianName').Value :=   keyMan.rKeyTM.strKeyTMCheDuiName;
  qry.FieldByName('dtStartTime').Value :=   keyMan.rKeyTM.dtKeyStartTime;
  qry.FieldByName('dtEndTime').Value :=   keyMan.rKeyTM.dtKeyEndTime;
  qry.FieldByName('strReason').Value :=   keyMan.rKeyTM.strKeyReason;
  qry.FieldByName('strAnnouncements').Value :=   keyMan.rKeyTM.strKeyAnnouncements;
  qry.FieldByName('strRegisterNumber').Value :=   keyMan.rKeyTM.strRegisterNumber;
  qry.FieldByName('strRegisterName').Value :=   keyMan.rKeyTM.strRegisterName;
  qry.FieldByName('dtRegisterTime').Value :=   keyMan.rKeyTM.dtRegisterTime;
  qry.FieldByName('strClientNumber').Value :=   keyMan.rKeyTM.strClientNumber;
  qry.FieldByName('strClientName').Value :=   keyMan.rKeyTM.strClientName;
  qry.FieldByName('eOpt').Value :=  ord(keyMan.rKeyTM.eOpt);//:EKeyTrainmanOpt;
end;

procedure TDBKeyTrainman.DB2Data(qry: TADOQuery; keyMan: TKeyTrainman);
begin
  keyMan.rKeyTM.strGUID := qry.FieldByName('strGUID').Value;
  keyMan.rKeyTM.strKeyTMNumber := qry.FieldByName('strTrainmanNumber').Value;
  keyMan.rKeyTM.strKeyTMName := qry.FieldByName('strTrainmanName').Value;
  keyMan.rKeyTM. strKeyTMWorkShopGUID := qry.FieldByName('strWorkShopGUID').Value;
  keyMan.rKeyTM.strKeyTMWorkShopName := qry.FieldByName('strWorkShopName').Value;
  keyMan.rKeyTM.strKeyTMCheDuiGUID := qry.FieldByName('strCheJianGUID').Value;
  keyMan.rKeyTM.strKeyTMCheDuiName := qry.FieldByName('strCheJianName').Value;
  keyMan.rKeyTM.dtKeyStartTime := qry.FieldByName('dtStartTime').Value;
  keyMan.rKeyTM.dtKeyEndTime := qry.FieldByName('dtEndTime').Value;
  keyMan.rKeyTM.strKeyReason := qry.FieldByName('strReason').Value;
  keyMan.rKeyTM.strKeyAnnouncements := qry.FieldByName('strAnnouncements').Value;
  keyMan.rKeyTM.strRegisterNumber := qry.FieldByName('strRegisterNumber').Value;
  keyMan.rKeyTM.strRegisterName := qry.FieldByName('strRegisterName').Value;
  keyMan.rKeyTM.dtRegisterTime := qry.FieldByName('dtRegisterTime').Value;
  keyMan.rKeyTM.strClientNumber := qry.FieldByName('strClientNumber').Value;
  keyMan.rKeyTM.strClientName := qry.FieldByName('strClientName').Value;
  keyMan.rKeyTM.eOpt := qry.FieldByName('eOpt').Value ;//:EKeyTrainmanOpt := qry.FieldByName('eOpt').Value;
end;

function TDBKeyTrainman.Del(keyMan: TKeyTrainman):Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    Self.GetADOConnection.BeginTrans ;
    try
      qry.SQL.Text := 'delete from ' + CS_Table_KeyTrainman +' where strGUID = :strGUID';
      qry.Parameters.ParamByName('strGUID').Value := keyMan.rKeyTM.strGUID;
      if qry.ExecSQL = 0 then Exit;
      updateTMKeyState(keyMan.rKeyTM.strKeyTMNumber,0);
      self.AddHis(keyman);
      self.GetADOConnection.CommitTrans;
      result := True;
    except on e:Exception do
      begin
        self.GetADOConnection.RollbackTrans;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    qry.Free;
  end;
end;

function TDBKeyTrainman.Modify(KeyMan: TKeyTrainman):Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    try
      self.GetADOConnection.BeginTrans;
      qry.SQL.Text := 'select * from ' + CS_Table_KeyTrainman + ' where strGUID = :strGUID';
      qry.Parameters.ParamByName('strGUID').Value := KeyMan.rKeyTM.strGUID;
      qry.Open;
      if qry.RecordCount = 0 then Exit;
      
      qry.Edit;
      self.Data2DB(KeyMan,qry);
      qry.Post;
      self.AddHis(KeyMan);
      self.GetADOConnection.CommitTrans;
      result := True;
    except on e:Exception do
      begin
        self.GetADOConnection.RollbackTrans;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBKeyTrainman.Query(qc: RDBKeyTM_QC;
  keyTrainmanList: TKeyTrainmanList);
var
  qry:TADOQuery;
  keyman:TKeyTrainman;
begin
  qry := NewADOQuery;
  try
    self.ConSql(qry,qc,CS_Table_KeyTrainman);
    qry.Open;
    while not qry.Eof do
    begin
      keyman := TKeyTrainman.Create;
      self.DB2Data(qry,keyman);
      keyTrainmanList.Add(keyman);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBKeyTrainman.QueryHis(qc: RDBKeyTM_QC;
  keyTrainmanList: TKeyTrainmanList);
var
  qry:TADOQuery;
  keyman:TKeyTrainman;
begin
  qry := NewADOQuery;
  try
    self.ConSql(qry,qc,CS_Table_KeyTrainman_His);
    qry.Open;
    while not qry.Eof do
    begin
      keyman := TKeyTrainman.Create;
      self.DB2Data(qry,keyman);
      keyTrainmanList.Add(keyman);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBKeyTrainman.updateTMKeyState(strTrainmanNumber: string;
  bKey: Integer);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'update tab_org_Trainman set bIsKey = :bIsKey where strTrainmanNumber = :strTrainmanNumber';
    qry.Parameters.ParamByName('bIsKey').Value := bKey;
    qry.Parameters.ParamByName('strTrainmanNumber').Value :=strTrainmanNumber ;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

end.
