unit ZMParser;

interface

uses Classes;

{ ����� ����������� ��������� ������������ ��� ������������
��������� Delphi Object Pascal, ������� �����:

Expr   ::= Term + Expr | Term - Expr | Term
Term   ::= Factor * Term | Factor / Term | Factor
Factor ::= + Item | - Item | Item
Item   ::= ( Expr ) | Fn( Expr ) | Number
Fn     ::= Sin | Cos | ������...
Number ::= floating point literal number (��������� ����� �������� �����)
}

type
  TExpressionParser = class(TParser)
  protected
    function SkipToken(Value: char): boolean;
    function EvalItem: double; virtual;
    function EvalFactor: double; virtual;
    function EvalTerm: double; virtual;
  public
    function EvalExpr: double;
  end;

implementation

uses SysUtils;

function TExpressionParser.SkipToken(Value: char): boolean;
begin
  { ���������� ������, ���� ������� ������� Value,
  � ���� ���, �� �������� ��������� ������� }
  Result := Token = Value;
  if Result then
    NextToken;
end;

function TExpressionParser.EvalItem: double;

var
  Expr: double;
  Fn: integer;

begin
  case Token of
    toInteger: Result := TokenInt;
    toFloat: Result := TokenFloat;
    '(':
      begin
        NextToken;
        Result := EvalExpr;
        CheckToken(')');
      end;
    toSymbol:
      begin
        if CompareText(TokenString, 'SIN') = 0 then
          Fn := 1
        else if CompareText(TokenString, 'COS') = 0 then
          Fn := 2
        else
          raise EParserError.CreateFmt('����������� ������� "%s"', [TokenString]
            );

        NextToken;
        CheckToken('(');
        NextToken;
        Expr := EvalExpr;
        CheckToken(')');
        case Fn of
          1: Result := SIN(Expr);
          2: Result := COS(Expr);
        end;
      end;
  else
    raise EParserError.CreateFmt('����������� ������ "%s"', [Token]);
  end;
  NextToken;
end;

function TExpressionParser.EvalFactor: double;

begin
  case Token of
    '+':
      begin
        NextToken;
        Result := EvalItem;
      end;
    '-':
      begin
        NextToken;
        Result := -EvalItem;
      end;
  else
    Result := EvalItem;
  end;
end;

function TExpressionParser.EvalTerm: double;
var
  AToken: char;
begin
  Result := EvalFactor;
  if SkipToken('*') then
    Result := Result * EvalTerm
  else if SkipToken('/') then
    Result := Result / EvalTerm;
end;

function TExpressionParser.EvalExpr: double;
begin
  Result := EvalTerm;
  if SkipToken('+') then
    Result := Result + EvalExpr
  else if SkipToken('-') then
    Result := Result - EvalExpr;
end;

end.
