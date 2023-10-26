(********************************************)
(*                                          *)
(*                DelphiCL                  *)
(*                                          *)
(*      created by      : Maksym Tymkovych  *)
(*                           (niello)       *)
(*                                          *)
(*      headers versions: 0.07              *)
(*      file name    : SimpleImageLoader.pas*)
(*      last modify     : 10.12.11          *)
(*      license         : BSD               *)
(*                                          *)
(*      Site            : www.niello.org.ua *)
(*      e-mail          : muxamed13@ukr.net *)
(*      ICQ             : 446-769-253       *)
(*                                          *)
(*********Copyright (c) niello 2008-2011*****)
unit SimpleImageLoader;

interface

uses
  CL_platform,
  CL,
  Graphics;

type
  PArrayByte = ^TArrayByte;
  TArrayByte = Array [0..0] of TCL_uchar4;
  TImageLoader = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FPtr: PArrayByte;
    FFormat: TCL_image_format;
    procedure SetPointer(const Ptr: Pointer);
    function GetPointer(): Pointer;
    function GetFormat(): PCL_image_format;
  public
    constructor Create(var bmp: TBitmap; pid,fid:integer); overload;
    constructor Create(); overload;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Pointer: Pointer read GetPointer write SetPointer;
    property Format: PCL_image_format read GetFormat;
    procedure Free();
    procedure Save(var bmp: tbitmap);
    procedure Update(var bmp: tbitmap);
    procedure Resize(const Width,Height: Integer);
  end;

implementation

{ TImageLoader }

constructor TImageLoader.Create(var bmp: TBitmap; pid,fid:integer);
var
//  bmp: Graphics.TBitmap;
  i,j: Integer;
  row: PArrayByte;
begin
//  inherited Create();
//  bmp := TBitmap.Create;
//  bmp.LoadFromFile(FileName);
  FWidth := bmp.Width;
  FHeight := bmp.Height;
  bmp.PixelFormat := pf32bit;
  FPtr:=GetMemory(FWidth*FHeight*4);
  for i:=0 to FHeight-1 do
  begin
    row := bmp.ScanLine[i];
    for j:=0 to FWidth-1 do
    begin
        FPtr^[i*FWidth+j].u8 := row^[j].u8;
    end;
  end;
  case pid of
  0:FFormat.Image_channel_order := CL_R;
  1:FFormat.Image_channel_order := CL_A;
  2:FFormat.Image_channel_order := CL_RG;
  3:FFormat.Image_channel_order := CL_RA;
  4:FFormat.Image_channel_order := CL_RGB;
  5:FFormat.Image_channel_order := CL_RGBA;
  6:FFormat.Image_channel_order := CL_BGRA;
  7:FFormat.Image_channel_order := CL_ARGB;
  8:FFormat.Image_channel_order := CL_INTENSITY;
  9:FFormat.Image_channel_order := CL_LUMINANCE;
  10:FFormat.Image_channel_order := CL_Rx;
  11:FFormat.Image_channel_order := CL_RGx;
  12:FFormat.Image_channel_order := CL_RGBx;
  end;
  //FFormat.Image_channel_order := CL_BGRA; //BMP - BGRA file

  case fid of
  0:FFormat.Image_channel_data_type := CL_SNORM_INT8;
  1:FFormat.Image_channel_data_type :=CL_SNORM_INT16;
  2:FFormat.Image_channel_data_type :=CL_UNORM_INT8;
  3:FFormat.Image_channel_data_type :=CL_UNORM_INT16;
  4:FFormat.Image_channel_data_type :=CL_UNORM_SHORT_565;
  5:FFormat.Image_channel_data_type :=CL_UNORM_SHORT_555;
  6:FFormat.Image_channel_data_type :=CL_UNORM_INT_101010;
  7:FFormat.Image_channel_data_type :=CL_SIGNED_INT8;
  8:FFormat.Image_channel_data_type :=CL_SIGNED_INT16;
  9:FFormat.Image_channel_data_type :=CL_SIGNED_INT32;
  10:FFormat.Image_channel_data_type :=CL_UNSIGNED_INT8;
  11:FFormat.Image_channel_data_type :=CL_UNSIGNED_INT16;
  12:FFormat.Image_channel_data_type :=CL_UNSIGNED_INT32;
  13:FFormat.Image_channel_data_type :=CL_HALF_FLOAT;
  14:FFormat.Image_channel_data_type :=CL_FLOAT;
  //FFormat.Image_channel_data_type := CL_UNSIGNED_INT8;
  end;

//  bmp.Free();
end;

constructor TImageLoader.Create();
begin
  inherited Create();

  FFormat.Image_channel_order := CL_BGRA; //BMP - BGRA file
  FFormat.Image_channel_data_type := CL_UNSIGNED_INT8;
end;

procedure TImageLoader.Update(var bmp: tbitmap);
var
//  bmp: Graphics.TBitmap;
  i,j: Integer;
  row: PArrayByte;
begin
  for i:=0 to FHeight-1 do
  begin
    row := bmp.ScanLine[i];
    for j:=0 to FWidth-1 do
    begin
        FPtr^[i*FWidth+j].u8 := row^[j].u8;
    end;
  end;
end;

procedure TImageLoader.Save(var bmp: tbitmap);
var
//  bmp: TBitmap;
  i,j: integer;
  row: PArrayByte;
begin
//  bmp:=TBitmap.Create();
//  bmp.Width := Width;
//  bmp.Height := Height;
  bmp.PixelFormat := pf32bit;
    for i:=0 to FHeight-1 do
    begin
      row := bmp.ScanLine[i];
      for j:=0 to FWidth-1 do
      begin
        row^[j].u8 := FPtr^[(i*FWidth+j)].u8;
      end;
    end;
//  bmp.SaveToFile(FileName);
//  bmp.Free;
end;

procedure TImageLoader.Free;
begin
  Dispose(FPtr);
  inherited Free();
end;

function TImageLoader.GetFormat: PCL_image_format;
begin
  Result := @FFormat;
end;

function TImageLoader.GetPointer: Pointer;
begin
  Result := FPtr;
end;

procedure TImageLoader.SetPointer(const Ptr: Pointer);
begin
  FPtr := Ptr;
end;

procedure TImageLoader.Resize(const Width, Height: Integer);
begin
//  freemem(FPtr);
  Dispose(FPtr);
  FPtr:=GetMemory(FWidth*FHeight*4);
end;

end.
