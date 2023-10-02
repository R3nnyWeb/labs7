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
void Mul(const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue);
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

void Init() {
    cl_uint numPlatforms;
    cl_platform_id platform = NULL;
    cl_int status = clGetPlatformIDs(0, NULL, &numPlatforms);
    #define CL_SUCCESS 0
    if (status != CL_SUCCESS)
    {
        //Обрабатываем ошибку
        const char* output = "Ошибка";
        cout << output << endl;
    }
	cout << "NumPlatforms: " << numPlatforms << endl;

    if (numPlatforms > 0)
    {
        cl_platform_id* platforms = (cl_platform_id*)malloc(numPlatforms * sizeof(cl_platform_id));
        status = clGetPlatformIDs(numPlatforms, platforms, NULL);
        platform = platforms[0];
        free(platforms);
    }
    cl_uint numDevices = 0;
    cl_device_id* devices;
    status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 0, NULL, &numDevices);
	cout << "NumDevices: " << numDevices << endl;

    devices = (cl_device_id*)malloc(numDevices * sizeof(cl_device_id));
   status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, numDevices, devices, NULL);
	/*char openclVersion[1024];
	status = clGetDeviceInfo(devices[0], CL_DEVICE_OPENCL_C_VERSION,
		sizeof(openclVersion), openclVersion, 0);
	cout << openclVersion << endl;*/

	char deviceName[1024];
	status = clGetDeviceInfo(devices[0], CL_DEVICE_TYPE,
		sizeof(deviceName), deviceName, 0);
	cout << deviceName << endl;

	cl_context context = clCreateContext(NULL, 1, devices, NULL, NULL, NULL);
	cl_command_queue commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);
	




	const char* filename = "HelloWorld_Kernel.cl";
	HelloWOrld(filename, context, devices, commandQueue);
	const char* filename1 = "Mul.cl";
	Mul(filename1, context, devices, commandQueue);

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

	const char* input = "GdkknVnqkc";
	size_t strlength = strlen(input);
	char* output = (char*)malloc(strlength + 1);
	const int k = 10;
	cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, (strlength + 1) * sizeof(char), (void*)input, NULL);
	cl_mem inputBuffer2 = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, sizeof(int), (void*)&k, NULL);
	cl_mem outputBuffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, (strlength + 1) * sizeof(char), NULL, NULL);

	cl_kernel kernel = clCreateKernel(program, "helloworld", NULL);

	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&inputBuffer);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&inputBuffer2);
	status = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&outputBuffer);

	size_t global_work_size[1] = { strlength };

	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);

	status = clEnqueueReadBuffer(commandQueue, outputBuffer, CL_TRUE, 0, strlength * sizeof(char), output, 0, NULL, NULL);

	output[strlength] = '\0';
	cout << output << endl;


	status = clReleaseKernel(kernel);
	status = clReleaseProgram(program);
	status = clReleaseMemObject(inputBuffer);
	status = clReleaseMemObject(outputBuffer);

	if (output != NULL)
	{
		free(output);
		output = NULL;
	}
}

void Mul(const char* filename, const cl_context& context, cl_device_id* devices, const cl_command_queue& commandQueue)
{
	cl_int status;
	string sourceStr;
	status = convertToString(filename, sourceStr);
	const char* source = sourceStr.c_str();
	size_t sourceSize[] = { strlen(source) };
	cl_program program = clCreateProgramWithSource(context, 1, &source, sourceSize, NULL);
	status = clBuildProgram(program, 1, devices, NULL, NULL, NULL);

	const size_t size = 10;

	const float input1[size] = {2.0f,2.0f,3.0f,4.0f,5.0f,6.0f,7.0f,8.0f,9.0f,10.0f};
	const float input2[size] = {41.0f,2.0f,3.0f,4.0f,5.0f,6.0f,7.0f,8.0f,9.0f,10.0f };



	float* output = (float*)malloc(size);



	cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, (size) * sizeof(float), (void*)input1, NULL);

	cl_mem inputBuffer2 = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, (size ) * sizeof(float), (void*)input2, NULL);

	cl_mem outputBuffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, (size ) * sizeof(float), NULL, NULL);

	cl_kernel kernel = clCreateKernel(program, "mul", NULL);

	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&inputBuffer);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&inputBuffer2);
	status = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&outputBuffer);

	size_t global_work_size[1] = { size };

	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);

	status = clEnqueueReadBuffer(commandQueue, outputBuffer, CL_TRUE, 0, size * sizeof(float), output, 0, NULL, NULL);

	for (size_t i = 0; i < size; i++)
	{
		cout << output[i] << endl;
	}
	


	status = clReleaseKernel(kernel);
	status = clReleaseProgram(program);
	status = clReleaseMemObject(inputBuffer);
	status = clReleaseMemObject(outputBuffer);

	
}

int main()
{
    Init();
	return 0;
}

// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

// Советы по началу работы 
//   1. В окне обозревателя решений можно добавлять файлы и управлять ими.
//   2. В окне Team Explorer можно подключиться к системе управления версиями.
//   3. В окне "Выходные данные" можно просматривать выходные данные сборки и другие сообщения.
//   4. В окне "Список ошибок" можно просматривать ошибки.
//   5. Последовательно выберите пункты меню "Проект" > "Добавить новый элемент", чтобы создать файлы кода, или "Проект" > "Добавить существующий элемент", чтобы добавить в проект существующие файлы кода.
//   6. Чтобы снова открыть этот проект позже, выберите пункты меню "Файл" > "Открыть" > "Проект" и выберите SLN-файл.
