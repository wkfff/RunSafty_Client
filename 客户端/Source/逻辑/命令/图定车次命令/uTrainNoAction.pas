unit uTrainNoAction;

interface
uses
  Windows,SysUtils ;

type

  //ͼ�����ζ�����
  TTrainNoAction = class
  public
    //ͼ�����α����
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
