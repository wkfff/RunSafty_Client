unit uGroupDragObject;

interface
uses
  Controls,uTrainmanJiaolu;
type
  //机组拖拽数据类
  TGroupDragObject = class(TDragObjectEx)
  public
    //机组信息
    GroupInfo : RRsGroup;
  end;
implementation

end.
