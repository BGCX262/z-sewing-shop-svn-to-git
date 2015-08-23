unit uSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ComCtrls;

type
  TfSetting = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Label1: TLabel;
    edTitleOut: TEdit;
    Label2: TLabel;
    edRuleStep: TEdit;
    Label3: TLabel;
    edRuleLabelStept: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edRuleWidth: TEdit;
    TabSheet2: TTabSheet;
    chbConstr: TCheckBox;
    Label6: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetting: TfSetting;

implementation

{$R *.dfm}

end.
