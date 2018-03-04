unit uWriteICCarSoftDefined;

interface
uses uTFSystem,Windows;

type

  {TOpenWindowStyle �򿪴��ڷ�ʽ}
  TOpenWindowStyle = (osShortCut{ͨ����ݼ�},osMouseDown{ͨ�������});

  {TSiWeiKDXKType ˼ά���д������}
  TSiWeiKDXKType = (skHaErBin{������},skNanJing{�Ͼ�});
   {TZZSKDXKType ���޿��д������}
  TZZSKDXKType = (zkZZ{����},zkNanNing{����});
  {TICCorpration IC�������������}
  TICCorpration = (SiWeiIckgl{˼άIC������},SiWeiKDXK{˼ά���д��},
      ZZKDXK{���޿��д��});

  {TKeHuo �ͻ�����}
  TKeHuo = (khHuoChe,khKeChe,khKeHuo);

  {TTravelDirection �г�����}
  TTravelDirection = (tdUp,tdDown,tdAll);

  {TOnWriteICCarStateNotice д��״̬֪ͨ�¼�}
  TOnStateNotice = procedure(strCommand:String) of Object;

  {RLoginInfo ��¼��Ϣ�ṹ��}
  RLoginInfo = record
    AdminPassword :string;       //����Ա��¼����
    OndutyPersonID :string;      //ֵ��Ա�˺�
    OndutyPersonPWD :string;     //ֵ��Ա��¼����
  end;


  {RDutyInfo д��������Ϣ�ṹ��}
  RWriteICCarDutyInfo = Record
    {�ͻ�}
    KeHuo : TKeHuo;
    {����}
    TravelDirection : TTravelDirection;
    {��ӡ����}
    PrintPageCount : Integer;
    {д������}
    QuDuan : string;
    {����ͷ}
    CheCiTou : String;
    {���κ�}
    CheCiNumber : String;
    {����κ�}
    DH : String;
    {���������}
    DName : String;
    {˾����}
    TrainmanNumber : String;
    {��˾����}
    SubTrainmanNumber : String;
    {��·��}
    JiaoLuHao : string;
    {��վ��}
    CheZhanHao : string;
  end;

  {RWriteICCarParam д�������ṹ��}
  RWriteICCarParam = Record
    {д�����������ڱ���}
    MainFormTitle : String;
    {�ȴ�ʱ��}
    WaitTimeOut : Integer;
    {�ȴ�д����������ʱ��,��λ����}
    WaitRunWriteICCarProgramTimeOut : Integer;
  end;

  {RWindowHandles д��������ִ��ھ��}
  RSoftHandles = Record
    {��������}
    MainFormHandle : HWND;
    {д��������}
    WriteCardFormHandle : HWND;
    {ֵ��Ա��¼���ھ��}
    AttendantFormHandle : HWND;
    {����Ա��½����}
    AdminFormHandle : HWND;
  end;



  {RAttendantLoginWindowChildOrders ֵ��Ա��½�����ӿؼ����˳���}
  RAttendantLoginWindowChildOrders = Record
    {���ű༭��}
    edtNumber_TabOrders : TIntArray;
    {����༭��}
    edtPassWord_TabOrders : TIntArray;
    {ȷ�ϰ�ť}
    btnConfirm_TabOrders : TIntArray;
  end;

  {RAdminLoginWindowChildOrders ����Ա��½�����ӿؼ����˳���}
  RAdminLoginWindowChildOrders = Record
    {����༭��}
    edtPassWord_TabOrders : TIntArray;
    {ȷ�ϰ�ť}
    btnConfirm_TabOrders : TIntArray;
  end;

  {RWriteICCarWindowChildOrders д�����ڿؼ����������Ϣ}
  RWriteICCarWindowChildOrders = Record
    {���οؼ��������}
    cbxQuDuan_TabOrders : TIntArray;
    {�ͳ��ؼ��������}
    rbKeChe_TabOrders : TIntArray;
    {�����ؼ��������}
    rbHuoChe_TabOrders : TIntArray;
    {�ͻ��ؼ��������}
    rbKeHuo_TabOrders : TIntArray;
    {����ͷ�ؼ��������}
    cbxCheCiTou_TabOrders : TIntArray;
    {����ͷ�༭��ؼ��������}
    edtCheCiTou_TabOrders : TIntArray;
    {���κſؼ��������}
    edtCheCiNumber_TabOrders : TIntArray;
    {˾���ſؼ��������}
    edtTrainmanNumber_TabOrders : TIntArray;
    {��˾���ſؼ��������}
    edtSubTrainmanNumber_TabOrders : TIntArray;
    {��·�ſؼ��������}
    edtJiaoLuNumber_TabOrders : TIntArray;
    {��վ�ſؼ��������}
    edtCheZhanNumber_TabOrders : TIntArray;
    {����οؼ��������}
    cbxJWD_TabOrders : TIntArray;
    {���ؿؼ��������}
    edtZongZhong_TabOrders : TIntArray;
    {�����ؼ��������}
    edtHuanChang_TabOrders : TIntArray;
    {�����ؼ��������}
    edtLiangShu_TabOrders : TIntArray;
    {����ؼ��������}
    rbBenWu_TabOrders : TIntArray;
    {�����ؼ��������}
    rbBuJi_TabOrders : TIntArray;
    {����Ա���˲������}
    rbTrainmanChuCheng_TabOrders : TIntArray;
    {�ɲ���˲������}
    rbGanBuTianCheng_TabOrders : TIntArray;
    {д����ť�������}
    btnWriteICCar_TabOrders : TIntArray;
    {������ť�������}
    btnEraseICCar_TabOrders : TIntArray;
    {����ʾ�ļ���ť�������}
    btnReadJieShiFile_TabOrders : TIntArray;
  end;

  {RJiaoFuJieShiPrintWindowChildOrders ������ʾ��ӡ���ڿؼ����������Ϣ}
  RJiaoFuJieShiPrintWindowChildOrders = Record
    {����Ԥ����ť����}
    btnPrintPreview_MousePoint : TPoint;
    {��ӡ�����������}
    PrintParent_TabOrders : TIntArray;
    {�����б��˳���}
    cbxSection_TabOrders : TIntArray;
    {�г�����˳���}
    cbxDirection_TabOrders : TIntArray;
    {�ͻ�˳���}
    cbxKeHuo_TabOrders : TIntArray;
    {��ӡ��ť˳���}
    btnPrint_TabOrders : TIntArray;
  end;

  {RPrintCountWindowChildOrders ��ӡ�������ڿؼ����������Ϣ}
  RPrintCountWindowChildOrders = Record
    {��ӡ�����༭��˳���}
    edtPrintCount_TabOrders : TIntArray;
    {ȷ�ϴ�ӡ��ť˳���}
    btnConfirm_TabOrders : TIntArray;
  end;




implementation



end.
