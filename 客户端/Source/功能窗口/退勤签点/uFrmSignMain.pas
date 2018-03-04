unit uFrmSignMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs,uTrainJiaolu,uGlobalDM,uFrmSignJiaolu,Contnrs,
  uTrainman,uLCBaseDict;

type
  {签点交路窗体列表}
  TFrmSignJiaoluList = class(TObjectList)
   protected
    function GetItem(Index: Integer): TFrmSignJiaoLu;
    procedure SetItem(Index: Integer; AObject: TFrmSignJiaoLu);
  public
    property Items[Index: Integer]: TFrmSignJiaoLu read GetItem write SetItem; default;
    function Add(AObject: TFrmSignJiaoLu): Integer;
  end;
  
  TFrmSignMain = class(TForm)
    pgMain: TRzPageControl;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //行车交路数组
    m_TrainJiaoluArray:TRsTrainJiaoluArray;
    //签点交路窗体列表
    m_FrmSignJiaoLuList:TFrmSignJiaoluList;
    //签点窗体类型
    m_FormType:TSignFormType;
  private
    {功能:初始化交路信息}
    procedure InitTrainJiaolus();
    {功能:增加交路}
    procedure AddJiaoLu(trainJiaolu:RRsTrainJiaolu);
    {功能:移除交路}
//    procedure DelJiaoLu(nIndex:Integer);
    {功能:移除所有交路}
//    procedure DelAllJiaoLu();
  public
    {签点}
    function Sign(trainman:RRStrainman):Boolean;
  end;
  {显示签点窗体}
  function ShowSignPlanForm(parent:TWinControl;FrmType:TSignFormType):TFrmSignMain;


implementation

{$R *.dfm}
function ShowSignPlanForm(parent:TWinControl;FrmType:TSignFormType):TFrmSignMain;
begin
  result  := TFrmSignMain.Create(parent);
  Result.BorderStyle := bsNone;
  result.Align := alClient;
  result.Parent := parent;
  result.m_FormType := FrmType;
  result.Show;
end;

procedure TFrmSignMain.AddJiaoLu(trainJiaolu: RRsTrainJiaolu);
var
  tabSheet:TRzTabSheet;
  frmSignJiaoLu:TFrmSignJiaoLu;
begin
  tabSheet := TRzTabSheet.Create(pgMain);
  tabSheet.PageControl := pgMain;
  tabSheet.Caption := trainJiaolu.strTrainJiaoluName;
  frmSignJiaoLu := TFrmSignJiaoLu.Create(nil);
  frmSignJiaoLu.TrainJiaoLu := trainJiaolu;
  frmSignJiaoLu.BorderStyle := bsNone;
  frmSignJiaoLu.Align := alClient;
  frmSignJiaoLu.FormType := self.m_FormType;
  m_FrmSignJiaoLuList.Add(frmSignJiaoLu);
  frmSignJiaoLu.Parent := tabSheet;
  frmSignJiaoLu.Show();

end;

//procedure TFrmSignMain.DelAllJiaoLu;
//var
//  i:Integer;
//begin
//  for i := Length(m_TrainJiaoluArray)-1 to  0 do
//  begin
//    DelJiaoLu(i);
//  end;
//  //m_FrmSignJiaoLuList.Free;
//end;

//procedure TFrmSignMain.DelJiaoLu(nIndex: Integer);
//begin
//  {tabSheet := pgMain.PageForTab(nIndex);
//  tabSheet.Parent := nil;
//  tabSheet.Free;}
//  if m_FrmSignJiaoLuList.Count > 0 then
//    m_FrmSignJiaoLuList.Delete(nIndex);
//end;

procedure TFrmSignMain.FormCreate(Sender: TObject);
begin
  m_FrmSignJiaoLuList:=TFrmSignJiaoluList.Create;
end;

procedure TFrmSignMain.FormDestroy(Sender: TObject);
begin
  //DelAllJiaoLu();
  m_FrmSignJiaoLuList.Free;
end;

procedure TFrmSignMain.FormShow(Sender: TObject);
begin
  InitTrainJiaolus();
  if m_FrmSignJiaoLuList.Count > 0 then
  begin
    pgMain.ActivePageIndex := 0;
  end;
end;

procedure TFrmSignMain.InitTrainJiaolus();
var
  i:Integer;
begin
  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);

  for I := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    AddJiaoLu(m_TrainjiaoluArray[i]);
  end;
end;

function TFrmSignMain.Sign(trainman: RRStrainman): Boolean;
begin
  Result := True;
  m_FrmSignJiaoLuList.Items[pgMain.ActivePageIndex].Sign(trainman);
end;

{ TFrmSignJiaoluList }

function TFrmSignJiaoluList.Add(AObject: TFrmSignJiaoLu): Integer;
begin
  result := inherited Add(AObject);
end;

function TFrmSignJiaoluList.GetItem(Index: Integer): TFrmSignJiaoLu;
begin
  result := TFrmSignJiaoLu(inherited GetItem(Index));
end;

procedure TFrmSignJiaoluList.SetItem(Index: Integer; AObject: TFrmSignJiaoLu);
begin
  inherited SetItem(Index,AObject);
end;

end.
