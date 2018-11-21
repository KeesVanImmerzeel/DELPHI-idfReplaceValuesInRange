program idfReplaceValuesInRange;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  uTSingleESRIgrid,
  AVGRIDIO,
  math,
  SysUtils,
  uError,
  UidfReplaceValuesInRange in 'UidfReplaceValuesInRange.pas' {MainForm};

var
  iResult, i, j: Integer;
  aValue, MinValue, MaxValue, ReplaceValue: Single;
  s: String;
  ReplaceByNA: Boolean;

{$R *.res}

Procedure ShowArgumentsAndTerminate;
begin
  ShowMessage('idfReplaceValuesInRange IDFin min max ReplaceValue IDFout');
  Application.Terminate;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  if (not (ParamCount() = 5)) then
    ShowArgumentsAndTerminate;

  MinValue := 0;
  MaxValue := 0;
  ReplaceValue := 0;
  s := '';
  ReplaceByNA := True;
  Try
    MinValue := StrToFloat(ParamStr(2));
    MaxValue := StrToFloat(ParamStr(3));
    s := ParamStr(4);
    ReplaceByNA := (AnsiCompareText(s,'NA')=0);
    if not ReplaceByNA then
      ReplaceValue := StrToFloat(s)
    else
      WriteToLogFile( 'Replace by NA.' );
  Except
    ShowArgumentsAndTerminate;
  End;

  if MinValue > MaxValue then
    ShowArgumentsAndTerminate;

  MainForm.IDFin := TSingleESRIgrid.InitialiseFromIDFfile(ParamStr(1), iResult,
    MainForm);

  with MainForm.IDFin do
  begin
    for i := 1 to NRows do
    begin
      for j := 1 to NCols do
      begin
        aValue := GetValue(i, j);
        if (aValue <> MissingSingle) then
        begin
          if (aValue >= MinValue) and (aValue < MaxValue) then begin
            if ReplaceByNA then
              MainForm.IDFin[i, j] :=  MissingSingle
            else
              MainForm.IDFin[i, j] :=  ReplaceValue;
          end;
        end; { -if }
      end; { -for j }
    end; { -for i }
    ExportToIDFfile(ParamStr(5))
  end;
  //ShowMessageFmt('IDF written to file [%s].', [ExpandFileName(ParamStr(4))]);

  //Application.Run;
end.
