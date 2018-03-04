unit uRunSaftyDefine;

interface
uses
  Graphics, uApparatusCommon;

type

  //////////////////////////////////////////////////////////////////////////////
  ///<summary>RItemUseConfig:是否启用某项功能配置类</summary>
  //////////////////////////////////////////////////////////////////////////////
  RItemUseConfig = packed record
    /// <summary>是否启用</summary>
    bIsUsed:Boolean;
    /// <summary>启用该功能时所需要的值</summary>
    nValue:Integer;
  end;

const
  C_CONFIG_FILENAME = 'config.ini';
  C_CONST_GRIDENAME_JIBAN = '机班列表';
  C_CONST_GRIDENAME_PAIBANSHI = '派班室列表';
  C_CONST_GRIDENAME_CHUQIN = '出勤列表';
  C_CONST_GRIDENAME_TUIQIN = '退勤列表';
  


  /// <summary>出勤卡控结果列表宽度定义</summary>
  TChuQinTrainmanDetailWidthAry : array[0..4] of Integer = (40{序号},107{卡控项},
    120{卡控时间},420{卡控描述},100{卡控结果});
implementation

end.
