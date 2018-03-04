unit uDownLoadSignInfo;

interface

uses
  SysUtils,DateUtils,DB,ADODB,Variants,Math,
  uTrainman,uRoomSign,uExchangeSignInfo;

const
  DOWN_TIME_RANGE = 2 ;//下载最近两天数据
  PAGE_TRAINMAIN = 20 ; //一次下载20个人员信息
type

    //进度函数指针
  TShowTrainmanFunc = procedure (Trainman : RRsTrainman) of object;

  ///  类名 : TDownSignInfo
  ///  类功能 ：房间下载类
  ///  类作者 ： LYQ
  TDownloadSignInfo = class(TBaseExchangeSignInfo)
  public
    // 设置人员显示信息
    procedure SetShowTrainmanFunc(Func:TShowTrainmanFunc);
        //下载人员信息数据
    //返回值是成功的个数
    function UpdateTrainman():Integer;
      //下载人员信息数据(一次下载20个)目前是第几页
    function DownloadTrainman(Page:Integer):Integer;
  public
    //获取远程数据库总人员
    function GetServerTrainmanCount():Integer;
    //清空本地数据库人员
    function ClearTrainmanInfo():Boolean;
  public
    //下载人员信息数据
    //ACount 是总共个数 ,返回值是成功的个数
    function DownloadTrainmanInfo(var ACount:Integer):Integer;
    //下载房间信息数据
    //ACount 是总共个数 ,返回值是成功的个数
    function DownloadRoomInfo(var ACount:Integer):Integer;
    //下载入寓信息数据  
    //ACount 是总共个数 ,返回值是成功的个数
    function DownloadSignInInfo(var ACount:Integer):Integer;
    //下载离寓信息数据
    //ACount 是总共个数 ,返回值是成功的个数
    function DownloadSignOutInfo(var ACount:Integer):Integer;
  private
    FShowTrainmanFunc : TShowTrainmanFunc;
  end;

implementation

{ TDownSignRoomInfo }


function TDownloadSignInfo.DownloadTrainman(Page: Integer): Integer;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  nTemp,ACount : Integer ;
  Trainman: RRsTrainman  ;
begin
  Result := 0 ;
  nTemp := PAGE_TRAINMAIN * ( Page - 1 ) ;

  strSqlServer := Format('Select  top  %d ' +
    ' strTrainmanGUID,strTrainmanNumber,strTrainmanName,FingerPrint1,FingerPrint2,nid From tab_Org_Trainman  '  +
    ' where nid not in ' +
    ' ( select top %d  nid from tab_Org_Trainman order by nid ) ' +
    ' order by nid ',[PAGE_TRAINMAIN,nTemp]);

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;

  adoServerQuery := TADOQuery.Create(nil);
  try

    adoServerQuery.Connection := m_conServer ;
    adoServerQuery.SQL.Text := strSqlServer ;
    adoServerQuery.Open;
    ACount := adoServerQuery.RecordCount ;

    while (not adoServerQuery.Eof) do
    begin
      {'从服务器获取数据'}
      ADOQueryToTrainman(Trainman,adoServerQuery);

      {$REGION '插入到本地'}
      strSqlLocal := 'select * from TAB_Org_Trainman where  1 = 2 ';
      with adoLocalQuery do
      begin
        Sql.Text := strSqlLocal;
        Open;
        Append;
        TrainmanToADOQuery(Trainman,adoLocalQuery);
        Post;
        Close ;
      end;
      {$ENDREGION}


      {$REGION '显示进度'}
      Inc(Result) ;

      if Assigned(FShowTrainmanFunc) then
        FShowTrainmanFunc(Trainman);

      if Assigned(m_pProgressFuncCur) then
        m_pProgressFuncCur(Result,ACount);
      {$ENDREGION}

      Trainman.FingerPrint1 := UnAssigned ;
      Trainman.FingerPrint2 := UnAssigned;
      Trainman.Picture := UnAssigned ;
      adoServerQuery.Next ;
    end;
  finally
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;

function TDownloadSignInfo.DownloadTrainmanInfo(var ACount: Integer): Integer;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;

  Trainman: RRsTrainman  ;
begin
  Result := 0 ;

  strSqlServer := 'Select  strTrainmanGUID,strTrainmanNumber,strTrainmanName,FingerPrint1,FingerPrint2 From tab_Org_Trainman  ' ;

  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;
  //清空本地人员
  adoLocalQuery.SQL.Text := 'delete from tab_org_trainman';
  adoLocalQuery.ExecSQL;

  try
    adoServerQuery.SQL.Text := strSqlServer ;
    adoServerQuery.Open;
    ACount := adoServerQuery.RecordCount ;

    while (not adoServerQuery.Eof) do
    begin
      {'从服务器获取数据'}
      ADOQueryToTrainman(Trainman,adoServerQuery);

      {$REGION '插入到本地'}
      strSqlLocal := 'select * from TAB_Org_Trainman where  1 = 2 ';
      with adoLocalQuery do
      begin
        Sql.Text := strSqlLocal;
        Open;
        Append;
        TrainmanToADOQuery(Trainman,adoLocalQuery);
        Post;
        Close ;
      end;
      {$ENDREGION}


      {$REGION '显示进度'}
      Inc(Result) ;
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ACount);
      {$ENDREGION}

      Trainman.FingerPrint1 := UnAssigned ;
      Trainman.FingerPrint2 := UnAssigned;
      Trainman.Picture := UnAssigned ;
      adoServerQuery.Next ;
    end;
  finally
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;


function TDownloadSignInfo.GetServerTrainmanCount: Integer;
var
  strSql:string;
  Query:TADOQuery ;
begin
  Result := 0 ;
  strSql := 'Select  count(*) as tcount From tab_org_trainman  ' ;
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := m_conServer ;
    Query.SQL.Text := strSql ;
    Query.Open ;
    Result := Query.FieldByName('tcount').AsInteger ;
  finally
    Query.Close;
    Query.Free ;
  end;
end;

procedure TDownloadSignInfo.SetShowTrainmanFunc(Func: TShowTrainmanFunc);
begin
  FShowTrainmanFunc := Func ;
end;

function TDownloadSignInfo.UpdateTrainman(): Integer;
var
  nTotalCount,nTotalPage,nCurPage : Integer ;
begin
  Result := 0 ;
  //获取远程人员总信息
  nTotalCount := GetServerTrainmanCount ;
  nTotalPage := Ceil( nTotalCount / PAGE_TRAINMAIN ) ;
  for nCurPage := 1 to nTotalPage  do
  begin
    //下载人员信息
    DownloadTrainman(nCurPage);
    //更新进度
    if Assigned(m_pProgressFunc) then
        m_pProgressFunc(nCurPage,nTotalPage) ;
    //
    //如果有有停止表位
    if CanStop then
      Break ;
  end;
  Result :=  nCurPage*PAGE_TRAINMAIN ;
end;

function TDownloadSignInfo.ClearTrainmanInfo: Boolean;
var
  adoLocalQuery:TADOQuery ;
begin
  adoLocalQuery := TADOQuery.Create(nil);
  try
    adoLocalQuery.Connection := m_conLocal ;
    //清空本地人员
    adoLocalQuery.SQL.Text := 'delete from tab_org_trainman';
    adoLocalQuery.ExecSQL;
  finally
    adoLocalQuery.Free ;
  end;
end;

function TDownloadSignInfo.DownloadRoomInfo(var ACount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  iRecordCount : Integer ;

  strRoomNumber:string;
  strTrainmanGUID:string;
  nBedNumber:Integer;
  nId:Integer;
begin
  Result := 0 ;

  strSqlServer := Format('select * from tab_Base_room order by strRoomNumber,nBedNumber',[]) ;

  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;
  try
    adoServerQuery.SQL.Text := strSqlServer ;
    adoServerQuery.Open;
    ACount := adoServerQuery.RecordCount ;

    while (not adoServerQuery.Eof) do
    begin
      {$REGION '从服务器获取数据'}
      nId :=  adoServerQuery.FieldByName('nID').AsInteger ;
      strRoomNumber := adoServerQuery.FieldByName('strRoomNumber').AsString;
      strTrainmanGUID := adoServerQuery.FieldByName('strTrainmanGUID').AsString;
      nBedNumber := adoServerQuery.FieldByName('nBedNumber').AsInteger;
      {$ENDREGION}

      {$REGION '检查本地是否存在相关信息'}
      strSqlLocal := Format('select count(*) as totalcount from  tab_base_room  where  strRoomNumber = %s  and nBedNumber = %d',
        [QuotedStr(strRoomNumber),nBedNumber]);
      with adoLocalQuery do
      begin
        ParamCheck := False ;
        SQL.Text := strSqlLocal;
        Close ;
        Open ;
        iRecordCount := FieldByName('totalcount').AsInteger;
      end;
      if iRecordCount > 0 then
        goto lbNext;

      {$ENDREGION}

      {$REGION '插入到本地'}
      strSqlLocal := Format('Insert into  tab_base_room  ( nID,strRoomNumber , strTrainmanGUID  ,nBedNumber ) values ( %d ,%s, %s , %d )  ',
        [nID,QuotedStr(strRoomNumber),QuotedStr(strTrainmanGUID),nBedNumber]);
      adoLocalQuery.SQL.Text := strSqlLocal;
      adoLocalQuery.ExecSQL ;

      {$ENDREGION}

lbNext:
      {$REGION '显示进度'}
      Inc(Result) ;
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ACount);
      {$ENDREGION}

      adoServerQuery.Next ;
    end;
  finally
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;

function TDownloadSignInfo.DownloadSignInInfo(var ACount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  dtStart,dtEnd:TDateTime;
  RoomSign: TRsRoomSign;
  iRecordCount : Integer ;
begin
  dtEnd := Now ;
  dtStart := Now - DOWN_TIME_RANGE ;
  Result := 0 ;
  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;

  RoomSign := TRsRoomSign.Create;
  try
    strSqlServer := Format('select * from TAB_Plan_InRoom where ( dtInRoomTime >= %s and  dtInRoomTime <= %s )',[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStart)), QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)) ] );
    adoServerQuery.SQL.Text := strSqlServer ;
    adoServerQuery.Open;
    ACount := adoServerQuery.RecordCount ;

    while (not adoServerQuery.Eof) do
    begin
      {$REGION '从服务器获取数据'}
      AdoToSignIn(RoomSign,adoServerQuery);
      {$ENDREGION}

      {$REGION '检查本地是否存在相关信息'}
      strSqlLocal := Format('select count(*) as totalcount from  TAB_Plan_InRoom  where  strInRoomGUID = %s  ',
        [QuotedStr(RoomSign.strInRoomGUID)]);
      with adoLocalQuery do
      begin
        ParamCheck := False ;
        SQL.Text := strSqlLocal;
        Close ;
        Open ;
        iRecordCount := FieldByName('totalcount').AsInteger;
      end;
      if iRecordCount > 0 then
        goto lbNext;

      {$ENDREGION}


      {$REGION '插入到本地'}
      strSqlLocal := 'select * from TAB_Plan_InRoom where 1 = 2 ';
      with adoLocalQuery do
      begin
        SQL.Text := strSqlLocal ;
        ParamCheck := False ;
        Close;
        Open();
        Append();
        SignInToAdo(adoLocalQuery,RoomSign);
        Post();
      end;
      {$ENDREGION}

lbNext:
      {$REGION '显示进度'}
      Inc(Result) ;
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ACount);
      {$ENDREGION}

      adoServerQuery.Next ;
    end;
  finally
    RoomSign.Free ;
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;

function TDownloadSignInfo.DownloadSignOutInfo(var ACount: Integer): Integer;
label
  lbNext;
var
  strSqlServer:string;
  strSqlLocal:string;
  adoServerQuery:TADOQuery ;
  adoLocalQuery:TADOQuery ;
  dtStart,dtEnd:TDateTime;
  RoomSign: TRsRoomSign;
  iRecordCount : Integer ;
begin
  dtEnd := Now ;
  dtStart := Now - DOWN_TIME_RANGE ;

  Result := 0 ;
  adoServerQuery := TADOQuery.Create(nil);
  adoServerQuery.Connection := m_conServer ;

  adoLocalQuery := TADOQuery.Create(nil);
  adoLocalQuery.Connection := m_conLocal ;
  RoomSign := TRsRoomSign.Create ;
  try
    strSqlServer := Format('select * from TAB_Plan_OutRoom where ( dtOutRoomTime >= %s and  dtOutRoomTime <= %s )',[
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStart)), QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd)) ] );
    adoServerQuery.SQL.Text := strSqlServer ;
    adoServerQuery.Open;
    ACount := adoServerQuery.RecordCount ;

    while (not adoServerQuery.Eof) do
    begin
      {$REGION '从服务器获取数据'}
      AdoToSignOut(RoomSign,adoServerQuery);
      {$ENDREGION}

      {$REGION '检查本地是否存在相关信息'}
      strSqlLocal := Format('select count(*) as totalcount from  TAB_Plan_OutRoom  where  strOutRoomGUID = %s  ',
        [QuotedStr(RoomSign.strOutRoomGUID)]);
      with adoLocalQuery do
      begin
        ParamCheck := False ;
        SQL.Text := strSqlLocal;
        Close ;
        Open ;
        iRecordCount := FieldByName('totalcount').AsInteger;
      end;
      if iRecordCount > 0 then
        goto lbNext;

      {$ENDREGION}

      {$REGION '插入到本地'}
      strSqlLocal := 'select * from TAB_Plan_OutRoom where 1 = 2 ';
      with adoLocalQuery do
      begin
        SQL.Text := strSqlLocal ;
        ParamCheck := False ;
        Close;
        Open();
        Append();
        SignOutToAdo(adoLocalQuery,RoomSign);
        Post();
      end;
      Inc(Result) ;
      {$ENDREGION}

lbNext:
      {$REGION '显示进度'}
      Inc(Result) ;
      if Assigned(m_pProgressFunc) then
        m_pProgressFunc(Result,ACount);
      {$ENDREGION}

      adoServerQuery.Next ;
    end;
  finally
    RoomSign.Free ;
    adoServerQuery.Free ;
    adoLocalQuery.Free ;
  end;
end;

end.
