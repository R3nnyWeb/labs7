__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST; 

__kernel void main(read_only image2d_t src_image,
                        write_only image2d_t dst_image)
 {


	uint x = get_global_id(0);
	uint y = get_global_id(1);
	
	uint width = get_global_size(0);
	uint height = get_global_size(1);

	uint4 i00;
	uint4 pixel;
	int2 coord;


	float4 Gx = (float4)(0);
	float4 Gy = Gx;

	coord = (int2)(x-1,y-1);	

	if( x >= 1 && x < (width-1) && y >= 1 && y < height - 1)
	{

	i00 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x,y-1);
	uint4 i10 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x+1,y-1);
	uint4 i20 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x-1,y);
	uint4 i01 = read_imageui(src_image, sampler, coord);

	coord = (int2)(x+1,y);
	uint4 i21 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x-1,y+1);
	uint4 i02 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x,y+1);
	uint4 i12 = read_imageui(src_image, sampler, coord);
	coord = (int2)(x+1,y+1);
	uint4 i22 = read_imageui(src_image, sampler, coord);

	coord = (int2)(x,y);
	uint4 i11 = read_imageui(src_image, sampler, coord);


	Gx =(float4)(i02.x,i02.y,i02.z,i02.w)+(float4)(i12.x,i12.y,i12.z,i12.w)+(float4)(i22.x,i22.y,i22.z,i22.w);
	Gx -= (float4)(i00.x,i00.y,i00.z,i00.w)+(float4)(i10.x,i10.y,i10.z,i10.w)+(float4)(i20.x,i20.y,i20.z,i20.w);


	Gy =(float4)(i20.x,i20.y,i20.z,i20.w)+(float4)(i21.x,i21.y,i21.z,i21.w)+(float4)(i22.x,i22.y,i22.z,i22.w);
	Gy -= (float4)(i00.x,i00.y,i00.z,i00.w)+(float4)(i01.x,i01.y,i01.z,i01.w)+(float4)(i02.x,i02.y,i02.z,i02.w);


	
	float4 Gxy =hypot(Gx, Gy);

	if (Gxy.x>(float)(255)){Gxy=(float4)(255);}
//	if (Gxy.x<(float)(flt1)){Gxy=(float4)(0);}
//	pixel = (uint4)(255)-(uint4)(Gxy.x, Gxy.y, Gxy.z, Gxy.w);
	pixel = (uint4)(255)-(uint4)(Gxy.x, Gxy.x, Gxy.x, Gxy.w);


   write_imageui(dst_image, coord, pixel);
}
else
{
coord = (int2)(x,y);
write_imageui(dst_image, coord, (uint4)(255));
}


}
