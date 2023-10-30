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
	int2 coord = (int2)(x,y);
	int2 origCoord;
	
	if (x<width/2){
		if(y<height/2){
			origCoord = (int2)(coord.x*2, coord.y*2);
			pixel = read_imageui(src_image, sampler, origCoord);
			pixel.xyw = (0,0,0);
		}
		else {
			origCoord = (int2)(coord.x*2, coord.y*2-height);
			pixel = read_imageui(src_image, sampler, origCoord);
			pixel.xzw = (0,0,0);
		}
	}	
	else{
		if(y<height/2){
			origCoord = (int2)(coord.x*2-width, coord.y*2);
			pixel = read_imageui(src_image, sampler, origCoord);
			pixel.yzw = (0,0,0);
		}
		else {
			origCoord = (int2)(coord.x*2-width, coord.y*2-height);
			pixel = read_imageui(src_image, sampler, origCoord);
			pixel.xyz = pixel.zyx;
		}
	}

   	write_imageui(dst_image, coord, pixel);
}
