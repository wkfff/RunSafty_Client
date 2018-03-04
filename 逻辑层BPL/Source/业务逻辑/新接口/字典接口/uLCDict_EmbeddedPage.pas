unit uLCDict_EmbeddedPage;

interface
uses
  uTrainType,Classes,SysUtils,uBaseWebInterface,superobject,Contnrs,
  uJsonSerialize;
type
  TEmbeddedPage = class(TPersistent)
  private
    m_Catalog: string;
    m_Caption: string;
    m_URL: string;
    m_ClientJobType: integer;
  published
    property Catalog: string read m_Catalog write m_Catalog;
    property Caption: string read m_Caption write m_Caption;
    property URL: string read m_URL write m_URL;
    property ClientJobType: integer read m_ClientJobType write m_ClientJobType;
  end;

  TEmbeddedPageList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TEmbeddedPage;
    procedure SetItem(Index: Integer; AObject: TEmbeddedPage);
  public
    property Items[Index: Integer]: TEmbeddedPage read GetItem write SetItem; default;
  end;
         
  //机车类型
  TRsLCEmbeddedPage = class(TBaseWebInterface)
  public
    procedure GetPageItems(ClientJobType: integer;PageList: TEmbeddedPageList);
  end;
implementation
function TEmbeddedPageList.GetItem(Index: Integer): TEmbeddedPage;
begin
  result := TEmbeddedPage(inherited GetItem(Index));
end;
procedure TEmbeddedPageList.SetItem(Index: Integer; AObject: TEmbeddedPage);
begin
  Inherited SetItem(Index,AObject);
end;       
{ TRsLCEmbeddedPage }

procedure TRsLCEmbeddedPage.GetPageItems(ClientJobType: integer;
  PageList: TEmbeddedPageList);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  PageList.Clear;
  json := CreateInputJson;
  json.I['ClientJobType'] := ClientJobType;
  
  strResult := Post('TF.Runsafty.LCEmbeddedPages.GetPageItems',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  TJsonSerialize.DeSerialize(json,PageList,TEmbeddedPage);
end;
end.
