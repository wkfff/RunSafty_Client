unit uTestFTPUDPThread;
interface

uses
  Classes,ComCtrls,SysUtils,ACTIVEX,StrUtils,Windows,uGlobalDM,uCallRoomDM,uLogs;

type
////////////////////////////////////////////////////////////////////////////////
// ������TTestFTPUDPThread
// ���ܣ����ڼ��UDP��FTP�����Ƿ�������ÿ��30����һ�Σ�
////////////////////////////////////////////////////////////////////////////////
  TTestFTPUDPThread = class(TThread)
  public
    constructor Create;overload;
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
  
  end;
var
  TestFTPUDPThread: TTestFTPUDPThread;

implementation


function MakeFileList(Path,FileExt:string):TStringList ;
var
sch:TSearchrec;
begin
  Result:=TStringlist.Create;
  if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
  else
  Path := trim(Path);
  if not DirectoryExists(Path) then
  begin
    Result.Clear;
    exit;
  end;
  if FindFirst(Path + '*', faAnyfile, sch) = 0 then
  begin
    repeat
       if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
       if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt)) or (FileExt='.*') then
       Result.Add(sch.Name);
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

constructor TTestFTPUDPThread.Create;
begin
  inherited Create(False);
  //FreeOnTerminate := True;
end;

procedure TTestFTPUDPThread.Execute;
var
  filelist: TStringList;
  i: Integer;
  WaitTerminate: Integer;
  WaitUDP: Integer;
begin
  CoInitialize(nil);
  WaitTerminate := 60;
  WaitUDP := 0;
  while not Terminated do
  begin
    try
      if WaitTerminate < 60 then
      begin
        Sleep(500);
        Inc(WaitTerminate);
        Continue;
      end;
      WaitTerminate := 0;

      if not DMCallRoom.bCallModel then
      begin
        DMCallRoom.bCanUDPLogs := DMCallRoom.bUDPConnect;
        DMCallRoom.bUDPConnect := False;
        DMCallRoom.UDPControl.SendCommand('*CSKS#');
        while WaitUDP < 10 do
        begin
          if terminated then Break;
          Sleep(500);
          Inc(WaitUDP);
        end;
        WaitUDP := 0;
      
        if DMCallRoom.bCanUDPLogs <> DMCallRoom.bUDPConnect then
        begin
          PostMessage(frmMain_RoomSign.Handle,WM_MSGTestUDPEnd,0,0);
        end;
      end;

      DMCallRoom.bCanFTPLogs := DMCallRoom.bFTPConnect;
      //FTP��������ʱ�Զ����ȴ��ϴ����ļ��ϴ���FTP
      if DMCallRoom.FTPCon.TestConnect then
      begin
        DMCallRoom.bFTPConnect := True;
        filelist := MakeFileList(GlobalDM.AppPath + '\upload\picture','.*');
        if filelist.Count > 0 then
        begin
          for I := 0 to filelist.Count - 1 do
          begin
            try
              DMCallRoom.FTPCon.UpLoad(filelist[i],True);
            except

            end;
          end;
        end;
        filelist.Free;
        filelist := MakeFileList(GlobalDM.AppPath + '\upload\callrecord','.*');
        if filelist.Count > 0 then
        begin
          for I := 0 to filelist.Count - 1 do
          begin
            try
              DMCallRoom.FTPCon.UpLoad(filelist[i],False);
            except

            end;
          end;
        end;
        filelist.Free;
      end
      else
      begin
        DMCallRoom.bFTPConnect := False;
      end;
      if DMCallRoom.bCanFTPLogs <> DMCallRoom.bFTPConnect then
      begin
        PostMessage(frmMain_RoomSign.Handle,WM_MSGTestFTPEnd,0,0);
      end;
    except
      on e : Exception do
      begin
        TLog.SaveLog(Now,'UDP��FTP����߳�������ֹ:' + e.Message);
        WaitTerminate := 0;
        WaitUDP := 0;
        Continue;
      end;
    end;
  end;
  CoUninitialize;
end;
end.
