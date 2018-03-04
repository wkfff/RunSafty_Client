unit uLCDDMLConfirm;

interface

uses
  SysUtils,Classes,uDrink,utfsystem,uTrainman,uTrainPlan,superobject,
  uBaseWebInterface,uSaftyEnum,uApparatusCommon,uTrainmanJiaolu,uEndWork,
  uDDMLConfirm;

type
  //���������߼������
  TRsLCDDMLConfirm = class(TBaseWebInterface)
  public
    {����:�������ͨ��}
    function ConfirmDDML(ddmlConfirm:TDDML_Confirm;out ErrStr:string):Boolean;

  private
    //����:����(��˵���)�ӿ��������JSON�ַ���
    function EnConfirmDDMLInputJSON(DBDDML_Confirm : TDDML_Confirm):String;
  end;

implementation

{ TRsLCDDML }

function TRsLCDDMLConfirm.ConfirmDDML(ddmlConfirm:TDDML_Confirm; out ErrStr:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;

  strInput:string;
begin
  Result := False ;
  json := CreateInputJson;
  try
    strInput := EnConfirmDDMLInputJSON(ddmlConfirm);
    strResult := Post('TF.RunSafty.LCDDML.ConfirmDDML',strInput);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCDDMLConfirm.EnConfirmDDMLInputJSON(DBDDML_Confirm : TDDML_Confirm):String;
//����:����(��˵���)�ӿ��������JSON�ַ���
var
    ItemJSON : ISuperObject;
    JSON : ISuperObject;
begin
    Result := '';
    JSON := SO('{}');
    try
        ItemJSON := SO('{}');
        ItemJSON.I['nID'] := DBDDML_Confirm.nID;
        ItemJSON.S['strGUID'] := DBDDML_Confirm.strGUID;
        ItemJSON.S['strWorkShopGUID'] := DBDDML_Confirm.strWorkShopGUID;
        ItemJSON.S['strWorkShopNumber'] := DBDDML_Confirm.strWorkShopNumber;
        ItemJSON.S['strWorkShopName'] := DBDDML_Confirm.strWorkShopName;
        ItemJSON.S['dtConfirmTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',DBDDML_Confirm.dtConfirmTime);
        ItemJSON.S['strDutyUserNumber'] := DBDDML_Confirm.strDutyUserNumber;
        ItemJSON.S['strDutyUserName'] := DBDDML_Confirm.strDutyUserName;
        JSON.O['DDML_Confirm'] := ItemJSON;
        Result := JSON.AsString;
    finally
        JSON := nil;
    end;
end;

end.
