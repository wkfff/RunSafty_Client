unit uLCPlanQuery;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uJsonSerialize;
type
  TTQDataObject = class(TPersistent)
  private
    m_TrainNo: string;
    m_TrainNumber: string;
    m_TrainTypeName: string;
    m_TmNumber1: string;
    m_TmName1: string;
    m_TmNumber2: string;
    m_TmName2: string;
    m_TmNumber3: string;
    m_TmName3: string;
    m_TmNumber4: string;
    m_TmName4: string;
    m_PlanTime: tdatetime;
    m_TQTime: tdatetime;
    m_ZCTime: tdatetime;
    m_FileEndTime: TDateTime;
  published
    property TrainNo: string read m_TrainNo write m_TrainNo;
    property TrainNumber: string read m_TrainNumber write m_TrainNumber;
    property TrainTypeName: string read m_TrainTypeName write m_TrainTypeName;
    property TmNumber1: string read m_TmNumber1 write m_TmNumber1;
    property TmName1: string read m_TmName1 write m_TmName1;
    property TmNumber2: string read m_TmNumber2 write m_TmNumber2;
    property TmName2: string read m_TmName2 write m_TmName2;
    property TmNumber3: string read m_TmNumber3 write m_TmNumber3;
    property TmName3: string read m_TmName3 write m_TmName3;
    property TmNumber4: string read m_TmNumber4 write m_TmNumber4;
    property TmName4: string read m_TmName4 write m_TmName4;
    property PlanTime: tdatetime read m_PlanTime write m_PlanTime;
    property TQTime: tdatetime read m_TQTime write m_TQTime;
    property ZCTime: tdatetime read m_ZCTime write m_ZCTime;
    property FileEndTime: TDateTime read m_FileEndTime write m_FileEndTime;
  end;


  TTQDataObjectList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTQDataObject;
    procedure SetItem(Index: Integer; AObject: TTQDataObject);
  public
    property Items[Index: Integer]: TTQDataObject read GetItem write SetItem; default;
  end;


  TLCPlanQuery = class(TWepApiBase)
  public
    //转储时间晚于退勤时间的记录
    procedure TQRelZC(WorkShop: string;BTime,ETime: TDateTime;Ret: TTQDataObjectList);
    //文件结束时间最于退勤时间某一设定值，如：最于退勤时间3小时,由接口端配置
    procedure TQRelFileEnd(WorkShop: string;BTime,ETime: TDateTime;Ret: TTQDataObjectList);
  end;
implementation
function TTQDataObjectList.GetItem(Index: Integer): TTQDataObject;
begin
  result := TTQDataObject(inherited GetItem(Index));
end;
procedure TTQDataObjectList.SetItem(Index: Integer; AObject: TTQDataObject);
begin
  Inherited SetItem(Index,AObject);
end;                 
{ TLCPlanQuery }

procedure TLCPlanQuery.TQRelFileEnd(WorkShop: string; BTime, ETime: TDateTime;
  Ret: TTQDataObjectList);
var
  strOutputData,strResultText : String;
  input,output: ISuperObject;
begin
  input := SO;
  input.S['WorkShopGUID'] := WorkShop;
  input.S['BeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BTime);
  input.S['EndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',ETime);;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.Plan.LCTrainPlan.GetEndWorkList4ZhuanChuByLastTime',input.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  output := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Ret.Clear;
  TJsonSerialize.DeSerialize(output,Ret,TTQDataObject);
end;


procedure TLCPlanQuery.TQRelZC(WorkShop: string; BTime, ETime: TDateTime;
  Ret: TTQDataObjectList);
var
  strOutputData,strResultText : String;
  input,output: ISuperObject;
begin
  input := SO;
  input.S['WorkShopGUID'] := WorkShop;
  input.S['BeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BTime);
  input.S['EndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',ETime);;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.Plan.LCTrainPlan.GetEndWorkList4ZhuanChuByCreatTime',input.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  output := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Ret.Clear;
  TJsonSerialize.DeSerialize(output,Ret,TTQDataObject);
end;


end.
