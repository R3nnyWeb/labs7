__kernel void helloworld( global char* in, global char* out)
{
intnum = get_global_id(0); 
out[num] = in[num] + 1;
}