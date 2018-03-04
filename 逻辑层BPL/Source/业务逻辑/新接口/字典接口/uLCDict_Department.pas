unit uLCDict_Department;

interface
uses
  uTrainType,Classes,SysUtils,uBaseWebInterface,superobject,Contnrs,
  uJsonSerialize;
type

  TDepartment = class(TPersistent)
  private
    m_ID: string;
    m_Name: string;
    m_DType: integer;
  published
    property ID: string read m_ID write m_ID;
    property Name: string read m_Name write m_Name;
    //DType 0为普通部门  1为运用车间
    property DType: integer read m_DType write m_DType;
  end;

  
  TRsLCDepartment = class(TBaseWebInterface)
  public
    procedure Query(DepartmentLst: TObjectList); 
  end;

  
implementation

{ TRsLCDepartment }

procedure TRsLCDepartment.Query(DepartmentLst: TObjectList);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  DepartmentLst.Clear;
  strResult := Post('TF.RunSafty.BaseDict.LCDepartment.Query','');

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;
  TJsonSerialize.DeSerialize(json,DepartmentLst,TDepartment);
end;

end.
