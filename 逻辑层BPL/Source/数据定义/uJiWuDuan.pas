unit uJiWuDuan;

interface

type
  //�������Ϣ
  RsJiWuDuan = record
    nID:Integer ;
    strJWDName:string;   //������
    strJWDNumber:string;  //�κ�
    strIp:string;          //ip
    nWebHtmlPort:Integer; //��ҳ�˿�
    nWebApiPort:Integer;  //�ӿڶ˿�
  end;

  TRsJiWuDuanArray = array of RsJiWuDuan ;

implementation

end.
