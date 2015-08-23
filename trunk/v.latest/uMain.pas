unit uMain;

interface

uses
  uGlobal,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, XPMan, JvGIF,
  ActnMenus, StdActns, ActnList, ImgList, XPStyleActnCtrls, ActnMan, Tabs,
  ToolWin, ActnCtrls, ZSewing,
  GDIPAPI, GDIPOBJ, Menus, Buttons, CheckLst, VirtualTrees;

type
  TfMain = class(TForm)
    XPManifest1: TXPManifest;
    StatusBar1: TStatusBar;
    ActionManager1: TActionManager;
    ImageList1: TImageList;
    FileExit1: TFileExit;
    aDraw: TAction;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    tbCut: TActionToolBar;
    aZoomIn: TAction;
    aZoomOut: TAction;
    aView: TAction;
    aSaveDim: TAction;
    aNew: TAction;
    aEditPoint: TAction;
    aSaveAsXML: TFileSaveAs;
    aLoadXML: TFileOpen;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    aDimensions: TAction;
    SpeedButton5: TSpeedButton;
    aInfo: TAction;
    SpeedButton6: TSpeedButton;
    aStandartDimensions: TAction;
    aAddPointFormula: TAction;
    aDeletePoint: TAction;
    Splitter1: TSplitter;
    ImageList2: TImageList;
    aEditDimensionTree: TAction;
    aEditPointTree: TAction;
    aPoints: TAction;
    aAddDimensionTree: TAction;
    aDelDimensionTree: TAction;
    aAddPointFormulaTree: TAction;
    aDelPointTree: TAction;
    aAddPointXY: TAction;
    aAddPointXYTree: TAction;
    aSetting: TAction;
    SpeedButton4: TSpeedButton;
    Panel3: TPanel;
    Splitter2: TSplitter;
    aSaveSize: TFileSaveAs;
    aLoadSize: TFileOpen;
    aLayerList: TAction;
    aAddLayer: TAction;
    SpeedButton7: TSpeedButton;
    aSaveXML2: TAction;
    pmLayers: TPopupMenu;
    N1: TMenuItem;
    aExportCorel: TAction;
    SpeedButton8: TSpeedButton;
    aSplines: TAction;
    aEditSplineTree: TAction;
    aAddSplineTree: TAction;
    aDelSplineTree: TAction;
    vsTree: TVirtualStringTree;
    pmDimensions: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    nEdit: TMenuItem;
    N7: TMenuItem;
    nDelete: TMenuItem;
    pmPoints: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    pmSplines: TPopupMenu;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    vsLayers: TVirtualStringTree;
    N16: TMenuItem;
    N17: TMenuItem;
    aEditLayerTree: TAction;
    aDelLayerTree: TAction;
    N18: TMenuItem;
    N19: TMenuItem;
    aHand: TAction;
    aCursor: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBox1Paint(Sender: TObject);
    procedure aDrawExecute(Sender: TObject);
    procedure aZoomInExecute(Sender: TObject);
    procedure aZoomOutExecute(Sender: TObject);
    procedure aViewExecute(Sender: TObject);
    procedure aNewExecute(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure aEditPointExecute(Sender: TObject);
    procedure aSaveAsXMLAccept(Sender: TObject);
    procedure aLoadXMLAccept(Sender: TObject);
    procedure aLoadXMLBeforeExecute(Sender: TObject);
    procedure aDimensionsExecute(Sender: TObject);
    procedure aInfoExecute(Sender: TObject);
    procedure aStandartDimensionsExecute(Sender: TObject);
    procedure aAddPointFormulaExecute(Sender: TObject);
    procedure aDeletePointExecute(Sender: TObject);
    procedure aEditDimensionTreeExecute(Sender: TObject);
    procedure aEditPointTreeExecute(Sender: TObject);
    procedure aPointsExecute(Sender: TObject);
    procedure aAddPointFormulaTreeExecute(Sender: TObject);
    procedure aDelPointTreeExecute(Sender: TObject);
    procedure aAddDimensionTreeExecute(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure aDelDimensionTreeExecute(Sender: TObject);
    procedure aAddPointXYExecute(Sender: TObject);
    procedure aAddPointXYTreeExecute(Sender: TObject);
    procedure aSettingExecute(Sender: TObject);
    procedure vtreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtreeInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure aSaveSizeAccept(Sender: TObject);
    procedure aLoadSizeAccept(Sender: TObject);
    procedure aLayerListExecute(Sender: TObject);
    procedure btnLayersClick(Sender: TObject);
    procedure aAddLayerExecute(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aLoadSizeBeforeExecute(Sender: TObject);
    procedure PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure aSaveXML2Execute(Sender: TObject);
    procedure aExportCorelExecute(Sender: TObject);
    procedure aSplinesExecute(Sender: TObject);
    procedure aEditSplineTreeExecute(Sender: TObject);
    procedure aAddSplineTreeExecute(Sender: TObject);
    procedure aDelSplineTreeExecute(Sender: TObject);
    procedure vsTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vsTreeGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vsTreeInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vsTreeInitChildren(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vsTreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure vsTreeGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure vsTreeDblClick(Sender: TObject);
    procedure vsTreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure vsLayersGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vsLayersGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vsLayersInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vsLayersPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure vsLayersChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure vsLayersGetPopupMenu(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
      var AskParent: Boolean; var PopupMenu: TPopupMenu);
    procedure aEditLayerTreeExecute(Sender: TObject);
    procedure aDelLayerTreeExecute(Sender: TObject);
    procedure vsLayersDblClick(Sender: TObject);
    procedure aHandExecute(Sender: TObject);
    procedure aCursorExecute(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aCrossMoveExecute(Sender: TObject);
  private
    { Private declarations }

    { побудова "модель не завантажена" }
    procedure DrawEmpty;
    { побудова}
    procedure Draw;
    { побудова моделі }
    procedure DrawModel(Agraphics : TGPGraphics);

    function GetCanvasWidth: Integer;
    function GetCanvasHeight: Integer;
    procedure ShowTitle(Agraphics : TGPGraphics; const X, Y: Integer;
      const Text: String);
    procedure DrawHorRules(Agraphics : TGPGraphics);
    procedure DrawVertRules(Agraphics : TGPGraphics);

    { перерисувати інфо }
    procedure UpdateInfo;
    { список і вип список шарів }
    procedure UpdateLayers;

    function SetSelectPointFromCoord(const AX, AY: Integer): Boolean;

    procedure OnLoadModel(Sender: TObject);
  public
    { Public declarations }
    ZM01: TZSewingModel;
    { редагування мірки }
    procedure EditDimension(ADimension: TZSMDimension);
    procedure DeleteDimension(ADimension: TZSMDimension);
    procedure AddDimension;
    { редагування точки }
    procedure EditPoint(APoint: TZSMPoint);
    { редагування сплайну }
    procedure EditSpline(ASpline: TZSMSpline);
    { додавання сплайну }
    procedure AddSpline;
    { видалення сплайну }
    procedure DeleteSpline(ASpline: TZSMSpline);
    { дерево }
    procedure UpdateTree;
    { редагування шарів }
    procedure EditLayer(ALayer: TZSMLayer);
    procedure DeleteLayer(ALayer: TZSMLayer);
    procedure AddLayer;
  end;

  PNodeData2 = ^TNodeData2;
  TNodeData2 = record
    Caption: String;
    Level: Integer;
    Count: Integer;
    SValue: String;
  end;

  PNodeDataL = ^TNodeDataL;
  TNodeDataL = record
    Caption: String;
    Checked: Boolean;
    AColor: TColor;
    Width: Integer;
  end;

  THandType = (htCursor, htHand);

var
  fMain: TfMain;
  ModelSet: TModelSet;
  HandType: THandType;
  HandPressed, MovePressed: Boolean;
  PosX, PosY: Integer;
  AX, AY: Double;

const
  SexList: array [0..4] of string  = ('unisex', 'чоловічі', 'жіночі', 'дитячі', 'для вагітних');

implementation

uses uSetDim, uCuts, uEditPoint, uDimensions, uInfo, uStandartDimensions,
  uPoints, uSetting, uEditLayer,
  uLayerList, uPaintPopUp, uProgress, uSplines, uEditSplines, uErrorList;

{$R *.dfm}

{
дерево
}
procedure TfMain.UpdateTree;
begin
  UpdateLayers;
  vsTree.ReinitNode(nil, true);
end;

{ список і вип список шарів }
procedure TfMain.UpdateLayers;
begin
  vsLayers.RootNodeCount := ZM01.LayerList.Count;
  vsLayers.ReinitNode(nil, true);
end;

{
редагування розмірностей
}
procedure TfMain.EditDimension(ADimension: TZSMDimension);
begin
  fSetDim := TfSetDim.Create(nil);
  with fSetDim do
  try
    edUName.Text := ADimension.UName;
    edTitle.Text := ADimension.Title;
    edValue.Text := Format('%3.2f', [ADimension.Value]);
    ShowModal;
    if ModalResult = mrOk then
    begin
      ADimension.UName := edUName.Text;
      ADimension.Title := edTitle.Text;
      ADimension.Value := StrToFloat(edValue.Text);
    end;
  finally
    free;
  end;
end;

procedure TfMain.DeleteDimension(ADimension: TZSMDimension);
begin
  if MessageDlg(Format('Видалити мірку "%s (%s)"?',
    [ADimension.Title, ADimension.UName]), mtWarning, [mbOk, mbCancel], 0) = mrOk then
    ZM01.DimensionList.Delete(ADimension.DimensionIndex);
end;

procedure TfMain.AddDimension;
var
  k: Integer;
begin
  k := ZM01.DimensionList.Add('new_dim', 'нова мірка', 0);
  EditDimension(ZM01.DimensionList[k]);
end;

{
редагування шарів
}
procedure TfMain.EditLayer(ALayer: TZSMLayer);
begin
  fEditLayer := TfEditLayer.Create(nil);
  with fEditLayer do
  try
    edTitle.Text := ALayer.Title;
    shColor.Brush.Color := ALayer.Color;
    edWidth.Text := Format('%d', [ALayer.Width]);
    ShowModal;
    if ModalResult = mrOk then
    begin
      ALayer.Title := edTitle.Text;
      ALayer.Color := shColor.Brush.Color;
      ALayer.Width := StrToInt(edWidth.Text);
      UpdateLayers;
      aDraw.Execute;
    end;
  finally
    free;
  end;
end;

procedure TfMain.DeleteLayer(ALayer: TZSMLayer);
begin
  if MessageDlg(Format('Видалити шар "%s"?',
    [ALayer.Title]), mtWarning, [mbOk, mbCancel], 0) = mrOk then
    ZM01.LayerList.Delete(ALayer.IIndex); 
end;

procedure TfMain.AddLayer;
var
  k: Integer;
begin
  k := ZM01.LayerList.Add('новий шар', clBlack, 1);
  EditLayer(ZM01.LayerList[k]);
end;

function TfMain.SetSelectPointFromCoord(const AX, AY: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to ZM01.PointsList.Count - 1 do
  begin
    if (Abs(ZM01.PointsList[i].Xpx - (AX - ModelSet.StartX)) < 5) and
       (Abs(ZM01.PointsList[i].Ypx - (AY - ModelSet.StartY)) < 5) then
    begin
      Result := True;
      if ZM01.PointsList.Selected <> i then
      begin
        ZM01.PointsList.Selected := i;
        UpdateInfo;
        aDraw.Execute;
        Exit;
      end;
    end;
  end;
end;

procedure TfMain.OnLoadModel(Sender: TObject);
begin
  if not Assigned(fProgress) then Exit;
  case ZM01.LoadIndex of
    lNone:       fProgress.lbProgress.Caption := '';
    lInfo:       fProgress.lbProgress.Caption := 'Завантаження загальної інформації...';
    lLayers:     fProgress.lbProgress.Caption := 'Завантаження шарів...';
    lDimensions: fProgress.lbProgress.Caption := 'Завантаження мірок...';
    lPoints:     fProgress.lbProgress.Caption := 'Завантаження точок...';
    lSplines:    fProgress.lbProgress.Caption := 'Завантаження відрізків, ламаних та сплайнів...';
  end;
  //Sleep(100);
  //Application.ProcessMessages;
end;

{
редагування точки
}
procedure TfMain.EditPoint(APoint: TZSMPoint);
var
  i: Integer;
begin
  ZM01.PointsList.Selected := APoint.PointIndex;
  fEditPoint := TfEditPoint.Create(nil);
  with fEditPoint do
  try
    with APoint do
    begin
      edTitle.Text := Uname;
      edFormula.Text := Formula;
      cbPrePoint.Items.Clear;
      cbPrePoint.Items.Add('<нічого>');
      for i := 0 to ZM01.PointsList.Count - 1 do
        cbPrePoint.Items.Add(ZM01.PointsList[i].UName);
      cbPrePoint.ItemIndex := PrePointIndex + 1;
      cbAngle.Text := Angle.Formula;
      chbSegment.Checked := ShowSpline;
      edX.Text := Format('%4.2f', [X]);
      edY.Text := Format('%4.2f', [Y]);
      edBasis.Text := ZM01.PointsList[BasisIndex].UName;
      case PosType of
        ptXY: pcPos1.TabIndex := 0;
        ptLine:
        begin
          pcPos1.TabIndex := 1;
          pcPos2.TabIndex := 0;
        end;
        ptArc:
        begin
          pcPos1.TabIndex := 1;
          pcPos2.TabIndex := 1;
        end;
      end;
      cbObjectAngle.Text := Format('%3.2f', [ObjectAngle]);
      chbVMirror.Checked := VMirror;
      chbHMirror.Checked := HMirror;
      ShowModal;
      if ModalResult = mrOk then
      begin
        Uname := edTitle.Text;
        Formula := edFormula.Text;
        PrePointIndex := cbPrePoint.ItemIndex - 1;
        Angle.Formula := cbAngle.Text;
        ShowSpline := chbSegment.Checked;
        X := StrToFloat(edX.Text);
        Y := StrToFloat(edY.Text);
        case pcPos1.TabIndex of
          0: PosType := ptXY;
          1:
          case pcPos2.TabIndex of
            0: PosType := ptLine;
            1: PosType := ptArc;
          end;
        end;
      ObjectAngle := StrToFloat(cbObjectAngle.Text);
      VMirror := chbVMirror.Checked;
      HMirror := chbHMirror.Checked;
      end;
    end;
  finally
    free;
  end;
end;

{
редагування сплайну
}
procedure TfMain.EditSpline(ASpline: TZSMSpline);
var
  i: Integer;
begin
  fEditSpline := TfEditSpline.Create(nil);
  with fEditSpline do
  try
    with ASpline do
    begin
      clbLayers.Items.Clear;
      for i := 0 to ZM01.LayerList.Count - 1 do
      begin
        clbLayers.Items.Add(ZM01.LayerList[i].Title);
        if LayerList.Count - 1 >= i then
          clbLayers.Checked[i] := LayerList[i].Checked;
      end;
      edPoints.Text := ASpline.PointsList.CommaText;
      rgLineType.ItemIndex := ord(ASpline.SplineType);
      //edTension.Text := Format('%1.3f', [ASpline.Tension]);
      tbTension.Position := Round(ASpline.Tension * 10);
      ShowModal;
      if ModalResult = mrOk then
      begin
        ASpline.PointsList.CommaText := edPoints.Text;
        ASpline.SplineType := TZSMSplineType(rgLineType.ItemIndex);
        {if edTension.Text = ''
          then ASpline.Tension := 0.5
          else ASpline.Tension := StrToFloat(edTension.Text);}
        ASpline.Tension := tbTension.Position / 10;
        LayerList.Clear;
        for i := 0 to clbLayers.Items.Count - 1 do
          LayerList.Add(clbLayers.Checked[i]);
      end;
    end;
  finally
    free;
  end;
end;

{
додавання сплайну
}
procedure TfMain.AddSpline;
var
  k: Integer;
begin
  if ZM01.PointsList.Count < 3 then
  begin
    MessageDlg('Щоб задати сплайн, повинно бути хоча б 3 точки', mtWarning, [mbOk], 0);
    Exit;
  end;
  k := ZM01.SplinesList.Add('', ltSpline, 0.5);
  EditSpline(ZM01.SplinesList[k]);
end;

{
видалення сплайну
}
procedure TfMain.DeleteSpline(ASpline: TZSMSpline);
begin
  if MessageDlg(Format('Видалити сплайн "%s"?',
    [ASpline.ShortTitle]), mtWarning, [mbOk, mbCancel], 0) = mrOk then
    ZM01.SplinesList.Delete(ASpline.SplineIndex);
end;

{
перерисувати інфо
}
procedure TfMain.UpdateInfo;
begin
  if ZM01.PointsList.Selected = -1 then
  begin
    StatusBar1.Panels[1].Text := 'точку не вибрано';
    Exit;
  end;
  StatusBar1.Panels[1].Text := Format('точка: %s [%4.2f; %4.2f]',
    [ZM01.PointsList[ZM01.PointsList.Selected].UName,
     ZM01.PointsList[ZM01.PointsList.Selected].X,
     ZM01.PointsList[ZM01.PointsList.Selected].Y]);
  StatusBar1.Panels[2].Text := ZM01.Title;
  if ModelSet.FileName <> ''
    then StatusBar1.Panels[3].Text := ModelSet.FileName
    else StatusBar1.Panels[3].Text := 'модель не збережено';
end;

{
побудова "модель не завантажена"
}
procedure TfMain.DrawEmpty;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  PaintBox1.Canvas.Pen.Color := clBlack;
  PaintBox1.Canvas.Pen.Width := 1;
  PaintBox1.Canvas.Rectangle(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  PaintBox1.Canvas.TextOut(10, 10, 'Модель не завантажено');
end;

procedure TfMain.ShowTitle(Agraphics : TGPGraphics; const X, Y: Integer;
  const Text: String);
var
  fontFamily: TGPFontFamily;
  font: TGPFont;
  p: TGPPointF;
  FontBrush: TGPSolidBrush;
begin
  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 14, FontStyleBold, UnitPixel);
  FontBrush := TGPSolidBrush.Create(MakeColor(0, 0, 255));
  P.X := X;
  P.Y := Y;
  Agraphics.DrawString(Text, -1, font, P, FontBrush);
end;

function TfMain.GetCanvasWidth: Integer;
begin
  Result := Round(500 * ZM01.Zoom);
end;

function TfMain.GetCanvasHeight: Integer;
begin
  Result := ModelSet.TitleOut + Round(500 * ZM01.Zoom);
end;

procedure TfMain.DrawHorRules(Agraphics : TGPGraphics);
var
  p: TGPPointF;
  i, k, l: Integer;
  pen: TGPPen;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  FontBrush: TGPSolidBrush;
begin
  pen:= TGPPen.Create(MakeColor(210, 210, 210), 1);
  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 10, FontStyleRegular, UnitPixel);
  FontBrush := TGPSolidBrush.Create(MakeColor(0, 0, 0));
  i := ModelSet.StartX;
  p.X := i + 2;
  p.Y := ModelSet.TitleOut + 2;
  k := 0;
  Agraphics.DrawString(Format('%4.2f', [k * ModelSet.RuleStep]), -1, font, p, FontBrush);
  l := ModelSet.RuleLabelStep;
  while i < PaintBox1.Width do
  begin
    Agraphics.DrawLine(pen, i, ModelSet.StartY, i, {_TitleOut + _RuleWidth} PaintBox1.Height);
    p.X := i + 2;
    if l = ModelSet.RuleLabelStep then
    begin
      Agraphics.DrawLine(pen, i, ModelSet.TitleOut, i, ModelSet.StartY);
      Agraphics.DrawString(Format('%4.2f', [k * ModelSet.RuleStep]), -1, font, p, FontBrush);
      l := 0;
    end;
    i := i + Round(ModelSet.RuleStep * ZM01.Zoom);
    k := k + 1;
    l := l + 1;
  end;
  Agraphics.DrawLine(pen, 0, ModelSet.TitleOut, PaintBox1.Width, ModelSet.TitleOut);
  pen.Free;
end;

procedure TfMain.DrawVertRules(Agraphics : TGPGraphics);
var
  p: TGPPointF;
  i, k, l: Integer;
  pen: TGPPen;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  FontBrush: TGPSolidBrush;
begin
  pen:= TGPPen.Create(MakeColor(210, 210, 210), 1);
  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 10, FontStyleRegular, UnitPixel);
  FontBrush := TGPSolidBrush.Create(MakeColor(0, 0, 0));
  i := ModelSet.StartY;
  p.X := 2;
  p.Y := i + 2;
  k := 0;
  Agraphics.DrawString(Format('%4.2f', [k * ModelSet.RuleStep]), -1, font, p, FontBrush);
  l := ModelSet.RuleLabelStep;
  while i < PaintBox1.Height do
  begin
    Agraphics.DrawLine(pen, ModelSet.StartX, i, PaintBox1.Width, i);
    p.Y := i + 2;
    if l = ModelSet.RuleLabelStep then
    begin
      Agraphics.DrawLine(pen, 0, i, ModelSet.StartX, i);
      Agraphics.DrawString(Format('%4.2f', [k * ModelSet.RuleStep]), -1, font, p, FontBrush);
      l := 0;
    end;
    i := i + Round(ModelSet.RuleStep * ZM01.Zoom);
    k := k + 1;
    l := l + 1;
  end;
  Agraphics.DrawLine(pen, 0, ModelSet.TitleOut, 0, PaintBox1.Height);
  pen.Free;
end;


{
побудова
}
procedure TfMain.Draw;
var
  graphics : TGPGraphics;
  pen: TGPPen;
  BackGroundBrush: TGPSolidBrush;
  hbrush, vbrush: TGPLinearGradientBrush;
  p1, p2: TGPPoint;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  i: Integer;
  p: TGPPointF;
  k: Integer;
  s: String;
begin
  graphics := TGPGraphics.Create(PaintBox1.Canvas.Handle);
  graphics.SetSmoothingMode(SmoothingModeAntiAlias);

  BackGroundBrush := TGPSolidBrush.Create(MakeColor(255, 255, 255));
  graphics.FillRectangle(BackGroundBrush, 0, 0, PaintBox1.Width - 1, PaintBox1.Height - 1);

  ShowTitle(graphics, 10, 10, Format('%s', [ZM01.Title]));
  DrawHorRules(graphics);
  DrawVertRules(graphics);
  DrawModel(graphics);

  graphics.Free;
end;

{
побудова базисної сітки
}
procedure TfMain.DrawModel(Agraphics : TGPGraphics);
var
  i, ax, ay, j, k, ax1, ay1, ax2, ay2: Integer;
  pen_line, pen_sel, pen_XY, pen_block: TGPPen;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  brush: TGPSolidBrush;
  p: TGPPointF;
  points: PGPPointF;
  a: TPointFDynArray;
const
  dash : array[0..1] of single = (2, 2);
begin
  pen_line := TGPPen.Create(MakeColor(ZM01.LayerList[0].Color), 1);
  pen_line.SetWidth(ZM01.LayerList[0].Width);
  pen_sel       := TGPPen.Create(MakeColor( 80,  80,  80), 1);
  pen_XY        := TGPPen.Create(MakeColor( 20, 180,  40), 1);
  pen_block     := TGPPen.Create(MakeColor( 20, 180,  40), 1);
  pen_block.SetDashPattern(@dash, 2);
  brush      := TGPSolidBrush.Create(MakeColor(0, 0, 0));
  fontFamily := TGPFontFamily.Create('Arial');
  font := TGPFont.Create(fontFamily, 10, FontStyleRegular, UnitPixel);

  { прохід по шарах }
  for j := 0 to ZM01.LayerList.Count - 1 do
    if ZM01.LayerList[j].Checked then
    begin
      with ZM01.SplinesList do
      for i := 0 to Count - 1 do
      begin
        { якщо відрізок(сплайн) є в списку хоча б одного із видимих шарів... }
        if Items[i].LayerList.Count - 1 >= j then
          if Items[i].LayerList[j].Checked then
          begin
            pen_line.SetColor(MakeColor(ZM01.LayerList[j].Color));
            pen_line.SetWidth(ZM01.LayerList[j].Width);
            SetLength(a, Items[i].PointsList.Count);
            for k := 0 to Items[i].PointsList.Count - 1 do
            begin
              a[k].X := ZM01.PointsList.Find(Items[i].PointsList[k]).Xpx + ModelSet.StartX;
              a[k].Y := ZM01.PointsList.Find(Items[i].PointsList[k]).Ypx + ModelSet.StartY;
            end;
            case Items[i].SplineType of
              ltLine:   Agraphics.DrawLines(pen_line, PGPPointF(@a[0]), Items[i].PointsList.Count);
              ltSpline: Agraphics.DrawCurve(pen_line, PGPPointF(@a[0]), Items[i].PointsList.Count, Items[i].Tension);
            end;
            a := nil;
          end;
      end;
    end;   
  if ZM01.LayerList[0].Checked then
 { якщо вибрано базис, то рисуємо точки }
  with ZM01.PointsList do
  begin
    for i := 0 to Count - 1 do
    begin
      brush.SetColor(MakeColor(ZM01.LayerList[0].Color));
      ax := Items[i].Xpx + ModelSet.StartX;
      ay := Items[i].Ypx + ModelSet.StartY;
      p.X := ax + 4;
      p.Y := ay - 12;
      agraphics.FillRectangle(brush, ax - 2, ay - 2, 4, 4);
      agraphics.DrawString(Items[i].UName, -1, font, p, brush);
      if Items[i].PosType = ptXY then
        agraphics.DrawEllipse(pen_XY, ax - 9, ay - 9, 18, 18);
      if Items[i].IsSelected then
        //agraphics.DrawRectangle(pen_sel, ax - 5, ay - 5, 10, 10);
        agraphics.FillRectangle(brush, ax - 5, ay - 5, 10, 10);
    end;
    { квадратики навколо блоків }
    for i := 0 to Count - 1 do
    if Items[i].PosType = ptXY then
      begin
        ax1 := Items[i].BaseLXpx + ModelSet.StartX;
        ay1 := Items[i].BaseLYpx + ModelSet.StartY;
        ax2 := Items[i].BaseRXpx + ModelSet.StartX;
        ay2 := Items[i].BaseRYpx + ModelSet.StartY;
        agraphics.DrawRectangle(pen_block, ax1 - 12, ay1 - 12, ax2 - ax1 + 24,
          ay2 - ay1 + 24);
      end;
  end;

  { побудова виділеного відрізку }
  { якщо вибрано базис, то рисуємо точки }
  {if (ZM01.LayerList[0].Checked) and (ZM01.SegmentList.Selected <> -1) then
    with ZM01.SegmentList[ZM01.SegmentList.Selected] do
    begin
      pen_line.SetColor(MakeColor(ZM01.LayerList[0].Color));
      pen_line.SetWidth(ZM01.LayerList[0].Width * 2);
      agraphics.DrawLine(pen_line,
        X1px + ModelSet.StartX, Y1px + ModelSet.StartY,
        X2px + ModelSet.StartX, Y2px + ModelSet.StartY);
    end; }
  pen_line.Free;
  pen_sel.Free;
  pen_XY.Free;
  pen_block.Free;
  brush.Free;
  font.Free;
  fontFamily.Free;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  HandType := htCursor;
  ZM01 := TZSewingModel.Create;
  ZM01.OnLoad := OnLoadModel;
  ModelSet := TModelSet.Create;
  ModelSet.LoadIni(ExtractFilePath(Application.ExeName) + '\ss.ini');
  ModelSet.FileName := '';
  ZM01.Sizes.LoadXML(ExtractFilePath(Application.ExeName) + '\Sizes\default.xml');
  //новий без aInfo.Execute
  ZM01.CreateNew;
  UpdateInfo;
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ModelSet.SaveIni(ExtractFilePath(Application.ExeName) + '\ss.ini');
  ModelSet.Free;
  ZM01.Free;
end;

procedure TfMain.PaintBox1Paint(Sender: TObject);
begin
  try
    Draw;
  except
  end;  
end;

procedure TfMain.aDrawExecute(Sender: TObject);
begin
  if PaintBox1.Width <> GetCanvasWidth then
    PaintBox1.Width := GetCanvasWidth;
  if PaintBox1.Height <> GetCanvasHeight then
    PaintBox1.Height := GetCanvasHeight;
  Draw;
  UpdateInfo;
end;

procedure TfMain.aZoomInExecute(Sender: TObject);
begin
  if ZM01.Zoom >= 50 then Exit;
  ZM01.Zoom := ZM01.Zoom + 2;
  aDraw.Execute;
end;

procedure TfMain.aZoomOutExecute(Sender: TObject);
begin
  if ZM01.Zoom <= 2 then Exit;
  ZM01.Zoom := ZM01.Zoom - 2;
  aDraw.Execute;
end;

procedure TfMain.aViewExecute(Sender: TObject);
begin
  fCuts.ShowModal;
  aDraw.Execute;
end;

procedure TfMain.aNewExecute(Sender: TObject);
begin
  ZM01.CreateNew;
  ModelSet.FileName := '';
  aInfo.Execute;
  UpdateInfo;
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  SX, SY: String;
  i: Integer;
begin
  SX := 'x';
  SY := 'y';
  AX := ZM01.GetX(X - ModelSet.StartX);
  AY := ZM01.GetY(Y - ModelSet.StartY);
  if AX >= 0 then
    SX := Format('%4.2f', [AX]);
  if AY >= 0 then
    SY := Format('%4.2f', [AY]);
  StatusBar1.Panels[0].Text :=
    Format('[%s; %s]', [SX, SY]);
  //SetSelectPointFromCoord(X, Y);
  if (HandType = htHand) and HandPressed then
  begin
    ScrollBox1.HorzScrollBar.Position := ScrollBox1.HorzScrollBar.Position + (PosX - X);
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + (PosY - Y);
  end;
  if MovePressed and (ZM01.PointsList[ZM01.PointsList.Selected].PosType = ptXY) then
  begin
    ZM01.PointsList[ZM01.PointsList.Selected].X := AX;
    ZM01.PointsList[ZM01.PointsList.Selected].Y := AY;
    aDraw.Execute;
  end;
end;

procedure TfMain.aEditPointExecute(Sender: TObject);
begin
  if ZM01.PointsList.Selected = -1 then Exit;
  EditPoint(ZM01.PointsList[ZM01.PointsList.Selected]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aSaveAsXMLAccept(Sender: TObject);
var
  s: String;
begin
  s := aSaveAsXML.Dialog.FileName;
  if ExtractFileExt(s) <> '.xml' then
    s := ChangeFileExt(s, '.xml');
  ModelSet.FileName := s;
  aSaveXML2.Execute;
end;

procedure TfMain.aLoadXMLAccept(Sender: TObject);
var
  s: String;
  TMPStr: TStringList;
begin
  fProgress := TfProgress.Create(nil);
  try
    PaintBox1.OnPaint := nil;
    TMPStr := TStringList.Create;
    fProgress.Show;
    ZM01.LoadXML(aLoadXML.Dialog.FileName, TMPStr);
    s := ChangeFileExt(aLoadXML.Dialog.FileName, '.bak');
    try
      ZM01.SaveXML(s);
    except
      MessageDlg('Не вдалось зберегти резервну копію', mtError, [mbOk], 0);
    end;
  finally
    fProgress.free;
    if TMPStr.Count > 0 then
      with TfErrorList.Create(nil) do
      try
        Memo1.Lines.Assign(TMPStr);
        ShowModal;
      finally
        free;
      end;
    TMPStr.Free;
    ModelSet.FileName := aLoadXML.Dialog.FileName;
    PaintBox1.OnPaint := PaintBox1Paint;
    UpdateInfo;
    UpdateTree;
    aDraw.Execute;
  end;
end;

procedure TfMain.aLoadXMLBeforeExecute(Sender: TObject);
begin
  aLoadXML.Dialog.InitialDir := ExtractFilePath(Application.ExeName) + 'Library';
end;

procedure TfMain.aDimensionsExecute(Sender: TObject);
begin
  fDimensions := TfDimensions.Create(nil);
  with fDimensions do
  try
    ShowDimensions;
    ShowModal;
  finally
    UpdateTree;
    aDraw.Execute;
    free;
  end;
end;

procedure TfMain.aInfoExecute(Sender: TObject);
var
  i: Integer;
begin
  fInfo := TfInfo.Create(nil);
  with fInfo do
  try
    edTitle.Text := fMain.ZM01.Title;
    cbSex.Items.Clear;
    for i := 0 to 5 - 1 do
      cbSex.Items.Add(SexList[i]);
    cbSex.ItemIndex := Ord(fMain.ZM01.Sex);
    edDescr.Text := fMain.ZM01.Description;
    if FileExists(ChangeFileExt(ModelSet.FileName, '.jpg'))
      then Image1.Picture.LoadFromFile(ChangeFileExt(ModelSet.FileName, '.jpg'))
      else Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + 'noimage.jpg');
    ShowModal;
    if ModalResult = mrOk then
    begin
      ZM01.Title := edTitle.Text;
      ZM01.Sex := TZSMSex(cbSex.ItemIndex);
      ZM01.Description := edDescr.Text;
      UpdateInfo;
    end;
  finally
    free;
  end;
end;

procedure TfMain.aStandartDimensionsExecute(Sender: TObject);
var
  i: Integer;
begin
  fStandartDimensions := TfStandartDimensions.Create(nil);
  with fStandartDimensions do
  try
    UpdateDimensions(0);
    ShowModal;
  finally
    free;
  end;
end;

procedure TfMain.aAddPointFormulaExecute(Sender: TObject);
var
  k: Integer;
begin
  k := ZM01.PointsList.Add('p', ZM01.PointsList.Selected, '0', '10',
    ptLine, -1, 0, 0, false);
  ZM01.PointsList[k].ShowSpline := True;
  aEditPoint.Execute;
end;

procedure TfMain.aDeletePointExecute(Sender: TObject);
begin
  if ZM01.PointsList.Count = 0 then Exit;
  if MessageDlg(Format('Видалити точку "%s"? Якщо це єдина точка чи ця точка використовується в' +
  ' одній чи декількох формулах, то її видалити буде неможливо.',
  [ZM01.PointsList[ZM01.PointsList.Selected].UName]), mtWarning, [mbOk, mbCancel], 0) = mrOk then
  begin
    if ZM01.PointsList.Count = 1 then Exit;
    ZM01.PointsList[ZM01.PointsList.Selected].ShowSpline := False;
    try
      ZM01.PointsList.Delete(ZM01.PointsList.Selected);
      ZM01.PointsList.Selected := 0;//ZM01.PointsList.Selected - 1;
    finally
      UpdateTree;
      aDraw.Execute;
    end;
  end;
end;

procedure TfMain.aEditDimensionTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  EditDimension(ZM01.DimensionList[Node.Index]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aEditPointTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  EditPoint(ZM01.PointsList[Node.Index]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aPointsExecute(Sender: TObject);
begin
  fPoints := TfPoints.Create(nil);
  with fPoints do
  try
    ShowPoints;
    ShowModal;
  finally
    UpdateTree;
    aDraw.Execute;
    free;
  end;
end;

procedure TfMain.aAddPointFormulaTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  ZM01.PointsList.Selected := ZM01.PointsList[Node.Index].PointIndex;
  aAddPointFormula.Execute;
end;

procedure TfMain.aDelPointTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  ZM01.PointsList.Selected := ZM01.PointsList[Node.Index].PointIndex;
  aDeletePoint.Execute;
end;

procedure TfMain.aAddDimensionTreeExecute(Sender: TObject);
begin
  AddDimension;
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.PaintBox1DblClick(Sender: TObject);
begin
  aEditPoint.Execute;
end;

procedure TfMain.aDelDimensionTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  DeleteDimension(ZM01.DimensionList[Node.Index]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aAddPointXYExecute(Sender: TObject);
var
  k: Integer;
begin
  k := ZM01.PointsList.Add('p', -1, '0', '10', ptXY, -1, AX, AY, false);
  aEditPoint.Execute;
end;

procedure TfMain.aAddPointXYTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  //ZM01.PointsList.Selected := ZM01.PointsList[Node.Index].PointIndex;
  AX := 10;
  AY := 10;
  aAddPointXY.Execute;
end;

procedure TfMain.aSettingExecute(Sender: TObject);
begin
  fSetting := TfSetting.Create(nil);
  with fSetting do
  try
    edTitleOut.Text := IntToStr(ModelSet.TitleOut);
    edRuleStep.Text := FloatToStrF(ModelSet.RuleStep, ffFixed, 5, 2);
    edRuleLabelStept.Text := IntToStr(ModelSet.RuleLabelStep);
    edRuleWidth.Text := IntToStr(ModelSet.RuleWidth);
    chbConstr.Checked := ModelSet.ConstrMode;
    ShowModal;
    if ModalResult = mrOk then
    begin
      ModelSet.TitleOut := StrToInt(edTitleOut.Text);
      ModelSet.RuleStep := StrToFloat(edRuleStep.Text);
      ModelSet.RuleLabelStep := StrToInt(edRuleLabelStept.Text);
      ModelSet.RuleWidth := StrToInt(edRuleWidth.Text);
      ModelSet.ConstrMode := chbConstr.Checked;
    end;
  finally
    free;
    aDraw.Execute;
  end;
end;

procedure TfMain.vtreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
begin
  CellText := '';
  case Column of
    0:
    case Node.Index of
      0: CellText := 'Мірки';
      1: CellText := 'Змінні';
      2: CellText := 'Точки';
      3: CellText := 'Відрізки';
    end;
  end;
{  case Column of
    0: // main column (has two different captions)
          CellText := '1';
    1: // no text in the image column
          CellText := '2';
    2:
          CellText := '3';
  end;   }
end;

procedure TfMain.vtreeInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
begin
  {case Node.Index of
    0: ChildCount := {ZM01.DimensionList.Count  * 10;
 // end; }
end;

procedure TfMain.aSaveSizeAccept(Sender: TObject);
var
  s: String;
begin
  s := aSaveSize.Dialog.FileName;
  if ExtractFileExt(s) <> '.xml' then
    s := ChangeFileExt(s, '.xml');
  ZM01.Sizes.SaveXML(s);
end;

procedure TfMain.aLoadSizeAccept(Sender: TObject);
begin
  ZM01.Sizes.LoadXML(aLoadSize.Dialog.FileName);
end;

procedure TfMain.aLayerListExecute(Sender: TObject);
var
  i: Integer;
begin
  with TfLayerList.Create(nil) do
  try
    ShowLayers;
    ShowModal;
  finally
    UpdateTree;
    aDraw.Execute;
    free;
  end;
end;

procedure TfMain.btnLayersClick(Sender: TObject);
begin
  aLayerList.Execute;
end;

procedure TfMain.aAddLayerExecute(Sender: TObject);
begin
  AddLayer;
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PosX := X;
  PosY := Y;
  case HandType of
    htCursor: MovePressed := SetSelectPointFromCoord(X, Y);
    htHand:   HandPressed := True;
  end;
end;

procedure TfMain.aLoadSizeBeforeExecute(Sender: TObject);
begin
  aLoadSize.Dialog.InitialDir := ExtractFilePath(Application.ExeName) + 'Sizes';
end;

procedure TfMain.PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  fPaintPopUp.Left := Mouse.CursorPos.X;
  fPaintPopUp.Top  := Mouse.CursorPos.Y;
  fPaintPopUp.ShowModal;
end;

procedure TfMain.aSaveXML2Execute(Sender: TObject);
var
  i: Integer;
  ext: String;
begin
  if ModelSet.FileName = ''
    then aSaveAsXML.Execute
    else
    begin
      if ModelSet.ConstrMode then { режим конструктора }
      for i := 0 to 999 do
      begin
        ext := '.' + Copy(IntToStr(1000 + i), 2, 3);
        if not FileExists(ChangeFileExt(ModelSet.FileName, ext))
        then
        begin
          CopyFile(PChar(ModelSet.FileName), PChar(ChangeFileExt(ModelSet.FileName, ext)), True);
          Break;
        end;
      end;
      ZM01.SaveXML(ModelSet.FileName);
    end;
end;

procedure TfMain.aExportCorelExecute(Sender: TObject);
var
  s1, s2: String;
begin
  s1 := ExtractFilePath(Application.ExeName) + 'Templates\01.cdr';
  s2 := ExtractFilePath(Application.ExeName) + 'Cdr\01.cdr';
  ZM01.ExportToCorelDraw(s1, s2);
end;

procedure TfMain.aSplinesExecute(Sender: TObject);
begin
  fSplines := TfSplines.Create(nil);
  with fSplines do
  try
    ShowSplines;
    ShowModal;
  finally
    UpdateTree;
    aDraw.Execute;
    free;
  end;
end;

procedure TfMain.aEditSplineTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  EditSpline(ZM01.SplinesList[Node.Index]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aAddSplineTreeExecute(Sender: TObject);
begin
  AddSpline;
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.aDelSplineTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  DeleteSpline(ZM01.SplinesList[Node.Index]);
  UpdateTree;
  aDraw.Execute;
end;

procedure TfMain.vsTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PNodeData2;

begin
  Data := Sender.GetNodeData(Node);
  CellText := '';
  case Column of
    0:
      case TextType of
        ttNormal:
          CellText := Data.Caption;
        ttStatic:
        case Data.Level of
          0: CellText := IntToStr(Data.Count);
          1: CellText := Data.SValue;
        end;
      end;
  end;
end;

procedure TfMain.vsTreeGetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TNodeData2);
end;

procedure TfMain.vsTreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data: PNodeData2;
begin
  Data := Sender.GetNodeData(Node);
  with Data^ do
  begin
    Level := Sender.GetNodeLevel(Node);
    if Level = 0 then
      Include(InitialStates, ivsHasChildren);
    if Data.Level = 0 then
    case Node.Index of
      0:
      begin
        Caption := 'Мірки';
        Count := ZM01.DimensionList.Count;
      end;
      1:
      begin
        Caption := 'Точки';
        Count := ZM01.PointsList.Count;
      end;
      2:
      begin
        Caption := 'Відрізки, ламані чи сплайни';
        Count := ZM01.SplinesList.Count;
      end;
    end
    else
      case Node.Parent.Index of
        0:
        begin
          Caption := ZM01.DimensionList[Node.Index].UName;
          Count := 0;
          SValue := Format('[L = %3.2f]', [ZM01.DimensionList[Node.Index].Value]);
        end;
        1:
        begin
          Caption := ZM01.PointsList[Node.Index].UName;
          Count := 0;
          SValue := Format('[X = %3.2f, Y = %3.2f]', [ZM01.PointsList[Node.Index].X,
            ZM01.PointsList[Node.Index].Y]);
        end;
        2:
        begin
          Caption := ZM01.SplinesList[Node.Index].Title;
          Count := 0;
          case ZM01.SplinesList[Node.Index].SplineType of
            ltLine:
              if ZM01.SplinesList[Node.Index].PointsList.Count < 3
                then SValue := '[відрізок]'
                else SValue := '[ламана]';
            ltSpline: SValue := Format('[сплайн, кривизна %1.3f]', [ZM01.SplinesList[Node.Index].Tension]);
          end;
        end;
      end;
  end;
end;

procedure TfMain.vsTreeInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
var
  Data: PNodeData2;
begin
  Data := Sender.GetNodeData(Node);
  ChildCount := Data.Count;
end;

procedure TfMain.vsTreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PNodeData2;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0:
      case TextType of
        ttNormal:
          if Data.Level = 0 then
            TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
        ttStatic:
          if Data.Level = 1 then
          begin
            if Node = Sender.HotNode then
              TargetCanvas.Font.Color := clRed
            else
              TargetCanvas.Font.Color := clBlue;
            TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsBold];
          end
          else TargetCanvas.Font.Color := clGray;
      end;
  end;
end;

procedure TfMain.vsTreeGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  Data: PNodeData2;
begin
  Data := Sender.GetNodeData(Node);
  if Data = nil then Exit;
  if ((Data.Level = 0) and (Node.Index = 0)) or
     ((Data.Level = 1) and (Node.Parent.Index = 0)) then
  begin
    pmDimensions.Items[3].Enabled := (Data.Level = 1);
    pmDimensions.Items[4].Enabled := (Data.Level = 1);
    PopupMenu := pmDimensions;
  end;
  if ((Data.Level = 0) and (Node.Index = 1)) or
     ((Data.Level = 1) and (Node.Parent.Index = 1)) then
  begin
    pmPoints.Items[3].Enabled := (Data.Level = 1);
    pmPoints.Items[4].Enabled := (Data.Level = 1);
    pmPoints.Items[5].Enabled := (Data.Level = 1);
    PopupMenu := pmPoints;
  end;
  if ((Data.Level = 0) and (Node.Index = 2)) or
     ((Data.Level = 1) and (Node.Parent.Index = 2)) then
  begin
    pmSplines.Items[3].Enabled := (Data.Level = 1);
    pmSplines.Items[4].Enabled := (Data.Level = 1);
    PopupMenu := pmSplines;
  end;
end;

procedure TfMain.vsTreeDblClick(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PNodeData2;
begin
  if vsTree.SelectedCount = 0 then Exit;
  Node := vsTree.GetFirstSelected;
  Data := vsTree.GetNodeData(Node);
  if ((Data.Level = 0) and (Node.Index = 0)) then
    aDimensions.Execute;
  if ((Data.Level = 0) and (Node.Index = 1)) then
    aPoints.Execute;
  if ((Data.Level = 0) and (Node.Index = 2)) then
    aSplines.Execute;
  if ((Data.Level = 1) and (Node.Parent.Index = 0)) then
    aEditDimensionTree.Execute;
  if ((Data.Level = 1) and (Node.Parent.Index = 1)) then
    aEditPointTree.Execute;
  if ((Data.Level = 1) and (Node.Parent.Index = 2)) then
    aEditSplineTree.Execute;
end;

procedure TfMain.vsTreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PNodeData2;
begin
  Data := vsTree.GetNodeData(Node);
  if ((Data.Level = 1) and (Node.Parent.Index = 1)) then
    if ZM01.PointsList.Selected <> Node.Index then
    begin
      ZM01.PointsList.Selected := Node.Index;
      aDraw.Execute;
    end; 
end;

procedure TfMain.vsLayersGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TNodeDataL);
end;

procedure TfMain.vsLayersGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data: PNodeDataL;
begin
  Data := Sender.GetNodeData(Node);
  case TextType of
    ttNormal: CellText := Data.Caption;
    ttStatic: CellText := Format('[W = %d]', [Data.Width]);
  end;
end;

procedure TfMain.vsLayersInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: PNodeDataL;
begin
  Data := Sender.GetNodeData(Node);
  with Data^ do
  begin
    Caption := ZM01.LayerList[Node.Index].Title;
    AColor := ZM01.LayerList[Node.Index].Color;
    Checked := ZM01.LayerList[Node.Index].Checked;
    Width := ZM01.LayerList[Node.Index].Width;
    Node.CheckType := ctCheckBox;
    case Checked of
      True:  Sender.CheckState[Node] := csCheckedNormal;
      False: Sender.CheckState[Node] := csUnCheckedNormal;
    end;
  end;
end;

procedure TfMain.vsLayersPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PNodeDataL;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0:
      case TextType of
        ttNormal:
        begin
          TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
          TargetCanvas.Font.Color := Data.AColor;
        end;
        ttStatic:
          TargetCanvas.Font.Color := clGray;
      end;
  end;
end;

procedure TfMain.vsLayersChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PNodeDataL;
begin
  Data := Sender.GetNodeData(Node);
  case Sender.CheckState[Node] of
    csCheckedNormal:   Data^.Checked := True;
    csUnCheckedNormal: Data^.Checked := False;
  end;
  ZM01.LayerList[Node.Index].Checked := Data^.Checked;
  aDraw.Execute;
end;

procedure TfMain.vsLayersGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
  Data: PNodeData2;
begin
  Data := Sender.GetNodeData(Node);
  pmLayers.Items[3].Enabled := (Data <> nil);
  pmLayers.Items[4].Enabled := (Data <> nil);
  PopupMenu := pmLayers;
end;

procedure TfMain.aEditLayerTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsLayers.SelectedCount = 0 then Exit;
  Node := vsLayers.GetFirstSelected;
  EditLayer(ZM01.LayerList[Node.Index]);
  UpdateLayers;
  aDraw.Execute;
end;

procedure TfMain.aDelLayerTreeExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  if vsLayers.SelectedCount = 0 then Exit;
  Node := vsLayers.GetFirstSelected;
  DeleteLayer(ZM01.LayerList[Node.Index]);
  UpdateLayers;
  aDraw.Execute;
end;

procedure TfMain.vsLayersDblClick(Sender: TObject);
begin
  if vsLayers.SelectedCount = 0
    then aLayerList.Execute
    else aEditLayerTree.Execute;
end;

procedure TfMain.aHandExecute(Sender: TObject);
begin
  if HandType = htCursor
    then HandType := htHand
    else HandType := htCursor;
  case HandType of
    htHand:   PaintBox1.Cursor := crHandPoint;
    htCursor: PaintBox1.Cursor := crCross;
  end;
end;

procedure TfMain.aCursorExecute(Sender: TObject);
begin
  if HandType = htCursor
    then HandType := htHand
    else HandType := htCursor;
  case HandType of
    htHand:   PaintBox1.Cursor := crHandPoint;
    htCursor: PaintBox1.Cursor := crCross;
  end;
end;

procedure TfMain.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HandPressed := False;
  MovePressed := False;
  case HandType of
    htHand:   PaintBox1.Cursor := crHandPoint;
    htCursor: PaintBox1.Cursor := crCross;
  end;  
end;

procedure TfMain.aCrossMoveExecute(Sender: TObject);
begin
  //
end;

end.

