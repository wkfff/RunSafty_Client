unit uUploadSignInfo;

interface

uses
  SysUtils,Classes,DateUtils,DB,ADODB,Variants,ZKFPEngXUtils,uSaftyEnum,
  uTrainman,uRoomSign,uExchangeSignInfo,uLeaderExam;

type

    ///  ���� : TUploadSignInfo
  ///  �๦�� ������������
  ///  ������ �� LYQ
  TUploadSignInfo = class(TBaseExchangeSignInfo)
  public
    //�����ϴ����ݵ���Ա
    procedure SetDutyUser(DutyUserGUID,SiteGUID:string);
    //�ϴ���Ԣ��Ϣ����
    //ACount ���ܹ����� ,����ֵ�ǳɹ��ĸ���
    function UploadSignInInfo(var ATotalCount:Integer):Integer;
    //�ϴ���Ԣ��Ϣ����
    //ACount ���ܹ����� ,����ֵ�ǳɹ��ĸ���
    function UploadSignOutInfo(var ATotalCount:Integer):Integer;
    //�ϴ������Ϣ����  
    //ACount ���ܹ����� ,����ֵ�ǳɹ��ĸ���
    function UploadLeaderInspectInfo(var ATotalCount:Integer):Integer;
  private
    // �ϴ���Ա
    m_strSiteGUID:string;
    m_strDutyUserGUID:string;
  end;

implementation


{ TUploadSignInfo }


procedure TUploadSignInfo.SetDutyUser(DutyUserGUID, SiteGUID: string);
begin
  m_strDutyUserGUID := DutyUserGUID;
  m_strSiteGUID := SiteGUID ;
end;


function TUploadSignInfo.UploadLeaderInspectInfo(var ATotalCount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  adoDeleteQuery:TADOQuery;
  LeaderInspect: RRsLeaderInspect;
begin
  Result := 0 ;
  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;

  adoDeleteQuery := TADOQuery.Create(nil);
  adoDeleteQuery.Connection := m_conLocal ;
  adoDeleteQuery.ParamCheck := False ;

  try
    strSqlLocal := Format('select * from TAB_Exam_Information where nDelFlag = 0',[]);
    adoLocalQuery.SQL.Text := strSqlLocal ;
    adoLocalQuery.ParamCheck := False ;
    adoLocalQuery.Open;
    ATotalCount := adoLocalQuery.RecordCount ;
    if ATotalCount <= 0  then
      Exit ;
    while not adoLocalQuery.Eof do
    begin
      {$REGION '��ȡһ����Ϣ'}
      AdoToLeaderInspect(adoLocalQuery,LeaderInspect);
      {$ENDREGION}

      {$REGION '�����Ա�Ƿ����'}
      strSqlServer := Format('select count(*) as totalcount from Tab_Org_Trainman where strTrainmanGUID = %s ',[
      QuotedStr(LeaderInspect.LeaderGUID)]);
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        if FieldByName('totalcount').AsInteger = 0 then
          goto lbNext;
      end;
      {$ENDREGION}

      {$REGION '��Ϣ��Ч�Լ��'}
      strSqlServer := Format('select count(*) as totalcount from TAB_Exam_Information where strGUID = %s ',[
      QuotedStr(LeaderInspect.GUID)]);
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        if FieldByName('totalcount').AsInteger > 0 then
          goto lbNext;
      end;
      {$ENDREGION}

      {$REGION '��Ϣ������Ч��Ϣ'}
      LeaderInspect.DutyGUID := m_strDutyUserGUID ;
      {$ENDREGION}

      {$REGION '��Ϣ�ش�'}
      strSqlServer := 'select * from TAB_Exam_Information where 1 = 2 ';
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        Append();
        LeaderInspectToAdo(adoServerQuery,LeaderInspect);
        Post();
      end;
      {$ENDREGION}

lbNext:

      {$REGION 'ɾ���ɹ�������'}
      strSqlLocal := Format('update TAB_Exam_Information Set nDelFlag = %d where strGUID= %s ', [1, QuotedStr(LeaderInspect.GUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;

      Inc(Result) ;
      {$ENDREGION}

      {$REGION '��ʾ������'}
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ATotalCount);
      {$ENDREGION}

      adoLocalQuery.Next;
    end;
  finally
    adoDeleteQuery.Free;
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;

function TUploadSignInfo.UploadSignInInfo(var ATotalCount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  adoDeleteQuery:TADOQuery;
  RoomSign: TRsRoomSign;
begin
  Result := 0 ;
  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;

  adoDeleteQuery := TADOQuery.Create(nil);
  adoDeleteQuery.Connection := m_conLocal ;
  adoDeleteQuery.ParamCheck := False ;

  RoomSign := TRsRoomSign.Create;
  try
    strSqlLocal := Format('select * from TAB_Plan_InRoom where nDelFlag = 0',[]);
    adoLocalQuery.SQL.Text := strSqlLocal ;
    adoLocalQuery.ParamCheck := False ;
    adoLocalQuery.Open;
    ATotalCount := adoLocalQuery.RecordCount ;
    if ATotalCount <= 0  then
      Exit ;
    while not adoLocalQuery.Eof do
    begin
      //��ȡһ����Ϣ
      AdoToSignIn(RoomSign,adoLocalQuery);


      {$REGION '��Ϣ��Ч�Լ��'}
      strSqlServer := Format('select count(*) as totalcount from TAB_Plan_InRoom where strInRoomGUID = %s ',[
        QuotedStr(RoomSign.strInRoomGUID)]);
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        if FieldByName('totalcount').AsInteger > 0 then
          goto lbNext;
      end;
      {$ENDREGION}


      {$REGION '��Ϣ�ش�'}
      strSqlServer := 'select * from TAB_Plan_InRoom where 1 = 2 ';
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        Append();
        SignInToAdo(adoServerQuery,RoomSign);
        Post();
      end;
      {$ENDREGION}

lbNext:

      {$REGION 'ɾ���ղųɹ�������'}
      strSqlLocal := Format('update TAB_Plan_InRoom Set nDelFlag = %d where strInRoomGUID = %s ', [1, QuotedStr(RoomSign.strInRoomGUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;

      Inc(Result) ;
      {$ENDREGION}

      {$REGION '��ʾ������'}
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ATotalCount);
      {$ENDREGION}

      adoLocalQuery.Next;
    end;
  finally
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
    adoDeleteQuery.Free;
    RoomSign.Free;
  end;
end;

function TUploadSignInfo.UploadSignOutInfo(var ATotalCount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  adoDeleteQuery:TADOQuery;
  RoomSign: TRsRoomSign;
begin
  Result := 0 ;
  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;

  adoDeleteQuery := TADOQuery.Create(nil);
  adoDeleteQuery.Connection := m_conLocal ;
  adoDeleteQuery.ParamCheck := False ;

  RoomSign := TRsRoomSign.Create;
  try
    strSqlLocal := Format('select * from TAB_Plan_OutRoom where nDelFlag = 0',[]);
    adoLocalQuery.SQL.Text := strSqlLocal ;
    adoLocalQuery.ParamCheck := False ;
    adoLocalQuery.Open;
    ATotalCount := adoLocalQuery.RecordCount ;
    if ATotalCount <= 0  then
      Exit ;
    while not adoLocalQuery.Eof do
    begin
      {$REGION '��ȡһ����Ϣ'}
      AdoToSignOut(RoomSign,adoLocalQuery);
      {$ENDREGION}

      {$REGION '��Ϣ��Ч�Լ��'}
      strSqlServer := Format('select count(*) as totalcount from TAB_Plan_OutRoom where strOutRoomGUID = %s ',[
      QuotedStr(RoomSign.strOutRoomGUID)]);
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        if FieldByName('totalcount').AsInteger > 0 then
          goto lbNext;
      end;
      {$ENDREGION}

      {$REGION '��Ϣ�ش�'}

      strSqlServer := 'select * from TAB_Plan_OutRoom where 1 = 2 ';
      adoServerQuery.SQL.Text := strSqlServer ;
      with adoServerQuery do
      begin
        Close;
        Open();
        Append();
        SignOutToAdo(adoServerQuery,RoomSign);
        Post();
      end;
      {$ENDREGION}

lbNext:

      {$REGION 'ɾ���ɹ�������'}
      strSqlLocal := Format('update TAB_Plan_OutRoom Set nDelFlag = %d where strOutRoomGUID = %s ', [ 1 , QuotedStr(RoomSign.strOutRoomGUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;
      Inc(Result) ;
      {$ENDREGION}

      {$REGION '��ʾ������'}
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ATotalCount);
      {$ENDREGION}

      adoLocalQuery.Next;
    end;
  finally
    adoDeleteQuery.Free;
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
    RoomSign.Free;
  end;
end;

end.
