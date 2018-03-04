unit uLCGeXingCheQin;
interface
uses
  SysUtils,Classes,superobject,uHttpWebAPI;

type

  //////////////////////////////////////////////////////////////////////////////
  /// TGeXingChuQinPlanInfo 人员出勤计划信息
  //////////////////////////////////////////////////////////////////////////////
  TGeXingChuQinPlanInfo = class
  public
    constructor create();
    destructor Destroy();override;
  private
    //人员工号列表
    m_TmNumbers:TStringList;
  public
    //库接,站接
    strRemarkTypeName:string;
    //车型
    strTrainType:string ;
    //车号
    strTrainNumber:string;
    //行车交路
    strTrainJiaoLu:string;
    //车次
    strTrainNo:string;
  public
    
    property TmNumbers: TStringList read m_TmNumbers;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///类名: TRsLCGeXingCheQin
  ///描述:个性化出勤类
  //////////////////////////////////////////////////////////////////////////////
  TRsLCGeXingCheQin = class(TWepApiBase)
  public
    {功能:获取个性出勤网页地址}
    procedure GetURL(planInfo:TGeXingChuQinPlanInfo;var strPDFURL,strExcelURL:string);

    class function PlanToJson(PlanInfo: TGeXingChuQinPlanInfo): ISuperObject;

  end;
implementation


{ TGeXingChuQinPlanInfo }

constructor TGeXingChuQinPlanInfo.create;
begin
  m_TmNumbers := TStringList.Create;
end;

destructor TGeXingChuQinPlanInfo.Destroy;
begin
  m_TmNumbers.Free;
  inherited;
end;




{ TRsLCGeXingCheQin }

procedure TRsLCGeXingCheQin.GetURL(planInfo: TGeXingChuQinPlanInfo;
  var strPDFURL, strExcelURL: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := PlanToJson(planInfo);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCSpecificOnDuty.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  strPDFURL := JSON.S['strPDFURL'];
  strExcelURL := JSON.S['strExcelURL'];
end;

class function TRsLCGeXingCheQin.PlanToJson(
  PlanInfo: TGeXingChuQinPlanInfo): ISuperObject;
var
  iJsTM:ISuperObject;
  i:Integer;
begin
  Result := SO();
  Result.S['cid'] := '';
  Result.S['cx'] := PlanInfo.strTrainType;
  Result.S['ch'] := PlanInfo.strTrainNumber;
  Result.s['xcjl'] := PlanInfo.strTrainJiaoLu;
  Result.S['cc'] := PlanInfo.strTrainNo;
  Result.S['remarkTypeName'] := PlanInfo.strRemarkTypeName;
  Result.O['gh'] := so('[]');
  for I := 0 to PlanInfo.TmNumbers.Count - 1 do
  begin
    iJsTM := so();
    iJsTM.S['ghID'] := PlanInfo.TmNumbers.Strings[i];
    Result.A['gh'].Add(iJsTM) ;
  end;
end;

end.
