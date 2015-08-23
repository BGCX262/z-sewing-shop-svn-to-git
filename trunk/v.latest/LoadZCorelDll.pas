{
********************************************************************************
������� ������� � �������� � �������� ZCorel.dll
********************************************************************************
}
unit LoadZCorelDll;

interface

{
������� �������� Corel
}
procedure ZCorelOpen(var V: Variant; const APFilename: PChar;
  const AVisible: Boolean = False); StdCall
{
�������� �������� Corel
}
procedure ZCorelSave(var V: Variant; const APFileName: PChar); StdCall
{
������� �������� Corel
}
procedure ZCorelClose(var V: Variant); StdCall
{
�������� ��� � ��'�� APName
}
procedure ZCorelInsertLayer(var V: Variant; const APageIndex: Integer;
  const APName: PChar); StdCall;

implementation

procedure ZCorelOpen;        external 'ZCorel.dll' name 'ZCorelOpen';
procedure ZCorelSave;        external 'ZCorel.dll' name 'ZCorelSave';
procedure ZCorelClose;       external 'ZCorel.dll' name 'ZCorelClose';
procedure ZCorelInsertLayer; external 'ZCorel.dll' name 'ZCorelInsertLayer';

end.
