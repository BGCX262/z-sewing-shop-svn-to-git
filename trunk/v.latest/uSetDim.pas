unit uSetDim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfSetDim = class(TForm)
    edValue: TEdit;
    Button1: TButton;
    Button2: TButton;
    edTitle: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edUName: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetDim: TfSetDim;

implementation

{$R *.dfm}

end.
