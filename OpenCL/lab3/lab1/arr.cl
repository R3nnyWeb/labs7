__kernel void mul( global int4* A, global int* phase, global int4* out)
{
	int num = get_global_id(0); 
	if(*phase == 0){
		out[num].x = A[num].x + A[num].z;
		*phase = 1;
	}
	else{
		out[num].y = trunc((A[num].w+A[num].x)/3.0);
	}
}