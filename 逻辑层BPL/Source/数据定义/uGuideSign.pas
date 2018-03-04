unit uGuideSign;

interface

type
  //ǩ����ʽ
  TRsSignFlag = (sfNone{��},sfInput{�ֶ�����},sfFinger{ָ��ʶ��});

  //ָ����ǩ����Ϣ
  RRsGuideSign = record
    //ǩ����¼GUID
    strGuideSignGUID : string;
    //����Ա����
    strTrainmanNumber : string;
    //����Ա����
    strTrainmanName : string;
    //��������GUID
    strWorkShopGUID : string; 
    //������������
    strWorkShopName  :string;
    //����ָ����GUID
    strGuideGroupGUID : string; 
    //����ָ��������
    strGuideGroupName : string;
    //ǩ��ʱ��
    dtSignInTime : TDateTime;
    //ǩ����ʽ
    nSignInFlag : TRsSignFlag;
    //ǩ��ʱ��
    dtSignOutTime : TDateTime;
    //ǩ�˷�ʽ
    nSignOutFlag : TRsSignFlag;
  end;
  TRsGuideSignArray = array of RRsGuideSign;

  //ָ����ǩ����Ϣ��ѯ����
  RRsQueryGuideSign = record
    //���ţ���Ϊ����
    strTrainmanNumber : string;
    //��������Ϊ����
    strTrainmanName : string;
    //�������䣬��Ϊ����
    strWorkShopGUID : string;
    //����ָ���� ����Ϊ����
    strGuideGroupGUID : string;
    //ǩ��ʱ��-��ʼ��ѯʱ��
    dtSignTimeBegin : TDateTime;   
    //ǩ��ʱ��-��ֹ��ѯʱ��
    dtSignTimeEnd : TDateTime;
    //ǩ����ʽ��sfNoneΪ����
    nSignFlag : TRsSignFlag; 
  end;

  //�򵥵���Ϣ��ֻ����GUID������
  RRsSimpleInfo = record
    //GUID
    strGUID : string;
    //����
    strName : string;
  end;
  TRsSimpleInfoArray = array of RRsSimpleInfo;

  //�򵥵�˾����Ϣ
  RRsTrainmanInfo = record
    //GUID
    strTrainmanGUID : string;
    //����
    strTrainmanName : string;
  end;
  TRsTrainmanInfoArray = array of RRsTrainmanInfo;
               
const
  //ǩ����ʽ
  TRsSignFlagArray : array[TRsSignFlag] of string = ('','�ֶ�','ָ��');

implementation

end.

