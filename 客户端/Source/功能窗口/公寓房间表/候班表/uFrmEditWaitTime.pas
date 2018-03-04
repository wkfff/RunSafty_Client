unit uFrmEditWaitTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit,uWaitWork,uTFSystem,uWaitWorkMgr,uDBWorkShop,
  uDBTrainJiaolu,uWorkShop,uTrainJiaolu,uGlobalDM;

type
  TFrmEditWaitTime = class(TForm)
    lbl3: TLabel;
    edtCheci: TEdit;
    lbl8: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    edtHouBan: TRzDateTimeEdit;
    edtJiaoBan: TRzDateTimeEdit;
    edtChuQin: TRzDateTimeEdit;
    edtKaiche: TRzDateTimeEdit;
    btnOK: TButton;
    btnCancel: TButton;
    lbl2: TLabel;
    edtRoomNum: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    {功能:校验数据}
    function CheckData():Boolean;
    {功能:赋值数据}
    procedure UI2Obj();
    {功能 :显示数据}
    procedure obj2UI();


  private
    //候班时刻表
    m_WaitTime:RWaitTime;
    //车间数据库操作
    m_DBWorkShop:TRsDBWorkShop;
    //交路数据库操作
    m_DBTrainJiaoLu:TRsDBTrainJiaolu;
    //车间数组
    m_WorkShopAry:TRsWorkShopArray;
    //交路数组
    m_JiaoLuAry:TRsTrainJiaoluArray;

  public
    {功能:修改候班表}
    class function ModifyWaitTable(var WaitTime:RWaitTime):Boolean;
    {功能:增加候班表}
    class function AddWaitTable(out WaitTime:RWaitTime):Boolean;
  end;

implementation

{$R *.dfm}

{ TFrmEditWaitTable }

class function TFrmEditWaitTime.AddWaitTable(out WaitTime: RWaitTime): Boolean;
var
  frm:TFrmEditWaitTime;
begin
  result := False;
  frm := TFrmEditWaitTime.Create(nil);
  try
    frm.m_WaitTime.New();
    if frm.ShowModal = mrOk then
    begin
      WaitTime := frm.m_WaitTime;
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmEditWaitTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditWaitTime.btnOKClick(Sender: TObject);
begin
  if CheckData = False then Exit;
  UI2Obj();
  ModalResult := mrOk;
end;



function TFrmEditWaitTime.CheckData: Boolean;
begin
  Result := False ;
  if Trim(edtCheci.Text) = '' then
  begin
    edtCheci.Focused;
    Box('车次不能为空');
    Exit;
  end;

  {
  if Trim(edtRoomNum.Text) = '' then
  begin
    edtCheci.Focused;
    Box('房间号不能为空');
    Exit;
  end;

  }

  if Trim(edtHouBan.Text) = '' then
  begin
    edtCheci.Focused;
    Box('候班时间不能为空');
    Exit;
  end;

  if Trim(edtJiaoBan.Text) = '' then
  begin
    edtCheci.Focused;
    Box('叫班时间不能为空');
    Exit;
  end;

  if Trim(edtChuQin.Text) = '' then
  begin
    edtCheci.Focused;
    Box('出勤时间不能为空');
    Exit;
  end;

  if Trim(edtKaiche.Text) = '' then
  begin
    edtCheci.Focused;
    Box('开车时间不能为空');
    Exit;
  end;
  result := True;
  
end;

procedure TFrmEditWaitTime.FormCreate(Sender: TObject);
begin
  m_DBWorkShop := TRsDBWorkShop.Create(GlobalDM.LocalADOConnection);
  m_DBTrainJiaoLu := TRsDBTrainJiaolu.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmEditWaitTime.FormShow(Sender: TObject);
begin
  obj2UI();
end;



class function TFrmEditWaitTime.ModifyWaitTable(
  var WaitTime: RWaitTime): Boolean;
var
  frm:TFrmEditWaitTime;
begin
  result := False;
  frm := TFrmEditWaitTime.Create(nil);
  try
    frm.m_WaitTime := WaitTime;
    if frm.ShowModal = mrOk then
    begin
      WaitTime := frm.m_WaitTime;
      result := True;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmEditWaitTime.obj2UI;
begin
  edtCheci.Text := m_WaitTime.strTrainNo;
  edtRoomNum.Text := m_WaitTime.strRoomNum;
  edtHouBan.Time := m_WaitTime.dtWaitTime;
  edtJiaoBan.Time := m_WaitTime.dtCallTime;
  edtChuQin.Time := m_WaitTime.dtChuQinTime;
  edtKaiche.Time := m_WaitTime.dtKaiCheTime;
end;

procedure TFrmEditWaitTime.UI2Obj;
begin
  m_WaitTime.strTrainNo := Trim(edtCheci.Text);
  m_WaitTime.strRoomNum := Trim(edtRoomNum.Text);
  m_WaitTime.dtWaitTime := edtHouBan.Time;
  m_WaitTime.dtCallTime := edtJiaoBan.Time;
  m_WaitTime.dtChuQinTime := edtChuQin.Time;
  m_WaitTime.dtKaiCheTime := edtKaiche.Time;
end;

end.
