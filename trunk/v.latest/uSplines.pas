unit uSplines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ZSewing;

type
  TfSplines = class(TForm)
    lvSplines: TListView;
    btnEdit: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowSplines;
  end;

var
  fSplines: TfSplines;

const
  LType: array[0..1] of string = ('ламана', 'сплайн');  

implementation

uses uMain;

{$R *.dfm}

procedure TfSplines.ShowSplines;
var
  i: Integer;
begin
  lvSplines.Items.Clear;
  for i := 0 to fMain.ZM01.SplinesList.Count - 1 do
    with lvSplines.Items.Add do
    begin
      Caption := fMain.ZM01.SplinesList[i].Title;
      SubItems.Add(LType[ord(fMain.ZM01.SplinesList[i].SplineType)]);
      if fMain.ZM01.SplinesList[i].SplineType = ltSpline
        then SubItems.Add(Format('%1.3f', [fMain.ZM01.SplinesList[i].Tension]))
        else SubItems.Add('');
    end;
end;

procedure TfSplines.btnEditClick(Sender: TObject);
begin
  if (lvSplines.ItemIndex < 0) or
     (lvSplines.Items[lvSplines.ItemIndex].Caption = '') then Exit;
  try
    fMain.EditSpline( fMain.ZM01.SplinesList[lvSplines.ItemIndex]);
  finally
    ShowSplines;
  end;
end;

procedure TfSplines.Button2Click(Sender: TObject);
begin
  fMain.AddSpline;
  ShowSplines;
end;

procedure TfSplines.Button3Click(Sender: TObject);
begin
  if (lvSplines.ItemIndex < 0) or
     (lvSplines.Items[lvSplines.ItemIndex].Caption = '') then Exit;
  try
    fMain.DeleteSpline( fMain.ZM01.SplinesList[lvSplines.ItemIndex]);
  finally
    ShowSplines;
  end;
end;

end.
