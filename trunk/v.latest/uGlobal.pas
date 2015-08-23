unit uGlobal;

interface

uses
  IniFiles;

{const
  _TitleOut  = 40;
  _RuleStep  = 1.0;
  _RuleLabelStep = 5;
  _RuleWidth = 50;
  _StartX =             _RuleWidth;
  _StartY = _TitleOut + _RuleWidth;}

type
 TModelSet = class
  private
    FFileName: String;
    FTitleOut: Integer;
    FRuleStep: Double;
    FRuleLabelStep: Integer;
    FRuleWidth: Integer;
    FConstrMode: Boolean; //режим конструктора
    function GetStartX: Integer;
    function GetStartY: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property FileName: String read FFileName write FFileName;
    property TitleOut: Integer read FTitleOut write FTitleOut;
    property RuleStep: Double read FRuleStep write FRuleStep;
    property RuleLabelStep: Integer read FRuleLabelStep write FRuleLabelStep;
    property RuleWidth: Integer read FRuleWidth write FRuleWidth;
    property StartX: Integer read GetStartX;
    property StartY: Integer read GetStartY;
    property ConstrMode: Boolean read FConstrMode write FConstrMode;
    procedure LoadIni(AFileName: String);
    procedure SaveIni(AFileName: String);
  end;

implementation

constructor TModelSet.Create;
begin
  inherited Create;
  FTitleOut := 40;
  FRuleStep := 1.0;
  FRuleLabelStep := 5;
  FRuleWidth := 50;
  FConstrMode := True;
end;

destructor TModelSet.Destroy;
begin

  inherited Destroy;
end;

function TModelSet.GetStartX: Integer;
begin
  Result := FRuleWidth;
end;

function TModelSet.GetStartY: Integer;
begin
  Result := FTitleOut + FRuleWidth;
end;

procedure TModelSet.LoadIni(AFileName: String);
var
  f: TIniFile;
begin
  f := TIniFile.Create(AFileName);
  with f do
  try
    FTitleOut      := ReadInteger('Rules', 'TitleOut',       40);
    FRuleStep      := ReadFloat('Rules', 'RuleStep',       1);
    FRuleLabelStep := ReadInteger('Rules', 'RuleLabelStept', 5);
    FRuleWidth     := ReadInteger('Rules', 'RuleWidth',      50);
    FConstrMode    := ReadBool('Common', 'ConstrMode', True);
  finally
    free;
  end;
end;

procedure TModelSet.SaveIni(AFileName: String);
var
  f: TIniFile;
begin
  f := TIniFile.Create(AFileName);
  with f do
  try
    WriteInteger('Rules', 'TitleOut',       FTitleOut);
    WriteFloat(  'Rules', 'RuleStep',       FRuleStep);
    WriteInteger('Rules', 'RuleLabelStept', FRuleLabelStep);
    WriteInteger('Rules', 'RuleWidth',      FRuleWidth);
    WriteBool('Common', 'ConstrMode', FConstrMode);
  finally
    free;
  end;
end;

end.
