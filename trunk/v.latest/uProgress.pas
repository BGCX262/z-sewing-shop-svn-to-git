unit uProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfProgress = class(TForm)
    lbProgress: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fProgress: TfProgress;

implementation

{$R *.dfm}

end.
