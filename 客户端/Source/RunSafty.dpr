program RunSafty;



uses
  GDIPOBJ,
  Forms,
  SysUtils,
  Windows,
  Controls,
  Dialogs,
  uSite,
  uTFSystem,
  uGlobalDM in 'uGlobalDM.pas' {GlobalDM: TDataModule},
  uFrmLogin in '功能窗口\登录验证\uFrmLogin.pas' {frmLogin},
  uFrmMain_TuiQin in 'uFrmMain_TuiQin.pas' {frmMain_TuiQin},
  uFrmMain_ChuQin in 'uFrmMain_ChuQin.pas' {frmMain_ChuQin},
  uFrmTrainNo in '功能窗口\图定车次表\uFrmTrainNo.pas' {frmTrainNo},
  uFrmTrainNoAdd in '功能窗口\图定车次表\uFrmTrainNoAdd.pas' {frmTrainNoadd},
  uFrmAddUser in '功能窗口\电子名牌\添加人员\uFrmAddUser.pas' {FrmAddUser},
  uFrmAddGroup in '功能窗口\电子名牌\添加机班\uFrmAddGroup.pas' {FrmAddGroup},
  uFrmAddCheCi in '功能窗口\电子名牌\添加机班\添加车次\uFrmAddCheCi.pas' {FrmAddCheCi},
  uFrmAddJiChe in '功能窗口\电子名牌\添加机车\uFrmAddJiChe.pas' {FrmAddJiChe},
  ufrmReadFingerprintTemplates in '功能窗口\指纹特征加载\ufrmReadFingerprintTemplates.pas' {frmReadFingerprintTemplates},
  ufrmTrainmanIdentity in '功能窗口\通用功能\单人登记\ufrmTrainmanIdentity.pas' {FrmTrainmanIdentity},
  ufrmCamer in '功能窗口\通用功能\拍照\ufrmCamer.pas' {frmCamera: TFrame},
  ufrmgather in '功能窗口\通用功能\拍照\ufrmgather.pas' {frmPictureGather},
  ufrmTextInput in '功能窗口\通用功能\文本输入\ufrmTextInput.pas' {frmTextInput},
  uFrmTuiQin in '功能窗口\司机退勤\uFrmTuiQin.pas' {frmTuiQin},
  ufrmFingerRegister in '功能窗口\通用功能\指纹注册\ufrmFingerRegister.pas' {frmFingerRegister},
  ufrmTrainmanPicFigEdit in '功能窗口\通用功能\照片指纹修改\ufrmTrainmanPicFigEdit.pas' {FormTrainmanPicFigEdit},
  uFrmChuQin in '功能窗口\司机出勤\uFrmChuQin.pas' {frmChuQin},
  uFrmThirdInfo in '功能窗口\司机出勤\uFrmThirdInfo.pas' {frameThirdInfo: TFrame},
  uRunSaftyDefine in '功能单元\uRunSaftyDefine.pas',
  uFrmTrainmanManage in '功能窗口\通用功能\乘务员信息管理\uFrmTrainmanManage.pas' {frmTrainmanManage},
  ufrmUserInfoEdit in '功能窗口\通用功能\乘务员信息管理\ufrmUserInfoEdit.pas' {frmUserInfoEdit},
  uFrmSetStringGridCol in '功能窗口\系统设置\设置列表列\uFrmSetStringGridCol.pas' {FrmSetStringGridCol},
  ufrmConfig in '功能窗口\系统设置\配置设置\ufrmConfig.pas',
  uFrmExchangeModule in '功能窗口\切换模块\uFrmExchangeModule.pas' {frmExchangeModule},
  uModuleExchange in '功能单元\模块切换函数\uModuleExchange.pas',
  ufrmModifyPassWord in '功能窗口\修改密码\ufrmModifyPassWord.pas' {frmModifyPassWord},
  uFrmProgressEx in '功能窗口\进度对话框\uFrmProgressEx.pas' {frmProgressEx},
  uGroupDragObject in '功能单元\手工派班机组拖拽\uGroupDragObject.pas',
  uFrmLeaveTypeMgr in '功能窗口\请销假\请假类型管理\uFrmLeaveTypeMgr.pas' {FrmLeaveTypeMgr},
  uFrmLeaveTypeModify in '功能窗口\请销假\请假类型管理\uFrmLeaveTypeModify.pas' {FrmLeaveTypeModify},
  uFrmLeaveQuery in '功能窗口\请销假\请销假记录查询\uFrmLeaveQuery.pas' {FrmLeaveQuery},
  uFrmAskLeaveDetail in '功能窗口\请销假\请销假详细信息\uFrmAskLeaveDetail.pas' {FrmAskLeaveDetail},
  uFrmCancelLeave in '功能窗口\请销假\销假登记\uFrmCancelLeave.pas' {FrmCancelLeave},
  uFrmAskLeave in '功能窗口\请销假\请假登记\uFrmAskLeave.pas' {FrmAskLeave},
  uNamedGroupView in '功能单元\电子名牌数据视图\uNamedGroupView.pas',
  uOrderGroupInTrainView in '功能单元\电子名牌数据视图\uOrderGroupInTrainView.pas',
  uOrderGroupView in '功能单元\电子名牌数据视图\uOrderGroupView.pas',
  uTogetherTrainView in '功能单元\电子名牌数据视图\uTogetherTrainView.pas',
  uTrainmanView in '功能单元\电子名牌数据视图\uTrainmanView.pas',
  uTrainmanOrderView in '功能单元\电子名牌数据视图\uTrainmanOrderView.pas',
  uFrmTrainmanDetail in '功能窗口\人员信息显示\uFrmTrainmanDetail.pas' {frmTrainmanDetail},
  utfPopBox in '功能窗口\自动关闭无焦点对话框\utfPopBox.pas' {tfPopBox},
  uFrmDrinkTestQuery in '功能窗口\测酒记录查询\uFrmDrinkTestQuery.pas' {frmDrinkTestQuery},
  uFrmXYRelation in '功能窗口\师徒关系管理\uFrmXYRelation.pas' {frmXYRelation},
  uFrmAddXY in '功能窗口\师徒关系管理\添加师徒\uFrmAddXY.pas' {FrmAddXY},
  ufrmTestDrinking in '功能窗口\通用功能\测酒\ufrmTestDrinking.pas' {frmTestDrinking},
  uCommonFunctions in '..\..\公共\功能单元\公共定义\uCommonFunctions.pas',
  uRunSaftyMessageDefine in '..\..\公共\功能单元\消息定义\uRunSaftyMessageDefine.pas',
  uFrmSelectColumn in '功能窗口\列表选择列\uFrmSelectColumn.pas' {frmSelectColumn},
  uStrGridUtils in '功能单元\StrGrid操作\uStrGridUtils.pas',
  ufrmRsXyOprLog in '功能窗口\师徒关系管理\操作记录\ufrmRsXyOprLog.pas' {frmXYLog},
  ufrmStudentManage in '功能窗口\师徒关系管理\学员管理\ufrmStudentManage.pas' {frmStudentManage},
  uConnAccess in '功能单元\断网模式\uConnAccess.pas',
  uFrmDrinkInfo in '功能窗口\断网模式\uFrmDrinkInfo.pas' {FrmDrinkInfo},
  ufrmTimeRange in '功能窗口\图定车次表\ufrmTimeRange.pas' {frmTuDingTimeRange},
  ufrmHint in '功能窗口\提示窗口\ufrmHint.pas' {frmHint},
  uLogManage in '..\..\公共\功能单元\日志管理器\uLogManage.pas',
  superobject in '..\..\公共\功能单元\JSON\superobject.pas',
  superxmlparser in '..\..\公共\功能单元\JSON\superxmlparser.pas',
  ufrmTrainplanExport in '功能窗口\机车计划\ufrmTrainplanExport.pas' {frmTrainplanExport},
  uRsConstFieldDefine in '..\..\公共\功能单元\公共定义\uRsConstFieldDefine.pas',
  uRsStepBase in '功能单元\功能步骤\uRsStepBase.pas',
  uRsStepConfig in '功能单元\功能步骤\uRsStepConfig.pas',
  uGenericData in '..\..\公共\功能单元\公共定义\uGenericData.pas',
  uRsTuiQinStep in '功能单元\功能步骤\退勤步骤\uRsTuiQinStep.pas',
  uRsTestDrinkStep in '功能单元\功能步骤\公共步骤\测酒步骤\uRsTestDrinkStep.pas',
  uFrmMain_GuanLi in 'uFrmMain_GuanLi.pas' {frmMain_GuanLi},
  uFrmLocalDrink in '功能窗口\断网模式\uFrmLocalDrink.pas' {FrmLocalDrink},
  uFrmImportDrinkInfo in '功能窗口\断网模式\uFrmImportDrinkInfo.pas' {FrmImportDrinkInfo},
  uFrmDisconnectHint in '功能窗口\断网模式\uFrmDisconnectHint.pas' {FrmDisconnectHint},
  uFrmMealTicketConfig in '功能窗口\饭票设置\uFrmMealTicketConfig.pas' {FrmMealTicketConfig},
  uRsRtfDefine in '..\..\公共\功能单元\公共定义\uRsRtfDefine.pas',
  uFrmTicketModify in '功能窗口\饭票修改\uFrmTicketModify.pas' {FrmTicketModify},
  ufrmTrainmanPicFigEditAccess in '功能窗口\通用功能\照片指纹修改\ufrmTrainmanPicFigEditAccess.pas' {FrmTrainmanPicFigEditAccess},
  uFrmAddMealTicket in '功能窗口\添加饭票\uFrmAddMealTicket.pas' {FrmAddMealTicket},
  uFrmViewMealTicket in '功能窗口\饭票查看\uFrmViewMealTicket.pas' {FrmViewMealTicket},
  uFrmTuiqinTimeLog in '功能窗口\退勤时间修改日志\uFrmTuiqinTimeLog.pas' {FrmTuiqinTimeLog},
  uFrmMealTicketRule in '功能窗口\饭票发放规则\uFrmMealTicketRule.pas' {FrmMealTicketRule},
  uFrmAddMealTicketRule in '功能窗口\饭票发放规则\添加规则\uFrmAddMealTicketRule.pas' {FrmAddMealTicketRule},
  uFrmViewMealTicketRuleInfo in '功能窗口\饭票发放规则\规则详细\uFrmViewMealTicketRuleInfo.pas' {FrmViewMealTicketRuleInfo},
  uFrmAddMealTicketRuleInfo in '功能窗口\饭票发放规则\规则详细\添加详细\uFrmAddMealTicketRuleInfo.pas' {FrmAddMealTicketRuleInfo},
  uFrmSelectDutyPlace in '功能窗口\出勤点\选择出勤点\uFrmSelectDutyPlace.pas' {FrmSelectDutyPlace},
  uFrmTrainPlanChangeLog in '功能窗口\机车计划变动日志\uFrmTrainPlanChangeLog.pas' {FrmTrainPlanChangeLog},
  uFrmTrainJiaoLu in '功能窗口\管辖区段\uFrmTrainJiaoLu.pas' {FrmTrainJiaoLu},
  uFrmPlanMessage in '功能窗口\消息窗口\uFrmPlanMessage.pas' {FrmPlanMessage},
  uFrmTrainPlan in '功能窗口\机车计划界面\uFrmTrainPlan.pas' {FrmTrainPlan},
  uFrmMain_JiDiao_Extra in 'uFrmMain_JiDiao_Extra.pas' {FrmMain_JiDiao_Extra},
  uPlanManager in '功能单元\消息计划提示\uPlanManager.pas',
  uTrainJiaoluItem in '功能单元\消息计划提示\uTrainJiaoluItem.pas',
  uThreadCheckPlan in '功能单元\检测未处理计划线程\uThreadCheckPlan.pas',
  ufrmTrainmanNumberInput in '功能窗口\通用功能\文本输入\ufrmTrainmanNumberInput.pas' {FrmTrainmanNumberInput},
  uFrmSetRest in '功能窗口\设置待班信息\uFrmSetRest.pas' {frmSetRest},
  uJiChePlan in '功能单元\计划导出\uJiChePlan.pas',
  uDayPlan in '功能单元\uDayPlan.pas',
  uFrmErrorAlarm in '功能窗口\异常提醒窗口\uFrmErrorAlarm.pas' {frmErrorAlarm},
  uFrmCallFailure in '功能窗口\异常提醒窗口\uFrmCallFailure.pas' {frmCallFailure},
  uFrmEditCallTime in '功能窗口\修改叫班时间\uFrmEditCallTime.pas' {frmEditCallTime},
  uFrmNoTimeAlarm in '功能窗口\异常提醒窗口\uFrmNoTimeAlarm.pas' {frmNoTimeAlarm},
  uFrmAbout in '功能窗口\系统设置\uFrmAbout.pas' {frmAbout},
  uFrmMain_WaiQin in 'uFrmMain_WaiQin.pas' {FrmMain_WaiQin},
  uFrmProgressExEx in '功能窗口\进度对话框\uFrmProgressExEx.pas' {FrmProgressExEx},
  uFrmSelectPlan in '功能窗口\选择计划班次\uFrmSelectPlan.pas' {FrmSelectPlan},
  uFrmTestDrinkSelect in '功能窗口\测酒类型选择\uFrmTestDrinkSelect.pas' {FrmTestDrinkSelect},
  uFrmOuterTrainman in '功能窗口\快捷人员创建\uFrmOuterTrainman.pas' {FrmOuterSideTrainman},
  uFrmTemplateTrainNoManager in '功能窗口\模板车次表\uFrmTemplateTrainNoManager.pas' {TemplateTrainNoManager},
  uTemplateDayPlan in '功能单元\模板机车计划\uTemplateDayPlan.pas',
  uFrmTemeplateTrainNoGroup in '功能窗口\模板车次表\uFrmTemeplateTrainNoGroup.pas' {FrmTemeplateTrainNoGroup},
  uFrmTemeplateTrainNoItem in '功能窗口\模板车次表\uFrmTemeplateTrainNoItem.pas' {FrmTemeplateTrainNoItem},
  uFrmMainTemeplateTrainNo in '功能窗口\模板车次表\uFrmMainTemeplateTrainNo.pas' {FrmMainTemeplateTrainNo},
  uFrmDayPlanTimeRange in '功能窗口\图定车次表\uFrmDayPlanTimeRange.pas' {FrmDayPlanTimeRange},
  ufrmManagerConfirm in '功能窗口\通用功能\密码\ufrmManagerConfirm.pas' {frmManagerConfirm},
  uFrmEditSignPlan in '功能窗口\退勤签点\uFrmEditSignPlan.pas' {FrmEditSignPlan},
  uFrmEditSignTrainman in '功能窗口\退勤签点\uFrmEditSignTrainman.pas' {FrmEditSignTrainman},
  uFrmOutWorkChoice in '功能窗口\退勤签点\uFrmOutWorkChoice.pas' {FrmOutWorkChoice},
  uFrmSignJiaolu in '功能窗口\退勤签点\uFrmSignJiaolu.pas' {FrmSignJiaoLu},
  uFrmSignMain in '功能窗口\退勤签点\uFrmSignMain.pas' {FrmSignMain},
  uLCSignPlan in '逻辑\退勤签点\uLCSignPlan.pas',
  uFrmMain_RenYuan in 'uFrmMain_RenYuan.pas' {frmMain_RenYuan},
  uFrmGetDateTime in '功能窗口\公寓房间表\uFrmGetDateTime.pas' {FrmGetDateTime},
  uFrmViewGroupOrder in '功能窗口\查看班序\uFrmViewGroupOrder.pas' {frmViewGroupOrder},
  uFrmPaiBanRecord in '功能窗口\派班日志写实\uFrmPaiBanRecord.pas' {frmPaibanRecord},
  uFrmNameBoardChangeLog in '功能窗口\查看名牌变动日志\uFrmNameBoardChangeLog.pas' {frmNameBoardChangeLog},
  uFrmShowText in '功能窗口\显示文本\uFrmShowText.pas' {frmShowText},
  uFrmGoodsManage in '功能窗口\物品管理\uFrmGoodsManage.pas' {frmGoodsManage},
  ufrmGoodsQuery in '功能窗口\物品管理\ufrmGoodsQuery.pas' {frmGoodsQuery},
  uFrmGoodsRangeManage in '功能窗口\物品管理\uFrmGoodsRangeManage.pas' {FrmGoodsRangeManage},
  uFrmGoodsSend in '功能窗口\物品管理\uFrmGoodsSend.pas' {frmGoodsSend},
  uFrmGoodsRangeView in '功能窗口\物品管理\物品编号范围\uFrmGoodsRangeView.pas' {FrmGoodsRangeView},
  uFrmBeginworkVIEW in '功能窗口\司机出勤\出勤进度\uFrmBeginworkVIEW.pas' {frmBeginworkView},
  uFrmPlanWriteSection in '功能窗口\指定出勤写卡区段\uFrmPlanWriteSection.pas' {frmPlanWriteSection},
  uFrmMain_GuideSign in 'uFrmMain_GuideSign.pas' {frmMain_GuideSign},
  uFrmDutyGroup in '功能窗口\指导队签到\uFrmDutyGroup.pas' {FrmDutyGroup},
  uFrmGuideGroup in '功能窗口\指导队签到\uFrmGuideGroup.pas' {FrmGuideGroup},
  uFrmSysParam in '功能窗口\指导队签到\uFrmSysParam.pas' {FrmSysParam},
  uFrmTemeplateDaWenItem in '功能窗口\模板车次表\uFrmTemeplateDaWenItem.pas' {FrmTemeplateDaWenItem},
  uPrintTMReport in '功能单元\司机报单\uPrintTMReport.pas',
  uFrmPrintTMRpt in '功能窗口\打印司机报单\uFrmPrintTMRpt.pas' {FrmPrintTMRpt},
  UFrmPrintJieShi in '功能窗口\交付揭示\显示打印交付揭示\UFrmPrintJieShi.pas' {FrmPrintJieShi},
  uDDMLDownload in '功能单元\调度命令\下载调度命令RAR\uDDMLDownload.pas',
  uFrmGeXingChuQin in '功能窗口\个性出勤\uFrmGeXingChuQin.pas',
  AcroPDFLib_TLB in '功能单元\PDF\AcroPDFLib_TLB.pas',
  Office_TLB in '功能单元\PDF\Office_TLB.pas',
  VBIDE_TLB in '功能单元\PDF\VBIDE_TLB.pas',
  Word_TLB in '功能单元\PDF\Word_TLB.pas',
  uLCBaseDict in '接口\uLCBaseDict.pas',
  uDayPlanExportToXls in '功能单元\模板机车计划\uDayPlanExportToXls.pas',
  uBeginworkViewDraw in '功能单元\出勤流程步骤\uBeginworkViewDraw.pas',
  uTFSkin in '功能单元\uTFSkin.pas',
  uDBMealTicket in '逻辑\饭票\uDBMealTicket.pas',
  uMealTicketManager in '逻辑\饭票\uMealTicketManager.pas',
  uExportPlan in '功能窗口\机车计划\uExportPlan.pas',
  uRSCommonFunctions in '功能单元\uRSCommonFunctions.pas',
  uRoomCallRemind in '功能单元\叫班提醒\uRoomCallRemind.pas',
  ufrmRemind in '功能单元\叫班提醒\ufrmRemind.pas' {frmRemind},
  uFrmWorkTimeDetail in '功能窗口\途中详情\uFrmWorkTimeDetail.pas' {frmWorkTimeDetail},
  uFrmTuiQinThird in '功能窗口\退勤卡控\uFrmTuiQinThird.pas' {frmTuiQinThird},
  ufrmMealTicketQuery in '功能窗口\饭票查询\ufrmMealTicketQuery.pas' {frmMealTicketQuery},
  ufrmLeaveJlSelect in '功能窗口\请销假\请假登记\ufrmLeaveJlSelect.pas' {frmLeaveJlSelect},
  uEmbeddedPageInMenu in '逻辑\嵌入查询页面\uEmbeddedPageInMenu.pas',
  uSynReader in '功能单元\uSynReader.pas',
  uFingerCtls in '功能单元\uFingerCtls.pas',
  uFrmFixedGoupEdit in '功能窗口\固定班\uFrmFixedGoupEdit.pas' {FrmFixedGroupEdit},
  uFrmFixedGroupMgr in '功能窗口\固定班\uFrmFixedGroupMgr.pas' {FrmFixedGroupMgr},
  uFrmKeyTrainmanEdit in '功能窗口\关键人管理\uFrmKeyTrainmanEdit.pas' {FrmKeyTrainmanEdit},
  uFrmKeyTrainmanMgr in '功能窗口\关键人管理\uFrmKeyTrainmanMgr.pas' {FrmKeyTrainmanMgr},
  uViewDefine in '功能单元\电子名牌数据视图\uViewDefine.pas',
  uFrmKeyTrainmanView in '功能窗口\关键人管理\uFrmKeyTrainmanView.pas' {FrmKeyTrainmanView},
  uFrmFixedGroupView in '功能窗口\固定班\uFrmFixedGroupView.pas' {FrmFixedGroupView},
  ufrmGanBuType in '功能窗口\干部管理\ufrmGanBuType.pas' {FrmGanBuTypeMgr},
  ufrmGanBuMgr in '功能窗口\干部管理\ufrmGanBuMgr.pas' {frmGanBuMgr},
  ufrmGanBuAdd in '功能窗口\干部管理\ufrmGanBuAdd.pas' {FrmGanbuAdd},
  uGanbuXlsExport in '功能窗口\干部管理\uGanbuXlsExport.pas',
  uKeyManXls in '功能窗口\关键人管理\uKeyManXls.pas',
  uFrmAnnualLeave in '功能窗口\年休假管理\uFrmAnnualLeave.pas' {FrmAnnualLeave},
  uFrmAnnualAdd in '功能窗口\年休假管理\uFrmAnnualAdd.pas' {FrmAnnualAdd},
  uFrmTMRptSelect in '功能窗口\打印司机报单\uFrmTMRptSelect.pas' {frmTMRptSelect},
  uFrmAnnualLog in '功能窗口\年休假管理\uFrmAnnualLog.pas' {FrmAnnualLog},
  uFrmAnnualDelRecord in '功能窗口\年休假管理\uFrmAnnualDelRecord.pas' {FrmAnnualDelRecord},
  uKeyManConfirm in '功能窗口\关键人管理\uKeyManConfirm.pas' {FrmKeyManConfirm},
  uPubJsPrintCtl in '功能单元\打印交付揭示\uPubJsPrintCtl.pas',
  uLib_PubJsCtl in '功能单元\打印交付揭示\uLib_PubJsCtl.pas',
  uRsLibUtils in '功能单元\uRsLibUtils.pas',
  uFrameFixGroup in '功能窗口\固定班\uFrameFixGroup.pas' {FrameFixGroup: TFrame},
  ufrmEndWorkQuery in '功能窗口\退勤记录查询\ufrmEndWorkQuery.pas' {FrmEndWorkQuery},
  uTMImporter in '功能窗口\通用功能\乘务员信息管理\uTMImporter.pas',
  uLCWebAPI in '接口\uLCWebAPI.pas',
  uMealTicketFacade in '逻辑\饭票\uMealTicketFacade.pas',
  ufrmTicketCountInput in '逻辑\饭票\ufrmTicketCountInput.pas' {FrmTicketCountInput},
  uFrmWorkFlowCheck in '功能窗口\流程卡控\uFrmWorkFlowCheck.pas' {FrmWorkFlowCheck},
  uFlowCtlIntf in '功能单元\uFlowCtlIntf.pas',
  uFrmMealticketServerCfg in '功能窗口\饭票设置\uFrmMealticketServerCfg.pas' {FrmMealTicketServerCfg},
  uFrmViewMealTicketLog in '功能窗口\饭票查看\uFrmViewMealTicketLog.pas' {FrmViewMealTicketLog},
  uMenuItemCtl in '功能单元\uMenuItemCtl.pas',
  ufrmTQRelZhuanChu in '功能窗口\TS违规记录查询\ufrmTQRelZhuanChu.pas' {FrmTQRelZhuanChu},
  ufrmJDPlan in '功能窗口\阶段计划\ufrmJDPlan.pas' {FrmJDPlan},
  uFrameJDPlan in '功能窗口\阶段计划\uFrameJDPlan.pas' {FrameJDPlan: TFrame},
  uLCJDPlan in '接口\uLCJDPlan.pas',
  uFrmRegionFilter in '功能窗口\阶段计划\uFrmRegionFilter.pas' {FrmRegionFilter},
  EventSink in '功能单元\类库\工具\EventSink.pas',
  uTFComObject in '功能单元\类库\工具\uTFComObject.pas',
  RsGlobal_TLB in '功能单元\类库\引用\RsGlobal_TLB.pas',
  RsNameplateLib_TLB in '功能单元\类库\引用\RsNameplateLib_TLB.pas',
  RsLibHelper in '功能单元\类库\调用\RsLibHelper.pas',
  ufrmTmJlSelect in '功能窗口\电子名牌管理\ufrmTmJlSelect.pas' {frmTmjlSelect},
  ufrmFindJDPlan in '功能窗口\阶段计划\ufrmFindJDPlan.pas' {frmFindJDPlan},
  uFrmFindJDPlanFromList in '功能窗口\阶段计划\uFrmFindJDPlanFromList.pas' {frmFindJDPlanFromList},
  uFrmSetOrg in '功能窗口\通用功能\乘务员信息管理\uFrmSetOrg.pas' {frmSetOrg},
  uFrmPBFromPrepare in '功能窗口\派班\uFrmPBFromPrepare.pas' {frmPBFromPrepare},
  uFrmNameBoardPrepareChangeLog in '功能窗口\查看名牌变动日志\uFrmNameBoardPrepareChangeLog.pas' {frmNameBoardPrepareChangeLog},
  uFrmCTQRecord in '功能窗口\出退勤记录\uFrmCTQRecord.pas' {frmCTQRecord};

{$R *.res}
//var
//  HMutex: DWord;

begin
//  HMutex := CreateMutex(nil, TRUE, 'RunSafty'); //创建Mutex句柄
//  {-----检测Mutex对象是否存在，如果存在，退出程序------------}
//  if (GetLastError = ERROR_ALREADY_EXISTS) then
//  begin
//    ReleaseMutex(hMutex); //释放Mutex对象
//    Exit;
//  end;
  TimeSeparator := ':';
  DateSeparator := '-';
  ShortDateFormat := 'yyyy-mm-dd';
  ShortTimeFormat := 'hh:nn:ss';
  SysUtils.LongTimeFormat := 'HH:mm:ss';
  SysUtils.LongDateFormat := 'yyyy-MM-dd';

  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Forms.Application.Initialize;
  Forms.Application.Title := '机务信息平台';
  try
    Forms.Application.CreateForm(TGlobalDM, GlobalDM);
  begin
      GlobalDM.UpdateConfigFile();
      GlobalDM.LoadConfig();
      frmLogin := TfrmLogin.Create(nil);
      try
        frmLogin.InitCustomUI;
        if frmLogin.ShowModal = mrOk then
        begin
          if GlobalDM.UseFinger then
          begin
            GlobalDM.LogManage.InsertLog('初始化指纹仪');

            if GlobalDM.FingerPrintCtl.Init then
            begin
              try
                GlobalDM.FingerPrintCtl.LoadLocalTM(TFrmFinerLoadProgress.ShowProgress());
                GlobalDM.FingerPrintCtl.SynFingerLoader.Start();
              finally
                TFrmFinerLoadProgress.CloseProgress();
              end;
            end;


          end;


          if frmLogin.InOffLine then
            TFrmLocalDrink.ShowForm
          else
          begin
            case GlobalDM.SiteInfo.nSiteJob of
              Ord(sjAdmin):
                begin
                  TFrmMain_JiDiao_Extra.EnterJiDiao;
                end;
              Ord(sjDiaodu):
                begin

                  GlobalDm.CurrentModule := sjDiaodu;
                  TFrmMain_JiDiao_Extra.EnterJiDiao;
                end;
              Ord(sjPaiBan):
                begin
                  GlobalDm.CurrentModule := sjPaiBan;
                  TfrmMain_RenYuan.EnterPaiBan;
                end;
              Ord(sjChuQin):
                begin
                  GlobalDm.CurrentModule := sjChuQin;
                  TfrmMain_ChuQin.EnterChuQin;
                end;
              Ord(sjTuiQin):
                begin
                  GlobalDm.CurrentModule := sjTuiQin;
                  TfrmMain_TuiQin.EnterTuiQin;
                end;
              Ord(sjGuanLi):
                begin
                  GlobalDm.CurrentModule := sjGuanLi;
                  TfrmMain_GuanLi.EnterGuanLi();
                end;
              ord(sjWaiQin):
                begin
                  GlobalDm.CurrentModule := sjWaiQin;
                  TFrmMain_WaiQin.EnterWaiQin();
                end;
              ord(sjGuide):
                begin
                  GlobalDm.CurrentModule := sjGuide;
                  TfrmMain_GuideSign.Enter;
                end

            else
              begin
                Forms.Application.MessageBox('错误的岗位信息！', '提示', MB_OK + MB_ICONINFORMATION);
              end;
            end;

          end;

        end;
      finally
        frmLogin.Free;
      end;
    end;
  except on e : exception do
    showmessage(e.Message);
  end;
  Forms.Application.Run;
end.

