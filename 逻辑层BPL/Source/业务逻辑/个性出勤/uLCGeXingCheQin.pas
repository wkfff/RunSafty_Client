unit uLCGeXingCheQin;
interface
uses
  SysUtils,Classes,superobject,uHttpWebAPI;

type

  //////////////////////////////////////////////////////////////////////////////
  /// TGeXingChuQinPlanInfo ��Ա���ڼƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TGeXingChuQinPlanInfo = class
  public
    constructor create();
    destructor Destroy();override;
  private
    //��Ա�����б�
    m_TmNumbers:TStringList;
  public
    //���,վ��
    strRemarkTypeName:string;
    //����
    strTrainType:string ;
    //����
    strTrainNumber:string;
    //�г���·
    strTrainJiaoLu:string;
    //����
    strTrainNo:string;
  public
    
    property TmNumbers: TStringList read m_TmNumbers;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///����: TRsLCGeXingCheQin
  ///����:���Ի�������
  //////////////////////////////////////////////////////////////////////////////
  TRsLCGeXingCheQin = class(TWepApiBase)
  public
    {����:��ȡ���Գ�����ҳ��ַ}
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
