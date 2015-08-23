program sewingshop;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  ZSewing in 'ZSewing.pas',
  ZSewingExceptions in 'ZSewingExceptions.pas',
  uCuts in 'uCuts.pas' {fCuts},
  uSetDim in 'uSetDim.pas' {fSetDim},
  ZMParser in 'ZMParser.pas',
  uEditPoint in 'uEditPoint.pas' {fEditPoint},
  uDimensions in 'uDimensions.pas' {fDimensions},
  uInfo in 'uInfo.pas' {fInfo},
  uStandartDimensions in 'uStandartDimensions.pas' {fStandartDimensions},
  uPoints in 'uPoints.pas' {fPoints},
  uGlobal in 'uGlobal.pas',
  uSetting in 'uSetting.pas' {fSetting},
  uEditLayer in 'uEditLayer.pas' {fEditLayer},
  uTypeRozmList in 'uTypeRozmList.pas' {fTypeRozmList},
  uEdTypeRozm in 'uEdTypeRozm.pas' {fEdTypeRozm},
  uDimPoznList in 'uDimPoznList.pas' {fDimPoznList},
  uEdDimPozn in 'uEdDimPozn.pas' {fEdDimPozn},
  uEditStDimValue in 'uEditStDimValue.pas' {fEditStDimValue},
  uLayerList in 'uLayerList.pas' {fLayerList},
  uPaintPopUp in 'uPaintPopUp.pas' {fPaintPopUp},
  uProgress in 'uProgress.pas' {fProgress},
  uSplines in 'uSplines.pas' {fSplines},
  uEditSplines in 'uEditSplines.pas' {fEditSpline},
  uErrorList in 'uErrorList.pas' {fErrorList};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Sewing Shop 1.0 - моделювання та побудова викройок';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfCuts, fCuts);
  Application.CreateForm(TfPaintPopUp, fPaintPopUp);
  Application.Run;
end.
