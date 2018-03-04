unit uJsonSerialize;

interface
uses
  Classes,SysUtils,superObject,TypInfo,Contnrs,EncdDecd;
type
  {
  参考CnPack组件CnIni单元
  
  TJsonSerialize 序列化及反序列化对象
  需要序列化的属性需要为Pushlied
  ObjectList类型序化为数组
  支持的类型有：
    Integer
    Char
    String
    Float
    Boolean
    DateTime     --时间类型序列化为yyyy-mm-dd hh:nn:ss
    Int64
    Enumeration
    Class        --对象类型的属性必需继承自 TPersistent或TObjectList才能序列化及反序列化,
                    如果是ObjectList则其元素必需继承自TPersistent

    类属性可以是TMemoryStream类型，内容以BASE64编码按字符串存储

    增加类属性为ISuperObject的支持
  }

  TSerialPersistentClass = class of TSerialPersistent;
  TSerialPersistent = class(TPersistent)
  public
    constructor Create();virtual;
  public
    procedure Clone(Src: TSerialPersistent);
  end;

  TSerialObjectList = class(TObjectList)
  public
    function GetSerialClass: TPersistentClass;virtual;abstract;
  end;
  TJsonSerialize = class
  public
    class function EncodeStream(Value: TStream): string;
    class procedure DecodeStream(const Value: string;OutPut: TStream);
    {功能:序列化对象}
    class function Serialize(AObject: TPersistent): ISuperObject;overload;
    {功能:序列化OBJECTLIST对象，元素必需继承TPersistent}
    class function Serialize(AObject: TObjectList): ISuperObject;overload;

    {功能:反序列化对象，不支持ObjectList属性，如果有此类属性，
      需要使用另一个重载方法，分别把序列化}
    class procedure DeSerialize(Value: ISuperObject;AObject: TPersistent);overload;
    {功能:反序列化OBJECTLIST对象，需要传入类引用，且元素必需继承TPersistent}
    class procedure DeSerialize(Value: ISuperObject;AObject: TObjectList;PersistentClass: TPersistentClass);overload;

    class procedure DeSerialize(Value: ISuperObject;AObject: TSerialObjectList);overload;

    class function SerializeAsString(AObject: TPersistent): string;overload;
    class function SerializeAsString(AObject: TObjectList): string;overload;
    class procedure DeSerializeFromString(const Value: string;AObject: TPersistent);overload;
    class procedure DeSerializeFromString(const Value: string;AObject: TObjectList;PersistentClass: TPersistentClass);overload;
  end;


  TJsonParse = class
  public
    class function ToString(Value: ISuperObject): string;
    class function ToInt(Value: ISuperObject): integer;
    class function ToDateTime(Value: ISuperObject): TDateTime;
    class function ToBoolean(Value: ISuperObject): Boolean;

    class procedure SetDateTime(Obj: ISuperObject;FieldName: string;Value: TDateTime);
  end;

implementation

function JsonStrToDateTime(const Value: string): TDateTime;
var
  FormatSettings: TFormatSettings;
begin
  FormatSettings.TimeSeparator := ':';
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FormatSettings.LongDateFormat := 'yyyy-MM-dd';
  FormatSettings.ShortTimeFormat := 'HH:mm';
  FormatSettings.LongTimeFormat := 'HH:mm:ss';

  Result := StrToDateTimeDef(Value,0,FormatSettings);
end;
function IsBooleanType(PInfo: PTypeInfo): Boolean;
begin
  Result := (PInfo.Kind = tkEnumeration) and
    (GetTypeData(PInfo)^.BaseType^ = TypeInfo(Boolean));
end;
function IsBoolType(PInfo: PTypeInfo): Boolean;
begin
  Result := (PInfo^.Kind = tkEnumeration) and
    (GetTypeData(PInfo)^.MinValue < 0); // Longbool/wordbool/bytebool
end;
function IsDateTimeType(PInfo: PTypeInfo): Boolean;
begin
  Result := PInfo = TypeInfo(TDateTime);
end;
function PropInfoName(PropInfo: PPropInfo): string;
begin
  Result := string(PropInfo^.Name);
end;

function TypeInfoName(TypeInfo: PTypeInfo): string;
begin
  Result := string(TypeInfo^.Name);
end;
{ TJsonSerialize }

class procedure TJsonSerialize.DeSerialize(Value: ISuperObject;
  AObject: TPersistent);
var
  S: string;
  WS: WideString;
  Count: Integer;
  PropIdx: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
  Obj: TObject;
  iJson: ISuperObject;
begin

  if (Value = nil)or ((not Value.IsType(stObject)) and (not Value.IsType(stNull)))  then
    raise Exception.Create('传入JSON对象为nil或不是不是对象类型，无法反序列化为对象');

  if Value.IsType(stNull) then Exit;
      
  Count := GetPropList(AObject.ClassInfo, tkProperties - [tkArray,tkDynArray,tkRecord,tkVariant, tkMethod], nil);
  GetMem(PropList, Count * SizeOf(Pointer));
  try
    GetPropList(AObject.ClassInfo, tkProperties - [tkArray, tkDynArray, tkRecord,
      tkVariant, tkMethod], @PropList^[0]);
    for PropIdx := 0 to Count - 1 do
    begin
      PropInfo := PropList^[PropIdx];
      if Value.O[PropInfoName(PropInfo)] <> nil then
      begin
        if IsBooleanType(PropInfo^.PropType^) then
        begin
          if Value.B[PropInfoName(PropInfo)] then
            SetEnumProp(AObject, PropInfo, BoolToStr(True, True))
          else
            SetEnumProp(AObject, PropInfo, BoolToStr(False, True));
        end
        else if IsBoolType(PropInfo^.PropType^) then
        begin
          if Value.B[PropInfoName(PropInfo)] then
            SetOrdProp(AObject, PropInfo, -1)
          else
            SetOrdProp(AObject, PropInfo, 0);
        end
        else if IsDateTimeType(PropInfo^.PropType^) then
          SetFloatProp(AObject, PropInfo, JsonStrToDateTime(Value.S[PropInfoName(PropInfo)]))
        else
        begin
          case PropInfo^.PropType^^.Kind of
            tkInteger:
              SetOrdProp(AObject, PropInfo, Value.I[PropInfoName(PropInfo)]);
            tkChar:
              begin
                S := Value.S[PropInfoName(PropInfo)];
                if S <> '' then
                  SetOrdProp(AObject, PropInfo, Ord(S[1]));
              end;
            tkWChar:
              begin
                WS := Value.S[PropInfoName(PropInfo)];
                if WS <> '' then
                  SetOrdProp(AObject, PropInfo, Ord(WS[1]));
              end;
            tkString, tkLString, tkWString:
              SetStrProp(AObject, PropInfo, Value.S[PropInfoName(PropInfo)]);
            tkFloat:
              SetFloatProp(AObject, PropInfo, Value.D[PropInfoName(PropInfo)]);
            tkInt64:
              SetInt64Prop(AObject, PropInfo, Value.I[PropInfoName(PropInfo)]);
            tkEnumeration:
              SetOrdProp(AObject, PropInfo,Value.I[PropInfoName(PropInfo)]);
            tkClass:
              begin
                Obj := TObject(GetOrdProp(AObject, PropInfo));
                if (Obj <> nil) and (Obj is TPersistent) then
                begin
                  DeSerialize(Value.O[PropInfoName(PropInfo)],(Obj as TPersistent));
                end;

                if (Obj <> nil) and (Obj is TMemoryStream) then
                begin
                  if Value.O[PropInfoName(PropInfo)].DataType = stString then
                  begin
                    (Obj as TMemoryStream).Clear;
                    DecodeStream(Value.S[PropInfoName(PropInfo)],Obj as TStream);
                  end;

                end;

                if (Obj <> nil) and (Obj is TSerialObjectList) then
                begin
                  DeSerialize(Value.O[PropInfoName(PropInfo)],(Obj as TSerialObjectList));
                end;

              end;
            tkInterface:
              begin
                if SameText(Trim(PropInfo.PropType^.Name),'ISuperObject') then
                begin
                  iJson := SO(Value.O[PropInfoName(PropInfo)].AsString);
                  SetInterfaceProp(AObject, PropInfo,iJson);
                end;
              end;
          end;
        end;            
      end;
    end;
  finally
    FreeMem(PropList);
  end;
end;


class function TJsonSerialize.Serialize(AObject: TPersistent): ISuperObject;
var
  Count: Integer;
  PropIdx: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
  Intf: IInterface;
  Obj: TObject;
  iJson: ISuperObject;
begin
  if AObject = nil then
    raise Exception.Create('传入对象为空，无法序列化为JSON');
  Result := SO;
  
  Count := GetPropList(AObject.ClassInfo, tkProperties - [tkArray,tkDynArray,tkVariant, tkMethod, tkRecord], nil);
    
  GetMem(PropList, Count * SizeOf(Pointer));
  try
    GetPropList(AObject.ClassInfo, tkProperties - [tkArray, tkDynArray, tkRecord,
      tkVariant, tkMethod], @PropList^[0]);
    for PropIdx := 0 to Count - 1 do
    begin
      PropInfo := PropList^[PropIdx];
      if IsBooleanType(PropInfo^.PropType^) or IsBoolType(PropInfo^.PropType^) then
        Result.B[PropInfoName(PropInfo)] := GetOrdProp(AObject, PropInfo) <> 0
        else if IsDateTimeType(PropInfo^.PropType^) then
        begin
          if GetFloatProp(AObject, PropInfo) >= 0 then
            Result.S[PropInfoName(PropInfo)] := FormatDateTime('yyyy-mm-dd hh:nn:ss',GetFloatProp(AObject, PropInfo))
          else
            Result.S[PropInfoName(PropInfo)] := FormatDateTime('yyyy-mm-dd hh:nn:ss',0);
        end

        else
        begin
          case PropInfo^.PropType^^.Kind of
            tkInteger:
              Result.I[PropInfoName(PropInfo)] := GetOrdProp(AObject, PropInfo);
            tkChar:
              Result.S[PropInfoName(PropInfo)] := Char(GetOrdProp(AObject, PropInfo));
            tkWChar:
              Result.S[PropInfoName(PropInfo)] := WideChar(GetOrdProp(AObject, PropInfo));
            tkString, tkLString, tkWString:
              Result.S[PropInfoName(PropInfo)] := GetStrProp(AObject, PropInfo);
            tkFloat:
              Result.D[PropInfoName(PropInfo)] := GetFloatProp(AObject, PropInfo);
            tkInt64:
              Result.I[PropInfoName(PropInfo)] := GetInt64Prop(AObject, PropInfo);
            tkEnumeration:
              Result.I[PropInfoName(PropInfo)] := GetOrdProp(AObject, PropInfo);
            tkClass:
              begin
                Obj := TObject(GetOrdProp(AObject, PropInfo));
                if (Obj <> nil) and (Obj is TObjectList) then
                  Result.O[PropInfoName(PropInfo)] := Serialize(Obj as TObjectList);
                  
                if (Obj <> nil) and (Obj is TPersistent) then
                begin
                  Result.O[PropInfoName(PropInfo)] := Serialize(Obj as TPersistent);
                end;

                if (Obj <> nil) and (Obj is TMemoryStream) then
                begin
                  Result.S[PropInfoName(PropInfo)] := EncodeStream(Obj as TStream);
                end;
              end;
            tkInterface:
              begin
                Intf := GetInterfaceProp(AObject, PropInfo);
                if (Intf <> nil) and supports(Intf,ISuperObject,iJson) then
                begin
                  Result.O[PropInfoName(PropInfo)] := SO(iJson.AsString);
                end;
              end;
          end;
        end;
    end;
  finally
    FreeMem(PropList);
  end;
end;

class procedure TJsonSerialize.DecodeStream(const Value: string;
  OutPut: TStream);
var
  StringStream: TStringStream;
begin
  StringStream := TStringStream.Create(Value);
  try
    StringStream.Position := 0;
    EncdDecd.DecodeStream(StringStream,OutPut);
  finally
    StringStream.Free;
  end;


end;

class procedure TJsonSerialize.DeSerialize(Value: ISuperObject;
  AObject: TObjectList; PersistentClass: TPersistentClass);
var
  I: Integer;
  obj: TPersistent;
begin
  if Value = nil then Exit;

  if Value.IsType(stNull) then Exit;
  
  if not Value.IsType(stArray) then
    raise Exception.Create('传入JSON对象为nil或不是数组，无法反序列化为ObjectList');

  AObject.Clear;

  for I := 0 to Value.AsArray.Length - 1 do
  begin
    if PersistentClass.InheritsFrom(TSerialPersistent) then
      Obj := TSerialPersistentClass(PersistentClass).Create
    else
      Obj := PersistentClass.Create;
    AObject.Add(Obj);
    DeSerialize(Value.AsArray.O[i],Obj);
  end;
end;

class procedure TJsonSerialize.DeSerializeFromString(const Value: string;
  AObject: TPersistent);
begin
  DeSerialize(SO(Value),AObject);
end;

class procedure TJsonSerialize.DeSerialize(Value: ISuperObject;
  AObject: TSerialObjectList);
var
  PersistentClass: TPersistentClass;
begin
  PersistentClass := AObject.GetSerialClass;
  DeSerialize(Value,AObject,PersistentClass);
end;

class procedure TJsonSerialize.DeSerializeFromString(const Value: string;
  AObject: TObjectList; PersistentClass: TPersistentClass);
begin
  DeSerialize(SO(Value),AObject,PersistentClass);
end;

class function TJsonSerialize.EncodeStream(Value: TStream): string;
var
  StringStream: TStringStream;
begin
  StringStream := TStringStream.Create('');
  try
    Value.Position := 0;
    EncdDecd.EncodeStream(Value,StringStream);
    Value.Position := 0;
    Result := StringStream.DataString;
  finally
    StringStream.Free;
  end;


end;

class function TJsonSerialize.Serialize(AObject: TObjectList): ISuperObject;
var
  I: Integer;
begin
  if AObject = nil then
    raise Exception.Create('传为对象为空，无法序列化为JSON');
  Result := SO('[]');
  for I := 0 to AObject.Count - 1 do
  begin
    if (AObject.Items[i] <> nil) and (AObject.Items[i] is TPersistent) then
      Result.AsArray.Add(Serialize(AObject.Items[i] as TPersistent))
    else
      Raise Exception.Create('ObjectList元素为空或不为TPersistent类型，无法序列化为JSON');
  end;
  
end;

class function TJsonSerialize.SerializeAsString(
  AObject: TObjectList): string;
var
  iJson: ISuperObject;
begin
  iJson := Serialize(AObject);
  Result := iJson.AsString;
end;

class function TJsonSerialize.SerializeAsString(AObject: TPersistent): string;
var
  iJson: ISuperObject;
begin
  iJson := Serialize(AObject);
  Result := iJson.AsString;
end;

{ TSerialPersistent }

procedure TSerialPersistent.Clone(Src: TSerialPersistent);
var
  iJson: ISuperObject;
begin
  iJson := TJsonSerialize.Serialize(src);

  TJsonSerialize.DeSerialize(iJson,self);
end;

constructor TSerialPersistent.Create;
begin

end;

{ TJsonParse }

class procedure TJsonParse.SetDateTime(Obj: ISuperObject;FieldName: string;
Value: TDateTime);
begin
  if value > 1 then
    Obj.S[FieldName] := FormatDateTime('yyyy-mm-dd hh:nn:ss',value);
end;

class function TJsonParse.ToBoolean(Value: ISuperObject): Boolean;
begin
  if Value.IsType(stBoolean) then
    Result := Value.AsBoolean
  else
    Result := False;
end;

class function TJsonParse.ToDateTime(Value: ISuperObject): TDateTime;
begin
  if Value.IsType(stString) then
    Result := StrToDateTimeDef(Value.AsString,0)
  else
    Result := 0;
end;

class function TJsonParse.ToInt(Value: ISuperObject): integer;
begin
  if (Value = nil) or (Value.IsType(stNull)) then
    Result := 0
  else
    Result := Value.AsInteger;
end;

class function TJsonParse.ToString(Value: ISuperObject): string;
begin
  if (Value = nil) or (Value.IsType(stNull)) then
    Result := ''
  else
    Result := Value.AsString;
end;

end.
