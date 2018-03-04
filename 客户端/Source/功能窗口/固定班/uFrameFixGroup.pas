unit uFrameFixGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, Menus;

type
  TFrameFixGroup = class(TFrame)
    StringGrid: TAdvStringGrid;
    PopupMenu: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init();
  end;

implementation

{$R *.dfm}

{ TFrameFixGroup }

procedure TFrameFixGroup.Init;
begin
  StringGrid.ClearRows(StringGrid.FixedRows,StringGrid.RowCount - StringGrid.FixedRows);
  
  StringGrid.RowCount := StringGrid.FixedRows + 1;
end;

end.
