unit uFrmFindJDPlanFromList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uLCJDPlan, ComCtrls, StdCtrls;

type
  TfrmFindJDPlanFromList = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ListView1: TListView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
    JDPlanList : TJDPlanList;
    procedure ClickOK;
    procedure Init;
  public
    SelectedTrainID : string;
    { Public declarations }
    class function ShowDialog(JDPlanList : TJDPlanList; out TrainID : string) : boolean;
  end;



implementation

{$R *.dfm}

{ TfrmFindJDPlanFromList }

procedure TfrmFindJDPlanFromList.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFindJDPlanFromList.btnOKClick(Sender: TObject);
begin
  ClickOK;
end;

procedure TfrmFindJDPlanFromList.ClickOK;
begin
  if ListView1.Selected = nil then
  begin
    application.MessageBox('请选择一条计划','提示',MB_OK+MB_ICONINFORMATION);
    exit;
  end;
  SelectedTrainID := JDPlanList.Items[listview1.Selected.Index].Train_id;
  ModalResult := mrOk;
end;

procedure TfrmFindJDPlanFromList.Init;
var
  i: Integer;
  item : TListItem;
begin
  listview1.Items.Clear;
  for i := 0 to JDPlanList.Count - 1 do
  begin
    item := ListView1.Items.Add;
    item.Caption := JDPlanList.Items[i].Section_id;
    item.SubItems.Add(JDPlanList.Items[i].Train_code);
    item.SubItems.Add(Formatdatetime('yyyy-MM-dd HH:nn:ss',JDPlanList.Items[i].Time_deptart));
    item.SubItems.Add(Formatdatetime('yyyy-MM-dd HH:nn:ss',JDPlanList.Items[i].Time_arrived));
    item.SubItems.Add(JDPlanList.Items[i].Station_deptart);
    item.SubItems.Add(JDPlanList.Items[i].Station_arrived);
  end;
end;

procedure TfrmFindJDPlanFromList.ListView1DblClick(Sender: TObject);
begin
  ClickOK;
end;

class function TfrmFindJDPlanFromList.ShowDialog(JDPlanList: TJDPlanList;
  out TrainID: string): boolean;
var
  frmFindJDPlanFromList : TfrmFindJDPlanFromList;
begin
  result := false;
  TrainID := '';
  frmFindJDPlanFromList := TfrmFindJDPlanFromList.Create(nil);
  try
    frmFindJDPlanFromList.JDPlanList := JDPlanList;
    frmFindJDPlanFromList.Init;
    if frmFindJDPlanFromList.ShowModal = mrCancel then exit;
    TrainID := frmFindJDPlanFromList.SelectedTrainID;
    result := true;
  finally
    frmFindJDPlanFromList.Free;
  end;
end;

end.
