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

  //根据API和消息操作控件的类
  TWinCtrlAPIController = class
    //根据窗口句柄获取标题
    class function GetFormCaption(FrmHandle:HWND):string;
    //根据窗口标题获取窗口句柄
    class function  GetFormHandle(FormTitle : string) : HWND; overload;
    //根据窗口标题获取窗口句柄 ,模糊匹配查找
    class function  GetFormHandleEx(FormTitle : string) : HWND; overload;


    //根据窗口的类名与标题获取窗口的句柄
    class function  GetFormHandle(FormClass:string;FormTitle : string) : HWND; overload;
    //获取指定句柄的子控件在指定父控件内的序号（位置）
    class function  GetChildControlIndex(ParentHandle: Hwnd;SourceHande:HWND):integer;
    //获取指定父控件内指定序号的子控件的句柄
    class function  GetChildControlHandle(ParentHandle: Hwnd;index : Integer):HWnd;
    //设置文本编辑框(TEdit)的文字
    class function  SetEditText(EditHandle:HWND; EditText:string) : bool;
    //获取文本编辑框(TEdit)的文字
    class function  GetEditText(EditHandle:HWND) : String;

    //设置下拉框（TComboBox）的当前选中文字-----根据文字换取索引
    class function  SetComboSelect(ComboHandle:HWND; SelectText:string):bool;
    //点击按钮
    class procedure ClickButton(ButtonHandle : HWND);

    //点击按钮
    class procedure ClickButtonWait(ButtonHandle : HWND);

    {功能:等待一个窗口启动}
    class function WaitWindowRun(nTimeOut : Integer;
        strWinCaption,strWinClassName : String):Integer;

    {功能:对句柄中某一个位置发送点击操作}
    class procedure ClickWindow(Window:HWND;x,y:Cardinal);
    {功能:等待一个窗口启动}
    class function WaitWindowRunEx(nTimeOut : Integer; strWinCaption:String):Integer;
    {功能:获得一个图片指定颜色的区域内容}
    class function GetPictureColorRect(Bitmap : TBitmap;Color:TColor):TPixelsArray;
    {功能:获得当前句柄的子句柄}
    class function GetChildHandle(ParentHandle:HWND;ChildOrders:TIntArray):HWND;

  end;


implementation

{ TWinCtrlAPIController }

class procedure TWinCtrlAPIController.ClickButton(ButtonHandle: HWND);
//点击按钮
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
  PostMessage(Window,messages.WM_LBUTTONDOWN,0,lParam); // 按下鼠标左键
  PostMessage(Window,messages.WM_LBUTTONUP,0,lParam);  //抬起鼠标左键
end;

class function TWinCtrlAPIController.GetChildControlHandle(ParentHandle: Hwnd;
  index: Integer): HWnd;
//获取指定父控件内指定序号的子控件的句柄
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
//获取指定句柄的子控件在指定父控件内的序号（位置）
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
//获取文本编辑框(TEdit)的文字
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
//根据窗口的类名与标题获取窗口的句柄
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
{功能:获得一个图片指定颜色的区域内容}
var
  i,j : integer;
  nTextRect : TRect;
  bFind : Boolean;
  tmpBitmap : TBitmap;
begin
  {获得开始Y坐标}
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

  {获得结束Y坐标}
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

  {获得开始X坐标}
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


  {获得结束X坐标}
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
//设置下拉框（TComboBox）的当前选中文字-----根据文字换取索引
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
//设置文本编辑框(TEdit)的文字
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
{功能:等待一个窗口启动}
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
