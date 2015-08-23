unit uInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfInfo = class(TForm)
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edTitle: TEdit;
    cbSex: TComboBox;
    Label3: TLabel;
    edDescr: TEdit;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fInfo: TfInfo;

implementation

uses uMain;

{$R *.dfm}

end.
