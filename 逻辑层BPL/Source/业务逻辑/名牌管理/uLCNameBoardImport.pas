unit uLCNameBoardImport;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uJsonSerialize,Contnrs;
type

  TNPTMImport = class(TPersistent)
  private
    m_strtmid: string;
    m_strtmName: string;
  published
    property tmid: string read m_strtmid write m_strtmid;
    property tmName: string read m_strtmName write m_strtmName;
  end;


  TNPGrpImport = class(TPersistent)
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_strgrpGUID: string;
    m_norder: integer;
    m_strcc1: string;
    m_strcc2: string;
    m_nccType: integer;
    m_tm1: TNPTMImport;
    m_tm2: TNPTMImport;
    m_tm3: TNPTMImport;
    m_tm4: TNPTMImport;
  published
    property grpGUID: string read m_strgrpGUID write m_strgrpGUID;
    property order: integer read m_norder write m_norder;
    property cc1: string read m_strcc1 write m_strcc1;
    property cc2: string read m_strcc2 write m_strcc2;
    property ccType: integer read m_nccType write m_nccType;
    property tm1: TNPTMImport read m_tm1 write m_tm1;
    property tm2: TNPTMImport read m_tm2 write m_tm2;
    property tm3: TNPTMImport read m_tm3 write m_tm3;
    property tm4: TNPTMImport read m_tm4 write m_tm4;
  end;


  TNPGrpImportList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TNPGrpImport;
    procedure SetItem(Index: Integer; AObject: TNPGrpImport);
  public
    property Items[Index: Integer]: TNPGrpImport read GetItem write SetItem; default;
  end;
                
  
  TLCNameBoardImporter = class(TWepApiBase)
  public
    procedure Import(jlGUID,jlName,siteNumber: string;GrpList: TNPGrpImportList);
  end;
implementation

{ TLCNameBoardImporter }

procedure TLCNameBoardImporter.Import(jlGUID,jlName,siteNumber: string;GrpList: TNPGrpImportList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['jlGUID'] := jlGUID;
  JSON.S['jlName'] := jlName;
  JSON.S['siteNumber'] := siteNumber;
  JSON.O['groups'] := TJsonSerialize.Serialize(GrpList);
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.NameGroup.ImportNamed',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;



function TNPGrpImportList.GetItem(Index: Integer): TNPGrpImport;
begin
  result := TNPGrpImport(inherited GetItem(Index));
end;
procedure TNPGrpImportList.SetItem(Index: Integer; AObject: TNPGrpImport);
begin
  Inherited SetItem(Index,AObject);
end;                    
{ TNPGrpImport }

constructor TNPGrpImport.Create;
begin
  m_tm1 := TNPTMImport.Create;
  m_tm2 := TNPTMImport.Create;
  m_tm3 := TNPTMImport.Create;
  m_tm4 := TNPTMImport.Create;
end;

destructor TNPGrpImport.Destroy;
begin
  m_tm1.Free;
  m_tm2.Free;
  m_tm3.Free;
  m_tm4.Free;
  inherited;
end;

end.
