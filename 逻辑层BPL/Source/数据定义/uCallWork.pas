unit uCallWork;

interface

type

  RRsCallWork = record
    nCallWorkType:Integer;  //�а���Ϣ���� 0 ���ӽа�  1 ȡ���а�
    strPlanGUID:string;        //�ƻ�GUID
    strMsgGUID:string;         //��ϢID
    strMsgContent:string;      //��������
    strStartTime:string ;     //����ʱ��
    strCreateTime:string;   //�а�ʱ��
    strTrainmanGUID:string;
    strTrainmanNumber:string;   //����
    strTrainmanName:string;   //����
    strMobileNumber:string; //�绰����
  end;

implementation

end.
