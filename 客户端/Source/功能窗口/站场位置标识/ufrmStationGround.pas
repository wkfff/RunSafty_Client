unit ufrmStationGround;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzAnimtr, ImgList, PngImageList, uGlobalDM,uTrainMaintainsDefine,
  PngFunctions,pngimage,uTFSystem, ActnList, Buttons, PngSpeedButton, StdCtrls;
const
  BACKGROUND_IMAGE = 'Images\Õ¾³¡Í¼\Õ¾³¡Í¼.bmp';
type
  TfrmStationGround = class(TForm)
    imgBackGround: TImage;
    PngImageList1: TPngImageList;
    RzAnimator: TRzAnimator;
    PngImageCollection: TPngImageCollection;
    ActionList: TActionList;
    ActEnter: TAction;
    ActEsc: TAction;
    Timer1: TTimer;
    Bevel1: TBevel;
    Label1: TLabel;
    btnCancel: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActEnterExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_strTrainType: string;
    m_strTrainNumber: string;
    m_MaintainInfoList: TRsTrainMaintainInfoList;
    m_FormShowTime: Cardinal;
    procedure LoadBackgroud();
    procedure GetTrainMaintainsInfo();
    procedure PaintTrains();
    procedure PaintWorkTrain(X,Y: Integer;TrainMaintainInfo: TRsTrainMaintainInfo);
  public
    { Public declarations }
    procedure Init();
    property TrainType: string read m_strTrainType write m_strTrainType;
    property TrainNumber: string read m_strTrainNumber write m_strTrainNumber;
  end;

procedure ShowTrainMaintainInfo(strTrainType,strTrainNumber: string);
implementation

uses uDBTrainMaintanInfo;
procedure ShowTrainMaintainInfo(strTrainType,strTrainNumber: string);
var
  frmStationGround: TfrmStationGround;
begin
  frmStationGround := TfrmStationGround.Create(nil);
  try
    frmStationGround.TrainType := strTrainType;
    frmStationGround.TrainNumber := strTrainNumber;
    frmStationGround.Init();
    frmStationGround.ShowModal;
  finally
    frmStationGround.Free;
  end;
end;
{$R *.dfm}

procedure TfrmStationGround.ActEnterExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmStationGround.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmStationGround.FormCreate(Sender: TObject);
begin
  m_MaintainInfoList := TRsTrainMaintainInfoList.Create;
  RzAnimator.Visible := False;

  LoadBackgroud();
end;

procedure TfrmStationGround.FormDestroy(Sender: TObject);
begin
  m_MaintainInfoList.Free;
end;

procedure TfrmStationGround.FormShow(Sender: TObject);
begin
  PaintTrains();
  Timer1.Enabled := not Boolean(System.DebugHook);
  m_FormShowTime := GetTickCount;
end;

procedure TfrmStationGround.GetTrainMaintainsInfo;
var
  DBTrainMaintain: TRsDBTrainMaintain;
begin
  DBTrainMaintain := TRsDBTrainMaintain.Create(GlobalDM.ADOConnection);
  try
    DBTrainMaintain.GetTrainMaintainInfo(m_MaintainInfoList);
  finally
    DBTrainMaintain.Free;
  end;
end;

procedure TfrmStationGround.Init;
begin
  GetTrainMaintainsInfo();
end;

procedure TfrmStationGround.LoadBackgroud;
begin
  if FileExists(GlobalDM.AppPath + BACKGROUND_IMAGE) then
  begin
    imgBackGround.Picture.LoadFromFile(GlobalDM.AppPath + BACKGROUND_IMAGE);
    Self.color := imgBackGround.Picture.Bitmap.Canvas.Pixels[1,1];
    imgBackGround.Top :=  (Screen.Height - imgBackGround.Height) div 2;
    imgBackGround.Left := (Screen.Width - imgBackGround.Width) div 2;
    imgBackGround.SendToBack;
  end;

end;

procedure TfrmStationGround.PaintWorkTrain(X,Y: Integer;
    TrainMaintainInfo: TRsTrainMaintainInfo);
begin
  RzAnimator.Visible := True;

  RzAnimator.Left := X - RzAnimator.Width div 2;
  RzAnimator.Top := Y - RzAnimator.Height div 2;
end;

procedure TfrmStationGround.Timer1Timer(Sender: TObject);
begin
  if (GetTickCount - m_FormShowTime) > 5000 then
  begin
    TTimer(Sender).Enabled := False;
    ModalResult := mrOk;
  end;

end;

procedure TfrmStationGround.PaintTrains;
var
  PngObj: TPNGObject;
  i: Integer;
  fXRatio: Double;
  fYRatio: Double;
  X,Y: Integer;
  Rect: TRect;
  noffSet: Integer;
begin
  PngObj := PngImageCollection.Items.Items[0].PngImage;
  if m_MaintainInfoList.Count > 0 then
  begin
    fXRatio := imgBackGround.Width / m_MaintainInfoList.Items[0].GroundWidth;
    fYRatio := imgBackGround.Height / m_MaintainInfoList.Items[0].GroundHeight;
  end
  else
    Exit;

  noffSet := PngObj.Width div 2; 
  for I := 0 to m_MaintainInfoList.Count - 1 do
  begin
    X := Round(imgBackGround.Left + m_MaintainInfoList.Items[i].CoordX * fXRatio);
    Y := Round(imgBackGround.Top + m_MaintainInfoList.Items[i].CoordY * fYRatio);

    if (m_MaintainInfoList.Items[i].strTrainTypeName = m_strTrainType)
    and (m_MaintainInfoList.Items[i].strTrainNumber = m_strTrainNumber) then
    begin
      PaintWorkTrain(X,Y,m_MaintainInfoList.Items[i]);
    end
    else
    begin
      Rect.Left := X - noffSet;
      Rect.Right := X + noffSet;
      Rect.Top := Y - noffSet;
      Rect.Bottom := Y + noffSet;
      DrawPNG(PngObj,imgBackGround.Canvas,Rect,[]);
    end;

  end;
end;

end.
