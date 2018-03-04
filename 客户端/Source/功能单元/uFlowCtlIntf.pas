unit uFlowCtlIntf;

interface
uses
  Classes,SysUtils;
type

  
  //�ƻ�ժҪ
  RPlanSummary = record
    //����
    TrainType: WideString;
    //����
    TrainNumber: WideString;
    //����
    TrainNo: WideString;
    //�ƻ�ID
    PlanID: WideString;
    //��·����
    JlName: WideString;
    //��·ID
    JlID: WideString;
    //�ƻ�ʱ��
    StartTime: TDateTime;
  end;

  //��Ա��Ϣ
  RTM = record
    //��ԱGUID
    ID: WideString;
    //����
    Number: WideString;
    //����
    Name: WideString;
    //
    WorkShopID: WideString;
    //
    WorkShopName: WideString;
  end;

  RSite = record
    WorkShopID: WideString;
    SiteID: WideString;
    SiteName: WideString;
  end;
  TLoginCallback = function (var TM: RTM; var Verify: integer): Boolean;


  RParam = record
    //�ṹ���С
    Size: integer;
    //������APP���
    AppHandle: integer;
    //�ӿڵ�ַ
    ApiHost: WideString;
    //�ӿڶ˿ں�
    ApiPort: integer;
    //
    Site: RSite;
    //�ƻ�
    Plan: RPlanSummary;
    //��Ա
    TM: RTM;
    //����Ա��¼�ص�
    LoginFun: TLoginCallback;
  end;             

  {$IFNDEF Project_Lib}
    function CheckBWFlow(param: RParam): Boolean;external 'WorkFlowCtl.dll';
  {$endif}
implementation

end.
