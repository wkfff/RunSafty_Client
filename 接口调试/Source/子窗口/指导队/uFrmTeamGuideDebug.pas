unit uFrmTeamGuideDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmDebugBase, ComCtrls, StdCtrls, ExtCtrls,uLCTeamGuide,uGuideSign,uTrainman;

type
  TFrmTeamGuideDebug = class(TFrmDebugBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RsLCGuideGroup: TRsLCGuideGroup;
  public
    { Public declarations }
  published
    //����:1.10.1    ��ȡ���г���
    procedure Group_GetWorkShopArray();
    //����:1.10.2    ��ȡ����GUID
    procedure Group_GetOwnerWorkShopID();
    //����:1.10.3    ��ȡָ��������
    procedure Group_GetName();
    //����:1.10.4    ��ȡ�������ƣ�ָ��������
    procedure Group_GetWorkShop_GuideGroup();
    //����:1.10.5    ���ݳ��䣬��ȡָ����
    procedure Group_GetGroupArray();

    //����:1.10.6    ����ԱID��������ָ����ID
    procedure Trainman_SetGroupByID();
    //����:1.10.7    �����Ÿ�������ָ����ID
    procedure Trainman_SetGroupByNumber();
    //����:1.10.8    ����˾��ְλ
    procedure Trainman_SetPostID();
    //����:1.10.9    ���ݲ�ѯ�����͹����������õ�˾���б�
    procedure Trainman_GetList();
    //����:1.10.10    ��ְλ��ȡ��Ա�б�
    procedure Trainman_GetByPost();
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
{ TFrmTeamGuideDebug }

procedure TFrmTeamGuideDebug.FormCreate(Sender: TObject);
begin
  inherited;
  RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmTeamGuideDebug.FormDestroy(Sender: TObject);
begin
  RsLCGuideGroup.Free;
  inherited;
end;

procedure TFrmTeamGuideDebug.Group_GetName;
var
  guideGroupID: string;
begin
  guideGroupID := 'AFE5BE29-A419-4911-B150-14FA3B0E2D8D';
  RsLCGuideGroup.GetName(guideGroupID);
end;

procedure TFrmTeamGuideDebug.Group_GetGroupArray;
var
  SimpleInfoArray: TRsSimpleInfoArray;
  WorkShopGUID: string;
begin
  WorkShopGUID := 'caa268d3-aeb3-42c2-9b1b-4cd97d02d9eb';
  RsLCGuideGroup.GetGroupArray(WorkShopGUID,SimpleInfoArray);
end;

procedure TFrmTeamGuideDebug.Group_GetOwnerWorkShopID;
var
  guideGUID: string;
begin
  guideGUID := 'AFE5BE29-A419-4911-B150-14FA3B0E2D8D';
  RsLCGuideGroup.GetOwnerWorkShopID(guideGUID);
end;

procedure TFrmTeamGuideDebug.Group_GetWorkShopArray;
var
  RsSimpleInfoArray: TRsSimpleInfoArray;
begin
  RsLCGuideGroup.GetWorkShopArray(RsSimpleInfoArray);
end;

procedure TFrmTeamGuideDebug.Group_GetWorkShop_GuideGroup();
var
  guideGUID: string;
begin
  guideGUID := 'AFE5BE29-A419-4911-B150-14FA3B0E2D8D';
  RsLCGuideGroup.GetWorkShop_GuideGroup(guideGUID);
end;

procedure TFrmTeamGuideDebug.Trainman_GetByPost;
var
  WorkShopGUID: String;
  nPostID, cmdType: Integer;
  trainmanArray: TRsTrainmanArray;
begin
  WorkShopGUID := 'caa268d3-aeb3-42c2-9b1b-4cd97d02d9eb';
  nPostID := 1;
  cmdType := 0;
  RsLCGuideGroup.Trainman.GetByPost(WorkShopGUID,nPostID,cmdType,trainmanArray);
end;

procedure TFrmTeamGuideDebug.Trainman_GetList;
var
  QueryParam, FilterParam: RRsQueryTrainman;
  trainmanArray: TRsTrainmanArray;
begin
  RsLCGuideGroup.Trainman.GetList(QueryParam, FilterParam,trainmanArray);
end;

procedure TFrmTeamGuideDebug.Trainman_SetGroupByID;
var
  trainmanid,groupid: string;
begin
  trainmanid := '{3DD78F83-700D-46F3-A8DC-B0AF982DB732}';
  groupid := 'AFE5BE29-A419-4911-B150-14FA3B0E2D8D';
  
  RsLCGuideGroup.Trainman.SetGroupByID(trainmanid,groupid);
end;

procedure TFrmTeamGuideDebug.Trainman_SetGroupByNumber;
var
  trainmannumber,groupid: string;
begin
  trainmannumber := '2022002';
  groupid := 'AFE5BE29-A419-4911-B150-14FA3B0E2D8D';
  RsLCGuideGroup.Trainman.SetGroupByNumber(trainmannumber,groupid,true);
end;

procedure TFrmTeamGuideDebug.Trainman_SetPostID;
var
  trainmanid: string;
  nPostID: integer;
begin
  trainmanid :=  '{3DD78F83-700D-46F3-A8DC-B0AF982DB732}';
  nPostID := 2;
  RsLCGuideGroup.Trainman.SetPostID(trainmanid,nPostID);
end;

initialization
  ChildFrmMgr.Reg(TFrmTeamGuideDebug);
end.
