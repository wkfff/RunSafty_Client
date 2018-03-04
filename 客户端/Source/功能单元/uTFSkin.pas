unit uTFSkin;

interface
uses
  RzPanel,Windows,RzCommon,Graphics,RzTabs,advGrid;
type
  TtfSkin = class
  public
    class procedure InitRzPanel(P : TRzPanel);
    class procedure InitRzTab(T : TRzTabControl);
    class procedure InitAdvGrid(Grid : TAdvStringGrid);
  end;

implementation

uses BaseGrid, Grids;

{ TtfSkin }

class procedure TtfSkin.InitAdvGrid(Grid: TAdvStringGrid);
begin
  with Grid do
  begin
    GridLineColor := Rgb(136,181,210);
    FixedColor := Rgb(239,244,248);
    with FixedFont do
    begin
      color := Rgb(4,46,83);
      Style := [];
      size := 12;
    end;
  end;
end;

class procedure TtfSkin.InitRzPanel(P: TRzPanel);
begin
  with P do
  begin
    VisualStyle := vsGradient;
    GradientDirection := gdHorizontalEnd;
    GradientColorStyle := gcsCustom;
    GradientColorStart := Rgb(57,162,227);
    GradientColorStop := Rgb(54,128,193);
    Font.Color := clwhite;
  end;
end;

class procedure TtfSkin.InitRzTab(T: TRzTabControl);
begin
   with T do
   begin
     BackgroundColor := Rgb(195,220,240);
     TabStyle := tsRoundCorners;
     SoftCorners := true;
     FlatColor := Rgb(141,171,199);
     with TextColors do
     begin
       Disabled := clGrayText;
       Selected := Rgb(15,39,65);
       Unselected := Rgb(3,38,70);
     end;
     with TabColors do
     begin
       HighlightBar := Rgb(54,128,193);
     end;
     Height := 25;
     Parent.Height := 25;
   end;
end;

end.
