unit uDrink;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,Graphics,DB,uFtpConnect;
type
  //测酒类型枚举
  TDrinkTypeEnum = (dteUnknown{未知测酒类型},dteSignin{签到测酒},dteChuQin{出勤测酒},dteTuiQin{退勤测酒});

  //////////////////////////////////////////////////////////////////////////////
  //测酒信息结构
  //////////////////////////////////////////////////////////////////////////////
  RDrink = record
    GUID : string;
    TrainmanGUID : string;        //乘务员GUID
    TrainmanNumber : string;      //乘务员工号
    TrainNo : string;             //所属车次
    DrinkResult : Integer;        //检查区域GUID
    VerifyID :  Integer;          //验证方式ID
    CreateTime : TDateTime;       //检查时间
    DutyGUID : string;            //值班员GUID
    DrinkImage : TPicture;        //测酒照片
    AreaGUID : string ;           //测酒地点GUID
    IsLocal : integer;            //是否本地司机
    DrinkType : TDrinkTypeEnum;   //测酒类型
    public
      procedure Init;
      procedure Free;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///测酒信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TDrinkOpt = class
  public
    //根据检查GUID获取测酒信息
    class function GetDrink(drinkGUID : string) : RDrink;
    //获取所有检查信息
    class procedure GetDrinks(beginDate,endDate : TDateTime;areaGUID: string;strTrainmanName,strTrainmanNumber:string;nIsLocal : Integer;out Rlt :TADOQuery);
    //添加检查
    class function AddDrink(drink:RDrink):boolean;
    //获取测酒的类型名称
    class function GetDrinkTypeName(DrinkType : TDrinkTypeEnum) : string;
  end;
implementation

{ TRoomOpt }
uses
  udataModule;


{ RRoom }



{ TDrinkOpt }

class function TDrinkOpt.AddDrink(drink: RDrink): boolean;
var
  ado : TADOQuery;
  guid : string;
  //(闫)
  dtDrinkTime: TDateTime;
  filename: string;
begin
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select * from TAB_Drink_Information where 1=2';
      if drink.IsLocal = 0 then
      begin
        Sql.Text := 'select * from TAB_Drink_OutSide where 1=2';      
      end;
      Open;
      Append;
      FieldByName('strTrainNo').AsString := drink.TrainNo;
      if drink.IsLocal = 1 then
      begin
        FieldByName('strGUID').AsString := guid;
        FieldByName('strTrainmanGUID').AsString := drink.TrainmanGUID;
      end
      else begin
        FieldByName('strGUID').AsString := guid;
        FieldByName('strTrainmanNumber').AsString := drink.TrainmanGUID;      
      end;
      FieldByName('nDrinkResult').AsInteger := drink.DrinkResult;
      FieldByName('nVerifyID').AsInteger := drink.VerifyID;
      dtDrinkTime := DMGlobal.GetNow;
      FieldByName('dtCreateTime').AsDateTime := dtDrinkTime;
      FieldByName('strDutyGUID').AsString := drink.DutyGUID;
      //TBlobField(FieldByName('DrinkImage')).LoadFromFile(DMGlobal.AppPath + 'temp.jpg');
      FieldByName('strAreaGUID').AsString := drink.AreaGUID;
      if FindField('nDrinkType') <> nil then
      begin
        FieldByName('nDrinkType').AsInteger := Ord(drink.DrinkType);
      end;   
      Post;
      Result := true;

      //(闫)
      filename := drink.TrainmanNumber +
        FormatDateTime('yyyymmddhhnnss',FieldByName('dtCreateTime').AsDateTime) + '.jpg';
      if not DirectoryExists(DMGlobal.AppPath + '\upload\picture') then
      begin
        ForceDirectories(DMGlobal.AppPath + '\upload\picture');
      end;
      drink.DrinkImage.SaveToFile(DMGlobal.AppPath + '\upload\picture\' + filename);
      DMGlobal.FTPCon.UpLoad(filename,True);
    end;
  finally
    ado.Free;
  end;

end;

class function TDrinkOpt.GetDrink(drinkGUID: string): RDrink;
var
  ado : TADOQuery;
  drinktypeField : TField;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Drink_Information  where strGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(drinkGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.GUID := FieldByName('strGUID').AsString;
        Result.TrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        Result.DrinkResult := FieldByName('nDrinkResult').AsInteger;

        Result.VerifyID := FieldByName('nVerifyID').AsInteger;
        Result.CreateTime := FieldByName('dtCreateTime').AsDateTime;
        Result.DutyGUID := FieldByName('strDutyGUID').AsString;
        Result.AreaGUID := FieldByName('strDrinkAreaGUID').AsString;
        Result.IsLocal := FieldByName('nIsLocal').AsInteger;
        Result.TrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        Result.TrainNo := FieldByName('strTrainNo').AsString;
        //(闫)
//        TBlobField(FieldByName('DrinkImage')).SaveToFile(DMGlobal.AppPath + 'temp.jpg');
//        Result.DrinkImage.LoadFromFile(DMGlobal.AppPath + 'temp.jpg');
        drinkTypeField := FindField('nDrinkType');
        result.DrinkType := dteUnknown;
        if drinktypeField <> nil then
        begin
          if not drinktypeField.IsNull then
          begin
            Result.DrinkType := TdrinkTypeEnum(drinktypeField.AsInteger);
          end;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TDrinkOpt.GetDrinks(beginDate,endDate : TDateTime;areaGUID: string;strTrainmanName,strTrainmanNumber:string;nIsLocal : Integer;out Rlt :TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := DMGlobal.ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_Drink_Information where strDrinkAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s ';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  if nIsLocal > -1 then
  begin
    Rlt.SQL.Text := Rlt.SQL.Text + ' and nIsLocal = %d ';
    Rlt.SQL.Text := Format(Rlt.SQL.Text,[nIsLocal]);
  end;
  if strTrainmanNumber <> '' then
  begin
    Rlt.SQL.Text := Rlt.SQL.Text + ' and strTrainmanNumber = %s ';
    Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(strTrainmanNumber)]);
  end;
  if strTrainmanName <> '' then
  begin
    Rlt.SQL.Text := Rlt.SQL.Text + ' and strTrainmanName like %s ';
    Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr('%'+strTrainmanName+'%')]);
  end;


  Rlt.SQL.Text := Rlt.SQL.Text + ' order by dtCreateTime desc';
  Rlt.Open;
end;

class function TDrinkOpt.GetDrinkTypeName(DrinkType: TDrinkTypeEnum): string;
begin
  Result := '未知类型';
  case DrinkType of
    dteUnknown: Result := '未知类型';
    dteSignin: Result := '签到测酒';
    dteChuQin: Result := '出勤测酒';
    dteTuiQin: Result := '退勤测酒';
  end;
end;

{ RDrink }

procedure RDrink.Free;
begin
  if DrinkImage <> nil then
    DrinkImage.Free;
end;

procedure RDrink.Init;
begin
  GUID := '';
  TrainmanGUID := '';        //乘务员GUID
  DrinkResult := 0;         //检查区域GUID
  VerifyID := 0;          //验证方式ID
  CreateTime := 0;       //检查时间
  DutyGUID := '';                   //值班员GUID
  DrinkImage := TPicture.Create;    //测酒照片
  AreaGUID := '';                   //测酒地点GUID
end;

end.
