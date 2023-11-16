__kernel void mul( global float* A,global float* B, global float* out)
{
int num = get_global_id(0); 
out[num] = A[num] * B[num];
}