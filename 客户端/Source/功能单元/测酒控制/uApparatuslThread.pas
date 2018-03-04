unit uApparatuslThread;

interface
uses Windows,Classes,SysUtils,UCommand,uBaseDefine,ActiveX;

const
  WAIT_CHECKMORETIME = 1200;

type

  {ApparatusThread ���״̬��ȡ�߳���}
  TApparatusThread = class(TThread)
  public
    constructor Create(Apparatus: TObject);overload;
  protected
    procedure Execute; override;
  private
    m_bIsReadDeviceState : Boolean;//�Ƿ��ȡ�豸״̬
    m_Apparatus: TObject; //����Ĳ���豸ͨ��
    m_nMoreFirstTime : Integer;//��һ�����Ƴ���ʱ��
    m_bDeviceIsReady : Boolean;//�豸�ӿ�ʼ����ʱ���������Ƿ����
    m_bChuiQi : boolean;
    m_bCeJiu : boolean;
  private
    procedure ReadDeviceState();
    procedure SetIsReadDeviceState(bValue : Boolean);
    procedure SendGH(gh : string);
    procedure SendXM(xm : string);
  public
    property IsReadDeviceState : Boolean read m_bIsReadDeviceState
        write SetIsReadDeviceState;
    property DeviceIsReady : Boolean read m_bDeviceIsReady
        write m_bDeviceIsReady;
  end;
  function GetChineseLattice_GH(ChineseText: string; out LatticeData: array of byte; Style: Integer; FontSize: Integer): Boolean; stdcall; far; external 'Lattices.dll';

  function GetChineseLattice_Name(ChineseText: string; out LatticeData: array of byte; Style: Integer; FontSize: Integer): Boolean; stdcall; far; external 'Lattices.dll';
implementation
uses
  uApparatus;
  
function IsDigit(str: string): boolean;
var
  I: Integer;
begin
  for I := 1 to length(str) do
    if not (str[i] in ['0'..'9', 'A'..'Z']) then
      begin
        Result := False;
        Exit;
      end;
  result := true;
end;
{ TAlcoholThread }

constructor TApparatusThread.Create(Apparatus: TObject);
begin
  inherited Create(Suspended);
  m_nMoreFirstTime := 0;
  m_Apparatus := Apparatus;
  FreeOnTerminate := False;
  m_bIsReadDeviceState := False;
  DeviceIsReady := False;
  m_bChuiQi := false;
  m_bCeJiu := false;
end;


procedure TApparatusThread.Execute;
var
  cmd : TCmdBase;
begin
  CoInitialize(nil);
  try
    while Terminated = False do
    begin
      ReadDeviceState();
      Sleep(200);
    end;
    cmd := TCmdStopRefrash.Create;
    try
      cmd.MakeArray;
      TApparatus(m_Apparatus).SendData(cmd);
    finally
      cmd.Free;
    end;
  finally
    CoUninitialize;  
  end;
end;

procedure TApparatusThread.ReadDeviceState;
//���ܣ���ȡ�豸״̬
var
  Cmd: TCmdAA;
  wCurrentStatus : Word;
begin
  try
    Assert(Assigned(TApparatus(m_Apparatus)));
  except
    On E:Exception do
    begin
      OutPutDebugString('�߳��е�TApparatus������Ч��');
      Exit;
    end;
  end;
  
  try
    if TApparatus(m_Apparatus).Connected = False then
    begin
      Sleep(1000);
      if TApparatus(m_Apparatus).Open() = False then Exit;
    end;
   if m_bIsReadDeviceState then
    begin
      if not m_bChuiQi then
      begin
        cmd := TCmdAA_ListQZJ.Create;
        try
          cmd.MakeArray;
          TApparatus(m_Apparatus).SendData(TCmdBase(Cmd));
        finally
          m_bChuiQi := true;
          cmd.Free;
        end;
        exit;
      end;
      if not m_bCeJiu then
      begin
        cmd := TCmdAA_Prepare.Create(TApparatus(m_Apparatus).ReadStandValue,true);
        try
          cmd.MakeArray;
          TApparatus(m_Apparatus).SendData(TCmdBase(Cmd));
        finally
          cmd.Free;
          m_bCeJiu := true;
        end;
        exit;
      end;
      Cmd := TCmdAA_Start.Create(TApparatus(m_Apparatus).ReadStandValue,true);
      Cmd.WriteStandVolt(TApparatus(m_Apparatus).ReadStandValue);
      TApparatus(m_Apparatus).SendData(TCmdBase(Cmd));
      
      SendGH(TApparatus(m_Apparatus).GH);
      SendXM(TApparatus(m_Apparatus).XM);
    end else begin
      Cmd := TCmdAA.Create(TApparatus(m_Apparatus).ReadStandValue,true);
      Cmd.WriteStandVolt(TApparatus(m_Apparatus).ReadStandValue);
      TApparatus(m_Apparatus).SendData(TCmdBase(Cmd));
    end;

    try
      if m_bIsReadDeviceState then
      begin
        wCurrentStatus := TApparatus(m_Apparatus).ApparatusInfo.wStatus;
        TApparatus(m_Apparatus).ApparatusInfo := Cmd.ApparatusInfo;
        if Word(Cmd.RecArray.RecArray[9]) = 1 then
        begin
          PostMessage(TApparatus(m_Apparatus).MSGHandle,WM_PhotoCaptured, 0, 0);
        end;
        if wCurrentStatus <> Cmd.ApparatusInfo.wStatus then
        begin
          if m_bDeviceIsReady then
          begin
            if TApparatus(m_Apparatus).StateChangeOnEndTest then
              IsReadDeviceState := False;

            PostMessage(TApparatus(m_Apparatus).Handle,
                WM_APPARATUS_INFO_CHANGE, 0, 0);
          end;
        end;

        if TApparatus(m_Apparatus).ApparatusInfo.wStatus = crReady then
        begin
          if m_bDeviceIsReady = False then
          begin
            m_bDeviceIsReady := True;
            PostMessage(TApparatus(m_Apparatus).Handle,
                WM_APPARATUS_INFO_CHANGE, 0, 0);
          end;
        end;
      end;
    finally
      if Assigned(Cmd) then
        FreeAndNil(Cmd);
    end;
  
  except
    On E:Exception do
    begin
      OutPutDebugString(PChar('��ȡ�豸״̬ʧ�ܣ�����:('+E.Message+')'));
    end;
  end;

end;

procedure TApparatusThread.SendGH(gh : string);
var
  strGH : string;
  i : integer;
  CmdGH : TCmdGH;
  SendAry : TSndAry58;
  CmdAA_Start: TCmdAA_Start;
begin
  strGH := Trim(Uppercase(gh));
  //�ж��Ƿ��ǺϷ����ַ� ֧��[789yy]����
  if IsDigit(strGH) then
  begin
    for I := 0 to Length(strGH) - 1 do
      begin
        FillChar(SendAry, 58, 0);
        GetChineseLattice_GH(gh[I + 1], SendAry, 0, 14);
        CmdGH := TCmdGH.Create(SendAry, i);
        TApparatus(m_Apparatus).SendData(CmdGH);
        CmdGH.Free;
      end;
  end;
end;

procedure TApparatusThread.SendXM(xm: string);
var
  I, J, nLen: Integer;
  CmdName: TCmdName;
  SendAry_Name: TSndAry116;
  strName, strTemp: string;
begin
  I := 1;
  J := 0;
  strName := Trim(xm);
  nLen := Length(strName);
  while I <= NLen do
  begin
    if (ord(strName[I]) >= 33) and (ord(strName[I]) <= 126) then
      begin
        strTemp := xm[I];
        if ((I + 1) <= NLen) and (ord(strName[I + 1]) >= 48) and (ord(strName[I + 1]) <= 57) then
          begin
            strTemp := copy(strName, I, 2);
            I := I + 2;
          end
        else
          I := I + 1;
      end
    else
      begin
        strTemp := copy(strName, I, 2);
        I := I + 2;
      end;
    FillChar(SendAry_Name, 116, 0);
    GetChineseLattice_Name(strTemp, SendAry_Name, 0, 14);
    CmdName := TCmdName.Create(SendAry_Name, J, N_Top);
    TApparatus(m_Apparatus).SendData(CmdName);
    CmdName.Free;

    CmdName := TCmdName.Create(SendAry_Name, J, N_Bottum);
    TApparatus(m_Apparatus).SendData(CmdName);
    CmdName.Free;

    Inc(J);
  end;
end;

procedure TApparatusThread.SetIsReadDeviceState(bValue: Boolean);
begin
  if bValue = m_bIsReadDeviceState then Exit;
  m_bIsReadDeviceState := bValue;
  m_bDeviceIsReady := False;
end;

end.

