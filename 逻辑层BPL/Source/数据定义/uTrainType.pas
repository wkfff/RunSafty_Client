unit uTrainType;

interface
uses
  uSaftyEnum;
type
  //�������ͷ�����Ϣ
  RRsTrainNoBelong = record
    //����ͷ��Ϊ��ʱ��ʾΪȫ����
    strTrainNoHead : string;
    //��ʼ��Χ
    nBeginNumber : integer;
    //������Χ
    nEndNumber : integer;
    //�ͻ�����
    nKehuoID  : TRsKehuo;
  end;

  TRsTrainNoBelongArray = array of RRsTrainNoBelong;
implementation

end.
