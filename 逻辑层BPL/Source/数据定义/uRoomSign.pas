unit uRoomSign;

interface
uses
  Classes,Contnrs;
type
  TRsRoomSignType = (stInRoom{��Ԣ},stOutRoom{��Ԣ});
  RRsRoomSign = record
    strInRoomGUID: string;
    strTrainPlanGUID: string;
    strTrainmanGUID: string;
    dtInRoomTime: TDateTime;
    nInRoomVerifyID: string;
    strDutyUserGUID: string;
    strTrainmanNumber: string;
    strTrainmanName: string;
    SignType: TRsRoomSignType;
  end;
  TRsRoomSignArray = array of RRsRoomSign;

  // add by lyq
  //2014-06-13

  //��λ��Ϣ
  RRsBedInfo = record
    strRoomNumber:string;
    dtInRoomTime:TDateTime;
    strTrainmanGUID:string;
    strTrainmanName:string;
    strTrainmanNumber:string;
    nBedNumber:Integer;
  end;

  RRsBedInfoPointer = ^RRsBedInfo  ;

  TRsBedInfoList = array [0..2]  of  RRsBedInfo ;
  TRsBedInfoArray = array of   RRsBedInfo ;

  //������Ϣ
  RRsRoomInfo = record
    nID:Integer;
    strRoomNumber:string;           //�����
    listBedInfo: TRsBedInfoList ;   //��λ��Ϣ
  end;

  TRsRoomInfoArray = array of RRsRoomInfo;


  TRsRoomSign = class
  public
    strPlanGUID : string ;    //�ƻ�GUID
    strInRoomGUID: string;      //��ԢGUID
    strOutRoomGUID: string;     //�뿪��ԢGUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //����ԱGUID
    dtInRoomTime: TDateTime;    //��Ԣʱ��
    dtOutRoomTime: TDateTime;   //��Ԣʱ��
    nInRoomVerifyID: Integer;    //��Ԣ��ʽ
    nOutRoomVerifyID: Integer;   //��Ԣ��ʽ
    strDutyUserGUID: string;    //ֵ��ԱGUID
    strDutyUserName:string;     //ֵ��Ա����
    strSiteGUID:string;
    strTrainmanNumber: string;  //����Ա����
    strTrainmanName: string;    //����Ա����
    strRoomNumber:string;     //������
    nBedNumber:Integer;        //��λ���
  end;

  TRsRoomSignList = class (TObjectList)
  protected
    procedure SetItem(Index:Integer;AObject:TRsRoomSign);
    function  GetItem(Index:Integer):TRsRoomSign;
  public
    function Add(AObject: TRsRoomSign): Integer;
    property Items[Index:Integer] : TRsRoomSign  read GetItem write SetItem;
  end;



  
  //��Ԣ����
  {��Ԣ��Ϣ}
  TRsInRoomInfo = record
    strInRoomGUID: string;      //��ԢGUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //����ԱGUID
    dtInRoomTime: TDateTime;    //��Ԣʱ��
    nInRoomVerifyID: Integer;    //��Ԣ��ʽ
    strDutyUserGUID: string;    //ֵ��ԱGUID
    strDutyUserName:string;
    strSiteGUID:string;
    strTrainmanNumber: string;  //����Ա����
    strRoomNumber:string;     //������
    nBedNumber:Integer;        //��λ���
    nIsOutRoom:Integer;       //�Ƿ��Ѿ���Ԣ
    dtCreatetTime:TDateTime;
  end;

  TRsInRoomInfoArray = array of TRsInRoomInfo;

  {��Ԣ��Ϣ}
  TRsOutRoomInfo = record
    strInRoomGUID: string;      //��ԢGUID
    strOutRoomGUID: string;     //�뿪��ԢGUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //����ԱGUID
    dtOutRoomTime: TDateTime;   //��Ԣʱ��
    nOutRoomVerifyID: Integer;   //��Ԣ��ʽ
    strDutyUserGUID: string;    //ֵ��ԱGUID
    strDutyUserName:string;
    strSiteGUID:string;
    strTrainmanNumber: string;  //����Ա����
    dtCreatetTime:TDateTime;
  end;

  TRsOutRoomInfoArray = array of TRsOutRoomInfo;
  //


implementation

{ TRoomSignInOutList }



function TRsRoomSignList.Add(AObject: TRsRoomSign): Integer;
begin
  Result := inherited  Add(AObject)  ;
end;

function TRsRoomSignList.GetItem(Index: Integer): TRsRoomSign;
begin
  Result := TRsRoomSign ( inherited GetItem(Index)) ;
end;

procedure TRsRoomSignList.SetItem(Index: Integer; AObject: TRsRoomSign);
begin
  inherited SetItem(Index,AObject);
end;

end.
