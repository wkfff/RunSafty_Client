unit uFlowCtlIntf;

interface
uses
  Classes,SysUtils;
type

  
  //计划摘要
  RPlanSummary = record
    //车型
    TrainType: WideString;
    //车号
    TrainNumber: WideString;
    //车次
    TrainNo: WideString;
    //计划ID
    PlanID: WideString;
    //交路名称
    JlName: WideString;
    //交路ID
    JlID: WideString;
    //计划时间
    StartTime: TDateTime;
  end;

  //人员信息
  RTM = record
    //人员GUID
    ID: WideString;
    //工号
    Number: WideString;
    //姓名
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
    //结构体大小
    Size: integer;
    //主进程APP句柄
    AppHandle: integer;
    //接口地址
    ApiHost: WideString;
    //接口端口号
    ApiPort: integer;
    //
    Site: RSite;
    //计划
    Plan: RPlanSummary;
    //人员
    TM: RTM;
    //管理员登录回调
    LoginFun: TLoginCallback;
  end;             

  {$IFNDEF Project_Lib}
    function CheckBWFlow(param: RParam): Boolean;external 'WorkFlowCtl.dll';
  {$endif}
implementation

end.
