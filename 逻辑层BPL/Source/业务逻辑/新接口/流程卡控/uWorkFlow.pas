unit uWorkFlow;

interface
uses
  Classes,contnrs;
const
  WORKFLOW_BEGINWORK = 'RS.RUNSAFTY.FLOW.BEGINWORK';
  WORKFLOW_ENDWORK = 'RS.RUNSAFTY.FLOW.ENDWORK';

type  
  TWorkFlow = class(TPersistent)
  private
    m_flowType: string;
    m_flowName: string;
    m_tmid: string;
    m_tmName: string;
    m_flowIdentify: string;
    m_description: string;
    m_success: integer;
    m_eventTime: tdatetime;
    m_planID: string;
  published
    property flowType: string read m_flowType write m_flowType;
    property flowName: string read m_flowName write m_flowName;
    property tmid: string read m_tmid write m_tmid;
    property tmName: string read m_tmName write m_tmName;
    property flowIdentify: string read m_flowIdentify write m_flowIdentify;
    property description: string read m_description write m_description;
    property success: integer read m_success write m_success;
    property eventTime: tdatetime read m_eventTime write m_eventTime;
    property planID: string read m_planID write m_planID;
  end;
  
  TWorkFlowList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWorkFlow;
    procedure SetItem(Index: Integer; AObject: TWorkFlow);
  public
    property Items[Index: Integer]: TWorkFlow read GetItem write SetItem; default;
  end;


  TWorkFlowCfg = class(TPersistent)
  private
    //流程类型
    m_flowType: string;
    //所属车间
    m_workShop: string;  
    //车间名称
    m_workShopName: string;
    //流程标识
    m_flowIdentify: string;
    //流程名称
    m_flowName: string;               
    //时间左边界
    m_timeBoundary_left: integer;
    //时间右边界
    m_timeBoundary_right: integer;
    //是否带有计划ID
    m_withPlanID: integer;
    //必需的流程
    m_necessary: integer;
  published
    property flowType: string read m_flowType write m_flowType;
    property workShop: string read m_workShop write m_workShop;
    property workShopName: string read m_workShopName write m_workShopName;
    property flowIdentify: string read m_flowIdentify write m_flowIdentify;
    property flowName: string read m_flowName write m_flowName;
    property timeBoundary_left: integer read m_timeBoundary_left write m_timeBoundary_left;
    property timeBoundary_right: integer read m_timeBoundary_right write m_timeBoundary_right;
    property withPlanID: integer read m_withPlanID write m_withPlanID;
    property necessary: integer read m_necessary write m_necessary;
  end;


  TWorkFlowCfgList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWorkFlowCfg;
    procedure SetItem(Index: Integer; AObject: TWorkFlowCfg);
  public
    property Items[Index: Integer]: TWorkFlowCfg read GetItem write SetItem; default;
  end;        
implementation


function TWorkFlowCfgList.GetItem(Index: Integer): TWorkFlowCfg;
begin
  result := TWorkFlowCfg(inherited GetItem(Index));
end;
procedure TWorkFlowCfgList.SetItem(Index: Integer; AObject: TWorkFlowCfg);
begin
  Inherited SetItem(Index,AObject);
end;


function TWorkFlowList.GetItem(Index: Integer): TWorkFlow;
begin
  result := TWorkFlow(inherited GetItem(Index));
end;
procedure TWorkFlowList.SetItem(Index: Integer; AObject: TWorkFlow);
begin
  Inherited SetItem(Index,AObject);
end;                                         
end.
