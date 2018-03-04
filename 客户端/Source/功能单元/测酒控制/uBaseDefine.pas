unit uBaseDefine;

interface

uses Windows, Messages;

const
    WM_APPARATUS_INFO_CHANGE = WM_USER + 1010;//测酒状态发生变化
    WM_CommunicationsFailure = WM_USER + 1018; //通信异常
    WM_CommunicationsSuccess = WM_USER + 1019; //通信正常

    //测酒仪状态
    crAbnormity = $FF; //异常,通讯失败.
    crReady = $01; //01检测就绪  只有测酒仪在该状态下才能检测
    crBusy = $100; //判断设备测完酒后，是否重新恢复到检测状态
    crNormal = $02; //正常
    crWarn = $10; //报警
    crMore = $14; //饮酒
    crMuch = $18; //酗酒
    crSave = $80; //保存数据
    crNotTest = $00; //未检测；
    crIniStatus = $44;//初始状态
    crTimeOut = $F1;//超时


type


  //测酒仪配置信息
  RAlcoholConfig = record
    dwNormalStandard: DWORD; //正常标准
    dwNormalModify: DWORD; //正常修正
    dwDrinkStandard: DWORD; //饮酒标准
    dwDrinkModify: DWORD; //饮酒修正
    dwBibulosityStandard: DWORD; //酗酒标准
    dwBibulosityModify: DWORD; //酗酒修正
    dwVltStandard: DWORD; //正常标准
    dwVltModify: DWORD; //正常修正
    dwVltDrinkStandard: DWORD; //饮酒标准
    dwVltDrinkModify: DWORD; //饮酒修正
    dwVltBibulosityStandard: DWORD; //酗酒标准
    dwVltBibulosityModify: DWORD; //酗酒修正
    dwVltNormalStepUp: DWORD; //正常升压
    dwVltNormalStepDown: DWORD; //正常降压
    dwRespondTime: DWORD; //响应时间
    dwStatus: DWORD; //测酒仪检测状态
  end;


  {RApparatusBaseVlt 测酒仪电压信息结构体}
  RApparatusVoltage = record
    wNormalVoltage: Word; //正常电压
    wMoreVoltage: Word; //饮酒电压
    wMuchVoltage: Word; //酗酒电压
  end;

  {测酒设备状态}
  TAlcoholicStatus = (acrNormal {正常}, acrMore {饮酒}, acrMuch {酗酒},
     acrAbnormity {异常}, acrReady {检测就绪},acrWarn {报警},
     acrBusy{测酒后是否返回},acrWarmup {正在预热},acrIniStatus {初始状态},
     acrTimeOut {超时});

  {测酒仪反馈信息}
  RApparatusInfo = record
    dwAlcoholicity: Word; //酒精含量；
    wStatus: Word; //测酒仪检测状态
    bReady :Boolean; //测酒仪是否准备好 ，检测灯灭：False；检测灯亮：True
    dwHVoltage0: Word; //通道0电压 麦克风电压
    dwHVoltage1: Word; //通道1电压 测酒传感器电压
    bSensorStatus: boolean; //传感器状态是否有效
  end;

  {测酒状态信息改变事件}
  TOnApparatusInfoChange = procedure(Info: RApparatusInfo) of object;
  {通讯状态变化事件}
  TOnCommunicationsStateChange = Procedure(bState : Boolean)of object;
  

function AlcoholicStatusToString(wStatus: WORD):String;

implementation

function AlcoholicStatusToString(wStatus: WORD):String;
//功能：将测酒设备状态返回为字符串
begin
  Result := '未知';
  case wStatus of
    crNormal : Result := '正常';
    crMore : Result := '饮酒';
    crMuch : Result := '酗酒';
    crAbnormity : Result := '异常';
    crReady : Result := '检测就绪';
    crWarn : Result := '报警';
    crNotTest : Result := '正在预热';
    crIniStatus : Result := '初始状态';
    crTimeOut : Result := '超时';
    crBusy : Result := '测酒后是否返回';
  end;
end;

{function GetAlcoholResult(dwResult: DWORD): TAlcoholicStatus;
//功能：获得测酒仪的当前结果
begin
  Result := acrIniStatus;
  if dwResult = crAbnormity then
      Result := acrAbnormity; //异常,通讯失败.

  if dwResult = crReady then
      Result := acrReady; //01检测就绪  只有测酒仪在该状态下才能检测

  if dwResult = crBusy then
      Result := acrBusy; //判断设备测完酒后，是否重新恢复到检测状态

  if dwResult = crNormal then
      Result := acrNormal; //正常

  if dwResult = crWarn then
      Result := acrWarn; //报警

  if dwResult = crMore then
      Result := acrMore; //饮酒

  if dwResult = crMuch then
      Result := acrMuch; //酗酒

  if dwResult = crNotTest then
      Result := acrWarmup; //未检测；

  if dwResult = crIniStatus then
      Result := acrIniStatus; //初始状态
end;   }

end.

