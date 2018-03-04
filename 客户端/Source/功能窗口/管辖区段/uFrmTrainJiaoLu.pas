unit uFrmTrainJiaoLu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs,uTrainJiaolu,uLCBaseDict,utfskin;

type
  TFrmTrainJiaoLu = class(TForm)
    tabTrainJiaolu: TRzTabControl;
    procedure tabTrainJiaoluChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //客户端ID
    m_strSiteID:string;
    //行车区段数组
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //选中当前事件
    m_eventChange:TNotifyEvent;
  private
    { Private declarations }
    //客户端SITEID
    procedure SetSiteID(SiteID:string);
    function  GetSiteID():string;
    //获取选中交路
    function  GetSelectTrainJiaoLu():RRsTrainJiaolu;
  public
    { Public declarations }
    //初始化行车区段信息
    procedure InitTrainJiaolus;
  public
    property SiteID:string read GetSiteID write SetSiteID;
    property SelectTrainJiaoLu:RRsTrainJiaolu  read GetSelectTrainJiaoLu;
    property ChangeEvent:TNotifyEvent read  m_eventChange write m_eventChange ;
    property TrainJiaoluArray:TRsTrainJiaoluArray read m_TrainjiaoluArray ;
  end;

var
  FrmTrainJiaoLu: TFrmTrainJiaoLu;

implementation
uses
  uGlobalDM ;

{$R *.dfm}

procedure TFrmTrainJiaoLu.FormCreate(Sender: TObject);
begin
  TtfSkin.InitRzTab(tabTrainJiaolu);
end;

function TFrmTrainJiaoLu.GetSelectTrainJiaoLu: RRsTrainJiaolu;
begin
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  if length(m_TrainjiaoluArray) < tabTrainJiaolu.Tabs.Count then
    exit
  else
    Result := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex];
end;

function TFrmTrainJiaoLu.GetSiteID: string;
begin
  Result := m_strSiteID ;
end;

procedure TFrmTrainJiaoLu.InitTrainJiaolus;
var
  i,tempIndex:Integer;
  tab:TRzTabCollectionItem;
begin
  tempIndex := tabTrainJiaolu.TabIndex;
  SetLength(m_TrainJiaoluArray,0);



  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(m_strSiteID,m_TrainJiaoluArray);
  tabTrainJiaolu.Tabs.Clear;

  for I := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    tab := tabTrainJiaolu.Tabs.Add;
    tab.Caption := m_TrainJiaoluArray[i].strTrainJiaoluName;
  end;
  if length(m_TrainJiaoluArray) > 0 then
  begin
    tabTrainJiaolu.TabIndex := 0;
    if (tempIndex > -1) and (tempIndex < tabTrainJiaolu.Tabs.Count) then
      tabTrainJiaolu.TabIndex := tempIndex;
  end;
end;

procedure TFrmTrainJiaoLu.SetSiteID(SiteID: string);
begin
  m_strSiteID := SiteID ;
end;

procedure TFrmTrainJiaoLu.tabTrainJiaoluChange(Sender: TObject);
begin
  if assigned(m_eventChange) then
    m_eventChange(Sender) ;
end;

end.
  