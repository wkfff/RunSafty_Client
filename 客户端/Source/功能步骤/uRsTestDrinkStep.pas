unit uRsTestDrinkStep;

interface
uses
  Classes,uRsStepBase,uRsStepConfig,ufrmTestDrinking,uApparatusCommon;
type
  TRsTestAlcoholStep = class(TRsStepBase)
  public
    {功能:执行功能步骤}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;override; 
  end;
  
implementation

uses uGlobalDM;

{ TRsTestAlcoholStep }

function TRsTestAlcoholStep.Execute(Param: TRsStepParam;
  var Direction: TRsStepDirection): Boolean;
var
  AlcoholInfo: RTestAlcoholInfo;
begin
  
  TestDrinking(Param.Trainman,Param.TrainmanPlan.TrainPlan.strTrainTypeName,
      Param.TrainmanPlan.TrainPlan.strTrainNumber,
      Param.TrainmanPlan.TrainPlan.strTrainNo,
      AlcoholInfo,
      m_ConfigNode.Attribute['RightBottomPopWindow']);
  Param.AlcoholInfo := AlcoholInfo;
  Result := True;
  Direction := sdNextStep;

end;
initialization
  RegisterClass(TRsTestAlcoholStep);
end.
