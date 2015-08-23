{
********************************************************************************
Основні класи проекту "Швейний магазин"

(с) Зореслав Гораль, 2010р.

початок: 04.02.2010
зміни:   03.05.2010

03.05.2010 - Добавлено розмірну лінійку: додати категорію, редагувати розміри,
             застосувати категорію до виробу

********************************************************************************
}
unit ZSewing;

interface

uses
  ZSewingExceptions, { exceptions }
  JclExprEval,       { парсер математичних виразів }
  LoadZCorelDll,     { функції для роботи з бібліотекою ZCorel.dll }

  Contnrs, SysUtils, Classes, IniFiles, StrUtils, msxml, Graphics, Variants,
  Windows;

const
  { кольори шарів по-замовчуванню }
  _n = 3;
  GridColors: array[0.._n] of Integer = (clRed, clGreen, clBlue, clYellow);
  _cdr_left   = 10;
  _cdr_widthy = 1189;

var
  _c: Char;

type
  {
  прості типи
  }
  { універсальна, чоловіча, жіноча чи дитяча}
  TZSMSex = (sUnisex, sMan, sWomen, sChildren, sPregnant);
  { євро-розміри }
  TZSMEuroSize = (esXS, esS, esM, esL, esXL, esXXL);
  { позиція-спосіб визначення положення точки (лінійно, дугою) }
  TZSMPosType = (ptXY, ptLine, ptArc);
  { події завантаження }
  TZSMLoad = (lNone, lInfo, lLayers, lDimensions, lPoints, lSplines);
  { ламана чи сплайн }
  TZSMSplineType = (ltLine, ltSpline);

  {
  випереджаючі оголошення
  }
  TZSewingModel     = class;
  TZSMCutList       = class;
  TZSMDimensionList = class;
  TZSMPointsList    = class;
  TZSMCut           = class;
  TZSMLayerList     = class;
  TZSMDimPoznList   = class;
  TZSMSexType       = class;
  TZSMSexTypeList   = class;
  TZSMSizes         = class;
  TZSMPoint         = class;
  TZSMSplineList  = class;

  {
  Типорозмір. Назва, позначення
  }
  TZSMDimPozn = class
  private
    FDimPoznList: TZSMDimPoznList;
    { позначення }
    FUname: String;
    { підпис }
    FTitle: String;
  public
    property UName: String read FUName write FUName;
    property Title: String read FTitle write FTitle;
  end;

  {
  Список типорозмірів
  }
  TZSMDimPoznList = class(TObjectList)
  private
    FSexType: TZSMSexType;
    function GetDimPozn(AIndex: Integer): TZSMDimPozn;
    procedure SetDimPozn(AIndex: Integer; AValue: TZSMDimPozn);
  public
    function Add(ATitle, AUName: String): Integer;
    property Items[Index: Integer]: TZSMDimPozn read GetDimPozn write SetDimPozn; default;
  end;

  {
  Типаж розмірний
  }
  TZSMTypeRozmList = class(TStringList)
  private
    FSexType: TZSMSexType;
  public
    function Add(const S: string): Integer; overload;
  end;


  {
  Розмір статі. Назва, індекс, список розмірів
  }
  TZSMSexType = class
  private
    FList: TZSMSexTypeList;
    FTitle: String;
    FItemIndex: Integer;
    { позначення типорозмірів (L, XL, M, etc.) }
    FTypeRozmList: TZSMTypeRozmList;
    { список мірок }
    FDimPoznList: TZSMDimPoznList;
    { Дані про заміри }
    FData: array of array of Double;
    { одержати значення }
    function GetData(ATypeRozmIndex, ADimPoznIndex: Integer): Double;
    { записати значення }
    procedure SetData(ATypeRozmIndex, ADimPoznIndex: Integer; const AValue: Double);
  public
    constructor Create;
    destructor Destroy; override;
    { застосувати до моделі }
    procedure Apply(ATypeRozmIndex: Integer);
    property Title: String read FTitle write FTitle;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
    property TypeRozmList: TZSMTypeRozmList read FTypeRozmList write FTypeRozmList;
    property DimPoznList: TZSMDimPoznList read FDimPoznList write FDimPoznList;
    property Data[ATypeRozmIndex, ADimPoznIndex: Integer]: Double read GetData
      write SetData;
  end;

  {
  Список по-статі (унісекс, чол, жін, вагітні)
  }
  TZSMSexTypeList = class(TObjectList)
  private
    FSizes: TZSMSizes;
    function GetSexType(AIndex: Integer): TZSMSexType;
    procedure SetSexType(AIndex: Integer; AValue: TZSMSexType);
    function Add(ATitle: String): Integer;
  public
    constructor Create;
    property Items[Index: Integer]: TZSMSexType read GetSexType write SetSexType; default;
  end;

  {
  Розмірна лінійка
  }
  TZSMSizes = class
  private
    FModel: TZSewingModel;
    FSexTypeList: TZSMSexTypeList;
  public
    constructor Create;
    destructor Destroy; override;
    property SexTypeList: TZSMSexTypeList read FSexTypeList write FSexTypeList;
    { Завантажити з XML }
    procedure LoadXML(const AFileName: String);
    { Зберегти проект в формат XML }
    procedure SaveXML(const AFileName: String);
  end;

  {
  Однин з шарів відрізка
  }
  TZSMSplineLayer = class
  private
    FChecked: Boolean;
  public
    property Checked: Boolean read FChecked write FChecked;
  end;

  {
  Список шарів відрізка (яким належить відрізок)
  }
  TZSMSplineLayerList = class(TObjectList)
  private
    function GetLayer(Index: Integer): TZSMSplineLayer;
    procedure SetLayer(Index: Integer; Value: TZSMSplineLayer);
  public
    property Items[Index: Integer]: TZSMSplineLayer read GetLayer write
      SetLayer; default;
    function Add(const AChecked: Boolean): Integer;
  end;

  {
  Універсальний відрізок (ламана, сплайн) побудови
  }
  TZSMSpline = class
  private
    FSplineList: TZSMSplineList;
    FSplineType: TZSMSplineType;
    FPointsList: TStringList;
    FLayerList:  TZSMSplineLayerList;
    FSplineIndex: Integer;
    FTension: Single;
    function GetShortTitle: String;
    function GetTitle: String;
    function FindSplineIndex: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property PointsList: TStringList read FPointsList write FPointsList;
    function GetPoint(const Index: Integer): TZSMPoint;
    property ShortTitle: String read GetShortTitle;
    property Title: String read GetTitle;
    property LayerList: TZSMSplineLayerList read FLayerList write FLayerList;
    property SplineIndex: Integer read FindSplineIndex;
    property SplineType: TZSMSplineType read FSplineType write FSplineType;
    property Tension: Single read FTension write FTension;
  end;

  {
  Список сплайнів побудови
  }
  TZSMSplineList = class(TObjectList)
  private
    FModel: TZSewingModel;
    function GetSpline(Index: Integer): TZSMSpline;
    procedure SetSpline(Index: Integer; Value: TZSMSpline);
  public
    function Add(AItem: TZSMSpline): Integer; overload;
    function Add(APoints: TStringList; ASplineType: TZSMSplineType; const ATension: Single; const ALayerIndex: Integer = 0): Integer; overload;
    function Add(APointsStr: String; ASplineType: TZSMSplineType; const ATension: Single; const ALayerIndex: Integer = 0): Integer; overload;
    property Items[Index: Integer]: TZSMSpline read GetSpline write SetSpline; default;
  end;

  {
  Викройка (підпис, опис)
  }
  TZSMCut = class
  private
    FCutList: TZSMCutList;
    { підпис }
    FTitle: String;
    { опис }
    FDescription: String;
  public
    constructor Create;
    destructor Destroy; override;
    property Title: String read FTitle write FTitle;
    property Description: String read FDescription write FDescription;
    procedure Build; virtual; abstract;
  end;

  {
  Список замірів моделі
  }
  TZSMCutList = class(TObjectList)
  private
    FModel: TZSewingModel;
    function GetCut(Index: Integer): TZSMCut;
    procedure SetCut(Index: Integer; Value: TZSMCut);
  public
    function Add(AItem: TZSMCut): Integer; overload;
    function Add(ATitle: String; ADescription: String): Integer; overload;
    property Items[Index: Integer]: TZSMCut read GetCut write SetCut; default;
  end;

  {
  Замір (позначення, підпис, величина)
  }
  TZSMDimension = class
  private
    FDimensionList: TZSMDimensionList;
    { позначення }
    FUname: String;
    { підпис }
    FTitle: String;
    { величина розміру, см }
    FValue: Double;
    FDimensionIndex: Integer;
    procedure SetUName(Value: String);
    function FindDimensionIndex: Integer;
    procedure SetValue(AValue: Double);
  public
    property UName: String read FUName write SetUname;
    property Title: String read FTitle write FTitle;
    property Value: Double read FValue write SetValue;
    property DimensionIndex: Integer read FindDimensionIndex;
  end;

  {
  Список замірів моделі
  }
  TZSMDimensionList = class(TObjectList)
  private
    FModel: TZSewingModel;
    function GetDim(Index: Integer): TZSMDimension;
    procedure SetDim(Index: Integer; Value: TZSMDimension);
  public
    property Items[Index: Integer]: TZSMDimension read GetDim write SetDim; default;
    function Add(AItem: TZSMDimension): Integer; overload;
    function Add(AUname, ATitle: String; AValue: Double): Integer; overload;
    function Find(const AUname: String; var ADimension: TZSMDimension): Boolean;
    function ValueByName(const AUname: String): Double;
  end;

  {
  Кут (задається як значенням, так і формулою)
  }
  TZSMAngle = class
  private
    FPoint: TZSMPoint;
    FAngleFormula: String;
    FValue: Double;
    procedure SetFormula(Value: String); overload;
    procedure SetFormula2(Value: String; AMustRun: Boolean); overload;
    function RunValue: Double;
    function VarInFormula(AVar: String): Boolean;
  public
    property Formula: String read FAngleFormula write SetFormula;
    property Value: Double read FValue;
  end;  

  {
  Точка (позначення, координати в см, координати в масштабі відображення)
  }
  TZSMPoint = class
  private
    FPointsList: TZSMPointsList;
    { координати }
    FX: Double;
    FY: Double;
    { зсув }
    { кут повороту }
    FObjectAngle: Double;
    { дзеркальні відображення }
    FHMirror: Boolean;
    FVMirror: Boolean;
    { позначення }
    FUname: String;
    { індекс в масиві }
    FPointIndex: Integer;
    { точка від котрої рахувати }
    FPrePointIndex: Integer;
    { кут }
    FAngle: TZSMAngle;
    { формула }
    FLFormula: String;
    { значення (довжина відрізка) }
    FL: Double;
    { визначення положення (задані координати, лінійне, дугове) }
    FPosType: TZSMPosType;
    { точка - центр кола для дугового позначення }
    FCentrePointIndex: Integer;
    { індекс шару }
    //FLayerIndex: Integer;
    { координати, см }
    function GetX: Double;
    function GetY: Double;
    procedure SetX(Value: Double);
    procedure SetY(Value: Double);
    { координати, точки }
    function GetXpx: Integer;
    function GetYpx: Integer;
    { координати розмірів блоку }
    function GetBaseLX: Double;
    function GetBaseRX: Double;
    function GetBaseLY: Double;
    function GetBaseRY: Double;
    function GetBaseLXpx: Integer;
    function GetBaseRXpx: Integer;
    function GetBaseLYpx: Integer;
    function GetBaseRYpx: Integer;
    function GetBaseCX: Double;
    function GetBaseCY: Double;
    { розрахунок довжини по-формулі }
    function RunFormula: Double;
    { признак чи активна }
    function CheckSelected: Boolean;
    { задати назву точки і замінити у формулах та у відрізках }
    procedure SetUName(Value: String);
    procedure SetFormula(Value: String); overload;
    procedure SetFormula2(Value: String; AMustRun: Boolean); overload;
    { чи відображається відрізок від розрахункової точки }
    function CheckShowSpline: Boolean;
    procedure SetSpline(Value: Boolean);
    procedure SetPrePointIndex(Value: Integer);
    function FindPointIndex: Integer;
    function FindPrePointIndex: Integer;
    function CheckInLayer(const ALayerIndex: Integer): Boolean;
    function GetL: Double;
    function VarInFormula(AVar: String): Boolean;
    //одержання першої базисної точки (ptXY) для даної точки
    function GetFirstBasisPoint: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property UName: String read FUName write SetUname;
    property X: Double read GetX write SetX;
    property Y: Double read GetY write SetY;
    property Xpx: Integer read GetXpx;
    property Ypx: Integer read GetYpx;
    property PointIndex: Integer read FindPointIndex;
    property BasisIndex: Integer read GetFirstBasisPoint;
    property PrePointIndex: Integer read FindPrePointIndex write SetPrePointIndex;
    property Angle: TZSMAngle read FAngle write FAngle;
    property Formula: String read FLFormula write SetFormula;
    property PosType: TZSMPosType read FPosType write FPosType;
    property CentrePointIndex: Integer read FCentrePointIndex write FCentrePointIndex;
    property IsSelected: Boolean read CheckSelected;
    property ShowSpline: Boolean read CheckShowSpline write SetSpline;
    //property LayerIndex: Integer read FLayerIndex write FLayerIndex;
    property Length: Double read FL;
    property BaseLXpx: Integer read GetBaseLXpx;
    property BaseRXpx: Integer read GetBaseRXpx;
    property BaseLYpx: Integer read GetBaseLYpx;
    property BaseRYpx: Integer read GetBaseRYpx;
    property ObjectAngle: Double read FObjectAngle write FObjectAngle;
    property HMirror: Boolean read FHMirror write FHMirror;
    property VMirror: Boolean read FVMirror write FVMirror;
  end;

  {
  Список точок
  }
  TZSMPointsList = class(TObjectList)
  private
    FModel: TZSewingModel;
    FSelected: Integer;
    function GetPoint(Index: Integer): TZSMPoint;
    procedure SetPoint(Index: Integer; Value: TZSMPOint);
    function DivLength(const APoint1, APoint2: TZSMPoint): Double; overload;
    function DivLength(const AIndex1, AIndex2: Integer): Double; overload;
    function DivLength(const AUname1, AUname2: String): Double;  overload;
    function DivLength(const ASegment: String): Double;          overload;
    function AngleLength(const APoint1, APoint2: TZSMPoint): Double; overload;
    function AngleLength(const AIndex1, AIndex2: Integer): Double; overload;
    function AngleLength(const AUname1, AUname2: String): Double;  overload;
    function AngleLength(const ASegment: String): Double;          overload;
    function UniquePointName(AUName: String): String;
    function GetSelected: Integer;
    procedure SetSelected(AValue: Integer);
  public
    constructor Create;
    property Items[Index: Integer]: TZSMPoint read GetPoint write SetPoint; default;
    property Selected: Integer read GetSelected write SetSelected;
    function Add(AItem: TZSMPoint): Integer; overload;
    function Add(
      const AUname: String;
      const APrePointIndex: Integer;
      const AAngle: String;
      const AFormula: String;
      const APosType: TZSMPosType;
      const ACentrePointIndex: Integer;
      const AX: Double;
      const AY: Double;
      const AddSpline: Boolean = True;
      const CheckSpline: Boolean = False
    ): Integer; overload;
    function MinY: Double;
    function MaxY: Double;
    function MinX: Double;
    function MaxX: Double;
    function Find(const AUname: String; var APoint: TZSMPoint): Boolean; overload;
    function Find(const AUname: String): TZSMPoint; overload;
    function XByName(const AUname: String): Double;
    function YByName(const AUname: String): Double;
    procedure FromString(const ANames: String);
    function Width: Double;
    function Height: Double;
    function WidthPx: Integer;
    function HeightPx: Integer;
  end;

  {
  Абстрактний клас ітема. Тре буде всі ітеми на нього перевести
  }
  TZSMItem = class(TObjectList)
  private
    FParent: TObjectList;
    FIIndex: Integer;
    function FindIIndex: Integer;
  public
    property IIndex: Integer read FindIIndex;
  end;

  {
  Абстрактний клас списку з селектом
  }
  TZSMSelItemList = class(TObjectList)
  private
    FSelected: Integer;
    procedure SetSelected(AValue: Integer);
  public
    property Selected: Integer read FSelected write SetSelected;
  end;

  {
  Абстрактний клас ітема з селектом. Тре буде всі ітеми на нього перевести
  }
  TZSMSelItem = class(TZSMItem)
  private
    FParent: TZSMSelItemList;
    function CheckSelected: Boolean;
  public
    property IsSelected: Boolean read CheckSelected;
  end;

  {
  Шар
  }
  TZSMLayer = class(TZSMSelItem)
  private
    FTitle: String;
    FChecked: Boolean;
    FColor: Integer;
    FWidth: Integer;
  public
    property Title: String read FTitle write FTitle;
    property Color: Integer read FColor write FColor;
    property Width: Integer read FWidth write FWidth;
    property Checked: Boolean read FChecked write FChecked;
    property IsSelected;
  end;

  {
  Список шарів
  }
  TZSMLayerList = class(TZSMSelItemList)
  private
    FModel: TZSewingModel;
    function GetLayer(Index: Integer): TZSMLayer;
    procedure SetLayer(Index: Integer; Value: TZSMLayer);
  public
    property Items[Index: Integer]: TZSMLayer read GetLayer write SetLayer; default;
    function Add(ATitle: String; AColor: Integer; const AWidth: Integer;
      const AChecked: Boolean = True): Integer;
  end;

  {
  Модель
  }
  TZSewingModel = class
  private
    { підпис }
    FTitle: String;
    { опис }
    FDescription: String;
    { європейський розмір }
    FEuroSize: TZSMEuroSize;
    { Універсальна, чоловіча чи жіноча }
    FSex: TZSMSex;
    { список замірів }
    FDimensionList: TZSMDimensionList;
    { список викройок }
    FCutList: TZSMCutList;
    { список точок }
    FPointsList: TZSMPointsList;
    { коефіцієнт побудови масштабу }
    FZoom: Double;
    { модель завантажена }
    FLoaded: Boolean;
    { розраховувач виразів }
    FEval: TEvaluator;
    { список універсальних відрізків }
    FSplineList: TZSMSplineList;
    { шари }
    FLayerList: TZSMLayerList;
    { розмірна лінійка }
    FSizes: TZSMSizes;
    { документ CorelDraw }
    FV: Variant;
    { події завантаження }
    FLoadIndex: TZSMLoad;
    FOnLoad: TNotifyEvent;

    procedure SetEuroSize(AValue: TZSMEuroSize);
    procedure SetSex(AValue: TZSMSex);
    procedure Build;
    { форматування виразу: заміна змінних числами }
    procedure FormatEvalution(var AString: String);
    { відкрити файл CorelDraw }
    procedure OpenCorel(const AInFileName: String);
    { нарисувати текст }
    procedure DrawText(const Ax, Ay: Double; const AFontSize: Integer;
      const AColor: TColor; const AText: String);
    { побудова шару в CorelDraw }
    procedure DrawLayer(const ALayer: TZSMLayer; const i: Integer);
    { побудова лінії в CorelDraw }
    procedure DrawLine(const Ax1, Ay1, Ax2, Ay2: Double;
      const AColor: TColor; const AWidth: double = 1);
    { побувати точку }
    procedure DrawPoint(const Ax, Ay: Double; const ATitle: String;
      const AColor: TColor = clBlack; const ARadius: double = 1.6;
      const DoDrawText: Boolean = True);
  protected
    procedure DoOnLoad; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    property Title: String read FTitle write FTitle;
    property Description: String read FDescription write FDescription;
    property EuroSize: TZSMEuroSize read FEuroSize write SetEuroSize;
    property Sex: TZSMSex read FSex write SetSex;
    property DimensionList: TZSMDimensionList read FDimensionList
      write FDimensionList;
    property PointsList: TZSMPointsList read FPointsList
      write FPointsList;
    property CutList: TZSMCutList read FCutList write FCutList;
    property Zoom: Double read FZoom write FZoom;
    property Loaded: Boolean read FLoaded write FLoaded;
    property SplinesList: TZSMSplineList read FSplineList write FSplineList;
    property LayerList: TZSMLayerList read FLayerList write FLayerList;
    { розмірна лінійка }
    property Sizes: TZSMSizes read FSizes write FSizes;
    property LoadIndex: TZSMLoad read FLoadIndex;
    property OnLoad: TNotifyEvent read FOnLoad write FOnLoad;
    { очистити }
    procedure Clear;
    { нова модель }
    procedure CreateNew;
    { реальні координати через піксели }
    function GetX(const Xpx: Integer): Double;
    function GetY(const Ypx: Integer): Double;
    { Завантажити з XML }
    procedure LoadXML(const AFileName: String; var AErrorList: TStringList);
    { Зберегти проект в формат XML }
    procedure SaveXML(const AFileName: String);
    { Експорт в CorelDraw }
    procedure ExportToCorelDraw(const AInFileName, AOutFileName: String);
  end;

function GetGridColor(const AIndex: Integer): Integer;

implementation

function mmToDuim(AValue: Double): Double;
begin
  Result := AValue / 25.4;
end;

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result:=B Shl 16 Or
  G Shl 8 Or
  R;
end;

function XMLElement(const ADOM: IXMLDOMDocument; const name, text: string): IXMLDOMElement;
begin
  Result := ADOM.createElement(name);
  Result.text := text;
end;

{
Одержати колір
}
function GetGridColor(const AIndex: Integer): Integer;
var
  k: Integer;
begin
  k := AIndex;
  if k > _n then
    k := k - (k div _n) * _n - 1;
  Result := GridColors[k];  
end;

{
Збільшення індексу змінної
}
procedure IncrementName(var AName: String);
var
  i: Integer;
  s1, s2: String;
begin
  if AName = '' then
    raise Exception.Create('error var');
  s1 := AName;
  s2 := '';
  i := Length(AName);
  while (AName[i] >= '0') and (AName[i] <= '9') and (i > 0) do
  begin
    s1 := Copy(AName, 1, i - 1);
    s2 := Copy(AName, i, Length(AName) - i + 1);
    i := i - 1;
  end;
  if s2 ='' then s2 := '0';
  AName := s1 + IntToStr(StrToInt(s2) + 1);
end;

function Pos2(const AWord, AString: String; offset: Integer): Integer;
var
  k: Integer;
begin
  Result := 0;
  if AString = '' then Exit;
  k := PosEx(AWord, AString, offset);
  if k > 0 then { входить }
  begin
    if k > 1 then  { пробіл перед словом }
      if (AString[k - 1] <> ' ') and (AString[k - 1] <> '=') then Exit;
    if (k + Length(AWord) - 1) < Length(AString) then  { пробіл після слова }
      if (AString[k + Length(AWord)] <> ' ') and (AString[k + Length(AWord)] <> '=') then Exit;
  end;
  Result := k;
end;

procedure ZReplaseString(var AString: String; const AFind, ARepl: String);
var
  Pe, p: Integer;
begin
  pe := 1;
  repeat
    p := Pos2(AFind, AString, pe);
    if p > 0 then
    begin
      Delete(AString, p, Length(AFind));
      Insert(ARepl, AString, p);
    end;
    pe := p + Length(AFind);
  until p = 0;
end;

procedure StrToCommaZ(var AString: String);
var
  i: Integer;
begin
  for i := 1 to Length(AString) do
  begin
    if AString[i] = '.' then AString[i] := _c;
    if AString[i] = ',' then AString[i] := _c;
  end;
end;

function StrToFloatZ(const AString: String): Double;
var
  s: String;
begin
  s := AString;
  StrToCommaZ(s);
  Result := StrToFloat(s);
end;

procedure CheckFile(const AFileName: String);
begin
  if not FileExists(AFileName) then
    raise Exception.Create(Format('Файл "%s" не знайдено', [AFileName]));
end;

{
TZSMItem - Абстрактний клас ітема. Тре буде всі ітеми на нього перевести
********************************************************************************
}
function TZSMItem.FindIIndex: Integer;
var
  i: Integer;
begin
  for i := 0 to FParent.Count - 1 do
    if TZSMItem(FParent.Items[i]).FIIndex = FIIndex then
    begin
      Result := i;
      Exit;
    end;
end;

{
TZSMSelItemList - Абстрактний клас списку з селектом
********************************************************************************
}
procedure TZSMSelItemList.SetSelected(AValue: Integer);
begin
  FSelected := AValue;
end;

{
TZSMSelItem - Абстрактний клас ітема з селектом. Тре буде всі ітеми на нього
перевести
********************************************************************************
}
function TZSMSelItem.CheckSelected: Boolean;
begin
  Result := (IIndex = FParent.FSelected);
end;

{
Список типорозмірів
********************************************************************************
}
function TZSMDimPoznList.GetDimPozn(AIndex: Integer): TZSMDimPozn;
begin
  Result := TZSMDimPozn(inherited GetItem(AIndex));
end;

procedure TZSMDimPoznList.SetDimPozn(AIndex: Integer; AValue: TZSMDimPozn);
begin
  inherited SetItem(AIndex, AValue);
end;

function TZSMDimPoznList.Add(ATitle, AUName: String): Integer;
var
  AItem: TZSMDimPozn;
  i: Integer;
begin
  AItem := TZSMDimPozn.Create;
  AItem.FUname := AUname;
  AItem.FTitle := ATitle;
  AItem.FDimPoznList := Self;
  Result := inherited Add(AItem);
  {зміна розміру масиву даних}
  if (Count > 0) and (FSexType.FTypeRozmList.Count > 0) then
  begin
    SetLength(FSexType.FData, Count, FSexType.FTypeRozmList.Count);
    for i := 0 to FSexType.FTypeRozmList.Count - 1 do
      FSexType.FData[Count - 1, i] := 0;
  end
  else
    SetLength(FSexType.FData, 0, 0);
end;

{
TZSMTypeRozmList - Типаж розмірний
********************************************************************************
}
function TZSMTypeRozmList.Add(const S: string): Integer;
var
  i: Integer;
begin
  Result := inherited Add(s);
  {зміна розміру масиву даних}
  if (Count > 0) and (FSexType.FDimPoznList.Count > 0) then
  begin
    SetLength(FSexType.FData, FSexType.FDimPoznList.Count, Count);
    for i := 0 to FSexType.FDimPoznList.Count - 1 do
      FSexType.FData[i, Count - 1] := 0;
  end
  else
    SetLength(FSexType.FData, 0, 0);
end;

{
Розмір статі. Назва, індекс, список розмірів
********************************************************************************
}
constructor TZSMSexType.Create;
begin
  inherited Create;
  SetLength(FData, 0, 0);
  FTypeRozmList := TZSMTypeRozmList.Create;
  FTypeRozmList.FSexType := self;
  FDimPoznList := TZSMDimPoznList.Create;
  FDimPoznList.FSexType := self;
end;

destructor TZSMSexType.Destroy;
begin
  FDimPoznList.Free;
  FTypeRozmList.Free;
  FData := nil;
  inherited Destroy;
end;

{
застосувати до моделі
}
procedure TZSMSexType.Apply(ATypeRozmIndex: Integer);
var
  i: Integer;
  ADimension: TZSMDimension;
begin
  for i := 0 to FDimPoznList.Count - 1 do
    with FList.FSizes.FModel do
      if FDimensionList.Find(FDimPoznList[i].FUname, ADimension) then
        ADimension.FValue := Data[i, ATypeRozmIndex];
end;

{
одержати значення
}
function TZSMSexType.GetData(ATypeRozmIndex, ADimPoznIndex: Integer): Double;
begin
  if (FDimPoznList.Count = 0) or (FTypeRozmList.Count = 0) then
  begin
    Result := -1;
    Exit
  end
  else Result := FData[ATypeRozmIndex, ADimPoznIndex];
end;

{
записати значення
}
procedure TZSMSexType.SetData(ATypeRozmIndex, ADimPoznIndex: Integer; const AValue: Double);
begin
  if not (ATypeRozmIndex >= 0) and (ATypeRozmIndex <= FTypeRozmList.Count - 1)
    then raise Exception.Create('Неправильний індекс масуву');
  if not (ADimPoznIndex >= 0)  and (ADimPoznIndex  <= FDimPoznList.Count - 1)
    then raise Exception.Create('Неправильний індекс масуву');
  FData[ATypeRozmIndex, ADimPoznIndex] := AValue;
end;

{
Список по-статі (унісекс, чол, жін, вагітні)
********************************************************************************
}
constructor TZSMSexTypeList.Create;
begin
  inherited Create;
  Add('унісекс');
  Add('чоловічі');
  Add('жіночі');
  Add('дитячі');
  Add('для вагітних');
  {Items[0].FTypeRozmList.Add('Стандарт');
  Items[0].FTypeRozmList.Add('XL');
  Items[2].FTypeRozmList.Add('48');
  Items[2].FTypeRozmList.Add('56');
  Items[0].FDimPoznList.Add('Довжина вуха', 'дв');
  Items[1].FDimPoznList.Add('Ширина вуха', 'шв'); }
end;

function TZSMSexTypeList.GetSexType(AIndex: Integer): TZSMSexType;
begin
  Result := TZSMSexType(inherited GetItem(AIndex));
end;

procedure TZSMSexTypeList.SetSexType(AIndex: Integer; AValue: TZSMSexType);
begin
  inherited SetItem(AIndex, AValue);
end;

function TZSMSexTypeList.Add(ATitle: String): Integer;
var
  AItem: TZSMSexType;
begin
  AItem := TZSMSexType.Create;
  AItem.FList := Self;
  AItem.FTitle := ATitle;
  Result := inherited Add(AItem);
  AItem.FItemIndex := Result;
end;

{
Розмірна лінійка
}
constructor TZSMSizes.Create;
begin
  inherited Create;
  FSexTypeList := TZSMSexTypeList.Create;
  FSexTypeList.FSizes := Self;
end;

destructor TZSMSizes.Destroy;
begin
  FSexTypeList.Free;
  inherited Destroy;
end;

procedure TZSMSizes.SaveXML(const AFileName: String);
var
  DOM: IXMLDOMDocument;
  nData, nTemp, nTemp1, nTemp2, nTemp3, nTemp4: IXMLDOMElement;
  nSexTypeList, nTypeRozmList, nDimPoznList, nDataList: IXMLDOMNode;
  i, j, k: Integer;
begin
  DOM := CoDOMDocument.Create;
  DOM.Set_async(false);
  try
    DOM.LoadXML(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
      '<data/>'
    );
    nData := DOM.Get_documentElement;
    nSexTypeList := nData.appendChild(XMLElement(DOM, 'sextypelist', ''));
    for i := 0 to FSexTypeList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('title', FSexTypeList[i].FTitle);
      nTypeRozmList := nTemp.appendChild(XMLElement(DOM, 'typerozmlist', ''));
      for j := 0 to FSexTypeList[i].FTypeRozmList.Count - 1 do
      begin
        nTemp1 := XMLElement(DOM, 'item', '');
        nTemp1.setAttribute('title', FSexTypeList[i].FTypeRozmList[j]);
        nTypeRozmList.appendChild(nTemp1);
      end;
      nDimPoznList := nTemp.appendChild(XMLElement(DOM, 'dimpoznlist', ''));
      for j := 0 to FSexTypeList[i].FDimPoznList.Count - 1 do
      begin
        nTemp2 := XMLElement(DOM, 'item', '');
        nTemp2.setAttribute('title', FSexTypeList[i].FDimPoznList[j].FTitle);
        nTemp2.setAttribute('uname', FSexTypeList[i].FDimPoznList[j].FUname);
        nDimPoznList.appendChild(nTemp2);
      end;
      nDataList := nTemp.appendChild(XMLElement(DOM, 'datalist', ''));
      for j := 0 to FSexTypeList[i].FTypeRozmList.Count - 1 do
      begin
        nTemp3 := XMLElement(DOM, 'item', '');
        for k := 0 to FSexTypeList[i].FDimPoznList.Count - 1 do
        begin
          nTemp4 := XMLElement(DOM, 'item', '');
          nTemp4.setAttribute('value', Format('%3.2f', [FSexTypeList[i].Data[k, j]]));
          nTemp3.appendChild(nTemp4);
        end;
        nDataList.appendChild(nTemp3);
      end;
      nSexTypeList.appendChild(nTemp);
    end;
    DOM.save(AFileName);
  finally
    DOM := nil;
  end;
end;

procedure TZSMSizes.LoadXML(const AFileName: String);
var
  DOM: IXMLDOMDocument;
  nData, nItem, nItem1, nItem2, nSexTypeList, nTypeRozmList, nDimPoznList,
  nDataList, nItem3, nItem4: IXMLDOMNode;
  i, j, k: Integer;
begin
  CheckFile(AFileName);
  FSexTypeList.Clear;
  DOM := CoDOMDocument.Create;
  try
    DOM.load(AFileName);
    nData := DOM.SelectSingleNode('data');
    nSexTypeList := nData.SelectSingleNode('sextypelist');
    for i := 0 to nSexTypeList.childNodes.length - 1 do
    begin
      nItem := nSexTypeList.childNodes.item[i];
      FSexTypeList.Add(nItem.attributes.getNamedItem('title').text);
      nTypeRozmList := nItem.SelectSingleNode('typerozmlist');
      for j := 0 to nTypeRozmList.childNodes.length - 1 do
      begin
        nItem1 := nTypeRozmList.childNodes.item[j];
        FSexTypeList[i].FTypeRozmList.Add(nItem1.attributes.getNamedItem('title').text);
      end;
      nDimPoznList := nItem.SelectSingleNode('dimpoznlist');
      for j := 0 to nDimPoznList.childNodes.length - 1 do
      begin
        nItem2 := nDimPoznList.childNodes.item[j];
        FSexTypeList[i].FDimPoznList.Add(
          nItem2.attributes.getNamedItem('title').text,
          nItem2.attributes.getNamedItem('uname').text
        );
      end;
      nDataList := nItem.SelectSingleNode('datalist');
      for j := 0 to nDataList.childNodes.length - 1 do
      begin
        nItem3 := nDataList.childNodes.item[j];
        for k := 0 to nItem3.childNodes.length - 1 do
        begin
          nItem4 := nItem3.childNodes.item[k];
          FSexTypeList[i].Data[k, j] :=
            StrToFloat(nItem4.attributes.getNamedItem('value').text);
        end;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create(Format('Помилка завантаження файлу "%s":'#13'%s',
        [AFileName, E.Message]));
  end;
end;

{
TZSMAngle - Кут (задається як значенням, так і формулою)
********************************************************************************
}
procedure TZSMAngle.SetFormula(Value: String);
begin
  SetFormula2(Value, False);
end;

procedure TZSMAngle.SetFormula2(Value: String; AMustRun: Boolean);
var
  s: String;
  i, j: Integer;
begin
  if (not AMustRun) and (FAngleFormula = Value) then Exit;
  s := UpperCase(Value);
  FAngleFormula := s;
  FValue := RunValue;
    for i := 0 to FPoint.FPointsList.Count - 1 do
    if (FPoint.FPointsList[i].FUname = FPoint.FUName) then
    begin
      for j := i + 1 to FPoint.FPointsList.Count - 1 do
        if FPoint.FPointsList[j].FAngle.VarInFormula(FPoint.FUName) then
        begin
          //FPoint.FPointsList[j].SetFormula2(FPoint.FPointsList[j].FLFormula, True);
          FPoint.FPointsList[j].FAngle.SetFormula2(FPoint.FPointsList[j].FAngle.Formula, True);
        end;
      Exit;
    end;
end;

function TZSMAngle.RunValue: Double;
var
  s: String;
begin
  s := FAngleFormula;
  FPoint.FPointsList.FModel.FormatEvalution(s);
  try
    Result := FPoint.FPointsList.FModel.FEval.Evaluate(s);
  except
    Result := 1;
  end;
end;

function TZSMAngle.VarInFormula(AVar: String): Boolean;
begin
  Result := (Pos2(AVar, FAngleFormula, 0) <> 0);
end;

{
Замір (позначення, підпис, величина)
********************************************************************************
}
procedure TZSMDimension.SetUName(Value: String);
begin
  if Value = FUname then Exit;
  FUname := UpperCase(Value);
end;

function TZSMDimension.FindDimensionIndex: Integer;
var
  i: Integer;
begin
  for i := 0 to FDimensionList.Count - 1 do
    if FDimensionList[i].FDimensionIndex = FDimensionIndex then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TZSMDimension.SetValue(AValue: Double);
var
  i: Integer;
begin
  if FValue = AValue then Exit;
  FValue := AValue;
  with FDimensionList.FModel do
    for i := 0 to FPointsList.Count - 1 do
      if FPointsList[i].VarInFormula(FUName) then
        FPointsList[i].SetFormula2(FPointsList[i].FLFormula, True);
end;

constructor TZSMPoint.Create;
begin
  inherited Create;
  FAngle := TZSMAngle.Create;
  FAngle.FPoint := Self;
  FObjectAngle := 0;
  FHMirror := False;
  FVMirror := False;
end;

destructor TZSMPoint.Destroy;
begin
  FAngle.Free;
  inherited Destroy;
end;

function TZSMPoint.GetX: Double;
begin
  case FPosType of
    ptXY: Result := FX;
    ptLine:
    begin
      if FPrePointIndex = -1 then
      begin
        Result := 0;
        Exit;
      end;
      if FAngle.Value = 0 then
      begin
        Result := FPointsList[PrePointIndex].X + FL;
        Exit;
      end;
      if FAngle.Value = 180 then
      begin
        Result := FPointsList[PrePointIndex].X - FL;
        Exit;
      end;
      if FAngle.Value = 90 then
      begin
        Result := FPointsList[PrePointIndex].X;
        Exit;
      end;
      if FAngle.Value = 270 then
      begin
        Result := FPointsList[PrePointIndex].X;
        Exit;
      end;
      Result := FPointsList[PrePointIndex].X + cos(pi / 180 * FAngle.Value) * FL;
    end;
    ptArc:;
  end;
end;

function TZSMPoint.GetY: Double;
begin
  case FPosType of
    ptXY: Result := FY;
    ptLine:
    begin
      if PrePointIndex = -1 then
      begin
        Result := 0;
        Exit;
      end;
      if FAngle.Value = 0 then
      begin
        Result := FPointsList[PrePointIndex].Y;
        Exit;
      end;
      if FAngle.Value = 180 then
      begin
        Result := FPointsList[PrePointIndex].Y;
        Exit;
      end;
      if FAngle.Value = 90 then
      begin
        Result := FPointsList[PrePointIndex].Y - FL;
        Exit;
      end;
      if FAngle.Value = 270 then
      begin
        Result := FPointsList[PrePointIndex].Y + FL;
        Exit;
      end;
      Result := FPointsList[PrePointIndex].Y - sin(pi / 180 * FAngle.Value) * FL;
    end;
    ptArc:;
  end;
end;

procedure TZSMPoint.SetX(Value: Double);
begin
  if FX <> Value then FX := Value;
end;

procedure TZSMPoint.SetY(Value: Double);
begin
  if FY <> Value then FY := Value;
end;

function TZSMPoint.GetXpx: Integer;
var
  AX: Double;
begin
  AX := X;
  if FPointsList[BasisIndex].HMirror then
    AX := - AX + 2 * FPointsList[BasisIndex].GetBaseCX;
  Result := Round(AX * FPointsList.FModel.FZoom);
end;

function TZSMPoint.GetYpx: Integer;
var
  AY: Double;
begin
  AY := Y;
  if FPointsList[BasisIndex].VMirror then
    AY := - AY + 2 * FPointsList[BasisIndex].GetBaseCY;
  Result := Round(AY * FPointsList.FModel.FZoom);
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseLXpx;
var
  i: Integer;
begin
  Result := GetXpx;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetXpx < Result then
          Result := FPointsList[i].GetXpx
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseRXpx;
var
  i: Integer;
begin
  Result := GetXpx;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetXpx > Result then
          Result := FPointsList[i].GetXpx
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseLYpx;
var
  i: Integer;
begin
  Result := GetYpx;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetYpx < Result then
          Result := FPointsList[i].GetYpx
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseRYpx;
var
  i: Integer;
begin
  Result := GetYpx;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetYpx > Result then
          Result := FPointsList[i].GetYpx
end;

function TZSMPoint.GetBaseLX;
var
  i: Integer;
begin
  Result := GetX;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetX < Result then
          Result := FPointsList[i].GetX
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseRX;
var
  i: Integer;
begin
  Result := GetX;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetX > Result then
          Result := FPointsList[i].GetX
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseLY;
var
  i: Integer;
begin
  Result := GetY;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetY < Result then
          Result := FPointsList[i].GetY
end;

{ координати розмірів блоку }
function TZSMPoint.GetBaseRY;
var
  i: Integer;
begin
  Result := GetY;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FUname <> FUName then
      if FPointsList[i].BasisIndex = FPointIndex then
        if FPointsList[i].GetY > Result then
          Result := FPointsList[i].GetY
end;

function TZSMPoint.GetBaseCX;
begin
  Result := Round((GetBaseLX + GetBaseRX) / 2);
end;

function TZSMPoint.GetBaseCY;
begin
  Result := Round((GetBaseLY + GetBaseRY) / 2);
end;

{
розрахунок довжини по-формулі
}
function TZSMPoint.RunFormula: Double;
var
  s: String;
begin
  Result := 0;
  s := FLFormula;
  FPointsList.FModel.FormatEvalution(s);
  Result := FPointsList.FModel.FEval.Evaluate(s);
end;

{
признак чи активна
}
function TZSMPoint.CheckSelected: Boolean;
begin
  Result := PointIndex = FPointsList.FSelected;
end;

{
задати назву точки і замінити у формулах та у відрізках
}
procedure TZSMPoint.SetUName(Value: String);
var
  i, j: Integer;
  AOldName, AValue: String;
begin
  if Value = FUName then Exit;

  AOldName := FUName;
  AValue := UpperCase(Value);

  for i := 0 to FPointsList.Count - 1 do
    if (FPointsList[i].FUname = AValue) and (i <> FPointIndex)
    then raise Exception.Create('Така точка вже існує. Задайте іншу назву');

  FUName := AValue;
  for i := 0 to FPointsList.Count - 1 do
    ZReplaseString(FPointsList[i].FLFormula, AOldName, FUName);

  for i := 0 to FPointsList.FModel.FSplineList.Count - 1 do
  begin
    for j := 0 to FPointsList.FModel.FSplineList[i].FPointsList.Count - 1 do
      if FPointsList.FModel.FSplineList[i].FPointsList[j] = AOldName
        then FPointsList.FModel.FSplineList[i].FPointsList[j]:= FUName;
  end;
end;

procedure TZSMPoint.SetFormula2(Value: String; AMustRun: Boolean);
var
  s: String;
  i, j: Integer;
begin
  if (not AMustRun) and (FLFormula = Value) then Exit;
  s := UpperCase(Value);
  FLFormula := s;
  FL := GetL;
  for i := 0 to FPointsList.Count - 1 do
    if (FPointsList[i].FUname = FUName) then
    begin
      for j := i + 1 to FPointsList.Count - 1 do
        if FPointsList[j].VarInFormula(FUName) then
          FPointsList[j].SetFormula2(FPointsList[j].FLFormula, True);
      Exit;
    end;
end;

procedure TZSMPoint.SetFormula(Value: String);
begin
  SetFormula2(Value, False);
end;

{
чи відображається відрізок від розрахункової точки
}
function TZSMPoint.CheckShowSpline: Boolean;
var
  s, bs: String;
  i: Integer;
begin
  Result := False;
  if FPrePointIndex = -1 then Exit;
  s  := FUName + ',' + FPointsList[FPrePointIndex].FUname;
  bs := FPointsList[FPrePointIndex].FUname + ',' + FUName;
  for i := 0 to FPointsList.FModel.FSplineList.Count - 1 do
  begin
    if ( s = FPointsList.FModel.FSplineList[i].FPointsList.CommaText) or
       (bs = FPointsList.FModel.FSplineList[i].FPointsList.CommaText) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

procedure TZSMPoint.SetSpline(Value: Boolean);
var
  i: Integer;
  s, bs: String;
begin
  if Value = CheckShowSpline then Exit;
  if FPrePointIndex = -1 then Exit;
  case Value of
    true: FPointsList.FModel.FSplineList.Add(FUName + ',' +
            FPointsList[FPrePointIndex].FUname, ltLine, 0.5);
    false:
    begin
      s  := FUName + ',' + FPointsList[FPrePointIndex].FUname;
      bs := FPointsList[FPrePointIndex].FUname + ',' + FUName;
      for i := 0 to FPointsList.FModel.FSplineList.Count - 1 do
         if ( s = FPointsList.FModel.FSplineList[i].FPointsList.CommaText) or
            (bs = FPointsList.FModel.FSplineList[i].FPointsList.CommaText) then
         begin
           FPointsList.FModel.FSplineList.Delete(i);
            exit;
         end;
    end;
  end;
end;

procedure TZSMPoint.SetPrePointIndex(Value: Integer);
begin
  if Value = PrePointIndex then Exit;
  if Value = PointIndex then
    raise EZSEval.Create('Неможливо рахувати точку від самої себе.');
  FPrePointIndex := FPointsList[Value].FPointIndex;
end;

function TZSMPoint.FindPointIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FPointIndex = FPointIndex then
    begin
      Result := i;
      Exit;
    end;
end;

function TZSMPoint.FindPrePointIndex: Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FPointsList.Count - 1 do
    if FPointsList[i].FPointIndex = FPrePointIndex then
    begin
      Result := i;
      Exit;
    end;
end;

function TZSMPoint.CheckInLayer(const ALayerIndex: Integer): Boolean;
begin
  Result := True;
end;

function TZSMPoint.GetL: Double;
begin
  try
    Result := RunFormula;
  except
    Result := 10;
  end;
end;

function TZSMPoint.VarInFormula(AVar: String): Boolean;
begin
  Result := (Pos2(AVar, FLFormula, 0) <> 0);
end;

{
одержання першої базисної точки (ptXY) для даної точки
}
function TZSMPoint.GetFirstBasisPoint: Integer;
var
  i: Integer;
begin
  Result := -1;
  if FPosType = ptXY then
  begin
    Result := FPointIndex;
    exit;
  end
  else Result := FPointsList[FindPrePointIndex].GetFirstBasisPoint;
end;

{
Викройка (підпис, опис)
********************************************************************************
}
constructor TZSMCut.Create;
begin
  inherited Create;
end;

destructor TZSMCut.Destroy;
begin
  inherited Destroy;
end;

{
Список шарів відрізка (яким належить відрізок)
********************************************************************************
}
function TZSMSplineLayerList.GetLayer(Index: Integer): TZSMSplineLayer;
begin
  Result := TZSMSplineLayer(inherited GetItem(Index));
end;

procedure TZSMSplineLayerList.SetLayer(Index: Integer; Value: TZSMSplineLayer);
begin
  inherited SetItem(Index, Value);
end;

function TZSMSplineLayerList.Add(const AChecked: Boolean): Integer;
var
  AItem: TZSMSplineLayer;
begin
  AItem := TZSMSplineLayer.Create;
  AItem.FChecked := AChecked;
  Result := inherited Add(AItem);
end;

{
TZSMLineElement - Універсальний відрізок (ламана, сплайн) побудови
********************************************************************************
}
constructor TZSMSpline.Create;
begin
  inherited Create;
  FSplineType := ltSpline;
  FPointsList := TStringList.Create;
  FLayerList := TZSMSplineLayerList.Create;
  FTension := 0.5;
end;

destructor TZSMSpline.Destroy;
begin
  FLayerList.Free;
  FPointsList.Free;
  inherited Create;
end;

function TZSMSpline.GetPoint(const Index: Integer): TZSMPoint;
begin
  Result := nil;
  if Index >= FPointsList.Count then
    raise Exception.Create('Невірний індекс елементу');
  Result := FSplineList.FModel.FPointsList.Find(FPointsList[Index]);
end;

function TZSMSpline.GetShortTitle: String;
begin
  case FPointsList.Count of
    0: Result := '<null>';
    1: Result := FPointsList[0];
    2: Result := FPointsList[0] + ', ' + FPointsList[1];
    3: Result := FPointsList[0] + ', ' + FPointsList[1] + ', ' + FPointsList[2]
    else
       Result := FPointsList[0] + ', ' + FPointsList[1] + ',... ' +
         FPointsList[FPointsList.Count - 1];
  end;       
end;

function TZSMSpline.GetTitle: String;
var
  i: Integer;
begin
  if FPointsList.Count = 0 then
  begin
    Result := '<null>';
    Exit;
  end;
  Result := FPointsList[0];
  for i := 1 to FPointsList.Count - 1 do
    Result := Result + ', ' + FPointsList[i];
end;

function TZSMSpline.FindSplineIndex: Integer;
var
  i: Integer;
begin
  for i := 0 to FSplineList.Count - 1 do
    if FSplineList[i].FSplineIndex = FSplineIndex then
    begin
      Result := i;
      Exit;
    end;
end;

{
TZSMSplineList - Список сплайнів побудови
********************************************************************************
}
function TZSMSplineList.GetSpline(Index: Integer): TZSMSpline;
begin
  Result := TZSMSpline(inherited GetItem(Index));
end;

procedure TZSMSplineList.SetSpline(Index: Integer; Value: TZSMSpline);
begin
  inherited SetItem(Index, Value);
end;

function TZSMSplineList.Add(AItem: TZSMSpline): Integer;
begin
  Result := inherited Add(AItem);
  Items[Result].FSplineList := Self;
  Items[Result].FSplineIndex := Result;
end;

function TZSMSplineList.Add(APoints: TStringList; ASplineType: TZSMSplineType;
  const ATension: Single; const ALayerIndex: Integer = 0): Integer;
var
  AItem: TZSMSpline;
  i: Integer;
begin
  AItem := TZSMSpline.Create;
  AItem.FPointsList.Clear;
  AItem.FPointsList.AddStrings(APoints);
  AItem.FSplineType := ASplineType;
  AItem.FTension := ATension;
  AItem.FLayerList.Clear;
  for i := 0 to FModel.FLayerList.Count - 1 do
    AItem.FLayerList.Add(ALayerIndex = i);
  Result := Add(AItem);
end;

function TZSMSplineList.Add(APointsStr: String; ASplineType: TZSMSplineType;
  const ATension: Single; const ALayerIndex: Integer = 0): Integer;
var
  AItem: TZSMSpline;
  i: Integer;
begin
  AItem := TZSMSpline.Create;
  AItem.FPointsList.Clear;
  AItem.FPointsList.CommaText := APointsStr;
  AItem.FSplineType := ASplineType;
  AItem.FTension := ATension;
  AItem.FLayerList.Clear;
  for i := 0 to FModel.FLayerList.Count - 1 do
    AItem.FLayerList.Add(ALayerIndex = i);
  Result := Add(AItem);
end;

{
Список замірів моделі
********************************************************************************
}
function TZSMDimensionList.GetDim(Index: Integer): TZSMDimension;
begin
  Result := TZSMDimension(inherited Items[Index]);
end;

procedure TZSMDimensionList.SetDim(Index: Integer; Value: TZSMDimension);
begin
  inherited SetItem(Index, Value);
end;

function TZSMDimensionList.Find(const AUname: String;
  var ADimension: TZSMDimension): Boolean;
var
  i: Integer;
begin
  Result := False;
  ADimension := nil;
  for i := 0 to Count - 1 do
    if AUname = Items[i].FUname then
    begin
      ADimension := Items[i];
      Result := True;
      Exit;
    end;
end;

function TZSMDimensionList.ValueByName(const AUname: String): Double;
var
  ADim: TZSMDimension;
begin
  Result := -1;
  if Find(AUname, ADim)
    then Result := ADim.FValue
    else raise EZS.Create(Format('Розмір "%s" не знайдено', [AUName]));
end;

function TZSMDimensionList.Add(AItem: TZSMDimension): Integer;
begin
  Result := inherited Add(AItem);
  Items[Result].FDimensionList := Self;
  Items[Result].FDimensionIndex := Result;
end;

function TZSMDimensionList.Add(AUname, ATitle: String; AValue: Double): Integer;
var
  AItem: TZSMDimension;
begin
  AItem := TZSMDimension.Create;
  AItem.FUname := UpperCase(AUName);
  AItem.FTitle := ATitle;
  AItem.FValue := AValue;
  Result := Add(AItem);
end;

{
Список шарів
********************************************************************************
}
function TZSMLayerList.GetLayer(Index: Integer): TZSMLayer;
begin
  Result := TZSMLayer(inherited Items[Index]);
end;

procedure TZSMLayerList.SetLayer(Index: Integer; Value: TZSMLayer);
begin
  inherited SetItem(Index, Value);
end;

function TZSMLayerList.Add(ATitle: String; AColor: Integer;
  const AWidth: Integer; const AChecked: Boolean = True): Integer;
var
  AItem: TZSMLayer;
begin
  AItem := TZSMLayer.Create;
  AItem.FParent := Self;
  AItem.FTitle := Atitle;
  AItem.FChecked := AChecked;
  AItem.FColor := AColor;
  AItem.FWidth := AWidth;
  Result := inherited Add(AItem);
  Selected := Result;
end;

{
Список точок
********************************************************************************
}
constructor TZSMPointsList.Create;
begin
  FSelected := -1;
end;

function TZSMPointsList.GetPoint(Index: Integer): TZSMPoint;
begin
  Result := TZSMPoint(inherited Items[Index]);
end;

procedure TZSMPointsList.SetPoint(Index: Integer; Value: TZSMPoint);
begin
  inherited SetItem(Index, Value);
end;

function TZSMPointsList.Find(const AUname: String; var APoint: TZSMPoint): Boolean;
var
  i: Integer;
begin
  Result := False;
  APoint := nil;
  for i := 0 to Count - 1 do
    if AUname = Items[i].FUname then
    begin
      APoint := Items[i];
      Result := True;
      Exit;
    end;
end;

function TZSMPointsList.Find(const AUname: String): TZSMPoint;
begin
  Find(AUName, Result);
end;

function TZSMPointsList.XByName(const AUname: String): Double;
var
  APoint: TZSMPoint;
begin
  Result := -1;
  if Find(AUname, APoint)
    then Result := APoint.X
    else raise EZS.Create(Format('Змінну "%s" не знайдено', [AUName]));
end;

function TZSMPointsList.YByName(const AUname: String): Double;
var
  APoint: TZSMPoint;
begin
  Result := -1;
  if Find(AUname, APoint)
    then Result := APoint.Y
    else raise EZS.Create(Format('Змінну "%s" не знайдено', [AUName]));
end;

function TZSMPointsList.Add(AItem: TZSMPoint): Integer;
begin
  Result := inherited Add(AItem);
  FSelected := Result;
  //Items[Result].FPointsList := Self;
  Items[Result].FPointIndex := Result;
end;

function TZSMPointsList.Add(
      const AUname: String;
      const APrePointIndex: Integer;
      const AAngle: String;
      const AFormula: String;
      const APosType: TZSMPosType;
      const ACentrePointIndex: Integer;
      const AX: Double;
      const AY: Double;
      const AddSpline: Boolean = True;
      const CheckSpline: Boolean = False): Integer;
var
  AItem: TZSMPoint;
  s: String;
begin
  AItem := TZSMPoint.Create;
  AItem.FPointsList := Self;
  AItem.FUname := UniquePointName(UpperCase(AUName));
  AItem.FPrePointIndex := APrePointIndex;
  s := UpperCase(AAngle);
  AItem.FAngle.Formula := s;
  s := UpperCase(AFormula);
  StrToCommaZ(s);
  AItem.Formula := s;
  AItem.FPosType := APosType;
  AItem.FCentrePointIndex := ACentrePointIndex;
  AItem.FX := AX;
  AItem.FY := AY;
  if CheckSpline then
    AItem.SetSpline(AddSpline);
  Result := Add(AItem);
end;

procedure TZSMPointsList.FromString(const ANames: String);
var
  s: TStringList;
  i: Integer;
begin
  Clear;
  s := TStringList.Create;
  try
    s.Delimiter := ';';
    s.DelimitedText := ANames;
    for i := 0 to s.Count - 1 do
      Add(s[i], -1, '0', '', ptLine, -1, 0, 0, true);
  finally
    s.Free;
  end;
end;

function TZSMPointsList.MinY: Double;
var
  i: Integer;
begin
  if Count = 0 then
  begin
    Result := 0;
    Exit;
    raise EZS.Create('Незадано відрізків для побудови');
  end;
  Result := Items[0].Y;
  for i := 0 to Count - 1 do
    if Items[i].Y < Result then Result := Items[i].Y;
end;

function TZSMPointsList.MaxY: Double;
var
  i: Integer;
begin
  if Count = 0 then
  begin
    Result := 0;
    Exit;
    raise EZS.Create('Незадано відрізків для побудови');
  end;
  Result := Items[0].Y;
  for i := 0 to Count - 1 do
    if Items[i].Y > Result then Result := Items[i].Y;
end;

function TZSMPointsList.MinX: Double;
var
  i: Integer;
begin
  if Count = 0 then
  begin
    Result := 0;
    Exit;
    raise EZS.Create('Незадано відрізків для побудови');
  end;
  Result := Items[0].X;
  for i := 0 to Count - 1 do
    if Items[i].X < Result then Result := Items[i].X;
end;

function TZSMPointsList.MaxX: Double;
var
  i: Integer;
begin
  if Count = 0 then
  begin
    Result := 0;
    Exit;
    raise EZS.Create('Незадано відрізків для побудови');
  end;
  Result := Items[0].GetX;
  for i := 0 to Count - 1 do
    if Items[i].X > Result then Result := Items[i].X;
end;

function TZSMPointsList.DivLength(const APoint1, APoint2: TZSMPoint): Double;
begin
  Result := Sqrt(
    sqr(APoint1.GetX - APoint2.GetX) +
    sqr(APoint1.GetY - APoint2.GetY));
end;

function TZSMPointsList.DivLength(const AIndex1, AIndex2: Integer): Double;
begin
  Result := DivLength(Items[AIndex1], Items[AIndex2]);
end;

function TZSMPointsList.DivLength(const AUName1, AUName2: String): Double;
begin
  Result := DivLength(Find(AUName1), Find(AUName2));
end;

function TZSMPointsList.DivLength(const ASegment: String): Double;
var
  s1, s2: String;
begin
  s1 := Copy(ASegment, 1, Pos('=', ASegment) - 1);
  s2 := Copy(ASegment, Pos('=', ASegment) + 1, Length(ASegment) -
    Pos('=', ASegment) + 1);
  Result := DivLength(Find(s1), Find(s2));
end;

function TZSMPointsList.AngleLength(const APoint1, APoint2: TZSMPoint): Double;
var
  a, b: Double;
begin
  { Вирахування чверті }
  a := - (APoint2.GetY - APoint1.GetY);
  b :=    APoint2.GetX - APoint1.GetX;
  { 0 or 180 }
  if a = 0 then
  begin
    case (b > 0) of
      True:  Result := 0;
      False: Result := 180;
    end;
    Exit;
  end;
  { 90 or 270 }
  if b = 0 then
  begin
    case (a > 0) of
      True:  Result := 90;
      False: Result := 270;
    end;
    Exit;
  end;
  { I }
  if (a > 0) and ( b > 0 ) then
  begin
    Result := arctan( abs(a) / abs(b) ) * 180 / Pi;
    Exit;
  end;
  { II }
  if ( a > 0 ) and ( b < 0 ) then
  begin
    Result := 180 - arctan( abs(a) / abs(b) ) * 180 / Pi;
    Exit;
  end;
  { III }
  if ( a < 0 ) and ( b < 0 ) then
  begin
    Result := 180 + arctan( abs(a) / abs(b) ) * 180 / Pi;
    Exit;
  end;
  { IV }
  if ( a < 0 ) and ( b > 0 ) then
  begin
    Result := 360 - arctan( abs(a) / abs(b) ) * 180 / Pi;
    Exit;
  end;
end;

function TZSMPointsList.AngleLength(const AIndex1, AIndex2: Integer): Double;
begin
  Result := AngleLength(Items[AIndex1], Items[AIndex2]);
end;

function TZSMPointsList.AngleLength(const AUName1, AUName2: String): Double;
begin
  Result := AngleLength(Find(AUName1), Find(AUName2));
end;

function TZSMPointsList.AngleLength(const ASegment: String): Double;
var
  s1, s2: String;
begin
  s1 := Copy(ASegment, 1, Pos('=', ASegment) - 1);
  s2 := Copy(ASegment, Pos('=', ASegment) + 1, Length(ASegment) -
    Pos('=', ASegment) + 1);
  Result := AngleLength(Find(s1), Find(s2));
end;

function TZSMPointsList.UniquePointName(AUName: String): String;
var
  i: Integer;
begin
  Result := AUName;
  for i := 0 to Count - 1 do
    if Items[i].FUname = Result then
    begin
      IncrementName(Result);
      Result := UniquePointName(Result);
    end;
end;

function TZSMPointsList.GetSelected: Integer;
begin
  Result := FSelected;
end;

procedure TZSMPointsList.SetSelected(AValue: Integer);
begin
  FSelected := AValue;
end;

function TZSMPointsList.Width: Double;
begin
  Result := MaxX - MinX;
end;

function TZSMPointsList.Height: Double;
begin
  Result := MaxY - MinY;
end;

function TZSMPointsList.WidthPx: Integer;
begin
  Result := Round(Width * FModel.FZoom);
end;

function TZSMPointsList.HeightPx: Integer;
begin
  Result := Round(Height * FModel.FZoom);
end;

{
TZSawingModel - Модель
********************************************************************************
}
constructor TZSewingModel.Create;
begin
  inherited Create;

  _c := Copy(Format('%1.1f', [1.1]), 2, 1)[1];

  FTitle := 'нова модель';
  FDescription := '';
  FEuroSize := esL;
  FSex := sMan;
  FDimensionList := TZSMDimensionList.Create;
  FDimensionList.FModel := Self;
  FCutList := TZSMCutList.Create;
  FCutList.FModel := Self;
  FPointsList := TZSMPointsList.Create;
  FPointsList.FModel := Self;
  FSplineList := TZSMSplineList.Create;
  FSplineList.FModel := Self;
  FZoom := 10;
  FLoaded := False;
  FEval := TEvaluator.Create;
  FLayerList := TZSMLayerList.Create;
  FLayerList.FModel := Self;

  FSizes := TZSMSizes.Create;
  FSizes.FModel := Self;
end;

destructor TZSewingModel.Destroy;
begin
  FSizes.Free;
  FSplineList.Free;
  FEval.Free;
  FDimensionList.Free;
  FCutList.Free;
  inherited Destroy;
end;

{
реальні координати через піксели
}
function TZSewingModel.GetX(const Xpx: Integer): Double;
begin
  Result := Xpx / FZoom;// + FPointsList.MinX;
end;

function TZSewingModel.GetY(const Ypx: Integer): Double;
begin
  Result := Ypx / FZoom;// + FPointsList.MinY;
end;


procedure TZSewingModel.Clear;
begin
  FTitle := 'нова модель';
  FDescription := '';
  FEuroSize := esL;
  FSex := sMan;
  FLayerList.Clear;
  FDimensionList.Clear;
  FCutList.Clear;
  FPointsList.Clear;
  FSplineList.Clear;
  FZoom := 10;
  FLoaded := True;
end;

procedure TZSewingModel.CreateNew;
begin
  Clear;
  FLayerList.Add('Базисна сітка', GetGridColor(0), 1);
  FPointsList.Add('T', -1, '0', '', ptXY, -1, 10, 10, False);
end;

procedure TZSewingModel.SetEuroSize(AValue: TZSMEuroSize);
begin
  FEuroSize := AValue;
end;

procedure TZSewingModel.SetSex(AValue: TZSMSex);
begin
  FSex := AValue;
end;

procedure TZSewingModel.Build;
var
  i: Integer;
begin
  for i := 0 to FCutList.Count - 1 do
    FCutList[i].Build;
end;

procedure TZSewingModel.DoOnLoad;
begin
  if Assigned(FOnLoad) then FOnLoad(Self);
end;

{
форматування виразу: заміна змінних числами
}
procedure TZSewingModel.FormatEvalution(var AString: String);
var
  i, p, pe, p2: Integer;
  c: Char;
  s: String;
begin
  StrToCommaZ(AString);

  for i := 0 to FDimensionList.Count - 1 do
    ZReplaseString(AString, FDimensionList[i].FUName, Format('%3.2f',
      [FDimensionList[i].FValue]));

  { пошук довжин }
  pe := 1;
  repeat
    p := Pos2('LENGTH(', AString, pe);
    if p > 0 then
    begin
      p2 := Pos2(')', AString, p + 7);
      s := Copy(AString, p + 7 + 1, p2 - p - 7 - 2);
      Delete(AString, p, p2 - p + 1);
      Insert(Format('%3.2f', [FPointsList.DivLength(s)]), AString, p);
    end;
    pe := p + 1;
  until p = 0;

  { пошук кута }
  pe := 1;
  repeat
    p := Pos2('ANGLE(', AString, pe);
    if p > 0 then
    begin
      p2 := Pos2(')', AString, p + 6);
      s := Copy(AString, p + 6 + 1, p2 - p - 6 - 2);
      Delete(AString, p, p2 - p + 1);
      Insert(Format('%3.2f', [FPointsList.AngleLength(s)]), AString, p);
    end;
    pe := p + 1;
  until p = 0;


end;

procedure TZSewingModel.SaveXML(const AFileName: String);
var
  DOM: IXMLDOMDocument;
  nData, nTemp, nTemp2: IXMLDOMElement;
  nLayers, nDimensions, nVars, nPoints, nSplines, nSLayers: IXMLDOMNode;
  i, j: Integer;
  s: String;

begin
  DOM := CoDOMDocument.Create;
  DOM.Set_async(false);
  try
    DOM.LoadXML(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
      '<data/>'
    );
    nData := DOM.Get_documentElement;
    nData.setAttribute('title', FTitle);
    nData.setAttribute('sex', ord(FSex));
    nData.setAttribute('description', FDescription);
    nLayers := nData.appendChild(XMLElement(DOM, 'layers', ''));
    for i := 0 to FLayerList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('title',    FLayerList[i].FTitle);
      nTemp.setAttribute('color',    FLayerList[i].FColor);
      nTemp.setAttribute('width',    FLayerList[i].FWidth);
      case FLayerList[i].FChecked of
        true:  s := '1';
        false: s := '0';
      end;
      nTemp.setAttribute('checked', s);
      nLayers.appendChild(nTemp);
    end;
    nDimensions := nData.appendChild(XMLElement(DOM, 'dimensions', ''));
    for i := 0 to FDimensionList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('uname', FDimensionList[i].FUname);
      nTemp.setAttribute('title', FDimensionList[i].FTitle);
      nTemp.setAttribute('value', FDimensionList[i].FValue);
      nDimensions.appendChild(nTemp);
    end;
    nPoints := nData.appendChild(XMLElement(DOM, 'points', ''));
    for i := 0 to FPointsList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('uname',            FPointsList[i].FUname);
      nTemp.setAttribute('prepointindex',    FPointsList[i].PrePointIndex);
      nTemp.setAttribute('angle',            FPointsList[i].FAngle.Formula);
      nTemp.setAttribute('formula',          FPointsList[i].Formula);
      nTemp.setAttribute('postype',          FPointsList[i].FPosType);
      nTemp.setAttribute('centrepointindex', FPointsList[i].FCentrePointIndex);
      nTemp.setAttribute('x',                FPointsList[i].FX);
      nTemp.setAttribute('y',                FPointsList[i].FY);
      nPoints.appendChild(nTemp);
    end;
{    nSegments := nData.appendChild(XMLElement(DOM, 'segments', ''));
    for i := 0 to FSegmentList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('title', FSegmentList[i].Title);
      nSLayers := nTemp.appendChild(XMLElement(DOM, 'slayers', ''));
      for j := 0 to FSegmentList[i].FLayerList.Count - 1 do
      begin
        case FSegmentList[i].FLayerList[j].FChecked of
          true:  s := '1';
          false: s := '0';
        end;
        nTemp2 := XMLElement(DOM, 'item', '');
        nTemp2.setAttribute('checked', s);
        nSLayers.appendChild(nTemp2);
      end;
      nSegments.appendChild(nTemp);
    end; }
    nSplines := nData.appendChild(XMLElement(DOM, 'splines', ''));
    for i := 0 to FSplineList.Count - 1 do
    begin
      nTemp := XMLElement(DOM, 'item', '');
      nTemp.setAttribute('title', FSplineList[i].FPointsList.CommaText);
      nTemp.setAttribute('ltype', FSplineList[i].FSplineType);
      nTemp.setAttribute('tension', FSplineList[i].FTension);
      nSLayers := nTemp.appendChild(XMLElement(DOM, 'slayers', ''));
      for j := 0 to FSplineList[i].FLayerList.Count - 1 do
      begin
        case FSplineList[i].FLayerList[j].FChecked of
          true:  s := '1';
          false: s := '0';
        end;
        nTemp2 := XMLElement(DOM, 'item', '');
        nTemp2.setAttribute('checked', s);
        nSLayers.appendChild(nTemp2);
      end;
      nSplines.appendChild(nTemp);
    end;
    DOM.save(AFileName);
  finally
    DOM := nil;
  end;
end;

procedure TZSewingModel.OpenCorel(const AInFileName: String);
begin
  if not FileExists(AInFileName) then
    raise Exception.Create(Format('Файл шаблону "%s" не знайдено', [AInFileName]));
  //відкрити файл CorelDraw
  try
    ZCorelOpen(FV, PChar(AInFileName), True);
  except
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

{
Експорт в CorelDraw
}
procedure TZSewingModel.ExportToCorelDraw(const AInFileName, AOutFileName: String);
var
  i: Integer;
begin
  OpenCorel(AInFileName);
  DrawText(_cdr_left, _cdr_widthy - _cdr_left - 40, 100, clBlack, FTitle);
  DrawText(_cdr_left, _cdr_widthy - _cdr_left - 70,  60, clBlack, FDescription);
  for i := 0 to FLayerList.Count - 1 do
    DrawLayer(FLayerList[i], i);
end;

procedure TZSewingModel.DrawPoint(const Ax, Ay: Double; const ATitle: String;
  const AColor: TColor = clBlack; const ARadius: double = 1.6;
  const DoDrawText: Boolean = True);
var
  s, s2: Variant;
begin
  s := FV.ActiveLayer.CreateEllipse2(
    mmToDuim(AX), mmToDuim(AY), mmToDuim(ARadius), mmToDuim(ARadius), -90, -90,
    True);
  s.Fill.UniformColor.RGBAssign(
    GetRValue(AColor),
    GetGValue(AColor),
    GetBValue(AColor));
  s2 := FV.Parent.OutlineStyles[0];
  s.Outline.Style := s2;
  s.Outline.Width := 0.003;
  s.Outline.Color.RGBAssign(0, 0, 0);
  if DoDrawText then
    DrawText(Ax + 5, Ay + 5, 20, clBlack, ATitle);
end;

{
побудова шару в CorelDraw
}
procedure TZSewingModel.DrawLayer(const ALayer: TZSMLayer; const i: Integer);
var
  j, k: Integer;
begin
  { якщо базис }
  if i = 0 then
    FV.ActiveLayer.Name := 'Base Layer'
  else begin
    ZCorelInsertLayer(FV, 1, PChar(Format('Layer  %2d', [i + 1])));
    Sleep(200);
  end;
  DrawText(_cdr_left + 500, _cdr_widthy - _cdr_left - 40, 70, ALayer.FColor,
    '(' + ALayer.FTitle + ')');
  for j := 0 to FSplineList.Count - 1 do
    if FSplineList[j].FLayerList.Count - 1 >= i then
    if FSplineList[j].FLayerList[i].FChecked then
    begin
      for k := 0 to FSplineList[j].FPointsList.Count - 2 do
        DrawLine(
                        _cdr_left + FPointsList.Find(FSplineList[j].FPointsList[k    ]).X * 10,
          _cdr_widthy - _cdr_left - FPointsList.Find(FSplineList[j].FPointsList[k    ]).Y * 10,
                        _cdr_left + FPointsList.Find(FSplineList[j].FPointsList[k + 1]).X * 10,
          _cdr_widthy - _cdr_left - FPointsList.Find(FSplineList[j].FPointsList[k + 1]).Y * 10,
          ALayer.FColor
        );
      for k := 0 to FSplineList[j].FPointsList.Count - 1 do
        DrawPoint(
                        _cdr_left + FPointsList.Find(FSplineList[j].FPointsList[k]).X * 10,
          _cdr_widthy - _cdr_left - FPointsList.Find(FSplineList[j].FPointsList[k]).Y * 10,
          '',
          ALayer.FColor,
          1.6,
          False
        );  
    end;
  {for j := 0 to FSegmentList.Count - 1 do
    if FSegmentList[j].FLayerList.Count - 1 >= i then
      if FSegmentList[j].FLayerList[i].FChecked then
      begin
        DrawLine(
                        _cdr_left + FSegmentList[j].GetX1 * 10,
          _cdr_widthy - _cdr_left - FSegmentList[j].GetY1 * 10,
                        _cdr_left + FSegmentList[j].GetX2 * 10,
          _cdr_widthy - _cdr_left - FSegmentList[j].GetY2 * 10,
          ALayer.FColor
        );
        DrawPoint(
                        _cdr_left + FSegmentList[j].GetX1 * 10,
          _cdr_widthy - _cdr_left - FSegmentList[j].GetY1 * 10,
          '',
          ALayer.FColor,
          1.6,
          False
        );
        DrawPoint(
                        _cdr_left + FSegmentList[j].GetX2 * 10,
          _cdr_widthy - _cdr_left - FSegmentList[j].GetY2 * 10,
          '',
          ALayer.FColor,
          1.6,
          False
        );
      end;}
end;

procedure TZSewingModel.DrawLine(const Ax1, Ay1, Ax2, Ay2: Double;
  const AColor: TColor; const AWidth: double = 1);
var
  s, s2: Variant;
begin
  s := FV.ActiveLayer.CreateLineSegment(mmToDuim(Ax1), mmToDuim(Ay1),
    mmToDuim(Ax2), mmToDuim(Ay2));
  s2 := FV.Parent.OutlineStyles[0];
  s.Outline.Style := s2;
  s.Outline.Width := 0.02777;
  s.Outline.Color.RGBAssign(
    GetRValue(AColor),
    GetGValue(AColor),
    GetBValue(AColor));
end;

procedure TZSewingModel.DrawText(const Ax, Ay: Double;
  const AFontSize: Integer; const AColor: TColor; const AText: String);
var
  s: Variant;
begin
  if AText = '' then Exit;
  s := FV.ActiveLayer.CreateArtisticText(mmToDuim(Ax), mmToDuim(Ay), AText);
  s.Text.FontProperties.Size := AFontSize;
  s.Fill.UniformColor.RGBAssign(
    GetRValue(AColor),
    GetGValue(AColor),
    GetBValue(AColor));
end;

procedure TZSewingModel.LoadXML(const AFileName: String; var AErrorList: TStringList);
var
  DOM:IXMLDOMDocument;
  nData, nLayers, nDimensions, nItem, nVars, nPoints, nSegments,
  nSLayers, nItem2, nSplines: IXMLDOMNode;
  i, awidth, j, SelLayerCount, k: Integer;
  s: Boolean;
  ts, AUname: String;
  pt: TZSMPosType;
  ATension: Single;
begin
  CheckFile(AFileName);
  Clear;
  DOM := CoDOMDocument.Create;
  try
    DOM.load(AFileName);
    FLoadIndex := lInfo;
    DoOnLoad;
    nData := DOM.SelectSingleNode('data');
    FTitle := nData.attributes.getNamedItem('title').text;
    FSex   := TZSMSex(StrToInt(nData.attributes.getNamedItem('sex').text));
    FDescription := nData.attributes.getNamedItem('description').text;
    FLoadIndex := lLayers;
    DoOnLoad;
    nLayers := nData.SelectSingleNode('layers');
    for i := 0 to nLayers.childNodes.length - 1 do
    begin
      nItem := nLayers.childNodes.item[i];
      case nItem.attributes.getNamedItem('checked').text[1] of
        '0': s := false;
        '1': s := true;
      end;
      try
        awidth := StrToInt(nItem.attributes.getNamedItem('width').text)
      except
        awidth := 1;
      end;
      FLayerList.Add(
        nItem.attributes.getNamedItem('title').text,
        StrToInt(nItem.attributes.getNamedItem('color').text),
        awidth,
        s
      );
    end;
    FLoadIndex := lDimensions;
    DoOnLoad;
    nDimensions := nData.SelectSingleNode('dimensions');
    for i := 0 to nDimensions.childNodes.length - 1 do
    begin
      nItem := nDimensions.childNodes.item[i];
      FDimensionList.Add(
        nItem.attributes.getNamedItem('uname').text,
        nItem.attributes.getNamedItem('title').text,
        StrToFloatZ(nItem.attributes.getNamedItem('value').text)
      );
    end;
    FLoadIndex := lPoints;
    DoOnLoad;
    nPoints := nData.SelectSingleNode('points');
    for i := 0 to nPoints.childNodes.length - 1 do
    begin
      nItem := nPoints.childNodes.item[i];
      AUname := nItem.attributes.getNamedItem('uname').text;
      k := StrToInt(nItem.attributes.getNamedItem('prepointindex').text);
      pt := TZSMPosType(StrToInt(nItem.attributes.getNamedItem('postype').text));
      if k >= i then
      begin
        AErrorList.Add(Format('%s [PointIndex = %d, PrePointIndex = %d]', [AUName, i, k]));
        k := -1;
        pt := ptXY;
      end;
      FPointsList.Add(
        AUName,
        k,
        nItem.attributes.getNamedItem('angle').text,
        nItem.attributes.getNamedItem('formula').text,
        pt,
        StrToInt(nItem.attributes.getNamedItem('centrepointindex').text),
        StrToFloatZ(nItem.attributes.getNamedItem('x').text),
        StrToFloatZ(nItem.attributes.getNamedItem('y').text),
        false,
        false
      );
    end;
    FLoadIndex := lSplines;
    DoOnLoad;
    nSplines := nData.SelectSingleNode('splines');
    for i := 0 to nSplines.childNodes.length - 1 do
    begin
      nItem := nSplines.childNodes.item[i];
      try

        ATension := StrToFloatZ(nItem.attributes.getNamedItem('tension').text);
      except
        ATension := 0.5;
      end;
      FSplineList.Add(
        nItem.attributes.getNamedItem('title').text,
        TZSMSplineType(StrToInt(nItem.attributes.getNamedItem('ltype').text)),
        ATension
      );
      try
        nSLayers := nItem.SelectSingleNode('slayers');
        FSplineList[i].FLayerList.Clear;
        SelLayerCount := 0;
        for j := 0 to nSLayers.childNodes.length - 1 do
        begin
          nItem2 := nSLayers.childNodes.item[j];
          case nItem2.attributes.getNamedItem('checked').text[1] of
            '0': s := false;
            '1': s := true;
          end;
          if s then inc(SelLayerCount);
          FSplineList[i].FLayerList.Add(s);
        end;
        if FSplineList[i].FLayerList.Count = 0 then
          FSplineList[i].FLayerList.Add(true);
        if SelLayerCount = 0 then
          FSplineList[i].FLayerList[0].FChecked := True;
      except
        FSplineList[i].FLayerList.Clear;
        FSplineList[i].FLayerList.Add(true);
      end; 
    end;
  except
    on E: Exception do
      raise Exception.Create(Format('Помилка завантаження файлу "%s":'#13'%s',
        [AFileName, E.Message]));
  end;
end;

{
TZSMCutList - Список замірів моделі
********************************************************************************
}
function TZSMCutList.GetCut(Index: Integer): TZSMCut;
begin
  Result := TZSMCut(inherited Items[Index]);
end;

procedure TZSMCutList.SetCut(Index: Integer; Value: TZSMCut);
begin
  inherited SetItem(Index, Value);
end;

function TZSMCutList.Add(AItem: TZSMCut): Integer;
begin
  Result := inherited Add(AItem);
  Items[Result].FCutList := Self;
end;

function TZSMCutList.Add(ATitle: String; ADescription: String): Integer;
var
  AItem: TZSMCut;
begin
  AItem := TZSMCut.Create;
  AItem.FTitle := ATitle;
  AItem.FDescription := ADescription;
  Result := Add(AItem);
end;

end.
