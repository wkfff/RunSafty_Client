unit uFrmOuterTrainman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,uSaftyEnum,
  Dialogs, Buttons, PngCustomButton, StdCtrls,uTFSystem, RzCmboBx,uTrainman,
  uJWD,StrUtils,uLCTrainmanMgr,uLCBaseDict;

type
  TFrmOuterSideTrainman = class(TForm)
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    btnSave: TPngCustomButton;
    btnCancel: TPngCustomButton;
    cmbJWD: TRzComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure InitData(TrainmanNumber:string);
    //获取结果
    procedure GetResult();
      //检查是否满足输入条件
    function CheckInput():Boolean;
    //创建人员
    function CreateTrainman(): Boolean;
  private
    //机务段ID
    m_strJwdCode : string ;
    //人员名字
    m_strTrainmanName : string ;


    //人员接口
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
  public
    { Public declarations }
    class function CreateOuterSideTrainman(const TrainmanNumber:string;
    var TrainmanName:string;var JwdCode:string):Boolean;
  end;

var
  FrmOuterSideTrainman: TFrmOuterSideTrainman;

implementation

uses
  uGlobalDM,utfPopBox ;

{$R *.dfm}

procedure TFrmOuterSideTrainman.btnOkClick(Sender: TObject);
begin
  if not CheckInput then
    Exit ;
  GetResult ;
  if not CreateTrainman() then Exit;
  ModalResult := mrOk ;
end;

procedure TFrmOuterSideTrainman.btnCancelClick(Sender: TObject);
begin
  if TBox('是否取消创建人员') then
    ModalResult := mrCancel
  else
    ;
end;

function TFrmOuterSideTrainman.CheckInput: Boolean;
begin
  Result := False ;
  if Trim(edtTrainmanNumber.Text) = '' then
  begin
    edtTrainmanNumber.SetFocus ;
    BoxErr('工号不能为空!');
    Exit ;
  end;

  if Length(Trim(edtTrainmanNumber.Text)) <> 7 then
  begin
    edtTrainmanNumber.SetFocus;
    BoxErr('工号长度必须是7位!');
    Exit ;
  end;

  if Trim(edtTrainmanName.Text) = '' then
  begin
    edtTrainmanName.SetFocus ;
    BoxErr('名字不能为空!');
    Exit;
  end;

  Result := True ;
end;

class function TFrmOuterSideTrainman.CreateOuterSideTrainman(
  const TrainmanNumber: string; var TrainmanName: string;
  var JwdCode: string): Boolean;
var
  frm : TFrmOuterSideTrainman ;
begin
  Result := False ;
  frm := TFrmOuterSideTrainman.Create(nil);
  try
    frm.InitData(TrainmanNumber);
    if frm.ShowModal = mrOk then
    begin
      TrainmanName := frm.m_strTrainmanName ;
      JwdCode := frm.m_strJwdCode ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

function TFrmOuterSideTrainman.CreateTrainman: Boolean;
var
  Trainman:RRsTrainman ;
  strNumber: string ;
begin
  Result := False;
  strNumber := Trim(edtTrainmanNumber.Text);
  with Trainman do
  begin
    strTrainmanGUID := NewGUID ;
    strTrainmanNumber := strNumber ;
    strTrainmanName := Trim(edtTrainmanName.Text) ;
    nPostID := ptNone ;
    bIsKey := 0 ;
    nKeHuoID :=  khNone ;
    nDriverLevel := 1 ;
    nDriverType :=  drtNone ;
    nTrainmanState := tsNormal ;
    strJP := GlobalDM.GetHzPy(Trim(strTrainmanName));
    strAreaGUID := cmbJWD.Value ;  //机务段号码
  end;
  if m_RsLCTrainmanMgr.ExistNumber('',strNumber) then
  begin
    BoxErr('该工号已存在,请更换一个工号');
    Exit ;
  end;
  m_RsLCTrainmanMgr.AddTrainman(Trainman);
  TtfPopBox.ShowBox('创建人员成功');
  Result := True;
end;

procedure TFrmOuterSideTrainman.FormCreate(Sender: TObject);
var
  JWDArray:TRsJWDArray;
  i: Integer;
  ErrInfo: string;
begin
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);



  //初始化车间信息
  if RsLCBaseDict.LCJwd.GetAllJwdList(JWDArray,ErrInfo) then
  begin
    cmbJWD.ClearItems;
    for i := 0 to length(JWDArray) - 1 do
    begin
      cmbJWD.AddItemValue(JWDArray[i].strName,JWDArray[i].strUserCode);
    end;
    cmbJWD.ItemIndex := 0;
  end
  else
  begin
    box(ErrInfo)
  end;

end;

procedure TFrmOuterSideTrainman.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free ; 
end;

procedure TFrmOuterSideTrainman.GetResult;
begin
  m_strJwdCode :=  cmbJWD.Value ;
  m_strTrainmanName :=  Trim(edtTrainmanName.Text);
end;

procedure TFrmOuterSideTrainman.InitData(TrainmanNumber: string);
var
  i : Integer ;
  strJwd : string ;
begin
  edtTrainmanNumber.Text := TrainmanNumber ;
  strJwd :=  LeftStr(TrainmanNumber,2) ;
  for I := 0 to cmbJWD.Items.Count - 1 do
  begin
    if cmbJWD.Values[i] =  strJwd  then
    begin
      cmbJWD.ItemIndex := i ;
      Break ;
    end;
  end;  
    
end;

end.
