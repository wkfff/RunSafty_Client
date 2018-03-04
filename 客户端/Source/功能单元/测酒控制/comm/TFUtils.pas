
////////////////////////////////////////////////////////////////////////////////
//   Desc:     device commont identity unit                                   //
//             enum variais kind of device in the pc, and enum device property//
//             about DosName, Symblic Name, FriendlyName and etc.             //
//                                                                            //
//   external: setupapi, dbt and etc.                                         //
//                                                                            //
//   Author:   vonraolee                                                      //
//                                                                            //
//   history:  2005-06-01    Create this unit and modified Windows APIs                                //
////////////////////////////////////////////////////////////////////////////////


unit TFUtils;

interface

uses
  Windows, SysUtils, Classes, Controls, StdCtrls, dbt, setupapi, ComCtrls;

const
  GUID_ZLG_USB: TGUID = '{5f49c570-9db2-40c2-bc71-b453ba92bbd8}';
  GUID_STD_COM: TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';
  GUID_VID_COM: TGUID = '{5f49c570-9db2-40c2-bc71-b453ba92bbd8}';
  GUID_VID_NUL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  
  // empty clsid
  ClSID_STD_NULL:                TGUID = '{00000000-0000-0000-0000-000000000000}';

  { DevInterface class guid}
  CLSID_D12_USB:                 TGUID = '{77f49320-16ef-11d2-ad51-006097b514dd}';
  {374s class guid}
  CLSID_374S_USB:                TGUID = '{5e7f6bdf-1ce5-4d78-bbcf-d20c44329f7d}';

  { zlg ic reader    }
  ClSID_ZLG_USB:                 TGUID = '{5f49c570-9db2-40c2-bc71-b453ba92bbd8}';
  { standard serials }
  GUID_SERENUM_BUS_ENUMERATOR:   TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';
  { Serial device interface }
  GUID_DEVINTERFACE_COMPORT:     TGUID = '{86e0d1e0-8089-11d0-9ce4-08003e301f73}';

  { DevClass guid}
  GUID_CLASS_USB_DEVICE:         TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';

  GUID_CLASS_USBHUB:             TGUID = '{f18a0e88-c30c-11d0-8815-00a0c906bed8}';

{
#define CTL_CODE( DeviceType, Function, Method, Access ) (                 \
    ((DeviceType) << 16) | ((Access) << 14) | ((Function) << 2) | (Method) \
 }

  BULK      = 0;
  INTERRUPT = 1;
  CONTROL   = 2;
  ISO       = 3;

  FILE_DEVICE_USB_SCAN		=	$8000;
  IOCTL_INDEX						  = $0800;
  FILE_ANY_ACCESS         = 0;
  METHOD_BUFFERED         = 0;

  SETUP_DMA_REQUEST		  = $471;
  GET_FIRMWARE_VERSION	= $472;

  IOCTL_READ_REGISTERS   =
      (FILE_DEVICE_USB_SCAN shl 16) or ((FILE_ANY_ACCESS shl 14) or
      ((IOCTL_INDEX+3) shl 2) or (METHOD_BUFFERED));


  IOCTL_WRITE_REGISTERS  =
      (FILE_DEVICE_USB_SCAN shl 16) or ((FILE_ANY_ACCESS shl 4) or
      ((IOCTL_INDEX+4) shl 2) or (METHOD_BUFFERED));

type
  _IO_BLOCK = packed record
    uOffset: UINT;
    uLength: UINT;
    pbyData: PUCHAR;
    uIndex:  UINT;
  end;
  IO_BLOCK = _IO_BLOCK;
  PIO_BLOCK = ^IO_BLOCK;

  _IO_REQUEST = packed record
    uAddressL: WORD;
    bAddressH: byte;
    uSize:     word;
    bCommand:  BYTE;
  end;
  IO_REQUEST = _IO_REQUEST;
  PIO_REQUEST = ^IO_REQUEST;

type
  PFilCatNode = ^TFilCatNode;
  TFilCatNode = record
    DosName: array[0..MAX_PATH-1] of char;                //COM1, LPT1:
    SymbName: array[0..MAX_PATH-1] of char;               //符号连接
    FriendlyName : array[0..MAX_PATH-1] of char;          //描述名
    ClassName    : array[0..MAX_PATH-1] of char;          // 类名
    ClassGUID    : TGUID;                                 // 类GUID
    CLSID        : TGUID;                                 //Instance ClassID
    Mfg          : array[0..MAX_PATH-1] of char;          //
  end;
  
  TSysObjEnum = class
  private
    FGuid: TGUID;
    FFilters: TList;
    hDevIf: HDEVINFO;                                 //Instance list
    function GetCat(var caList: TList; CatGUID: TGUID): integer;
    function GetCountFilters: integer;
    function GetFilter(Item: integer): TFilCatNode;
    procedure SetIntfGUID(const CatGUID: TGUID);
    procedure RemoveAll();
  public
    // default to STD_COMM
    constructor Create; overload;

    constructor Create(const InstGuid: TGUID); overload;
    destructor Destroy; override;
    function FilterIndexOfFriendlyName(const FriendlyName: string): Integer;
    property CountFilters: integer read GetCountFilters;
    property Filters[item: integer]: TFilCatNode read GetFilter;
    property IntfGuid: TGuid read FGUID write SetIntfGUID;
  end;
  
implementation

{ TSysObjEnum }

constructor TSysObjEnum.Create(const InstGuid: TGUID);
begin
  inherited Create();
  if FFilters = nil then
    FFilters := TList.Create;
  GetCat(FFilters, InstGUID);
end;

constructor TSysObjEnum.Create();
begin
  inherited;
  if not Assigned(FFilters) then
    FFilters := TList.Create;
  GetCat(FFilters, GUID_SERENUM_BUS_ENUMERATOR);
end;

destructor TSysObjEnum.Destroy();
begin
  RemoveAll();

  FreeAndNil(FFilters);
  SetupDiDestroyDeviceInfoList(hDevIf);
  inherited;
end;

function TSysObjEnum.FilterIndexOfFriendlyName(
  const FriendlyName: string): Integer;
begin
  Result := FFilters.Count - 1;
  while (Result >= 0) and
        (AnsiCompareText(PFilCatNode(FFilters.Items[Result])^.FriendlyName,
                         FriendlyName) <> 0) do
    Dec(Result);
end;

function TSysObjEnum.GetCat(var caList: TList; CatGUID: TGUID): integer;
var
  idx: integer;
  PCatNode: PFilCatNode;
  S: array[0..MAX_PATH-1] of char;
  hNewDevIf: HDEVINFO;
  DevKey: HKEY;
  requiredLength: DWORD;
  deviceIfData: SP_DEVINFO_DATA;
  deviceInfoData: SP_DEVICE_INTERFACE_DATA;
  deviceDetailData: PSP_DEVICE_INTERFACE_DETAIL_DATA;
begin
  for idx := 0 to (caList.Count - 1) do
    if Assigned(caList.Items[idx]) then Dispose(caList.Items[idx]);

  caList.Clear;

  result := 0;
  SetupDiDestroyDeviceInfoList(hDevIf);

  hDevIf := SetupDiCreateDeviceInfoList(nil, 0);
  if hDevIf = Pointer(INVALID_HANDLE_VALUE) then exit;
  
  hNewDevIf := SetupDiGetClassDevsEx(@CatGUID,
                                     nil,
                                     0,
                                     DIGCF_PRESENT or DIGCF_DEVICEINTERFACE,
                                     hDevIf,
                                     nil,
                                     nil);
                                     
  FillChar(deviceInfoData, SizeOf(SP_DEVICE_INTERFACE_DATA), 0);
  deviceInfoData.cbSize := SizeOf(SP_DEVICE_INTERFACE_DATA);

  result := 0;
  while SetupDiEnumDeviceInterfaces(hNewDevIf,
                                   nil,
                                   CatGUID,
                                   result,
                                   deviceInfoData) do
  begin
    // Get Interface Size
    requiredLength := MAX_PATH;
    SetupDiGetDeviceInterfaceDetail(hNewDevIf,
                                   @deviceInfoData,
                                   nil,
                                   0,
                                   @requiredLength,
                                   nil);

    deviceDetailData := AllocMem(requiredLength);
    deviceDetailData^.cbSize := sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA);

    // Get Interface Detail Data
    FillChar(deviceIfData, SizeOf(SP_DEVINFO_DATA), 0);
    deviceIfData.cbSize := SizeOf(SP_DEVINFO_DATA);
    SetupDiGetDeviceInterfaceDetail(hNewDevIf,
                                   @DeviceInfoData,
                                   deviceDetailData,
                                   requiredLength,
                                   @requiredLength,
                                   @deviceIfData);

    New(PCatNode);
    ZeroMemory(PCatNode, SizeOf(TFilCatNode));

    CopyMemory(@PCatNode.SymbName[0],
               @deviceDetailData.DevicePath[0],
               requiredLength);

    FillChar(S, SizeOf(s), 0);
    if (SetupDiGetDeviceRegistryProperty(hNewDevIf,
                                     deviceIfData,
                                     SPDRP_FRIENDLYNAME,
                                     nil,
                                     PByte(@S[0]),
                                     MAX_PATH,
                                     @requiredLength))
    or (SetupDiGetDeviceRegistryProperty(hNewDevIf,
                                     deviceIfData,
                                     SPDRP_DEVICEDESC,
                                     nil,
                                     PByte(@S[0]),
                                     MAX_PATH,
                                     @requiredLength)) then
    CopyMemory(@PCatNode.FriendlyName[0],
               @S[0],
               requiredLength);

    FillChar(S, SizeOf(S), 0);
    SetupDiGetDeviceRegistryProperty(hNewDevIf,
                                     deviceIfData,
                                     SPDRP_CLASS,
                                     nil,
                                     PByte(@S[0]),
                                     MAX_PATH,
                                     @requiredLength);
    CopyMemory(@PCatNode.ClassName[0],
               @S[0],
               requiredLength);

    FillChar(S, SizeOf(S), 0);
    SetupDiGetDeviceRegistryProperty(hNewDevIf,
                                     deviceIfData,
                                     SPDRP_MFG,
                                     nil,
                                     PByte(@S[0]),
                                     MAX_PATH,
                                     @requiredLength);
    CopyMemory(@PCatNode.MFG[0],
               @S[0],
               requiredLength);

    FillChar(S, SizeOf(S), 0);
    SetupDiGetDeviceRegistryProperty(hNewDevIf,
                                     deviceIfData,
                                     SPDRP_CLASSGUID,
                                     nil,
                                     PByte(@S[0]),
                                     MAX_PATH,
                                     @requiredLength);
    PCatNode^.ClassGUID := StringToGUID(s);

    PCatNode.CLSID := deviceInfoData.InterfaceClassGuid;

    // get "Device Parameters" subkey PortName
    DevKey := SetupDiOpenDevRegKey(hNewDevIf,
                                   deviceIfData,
                                   DICS_FLAG_GLOBAL,
                                   0,
                                   DIREG_DEV,
                                   KEY_READ);

    if INVALID_HANDLE_VALUE <> DevKey then
    begin
      requiredLength := MAX_PATH;

      if RegQueryValueEx(DevKey,
                         'PortName',
                         nil,
                         nil,
                         @S[0],
                         @requiredLength) = ERROR_SUCCESS then
        CopyMemory(@PCatNode.DosName[0], @S[0], requiredLength);
        
      RegCloseKey(DevKey);
    end;
    
    FFilters.Add(PCatNode);
    FreeMem(deviceDetailData);
    Inc(result);
  end;
                                
  FGUID := CatGUID;
end;

function TSysObjEnum.GetCountFilters: integer;
begin
  result := FFilters.Count;
end;

function TSysObjEnum.GetFilter(Item: integer): TFilCatNode;
var
  PCategory: PFilCatNode;
begin
  PCategory := FFilters.Items[item];
  result := PCategory^;
end;

procedure TSysObjEnum.RemoveAll;
var
  Idx: integer;
begin
  for idx := 0 to (FFilters.Count - 1) do
    if Assigned(FFilters.Items[idx]) then Dispose(FFilters.Items[idx]);

  FFilters.Clear;
end;

procedure TSysObjEnum.SetIntfGUID(const CatGUID: TGUID);
begin
  RemoveAll();
  FGuid := CatGUID;
  GetCat(FFilters, CatGUID);
end;


function SetWDMBuffer(hDevice: THandle; BufferSize: DWORD): boolean;
var
  nResult: boolean;
  nBytes: DWORD;
  ioBlock: IO_BLOCK;
  ioRequest: IO_REQUEST;
begin
  ioRequest.uAddressL := 0;
  ioRequest.bAddressH := 0;
  ioRequest.uSize := BufferSize;
  ioRequest.bCommand := $80;	//start, write

  ioBlock.uOffset := 0;
  ioBlock.uLength := sizeof(IO_REQUEST);
  ioBlock.pbyData := @ioRequest;
  ioBlock.uIndex := SETUP_DMA_REQUEST;
			

  nResult := DeviceIoControl(hDevice,
    DWORD(IOCTL_WRITE_REGISTERS),
    @ioBlock,
    sizeof(IO_BLOCK),
    nil,
    0,
    nBytes,
    nil);

  ioRequest.uAddressL := 0;
  ioRequest.bAddressH := 0;
  ioRequest.uSize := BufferSize;
  ioRequest.bCommand := $81;	//start, read

  ioBlock.uOffset := 0;
  ioBlock.uLength := sizeof(IO_REQUEST);
  ioBlock.pbyData := @ioRequest;
  ioBlock.uIndex := SETUP_DMA_REQUEST;
			

  result := DeviceIoControl(hDevice,
    DWORD(IOCTL_WRITE_REGISTERS),
    @ioBlock,
    sizeof(IO_BLOCK),
    nil,
    0,
    nBytes,
    nil);

  result := result and nResult;
end;

end.
