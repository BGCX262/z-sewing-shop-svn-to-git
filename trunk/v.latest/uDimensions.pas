unit uDimensions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TfDimensions = class(TForm)
    lvDimensions: TListView;
    btnEdit: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure lvDimensionsDblClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowDimensions;
  end;

var
  fDimensions: TfDimensions;

implementation

uses uMain, uSetDim;

{$R *.dfm}

procedure TfDimensions.ShowDimensions;
var
  i: Integer;
begin
  lvDimensions.Items.Clear;
  for i := 0 to fMain.ZM01.DimensionList.Count - 1 do
    with lvDimensions.Items.Add do
    begin
      Caption := fMain.ZM01.DimensionList[i].Title;
      SubItems.Add(fMain.ZM01.DimensionList[i].UName);
      SubItems.Add(Format('%3.2f', [fMain.ZM01.DimensionList[i].Value]));
    end;
end;

procedure TfDimensions.lvDimensionsDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

procedure TfDimensions.btnEditClick(Sender: TObject);
begin
  if (lvDimensions.ItemIndex < 0) or
     (lvDimensions.Items[lvDimensions.ItemIndex].Caption = '') then Exit;
  try
    fMain.EditDimension( fMain.ZM01.DimensionList[lvDimensions.ItemIndex]);
  finally
    ShowDimensions;
  end;
end;

procedure TfDimensions.Button2Click(Sender: TObject);
begin
  fMain.AddDimension;
  ShowDimensions;
end;

procedure TfDimensions.Button3Click(Sender: TObject);
begin
  if (lvDimensions.ItemIndex < 0) or
     (lvDimensions.Items[lvDimensions.ItemIndex].Caption = '') then Exit;
  try
    fMain.DeleteDimension(fMain.ZM01.DimensionList[lvDimensions.ItemIndex]);
  finally
    ShowDimensions;
  end;
end;

end.
