unit uPaintPopUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfPaintPopUp = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPaintPopUp: TfPaintPopUp;

implementation

uses uMain, ZSewing;

{$R *.dfm}

procedure TfPaintPopUp.SpeedButton1Click(Sender: TObject);
var
  k: Integer;
begin
  Close;
  k := fMain.ZM01.PointsList.Add('p', fMain.ZM01.PointsList.Selected, '0', '10',
    ptLine, -1, 0, 0, false);
  fMain.ZM01.PointsList[k].ShowSpline := True;
  fMain.aEditPoint.Execute;
end;

procedure TfPaintPopUp.SpeedButton2Click(Sender: TObject);
begin
  Close;
  fMain.aAddPointXY.Execute;
end;

procedure TfPaintPopUp.SpeedButton3Click(Sender: TObject);
begin
  Close;
  fMain.aEditPoint.Execute;
end;

procedure TfPaintPopUp.SpeedButton4Click(Sender: TObject);
begin
  Close;
  fMain.aDeletePoint.Execute;
end;

procedure TfPaintPopUp.SpeedButton5Click(Sender: TObject);
var
  k: Integer;
begin
  Close;
  k := fMain.ZM01.PointsList.Add('p', fMain.ZM01.PointsList.Selected, '90', '10',
    ptLine, -1, 0, 0, false);
  fMain.ZM01.PointsList[k].ShowSpline := True;
  fMain.aEditPoint.Execute;
end;

procedure TfPaintPopUp.SpeedButton6Click(Sender: TObject);
var
  k: Integer;
begin
  Close;
  k := fMain.ZM01.PointsList.Add('p', fMain.ZM01.PointsList.Selected, '180', '10',
    ptLine, -1, 0, 0, false);
  fMain.ZM01.PointsList[k].ShowSpline := True;
  fMain.aEditPoint.Execute;
end;

procedure TfPaintPopUp.SpeedButton7Click(Sender: TObject);
var
  k: Integer;
begin
  Close;
  k := fMain.ZM01.PointsList.Add('p', fMain.ZM01.PointsList.Selected, '270', '10',
    ptLine, -1, 0, 0, false);
  fMain.ZM01.PointsList[k].ShowSpline := True;
  fMain.aEditPoint.Execute;
end;

end.
