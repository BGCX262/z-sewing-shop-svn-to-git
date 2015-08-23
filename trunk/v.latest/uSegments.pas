unit uSegments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfSegments = class(TForm)
    lvSegments: TListView;
    btnEdit: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnEditClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lvSegmentsDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowSegments;
  end;

var
  fSegments: TfSegments;

implementation

uses uMain;

{$R *.dfm}

procedure TfSegments.ShowSegments;
var
  i: Integer;
begin
  lvSegments.Items.Clear;
  for i := 0 to fMain.ZM01.SegmentList.Count - 1 do
    with lvSegments.Items.Add do
    begin
      Caption := fMain.ZM01.SegmentList[i].Title;
      SubItems.Add(Format('%3.2f', [fMain.ZM01.SegmentList[i].Length]));
    end;
end;

procedure TfSegments.btnEditClick(Sender: TObject);
begin
  if (lvSegments.ItemIndex < 0) or
     (lvSegments.Items[lvSegments.ItemIndex].Caption = '') then Exit;
  try
    fMain.EditSegment( fMain.ZM01.SegmentList[lvSegments.ItemIndex]);
  finally
    ShowSegments;
  end;
end;

procedure TfSegments.Button2Click(Sender: TObject);
begin
  fMain.AddSegment;
  ShowSegments;
end;

procedure TfSegments.lvSegmentsDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

procedure TfSegments.Button3Click(Sender: TObject);
begin
  if (lvSegments.ItemIndex < 0) or
     (lvSegments.Items[lvSegments.ItemIndex].Caption = '') then Exit;
  try
    fMain.DeleteSegment( fMain.ZM01.SegmentList[lvSegments.ItemIndex]);
  finally
    ShowSegments;
  end;
end;

end.
