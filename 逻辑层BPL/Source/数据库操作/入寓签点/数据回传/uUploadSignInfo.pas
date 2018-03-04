unit uUploadSignInfo;

interface

uses
  SysUtils,Classes,DateUtils,DB,ADODB,Variants,ZKFPEngXUtils,uSaftyEnum,
  uTrainman,uRoomSign,uExchangeSignInfo,uLeaderExam;

type

    ///  类名 : TUploadSignInfo
  ///  类功能 ：房间下载类
  ///  类作者 ： LYQ
  TUploadSignInfo = class(TBaseExchangeSignInfo)
  public
    //设置上传数据的人员
    procedure SetDutyUser(DutyUserGUID,SiteGUID:string);
    //上传入寓信息数据
    //ACount 是总共个数 ,返回值是成功的个数
    function UploadSignInInfo(var ATotalCount:Integer):Integer;
    //上传离寓信息数据
    //ACount 是总共个数 ,返回值是成功的个数
    function UploadSignOutInfo(var ATotalCount:Integer):Integer;
    //上传查岗信息数据  
    //ACount 是总共个数 ,返回值是成功的个数
    function UploadLeaderInspectInfo(var ATotalCount:Integer):Integer;
  private
    // 上传人员
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
      {$REGION '获取一条信息'}
      AdoToLeaderInspect(adoLocalQuery,LeaderInspect);
      {$ENDREGION}

      {$REGION '检查人员是否存在'}
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

      {$REGION '信息有效性检查'}
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

      {$REGION '信息增加有效信息'}
      LeaderInspect.DutyGUID := m_strDutyUserGUID ;
      {$ENDREGION}

      {$REGION '信息回传'}
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

      {$REGION '删除成功的数据'}
      strSqlLocal := Format('update TAB_Exam_Information Set nDelFlag = %d where strGUID= %s ', [1, QuotedStr(LeaderInspect.GUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;

      Inc(Result) ;
      {$ENDREGION}

      {$REGION '显示进度条'}
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
      //获取一条信息
      AdoToSignIn(RoomSign,adoLocalQuery);


      {$REGION '信息有效性检查'}
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


      {$REGION '信息回传'}
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

      {$REGION '删除刚才成功的数据'}
      strSqlLocal := Format('update TAB_Plan_InRoom Set nDelFlag = %d where strInRoomGUID = %s ', [1, QuotedStr(RoomSign.strInRoomGUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;

      Inc(Result) ;
      {$ENDREGION}

      {$REGION '显示进度条'}
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
      {$REGION '获取一条信息'}
      AdoToSignOut(RoomSign,adoLocalQuery);
      {$ENDREGION}

      {$REGION '信息有效性检查'}
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

      {$REGION '信息回传'}

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

      {$REGION '删除成功的数据'}
      strSqlLocal := Format('update TAB_Plan_OutRoom Set nDelFlag = %d where strOutRoomGUID = %s ', [ 1 , QuotedStr(RoomSign.strOutRoomGUID)]);
      adoDeleteQuery.SQL.Text := strSqlLocal ;
      with adoDeleteQuery do
      begin
        ExecSQL;
      end;
      Inc(Result) ;
      {$ENDREGION}

      {$REGION '显示进度条'}
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
