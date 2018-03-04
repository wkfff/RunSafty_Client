unit uOrg;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //区域信息
  //////////////////////////////////////////////////////////////////////////////
  RArea = record
    strGUID : string;           //区域GUID
    strAreaName : string;       //区域名称
    nDeleteState : Integer;     //删除状态
    public
      procedure Init;
  end;
  TAreaArray = array of RArea;
  //////////////////////////////////////////////////////////////////////////////
  ///区域信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TAreaOpt = class
  public
    //是否已经存在指定的区域名称
    class function ExistArea(areaName:String) : boolean;
    //根据区域GUID获取区域信息
    class function GetArea(areaGUID:string) : RArea;
    //获取所有的区域信息
    class procedure GetAreas(out Rlt: TADOQuery);

    //获取所有的区域信息
    class procedure GetAreaArray(out areaArray: TAreaArray);
    //添加区域
    class function AddArea(area:RArea):string;
    //修改区域
    class function UpdateArea(area:RArea):boolean;
    //删除区域信息
    class function DeleteArea(areaGUID : string):boolean;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //分区信息
  //////////////////////////////////////////////////////////////////////////////
  RPart = record
    strGUID : string;           //分区GUID
    strPartName : string;       //分区名称
    strPartNumber : string;     //分区编号
    strAreaGUID : string;       //所属区域GUID
    nDeleteState : Integer;     //删除状态
    public
      procedure Init;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///分区信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TPartOpt = class
  public
    //是否已经存在指定的分区名称
    class function ExistPart(partName:String) : boolean;
    //根据分区GUID获取分区信息
    class function GetPart(partGUID:string) : RPart;
    //获取所有的分区信息
    class procedure GetParts(strAreaGUID : string;out Rlt: TADOQuery);
    //添加分区
    class function AddPart(part:RPart):string;
    //修改分区
    class function UpdatePart(part:RPart):boolean;
    //删除分区信息
    class function DeletePart(partGUID : string):boolean;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///车间信息
  //////////////////////////////////////////////////////////////////////////////
  RWorkShop = record
    strGUID : string;
    strWorkShopName : string;
    strPartGUID : string;
    nDeleteState : Integer;
  public
    procedure Init;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///车间信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TWorkShopOpt = class
  public
    //是否已经存在指定的车间名称
    class function ExistWorkShop(partGUID,workShopName:String) : boolean;
    //根据车间GUID获取车间信息
    class function GetWorkShop(workShopGUID:string) : RWorkShop;
    //获取所有的车间信息
    class PROCEDURE GetWorkShops(strAreaGUID,strPartGUID,strWorkShopName : string;out Rlt: TADOQuery);
    //添加车间
    class function AddWorkShop(workShop:RWorkShop):string;
    //修改车间
    class function UpdateWorkShop(workShop:RWorkShop):boolean;
    //删除车间信息
    class function DeleteWorkShop(workShopGUID : string):boolean;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///班组信息
  //////////////////////////////////////////////////////////////////////////////
  RGroup = record
    strGUID : string;
    strGroupName : string;
    strWorkShopGUID : string;
    nDeleteState : Integer;
  public
    procedure Init;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///车间信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TGroupOpt = class
  public
    //是否已经存在指定的班组名称
    class function ExistGroup(workShopGUID,groupName:String) : boolean;
    //根据班组GUID获取班组信息
    class function GetGroup(groupGUID:string) : RGroup;
    //获取所有的班组信息
    class procedure GetGroups(strAreaGUID,strPartGUID,strWorkShopGUID,strGroupName : string;out RLT : TADOQuery);
    //添加班组
    class function AddGroup(group:RGroup):string;
    //修改班组
    class function UpdateGroup(group:RGroup):boolean;
    //删除班组
    class function DeleteGroup(groupGUID : string):boolean;
  end;

implementation

{ TAreaOpt }
uses
  udataModule, uRoom, DB;
class function TAreaOpt.AddArea(area: RArea): string;
var
  ado : TADOQuery;
  guid : string;
begin
  Result := '';
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'insert into TAB_Org_Area  (strGUID,strAreaName,nDeleteState) ' +
        ' values (%s,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(area.strAreaName),area.nDeleteState]);
      if ExecSQL > 0 then
        Result := guid;
    end;
  finally
    ado.Free;
  end;

end;

class function TAreaOpt.DeleteArea(areaGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Area  set nDeleteState=0 where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TAreaOpt.ExistArea(areaName:string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Area  where strAreaName = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaName)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TAreaOpt.GetArea(areaGUID: string): RArea;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Area  where strGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strAreaName := FieldByName('strAreaName').AsString;
        Result.nDeleteState := FieldByName('nDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TAreaOpt.GetAreaArray(out areaArray: TAreaArray);
var
  adoQuery : TADOQuery;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select * from VIEW_Org_Area  order by strAreaName';
      Open;
      SetLength(areaArray,RecordCount);
      i := 0;
      while not eof do
      begin
        areaArray[i].strGUID := FieldByName('strGUID').AsString;
        areaArray[i].strAreaName := FieldByName('strAreaName').AsString;
        areaArray[i].nDeleteState := FieldByName('nDeleteState').AsInteger;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TAreaOpt.GetAreas(out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := DMGlobal.ADOConn;
    Close;
    Sql.Text := 'select * from VIEW_Org_Area  order by strAreaName';
    Open;
  end;

end;

class function TAreaOpt.UpdateArea(area: RArea): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Area  set strAreaName=%s where strGUID=%s' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(area.strAreaName),QuotedStr(area.strGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

{ RArea }

procedure RArea.Init;
begin
  strGUID := '';
  strAreaName := '';
  nDeleteState := 1;
end;

{ RPart }

procedure RPart.Init;
begin
  StrGUID := '';
  strPartName := '';
  strAreaGUID := '';
  strPartNumber := '';
  nDeleteState := 1;
end;

{ TPartOpt }

class function TPartOpt.AddPart(part: RPart): string;
var
  ado : TADOQuery;
  guid : string;
begin
  Result := '';
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'insert into TAB_Org_Part  (strGUID,strPartName,strPartNumber,strAreaGUID,nDeleteState) ' +
        ' values (%s,%s,%s,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(part.strPartName),
        QuotedStr(part.strPartNumber),QuotedStr(part.strAreaGUID),part.nDeleteState]);
      if ExecSQL > 0 then
        Result := guid;
    end;
  finally
    ado.Free;
  end;
end;

class function TPartOpt.DeletePart(partGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Part  set nDeleteState=0 where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(partGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TPartOpt.ExistPart(partName: String): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Part  where strPartName = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(partName)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TPartOpt.GetPart(partGUID: string): RPart;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Part  where strGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(partGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strPartName := FieldByName('strPartName').AsString;
        Result.strAreaGUID := FieldByName('strAreaGUID').AsString;
        Result.strPartNumber := FieldByName('strPartNumber').AsString;        
        Result.nDeleteState := FieldByName('nPartDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TPartOpt.GetParts(strAreaGUID : string;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := DMGlobal.ADOConn;
    Close;
    Sql.Text := 'select * from VIEW_Org_Part ';
    if strAreaGUID <> '' then
    begin
      Sql.Text := SQL.Text + '  where strAreaGUID = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strAreaGUID)]);
    end;
    Sql.Text := Sql.Text + ' order by strAreaName,strPartNumber';
    Open;
  end;

end;

class function TPartOpt.UpdatePart(part: RPart): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Part  set strPartName=%s,strPartNumber=%s,strAreaGUID=%s where strGUID=%s' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(part.strPartName),QuotedStr(part.strPartNumber),QuotedStr(part.strAreaGUID),QuotedStr(part.strGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

{ RWorkShop }

procedure RWorkShop.Init;
begin
  strGUID := '';
  strWorkShopName := '';
  strPartGUID := '';
  nDeleteState := 1;
end;

{ TWorkShopOpt }

class function TWorkShopOpt.AddWorkShop(workShop: RWorkShop): string;
var
  ado : TADOQuery;
  guid : string;
begin
  Result := '';
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'insert into TAB_Org_WorkShop  (strGUID,strWorkShopName,strPartGUID,nDeleteState) ' +
        ' values (%s,%s,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(workShop.strWorkShopName),
        QuotedStr(workShop.strPartGUID),workShop.nDeleteState]);
      if ExecSQL > 0 then
        Result := guid;
    end;
  finally
    ado.Free;
  end;
end;

class function TWorkShopOpt.DeleteWorkShop(workShopGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_WorkShop  set nDeleteState=0 where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(workShopGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TWorkShopOpt.ExistWorkShop(partGUID,
  workShopName: String): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_WorkShop  where strPartGUID = %s and strWorkShopName=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(partGUID),QuotedStr(workShopName)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TWorkShopOpt.GetWorkShop(workShopGUID: string): RWorkShop;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_WorkShop  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(workShopGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strWorkShopName := FieldByName('strWorkShopName').AsString;
        Result.strPartGUID := FieldByName('strPartGUID').AsString;
        Result.nDeleteState := FieldByName('nDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class PROCEDure TWorkShopOpt.GetWorkShops(strAreaGUID, strPartGUID,
  strWorkShopName: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := DMGlobal.ADOConn;
    Close;
    Sql.Text := 'select * from VIEW_Org_WorkShop  where 1=1 ';
    if strAreaGUID <> '' then
    begin
      Sql.Text := Sql.Text + ' and strAreaGUID=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strAreaGUID)]);
    end;
    if strPartGUID <> '' then
    begin
      Sql.Text := Sql.Text + ' and strPartGUID = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strPartGUID)]);
    end;
    if strWorkShopName <> '' then
    begin
      Sql.Text := Sql.Text + ' and strWorkShopName like %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr('%' + strWorkShopName+ '%') ]);
    end;
    Sql.Text := Sql.Text + ' order by strAreaName,strPartNumber,strWorkShopName';
    Open;
  end;
end;

class function TWorkShopOpt.UpdateWorkShop(workShop: RWorkShop): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_WorkShop  set strWorkShopName=%s,strPartGUID=%s where strGUID=%s' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(workShop.strWorkShopName),QuotedStr(workShop.strPartGUID),QuotedStr(workShop.strGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

{ TGroupOpt }

class function TGroupOpt.AddGroup(group: RGroup): string;
var
  ado : TADOQuery;
  guid : string;
begin
  Result := '';
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'insert into TAB_Org_Group  (strGUID,strGroupName,strWorkShopGUID,nDeleteState) ' +
        ' values (%s,%s,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(group.strGroupName),
        QuotedStr(group.strWorkShopGUID),group.nDeleteState]);
      if ExecSQL > 0 then
        Result := guid;
    end;
  finally
    ado.Free;
  end;
end;

class function TGroupOpt.DeleteGroup(groupGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Group  set nDeleteState=0 where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(groupGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TGroupOpt.ExistGroup(workShopGUID, groupName: String): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Group  where strWorkShopGUID = %s and strGroupName=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(workShopGUID),QuotedStr(groupName)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TGroupOpt.GetGroup(groupGUID: string): RGroup;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Group  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(groupGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strGroupName := FieldByName('strGroupName').AsString;
        Result.strWorkShopGUID := FieldByName('strWorkshopGUID').AsString;
        Result.nDeleteState := FieldByName('nDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TGroupOpt.GetGroups(strAreaGUID, strPartGUID, strWorkShopGUID,
  strGroupName: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := DMGlobal.ADOConn;
    Close;
    Sql.Text := 'select * from VIEW_Org_Group  where 1=1 ';
    if strAreaGUID <> '' then
    begin
      Sql.Text := Sql.Text + ' and strAreaGUID=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strAreaGUID)]);
    end;
    if strPartGUID <> '' then
    begin
      Sql.Text := Sql.Text + ' and strPartGUID = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strPartGUID)]);
    end;
    if strWorkShopGUID <> '' then
    begin
      Sql.Text := Sql.Text + ' and strWorkShopGUID = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strWorkShopGUID)]);
    end;
    if strGroupName <> '' then
    begin
      Sql.Text := Sql.Text + ' and strGroupName like %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr('%' + strGroupName+ '%') ]);
    end;
    Sql.Text := Sql.Text + ' order by strAreaName,strPartNumber,strWorkShopName,strGroupName';
    Open;
  end;
end;

class function TGroupOpt.UpdateGroup(group: RGroup): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_Group  set strGroupName=%s,strWorkShopGUID=%s where strGUID=%s' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(group.strGroupName),QuotedStr(group.strWorkShopGUID),QuotedStr(group.strGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

{ RGroup }

procedure RGroup.Init;
begin
  strGUID := '';
  strGroupName := '';
  strWorkShopGUID := '';
  nDeleteState := 1;
end;

end.
