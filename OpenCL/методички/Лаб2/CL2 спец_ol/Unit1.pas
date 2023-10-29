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
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    Button5: TButton;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label2: TLabel;
    OpenDialog2: TOpenDialog;
    Label4: TLabel;
    Label10: TLabel;
    Button6: TButton;
    Button7: TButton;
    ComboBox3: TComboBox;
    Label6: TLabel;
    ComboBox4: TComboBox;
    Label7: TLabel;
    ComboBox5: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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

  //execute
  platform_id , device_id:integer;

 //========
 tdclps:TDCLPlatforms;
 tdclp:TDCLPlatform;
 clp_count:integer;
 dev_count:integer;
 clp_tec:integer;

 FT:text;

implementation

uses Unit2, Unit3;

{$R *.dfm}

procedure Draw;
begin
form1.Repaint;
form1.Canvas.Draw(0,0,bmp);
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
 s,s1:string;
 j:integer;
 cl_file_name:string;
 begin
InitOpenCL();
platform_id:=combobox1.ItemIndex;
device_id:=combobox2.ItemIndex;

if opendialog2.execute then
begin
combobox5.Items.Clear();
  clp_tec:=combobox1.Itemindex;
//tdclp:=TDCLPlatforms.Create().Platforms[clp_tec];
  i_dev:=TDCLPlatforms.Create().Platforms[clp_tec].Devices[device_id];
  memo1.Lines.Add('Устройство - '+GetString(i_dev.Status));

 with i_dev do
 begin
    //s:=Edit2.text;
    MainProgram := CreateProgram(Opendialog2.FileName);
    assignfile(FT,Opendialog2.FileName);
    reset(FT);
    while not(EOF(FT)) do
    begin
      readln(FT,s1);
      j:=-1;
      j:=pos('__kernel void ',s1);
      if j>0 then
      begin
        s1:=copy(s1,J+14,length(s1)-14);
        j:=pos('(',s1);
        s1:=copy(s1,1,j-1);
        j:=1;
        while s1[j]=' ' do
        inc(j);

        s1:=copy(s1,j,length(s1)-j+1);
        memo1.lines.add('Kernel in file - '+s1);
        combobox5.Items.Add(s1);
      end;
    end;
    closefile(FT);

    combobox5.ItemIndex:=0;
    memo1.Lines.Add('OpenCL устройство инициализированно!');
 end;


end;


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
s:string;
begin
 s:=Combobox5.Text;
 Kernel := MainProgram.CreateKernel(@s[1]);
 memo1.Lines.Add('Kernel - '+GetString(kernel.Status));
 CommandQueue:= i_dev.CreateCommandQueue();
 memo1.Lines.Add('CommandQueue - '+GetString(CommandQueue.Status));

Form3.show;
iter:=strtoint(Edit1.text);
QueryPerformanceFrequency(iCounterPerSec);
QueryPerformanceCounter(d_tic[1].tn);

for i:=1 to iter do
begin
    ImageLoader:= TImageLoader.Create(bmp,combobox3.itemindex,combobox4.itemindex);
    ImageLoaderZ:= TImageLoader.Create(bmp1,combobox3.itemindex,combobox4.itemindex);

   with i_dev do
    begin
    with ImageLoader do InputImage:= CreateImage2D(Format,Width,Height,0,ImageLoader.Pointer,[mfReadOnly, mfUseHostPtr]);
    with ImageLoaderZ do OutputImage:= CreateImage2D(Format,Width,Height,0,nil,[mfReadWrite, mfAllocHostPtr]);

    Kernel.SetArg(0,InputImage);
    Kernel.SetArg(1,OutputImage);

    QueryPerformanceCounter(d_tic[2].tn);
    CommandQueue.Execute(Kernel,[ImageLoader.Width,ImageLoader.Height]);
    memo1.Lines.Add('Execute - '+ GetString(CommandQueue.Status));

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
memo1.Lines.Add('Общее время выполнения- '+FormatFloat('0.0000', (d_tic[1].tf / iCounterPerSec)));
memo1.Lines.Add('В том числе время вычислений - '+FormatFloat('0.0000', (d_tic[2].tf / iCounterPerSec)));
//form1.label1.Caption:=FormatFloat('0.0000', (d_tic[1].tf / iCounterPerSec));
//form1.label9.Caption:=FormatFloat('0.0000', (d_tic[2].tf / iCounterPerSec));
Form3.Image2.Picture.Bitmap.Assign(bmp1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
bmp:=TBitmap.Create;
bmpR:=TBitmap.Create;
bmp1:=TBitmap.Create;
button5.onclick(self);
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
 Form2.image1.Picture.Bitmap.Assign(bmp);
 Form2.Show();
 bmp1.Assign(bmp);
 Memo1.Lines.Add('Bitmap - '+inttostr(bmp.Height)+'x'+inttostr(bmp.width));
end;
end;



procedure get_platform_info(id:integer);
begin
    tdclp:=TDCLPlatforms.Create().Platforms[id];
    form1.memo1.Lines.Add('======================================');
    form1.memo1.Lines.Add('Платформа № - '+inttostr(id));
    form1.memo1.Lines.Add('Наименование - '+tdclp.Name);
    form1.memo1.Lines.Add('Версия - '+tdclp.Version);
    form1.memo1.Lines.Add('Профиль - '+tdclp.Profile);
    form1.memo1.Lines.Add('Количество устройств на платформе - '+inttostr(tdclp.DeviceCount));
    form1.memo1.Lines.Add('Количество расширений для платформы - '+inttostr(tdclp.ExtensionsCount));
    form1.memo1.Lines.Add('Доступные расширения платформы:');
    form1.memo1.Lines.Add(tdclp.ExtensionsString);
    tdclp.Free;
end;

procedure get_device_info(pid,id:integer);
begin
//    tdclp:=TDCLPlatforms.Create().Platforms[pid];
    i_dev:=TDCLPlatforms.Create().Platforms[pid].Devices[id];
    form1.memo1.Lines.Add('======================================');
    form1.memo1.Lines.Add('Устройство № - '+inttostr(id));
    if i_dev.IsCPU then  form1.memo1.Lines.Add('Тип устройства - CPU');
    if i_dev.IsGPU then  form1.memo1.Lines.Add('Тип устройства - GPU');

    form1.memo1.Lines.Add('Наименование - '+i_dev.Name);
    form1.memo1.Lines.Add('Версия - '+i_dev.Version);
    form1.memo1.Lines.Add('Профиль - '+i_dev.Profile);

    form1.memo1.Lines.Add('Версия драйвера - '+i_dev.DriverVersion);
    form1.memo1.Lines.Add('Версия OpenCL - '+i_dev.OpenCLCVersion);
  
    form1.memo1.Lines.Add('Количество расширений для устройства - '+inttostr(i_dev.ExtensionsCount));
    form1.memo1.Lines.Add('Доступные расширения устройства:');
    form1.memo1.Lines.Add(i_dev.ExtensionsString);
    i_dev.Free;
//    tdclp.Free;
end;


procedure TForm1.Button5Click(Sender: TObject);
var j:integer;
begin
Memo1.Lines.Clear();
combobox1.Items.Clear();

InitOpenCL();

tdclps:=TDCLPlatforms.Create();
if tdclps.Status=0 then
begin
 clp_count:=tdclps.PlatformCount;
 memo1. lines.add('Количество доступных платформ - '+inttostr(clp_count));

  for j:=0 to clp_count-1 do
  begin
     tdclp:=TDCLPlatforms.Create().Platforms[j];
     combobox1.Items.Add(tdclp.Name);
     clp_tec:=j;
     tdclp.Free;
  end;

  combobox1.Itemindex:=clp_tec;

  tdclp:=TDCLPlatforms.Create().Platforms[clp_tec];
  dev_count:=tdclp.DeviceCount;
  combobox2.Items.Clear;
  for j:=0 to dev_count-1 do
  begin
     //get_platform(j);
     //memo1.Lines.Add('');
     i_dev:=TDCLPlatforms.Create().Platforms[clp_tec].Devices[j];
     combobox2.Items.Add(i_dev.Name);
     i_dev.Free;

  end;
  tdclp.Free;

  combobox2.Itemindex:=combobox2.Items.Count-1;

end
else
 memo1.Lines.Add(GetString(tdclps.Status));



{

clp_count:=tdclps.PlatformCount;
tdclps.Free;
 for j:=0 to clp_count-1 do
 begin
   tdclp:=TDCLPlatforms.Create().Platforms[j];
   dev_count:=tdclp.DeviceCount;
   tdclp.Free;

   for i:=0 to dev_count-1 do
   begin
     i_dev:=TDCLPlatforms.Create().Platforms[j].Devices[i];
     combobox2.Items.Add(inttostr(j)+','+inttostr(i)+'-'+i_dev.Name);
     i_dev.Free;
   end;
}
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var j:integer;
begin
 get_platform_info(combobox1.ItemIndex);
 tdclp:=TDCLPlatforms.Create().Platforms[combobox1.ItemIndex];
 dev_count:=tdclp.DeviceCount;
 combobox2.Items.Clear;
 for j:=0 to dev_count-1 do
 begin
     i_dev:=TDCLPlatforms.Create().Platforms[combobox1.ItemIndex].Devices[j];
     combobox2.Items.Add(i_dev.Name);
     i_dev.Free;
 end;
  tdclp.Free;
  combobox2.Itemindex:=   combobox2.items.Count-1;

end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
 get_device_info(combobox1.ItemIndex,combobox2.ItemIndex);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
Form2.Show();
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
Form3.show;
end;

end.
