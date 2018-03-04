unit uDBDrink;

interface
uses
  ADODB,Classes;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBDrink
  /// 说明:测酒记录查询
  //////////////////////////////////////////////////////////////////////////////
  TDBDrink = class
    //获取所有检查信息
    class procedure GetDrinks(beginDate,endDate : TDateTime;areaGUID: string;
      strTrainmanName,strTrainmanNumber:string;nIsLocal : Integer;out Rlt :TADOQuery;ADOConn : TADOConnection);
    class procedure GetDrinkImage(drinkGUID : string;var DrinkPhoto : TMemoryStream;ADOConn : TADOConnection);
  end;

implementation
uses
  SysUtils,DB;
{ TDBDrink }

class procedure TDBDrink.GetDrinkImage(drinkGUID: string; var DrinkPhoto : TMemoryStream;ADOConn : TADOConnection);
var
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := 'select DrinkImage from TAB_Drink_Information where strGUID = ' + QuotedStr(drinkGUID);
      Open;
      if RecordCount > 0 then
      begin
        TBlobField(FieldByName('DrinkImage')).SaveToStream(DrinkPhoto);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBDrink.GetDrinks(beginDate, endDate: TDateTime; areaGUID,
  strTrainmanName, strTrainmanNumber: string; nIsLocal: Integer;
  out Rlt: TADOQuery;ADOConn : TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_Drink_Information where strAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s ';
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

end.
