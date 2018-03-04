unit uJiWuDuan;

interface

type
  //机务段信息
  RsJiWuDuan = record
    nID:Integer ;
    strJWDName:string;   //段名字
    strJWDNumber:string;  //段号
    strIp:string;          //ip
    nWebHtmlPort:Integer; //网页端口
    nWebApiPort:Integer;  //接口端口
  end;

  TRsJiWuDuanArray = array of RsJiWuDuan ;

implementation

end.
