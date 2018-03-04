unit uRunSaftyDefine;

interface
uses
  Graphics, uApparatusCommon;

type

  //////////////////////////////////////////////////////////////////////////////
  ///<summary>RItemUseConfig:�Ƿ�����ĳ���������</summary>
  //////////////////////////////////////////////////////////////////////////////
  RItemUseConfig = packed record
    /// <summary>�Ƿ�����</summary>
    bIsUsed:Boolean;
    /// <summary>���øù���ʱ����Ҫ��ֵ</summary>
    nValue:Integer;
  end;

const
  C_CONFIG_FILENAME = 'config.ini';
  C_CONST_GRIDENAME_JIBAN = '�����б�';
  C_CONST_GRIDENAME_PAIBANSHI = '�ɰ����б�';
  C_CONST_GRIDENAME_CHUQIN = '�����б�';
  C_CONST_GRIDENAME_TUIQIN = '�����б�';
  


  /// <summary>���ڿ��ؽ���б��ȶ���</summary>
  TChuQinTrainmanDetailWidthAry : array[0..4] of Integer = (40{���},107{������},
    120{����ʱ��},420{��������},100{���ؽ��});
implementation

end.
