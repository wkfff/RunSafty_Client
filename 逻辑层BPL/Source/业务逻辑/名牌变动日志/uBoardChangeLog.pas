unit uBoardChangeLog;

interface
uses
  uTFSystem,ADODB,uTrainman,uTrainmanJiaolu,
  SysUtils,uDutyUser,Windows,Classes, forms, Controls;
type
  TBoardChangeType = (btNone=0,btcAddTrainman{�����Ա},btcDeleteTrainman{ɾ����Ա},
    btcExchangeTrainman{������Ա},btcAddGroup{��ӻ���},btcDeleteGroup{ɾ������},
    bctExchangeGroup{��������},btcChangeGroupOrder{�޸Ļ����˳��});

implementation

end.
