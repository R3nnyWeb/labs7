__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST; 

__kernel void main1(read_only image2d_t src_image,
                        write_only image2d_t dst_image)
 {


	uint x = get_global_id(0);
	uint y = get_global_id(1);
	
	uint width = get_global_size(0);
	uint height = get_global_size(1);

	uint4 i00;
	uint4 pixel;
	int2 coord;

	coord = (int2)(x,y);
	pixel = read_imageui(src_image, sampler, coord);
	if (x<width/2){
		pixel.xyw = (0,0,0);
	}	
	else{
		pixel.yzw = (0,0,0);
	}
	
	


   write_imageui(dst_image, coord, pixel);


}
