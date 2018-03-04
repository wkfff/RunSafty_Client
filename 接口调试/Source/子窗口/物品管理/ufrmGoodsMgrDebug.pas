unit ufrmGoodsMgrDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmDebugBase, ComCtrls, StdCtrls, ExtCtrls,uLendingDefine,uGoodsRange,
  uDBLendingManage,uLCGoodsMgr;

type
  TFrmGoodsMgrDebug = class(TFrmDebugBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    LCCodeRange: TRsLCCodeRange;
    LCGoodsMgr: TRsLCGoodsMgr;
  public
    { Public declarations }
  published
    //����:1.6.11    ��ȡ���뷶Χ
    procedure CodeRange_Get();
    //����:1.6.12    ���ӱ�ŷ�Χ
    procedure CodeRange_Add();
    //����:1.6.13    �޸ı�ŷ�Χ
    procedure CodeRange_Update();
    //����:1.6.14    ɾ����ŷ�Χ
    procedure CodeRange_Delete();


    //����:1.6.1    ��ȡ��Ʒ����
    procedure GetGoodType();
    //����:1.6.2    ��ȡ��Ʒ״̬����
    procedure GetStateNames();
    //����:1.6.3    ������Ʒ
    procedure Send();
    //����:1.6.4    �黹��Ʒ
    procedure Recieve();
    //����:1.6.5    ��ѯ���ż�¼
    procedure QueryRecord();
    //����:1.6.6    ��ѯ��Ʒ��������ѽ������ʾ���������ѹ黹����ʾ��Ʒ���
    procedure QueryGoodsNow();
    //����:1.6.7    ��ѯ������ϸ
    procedure QueryDetails();
    //����:1.6.8    ��ȡͳ����Ϣ
    procedure GetTongJiInfo();
    //����:1.6.9    �ж�ָ����Ա�Ƿ���δ�黹����Ʒ
    procedure IsHaveNotReturnGoods();
    //����:1.6.10    ���ָ����Աδ�黹��Ʒ�б�
    procedure GetTrainmanNotReturnLendingInfo();
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
{ TFrmGoodsMgrDebug }

procedure TFrmGoodsMgrDebug.CodeRange_Add;
var
  RsGoodsRange: RRsGoodsRange;
  ErrInfo: string;
begin
  LCCodeRange.Add(RsGoodsRange,ErrInfo)
end;
procedure TFrmGoodsMgrDebug.CodeRange_Delete;
var
  ErrInfo: string;
begin
  LCCodeRange.Delete('',ErrInfo)
end;
procedure TFrmGoodsMgrDebug.CodeRange_Get;
var
  WorkShopGUID: String; lendingType: Integer;
  codeRangeArray: TRsGoodsRangeList;
begin
  lendingType := -1;
  WorkShopGUID := '3b50bf66-dabb-48c0-8b6d-05db80591090';
  LCCodeRange.Get(WorkShopGUID,lendingType,codeRangeArray);
end;

procedure TFrmGoodsMgrDebug.CodeRange_Update;
var
  RsGoodsRange: RRsGoodsRange;
  ErrInfo: string;
begin
  RsGoodsRange.strGUID := '81EF1F13-97C3-41CA-A9C2-547D5F9DA69C';
  RsGoodsRange.nLendingTypeID := 1;
  RsGoodsRange.nStartCode := 1;
  RsGoodsRange.nStopCode := 200;
  RsGoodsRange.strExceptCodes := '';
  RsGoodsRange.strWorkShopGUID := '3b50bf66-dabb-48c0-8b6d-05db80591090';

  LCCodeRange.Update(RsGoodsRange,ErrInfo)
end;

procedure TFrmGoodsMgrDebug.FormCreate(Sender: TObject);
begin
  inherited;
  LCCodeRange:= TRsLCCodeRange.Create(GlobalDM.WebAPIUtils);
  LCGoodsMgr:= TRsLCGoodsMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmGoodsMgrDebug.FormDestroy(Sender: TObject);
begin
  LCCodeRange.Free;
  LCGoodsMgr.Free;
  inherited;
end;

procedure TFrmGoodsMgrDebug.GetGoodType;
var
  lendingTypeList: TRsLendingTypeList;
begin
  lendingTypeList := TRsLendingTypeList.Create;
  try
    LCGoodsMgr.GetGoodType(lendingTypeList);
  finally
    lendingTypeList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.GetStateNames;
var
  returnStateList: TRsReturnStateList;
begin
  returnStateList := TRsReturnStateList.Create;
  try
    LCGoodsMgr.GetStateNames(returnStateList);
  finally
    returnStateList.Free;
  end;
end;

procedure TFrmGoodsMgrDebug.GetTongJiInfo;
var
  lendingTjList: TRslendingToJiList;
  WorkShopGUID: String;
begin
  lendingTjList := TRslendingToJiList.Create;
  try
    WorkShopGUID := '3b50bf66-dabb-48c0-8b6d-05db80591090';
    LCGoodsMgr.GetTongJiInfo(lendingTjList,WorkShopGUID);
  finally
    lendingTjList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.GetTrainmanNotReturnLendingInfo;
var
  TrainmanGUID: String;
  lendingDetailList: TRsLendingDetailList;
begin
  lendingDetailList := TRsLendingDetailList.Create;
  try
    TrainmanGUID := '92628EC8-DA00-4C46-A71F-16DCFF59C85A';
    LCGoodsMgr.GetTrainmanNotReturnLendingInfo(TrainmanGUID,lendingDetailList)
  finally
    lendingDetailList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.IsHaveNotReturnGoods;
var
  trainmanid: string;
begin
  trainmanid := '92628EC8-DA00-4C46-A71F-16DCFF59C85A';
  LCGoodsMgr.IsHaveNotReturnGoods(trainmanid);
end;

procedure TFrmGoodsMgrDebug.QueryDetails;
var
  queryParam: TRsDetailsQueryCondition;
  lendingDetailList: TRsLendingDetailList;
begin
  queryParam := TRsDetailsQueryCondition.Create;
  lendingDetailList := TRsLendingDetailList.Create;
  try
    LCGoodsMgr.QueryDetails(queryParam,lendingDetailList);
  finally
    queryParam.Free;
    lendingDetailList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.QueryGoodsNow;
var
  WorkShopGUID: String;
  GoodType,GoodID: Integer;
  orderType: TGoodsOrderType;
  lendingDetailList: TRsLendingDetailList;
begin
  lendingDetailList := TRsLendingDetailList.Create;
  try
    GoodType := 1;
    GoodID := 1;
    orderType := gotNumber;
    LCGoodsMgr.QueryGoodsNow(WorkShopGUID,GoodType,GoodID,orderType,lendingDetailList);
  finally
    lendingDetailList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.QueryRecord;
var
  queryParam: TRsQueryCondition;
  lendingInfoList: TRsLendingInfoList;
begin
  queryParam := TRsQueryCondition.Create;
  lendingInfoList := TRsLendingInfoList.Create;
  try
    LCGoodsMgr.QueryRecord(queryParam,lendingInfoList);
  finally
    lendingInfoList.Free;
    queryParam.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.Recieve;
var
  TrainmanGUID, remark: String;
  lendingDetailList: TRsLendingDetailList;
begin
  lendingDetailList := TRsLendingDetailList.Create;
  try
    LCGoodsMgr.Recieve(TrainmanGUID,remark,lendingDetailList);
  finally
    lendingDetailList.Free;
  end;

end;

procedure TFrmGoodsMgrDebug.Send;
var
  TrainmanGUID, WorkShopGUID, remark: String;
  UsesGoodsRange: Boolean;
  lendingDetailList: TRsLendingDetailList;
begin
  lendingDetailList := TRsLendingDetailList.Create;
  try
    UsesGoodsRange := True;
    LCGoodsMgr.Send(TrainmanGUID, WorkShopGUID, remark,UsesGoodsRange,lendingDetailList);
  finally
    lendingDetailList.Free;
  end;

end;

initialization
  ChildFrmMgr.Reg(TFrmGoodsMgrDebug);
end.
