unit uFrmDutyGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, Buttons, Grids, RzGrids, ExtCtrls, RzPanel,
  IniFiles, uGlobalDM, uTFSystem, uSaftyEnum,
  uTrainman,  uGuideSign,  PngSpeedButton,uLCTeamGuide;

const
  TRsPostName : array[TRsPost] of string = ('', '司机','副司机','学员');

type
  TFrmDutyGroup = class(TForm)
    Label10: TLabel;
    pnlLeft: TRzPanel;
    RzPanel2: TRzPanel;
    Label1: TLabel;
    grdSrc: TRzStringGrid;
    pnlRight: TRzPanel;
    RzPanel4: TRzPanel;
    Label2: TLabel;
    grdDes: TRzStringGrid;
    pnlMiddle: TRzPanel;
    btnSelOne: TBitBtn;
    btnSelAll: TBitBtn;
    btnDelOne: TBitBtn;
    btnDelAll: TBitBtn;
    btnSrcPY: TPngSpeedButton;
    edtSrcPY: TEdit;
    Label3: TLabel;
    edtDesPY: TEdit;
    btnDesPY: TPngSpeedButton;
    RadioGroupDuty: TRadioGroup;
    RadioGroupNone: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdSrcDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btnSelOneClick(Sender: TObject);
    procedure btnDelOneClick(Sender: TObject);
    procedure btnSrcPYClick(Sender: TObject);
    procedure btnDesPYClick(Sender: TObject);
    procedure RadioGroupDutyClick(Sender: TObject);
    procedure RadioGroupNoneClick(Sender: TObject);
  private
    { Private declarations }

    m_RsLCGuideGroup: TRsLCGuideGroup;
    //所在车间GUID
    m_strWorkShopGUID : string;
    //职位ID
    m_nPostID: integer;

    //显示待选的司机信息
    procedure ShowAllTrainman;
    //显示已选的司机信息   
    procedure ShowSelTrainman;
    //选择和反选
    procedure AddRow(grd: TRzStringGrid; txt: string);
    procedure DelRow(grd: TRzStringGrid; row: integer);
  public
    { Public declarations }  
    class function ShowForm: TModalResult;
  end;

implementation

uses
  uFrmMain_GuideSign;


{$R *.dfm}

{ TFrmDutyGroup }

class function TFrmDutyGroup.ShowForm: TModalResult;
var
  FrmDutyGroup: TFrmDutyGroup;
begin
  FrmDutyGroup := TFrmDutyGroup.Create(nil);
  result := FrmDutyGroup.ShowModal;
  FrmDutyGroup.Free;
end;

procedure TFrmDutyGroup.FormCreate(Sender: TObject);
begin
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmDutyGroup.FormDestroy(Sender: TObject);
begin
  m_RsLCGuideGroup.Free;
end;

procedure TFrmDutyGroup.FormResize(Sender: TObject);
begin
  //self.pnlLeft.Width := (self.ClientWidth - self.pnlMiddle.Width) div 2;
end;

procedure TFrmDutyGroup.FormShow(Sender: TObject);
begin
  inherited;

  
  grdSrc.RowCount := 1;
  grdSrc.ColCount := 5;
  grdSrc.RowHeights[0] := 24;
  grdSrc.ColWidths[0] := 16;
  grdSrc.ColWidths[1] := 80;
  grdSrc.ColWidths[2] := 100;
  grdSrc.ColWidths[3] := 80;
  grdSrc.ColWidths[4] := 0;
  grdSrc.Cells[1,0] := '工号';
  grdSrc.Cells[2,0] := '姓名';
  grdSrc.Cells[3,0] := '职位';
  
  grdDes.RowCount := 1;
  grdDes.ColCount := 5;
  grdDes.RowHeights[0] := 24;
  grdDes.ColWidths[0] := 16;
  grdDes.ColWidths[1] := 80;
  grdDes.ColWidths[2] := 100;
  grdDes.ColWidths[3] := 80;
  grdDes.ColWidths[4] := 0;
  grdDes.Cells[1,0] := '工号';
  grdDes.Cells[2,0] := '姓名';
  grdDes.Cells[3,0] := '职位';

  m_strWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  m_nPostID := 1;
  RadioGroupDuty.ItemIndex := m_nPostID - 1;
  RadioGroupNone.ItemIndex := 0;
//
//  ShowAllTrainman;
//  ShowSelTrainman;
end;
     
procedure TFrmDutyGroup.RadioGroupDutyClick(Sender: TObject);
begin
  m_nPostID := RadioGroupDuty.ItemIndex + 1;
  ShowSelTrainman;
  if RadioGroupNone.ItemIndex = 1 then ShowAllTrainman;
end;

procedure TFrmDutyGroup.RadioGroupNoneClick(Sender: TObject);
begin
  ShowAllTrainman;
end;

procedure TFrmDutyGroup.grdSrcDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  WSpace = 2;
var
  T: string;
  W, H: integer;
begin
  inherited;
  T := (Sender as TStringGrid).Cells[ACol,ARow];
  with (Sender as TStringGrid).Canvas do
  begin
    if ARow = 0 then Font.Style := [fsBold];
    W := TextWidth(T);
    H := TextHeight(T);
    TextRect(Rect, Trunc((Rect.Right+Rect.Left-W)/2), Trunc((Rect.Bottom+Rect.Top-H)/2), T); //居中显示
  end;
end;

procedure TFrmDutyGroup.btnSelOneClick(Sender: TObject);
var
  i: integer;
  strTrainmanGUID: string;
begin
  inherited;
  i := grdSrc.Row;
  if i <= 0 then exit;
  strTrainmanGUID := grdSrc.Cells[4,i];
  if strTrainmanGUID = '' then exit;

  m_RsLCGuideGroup.Trainman.SetPostID(strTrainmanGUID, m_nPostID);
//  m_dbGuideSign.UpdatePostGroupByTrainmanGUID(strTrainmanGUID, m_nPostID);

  grdSrc.Cells[3,i] := TRsPostName[TRsPost(m_nPostID)];
  AddRow(grdDes, grdSrc.Rows[i].Text);
  DelRow(grdSrc, i);
end;
     
procedure TFrmDutyGroup.btnDelOneClick(Sender: TObject);
var
  i: integer; 
  strTrainmanGUID: string;
begin
  inherited;
  i := grdDes.Row;
  if i <= 0 then exit; 
  strTrainmanGUID := grdDes.Cells[4,i];
  if strTrainmanGUID = '' then exit;

  m_RsLCGuideGroup.Trainman.SetPostID(strTrainmanGUID, 0);
//  m_dbGuideSign.UpdatePostGroupByTrainmanGUID(strTrainmanGUID, 0);

  grdDes.Cells[3,i] := '';
  AddRow(grdSrc, grdDes.Rows[i].Text);
  DelRow(grdDes, i);
end;

procedure TFrmDutyGroup.btnSrcPYClick(Sender: TObject);
begin
  ShowAllTrainman;
end;
          
procedure TFrmDutyGroup.btnDesPYClick(Sender: TObject);
begin
  ShowSelTrainman;
end;

procedure TFrmDutyGroup.ShowAllTrainman;
var
  TrainmanArray, TrainmanArray2: TRsTrainmanArray;
  i, nRow: integer;
  strPY: string;
begin
  try

    m_RsLCGuideGroup.Trainman.GetByPost(m_strWorkShopGUID, (RadioGroupDuty.ItemIndex + 1),1, TrainmanArray2);

    //根据拼音检索
    strPY := Trim(edtSrcPY.Text);
    if strPY = '' then
    begin
      TrainmanArray := TrainmanArray2;
    end
    else
    begin
      for i := 0 to Length(TrainmanArray2)-1 do
      begin
        //if Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(TrainmanArray2[i].strTrainmanName))) > 0 then
        if (Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(TrainmanArray2[i].strTrainmanName))) > 0)
        or (Pos(UpperCase(strPY),TrainmanArray2[i].strTrainmanNumber) > 0)
        or (Pos(UpperCase(strPY),TrainmanArray2[i].strTrainmanName) > 0) then
        begin
          SetLength(TrainmanArray, Length(TrainmanArray)+1);
          TrainmanArray[Length(TrainmanArray)-1] := TrainmanArray2[i];
        end;
      end;
    end;
    //---------------

    grdSrc.RowCount := 1;
    for i := 0 to Length(TrainmanArray)-1 do
    begin
      nRow := grdSrc.RowCount;
      grdSrc.RowCount := nRow + 1;
      grdSrc.RowHeights[nRow] := 24;
      grdSrc.Cells[1,nRow] := TrainmanArray[i].strTrainmanNumber;
      grdSrc.Cells[2,nRow] := TrainmanArray[i].strTrainmanName;
      grdSrc.Cells[3,nRow] := TRsPostName[TrainmanArray[i].nPostID];
      grdSrc.Cells[4,nRow] := TrainmanArray[i].strTrainmanGUID;
    end;
  finally
    if grdSrc.RowCount = 1 then
    begin
      grdSrc.RowCount := 2;
      grdSrc.RowHeights[1] := 24;
      grdSrc.Rows[1].Text := '';
    end;
    grdSrc.FixedRows := 1;
  end;
end;
       
procedure TFrmDutyGroup.ShowSelTrainman;
var
  TrainmanArray, TrainmanArray2: TRsTrainmanArray;
  i, nRow: integer;    
  strPY: string;
begin
  try
    m_RsLCGuideGroup.Trainman.GetByPost(m_strWorkShopGUID, m_nPostID, 0,TrainmanArray2);
//    m_dbGuideSign.GetSelTrainmanListByPost(m_strWorkShopGUID, m_nPostID, TrainmanArray2);
                         
    //根据拼音检索
    strPY := Trim(edtDesPY.Text);
    if strPY = '' then
    begin
      TrainmanArray := TrainmanArray2;
    end
    else
    begin
      for i := 0 to Length(TrainmanArray2)-1 do
      begin
        if (Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(TrainmanArray2[i].strTrainmanName))) > 0)
        or (Pos(UpperCase(strPY),TrainmanArray2[i].strTrainmanNumber) > 0)
        or (Pos(UpperCase(strPY),TrainmanArray2[i].strTrainmanName) > 0) then
        begin
          SetLength(TrainmanArray, Length(TrainmanArray)+1);
          TrainmanArray[Length(TrainmanArray)-1] := TrainmanArray2[i];
        end;
      end;
    end;
    //---------------

    grdDes.RowCount := 1;
    for i := 0 to Length(TrainmanArray)-1 do
    begin
      nRow := grdDes.RowCount;
      grdDes.RowCount := nRow + 1;
      grdDes.RowHeights[nRow] := 24;
      grdDes.Cells[1,nRow] := TrainmanArray[i].strTrainmanNumber;
      grdDes.Cells[2,nRow] := TrainmanArray[i].strTrainmanName;
      grdDes.Cells[3,nRow] := TRsPostName[TrainmanArray[i].nPostID];
      grdDes.Cells[4,nRow] := TrainmanArray[i].strTrainmanGUID;
    end;
  finally
    if grdDes.RowCount = 1 then
    begin
      grdDes.RowCount := 2;
      grdDes.RowHeights[1] := 24;
      grdDes.Rows[1].Text := '';
    end;
    grdDes.FixedRows := 1;
  end;
end;

procedure TFrmDutyGroup.AddRow(grd: TRzStringGrid; txt: string);
var
  i: integer;
begin
  inherited;
  i := grd.RowCount;

  if grd.RowCount = 1 then
  begin
    grd.RowCount := 2;
    grd.RowHeights[1] := 24;
    grd.FixedRows := 1;
  end;

  if grd.RowCount = 2 then
  begin
    if grd.Cells[4,1] = '' then
      i := 1
    else
      grd.RowCount := i+1;
  end
  else
  begin
    grd.RowCount := i+1;
  end;
  grd.RowHeights[i] := 24;

  grd.Rows[i].Text := txt;
end;

procedure TFrmDutyGroup.DelRow(grd: TRzStringGrid; row: integer);
var
  i, n: integer;
begin
  n := grd.RowCount;
  if n = 2 then
  begin
    grd.Rows[row].Text := '';
    exit;
  end;

  if n > 2 then
  begin
    for i := row+1 to n-1 do
    begin
      grd.Rows[i-1].Text := grd.Rows[i].Text;
    end;
    grd.RowCount := n-1;
  end;
end;

end.
