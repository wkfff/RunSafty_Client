unit uGroupTrainmanIndex;

interface

type

  TRsGroupTrainmanIndex = record
    //��GUID
    strGroupGUID:string;
    //trainman GUID
    strTrainmanGUID:string;
    //˾������ 1,2,3,4
    nTrainmanIndex:Integer;
    //����ʱ��
    dtCreateTime:TDateTime;
    //ֵ��ԱGUID
    strDutyUserGUID:string;
    //ֵ��Ա����
    strDutyUserName:string;
    //��λGUID
    strSiteGUID:string;
    //��λ��
    strSiteName:string;
  end;

  TRsGroupTrainmanIndexArray  = array of TRsGroupTrainmanIndex  ;

implementation

end.
