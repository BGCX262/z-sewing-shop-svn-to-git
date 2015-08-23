unit uEditSplines;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, ComCtrls;

type
  TfEditSpline = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    clbLayers: TCheckListBox;
    edPoints: TEdit;
    rgLineType: TRadioGroup;
    gbTension: TGroupBox;
    Label1: TLabel;
    tbTension: TTrackBar;
    Label5: TLabel;
    Label4: TLabel;
    procedure rgLineTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEditSpline: TfEditSpline;

implementation

{$R *.dfm}

procedure TfEditSpline.rgLineTypeClick(Sender: TObject);
begin
  gbTension.Visible := (rgLineType.ItemIndex = 1);
end;

end.
