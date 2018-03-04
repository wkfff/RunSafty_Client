unit uMealTicketConfig;

interface

uses
  SysUtils,IniFiles;


const
  {�������ݿ��Ĭ���û���������}
  FIRE_BIRD_NAME = 'SYSDBA' ;
  FIRE_BIRD_PASS = 'masterkey' ;
  FIRE_BIRD_LOCATION = 'D:\BPGL\CJGL.DAT' ;

type
  //��Ʊ�ķ���������
  RRsMealServerConfig = record
    bUsesMealTicket:Boolean;  //�Ƿ�ʹ��(�ڴ����Ӧ����int)
    strServerIP:string;       //��������ַ
    strServerUser:string;     //�û���
    strServerPass:string;     //����
    strDataLocation:string;   //���ݿ�λ��
    strCheJian:string;        //��������
    nInterval:Integer;        //���ż��
  end;

  //��ȡ��Ʊ������������
  TRsMealConfigOper = class
  public
    constructor Create(FileName:string);
  public
    //��ȡ
    procedure ReadMealServerConfig(var MealServerConfig:RRsMealServerConfig);
    //д��
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
    raise Exception.Create('�ļ�������Ϊ��');
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
    raise Exception.Create('�ļ�������Ϊ��');
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
