unit uEditPoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TfEditPoint = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edTitle: TEdit;
    chbSegment: TCheckBox;
    cbPrePoint: TComboBox;
    Label2: TLabel;
    pcPos1: TPageControl;
    TabSheet4: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    edX: TEdit;
    edY: TEdit;
    TabSheet5: TTabSheet;
    Label4: TLabel;
    pcPos2: TPageControl;
    TabSheet6: TTabSheet;
    Label3: TLabel;
    cbAngle: TComboBox;
    TabSheet7: TTabSheet;
    edBasis: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    chbVMirror: TCheckBox;
    chbHMirror: TCheckBox;
    Label9: TLabel;
    Bevel1: TBevel;
    edFormula: TMemo;
    cbObjectAngle: TComboBox;
    Image1: TImage;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    FOldFormula: Text;
  end;

var
  fEditPoint: TfEditPoint;

implementation

uses uMain;

{$R *.dfm}

end.
