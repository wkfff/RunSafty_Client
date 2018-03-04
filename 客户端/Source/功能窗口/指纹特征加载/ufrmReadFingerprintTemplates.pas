unit ufrmReadFingerprintTemplates;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzPrgres, ExtCtrls, RzPanel, pngimage,uTFSystem;

type
  TFrmFinerLoadProgress = class(TForm)
    RzPanel1: TRzPanel;
    Label1: TLabel;
    ProgressBar: TRzProgressBar;
    Image1: TImage;
  private
    { Private declarations }
    procedure StepProgress(nMax,nPosition: integer);
  public
    { Public declarations }
    class function ShowProgress(): TOnReadChangeEvent;
    class procedure CloseProgress();
  end;

implementation

var
  FrmFinerLoadProgress: TFrmFinerLoadProgress = nil;
{$R *.dfm}



{ TfrmReadFingerprintTemplates }

class procedure TFrmFinerLoadProgress.CloseProgress;
begin
  if Assigned(FrmFinerLoadProgress) then
  begin
    FreeAndNil(FrmFinerLoadProgress);
  end;
end;

class function TFrmFinerLoadProgress.ShowProgress: TOnReadChangeEvent;
begin
  if not Assigned(FrmFinerLoadProgress) then
  begin
    FrmFinerLoadProgress := TFrmFinerLoadProgress.Create(Application);
    FrmFinerLoadProgress.Show;
    FrmFinerLoadProgress.Update();
  end;
  Result := FrmFinerLoadProgress.StepProgress;
end;

procedure TFrmFinerLoadProgress.StepProgress(nMax, nPosition: integer);
begin
  ProgressBar.TotalParts := nMax;
  ProgressBar.PartsComplete := nPosition;
end;

end.
