__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST; 

__kernel void main1(read_only image2d_t src_image,
                        write_only image2d_t dst_image)
 {
	uint x = get_global_id(0);
	uint y = get_global_id(1);
	
	uint width = get_global_size(0);
	uint height = get_global_size(1);

	uint4 pixel;
	int2 coord;

	coord = (int2)(x,y);
	if(x<=50 && y<=50){
		pixel = (uint4)(255);
	}
	else {
		pixel = read_imageui(src_image, sampler, coord);
		pixel.xyz = (uint3)(255-(pixel.x+pixel.y+pixel.z)/3);
	}
   	write_imageui(dst_image, coord, pixel);
}
