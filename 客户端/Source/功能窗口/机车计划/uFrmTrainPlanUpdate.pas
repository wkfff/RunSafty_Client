unit uFrmTrainPlanUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ADODB,uGlobalDM, RzCmboBx,uTrainman,uSaftyEnum;

type
  TfrmTrainPlanUpdate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtTrainNo: TEdit;
    comboTrainJiaolu: TComboBox;
    comboTrainmanType: TComboBox;
    ComboStartStation: TComboBox;
    ComboEndStation: TComboBox;
    comboTrainType: TComboBox;
    edtTrainNumber: TEdit;
    edtRealTrainNumber: TEdit;
    comboRealTrainType: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    dtpOutDutyTime: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    btnConfirm: TButton;
    btnCancel: TButton;
    Label13: TLabel;
    Label14: TLabel;
    dtpArriveTime: TDateTimePicker;
    dtpCallTime: TDateTimePicker;
    checkNeedRest: TCheckBox;
    ComboKehuo: TRzComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMMessageFormShow(var message : TMessage) ; message WM_Message_FormShow;
  public
    { Public declarations }
    TrainPlanGUID : string;
  end;

var
  frmTrainPlanUpdate: TfrmTrainPlanUpdate;

implementation
{$R *.dfm}
uses
  uTrainPlan,uDBTrainPlan,uDBStation,uDBTrainmanType,uDBTrainType,uDBTrainJiaolu,
  uKehuo,uDBKeHuo;
procedure TfrmTrainPlanUpdate.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainPlanUpdate.btnConfirmClick(Sender: TObject);
var
  trainPlan : RRsTrainPlan;
begin
  trainPlan.strTrainPlanGUID := TrainPlanGUID;
  trainPlan.strTrainNo := trim(edtTrainNo.Text);
  trainPlan.nKeHuoID := TRsKehuo(StrToInt(ComboKehuo.Value));
  trainPlan.strTrainJiaoluGUID := '';
  if comboTrainJiaolu.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择机车交路','提示',MB_OK + MB_ICONINFORMATION);
    comboTrainJiaolu.SetFocus;
    exit;
  end;
  
  if (dtpStartTime.DateTime <= dtpOutDutyTime.DateTime) then
    begin
      Application.MessageBox('开车时间不能小于出勤时间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
  if checkNeedRest.Checked then
  begin
    if (dtpCallTime.DateTime <= dtpArriveTime.DateTime) then
    begin
      Application.MessageBox('强休时间不能小于叫班时间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if (dtpOutDutyTime.DateTime <= dtpCallTime.DateTime) then
    begin
      Application.MessageBox('出勤时间不能小于叫班时间','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;    
  end;
  trainPlan.strTrainJiaoluGUID := PString(comboTrainJiaolu.Items.Objects[comboTrainJiaolu.ItemIndex])^;
  trainPlan.strTrainTypeName := comboTrainType.Text;
  trainPlan.strTrainNumber := Trim(edtTrainNumber.Text);

  
  if comboTrainmanType.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择值乘类型','提示',MB_OK + MB_ICONINFORMATION);
    comboTrainmanType.SetFocus;
    exit;
  end;
 // trainPlan.nTrainmanTypeID := StrToInt(PString(comboTrainmanType.Items.Objects[comboTrainmanType.ItemIndex])^);
  trainPlan.dtCreateTime := GlobalDM.GetNow;
  if ComboStartStation.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择出发站','提示',MB_OK + MB_ICONINFORMATION);
    ComboStartStation.SetFocus;
    exit;
  end;
  trainPlan.strStartStation := PString(ComboStartStation.Items.Objects[ComboStartStation.ItemIndex])^;
  if ComboEndStation.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择终到车站','提示',MB_OK + MB_ICONINFORMATION);
    ComboEndStation.SetFocus;
    exit;
  end;
  trainPlan.strEndStation := PString(ComboEndStation.Items.Objects[ComboEndStation.ItemIndex])^;
  try
   // TDBTrainPlan.Update(GlobalDM.ADOConnection,trainPlan);
    ShowMessage('修改成功。');
    ModalResult := mrOk;
  except on e: exception do
    begin
      ShowMessage(Format('修改失败，错误信息:%s',[e.Message]));
    end;
  end;

end;

procedure TfrmTrainPlanUpdate.FormDestroy(Sender: TObject);
begin
  GlobalDM.FreeComboValue(comboTrainJiaolu);
  GlobalDM.FreeComboValue(comboTrainmanType);
  GlobalDM.FreeComboValue(ComboStartStation);
  GlobalDM.FreeComboValue(ComboEndStation);
end;

procedure TfrmTrainPlanUpdate.FormShow(Sender: TObject);
begin
  btnConfirm.Enabled := false;
  PostMessage(Handle,WM_Message_FormShow,0,0);
end;

procedure TfrmTrainPlanUpdate.WMMessageFormShow(var message: TMessage);
var
  adoQuery : TADOQuery;
  strTemp : PString;
  trainPlan : RRsTrainPlan;
  i : integer;
  kehuoArray : TRsKeHuoArray;
begin
  if TrainPlanGUID = '' then
  begin
    ShowMessage('错误的参数');
    exit;
  end;
  try
    trainPlan.strTrainPlanGUID := TrainPlanGUID;
    //TDBTrainPlan.GetPlan(trainPlan);
  except on  e : exception do
    begin
      ShowMessage(e.Message);
      exit;
    end;
  end;
  try
    {$region '初始化起始终止车站信息'}
    try
      TRsDBStation.GetStations(GlobalDM.ADOConnection,adoQuery);
      ComboStartStation.Items.Clear;
      adoQuery.First;
      while not adoQuery.Eof do
      begin
       New(strTemp);
        strTemp^ := adoQuery.FieldByName('strStationGUID').AsString;
        ComboStartStation.Items.AddObject(adoQuery.FieldByName('strStationName').AsString,
          Pointer(strTemp));
        adoQuery.Next;
      end;
      ComboStartStation.ItemIndex := GlobalDM.FindComboValue(ComboStartStation,trainPlan.strStartStation);

      ComboEndStation.Items.Clear;
      adoQuery.First;
      while not adoQuery.Eof do
      begin
        New(strTemp);
        strTemp^ := adoQuery.FieldByName('strStationGUID').AsString;
        ComboEndStation.Items.AddObject(adoQuery.FieldByName('strStationName').AsString,
          Pointer(strTemp));
        adoQuery.Next;
      end;
      ComboEndStation.ItemIndex := GlobalDM.FindComboValue(ComboEndStation,trainPlan.strEndStation);
    finally
      adoQuery.Free;
    end;
    {$endregion '初始化起始终止车站信息'}

    {$region '初始化客货类型'}
    TRsDBKeHuo.GetKeHuos(GlobalDM.ADOConnection,kehuoArray);
    ComboKehuo.Items.Clear;
    ComboKehuo.Values.Clear;
    for i := 0 to length(kehuoArray) - 1 do
    begin
      ComboKehuo.AddItemValue(kehuoArray[i].strKeHuoName,IntToStr(kehuoArray[i].nKehuoID));
    end;
    if ComboKehuo.Items.Count > 0 then
      ComboKehuo.ItemIndex := 0;
    {$endregion '初始化客货类型'}
    
    {$region '初始化值乘类型'}
    try
      TRsDBTrainmanType.GetTrainmanTypes(GlobalDM.ADOConnection,adoQuery);
      comboTrainmanType.Items.Clear;
      while not adoQuery.Eof do
      begin
        New(strTemp);
        strTemp^ := adoQuery.FieldByName('nTrainmanTypeID').AsString;
        comboTrainmanType.Items.AddObject(adoQuery.FieldByName('strTrainmanTypeName').AsString,
          Pointer(strTemp));
        adoQuery.next;
      end;
    finally
      adoQuery.Free;
    end;
   // comboTrainmanType.ItemIndex := GlobalDM.FindComboValue(comboTrainmanType,IntToStr(trainPlan.nTrainmanTypeID));
    {$endregion '初始化值乘类型'}

    {$region '初始化机车类型'}
    try
      TRsDBTrainType.GetTrainTypes(GlobalDM.ADOConnection,adoQuery);
      comboTrainType.Items.Clear;
      while not adoQuery.Eof do
      begin
        comboTrainType.Items.Add(adoQuery.FieldByName('strTrainTypeName').AsString);
        adoQuery.next;
      end;
    finally
      adoQuery.Free;
    end;
    comboTrainType.ItemIndex := comboTrainType.Items.IndexOf(trainPlan.strTrainTypeName);

    try
      TRsDBTrainType.GetTrainTypes(GlobalDM.ADOConnection,adoQuery);
      comboRealTrainType.Items.Clear;
      while not adoQuery.Eof do
      begin
        comboRealTrainType.Items.Add(adoQuery.FieldByName('strTrainTypeName').AsString);
        adoQuery.next;
      end;
    finally
      adoQuery.Free;
    end;
   // comboRealTrainType.ItemIndex := comboRealTrainType.Items.IndexOf(trainPlan.strRealTrainTypeName);
    {$endregion '初始化机车类型'}


    {$region '初始化机车交路'}
     try
      TRsDBTrainJiaolu.GetDBTrainJiaolu(GlobalDM.ADOConnection,adoQuery);
      comboTrainJiaolu.Items.Clear;
      while not adoQuery.Eof do
      begin
        New(strTemp);
        strTemp^ := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        comboTrainJiaolu.Items.AddObject(adoQuery.FieldByName('strTrainJiaoluName').AsString,
          Pointer(strTemp));

        adoQuery.next;
      end;
    finally
      adoQuery.Free;
    end;
    comboTrainJiaolu.ItemIndex := GlobalDM.FindComboValue(comboTrainJiaolu,(trainPlan.strTrainJiaoluGUID));
    {$endregion '初始化机车交路'}

    edtTrainNo.Text := trainPlan.strTrainNo;
    //ComboKehuo.ItemIndex := ComboKehuo.Values.IndexOf(IntToStr(trainPlan.nKeHuoID));
    edtTrainNumber.Text := trainPlan.strTrainNumber;
   
    btnConfirm.Enabled := true;
  except on e : exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

end.
