unit uDrink;
interface
uses
  Classes,ZKFPEngXUtils,uApparatusCommon;
type
  //��Ƽ�¼��ѯ
  RRsDrink = Record
    //��Ƽ�¼GUID
    strGUID : string;
    //�Ƿ��Ǳ�����Ա
    bLocalAreaTrainman:boolean;
    //����ԱGUID
    strTrainmanGUID : string;
    //��Ա����
    strTrainmanName : string;
    //��Ա����
    strTrainmanNumber : string;
    //�ƾ���(mg/100ml)
    dwAlcoholicity : Integer ;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;

    //��Ƶص�
    strPlaceID : string ;
    //��Ƶص�����
    strPlaceName: string ;

    //�ͻ��˱��
    strSiteGUID : string;
    //�ͻ���IP
    strSiteIp : string;
    //�ͻ�������
    strSiteName : string;

    //������������
    strWorkShopName : string;
    //��������
    strWorkShopGUID : string ;

    //��ƽ��
    nDrinkResult : integer;
    //��ƽ������
    strDrinkResultName : string;
    //���ʱ��
    dtCreateTime : TDateTime;
    //�����Ƭ
    DrinkImage : OleVariant;
    //�������
    strAreaGUID : string;
    //ֵ��ԱGUID
    strDutyGUID : string;
    //ֵ��Ա����
    strDutyNumber:string;
    //ֵ��Ա����
    strDutyName : string ;
    //��֤��ʽ
    nVerifyID : integer;
    //��֤��������
    strVerifyName : string;
    //��������GUID
    strWorkID : string;
    //�������
    nWorkTypeID : integer;
    //�����������
    strWorkTypeName : string;
    //�����ƬURL
    strPictureURL: string;
    //��ע
    strRemark: string;

    //��������ID
    strDepartmentID: string;
    //������������
    strDepartmentName: string;

    //ְ��ID
    nCadreTypeID: integer;
    //ְ������
    strCadreTypeName: string;

  public
    procedure SetPicture(Picture: TMemoryStream);
    procedure ReadPicture(Stream: TMemoryStream);
    procedure AssignFromTestAlcoholInfo(TestAlcoholInfo: RTestAlcoholInfo);
  End;
  TRsDrinkArray = array of RRsDrink;
  
implementation

{ RRsDrink }

procedure RRsDrink.AssignFromTestAlcoholInfo(TestAlcoholInfo: RTestAlcoholInfo);
begin
  nDrinkResult := Ord(TestAlcoholInfo.taTestAlcoholResult);
  DrinkImage := TestAlcoholInfo.Picture;
  dtCreateTime := TestAlcoholInfo.dtTestTime;

  dwAlcoholicity := TestAlcoholInfo.nAlcoholicity;
end;

procedure RRsDrink.ReadPicture(Stream: TMemoryStream);
begin
  TemplateOleVariantToStream(DrinkImage,Stream);
end;

procedure RRsDrink.SetPicture(Picture: TMemoryStream);
begin
  DrinkImage := StreamToTemplateOleVariant(Picture)
end;

end.
