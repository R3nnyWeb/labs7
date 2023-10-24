__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST; 

__kernel void ww(read_only image2d_t src_image,
                        write_only image2d_t dst_image)
 {


	uint x = get_global_id(0);
	uint y = get_global_id(1);
	
	uint width = get_global_size(0);
	uint height = get_global_size(1);

	uint4 i00;
	int2 coord;


	float4 Gx = (float4)(0);
	float4 Gy = Gx;

	coord = (int2)(x,y);	

	if( x >= 10 && x < (width-10) && y >= 10 && y < height - 10)
	{

	i00 = read_imageui(src_image, sampler, coord);
	i00=(uint4)(255)-i00;
	write_imageui(dst_image, coord,i00);
}
else
{
coord = (int2)(x,y);
write_imageui(dst_image, coord, (uint4)(255));
}


}
