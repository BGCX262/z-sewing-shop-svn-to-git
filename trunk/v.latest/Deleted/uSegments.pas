unit uSegments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfSegments = class(TForm)
    lvSegments: TListView;
    btnEdit: TButton;
    Button2: TButton;
    Button3: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSegments: TfSegments;

implementation

uses uMain;

{$R *.dfm}

end.
