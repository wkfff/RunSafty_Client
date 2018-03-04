program Project1;

uses
  Forms,
  Unit1 in 'D:\Documents and Settings\Administrator\桌面\新建文件夹 (2)\Unit1.pas' {Form1},
  uAudio in 'uAudio.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
