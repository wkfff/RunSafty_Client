unit uFrmProgressExEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, uTFRotationPicture, StdCtrls, RzPrgres, ExtCtrls, RzPanel;

type
  TFrmProgressExEx = class(TForm)
    RzPanel1: TRzPanel;
    ProgressBar: TRzProgressBar;
    LblText: TLabel;
    TFRotationPicture1: TTFRotationPicture;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBarCur: TRzProgressBar;
    procedure FormCreate(Sender: TObject);
  public
    class procedure DisplayProgess(Index,Count : integer);
    class procedure DisplayProgessCur(Index,Count : integer);
    class procedure CreateProgress();
    class procedure SetHint(TextHint : string);
    { Public declarations }
    class procedure ShowProgress(TextHint : string;Index,Count : integer;Delay: integer = 0);
    class procedure CloseProgress();
  end;

var
  FrmProgressExEx: TFrmProgressExEx;

implementation

{$R *.dfm}

class procedure TFrmProgressExEx.CloseProgress;
begin
   if FrmProgressExEx <> nil then
  begin
    FreeAndNil(FrmProgressExEx);
  end;
end;

class procedure TFrmProgressExEx.CreateProgress;
begin
  if FrmProgressExEx = nil then
  begin
    FrmProgressExEx := TFrmProgressExEx.Create(nil);
  end;
end;

class procedure TFrmProgressExEx.DisplayProgess(Index, Count: integer);
begin
  if FrmProgressExEx = nil then
    Exit ;
  FrmProgressExEx.ProgressBar.Percent := Round((Index * 100)/Count);
  FrmProgressExEx.Show;
  Application.ProcessMessages;
  //sleep(0);
end;

class procedure TFrmProgressExEx.DisplayProgessCur(Index, Count: integer);
begin
  if FrmProgressExEx = nil then
    Exit ;
  FrmProgressExEx.ProgressBarCur.Percent := Round((Index * 100)/Count);
  FrmProgressExEx.Show;
  Application.ProcessMessages;
  //sleep(0);
end;

procedure TFrmProgressExEx.FormCreate(Sender: TObject);
begin
  RzPanel1.DoubleBuffered := true;
end;

class procedure TFrmProgressExEx.SetHint(TextHint: string);
begin
  if FrmProgressExEx = nil then
    Exit ;
  FrmProgressExEx.LblText.Caption := TextHint;
end;

class procedure TFrmProgressExEx.ShowProgress(TextHint: string; Index, Count,
  Delay: integer);
begin
  if FrmProgressExEx = nil then
  begin
    FrmProgressExEx := TFrmProgressExEx.Create(nil);
  end;
  FrmProgressExEx.LblText.Caption := TextHint;
  FrmProgressExEx.ProgressBar.Percent := Round((Index * 100)/Count);
  FrmProgressExEx.Show;
  Application.ProcessMessages;
  sleep(Delay);
end;

end.
