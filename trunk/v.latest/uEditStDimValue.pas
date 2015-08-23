unit uEditStDimValue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfEditStDimValue = class(TForm)
    Label1: TLabel;
    lbTypeRozm: TLabel;
    lbDimPozn: TLabel;
    lbSexType: TLabel;
    edValue: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEditStDimValue: TfEditStDimValue;

implementation

{$R *.dfm}

end.
