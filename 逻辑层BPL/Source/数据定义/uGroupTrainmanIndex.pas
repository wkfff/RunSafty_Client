unit uGroupTrainmanIndex;

interface

type

  TRsGroupTrainmanIndex = record
    //组GUID
    strGroupGUID:string;
    //trainman GUID
    strTrainmanGUID:string;
    //司机种类 1,2,3,4
    nTrainmanIndex:Integer;
    //创建时间
    dtCreateTime:TDateTime;
    //值班员GUID
    strDutyUserGUID:string;
    //值班员名字
    strDutyUserName:string;
    //岗位GUID
    strSiteGUID:string;
    //岗位人
    strSiteName:string;
  end;

  TRsGroupTrainmanIndexArray  = array of TRsGroupTrainmanIndex  ;

implementation

end.
