unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  CL_platform, CL, DelphiCL, SimpleImageLoader, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Edit4: TEdit;
    Label2: TLabel;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type time_count=record
tn,tk,tf,te:TLargeInteger;
end;


var
  Form1: TForm1;

  CommandQueue: TDCLCommandQueue;
  MainProgram: TDCLProgram;
  Kernel,k1 : TDCLKernel;

  InputImage,OutputImage: TDCLImage2D;
  ImageLoader,ImageLoaderZ: TImageLoader;
  i_dev:TDCLDevice;
  bmp,bmpr,bmp1:Tbitmap;


  d_tic:array [1..10] of time_count;


implementation

{$R *.dfm}

procedure Draw;
begin
form1.Repaint;
form1.Canvas.Draw(0,0,bmp);
end;

procedure TForm1.Button1Click(Sender: TObject);
Var id,id2:integer;
s:string;
begin
id:=strtoint(edit4.text);
id2:=strtoint(edit2.text);
 InitOpenCL();
 i_dev:=TDCLPlatforms.Create().Platforms[id].Devices[id2];// DeviceWithMaxImage3DWidth; //DeviceWithMaxComputeUnits;
 with i_dev do
 begin
    MainProgram := CreateProgram(ExtractFilePath(ParamStr(0))+'Prog.cl');
    Kernel := MainProgram.CreateKernel('main');
 k1 := MainProgram.CreateKernel('11111');
    CommandQueue:= CreateCommandQueue();
end;
s:=chr(0);
id:=pos(s,i_dev.Name);
s:='Инициализация устройства '+copy(i_dev.Name,1,id-1)+' проведена!';
ShowMessage(s);
form1.Caption:=i_dev.Name;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Kernel.Free();
    MainProgram.Free();
//    Kernel2.Free();
//    Program2.Free();
    CommandQueue.Free();
end;

var
  iCounterPerSec: TLargeInteger;
  iterPerSec: TLargeInteger;

procedure TForm1.Button3Click(Sender: TObject);
var i,iter: integer ;

begin
iter:=strtoint(Edit1.text);
QueryPerformanceFrequency(iCounterPerSec);
QueryPerformanceCounter(d_tic[1].tn);

for i:=1 to iter do
begin
    ImageLoader:= TImageLoader.Create(bmp);
    ImageLoaderZ:= TImageLoader.Create(bmp1);

   with i_dev do
    begin
    with ImageLoader do InputImage:= CreateImage2D(Format,Width,Height,0,ImageLoader.Pointer,[mfReadOnly, mfUseHostPtr]);
    with ImageLoaderZ do OutputImage:= CreateImage2D(Format,Width,Height,0,nil,[mfReadWrite, mfAllocHostPtr]);

    Kernel.SetArg(0,InputImage);
    Kernel.SetArg(1,OutputImage);

    QueryPerformanceCounter(d_tic[2].tn);
    CommandQueue.Execute(Kernel,[ImageLoader.Width,ImageLoader.Height]);
    QueryPerformanceCounter(d_tic[2].tk);
    ImageLoader.Resize(ImageLoader.Width,ImageLoader.Height);//Dispose and Get Memory
    ImageLoaderZ.Resize(ImageLoaderZ.Width,ImageLoaderZ.Height);//Dispose and Get Memory

    CommandQueue.ReadImage2D(OutputImage,ImageLoaderZ.Width,ImageLoaderZ.Height,ImageLoaderZ.Pointer);

    ImageLoaderZ.Save(bmp1);
    ImageLoaderZ.Free();
    ImageLoader.Free();//!!
    InputImage.Free();
    OutputImage.Free();
    end;

end;
QueryPerformanceCounter(d_tic[1].tk);
d_tic[1].tf:=d_tic[1].tk-d_tic[1].tn;
d_tic[2].tf:=d_tic[2].tk-d_tic[2].tn;
form1.label1.Caption:=FormatFloat('0.0000', (d_tic[1].tf / iCounterPerSec));
form1.label9.Caption:=FormatFloat('0.0000', (d_tic[2].tf / iCounterPerSec));
Image2.Picture.Bitmap.Assign(bmp1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
bmp:=TBitmap.Create;
bmpR:=TBitmap.Create;
bmp1:=TBitmap.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
bmp.Free;
bmpr.Free;
bmp1.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
if opendialog1.Execute then
begin
bmp.LoadFromFile(opendialog1.filename);
image1.Picture.Bitmap.Assign(bmp);
bmp1.Assign(bmp);
end;
//bmpr.LoadFromFile('R.bmp');
//bmp1.Assign(bmp);
//draw;
end;

end.
