// lab1.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//
#include <CL/cl.h>

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <fstream>


using namespace std;
void HelloWOrld(const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue);
void arr(const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue);
int convertToString(const char* filename, std::string& s)
{
	size_t size;
	char* str;
	std::fstream f(filename, (std::fstream::in | std::fstream::binary));
	if (f.is_open())
	{
		size_t fileSize;
		f.seekg(0, std::fstream::end);
		size = fileSize = (size_t)f.tellg();
		f.seekg(0, std::fstream::beg);
		str = new char[size + 1];
		if (!str)
		{
			f.close();
			return 0;
		}

		f.read(str, fileSize);
		f.close();
		str[size] = '\0';
		s = str;
		delete[] str;
		return 0;
	}

	return -1;
}

void isSuccess(cl_int status) {
	#define CL_SUCCESS 0
	if (status != CL_SUCCESS)
	{
		cout << "Ошибка: " << status << endl;
	}
}

void Init() {
    cl_uint numPlatforms;
    cl_platform_id platform = NULL;
    cl_int status = clGetPlatformIDs(0, NULL, &numPlatforms);
	isSuccess(status);
	cout << "NumPlatforms: " << numPlatforms << endl;

    if (numPlatforms > 0)
    {
        cl_platform_id* platforms = (cl_platform_id*)malloc(numPlatforms * sizeof(cl_platform_id));
        status = clGetPlatformIDs(numPlatforms, platforms, NULL);
		isSuccess(status);
        platform = platforms[0];
        free(platforms);
    }
    cl_uint numDevices = 0;
    cl_device_id* devices;
    status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 0, NULL, &numDevices);
	isSuccess(status);
	cout << "NumDevices: " << numDevices << endl;

	devices = (cl_device_id*)malloc(numDevices * sizeof(cl_device_id));
	status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, numDevices, devices, NULL);
	isSuccess(status);

	cl_context context = clCreateContext(NULL, 1, devices, NULL, NULL, NULL);
	cl_command_queue commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);

	cout << endl << "Run programs" << endl << endl;
	const char* filename = "HelloWorld_Kernel.cl";
	HelloWOrld(filename, context, devices, commandQueue);
	const char* filename1 = "arr.cl";
	arr(filename1, context, devices, commandQueue);

	status = clReleaseCommandQueue(commandQueue);
	status = clReleaseContext(context);

	if (devices != NULL)
	{
		free(devices);
		devices = NULL;
	}

}

void HelloWOrld( const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue)
{
	cl_int status;
	string sourceStr;
	status = convertToString(filename, sourceStr);
	const char* source = sourceStr.c_str();
	size_t sourceSize[] = { strlen(source) };
	cl_program program = clCreateProgramWithSource(context, 1, &source, sourceSize, NULL);
	status = clBuildProgram(program, 1, devices, NULL, NULL, NULL);

	const char* input = "FcjjmUmpjb";
	size_t strlength = strlen(input);
	char* output = (char*)malloc(strlength + 1);
	
	cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, (strlength + 1) * sizeof(char), (void*)input, NULL);

	cl_kernel kernel = clCreateKernel(program, "helloworld", NULL);

	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&inputBuffer);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&inputBuffer);

	size_t global_work_size[1] = { strlength };

	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);
	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);

	status = clEnqueueReadBuffer(commandQueue, inputBuffer, CL_TRUE, 0, strlength * sizeof(char), output, 0, NULL, NULL);

	output[strlength] = '\0';
	cout << output << endl;


	status = clReleaseKernel(kernel);
	status = clReleaseProgram(program);
	status = clReleaseMemObject(inputBuffer);

	if (output != NULL)
	{
		free(output);
		output = NULL;
	}
}

void arr(const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue)
{
	cl_int status;
	string sourceStr;
	status = convertToString(filename, sourceStr);
	const char* source = sourceStr.c_str();
	size_t sourceSize[] = { strlen(source) };
	cl_program program = clCreateProgramWithSource(context, 1, &source, sourceSize, NULL);
	status = clBuildProgram(program, 1, devices, NULL, NULL, NULL);

	const size_t size = 10;
	cout << "Input data: " << endl;
	//{1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 9.0f, 10.0f }
	cl_int4 input[size];
	for (size_t i = 1; i <= size; i++) {
		input[i-1].s[0] = i;
		input[i-1].s[1] = i+i/2;
		input[i-1].s[2] = i*2;
		input[i-1].s[3] = i/2*3;
		cout << "(" << input[i - 1].s[0] <<", "<< input[i - 1].s[1] << ", " << input[i - 1].s[2] << ", " << input[i - 1].s[3] << ") ";
	}
	cout << endl;
	int phase = 0;
	cl_int4* output = (cl_int4*)malloc(size);

	cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, (size) * sizeof(cl_int4), (void*)input, NULL);
	cl_mem phaseBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, sizeof(int), (void*)&phase, NULL);

	cl_kernel kernel = clCreateKernel(program, "mul", NULL);

	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&inputBuffer);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&phaseBuffer);
	status = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&inputBuffer);

	size_t global_work_size[1] = { size };

	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);
	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);

	status = clEnqueueReadBuffer(commandQueue, inputBuffer, CL_TRUE, 0, size * sizeof(cl_int4), output, 0, NULL, NULL);
	cout << "Output data: " << endl;
	for (size_t i = 0; i < size; i++)
	{
		cout << "(" << output[i].s[0] << ", " << output[i].s[1] << ", " << output[i].s[2] << ", " << output[i].s[3] << ") ";
	}
	cout << endl;
	

	status = clReleaseKernel(kernel);
	status = clReleaseProgram(program);
	status = clReleaseMemObject(inputBuffer);
}

int main()
{
    Init();
	return 0;
}