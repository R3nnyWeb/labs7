program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  CL_platform in 'Libs\OpenCL\CL_platform.pas',
  CL in 'Libs\OpenCL\CL.pas',
  DelphiCL in 'Libs\OpenCL\DelphiCL.pas',
  SimpleImageLoader in 'Libs\OpenCL\SimpleImageLoader.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

