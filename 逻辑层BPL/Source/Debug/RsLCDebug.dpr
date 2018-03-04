program RsLCDebug;

uses
  Forms,
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  uBaseWebInterface in '..\业务逻辑\接口基类\uBaseWebInterface.pas',
  uLCDict_Jwd in '..\业务逻辑\通用\uLCDict_Jwd.pas',
  uLCDict_Station in '..\业务逻辑\通用\uLCDict_Station.pas',
  uLCDict_TrainJiaoLu in '..\业务逻辑\通用\uLCDict_TrainJiaoLu.pas',
  uLCDict_TrainmanJiaoLu in '..\业务逻辑\通用\uLCDict_TrainmanJiaoLu.pas',
  uLCDict_WorkShop in '..\业务逻辑\通用\uLCDict_WorkShop.pas',
  superobject in '..\..\..\公共\功能单元\JSON\superobject.pas',
  uHttpCom in '..\功能单元\HTTP通信\uHttpCom.pas',
  uArea in '..\数据定义\uArea.pas',
  uAskForLeave in '..\数据定义\uAskForLeave.pas',
  uCallNotify in '..\数据定义\uCallNotify.pas',
  uCallRecord in '..\数据定义\uCallRecord.pas',
  uCallWork in '..\数据定义\uCallWork.pas',
  uCheckRecord in '..\数据定义\uCheckRecord.pas',
  uClientAppInfo in '..\数据定义\uClientAppInfo.pas',
  uDBConfig in '..\数据定义\uDBConfig.pas',
  uDDMLConfirm in '..\数据定义\uDDMLConfirm.pas',
  uDrink in '..\数据定义\uDrink.pas',
  uDutyPlace in '..\数据定义\uDutyPlace.pas',
  uDutyUser in '..\数据定义\uDutyUser.pas',
  uEndWork in '..\数据定义\uEndWork.pas',
  uGoodsRange in '..\数据定义\uGoodsRange.pas',
  uGroupTrainmanIndex in '..\数据定义\uGroupTrainmanIndex.pas',
  uGuideGroup in '..\数据定义\uGuideGroup.pas',
  uGuideSign in '..\数据定义\uGuideSign.pas',
  uJiWuDuan in '..\数据定义\uJiWuDuan.pas',
  uJWD in '..\数据定义\uJWD.pas',
  uKeHuo in '..\数据定义\uKeHuo.pas',
  uLeaderExam in '..\数据定义\uLeaderExam.pas',
  uLeaveListInfo in '..\数据定义\uLeaveListInfo.pas',
  uLendingDefine in '..\数据定义\uLendingDefine.pas',
  uLine in '..\数据定义\uLine.pas',
  uMealTicket in '..\数据定义\uMealTicket.pas',
  uMealTicketConfig in '..\数据定义\uMealTicketConfig.pas',
  uMealTicketRule in '..\数据定义\uMealTicketRule.pas',
  uPlanLater in '..\数据定义\uPlanLater.pas',
  uPubFun in '..\数据定义\uPubFun.pas',
  uRoom in '..\数据定义\uRoom.pas',
  uRoomSign in '..\数据定义\uRoomSign.pas',
  uRoomWait in '..\数据定义\uRoomWait.pas',
  uRsInterfaceDefine in '..\数据定义\uRsInterfaceDefine.pas',
  uRunEvent in '..\数据定义\uRunEvent.pas',
  uRunSafetyInterfaceDefine in '..\数据定义\uRunSafetyInterfaceDefine.pas',
  uSaftyEnum in '..\数据定义\uSaftyEnum.pas',
  uSection in '..\数据定义\uSection.pas',
  uSickLeave in '..\数据定义\uSickLeave.pas',
  uSignPlan in '..\数据定义\uSignPlan.pas',
  uSite in '..\数据定义\uSite.pas',
  uStation in '..\数据定义\uStation.pas',
  uSystemDict in '..\数据定义\uSystemDict.pas',
  uTrainJiaolu in '..\数据定义\uTrainJiaolu.pas',
  uTrainMaintainsDefine in '..\数据定义\uTrainMaintainsDefine.pas',
  uTrainman in '..\数据定义\uTrainman.pas',
  uTrainmanJiaolu in '..\数据定义\uTrainmanJiaolu.pas',
  uTrainNo in '..\数据定义\uTrainNo.pas',
  uTrainnos in '..\数据定义\uTrainnos.pas',
  uTrainPlan in '..\数据定义\uTrainPlan.pas',
  uTrainType in '..\数据定义\uTrainType.pas',
  uWaitWork in '..\数据定义\uWaitWork.pas',
  uWebServiceType in '..\数据定义\uWebServiceType.pas',
  uWorkShop in '..\数据定义\uWorkShop.pas',
  uWorkTime in '..\数据定义\uWorkTime.pas',
  uWorkTimeDefine in '..\数据定义\uWorkTimeDefine.pas',
  uWriteCardSection in '..\数据定义\uWriteCardSection.pas',
  uXYRelation in '..\数据定义\uXYRelation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
