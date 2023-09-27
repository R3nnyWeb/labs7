
cmake_minimum_required(VERSION 3.25)
project(lab1)

set(CMAKE_CXX_STANDARD 17)

add_executable(lab1 main.cpp)

include_directories("C:/AMD APP/include")
target_link_libraries(lab1 "C:/AMD APP/lib/x86_64/OpenCl.lib")
