unit uPoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfPoints = class(TForm)
    lvPoints: TListView;
    btnEdit: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure lvPointsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowPoints;
  end;

var
  fPoints: TfPoints;

implementation

uses uMain;

{$R *.dfm}

procedure TfPoints.ShowPoints;
var
  i: Integer;
begin
  lvPoints.Items.Clear;
  for i := 0 to fMain.ZM01.PointsList.Count - 1 do
    with lvPoints.Items.Add do
    begin
      Caption := fMain.ZM01.PointsList[i].UName;
      SubItems.Add(Format('%3.2f', [fMain.ZM01.PointsList[i].X]));
      SubItems.Add(Format('%3.2f', [fMain.ZM01.PointsList[i].Y]));
    end;
end;

procedure TfPoints.btnEditClick(Sender: TObject);
begin
  if (lvPoints.ItemIndex < 0) or
     (lvPoints.Items[lvPoints.ItemIndex].Caption = '') then Exit;
  try
    fMain.EditPoint(fMain.ZM01.PointsList[lvPoints.ItemIndex]);
  finally
    ShowPoints;
  end;
end;

procedure TfPoints.Button2Click(Sender: TObject);
begin
  fMain.aAddPointFormula.Execute;
  ShowPoints;
end;

procedure TfPoints.Button4Click(Sender: TObject);
begin
  fMain.aAddPointXY.Execute;
  ShowPoints;
end;

procedure TfPoints.Button3Click(Sender: TObject);
begin
  if (lvPoints.ItemIndex < 0) or
     (lvPoints.Items[lvPoints.ItemIndex].Caption = '') then Exit;
  try
    fMain.ZM01.PointsList.Selected := lvPoints.ItemIndex;
    fMain.aDeletePoint.Execute;
  finally
    ShowPoints;
  end;
end;

procedure TfPoints.lvPointsDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

end.
