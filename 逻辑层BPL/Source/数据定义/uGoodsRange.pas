unit uGoodsRange;

interface

uses
  SysUtils;

type
  //��Ʒ��ŷ�Χ
  RRsGoodsRange = record
    strGUID:string;         //Ψһ���
    nLendingTypeID:Integer; //��Ʒ���� {��̨/IC��/����}
    nStartCode:Integer;     //��ʼ���
    nStopCode:Integer;      //��ֹ���
    strExceptCodes:string;  //�ų��ı��
    strWorkShopGUID:string; //������
  end;

  //��Ʒ��Χ����
  TRsGoodsRangeList = array of  RRsGoodsRange ;

  //��Ʒ��Χָ��
  PRsGoodsRange =  ^RRsGoodsRange ;

implementation

end.
