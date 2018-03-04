unit uDBGroupTrainmanIndex;

interface

uses

  ADODB, Classes, Variants, ComObj, SysUtils, DateUtils,
  uTFSystem,uGroupTrainmanIndex;

type
  //////////////////////////////////////////////////////////////////////////////
  ///机组索引
  /// add by lyq 2014-5-19
  //////////////////////////////////////////////////////////////////////////////

  TShowProgessEvent = procedure(Pos:Double) of object ;
  TOnResult = procedure(List:TStrings)  of object  ;                           //结果

  TDBGroupTrainmanIndex  = class  (TDBOperate)
  public
    //获取所有的记录
    procedure Query(GroupGUID:string;var GroupTrainmanIndexArray:TRsGroupTrainmanIndexArray);
    //插入一条新的纪录
    function Insert(GroupTrainmanIndex:TRsGroupTrainmanIndex):Boolean;
    //删除与机组有关的索引
    procedure Delete(GroupGUID:string);
    //移除机组人员
    procedure Remove(GroupGUID:string;TrainmanGUID:string);
    //从NameplateGroup获取数据
    procedure UpdateFromNameplateGroup(ShowProgessEvent:TShowProgessEvent;DutyUserGUID:string;DutyUserName:string;SiteGUID:string;SiteName:string;DeleteOldData:Boolean=False);
    //和NameplateGroup比较数据
    function CompareWithNameplateGroup(ShowProgessEvent:TShowProgessEvent;OnResult: TOnResult):Integer;
  private
    procedure DataToAdo(ADOQuery:TADOQuery;GroupTrainmanIndex:TRsGroupTrainmanIndex);
    procedure AdoToData(var GroupTrainmanIndex:TRsGroupTrainmanIndex;ADOQuery:TADOQuery);
  end;

implementation

{ TDBGroupTrainmanIndex }

procedure TDBGroupTrainmanIndex.AdoToData(
  var GroupTrainmanIndex: TRsGroupTrainmanIndex; ADOQuery: TADOQuery);
begin
  with ADOQuery do
  begin
    GroupTrainmanIndex.strGroupGUID := FieldByName('strGroupGUID').AsString;
    GroupTrainmanIndex.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
    GroupTrainmanIndex.nTrainmanIndex := FieldByName('nTrainmanIndex').AsInteger;
    GroupTrainmanIndex.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    GroupTrainmanIndex.strDutyUserGUID := FieldByName('strDutyUserGUID').AsString;
    GroupTrainmanIndex.strDutyUserName := FieldByName('strDutyUserName').AsString;
    GroupTrainmanIndex.strSiteGUID := FieldByName('strSiteGUID').AsString;
    GroupTrainmanIndex.strSiteName := FieldByName('strSiteName').AsString;
  end;
end;

function TDBGroupTrainmanIndex.CompareWithNameplateGroup(ShowProgessEvent:TShowProgessEvent;OnResult: TOnResult):Integer;
label
  errLabel;
var
  strSql : string;
  adoQuery : TADOQuery;
  strGroupGUID:string;
  strTrainmanGUID1:string;
  strTrainmanGUID2:string;
  strTrainmanGUID3:string;
  strTrainmanGUID4:string;
  GroupTrainmanIndexArray: TRsGroupTrainmanIndexArray  ;
  strResult : string;
  nPos:Integer;
  nLen : Integer ;
  list:TStrings;
begin
  Result := 0 ;
  list := TStringList.Create;
  nPos := 1 ;
  strSql := 'select* from TAB_Nameplate_Group ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if recordcount <= 0 then
        Exit ;

      while not eof do
      begin

        if Assigned(ShowProgessEvent) then
          ShowProgessEvent( nPos / RecordCount  );

        strGroupGUID := FieldByName('strGroupGUID').AsString ;
        strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString ;
        strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString ;
        strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString ;
        strTrainmanGUID4 := FieldByName('strTrainmanGUID4').AsString ;

        //如果是没有任何人的组
        if  ( strTrainmanGUID1 = '' ) and
          ( strTrainmanGUID2 = '' ) and
          ( strTrainmanGUID3 = '' ) and
          ( strTrainmanGUID4 = '')
        then
          goto  errLabel;


        Query(strGroupGUID,GroupTrainmanIndexArray);
        nLen := Length(GroupTrainmanIndexArray);

        strResult := '' ;
        if nLen = 0 then
        begin
          strResult := ' 【 GroupID 】:' + strGroupGUID + '索引表没有任何相关信息';
          List.Add(strResult) ;
          goto errLabel;
        end;

        strResult := '' ;
        if strTrainmanGUID1 <> '' then
        begin
          if nLen >= 1 then
          begin
            if GroupTrainmanIndexArray[0].strTrainmanGUID  <> strTrainmanGUID1 then
              strResult := '【 GroupID 】:' + strGroupGUID + ' 【索引表的Trainman1】:' + GroupTrainmanIndexArray[0].strTrainmanGUID + '----' + '【Nameplate_Group的Trainman1】:'+strTrainmanGUID1
            else
            begin
              strResult := '';//'【 GroupID 】:' + strGroupGUID +  '【Trainman1】匹配' ;
            end;
          end
          else
            strResult := '【 GroupID 】 :' + strGroupGUID + ' 【索引表的Trainman1】不存在';
          if strResult <> '' then
            List.Add(strResult)   ;
        end
        else
          goto errLabel;

        strResult := '' ;
        if strTrainmanGUID2 <> '' then
        begin
          if nLen >= 2 then
          begin
          if GroupTrainmanIndexArray[1].strTrainmanGUID  <> strTrainmanGUID2 then
            strResult := '【GroupID】 :' + strGroupGUID + ' 【索引表的Trainman2】:' + GroupTrainmanIndexArray[1].strTrainmanGUID + '----' + '【Nameplate_Group的Trainman2】:'+strTrainmanGUID2
          else
          begin
            strResult := '';//'【 GroupID 】:' + strGroupGUID +  '【Trainman2】匹配' ;
          end;
          end
          else
            strResult := '【GroupID】 :' + strGroupGUID + ' 【索引表的Trainman2】不存在';
          if strResult <> '' then
            List.Add(strResult)   ;
        end
        else
          goto errLabel;

        strResult := '' ;
        if strTrainmanGUID3 <> '' then
        begin
          if nLen >= 2 then
          begin
          if GroupTrainmanIndexArray[2].strTrainmanGUID  <> strTrainmanGUID3 then
            strResult := '【GroupID 】:' + strGroupGUID + ' 【索引表的Trainman3】:' + GroupTrainmanIndexArray[2].strTrainmanGUID + '----' + '【Nameplate_Group的Trainman3】:' +strTrainmanGUID3
          else
          begin
            strResult := '';//'【 GroupID 】:' + strGroupGUID +  '【Trainman3】匹配' ;
          end;
          end
          else
            strResult := '【GroupID 】:' + strGroupGUID + ' 【索引表的Trainman3】不存在';
          if strResult <> '' then
            List.Add(strResult)   ;
        end
        else
          goto errLabel;

        strResult := '' ;
        if strTrainmanGUID4 <> '' then
        begin
          if nLen >= 2 then
          begin
          if GroupTrainmanIndexArray[3].strTrainmanGUID  <> strTrainmanGUID4 then
            strResult := '【GroupID】 :' + strGroupGUID + ' 【索引表的Trainman4】:'+ GroupTrainmanIndexArray[3].strTrainmanGUID + '----' + '【Nameplate_Group的Trainman4】:' +strTrainmanGUID4 
          else
              strResult := '';//'【 GroupID 】:' + strGroupGUID +  '【Trainman4】匹配' ;
          end
          else
            strResult := '【GroupID】:' + strGroupGUID + ' 【索引表的Trainman4】不存在';
          if strResult <>'' then
            List.Add(strResult)   ;
        end;
errLabel:
        if Assigned(OnResult) then
        begin
          if list.Count <> 0 then
            OnResult(List)  ;
        end;

        list.Clear;
        SetLength(GroupTrainmanIndexArray,0);

        Inc(nPos);
        Next ;
      end;
    end;
  finally
    adoQuery.Free;
    list.Free;
  end;
end;

procedure TDBGroupTrainmanIndex.DataToAdo(ADOQuery: TADOQuery;
  GroupTrainmanIndex: TRsGroupTrainmanIndex);
begin
  with ADOQuery do
  begin
    FieldByName('strGroupGUID').AsString := GroupTrainmanIndex.strGroupGUID;
    FieldByName('strTrainmanGUID').AsString := GroupTrainmanIndex.strTrainmanGUID;
    FieldByName('nTrainmanIndex').AsInteger := GroupTrainmanIndex.nTrainmanIndex;
    FieldByName('dtCreateTime').AsDateTime := GroupTrainmanIndex.dtCreateTime;
    FieldByName('strDutyUserGUID').AsString := GroupTrainmanIndex.strDutyUserGUID;
    FieldByName('strDutyUserName').AsString := GroupTrainmanIndex.strDutyUserName;
    FieldByName('strSiteGUID').AsString := GroupTrainmanIndex.strSiteGUID;
    FieldByName('strSiteName').AsString := GroupTrainmanIndex.strSiteName;
  end;
end;

procedure TDBGroupTrainmanIndex.Delete(GroupGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'delete from TAB_Nameplate_Group_TrainmanIndex where strGroupGUID =  '+ QuotedStr(GroupGUID);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBGroupTrainmanIndex.Insert(
  GroupTrainmanIndex: TRsGroupTrainmanIndex): Boolean;
var
  strSql:string;
  ADOQuery: TADOQuery;
begin
  Result := False ;
  ADOQuery := TADOQuery.Create(nil);
  try
    strSql := 'select * from TAB_Nameplate_Group_TrainmanIndex where 1 = 2 ';
    with ADOQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      Append;
      DataToAdo(ADOQuery,GroupTrainmanIndex);
      Post;
      Result := True ;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBGroupTrainmanIndex.Query(GroupGUID:string;
  var GroupTrainmanIndexArray: TRsGroupTrainmanIndexArray);
var
  strSql:string;
  ADOQuery: TADOQuery;
  i : Integer ;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    strSql := 'select * from TAB_Nameplate_Group_TrainmanIndex where 1 = 1 ';
    if  GroupGUID <> '' then
      strSql := strSql + 'and strGroupGUID = ' + QuotedStr(GroupGUID) ;

    strSql := strSql + 'order by nTrainmanIndex' ;

    with ADOQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if RecordCount = 0  then
        Exit;
      SetLength(GroupTrainmanIndexArray,RecordCount);
      i := 0 ;
      while not eof do
      begin
        AdoToData(GroupTrainmanIndexArray[i],ADOQuery);
        Next;
        Inc(i);
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBGroupTrainmanIndex.Remove(GroupGUID, TrainmanGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'delete from TAB_Nameplate_Group_TrainmanIndex where strGroupGUID =  '+ QuotedStr(GroupGUID);
  strSql := strSql + 'and strTrainmanGUID = ' + QuotedStr(TrainmanGUID);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TDBGroupTrainmanIndex.UpdateFromNameplateGroup(ShowProgessEvent:TShowProgessEvent;DutyUserGUID:string;DutyUserName:string;SiteGUID:string;SiteName:string;
  DeleteOldData: Boolean);
var
  GroupTrainmanIndex: TRsGroupTrainmanIndex;
  strSql : string;
  adoQuery : TADOQuery;
  strTrainmanGUID:string;
  nPos:Integer ;
begin
  nPos := 1 ;
  strSql := 'delete from TAB_Nameplate_Group_TrainmanIndex ';
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      if DeleteOldData then
      begin
        ExecSQL;
        Close;
      end;

      strSql := 'select * from TAB_Nameplate_Group' ;
      SQL.Text := strSql;
      Open;

      while not eof do
      begin

        GroupTrainmanIndex.dtCreateTime := Now;
        GroupTrainmanIndex.strGroupGUID := FieldByName('strGroupGUID').AsString ;
        GroupTrainmanIndex.strDutyUserGUID := DutyUserGUID ;
        GroupTrainmanIndex.strDutyUserName := DutyUserName ;
        GroupTrainmanIndex.strSiteGUID := SiteGUID ;
        GroupTrainmanIndex.strSiteName := SiteName ;

        //司机1
        strTrainmanGUID :=  FieldByName('strTrainmanGUID1').AsString  ;
        if strTrainmanGUID <> '' then
        begin
          GroupTrainmanIndex.strTrainmanGUID := strTrainmanGUID;
          GroupTrainmanIndex.nTrainmanIndex := 1;
          Self.Insert(GroupTrainmanIndex);
        end;

        //司机2
        strTrainmanGUID :=  FieldByName('strTrainmanGUID2').AsString  ;
        if strTrainmanGUID <> '' then
        begin
          GroupTrainmanIndex.strTrainmanGUID := strTrainmanGUID;
          GroupTrainmanIndex.nTrainmanIndex := 2;
          Self.Insert(GroupTrainmanIndex);
        end;

        //司机3
        strTrainmanGUID :=  FieldByName('strTrainmanGUID3').AsString  ;
        if strTrainmanGUID <> '' then
        begin
          GroupTrainmanIndex.strTrainmanGUID := strTrainmanGUID;
          GroupTrainmanIndex.nTrainmanIndex := 3;
          Self.Insert(GroupTrainmanIndex);
        end;

        //司机4
        strTrainmanGUID :=  FieldByName('strTrainmanGUID4').AsString  ;
        if strTrainmanGUID <> '' then
        begin
          GroupTrainmanIndex.strTrainmanGUID := strTrainmanGUID;
          GroupTrainmanIndex.nTrainmanIndex := 4;
          Self.Insert(GroupTrainmanIndex);
        end;

        if Assigned(ShowProgessEvent) then
          ShowProgessEvent( nPos / RecordCount  );
        inc(nPos);
        Next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
