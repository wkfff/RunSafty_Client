unit uMealTicketConfig;

interface

uses
  SysUtils,IniFiles;


const
  {火鸟数据库的默认用户名和密码}
  FIRE_BIRD_NAME = 'SYSDBA' ;
  FIRE_BIRD_PASS = 'masterkey' ;
  FIRE_BIRD_LOCATION = 'D:\BPGL\CJGL.DAT' ;

type
  //饭票的服务器配置
  RRsMealServerConfig = record
    bUsesMealTicket:Boolean;  //是否使用(内存对齐应该是int)
    strServerIP:string;       //服务器地址
    strServerUser:string;     //用户名
    strServerPass:string;     //密码
    strDataLocation:string;   //数据库位置
    strCheJian:string;        //所属车间
    nInterval:Integer;        //发放间隔
  end;

  //获取饭票服务器的配置
  TRsMealConfigOper = class
  public
    constructor Create(FileName:string);
  public
    //获取
    procedure ReadMealServerConfig(var MealServerConfig:RRsMealServerConfig);
    //写入
    procedure WriteMealServerConfig(MealServerConfig:RRsMealServerConfig);
  private
    m_strFileName:string;
  end;

implementation

{ TRsMealConfigOper }

constructor TRsMealConfigOper.Create(FileName: string);
begin
  inherited Create();
  m_strFileName := FileName ;
end;

procedure TRsMealConfigOper.ReadMealServerConfig(var MealServerConfig: RRsMealServerConfig);
var
  ini:TIniFile;
begin
  if m_strFileName = '' then
  begin
    raise Exception.Create('文件名不能为空');
  end;
  ini := TIniFile.Create(m_strFileName);
  try
    with MealServerConfig do
    begin
      strServerIP := ini.ReadString('MealTicketConfig','DBServer','')  ;
      strServerUser := ini.ReadString('MealTicketConfig','DBName',FIRE_BIRD_NAME);
      strServerPass := ini.ReadString('MealTicketConfig','DBPass',FIRE_BIRD_PASS);
      strDataLocation := ini.ReadString('MealTicketConfig','DBLocation',FIRE_BIRD_LOCATION);
      nInterval := ini.ReadInteger('MealTicketConfig','Interval',0);
      strCheJian := ini.ReadString('MealTicketConfig','CheJian','');
    end;
  finally
    ini.Free;
  end;
end;

procedure TRsMealConfigOper.WriteMealServerConfig(MealServerConfig: RRsMealServerConfig);
var
  ini:TIniFile;
begin
  if m_strFileName = '' then
  begin
    raise Exception.Create('文件名不能为空');
  end;
  ini := TIniFile.Create(m_strFileName);
  try
    with MealServerConfig do
    begin
      ini.WriteString('MealTicketConfig','DBServer',strServerIP);
      ini.WriteString('MealTicketConfig','DBName',strServerUser);
      ini.WriteString('MealTicketConfig','DBPass',strServerPass);
      ini.WriteString('MealTicketConfig','DBLocation',strDataLocation);
      ini.WriteInteger('MealTicketConfig','Interval',nInterval);
      ini.WriteString('MealTicketConfig','CheJian',strCheJian);
    end;
  finally
    ini.Free;
  end;
end;

end.
