unit uWriteICCarSoftDefined;

interface
uses uTFSystem,Windows;

type

  {TOpenWindowStyle 打开窗口方式}
  TOpenWindowStyle = (osShortCut{通过快捷键},osMouseDown{通过鼠标点击});

  {TSiWeiKDXKType 思维跨段写卡类型}
  TSiWeiKDXKType = (skHaErBin{哈尔滨},skNanJing{南京});
   {TZZSKDXKType 株洲跨段写卡类型}
  TZZSKDXKType = (zkZZ{株洲},zkNanNing{南宁});
  {TICCorpration IC卡管理软件类型}
  TICCorpration = (SiWeiIckgl{思维IC卡管理},SiWeiKDXK{思维跨段写卡},
      ZZKDXK{株洲跨段写卡});

  {TKeHuo 客货类型}
  TKeHuo = (khHuoChe,khKeChe,khKeHuo);

  {TTravelDirection 行车方向}
  TTravelDirection = (tdUp,tdDown,tdAll);

  {TOnWriteICCarStateNotice 写卡状态通知事件}
  TOnStateNotice = procedure(strCommand:String) of Object;

  {RLoginInfo 登录信息结构体}
  RLoginInfo = record
    AdminPassword :string;       //管理员登录密码
    OndutyPersonID :string;      //值班员账号
    OndutyPersonPWD :string;     //值班员登录密码
  end;


  {RDutyInfo 写卡出勤信息结构体}
  RWriteICCarDutyInfo = Record
    {客货}
    KeHuo : TKeHuo;
    {方向}
    TravelDirection : TTravelDirection;
    {打印份数}
    PrintPageCount : Integer;
    {写卡区段}
    QuDuan : string;
    {车次头}
    CheCiTou : String;
    {车次号}
    CheCiNumber : String;
    {机务段号}
    DH : String;
    {机务段名称}
    DName : String;
    {司机号}
    TrainmanNumber : String;
    {副司机号}
    SubTrainmanNumber : String;
    {交路号}
    JiaoLuHao : string;
    {车站号}
    CheZhanHao : string;
  end;

  {RWriteICCarParam 写卡参数结构体}
  RWriteICCarParam = Record
    {写卡程序主窗口标题}
    MainFormTitle : String;
    {等待时间}
    WaitTimeOut : Integer;
    {等待写卡程序启动时间,单位毫秒}
    WaitRunWriteICCarProgramTimeOut : Integer;
  end;

  {RWindowHandles 写卡软件各种窗口句柄}
  RSoftHandles = Record
    {主窗体句柄}
    MainFormHandle : HWND;
    {写卡窗体句柄}
    WriteCardFormHandle : HWND;
    {值班员登录窗口句柄}
    AttendantFormHandle : HWND;
    {管理员登陆窗口}
    AdminFormHandle : HWND;
  end;



  {RAttendantLoginWindowChildOrders 值班员登陆窗口子控件句柄顺序号}
  RAttendantLoginWindowChildOrders = Record
    {工号编辑框}
    edtNumber_TabOrders : TIntArray;
    {密码编辑框}
    edtPassWord_TabOrders : TIntArray;
    {确认按钮}
    btnConfirm_TabOrders : TIntArray;
  end;

  {RAdminLoginWindowChildOrders 管理员登陆窗口子控件句柄顺序号}
  RAdminLoginWindowChildOrders = Record
    {密码编辑框}
    edtPassWord_TabOrders : TIntArray;
    {确认按钮}
    btnConfirm_TabOrders : TIntArray;
  end;

  {RWriteICCarWindowChildOrders 写卡窗口控件查找序号信息}
  RWriteICCarWindowChildOrders = Record
    {区段控件查找序号}
    cbxQuDuan_TabOrders : TIntArray;
    {客车控件查找序号}
    rbKeChe_TabOrders : TIntArray;
    {货车控件查找序号}
    rbHuoChe_TabOrders : TIntArray;
    {客货控件查找序号}
    rbKeHuo_TabOrders : TIntArray;
    {车次头控件查找序号}
    cbxCheCiTou_TabOrders : TIntArray;
    {车次头编辑框控件查找序号}
    edtCheCiTou_TabOrders : TIntArray;
    {车次号控件查找序号}
    edtCheCiNumber_TabOrders : TIntArray;
    {司机号控件查找序号}
    edtTrainmanNumber_TabOrders : TIntArray;
    {副司机号控件查找序号}
    edtSubTrainmanNumber_TabOrders : TIntArray;
    {交路号控件查找序号}
    edtJiaoLuNumber_TabOrders : TIntArray;
    {车站号控件查找序号}
    edtCheZhanNumber_TabOrders : TIntArray;
    {机务段控件查找序号}
    cbxJWD_TabOrders : TIntArray;
    {总重控件查找序号}
    edtZongZhong_TabOrders : TIntArray;
    {换长控件查找序号}
    edtHuanChang_TabOrders : TIntArray;
    {辆数控件查找序号}
    edtLiangShu_TabOrders : TIntArray;
    {本务控件查找序号}
    rbBenWu_TabOrders : TIntArray;
    {补机控件查找序号}
    rbBuJi_TabOrders : TIntArray;
    {乘务员出乘查找序号}
    rbTrainmanChuCheng_TabOrders : TIntArray;
    {干部添乘查找序号}
    rbGanBuTianCheng_TabOrders : TIntArray;
    {写卡按钮查找序号}
    btnWriteICCar_TabOrders : TIntArray;
    {擦卡按钮查找序号}
    btnEraseICCar_TabOrders : TIntArray;
    {读揭示文件按钮查找序号}
    btnReadJieShiFile_TabOrders : TIntArray;
  end;

  {RJiaoFuJieShiPrintWindowChildOrders 交付揭示打印窗口控件查找序号信息}
  RJiaoFuJieShiPrintWindowChildOrders = Record
    {交付预览按钮坐标}
    btnPrintPreview_MousePoint : TPoint;
    {打印参数所属面板}
    PrintParent_TabOrders : TIntArray;
    {区段列表框顺序号}
    cbxSection_TabOrders : TIntArray;
    {行车方向顺序号}
    cbxDirection_TabOrders : TIntArray;
    {客货顺序号}
    cbxKeHuo_TabOrders : TIntArray;
    {打印按钮顺序号}
    btnPrint_TabOrders : TIntArray;
  end;

  {RPrintCountWindowChildOrders 打印份数窗口控件查找序号信息}
  RPrintCountWindowChildOrders = Record
    {打印数量编辑框顺序号}
    edtPrintCount_TabOrders : TIntArray;
    {确认打印按钮顺序号}
    btnConfirm_TabOrders : TIntArray;
  end;




implementation



end.
