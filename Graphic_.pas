unit Graphic_;

interface

uses
  BookOption_, SysUtils, Windows, Graphics, Controls, ExtCtrls;

procedure Draw(Canvas: TCanvas; PageOption: TPageOption;
  ABitmap: TBitmap);

procedure Clear(Image: TImage);

implementation


procedure Draw(Canvas: TCanvas; PageOption: TPageOption;
  ABitmap: TBitmap);
  function RlcPrm(Percent, Value: Integer):Integer;
  begin
    Result := Round(Value - Percent * Value / 1000);
  end;
var
  Header, Bits: Pointer;
  HeaderSize: DWORD;
  BitsSize: DWORD;
  Left_,
  Top_,
  Right_,
  Bottom_,
  zoom_,
  X,
  Y,
  Width_,
  Height_: Integer;
  RelationPrinterToSource: Real;
begin
  GetDIBSizes(ABitmap.Handle, HeaderSize, BitsSize);
  Header := AllocMem(HeaderSize);
  Bits := AllocMem(BitsSize);
  try
    GetDIB(ABitmap.Handle, ABitmap.Palette, Header^, Bits^);
    with PageOption, Canvas.ClipRect do
    begin
      Right_ := Right;
      Bottom_ := Bottom;
      zoom_ := zoom;

      RelationPrinterToSource := Bottom / ABitmap.Height;
      StretchDIBits(
        Canvas.Handle,
        // вначале область куда выводим
        {смещение по X}RlcPrm(shift.X, Right_) ,
        {смещение по Y}RlcPrm(shift.Y, Bottom_),
        RlcPrm(zoom_, Trunc(RelationPrinterToSource * ABitmap.Width)), // ширина
        RlcPrm(zoom_, Bottom_), // высота

        // теперь область того что выводим
        Left, Top, ABitmap.Width, ABitmap.Height,
        Bits, TBitmapInfo(Header^), DIB_RGB_COLORS, SRCCOPY
      );
    end;
  finally
    FreeMem(Header, HeaderSize);
    FreeMem(Bits, BitsSize);
  end;
end;

procedure Clear(Image: TImage);
begin
  with Image do
    PatBlt(Canvas.Handle, 0, 0, ClientWidth, ClientHeight, WHITENESS);
end;

end.
