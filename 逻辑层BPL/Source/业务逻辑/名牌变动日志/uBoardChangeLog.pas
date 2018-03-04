unit uBoardChangeLog;

interface
uses
  uTFSystem,ADODB,uTrainman,uTrainmanJiaolu,
  SysUtils,uDutyUser,Windows,Classes, forms, Controls;
type
  TBoardChangeType = (btNone=0,btcAddTrainman{添加人员},btcDeleteTrainman{删除人员},
    btcExchangeTrainman{交换人员},btcAddGroup{添加机组},btcDeleteGroup{删除机组},
    bctExchangeGroup{交换机组},btcChangeGroupOrder{修改机组的顺序});

implementation

end.
