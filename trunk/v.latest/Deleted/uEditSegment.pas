unit uEditSegment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TfEditSegment = class(TForm)
    Label2: TLabel;
    cbP1: TComboBox;
    Label1: TLabel;
    cbP2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    clbLayers: TCheckListBox;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fEditSegment: TfEditSegment;

implementation

{$R *.dfm}

end.
