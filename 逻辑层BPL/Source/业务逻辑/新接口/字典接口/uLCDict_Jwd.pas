unit uLCDict_Jwd;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uJWD,superobject;
type
  //机务段信息接口
  TRsLCJwd = class(TBaseWebInterface)
  public
    {功能:获取全部机务段信息}
    function GetAllJwdList(var JWDArray:TRsJWDArray;out ErrStr: string): Boolean;
  private
    {功能:JSON反序列化为结构体}
    procedure jsonToJwd(iJson: ISuperObject;var Jwd: RRsJWD);
  end;
implementation

{ TRsLCJwd }

function TRsLCJwd.GetAllJwdList(var JWDArray: TRsJWDArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  try
    strResult := Post('TF.RunSafty.BaseDict.LCJwd.GetAllJwdList',json.AsString);

    json.Clear();
    
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;


    SetLength(JWDArray,json.AsArray.Length);
    for I := 0 to json.AsArray.Length - 1 do
    begin
      jsonToJwd(json.AsArray[i],JWDArray[i]);
    end;

    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

procedure TRsLCJwd.jsonToJwd(iJson: ISuperObject; var Jwd: RRsJWD);
begin
  Jwd.nID := iJson.I['nID'];
  Jwd.strCode := iJson.S['strCode'];
  Jwd.strName := iJson.S['strName'];
  Jwd.strShortName := iJson.S['strShortName'];
  Jwd.strPinYinCode := iJson.S['strPinYinCode'];
  Jwd.strStatCode := iJson.S['strStatCode'];
  Jwd.strUserCode := iJson.S['strUserCode'];
  Jwd.strLJCode := iJson.S['strLJCode'];
  Jwd.dtLastModify := StrToDateTime(iJson.S['dtLastModify']);
  //是否显示
  Jwd.bIsVisible := iJson.B['bIsVisible'];
end;                          
end.
