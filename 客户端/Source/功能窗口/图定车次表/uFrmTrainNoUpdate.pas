unit uFrmTrainNoUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,ADODB,uGlobalDM, RzCmboBx;

type
  TfrmTrainNoUpdate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    edtTrainNo: TEdit;
    comboTrainJiaolu: TComboBox;
    btnConfirm: TButton;
    btnCancel: TButton;
    comboTrainmanType: TComboBox;
    ComboStartStation: TComboBox;
    ComboEndStation: TComboBox;
    Label5: TLabel;
    comboTrainType: TComboBox;
    Label6: TLabel;
    edtTrainNumber: TEdit;
    Label10: TLabel;
    ComboKehuo: TRzComboBox;
    Label7: TLabel;
    Label8: TLabel;
    dtpOutDutyTime: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    Label11: TLabel;
    dtpArriveTime: TDateTimePicker;
    Label12: TLabel;
    dtpCallTime: TDateTimePicker;
    checkNeedRest: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure WMMessageFormShow(var message : TMessage) ; message WM_Message_FormShow;
  public
    { Public declarations }
    TrainNoGUID : string;
  end;

var
  frmTrainNoUpdate: TfrmTrainNoUpdate;

implementation
uses
  uTrainNo,uDBTrainNo,uDBStation,uDBTrainmanType,uDBTrainType,uDBTrainJiaolu,
  uKeHuo,uDBKeHuo;
{$R *.dfm}

procedure TfrmTrainNoUpdate.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainNoUpdate.btnConfirmClick(Sender: TObject);
var
  trainno : RTrainNo;
begin
  trainno.strGUID := TrainNoGUID;
  trainno.strTrainNo := trim(edtTrainNo.Text);
  trainno.nKeHuoID := strtoInt(ComboKehuo.Value);
  trainno.strTrainJiaoluGUID := '';
  if (comboTrainJiaolu.ItemIndex < 0) then
  begin
    Application.MessageBox('请选择机车交路','提示',MB_OK + MB_ICONINFORMATION);
    comboTrainJiaolu.SetFocus;
    exit;
  end;

  trainno.strTrainJiaoluGUID := PString(comboTrainJiaolu.Items.Objects[comboTrainJiaolu.ItemIndex])^;
  trainno.strTrainTypeName := comboTrainType.Text;
  trainno.strTrainNumber := Trim(edtTrainNumber.Text);
  trainno.dtChuQinTime := dtpOutDutyTime.Time;
  trainno.dtStartTime := dtpStartTime.Time;
  trainno.dtArriveTime := dtpArriveTime.Time;
  trainno.dtCallTime := dtpCallTime.Time;
  trainno.nNeedRest := 0;
  if checkNeedRest.Checked then
    trainno.nNeedRest := 1;
  if comboTrainmanType.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择值乘类型','提示',MB_OK + MB_ICONINFORMATION);
    comboTrainmanType.SetFocus;
    exit;
  end;
  trainno.nTrainmanTypeID := StrToInt(PString(comboTrainmanType.Items.Objects[comboTrainmanType.ItemIndex])^);
  trainno.dtCreateTime := now;
  if ComboStartStation.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择出发站','提示',MB_OK + MB_ICONINFORMATION);
    ComboStartStation.SetFocus;
    exit;
  end;
  trainno.strStartStation := PString(ComboStartStation.Items.Objects[ComboStartStation.ItemIndex])^;
  if ComboEndStation.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择终到车站','提示',MB_OK + MB_ICONINFORMATION);
    ComboEndStation.SetFocus;
    exit;
  end;
  trainno.strEndStation := PString(ComboEndStation.Items.Objects[ComboEndStation.ItemIndex])^;
  try
    TDBTrainno.Update(GlobalDM.ADOConnection,trainno);
    ShowMessage('修改成功。');
    ModalResult := mrOk;
  except on e: exception do
    begin
      ShowMessage(Format('修改失败，错误信息:%s',[e.Message]));
    end;
  end;
end;

procedure TfrmTrainNoUpdate.FormDestroy(Sender: TObject);
begin
  GlobalDM.FreeComboValue(comboTrainJiaolu);
  GlobalDM.FreeComboValue(comboTrainmanType);
  GlobalDM.FreeComboValue(ComboStartStation);
  GlobalDM.FreeComboValue(ComboEndStation);
end;

procedure TfrmTrainNoUpdate.FormShow(Sender: TObject);
begin
  btnConfirm.Enabled := false;
  PostMessage(Handle,WM_Message_FormShow,0,0);
end;

procedure TfrmTrainNoUpdate.WMMessageFormShow(var message: TMessage);
var
  adoQuery : TADOQuery;
  strTemp : PString;
  trainNo : RTrainNo;
  kehuoArray : TKeHuoArray;
  i : integer;
begin
  if TrainNoGUID = '' then
  begin
    ShowMessage('错误的参数');
    exit;
  end;
  try
    trainNo.strGUID := TrainNoGUID;
    TDBTrainNo.GetTrainNo(GlobalDM.ADOConnection,trainNo);
  except on  e : exception do
    begin
      ShowMessage(e.Message);
      exit;
    end;
  end;
  try
  
    {$region '初始化起始终止车站信息'}
    try
      TDBStation.GetStations(GlobalDM.ADOConnection,adoQuery);
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
      ComboStartStation.ItemIndex := GlobalDM.FindComboValue(ComboStartStation,trainNo.strStartStation);

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
      ComboEndStation.ItemIndex := GlobalDM.FindComboValue(ComboEndStation,trainNo.strEndStation);
    finally
      adoQuery.Free;
    end;
    {$endregion '初始化起始终止车站信息'}

    {$region '初始化客货类型'}
    TDBKeHuo.GetKeHuos(GlobalDM.ADOConnection,kehuoArray);
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
      TDBTrainmanType.GetTrainmanTypes(GlobalDM.ADOConnection,adoQuery);
      comboTrainmanType.Items.Clear;
      while not adoQuery.Eof do
      begin
        New(strTemp);
        strTemp^ := adoQuery.FieldByName('nTrainmanTypeID').AsString;
        comboTrainmanType.Items.AddObject(adoQuery.FieldByName('strTrainmanTypeName').AsString,
          Pointer(strTemp));
        adoQuery.next;
      end;
      if comboTrainmanType.Items.Count > 0 then
        comboTrainmanType.ItemIndex := 0;
    finally
      adoQuery.Free;
    end;
    comboTrainmanType.ItemIndex := GlobalDM.FindComboValue(comboTrainmanType,IntToStr(trainNo.nTrainmanTypeID));
    {$endregion '初始化值乘类型'}

    {$region '初始化机车类型'}
    try
      TDBTrainType.GetTrainTypes(GlobalDM.ADOConnection,adoQuery);
      comboTrainType.Items.Clear;
      while not adoQuery.Eof do
      begin
        comboTrainType.Items.Add(adoQuery.FieldByName('strTrainTypeName').AsString);
        adoQuery.next;
      end;
    finally
      adoQuery.Free;
    end;
    comboTrainType.ItemIndex := comboTrainType.Items.IndexOf(trainNo.strTrainTypeName);
    {$endregion '初始化机车类型'}


    {$region '初始化机车交路'}
     try
      TDBTrainJiaolu.GetDBTrainJiaolu(GlobalDM.ADOConnection,adoQuery);
      comboTrainJiaolu.Items.Clear;
      while not adoQuery.Eof do
      begin
        New(strTemp);
        strTemp^ := adoQuery.FieldByName('strTrainJiaoluGUID').AsString;
        comboTrainJiaolu.Items.AddObject(adoQuery.FieldByName('strTrainJiaoluName').AsString,
          Pointer(strTemp));

        adoQuery.next;
      end;
      if comboTrainJiaolu.Items.Count > 0 then
        comboTrainJiaolu.ItemIndex := 0;
    finally
      adoQuery.Free;
    end;
    comboTrainJiaolu.ItemIndex := GlobalDM.FindComboValue(comboTrainJiaolu,(trainNo.strTrainJiaoluGUID));
    {$endregion '初始化机车交路'}

    edtTrainNo.Text := trainno.strTrainNo;
    ComboKehuo.ItemIndex := ComboKehuo.Values.IndexOf(IntToStr(trainNo.nKeHuoID));
    edtTrainNumber.Text := trainno.strTrainNumber;
    dtpOutDutyTime.Time := trainNo.dtChuQinTime;
    dtpStartTime.Time := trainno.dtStartTime;
    dtpArriveTime.Time := trainno.dtArriveTime;
    dtpCallTime.Time := trainNo.dtCallTime;
    checkNeedRest.Checked := trainNo.nNeedRest > 0;

    btnConfirm.Enabled := true;
  except on e : exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

end.
