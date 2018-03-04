unit uTrainNo;

interface
uses
  uSaftyEnum;
type
  /// ����:TTrainNo
  /// ˵��:ͼ��������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RRsTrainNo = record
  public
    strGUID : String;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;
    {����ʱ��}
    dtStartTime : TDateTime;
    //ʵ�ʿ���ʱ��
    dtRealStartTime : TDateTime;
    {������·}
    strTrainJiaoluGUID : String;
   //������·����
    strTrainJiaoluName : string;
    {��ʼվGUID}
    strStartStation : string;
    //��ʼվ����
    strStartStationName : string;
    {�յ�վGUID}
    strEndStation : string;
    //�յ�վ����
    strEndStationName : string;
    //ֵ�˷�ʽ
    nTrainmanTypeID : TRsTrainmanType;
    //�ƻ�����
    nPlanType : TRsPlanType;
    //ǣ��״̬
    nDragType : TRsDragType;
    //�ͻ�
    nKeHuoID : TRsKehuo;
    //��ע����
    nRemarkType : TRsPlanRemarkType;
    //��ע����
    strRemark : string;


     {��¼����ʱ��}
    dtCreateTime : TDateTime;
    //�����Ŀͻ���GUID
    strCreateSiteGUID : string;
    //�����Ŀͻ�������
    strCreateSiteName : string;
    //������
    strCreateUserGUID : string;
    //����������
    strCreateUserName : string;
  end;
  TRsTrainNoArray = array of RRsTrainNo;
implementation

end.
