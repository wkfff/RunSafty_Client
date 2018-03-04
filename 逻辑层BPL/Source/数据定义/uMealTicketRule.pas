unit uMealTicketRule;

interface

uses
  SysUtils,uTrainmanJiaolu;

type

  //��ȡ��Ʊ��Ϣ����Ա��Ϣ
  RRsMealTicketPersonInfo = record
    //��Ա����
    strTrainmanNumber:string;
    //��������
    strWorkShopGUID:string;
    //����
    strQuDuan:string;
    //����
    strCheCi:string;
    //�ɰ�ʱ��
    dtPaiBan:TDateTime;
  end;



  // ����/���ε������Ϣ
  RRsMealTicketCheCi = record
    //GUID
    strGUID:string;
    //����GUID��ITYPE���ݿ��ѯ��Ʊʹ�õ�
    //����GUID
    strWorkShopGUID:string;
    // ��·����
    iType:Integer;
    //����
    strQuDuan:string;
    //����
    strCheCi:string;
    //��ʼʱ��(���ŷ�Ʊ�ǿ�ʼ-����ʱ���TIME������Ч)
    //���� 06:00 ~ 09:00
    dtStartTime:TDateTime;
    //ֹͣʱ��
    dtEndTime:TDateTime;
    //����GUID
    strRuleGUID:string;
  end;

  RRsMealTicketCheCiPointer = ^RRsMealTicketCheCi ;


  TRsMealTicketCheCiList = array of RRsMealTicketCheCi;


  //��Ʊ����RULE
  RRsMealTicketRule = record
    //������¼��GUID
    strGUID:string;
    //��������
    strName:string;
    //����GUID
    strWorkShopGUID:string;
    // ��·����
    iType:Integer;
    //���
    iA:Integer;
    //����
    iB:Integer;
  end;


  RRsMealTicketRulePointer = ^RRsMealTicketRule;


  TRsMealTicketRuleList = array of RRsMealTicketRule ;

  //��ϸ˵��
 // ��Ʊ������ԶԶ�� �г��ƻ���Ϣ


implementation

end.
