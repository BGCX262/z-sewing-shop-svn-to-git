unit uEditLayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfEditLayer = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edTitle: TEdit;
    Label2: TLabel;
    shColor: TShape;
    Cd1: TColorDialog;
    Label3: TLabel;
    edWidth: TEdit;
    procedure shColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEditLayer: TfEditLayer;

implementation

{$R *.dfm}

procedure TfEditLayer.shColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if cd1.Execute then
    shColor.Brush.Color := cd1.Color;
end;

end.
