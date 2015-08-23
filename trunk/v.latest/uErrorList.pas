unit uErrorList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfErrorList = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fErrorList: TfErrorList;

implementation

{$R *.dfm}

end.
