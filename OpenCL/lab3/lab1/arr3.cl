__kernel void sum( global int* A, global int* out)
{
	int num = get_global_id(0);
	int size = get_global_size(0);
	if(num < size){
		out[num] = A[num+1]+num;
	}
	else out[num] = A[num];
}

__kernel void change( global int* A, global int* out)
{
	int num = get_global_id(0); 
	if (A[num] % 2 == 0){
		out[num] = -A[num];
	}
	else{
		out[num] = A[num] - 1;
	}
}