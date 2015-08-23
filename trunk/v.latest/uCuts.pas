unit uCuts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TfCuts = class(TForm)
    chbBaseGrid: TCheckBox;
    Label1: TLabel;
    CheckListBox1: TCheckListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCuts: TfCuts;

implementation

{$R *.dfm}

end.
