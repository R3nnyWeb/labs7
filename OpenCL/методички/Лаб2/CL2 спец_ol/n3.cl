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
	
	if(x!=0 && y!=0 && x != width && y != height){
		uint4 arr[9];

		int index = 0;
		for(int i=-1; i<=1; i++){
			for(int j=-1; j<=1; j++){
				pixel = read_imageui(src_image, sampler, (int2)(x+i, y+j));
				//pixel.xyz = (uint3)(0.299f*pixel.x + 0.587f*pixel.y + 0.114f*pixel.z);
				arr[index] = pixel;
				index++;
			}
		}
		for(int i=1; i<9; i++){
			uint4 key = arr[i];
			int j = i-1;
			while(j>=0 && arr[j].z>key.z){
				arr[j+1] = arr[j];
				j = j-1;
			}
			arr[j+1] = key;
		}
		write_imageui(dst_image, coord, arr[4]);
	}
	else {
		pixel = read_imageui(src_image, sampler, coord);
		write_imageui(dst_image, coord, pixel);
	} 	
}