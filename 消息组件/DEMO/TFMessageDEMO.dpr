program TFMessageDEMO;

uses
  Forms,
  ufrmMain in 'ufrmMain.pas' {frmMain},
  uTFMessageComponent in '..\Source\uTFMessageComponent.pas',
  superobject in '..\Source\JSON\superobject.pas',
  superxmlparser in '..\Source\JSON\superxmlparser.pas',
  uTFMessageDefine in '..\Source\uTFMessageDefine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
