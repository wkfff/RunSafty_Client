unit uDBFixedGroup;

interface
uses uTFSystem,ADODB,Classes,uFixedGroup,uTrainman,SysUtils,StrUtils;
type

  //��ѯ����
  RDBFixedGroup_QC = record
    //������
    strWorkShopGUID:string;
    //���ӱ��
    strCheDuiGUID:string;
    //����
    strTMNumber:string;
    //����
    strTMName:string;
  end;


  //�̶���������ݿ����
  TDBFixedGroup = class(TDBOperate)
  public
    //����
    procedure AddGroup(group:TFixedGroup);
    //�޸Ļ���
    procedure ModifyGroup(group:TFixedGroup);
    //ɾ��
    procedure DelGroup(group:TFixedGroup);
    //������Ա
    procedure AddTM(group:TFixedGroup; index:Integer;trainman:RRsTrainman);
    //�޸���Ա
    procedure ModifyTM(group:TFixedGroup;Index:Integer; sTrainman, dtrainman:RRsTrainman);
    //ɾ����
    procedure DelTM(group:TFixedGroup;tm:RRsTrainman);

    //��ѯ
    procedure Query(qc: RDBFixedGroup_QC; groupList:TFixedGroupList);

  private
        //�����ѯ
    procedure ConSql(qry:TADOQuery; qc: RDBFixedGroup_QC;strTbName:string);
    //����
    procedure Ado2Group(ado:TADOQuery;group:TFixedGroup);
    procedure Group2Ado(group:TFixedGroup;ado:TADOQuery);

    //��Ա
    procedure Ado2TM(ado:TADOQuery;var trainman:RRsTrainman);
    procedure TM2Ado(trainman:RRsTrainman;index:Integer; ado:TADOQuery);


  end;

implementation

{ TDBFixedGroup }

procedure TDBFixedGroup.AddGroup(group: TFixedGroup);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from TAB_FixedGroup where 1<> 1';
    qry.Open;
    qry.Append;
    self.Group2Ado(group,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;
procedure TDBFixedGroup.ModifyGroup(group:TFixedGroup);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from TAB_FixedGroup where strGroupGUID = :strGroupGUID';
    qry.Parameters.ParamByName('strGroupGUID').Value := group.rFixedGroup.strGroupGUID;
    qry.Open;
    qry.Edit;
    self.Group2Ado(group,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

procedure TDBFixedGroup.AddTM(group: TFixedGroup; index:Integer; trainman: RRsTrainman);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  Self.GetADOConnection.BeginTrans;
  try
    qry.SQL.Text := 'select * from tab_org_Trainman where strFixedGroupGUID = :strFixedGroupGUID';
    qry.Parameters.ParamByName('strFixedGroupGUID').Value := group.rFixedGroup.strGroupGUID;
    qry.Open;
    qry.Edit;
    self.TM2Ado(trainman,index,qry);
    qry.Post;
  finally
    qry.Free;
  end;

end;


procedure TDBFixedGroup.DelGroup(group: TFixedGroup);
var
  qry:TADOQuery;
  qryTM:TADOQuery;
begin
  qry:= NewADOQuery;
  qryTM := NewADOQuery;
  Self.GetADOConnection.BeginTrans;
  try
    try
      qry.SQL.Text := 'delete from tab_FixedGroup where strGroupGUID = :strGroupGUID';
      qry.Parameters.ParamByName('strGroupGUID').value :=group.rFixedGroup.strGroupGUID;
      qryTM.SQL.Text := 'update tab_org_Trainman set strFixedGroupGUID = :strEmptyGUID , nFixedGroupIndex = 0 '
        + ' where strFixedGroupGUID =:strFixedGroupGUID';
      qryTM.Parameters.ParamByName('strFixedGroupGUID').Value :=  group.rFixedGroup.strGroupGUID;
      qryTM.Parameters.ParamByName('strEmptyGUID').Value :=  '';
      qry.ExecSQL;
      qryTM.ExecSQL;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      begin
        Self.GetADOConnection.RollbackTrans;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    qry.Free;
    qryTM.Free;
  end;
end;

procedure TDBFixedGroup.DelTM(group: TFixedGroup; tm: RRsTrainman);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'update tab_org_trainman set strFixedGroupGUID = :strFixedGroupGUID ,nFixedGoupIndex = 0 where '
      + 'strTrianmanGUID = :strTrainmanGUID ';
    qry.Parameters.ParamByName('strFixedGroupGUID').Value := '';
    qry.Parameters.ParamByName('nFixedGoupIndex').Value := 0;
    qry.Parameters.ParamByName('strTrianmanGUID').Value := tm.strTrainmanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;
procedure TDBFixedGroup.Ado2Group(ado: TADOQuery; group: TFixedGroup);
begin
  group.rFixedGroup.strWorkShopGUID := ado.FieldByName('strGroupWorkShopGUID').Value;
  group.rFixedGroup.strWorkShopName := ado.FieldByName('strGroupWorkShopName').Value;
  group.rFixedGroup.strCheDuiGUID := ado.FieldByName('strGroupCheDuiGUID').Value;
  group.rFixedGroup.strCheDuiName := ado.FieldByName('strGroupCheDuiName').Value;
  group.rFixedGroup.strGroupGUID := ado.FieldByName('strGroupGUID').Value;
  group.rFixedGroup.nGroupIndex := ado.FieldByName('nGroupIndex').Value;
  group.rFixedGroup.strGroupName := ado.FieldByName('strGroupName').Value;
end;


procedure TDBFixedGroup.Group2Ado(group: TFixedGroup; ado: TADOQuery);
begin
  ado.FieldByName('strGroupGUID').Value := group.rFixedGroup.strGroupGUID;
  ado.FieldByName('nGroupIndex').Value := group.rFixedGroup.nGroupIndex;
  ado.FieldByName('strGroupName').Value := group.rFixedGroup.strGroupName;
  ado.FieldByName('strGroupWorkShopGUID').Value := group.rFixedGroup.strWorkShopGUID;
  ado.FieldByName('strGroupWorkShopName').Value := group.rFixedGroup.strWorkShopName;
  ado.FieldByName('strGroupCheDuiGUID').Value := group.rFixedGroup.strCheDuiGUID;
  ado.FieldByName('strGroupCheDuiName').Value := group.rFixedGroup.strCheDuiName;
end;

procedure TDBFixedGroup.ModifyTM(group:TFixedGroup;Index:Integer; sTrainman, dtrainman:RRsTrainman);
var
  sQry,dQry:TADOQuery;
begin
  sQry := NewADOQuery;
  dQry := NewADOQuery;
  self.GetADOConnection.BeginTrans;
  try
    try
      sQry.SQL.Text := 'select * from tab_org_Trainman where strTrainmanGUID = :strTrainmanGUID';
      sQry.Parameters.ParamByName('strTrainmanGUID').Value := sTrainman.strTrainmanGUID;
      sQry.Open;
      sQry.Edit;
      self.TM2Ado(sTrainman,0,sQry);
      sQry.Post;

      dQry.SQL.Text := 'select * from tab_org_Trainman where strTrainmanGUID = :strTrainmanGUID';
      dQry.Parameters.ParamByName('strTrainmanGUID').Value := dtrainman.strTrainmanGUID;
      dQry.Open;
      dQry.Edit;
      self.TM2Ado(dtrainman,Index,dQry);
      dQry.Post;

      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      begin
        self.GetADOConnection.RollbackTrans;
        raise Exception.Create(e.Message);
      end;
    end;
  finally
    sQry.Free;
    dQry.Free;
  end;



end;

procedure TDBFixedGroup.Query(qc: RDBFixedGroup_QC; groupList: TFixedGroupList);
var
  qry:TADOQuery;
  group:TFixedGroup;
begin
  qry := NewADOQuery;
  try
    ConSql(qry,qc,'View_FixedGroup');
    qry.Open;
    while not qry.Eof do
    begin
      group:= groupList.Find(qry.FieldByName('strGroupGUID').AsString);
      if group = nil then
      begin
        group := TFixedGroup.Create;
        self.Ado2Group(qry,group);
        groupList.Add(group);
      end;
      if not qry.FieldByName('nFixedGroupIndex').IsNull then
      begin
        case qry.FieldByName('nFixedGroupIndex').AsInteger of
          1:Self.Ado2TM(qry,group.trainman1);
          2:Self.Ado2TM(qry,group.trainman2);
          3:Self.Ado2TM(qry,group.trainman3);
          4:Self.Ado2TM(qry,group.trainman4);
        end;
      end;
      qry.Next;
    end;

  finally
    qry.Free;
  end;

end;

procedure TDBFixedGroup.TM2Ado(trainman:RRsTrainman;index:Integer; ado:TADOQuery);
begin
  ado.FieldByName('strWorkShopGUID').Value := trainman.strWorkShopGUID  ;
  ado.FieldByName('strGuideGroupGUID').Value := trainman.strGuideGroupGUID  ;

  ado.FieldByName('strFixedGroupGUID').Value := trainman.strFixedGroupGUID;
  ado.FieldByName('nFixedGroupIndex').Value := index;

end;

procedure TDBFixedGroup.Ado2TM(ado: TADOQuery; var trainman: RRsTrainman);
begin
  trainman.strTrainmanGUID := ado.FieldByName('strTrainmanGUID').Value;
  trainman.strTrainmanNumber := ado.FieldByName('strTrainmanNumber').Value;
  trainman.strTrainmanName := ado.FieldByName('strTrainmanName').Value;
  trainman.strWorkShopGUID := ado.FieldByName('strWorkShopGUID').Value  ;
  trainman.strGuideGroupGUID := ado.FieldByName('strGuideGroupGUID').Value  ;

  trainman.strFixedGroupGUID := ado.FieldByName('strFixedGroupGUID').Value;
  trainman.nFixedGroupIndex := ado.FieldByName('nFixedGroupIndex').Value;
end;

procedure TDBFixedGroup.ConSql(qry: TADOQuery; qc: RDBFixedGroup_QC;
  strTbName: string);
var
  strSql:string;
begin
  strSql := 'select * from ' + strTbName + ' where';
  if qc.strWorkShopGUID <> '' then
  begin
    strSql := strSql + ' strGroupWorkShopGUID = :strGroupWorkShopGUID and';
  end;
  if qc.strCheDuiGUID <> '' then
  begin
    strSql := strSql + ' strGroupCheDuiGUID = :strGroupCheDuiGUID and';
  end;
  if qc.strTMNumber <> '' then
  begin
    strSql := strSql + ' strTrainmanNumber = :strTrainmanNumber and';
  end;
  if qc.strTMName <> '' then
  begin
    strSql := strSql + ' strTrainmanName = :strTrainmanName and';
  end;
  

  if StrUtils.EndsStr('and',strSql) = True then
    strSql := StrUtils.LeftStr(strSql,Length(strSql)-3);
    //strSql := StrUtils.ReplaceText(strSql,'and','');

  if StrUtils.EndsStr('where',strSql) = True then
    strSql := StrUtils.ReplaceText(strSql,'where','');

  strSql := strSql + ' order by strGroupName,strGroupCheDuiName,nGroupIndex,nFixedGroupIndex' ;

  qry.SQL.Text := strSql;

  if qc.strWorkShopGUID <> '' then
  begin
    qry.Parameters.ParamByName('strGroupWorkShopGUID').Value := qc.strWorkShopGUID;
  end;
  if qc.strCheDuiGUID <> '' then
  begin
    qry.Parameters.ParamByName('strGroupCheDuiGUID').Value := qc.strCheDuiGUID;
  end;
  if qc.strTMNumber <> '' then
  begin
    qry.Parameters.ParamByName('strTrainmanNumber').Value := qc.strTMNumber;
  end;
  if qc.strTMName <> '' then
  begin
    qry.Parameters.ParamByName('strTrainmanName').Value := qc.strTMName;
  end;


end;

end.
