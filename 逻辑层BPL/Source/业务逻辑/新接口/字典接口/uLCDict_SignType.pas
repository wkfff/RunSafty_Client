unit uLCDict_SignType;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject,uGuideGroup;
type
  //常用意见维护
  TRsLCSignType = class(TBaseWebInterface)
  public
    //获取常用的超劳意见
    procedure GetSignType(TypeList : TStrings);
    //添加常用签署意见
    procedure AddSignType(SignText : string);
    //删除常用签署意见
    procedure DeleteSignType(SignText : string); 
  end;
implementation

{ TRsLCSignType }

procedure TRsLCSignType.AddSignType(SignText: string);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['SignText'] := SignText;

  strResult := Post('TF.RunSafty.Bll.BaseDict.SignType.AddSignType',json.AsString);
    
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
    raise Exception.Create(ErrStr);

end;

procedure TRsLCSignType.DeleteSignType(SignText: string);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['SignText'] := SignText;

  strResult := Post('TF.RunSafty.Bll.BaseDict.SignType.DeleteSignType',json.AsString);
    
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
    raise Exception.Create(ErrStr);

end;

procedure TRsLCSignType.GetSignType(TypeList: TStrings);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;

  strResult := Post('TF.RunSafty.Bll.BaseDict.SignType.GetSignType',json.AsString);
    
  json.Clear();
  TypeList.Clear;
  
  if not GetJsonResult(strResult,json,ErrStr) then
    raise Exception.Create(ErrStr);

  jsonArray := json.AsArray;
  for I := 0 to jsonArray.Length - 1 do
  begin
    TypeList.Add(jsonArray[i].AsString);
  end;

end;

end.
