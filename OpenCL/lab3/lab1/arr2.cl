__kernel void mul( global int4* A, global int4* out)
{
	int num = get_global_id(0); 
	out[num].x = A[num].x + A[num].z;
	out[num].yzw = A[num].yzw;
}

__kernel void mul2( global int4* A, global int4* out)
{
	int num = get_global_id(0); 
	out[num] = A[num];
	out[num].y = trunc((A[num].w+A[num].x)/3.0);
}