unit uTrainNoAction;

interface
uses
  Windows,SysUtils ;

type

  //图定车次动作类
  TTrainNoAction = class
  public
    //图定车次表管理
    procedure ManagerTrainNo();
  end;


implementation

uses
  uFrmTrainNo ;

{ TTrainNoAction }


procedure TTrainNoAction.ManagerTrainNo;
begin
  TfrmTrainNo.ManageTrainNo;
end;

end.
