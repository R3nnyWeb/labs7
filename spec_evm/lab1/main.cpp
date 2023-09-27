#include <iostream>
#include <CL/cl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <fstream>

int convertToString(const char *filename, std::string& s);

using namespace std;

void Init() {
    cl_uint numPlatforms;
    cl_platform_id platform = NULL;
    cl_int status = clGetPlatformIDs(0, NULL, &numPlatforms);
#define CL_SUCCESS 0
    if (status != CL_SUCCESS) {
//Обрабатываем ошибку
        const char *output = "Ошибка";
        cout << output << endl;

    };
    if (numPlatforms > 0) {
        cl_platform_id *platforms = (cl_platform_id *) malloc(numPlatforms * sizeof(cl_platform_id));
        status = clGetPlatformIDs(numPlatforms, platforms, NULL);
        platform = platforms[0];
        free(platforms);
    }
    cl_uint numDevices = 0;
    cl_device_id *devices;
    status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 0, NULL, &numDevices);
    devices = (cl_device_id *) malloc(numDevices * sizeof(cl_device_id));
    status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, numDevices, devices, NULL);
    char openclVersion[1024];
    cl_context context = clCreateContext(NULL, 1, devices, NULL, NULL, NULL);
    cl_command_queue commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);
    const char *filename = "C:/HelloWorld_Kernel.cl";
    string sourceStr;
    status = convertToString(filename, sourceStr);
    const char *source = sourceStr.c_str();
    size_t sourceSize[] = {strlen(source)};
    cl_program program = clCreateProgramWithSource(context, 1, &source, sourceSize, NULL);
   status = clBuildProgram(program, 1, devices, NULL, NULL, NULL);
    const char* input = "GdkknVnqkc";
    size_t strlength = strlen(input);
    char* output = (char*)malloc(strlength + 1);
    cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, (strlength + 1) * sizeof(char), (void*)input, NULL);
    cl_mem outputBuffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, (strlength + 1) * sizeof(char), NULL, NULL);
    cl_kernel kernel = clCreateKernel(program, "helloworld", NULL);
    status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&inputBuffer);
    status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&outputBuffer);
    size_t global_work_size[1] = { strlength };
    status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);
    status = clEnqueueReadBuffer(commandQueue, outputBuffer, CL_TRUE, 0, strlength * sizeof(char), output, 0, NULL, NULL);
    output[strlength] = '\0';
    cout << output << endl;
    status = clReleaseKernel(kernel);
    status = clReleaseProgram(program);
    status = clReleaseMemObject(inputBuffer);
    status = clReleaseMemObject(outputBuffer);
    status = clReleaseCommandQueue(commandQueue);
    status = clReleaseContext(context);

    if (output != NULL)
    {
        free(output);
        output = NULL;
    }

    if (devices != NULL)
    {
        free(devices);
        devices = NULL;
    }

}

int convertToString(const char *filename, std::string &s) {
    size_t size;
    char *str;
    std::fstream f(filename, (std::fstream::in | std::fstream::binary));
    if (f.is_open()) {
        size_t fileSize;
        f.seekg(0, std::fstream::end);
        size = fileSize = (size_t) f.tellg();
        f.seekg(0, std::fstream::beg);
        str = new char[size + 1];
        if (!str) {
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


int main() {
    Init();

    return 0;
}

