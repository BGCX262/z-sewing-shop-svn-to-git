{
********************************************************************************

   Компонент GeoLas - зчитування з файлу, перевірка, формування Las-файлів,
   запис в XML-формат

   Залежності:
     ZGeoLasExceptions,
     ZGeoConst,
     LoadZExcelDll (..//DLLs/ZExcel.dll),
     ZLas,
     ZLog

   (с) Зореслав Гораль, НДПІ ВАТ "Укрнафта", 2010р.

   Початок:       26.01.2010р.
   Останні зміни: 16.02.2010р.

********************************************************************************

16.02.2010 - Зчитування з файлу XML. Розробка структури XML

26.01.2010 - початок розробки структури, визначення основних полів і методів

********************************************************************************
}
unit ZGeoLas;

interface

uses
  ZGeoLasExceptions, //виключні ситуації
  ZGeoConst,         //константи
  LoadZExcelDll,     //функції роботи з Excel
  ZLas,              //компонент Las
  ZLog,

  Classes, Contnrs, SysUtils, Variants, ComObj, IniFiles, msxml;

type
  {
  Випереджаючі оголошення
  }
  TZglErrorList = class;
  TZGLIndexPage = class;
  TZGLWellList  = class;
  TZGLRozList   = class;
  TZGLIntList   = class;
  TZGLCurveItem = class;
  TZGLCurveList = class;

  { тип помилок }
  TZgleType = (
    gleUnknow,
    gleNotHorizonts,
    gleNotModValue,
    gleHorizontsNext,

    gleNotIndexPage, //відсутня сторінка індексації

    gleNotIntPage,   //відсутня сторінка INT_
    gleNotRozPage,   //відсутня сторінка ROZ_

    gleIntFormat,
    gleDoubleFormat,

    gleNotRoz,
    gleRozBlockName,
    gleRozDept,
    gleRozMod,
    gleRozNext,
    gleRozNextDept,
    gleRozNotInIndex,

    gleNotInt,
    gleIntDept,
    gleIntMod,
    gleIntNextDept,
    gleIntNotInRoz,
    gleIntDeptNotInRoz,

    gleLITO_01,
    glePORO_01,
    gleSOIL_01,
    gleSGAS_01,
    gleHEF_01,
    gleHEFO_01,
    gleHEFW_01
  );

  {
  Опції перевірки GeoLas
  }
  TZGLCheckOptions = class
  private
    FCheckBlockName: Boolean;
    FCheckMod: Boolean;
  public
    property CheckBlockName: Boolean read FCheckBlockName write FCheckBlockName default False;
    property CheckMod: Boolean read FCheckMod write FCheckMod default False;
    procedure SaveIni(const AFileName: String);
    procedure LoadIni(const AFileName: String);
  end;

  {
  Опції експорту LAS
  }
  TZGLLasOptions = class
  private
    { крок }
    FStep: Double;
    { покрівля по колектору }
    FTopCollector: Boolean;
    { підошва по колектору }
    FBottomCollector: Boolean;
    { будувати криву NTG }
    FNTG: Boolean;
  public
    constructor Create;
    property Step: Double read FStep write FStep;
    property TopCollector: Boolean read FTopCollector write FTopCollector;
    property BottomCollector: Boolean read FBottomCollector write FBottomCollector;
    property NTG: Boolean read FNTG write FNTG;
  end;

  {
  Основний класс
  }
  TZGeoLas = class(TComponent)
  private
    { Опції перевірки GeoLas }
    FCheckOptions: TZGLCheckOptions;
    { Опції експорту LAS }
    FLasOptions: TZGLLasOptions;
    FFieldName: String;
    FFieldID: Integer;
    FDescription: TStringList;
    FErrorList: TZGLErrorList;
    FIndexPage: TZGLIndexPage;
    FWellList: TZGLWellList;
    FOnStopError: TNotifyEvent;
    FOnFinishLoadIndexPage: TNotifyEvent;
    { Завантажено наступну свердловину }
    FOnFinishLoadNextWell: TNotifyEvent;
    { Криві. Просто список всіх, що будуть зустрічатись }
    FCurveList: TZGLCurveList;
    { LAS-ка }
    FLas: TZLas;
    { Журнал }
    FLog: TZLog;
    procedure SetLas(Value: TZLas);
    function GetLas: TZLas;
    procedure SetLog(Value: TZLog);
    function GetLog: TZLog;
  protected
    { OnStopError -- процедура події помилки для зупинки подальшого
    завантаження }
    procedure StopError; dynamic;
    { OnFinishLoadIndexPage-- процедура події закінчення завантаження сторінки
    індексації}
    procedure FinishLoadIndexPage; dynamic;
    procedure FinishLoadNextWell; dynamic;
  published
    property OnStopError: TNotifyEvent read FOnStopError write FOnStopError;
    property OnFinishLoadIndexPage: TNotifyEvent read FOnFinishLoadIndexPage
      write FOnFinishLoadIndexPage;
    property OnFinishLoadNextWell: TNotifyEvent read FOnFinishLoadNextWell
      write FOnFinishLoadNextWell;
    property Las: TZLas read GetLas write SetLas;
    property Log: TZLog read GetLog write SetLog;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property CheckOptions: TZGLCheckOptions read FCheckOptions write FCheckOptions;
    property LasOptions: TZGLLasOptions read FLasOptions write FLasOptions;
    property FieldName: String read FFieldName write FFieldName;
    property ErrorList: TZGLErrorList read FErrorList write FErrorList;
    property IndexPage: TZGLIndexPage read FIndexPage write FIndexPage;
    property WellList: TZGLWellList read FWellList write FWellList;
    property CurveList: TZGLCurveList read FCurveList;
    property Description: TStringList read FDescription write FDescription;
    property FieldID: Integer read FFieldID write FFieldID;

    { Зчитати з файла Excel }
    procedure LoadXLS(const AFileName: String);
    { Зчитати з файла XML }
    procedure LoadXML(const AFileName: String);
    { Зберегти в файл XML }
    procedure SaveXML(const AFileName: String);
  end;

  {
  один рядок сторінки індексації
  }
  TZGLIndexItem = class
  private
    FIndexPage: TZGLIndexPage;
    FUHorizontName: String;
    FIndexName: Integer;
    FHorizontName: String;
    procedure CheckMod;
    procedure CheckNext(const AIndex: Integer);
  public
    property UHorizontName: String read FUHorizontName write FUHorizontName;
    property IndexName: Integer read FIndexName write FIndexName;
    property HorizontName: String read FHorizontName write FHorizontName;
  end;

  {
  сторінка індексації
  }
  TZGLIndexPage = class(TObjectlist)
  private
    FGeoLas: TZGeoLas;
    function GetZItem(AIndex: Integer): TZGLIndexItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLIndexItem);
    { Зчитати з файла Excel }
    procedure LoadXLS(const V: Variant);
    procedure CheckErrors;
  public
    function Add(const AItem: TZGLIndexItem): Integer; overload;
    function Add(const AUHorizontName: String; const AIndexName: Integer;
      const AHorizontName: String): Integer; overload;

    property Items[Index: Integer]: TZGLIndexItem read GetZItem write SetZItem;
      default;
  end;

  TZGLErrorItem = class
  private
    FErrorList: TZglErrorList;
    FgleType: TZgleType;
    FxlsPage: String;
    FxlsRow:  Integer;
    FxlsCol:  Integer;
    FErrorString: String;
    FWellIndex: Integer;
  public
    property gleType: TZgleType read FgleType;
    property xlsPage: String read FxlsPage;
    property xlsRow: Integer read FxlsRow;
    property xlsCol: Integer read FxlsCol;
    property ErrorString: String read FErrorString;
    property WellIndex: Integer read FWellIndex;
  end;

  {
  Список помилок
  }
  TZGLErrorList = class(TObjectList)
  private
    FGeoLas: TZGeoLas;
    function GetZItem(AIndex: Integer): TZGLErrorItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLErrorItem);
  public
    function Add(const AItem: TZGLErrorItem): Integer; overload;
    function Add(const AGLEType: TZGLEType; const AxlsPage: String;
      const AxlsRow, AxlsCol:  Integer; const AErrorString: String;
      const AWellIndex: Integer = -1): Integer; overload;
    procedure SaveToFile(const AFileName: String);

    property Items[Index: Integer]: TZGLErrorItem read GetZItem write SetZItem;
      default;
  end;

  {
  свердловина
  }
  TZGLWellItem = class
  private
    FWellList: TZGLWellList;
    FTitle: String;
    FID: Integer;
    FIsRoz: Boolean;
    FIsInt: Boolean;
    FIntIndex: Integer;
    FRozIndex: Integer;
    FHasError: Boolean;
    FWellIndex: Integer;
    FErrorList: TZGLErrorList;
    FRozList: TZGLRozList;
    FIntList: TZGLIntList;
    procedure GetZGLErrorList;
    procedure CheckRoz;
    procedure CheckInt;
  public
    constructor Create;
    destructor Destroy; override;
    property Title: String read FTitle;
    property ID: Integer read FID;
    property HasError: Boolean read FHasError;
    property ErrorList: TZGLErrorList read FErrorList;
    property RozList: TZGLRozList read FRozList;
    property IntList: TZGLIntList read FIntList;
    procedure ExportLas(const AFileName: String);
  end;

  {
  Список помилок
  }
  TZGLWellList = class(TObjectList)
  private
    FGeoLas: TZGeoLas;
    function GetZItem(AIndex: Integer): TZGLWellItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLWellItem);
    { пошук сторінок свердловин }
    procedure FindWellsSheets(const V: Variant);
    procedure CheckErrors;
    function GetErrorString: String;
    procedure GetZGLErrorList;
    procedure LoadXLS(const V: Variant);
    procedure SetRozItems;
  public
    function Add(const AItem: TZGLWellItem): Integer; overload;
    function Add(const ATitle: String; const AID: Integer = -1): Integer; overload;
    function AddInt(const ATitle: String; const APageIndex: Integer): Integer;
    function AddRoz(const ATitle: String; const APageIndex: Integer): Integer;

    property Items[Index: Integer]: TZGLWellItem read GetZItem write SetZItem;
      default;
    property ErrorString: String read GetErrorString;
  end;

  {
  Елемент розбивки по свердловині
  }
  TZGLRozItem = class
  private
    { батько }
    FRozList: TZGLRozList;
    { індекс }
    FIndexName: Integer;
    { інтервал: від-до }
    FDeptFrom: Double;
    FDeptTo:   Double;
    { блок }
    FBlockName: String;
    { індекс горизонту (TZGLIndexItem), що відповідає даному }
    FIndexItem: TZGLIndexItem;
    function CheckBlockName: Boolean;
    function CheckDept: Boolean;
    function CheckMod: Boolean;
    function CheckNext(const AIndex: Integer): Boolean;
    function CheckNextDept(const ADept: Double): Boolean;
    function CheckInIndexPage: Boolean;
    function CheckDeptIn(const ADept: Double): Boolean;
    function CheckDeptAfter(const ADept: Double): Boolean;
    function CheckDeptBefore(const ADept: Double): Boolean;
  public
    property IndexName: Integer read FIndexName write FIndexName;
    property DeptFrom: Double read FDeptFrom write FDeptFrom;
    property DeptTo:   Double read FDeptTo   write FDeptTo;
    property BlockName: String read FBlockName write FBlockName;
  end;

  {
  Список розбивок по свердловині
  }
  TZGLRozList = class(TObjectList)
  private
    FWellItem: TZGLWellItem;
    function GetZItem(AIndex: Integer): TZGLRozItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLRozItem);
    function CheckErrors: Boolean;
    procedure LoadXLS(const V: Variant);
    function GetIndexName(const ADept: Double): Integer;
  public
    function Add(const AItem: TZGLRozItem): Integer; overload;
    function Add(const AIndexName: Integer; const AD1, AD2: Double;
      const ABlockName: String): Integer; overload;
    property Items[Index: Integer]: TZGLRozItem read GetZItem write SetZItem;
      default;
  end;

  {
  Елемент INT по свердловині
  }
  TZGLIntItem = class
  private
    { батько }
    FIntList: TZGLIntList;
    { індекс }
    FIndexName: Integer;
    { інтервал: від-до }
    FDeptFrom: Double;
    FDeptTo:   Double;
    { TZGLRozItem, що відповідає даному }
    FRozItem: TZGLRozItem;
    { порядковий індекс }
    FOrdIndex: Integer;
    { встановлює RozItem що відповідає даному }
    procedure SetRozItem;
    function CheckDept: Boolean;
    function CheckMod: Boolean;
    function CheckNextDept(const ADept: Double): Boolean;
    { перевірка чи є індекс на сторінці ROZ }
    function CheckInRoz: Boolean;
    { перевірка чи діапазон відповідає дыапазону на сторінці ROZ }
    function CheckDeptInRoz: Boolean;
    { повертає величину кривої по її назві }
    function CurveValueByName(const AName: String): Double;
    { повертає величину кривої по її індексу }
    function GetCurveValue(Index: Integer): Double;
  public
    property IndexName: Integer read FIndexName write FIndexName;
    property DeptFrom: Double read FDeptFrom write FDeptFrom;
    property DeptTo:   Double read FDeptTo   write FDeptTo;
    property CurveValue[Index: Integer]: Double read GetCurveValue;
    function CheckDeptIn(const ADept: Double): Boolean;
  end;

  {
  Список кривих
  }
  TZGLCurveList = class(TObjectlist)
  private
    FIntList: TZGLIntList;
    function GetZItem(AIndex: Integer): TZGLCurveItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLCurveItem);
  public
    function Add(const AItem: TZGLCurveItem): Integer; overload;
    function Add(const ATitle, AUName: String;
      const ADataIndex: Integer = -1;
      const DoUpperCase: Boolean = True): Integer; overload;
    function FindByName(const AName: String; const DoRaise: Boolean = True): TZGLCurveItem;

    property Items[Index: Integer]: TZGLCurveItem read GetZItem write SetZItem;
      default;
  end;

  {
  Крива
  }
  TZGLCurveItem = class
  private
    FCurveList: TZGLCurveList;
    FDataIndex: Integer;
    FTitle: String;
    FUName: String;
    { віртуальна функція, ініціалізується в похідних }
    function CheckError: Boolean; virtual; abstract;
    function GetValue(Index: Integer): Double;
    procedure SetValue(Index: Integer; AValue: Double);
    function GetItemsCount: Integer;
    function GetMinValue: Double;
    function GetMaxValue: Double;
  public
    property Title: String read FTitle write FTitle;
    property UName: String read FUName write FUName;
    property Values[Index: Integer]: Double read GetValue write SetValue;
    property ItemsCount: Integer read GetItemsCount;
    property MinValue: Double read GetMinValue;
    property MaxValue: Double read GetMaxValue;
  end;

  {
  Крива по-замовчуванню. Походить від кривої
  }
  TZGLDefaultCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива LITO. Походить від кривої
  }
  TZGLLitoCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива PORO. Походить від кривої
  }
  TZGLPoroCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива SOIL. Походить від кривої
  }
  TZGLSoilCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива SGAS. Походить від кривої
  }
  TZGLSgasCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива HEF. Походить від кривої
  }
  TZGLHefCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива HEFO. Походить від кривої
  }
  TZGLHefoCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Крива HEFW. Походить від кривої
  }
  TZGLHefwCurveItem = class(TZGLCurveItem)
  private
    function CheckError: Boolean; override;
  end;

  {
  Список INT по свердловині
  }
  TZGLIntList = class(TObjectList)
  private
    FWellItem: TZGLWellItem;
    { дані -- двовимірний масив }
    FData: Array of Array of Double;
    { криві }
    FCurveList: TZGLCurveList;
    function GetZItem(AIndex: Integer): TZGLIntItem;
    procedure SetZItem(AIndex: Integer; Value: TZGLIntItem);
    function CheckErrors: Boolean;
    procedure LoadXLS(const V: Variant);
    procedure FillCurvesToParent;
    procedure SetRozItems;
    function GetCurveValue(const ADept: Double; ACurveIndex: Integer): Double;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AItem: TZGLIntItem): Integer; overload;
    function Add(const AIndexName: Integer; const AD1, AD2: Double): Integer;
      overload;
    property Items[Index: Integer]: TZGLIntItem read GetZItem write SetZItem;
      default;
    property CurveList: TZGLCurveList read FCurveList write FCurveList;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BBIC', [TZGeoLas]);
end;

procedure CheckFile(const AFileName: String);
begin
  if not FileExists(AFileName) then
    raise EZGLLoad.Create(Format(_s_filenotfound, [AFileName]));
end;

function StrToFloatZ(const AString: String): Double;
var
  s: String;
  c: Char;
  i: Integer;
begin
  c := Copy(Format('%1.1f', [1.1]), 2, 1)[1];
  s := AString;
  for i := 1 to Length(s) do
  begin
    if s[i] = '.' then s[i] := c;
    if s[i] = ',' then s[i] := c;
  end;
  Result := StrToFloat(s);
end;

function ZRound(const Value: Double; const pw: Integer): Double;
var
  i, k: Integer;
begin
  k := 1;
  for i := 0 to pw - 2 do
    k := k * 10;
  Result := Round(Value * k) / k;
end;

{
Опції експорту LAS
********************************************************************************
}
constructor TZGLLasOptions.Create;
begin
  inherited Create;
  FStep := 0.2;
  FTopCollector := False;
  FBottomCollector := False;
  FNTG := False;
end;

{
Опції перевірки GeoLas
********************************************************************************
}
procedure TZGLCheckOptions.SaveIni(const AFileName: String);
var
  f: TIniFile;
begin
  f := TIniFile.Create(AFileName);
  try
    f.WriteBool('CheckOptions', 'BlockName', FCheckBlockName);
    f.WriteBool('CheckOptions', 'Mod',       FCheckMod);
  finally
    f.Free;
  end;
end;

procedure TZGLCheckOptions.LoadIni(const AFileName: String);
var
  f: TIniFile;
begin
  f := TIniFile.Create(AFileName);
  try
    FCheckBlockName := f.ReadBool('CheckOptions', 'BlockName', false);
    FCheckMod       := f.ReadBool('CheckOptions', 'Mod',       true);
  finally
    f.Free;
  end;
end;

{
TZGeoLas
********************************************************************************
}
constructor TZGeoLas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFieldID := -1;
  FCheckOptions := TZGLCheckOptions.Create;
  FErrorList := TZGLErrorList.Create;
  FErrorList.FGeoLas := Self;
  FIndexPage := TZGLIndexPage.Create;
  FIndexPage.FGeoLas := Self;
  FWellList := TZGLWellList.Create;
  FWellList.FGeoLas := Self;
  FCurveList := TZGLCurveList.Create;
  FLasOptions := TZGLLasOptions.Create;
  FDescription := TStringList.Create;
  FDescription.Add('немає коментарів');
end;

destructor TZGeoLas.Destroy;
begin
  FDescription.Free;
  FCurveList.Clear;
  FWellList.Free;
  FIndexPage.Free;
  FErrorList.Free;
  FCheckOptions.Free;
  FLasOptions.Free;
  inherited Destroy;
end;

{
Зчитати з файла Excel
}
procedure TZGeoLas.LoadXLS(const AFileName: String);
var
  V: Variant;
begin
  { TODO : поток!!! }
  CheckFile(AFileName);
  try
    FLog.Add(Format('Відкриття файлу "%s"', [AFileName]));
    ExcOpen(V, PChar(AFileName), False);
  except
    on E: Exception do
      raise EZGLExcel.Create(Format(_s_xlsloaderror, [AFileName, E.Message]));
  end;
  FErrorList.Clear;
  FCurveList.Clear;
  FLog.Add('Завантаження сторінки індексації');
  FIndexPage.LoadXLS(V);
  FLog.Add('Перевірка помилок сторінки індексації');
  FIndexPage.CheckErrors;
  FLog.Add('Пошук сторінок з свердловинами. Формування списку свердловин');
  FWellList.FindWellsSheets(V);
  FLog.Add('Завантаження сторінок свердловин');
  FWellList.LoadXLS(V);
  FLog.Add('Визначення відповідності між ROZ та Int');
  FWellList.SetRozItems;
  FLog.Add('Перевірка помилок сторінок свердловин');
  FWellList.CheckErrors;
  FWellList.GetZGLErrorList;
  try
    FLog.Add(Format('Закриття файлу "%s"', [AFileName]));
    ExcClose(V);
  except
    on E: Exception do
      raise EZGLExcel.Create(Format(_s_xlscloserror, [AFileName, E.Message]));
  end;
end;

{
Зчитати з файла XML
}
procedure TZGeoLas.LoadXML(const AFileName: String);
var
  DOM:IXMLDOMDocument;
  nData, nDescr, nItem, nItem2, nField, nIndexPage, nWells, nRoz,
  nInt: IXMLDOMNode;
  i, j, k, l: Integer;
  s: String;

  function IsCurve(const AString: String): Boolean;
  begin
    result := (Copy(AString, 1, 6) = 'curve_');
  end;

  function GetCurveName(const AString: String): String;
  begin
    Result := Copy(AString, 7, Length(s) - 7 + 1);
  end;

begin
  CheckFile(AFileName);
  DOM := CoDOMDocument.Create;
  try
    FLog.Add(Format('Відкриття файлу "%s"', [AFileName]));
    DOM.load(AFileName);
    nData := DOM.SelectSingleNode('data');

    FDescription.Clear;
    nDescr := nData.SelectSingleNode('description');
    for i := 0 to nDescr.childNodes.length - 1 do
    begin
      nItem := nDescr.childNodes.item[i];
      FDescription.Add(nItem.attributes.getNamedItem('line').text)
    end;
    { інформація про родовище }
    nField := nData.SelectSingleNode('field');
    FFieldName := nField.attributes.getNamedItem('name').text;
    FFieldID := StrToInt(nField.attributes.getNamedItem('id').text);
    { сторінка індексації }
    FIndexPage.Clear;
    nIndexPage := nData.SelectSingleNode('indexpage');
    for i := 0 to nIndexPage.childNodes.length - 1 do
    begin
      nItem := nIndexPage.childNodes.item[i];
      FIndexPage.Add(
        nItem.attributes.getNamedItem('uindex').text,
        StrToInt(nItem.attributes.getNamedItem('index').text),
        nItem.attributes.getNamedItem('name').text
      );
    end;
    FIndexPage.CheckErrors;
    { свердловини }
    FWellList.Clear;
    nWells := nData.SelectSingleNode('wells');
    for i := 0 to nWells.childNodes.length - 1 do
    begin
      nItem := nWells.childNodes.item[i];
      FWellList.Add(
        nItem.attributes.getNamedItem('name').text,
        StrToInt(nItem.attributes.getNamedItem('id').text)
      );
      FWellList[i].FIsRoz := True;
      FWellList[i].FIsInt := True;
      FWellList[i].FRozList.Clear;
      nRoz := nItem.SelectSingleNode('roz');
      for j := 0 to nRoz.childNodes.length - 1 do
      begin
        nItem2 := nRoz.childNodes.item[j];
        FWellList[i].FRozList.Add(
          StrToInt(nItem2.attributes.getNamedItem('index').text),
          StrToFloatZ(nItem2.attributes.getNamedItem('from').text),
          StrToFloatZ(nItem2.attributes.getNamedItem('to').text),
          nItem2.attributes.getNamedItem('block').text
        );
      end;
      FWellList[i].FIntList.Clear;
      FWellList[i].FIntList.FCurveList.Clear;
      nInt := nItem.SelectSingleNode('int');
      for j := 0 to nInt.childNodes.length - 1 do
      begin
        nItem2 := nInt.childNodes.item[j];
        FWellList[i].FIntList.Add(
          StrToInt(nItem2.attributes.getNamedItem('index').text),
          StrToFloatZ(nItem2.attributes.getNamedItem('from').text),
          StrToFloatZ(nItem2.attributes.getNamedItem('to').text)
        );
        for k := 0 to nInt.childNodes.item[j].attributes.length - 1 do
        begin
          s := nInt.childNodes.item[j].attributes[k].nodeName;
          if IsCurve(s) then
          begin
            if (FWellList[i].FIntList.FCurveList.FindByName(GetCurveName(s), False) = nil) then
            begin
              l := FWellList[i].FIntList.FCurveList.Add(GetCurveName(s), GetCurveName(s));
              FWellList[i].FIntList.FCurveList[l].FDataIndex := l;
            end;
            SetLength(FWellList[i].FIntList.FData,
              FWellList[i].FIntList.FCurveList.Count,
              FWellList[i].FIntList.Count
            );
            WellList[i].FIntList.FCurveList.FindByName(GetCurveName(s)).Values[j] :=
              StrToFloatZ(nInt.childNodes.item[j].attributes[k].nodeValue);
          end;
        end;
        WellList[i].FIntList.FillCurvesToParent;
      end;
    end;
    FWellList.SetRozItems;
    FWellList.CheckErrors;
    FWellList.GetZGLErrorList;
  except
    on E: Exception do
      raise EZGLXML.Create(Format(_s_xmlloaderror, [AFileName, E.Message]));
  end;
end;

{
Зберегти в файл XML
}
procedure TZGeoLas.SaveXML(const AFileName: String);
var
  DOM: IXMLDOMDocument;
  nData, nTemp: IXMLDOMElement;
  nDescr, nIndexPage, nField, nWells, nWell, nRoz, nInt: IXMLDOMNode;
  i, j, k: Integer;

  function XMLElement(const name, text: string): IXMLDOMElement;
  begin
    Result := DOM.createElement(name);
    Result.text := text;
  end;

begin
  DOM := CoDOMDocument.Create;
  DOM.Set_async(false);
  try
    DOM.LoadXML(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
      '<data/>'
    );
    nData := DOM.Get_documentElement;
    nDescr := nData.appendChild(XMLElement('description', ''));
    for i := 0 to FDescription.Count - 1 do
    begin
      nTemp := XMLElement('item', '');
      nTemp.setAttribute('line', FDescription[i]);
      nDescr.appendChild(nTemp);
    end;
    nTemp := XMLElement('field', '');
    nTemp.setAttribute('id',   IntToStr(FFieldID));
    nTemp.setAttribute('name', FFieldName);
    nField := nData.appendChild(nTemp);
    nIndexPage := nData.appendChild(XMLElement('indexpage', ''));
    for i := 0 to FIndexPage.Count - 1 do
    begin
      nTemp := XMLElement('item', '');
      nTemp.setAttribute('index',  IntToStr(FIndexPage[i].FIndexName));
      nTemp.setAttribute('uindex', FIndexPage[i].FUHorizontName);
      nTemp.setAttribute('name',   FIndexPage[i].FHorizontName);
      nIndexPage.appendChild(nTemp);
    end;
    nWells := nData.appendChild(XMLElement('wells', ''));
    for i := 0 to FWellList.Count - 1 do
    begin
      nTemp := XMLElement('item', '');
      nTemp.setAttribute('id',   IntToStr(FWellList[i].FID));
      nTemp.setAttribute('name', FWellList[i].FTitle);
      nWell := nWells.appendChild(nTemp);
      nRoz := nWell.appendChild(XMLElement('roz', ''));
      for j := 0 to FWellList[i].FRozList.Count - 1 do
      begin
        nTemp := XMLElement('item', '');
        nTemp.setAttribute('index', Format('%d',    [FWellList[i].FRozList[j].FIndexName]));
        nTemp.setAttribute('from',  Format('%5.2f', [FWellList[i].FRozList[j].FDeptFrom]));
        nTemp.setAttribute('to',    Format('%5.2f', [FWellList[i].FRozList[j].FDeptTo]));
        nTemp.setAttribute('block', FWellList[i].FRozList[j].FBlockName);
        nRoz.appendChild(nTemp);
      end;
      nInt := nWell.appendChild(XMLElement('int', ''));
      for j := 0 to FWellList[i].FIntList.Count - 1 do
      begin
        nTemp := XMLElement('item', '');
        nTemp.setAttribute('index', Format('%d',    [FWellList[i].FIntList[j].FIndexName]));
        nTemp.setAttribute('from',  Format('%5.2f', [FWellList[i].FIntList[j].FDeptFrom]));
        nTemp.setAttribute('to',    Format('%5.2f', [FWellList[i].FIntList[j].FDeptTo]));
        for k := 0 to FWellList[i].FIntList.FCurveList.Count - 1 do
        begin
          nTemp.setAttribute(
            Format('curve_%s', [FWellList[i].FIntList.FCurveList[k].FTitle]),
            Format('%5.4f',    [FWellList[i].FIntList.FCurveList[k].GetValue(j)])
          );
        end;
        nInt.appendChild(nTemp);
      end;
    end;
    DOM.save(AFileName);
  finally
    DOM := nil;
  end;
end;

{
OnStopError -- процедура події помилки для зупинки подальшого завантаження
}
procedure TZGeoLas.StopError;
begin
  if Assigned(FOnStopError) then FOnStopError(Self);
end;

procedure TZGeoLas.FinishLoadIndexPage;
begin
  if Assigned(FOnFinishLoadIndexPage) then FOnFinishLoadIndexPage(Self);
end;

procedure TZGeoLas.FinishLoadNextWell;
begin
  if Assigned(FOnFinishLoadNextWell) then FOnFinishLoadNextWell(Self);
end;

procedure TZGeoLas.SetLas(Value: TZLas);
begin
  FLas := Value;
end;

function TZGeoLas.GetLas: TZLas;
begin
  Result := FLas;
end;

procedure TZGeoLas.SetLog(Value: TZLog);
begin
  FLog := Value;
end;

function TZGeoLas.GetLog: TZLog;
begin
  Result := FLog;
end;

{
TZGLErrorList
********************************************************************************
}
function TZGLErrorList.GetZItem(AIndex: Integer): TZGLErrorItem;
begin
  Result := TZGLErrorItem(inherited Items[AIndex]);
end;

procedure TZGLErrorList.SetZItem(AIndex: Integer; Value: TZGLErrorItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLErrorList.Add(const AItem: TZGLErrorItem): Integer;
begin
  Result := inherited Add(AItem);
end;

function TZGLErrorList.Add(const AGLEType: TZGLEType; const AxlsPage: String;
  const AxlsRow, AxlsCol:  Integer; const AErrorString: String;
  const AWellIndex: Integer = -1): Integer;
var
  AItem: TZGLErrorItem;
begin
  AItem := TZGLErrorItem.Create;
  AItem.FGLEType := AGLEType;
  AItem.FxlsPage := AxlsPage;
  AItem.FxlsRow := AxlsRow;
  AItem.FxlsCol := AxlsCol;
  AItem.FErrorString := AErrorString;
  AItem.FWellIndex := AWellIndex;
  Result := Add(AItem);
end;

procedure TZGLErrorList.SaveToFile(const AFileName: String);
var
  i: Integer;
  f: TextFile;
begin
  AssignFile(f, AFileName);
  try
    ReWrite(f);
    WriteLn(f, Format(_s_errorlog, [DateToStr(Now)]));
    for i := 0 to Count - 1 do
      WriteLn(f, Format(_s_erroritem, [i + 1, Ord(Items[i].FgleType),
        Items[i].FxlsPage, Items[i].FxlsRow, Items[i].FxlsCol,
        Items[i].FErrorString]));
  finally
    CloseFile(f);
  end;
end;

{
TZGLIndexItem
********************************************************************************
}
procedure TZGLIndexItem.CheckMod;
begin
  if FIndexName mod 2 <> 0 then
    FIndexPage.FGeoLas.FErrorList.Add(
      gleNotModValue,
      'INDEX',
      0,
      0,
      Format(_s_notmodhorizont, [FHorizontName])
    );
end;

procedure TZGLIndexItem.CheckNext(const AIndex: Integer);
begin
  if AIndex <= FIndexName then
    FIndexPage.FGeoLas.FErrorList.Add(
      gleHorizontsNext,
      'INDEX',
      0,
      0,
      Format(_s_horizontnext, [AIndex, FIndexName])
    );
end;

{
TZGLIndexPage
********************************************************************************
}
function TZGLIndexPage.GetZItem(AIndex: Integer): TZGLIndexItem;
begin
  Result := TZGLIndexItem(inherited Items[AIndex]);
end;

procedure TZGLIndexPage.SetZItem(AIndex: Integer; Value: TZGLIndexItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLIndexPage.Add(const AItem: TZGLIndexItem): Integer;
begin
  Result := inherited Add(AItem);
end;

function TZGLIndexPage.Add(const AUHorizontName: String;
  const AIndexName: Integer; const AHorizontName: String): Integer;
var
  AItem: TZGLIndexItem;
begin
  AItem := TZGLIndexItem.Create;
  AItem.FIndexPage := Self;
  AItem.FUHorizontName := AUHorizontName;
  AItem.FIndexName := AIndexName;
  AItem.FHorizontName := AHorizontName;
  Result := Add(AItem);
end;

{
Зчитати з файла Excel
}
procedure TZGLIndexPage.LoadXLS(const V: Variant);
var
  IndexPage, i, yr, ti: Integer;
  Arr: Variant;
begin
  FGeoLas.FLog.Add('Пошук сторінки індексації');
  ExcFindSheet(V, 'index', IndexPage);
  if IndexPage = -1 then { сторінку індексації не знайдено }
  begin
    FGeoLas.FErrorList.Add(gleNotIndexPage, 'index', 0, 0, _s_indexnotfound);
    FGeoLas.StopError;
    Exit;
  end;
  Clear;
  FGeoLas.FLog.Add('Завантаження горизонтів');
  FGeoLas.FFieldName := V.Sheets.Item[IndexPage].Cells[1, 1];
  yr := V.Sheets.Item[IndexPage].UsedRange.Rows.Count;
  ExcGetRangeArray(V.Sheets.Item[IndexPage], Arr, 1, 2, 3, yr);
  for i := 0 to yr - 2 do
  begin
    if (String(Arr[i + 1, 3]) <> '') then
    begin
    { TODO : перевірка на integer }
      try
        ti := Arr[i + 1, 1];
      except
        ti := -1;
        FGeoLas.FErrorList.Add(
          gleIntFormat,
          'INDEX',
          i + 1,
          1,
          Format(_s_intformat, ['']),
          -1
        )
      end;
      Add(String(Arr[i + 1, 2]), ti, String(Arr[i + 1, 3]));
    end;
  end;
  Arr := unassigned;
  FGeoLas.FinishLoadIndexPage;
end;

procedure TZGLIndexPage.CheckErrors;
var
  i: Integer;
begin
  if Count = 0 then
    FGeoLas.FErrorList.Add(
      gleNotHorizonts,
      'INDEX',
      0,
      0,
      _s_nothorizonts
    );
  for i := 0 to Count - 1 do
  begin
    if FGeoLas.FCheckOptions.FCheckMod then
      Items[i].CheckMod;
    if i < (Count - 1) then
      Items[i].CheckNext(Items[i + 1].FIndexName);
  end;
end;

{
TZGLWellItem
********************************************************************************
}
constructor TZGLWellItem.Create;
begin
  inherited Create;
  FErrorList := TZGLErrorList.Create;
  FRozList := TZGLRozList.Create;
  FRozList.FWellItem := Self;
  FIntList := TZGLIntList.Create;
  FIntList.FWellItem := Self;
  FTitle := 'new well';
  FID := -1;
end;

destructor TZGLWellItem.Destroy;
begin
  FIntList.Free;
  FRozList.Free;
  FErrorList.Free;
  inherited Destroy;
end;

procedure TZGLWellItem.GetZGLErrorList;
var
  i: Integer;
begin
  FErrorList.Clear;
  for i := 0 to FWellList.FGeoLas.ErrorList.Count - 1 do
    if FWellList.FGeoLas.ErrorList[i].FWellIndex = FWellIndex then
      FErrorList.Add(
        FWellList.FGeoLas.ErrorList[i].gleType,
        FWellList.FGeoLas.ErrorList[i].xlsPage,
        FWellList.FGeoLas.ErrorList[i].FxlsRow,
        FWellList.FGeoLas.ErrorList[i].FxlsCol,
        FWellList.FGeoLas.ErrorList[i].FErrorString,
        FWellList.FGeoLas.ErrorList[i].FWellIndex
      );
end;

procedure TZGLWellItem.CheckRoz;
begin
  if not FIsRoz then
  begin
    FHasError := True;
    FWellList.FGeoLas.FErrorList.Add(
      gleNotRozPage,
      Format('ROZ_%s', [FTitle]),
      0,
      0,
      Format(_s_roznotfound, [FTitle, FTitle]),
      FWellIndex
    );
  end;
  if FRozList.CheckErrors then
    FHasError := True;
end;

procedure TZGLWellItem.CheckInt;
begin
  if not FIsInt then
  begin
    FHasError := True;
    FWellList.FGeoLas.FErrorList.Add(
      gleNotIntPage,
      Format('INT_%s', [FTitle]),
      0,
      0,
      Format(_s_intnotfound, [FTitle, FTitle]),
      FWellIndex
    );
  end;
  if FIntList.CheckErrors then
    FHasError := True;
end;

procedure TZGLWellItem.ExportLas(const AFileName: String);
var
  i, i_md, i_zl: Integer;
  r: Double;
begin
  if FHasError then
    raise EZGLExportLas.Create(Format(_s_wellerror, [FTitle]));
  FWellList.FGeoLas.FLas.Curves.Clear;
  {
  загальна інформація
  }
  FWellList.FGeoLas.FLas.Comments := FWellList.FGeoLas.FLas.Comments +
    ' (from GeoLas file)';
  FWellList.FGeoLas.FLas.NameField := FWellList.FGeoLas.FFieldName;
  {
  інформація по св-ні
  }
  FWellList.FGeoLas.FLas.NameWell := FTitle;
  FWellList.FGeoLas.FLas.StartValue := FRozList[0].FDeptFrom - FWellList.FGeoLas.FLasOptions.FStep;
  FWellList.FGeoLas.FLas.StopValue  := FRozList[RozList.Count - 1].FDeptTo;
  FWellList.FGeoLas.FLas.StepValue := FWellList.FGeoLas.FLasOptions.FStep;
  {
  додавання кривих
  }
  { глибина }
  i_md := FWellList.FGeoLas.FLas.Curves.Add;
  FWellList.FGeoLas.FLas.Curves[i_md].ID      := _md_curve_name;
  FWellList.FGeoLas.FLas.Curves[i_md].DimUnit := _md_curve_dim;
  FWellList.FGeoLas.FLas.Curves[i_md].Descr   := _md_curve_descr;
  { ZONELOG }
  i_zl := FWellList.FGeoLas.FLas.Curves.Add;
  FWellList.FGeoLas.FLas.Curves[i_zl].ID      := _zl_curve_name;
  FWellList.FGeoLas.FLas.Curves[i_zl].DimUnit := _zl_curve_dim;
  FWellList.FGeoLas.FLas.Curves[i_zl].Descr   := _zl_curve_descr;
  { решта кривих }
  for i := 0 to FIntList.FCurveList.Count - 1 do
  begin
    FWellList.FGeoLas.FLas.Curves.Add;
    FWellList.FGeoLas.FLas.Curves[i + 2].ID := FIntList.FCurveList[i].FTitle;
  end;
  {
  Заповнення даними
  }
  { глибини }
  r := FWellList.FGeoLas.FLas.StartValue;
  while (r <= FWellList.FGeoLas.FLas.StopValue) do
  begin
    FWellList.FGeoLas.FLas.Curves[i_md].Add(r);
    FWellList.FGeoLas.FLas.Curves[i_zl].Add(FRozList.GetIndexName(r));
    for i := 0 to FIntList.FCurveList.Count - 1 do
      FWellList.FGeoLas.FLas.Curves[i + 2].Add(FIntList.GetCurveValue(r, i));
    r := Round((r + FWellList.FGeoLas.FLas.StepValue) * 10)/10;
  end;
  {
  збереження las
  }
  FWellList.FGeoLas.FLas.SaveToLasFile(AFileName);
end;

{
TZGLWellList
********************************************************************************
}
function TZGLWellList.GetZItem(AIndex: Integer): TZGLWellItem;
begin
  Result := TZGLWellItem(inherited Items[AIndex]);
end;

procedure TZGLWellList.SetZItem(AIndex: Integer; Value: TZGLWellItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLWellList.Add(const AItem: TZGLWellItem): Integer;
begin
  AItem.FWellList := Self;
  Result := inherited Add(AItem);
  AItem.FWellIndex := Result;
end;

function TZGLWellList.Add(const ATitle: String; const AID: Integer = -1): Integer;
var
  AItem: TZGLWellItem;
begin
  AItem := TZGLWellItem.Create;
  AItem.FTitle := ATitle;
  AItem.FID := AID;
  AItem.FIsInt := False;
  AItem.FIsRoz := False;
  AItem.FIntIndex := -1;
  AItem.FRozIndex := -1;
  AItem.FHasError := False;
  Result := Add(AItem);
end;

function TZGLWellList.AddInt(const ATitle: String;
  const APageIndex: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if UpperCase(Items[i].FTitle) = UpperCase(ATitle) then
    begin
      Items[i].FIsInt := True;
      Items[i].FIntIndex := APageIndex;
      Exit;
    end;
  Result := Add(UpperCase(ATitle));
  Items[Result].FIsInt := True;
  Items[Result].FIntIndex := APageIndex;
end;

function TZGLWellList.AddRoz(const ATitle: String;
  const APageIndex: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if UpperCase(Items[i].FTitle) = UpperCase(ATitle) then
    begin
      ITems[i].FIsRoz:= True;
      Items[i].FRozIndex := APageIndex;
      Exit;
    end;
  Result := Add(UpperCase(ATitle));
  Items[Result].FIsRoz := True;
  Items[Result].FRozIndex := APageIndex;
end;

{
пошук сторінок свердловин
}
procedure TZGLWellList.FindWellsSheets(const V: Variant);
var
  i: Integer;
  s: String;
begin
  Clear;
  for i := 0 to V.Sheets.Count - 1 do
  begin
    s := V.Sheets.Item[i + 1].Name;
    if UpperCase(Copy(s, 1, 4)) = 'INT_' then
      AddInt(Copy(s, 5, Length(s)), i + 1);
    if UpperCase(Copy(s, 1, 4)) = 'ROZ_' then
      AddRoz(Copy(s, 5, Length(s)), i + 1);
  end;
end;

procedure TZGLWellList.CheckErrors;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].CheckRoz;
    Items[i].CheckInt;
  end;
end;

function TZGLWellList.GetErrorString: String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    if Items[i].HasError then
      if Result = ''
        then Result := Items[i].Title
        else Result := Result + ', ' + Items[i].Title;
  end;
end;

procedure TZGLWellList.GetZGLErrorList;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].GetZGLErrorList;
end;

procedure TZGLWellList.SetRozItems;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].FIntList.SetRozItems;
end;

procedure TZGLWellList.LoadXLS(const V: Variant);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].FIntList.LoadXLS(V);
    Items[i].FIntList.FillCurvesToParent;
    Items[i].FRozList.LoadXLS(V);
    FGeoLas.FinishLoadNextWell;
  end;
end;

{
TZGLRozItem
********************************************************************************
}
function TZGLRozItem.CheckBlockName: Boolean;
begin
  Result :=  (FBlockName = '');
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozBlockName,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_notblockname, [FRozList.FWellItem.FTitle, FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckDept: Boolean;
begin
  Result :=  (FDeptFrom >= FDeptTo);
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozDept,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_rozdept, [FDeptFrom, FDeptTo, FRozList.FWellItem.FTitle, FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckMod: Boolean;
begin
  Result :=  not ((FIndexName mod 2) = 0);
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozMod,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_rozmod, [FIndexName, FRozList.FWellItem.FTitle, FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckNext(const AIndex: Integer): Boolean;
begin
  Result := (AIndex < FIndexName);
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozNext,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_roznext, [AIndex, FIndexName, FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckNextDept(const ADept: Double): Boolean;
begin
  Result := not (FDeptTo <= ADept);
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozNextDept,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_roznextdept, [ADept, FDeptTo, FIndexName,
        FRozList.FWellItem.FTitle, FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckInIndexPage: Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to FRozList.FWellItem.FWellList.FGeoLas.FIndexPage.Count - 1 do
   if FRozList.FWellItem.FWellList.FGeoLas.FIndexPage[i].FIndexName = FIndexName
     then
     begin
       Result := False;
       Exit;
     end;
  if Result then
    FRozList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleRozNotInIndex,
      Format('ROZ_%s', [FRozList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_RozNotInIndex, [FIndexName, FRozList.FWellItem.FTitle,
        FRozList.FWellItem.FTitle]),
      FRozList.FWellItem.FWellIndex
    );
end;

function TZGLRozItem.CheckDeptIn(const ADept: Double): Boolean;
begin
  Result := ((ADept >= FDeptFrom) and (ADept < FDeptTo));
end;

function TZGLRozItem.CheckDeptAfter(const ADept: Double): Boolean;
begin
  Result := (ADept >= FDeptTo);
end;

function TZGLRozItem.CheckDeptBefore(const ADept: Double): Boolean;
begin
  Result := (ADept < FDeptFrom);
end;

{
TZGLRozList
********************************************************************************
}
function TZGLRozList.GetZItem(AIndex: Integer): TZGLRozItem;
begin
  Result := TZGLRozItem(inherited Items[AIndex]);
end;

procedure TZGLRozList.SetZItem(AIndex: Integer; Value: TZGLRozItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLRozList.Add(const AItem: TZGLRozItem): Integer;
begin
  Result := inherited Add(AItem);
end;

function TZGLRozList.Add(const AIndexName: Integer;
  const AD1, AD2: Double; const ABlockName: String): Integer;
var
  AItem: TZGLRozItem;
begin
  AItem := TZGLRozItem.Create;
  AItem.FRozList := Self;
  AItem.FIndexName := AIndexName;
  AItem.FDeptFrom  := AD1;
  AItem.FDeptTo    := AD2;
  AItem.FBlockName := ABlockName;
  Add(AItem);
end;

function TZGLRozList.CheckErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  if Count = 0 then
  begin
    FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleNotRoz,
      Format('ROZ_%s', [FWellItem.FTitle]),
      0,
      0,
      Format(_s_notroz, [FWellItem.FTitle, FWellItem.FTitle]),
      FWellItem.FWellIndex
    );
    Result := True;
  end;
  for i :=0 to Count - 1 do
  begin
    if FWellItem.FWellList.FGeoLas.FCheckOptions.FCheckBlockName then
      if Items[i].CheckBlockName   then Result := True;
    if Items[i].CheckDept        then Result := True;
    if FWellItem.FWellList.FGeoLas.FCheckOptions.FCheckMod then
      if Items[i].CheckMod         then Result := True;
    if i < (Count - 1 ) then
    begin
      if Items[i].CheckNext(Items[i + 1].FIndexName) then Result := True;
      if Items[i].CheckNextDept(Items[i + 1].FDeptFrom) then Result := True;
    end;
    if Items[i].CheckInIndexPage then Result := True;
  end;
end;

procedure TZGLRozList.LoadXLS(const V: Variant);
var
  i, yr, ti: Integer;
  Arr: Variant;
  td1, td2: double;
begin
  if not FWellItem.FIsRoz then Exit;
  Clear;
  yr := V.Sheets.Item[FWellItem.FRozIndex].UsedRange.Rows.Count;
  ExcGetRangeArray(V.Sheets.Item[FWellItem.FRozIndex], Arr, 1, 2, 5, yr);
  for i := 0 to yr - 1 - 2 do
  begin
    if (String(Arr[i + 1, 2]) <> '') or (String(Arr[i + 1, 3]) <> '') then
    begin
      try
        ti := Arr[i + 1, 1];
      except
        ti := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleIntFormat,
          'ROZ_' + FWellItem.FTitle,
          i + 3,
          1,
          Format(_s_intformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      try
        td1 := Arr[i + 1, 2];
      except
        td1 := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleDoubleFormat,
          'ROZ_' + FWellItem.FTitle,
          i + 3,
          2,
          Format(_s_doubleformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      try
        td2 := Arr[i + 1, 3];
      except
        td2 := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleDoubleFormat,
          'ROZ_' + FWellItem.FTitle,
          i + 3,
          3,
          Format(_s_doubleformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      Add(ti, td1, td2, Arr[i + 1, 5]);
    end;
  end;
  Arr := unassigned;
end;

function TZGLRozList.GetIndexName(const ADept: Double): Integer;
var
  i: Integer;
begin
  Result := -1;
  { перед першим горизонтом }
  if ADept < Items[0].FDeptFrom then
  begin
    Result := Items[0].FIndexName - 1;
    if Result < 0 then
      raise EZGLExportLas.Create(Format(_s_las_01, [FWellItem.FTitle]));
    Exit;
  end;
  { за останнім }
  if ADept >= Items[Count - 1].FDeptTo then
  begin
    Result := Items[Count - 1].FIndexName + 1;
    Exit;
  end;
  { в горизонті }
  for i := 0 to Count - 1 do
    if Items[i].CheckDeptIn(ADept) then
    begin
      Result := Items[i].FIndexName;
      Exit;
    end;
  { між горизонтами }
  for i := 0 to Count - 2 do
    if Items[i].CheckDeptAfter(ADept) and
      Items[i + 1].CheckDeptBefore(ADept) then
      begin
        Result := Items[i].FIndexName + 1;
        Exit;
      end;
  if Result < 0 then
    raise EZGLExportLas.Create(Format(_s_las_01, [FWellItem.FTitle]));
end;

{
TZGLIntItem
********************************************************************************
}
function TZGLIntItem.CheckDept: Boolean;
begin
  Result :=  (FDeptFrom >= FDeptTo);
  if Result then
    FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleIntDept,
      Format('INT_%s', [FIntList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_intdept, [FDeptFrom, FDeptTo, FIntList.FWellItem.FTitle,
        FIntList.FWellItem.FTitle]),
      FIntList.FWellItem.FWellIndex
    );
end;

function TZGLIntItem.CheckMod: Boolean;
begin
  Result :=  not ((FIndexName mod 2) = 0);
  if Result then
    FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleIntMod,
      Format('INT_%s', [FIntList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_intmod, [FIndexName, FIntList.FWellItem.FTitle,
        FIntList.FWellItem.FTitle]),
      FIntList.FWellItem.FWellIndex
    );
end;

function TZGLIntItem.CheckNextDept(const ADept: Double): Boolean;
begin
  Result := not (FDeptTo <= ADept);
  if Result then
    FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleIntNextDept,
      Format('INT_%s', [FIntList.FWellItem.FTitle]),
      0,
      0,
      Format(_s_intnextdept, [ADept, FDeptTo, FIndexName,
        FIntList.FWellItem.FTitle, FIntList.FWellItem.FTitle]),
      FIntList.FWellItem.FWellIndex
    );
end;

function TZGLIntItem.CheckInRoz: Boolean;
var
  i: Integer;
begin
  for i := 0 to FIntList.FWellItem.FRozList.Count - 1 do
    if FRozItem = nil then
    begin
      Result := True;
      FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleIntNotInRoz,
        Format('INT_%s', [FIntList.FWellItem.FTitle]),
        0,
        0,
        Format(_s_IntNotInRoz, [FIndexName, FIntList.FWellItem.FTitle,
          FIntList.FWellItem.FTitle]),
        FIntList.FWellItem.FWellIndex
      );
    end;
end;

{ встановлює RozItem що відповідає даному }
procedure TZGLIntItem.SetRozItem;
var
  i: Integer;
begin
  for i := 0 to FIntList.FWellItem.FRozList.Count - 1 do
   if FIntList.FWellItem.FRozList[i].FIndexName = FIndexName then
   begin
     FRozItem := FIntList.FWellItem.FRozList[i];
     Exit;
   end;
end;

{
перевірка чи діапазон відповідає дыапазону на сторінці ROZ
}
function TZGLIntItem.CheckDeptInRoz: Boolean;
begin
  if FRozItem <> nil then
  begin
    Result := (FDeptFrom < FRozItem.FDeptFrom) or (FDeptTo > FRozItem.FDeptTo);
    if Result then
      FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleIntDeptNotInRoz,
        Format('INT_%s', [FIntList.FWellItem.FTitle]),
        0,
        0,
        Format(_s_IntDeptNotInRoz, [
          FIndexName,
          FDeptFrom,
          FDeptTo,
          FIntList.FWellItem.FTitle,
          FIntList.FWellItem.FTitle
          ]), FIntList.FWellItem.FWellIndex
      );
  end;
end;

{
повертає величину кривої по її індексу
}
function TZGLIntItem.CurveValueByName(const AName: String): Double;
begin
  Result := FIntList.FCurveList.FindByName(AName).GetValue(FOrdIndex);
end;

{
повертає величину кривої по її індексу
}
function TZGLIntItem.GetCurveValue(Index: Integer): Double;
begin
  Result := FIntList.FCurveList[Index].GetValue(FOrdIndex);
end;

function TZGLIntItem.CheckDeptIn(const ADept: Double): Boolean;
begin
  Result := ((ADept >= FDeptFrom) and (ADept < FDeptTo));
end;

{
TZGLIntList
********************************************************************************
}
constructor TZGLIntList.Create;
begin
  inherited Create;
  SetLength(FData, 0, 0);
  FCurveList := TZGLCurveList.Create;
  FCurveList.FIntList := Self;
end;

destructor TZGLIntList.Destroy;
begin
  FData := nil;
  FCurveList.Free;
  inherited Destroy;
end;

function TZGLIntList.GetZItem(AIndex: Integer): TZGLIntItem;
begin
  Result := TZGLIntItem(inherited Items[AIndex]);
end;

procedure TZGLIntList.SetZItem(AIndex: Integer; Value: TZGLIntItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLIntList.Add(const AItem: TZGLIntItem): Integer;
begin
  Result := inherited Add(AItem);
  Items[Result].FOrdIndex := Result;
end;

function TZGLIntList.Add(const AIndexName: Integer;
  const AD1, AD2: Double): Integer;
var
  AItem: TZGLIntItem;
begin
  AItem := TZGLIntItem.Create;
  AItem.FIntList := Self;
  AItem.FRozItem := nil;
  AItem.FIndexName := AIndexName;
  AItem.FDeptFrom  := AD1;
  AItem.FDeptTo    := AD2;
  Add(AItem);
end;

function TZGLIntList.CheckErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  if Count = 0 then
  begin
    FWellItem.FWellList.FGeoLas.FErrorList.Add(
      gleNotInt,
      Format('INT_%s', [FWellItem.FTitle]),
      0,
      0,
      Format(_s_notint, [FWellItem.FTitle, FWellItem.FTitle]),
      FWellItem.FWellIndex
    );
    Result := True;
  end;
  for i :=0 to Count - 1 do
  begin
    if Items[i].CheckDept then Result := True;
    if FWellItem.FWellList.FGeoLas.FCheckOptions.FCheckMod then
      if Items[i].CheckMod then Result := True;
    if i < (Count - 1 ) then
      if Items[i].CheckNextDept(Items[i + 1].FDeptFrom) then Result := True;
    if Items[i].CheckInRoz then Result := True;
    if Items[i].CheckDeptInRoz then Result := True;
  end;
  { перевірка спеціальних кривих }
  for i := 0 to FCurveList.Count - 1 do
    if FCurveList[i].CheckError then Result := True;
end;

procedure TZGLIntList.LoadXLS(const V: Variant);
var
  i, j, yr, xr, ti: Integer;
  Arr: Variant;
  td1, td2, tvalue: double;
begin
  if not FWellItem.FIsInt then Exit;
  Clear;
  FCurveList.Clear;
  yr := V.Sheets.Item[FWellItem.FIntIndex].UsedRange.Rows.Count;
  xr := V.Sheets.Item[FWellItem.FIntIndex].UsedRange.Columns.Count;
  { визначаємо перелік кривих }
  for i := 4 to xr do
    if String(V.Sheets.Item[FWellItem.FIntIndex].Cells[3, i]) <> '' then
    begin
      FCurveList.Add(
        V.Sheets.Item[FWellItem.FIntIndex].Cells[3, i],
        '',
        i - 4,
        True
      );
    end;
  { задаємо розмір масиву даних кривих }
  SetLength(FData, FCurveList.Count, yr - 4);
  ExcGetRangeArray(V.Sheets.Item[FWellItem.FIntIndex], Arr, 1, 4,
    FCurveList.Count + 4, yr);
  for i := 0 to yr - 1 - 4 do
    if (String(Arr[i + 1, 2]) <> '') or (String(Arr[i + 1, 3]) <> '') then
    begin
      try
        ti := Arr[i + 1, 1];
      except
        ti := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleIntFormat,
          'INT_' + FWellItem.FTitle,
          i + 3,
          1,
          Format(_s_intformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      try
        td1 := Arr[i + 1, 2];
      except
        td1 := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleDoubleFormat,
          'INT_' + FWellItem.FTitle,
          i + 3,
          2,
          Format(_s_doubleformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      try
        td2 := Arr[i + 1, 3];
      except
        td2 := -1;
        FWellItem.FWellList.FGeoLas.FErrorList.Add(
          gleDoubleFormat,
          'INT_' + FWellItem.FTitle,
          i + 3,
          3,
          Format(_s_doubleformat, [' [свердловина ' + FWellItem.FTitle + ']']),
          FWellItem.FWellIndex
        );
        FWellItem.FHasError := True;
      end;
      Add(ti, td1, td2);
      { заповнюємо масив даних кривих }
      for j := 0 to FCurveList.Count - 1 do
      begin
        try
          tvalue := Arr[i + 1, j + 4];
        except
          tvalue := defNullValue;
          FWellItem.FWellList.FGeoLas.FErrorList.Add(
            gleDoubleFormat,
            'INT_' + FWellItem.FTitle,
            i + 3,
            3,
            Format(_s_doubleformat, [' [свердловина ' + FWellItem.FTitle +
              ', крива ' + FCurveList[j].FTitle + ']']),
            FWellItem.FWellIndex
          );
          FWellItem.FHasError := True;
        end;
        FData[j, i] := tvalue;
      end;
  end;
  Arr := unassigned;
  { уточняємо розмір масиву даних кривих. якщо потрібно, то обрізаємо }
  if Count < yr - 4 then
    SetLength(FData, FCurveList.Count, Count);
end;

procedure TZGLIntList.FillCurvesToParent;
var
  i: Integer;
begin
  for i := 0 to FCurveList.Count - 1 do
    if FWellItem.FWellList.FGeoLas.FCurveList.FindByName(FCurveList[i].Title, False) = nil then
      FWellItem.FWellList.FGeoLas.FCurveList.Add(FCurveList[i].Title, '');
end;

procedure TZGLIntList.SetRozItems;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].SetRozItem;
end;

function TZGLIntList.GetCurveValue(const ADept: Double;
  ACurveIndex: Integer): Double;
var
  i: Integer;
begin
  Result := 0;
  { в продуктивному пропластку }
  for i := 0 to Count - 1 do
    if Items[i].CheckDeptIn(ADept) then
    begin
      Result := Items[i].CurveValue[ACurveIndex];
      Exit;
    end;
end;

{
TZGLCurveList
********************************************************************************
}
function TZGLCurveList.GetZItem(AIndex: Integer): TZGLCurveItem;
begin
  Result := TZGLCurveItem(inherited Items[AIndex]);
end;

procedure TZGLCurveList.SetZItem(AIndex: Integer; Value: TZGLCurveItem);
begin
  inherited SetItem(AIndex, Value);
end;

function TZGLCurveList.Add(const AItem: TZGLCurveItem): Integer;
begin
  Result := inherited Add(AItem);
end;

function TZGLCurveList.Add(const ATitle, AUName: String;
  const ADataIndex: Integer = -1; const DoUpperCase: Boolean = True): Integer;
var
  AItem: TZGLCurveItem;
  cindex: Integer;
begin
  cindex := -1;
  if Uppercase(ATitle) = 'LITO' then cindex := 0;
  if Uppercase(ATitle) = 'PORO' then cindex := 1;
  if Uppercase(ATitle) = 'SOIL' then cindex := 2;
  if Uppercase(ATitle) = 'SGAS' then cindex := 3;
  if Uppercase(ATitle) = 'HEF'  then cindex := 4;
  if Uppercase(ATitle) = 'HEFO' then cindex := 5;
  if Uppercase(ATitle) = 'HEFW' then cindex := 6;
  case cindex of
    0:   AItem := TZGLLitoCurveItem.Create;
    1:   AItem := TZGLPoroCurveItem.Create;
    2:   AItem := TZGLSoilCurveItem.Create;
    3:   AItem := TZGLSgasCurveItem.Create;
    4:   AItem := TZGLHefCurveItem.Create;
    5:   AItem := TZGLHefoCurveItem.Create;
    6:   AItem := TZGLHefwCurveItem.Create
    else AItem := TZGLDefaultCurveItem.Create;
  end;
  AItem.FCurveList := Self;
  if DoUpperCase
    then AItem.FTitle := Uppercase(ATitle)
    else AItem.FTitle := ATitle;
  AItem.FUName := AUName;
  AItem.FDataIndex := ADataIndex;
  Result := Add(AItem);
end;

function TZGLCurveList.FindByName(const AName: String; const DoRaise: Boolean = True): TZGLCurveItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if UpperCase(Items[i].FTitle) = UpperCase(AName) then
    begin
      Result := Items[i];
      Exit;
    end;
  if DoRaise then
    raise EZGLCFind.Create(Format(_s_findcurve, [UpperCase(AName)]));
end;

{
TZGLCurveItem
********************************************************************************
}
function TZGLCurveItem.GetValue(Index: Integer): Double;
begin
  Result := FCurveList.FIntList.FData[FDataIndex, Index];
end;

procedure TZGLCurveItem.SetValue(Index: Integer; AValue: Double);
begin
  if FCurveList.FIntList.FData[FDataIndex, Index] <> AValue then
    FCurveList.FIntList.FData[FDataIndex, Index] := AValue;
end;

function TZGLCurveItem.GetItemsCount: Integer;
begin
  Result := FCurveList.FIntList.Count;
end;

function TZGLCurveItem.GetMinValue: Double;
var
  i: Integer;
begin
  if ItemsCount = 0 then
    raise EZGLCCount.Create(Format(_s_curvecount, [FTitle]));
  Result := Values[0];
  for i := 1 to ItemsCount - 1 do
    if Values[i] < Result then Result := Values[i];
end;

function TZGLCurveItem.GetMaxValue: Double;
var
  i: Integer;
begin
  if ItemsCount = 0 then
    raise EZGLCCount.Create(Format(_s_curvecount, [FTitle])); 
  Result := Values[0];
  for i := 1 to ItemsCount - 1 do
    if Values[i] > Result then Result := Values[i];
end;

{
TZGLDefaultCurveItem
********************************************************************************
}
function TZGLDefaultCurveItem.CheckError: Boolean;
begin
  { для кривої по-замовчуванню відсутні спеціальні перевірки }
  Result := False;
end;

{
TZGLLitoCurveItem
********************************************************************************
}
function TZGLLitoCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if ((ZRound(Values[i], 4) <> 0) and (ZRound(Values[i], 4) <> 1)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleLITO_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_lito_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLPoroCurveItem
********************************************************************************
}
function TZGLPoroCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if ((ZRound(Values[i], 4) > 1) or (ZRound(Values[i], 4) < 0)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        glePORO_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_poro_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLSoilCurveItem
********************************************************************************
}
function TZGLSoilCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if ((ZRound(Values[i], 4) > 1) or (ZRound(Values[i], 4) < 0)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleSOIL_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_soil_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLSgasCurveItem
********************************************************************************
}
function TZGLSgasCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if ((ZRound(Values[i], 4) > 1) or (ZRound(Values[i], 4) < 0)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleSGAS_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_sgas_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLHefCurveItem
********************************************************************************
}
function TZGLHefCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if (ZRound(Values[i], 2) > ZRound((FCurveList.FIntList[i].FDeptTo -
       FCurveList.FIntList[i].FDeptFrom), 2)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleHEF_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_hef_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLHefoCurveItem
********************************************************************************
}
function TZGLHefoCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if (ZRound(Values[i], 2) > ZRound((FCurveList.FIntList[i].FDeptTo -
      FCurveList.FIntList[i].FDeptFrom), 2)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleHEFO_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_hefo_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

{
TZGLHefwCurveItem
********************************************************************************
}
function TZGLHefwCurveItem.CheckError: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ItemsCount - 1 do
  begin
    if (ZRound(Values[i], 2) > ZRound((FCurveList.FIntList[i].FDeptTo -
      FCurveList.FIntList[i].FDeptFrom), 2)) then
    if (Values[i] <> defNullValue) then
    begin
      Result := True;
      FCurveList.FIntList.FWellItem.FWellList.FGeoLas.FErrorList.Add(
        gleHEFW_01,
        'INT_' + FCurveList.FIntList.FWellItem.FTitle,
        i + 3,
        3,
        Format(_s_hefw_01, [Values[i],
          FCurveList.FIntList.FWellItem.FTitle, i + 1]),
        FCurveList.FIntList.FWellItem.FWellIndex
      );
    end;
  end;
end;

end.
