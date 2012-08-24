program ProcessingBeforePrinting;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ProcessingBeforePrinting_ in 'ProcessingBeforePrinting_.pas',
  Graphic_ in 'Graphic_.pas',
  BookOption_ in 'BookOption_.pas',
  File_ in 'File_.pas',
  Option in 'Option.pas',
  Globals in 'Globals.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
