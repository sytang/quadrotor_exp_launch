cmake_minimum_required(VERSION 2.8.3)
project(quadrotor_exp_launch)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -march=native -Wall -std=gnu++0x")
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

find_package(catkin REQUIRED)