unit uDimPoznList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfDimPoznList = class(TForm)
    Label1: TLabel;
    cbSizes: TComboBox;
    lvDimensions: TListView;
    Button2: TButton;
    Button3: TButton;
    btnEdit: TButton;
    Button5: TButton;
    procedure cbSizesChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDimPoznList: TfDimPoznList;

implementation

uses uMain, uEdDimPozn;

{$R *.dfm}

procedure TfDimPoznList.cbSizesChange(Sender: TObject);
var
  i: Integer;
begin
  lvDimensions.Clear;
  for i := 0 to fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList.Count - 1 do
    with lvDimensions.Items.Add do
    begin
      Caption := fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].Title;
      SubItems.Add(fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].UName);
    end;
end;

procedure TfDimPoznList.btnEditClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvDimensions.Items.Count - 1 do
    if lvDimensions.Items[i].Selected then
    with TfEdDimPozn.Create(nil) do
    try
      edTitle.Text := fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].Title;
      edUName.Text := fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].UName;
      ShowModal;
      if ModalResult = mrOk then
      begin
        fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].Title := edTitle.Text;
        fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList[i].UName := edUName.Text;
        cbSizes.OnChange(nil);
        break;
      end;
    finally
      free;
    end;
end;

procedure TfDimPoznList.Button5Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvDimensions.Items.Count - 1 do
    if lvDimensions.Items[i].Selected then
      if MessageDlg('Видалити мірку з усімв зазначеними значеннями в усіх типорозмірах?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
        fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList.Delete(i);
        cbSizes.OnChange(nil);
        Exit;
      end
      else Exit;
end;

procedure TfDimPoznList.Button3Click(Sender: TObject);
begin
  fMain.ZM01.Sizes.SexTypeList[cbSizes.ItemIndex].DimPoznList.Add('нова мірка', 'new_dim');
  cbSizes.OnChange(nil);
  lvDimensions.Items[lvDimensions.Items.Count - 1].Selected := True;
  btnEdit.Click;
end;

end.
