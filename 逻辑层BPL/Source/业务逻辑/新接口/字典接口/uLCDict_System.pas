unit uLCDict_System;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uSystemDict,superobject,uTrainmanJiaolu;
type
  RSysDictItem = record
    TypeID: integer;
    TypeName: string;
  end;

  TSysDictItemArray = array of RSysDictItem;
  //ϵͳ�ֵ�ӿ�
  TRsLCSystemDict = class(TBaseWebInterface)
  public
    //��ȡ�����������
    procedure GetDrinkTypeArray(out DictItemArray : TSysDictItemArray);
    //��ȡ��֤��ʽ����
    procedure GetVerifyArray(out DictItemArray : TSysDictItemArray);
    //��ȡ��ƽ������
    procedure GetDrinkResult(out DictItemArray : TSysDictItemArray);
    //��ȡ�˰�ϵͳʱ�䶨����Ϣ
    function GetKernelTimeConfig(out TimeConfig: RRsKernelTimeConfig): Boolean;
  private
    function JsonToSysDictItem(iJson: ISuperObject): RSysDictItem;
  end;
implementation

{ TRsLCSystemDict }

procedure TRsLCSystemDict.GetDrinkResult(
  out DictItemArray: TSysDictItemArray);
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  strResult := Post('TF.RunSafty.BaseDict.LCSystemDict.GetDrinkResult',json.AsString);

  json.Clear();
    
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  SetLength(DictItemArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    DictItemArray[i] := JsonToSysDictItem(json.AsArray[i]);
  end;
end;


procedure TRsLCSystemDict.GetDrinkTypeArray(
  out DictItemArray: TSysDictItemArray);
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  strResult := Post('TF.RunSafty.BaseDict.LCSystemDict.GetDrinkTypeArray',json.AsString);

  json.Clear();
    
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  SetLength(DictItemArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    DictItemArray[i] := JsonToSysDictItem(json.AsArray[i]);
  end;
end;

function TRsLCSystemDict.GetKernelTimeConfig(
  out TimeConfig: RRsKernelTimeConfig): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  strResult := Post('TF.Runsafty.LCSystemDict.KernelTimeConfig.Get',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  Result := json.I['Exist'] = 1;
  if Result then
  begin
    TimeConfig.nMinCallBeforeChuQing := json.O['Config.nMinCallBeforeChuQing'].AsInteger;
    TimeConfig.nMinChuQingBeforeStartTrain_Z := json.O['Config.nMinChuQingBeforeStartTrain_Z'].AsInteger;
    TimeConfig.nMinChuQingBeforeStartTrain_K := json.O['Config.nMinChuQingBeforeStartTrain_K'].AsInteger;
    TimeConfig.nMinDayWorkStart := json.O['Config.nMinDayWorkStart'].AsInteger;
    TimeConfig.nMinNightWokrStart := json.O['Config.nMinNightWokrStart'].AsInteger;
  end;

end;


procedure TRsLCSystemDict.GetVerifyArray(out DictItemArray: TSysDictItemArray);
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  json := CreateInputJson;
  strResult := Post('TF.RunSafty.BaseDict.LCSystemDict.GetVerifyArray',json.AsString);

  json.Clear();
    
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  SetLength(DictItemArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    DictItemArray[i] := JsonToSysDictItem(json.AsArray[i]);
  end;
end;

function TRsLCSystemDict.JsonToSysDictItem(iJson: ISuperObject): RSysDictItem;
begin
  Result.TypeID := iJson.I['TypeID'];
  Result.TypeName := iJson.S['TypeName'];
end;

end.
