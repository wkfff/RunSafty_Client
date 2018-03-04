unit uFrmChuQinTrainmanDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzLabel, StdCtrls, RzPanel, ExtCtrls, RzButton, Grids, AdvObj,
  BaseGrid, AdvGrid, ComCtrls, RzEdit, pngimage, uTrainPlan, uTrainman,
  uCheckRecord,uTFVariantUtils,uSaftyEnum;

type
  TFrmChuQinTrainmanDetail = class(TForm)
    rzpnl1: TRzPanel;
    rzgrpbx1: TRzGroupBox;
    lbl1: TLabel;
    lblGongHao: TRzLabel;
    lbl2: TLabel;
    lblName: TRzLabel;
    lbl3: TLabel;
    lblStation: TRzLabel;
    lbl4: TLabel;
    lblArea: TRzLabel;
    lbl5: TLabel;
    lblState: TRzLabel;
    lbl6: TLabel;
    lblPost: TRzLabel;
    lbl7: TLabel;
    lblTel: TRzLabel;
    lblLoginType: TRzLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lblDrinkResult: TRzLabel;
    pbTrainmanPicture1: TPaintBox;
    lbl10: TLabel;
    imgPic1: TImage;
    imgDrink: TImage;
    pbDrink: TPaintBox;
    lbl11: TLabel;
    edtNote: TRzRichEdit;
    advstrngrdControl: TAdvStringGrid;
    lbl13: TLabel;
    lbl12: TLabel;
    rzbtbtnCancel: TRzBitBtn;
    procedure pbTrainmanPicture1Paint(Sender: TObject);
    procedure pbDrinkPaint(Sender: TObject);
    procedure advstrngrdControlGetAlignment(Sender: TObject; ARow,
      ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormShow(Sender: TObject);
    procedure advstrngrdControlGetCellColor(Sender: TObject; ARow,
      ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    { Private declarations }
    m_ChuQinInfo:RRsChuQinPlan;
    m_TrainmanPost:TRsPost;
    m_CheckRecAry:TRsCheckRecordArray;
  private
    procedure UpdateTrainmanInfo;
    procedure UpdateCuQinCheckRecList(strTrainGUID:string;dtChuQin:TDateTime);
  published
    property ChuQinInfo:RRsChuQinPlan read m_ChuQinInfo write m_ChuQinInfo;
    property Post:TRsPost read m_TrainmanPost write m_TrainmanPost;
  end;

procedure ShowChuQinTrainmanDetailInfo(Sender:TComponent;post:TRsPost;ChuQinInfo:RRsChuQinPlan);
implementation
uses
  uTFSystem, uRunSaftyDefine, uGlobalDM, uDBCheckRecord;

{$R *.dfm}
procedure ShowChuQinTrainmanDetailInfo(Sender:TComponent;post:TRsPost;ChuQinInfo:RRsChuQinPlan);
var
  frmDetail:TFrmChuQinTrainmanDetail;
begin
  frmDetail := TFrmChuQinTrainmanDetail.Create(Sender);
  try
    frmDetail.Post := post;
    frmDetail.ChuQinInfo := ChuQinInfo;
    frmDetail.ShowModal;
  finally
    FreeAndNil(frmDetail);
  end;
end;

{ TFrmChuQinTrainmanDetail }

procedure TFrmChuQinTrainmanDetail.advstrngrdControlGetAlignment(
  Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment;
  var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TFrmChuQinTrainmanDetail.advstrngrdControlGetCellColor(
  Sender: TObject; ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush;
  AFont: TFont);
begin
  if ACol = 4 then
  begin
    if advstrngrdControl.Cells[ACol,ARow] = 'Ê§°Ü' then
      ABrush.Color := clRed;
  end;
end;

procedure TFrmChuQinTrainmanDetail.FormShow(Sender: TObject);
var
  I:Integer;
begin
  for I := 0 to Length(TChuQinTrainmanDetailWidthAry) - 1 do
  begin
    advstrngrdControl.ColWidths[I] := TChuQinTrainmanDetailWidthAry[I];
  end;
  UpdateTrainmanInfo;
end;

procedure TFrmChuQinTrainmanDetail.pbDrinkPaint(Sender: TObject);
begin
  case m_TrainmanPost of
    ptNone: ;
    ptTrainman:
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.TestAlcoholInfo1.Picture,pbDrink);
    end;
    ptSubTrainman: 
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.TestAlcoholInfo2.Picture,pbDrink);
    end;
    ptLearning: 
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.TestAlcoholInfo3.Picture,pbDrink);
    end;
  end;
end;

procedure TFrmChuQinTrainmanDetail.pbTrainmanPicture1Paint(Sender: TObject);
begin
  case m_TrainmanPost of
    ptNone: ;
    ptTrainman:
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.Group.Trainman1.Picture,TPaintBox(Sender));
    end;
    ptSubTrainman:
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.Group.Trainman2.Picture,TPaintBox(Sender));
    end;
    ptLearning:
    begin
      TTFVariantUtils.CopyJPEGVariantToPaintBox(m_ChuQinInfo.ChuQinGroup.Group.Trainman3.Picture,TPaintBox(Sender));
    end;
  end;
end;

procedure TFrmChuQinTrainmanDetail.UpdateCuQinCheckRecList(strTrainGUID: string;
  dtChuQin: TDateTime);
var
  I:Integer;
begin
  advstrngrdControl.BeginUpdate;
  try
    advstrngrdControl.ClearRows(1,10000);
    advstrngrdControl.RowCount := 2;
    TRsDBCheckcRecord.GetTrainmanCheckRecord(GlobalDM.ADOConnection,strTrainGUID,
      dtChuQin,m_CheckRecAry);
    for I := 0 to Length(m_CheckRecAry) - 1 do
    begin
      advstrngrdControl.Cells[0,I+1] := IntToStr(I+1);
      advstrngrdControl.Cells[1,I+1] := m_CheckRecAry[I].strPointName;
      advstrngrdControl.Cells[2,I+1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',m_CheckRecAry[I].dtCheckTime);
      advstrngrdControl.Cells[3,I+1] := m_CheckRecAry[I].strItemContent;
      if m_CheckRecAry[I].nCheckResult > 0 then      
        advstrngrdControl.Cells[4,I+1] := 'Í¨¹ý'
      else
        advstrngrdControl.Cells[4,I+1] := 'Ê§°Ü';
    end;
  finally
    advstrngrdControl.EndUpdate;
  end;
end;

procedure TFrmChuQinTrainmanDetail.UpdateTrainmanInfo;
begin
  case m_TrainmanPost of
    ptNone: ;
    ptTrainman:
    begin            
      lblGongHao.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman1.strTrainmanNumber;
      lblName.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman1.strTrainmanName;
      lblPost.Caption := TRsPostNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman1.nPostID];
      lblState.Caption := TRsTrainmanStateNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman1.nTrainmanState];
      lblLoginType.Caption := TRsRegisterFlagNameAry[ChuQinInfo.ChuQinGroup.nVerifyID1];
      lblDrinkResult.Caption := TTestAlcoholResultNameAry[ChuQinInfo.ChuQinGroup.TestAlcoholInfo1.taTestAlcoholResult];
      lblArea.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman1.strWorkShopName;
      lblTel.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman1.strTelNumber;

      UpdateCuQinCheckRecList(ChuQinInfo.ChuQinGroup.Group.Trainman1.strTrainmanGUID,
        ChuQinInfo.ChuQinGroup.TestAlcoholInfo1.dtTestTime);
    end;
    ptSubTrainman:
    begin
      lblGongHao.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman2.strTrainmanNumber;
      lblName.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman2.strTrainmanName;
      lblPost.Caption := TRsPostNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman2.nPostID];
      lblState.Caption := TRsTrainmanStateNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman2.nTrainmanState];
      lblLoginType.Caption := TRsRegisterFlagNameAry[ChuQinInfo.ChuQinGroup.nVerifyID2];
      lblDrinkResult.Caption := TTestAlcoholResultNameAry[ChuQinInfo.ChuQinGroup.TestAlcoholInfo2.taTestAlcoholResult];
      lblArea.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman2.strWorkShopName;
      lblTel.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman2.strTelNumber;
      
      UpdateCuQinCheckRecList(ChuQinInfo.ChuQinGroup.Group.Trainman1.strTrainmanGUID,
        ChuQinInfo.ChuQinGroup.TestAlcoholInfo2.dtTestTime);
    end;
    ptLearning:
    begin
      lblGongHao.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman3.strTrainmanNumber;
      lblName.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman3.strTrainmanName;
      lblPost.Caption := TRsPostNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman3.nPostID];
      lblState.Caption := TRsTrainmanStateNameAry[ChuQinInfo.ChuQinGroup.Group.Trainman3.nTrainmanState];
      lblLoginType.Caption := TRsRegisterFlagNameAry[ChuQinInfo.ChuQinGroup.nVerifyID3];
      lblDrinkResult.Caption := TTestAlcoholResultNameAry[ChuQinInfo.ChuQinGroup.TestAlcoholInfo3.taTestAlcoholResult];
      lblArea.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman3.strWorkShopName;
      lblTel.Caption := ChuQinInfo.ChuQinGroup.Group.Trainman3.strTelNumber;

      UpdateCuQinCheckRecList(ChuQinInfo.ChuQinGroup.Group.Trainman1.strTrainmanGUID,
        ChuQinInfo.ChuQinGroup.TestAlcoholInfo3.dtTestTime);
    end;
  end;       
  lblStation.Caption := ChuQinInfo.ChuQinGroup.Group.Station.strStationName;
  edtNote.Text := ChuQinInfo.ChuQinGroup.strChuQinMemo;
  
end;

end.
