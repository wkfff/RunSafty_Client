unit uWinCtrlAPIController;

interface
uses Windows,Messages,SysUtils,Graphics,Classes,uTFSystem;
type

  RPixels = Record
    x : Integer;
    y : Integer;
    Color : TColor;
  end;

  TPixelsArray = array of RPixels;

  //����API����Ϣ�����ؼ�����
  TWinCtrlAPIController = class
    //���ݴ��ھ����ȡ����
    class function GetFormCaption(FrmHandle:HWND):string;
    //���ݴ��ڱ����ȡ���ھ��
    class function  GetFormHandle(FormTitle : string) : HWND; overload;
    //���ݴ��ڱ����ȡ���ھ�� ,ģ��ƥ�����
    class function  GetFormHandleEx(FormTitle : string) : HWND; overload;


    //���ݴ��ڵ�����������ȡ���ڵľ��
    class function  GetFormHandle(FormClass:string;FormTitle : string) : HWND; overload;
    //��ȡָ��������ӿؼ���ָ�����ؼ��ڵ���ţ�λ�ã�
    class function  GetChildControlIndex(ParentHandle: Hwnd;SourceHande:HWND):integer;
    //��ȡָ�����ؼ���ָ����ŵ��ӿؼ��ľ��
    class function  GetChildControlHandle(ParentHandle: Hwnd;index : Integer):HWnd;
    //�����ı��༭��(TEdit)������
    class function  SetEditText(EditHandle:HWND; EditText:string) : bool;
    //��ȡ�ı��༭��(TEdit)������
    class function  GetEditText(EditHandle:HWND) : String;

    //����������TComboBox���ĵ�ǰѡ������-----�������ֻ�ȡ����
    class function  SetComboSelect(ComboHandle:HWND; SelectText:string):bool;
    //�����ť
    class procedure ClickButton(ButtonHandle : HWND);

    //�����ť
    class procedure ClickButtonWait(ButtonHandle : HWND);

    {����:�ȴ�һ����������}
    class function WaitWindowRun(nTimeOut : Integer;
        strWinCaption,strWinClassName : String):Integer;

    {����:�Ծ����ĳһ��λ�÷��͵������}
    class procedure ClickWindow(Window:HWND;x,y:Cardinal);
    {����:�ȴ�һ����������}
    class function WaitWindowRunEx(nTimeOut : Integer; strWinCaption:String):Integer;
    {����:���һ��ͼƬָ����ɫ����������}
    class function GetPictureColorRect(Bitmap : TBitmap;Color:TColor):TPixelsArray;
    {����:��õ�ǰ������Ӿ��}
    class function GetChildHandle(ParentHandle:HWND;ChildOrders:TIntArray):HWND;

  end;


implementation

{ TWinCtrlAPIController }

class procedure TWinCtrlAPIController.ClickButton(ButtonHandle: HWND);
//�����ť
begin
  PostMessage(ButtonHandle,WM_LBUTTONDOWN,0,0);

  PostMessage(ButtonHandle,WM_LBUTTONUP,0,0);
  Sleep(10);
  PostMessage(ButtonHandle,WM_LBUTTONDOWN,0,0);

  PostMessage(ButtonHandle,WM_LBUTTONUP,0,0);
end;

class procedure TWinCtrlAPIController.ClickButtonWait(ButtonHandle: HWND);
var
  TickCount : Cardinal;
begin
  TickCount := GetTickCount;
  while ((SendMessage(ButtonHandle,WM_LBUTTONDOWN,0,0) <> 0) and ((GetTickCount - TickCount) < 1000) ) do
  ;
  TickCount := GetTickCount;
  while ((SendMessage(ButtonHandle,WM_LBUTTONUP,0,0) <> 0) and ((GetTickCount - TickCount) < 1000) ) do
  ;
end;

class procedure TWinCtrlAPIController.ClickWindow(Window: HWND; x, y: Cardinal);
var
  lParam:Cardinal;
begin
  lParam:=(y shl 16) or x;
  PostMessage(Window,messages.WM_LBUTTONDOWN,0,lParam); // ����������
  PostMessage(Window,messages.WM_LBUTTONUP,0,lParam);  //̧��������
end;

class function TWinCtrlAPIController.GetChildControlHandle(ParentHandle: Hwnd;
  index: Integer): HWnd;
//��ȡָ�����ؼ���ָ����ŵ��ӿؼ��ľ��
var
  hand,nextHand : HWnd;
  i : integer;
begin
  hand := GetTopWindow(ParentHandle);
  if (index = 0) then
  begin
    result := hand;
    exit;
  end;

  i := 1;
  nextHand := GetNextWindow(hand,GW_HWNDNEXT);
  while i < index do
  begin
    hand := nextHand;
    nextHand := GetNextWindow(hand,GW_HWNDNEXT);
    i := i + 1;
  end;
  result := nextHand;
end;

class function TWinCtrlAPIController.GetChildControlIndex(ParentHandle,
  SourceHande: HWND): integer;
//��ȡָ��������ӿؼ���ָ�����ؼ��ڵ���ţ�λ�ã�
var
  hand,nextHand : HWnd;
  i : integer;
begin
  result := -1;
  hand := GetTopWindow(ParentHandle);
  if (hand = 0) then exit;
  if (hand = SourceHande) then
  begin
    result := 0;
    exit;
  end;
  i := 1;
  nextHand := GetNextWindow(hand,GW_HWNDNEXT);
  while nextHand > 0 do
  begin
    if (nextHand = SourceHande) then
    begin
      result := i;
      exit;
    end;
    hand := nextHand;
    nextHand := GetNextWindow(hand,GW_HWNDNEXT);
    i := i + 1;
  end;
end;

class function TWinCtrlAPIController.GetChildHandle(ParentHandle: HWND;
  ChildOrders: TIntArray): HWND;
var
  i : Integer;
begin
  Result := ParentHandle;
  for I := 0 to length(ChildOrders) - 1 do
  begin
    Result :=
        TWinCtrlAPIController.GetChildControlHandle(Result,ChildOrders[i]);
  end;
end;

class function TWinCtrlAPIController.GetEditText(EditHandle: HWND): String;
//��ȡ�ı��༭��(TEdit)������
var
  Chars : Array [0..MAXCHAR] of char;
  strResult :AnsiString;
begin
  SendMessage(EditHandle,WM_GETTEXT,MAXCHAR,Longint(@Chars));
  strResult := Chars;
  Result :=  strResult;
end;

class function TWinCtrlAPIController.GetFormCaption(FrmHandle: HWND): string;
var
  TempStr:array [0..20] of Char;
begin
  GetWindowText(FrmHandle,TempStr,Length(TempStr));
  Result := Trim(TempStr);
end;

class function TWinCtrlAPIController.GetFormHandle(FormClass,
  FormTitle: string): HWND;
//���ݴ��ڵ�����������ȡ���ڵľ��
begin
  result := FindWindow(PChar(FormClass),PChar(FormTitle));
end;

class function TWinCtrlAPIController.GetFormHandleEx(FormTitle: string): HWND;
var
  HWNDArray : THWNDArray;
  i : Integer;
  AppName: array[0..255] of Char;
begin
  result := 0;
  HWNDArray := GetSystemAllHWND();
  for I := 0 to length(HWNDArray) - 1 do
  begin
    GetWindowText(HWNDArray[i],AppName, 255);
    if Pos(FormTitle,AppName) > 0 then
    begin
      Result := HWNDArray[i];
      Break;
    end;
  end;
end;

class function TWinCtrlAPIController.GetPictureColorRect(Bitmap: TBitmap;
  Color: TColor): TPixelsArray;
{����:���һ��ͼƬָ����ɫ����������}
var
  i,j : integer;
  nTextRect : TRect;
  bFind : Boolean;
  tmpBitmap : TBitmap;
begin
  {��ÿ�ʼY����}
  for I := 0 to Bitmap.Height - 1 do
  begin
    bFind := False;
    for j := 0 to Bitmap.Width - 1 do
    begin
      if Bitmap.Canvas.Pixels[j,i] =  Color then
      begin
        bFind := True;
        nTextRect.Top := i;
        Break;
      end;
    end;
    if bFind then Break;
  end;

  {��ý���Y����}
  for I := 0 to Bitmap.Height - 1 do
  begin
    bFind := False;
    for j := 0 to Bitmap.Width - 1 do
    begin
      if Bitmap.Canvas.Pixels[j,Bitmap.Height-i-1] =  Color then
      begin
        bFind := True;
        nTextRect.Bottom := Bitmap.Height-i-1;
        Break;
      end;
    end;
    if bFind then Break;    
  end;

  {��ÿ�ʼX����}
  for I := 0 to Bitmap.Width - 1 do
  begin
    bFind := False;
    for j := 0 to Bitmap.Height - 1 do
    begin
      if Bitmap.Canvas.Pixels[i,j] =  Color then
      begin
        bFind := True;
        nTextRect.Left := i;
        Break;
      end;
    end;
    if bFind then Break;
  end;


  {��ý���X����}
  for I := 0 to Bitmap.Width - 1 do
  begin
    bFind := False;
    for j := 0 to Bitmap.Height - 1 do
    begin
      if Bitmap.Canvas.Pixels[Bitmap.Width-i-1,j] =  Color then
      begin
        bFind := True;
        nTextRect.Right := Bitmap.Width-i-1;
        Break;        
      end;
    end;
    if bFind then Break;
  end;

  nTextRect.Left := nTextRect.Left ;
  nTextRect.Right := nTextRect.Right + 1;

  nTextRect.Top := nTextRect.Top ;
  nTextRect.Bottom := nTextRect.Bottom + 1;

  tmpBitmap := TBitmap.Create;
  tmpBitmap.Width := nTextRect.Right - nTextRect.Left;
  tmpBitmap.Height := nTextRect.Bottom - nTextRect.Top;

  tmpBitmap.Canvas.CopyRect(
      Rect(0,0,tmpBitmap.Width,tmpBitmap.Height),Bitmap.Canvas,nTextRect);

  SetLengTh(Result,0);
  for I := 0 to tmpBitmap.Width - 1 do
  begin
    for j := 0 to tmpBitmap.Height - 1 do
    begin
      if tmpBitmap.Canvas.Pixels[i,j] = Color then
      begin
        SetLengTh(Result,length(Result)+1);
        Result[length(Result)-1].x := i;
        Result[length(Result)-1].y := j;
        Result[length(Result)-1].Color := Color;
      end;
    end;
  end;
  tmpBitmap.Free;
end;

class function TWinCtrlAPIController.GetFormHandle(FormTitle: string): HWND;
begin
  result := FindWindow(nil,PChar(FormTitle));
end;

class function TWinCtrlAPIController.SetComboSelect(ComboHandle: HWND;
  SelectText: string): bool;
//����������TComboBox���ĵ�ǰѡ������-----�������ֻ�ȡ����
var
  rlt : Integer;
  msg : TMessage;
begin
  result := false;
  rlt := SendMessage(ComboHandle,CB_SELECTSTRING,0,Integer(PChar(SelectText)));
  if (rlt <> CB_ERR) then
  begin
    twmcommand(msg).NotifyCode := 0001;
    twmcommand(msg).ItemID := 100;
    twmcommand(msg).Ctl := ComboHandle;
    PostMessage(ComboHandle,WM_COMMAND ,msg.WParam,msg.LParam);
    result := true;
  end;
end;

class function TWinCtrlAPIController.SetEditText(EditHandle: HWND;
  EditText: string): bool;
//�����ı��༭��(TEdit)������
var
  msg : TMessage;
  rlt : Integer;
begin
  TWMSetText(msg).Text := PChar(EditText);
  rlt := SendMessage(EditHandle,WM_SETTEXT,0,msg.LParam);
  result := false;
  if (rlt > 0) then
    result := true;
end;


class function TWinCtrlAPIController.WaitWindowRunEx(nTimeOut: Integer;
  strWinCaption:String): Integer;
var
  nCountTicket : int64;
begin
  nCountTicket := GetTickCount();
  Result := 0;
  while (Result = 0) and ((GetTickCount - nCountTicket) < nTimeOut) do
  begin
    Sleep(100);
    Result := TWinCtrlAPIController.GetFormHandleEx(strWinCaption)
  end;
end;

class function TWinCtrlAPIController.WaitWindowRun(nTimeOut: Integer;
  strWinCaption, strWinClassName: String): Integer;
{����:�ȴ�һ����������}
var
  nCountTicket : int64;
begin

  nCountTicket := GetTickCount();
  Result := 0;

  while (Result = 0) and ((GetTickCount - nCountTicket) < nTimeOut) do
  begin
    Sleep(100);
    if strWinClassName = '' then
      Result := TWinCtrlAPIController.GetFormHandle(strWinCaption)
    else
      Result := TWinCtrlAPIController.GetFormHandle(strWinClassName,strWinCaption);
  end;

end;

end.
