unit test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, GDIPAPI, GDIPOBJ;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure CreateFigure(Gdi: TGPGraphics);
    procedure Paint;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ox, oy: integer;

implementation

{$R *.dfm}

procedure TForm1.CreateFigure(Gdi: TGPGraphics);
var
  SolidBrush: TGPSolidBrush;
  Pen: TGPPen;
begin
  Pen := TGPPen.Create(MakeColor(100, 0, 0, 255));
  SolidBrush := TGPSolidBrush.Create(MakeColor(150, 255, 0, 0));
  Gdi.DrawLine(Pen, ox, oy, ox+100, oy+100);
  Gdi.FillEllipse(SolidBrush, ox-3, oy-3, 6, 6);
  Pen.Free;
  SolidBrush.Free;
end;

procedure TForm1.Paint;
var
  graphics_buf: TGPGraphics;
  graphics : TGPGraphics;
  graphics_img: TGPBitmap;
begin
  graphics:= TGPGraphics.Create(Self.Canvas.Handle);
  graphics_img:= TGPBitmap.Create(ClientWidth, ClientHeight, PixelFormat32bppRGB);
  graphics_buf:= TGPGraphics.Create(graphics_img);
  graphics_buf.SetSmoothingMode(SmoothingModeAntiAlias);
  graphics_buf.Clear(MakeColor(255, 255, 255, 255));
  CreateFigure(graphics_buf);
  graphics_buf.Free;
  graphics.DrawImage(graphics_img, 0, 0);
  graphics.Free;
  graphics_img.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  ox:=ox+2;
  oy:=oy+2;
  if ox>=300 then ox:=0;
  if oy>=300 then oy:=0;
  Paint;
end;

end.


