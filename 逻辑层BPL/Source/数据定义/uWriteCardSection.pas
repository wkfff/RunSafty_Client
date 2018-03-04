unit uWriteCardSection;

interface

type
  //写卡区段
  RRsWriteCardSection = record
    //所属机务段号
    strJWDNumber : string;
    //区段ID
    strSectionID : string;
    //区段名称
    strSectionName : string;
  end;
  TRsWriteCardSectionArray = array of RRsWriteCardSection;
implementation

end.
