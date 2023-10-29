unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dglOpenGL, ExtCtrls, ImgList,
  StdCtrls, ComCtrls, jpeg, CL, cl_platform, clext, oclUtils, cl_gl, cl_ext;

type
  TForm1 = class(TForm)
    ImageList1: TImageList;
    sTreeView1: TTreeView;
    LabelCommonPlatform: TLabel;
    LabelCommonVersion: TLabel;
    LabelCommonVendor: TLabel;
    LabelCommonType: TLabel;
    MemoCommonExt: TMemo;
    CB_Devices: TComboBox;
    CB_Platforms: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure CB_DevicesChange(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure CB_PlatformsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    numPlatforms: TCL_uint; // Кол-во платформ
    PPlatform: PCL_platform_id; // Выбранная платформа
    PPPlatforms: PPCL_platform_id; // Массив всех платформ

    procedure oclGetDevice();
    procedure oclGetPlatforms(CB_Platforms: TComboBox);

  public
    { Public declarations }
    Fcurrent_device: PPCL_device_id;
    Fcurrent_indevice: Integer;
    Fcontext: PCL_context;
    FStatus: TCL_int;
    Fdev_num: TCL_int;
    FBuf: array [0..1023]of AnsiChar;
    FSize: TSize_t;
    FBool: Tcl_bool;
    FuLong: TCL_ulong;
    FLong: TCL_uint;
    FVecs: array [0..4] of TSize_t;
    FVecl: array [0..4] of TCL_uint;
//    FInt: PCL_int;
//    FFloat: PCL_float;
    Fplatform_ : PCL_platform_id;
  end;

const
  nvd: AnsiString = 'NVIDIA Corporation';
  ati_amdd: AnsiString = 'ATI Technologies Inc.';

  OCL_DRIVER = 'OpenCL.dll';
//  NV_DRIVER = 'OpenCL.dll';
//  ATI_AMD_DRIVER = 'atiocl.dll';//'OpenCL.dll'

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  CPS: array [0..2] of PCL_context_properties = (
                                                  pcl_context_properties(cl_context_platform),
                                                  nil,
                                                  nil
                                                );

//==============================================================================
//==============================================================================
procedure TForm1.CB_PlatformsChange(Sender: TObject);
 // Изменили выбор платформы.
begin

 clReleaseContext(Fcontext); // Чтобы небыло утечки памяти
 self.oclGetDevice();

end;
//==============================================================================
//==============================================================================
procedure TForm1.CB_DevicesChange(Sender: TObject);
 // Изменили выбор устройства
 var
  node: TTreeNode;
  node2: TTreeNode;

 //-----------------------------------------------------------------------------
  procedure ParseExtensions(const Ext: AnsiString);
   var
    i: Integer;
    OldStep: Integer;

  begin

    node2 := sTreeView1.Items.AddChild(node, 'Extensions:');
    OldStep := 1;
    for i := 1 to Length(Ext) do
     if (Ext[i] = ' ') then
      begin
       sTreeView1.Items.AddChild(node2, Copy(Ext, OldStep, i));
       OldStep := i;
      end; // if (Ext[i] = ' ') then

  end;
 //-----------------------------------------------------------------------------

begin

  Fcurrent_device := oclGetDev(Fcontext, self.CB_Devices.ItemIndex);
  Fcurrent_indevice := Integer(Fcurrent_device^);

  //first page - platform
  sTreeView1.Items.Clear;
  node := sTreeView1.Items.Add(nil, 'Platform');
  FStatus := clGetPlatformInfo(Fplatform_, CL_PLATFORM_NAME, SizeOf(FBuf), @FBuf, nil);
  LabelCommonPlatform.Caption := FBuf;
  sTreeView1.Items.AddChild(node, 'Name: ' + FBuf);

  FStatus := clGetPlatformInfo(Fplatform_, CL_PLATFORM_VERSION, SizeOf(FBuf), @FBuf, nil);
  LabelCommonVersion.Caption := FBuf;
  sTreeView1.Items.AddChild(node, 'Version: ' + FBuf);

  FStatus := clGetPlatformInfo(Fplatform_, CL_PLATFORM_VENDOR, SizeOf(FBuf), @FBuf, nil);
  LabelCommonVendor.Caption := FBuf;
  sTreeView1.Items.AddChild(node, 'Vendor: ' + FBuf);

  FStatus := clGetPlatformInfo(Fplatform_, CL_PLATFORM_PROFILE, SizeOf(FBuf), @FBuf, nil);
  LabelCommonType.Caption := FBuf;
  sTreeView1.Items.AddChild(node, 'Type: ' + FBuf);

  FStatus := clGetPlatformInfo(Fplatform_, CL_PLATFORM_EXTENSIONS, SizeOf(FBuf), @FBuf, nil);
  MemoCommonExt.Text := FBuf;
  ParseExtensions(FBuf);

  //Device
  node := sTreeView1.Items.Add(nil, 'Device');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_NAME, SizeOf(FBuf), @FBuf, nil);
  sTreeView1.Items.AddChild(node, 'Name: ' + FBuf);

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_VERSION, SizeOf(FBuf), @FBuf, nil);
  sTreeView1.Items.AddChild(node, 'Version: ' + FBuf);

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_VENDOR, SizeOf(FBuf), @FBuf, nil);
  sTreeView1.Items.AddChild(node, 'Vendor: ' + FBuf);

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_TYPE, SizeOf(FuLong), @FuLong, nil);
  if (FuLong and CL_DEVICE_TYPE_CPU) <> 0 then
   sTreeView1.Items.AddChild(node, 'Type: CPU');
  if (FuLong and CL_DEVICE_TYPE_GPU) <> 0 then
   sTreeView1.Items.AddChild(node, 'Type: GPU');
  if (FuLong and CL_DEVICE_TYPE_ACCELERATOR) <> 0 then
   sTreeView1.Items.AddChild(node, 'Type: Accelerator');
  if (FuLong and CL_DEVICE_TYPE_Default) <> 0 then
   sTreeView1.Items.AddChild(node, 'Type: Default');
//  if (FuLong and CL_DEVICE_TYPE_All) <> 0 then
//   sTreeView1.Items.AddChild(node, 'Type: All');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_EXTENSIONS, SizeOf(FBuf), @FBuf, nil);
  ParseExtensions(FBuf);

  //compute unit
  node := sTreeView1.Items.Add(nil, 'Compute Unit');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_COMPUTE_UNITS, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'Cores: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_CLOCK_FREQUENCY, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'Clock: ' + IntToStr(FSize) + 'Mhz');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_ADDRESS_BITS, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'BitsWidth: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_WORK_GROUP_SIZE, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'GroupSize: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_WORK_ITEM_SIZES , SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'ItemSize: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'GridDimansions: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_MEM_ALLOC_SIZE, SizeOf(FSize), @FSize, nil);
  sTreeView1.Items.AddChild(node, 'MemoryAllocSize: ' + IntToStr(FSize));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_GLOBAL_MEM_SIZE, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'GlobalMemorySize: ' + IntToStr(Round(FuLong / (1024 * 1024))) + ' MByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'GlobalMemoryCacheLineSize: ' + IntToStr(Round(FuLong / 1024)) + ' KByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_GLOBAL_MEM_CACHE_SIZE, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'GlobalMemoryCacheSize: ' + IntToStr(Round(FuLong / 1024)) + ' KByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_GLOBAL_MEM_SIZE, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'GlobalMemorySize: ' + IntToStr(Round(FuLong / (1024 * 1024))) + ' MByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_ERROR_CORRECTION_SUPPORT, SizeOf(FBool), @FBool, nil);
  if FBool = 0 then
   sTreeView1.Items.AddChild(node, 'ErrorCorrectionSupport: False')
  else
   sTreeView1.Items.AddChild(node, 'ErrorCorrectionSupport: True');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_LOCAL_MEM_TYPE, SizeOf(FSize), @FSize, nil);
  if FSize = 1 then
   sTreeView1.Items.AddChild(node, 'LocalMemoryType: Local')
  else
   sTreeView1.Items.AddChild(node, 'LocalMemoryType: Global');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_LOCAL_MEM_SIZE, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'LocalMemorySize: ' + IntToStr(Round(FuLong / 1024)) + ' KByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_COMPUTE_UNITS, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'LocalMemorySize: ' + IntToStr(Round(FuLong / 1024)) + ' KByte');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_QUEUE_PROPERTIES, SizeOf(FuLong), @FuLong, nil);
  if (FuLong and CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE) <> 0 then
   sTreeView1.Items.AddChild(node, 'QueueProperties: CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE');
  if (FuLong and CL_QUEUE_PROFILING_ENABLE) <> 0 then
   sTreeView1.Items.AddChild(node, 'QueueProperties: CL_QUEUE_PROFILING_ENABLE');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE_SUPPORT, SizeOf(FBool), @FBool, nil);
  if FBool = 0 then
   sTreeView1.Items.AddChild(node, 'ImageSupport: False');
  if FBool = 1 then
   sTreeView1.Items.AddChild(node, 'ImageSupport: True');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_READ_IMAGE_ARGS, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'MaxReadImageARGS: ' + IntToStr(FuLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_WRITE_IMAGE_ARGS, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'MaxWriteImageARGS: ' + IntToStr(FuLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_MAX_READ_IMAGE_ARGS, SizeOf(FuLong), @FuLong, nil);
  sTreeView1.Items.AddChild(node, 'MaxReadImageARGS: ' + IntToStr(FuLong));

  node2 := sTreeView1.Items.AddChild(node, 'PreferredVectorWidth:');
  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Char: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Short: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Int: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Long: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Float: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node2, 'Double: ' + IntToStr(FLong));

  //DeviceImage
  node := sTreeView1.Items.Add(nil, 'Image');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE2D_MAX_WIDTH, SizeOf(FVecs[0]), @FVecs[0], nil);
  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE2D_MAX_HEIGHT, SizeOf(FVecs[0]), @FVecs[1], nil);
  sTreeView1.Items.AddChild(node, '2DMax: ' + IntToStr(FVecs[0]) + 'x' + IntToStr(FVecs[1]));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE3D_MAX_WIDTH, SizeOf(FVecs[0]), @FVecs[0], nil);
  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE3D_MAX_HEIGHT, SizeOf(FVecs[0]), @FVecs[1], nil);
  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_IMAGE3D_MAX_HEIGHT, SizeOf(FVecs[0]), @FVecs[2], nil);
  sTreeView1.Items.AddChild(node, '3DMax: ' + IntToStr(FVecs[0]) + 'x' + IntToStr(FVecs[1]) + 'x' + IntToStr(FVecs[2]));

  //NV Device
  node := sTreeView1.Items.Add(nil, 'NV');

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_COMPUTE_CAPABILITY_MAJOR, SizeOf(FVecl[0]), @FVecl[0], nil);
  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_COMPUTE_CAPABILITY_MINOR, SizeOf(FVecl[0]), @FVecl[1], nil);
  sTreeView1.Items.AddChild(node, 'ComputeCapability: ' + IntToStr(FVecl[0]) + '.' + IntToStr(FVecl[1]));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_REGISTERS_PER_BLOCK, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node, 'RegistersPerBlock: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_WARP_SIZE, SizeOf(FLong), @FLong, nil);
  sTreeView1.Items.AddChild(node, 'WarpSize: ' + IntToStr(FLong));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_GPU_OVERLAP, SizeOf(FBool), @FBool, nil);
  sTreeView1.Items.AddChild(node, 'GPU_Overlap: ' + IntToStr(FBool));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_KERNEL_EXEC_TIMEOUT, SizeOf(FBool), @FBool, nil);
  sTreeView1.Items.AddChild(node, 'KernelExecTimeOut: ' + IntToStr(FBool));

  FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_NV_DEVICE_INTEGRATED_MEMORY, SizeOf(FBool), @FBool, nil);
  sTreeView1.Items.AddChild(node, 'IntegratedMemory: ' + IntToStr(FBool));
end;
//==============================================================================
//==============================================================================
procedure TForm1.oclGetDevice();
 var
  i: integer;

begin

  self.CB_Devices.Items.Clear;
  self.CB_Devices.ItemIndex := -1;

  i := self.CB_Platforms.ItemIndex;
  Fplatform_ := PCL_platform_id(Pointer(Integer(PPPlatforms) + SizeOf(PCL_platform_id) * i)^);

//  FStatus := clGetPlatformIDs(i, @Fplatform_, nil);
//  if (FStatus <> CL_SUCCESS) then
//   begin
//    MessageBoxA(Handle, PAnsiChar(GetString(FStatus)), 'Error', MB_OK or MB_ICONERROR);
//    Close;
//    Exit;
//   end;

  CPS[1] := pcl_context_properties(Fplatform_);
  Fcontext := clCreateContextFromType(@CPS, CL_DEVICE_TYPE_ALL, nil, nil, @Fstatus);
  if (FStatus <> CL_SUCCESS) then
   begin
    MessageBoxA(Handle, PAnsiChar(GetString(FStatus)), 'Error', MB_OK or MB_ICONERROR);
    Close;
    Exit;
   end;

  FStatus := clGetContextInfo(Fcontext, CL_CONTEXT_DEVICES, 0, nil, @Fdev_num);
  if (FStatus <> CL_SUCCESS) then
   begin
    MessageBoxA(0, PAnsiChar(GetString(FStatus)), 'Error', MB_OK or MB_ICONERROR);
    Close;
    Exit;
   end;

  if (Fdev_num <= 0) then
   begin
    MessageBox(Handle, PChar(GetString(FStatus)), 'Error', MB_OK or MB_ICONERROR);
    Close;
    Exit;
   end;

  for i := 0 to (Round(Fdev_num / 4) - 1) do
   begin
    Fcurrent_device := oclGetDev(Fcontext, i);
    Fcurrent_indevice := Integer(Fcurrent_device^);
    FStatus := clGetDeviceInfo(PCL_device_id(Fcurrent_indevice), CL_DEVICE_NAME, SizeOf(FBuf), @FBuf, nil);
    if (FStatus <> CL_SUCCESS) then
     begin
      MessageBox(Handle, PChar(GetString(FStatus)), 'Error', MB_OK or MB_ICONERROR);
      Close;
      Exit;
     end;
    self.CB_Devices.Items.Add('[' + IntToStr(i) + '] ' + string(FBuf));
   end; // for i := 0 to (Round(Fdev_num / 4) - 1) do
  
  self.CB_Devices.ItemIndex := 0;
  self.CB_DevicesChange(self);

end;
//==============================================================================
//==============================================================================
procedure TForm1.oclGetPlatforms(CB_Platforms: TComboBox);
 var
  status: TCL_int;

  i: Cardinal;
  pbuff: array [1..250] of char;

 const
  lpCaption_01: string = 'Error';
  lpText_01: string = 'NULL platform found so Exiting Application.';

begin

  status := CL_SUCCESS;  // = 0
  PPlatform := nil;
  PPPlatforms := nil;

  //=b===1. Выбираем платформу

  status := clGetPlatformIDs(0, nil, @numPlatforms);

  if (status <> CL_SUCCESS) then
   begin
    MessageBox(Handle, PAnsiChar(GetString(status)), PAnsiChar(lpCaption_01), MB_OK or MB_ICONERROR);
    Close;
    Exit;
   end; // if (status <> CL_SUCCESS) then

//  MessageBox(Handle, PAnsiChar('Количество платформ: ' + IntToStr(numPlatforms)), 'Платформы...', MB_OK);

  if (numPlatforms > 0) then
   begin
 // нашли платформы

    PPPlatforms := AllocMem(SizeOf(PCL_platform_id) * numPlatforms); // Выделяем память

    status := clGetPlatformIDs(numPlatforms, PPPlatforms, nil); // Получаем список

    if (status <> CL_SUCCESS) then
     begin
      MessageBox(Handle, PAnsiChar(GetString(status)), PAnsiChar(lpCaption_01), MB_OK or MB_ICONERROR);
      Close;
      Exit;
     end; // if (status <> CL_SUCCESS) then

    for i := 0 to (numPlatforms - 1) do
     begin

      status := clGetPlatformInfo(PCL_platform_id(Pointer(Integer(PPPlatforms) + SizeOf(PCL_platform_id) * i)^),
                                  CL_PLATFORM_VENDOR,
                                  SizeOf(pbuff),
                                  @pbuff,
                                  nil);

      if (status <> CL_SUCCESS) then
       begin
        MessageBox(Handle, PAnsiChar(GetString(status)), PAnsiChar(lpCaption_01), MB_OK or MB_ICONERROR);
        Close;
        Exit;
       end; // if (status <> CL_SUCCESS) then

      CB_Platforms.Items.Add('[' + IntToStr(i) + '] ' + String(pbuff));

      PPlatform := PCL_platform_id(Pointer(Integer(PPPlatforms^) + SizeOf(PCL_platform_id) * i)^);

     end; // for i := 0 to (numPlatforms - 1) do

    PPlatform := PCL_platform_id(Pointer(Integer(PPPlatforms) + SizeOf(PCL_platform_id) * 0)^); // Берём первый попавшийся (0)

 //   FreeMem(PPPlatforms); поместил в процедуру закрытия формы

   end; // if (numPlatforms > 0) then

  if (PPlatform = nil) then
   begin
    MessageBox(Handle, PAnsiChar(lpText_01), PAnsiChar(lpCaption_01), MB_OK or MB_ICONERROR);
    Close;
    Exit;
   end; // if (PPlatform = nil) then

 //=e===1. Выбираем платформу

end;
//==============================================================================
//==============================================================================
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
 // Подчищаем за собой
begin

 clReleaseContext(Fcontext);
 FreeMem(PPPlatforms);

end;
//==============================================================================
//==============================================================================
procedure TForm1.FormCreate(Sender: TObject);
var
//  SysDir: array [0..(MAX_PATH - 1)] of AnsiChar;
//  l: Cardinal;
//  FVendor: AnsiString;
//  FRC: HGLRC;
//  FDC: HDC;
//  pfd: TPixelFormatDescriptor;
  FOCL: AnsiString;
//
//  i: Integer;
begin
//  l := MAX_PATH;
//  GetSystemDirectoryA(@SysDir[0], l);
//
//{$REGION 'GetVendor'}
//  FillChar(pfd, SizeOf(pfd), 0);
//  with pfd do begin
//    nSize := SizeOf(pfd);
//    nVersion := 1;
//    dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
//    iPixelType   := PFD_TYPE_RGBA;
//    cColorBits := 32;
//    cDepthBits := 24;
//    cStencilBits := 8;
//    iLayerType   := PFD_MAIN_PLANE;
//  end;
//
//  InitOpenGL;
//  DeactivateRenderingContext;
//  FDC := GetDC(Form1.Handle);
//
//  SetPixelFormat(FDC, ChoosePixelFormat(FDC, @pfd), @pfd);
//
//  FRC := dglOpenGL.wglCreateContext(FDC);
//  wglMakeCurrent(FDC, FRC);
//  ReadImplementationProperties;
//  ReadExtensions;
//  FVendor     := glGetString(GL_VERSION);
//  FVendor := glGetString(GL_VENDOR);
//  wglMakeCurrent(0, 0);
//  wglDeleteContext(FRC);
//  ReleaseDC(Form1.Handle, FDC);
//{$ENDREGION}

  FOCL := OCL_DRIVER;

//  if FVendor = nvd then
//   FOCL := NV_DRIVER
//  else
//   if FVendor = ati_amdd then
//    FOCL := ATI_AMD_DRIVER;

//  if FVendor = nvd then
//   ImageNV.Visible := True
//  else
//   if FVendor = ati_amdd then
//    ImageAMD.Visible := True;

  if not InitOpenCL(string(FOCL)) then begin
    MessageBoxA(Handle, 'InitOpenCL - fail', 'Error', MB_OK or MB_ICONERROR);
    Exit;
  end;

  InitCL_EXT;
//  InitCL_OGL;
//  InitCL_D3D9;
//  InitCL_D3D10;

 PPPlatforms := nil; // Инициализируем указатель на массив всех платформ nil`ом. Т.к. выделяем память для него 

 self.oclGetPlatforms(self.CB_Platforms);

 self.CB_Platforms.ItemIndex := 0;
 self.CB_PlatformsChange(self);

end;
//==============================================================================
//==============================================================================
procedure TForm1.sButton1Click(Sender: TObject);
begin
  Close;
end;
//==============================================================================
//==============================================================================
end.
