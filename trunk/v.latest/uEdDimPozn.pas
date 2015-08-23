unit uEdDimPozn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfEdDimPozn = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edTitle: TEdit;
    Label2: TLabel;
    edUName: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEdDimPozn: TfEdDimPozn;

implementation

{$R *.dfm}

end.
