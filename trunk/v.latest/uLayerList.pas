unit uLayerList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfLayerList = class(TForm)
    lvLayers: TListView;
    Button3: TButton;
    btnEdit: TButton;
    Button5: TButton;
    procedure lvLayersCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lvLayersDblClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowLayers;
  end;

var
  fLayerList: TfLayerList;

implementation

uses uMain, ZSewing;

{$R *.dfm}

procedure TfLayerList.lvLayersCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if SubItem = 1 then
    lvLayers.Canvas.Font.Color := fMain.ZM01.LayerList[Item.Index].Color
  else
    lvLayers.Canvas.Font.Color := clBlack;
end;

procedure TfLayerList.ShowLayers;
var
  i: Integer;
begin
    lvLayers.Items.Clear;
    for i := 0 to fmain.ZM01.LayerList.Count - 1 do
      with lvLayers.Items.Add do
      begin
        Caption := fmain.ZM01.LayerList[i].Title;
        SubItems.Add(
          Format('(%d; %d; %d)',
          [GetRValue(fmain.ZM01.LayerList[i].Color),
           GetGValue(fmain.ZM01.LayerList[i].Color),
           GetBValue(fmain.ZM01.LayerList[i].Color)])
        );
        SubItems.Add(IntToStr(fmain.ZM01.LayerList[i].Width));
      end;
end;

procedure TfLayerList.Button3Click(Sender: TObject);
begin
  fMain.AddLayer;
  ShowLayers;
end;

procedure TfLayerList.btnEditClick(Sender: TObject);
begin
  if (lvLayers.ItemIndex < 0) or
     (lvLayers.Items[lvLayers.ItemIndex].Caption = '') then Exit;
  try
    fMain.EditLayer(fMain.ZM01.LayerList[lvLayers.ItemIndex]);
  finally
    ShowLayers;
  end;
end;

procedure TfLayerList.lvLayersDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

procedure TfLayerList.Button5Click(Sender: TObject);
begin
  if (lvLayers.ItemIndex < 0) or
     (lvLayers.Items[lvLayers.ItemIndex].Caption = '') then Exit;
  try
    fMain.DeleteLayer(fMain.ZM01.LayerList[lvLayers.ItemIndex]);
  finally
    ShowLayers;
  end;
end;

end.
