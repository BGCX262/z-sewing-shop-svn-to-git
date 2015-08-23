unit uStandartDimensions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfStandartDimensions = class(TForm)
    tcDimPozn: TTabControl;
    Button1: TButton;
    lvDimensions: TListView;
    rgSexList: TRadioGroup;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    procedure rgSexListClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure tcDimPoznChange(Sender: TObject);
    procedure lvDimensionsDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateDimensions(const ASizeIndex: Integer);
  end;

var
  fStandartDimensions: TfStandartDimensions;

implementation

uses uMain, uTypeRozmList, uDimPoznList, uEditStDimValue;

{$R *.dfm}

procedure TfStandartDimensions.rgSexListClick(Sender: TObject);
var
  i: Integer;
begin
  tcDimPozn.Tabs.Clear;
  lvDimensions.Clear;
  with fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex] do
  begin
    for i := 0 to TypeRozmList.Count - 1 do
      tcDimPozn.Tabs.Add(TypeRozmList[i]);
    for i := 0 to DimPoznList.Count - 1 do
      with lvDimensions.Items.Add do
      begin
        Caption := DimPoznList[i].Title;
        SubItems.Add(DimPoznList[i].UName);
        SubItems.Add('-');
      end;
  end;
  tcDimPozn.OnChange(nil);
end;

procedure TfStandartDimensions.UpdateDimensions(const ASizeIndex: Integer);
var
  i: Integer;
begin
  rgSexList.Items.Clear;
  for i := 0 to fMain.ZM01.Sizes.SexTypeList.Count - 1 do
    rgSexList.Items.Add(fMain.ZM01.Sizes.SexTypeList[i].Title);
  if fMain.ZM01.Sizes.SexTypeList.Count > 0 then
  begin
    rgSexList.Columns := fMain.ZM01.Sizes.SexTypeList.Count;
    rgSexList.ItemIndex := ASizeIndex;
  end;
  tcDimPozn.OnChange(nil);
end;

procedure TfStandartDimensions.Button7Click(Sender: TObject);
var
  i: Integer;
begin
  with TfTypeRozmList.Create(nil) do
  try
    cbSizes.Clear;
    for i := 0 to fMain.ZM01.Sizes.SexTypeList.Count - 1 do
      cbSizes.Items.Add(fMain.ZM01.Sizes.SexTypeList[i].Title);
    cbSizes.ItemIndex := rgSexList.ItemIndex;
    cbSizes.OnChange(nil);
    ShowModal;
  finally
    UpdateDimensions(cbSizes.ItemIndex);
    free;
  end;
end;

procedure TfStandartDimensions.Button8Click(Sender: TObject);
var
  i: Integer;
begin
  with TfDimPoznList.Create(nil) do
  try
    cbSizes.Clear;
    for i := 0 to fMain.ZM01.Sizes.SexTypeList.Count - 1 do
      cbSizes.Items.Add(fMain.ZM01.Sizes.SexTypeList[i].Title);
    cbSizes.ItemIndex := rgSexList.ItemIndex;
    cbSizes.OnChange(nil);
    ShowModal;
  finally
    UpdateDimensions(cbSizes.ItemIndex);
    free;
  end;
end;

procedure TfStandartDimensions.Button4Click(Sender: TObject);
begin
  fMain.aLoadSize.Execute;
  UpdateDimensions(0);
end;

procedure TfStandartDimensions.tcDimPoznChange(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvDimensions.Items.Count - 1 do
  begin
    if fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex].Data[i, tcDimPozn.TabIndex] = -1
      then lvDimensions.Items[i].SubItems[1] := '-'
      else lvDimensions.Items[i].SubItems[1] :=
        Format('%3.2f',
        [fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex].Data[i, tcDimPozn.TabIndex]]);
  end;
end;

procedure TfStandartDimensions.lvDimensionsDblClick(Sender: TObject);
var
  i: Integer;
begin
  if tcDimPozn.Tabs.Count = 0 then Exit;
  for i := 0 to lvDimensions.Items.Count - 1 do
  begin
    if lvDimensions.Items[i].Selected then
    begin
      with TfEditStDimValue.Create(nil) do
      try
        lbTypeRozm.Caption := tcDimPozn.Tabs[tcDimPozn.TabIndex];
        lbSexType.Caption  := rgSexList.Items[rgSexList.ItemIndex];
        lbDimPozn.Caption  := Format('%s (%s)', [lvDimensions.Items[i].Caption, lvDimensions.Items[i].SubItems[0]]);
        edValue.Text := Format('%3.2f', [fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex].Data[i, tcDimPozn.TabIndex]]);
        ShowModal;
        if ModalResult = mrOk then
        begin
          fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex].Data[i, tcDimPozn.TabIndex] :=
            StrToFloat(edValue.Text);
          tcDimPozn.OnChange(nil);
        end;
      finally
        free;
      end;
    end;
  end;
end;

procedure TfStandartDimensions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if MessageDlg('Зберегти розмірну лінійку?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    fMain.aSaveDim.Execute;
end;

procedure TfStandartDimensions.Button6Click(Sender: TObject);
begin
  fMain.ZM01.Sizes.SexTypeList[rgSexList.ItemIndex].Apply(tcDimPozn.TabIndex);
  fMain.UpdateTree;
  fMain.aDraw.Execute;
end;

end.
