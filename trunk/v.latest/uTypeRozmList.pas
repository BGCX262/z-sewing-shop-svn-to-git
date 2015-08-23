unit uTypeRozmList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfTypeRozmList = class(TForm)
    Label1: TLabel;
    cbSizes: TComboBox;
    lvDimensions: TListView;
    Button2: TButton;
    Button3: TButton;
    btnEdit: TButton;
    Button5: TButton;
    procedure Button3Click(Sender: TObject);
    procedure cbSizesChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTypeRozmList: TfTypeRozmList;

implementation

uses uMain, uEdTypeRozm;

{$R *.dfm}

procedure TfTypeRozmList.Button3Click(Sender: TObject);
begin
  fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList.Add('новий типорозмір');
  cbSizes.OnChange(nil);
  lvDimensions.Items[lvDimensions.Items.Count - 1].Selected := True;
  btnEdit.Click;
end;

procedure TfTypeRozmList.cbSizesChange(Sender: TObject);
var
  i: Integer;
begin
  lvDimensions.Clear;
  for i := 0 to fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList.Count - 1 do
    lvDimensions.Items.Add.Caption := fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList[i];
end;

procedure TfTypeRozmList.btnEditClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvDimensions.Items.Count - 1 do
    if lvDimensions.Items[i].Selected then
    with TfEdTypeRozm.Create(nil) do
    try
      edTitle.Text := fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList[i];
      ShowModal;
      if ModalResult = mrOk then
      begin
        fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList[i] := edTitle.Text;
        cbSizes.OnChange(nil);
        break;
      end;
    finally
      free;
    end;
end;

procedure TfTypeRozmList.Button5Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvDimensions.Items.Count - 1 do
    if lvDimensions.Items[i].Selected then
      if MessageDlg('Видалити типорозмір з усімв зазначеними значеннями мірок?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
        fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].TypeRozmList.Delete(i);
        cbSizes.OnChange(nil);
        Exit;
      end
      else Exit;
end;

end.
